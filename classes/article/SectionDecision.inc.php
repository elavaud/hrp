<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/SectionDecision.inc.php
 *
 *
 * @brief section decision class.
 * Added by EL on April 2013
 */

// Review type - If modified, should modify to Action.inc.php
define('REVIEW_TYPE_INITIAL', 1); 	// Initial Review
define('REVIEW_TYPE_PR', 2);	// Progress report
define('REVIEW_TYPE_AMENDMENT', 3);	// Post-Approval Amendment
define('REVIEW_TYPE_SAE', 4);	// Serious Adverse Event(s)
define('REVIEW_TYPE_FR', 5);	// End of study


// Reasons for exemption constants

define ('EXEMPTION_NO_HUMAN_PARTICIPANTS', 1);
define ('EXEMPTION_ALREADY_EXISTS', 2);
define ('EXEMPTION_PUBLIC_OFFICIALS', 4);
define ('EXEMPTION_LIMITED_OBSERVATION', 8);
define ('EXEMPTION_LIMITED_SURVEILLANCE', 16);
define ('EXEMPTION_REGISTERED', 32);


class SectionDecision extends DataObject {

	var $reviewAssignments;
	
	var $removedReviewAssignments;

	/**
	 * Constructor.
	 */
	function SectionDecision() {
		parent::DataObject();
		$this->reviewAssignments = array();
		$this->removedReviewAssignments = array();
	}

	/**
	 * Get section decision id.
	 * @return int
	 */
	function getId() {
		return $this->getData('sectionDecisionId');
	}

	/**
	 * Set section decision id.
	 * @param $articleId int
	 */
	function setId($sectionDecisionId) {
		return $this->setData('sectionDecisionId', $sectionDecisionId);
	}
	
	/**
	 * Get article id.
	 * @return int
	 */
	function getArticleId() {
		return $this->getData('articleId');
	}

	/**
	 * Set article id.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		return $this->setData('articleId', $articleId);
	}

	/**
	 * Get review type.
	 * @return int
	 */
	function getReviewType() {
		return $this->getData('reviewType');
	}

	/**
	 * Set review type.
	 * @param $reviewType int
	 */
	function setReviewType($reviewType) {
		return $this->setData('reviewType', $reviewType);
	}

	/**
	 * Get round.
	 * @return int
	 */
	function getRound() {
		return $this->getData('round');
	}

	/**
	 * Set round.
	 * @param $round int
	 */
	function setRound($round) {
		return $this->setData('round', $round);
	}

	/**
	 * Get section id.
	 * @return int
	 */
	function getSectionId() {
		return $this->getData('sectionId');
	}

	/**
	 * Set section id.
	 * @param $sectionId int
	 */
	function setSectionId($sectionId) {
		return $this->setData('sectionId', $sectionId);
	}

	/**
	 * Get decision.
	 * @return int
	 */
	function getDecision() {
		return $this->getData('decision');
	}

	/**
	 * Set comments.
	 * @param $comments text
	 */
	function setComments($comments) {
		return $this->setData('comments', $comments);
	}

        /**
	 * Get comments.
	 * @return text
	 */
	function getComments() {
		return $this->getData('comments');
	}

	/**
	 * Set decision.
	 * @param $decision int
	 */
	function setDecision($decision) {
		return $this->setData('decision', $decision);
	}

	/**
	 * Get date decided.
	 * @return date
	 */
	function getDateDecided() {
		return $this->getData('dateDecided');
	}

	/**
	 * Set date decided.
	 * @param $dateDecided date
	 */
	function setDateDecided($dateDecided) {
		return $this->setData('dateDecided', $dateDecided);
	}

	/**
	 * Get review assignments for this decision.
	 * @return array ReviewAssignments
	 */
	function &getReviewAssignments() {
		return $this->reviewAssignments;
	}

	/**
	 * Set review assignments for this article.
	 * @param $reviewAssignments array ReviewAssignments
	 */
	function setReviewAssignments($reviewAssignments) {
		return $this->reviewAssignments = $reviewAssignments;
	}

	/**
	 * Get author viewable review files for this decision.
	 * @return array ReviewAssignments
	 */
	function getAuthorViewableReviewFiles() {
		return $this->getData('authorViewableReviewFiles');
	}

	/**
	 * Set author viewable review files for this decision.
	 * @param $reviewAssignments array ReviewAssignments
	 */
	function setAuthorViewableReviewFiles($authorViewableReviewFiles) {
		return $this->setData('authorViewableReviewFiles', $authorViewableReviewFiles);
	}

	/**
	 * Get decision file.
	 * @return array ReviewAssignments
	 */
	function getDecisionFiles() {
		return $this->getData('decisionFiles');
	}

	/**
	 * Set decision file.
	 * @param $reviewAssignments array ReviewAssignments
	 */
	function setDecisionFiles($decisionFiles) {
		return $this->setData('decisionFiles', $decisionFiles);
	}

	/**
	 * Add a review assignment decision.
	 * @param $reviewAssignment ReviewAssignment
	 */
	function addReviewAssignment($reviewAssignment) {
		if ($reviewAssignment->getDecisionId() == null) {
			$reviewAssignment->setDecisionId($this->getId());
		}

		if (isset($this->reviewAssignments)) {
			$reviewAssignments = $this->reviewAssignments;
		} else {
			$reviewAssignments = Array();
		}
		array_push($reviewAssignments, $reviewAssignment);

		return $this->reviewAssignments = $reviewAssignments;
	}
	
	function removeReviewAssignment($reviewId) {
		$reviewId = (int) $reviewId;

		foreach ($this->reviewAssignments as $key => $assignment) {
			if ($assignment->getReviewId() == $reviewId) {
				$this->removedReviewAssignments[] = $reviewId;
				unset($this->reviewAssignments[$key]);
				return true;
			}
		}
		return false;
	}

	/**
	 * Get the number of resubmission
	 * @return int
	*/
	function getResubmitCount(){
		$sectionDecisionDao = DAORegistry::getDAO('SectionDecisionDAO');
		return $sectionDecisionDao->getResubmitCount($this->getDateDecided(), $this->getArticleId(), $this->getReviewType(), $this->getRound());
	}
	
	/**
	 * Set the public proposal ID of the article concerned by the decision
	 * @return string
	 */
	function setProposalId($proposalId){
		return $this->setData('proposalId', $proposalId);
	}
        
        /**
	 * Get the public proposal ID of the article concerned by the decision
	 * @return int
	 */
	function getProposalId(){
		return $this->getData('proposalId');
	}
        
	/**
	 * Get a map for review type  to locale key.
	 * @return array
	 */
	function getReviewTypeMap() {
                return $reviewTypeMap = array(
                        REVIEW_TYPE_INITIAL => 'submission.initialReview',
                        REVIEW_TYPE_PR => 'submission.progressReport',
                        REVIEW_TYPE_AMENDMENT => 'submission.protocolAmendment',
                        REVIEW_TYPE_SAE => 'submission.seriousAdverseEvents',
                        REVIEW_TYPE_FR => 'submission.finalReport'
                );
	}
	
	/**
	 * Get a locale key for the review type
	 */
	function getReviewTypeKey() {
		$reviewTypeMap =& $this->getReviewTypeMap();
		return $reviewTypeMap[$this->getReviewType()];
	}

        /**
	 * Get a map for review status constant to locale key.
	 * @return array
	 */
	function &getReviewStatusMap() {
                $reviewStatusMap = array(
                        SUBMISSION_SECTION_NO_DECISION => 'submission.status.submitted',
                        SUBMISSION_SECTION_DECISION_INCOMPLETE => 'submission.status.incomplete',
                        SUBMISSION_SECTION_DECISION_COMPLETE => 'submission.status.complete',
                        SUBMISSION_SECTION_DECISION_EXEMPTED => 'submission.status.exempted',
                        SUBMISSION_SECTION_DECISION_FULL_REVIEW => 'submission.status.fullReview',
                        SUBMISSION_SECTION_DECISION_EXPEDITED => 'submission.status.expeditedReview',
                        SUBMISSION_SECTION_DECISION_APPROVED => 'submission.status.approved',
                        SUBMISSION_SECTION_DECISION_RESUBMIT => 'submission.status.reviseAndResubmit',
                        SUBMISSION_SECTION_DECISION_DECLINED => 'submission.status.declined'
                );
		return $reviewStatusMap;
	}

        /**
	 * Get a locale key for the submission review status
	 */
	function getReviewStatusKey() {
		$reviewStatus = $this->getDecision();
		$reviewStatusMap =& $this->getReviewStatusMap();
		return $reviewStatusMap[$reviewStatus];
	}


        /**
	 * Get the section concerned by this decision
	 */
	function getSection() {
		$sectionDao = DAORegistry::getDAO('SectionDAO');
		return $sectionDao->getSection($this->getSectionId());
	}
   
        /**
	 * Get the section acronym concerned by this decision
	 */
	function getSectionAcronym() {
		$section = $this->getSection();
		return $section->getLocalizedAbbrev();
	}

        /**
	 * check if the user is the secretary of the committee concerned by this decision
	 * @param $userId
	 */
	function isSecretary($userId) {
		$sectionEditorsDao = DAORegistry::getDAO('SectionEditorsDAO');
		return $sectionEditorsDao->ercSecretaryExists($this->getSectionId(), $userId);
	}
        
        /**
	 * Get array mapping of selected reasons for exemption
	 * @return array
	 */
	function getProposalReasonsForExemption() {
		$comments = $this->getComments();
		$reasons = array();
		for($i=5; $i>=0; $i--) {
			$num = pow(2, $i);
			if($num <= $comments) {
				$reasons[$num] = 1;
				$comments = $comments - $num;
			}
			else
				$reasons[$num] = 0;			
		}
		return $reasons;
	}
	
	/*
	 * Get a map for exemption reasons to locale key
	 * @return array
	 */	 
	function &getReasonsForExemptionMap() {
		static $reasonsForExemptionMap;
		if (!isset($reasonsForExemptionMap)) {
			$reasonsForExemptionMap = array(
				EXEMPTION_NO_HUMAN_PARTICIPANTS => 'editor.article.exemption.noHumanParticipants',
				EXEMPTION_ALREADY_EXISTS => 'editor.article.exemption.alreadyExists',
				EXEMPTION_PUBLIC_OFFICIALS => 'editor.article.exemption.publicOfficials',
				EXEMPTION_LIMITED_OBSERVATION => 'editor.article.exemption.limitedObservation',
				EXEMPTION_LIMITED_SURVEILLANCE => 'editor.article.exemption.limitedPublicHealthSurveillance',
				EXEMPTION_REGISTERED => 'editor.article.exemption.registered'			
			);
		}
		return $reasonsForExemptionMap;
	}  


        /*
	 * Return an array of the reviewAssignments where the reviewer at least answered a form or uploaded a file
	 * @return int
	 */	 
	function &getReviewAssignmentsDone() {
            $reviewAssignmentsDone = array();
            $reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
            foreach ($this->reviewAssignments as $reviewAssignment){
                if (($reviewFormResponseDao->reviewFormResponseExists($reviewAssignment->getId())) || $reviewAssignment->getReviewerFile()) 
                        $reviewAssignmentsDone[] = $reviewAssignment;
            }
            return $reviewAssignmentsDone;
	}  

        /*
         * Get localized proposal title
	 */	 
	function &getLocalizedProposalTitle() {
            $abstractDao =& DAORegistry::getDAO('ProposalAbstractDAO');
            $locale = Locale::getLocale();
            $abstracts = $abstractDao->getAbstractsByArticle($this->getArticleId());
            $abstract = $abstracts[$locale];
            $scientificTitle = $abstract->getScientificTitle();
            return $scientificTitle;
	}
        
        /*
         * Get localized proposal title
	 */	 
	function &getAuthorString() {
            $authorDao =& DAORegistry::getDAO('AuthorDAO');
            $authors = $authorDao->getAuthorsByArticle($this->getArticleId());
            $authorString = '-';
            foreach ($authors as $author) {
                if ($author->getPrimaryContact()){
                    $authorString = $author->getFullName();
                }
            }
            return $authorString;
	}

        
	/**
	 * Set all meetings related to this decision.
	 * @param $dateDecided date
	 */
	function setMeetings($meetings) {
		return $this->setData('meetings', $meetings);
	}

	/**
	 * Get all meetings for this decision.
	 * @return array ReviewAssignments
	 */
	function &getMeetings() {
		return $this->getData('meetings');
	}

	/**
	 * Get all meetings for this decision, where the investigator has been invited.
	 * @return array ReviewAssignments
	 */
	function &getInvestigatorMeetings() {
		$meetings = $this->getData('meetings');
                $investigatorMeetings = array();
                foreach($meetings as $meeting){
                    if ($meeting->getInvestigator() == 1){
                        array_push($investigatorMeetings, $meeting);
                    }
                }
                return $investigatorMeetings;
	}
}
?>
