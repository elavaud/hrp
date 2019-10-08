<?php

/**
 * @file classes/submission/reviewer/ReviewerSubmission.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ReviewerSubmission
 * @ingroup submission
 * @see ReviewerSubmissionDAO
 *
 * @brief ReviewerSubmission class.
 */

// $Id$


import('classes.article.Article');

class ReviewerSubmission extends Article {

	/** @var array ArticleComments peer review comments of this article */
	var $peerReviewComments;

	/** @var array past decisions and assignments for this article and reviewer*/
	var $pastDecisionsAndAssignments;

	/** @var array undergoing decision and assignment for this article and reviewer*/
	var $undergoingDecisionAndAssignment;
        
	/** @var array section decisions that have at least one meeting*/
	var $meetingsDecisions;
        
	/**
	 * Constructor.
	 */
	function ReviewerSubmission() {
		parent::Article();
	}

	/**
	 * Get/Set Methods.
	 */

	/**
	 * Get the competing interests for this article.
	 * @return string
	 */
	function getCompetingInterests() {
		return $this->getData('competingInterests');
	}

	/**
	 * Set the competing interests statement.
	 * @param $competingInterests string
	 */
	function setCompetingInterests($competingInterests) {
		return $this->setData('competingInterests', $competingInterests);
	}

	/**
	 * Get ID of reviewer.
	 * @return int
	 */
	function getReviewerId() {
		return $this->getData('reviewerId');
	}

	/**
	 * Set ID of reviewer.
	 * @param $reviewerId int
	 */
	function setReviewerId($reviewerId) {
		return $this->setData('reviewerId', $reviewerId);
	}

	/**
	 * Get full name of reviewer.
	 * @return string
	 */
	function getReviewerFullName() {
		return $this->getData('reviewerFullName');
	}

	/**
	 * Set full name of reviewer.
	 * @param $reviewerFullName string
	 */
	function setReviewerFullName($reviewerFullName) {
		return $this->setData('reviewerFullName', $reviewerFullName);
	}

	/**
	 * prvate function for sorting decisions.
	 * @return array
	 */
	private function usortDecisions($a, $b){
                $aDecision = $a['decision'];
                $bDecision = $b['decision'];
                return $aDecision->getId() == $bDecision->getId() ? 0 : ( $aDecision->getId() > $bDecision->getId() ) ? 1 : -1;
   	}
        
	function getPastDecisionsAndAssignments() {
		$decisionsAndAssignments =& $this->pastDecisionsAndAssignments;
		usort($decisionsAndAssignments, array($this, "usortDecisions"));
		if ($decisionsAndAssignments) return $decisionsAndAssignments;
		else return null;
	}
        
        /**
	 * Get private function for sorting the decisions that have at least one meeting.
	 * @return array
	 */
	private function usortMeetingsDecisions($a, $b){
                return $a->getId() == $b->getId() ? 0 : ( $a->getId() > $b->getId() ) ? 1 : -1;
   	}
        
        function getMeetingsDecisions() {
		$decisions =& $this->meetingsDecisions;
		usort($decisions, array($this, "usortMeetingsDecisions"));
		if ($decisions) return $decisions;
		else return null;
	}
        
	/**
	 * Set comittee decisions for this research where the reviewer is concerned by a review assignment.
	 * @param $sectionDecisions array
	 */
	function setDecisionsAndAssignments($sectionDecisions) {
                $meetingsDecisions = array();
                $decisionsAndAssignments = array();
                $pastDecisionsAndAssignments = array();
                $undergoingDecisionAndAssignment = array();
                // Select only concerned decisions
                foreach($sectionDecisions as $skey => $sectionDecision){
                    $reviewAssignments = $sectionDecision->getReviewAssignments();
                    foreach ($reviewAssignments as $rkey => $reviewAssignment){
                        // Clean the decision of review assignments not addressed to the reviewer
                        if ($reviewAssignment->getReviewerId() == $this->getReviewerId()) {
                            array_push($decisionsAndAssignments, array('decision' => $sectionDecision, 'assignment' => $reviewAssignment));
                        }
                    }
                }
                // Separate the past ones and the undergoing one
                foreach($decisionsAndAssignments as $dakey => $decisionsAndAssignment) {
                    $sectionDecision = $decisionsAndAssignment['decision'];
                    $assignment = $decisionsAndAssignment['assignment'];
                    if ($sectionDecision->getDecision() != SUBMISSION_SECTION_DECISION_EXPEDITED && $sectionDecision->getDecision() != SUBMISSION_SECTION_DECISION_FULL_REVIEW) {
                        array_push($pastDecisionsAndAssignments, array('decision' => $sectionDecision, 'assignment' => $assignment));
                    } else {
                        // Refer to reviewerSubmissionDAO
                        if ($assignment->getReviewerId() != $this->getReviewerId() 
                                || $assignment->getDateCompleted() != '' 
                                || $assignment->getDeclined() == 1 
                                || $assignment->getCancelled() == 1) {
                            array_push($pastDecisionsAndAssignments, array('decision' => $sectionDecision, 'assignment' => $assignment));
                        } else {
                            $undergoingDecisionAndAssignment = array('decision' => $sectionDecision, 'assignment' => $assignment);
                        }
                    }
                    
                }
                // get the ones for meetings
                foreach ($sectionDecisions as $meetingsDecision) {
                    $meetings =& $meetingsDecision->getMeetings();
                    $foundDecision = false;
                    $concernedMeetings = array();
                    foreach ($meetings as $meeting) {
                        $foundMeeting = false;
                        $attendances =& $meeting->getMeetingAttendances();
                        foreach ($attendances as $attendance) {
                            if ($attendance->getUserId() == $this->getReviewerId() && !$foundMeeting) {
                                array_push($concernedMeetings, $meeting);
                                $foundDecision = true;
                                $foundMeeting = true;
                            }
                        }
                    }
                    if ($foundDecision) {
                        $meetingsDecision->setMeetings($concernedMeetings);
                        array_push($meetingsDecisions, $meetingsDecision);
                    }                    
                }
                $this->meetingsDecisions = $meetingsDecisions;
		$this->pastDecisionsAndAssignments = $pastDecisionsAndAssignments;
		$this->undergoingDecisionAndAssignment = $undergoingDecisionAndAssignment;
	}
        
	/**
	 * Get the undergoing committee decision.
	 * @return $sectionDecision SectionDecision
	 */
        function getUndergoingDecisionAndAssignment(){
		$decisionAndAssignment =& $this->undergoingDecisionAndAssignment;
                if (!empty($decisionAndAssignment)) {
                    return $decisionAndAssignment;
                } else {
                    return null;
                }
        }
        function getUndergoingDecision(){
            $uDA = $this->getUndergoingDecisionAndAssignment();
            if ($uDA) {
                return $uDA['decision'];
            } else {
                return null;
            }
        }
        function getUndergoingAssignment(){
            $uDA = $this->getUndergoingDecisionAndAssignment();
            if ($uDA) {
                return $uDA['assignment'];
            } else {
                return null;
            }            
        }
        
	/**
	 * Get the last section decision id for this article.
	 * @return Section Decision object
	 */
	function getLastSectionDecisionId() {
		$sectionDecisions =& $this->getDecisions();
		$sDecision =& $sectionDecisions[(count($sectionDecisions)-1)];
		if ($sDecision) return $sDecision->getId();
		else return null;
	}	

	/**
	 * Get review file id.
	 * @return int
	 */
	function getReviewFileId() {
		return $this->getData('reviewFileId');
	}

	/**
	 * Set review file id.
	 * @param $reviewFileId int
	 */
	function setReviewFileId($reviewFileId) {
		return $this->setData('reviewFileId', $reviewFileId);
	}

	//
	// Files
	//

	/**
	 * Get submission file for this article.
	 * @return ArticleFile
	 */
	function &getSubmissionFile() {
		$returner =& $this->getData('submissionFile');
		return $returner;
	}

	/**
	 * Set submission file for this article.
	 * @param $submissionFile ArticleFile
	 */
	function setSubmissionFile($submissionFile) {
		return $this->setData('submissionFile', $submissionFile);
	}

	/**
	 * Get revised file for this article.
	 * @return ArticleFile
	 */
	function &getRevisedFile() {
		$returner =& $this->getData('revisedFile');
		return $returner;
	}

	/**
	 * Set revised file for this article.
	 * @param $submissionFile ArticleFile
	 */
	function setRevisedFile($revisedFile) {
		return $this->setData('revisedFile', $revisedFile);
	}

	/**
	 * Get supplementary files for this article.
	 * @return array SuppFiles
	 */
	function &getSuppFiles() {
		$returner =& $this->getData('suppFiles');
		return $returner;
	}

	/**
	 * Set supplementary file for this article.
	 * @param $suppFiles array SuppFiles
	 */
	function setSuppFiles($suppFiles) {
		return $this->setData('suppFiles', $suppFiles);
	}
        
        /**
	 * Get report files for this article.
	 * @return array ReportFiles
	 */
	function &getReportFiles() {
		$returner =& $this->getData('reportFiles');
		return $returner;
	}

	/**
	 * Set report files for this article.
	 * @param $reportFiles array ReportFiles
	 */
	function setReportFiles($reportFiles) {
		return $this->setData('reportFiles', $reportFiles);
	}
        
	/**
	 * Get review file.
	 * @return ArticleFile
	 */
	function &getReviewFile() {
		$returner =& $this->getData('reviewFile');
		return $returner;
	}

	/**
	 * Set review file.
	 * @param $reviewFile ArticleFile
	 */
	function setReviewFile($reviewFile) {
		return $this->setData('reviewFile', $reviewFile);
	}

	/**
	 * Get reviewer file.
	 * @return ArticleFile
	 */
	function &getReviewerFile() {
		$returner =& $this->getData('reviewerFile');
		return $returner;
	}

	/**
	 * Set reviewer file.
	 * @param $reviewFile ArticleFile
	 */
	function setReviewerFile($reviewerFile) {
		return $this->setData('reviewerFile', $reviewerFile);
	}


        /**
	 * Get the submission status. Returns one of the defined constants
         * PROPOSAL_STATUS_DRAFT, PROPOSAL_STATUS_WITHDRAWN, PROPOSAL_STATUS_SUBMITTED,
         * PROPOSAL_STATUS_RETURNED, PROPOSAL_STATUS_REVIEWED, PROPOSAL_STATUS_EXEMPTED
         * Copied from SectionEditorSubmission::getSubmissionStatus
	 */
	function getSubmissionStatus() {
				
	    if ($this->getSubmissionProgress() && !$this->getDateSubmitted()) return PROPOSAL_STATUS_DRAFT;
	
	    //Withdrawn status is reflected in table articles field status
	    if($this->getStatus() == STATUS_WITHDRAWN) return PROPOSAL_STATUS_WITHDRAWN;
	
	    if($this->getStatus() == STATUS_REVIEWED) return PROPOSAL_STATUS_REVIEWED;
	    
	    //Archived status is reflected in table articles field status
	    if($this->getStatus() == STATUS_ARCHIVED) return PROPOSAL_STATUS_ARCHIVED;                               

	    if($this->getStatus() != STATUS_ARCHIVED && $this->getStatus() != STATUS_REVIEWED && $this->getStatus() != STATUS_WITHDRAWN && $this->getStatus() != STATUS_COMPLETED) {
	    	if ($this->getLastModified() > $this->getLastSectionDecisionDate()) {
	    		if ($this->getResubmitCount() > 0) return PROPOSAL_STATUS_RESUBMITTED;
	    		else return PROPOSAL_STATUS_SUBMITTED;
	    	}
	    }
	    	
	    $status = $this->getProposalStatus();
	    
	    if($status == PROPOSAL_STATUS_RETURNED) {
	        $articleDao = DAORegistry::getDAO('ArticleDAO');
	        $isResubmitted = $articleDao->isProposalResubmitted($this->getArticleId());
	
	        if($isResubmitted) return PROPOSAL_STATUS_RESUBMITTED;
	    }
	
	    //For all other statuses
	    return $status;
	}
                
        /**
	 * Get serious adverse event files for this article.
	 * @return array SAEFiles
	 */
	function &getSAEFiles() {
		$returner =& $this->getData('saeFiles');
		return $returner;
	}

	/**
	 * Set serious adverse event files for this article.
	 * @param $saeFiles array SAEFiles
	 */
	function setSAEFiles($saeFiles) {
		return $this->setData('saeFiles', $saeFiles);
	} 
}

?>
