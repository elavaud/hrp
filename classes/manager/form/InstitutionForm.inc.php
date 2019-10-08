<?php

/**
 * @file classes/manager/form/InstitutionForm.inc.php
 *
 * @class InstitutionForm
 * @ingroup manager_form
 *
 * @brief Form for creating and modifying institutions.
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.journal.Institution');

class InstitutionForm extends Form {

	/** @var $institutionId int The ID of the institution being edited */
	var $institutionId;

	/**
	 * Constructor.
	 * @param $journalId int omit for a new journal
	 */
	function InstitutionForm($institutionId = null) {
		parent::Form('manager/institutions/institutionForm.tpl');
		$this->institutionId = $institutionId;

		// Validation checks for this form

		$this->addCheck(new FormValidator($this, 'name', 'required', 'manager.institutions.form.nameRequired'));
                $this->addCheck(new FormValidatorCustom($this, 'name', 'required', 'manager.institutions.form.nameExists', array(DAORegistry::getDAO('InstitutionDAO'), 'institutionExistsByName'), array($this->institutionId), true));
		$this->addCheck(new FormValidator($this, 'acronym', 'required', 'manager.institutions.form.acronymRequired'));
                $this->addCheck(new FormValidatorCustom($this, 'acronym', 'required', 'manager.institutions.form.acronymExists', array(DAORegistry::getDAO('InstitutionDAO'), 'institutionExistsByAcronym'), array($this->institutionId), true));
                $this->addCheck(new FormValidator($this, 'international', 'required', 'manager.institutions.form.regionRequired'));
                $this->addCheck(new FormValidator($this, 'locationCountry', 'required', 'manager.institutions.form.regionRequired'));
                $this->addCheck(new FormValidator($this, 'locationInternational', 'required', 'manager.institutions.form.regionRequired'));
		$this->addCheck(new FormValidator($this, 'type', 'required', 'manager.institutions.form.typeRequired'));
	}


	/**
	 * Display the form.
	 */
	function display() {
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
		$countryDao =& DAORegistry::getDAO('CountryDAO');
                         
                $regions = $extraFieldDao->getExtraFieldsList(EXTRA_FIELD_GEO_AREA);
                $institutionTypes = $institutionDao->getInstitutionTypes();
                $internationalArray = $institutionDao->getInstitutionInternationalArray();
		$countries =& $countryDao->getCountries();
                
		$templateMgr =& TemplateManager::getManager();
                
		$templateMgr->assign('institutionId', $this->institutionId);
                $templateMgr->assign('internationalArray', $internationalArray);
                $templateMgr->assign('institutionTypes', $institutionTypes);
		$templateMgr->assign_by_ref('countries', $countries);                
                $templateMgr->assign_by_ref('regions', $regions);
                
		parent::display(); 
	}

	/**
	 * Initialize form data from current settings.
	 */
	function initData() {
		if (isset($this->institutionId)) {
			$institutionDao =& DAORegistry::getDAO('InstitutionDAO');
			$institution =& $institutionDao->getInstitutionById($this->institutionId);
			
                        $international = $institution->getInstitutionInternational();
                        if ($international == INSTITUTION_NATIONAL) {
                            $locationCountry = $institution->getInstitutionLocation();
                            $locationInternational = null;                                                    
                        } elseif ($international == INSTITUTION_INTERNATIONAL) {
                            $locationCountry = null;
                            $locationInternational = $institution->getInstitutionLocation();                                                    
                        } else {
                            $locationCountry = null;
                            $locationInternational = null;                                                    
                        }
                        
			$this->_data = array(
				'name' => $institution->getInstitutionName(),
				'acronym' => $institution->getInstitutionAcronym(),
				'international' => $international,
				'locationCountry' => $locationCountry,
				'locationInternational' => $locationInternational,
				'type' => $institution->getInstitutionType()
			);
		}
	}

	/**
	 * Assign form data to user-submitted data.
	 * Added region
	 * EL on February 11th 2013
	*/
	function readInputData() {
	
		$this->readUserVars(array('name', 'acronym', 'international', 'locationCountry', 'locationInternational', 'type'));
	}

	/**
	 * Save institution.
	*/
	function execute() {

		$institutionDao =& DAORegistry::getDAO('InstitutionDAO');

		if (isset($this->institutionId)) {
			$institution =& $institutionDao->getInstitutionById($this->institutionId);
		}
		
		if (!isset($institution)) {
			$institution = new Institution();
                }
                
		$institution->setInstitutionName($this->getData('name'));
		$institution->setInstitutionAcronym($this->getData('acronym'));
                
                $international = $this->getData('international');
                $institution->setInstitutionInternational($international);
                if ($international == INSTITUTION_NATIONAL) {
                    $institution->setInstitutionLocation($this->getData('locationCountry'));
                } elseif ($international == INSTITUTION_INTERNATIONAL) {
                    $institution->setInstitutionLocation($this->getData('locationInternational'));
                }
                
                $institution->setInstitutionType($this->getData('type'));

		if ($institution->getInstitutionId() != null) {
			$institutionDao->updateInstitution($institution);
                } else {
			$institutionDao->insertInstitution($institution);
                }
	}
}

?>
