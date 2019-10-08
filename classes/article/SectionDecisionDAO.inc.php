<?php

/**
 * @file classes/article/SectionDecisionDAO.inc.php
 *
 * @class SectionDecisionDAO
 *
 * @brief Operations for retrieving and modifying section decision objects.
 * Added by EL on April 2013
 */

// $Id$

import('classes.article.SectionDecision');

class SectionDecisionDAO extends DAO{
        
	var $reviewAssignmentDao;

	/**
	 * Constructor.
	 */	
	function SectionDecisionDAO() {
		parent::DAO();
		$this->reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
	}



	/**
	 * Get a specific section decision.
	 * @param $sectionDecisionId int
	 * @return section decision
	 */
	function &getSectionDecision($sectionDecisionId) {

		$result =& $this->retrieve(
			'SELECT sd.*, a.public_id FROM section_decisions sd'
                        . ' LEFT JOIN articles a ON (a.article_id = sd.article_id)'
                        . ' WHERE section_decision_id = ?',
			(int) $sectionDecisionId
		);

		$sectionDecision =& $this->_returnSectionDecisionFromRow($result->GetRowAssoc(false));

		$result->Close();
		unset($result);

		return $sectionDecision;
	}

	/**
	 * Get a specific section decision.
	 * @param $sectionDecisionId int
	 * @return section decision
	 */
	function &getSectionDecisionsByArticleId($articleId) {
		$sectionDecisions = array();
		
		$result =& $this->retrieve(
			'SELECT sd.*, a.public_id FROM section_decisions sd'
                        . ' LEFT JOIN articles a ON (a.article_id = sd.article_id)'
                        . ' WHERE sd.article_id = ?',
			(int) $articleId
		);
		
		while (!$result->EOF) {
			$sectionDecisions[] =& $this->_returnSectionDecisionFromRow($result->GetRowAssoc(false));
			$result->moveNext();		
		}

		$result->Close();
		unset($result);		
		return $sectionDecisions;
	}
	
	/**
	 * Insert a new section decision.
	 * @param $author Author
	 */
	function insertSectionDecision(&$sectionDecision) {
		$this->update(
			sprintf('
				INSERT INTO section_decisions 
					(article_id, review_type, round, section_id, decision, comments, date_decided) 
				VALUES 
					(?, ?, ?, ?, ?, ?, %s)', 
			$this->datetimeToDB($sectionDecision->getDateDecided())), 
			array(
				(int) $sectionDecision->getArticleId(),
				(int) $sectionDecision->getReviewType(),
				(int) $sectionDecision->getRound(),
				(int) $sectionDecision->getSectionId(),
				(int) $sectionDecision->getDecision(),
				$sectionDecision->getComments()

                       )
		);
	
		return true;
	}

	/**
	 * Update an existing section decision.
	 * @param $sectionDecision Section Decision
	 */
	function updateSectionDecision(&$sectionDecision) {
		$this->update(
			sprintf('
				UPDATE section_decisions SET
					review_type = ?, round = ?, section_id = ?, decision = ?, comments = ?, date_decided = %s
				WHERE section_decision_id = ?',
			$this->datetimeToDB($sectionDecision->getDateDecided())),
			array($sectionDecision->getReviewType(), $sectionDecision->getRound(), $sectionDecision->getSectionId(), $sectionDecision->getDecision(), $sectionDecision->getComments(), $sectionDecision->getId())
		);

		foreach ($sectionDecision->getReviewAssignments() as $reviewAssignment) {
			if ($reviewAssignment->getId() > 0) {
				$this->reviewAssignmentDao->updateReviewAssignment($reviewAssignment);
			} else {
				$this->reviewAssignmentDao->insertReviewAssignment($reviewAssignment);
			}
		}
		
		return true;
	}

	/**
	 * Delete a specific section decision by id
	 * @param $sectionDecisionId int
	 */
	function deleteSectionDecision($sectionDecisionId) {
		$returner = $this->update(
			'DELETE FROM section_decisions WHERE section_decision_id = ?',
			$sectionDecisionId
		);
		
		
		return $returner;
	}

	/**
	 * Delete all section decisions of an article id
	 * @param $articleId int
	 */
	function deleteSectionDecisionsByArticleId($articleId) {
		$returner = false;
		$sDecisions =& $this->getSectionDecisionsByArticleId($articleId);
		foreach ($sDecisions as $sDecision){
			$this->deleteSectionDecision($sDecision->getId());
			$this->reviewAssignmentDao->deleteByDecisionId($sDecision->getId());
			$returner = true;
		}
		return $returner;
	}

	/**
	 * Internal function to return a section decision object from a row.
	 * @param $row array
	 * @return sectionDecision
	 */
	function &_returnSectionDecisionFromRow(&$row) {
		$sectionDecision = new SectionDecision();
		$sectionDecision->setId($row['section_decision_id']);
		$sectionDecision->setArticleId($row['article_id']);
		$sectionDecision->setReviewType($row['review_type']);
		$sectionDecision->setRound($row['round']);
		$sectionDecision->setSectionId($row['section_id']);
		$sectionDecision->setDecision($row['decision']);
		$sectionDecision->setComments($row['comments']);
                $sectionDecision->setDateDecided($this->datetimeFromDB($row['date_decided']));

                $sectionDecision->setProposalId($row['public_id']);
                
		$sectionDecision->setReviewAssignments($this->reviewAssignmentDao->getReviewAssignmentsByDecisionId($row['section_decision_id']));

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');		
		import('classes.file.ArticleFileManager');

		$sectionDecision->setAuthorViewableReviewFiles($this->reviewAssignmentDao->getAuthorViewableFilesByDecision($row['section_decision_id']));

		$sectionDecision->setDecisionFiles($articleFileDao->getArticleFilesByAssocId($row['section_decision_id'], ARTICLE_FILE_DECISION));
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
                $sectionDecision->setMeetings($meetingDao->getMeetingsBySectionDecisionId($row['section_decision_id']));
                
		HookRegistry::call('SectionDecisionDAO::_returnSectionDecisionFromRow', array(&$sectionDecision, &$row));

		return $sectionDecision;
	}


	function getLastSectionDecision($articleId, $reviewType = null) {
		
		if ($reviewType) {
			$result =& $this->retrieve(
				'SELECT sd.*, a.public_id FROM section_decisions sd LEFT JOIN articles a ON (a.article_id = sd.article_id) WHERE sd.article_id = ? AND sd.review_type = ? ORDER BY sd.section_decision_id DESC LIMIT 1', array($articleId, $reviewType)
			);		
		} else {
			$result =& $this->retrieve(
				'SELECT sd.*, a.public_id FROM section_decisions sd LEFT JOIN articles a ON (a.article_id = sd.article_id) WHERE sd.article_id = ? ORDER BY sd.section_decision_id DESC LIMIT 1', $articleId
			);
		}
		
		$sectionDecision =& $this->_returnSectionDecisionFromRow($result->GetRowAssoc(false));
		 
		$result->Close();
		unset($result);
		
		return $sectionDecision;
	}

	function getResubmitCount($dateDecided, $articleId, $reviewType, $round) {
		$result =& $this->retrieve(
			sprintf('SELECT COUNT(*) FROM section_decisions WHERE article_id = ? AND review_type = ? AND round = ? AND date_decided < %s', 
			$this->datetimeToDB($dateDecided)),
			array($articleId, $reviewType, $round)
		);

		$returner = isset($result->fields[0]) ? $result->fields[0] : 0;

		$result->Close();
		unset($result);
		
		return $returner;
	}
	
	/**
	 * Get proposal status based on last decision on article
	**/
	function getProposalStatus($articleId) {
		$decision = $this->getLastSectionDecision($articleId);
		switch ($decision->getDecision()) {
			case SUBMISSION_SECTION_DECISION_EXEMPTED:
				$proposalStatus = PROPOSAL_STATUS_EXEMPTED;
				break;
			case SUBMISSION_SECTION_DECISION_COMPLETE:
				$proposalStatus = PROPOSAL_STATUS_CHECKED;
				break;
			case SUBMISSION_SECTION_DECISION_FULL_REVIEW:
				$proposalStatus = PROPOSAL_STATUS_FULL_REVIEW;
				break;
			case SUBMISSION_SECTION_DECISION_EXPEDITED:
				$proposalStatus = PROPOSAL_STATUS_EXPEDITED;
				break;
			case SUBMISSION_SECTION_DECISION_APPROVED:
			case SUBMISSION_SECTION_DECISION_RESUBMIT:
			case SUBMISSION_SECTION_DECISION_DECLINED:
				$proposalStatus = PROPOSAL_STATUS_REVIEWED;
				break;
			case SUBMISSION_SECTION_DECISION_INCOMPLETE:
				$proposalStatus = PROPOSAL_STATUS_RETURNED;
				break;
			default:
				$proposalStatus=PROPOSAL_STATUS_SUBMITTED;
				break;
		}
		return $proposalStatus;
	}


	/**
	 * Check if a reviewer is assigned to a specified decision.
	 * @param $decisionId int
	 * @param $reviewerId int
	 * @return boolean
	 */
	function reviewerExists($decisionId, $reviewerId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM review_assignments WHERE decision_id = ? AND reviewer_id = ? AND cancelled = 0', array((int) $decisionId, (int) $reviewerId)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}

        /*
	 * Get section decisions available for a committee meeting
	 * @param $sectionId int
	 */
	function getSectionDecisionsAvailableForMeeting($sectionId) {
            
            	$result =& $this->retrieve(
			sprintf('SELECT sd.*, a.public_id FROM section_decisions sd LEFT JOIN articles a ON (a.article_id = sd.article_id) WHERE sd.section_id = ? AND (sd.decision = ? OR decision = ?)'),
			array($sectionId, SUBMISSION_SECTION_DECISION_FULL_REVIEW, SUBMISSION_SECTION_DECISION_EXPEDITED)
		);
                
		$returner = new DAOResultFactory($result, $this, '_returnSectionDecisionFromRow');

                return $returner;
	}
        
        /**
	 * Get a map for review type  to locale key.
	 * @return array
	 */
	function getReviewTypeMap() {
                return $reviewTypeMap = array(
                        REVIEW_TYPE_INITIAL => Locale::translate('submission.initialReview'),
                        REVIEW_TYPE_PR => Locale::translate('submission.progressReport'),
                        REVIEW_TYPE_AMENDMENT => Locale::translate('submission.protocolAmendment'),
                        REVIEW_TYPE_SAE => Locale::translate('submission.seriousAdverseEvents'),
                        REVIEW_TYPE_FR => Locale::translate('submission.finalReport')
                );
	}
}

?>
