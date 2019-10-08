<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/ProposalDetails.inc.php
 *
 *
 * @brief proposal details class.
 */

// For integers
define ('PROPOSAL_DETAIL_NOT_PROVIDED', 0);
define ('PROPOSAL_DETAIL_NO', 1);
define ('PROPOSAL_DETAIL_YES', 2);

// For non nationwide research
define ('PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS', 3);

// For data collection
define ('PROPOSAL_DETAIL_PRIMARY_DATA_COLLECTION', 1);
define ('PROPOSAL_DETAIL_SECONDARY_DATA_COLLECTION', 2);
define ('PROPOSAL_DETAIL_BOTH_DATA_COLLECTION', 3);

// For Committee reviewed
define ('PROPOSAL_DETAIL_UNDER_REVIEW', 2);
define ('PROPOSAL_DETAIL_REVIEW_AVAILABLE', 3);


class ProposalDetails extends DataObject {
    
	
	var $studentResearchInfo;

    
        var $proposalDetailsDAO;
        
	/**
	 * Constructor.
	 */
	function ProposalDetails() {
                $this->proposalDetailsDAO =& DAORegistry::getDAO('ProposalDetailsDAO');
	}

        
	/**
	 * Set article id.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		return $this->setData('articleId', $articleId);
	}    
	/**
	 * Get article id.
	 * @return int
	 */
	function getArticleId() {
		return $this->getData('articleId');
	}

 
	/**
	 * Set if it's a student Research.
	 * @param $studentResearch int
	 */
	function setStudentResearch($studentResearch) {
		return $this->setData('studentResearch', $studentResearch);
	}       
	/**
	 * Get if it's a student Research.
	 * @return int
	 */
	function getStudentResearch() {
		return $this->getData('studentResearch');
	}
	/**
	 * Set student research info (object) for this proposal
	 * @param $studentResearch object
	 */
	function setStudentResearchInfo($studentResearchInfo) {
		return $this->studentResearchInfo = $studentResearchInfo;
	}
	/**
	 * Get student research info (object) for this proposal
	 */
	function getStudentResearchInfo() {
		return $this->studentResearchInfo;
	}

        
        /**
	 * Set start date of the research.
	 * @param $startDate date
	 */
	function setStartDate($startDate) {
		return $this->setData('startDate', $startDate);
	}
	/**
	 * Get start date of the research.
	 * @return date
	 */
	function getStartDate() {
		return $this->getData('startDate');
	}


	/**
	 * Set end date of the research.
	 * @param $endDate date
	 */
	function setEndDate($endDate) {
		return $this->setData('endDate', $endDate);
	}
	/**
	 * Get end date of the research.
	 * @return date
	 */
	function getEndDate() {
		return $this->getData('endDate');
	}


        /**
	 * Set key implementing institution.
	 * @param $keyImplInstitution int
	 */
	function setKeyImplInstitution($keyImplInstitution) {
		return $this->setData('keyImplInstitution', $keyImplInstitution);
	}
	/**
	 * Get key implementing institution.
	 * @return int
	 */
	function getKeyImplInstitution() {
		return $this->getData('keyImplInstitution');
	}  
	/**
	 * Get key implementing institution name.
	 * @return int
	 */
	function getKeyImplInstitutionName() {
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                $institution = $institutionDao->getInstitutionById($this->getKeyImplInstitution());
		return $institution->getInstitutionName();
	} 
	/**
	 * Get key implementing institution acronym.
	 * @return int
	 */
	function getKeyImplInstitutionAcronym() {
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                $institution = $institutionDao->getInstitutionById($this->getKeyImplInstitution());
		return $institution->getInstitutionAcronym();
        }  
	/**
	 * Get key implementing institution object.
	 * @return int
	 */
	function getKeyImplInstitutionObject() {
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                return $institutionDao->getInstitutionById($this->getKeyImplInstitution());
        }  
        
        
	/**
	 * Set if the research involves multiple countries.
	 * @param $multiCountry int
	 */
	function setMultiCountryResearch($multiCountry) {
		return $this->setData('multiCountry', $multiCountry);
	}    
	/**
	 * Get if the research involves multiple countries.
	 * @return int
	 */
	function getMultiCountryResearch() {
		return $this->getData('multiCountry');
	}
        
        
	/**
	 * Set countries in case of multi-country research.
	 * @param $countries string
	 */
	function setCountries($countries) {
		return $this->setData('countries', $countries);
	}
	/**
	 * Get countries in case of multi-country research.
	 * @return string
	 */
	function getCountries() {
		return $this->getData('countries');
	}
   	/**
	 * Get "localized" multi country full text.
	 * @return string
	 */
	function getLocalizedMultiCountryText() {
                $countryDAO =& DAORegistry::getDAO('CountryDAO');
		return $countryDAO->getCountry($this->getCountries());
	}

        
	/**
	 * Set if the research is nationwide.
	 * @param $nationwide int
	 */
	function setNationwide($nationwide) {
		return $this->setData('nationwide', $nationwide);
	}
	/**
	 * Get if the research is nationwide.
	 * @return int
	 */
	function getNationwide() {
		return $this->getData('nationwide');
	}
        /**
	 * Get a map for yes/no/not provided constant to locale key.
	 * @return array
	 */
	function &getNationwideMap() {
		static $nationwideMap;
		if (!isset($nationwideMap)) {
			$nationwideMap = array(
                                PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS => 'proposal.randomlySelectedProvince',
				PROPOSAL_DETAIL_NO => 'common.no',
				PROPOSAL_DETAIL_YES => 'common.yes'
			);
		}
		return $nationwideMap;
	}	
	/**
	 * Get a locale key for yes/no/not provided
	 * @param $value
	 */
	function getNationwideKey() {
		$nationwideMap =& $this->getNationwideMap();
		return $nationwideMap[$this->getNationwide()];
	}        
        
        
	/**
	 * Set geographical areas of the research.
	 * @param $geoAreas string
	 */
	function setGeoAreas($geoAreas) {
		return $this->setData('geoAreas', $geoAreas);
	}
	/**
	 * Set geographical areas of the research from an array.
	 * @param $geoAreas array
	 */
	function setGeoAreasFromArray($geoAreasArray) {
                return $this->setGeoAreas(implode(",", $geoAreasArray));
	}        
	/**
	 * Get geographical areas of the research.
	 * @return string
	 */
	function getGeoAreas() {
		return $this->getData('geoAreas');
        }
	/**
	 * Get geographical areas of the research in an array.
	 * @return array
	 */
	function getGeoAreasArray() {
                $geoAreas = $this->getGeoAreas();
                if($geoAreas == '' || $geoAreas == null) {
                    return null;
                } else {                
                    return explode(",", $geoAreas);
                }
        }
        /**
	 * Get "localized" geographical areas full text.
s	 * @return string
	 */
	function getLocalizedGeoAreasText() {
                $extraFieldDAO =& DAORegistry::getDAO('ExtraFieldDAO');
		return $extraFieldDAO->getLocalizedNames($this->getGeoAreasArray());
	}
        
	/**
	 * Set research domains of the research.
	 * @param $domains string
	 */
	function setResearchDomains($domains) {
		return $this->setData('rDomains', $domains);
	}
	
        /**
	 * Get research domains of the research.
	 * @return string
	 */
	function getResearchDomains() {
		return $this->getData('rDomains');
        }

        /**
	 * Set research domains of the research.
	 * @param $domainsArray Array
	 */
	function setResearchDomainsFromArray($domainsArray) {
		return $this->setResearchDomains(implode("+", $domainsArray));
        }

        /**
	 * Get research domains of the research in an array.
	 * @return Array
	 */
	function getResearchDomainsArray() {
                $researchDomainsString = $this->getResearchDomains();
                if($researchDomainsString == '' || $researchDomainsString == null) {
                    return null;
                } else {
                    return explode("+", $researchDomainsString);
                }
        }
        
        /**
	 * Get "localized" research domains full text.
	 * @return string
	 */
	function getLocalizedResearchDomainsText() {
                $extraFieldDAO =& DAORegistry::getDAO('ExtraFieldDAO');
		return $extraFieldDAO->getLocalizedNames($this->getResearchDomainsArray());
	}
        
	/**
	 * Set research fields.
	 * @param $researchFields string
	 */
	function setResearchFields($researchFields) {
		return $this->setData('researchFields', $researchFields);
	} 
	/**
	 * Set research fields from an array.
	 * @param $researchFieldsArray array
	 */
	function setResearchFieldsFromArray($researchFieldsArray) {
		return $this->setResearchFields(implode("+", $researchFieldsArray));
	} 
        /**
	 * Get research fields.
	 * @return string
	 */
	function getResearchFields() {
		return $this->getData('researchFields');
	}
        /**
	 * Get research fields in an array.
	 * @return array
	 */
	function getResearchFieldsArray() {
                $researchFields = $this->getResearchFields();
                if($researchFields == '' || $researchFields == null) {
                    return null;
                } else {
                    return explode("+", $researchFields);
                }                        
	}
        /**
	 * Set other research field
	 * @param $otherResearchField string
	 */
	function setOtherResearchField($otherResearchField) {
		return $this->setData('otherResearchField', $otherResearchField);
	}
	/**
	 * Get other research field.
	 * @return string
	 */
	function getOtherResearchField() {
		return $this->getData('otherResearchField');
	}
        /**
	 * Get "localized" research field's full text.
	 * @return string
	 */
	function getLocalizedResearchFieldText() {
                $extraFieldDAO =& DAORegistry::getDAO('ExtraFieldDAO');
		return $extraFieldDAO->getLocalizedNames($this->getResearchFieldsArray());            
	}
 
        
	/**
	 * Set if the research involves human subjects.
	 * @param $humanSubjects int
	 */
	function setHumanSubjects($humanSubjects) {
		return $this->setData('humanSubjects', $humanSubjects);
	}
	/**
	 * Get if the research involves human subjects.
	 * @return int
	 */
	function getHumanSubjects() {
		return $this->getData('humanSubjects');
	}
        
        
	/**
	 * Set the types of the proposal.
	 * @param $proposalTypes string
	 */
	function setProposalTypes($proposalTypes) {
		return $this->setData('proposalTypes', $proposalTypes);
	}
	/**
	 * Set the types of the proposal from an array.
	 * @param $proposalTypesArray array
	 */
	function setProposalTypesFromArray($proposalTypesArray) {
		return $this->setProposalTypes(implode("+", $proposalTypesArray));
	}
        /**
	 * Get the types of the proposal.
	 * @return string
	 */
	function getProposalTypes() {
		return $this->getData('proposalTypes');
	}
	/**
	 * Get the types of the proposal in an array.
	 * @return array
	 */
	function getProposalTypesArray() {
                $proposalTypes = $this->getProposalTypes();
                if($proposalTypes == '' || $proposalTypes == null) {
                    return null;
                } else {
                    return explode("+", $proposalTypes);
                }         
	}        
        /**
	 * Set other proposal type
	 * @param $otherProposalType string
	 */
	function setOtherProposalType($otherProposalType) {
		return $this->setData('otherProposalType', $otherProposalType);
	}
	/**
	 * Get other proposal type.
	 * @return string
	 */
	function getOtherProposalType() {
		return $this->getData('otherProposalType');
        }
        /**
	 * Get "localized" proposal type's full text.
	 * @return string
	 */
	function getLocalizedProposalTypeText() {
                $extraFieldDAO =& DAORegistry::getDAO('ExtraFieldDAO');
		return $extraFieldDAO->getLocalizedNames($this->getProposalTypesArray());    
	}

        
	/**
	 * Set the data collection for this proposal (yes/no).
	 * @param $dataCollection int
	 */
	function setDataCollection($dataCollection) {
		return $this->setData('dataCollection', $dataCollection);
	}
	/**
	 * Get the data collection for this proposal.
	 * @return int
	 */
	function getDataCollection() {
		return $this->getData('dataCollection');
	}
        /**
	 * Get a map for previous committee reviewed constant to locale key.
	 * @return array
	 */
	function &getDataCollectionMap() {
		static $dataCollectionMap;
		if (!isset($dataCollectionMap)) {
			$dataCollectionMap = array(
                                PROPOSAL_DETAIL_NOT_PROVIDED => 'common.dataNotProvided',
				PROPOSAL_DETAIL_PRIMARY_DATA_COLLECTION => 'proposal.primaryDataCollection',
				PROPOSAL_DETAIL_SECONDARY_DATA_COLLECTION => 'proposal.secondaryDataCollection',
				PROPOSAL_DETAIL_BOTH_DATA_COLLECTION => 'proposal.bothDataCollection'
			);
		}
		return $dataCollectionMap;
	}
	/**
	 * Get a locale key for the previous committee reviewed status
	 */
	function getDataCollectionKey() {
                $dataCollection = $this->getDataCollection();
		$dataCollectionMap =& $this->getDataCollectionMap();
		return $dataCollectionMap[$dataCollection];
	}
        
        
	/**
	 * Set if the proposal has already been reviewed by another committee.
	 * @param $committeeReviewed int
	 */
	function setCommitteeReviewed($committeeReviewed) {
		return $this->setData('committeeReviewed', $committeeReviewed);
	}
	/**
	 * Get if the proposal has already been reviewed by another committee.
	 * @return int
	 */
	function getCommitteeReviewed() {
		return $this->getData('committeeReviewed');
	}
        /**
	 * Get a map for previous committee reviewed constant to locale key.
	 * @return array
	 */
	function &getCommitteeReviewedMap() {
		static $committeeReviewedMap;
		if (!isset($committeeReviewedMap)) {
			$committeeReviewedMap = array(
                                PROPOSAL_DETAIL_NOT_PROVIDED => 'common.dataNotProvided',
				PROPOSAL_DETAIL_NO => 'common.no',
				PROPOSAL_DETAIL_UNDER_REVIEW => 'proposal.otherErcDecisionUnderReview',
				PROPOSAL_DETAIL_REVIEW_AVAILABLE => 'proposal.otherErcDecisionFinalAvailable'
			);
		}
		return $committeeReviewedMap;
	}
	/**
	 * Get a locale key for the previous committee reviewed status
	 */
	function getCommitteeReviewedKey() {
                $committeeReviewed = $this->getCommitteeReviewed();
		$committeeReviewedMap =& $this->getCommitteeReviewedMap();
		return $committeeReviewedMap[$committeeReviewed];
	}

        
        /**
	 * Get a map for yes/no/not provided constant to locale key.
	 * @return array
	 */
	function &getYesNoMap() {
		static $yesNoMap;
		if (!isset($yesNoMap)) {
			$yesNoMap = array(
                                PROPOSAL_DETAIL_NOT_PROVIDED => 'common.dataNotProvided',
				PROPOSAL_DETAIL_NO => 'common.no',
				PROPOSAL_DETAIL_YES => 'common.yes'
			);
		}
		return $yesNoMap;
	}	
	/**
	 * Get a locale key for yes/no/not provided
	 * @param $value
	 */
	function getYesNoKey($value) {
		$yesNoMap =& $this->getYesNoMap();
		return $yesNoMap[$value];
	}
        
    
}
?>
