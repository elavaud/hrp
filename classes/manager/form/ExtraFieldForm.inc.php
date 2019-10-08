<?php

/**
 * @file classes/manager/form/ExtraFieldForm.inc.php
 *
 * @class ExtraFieldForm
 * @ingroup manager_form
 *
 * @brief Form for creating and modifying extra fields.
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.journal.ExtraField');

class ExtraFieldForm extends Form {

	/** @var $extraFieldId int The ID of the extra field being edited */
	var $extraFieldId;

        /** @var $type string The type of the extra field */
	var $type;

        /** @var $typeConst int The constant for the type of the extra field */
	var $typeConst;

	/**
	 * Constructor.
	 * @param $extraFieldId int omit for a new extra field
	 */
	function ExtraFieldForm($type, $extraFieldId = null) {
		parent::Form('manager/extraFields/extraFieldForm.tpl');
		$this->extraFieldId = $extraFieldId;
		$this->type = $type;
                
                switch ($type) {
                    case 'geoAreas':
                        $this->typeConst = (int) EXTRA_FIELD_GEO_AREA;
                        break;
                    case 'researchFields':
                        $this->typeConst = (int) EXTRA_FIELD_RESEARCH_FIELD;
                        break;
                    case 'researchDomains':
                        $this->typeConst = (int) EXTRA_FIELD_RESEARCH_DOMAIN;
                        break;
                    case 'proposalTypes':
                        $this->typeConst = (int) EXTRA_FIELD_PROPOSAL_TYPE;
                        break;
                }

		// Validation checks for this form
                $this->addCheck(new FormValidatorArray($this, 'extraFieldNames', 'required', 'manager.extraFields.'.$type.'.missing.name'), array('name'));
                $this->addCheck(new FormValidator($this, 'active', 'required', 'manager.extraFields.active.required'));
	}


	/**
	 * Display the form.
	 */
	function display() {
		$templateMgr =& TemplateManager::getManager();
                
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                $sectionDao =& DAORegistry::getDAO('SectionDAO');      
                
                $countProposals = count($proposalDetailsDao->getExtraFields($this->type, $this->extraFieldId));
                $countInstitutions = count($institutionDao->getGeoAreas($this->extraFieldId));
                $countCommittees = count($sectionDao->getGeoAreas($this->extraFieldId));
                
                if ($this->typeConst == EXTRA_FIELD_GEO_AREA) {
                    if ($this->extraFieldId && ($countInstitutions > 0 || $countProposals > 0 || $countCommittees > 0)) {
                        $warning = 'manager.extraFields.geoAreas.modify.warning';
                    } else {
                        $warning = null;
                    }
                } else {
                    if ($this->extraFieldId && $countProposals > 0) {
                        $warning = 'manager.extraFields.modify.warning';
                    } else {
                        $warning = null;
                    }                    
                }
		$templateMgr->assign('warning', $warning);
                $templateMgr->assign('yesNoArray', array(EXTRA_FIELD_ACTIVE => Locale::translate('common.yes'), EXTRA_FIELD_NOT_ACTIVE => Locale::translate('common.no')));
		$templateMgr->assign('pageTitle', 'manager.extraFields.'.$this->type.'.edit');
		$templateMgr->assign('extraFieldId', $this->extraFieldId);
		$templateMgr->assign('type', $this->type);
                $journal = Request::getJournal();
                $templateMgr->assign_by_ref('locales', $journal->getSupportedLocaleNames());
		parent::display(); 
	}

	/**
	 * Initialize form data from current settings.
	 */
	function initData() {
		if (isset($this->extraFieldId)) {
			$extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
			$extraField =& $extraFieldDao->getExtraField($this->extraFieldId);
                        
                        $this->_data = array(
				'extraFieldNames' => array(),
				'active' => $extraField->getExtraFieldActive()
			);
                        
                        $extraFieldNames =& $extraField->getExtraFieldName(null);
                        $journal = Request::getJournal();
                        foreach ($journal->getSupportedLocaleNames() as $localeKey => $localeValue) {
                            if (isset($extraFieldNames[$localeKey])) {
                                $this->_data['extraFieldNames'][$localeKey] = $extraFieldNames[$localeKey];
                            }
                        }

                } else {
                    $this->_data = array('active' => EXTRA_FIELD_ACTIVE);
                }
	}
        
        /**
	 * Get the names of fields for which localized data is allowed.
	 * @return array
	 */
        
	function getLocaleFieldNames() {
		$extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
		return $extraFieldDao->getLocaleFieldNames();
	}

	/**
	 * Assign form data to user-submitted data.
	*/
	function readInputData() {
		$this->readUserVars(array('extraFieldNames', 'active', 'type'));
	}

	/**
	 * Save extra field.
	*/
	function execute() {

		$extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');

		if (isset($this->extraFieldId)) {
			$extraField =& $extraFieldDao->getExtraField($this->extraFieldId);
		}
		
		if (!isset($extraField)) {
			$extraField = new ExtraField();
                }
                
                $extraField->setExtraFieldType($this->typeConst);
                    
                $journal = Request::getJournal();
                $extraFieldNames = $this->getData('extraFieldNames');
                foreach ($journal->getSupportedLocaleNames() as $localeKey => $localeValue) {
                    $extraField->setExtraFieldName($extraFieldNames[$localeKey], $localeKey);	
                }
                $extraField->setExtraFieldActive($this->getData('active'));

		if (isset($this->extraFieldId)) {
			$extraFieldDao->updateExtraField($extraField);
                } else {
			$extraFieldDao->insertExtraField($extraField);
                }
	}
}

?>
