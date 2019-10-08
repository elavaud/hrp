<?php

/**
 * @file classes/author/form/submit/AuthorSubmitStep5Form.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmitStep5Form
 * @ingroup author_form_submit
 *
 * @brief Form for Step 5 of author article submission.
 */

// $Id$


import('classes.author.form.submit.AuthorSubmitForm');

class AuthorSubmitStep5Form extends AuthorSubmitForm {

	/**
	 * Constructor.
	 */
	function AuthorSubmitStep5Form(&$article, &$journal) {
		parent::AuthorSubmitForm($article, 5, $journal);

		$this->addCheck(new FormValidatorCustom($this, 'qualifyForWaiver', 'optional', 'author.submit.mustEnterWaiverReason', array(&$this, 'checkWaiverReason')));
	}

	/**
	 * Check that if the user choses a Waiver that they enter text in the comments to Editor
	 */
	function checkWaiverReason() {
		if ( Request::getUserVar('qualifyForWaiver') == false ) return true;
		else return  (Request::getUserVar('commentsToEditor') != '');
	}

	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$templateMgr =& TemplateManager::getManager();

                // Get article file for this article
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$articleFiles =& $articleFileDao->getArticleFilesByArticle($this->articleId);			
		
		$previousFiles =& $articleFileDao->getPreviousFilesByArticleId($this->articleId);
		foreach ($articleFiles as $articleFile) {
			foreach ($previousFiles as $previousFile) {
				if ($articleFile->getFileId() == $previousFile->getFileId()) {
					$articleFile->setType('previous');
				}
			}
		}
		
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
                $section = $sectionDao->getSection($this->article->getSectionId());
		$templateMgr->assign_by_ref('section', $section);
		
		$templateMgr->assign_by_ref('files', $articleFiles);	
		$templateMgr->assign_by_ref('journal', Request::getJournal());

                $templateMgr->assign_by_ref('article', $this->article);
                                
		// Set up required Payment Related Information
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		if ( $paymentManager->submissionEnabled() || $paymentManager->fastTrackEnabled() || $paymentManager->publicationEnabled()) {
			$templateMgr->assign('sectionId', $this->article->getSectionId());
			$templateMgr->assign('bankAccount', $section->getLocalizedPaymentInfo());
                        $templateMgr->assign('authorFees', true);
			$completedPaymentDAO =& DAORegistry::getDAO('OJSCompletedPaymentDAO');
			$articleId = $this->articleId;

			if ( $paymentManager->submissionEnabled() ) {
				$templateMgr->assign_by_ref('submissionPayment', $completedPaymentDAO->getSubmissionCompletedPayment ( $journal->getId(), $articleId ));
				$templateMgr->assign('manualPayment', $journal->getSetting('paymentMethodPluginName') == 'ManualPayment');
			}

			if ( $paymentManager->fastTrackEnabled()  ) {
				$templateMgr->assign_by_ref('fastTrackPayment', $completedPaymentDAO->getFastTrackCompletedPayment ( $journal->getId(), $articleId ));
			}
		}
                
                $templateMgr->assign_by_ref('abstractLocales', $journal->getSupportedLocaleNames());
                
		$currencyDao =& DAORegistry::getDAO('CurrencyDAO');
                $sourceCurrencyId = $journal->getSetting('sourceCurrency');
                $templateMgr->assign('sourceCurrency', $currencyDao->getCurrencyByAlphaCode($sourceCurrencyId));
                
		parent::display();
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {
		if (isset($this->article)) {
			$this->_data = array(
				'commentsToEditor' => $this->article->getCommentsToEditor()
			);
		}

	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array('paymentSent', 'qualifyForWaiver', 'commentsToEditor'));
	}

	/**
	 * Validate the form
	 */
	function validate() {
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		if ( $paymentManager->submissionEnabled() ) {
			if ( !parent::validate() ) return false;

			$journal =& Request::getJournal();
			$journalId = $journal->getId();
			$articleId = $this->articleId;
			$user =& Request::getUser();

			$completedPaymentDAO =& DAORegistry::getDAO('OJSCompletedPaymentDAO');
			if ( $completedPaymentDAO->hasPaidSubmission ( $journalId, $articleId )  ) {
				return parent::validate();
			} elseif ( Request::getUserVar('qualifyForWaiver') && Request::getUserVar('commentsToEditor') != '') {
				return parent::validate();
			} elseif ( Request::getUserVar('paymentSent') ) {
				return parent::validate();
			} elseif ( $this->article->getTotalBudget() < 5000 ) {
				return parent::validate();
			} else {
				$queuedPayment =& $paymentManager->createQueuedPayment($journalId, PAYMENT_TYPE_SUBMISSION, $user->getId(), $articleId, $journal->getSetting('submissionFee'));
				$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

				$paymentManager->displayPaymentForm($queuedPaymentId, $queuedPayment);
				exit;
			}
		} else {
			return parent::validate();
		}
	}

	/**
	 * Save changes to article.
	 */
	function execute() {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');

		$journal = Request::getJournal();
		$user = Request::getUser();

		// Update article
		$article =& $this->article;
                
                if($article->getDateSubmitted() == null) {
                        $year = substr(Core::getCurrentDate(), 0, 4);

                        $countyear = $articleDao->getSubmissionsForYearCount($year) + 1;
            
                        $proposalDetails =& $article->getProposalDetails();
            
                        $geoAreas = explode(",", $proposalDetails->getGeoAreas());
            
                        //$section = $sectionDao->getSection($article->getSectionId());
            
                        //$countyearsection = $articleDao->getSubmissionsForYearForSectionCount($year, $section->getId()) + 1;
            
                        if ($proposalDetails->getMultiCountryResearch() == PROPOSAL_DETAIL_YES){
                                $country = 'MC';
                        } elseif ($proposalDetails->getNationwide() == PROPOSAL_DETAIL_YES) {
                                $country = 'NW';
                        } elseif(count($geoAreas) > 1) {
                                $country = 'MP';
                                $countyearcountry = $articleDao->getICPSubmissionsForYearCount($year) + 1;
                        } else {
                                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                                $geoArea =& $extraFieldDao->getExtraField($geoAreas[0]);
                                $country = $geoArea->getThreeFirstLettersOfName();
                                $countyearcountry = $articleDao->getSubmissionsForYearForCountryCount($year, $country) + 1;
                        }
            
                        $article->setProposalId($year. '.' . $countyear . '.' . $country );
                }
                if ($this->getData('commentsToEditor') != '') {
                        $article->setCommentsToEditor($this->getData('commentsToEditor'));
                }

		$article->setDateSubmitted(Core::getCurrentDate());
		$article->setSubmissionProgress(0);
		$article->stampStatusModified();
                $articleDao->updateArticle($article);

		// Designate this as the review version by default.
		$authorSubmissionDao =& DAORegistry::getDAO('AuthorSubmissionDAO');
		$authorSubmission =& $authorSubmissionDao->getAuthorSubmission($article->getId());
		AuthorAction::designateReviewVersion($authorSubmission, true);
		unset($authorSubmission);

		$copyeditInitialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $article->getId());
		$copyeditAuthorSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_AUTHOR', ASSOC_TYPE_ARTICLE, $article->getId());
		$copyeditFinalSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $article->getId());
		$copyeditInitialSignoff->setUserId(0);
		$copyeditAuthorSignoff->setUserId($user->getId());
		$copyeditFinalSignoff->setUserId(0);
		$signoffDao->updateObject($copyeditInitialSignoff);
		$signoffDao->updateObject($copyeditAuthorSignoff);
		$signoffDao->updateObject($copyeditFinalSignoff);

		$layoutSignoff = $signoffDao->build('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $article->getId());
		$layoutSignoff->setUserId(0);
		$signoffDao->updateObject($layoutSignoff);

		$proofAuthorSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_AUTHOR', ASSOC_TYPE_ARTICLE, $article->getId());
		$proofProofreaderSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_PROOFREADER', ASSOC_TYPE_ARTICLE, $article->getId());
		$proofLayoutEditorSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_LAYOUT', ASSOC_TYPE_ARTICLE, $article->getId());
		$proofAuthorSignoff->setUserId($user->getId());
		$proofProofreaderSignoff->setUserId(0);
		$proofLayoutEditorSignoff->setUserId(0);
		$signoffDao->updateObject($proofAuthorSignoff);
		$signoffDao->updateObject($proofProofreaderSignoff);
		$signoffDao->updateObject($proofLayoutEditorSignoff);

		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
			
		$user =& Request::getUser();

		// Update search index
		import('classes.search.ArticleSearchIndex');
		ArticleSearchIndex::indexArticleMetadata($article);
		ArticleSearchIndex::indexArticleFiles($article);
             
		// Send author notification email
		import('classes.mail.ArticleMailTemplate');
		$mail = new ArticleMailTemplate($article, null, 'SUBMISSION_ACK', null, null, null, false);
		foreach ($sectionEditors as $sectionEditor) {
                        
                        // If one of the secretary is the chair of the committee, send from the chair, if not, take the last secretary in the array
                        $from = $mail->getFrom();
                        if ($ercReviewersDao->isErcReviewer($journal->getId(), $sectionEditor->getId(), REVIEWER_CHAIR)){
                            $mail->setFrom($sectionEditor->getEmail(), $sectionEditor->getFullName());
                        } elseif ($from['email'] == $user->getEmail()){
                            $mail->setFrom($sectionEditor->getEmail(), $sectionEditor->getFullName());
                        }
			
			$mail->addBcc($sectionEditor->getEmail(), $sectionEditor->getFullName());
			unset($sectionEditor);
		}
		if ($mail->isEnabled()) {
			$mail->addRecipient($user->getEmail(), $user->getFullName());
			if($journal->getSetting('copySubmissionAckSpecified')) {
				$copyAddress = $journal->getSetting('copySubmissionAckAddress');
				if (!empty($copyAddress)) $mail->addBcc($copyAddress);
			}
			
			$section = $sectionDao->getSection($article->getSectionId());
			$mail->assignParams(array(
				'authorName' => $user->getFullName(),
				'authorUsername' => $user->getUsername(),
				'address' => $sectionDao->getSettingValue($article->getSectionId(), 'address'),
				'bankAccount' => $sectionDao->getSettingValue($article->getSectionId(), 'bankAccount'),
				'proposalId' => $article->getProposalId(),
				'submissionUrl' => Request::url(null, 'author', 'submission', $article->getId())
			));
			$mail->send();
		}
		
		// Send a regular notification to section editors
                $lastDecision = $article->getLastSectionDecision();
                switch ($lastDecision->getReviewType()){
                    case REVIEW_TYPE_INITIAL:
                        if ($lastDecision->getRound() == 1) {$message = 'notification.type.articleSubmitted.initialReview';}
                        else {$message = 'notification.type.articleReSubmitted.initialReview';}
                        break;
                    case REVIEW_TYPE_PR:
                        if ($lastDecision->getRound() == 1) {$message = 'notification.type.articleSubmitted.continuingReview';}
                        else {$message = 'notification.type.articleReSubmitted.continuingReview';}
                        break;
                    case REVIEW_TYPE_AMENDMENT:
                        if ($lastDecision->getRound() == 1) {$message = 'notification.type.articleSubmitted.PAAmendmentReview';}
                        else {$message = 'notification.type.articleReSubmitted.PAAmendmentReview';}                        
                        break;
                    case REVIEW_TYPE_SAE:
                        if ($lastDecision->getRound() == 1) {$message = 'notification.type.articleSubmitted.SAE';}
                        else {$message = 'notification.type.articleReSubmitted.SAE';}                        
                        break;
                    case REVIEW_TYPE_FR:
                        if ($lastDecision->getRound() == 1) {$message = 'notification.type.articleSubmitted.EOS';}
                        else {$message = 'notification.type.articleReSubmitted.EOS';}                        
                        break;
                }
                
		import('lib.pkp.classes.notification.NotificationManager');
		$notificationManager = new NotificationManager();
		$url = Request::url($journal->getPath(), 'sectionEditor', 'submissionReview', array($article->getId()));
                foreach ($sectionEditors as $sectionEditor) {
                    $notificationManager->createNotification(
                        $sectionEditor->getId(), $message,
                        $article->getProposalId(), $url, 1, NOTIFICATION_TYPE_ARTICLE_SUBMITTED
                    );
                }

		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
                if($lastDecision->getRound() == 1){$message = 'log.author.submitted';}
                else {$message = 'log.author.resubmitted';}
		ArticleLog::logEvent($this->articleId, ARTICLE_LOG_ARTICLE_SUBMIT, ARTICLE_LOG_TYPE_AUTHOR, $user->getId(), $message, array('submissionId' => $article->getProposalId(), 'authorName' => $user->getFullName(), 'reviewType' => Locale::translate($lastDecision->getReviewTypeKey())));
        
		return $this->articleId;
	}

}

?>
