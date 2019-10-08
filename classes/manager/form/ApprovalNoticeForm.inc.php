<?php

/**
 * @defgroup manager_form
 */

/**
 * @file classes/manager/form/ApprovalNoticeForm.inc.php
 *
 * @class ApprovalNoticeForm
 * @ingroup manager_form
 *
 * @brief Form for managers to create/edit approval notices.
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.approvalNotice.ApprovalNotice');

class ApprovalNoticeForm extends Form {
    
	/** @var approvalNoticeId int the ID of the approval notice being edited */
	var $approvalNoticeId;

	/**
	 * Constructor
            * @param approvalNoticeId int leave as default for new notice
	 */
	function ApprovalNoticeForm($approvalNoticeId = null) {

		$this->approvalNoticeId = isset($approvalNoticeId) ? (int) $approvalNoticeId : null;
		parent::Form('manager/approvalNotices/approvalNoticeForm.tpl');

		// Title is provided
		$this->addCheck(new FormValidator($this, 'title', 'required', 'manager.approvalNotice.title.required'));
		$this->addCheck(new FormValidator($this, 'active', 'required', 'manager.approvalNotice.active.required'));

		$this->addCheck(new FormValidatorPost($this));
	}

	/**
	 * Display the form.
	 */
	function display() {
            
                $sectionDao =& DAORegistry::getDAO('SectionDAO');
                $approvalNoticeDao =& DAORegistry::getDAO('ApprovalNoticeDAO');
                $sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
                Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION));

                $journal =& Request::getJournal();
                $committees = $sectionDao->getSectionTitles($journal->getId());
                $committees[APPROVAL_NOTICE_TYPE_ALL] = Locale::translate('common.all');
                $reviewTypes = $sectionDecisionDao->getReviewTypeMap();
                $reviewTypes[APPROVAL_NOTICE_COMMITTEE_ALL] = Locale::translate('common.all');                
                
                $templateMgr =& TemplateManager::getManager(); 

		$templateMgr->assign('approvalNoticeId', $this->approvalNoticeId);
		$templateMgr->assign_by_ref('committeesList', $committees);
		$templateMgr->assign_by_ref('reviewTypesList', $reviewTypes);
                $templateMgr->assign_by_ref('activeMap', $approvalNoticeDao->getActiveMap());
                
                
                
                $journal = Request::getJournal();

		parent::display();
	}

	/**
	 * Initialize form data from current announcement.
	 */
	function initData() {
                $approvalNoticeDao =& DAORegistry::getDAO('ApprovalNoticeDAO');
                if (isset($this->approvalNoticeId)) {
			$approvalNotice =& $approvalNoticeDao->getApprovalNotice($this->approvalNoticeId);
			if ($approvalNotice != null) {
				$this->_data = array(
					'title' => $approvalNotice->getApprovalNoticeTitle(),
                                        'committees' => $approvalNotice->getCommitteesArray(),
                                        'reviewTypes' => $approvalNotice->getReviewTypesArray(),  
                                        'active' => $approvalNotice->getActive(),
					'APHeader' => $approvalNotice->getApprovalNoticeHeader(),
					'APBody' => $approvalNotice->getApprovalNoticeBody(),
					'APFooter' => $approvalNotice->getApprovalNoticeFooter()
				);
			} else {
				$this->approvalNoticeId = null;
				$this->_data = array(
                                        'committees' => array(0 => APPROVAL_NOTICE_COMMITTEE_ALL),
                                        'reviewTypes' => array(0 => APPROVAL_NOTICE_TYPE_ALL)
				);
			}
		} else {
                        $this->_data = array(
                                'committees' => array(0 => APPROVAL_NOTICE_COMMITTEE_ALL),
                                'reviewTypes' => array(0 => APPROVAL_NOTICE_TYPE_ALL)
                        );
                }
                
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array('title', 'committees', 'reviewTypes', 'active', 'APHeader', 'APBody', 'APFooter'));
	}

	/**
	 * Save approval notice.
	 */
	function execute() {
		$approvalNoticeDao =& DAORegistry::getDAO('ApprovalNoticeDAO');
                
                // Create or edit approval notice
		if (isset($this->approvalNoticeId)) {
			$approvalNotice =& $approvalNoticeDao->getApprovalNotice($this->approvalNoticeId);
		}

		if (!isset($approvalNotice)) {
			$approvalNotice = new ApprovalNotice();
		}
                
                // Clean the committees and review types array before saving them
                $committees = array_unique($this->getData('committees'));
                $reviewTypes = array_unique($this->getData('reviewTypes'));
                $allComFound = false;
                $allTypeFound = false;
                foreach ($committees as $committeeId){
                    if ($committeeId == APPROVAL_NOTICE_COMMITTEE_ALL){
        		$approvalNotice->setCommitteesFromArray(array(0 => APPROVAL_NOTICE_COMMITTEE_ALL)); 
                        $allComFound = true;
                    }
                }
                if (!$allComFound) {
                    $approvalNotice->setCommitteesFromArray($committees); 
                }
                foreach ($reviewTypes as $reviewTypeId){
                    if ($reviewTypeId == APPROVAL_NOTICE_TYPE_ALL){
        		$approvalNotice->setReviewTypesFromArray(array(0 => APPROVAL_NOTICE_TYPE_ALL)); 
                        $allTypeFound = true;
                    }
                }
                if (!$allTypeFound) {
                    $approvalNotice->setReviewTypesFromArray($reviewTypes); 
                }
                
		$approvalNotice->setApprovalNoticeTitle($this->getData('title'));
		$approvalNotice->setActive($this->getData('active'));
		$approvalNotice->setApprovalNoticeHeader($this->getData('APHeader'));
		$approvalNotice->setApprovalNoticeBody($this->getData('APBody')); 
		$approvalNotice->setApprovalNoticeFooter($this->getData('APFooter')); 
                
		// Update or insert announcement
		if ($approvalNotice->getId() != null) {
			$approvalNoticeDao->updateObject($approvalNotice);
		} else {
			$approvalNoticeDao->insertApprovalNotice($approvalNotice);
		}

		return $approvalNotice;
	}

}

?>
