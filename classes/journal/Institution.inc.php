<?php

/**
 * @file classes/journal/Section.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class Section
 * @ingroup journal
 * @see SectionDAO
 *
 * @brief Describes basic section properties.
 */

// $Id$

define('INSTITUTION_TYPE_OTHER', 0);
define('INSTITUTION_TYPE_PUBLIC', 1);
define('INSTITUTION_TYPE_PRIVATE_PROFIT', 2);
define('INSTITUTION_TYPE_PRIVATE_NON_PROFIT', 3);
define('INSTITUTION_TYPE_PRIVATE_INDIVIDUAL', 4);

define('INSTITUTION_NATIONAL', 0);
define('INSTITUTION_INTERNATIONAL', 1);

class Institution extends DataObject {

	/**
	 * Constructor.
	 */
	function Institution() {
		parent::DataObject();
	}

        //
	// Get/set methods
	//

	/**
	 * Get institution id.
	 * @return int
	 */
	function getInstitutionId() {
		return $this->getData('institutionId');
	} 

	/**
	 * Set institution id.
	 * @param $institutionId int
	 */
	function setInstitutionId($institutionId) {
		return $this->setData('institutionId', $institutionId);
	}

	/**
	 * Get institution type.
	 * @return int
	 */
	function getInstitutionType() {
		return $this->getData('type');
	} 

        /**
	 * Get institution type translation key.
	 * @return int
	 */
	function getInstitutionTypeKey() {
		$institutionTypeMap =& $this->getInstitutionTypeMap();
		return $institutionTypeMap[$this->getInstitutionType()];
	}

        /**
	 * Get a map for yes/no/not provided constant to locale key.
	 * @return array
	 */
	function &getInstitutionTypeMap() {
		static $institutionTypeMap;
		if (!isset($institutionTypeMap)) {
			$institutionTypeMap = array(
                                INSTITUTION_TYPE_PUBLIC => 'institution.type.public',
				INSTITUTION_TYPE_PRIVATE_PROFIT => 'institution.type.privateProfit',
				INSTITUTION_TYPE_PRIVATE_NON_PROFIT => 'institution.type.privateNonProfit',
				INSTITUTION_TYPE_PRIVATE_INDIVIDUAL => 'institution.type.privateIndividual'
                        );
		}
		return $institutionTypeMap;
	}
        
        
	/**
	 * Set institution type.
	 * @param $type int
	 */
	function setInstitutionType($type) {
		return $this->setData('type', $type);
	}
        
        /**
	 * Get if the institution is international or national.
	 * @return int
	 */
        function getInstitutionInternational() {
		return $this->getData('international');
        }
        
        /**
	 * Get institution international full text.
	 * @return string
	 */
	function getInstitutionInternationalText() {
                $international = $this->getData('international');
                if ($international == INSTITUTION_NATIONAL) {
                    $journal =& Request::getJournal();
                    $coveredArea = $journal->getLocalizedSetting('location');               
                    return $coveredArea;
                } else {
                    return Locale::translate('institution.international');
                }

	}

        /**
	 * Set if the institution is international or national.
	 * @param $international int
	 */
        function setInstitutionInternational($international){
		return $this->setData('international', $international);
        }
        
        /**
	 * Get institution location.
	 * @return string
	 */
	function getInstitutionLocation() {
		return $this->getData('location');
	} 
        
        /**
	 * Get institution location full text.
	 * @return string
	 */
	function getInstitutionLocationText() {
            
                $international = $this->getInstitutionInternational();
                $location = $this->getInstitutionLocation(); 
                $returner = (string) '';
                if ($international == INSTITUTION_NATIONAL) {
                    $extraFieldDAO =& DAORegistry::getDAO('ExtraFieldDAO');
                    $extraField =& $extraFieldDAO->getExtraField($location);
                    if (isset($extraField)){$returner = $extraField->getLocalizedExtraFieldName();}
                    else {$returner = '-';}
                } elseif ($international == INSTITUTION_INTERNATIONAL) {
                    $countryDAO =& DAORegistry::getDAO('CountryDAO');
                    $returner = $countryDAO->getCountry($location);
                }
                return $returner;            
	}
        
	/**
	 * Set institution location.
	 * @param $location string
	 */
	function setInstitutionLocation($location) {
		return $this->setData('location', $location);
	}

        /**
	 * Get institution name.
	 * @return string
	 */
	function getInstitutionName() {
		return $this->getData('name');
	} 

	/**
	 * Set institution name.
	 * @param $name string
	 */
	function setInstitutionName($name) {
		return $this->setData('name', $name);
	}

        /**
	 * Get institution acronym.
	 * @return string
	 */
	function getInstitutionAcronym() {
		return $this->getData('acronym');
	} 

	/**
	 * Set institution acronym.
	 * @param $acronym string
	 */
	function setInstitutionAcronym($acronym) {
		return $this->setData('acronym', $acronym);
	}
        
}

?>