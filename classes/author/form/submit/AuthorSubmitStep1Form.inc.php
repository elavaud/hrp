<?php

/**
 * @file classes/author/form/submit/AuthorSubmitStep1Form.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmitStep1Form
 * @ingroup author_form_submit
 *
 * @brief Form for Step 1 of author article submission.
 */


import('classes.author.form.submit.AuthorSubmitForm');

class AuthorSubmitStep1Form extends AuthorSubmitForm {

	/**
	 * Constructor.
	 */
	function AuthorSubmitStep1Form(&$article, &$journal) {
		parent::AuthorSubmitForm($article, 1, $journal);

		// Validation checks for this form
		$this->addCheck(new FormValidator($this, 'sectionId', 'required', 'author.submit.form.sectionRequired'));
		$this->addCheck(new FormValidatorCustom($this, 'sectionId', 'required', 'author.submit.form.sectionRequired', array(DAORegistry::getDAO('SectionDAO'), 'sectionExists'), array($journal->getId())));

		$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
		if (!is_array($supportedSubmissionLocales) || count($supportedSubmissionLocales) < 1) $supportedSubmissionLocales = array($journal->getPrimaryLocale());
		$this->addCheck(new FormValidatorInSet($this, 'locale', 'required', 'author.submit.form.localeRequired', $supportedSubmissionLocales));
	}

	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$templateMgr =& TemplateManager::getManager();

		// Get sections for this journal
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		// If this user is a section editor or an editor, they are
		// allowed to submit to sections flagged as "editor-only" for
		// submissions. Otherwise, display only sections they are
		// allowed to submit to.
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$isEditor = $roleDao->roleExists($journal->getId(), $user->getId(), ROLE_ID_EDITOR) || $roleDao->roleExists($journal->getId(), $user->getId(), ROLE_ID_SECTION_EDITOR);
		$templateMgr->assign('sectionOptions', array('0' => Locale::translate('author.submit.selectSection')) + $sectionDao->getSectionTitles($journal->getId(), !$isEditor));

		// Set up required Payment Related Information
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		if ( $paymentManager->submissionEnabled() || $paymentManager->fastTrackEnabled() || $paymentManager->publicationEnabled()) {
			$templateMgr->assign('authorFees', true);
			$completedPaymentDAO =& DAORegistry::getDAO('OJSCompletedPaymentDAO');
			$articleId = $this->articleId;

			if ($paymentManager->submissionEnabled()) {
				$templateMgr->assign_by_ref('submissionPayment', $completedPaymentDAO->getSubmissionCompletedPayment ($journal->getId(), $articleId));
			}

			if ($paymentManager->fastTrackEnabled()) {
				$templateMgr->assign_by_ref('fastTrackPayment', $completedPaymentDAO->getFastTrackCompletedPayment ($journal->getId(), $articleId));
			}
		}

		// Provide available submission languages. (Convert the array
		// of locale symbolic names xx_XX into an associative array
		// of symbolic names => readable names.)
		$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
		if (empty($supportedSubmissionLocales)) $supportedSubmissionLocales = array($journal->getPrimaryLocale());
		$templateMgr->assign(
			'supportedSubmissionLocaleNames',
			array_flip(array_intersect(
				array_flip(Locale::getAllLocales()),
				$supportedSubmissionLocales
			))
		);

		parent::display();
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {
		if (isset($this->article)) {
                        $lastSectionDecision = $this->article->getLastSectionDecision();
			$this->_data = array(
				'sectionId' => $lastSectionDecision->getSectionId(),
				'locale' => $this->article->getLocale(),
				'commentsToEditor' => $this->article->getCommentsToEditor()
			);
		} else {
			$journal =& Request::getJournal();
			$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
			// Try these locales in order until we find one that's
			// supported to use as a default.
			$tryLocales = array(
				$this->getFormLocale(), // Current form locale
				Locale::getLocale(), // Current UI locale
				$journal->getPrimaryLocale(), // Journal locale
				$supportedSubmissionLocales[array_shift(array_keys($supportedSubmissionLocales))] // Fallback: first one on the list
			);
			$this->_data = array();
			foreach ($tryLocales as $locale) {
				if (in_array($locale, $supportedSubmissionLocales)) {
					// Found a default to use
					$this->_data['locale'] = $locale;
					break;
				}
			}
		}
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array('locale', 'submissionChecklist', 'copyrightNoticeAgree', 'sectionId', 'commentsToEditor'));
	}

	/**
	 * Save changes to article.
	 * @return int the article ID
	 */
	function execute() {
		
		$authorSubmissionDao =& DAORegistry::getDAO('AuthorSubmissionDAO');

		if (isset($this->article)) {
			// Update existing article
			$this->article->setLocale($this->getData('locale'));
			$this->article->setCommentsToEditor($this->getData('commentsToEditor'));
			if ($this->article->getSubmissionProgress() <= $this->step) {
				$this->article->stampStatusModified();
				$this->article->setSubmissionProgress($this->step + 1);
			}
                        $lastSectionDecision = $this->article->getLastSectionDecision();
                        $lastSectionDecision->setSectionId($this->getData('sectionId'));
			$authorSubmissionDao->updateAuthorSubmission($this->article);

		} else {
			// Insert new article
			$journal =& Request::getJournal();
			$user =& Request::getUser();

			$this->article = new AuthorSubmission();
			$this->article->setLocale($this->getData('locale'));
			$this->article->setUserId($user->getId());
			$this->article->setJournalId($journal->getId());
			$this->article->stampStatusModified();
			$this->article->setSubmissionProgress($this->step + 1);
			$this->article->setLanguage(String::substr($this->article->getLocale(), 0, 2));
			$this->article->setCommentsToEditor($this->getData('commentsToEditor'));
                        
                        // Set new Section Decision
                        $sectionDecision =& new SectionDecision();
                        $sectionDecision->setReviewType(REVIEW_TYPE_INITIAL);
                        $sectionDecision->setRound(1);
                        $sectionDecision->setSectionId($this->getData('sectionId'));
                        $sectionDecision->setDecision(0);
                        $sectionDecision->setDateDecided(date(Core::getCurrentDate()));
                        $this->article->addDecision($sectionDecision);    
			
                        // Set user to initial author
			$author = new Author();
			$author->setFirstName($user->getFirstName());
			$author->setMiddleName($user->getMiddleName());
			$author->setLastName($user->getLastName());
			$author->setAffiliation($user->getLocalizedAffiliation());
			$author->setEmail($user->getEmail());
			$author->setPhoneNumber($user->getPhone());
			$author->setBiography($user->getBiography(null), null);
			$author->setPrimaryContact(1);
			$this->article->addAuthor($author);
			
			$authorSubmissionDao->insertAuthorSubmission($this->article);
			$this->articleId = $this->article->getId();
		}

		return $this->articleId;
	}

}

?>
