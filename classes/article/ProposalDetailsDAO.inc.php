<?php

/**
 * @file classes/article/ProposalDetailsDAO.inc.php
 *
 * @class ProposalDetailsDAO
 *
 * @brief Operations for retrieving and modifying proposal details objects.
 */

// $Id$

import('classes.article.ProposalDetails');

class ProposalDetailsDAO extends DAO{

	var $studentResearchDao;
 
        /**
	 * Constructor.
	 */
	function ProposalDetailsDAO() {
		parent::DAO();
		$this->studentResearchDao =& DAORegistry::getDAO('StudentResearchDAO');
        }

        /**
	 * Get the proposal details for a submission.
	 * @param $submissionId int
	 * @return proposalDetails object
	 */
	function &getProposalDetailsByArticleId($submissionId) {

		$result =& $this->retrieve(
			'SELECT * FROM article_details WHERE article_id = ? LIMIT 1',
			(int) $submissionId
		);

		$proposalDetails =& $this->_returnProposalDetailsFromRow($result->GetRowAssoc(false));

		$result->Close();
		unset($result);

		return $proposalDetails;
	}

	/**
	 * Insert a new proposal details.
	 * @param $proposalDetails object
	 */
	function insertProposalDetails(&$proposalDetails) {
		$this->update(
                        sprintf(
			'INSERT INTO article_details
				(article_id, student, start_date, end_date, key_implementing_institution, multi_country, countries, nationwide, geo_areas, research_domains, research_fields, human_subjects, proposal_types, data_collection, committee_reviewed)
				VALUES			
                                (?, ?, %s, %s, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                        $this->dateToDB(strtotime($proposalDetails->getStartDate())), $this->dateToDB(strtotime($proposalDetails->getEndDate()))),
			array(
				(int) $proposalDetails->getArticleId(),
				(int) $proposalDetails->getStudentResearch(),
				(int) $proposalDetails->getKeyImplInstitution(),
				(int) $proposalDetails->getMultiCountryResearch(),
				(string) $proposalDetails->getCountries(),
				(int) $proposalDetails->getNationwide(),
				(string) $proposalDetails->getGeoAreas(),
				(string) $proposalDetails->getResearchDomains(),
                                (string) $proposalDetails->getResearchFields(),
				(int) $proposalDetails->getHumanSubjects(),
				(string) $proposalDetails->getProposalTypes(),
				(int) $proposalDetails->getDataCollection(),
				(int) $proposalDetails->getCommitteeReviewed()
			)
		);
		
                // inser student research
		$studentResearch =& $proposalDetails->getStudentResearchInfo();
		if ($this->studentResearchDao->studentResearchExists($proposalDetails->getArticleId())) {
                        if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) $this->studentResearchDao->updateStudentResearch($studentResearch);
                        else $this->studentResearchDao->deleteStudentResearch($proposalDetails->getArticleId());
		} elseif ($studentResearch->getArticleId() != null) {
                        if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) $this->studentResearchDao->insertStudentResearch($studentResearch);
		}

		return true;
	}

	/**
	 * Update an existing proposal details object.
	 * @param $proposalDetails ProposalDetails object
	 */
	function updateProposalDetails(&$proposalDetails) {
		$returner = $this->update(sprintf(
			'UPDATE article_details
			SET	
				student = ?,
				start_date = %s,
				end_date = %s,
				key_implementing_institution = ?, 
				multi_country = ?,
				countries = ?,
				nationwide = ?,
				geo_areas = ?,
				research_domains = ?,
                                research_fields = ?,
				human_subjects = ?,
				proposal_types = ?,
				data_collection = ?,
				committee_reviewed = ?
			WHERE	article_id = ?',
                        $this->datetimeToDB(strtotime($proposalDetails->getStartDate())), 
                        $this->datetimeToDB(strtotime($proposalDetails->getEndDate()))),
			array(
				(int) $proposalDetails->getStudentResearch(),
				(int) $proposalDetails->getKeyImplInstitution(),
				(int) $proposalDetails->getMultiCountryResearch(),
				(string) $proposalDetails->getCountries(),
				(int) $proposalDetails->getNationwide(),
				(string) $proposalDetails->getGeoAreas(),
				(string) $proposalDetails->getResearchDomains(),
				(string) $proposalDetails->getResearchFields(),
				(int) $proposalDetails->getHumanSubjects(),
				(string) $proposalDetails->getProposalTypes(),
				(int) $proposalDetails->getDataCollection(),
				(int) $proposalDetails->getCommitteeReviewed(),
				(int) $proposalDetails->getArticleId()
			)
		);

                // update student research for this proposail details
		$studentResearch =& $proposalDetails->getStudentResearchInfo();
		if ($this->studentResearchDao->studentResearchExists($proposalDetails->getArticleId())) {
                        if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) $this->studentResearchDao->updateStudentResearch($studentResearch);
                        else $this->studentResearchDao->deleteStudentResearch($proposalDetails->getArticleId());
		} elseif ($studentResearch->getArticleId() != null) {
                        if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) $this->studentResearchDao->insertStudentResearch($studentResearch);
		}
                
		return true;
	}

	/**
	 * Delete a specific proposal details by article ID
	 * @param $submissionId int
	 */
	function deleteProposalDetails($submissionId) {
		$returner = $this->update(
			'DELETE FROM article_details WHERE article_id = ?',
			$submissionId
		);

		return $this->studentResearchDao->deleteStudentResearch($submissionId);
	}

	/**
	 * Check if a proposal details object exists
	 * @param $submissionId int
	 * @return boolean
	 */
	function proposalDetailsExists($submissionId) {
		$result =& $this->retrieve('SELECT count(*) FROM article_details WHERE article_id = ?', (int) $submissionId);
		$returner = $result->fields[0]?true:false;
		$result->Close();
		return $returner;
	}
        
        /**
	 * Internal function to return a proposal details object from a row.
	 * @param $row array
	 * @return ProposalDetails object
	 */
	function &_returnProposalDetailsFromRow(&$row) {
            
		$proposalDetails = new ProposalDetails();
                
		$proposalDetails->setArticleId($row['article_id']);
		$proposalDetails->setStudentResearch($row['student']);
		if(isset($row['start_date']))$proposalDetails->setStartDate(date("d-M-Y", strtotime($this->dateFromDB($row['start_date']))));
		if(isset($row['end_date']))$proposalDetails->setEndDate(date("d-M-Y", strtotime($this->dateFromDB($row['end_date']))));
                $proposalDetails->setKeyImplInstitution($row['key_implementing_institution']);
		$proposalDetails->setMultiCountryResearch($row['multi_country']);
		$proposalDetails->setCountries($row['countries']);
		$proposalDetails->setNationwide($row['nationwide']);
		$proposalDetails->setGeoAreas($row['geo_areas']);
		$proposalDetails->setResearchDomains($row['research_domains']);
                $proposalDetails->setResearchFields($row['research_fields']);
		$proposalDetails->setHumanSubjects($row['human_subjects']);
		$proposalDetails->setProposalTypes($row['proposal_types']);
		$proposalDetails->setDataCollection($row['data_collection']);
		$proposalDetails->setCommitteeReviewed($row['committee_reviewed']);

                $proposalDetails->setStudentResearchInfo($this->studentResearchDao->getStudentResearchByArticleId($row['article_id']));
                        
		HookRegistry::call('ProposalDetailsDAO::_returnProposalDetailsFromRow', array(&$proposalDetails, &$row));

		return $proposalDetails;
	}
        
        function getYesNoArray() {
            return array(
                PROPOSAL_DETAIL_YES => Locale::translate("common.yes"),
                PROPOSAL_DETAIL_NO => Locale::translate("common.no")
            );
        }
        
        function getNationwideRadioButtons() {
            return array(
                PROPOSAL_DETAIL_YES => Locale::translate("common.yes"),
                PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS => Locale::translate("proposal.randomlySelectedProvince"),
                PROPOSAL_DETAIL_NO => Locale::translate("common.no")
            );
        }
        
        function getDataCollectionArray() {
            return array(
                PROPOSAL_DETAIL_PRIMARY_DATA_COLLECTION => Locale::translate("proposal.primaryDataCollection"),
                PROPOSAL_DETAIL_SECONDARY_DATA_COLLECTION => Locale::translate("proposal.secondaryDataCollection"),
                PROPOSAL_DETAIL_BOTH_DATA_COLLECTION => Locale::translate("proposal.bothDataCollection")
            );
        }
        
        function getOtherErcDecisionArray() {
            return array(
                PROPOSAL_DETAIL_UNDER_REVIEW => Locale::translate("proposal.otherErcDecisionUnderReview"),
                PROPOSAL_DETAIL_REVIEW_AVAILABLE => Locale::translate("proposal.otherErcDecisionFinalAvailable")
            );
        }
        
        /*
         * Count the number of Key Implementing Institution using a specific institution
         */
        function getCountKIIByInstitution($institutionId) {
            $result = $this->retrieve('SELECT count(*) FROM article_details WHERE key_implementing_institution = ?', (int) $institutionId);
            $returner = isset($result->fields[0]) ? $result->fields[0] : 0;

            $result->Close();
            unset($result);
            return $returner;
        }
        
        /*
         * Replace the Key Implementing Institution by another institution
         */
        function replaceKII($oldInstitutionId, $replacementInstitutionId) {
		return $this->update('UPDATE article_details SET key_implementing_institution = '.$replacementInstitutionId.' WHERE key_implementing_institution = '.$oldInstitutionId);
        }         
        
        
        /*
         * Get all the proposal details using a specific extra field
         */
        function getExtraFields($type, $extraFieldId) {
            $proposalDetails = array();
            
            switch ($type) {
                case 'geoAreas':
                    $result = $this->retrieve('SELECT * FROM article_details WHERE '
                            . 'geo_areas LIKE "'.$extraFieldId.'" OR '
                            . 'geo_areas LIKE "'.$extraFieldId.',%" OR '
                            . 'geo_areas LIKE "%,'.$extraFieldId.',%" OR '
                            . 'geo_areas LIKE "%,'.$extraFieldId.'"');
                    break;
                case 'researchFields':
                    $result = $this->retrieve('SELECT * FROM article_details WHERE '
                            . 'research_fields LIKE "'.$extraFieldId.'" OR '
                            . 'research_fields LIKE "'.$extraFieldId.'+%" OR '
                            . 'research_fields LIKE "%+'.$extraFieldId.'+%" OR '
                            . 'research_fields LIKE "%+'.$extraFieldId.'"');
                    break;
                case 'researchDomains':
                    $result = $this->retrieve('SELECT * FROM article_details WHERE '
                            . 'research_domains LIKE "'.$extraFieldId.'" OR '
                            . 'research_domains LIKE "'.$extraFieldId.'+%" OR '
                            . 'research_domains LIKE "%+'.$extraFieldId.'+%" OR '
                            . 'research_domains LIKE "%+'.$extraFieldId.'"');
                    break;
                case 'proposalTypes':
                    $result = $this->retrieve('SELECT * FROM article_details WHERE '
                            . 'proposal_types LIKE "'.$extraFieldId.'" OR '
                            . 'proposal_types LIKE "'.$extraFieldId.'+%" OR '
                            . 'proposal_types LIKE "%+'.$extraFieldId.'+%" OR '
                            . 'proposal_types LIKE "%+'.$extraFieldId.'"');
                    break;
            }            
            while (!$result->EOF) {
                    $row = $result->GetRowAssoc(false);
                    $proposalDetails[] =& $this->_returnProposalDetailsFromRow($row);
                    $result->moveNext();
            }

            $result->Close();
            unset($result);
            return $proposalDetails;
        }
        
        
        /*
         * Get an array of all the "other" fields the submitter enter manually for research fields and proposal types
         * @param $type int specify wether it is for the research fields or for the proposal types
         */
         function getAllOtherFields($type){
             $proposalDetails = array();
             $otherFields = array();
             if ($type == "researchFields") {
                 $sql = 'SELECT * FROM article_details WHERE research_fields LIKE "%Other (%"';
                 $function = 'getResearchFieldsArray';
             } elseif ($type == "proposalTypes"){
                 $sql = 'SELECT * FROM article_details WHERE proposal_types LIKE "%Other (%"';
                 $function = 'getProposalTypesArray';
             } else {
                 return $otherFields;
             }
             
             $result = $this->retrieve($sql);
             
             while (!$result->EOF) {
                    $row = $result->GetRowAssoc(false);
                    $proposalDetails[] =& $this->_returnProposalDetailsFromRow($row);
                    $result->moveNext();
             }
             
             foreach ($proposalDetails as $proposalDetail) {
                 $array = $proposalDetail->$function();
                 $otherValue = '';
                 foreach ($array as $value){
                    if (preg_match('#^Other\s\(.+\)$#', $value)){
                        $value = preg_replace('#^Other\s\(#','', $value);
                        $value = preg_replace('#\)$#','', $value);
                        $otherValue = $value;
                    }
                 }
                 $otherFields = $otherFields + array($proposalDetail->getArticleId() => $otherValue);
             }
             
             return $otherFields;
         }
}

?>
