<?php

/**
 * @file classes/manager/form/AboutFileForm.inc.php
 *
 * @class AboutFileForm
 * @ingroup manager_form
 *
 * @brief Form for upoloading and crating file to put in the about page.
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.file.AboutFile');

class AboutFileForm extends Form {

	/** @var $aboutFileId int The ID of the about file being edited */
	var $aboutFileId;

	/**
	 * Constructor.
	 * @param $aboutFileId int if file editing
	 */
	function AboutFileForm($aboutFileId = null) {
		parent::Form('manager/aboutFiles/aboutFileForm.tpl');
		$this->aboutFileId = $aboutFileId;

		// Validation checks for this form
		$this->addCheck(new FormValidator($this, 'type', 'required', 'manager.aboutFiles.typeRequired'));
                $this->addCheck(new FormValidatorArray($this, 'aboutFileNames', 'required', 'manager.aboutFiles.nameRequired'), array('name'));
	}

	/**
	 * Display the form.
	 */
	function display() {
		$templateMgr =& TemplateManager::getManager();
		
		$templateMgr->assign('aboutFileId', $this->aboutFileId);
        
                if ($this->aboutFileId != null) {
			$aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
			$templateMgr->assign_by_ref('aboutFile', $aboutFileDao->getAboutFile($this->aboutFileId));
		}

                
                $templateMgr->assign('aboutFileTypes', array(
                                '' => 'common.chooseOne',
                                ABOUT_FILE_POLICY => 'manager.aboutFiles.policyFile',
                                ABOUT_FILE_USER_MANUAL => 'manager.aboutFiles.userManual',
                                ABOUT_FILE_TEMPLATE => 'manager.aboutFiles.template',
                                ABOUT_FILE_MISCELLANEOUS => 'manager.aboutFiles.miscellaneousFile'
                                )
                );
                
                $journal = Request::getJournal();
                $templateMgr->assign_by_ref('abstractLocales', $journal->getSupportedLocaleNames());
                
		parent::display(); 
	}
        
        
        /**
	 * Get the names of fields for which localized data is allowed.
	 * @return array
	 */
        
	function getLocaleFieldNames() {
		$aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
		return $aboutFileDao->getLocaleFieldNames();
	}
        
        /**
	 * Initialize form data from current settings.
	 */
	function initData() {
		if (isset($this->aboutFileId)) {
			$aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
			$aboutFile =& $aboutFileDao->getAboutFile($this->aboutFileId);
                                                
                        $this->_data = array(
				'aboutFileNames' => array(),
				'aboutFileDescriptionArray' => array(),
                                'originalName' => $aboutFile->getAboutFileOriginalName(),
				'type' => $aboutFile->getAboutFileType()
			);
                        
                        $aboutFileNames =& $aboutFile->getAboutFileName(null);
                        $aboutFileDescriptionArray =& $aboutFile->getAboutFileDescription(null);
                        $journal = Request::getJournal();
                        foreach ($journal->getSupportedLocaleNames() as $localeKey => $localeValue) {
                            if (isset($aboutFileNames[$localeKey])) {
                                $this->_data['aboutFileNames'][$localeKey] = array(
                                        'name' => $aboutFileNames[$localeKey]
                                    );
                            }
                            if (isset($aboutFileDescriptionArray[$localeKey])) {
                                $this->_data['aboutFileDescriptionArray'][$localeKey] = array(
                                        'description' => $aboutFileDescriptionArray[$localeKey]
                                    );
                            }                            
                        }

		}
	}

	/**
	 * Assign form data to user-submitted data.
	 * Added region
	 * EL on February 11th 2013
	*/
	function readInputData() {
	
		$this->readUserVars(array('aboutFileNames', 'aboutFileDescriptionArray','type', 'aboutFile'));
	}
        
	/**
	 * Upload the about file.
	 * @param $fileName string
	 * @return boolean
	 */
	function uploadAboutFile($fileName, $type) {
                import('classes.file.AboutFileManager');
                
                $aboutfileManager = new AboutFileManager();

                if ($aboutfileManager->uploadedFileExists($fileName) && $type != null) {
                        $aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
                        
                        if ($this->aboutFileId != null && $this->aboutFileId != 0) {
                            
                            $aboutfileManager->deleteFile($this->aboutFileId);
                            $aboutfileManager->handleUpload($fileName, $type, $this->aboutFileId);
                            
                        } else $this->aboutFileId = $aboutfileManager->handleUpload($fileName, $type);
                                                
                        return true;
                        
		} else return false;
	}
        
	/**
	 * Save institution.
	 */
	function execute() {
                //$this->uploadAboutFile($this->getData('aboutFile'), $this->getData('type'));
                
                $aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
		if (isset($this->aboutFileId)) {
			$aboutFile =& $aboutFileDao->getAboutFile($this->aboutFileId);
		} else return null;
                
                $aboutFile->setAboutFileType($this->getData('type'));
                    
                $journal = Request::getJournal();
                $aboutFileNames = $this->getData('aboutFileNames');
                $aboutFileDescriptionArray = $this->getData('aboutFileDescriptionArray');                
                foreach ($journal->getSupportedLocaleNames() as $localeKey => $localeValue) {
                    $aboutFile->setAboutFileName($aboutFileNames[$localeKey]['name'], $localeKey);	
                    $aboutFile->setAboutFileDescription($aboutFileDescriptionArray[$localeKey]['description'], $localeKey);	                    
                }
		$aboutFileDao->updateAboutFile($aboutFile);
	}
}

?>
