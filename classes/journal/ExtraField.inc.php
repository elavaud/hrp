<?php

/**
 * @file classes/journal/ExtraField.inc.php
 *
 * @class ExtraField
 * @ingroup journal
 * @see ExtraFieldDAO
 *
 * @brief Describes extra fields used for metadata (the geographical areas, the research fields....).
 */

// $Id$

define('EXTRA_FIELD_GEO_AREA', 1);
define('EXTRA_FIELD_RESEARCH_FIELD', 2);
define('EXTRA_FIELD_RESEARCH_DOMAIN', 3);
define('EXTRA_FIELD_PROPOSAL_TYPE', 4);

define('EXTRA_FIELD_ACTIVE', 1);
define('EXTRA_FIELD_NOT_ACTIVE', 2);

class ExtraField extends DataObject {

	/**
	 * Constructor.
	 */
	function ExtraField() {
		parent::DataObject();
	}

        //
	// Get/set methods
	//

	/**
	 * Get extra field id.
	 * @return int
	 */
	function getExtraFieldId() {
		return $this->getData('extraFieldId');
	} 

	/**
	 * Set extra field id.
	 * @param $extraFieldId int
	 */
	function setExtraFieldId($extraFieldId) {
		return $this->setData('extraFieldId', $extraFieldId);
	}

	/**
	 * Get extra field type.
	 * @return int
	 */
	function getExtraFieldType() {
		return $this->getData('type');
	} 
        
        
	/**
	 * Set extra field type.
	 * @param $type int
	 */
	function setExtraFieldType($type) {
		return $this->setData('type', $type);
	}
        
	/**
	 * Get if the extra field is active.
	 * @return int
	 */
	function getExtraFieldActive() {
		return $this->getData('active');
	} 
        
	/**
	 * Set if the extra field is active.
	 * @param $active int
	 */
	function setExtraFieldActive($active) {
		return $this->setData('active', $active);
	}
        
	/**
	 * Get the key if extra field is active.
	 * @return string
	 */
	function getExtraFieldActiveKey() {
                $extraFieldActiveMap = $this->getExtraFieldActiveMap();
		return $extraFieldActiveMap[$this->getExtraFieldActive()];
	} 
        
        /**
	 * Get a map of the translation keys inactive/active.
	 * @return int
	 */
	function getExtraFieldActiveMap() {
		static $extraFieldActiveMap;
		if (!isset($extraFieldActiveMap)) {
			$extraFieldActiveMap = array(
                                EXTRA_FIELD_ACTIVE => 'common.yes',
				EXTRA_FIELD_NOT_ACTIVE => 'common.no'
			);
		}
		return $extraFieldActiveMap;
	}      
        /**
	 * Set the name of the extra field.
	 * @param $name string
	 * @param $locale string
         */
	function setExtraFieldName($name, $locale) {
		return $this->setData('extraFieldName', $name, $locale);
	}
        
        /**
	 * Get the name of the extra field.
	 * @return string
	 */
	function getExtraFieldName($locale) {
		return $this->getData('extraFieldName', $locale);
	}
        
        /**
	 * Get the name of the extra field, automatically localized.
	 * @return string
	 */
	function getLocalizedExtraFieldName() {
		return $this->getLocalizedData('extraFieldName');
	}        
        
        /**
	 * Get the three first letters
	 * @return string
	 */
	function getThreeFirstLettersOfName(){
                $primaryLocale = Locale::getPrimaryLocale();
                $name = $this->getExtraFieldName($primaryLocale);
                if (!isset($name)) {
                    $name = $this->getLocalizedExtraFieldName();
                }
                $subName = substr($name, 0, 3);
                if ($subName != null && $subName != '') {
                    return $subName;
                } else {
                    return $this->getExtraFieldId();
                }
	}   
}

?>