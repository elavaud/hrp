<?php

/**
 * @file SubmissionReviewHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SubmissionReviewHandler
 * @ingroup pages_reviewer
 *
 * @brief Handle requests for submission tracking. 
 */

// $Id$

import('pages.reviewer.ReviewerHandler');

class SubmissionReviewHandler extends ReviewerHandler {
	/** submission associated with the request **/
	var $submission;
	
	/** user associated with the request **/
	var $user;
		
	/**
	 * Constructor
	 **/
	function SubmissionReviewHandler() {
		parent::ReviewerHandler();
	}

	/**
	 * Display the submission review page.
	 * @param $args array
	 */
	function submission($args) {
		$journal =& Request::getJournal();
		$articleId = $args[0];
		$page = isset($args[1]) ? $args[1] : 'submissionReview';

                $this->validate($articleId);
		$user =& $this->user;
		$submission =& $this->submission;

		$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
                $currencyDao =& DAORegistry::getDAO('CurrencyDAO');
		$articleFileDao =& DAORegistry::getDao('ArticleFileDAO');
		$meetingSectionDecisionDao =& DAORegistry::getDAO('MeetingSectionDecisionDAO');

                $this->setupTemplate(false, 0, $submission->getArticleId());
		$templateMgr =& TemplateManager::getManager();

                // Get the decisions concerned by a meeting but where the user has not been assigned to review. Only to attend the meeting (array will be cleaned after in this function)
		$meetingDecisions =& $meetingSectionDecisionDao->getUserMeetingSectionDecisions($articleId, $user->getId());

                $undergoingDecisionAndAssignment = $submission->getUndergoingDecisionAndAssignment();
                if ($undergoingDecisionAndAssignment){
                    $templateMgr->assign('undergoing', '1');
                    $templateMgr->assign_by_ref('undergoingDecision', $undergoingDecisionAndAssignment['decision']);
                    $templateMgr->assign_by_ref('undergoingAssignment', $undergoingDecisionAndAssignment['assignment']);
                    if ($undergoingDecisionAndAssignment['assignment']->getDateConfirmed() == null) {
                            $confirmedStatus = 0;
                    } else {
                            $confirmedStatus = 1;
                    }         
                    $templateMgr->assign('confirmedStatus', $confirmedStatus);
                    $templateMgr->assign('declined', $undergoingDecisionAndAssignment['assignment']->getDeclined());
                    $templateMgr->assign('reviewFormResponseExists', $reviewFormResponseDao->reviewFormResponseExists($undergoingDecisionAndAssignment['assignment']->getReviewId()));
                    foreach ($meetingDecisions as $mdkey => $meetingDecision) {
                        if ($undergoingDecisionAndAssignment['decision']->getId() == $meetingDecision->getId()) {
                            unset($meetingDecisions[$mdkey]);
                        }                            
                    }
                } else {
                    $templateMgr->assign('undergoing', '0');
                }
                
                $pastDecisionsAndAssignments =& $submission->getPastDecisionsAndAssignments();
                if ($pastDecisionsAndAssignments) {
                    $templateMgr->assign('past', '1');
                    $templateMgr->assign_by_ref('pastDecisionsAndAssignments', $pastDecisionsAndAssignments);
                    foreach ($pastDecisionsAndAssignments as $pastDecisionAndAssignment) {
                        $pastDecision =& $pastDecisionAndAssignment['decision'];
                        foreach ($meetingDecisions as $mdkey => $meetingDecision) {
                            if ($pastDecision->getId() == $meetingDecision->getId()) {
                                unset($meetingDecisions[$mdkey]);
                            }                            
                        }
                    }
                } else {
                    $templateMgr->assign('past', '0');
                }
                
                if(!empty($meetingDecisions)){
                    $templateMgr->assign('otherDecisionsExist', true);
                    $templateMgr->assign_by_ref('otherDecisions', $meetingDecisions);
                } else {
                    $templateMgr->assign('otherDecisionsExist', false);
                }
                
		$templateMgr->assign_by_ref('user', $user);
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('reviewFile', $submission->getSubmissionFile());
		$templateMgr->assign_by_ref('reviewerFile', $submission->getReviewerFile());
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());
		$templateMgr->assign_by_ref('reportFiles', $submission->getReportFiles());
		$templateMgr->assign_by_ref('saeFiles', $submission->getSAEFiles());
		$templateMgr->assign_by_ref('previousFiles', $articleFileDao->getPreviousFilesByArticleId($submission->getId()));
                $templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
		$templateMgr->assign_by_ref('journal', $journal);
		$templateMgr->assign_by_ref('reviewGuidelines', $journal->getLocalizedSetting('reviewGuidelines'));
                
		import('classes.submission.reviewAssignment.ReviewAssignment');
		$templateMgr->assign_by_ref('reviewerRecommendationOptions', ReviewAssignment::getReviewerRecommendationOptions());
                $templateMgr->assign_by_ref('abstractLocales', $journal->getSupportedLocaleNames());
		$templateMgr->assign('helpTopicId', 'editorial.reviewersRole.review');

                $sourceCurrencyId = $journal->getSetting('sourceCurrency');
                $templateMgr->assign('sourceCurrency', $currencyDao->getCurrencyByAlphaCode($sourceCurrencyId));                
                
                $templateMgr->assign('pageToDisplay', $page);
                
		$templateMgr->display('reviewer/submission.tpl');
	}

	
	/**
	 * Confirm whether the review has been accepted or not.
	 * @param $args array optional
	 */
	function confirmReview($args = null) {
		$reviewId = Request::getUserVar('reviewId');
		$declineReview = Request::getUserVar('declineReview');

		$this->validateAction($reviewId);
		$reviewerSubmission =& $this->submission;

                $reviewAssignmentDao =& DAORegistry::getDao('ReviewAssignmentDAO');
                $assignment =& $reviewAssignmentDao->getReviewAssignmentById($reviewId);
                
		$this->setupTemplate();

		$decline = isset($declineReview) ? 1 : 0;

		if (!$assignment->getCancelled()) {
			if (ReviewerAction::confirmReview($assignment, $decline, Request::getUserVar('send'))) {
                            Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
			}
		} else {
                    Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
		}
	}

	/**
	 * Save the competing interests statement, if allowed.
	 */
	function saveCompetingInterests() {
		$reviewId = Request::getUserVar('reviewId');
		$this->validateAction($reviewId);
		$reviewerSubmission =& $this->submission;

                $reviewAssignmentDao =& DAORegistry::getDao('ReviewAssignmentDAO');
                $assignment =& $reviewAssignmentDao->getReviewAssignmentById($reviewId);
                
		if ($assignment->getDateConfirmed() && !$assignment->getDeclined() && !$assignment->getCancelled() && !$assignment->getRecommendation()) {
			$assignment->setCompetingInterests(Request::getUserVar('competingInterests'));
			$reviewAssignmentDao->updateReviewAssignment($assignment);
		}

                Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
	}

	/**
	 * Record the reviewer recommendation.
	 */
	function recordRecommendation() {
		$reviewId = Request::getUserVar('reviewId');
		$recommendation = Request::getUserVar('recommendation');

		$this->validateAction($reviewId);
		$reviewerSubmission =& $this->submission;

                $reviewAssignmentDao =& DAORegistry::getDao('ReviewAssignmentDAO');
                $assignment =& $reviewAssignmentDao->getReviewAssignmentById($reviewId);

		$this->setupTemplate();

		if (!$assignment->getCancelled()) {
			if (ReviewerAction::recordRecommendation($assignment, $recommendation, Request::getUserVar('send'))) {
				Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
			}
		} else {
			Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
		}
	}

	/**
	 * View the submission metadata
	 * @param $args array
	 */
	function viewMetadata($args, $request) {
		$reviewId = (int) array_shift($args);
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($reviewId);
		$reviewerSubmission =& $this->submission;

		$this->setupTemplate(false, 0, $articleId);
		
		ReviewerAction::viewMetadata($reviewerSubmission, $journal);
	}

	/**
	 * Upload the reviewer's annotated version of an article.
	 */
	function uploadReviewerVersion() {
		$reviewId = Request::getUserVar('reviewId');

		$this->validateAction($reviewId);
		$this->setupTemplate();
		$reviewerSubmission =& $this->submission;

                ReviewerAction::uploadReviewerVersion($reviewId);
		Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
	}

	/*
	 * Delete one of the reviewer's annotated versions of an article.
	 */
	function deleteReviewerVersion($args) {		
		$reviewId = isset($args[0]) ? (int) $args[0] : 0;
		$fileId = isset($args[1]) ? (int) $args[1] : 0;
		$articleId = isset($args[2]) ? (int) $args[2] : 0;

		$this->validateAction($reviewId);
		$reviewerSubmission =& $this->submission;
                $reviewAssignmentDao =& DAORegistry::getDao('ReviewAssignmentDAO');
                $assignment =& $reviewAssignmentDao->getReviewAssignmentById($reviewId);
                
		if (!$assignment->getCancelled()) ReviewerAction::deleteReviewerVersion($reviewId, $fileId, $articleId);
		Request::redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
	}

	//
	// Misc
	//

	/**
	 * Download a file.
	 * @param $args array ($articleId, $fileId)
	 */
	function downloadFile($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;
		$reviewId = isset($args[2]) ? $args[2] : null;

		$this->validate($articleId);

		$reviewerSubmission =& $this->submission;

		if (!ReviewerAction::downloadReviewerFile($reviewerSubmission, $fileId, $reviewId)) {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}
	
	//
	// Review Form
	//

	/**
	 * Edit or preview review form response.
	 * @param $args array
	 */
	function editReviewFormResponse($args) {
		$reviewId = isset($args[0]) ? $args[0] : 0;
		
		$this->validateAction($reviewId);

		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$reviewFormId = $reviewAssignment->getReviewFormId();
		if ($reviewFormId != null) {
			ReviewerAction::editReviewFormResponse($reviewId, $reviewFormId);
		}
	}

	/**
	 * Save review form response
	 * @param $args array
	 */
	function saveReviewFormResponse($args, $request) {
		$reviewId = (int) array_shift($args);
		$reviewFormId = (int) array_shift($args);
		$this->validateAction($reviewId);

                $reviewerSubmission =& $this->submission;

		// For form errors (#6562)
		Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
                
		if (ReviewerAction::saveReviewFormResponse($reviewId, $reviewFormId)) {
			$request->redirect(null, null, 'submission', $reviewerSubmission->getArticleId());
		}
	}

	//
	// Validation
	//

	/**
	 * Validate that the user is an assigned reviewer for
	 * the article and that the assignment is still undergoing.
	 * Redirects to reviewer index page if validation fails.
	 */
	function validateAction($reviewId) {
		$reviewerSubmissionDao =& DAORegistry::getDAO('ReviewerSubmissionDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$isValid = true;
		$newKey = Request::getUserVar('key');

		$reviewerSubmission =& $reviewerSubmissionDao->getReviewerSubmission($reviewId);
		
		if (!$reviewerSubmission) {
			$isValid = false;
		} elseif ($user && empty($newKey)) {
			if ($reviewerSubmission->getReviewerId() != $user->getId()) {
				$isValid = false;
			}
		} else {
			$user =& SubmissionReviewHandler::validateAccessKey($reviewerSubmission->getReviewerId(), $reviewId, $newKey);
                        if (!$user) {
                            $isValid = false;
                        }
                        $undergoingDecisionAndAssignment = $reviewerSubmission->getUndergoingDecisionAndAssignment();
                        if (empty($undergoingDecisionAndAssignment)) {
                            $isValid = false;
                        }
		}
		
		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}
		
		$this->submission =& $reviewerSubmission;
		$this->user =& $user;
		return true;
	}
        
        /**
	 * Validate that the user has been assigned at least once for a review in this article.
	 * Redirects to reviewer index page if validation fails.
	 */
	function validate($articleId) {
		$reviewerSubmissionDao =& DAORegistry::getDAO('ReviewerSubmissionDAO');
		$user =& Request::getUser();

		$isValid = true;
		$newKey = Request::getUserVar('key');

		$reviewerSubmission =& $reviewerSubmissionDao->getReviewerSubmissionByArticleAndReviewerId($articleId, $user->getId());
		
		if (!$reviewerSubmission) {
			$isValid = false;
		} elseif ($user && empty($newKey)) {
			if ($reviewerSubmission->getReviewerId() != $user->getId()) {
				$isValid = false;
			}
		} else {
                        $decisionsAndAssignments = $reviewerSubmission->getPastDecisionsAndAssignments();
                        $undergoingDecisionAndAssignment = $reviewerSubmission->getUndergoingDecisionAndAssignment();
                        $user = null;
                        foreach ($decisionsAndAssignments as $decisionsAndAssignment) {
                            if(!$user) {
                                $assignment = $decisionsAndAssignment['assignment'];
                                $user =& SubmissionReviewHandler::validateAccessKey($reviewerSubmission->getReviewerId(), $assignment->getReviewId(), $newKey);                                
                            }
                        }
                        if (!$user) {
                            $assignment = $undergoingDecisionAndAssignment['assignment'];
                            $user =& SubmissionReviewHandler::validateAccessKey($reviewerSubmission->getReviewerId(), $assignment->getReviewId(), $newKey);                                
                        }
                        if (!$user) {
                            $isValid = false;
                        }                        
		}
		
		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}
		
		$this->submission =& $reviewerSubmission;
		$this->user =& $user;
		return true;
	}

}
?>
