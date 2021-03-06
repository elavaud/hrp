<?php

/**
 * @file classes/submission/sectionEditor/SectionEditorAction.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SectionEditorAction
 * @ingroup submission
 *
 * @brief SectionEditorAction class.
 */

// $Id$


import('classes.submission.common.Action');

class SectionEditorAction extends Action {

	/**
	 * Constructor.
	 */
	function SectionEditorAction() {
		parent::Action();
	}

	/**
	 * Records an editor's submission decision. (Modified: Update if there is already an existing decision.)
	 * @param $sectionEditorSubmission object
	 * @param $decision int
	 * @param $lastDecisionId int (Added)
	 */
	function recordDecision($sectionEditorSubmission, $decision, $reviewType, $round, $comments = null, $dateDecided = null, $lastDecisionId = null) {

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$user =& Request::getUser();
		$journal =& Request::getJournal();

		$currentDate = date(Core::getCurrentDate());
		$approvalDate = (($dateDecided == null) ? $currentDate : date($dateDecided));

		// Create the section decision
		import('classes.article.SectionDecision');
		$sectionDecision = new SectionDecision();
		if ($lastDecisionId) $sectionDecision->setId($lastDecisionId);
		$sectionDecision->setArticleId($sectionEditorSubmission->getArticleId());
		$sectionDecision->setDecision($decision);
		$sectionDecision->setReviewType($reviewType);
		$sectionDecision->setRound($round);
		$sectionDecision->setSectionId($user->getSecretaryCommitteeId());
		$sectionDecision->setComments($comments);
                $sectionDecision->setDateDecided($approvalDate);

		if (!HookRegistry::call('SectionEditorAction::recordDecision', array($sectionEditorSubmission, $decision, $reviewType, $round, $dateDecided, $lastDecisionId))) {
			
                        if ($reviewType == REVIEW_TYPE_FR && ($decision == SUBMISSION_SECTION_DECISION_APPROVED || ($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && $sectionDecision->getComments()))){
                            if(!SectionEditorAction::_publishResearch($sectionEditorSubmission)){
				Request::redirect(null, null, 'submissionReview', $sectionEditorSubmission->getArticleId());
                            }
                        }
                        
                        if ($reviewType == REVIEW_TYPE_FR && ($decision == SUBMISSION_SECTION_DECISION_APPROVED || ($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && $sectionDecision->getComments()))) {
				$sectionEditorSubmission->setStatus(STATUS_COMPLETED);
                        } elseif (($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && $sectionDecision->getComments())
				|| $decision == SUBMISSION_SECTION_DECISION_APPROVED 
				|| $decision == SUBMISSION_SECTION_DECISION_DONE 
				|| $decision == SUBMISSION_SECTION_DECISION_INCOMPLETE
				|| $decision == SUBMISSION_SECTION_DECISION_RESUBMIT
                        ) {
				$sectionEditorSubmission->setStatus(STATUS_REVIEWED);
                        } elseif ($decision == SUBMISSION_SECTION_DECISION_DECLINED) { 
				$sectionEditorSubmission->setStatus(STATUS_ARCHIVED);
                        }

			$sectionEditorSubmission->stampStatusModified();
			$sectionEditorSubmission->addDecision($sectionDecision);
			$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);
			
                        // Send a notification to the user
                        import('lib.pkp.classes.notification.NotificationManager');
                        $notificationManager = new NotificationManager();
                        $url = Request::url($journal->getPath(), 'author', 'submissionReview', array($sectionEditorSubmission->getArticleId()));
                        
                        switch ($decision) {
                            case SUBMISSION_SECTION_DECISION_COMPLETE:
                                $message = 'notification.type.submissionComplete';
                                break;
                            case SUBMISSION_SECTION_DECISION_INCOMPLETE:
                                $message = 'notification.type.submissionIncomplete';
                                break;
                            case SUBMISSION_SECTION_DECISION_EXPEDITED:
                                $message = 'notification.type.submissionExpedited';
                                break;
                            case SUBMISSION_SECTION_DECISION_FULL_REVIEW:
                                $message = 'notification.type.submissionAssigned';
                                break;
                            case SUBMISSION_SECTION_DECISION_EXEMPTED:
                                $message = 'notification.type.submissionExempted';
                                break;
                            case SUBMISSION_SECTION_DECISION_DECLINED:
                                $message = 'notification.type.submissionDecline';
                                break;
                            case SUBMISSION_SECTION_DECISION_APPROVED:
                                $message = 'notification.type.submissionAccept';
                                break;
                            case SUBMISSION_SECTION_DECISION_DONE:
                                $message = 'notification.type.submissionDone';
                                break;
                            case SUBMISSION_SECTION_DECISION_RESUBMIT:
                                $message = 'notification.type.reviseAndResubmit';
                                break;                            
                        }
                        
                        switch ($reviewType) {
                            case REVIEW_TYPE_PR:
                                $message = $message.'.continuingReview';
                                break;
                            case REVIEW_TYPE_AMENDMENT:
                                $message = $message.'.amendment';
                                break;
                            case REVIEW_TYPE_SAE:
                                $message = $message.'.sae';
                                break;
                            case REVIEW_TYPE_FR:
                                $message = $message.'.eos';
                                break;                            
                        }
                        
                        $notificationManager->createNotification(
                            $sectionEditorSubmission->getUserId(), $message,
                            $sectionEditorSubmission->getProposalId(), $url, 1, NOTIFICATION_TYPE_SECTION_DECISION_COMMENT
                        ); 

                        
			$decisions = SectionEditorSubmission::getAllPossibleEditorDecisionOptions();
			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_SUBMISSION));
			ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_SECTION_DECISION, ARTICLE_LOG_TYPE_EDITOR, $user->getId(), 'log.editor.decision', array('editorName' => $user->getFullName(), 'proposalId' => $sectionEditorSubmission->getProposalId(), 'decision' => Locale::translate($sectionDecision->getReviewTypeKey()).' - '.$sectionDecision->getRound().': '.Locale::translate($decisions[$decision])));
		}
	}

	/**
	 * Assigns a reviewer to a submission.
	 * @param $sectionEditorSubmission object
	 * @param $reviewerId int
	 */
	function addReviewer($lastSectionDecisionId, $reviewerId) {
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$user =& Request::getUser();

		$reviewer =& $userDao->getUser($reviewerId);

		// Check to see if the requested reviewer is not already
		// assigned to review this article.
		$lastSectionDecision =& $sectionDecisionDao->getSectionDecision($lastSectionDecisionId);
		
		$assigned = $sectionDecisionDao->reviewerExists($lastSectionDecision->getId(), $reviewerId);

		// Only add the reviewer if he has not already
		// been assigned to review this article.
		if (!$assigned && isset($reviewer) && !HookRegistry::call('SectionEditorAction::addReviewer', array(&$lastSectionDecision, $reviewerId))) {
			$reviewAssignment = new ReviewAssignment();
			$reviewAssignment->setReviewerId($reviewerId);
			$reviewAssignment->setDateAssigned(Core::getCurrentDate());

			// Assign review form automatically if needed
			$journal =& Request::getJournal();
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$reviewFormDao =& DAORegistry::getDAO('ReviewFormDAO');

			$sectionId = $lastSectionDecision->getSectionId();
			$section =& $sectionDao->getSection($sectionId, $journal->getId());
			if ($section && ($reviewFormId = (int) $section->getReviewFormId())) {
				if ($reviewFormDao->reviewFormExists($reviewFormId, ASSOC_TYPE_JOURNAL, $journal->getId())) {
					$reviewAssignment->setReviewFormId($reviewFormId);
				}
			}

			$lastSectionDecision->addReviewAssignment($reviewAssignment);
			$sectionDecisionDao->updateSectionDecision($lastSectionDecision);

			$reviewAssignment = $reviewAssignmentDao->getReviewAssignment($lastSectionDecision->getId(), $reviewerId);

			$settingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
			$settings =& $settingsDao->getJournalSettings($journal->getId());
			if (isset($settings['numWeeksPerReview'])) {
				SectionEditorAction::setDueDate($lastSectionDecision->getArticleId(), $reviewAssignment->getId(), null, $settings['numWeeksPerReview'], false);
			}

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($lastSectionDecision->getArticleId(), ARTICLE_LOG_REVIEW_ASSIGN, ARTICLE_LOG_TYPE_REVIEW, $reviewAssignment->getId(), 'log.review.reviewerAssigned', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $lastSectionDecision->getProposalId()));
		}
	}

	/**
	 * Clears a review assignment from a submission.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 */
	function clearReview($lastSectionDecision, $reviewId) {
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$user =& Request::getUser();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);

		if (isset($reviewAssignment) && $reviewAssignment->getDecisionId() == $lastSectionDecision->getId() && !HookRegistry::call('SectionEditorAction::clearReview', array(&$lastSectionDecision, $reviewAssignment))) {
			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
			if (!isset($reviewer)) return false;
			$lastSectionDecision->removeReviewAssignment($reviewId);
			$sectionDecisionDao->updateSectionDecision($lastSectionDecision);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($lastSectionDecision->getArticleId(), ARTICLE_LOG_REVIEW_CLEAR, ARTICLE_LOG_TYPE_REVIEW, $reviewAssignment->getId(), 'log.review.reviewCleared', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $lastSectionDecision->getProposalId()));
		}
	}

	/**
	 * Notifies a reviewer about a review assignment.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 * @return boolean true iff ready for redirect
	 */
	function notifyReviewer($sectionEditorSubmission, $reviewId, $incrementNumber = 0, $send = false) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);


		$isEmailBasedReview = $journal->getSetting('mailSubmissionsToReviewers')==1?true:false;
		$reviewerAccessKeysEnabled = $journal->getSetting('reviewerAccessKeysEnabled');

		// If we're using access keys, disable the address fields
		// for this message. (Prevents security issue: section editor
		// could CC or BCC someone else, or change the reviewer address,
		// in order to get the access key.)
		$preventAddressChanges = $reviewerAccessKeysEnabled;

		import('classes.mail.ArticleMailTemplate');

		$email = new ArticleMailTemplate($sectionEditorSubmission, null, $isEmailBasedReview?'REVIEW_REQUEST_ATTACHED':($reviewerAccessKeysEnabled?'REVIEW_REQUEST_ONECLICK':'REVIEW_REQUEST'), null, $isEmailBasedReview?true:null);

		if ($preventAddressChanges) {
			$email->setAddressFieldsEnabled(false);
		}
		
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');

		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());

		if ($sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId() && $reviewAssignment->getReviewFileId()) {
			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());

			if (!isset($reviewer)) return true;

			if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
				HookRegistry::call('SectionEditorAction::notifyReviewer', array(&$sectionEditorSubmission, &$reviewAssignment, $incrementNumber, &$email));
				if ($email->isEnabled()) {
					$email->setAssoc(ARTICLE_EMAIL_REVIEW_NOTIFY_REVIEWER, ARTICLE_EMAIL_TYPE_REVIEW, $reviewId);			
					if ($reviewerAccessKeysEnabled) {
						import('lib.pkp.classes.security.AccessKeyManager');
						import('pages.reviewer.ReviewerHandler');
						$accessKeyManager = new AccessKeyManager();

						// Key lifetime is the typical review period plus four weeks
						$keyLifetime = ($journal->getSetting('numWeeksPerReview') + 4) * 7;

						$email->addPrivateParam('ACCESS_KEY', $accessKeyManager->createKey('ReviewerContext', $reviewer->getId(), $reviewId, $keyLifetime));
					}

					if (!Request::getUserVar('continued') || $preventAddressChanges) {
						$weekLaterDate = strftime(Config::getVar('general', 'date_format_short'), strtotime('+1 week'));

						if ($reviewAssignment->getDateDue() != null) {
							$reviewDueDate = strftime(Config::getVar('general', 'date_format_short'), strtotime($reviewAssignment->getDateDue()));
						} else {
							$numWeeks = max((int) $journal->getSetting('numWeeksPerReview'), 2);
							$reviewDueDate = strftime(Config::getVar('general', 'date_format_short'), strtotime('+' . $numWeeks . ' week'));
						}
						$submissionUrl = Request::url(null, 'reviewer', 'submission', $reviewId, $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array());
					

						$paramArray = array(
							'reviewerName' => $reviewer->getFullName(),
							'weekLaterDate' => $weekLaterDate,
							'reviewDueDate' => $reviewDueDate,
							'reviewerUsername' => $reviewer->getUsername(),
							'reviewerPassword' => $reviewer->getPassword(),
							'editorialContactSignature' => $user->getContactSignature(),
							'reviewGuidelines' => String::html2text($journal->getLocalizedSetting('reviewGuidelines')),
							'submissionReviewUrl' => $submissionUrl,
							'abstractTermIfEnabled' => ($sectionEditorSubmission->getLocalizedAbstract() == ''?'':Locale::translate('article.abstract')),
							'passwordResetUrl' => Request::url(null, 'login', 'resetPassword', $reviewer->getUsername(), array('confirm' => Validation::generatePasswordResetHash($reviewer->getId())))
						);
						$email->assignParams($paramArray);

						// Ensure that this messages goes to the reviewer, and the reviewer ONLY.
						$email->clearAllRecipients();
						$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
					}
					$email->send();
				}
				
				import('lib.pkp.classes.notification.NotificationManager');
				$notificationManager = new NotificationManager();
				$url = Request::url($journal->getPath(), 'reviewer', 'submission', array($reviewId));
				$notificationManager->createNotification(
                                    $reviewAssignment->getReviewerId(), 'notification.type.reviewAssignment',
                                    $sectionEditorSubmission->getProposalId(), $url, 1, NOTIFICATION_TYPE_SECTION_DECISION_COMMENT
                                );
            	
				$reviewAssignment->setDateNotified(Core::getCurrentDate());
				$reviewAssignment->setCancelled(0);
				$reviewAssignment->stampModified();
				$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

				return true;
			} else {
				if (!Request::getUserVar('continued') || $preventAddressChanges) {
					$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
				}

				if (!Request::getUserVar('continued')) {
					$weekLaterDate = strftime(Config::getVar('general', 'date_format_short'), strtotime('+1 week'));

					if ($reviewAssignment->getDateDue() != null) {
						$reviewDueDate = strftime(Config::getVar('general', 'date_format_short'), strtotime($reviewAssignment->getDateDue()));
					} else {
						$numWeeks = max((int) $journal->getSetting('numWeeksPerReview'), 2);
						$reviewDueDate = strftime(Config::getVar('general', 'date_format_short'), strtotime('+' . $numWeeks . ' week'));
					}

					$submissionUrl = Request::url(null, 'reviewer', 'submission', $reviewId, $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array());

					$paramArray = array(
						'reviewerName' => $reviewer->getFullName(),
						'weekLaterDate' => $weekLaterDate,
						'reviewDueDate' => $reviewDueDate,
						'reviewerUsername' => $reviewer->getUsername(),
						'reviewerPassword' => $reviewer->getPassword(),
						'editorialContactSignature' => $user->getContactSignature(),
						'reviewGuidelines' => String::html2text($journal->getLocalizedSetting('reviewGuidelines')),
						'submissionReviewUrl' => $submissionUrl,
						'abstractTermIfEnabled' => ($sectionEditorSubmission->getLocalizedAbstract() == ''?'':Locale::translate('article.abstract')),
						'passwordResetUrl' => Request::url(null, 'login', 'resetPassword', $reviewer->getUsername(), array('confirm' => Validation::generatePasswordResetHash($reviewer->getId())))
					);
					$email->assignParams($paramArray);
					if ($isEmailBasedReview) {
						// An email-based review process was selected. Attach
						// the current review version.
						import('classes.file.TemporaryFileManager');
						$temporaryFileManager = new TemporaryFileManager();
						$reviewVersion =& $sectionEditorSubmission->getReviewFile();
						if ($reviewVersion) {
							$temporaryFile = $temporaryFileManager->articleToTemporaryFile($reviewVersion, $user->getId());
							$email->addPersistAttachment($temporaryFile);
						}
					}
				}
				$email->displayEditForm(Request::url(null, null, 'notifyReviewers', array($sectionEditorSubmission->getArticleId(), $incrementNumber)));
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Cancels a review.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 * @return boolean true iff ready for redirect
	 */
	function cancelReview($sectionEditorSubmission, $reviewId, $send = false) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());

		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
		if (!isset($reviewer)) return true;

		if ($sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId()) {
			// Only cancel the review if it is currently not cancelled but has previously
			// been initiated, and has not been completed.
			if ($reviewAssignment->getDateNotified() != null && !$reviewAssignment->getCancelled() && ($reviewAssignment->getDateCompleted() == null || $reviewAssignment->getDeclined())) {
				import('classes.mail.ArticleMailTemplate');
				$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'REVIEW_CANCEL');

				if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
					HookRegistry::call('SectionEditorAction::cancelReview', array(&$sectionEditorSubmission, &$reviewAssignment, &$email));
					if ($email->isEnabled()) {
						$email->setAssoc(ARTICLE_EMAIL_REVIEW_CANCEL, ARTICLE_EMAIL_TYPE_REVIEW, $reviewId);
						$email->send();
					}

					$reviewAssignment->setCancelled(1);
					$reviewAssignment->setDateCompleted(Core::getCurrentDate());
					$reviewAssignment->stampModified();
					$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);
					
					//Send notification
					import('lib.pkp.classes.notification.NotificationManager');
					$notificationManager = new NotificationManager();
					$url = Request::url($journal->getPath(), 'reviewer', 'submission', array($reviewId));
					$notificationManager->createNotification(
                		$reviewAssignment->getReviewerId(), 'notification.type.reviewAssignmentCanceled',
                		$sectionEditorSubmission->getProposalId(), $url, 1, NOTIFICATION_TYPE_SECTION_DECISION_COMMENT
            		);
            	
					// Add log
					import('classes.article.log.ArticleLog');
					import('classes.article.log.ArticleEventLogEntry');
                                        Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
					ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_REVIEW_CANCEL, ARTICLE_LOG_TYPE_REVIEW, $reviewAssignment->getId(), 'log.review.reviewCancelled', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $sectionEditorSubmission->getProposalId()));
				} else {
					if (!Request::getUserVar('continued')) {
						$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());

						$paramArray = array(
							'reviewerName' => $reviewer->getFullName(),
							'reviewerUsername' => $reviewer->getUsername(),
							'reviewerPassword' => $reviewer->getPassword(),
							'editorialContactSignature' => $user->getContactSignature()
						);
						$email->assignParams($paramArray);
					}
					$email->displayEditForm(Request::url(null, null, 'cancelReview', 'send'), array('reviewId' => $reviewId, 'articleId' => $sectionEditorSubmission->getArticleId()));
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * Reminds a reviewer about a review assignment.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 * @return boolean true iff no error was encountered
	 */
	function remindReviewer($sectionEditorSubmission, $reviewId, $send = false) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$reviewerAccessKeysEnabled = $journal->getSetting('reviewerAccessKeysEnabled');

		// If we're using access keys, disable the address fields
		// for this message. (Prevents security issue: section editor
		// could CC or BCC someone else, or change the reviewer address,
		// in order to get the access key.)
		$preventAddressChanges = $reviewerAccessKeysEnabled;

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, $reviewerAccessKeysEnabled?'REVIEW_REMIND_ONECLICK':'REVIEW_REMIND');

		if ($preventAddressChanges) {
			$email->setAddressFieldsEnabled(false);
		}

		if ($send && !$email->hasErrors()) {
			HookRegistry::call('SectionEditorAction::remindReviewer', array(&$sectionEditorSubmission, &$reviewAssignment, &$email));
			$email->setAssoc(ARTICLE_EMAIL_REVIEW_REMIND, ARTICLE_EMAIL_TYPE_REVIEW, $reviewId);

			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());

			if ($reviewerAccessKeysEnabled) {
				import('lib.pkp.classes.security.AccessKeyManager');
				import('pages.reviewer.ReviewerHandler');
				$accessKeyManager = new AccessKeyManager();

				// Key lifetime is the typical review period plus four weeks
				$keyLifetime = ($journal->getSetting('numWeeksPerReview') + 4) * 7;
				$email->addPrivateParam('ACCESS_KEY', $accessKeyManager->createKey('ReviewerContext', $reviewer->getId(), $reviewId, $keyLifetime));
			}

			if ($preventAddressChanges) {
				// Ensure that this messages goes to the reviewer, and the reviewer ONLY.
				$email->clearAllRecipients();
				$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
			}

			$email->send();

			$reviewAssignment->setDateReminded(Core::getCurrentDate());
			$reviewAssignment->setReminderWasAutomatic(0);
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);
			return true;
		} elseif ($sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId()) {
			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());

			if (!Request::getUserVar('continued')) {
				if (!isset($reviewer)) return true;
				$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());

				$submissionUrl = Request::url(null, 'reviewer', 'submission', $reviewId, $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array());

				// Format the review due date
				$reviewDueDate = strtotime($reviewAssignment->getDateDue());
				$dateFormatShort = Config::getVar('general', 'date_format_short');
				if ($reviewDueDate == -1) $reviewDueDate = $dateFormatShort; // Default to something human-readable if no date specified
				else $reviewDueDate = strftime($dateFormatShort, $reviewDueDate);

				$paramArray = array(
					'reviewerName' => $reviewer->getFullName(),
					'reviewerUsername' => $reviewer->getUsername(),
					'reviewerPassword' => $reviewer->getPassword(),
					'reviewDueDate' => $reviewDueDate,
					'editorialContactSignature' => $user->getContactSignature(),
					'passwordResetUrl' => Request::url(null, 'login', 'resetPassword', $reviewer->getUsername(), array('confirm' => Validation::generatePasswordResetHash($reviewer->getId()))),
					'submissionReviewUrl' => $submissionUrl
				);
				$email->assignParams($paramArray);

			}
			$email->displayEditForm(
			Request::url(null, null, 'remindReviewer', 'send'),
			array(
					'reviewerId' => $reviewer->getId(),
					'articleId' => $sectionEditorSubmission->getArticleId(),
					'reviewId' => $reviewId
			)
			);
			return false;
		}
		return true;
	}

	/**
	 * Thanks a reviewer for completing a review assignment.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 * @return boolean true iff ready for redirect
	 */
	function thankReviewer($sectionEditorSubmission, $reviewId, $send = false) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'REVIEW_ACK');

		if ($sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId()) {
			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
			if (!isset($reviewer)) return true;

			if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
				HookRegistry::call('SectionEditorAction::thankReviewer', array(&$sectionEditorSubmission, &$reviewAssignment, &$email));
				if ($email->isEnabled()) {
					$email->setAssoc(ARTICLE_EMAIL_REVIEW_THANK_REVIEWER, ARTICLE_EMAIL_TYPE_REVIEW, $reviewId);
					$email->send();
				}

				$reviewAssignment->setDateAcknowledged(Core::getCurrentDate());
				$reviewAssignment->stampModified();
				$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);
			} else {
				if (!Request::getUserVar('continued')) {
					$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());

					$paramArray = array(
						'reviewerName' => $reviewer->getFullName(),
						'editorialContactSignature' => $user->getContactSignature()
					);
					$email->assignParams($paramArray);
				}
				$email->displayEditForm(Request::url(null, null, 'thankReviewer', 'send'), array('reviewId' => $reviewId, 'articleId' => $sectionEditorSubmission->getArticleId()));
				return false;
			}
		}
		return true;
	}

	/**
	 * Rates a reviewer for quality of a review.
	 * @param $articleId int
	 * @param $reviewId int
	 * @param $quality int
	 */
	function rateReviewer($articleId, $reviewId, $quality = null) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$user =& Request::getUser();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
		if (!isset($reviewer)) return false;

		if ($sectionDecision->getArticleId() == $articleId && !HookRegistry::call('SectionEditorAction::rateReviewer', array(&$reviewAssignment, &$reviewer, &$quality))) {
			// Ensure that the value for quality
			// is between 1 and 5.
			if ($quality != null && ($quality >= 1 && $quality <= 5)) {
				$reviewAssignment->setQuality($quality);
			}

			$reviewAssignment->setDateRated(Core::getCurrentDate());
			$reviewAssignment->stampModified();
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($articleId, ARTICLE_LOG_REVIEW_RATE, ARTICLE_LOG_TYPE_REVIEW, $reviewAssignment->getId(), 'log.review.reviewerRated', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $sectionDecision->getProposalId()));
		}
	}

	/**
	 * Makes a reviewer's annotated version of an article available to the author.
	 * @param $articleId int
	 * @param $reviewId int
	 * @param $viewable boolean
	 */
	function makeReviewerFileViewable($articleId, $reviewId, $fileId, $viewable = false) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$articleFile =& $articleFileDao->getArticleFile($fileId);

		if ($sectionDecision->getArticleId() == $articleId && $reviewAssignment->getReviewerFileId() == $fileId && !HookRegistry::call('SectionEditorAction::makeReviewerFileViewable', array(&$reviewAssignment, &$articleFile, &$viewable))) {
			$articleFile->setViewable($viewable);
			$articleFileDao->updateArticleFile($articleFile);
			
			// Send a notification to the investigator
			import('lib.pkp.classes.notification.NotificationManager');
			$userDao =& DAORegistry::getDAO('UserDAO');
			$notificationManager = new NotificationManager();
			$article =& $articleDao->getArticle($articleId);
			$notificationUsers = $article->getAssociatedUserIds(true, false, false, false);
			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
			if ($viewable) $message = 'notification.type.reviewerFile';
			else $message = 'notification.type.reviewerFileDeleted';
			$param = $article->getProposalId().':<br/>A reviewer';
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'peerReview');
				$notificationManager->createNotification(
            		$userRole['id'], $message,
                	$param, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
                );
			}
		}
	}

	/**
	 * Sets the due date for a review assignment.
	 * @param $articleId int
	 * @param $reviewId int
	 * @param $dueDate string
	 * @param $numWeeks int
	 * @param $logEntry boolean
	 */
	function setDueDate($articleId, $reviewId, $dueDate = null, $numWeeks = null, $logEntry = false) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$user =& Request::getUser();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
				
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
		if (!isset($reviewer)) return false;

		if ($sectionDecision->getArticleId() == $articleId && !HookRegistry::call('SectionEditorAction::setDueDate', array(&$reviewAssignment, &$reviewer, &$dueDate, &$numWeeks, &$meetingDate))) {
			$today = getDate();
			$todayTimestamp = mktime(0, 0, 0, $today['mon'], $today['mday'], $today['year']);
			if ($dueDate != null) {

				$dueDateParts = explode('-', $dueDate);

				// Ensure that the specified due date is today or after today's date.
				if ($todayTimestamp <= strtotime($dueDate)) {
					$reviewAssignment->setDateDue(mktime(0, 0, 0, $dueDateParts[1], $dueDateParts[2], $dueDateParts[0]));
				} else {
					$reviewAssignment->setDateDue(date('Y-m-d H:i:s', $todayTimestamp));
				}
			} else {
				// Add the equivalent of $numWeeks weeks, measured in seconds, to $todaysTimestamp.
				$newDueDateTimestamp = $todayTimestamp + ($numWeeks * 7 * 24 * 60 * 60);
				$reviewAssignment->setDateDue($newDueDateTimestamp);
			}
				
			$reviewAssignment->stampModified();
			
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

			if ($logEntry) {
				// Add log
				import('classes.article.log.ArticleLog');
				import('classes.article.log.ArticleEventLogEntry');
                                Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
				ArticleLog::logEvent(
				$articleId,
				ARTICLE_LOG_REVIEW_SET_DUE_DATE,
				ARTICLE_LOG_TYPE_REVIEW,
				$reviewAssignment->getId(),
					'log.review.reviewDueDateSet',
				array(
						'reviewerName' => $reviewer->getFullName(),
						'dueDate' => strftime(Config::getVar('general', 'date_format_short'),
				strtotime($reviewAssignment->getDateDue())),
						'articleId' => $sectionDecision->getProposalId()
				)
				);
			}
		}
	}

	/**
	 * Notifies an author that a submission was unsuitable.
	 * @param $sectionEditorSubmission object
	 * @return boolean true iff ready for redirect
	 */
	function unsuitableSubmission($sectionEditorSubmission, $send = false) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$author =& $userDao->getUser($sectionEditorSubmission->getUserId());
		if (!isset($author)) return true;

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'SUBMISSION_UNSUITABLE');

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::unsuitableSubmission', array(&$sectionEditorSubmission, &$author, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_EDITOR_NOTIFY_AUTHOR_UNSUITABLE, ARTICLE_EMAIL_TYPE_EDITOR, $user->getId());
				$email->send();
			}
			SectionEditorAction::archiveSubmission($sectionEditorSubmission);
			return true;
		} else {
			if (!Request::getUserVar('continued')) {
				$paramArray = array(
					'editorialContactSignature' => $user->getContactSignature(),
					'authorName' => $author->getFullName()
				);
				$email->assignParams($paramArray);
				$email->addRecipient($author->getEmail(), $author->getFullName());
			}
			$email->displayEditForm(Request::url(null, null, 'unsuitableSubmission'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
	}

	/**
	 * Sets the reviewer recommendation for a review assignment.
	 * Also concatenates the reviewer and editor comments from Peer Review and adds them to Editor Review.
	 * @param $articleId int
	 * @param $reviewId int
	 * @param $recommendation int
	 */
	function setReviewerRecommendation($articleId, $reviewId, $recommendation, $acceptOption) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$user =& Request::getUser();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId(), true);

		if ($sectionDecision->getArticleId() == $articleId && !HookRegistry::call('SectionEditorAction::setReviewerRecommendation', array(&$reviewAssignment, &$reviewer, &$recommendation, &$acceptOption))) {
			$reviewAssignment->setRecommendation($recommendation);

			$nowDate = Core::getCurrentDate();
			if (!$reviewAssignment->getDateConfirmed()) {
				$reviewAssignment->setDateConfirmed($nowDate);
			}
			$reviewAssignment->setDateCompleted($nowDate);
			$reviewAssignment->stampModified();
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($articleId, ARTICLE_LOG_REVIEW_RECOMMENDATION_BY_PROXY, ARTICLE_LOG_TYPE_REVIEW, $reviewAssignment->getId(), 'log.review.reviewRecommendationSetByProxy', array('editorName' => $user->getFullName(), 'reviewerName' => $reviewer->getFullName(), 'articleId' => $sectionDecision->getProposalId()));
		}
	}

	/**
	 * Clear a review form
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 */
	function clearReviewForm($sectionEditorSubmission, $reviewId) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());

		if (HookRegistry::call('SectionEditorAction::clearReviewForm', array(&$sectionEditorSubmission, &$reviewAssignment, &$reviewId))) return $reviewId;

		if (isset($reviewAssignment) && $sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId()) {
			$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
			$responses = $reviewFormResponseDao->getReviewReviewFormResponseValues($reviewId);
			if (!empty($responses)) {
				$reviewFormResponseDao->deleteByReviewId($reviewId);
			}
			$reviewAssignment->setReviewFormId(null);

			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);
		}
	}

	/**
	 * Assigns a review form to a review.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 * @param $reviewFormId int
	 */
	function addReviewForm($sectionEditorSubmission, $reviewId, $reviewFormId) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());

		if (HookRegistry::call('SectionEditorAction::addReviewForm', array(&$sectionEditorSubmission, &$reviewAssignment, &$reviewId, &$reviewFormId))) return $reviewFormId;

		if (isset($reviewAssignment) && $sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId()) {
			// Only add the review form if it has not already
			// been assigned to the review.
			if ($reviewAssignment->getReviewFormId() != $reviewFormId) {
				$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
				$responses = $reviewFormResponseDao->getReviewReviewFormResponseValues($reviewId);
				if (!empty($responses)) {
					$reviewFormResponseDao->deleteByReviewId($reviewId);
				}
				$reviewAssignment->setReviewFormId($reviewFormId);

				$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);
			}
		}
	}

	/**
	 * View review form response.
	 * @param $sectionEditorSubmission object
	 * @param $reviewId int
	 */
	function viewReviewFormResponse($sectionEditorSubmission, $reviewId) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		
		if (HookRegistry::call('SectionEditorAction::viewReviewFormResponse', array(&$sectionEditorSubmission, &$reviewAssignment, &$reviewId))) return $reviewId;

		if (isset($reviewAssignment) && $sectionDecision->getArticleId() == $sectionEditorSubmission->getArticleId()) {
			$reviewFormId = $reviewAssignment->getReviewFormId();
			if ($reviewFormId != null) {
				import('classes.submission.form.ReviewFormResponseForm');
				$reviewForm = new ReviewFormResponseForm($reviewId, $reviewFormId);
				$reviewForm->initData();
				$reviewForm->display();
			}
		}
	}

	/**
	 * Set the file to use as the default copyedit file.
	 * @param $sectionEditorSubmission object
	 * @param $fileId int
	 * TODO: SECURITY!
	 */
	function setCopyeditFile($sectionEditorSubmission, $fileId) {
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($sectionEditorSubmission->getArticleId());
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$user =& Request::getUser();

		if (!HookRegistry::call('SectionEditorAction::setCopyeditFile', array(&$sectionEditorSubmission, &$fileId))) {
			// Copy the file from the editor decision file folder to the copyedit file folder
			$newFileId = $articleFileManager->copyToCopyeditFile($fileId);

			$copyeditSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());

			$copyeditSignoff->setFileId($newFileId);
			// No revision anymore
			//$copyeditSignoff->setFileRevision(1);

			$signoffDao->updateObject($copyeditSignoff);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_COPYEDIT_SET_FILE, ARTICLE_LOG_TYPE_COPYEDIT, $sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL', true), 'log.copyedit.copyeditFileSet');
		}
	}

	/*
	 * Never called
	function initiateNewReviewRound($sectionEditorSubmission) {
		if (!HookRegistry::call('SectionEditorAction::initiateNewReviewRound', array(&$sectionEditorSubmission))) {
			// Increment the round
			$currentRound = $sectionEditorSubmission->getCurrentRound();
			$sectionEditorSubmission->setCurrentRound($currentRound + 1);
			$sectionEditorSubmission->stampStatusModified();
			// Now, reassign all reviewers that submitted a review for this new round of reviews.
			$previousRound = $sectionEditorSubmission->getCurrentRound() - 1;
			foreach ($sectionEditorSubmission->getReviewAssignments($previousRound) as $reviewAssignment) {
				if ($reviewAssignment->getRecommendation() !== null && $reviewAssignment->getRecommendation() !== '') {
					// Then this reviewer submitted a review.
					SectionEditorAction::addReviewer($sectionEditorSubmission, $reviewAssignment->getReviewerId(), $sectionEditorSubmission->getCurrentRound());
				}
			}

		}
	}
	*/

	/**
	 * Resubmit the file for review.
	 * @param $sectionEditorSubmission object
	 * @param $fileId int
	 * @param $revision int
	 * TODO: SECURITY!
	 */
	 /* Not currently used
	function resubmitFile($sectionEditorSubmission, $fileId, $revision) {
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($sectionEditorSubmission->getArticleId());
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$user =& Request::getUser();

		if (!HookRegistry::call('SectionEditorAction::resubmitFile', array(&$sectionEditorSubmission, &$fileId, &$revision))) {
			// Increment the round
			$currentRound = $sectionEditorSubmission->getCurrentRound();
			$sectionEditorSubmission->setCurrentRound($currentRound + 1);
			$sectionEditorSubmission->stampStatusModified();

			// Copy the file from the editor decision file folder to the review file folder
			$newFileId = $articleFileManager->copyToReviewFile($fileId, $revision, $sectionEditorSubmission->getReviewFileId());
			$newReviewFile = $articleFileDao->getArticleFile($newFileId);
			$newReviewFile->setRound($sectionEditorSubmission->getCurrentRound());
			$articleFileDao->updateArticleFile($newReviewFile);

			// Copy the file from the editor decision file folder to the next-round editor file
			// $editorFileId may or may not be null after assignment
			$editorFileId = $sectionEditorSubmission->getEditorFileId() != null ? $sectionEditorSubmission->getEditorFileId() : null;

			// $editorFileId definitely will not be null after assignment
			$editorFileId = $articleFileManager->copyToDecisionFile($newFileId, null, $editorFileId);
			$newEditorFile = $articleFileDao->getArticleFile($editorFileId);
			$newEditorFile->setRound($sectionEditorSubmission->getCurrentRound());
			$articleFileDao->updateArticleFile($newEditorFile);

			// The review revision is the highest revision for the review file.
			$reviewRevision = $articleFileDao->getRevisionNumber($newFileId);
			$sectionEditorSubmission->setReviewRevision($reviewRevision);

			$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);

			// Now, reassign all reviewers that submitted a review for this new round of reviews.
			$previousRound = $sectionEditorSubmission->getCurrentRound() - 1;
			foreach ($sectionEditorSubmission->getReviewAssignments($previousRound) as $reviewAssignment) {
				if ($reviewAssignment->getRecommendation() !== null && $reviewAssignment->getRecommendation() !== '') {
					// Then this reviewer submitted a review.
					SectionEditorAction::addReviewer($sectionEditorSubmission, $reviewAssignment->getReviewerId(), $sectionEditorSubmission->getCurrentRound());
				}
			}


			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_REVIEW_RESUBMIT, ARTICLE_LOG_TYPE_EDITOR, $user->getId(), 'log.review.resubmit', array('articleId' => $sectionEditorSubmission->getArticleId()));
		}
	}
	*/

	/**
	 * Assigns a copyeditor to a submission.
	 * @param $sectionEditorSubmission object
	 * @param $copyeditorId int
	 */
	function selectCopyeditor($sectionEditorSubmission, $copyeditorId) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$user =& Request::getUser();

		// Check to see if the requested copyeditor is not already
		// assigned to copyedit this article.
		$assigned = $sectionEditorSubmissionDao->copyeditorExists($sectionEditorSubmission->getArticleId(), $copyeditorId);

		// Only add the copyeditor if he has not already
		// been assigned to review this article.
		if (!$assigned && !HookRegistry::call('SectionEditorAction::selectCopyeditor', array(&$sectionEditorSubmission, &$copyeditorId))) {
			$copyeditInitialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$copyeditInitialSignoff->setUserId($copyeditorId);
			$signoffDao->updateObject($copyeditInitialSignoff);

			$copyeditor =& $userDao->getUser($copyeditorId);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_COPYEDIT_ASSIGN, ARTICLE_LOG_TYPE_COPYEDIT, $copyeditorId, 'log.copyedit.copyeditorAssigned', array('copyeditorName' => $copyeditor->getFullName(), 'articleId' => $sectionEditorSubmission->getArticleId()));
		}
	}

	/**
	 * Notifies a copyeditor about a copyedit assignment.
	 * @param $sectionEditorSubmission object
	 * @return boolean true iff ready for redirect
	 */
	function notifyCopyeditor($sectionEditorSubmission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'COPYEDIT_REQUEST');

		$copyeditor = $sectionEditorSubmission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL');
		if (!isset($copyeditor)) return true;

		if ($sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL') && (!$email->isEnabled() || ($send && !$email->hasErrors()))) {
			HookRegistry::call('SectionEditorAction::notifyCopyeditor', array(&$sectionEditorSubmission, &$copyeditor, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_COPYEDIT_NOTIFY_COPYEDITOR, ARTICLE_EMAIL_TYPE_COPYEDIT, $sectionEditorSubmission->getArticleId());
				$email->send();
			}

			$copyeditInitialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$copyeditInitialSignoff->setDateNotified(Core::getCurrentDate());
			$copyeditInitialSignoff->setDateUnderway(null);
			$copyeditInitialSignoff->setDateCompleted(null);
			$copyeditInitialSignoff->setDateAcknowledged(null);
			$signoffDao->updateObject($copyeditInitialSignoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($copyeditor->getEmail(), $copyeditor->getFullName());
				$paramArray = array(
					'copyeditorName' => $copyeditor->getFullName(),
					'copyeditorUsername' => $copyeditor->getUsername(),
					'copyeditorPassword' => $copyeditor->getPassword(),
					'editorialContactSignature' => $user->getContactSignature(),
					'submissionCopyeditingUrl' => Request::url(null, 'copyeditor', 'submission', $sectionEditorSubmission->getArticleId())
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyCopyeditor', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Initiates the initial copyedit stage when the editor does the copyediting.
	 * @param $sectionEditorSubmission object
	 */
	function initiateCopyedit($sectionEditorSubmission) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$user =& Request::getUser();

		// Only allow copyediting to be initiated if a copyedit file exists.
		if ($sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL') && !HookRegistry::call('SectionEditorAction::initiateCopyedit', array(&$sectionEditorSubmission))) {
			$signoffDao =& DAORegistry::getDAO('SignoffDAO');

			$copyeditSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			if (!$copyeditSignoff->getUserId()) {
				$copyeditSignoff->setUserId($user->getId());
			}
			$copyeditSignoff->setDateNotified(Core::getCurrentDate());

			$signoffDao->updateObject($copyeditSignoff);
		}
	}

	/**
	 * Thanks a copyeditor about a copyedit assignment.
	 * @param $sectionEditorSubmission object
	 * @return boolean true iff ready for redirect
	 */
	function thankCopyeditor($sectionEditorSubmission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'COPYEDIT_ACK');

		$copyeditor = $sectionEditorSubmission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL');
		if (!isset($copyeditor)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::thankCopyeditor', array(&$sectionEditorSubmission, &$copyeditor, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_COPYEDIT_NOTIFY_ACKNOWLEDGE, ARTICLE_EMAIL_TYPE_COPYEDIT, $sectionEditorSubmission->getArticleId());
				$email->send();
			}

			$initialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$initialSignoff->setDateAcknowledged(Core::getCurrentDate());
			$signoffDao->updateObject($initialSignoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($copyeditor->getEmail(), $copyeditor->getFullName());
				$paramArray = array(
					'copyeditorName' => $copyeditor->getFullName(),
					'editorialContactSignature' => $user->getContactSignature()
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'thankCopyeditor', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Notifies the author that the copyedit is complete.
	 * @param $sectionEditorSubmission object
	 * @return true iff ready for redirect
	 */
	function notifyAuthorCopyedit($sectionEditorSubmission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'COPYEDIT_AUTHOR_REQUEST');

		$author =& $userDao->getUser($sectionEditorSubmission->getUserId());
		if (!isset($author)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::notifyAuthorCopyedit', array(&$sectionEditorSubmission, &$author, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_COPYEDIT_NOTIFY_AUTHOR, ARTICLE_EMAIL_TYPE_COPYEDIT, $sectionEditorSubmission->getArticleId());
				$email->send();
			}

			$authorSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_AUTHOR', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$authorSignoff->setUserId($author->getId());
			$authorSignoff->setDateNotified(Core::getCurrentDate());
			$authorSignoff->setDateUnderway(null);
			$authorSignoff->setDateCompleted(null);
			$authorSignoff->setDateAcknowledged(null);
			$signoffDao->updateObject($authorSignoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($author->getEmail(), $author->getFullName());
				$paramArray = array(
					'authorName' => $author->getFullName(),
					'authorUsername' => $author->getUsername(),
					'authorPassword' => $author->getPassword(),
					'editorialContactSignature' => $user->getContactSignature(),
					'submissionCopyeditingUrl' => Request::url(null, 'author', 'submission', $sectionEditorSubmission->getArticleId())

				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyAuthorCopyedit', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Thanks an author for completing editor / author review.
	 * @param $sectionEditorSubmission object
	 * @return boolean true iff ready for redirect
	 */
	function thankAuthorCopyedit($sectionEditorSubmission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'COPYEDIT_AUTHOR_ACK');

		$author =& $userDao->getUser($sectionEditorSubmission->getUserId());
		if (!isset($author)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::thankAuthorCopyedit', array(&$sectionEditorSubmission, &$author, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_COPYEDIT_NOTIFY_AUTHOR_ACKNOWLEDGE, ARTICLE_EMAIL_TYPE_COPYEDIT, $sectionEditorSubmission->getArticleId());
				$email->send();
			}

			$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_AUTHOR', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$signoff->setDateAcknowledged(Core::getCurrentDate());
			$signoffDao->updateObject($signoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($author->getEmail(), $author->getFullName());
				$paramArray = array(
					'authorName' => $author->getFullName(),
					'editorialContactSignature' => $user->getContactSignature()
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'thankAuthorCopyedit', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Notify copyeditor about final copyedit.
	 * @param $sectionEditorSubmission object
	 * @param $send boolean
	 * @return boolean true iff ready for redirect
	 */
	function notifyFinalCopyedit($sectionEditorSubmission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'COPYEDIT_FINAL_REQUEST');

		$copyeditor = $sectionEditorSubmission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL');
		if (!isset($copyeditor)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::notifyFinalCopyedit', array(&$sectionEditorSubmission, &$copyeditor, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_COPYEDIT_NOTIFY_FINAL, ARTICLE_EMAIL_TYPE_COPYEDIT, $sectionEditorSubmission->getArticleId());
				$email->send();
			}

			$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$signoff->setUserId($copyeditor->getId());
			$signoff->setDateNotified(Core::getCurrentDate());
			$signoff->setDateUnderway(null);
			$signoff->setDateCompleted(null);
			$signoff->setDateAcknowledged(null);

			$signoffDao->updateObject($signoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($copyeditor->getEmail(), $copyeditor->getFullName());
				$paramArray = array(
					'copyeditorName' => $copyeditor->getFullName(),
					'copyeditorUsername' => $copyeditor->getUsername(),
					'copyeditorPassword' => $copyeditor->getPassword(),
					'editorialContactSignature' => $user->getContactSignature(),
					'submissionCopyeditingUrl' => Request::url(null, 'copyeditor', 'submission', $sectionEditorSubmission->getArticleId())
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyFinalCopyedit', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Thank copyeditor for completing final copyedit.
	 * @param $sectionEditorSubmission object
	 * @return boolean true iff ready for redirect
	 */
	function thankFinalCopyedit($sectionEditorSubmission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($sectionEditorSubmission, null, 'COPYEDIT_FINAL_ACK');

		$copyeditor = $sectionEditorSubmission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL');
		if (!isset($copyeditor)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::thankFinalCopyedit', array(&$sectionEditorSubmission, &$copyeditor, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_COPYEDIT_NOTIFY_FINAL_ACKNOWLEDGE, ARTICLE_EMAIL_TYPE_COPYEDIT, $sectionEditorSubmission->getArticleId());
				$email->send();
			}

			$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
			$signoff->setDateAcknowledged(Core::getCurrentDate());
			$signoffDao->updateObject($signoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($copyeditor->getEmail(), $copyeditor->getFullName());
				$paramArray = array(
					'copyeditorName' => $copyeditor->getFullName(),
					'editorialContactSignature' => $user->getContactSignature()
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'thankFinalCopyedit', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Upload the review version of an article.
	 * @param $sectionEditorSubmission object
	 */
	function uploadReviewVersion($sectionEditorSubmission) {
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($sectionEditorSubmission->getArticleId());
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

		$fileName = 'upload';
		if ($articleFileManager->uploadedFileExists($fileName) && !HookRegistry::call('SectionEditorAction::uploadReviewVersion', array(&$sectionEditorSubmission))) {
			if ($sectionEditorSubmission->getReviewFileId() != null) {
				$reviewFileId = $articleFileManager->uploadReviewFile($fileName, null, $sectionEditorSubmission->getReviewFileId());
			} else {
				$reviewFileId = $articleFileManager->uploadReviewFile($fileName);
			}
			$editorFileId = $articleFileManager->copyToDecisionFile($reviewFileId, $sectionEditorSubmission->getEditorFileId());
		}

		if (isset($reviewFileId) && $reviewFileId != 0 && isset($editorFileId) && $editorFileId != 0) {
			$sectionEditorSubmission->setReviewFileId($reviewFileId);
			$sectionEditorSubmission->setEditorFileId($editorFileId);

			$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);
		}
	}

	/**
	 * Upload the post-review version of an article.
	 * @param $sectionEditorSubmission object
	 */
	function uploadEditorVersion($sectionEditorSubmission) {
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($sectionEditorSubmission->getArticleId());
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$user =& Request::getUser();

		$fileName = 'upload';
		if ($articleFileManager->uploadedFileExists($fileName) && !HookRegistry::call('SectionEditorAction::uploadEditorVersion', array(&$sectionEditorSubmission))) {
			if ($sectionEditorSubmission->getEditorFileId() != null) {
				$fileId = $articleFileManager->uploadDecisionFile($fileName,$sectionEditorSubmission->getLastSectionDecisionId(), $sectionEditorSubmission->getEditorFileId());
			} else {
				$fileId = $articleFileManager->uploadDecisionFile($fileName, $sectionEditorSubmission->getLastSectionDecisionId());
			}
		}

		if (isset($fileId) && $fileId != 0) {
			$sectionEditorSubmission->setEditorFileId($fileId);

			$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_EDITOR_FILE, ARTICLE_LOG_TYPE_EDITOR, $sectionEditorSubmission->getEditorFileId(), 'log.editor.editorFile');
		}
	}

	/**
	 * Upload the copyedit version of an article.
	 * @param $sectionEditorSubmission object
	 * @param $copyeditStage string
	 */
	function uploadCopyeditVersion($sectionEditorSubmission, $copyeditStage) {
		$articleId = $sectionEditorSubmission->getArticleId();
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($articleId);
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		// Perform validity checks.
		$initialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $articleId);
		$authorSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_AUTHOR', ASSOC_TYPE_ARTICLE, $articleId);

		if ($copyeditStage == 'final' && $authorSignoff->getDateCompleted() == null) return;
		if ($copyeditStage == 'author' && $initialSignoff->getDateCompleted() == null) return;

		$fileName = 'upload';
		if ($articleFileManager->uploadedFileExists($fileName) && !HookRegistry::call('SectionEditorAction::uploadCopyeditVersion', array(&$sectionEditorSubmission))) {
			if ($sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL', true) != null) {
				$copyeditFileId = $articleFileManager->uploadCopyeditFile($fileName, $sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL', true));
			} else {
				$copyeditFileId = $articleFileManager->uploadCopyeditFile($fileName);
			}
		}

		if (isset($copyeditFileId) && $copyeditFileId != 0) {
			if ($copyeditStage == 'initial') {
				$signoff =& $initialSignoff;
				$signoff->setFileId($copyeditFileId);
				// No revision anymore
				//$signoff->setFileRevision($articleFileDao->getRevisionNumber($copyeditFileId));
			} elseif ($copyeditStage == 'author') {
				$signoff =& $authorSignoff;
				$signoff->setFileId($copyeditFileId);
				// No revision anymore
				//$signoff->setFileRevision($articleFileDao->getRevisionNumber($copyeditFileId));
			} elseif ($copyeditStage == 'final') {
				$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $articleId);
				$signoff->setFileId($copyeditFileId);
				// No revision anymore
				//$signoff->setFileRevision($articleFileDao->getRevisionNumber($copyeditFileId));
			}

			$signoffDao->updateObject($signoff);
		}
	}

	/**
	 * Editor completes initial copyedit (copyeditors disabled).
	 * @param $sectionEditorSubmission object
	 */
	function completeCopyedit($sectionEditorSubmission) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		// This is only allowed if copyeditors are disabled.
		if ($journal->getSetting('useCopyeditors')) return;

		if (HookRegistry::call('SectionEditorAction::completeCopyedit', array(&$sectionEditorSubmission))) return;

		$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
		$signoff->setDateCompleted(Core::getCurrentDate());
		$signoffDao->updateObject($signoff);
		// Add log entry
		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
                Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
		ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_COPYEDIT_INITIAL, ARTICLE_LOG_TYPE_COPYEDIT, $user->getId(), 'log.copyedit.initialEditComplete', Array('copyeditorName' => $user->getFullName(), 'articleId' => $sectionEditorSubmission->getArticleId()));
	}

	/**
	 * Section editor completes final copyedit (copyeditors disabled).
	 * @param $sectionEditorSubmission object
	 */
	function completeFinalCopyedit($sectionEditorSubmission) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		// This is only allowed if copyeditors are disabled.
		if ($journal->getSetting('useCopyeditors')) return;

		if (HookRegistry::call('SectionEditorAction::completeFinalCopyedit', array(&$sectionEditorSubmission))) return;

		$copyeditSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());
		$copyeditSignoff->setDateCompleted(Core::getCurrentDate());
		$signoffDao->updateObject($copyeditSignoff);

		if ($copyEdFile = $sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_FINAL')) {
			// Set initial layout version to final copyedit version
			$layoutSignoff = $signoffDao->build('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $sectionEditorSubmission->getArticleId());

			if (!$layoutSignoff->getFileId()) {
				import('classes.file.ArticleFileManager');
				$articleFileManager = new ArticleFileManager($sectionEditorSubmission->getArticleId());
				if ($layoutFileId = $articleFileManager->copyToLayoutFile($copyEdFile->getFileId())) {
					$layoutSignoff->setFileId($layoutFileId);
					$signoffDao->updateObject($layoutSignoff);
				}
			}
		}
		// Add log entry
		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
                Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
		ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_COPYEDIT_FINAL, ARTICLE_LOG_TYPE_COPYEDIT, $user->getId(), 'log.copyedit.finalEditComplete', Array('copyeditorName' => $user->getFullName(), 'articleId' => $sectionEditorSubmission->getProposalId()));
	}

	/**
	 * Archive a submission.
	 * @param $sectionEditorSubmission object
	 */
	function archiveSubmission($sectionEditorSubmission) {
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$user =& Request::getUser();

		if (HookRegistry::call('SectionEditorAction::archiveSubmission', array(&$sectionEditorSubmission))) return;

		$sectionEditorSubmission->setStatus(STATUS_ARCHIVED);
		$sectionEditorSubmission->stampStatusModified();

		$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);

		// Add log
		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
                Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
		ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_EDITOR_ARCHIVE, ARTICLE_LOG_TYPE_EDITOR, $sectionEditorSubmission->getArticleId(), 'log.editor.archived', array('articleId' => $sectionEditorSubmission->getProposalId()));
	}

	/**
	 * Restores a submission to the queue.
	 * @param $sectionEditorSubmission object
	 */
	function restoreToQueue($sectionEditorSubmission) {
		if (HookRegistry::call('SectionEditorAction::restoreToQueue', array(&$sectionEditorSubmission))) return;

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

		// Determine which queue to return the article to: the
		// scheduling queue or the editing queue.
		$publishedArticleDao =& DAORegistry::getDAO('PublishedArticleDAO');
		$publishedArticle =& $publishedArticleDao->getPublishedArticleByArticleId($sectionEditorSubmission->getArticleId());
		if ($publishedArticle) {
			$sectionEditorSubmission->setStatus(STATUS_PUBLISHED);
		} else {
			$sectionEditorSubmission->setStatus(STATUS_QUEUED);
		}
		unset($publishedArticle);

		$sectionEditorSubmission->stampStatusModified();

		$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);

		// Add log
		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
                Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
		ArticleLog::logEvent($sectionEditorSubmission->getArticleId(), ARTICLE_LOG_EDITOR_RESTORE, ARTICLE_LOG_TYPE_EDITOR, $sectionEditorSubmission->getArticleId(), 'log.editor.restored', array('articleId' => $sectionEditorSubmission->getProposalId()));
	}

	/**
	 * Changes the submission RT comments status.
	 * @param $submission object
	 * @param $commentsStatus int
	 */
	function updateCommentsStatus($submission, $commentsStatus) {
		if (HookRegistry::call('SectionEditorAction::updateCommentsStatus', array(&$submission, &$commentsStatus))) return;

		$submissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$submission->setCommentsStatus($commentsStatus); // FIXME validate this?
		$submissionDao->updateSectionEditorSubmission($submission);
	}

	//
	// Layout Editing
	//

	/**
	 * Upload the layout version of an article.
	 * @param $submission object
	 */
	function uploadLayoutVersion($submission) {
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($submission->getArticleId());
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$layoutSignoff = $signoffDao->build('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $submission->getArticleId());

		$fileName = 'layoutFile';
		if ($articleFileManager->uploadedFileExists($fileName) && !HookRegistry::call('SectionEditorAction::uploadLayoutVersion', array(&$submission, &$layoutAssignment))) {
			if ($layoutSignoff->getFileId() != null) {
				$layoutFileId = $articleFileManager->uploadLayoutFile($fileName, $layoutSignoff->getFileId());
			} else {
				$layoutFileId = $articleFileManager->uploadLayoutFile($fileName);
			}
			$layoutSignoff->setFileId($layoutFileId);
			$signoffDao->updateObject($layoutSignoff);
		}
	}

	/**
	 * Assign a layout editor to a submission.
	 * @param $submission object
	 * @param $editorId int user ID of the new layout editor
	 */
	function assignLayoutEditor($submission, $editorId) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		if (HookRegistry::call('SectionEditorAction::assignLayoutEditor', array(&$submission, &$editorId))) return;

		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
                Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
		$layoutSignoff = $signoffDao->build('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $submission->getArticleId());
		$layoutProofSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_LAYOUT', ASSOC_TYPE_ARTICLE, $submission->getArticleId());
		if ($layoutSignoff->getUserId()) {
			$layoutEditor =& $userDao->getUser($layoutSignoff->getUserId());
			ArticleLog::logEvent($submission->getArticleId(), ARTICLE_LOG_LAYOUT_UNASSIGN, ARTICLE_LOG_TYPE_LAYOUT, $layoutSignoff->getId(), 'log.layout.layoutEditorUnassigned', array('editorName' => $layoutEditor->getFullName(), 'articleId' => $submission->getProposalId()));
		}

		$layoutSignoff->setUserId($editorId);
		$layoutSignoff->setDateNotified(null);
		$layoutSignoff->setDateUnderway(null);
		$layoutSignoff->setDateCompleted(null);
		$layoutSignoff->setDateAcknowledged(null);
		$layoutProofSignoff->setUserId($editorId);
		$layoutProofSignoff->setDateNotified(null);
		$layoutProofSignoff->setDateUnderway(null);
		$layoutProofSignoff->setDateCompleted(null);
		$layoutProofSignoff->setDateAcknowledged(null);
		$signoffDao->updateObject($layoutSignoff);
		$signoffDao->updateObject($layoutProofSignoff);

		$layoutEditor =& $userDao->getUser($layoutSignoff->getUserId());
		ArticleLog::logEvent($submission->getArticleId(), ARTICLE_LOG_LAYOUT_ASSIGN, ARTICLE_LOG_TYPE_LAYOUT, $layoutSignoff->getId(), 'log.layout.layoutEditorAssigned', array('editorName' => $layoutEditor->getFullName(), 'articleId' => $submission->getProposalId()));
	}

	/**
	 * Notifies the current layout editor about an assignment.
	 * @param $submission object
	 * @param $send boolean
	 * @return boolean true iff ready for redirect
	 */
	function notifyLayoutEditor($submission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$submissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($submission, null, 'LAYOUT_REQUEST');
		$layoutSignoff = $signoffDao->getBySymbolic('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $submission->getArticleId());
		$layoutEditor =& $userDao->getUser($layoutSignoff->getUserId());
		if (!isset($layoutEditor)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::notifyLayoutEditor', array(&$submission, &$layoutEditor, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_LAYOUT_NOTIFY_EDITOR, ARTICLE_EMAIL_TYPE_LAYOUT, $layoutSignoff->getId());
				$email->send();
			}

			$layoutSignoff->setDateNotified(Core::getCurrentDate());
			$layoutSignoff->setDateUnderway(null);
			$layoutSignoff->setDateCompleted(null);
			$layoutSignoff->setDateAcknowledged(null);
			$signoffDao->updateObject($layoutSignoff);
		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($layoutEditor->getEmail(), $layoutEditor->getFullName());
				$paramArray = array(
					'layoutEditorName' => $layoutEditor->getFullName(),
					'layoutEditorUsername' => $layoutEditor->getUsername(),
					'editorialContactSignature' => $user->getContactSignature(),
					'submissionLayoutUrl' => Request::url(null, 'layoutEditor', 'submission', $submission->getArticleId())
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyLayoutEditor', 'send'), array('articleId' => $submission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Sends acknowledgement email to the current layout editor.
	 * @param $submission object
	 * @param $send boolean
	 * @return boolean true iff ready for redirect
	 */
	function thankLayoutEditor($submission, $send = false) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$submissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($submission, null, 'LAYOUT_ACK');

		$layoutSignoff = $signoffDao->getBySymbolic('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $submission->getArticleId());
		$layoutEditor =& $userDao->getUser($layoutSignoff->getUserId());
		if (!isset($layoutEditor)) return true;

		if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
			HookRegistry::call('SectionEditorAction::thankLayoutEditor', array(&$submission, &$layoutEditor, &$email));
			if ($email->isEnabled()) {
				$email->setAssoc(ARTICLE_EMAIL_LAYOUT_THANK_EDITOR, ARTICLE_EMAIL_TYPE_LAYOUT, $layoutSignoff->getId());
				$email->send();
			}

			$layoutSignoff->setDateAcknowledged(Core::getCurrentDate());
			$signoffDao->updateObject($layoutSignoff);

		} else {
			if (!Request::getUserVar('continued')) {
				$email->addRecipient($layoutEditor->getEmail(), $layoutEditor->getFullName());
				$paramArray = array(
					'layoutEditorName' => $layoutEditor->getFullName(),
					'editorialContactSignature' => $user->getContactSignature()
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'thankLayoutEditor', 'send'), array('articleId' => $submission->getArticleId()));
			return false;
		}
		return true;
	}

	/**
	 * Change the sequence order of a galley.
	 * @param $article object
	 * @param $galleyId int
	 * @param $direction char u = up, d = down
	 */
	function orderGalley($article, $galleyId, $direction) {
		import('classes.submission.layoutEditor.LayoutEditorAction');
		LayoutEditorAction::orderGalley($article, $galleyId, $direction);
	}

	/**
	 * Delete a galley.
	 * @param $article object
	 * @param $galleyId int
	 */
	function deleteGalley($article, $galleyId) {
		import('classes.submission.layoutEditor.LayoutEditorAction');
		LayoutEditorAction::deleteGalley($article, $galleyId);
	}

	/**
	 * Change the sequence order of a supplementary file.
	 * @param $article object
	 * @param $suppFileId int
	 * @param $direction char u = up, d = down
	 */
	function orderSuppFile($article, $suppFileId, $direction) {
		import('classes.submission.layoutEditor.LayoutEditorAction');
		LayoutEditorAction::orderSuppFile($article, $suppFileId, $direction);
	}

	/**
	 * Delete a supplementary file.
	 * @param $article object
	 * @param $suppFileId int
	 */
	function deleteSuppFile($article, $suppFileId) {
		import('classes.submission.layoutEditor.LayoutEditorAction');
		LayoutEditorAction::deleteSuppFile($article, $suppFileId);
	}

	/**
	 * Delete a file from an article.
	 * @param $submission object
	 * @param $fileId int
	 */
	function deleteArticleFile($submission, $fileId) {
		import('classes.file.ArticleFileManager');
		$file =& $submission->getEditorFile();

		if (isset($file) && $file->getFileId() == $fileId && !HookRegistry::call('SectionEditorAction::deleteArticleFile', array(&$submission, &$fileId))) {
			$articleFileManager = new ArticleFileManager($submission->getArticleId());
			$articleFileManager->deleteFile($fileId);
		}
	}

	/**
	 * Delete an image from an article galley.
	 * @param $submission object
	 * @param $fileId int
	 */
	function deleteArticleImage($submission, $fileId) {
		import('classes.file.ArticleFileManager');
		$articleGalleyDao =& DAORegistry::getDAO('ArticleGalleyDAO');
		if (HookRegistry::call('SectionEditorAction::deleteArticleImage', array(&$submission, &$fileId))) return;
		foreach ($submission->getGalleys() as $galley) {
			$images =& $articleGalleyDao->getGalleyImages($galley->getId());
			foreach ($images as $imageFile) {
				if ($imageFile->getArticleId() == $submission->getArticleId() && $fileId == $imageFile->getFileId()) {
					$articleFileManager = new ArticleFileManager($submission->getArticleId());
					$articleFileManager->deleteFile($imageFile->getFileId());
				}
			}
			unset($images);
		}
	}

	/**
	 * Add Submission Note
	 * @param $articleId int
	 */
	function addSubmissionNote($articleId) {
		import('classes.file.ArticleFileManager');

		$noteDao =& DAORegistry::getDAO('NoteDAO');
		$user =& Request::getUser();
		$journal =& Request::getJournal();

		$note = $noteDao->newDataObject();
		$note->setAssocType(ASSOC_TYPE_ARTICLE);
		$note->setAssocId($articleId);
		$note->setUserId($user->getId());
		$note->setContextId($journal->getId());
		$note->setDateCreated(Core::getCurrentDate());
		$note->setDateModified(Core::getCurrentDate());
		$note->setTitle(Request::getUserVar('title'));
		$note->setContents(Request::getUserVar('note'));

		if (!HookRegistry::call('SectionEditorAction::addSubmissionNote', array(&$articleId, &$note))) {
			$articleFileManager = new ArticleFileManager($articleId);
			if ($articleFileManager->uploadedFileExists('upload')) {
				$fileId = $articleFileManager->uploadSubmissionNoteFile('upload');
			} else {
				$fileId = 0;
			}

			$note->setFileId($fileId);

			$noteDao->insertObject($note);
		}
	}

	/**
	 * Remove Submission Note
	 * @param $articleId int
	 */
	function removeSubmissionNote($articleId) {
		$noteId = Request::getUserVar('noteId');
		$fileId = Request::getUserVar('fileId');

		if (HookRegistry::call('SectionEditorAction::removeSubmissionNote', array(&$articleId, &$noteId, &$fileId))) return;

		// if there is an attached file, remove it as well
		if ($fileId) {
			import('classes.file.ArticleFileManager');
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteFile($fileId);
		}

		$noteDao =& DAORegistry::getDAO('NoteDAO');
		$noteDao->deleteById($noteId);
	}

	/**
	 * Updates Submission Note
	 * @param $articleId int
	 */
	function updateSubmissionNote($articleId) {
		import('classes.file.ArticleFileManager');

		$noteDao =& DAORegistry::getDAO('NoteDAO');

		$user =& Request::getUser();
		$journal =& Request::getJournal();

		$note = new Note();
		$note->setId(Request::getUserVar('noteId'));
		$note->setAssocType(ASSOC_TYPE_ARTICLE);
		$note->setAssocId($articleId);
		$note->setUserId($user->getId());
		$note->setDateModified(Core::getCurrentDate());
		$note->setContextId($journal->getId());
		$note->setTitle(Request::getUserVar('title'));
		$note->setContents(Request::getUserVar('note'));
		$note->setFileId(Request::getUserVar('fileId'));

		if (HookRegistry::call('SectionEditorAction::updateSubmissionNote', array(&$articleId, &$note))) return;

		$articleFileManager = new ArticleFileManager($articleId);

		// if there is a new file being uploaded
		if ($articleFileManager->uploadedFileExists('upload')) {
			// Attach the new file to the note, overwriting existing file if necessary
			$fileId = $articleFileManager->uploadSubmissionNoteFile('upload', $note->getFileId(), true);
			$note->setFileId($fileId);

		} else {
			if (Request::getUserVar('removeUploadedFile')) {
				$articleFileManager = new ArticleFileManager($articleId);
				$articleFileManager->deleteFile($note->getFileId());
				$note->setFileId(0);
			}
		}

		$noteDao->updateObject($note);
	}

	/**
	 * Clear All Submission Notes
	 * @param $articleId int
	 */
	function clearAllSubmissionNotes($articleId) {
		if (HookRegistry::call('SectionEditorAction::clearAllSubmissionNotes', array(&$articleId))) return;

		import('classes.file.ArticleFileManager');

		$noteDao =& DAORegistry::getDAO('NoteDAO');

		$fileIds = $noteDao->getAllFileIds(ASSOC_TYPE_ARTICLE, $articleId);

		if (!empty($fileIds)) {
			$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
			$articleFileManager = new ArticleFileManager($articleId);

			foreach ($fileIds as $fileId) {
				$articleFileManager->deleteFile($fileId);
			}
		}

		$noteDao->deleteByAssoc(ASSOC_TYPE_ARTICLE, $articleId);

	}

	//
	// Comments
	//

	/**
	 * View reviewer comments.
	 * @param $article object
	 * @param $reviewId int
	 */
	function viewPeerReviewComments(&$article, $reviewId) {
		if (HookRegistry::call('SectionEditorAction::viewPeerReviewComments', array(&$article, &$reviewId))) return;

		import('classes.submission.form.comment.PeerReviewCommentForm');

		$commentForm = new PeerReviewCommentForm($article, $reviewId, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->initData();
		$commentForm->display();
	}

	/**
	 * Post reviewer comments.
	 * @param $article object
	 * @param $reviewId int
	 * @param $emailComment boolean
	 */
	function postPeerReviewComment(&$article, $reviewId, $emailComment) {
		if (HookRegistry::call('SectionEditorAction::postPeerReviewComment', array(&$article, &$reviewId, &$emailComment))) return;

		$user =& Request::getUser();
		
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
		
		import('classes.submission.form.comment.PeerReviewCommentForm');

		$commentForm = new PeerReviewCommentForm($article, $reviewId, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->readInputData();

		if ($commentForm->validate()) {
			$commentForm->execute();

			// Send a notification to associated users (if exist, other secretaries of the committees and the concerned reviewer)
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(false, true);
                foreach ($notificationUsers as $userRole) {
            	$param = $article->getProposalId().':<br/>'.$user->getUsername().' commented ';
            	if ($userRole['role'] == 'sectionEditor') {
            		$param = $param.'the review of '.$reviewer->getUsername();
            		$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'peerReview');
            	} else {
            		$url = Request::url(null, $userRole['role'], 'submission', $reviewId);
            		$param = $param.'your review';
            	}
                if (($userRole['role'] == 'sectionEditor' && $user->getId()!=$userRole['id']) || ($userRole['role'] == 'reviewer' && $reviewer->getId()==$userRole['id'])) $notificationManager->createNotification(
                	$userRole['id'], 'notification.type.reviewerComment',
                	$param, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
                );
                
			}

			if ($emailComment) {
				$commentForm->email();
			}

		} else {
			$commentForm->display();
			return false;
		}
		return true;
	}

	/**
	 * View editor decision comments.
	 * @param $article object
	 */
	function viewEditorDecisionComments($article) {
		if (HookRegistry::call('SectionEditorAction::viewEditorDecisionComments', array(&$article))) return;

		import('classes.submission.form.comment.EditorDecisionCommentForm');

		$commentForm = new EditorDecisionCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->initData();
		$commentForm->display();
	}

	/**
	 * Post editor decision comment.
	 * @param $article int
	 * @param $emailComment boolean
	 */
	function postEditorDecisionComment($article, $emailComment) {
		if (HookRegistry::call('SectionEditorAction::postEditorDecisionComment', array(&$article, &$emailComment))) return;
		
		$user =& Request::getUser();
		
		import('classes.submission.form.comment.EditorDecisionCommentForm');
		
		$commentForm = new EditorDecisionCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->readInputData();

		if ($commentForm->validate()) {
			$commentForm->execute();

			// Send a notification to associated users 
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(true, false);
			$param = $article->getProposalId().': <br/>'.$user->getFullName().', <i>'.$user->getErcFunction($article->getSectionId()).'</i>,';
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'editorDecision');
				if ($user->getId()!=$userRole['id']) $notificationManager->createNotification(
					$userRole['id'], 'notification.type.editorDecisionComment',
					$param, $url, 1, NOTIFICATION_TYPE_SECTION_DECISION_COMMENT
				);
			}

			if ($emailComment) {
				$commentForm->email();
			}
		} else {
			$commentForm->display();
			return false;
		}
		return true;
	}

	/**
	 * Email editor decision comment
	 * @param $sectionEditorSubmission object
	 * @param $send boolean
	 */
	function emailEditorDecisionComment($sectionEditorSubmission, $send) {
		$userDao =& DAORegistry::getDAO('UserDAO');
		$articleCommentDao =& DAORegistry::getDAO('ArticleCommentDAO');
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

		$journal =& Request::getJournal();

		$user =& Request::getUser();
		import('classes.mail.ArticleMailTemplate');

		$decisionTemplateMap = array(
		SUBMISSION_SECTION_DECISION_APPROVED => 'SECTION_DECISION_APPROVED',
		SUBMISSION_SECTION_DECISION_RESUBMIT => 'SECTION_DECISION_RESUBMIT',
		SUBMISSION_SECTION_DECISION_INCOMPLETE => 'SECTION_DECISION_INCOMPLETE',
		SUBMISSION_SECTION_DECISION_DECLINED => 'SECTION_DECISION_DECLINE',
		SUBMISSION_SECTION_DECISION_EXEMPTED => 'SECTION_DECISION_EXEMPT'
		);

		$decision = $sectionEditorSubmission->getLastSectionDecision();
		
                if ($decision->getDecision() == SUBMISSION_SECTION_DECISION_APPROVED && $decision->getReviewType() == REVIEW_TYPE_FR) {
                    $email = new ArticleMailTemplate(
                        $sectionEditorSubmission, null, 
                        'SECTION_DECISION_FR_APPROVED'
                    );                    
                } elseif ($decision->getDecision() == SUBMISSION_SECTION_DECISION_EXEMPTED && $decision->getComments() == null) {
                    return true;
                }else {
                    $email = new ArticleMailTemplate(
                        $sectionEditorSubmission, null, 
                        isset($decisionTemplateMap[$decision->getDecision()])?$decisionTemplateMap[$decision->getDecision()]:null
                    );
                }

		$copyeditor = $sectionEditorSubmission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL');

		if ($send && !$email->hasErrors()) {
			HookRegistry::call('SectionEditorAction::emailEditorDecisionComment', array(&$sectionEditorSubmission, &$send));
			$email->send();

			$articleComment = new ArticleComment();
			$articleComment->setCommentType(COMMENT_TYPE_SECTION_DECISION);
			$articleComment->setRoleId(Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
			$articleComment->setArticleId($sectionEditorSubmission->getArticleId());
			$articleComment->setAuthorId($user->getUserId());
			$articleComment->setCommentTitle($email->getSubject());
			$articleComment->setComments($email->getBody());
			$articleComment->setDatePosted(Core::getCurrentDate());
			$articleComment->setViewable(true);
			$articleComment->setAssocId($sectionEditorSubmission->getArticleId());
			$articleCommentDao->insertArticleComment($articleComment);

			return true;
		} else {
			if (!Request::getUserVar('continued')) {
				$authorUser =& $userDao->getUser($sectionEditorSubmission->getUserId());
				$authorEmail = $authorUser->getEmail();
				$email->assignParams(array(
					'editorialContactSignature' => $user->getContactSignature(),
					'authorName' => $authorUser->getFullName(),
					'urlOngoing' => Request::url(null, 'author', 'index', 'ongoingResearches'),
    					'urlDrafts' => Request::url(null, 'author', 'index', 'proposalsToSubmit'),
    					'url' => Request::url(null, 'author', 'submissionReview', $sectionEditorSubmission->getArticleId()),
                                        'reviewType' => Locale::translate($decision->getReviewTypeKey()),
					'journalTitle' => $journal->getLocalizedTitle()
				));
				$email->addRecipient($authorEmail, $authorUser->getFullName());
				if ($journal->getSetting('notifyAllAuthorsOnDecision')) foreach ($sectionEditorSubmission->getAuthors() as $author) {
					if ($author->getEmail() != $authorEmail) {
						$email->addCc ($author->getEmail(), $author->getFullName());
					}
				}
                                import('classes.file.TemporaryFileManager');
                                $temporaryFileManager = new TemporaryFileManager();
                                $decisionFiles =& $decision->getDecisionFiles();
                                foreach ($decisionFiles as $file) {
                                    if ($file) {
                                            $temporaryFile = $temporaryFileManager->articleToTemporaryFile($file, $user->getId());
                                            $email->addPersistAttachment($temporaryFile);
                                    }    
                                }

			} elseif (Request::getUserVar('importPeerReviews')) {
				$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
				$reviewAssignments =& $reviewAssignmentDao->getByDecisionId($sectionEditorSubmission->getLastSectionDecisionId());
				$reviewIndexes =& $reviewAssignmentDao->getReviewIndexesForDecision($sectionEditorSubmission->getLastSectionDecisionId());

				$body = '';
				foreach ($reviewAssignments as $reviewAssignment) {
					// If the reviewer has completed the assignment, then import the review.
					if ($reviewAssignment->getDateCompleted() != null && !$reviewAssignment->getCancelled()) {
						// Get the comments associated with this review assignment
						$articleComments =& $articleCommentDao->getArticleComments($sectionEditorSubmission->getArticleId(), COMMENT_TYPE_PEER_REVIEW, $reviewAssignment->getId());
						if($articleComments) {
							$body .= "------------------------------------------------------\n";
							$body .= Locale::translate('submission.comments.importPeerReviews.reviewerLetter', array('reviewerLetter' => chr(ord('A') + $reviewIndexes[$reviewAssignment->getId()]))) . "\n";
							if (is_array($articleComments)) {
								foreach ($articleComments as $comment) {
									// If the comment is viewable by the author, then add the comment.
									if ($comment->getViewable()) $body .= String::html2text($comment->getComments()) . "\n\n";
								}
							}
							$body .= "------------------------------------------------------\n\n";
						}
						if ($reviewFormId = $reviewAssignment->getReviewFormId()) {
							$reviewId = $reviewAssignment->getId();
							$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
							$reviewFormElementDao =& DAORegistry::getDAO('ReviewFormElementDAO');
							$reviewFormElements =& $reviewFormElementDao->getReviewFormElements($reviewFormId);
							if(!$articleComments) {
								$body .= "------------------------------------------------------\n";
								$body .= Locale::translate('submission.comments.importPeerReviews.reviewerLetter', array('reviewerLetter' => chr(ord('A') + $reviewIndexes[$reviewAssignment->getId()]))) . "\n\n";
							}
							foreach ($reviewFormElements as $reviewFormElement) if ($reviewFormElement->getIncluded()) {
								$body .= String::html2text($reviewFormElement->getLocalizedQuestion()) . ": \n";
								$reviewFormResponse = $reviewFormResponseDao->getReviewFormResponse($reviewId, $reviewFormElement->getId());

								if ($reviewFormResponse) {
									$possibleResponses = $reviewFormElement->getLocalizedPossibleResponses();
									if (in_array($reviewFormElement->getElementType(), $reviewFormElement->getMultipleResponsesElementTypes())) {
										if ($reviewFormElement->getElementType() == REVIEW_FORM_ELEMENT_TYPE_CHECKBOXES) {
											foreach ($reviewFormResponse->getValue() as $value) {
												$body .= "\t" . String::html2text($possibleResponses[$value-1]['content']) . "\n";
											}
										} else {
											$body .= "\t" . String::html2text($possibleResponses[$reviewFormResponse->getValue()-1]['content']) . "\n";
										}
										$body .= "\n";
									} else {
										$body .= "\t" . String::html2text($reviewFormResponse->getValue()) . "\n\n";
									}
								}
							}
							$body .= "------------------------------------------------------\n\n";
						}
					}
				}
				$oldBody = $email->getBody();
				if (!empty($oldBody)) $oldBody .= "\n";
				$email->setBody($oldBody . $body);
			}

			$email->displayEditForm(Request::url(null, null, 'emailEditorDecisionComment', 'send'), array('articleId' => $sectionEditorSubmission->getArticleId()), 'submission/comment/editorDecisionEmail.tpl', array('isAnEditor' => true));

			return false;
		}
	}


	/**
	 * Blind CC the reviews to reviewers.
	 * @param $article object
	 * @param $send boolean
	 * @param $inhibitExistingEmail boolean
	 * @return boolean true iff ready for redirect
	 */
	function blindCcReviewsToReviewers($article, $send = false, $inhibitExistingEmail = false) {
		$commentDao =& DAORegistry::getDAO('ArticleCommentDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$journal =& Request::getJournal();

		$comments =& $commentDao->getArticleComments($article->getId(), COMMENT_TYPE_SECTION_DECISION);
		$reviewAssignments =& $reviewAssignmentDao->getByDecisionId($article->getLastSectionDecisionId());

		$commentsText = "";
		foreach ($comments as $comment) {
			$commentsText .= String::html2text($comment->getComments()) . "\n\n";
		}

		$user =& Request::getUser();
		import('classes.mail.ArticleMailTemplate');
		$email = new ArticleMailTemplate($article, null, 'SUBMISSION_DECISION_REVIEWERS');

		if ($send && !$email->hasErrors() && !$inhibitExistingEmail) {
			HookRegistry::call('SectionEditorAction::blindCcReviewsToReviewers', array(&$article, &$reviewAssignments, &$email));
			$email->send();
			return true;
		} else {
			if ($inhibitExistingEmail || !Request::getUserVar('continued')) {
				$email->clearRecipients();
				foreach ($reviewAssignments as $reviewAssignment) {
					if ($reviewAssignment->getDateCompleted() != null && !$reviewAssignment->getCancelled()) {
						$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());

						if (isset($reviewer)) $email->addBcc($reviewer->getEmail(), $reviewer->getFullName());
					}
				}

				$paramArray = array(
					'comments' => $commentsText,
					'editorialContactSignature' => $user->getContactSignature()
				);
				$email->assignParams($paramArray);
			}

			$email->displayEditForm(Request::url(null, null, 'blindCcReviewsToReviewers'), array('articleId' => $article->getId()));
			return false;
		}
	}

	/**
	 * View copyedit comments.
	 * @param $article object
	 */
	function viewCopyeditComments($article) {
		if (HookRegistry::call('SectionEditorAction::viewCopyeditComments', array(&$article))) return;

		import('classes.submission.form.comment.CopyeditCommentForm');

		$commentForm = new CopyeditCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->initData();
		$commentForm->display();
	}

	/**
	 * Post copyedit comment.
	 * @param $article object
	 * @param $emailComment boolean
	 */
	function postCopyeditComment($article, $emailComment) {
		if (HookRegistry::call('SectionEditorAction::postCopyeditComment', array(&$article, &$emailComment))) return;

		import('classes.submission.form.comment.CopyeditCommentForm');

		$commentForm = new CopyeditCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->readInputData();

		if ($commentForm->validate()) {
			$commentForm->execute();

			// Send a notification to associated users
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(true, false);
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionEditing', $article->getId(), null, 'copyedit');
				$notificationManager->createNotification(
				$userRole['id'], 'notification.type.copyeditComment',
				$article->getProposalId(), $url, 1, NOTIFICATION_TYPE_COPYEDIT_COMMENT
				);
			}

			if ($emailComment) {
				$commentForm->email();
			}

		} else {
			$commentForm->display();
			return false;
		}
		return true;
	}

	/**
	 * View layout comments.
	 * @param $article object
	 */
	function viewLayoutComments($article) {
		if (HookRegistry::call('SectionEditorAction::viewLayoutComments', array(&$article))) return;

		import('classes.submission.form.comment.LayoutCommentForm');

		$commentForm = new LayoutCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->initData();
		$commentForm->display();
	}

	/**
	 * Post layout comment.
	 * @param $article object
	 * @param $emailComment boolean
	 */
	function postLayoutComment($article, $emailComment) {
		if (HookRegistry::call('SectionEditorAction::postLayoutComment', array(&$article, &$emailComment))) return;

		import('classes.submission.form.comment.LayoutCommentForm');

		$commentForm = new LayoutCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->readInputData();

		if ($commentForm->validate()) {
			$commentForm->execute();

			// Send a notification to associated users
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(true, false);
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionEditing', $article->getId(), null, 'layout');
				$notificationManager->createNotification(
				$userRole['id'], 'notification.type.layoutComment',
				$article->getProposalId(), $url, 1, NOTIFICATION_TYPE_LAYOUT_COMMENT
				);
			}

			if ($emailComment) {
				$commentForm->email();
			}

		} else {
			$commentForm->display();
			return false;
		}
		return true;
	}

	/**
	 * View proofread comments.
	 * @param $article object
	 */
	function viewProofreadComments($article) {
		if (HookRegistry::call('SectionEditorAction::viewProofreadComments', array(&$article))) return;

		import('classes.submission.form.comment.ProofreadCommentForm');

		$commentForm = new ProofreadCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->initData();
		$commentForm->display();
	}

	/**
	 * Post proofread comment.
	 * @param $article object
	 * @param $emailComment boolean
	 */
	function postProofreadComment($article, $emailComment) {
		if (HookRegistry::call('SectionEditorAction::postProofreadComment', array(&$article, &$emailComment))) return;

		import('classes.submission.form.comment.ProofreadCommentForm');

		$commentForm = new ProofreadCommentForm($article, Validation::isEditor()?ROLE_ID_EDITOR:ROLE_ID_SECTION_EDITOR);
		$commentForm->readInputData();

		if ($commentForm->validate()) {
			$commentForm->execute();

			// Send a notification to associated users
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(true, false);
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionEditing', $article->getId(), null, 'proofread');
				$notificationManager->createNotification(
				$userRole['id'], 'notification.type.proofreadComment',
				$article->getProposalId(), $url, 1, NOTIFICATION_TYPE_PROOFREAD_COMMENT
				);
			}

			if ($emailComment) {
				$commentForm->email();
			}

		} else {
			$commentForm->display();
			return false;
		}
		return true;
	}

	/**
	 * Confirms the review assignment on behalf of its reviewer.
	 * @param $reviewId int
	 * @param $accept boolean True === accept; false === decline
	 */
	function confirmReviewForReviewer($reviewId, $accept) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
		$user =& Request::getUser();
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId(), true);

		if (HookRegistry::call('SectionEditorAction::acceptReviewForReviewer', array(&$reviewAssignment, &$reviewer, &$accept))) return;

		// Only confirm the review for the reviewer if
		// he has not previously done so.
		if ($reviewAssignment->getDateConfirmed() == null) {
			$reviewAssignment->setDeclined($accept?0:1);
			$reviewAssignment->setDateConfirmed(Core::getCurrentDate());
			$reviewAssignment->stampModified();
			
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

			//Send a notification to reviewer
			import('lib.pkp.classes.notification.NotificationManager');
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($sectionDecision->getArticleId());
			$notificationManager = new NotificationManager();
			if ($accept == 1) $message = $article->getProposalId().':<br/>'.$user->getUsername().' confirmed your ability';
			else $message = $article->getProposalId().':<br/>'.$user->getUsername().' confirmed your inability';
			$url = Request::url(null, 'reviewer', 'submission', $reviewAssignment->getId());
            $notificationManager->createNotification(
            		$reviewAssignment->getReviewerId(), 'notification.type.reviewConfirmedBySecretary',
                	$message, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
            );
            
			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			$entry = new ArticleEventLogEntry();
			$entry->setArticleId($sectionDecision->getArticleId());
			$entry->setUserId($user->getId());
			$entry->setDateLogged(Core::getCurrentDate());
			$entry->setEventType(ARTICLE_LOG_REVIEW_CONFIRM_BY_PROXY);
			$entry->setLogMessage($accept?'log.review.reviewAcceptedByProxy':'log.review.reviewDeclinedByProxy', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $article->getProposalId(), 'userName' => $user->getFullName()));
			$entry->setAssocType(ARTICLE_LOG_TYPE_REVIEW);
			$entry->setAssocId($reviewAssignment->getId());

			ArticleLog::logEventEntry($sectionDecision->getArticleId(), $entry);
		}
	}

	/**
	 * Upload a review on behalf of its reviewer.
	 * @param $reviewId int
	 */
	function uploadReviewForReviewer($reviewId) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		
		$user =& Request::getUser();
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$article =& $articleDao->getArticle($sectionDecision->getArticleId());
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId(), true);

		if (HookRegistry::call('SectionEditorAction::uploadReviewForReviewer', array(&$reviewAssignment, &$reviewer))) return;

		// Upload the review file.
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($sectionDecision->getArticleId());
		// Only upload the file if the reviewer has yet to submit a recommendation
		if (($reviewAssignment->getRecommendation() === null || $reviewAssignment->getRecommendation() === '') && !$reviewAssignment->getCancelled()) {
			$fileName = 'upload';
			if ($articleFileManager->uploadedFileExists($fileName)) {
                            
				// Check if file already uploaded
				$reviewFile =& $reviewAssignment->getReviewerFile();
				if ($reviewFile != null) {
					$articleFileManager->deleteFile($reviewFile->getFileId());
				}
                            
				if ($reviewAssignment->getReviewerFileId() != null) {
					$fileId = $articleFileManager->uploadReviewFile($fileName, $reviewAssignment->getDecisionId(), $reviewAssignment->getReviewerFileId());
				} else {
					$fileId = $articleFileManager->uploadReviewFile($fileName, $reviewAssignment->getDecisionId());
				}
			}
		}

		if (isset($fileId) && $fileId != 0) {
			// Only confirm the review for the reviewer if
			// he has not previously done so.
			if ($reviewAssignment->getDateConfirmed() == null) {
				$reviewAssignment->setDeclined(0);
				$reviewAssignment->setDateConfirmed(Core::getCurrentDate());
			}

			$reviewAssignment->setReviewerFileId($fileId);
			$reviewAssignment->stampModified();
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');
			Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON));
			$entry = new ArticleEventLogEntry();
			$entry->setArticleId($sectionDecision->getArticleId());
			$entry->setUserId($user->getId());
			$entry->setDateLogged(Core::getCurrentDate());
			$entry->setEventType(ARTICLE_LOG_REVIEW_FILE_BY_PROXY);
			$entry->setLogMessage('log.review.reviewFileByProxy', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $article->getProposalId(), 'userName' => $user->getFullName()));
			$entry->setAssocType(ARTICLE_LOG_TYPE_REVIEW);
			$entry->setAssocId($reviewAssignment->getId());

			ArticleLog::logEventEntry($sectionDecision->getArticleId(), $entry);
		}
	}

	/**
	 * Helper method for building submission breadcrumb
	 * @param $articleId
	 * @param $parentPage name of submission component
	 * @return array
	 * Last modified EL on February 22th 2013
	 */
	function submissionBreadcrumb($articleId, $parentPage, $section) {
		$breadcrumb = array();

		
		if ($articleId) {
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($articleId);
			$proposalId = $article->getProposalId();
			$breadcrumb[] = array(Request::url(null, $section, 'submission', $articleId), "$proposalId", true);
		}

		if ($parentPage) {
			switch($parentPage) {
				case 'summary':
					$parent = array(Request::url(null, $section, 'submission', $articleId), 'submission.summary');
					break;
				case 'review':
					$parent = array(Request::url(null, $section, 'submissionReview', $articleId), 'submission.review');
					break;
				case 'editing':
					$parent = array(Request::url(null, $section, 'submissionEditing', $articleId), 'submission.editing');
					break;
				case 'history':
					$parent = array(Request::url(null, $section, 'submissionHistory', $articleId), 'submission.history');
					break;
			}
			if ($section != 'editor' && $section != 'sectionEditor') {
				$parent[0] = Request::url(null, $section, 'submission', $articleId);
			}
			$breadcrumb[] = $parent;
		}
		return $breadcrumb;
	}
	
	function uploadDecisionFile($articleId, $fileName, $decisionId) {
		$journal =& Request::getJournal();
		$this->validate($articleId);

		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($articleId);		
		
                // Upload file, if file selected.
		if ($articleFileManager->uploadedFileExists($fileName)) {
			$fileId = $articleFileManager->uploadDecisionFile($fileName, $decisionId);
			return $fileId;	
		} else {
			$fileId = 0;
			return $fileId; 
		}

	}
        
        
        function automaticSummaryInPDF($sectionEditorSubmission){

                $this->validate($sectionEditorSubmission->getId());
		$journal =& Request::getJournal();
		Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_PKP_USER));
                
                import('classes.lib.tcpdf.pdf');
                import('classes.lib.tcpdf.tcpdf');

                
                $pdf = new PDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
                                                
                $pdf->SetCreator(PDF_CREATOR);
                
                $submitter =& $sectionEditorSubmission->getUser();
                $pdf->SetAuthor($submitter->getFullName());
                
                $pdf->SetTitle($journal->getJournalTitle());
                
                $pdf->SetSubject($sectionEditorSubmission->getProposalId().' - '.Locale::translate('submission.summary'));                
                
                //$pdf->SetKeywords('TCPDF, PDF, example, tutorial');

                $cell_width = 45;
                $cell_height = 6;
                
                // set default header data
                $pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE.' 020', PDF_HEADER_STRING);

                // set header and footer fonts
                $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
                $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

                // set default monospaced font
                $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

                // set margins
                $pdf->SetMargins(PDF_MARGIN_LEFT, 58, PDF_MARGIN_RIGHT);
                $pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
                $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

                // set auto page breaks
                $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

                // set image scale factor
                $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
                
                $pdf->AddPage();
                $pdf->SetFont('dejavusans','B',13);
                $pdf->MultiCell(0,6,Locale::translate("article.authors"), 0, 'L');
                
                // Investigator(s)
                
                $authors = $sectionEditorSubmission->getAuthors();
                
                $pdf->ln();
                
                foreach ($authors as $author) {
                    if ($author->getPrimaryContact()) {
                        
                        $pdf->SetFont('dejavusans','BI',11);
                        $pdf->MultiCell(0,6,Locale::translate("user.role.primaryInvestigator"), 0, 'L');
                        $pdf->ln();
                        
                        $pdf->SetFont('dejavusans','',11);
                        $pdf->MultiRow($cell_width, Locale::translate('user.name').': ', $author->getFullName());
                        $pdf->MultiRow($cell_width, Locale::translate('user.affiliation').': ', $author->getAffiliation());
                        $pdf->MultiRow($cell_width, Locale::translate('user.email').': ', $author->getEmail());
                        $pdf->MultiRow($cell_width, Locale::translate('user.tel').': ', $author->getPhoneNumber());                      
                        $pdf->ln();
                    }     
                }
                
                $countCoInvestigator = (int) 0;
                foreach ($authors as $author) {
                    if (!$author->getPrimaryContact()) {
                        if ($countCoInvestigator == 0) {
                            $pdf->SetFont('dejavusans','BI',11);
                            $pdf->MultiCell(0,$cell_height,Locale::translate("user.role.coinvestigator"), 0, 'L');
                            $pdf->ln();
                        }
                        
                        $pdf->SetFont('dejavusans','',11);
                        $pdf->MultiRow($cell_width, Locale::translate('user.name').': ', $author->getFullName());
                        $pdf->MultiRow($cell_width, Locale::translate('user.affiliation').': ', $author->getAffiliation());
                        $pdf->MultiRow($cell_width, Locale::translate('user.email').': ', $author->getEmail());
                        $pdf->MultiRow($cell_width, Locale::translate('user.tel').': ', $author->getPhoneNumber());                      
                        $pdf->ln();

                        $countCoInvestigator++;
                    }
                }
                
                
                // Title and abstracts
                
                $pdf->SetFont('dejavusans','B',13);
                $pdf->MultiCell(0,$cell_height,Locale::translate("submission.titleAndAbstract"), 0, 'L');                
                                
                $pdf->ln();

                $abstractLocales = $journal->getSupportedLocaleNames();
                $abstracts = $sectionEditorSubmission->getAbstracts();
                
                foreach ($abstractLocales as $localeKey => $localeName){
                    
                    $abstract = $abstracts[$localeKey];
                    
                    $pdf->SetFont('dejavusans','BI',11);
                    
                    $pdf->MultiCell(0,$cell_height,$localeName, 0, 'L');  
                                    
                    $pdf->ln();

                    $pdf->SetFont('dejavusans','',11);
                    
                    $pdf->MultiRow($cell_width, Locale::translate('proposal.scientificTitle').': ', $abstract->getScientificTitle());
                    $pdf->MultiRow($cell_width, Locale::translate('proposal.publicTitle').': ', $abstract->getPublicTitle());
                    $pdf->ln();
                    
                    $pdf->MultiRow($cell_width, Locale::translate('proposal.abstract').': ', $abstract->getBackground()." \n\n", 'J');
                    $pdf->MultiRow($cell_width, ' ', $abstract->getObjectives()." \n\n", 'J');
                    $pdf->MultiRow($cell_width, ' ', $abstract->getStudyMethods()." \n\n", 'J');
                    $pdf->MultiRow($cell_width, ' ', $abstract->getExpectedOutcomes()." \n\n", 'J');
                    
                    $pdf->MultiRow($cell_width, Locale::translate('proposal.keywords').': ', $abstract->getKeywords());
                    $pdf->ln();
                    
                }
                
                // Proposal Details
                
                $pdf->SetFont('dejavusans','B',13);
                $pdf->MultiCell(0,$cell_height,Locale::translate("submission.proposalDetails"), 0, 'L');
                $pdf->Ln();

                $proposalDetails = $sectionEditorSubmission->getProposalDetails();
                
                $pdf->SetFont('dejavusans','',11);
                
                $pdf->MultiRow($cell_width, Locale::translate('proposal.studentInitiatedResearch').': ', Locale::translate($proposalDetails->getYesNoKey($proposalDetails->getStudentResearch())));
                if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES){
                    $studentResearch = $proposalDetails->getStudentResearchInfo();
                    
                    $pdf->MultiRow3Columns($cell_width, $cell_width, ' ', Locale::translate('proposal.studentInstitution').': ', $studentResearch->getInstitution());
                    $pdf->MultiRow3Columns($cell_width, $cell_width, ' ', Locale::translate('proposal.academicDegree').': ', Locale::translate($studentResearch->getDegreeKey()));
                    $pdf->SetFont('dejavusans','I',11);
                    $pdf->MultiRow($cell_width, ' ', Locale::translate('proposal.studentSupervisor').': ');
                    $pdf->SetFont('dejavusans','',11);
                    $pdf->MultiRow3Columns($cell_width, $cell_width, ' ', Locale::translate('proposal.studentSupervisorName').': ', $studentResearch->getSupervisorName());
                    $pdf->MultiRow3Columns($cell_width, $cell_width, ' ', Locale::translate('user.email').': ', $studentResearch->getSupervisorEmail());
                }
                $pdf->ln();
                
                $startDate = DateTime::createFromFormat('d-M-Y', $proposalDetails->getStartDate());
                $pdf->MultiRow($cell_width, Locale::translate('proposal.startDate').': ', $startDate->format('l d F Y'));
                $endDate = DateTime::createFromFormat('d-M-Y', $proposalDetails->getEndDate());
                $pdf->MultiRow($cell_width, Locale::translate('proposal.endDate').': ', $endDate->format('l d F Y'));
                $pdf->ln();
                
                $pdf->MultiRow($cell_width, Locale::translate('proposal.keyImplInstitution').': ', $proposalDetails->getKeyImplInstitutionName());
                $pdf->ln();
                
                $pdf->MultiRow($cell_width, Locale::translate('proposal.multiCountryResearch').': ', Locale::translate($proposalDetails->getYesNoKey($proposalDetails->getMultiCountryResearch())));
                if ($proposalDetails->getMultiCountryResearch() == PROPOSAL_DETAIL_YES) $pdf->MultiRow($cell_width, ' ', $proposalDetails->getLocalizedMultiCountryText());
                $pdf->ln();

                $pdf->MultiRow($cell_width, Locale::translate('proposal.nationwide').': ', Locale::translate($proposalDetails->getNationwideKey()));
		if ($proposalDetails->getNationwide() == PROPOSAL_DETAIL_NO || $proposalDetails->getNationwide() == PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS) $pdf->MultiRow($cell_width, ' ', $proposalDetails->getLocalizedGeoAreasText());
                $pdf->ln();

                $pdf->MultiRow($cell_width, Locale::translate('proposal.proposal.researchDomains').': ', $proposalDetails->getLocalizedResearchDomainsText());
                $pdf->ln();

                $pdf->MultiRow($cell_width, Locale::translate('proposal.researchField').': ', $proposalDetails->getLocalizedResearchFieldText());
                $pdf->ln();

                $pdf->MultiRow($cell_width, Locale::translate('proposal.withHumanSubjects').': ', Locale::translate($proposalDetails->getYesNoKey($proposalDetails->getHumanSubjects())));
		if ($proposalDetails->getHumanSubjects() == PROPOSAL_DETAIL_YES) $pdf->MultiRow($cell_width, Locale::translate('proposal.proposalType').': ', $proposalDetails->getLocalizedProposalTypeText());
                $pdf->ln();

                $pdf->MultiRow($cell_width, Locale::translate('proposal.dataCollection').': ', Locale::translate($proposalDetails->getDataCollectionKey()));
                $pdf->ln();

                $pdf->MultiRow($cell_width, Locale::translate('proposal.reviewedByOtherErc').': ', Locale::translate($proposalDetails->getCommitteeReviewedKey()));
                $pdf->ln();                
                
                
                // Source(s) of Monetary and Material Support
                $pdf->SetFont('dejavusans','B',13);
                $pdf->MultiCell(0,$cell_height,Locale::translate("proposal.sourceOfMonetary"), 0, 'L');                        
                $pdf->ln();
                
                $sources =& $sectionEditorSubmission->getSources();
		$currencyDao =& DAORegistry::getDAO('CurrencyDAO');
                $sourceCurrencyId = $journal->getSetting('sourceCurrency');
                $sourceCurrency = $currencyDao->getCurrencyByAlphaCode($sourceCurrencyId);
                $cell_width_source = 70;
                
                $pdf->SetFont('dejavusans','',11);
                foreach($sources as $source){
                    $pdf->MultiRow($cell_width_source, $source->getSourceInstitutionName(), $source->getSourceAmountString().' '.$sourceCurrency->getCodeAlpha());
                    $pdf->ln();
                }
                $pdf->ln();
                
                $pdf->SetFont('dejavusans','BI',11);
                $pdf->MultiRow($cell_width_source, Locale::translate('proposal.fundsRequired').': ', $sectionEditorSubmission->getTotalBudgetString().' '.$sourceCurrency->getName().' ('.$sourceCurrency->getCodeAlpha().')');
                $pdf->ln();
                        
                
                // Risk Assessment
                $pdf->SetFont('dejavusans','B',13);
                $pdf->MultiCell(0,$cell_height,Locale::translate("proposal.riskAssessment"), 0, 'L');                        
                $pdf->ln();
                
                $riskAssessment = $sectionEditorSubmission->getRiskAssessment();
                $cell_width_risk_assessment = 90;
                
                $pdf->SetFont('dejavusans','BI',11);
                $pdf->MultiCell(0,$cell_height, Locale::translate('proposal.researchIncludesHumanSubject'), 0, 'L');  
                $pdf->ln();
                
                $pdf->SetFont('dejavusans','',11);
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.identityRevealed'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getIdentityRevealed())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.unableToConsent'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getUnableToConsent())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.under18'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getUnder18())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.dependentRelationship'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getDependentRelationship())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.ethnicMinority'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getEthnicMinority())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.impairment'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getImpairment())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.pregnant'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getPregnant())));
                $pdf->ln();

                $pdf->SetFont('dejavusans','BI',11);
                $pdf->MultiCell(0,$cell_height, Locale::translate('proposal.researchIncludes'), 0, 'L');  
                $pdf->ln();
                
                $pdf->SetFont('dejavusans','',11);
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.newTreatment'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getNewTreatment())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.bioSamples'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getBioSamples())));
                if ($riskAssessment->getBioSamples() == RISK_ASSESSMENT_YES){
                    $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.exportHumanTissue'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getExportHumanTissue())));
                    if ($riskAssessment->getExportHumanTissue() == RISK_ASSESSMENT_YES){
                        $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.exportReason'), Locale::translate($riskAssessment->getExportReasonKey()));
                    }
                }
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.radiation'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getRadiation())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.distress'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getDistress())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.inducements'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getInducements())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.sensitiveInfo'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getSensitiveInfo())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.reproTechnology'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getReproTechnology())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.genetic'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getGenetic())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.stemCell'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getStemCell())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.biosafety'), Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getBiosafety())));
                $pdf->ln();

                $pdf->SetFont('dejavusans','BI',11);
                $pdf->MultiCell(0,$cell_height, Locale::translate('proposal.potentialRisk'), 0, 'L');  
                $pdf->ln();
                
                $pdf->SetFont('dejavusans','',11);
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.riskLevel').': ', Locale::translate($riskAssessment->getRiskLevelKey()));
                if ($riskAssessment->getRiskLevel() != RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL) {
                    $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.listRisks').': ', $riskAssessment->getListRisks());
                    $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.howRisksMinimized').': ', $riskAssessment->getHowRisksMinimized());
                }
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.riskApplyTo').': ', $riskAssessment->getLocalizedRisksApplyToString());                
                $pdf->ln();

                $pdf->SetFont('dejavusans','BI',11);
                $pdf->MultiCell(0,$cell_height, Locale::translate('proposal.potentialBenefits'), 0, 'L');  
                $pdf->ln();
                
                $pdf->SetFont('dejavusans','',11);
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.benefitsFromTheProject').': ', $riskAssessment->getLocalizedBenefitsToString());                
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.multiInstitutions').': ', Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getMultiInstitutions())));
                $pdf->MultiRow($cell_width_risk_assessment, Locale::translate('proposal.conflictOfInterest').': ', Locale::translate($riskAssessment->getConflictOfInterestKey()));
                
                $pdf->Output($sectionEditorSubmission->getProposalId().' - '.Locale::translate('submission.summary').'.pdf',"D");   
                
        }

        /**
	 * Internal function to write the pdf of a published researt.
	 * @param $sectionEditorSubmission SectionEditorSubmission
	 * @return bool
	 */
        function _publishResearch($sectionEditorSubmission){
            
            $completionReport = $sectionEditorSubmission->getLastReportFile();
            
            if ($completionReport->getFileType() == "application/pdf") {
                
                $coverPath = SectionEditorAction::_generateCover($sectionEditorSubmission);
                
                if ($coverPath && $coverPath!= '') {

                    import('classes.lib.TCPDFMerger');
                    $file2merge=array($coverPath.'tempCover.pdf', $completionReport->getFilePath());
                    $pdf = new TCPDFMerger();
                    $pdf->setFiles($file2merge);
                    $pdf->concat();
                    $fileName = $sectionEditorSubmission->getProposalId().'-Final_Technical_Report.pdf';
                    $pdf->Output($coverPath.$fileName, "F");
                    
                    FileManager::deleteFile($coverPath.'tempCover.pdf');
                    
                    if (file_exists($coverPath.$fileName)) {
                        
                        //import('classes.article.ArticleFile');
                        $articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
                        $technicalReport = new ArticleFile();

                        $technicalReport->setArticleId($sectionEditorSubmission->getArticleId());
                        $technicalReport->setFileName($fileName);
                        $technicalReport->setFileType('application/pdf');
                        $technicalReport->setFileSize(filesize($coverPath.$fileName));
                        $technicalReport->setOriginalFileName($fileName);
                        $technicalReport->setType('public');
                        $technicalReport->setDateUploaded(Core::getCurrentDate());
                        $technicalReport->setDateModified(Core::getCurrentDate());

                        $fileId = $articleFileDao->insertArticleFile($technicalReport);
                        
                        return $fileId;
                        
                    }
                    
                }
                
            }
            return false;
        }
    
        /**
	 * Internal function to return the cover for publishing a research
	 * @param $sectionEditorSubmission SectionEditorSubmission
	 * @return string path to cover created
	 */
        function &_generateCover($sectionEditorSubmission){
		$journal =& Request::getJournal();
            
                import('classes.lib.tcpdf.pdf');
                import('classes.lib.tcpdf.tcpdf');
            
		Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_PKP_USER));
                $pdf = new PDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
                
                // No header and footer for this document
                $pdf->SetPrintHeader(false);
                $pdf->SetPrintFooter(false);

                $pdf->SetCreator(PDF_CREATOR);
                
                $pdf->SetAuthor($journal->getJournalTitle());
                
                // set margins
                $pdf->SetMargins(PDF_MARGIN_LEFT, 20, PDF_MARGIN_RIGHT);

                // set auto page breaks
                $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

                // set image scale factor
                $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
                
                // Right now this cover page is only in english, but the english translation keys are ready
                $pdf->AddPage();
                $pdf->SetFont('dejavusans','B',14);
                $pdf->MultiCell(0,6,'Final Technical Report', 0, 'C'); // Locale::translate('editor.finalReport')
                $pdf->ln();
                $pdf->ln();
                $pdf->MultiCell(0,6,'for', 0, 'C'); // Locale::translate('editor.finalReport.for')
                $pdf->ln();
                $pdf->ln();
                $pdf->MultiCell(0,6,'Research Project', 0, 'C'); // Locale::translate('editor.finalReport.researchProject')
                $pdf->ln();
                $pdf->ln();
                $pdf->ln();
                $pdf->ln();

                $abstract = $sectionEditorSubmission->getAbstractByLocale('en_US'); // Right now, considering only the english language
                $pdf->SetFont('dejavusans','B',16);
                $pdf->MultiCell(0,6,$abstract->getScientificTitle(), 0, 'C');                
                $pdf->ln();
                
                $authors = $sectionEditorSubmission->getAuthors();
                $coInvestigatorsString = (string) '';
                $pInvestigatorsString = (string) '';
                foreach ($authors as $author) {
                    if (!$author->getPrimaryContact()) {
                        if ($coInvestigatorsString == '') {
                            $coInvestigatorsString = $author->getFullName().' ('.$author->getAffiliation().')';
                        } else {
                            $coInvestigatorsString = $coInvestigatorsString.', '.$author->getFullName().' ('.$author->getAffiliation().')';
                        }
                    } else {
                        $pInvestigatorsString = $author->getFullName().' ('.$author->getAffiliation().')';
                    }
                }
                
                $pdf->SetFont('dejavusans','',16);
                $pdf->MultiCell(0,6,'Principal Investigator: '.$pInvestigatorsString, 0, 'C'); // Locale::translate('user.role.primaryInvestigator')         
                
                if ($coInvestigatorsString != ''){
                    $pdf->MultiCell(0,6,'Co-Investigator(s): '.$coInvestigatorsString, 0, 'C'); // Locale::translate('user.role.coinvestigator')   
                }
                $pdf->ln();
                $pdf->ln();
                $pdf->ln();
                $pdf->ln();
                
                $pdf->SetFont('dejavusans','B',16);
                $pdf->MultiCell(0,6,$sectionEditorSubmission->getProposalId(), 0, 'C');
                $pdf->ln();
                $pdf->ln();

                $decision = $sectionEditorSubmission->getLastSectionDecision();

                $pdf->MultiCell(0, 0, date("F Y", strtotime($decision->getDateDecided())), 0, 'L', 0, 1, '', 250, true);
                $pdf->Image("public/site/images/mainlogo.png", 'C', 230, 40, '', '', false, 'C', false, 300, 'R', false, false, 0, false, false, false);

                $pdf->AddPage();
                
                $pdf->SetFont('dejavusans','B',14);
                $pdf->MultiCell(0,6,'Final Technical Report', 0, 'C'); // Locale::translate('editor.finalReport')
                $pdf->ln();
                $pdf->ln();

                $pdf->SetFont('dejavusans','B',12);
                $pdf->MultiCell(0,6,'Disclaimer', 0, 'C'); // Locale::translate('editor.finalReport.disclaimer')
                $pdf->ln();
                $pdf->ln();

                $pdf->SetFont('dejavusans','',11);
                $pdf->writeHTMLCell(0, 6, '', '', $journal->getSetting('reportDisclaimer'), 0, 0, false, true, 'J');
                $filePath = Config::getVar('files', 'files_dir') .
		'/articles/' . $sectionEditorSubmission->getArticleId() . '/public/';
                
		if (!FileManager::fileExists($filePath, 'dir')) {
                    FileManager::mkdirtree($filePath);
                }
                
		$pdf->Output($filePath.'tempCover.pdf','F');
                
                return $filePath;
        }
}

?>
