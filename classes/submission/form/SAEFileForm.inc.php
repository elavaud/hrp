<?php

/**
 * @file classes/submission/form/SAEFileForm.inc.php
 *
 * @class SAEFileForm
 * @ingroup submission_form
 *
 * @brief Serious Adverse Event file form.
 */

// $Id$


import('lib.pkp.classes.form.Form');

class SAEFileForm extends Form {
    
	/** @var int the ID of the report file */
	var $fileId;

	/** @var Article current article */
	var $article;

	/** @var ArticleFile current report file */
	var $file;

	/**
	 * Constructor.
	 * @param $article object
	 * @param $fileId int (optional)
	 */
	function SAEFileForm($article, $fileId = null) {

		parent::Form(
			'author/submission/saeFileForm.tpl',
			true
		);

		$this->article = $article;

		if (isset($fileId) && !empty($fileId)) {
			$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
			$this->file =& $articleFileDao->getArticleFile($fileId, $article->getId());
			if (isset($this->file)) {
				$this->fileId = $fileId;
			}
		}
                        
                $this->addCheck(new FormValidatorCustom($this, 'uploadReportFile', 'required', 'author.submit.form.fileTooBig', 
                        function() {
                            if ($_FILES['uploadReportFile']['size'] > 20971520) {
                                return false;
                            } else {
                                return true;
                            }
                        }));
                        
		$this->addCheck(new FormValidatorPost($this));
	}

	/**
	 * Get the default form locale.
	 * @return string
	 */
	function getDefaultFormLocale() {
	}

	/**
	 * Get the names of fields for which data should be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
	}


	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
                
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('rolePath', Request::getRequestedPage());
		$templateMgr->assign('articleId', $this->article->getArticleId());
		$templateMgr->assign('fileId', $this->fileId);
		$templateMgr->assign('status', $this->article->getStatus());

                // Sometimes it's necessary to track the page we came from in
		// order to redirect back to the right place
		$templateMgr->assign('from', Request::getUserVar('from'));

		$templateMgr->assign('saeGuidelines', $journal->getLocalizedSetting('saeGuidelines'));
                
		if (isset($this->file)) {
                    $templateMgr->assign_by_ref('file', $this->file);
		}
		parent::display();
	}

	/**
	 * Validate the form
	 */
	function validate() {

		import ('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($this->article->getArticleId());
		if (!$articleFileManager->uploadedFileExists('uploadReportFile')){
                        $this->addError('uploadReportFile', Locale::translate('author.submit.form.noFileSelected'));	
		}
		return parent::validate();
	}

	/**
	 * Initialize form data from current report file (if applicable).
	 */
	function initData() {
                
	}

        
	/**
	 * Assign form data to user-submitted data.
	 * 
         */
	function readInputData() {
		$this->readUserVars(
			array(
                                'articleId',
                                'from',
                                'uploadReportFile'
			)
		);
	}
         

	/**
	 * Save changes to the report file.
	 * @return int the report file ID
	 */
	function execute($fileName = null) {
            
                $sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
                $articleDao =& DAORegistry::getDAO('ArticleDAO');
                
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($this->article->getArticleId());
                
		$fileName = isset($fileName) ? $fileName : 'uploadReportFile';
                
                $lastDecision = $this->article->getLastSectionDecision();
                $lastDecisionDecision = $lastDecision->getDecision();
                $lastDecisionType = $lastDecision->getReviewType();
                
                // Ensure to start a new round of review when needed, and if the file to upload is correct
                if (    (
                            ($lastDecisionDecision == SUBMISSION_SECTION_DECISION_APPROVED || $lastDecisionDecision == SUBMISSION_SECTION_DECISION_EXEMPTED)
                            || (
                                $lastDecisionType == REVIEW_TYPE_SAE && ($lastDecisionDecision == SUBMISSION_SECTION_DECISION_INCOMPLETE || $lastDecisionDecision == SUBMISSION_SECTION_DECISION_RESUBMIT)                                
                            )
                        )
                            && $articleFileManager->uploadedFileExists($fileName)
                   ) {
                    $this->fileId = $articleFileManager->uploadSAEFile($fileName);
                } else {
                    $this->fileId = 0;
                }

                if ($this->fileId && $this->fileId > 0){
                    $sectionDecision =& new SectionDecision();
                    $sectionDecision->setSectionId($lastDecision->getSectionId());
                    $sectionDecision->setDecision(0);
                    $sectionDecision->setDateDecided(date(Core::getCurrentDate()));      
                    $sectionDecision->setArticleId($this->article->getArticleId());
                    $sectionDecision->setReviewType(REVIEW_TYPE_SAE);

                    if ($lastDecisionType == $sectionDecision->getReviewType()) {
                        $lastRound = (int) $lastDecision->getRound();
                        $sectionDecision->setRound($lastRound + 1);
                    } else {
                        $sectionDecision->setRound(1);
                    }
                                        
                    $sectionDecisionDao->insertSectionDecision($sectionDecision);
                    $articleDao->changeArticleStatus($this->article->getArticleId(), STATUS_QUEUED);
                }
                
		// Notifications
		import('lib.pkp.classes.notification.NotificationManager');
		$notificationManager = new NotificationManager();
		$journal =& Request::getJournal();
		$url = Request::url($journal->getPath(), 'sectionEditor', 'submissionReview', array($this->article->getArticleId()));
                $sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
                $sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $lastDecision->getSectionId());
		foreach ($sectionEditors as $sectionEditor) {
                    $notificationSectionEditors[] = array('id' => $sectionEditor->getId());
                }
                foreach ($notificationSectionEditors as $userRole) {
                    $notificationManager->createNotification(
                            $userRole['id'], 'notification.type.sae',
                            $this->article->getProposalId(), $url, 1, NOTIFICATION_TYPE_METADATA_MODIFIED
                    );
                }
                
		return $this->fileId;
	}

}

?>
