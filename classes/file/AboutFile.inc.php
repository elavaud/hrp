<?php

define('ABOUT_FILE_POLICY', 1);
define('ABOUT_FILE_USER_MANUAL', 2);
define('ABOUT_FILE_TEMPLATE', 3);
define('ABOUT_FILE_MISCELLANEOUS', 4);


class AboutFile extends DataObject {

    	/**
	 * Constructor
	 */
	function AboutFile() {
		parent::DataObject();
	}

        /**
	 * Return absolute path to the file on the host filesystem.
	 * @return string
	 */
	function getFilePath() {
		return Config::getVar('general', 'base_url') . '/public/about/' . $this->getFileName();
	}
        
        /**
	 * Set the name of the file.
	 * @param $originalName string
	 */
	function setFileName($name) {
		return $this->setData('name', $name);
	}

        /**
	 * Get the name of the about file.
	 * @return string
	 */
	function getFileName() {
		return $this->getData('name');
	} 
        
	/**
	 * Set the name of the file.
	 * @param $originalName string
	 */
	function setAboutFileOrinalName($originalName) {
		return $this->setData('originalName', $originalName);
	}

        /**
	 * Get the name of the about file.
	 * @return string
	 */
	function getAboutFileOriginalName() {
		return $this->getData('originalName');
	} 
        
        /**
	 * Set the name of the file.
	 * @param $name string
	 * @param $name string
         */
	function setAboutFileName($name, $locale) {
		return $this->setData('aboutFileName', $name, $locale);
	}
        
        /**
	 * Get the name of the about file.
	 * @return string
	 */
	function getAboutFileName($locale) {
		return $this->getData('aboutFileName', $locale);
	}
        
        /**
	 * Get the name of the about file, automatically localized.
	 * @return string
	 */
	function getLocalizedAboutFileName() {
		return $this->getLocalizedData('aboutFileName');
	}

        /**
	 * Set the description of the file.
	 * @param $description string
	 * @param $locale string
         */
	function setAboutFileDescription($description, $locale) {
		return $this->setData('aboutFileDescription', $description, $locale);
	}
        
        /**
	 * Get the description of the about file.
	 * @return string
	 */
	function getAboutFileDescription($locale) {
		return $this->getData('aboutFileDescription', $locale);
	}
        
        /**
	 * Get the description of the about file, automatically localized.
	 * @return string
	 */
	function getLocalizedAboutFileDescription() {
		return $this->getLocalizedData('aboutFileDescription');
	}

        /**
	 * Set type of the file.
	 * @param $type string
	 */
	function setFileType($fileType) {
		return $this->setData('fileType', $fileType);
	}
        
	/**
	 * Get type of the file.
	 * @ return string
	 */
	function getFileType() {
		return $this->getData('fileType');
	}

	/**
	 * Get extension of the file.
	 * @ return string
	 */
	function getFileExtension() {
		return FileManager::getExtension($this->getData('originalName'));
	}

	/**
	 * Set file size of file.
	 * @param $fileSize int
	 */

	function setFileSize($fileSize) {
		return $this->SetData('fileSize', $fileSize);
	}
        
        /**
	 * Get file size of file.
	 * @return int
	 */
	function getFileSize() {
		return $this->getData('fileSize');
	}

	function getNiceFileSize() {
		return FileManager::getNiceFileSize($this->getData('fileSize'));
	}

        /**
	 * Set the type of the file.
	 * @param $type int
	 */
	function setAboutFileType($type) {
		return $this->setData('type', $type);
	}

        /**
	 * Get the type of the about file.
	 * @return int
	 */
	function getAboutFileType() {
		return $this->getData('type');
	}
        
        /**
	 * Get a map of all the translation keys of the types of the about files.
	 * @return int
	 */
	function getAboutFileTypeMap() {
		static $aboutFileTypeMap;
		if (!isset($aboutFileTypeMap)) {
			$aboutFileTypeMap = array(
                                ABOUT_FILE_POLICY => 'manager.aboutFiles.policyFile',
				ABOUT_FILE_USER_MANUAL => 'manager.aboutFiles.userManual',
				ABOUT_FILE_TEMPLATE => 'manager.aboutFiles.template',
                                ABOUT_FILE_MISCELLANEOUS => 'manager.aboutFiles.miscellaneousFile'
			);
		}
		return $aboutFileTypeMap;
	}

        /**
	 * Get the translation key of the type of the about file.
	 * @return int
	 */
	function getAboutFileTypeKey() {
		$aboutFileTypeMap =& $this->getAboutFileTypeMap();
		return $aboutFileTypeMap[$this->getAboutFileType()];
	}
}

?>
