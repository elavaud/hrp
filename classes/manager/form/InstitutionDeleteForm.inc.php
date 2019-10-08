<?php

/**
 * @file classes/manager/form/InstitutionDeleteForm.inc.php
 *
 * @class InstitutionForm
 * @ingroup manager_form
 *
 * @brief Form for deleting a specific institution.
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.journal.Institution');

class InstitutionDeleteForm extends Form {

	/** @var $institutionId int The ID of the insitution being deleted */
	var $institutionId;
        
        
	/**
	 * Constructor.
	 * @param $journalId int omit for a new journal
	 */
	function InstitutionDeleteForm($institutionId) {
		parent::Form('manager/institutions/institutionDeleteForm.tpl');
                $this->institutionId = $institutionId;
                
		$this->addCheck(new FormValidator($this, 'replacementInstitution', 'required', 'manager.institutions.form.replacementInstitutionRequired'));
	}


	/**
	 * Display the form.
	 */
	function display() {
		$templateMgr =& TemplateManager::getManager();
		                
                $proposalSourceDao =& DAORegistry::getDAO('ProposalSourceDAO');
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');

                // Get the list of institutions for the replacement and remove from it the one to delete
                $institutionsList = $institutionDao->getInstitutionsList();
                unset($institutionsList[$this->institutionId]);
                
                // Get the institution to delete
                $institutionToDelete =& $institutionDao->getInstitutionById($this->institutionId);
                
		$templateMgr->assign('institutionId', $this->institutionId);
		$templateMgr->assign('institutionToDelete', $institutionToDelete);
                $templateMgr->assign('institutionsList', $institutionsList);
		$templateMgr->assign('countKII', $proposalDetailsDao->getCountKIIByInstitution($this->institutionId));
		$templateMgr->assign('countSources', $proposalSourceDao->getCountSourcesByInstitution($this->institutionId));
                
                parent::display(); 
	}

	/**
	 * Assign form data to user-submitted data.
	*/
	function readInputData() {
	
		$this->readUserVars(array('replacementInstitution'));
	}

	/**
	 * Delete an institution.
	*/
	function execute() {
                $proposalSourceDao =& DAORegistry::getDAO('ProposalSourceDAO');
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');            
                
                $countKII = $proposalDetailsDao->getCountKIIByInstitution($this->institutionId);
                $countSources = $proposalSourceDao->getCountSourcesByInstitution($this->institutionId);
                        
                if ($countKII > 0 || $countSources > 0) {
                    $proposalDetailsDao->replaceKII($this->institutionId, $this->getData('replacementInstitution'));
                    $proposalSourceDao->replaceInstitutionSource($this->institutionId, $this->getData('replacementInstitution'));
                }
                
                $institutionDao->deleteInstitutionById($this->institutionId);
	}
}

?>
