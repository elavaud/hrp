<?php

/**
 * @file classes/manager/form/ManageOtherExtraFieldsForm.inc.php
 *
 * @class ManageOtherExtraFieldsForm
 * @ingroup manager_form
 *
 * @brief Form for replacing fields manually entered by the submitters of research proposals
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.journal.ExtraField');

class ManageOtherExtraFieldsForm extends Form {

        /** @var $type string The type of the extra field being deleted */
	var $type;

        /** @var $typeConst int The constant for the type of the extra field being deleted */
	var $typeConst;        
        
	/**
	 * Constructor.
	 * @param type string
	 */
	function ManageOtherExtraFieldsForm($type) {
		parent::Form('manager/extraFields/manageOtherExtraFieldsForm.tpl');
                $this->type = $type;
                switch ($type) {
                    case 'researchFields':
                        $this->typeConst = (int) EXTRA_FIELD_RESEARCH_FIELD;
                        break;
                    case 'proposalTypes':
                        $this->typeConst = (int) EXTRA_FIELD_PROPOSAL_TYPE;
                        break;
                }           
                $this->addCheck(new FormValidator($this, 'replacement', 'required', 'manager.extraFields.others.replacementRequired'));
	}


	/**
	 * Display the form.
	 */
	function display() {
		$templateMgr =& TemplateManager::getManager();
                
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                
                // Get the list of extra fields for the replacement and remove from it the one to delete
                $extraFieldsList = $extraFieldDao->getExtraFieldsList($this->typeConst);
                
                // Get a array of 'other' fields
                $otherFields = $proposalDetailsDao->getAllOtherFields($this->type);
                
                
		$templateMgr->assign('type', $this->type);
		$templateMgr->assign('otherFields', $otherFields);
                $templateMgr->assign('extraFieldsList', $extraFieldsList);
                $templateMgr->assign('pageInfo', 'manager.extraFields.'.$this->type.'.manageOthers');

                parent::display(); 
	}

	/**
	 * Assign form data to user-submitted data.
	*/
	function readInputData() {
	
		$this->readUserVars(array('selectedOtherFields','replacement'));
	}

	/**
	 * Delete an institution.
	*/
	function execute() {
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');

                $replacementExtraFieldId = $this->getData('replacement');
                $selectedOtherFieldsId = $this->getData('selectedOtherFields');
                
                if ($this->typeConst == EXTRA_FIELD_RESEARCH_FIELD) {
                    $functionGet = 'getResearchFieldsArray';
                    $functionSet = 'setResearchFieldsFromArray';                    
                } else {
                    $functionGet = 'getProposalTypesArray';
                    $functionSet = 'setProposalTypesFromArray';                    
                }
                
                foreach ($selectedOtherFieldsId as $selectedOtherFieldId) {
                    $proposalDetail =& $proposalDetailsDao->getProposalDetailsByArticleId($selectedOtherFieldId);
                    $array = $proposalDetail->$functionGet();
                    foreach ($array as $key => $value){
                       if (preg_match('#^Other\s\(.+\)$#', $value)){
                           $array[$key] = $replacementExtraFieldId;
                       }
                    }
                    $proposalDetail->$functionSet($array);
                    $proposalDetailsDao->updateProposalDetails($proposalDetail);
                }                
	}
}

?>
