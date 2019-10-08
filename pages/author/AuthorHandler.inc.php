<?php

/**
 * @file AuthorHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorHandler
 * @ingroup pages_author
 *
 * @brief Handle requests for journal author functions. 
 */

// $Id$

import('classes.submission.author.AuthorAction');
import('classes.handler.Handler');

class AuthorHandler extends Handler {
	/**
	 * Constructor
	 **/
	function AuthorHandler() {
		parent::Handler();
		$this->addCheck(new HandlerValidatorJournal($this));		
	}

	/**
	 * Display journal author index page.
	 */
	function index($args) {
		$this->validate();
		
		$this->setupTemplate();
		$journal =& Request::getJournal();

		$user =& Request::getUser();
		$rangeInfo =& Handler::getRangeInfo('submissions');

		$authorSubmissionDao =& DAORegistry::getDAO('AuthorSubmissionDAO');

		$searchField = Request::getUserVar('searchField');
		$dateSearchField = Request::getUserVar('dateSearchField');
		$searchMatch = Request::getUserVar('searchMatch');
		$search = Request::getUserVar('search');

		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$page = isset($args[0]) ? $args[0] : '';
		switch($page) {
			case 'proposalsInReview':
				$functionName = 'getAuthorProposalsInReviewIterator';
				break;
			case 'ongoingResearches':
				$functionName = 'getAuthorOngoingResearchesIterator';
				break;
			case 'completedResearches':
				$functionName = 'getAuthorCompletedResearchesIterator';
				break;
			case 'submissionsArchives':
				$functionName = 'getAuthorArchivesIterator';
				break;
			default:
				$functionName = 'getAuthorProposalsToSubmitIterator';
				$page = 'proposalsToSubmit';
		}
		
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'title';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == SORT_DIRECTION_ASC || $sortDirection == SORT_DIRECTION_DESC)) ? $sortDirection : SORT_DIRECTION_ASC;
		
                $submissions = $authorSubmissionDao->$functionName($user->getId(), $journal->getId(), $searchField, $searchMatch, $search, $dateSearchField, $fromDate, $toDate, $rangeInfo, $sort, $sortDirection);
		
                $templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('pageToDisplay', $page);

		$templateMgr->assign_by_ref('submissions', $submissions);
        
		/*********************************************************************
		 * Add search fields to template
		 * Added by:  Ayvee Mallare
		 * Last Updated: Sept 25, 2011
         *********************************************************************/
        $duplicateParameters = array(
			'searchField', 'searchMatch', 'search',
			'dateFromMonth', 'dateFromDay', 'dateFromYear',
			'dateToMonth', 'dateToDay', 'dateToYear',
			'dateSearchField'
		);
		foreach ($duplicateParameters as $param) $templateMgr->assign($param, Request::getUserVar($param));
                
        $templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('fieldOptions', Array(
			SUBMISSION_FIELD_TITLE => 'article.title',
			SUBMISSION_FIELD_AUTHOR => 'user.role.author',
			SUBMISSION_FIELD_EDITOR => 'user.role.editor'
		));
		$templateMgr->assign('dateFieldOptions', Array(
			SUBMISSION_FIELD_DATE_SUBMITTED => 'submissions.submitted',
		));
		
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                $countries =& $extraFieldDao->getExtraFieldsList(EXTRA_FIELD_GEO_AREA);
       	
                $templateMgr->assign_by_ref('countries', $countries);
        
		// assign payment 
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		
		if ( $paymentManager->isConfigured() ) {		
			$templateMgr->assign('submissionEnabled', $paymentManager->submissionEnabled());
			$templateMgr->assign('fastTrackEnabled', $paymentManager->fastTrackEnabled());
			$templateMgr->assign('publicationEnabled', $paymentManager->publicationEnabled());
			
			$completedPaymentDAO =& DAORegistry::getDAO('OJSCompletedPaymentDAO');
			$templateMgr->assign_by_ref('completedPaymentDAO', $completedPaymentDAO);
		} 				
		import('classes.issue.IssueAction');
		$issueAction = new IssueAction();
		$templateMgr->register_function('print_issue_id', array($issueAction, 'smartyPrintIssueId'));
		$templateMgr->assign('helpTopicId', 'editorial.authorsRole.submissions');
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->display('author/index.tpl');
	}

	/**
	 * Validate that user has author permissions in the selected journal.
	 * Redirects to user index page if not properly authenticated.
	 */
	function validate($reason = null) {
		$this->addCheck(new HandlerValidatorRoles($this, true, $reason, null, array(ROLE_ID_AUTHOR)));		
		return parent::validate();
	}

	/**
	 * Setup common template variables.
	 * @param $subclass boolean set to true if caller is below this handler in the hierarchy
	 */
	function setupTemplate($subclass = false, $articleId = 0, $parentPage = null) {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_AUTHOR, LOCALE_COMPONENT_PKP_SUBMISSION));
		$templateMgr =& TemplateManager::getManager();
		$pageHierarchy = $subclass ? array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, 'author'), 'user.role.author'), array(Request::url(null, 'author'), 'article.submissions'))
			: array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, 'author'), 'user.role.author'));
		import('classes.submission.sectionEditor.SectionEditorAction');
		$submissionCrumb = SectionEditorAction::submissionBreadcrumb($articleId, $parentPage, 'author');
		if (isset($submissionCrumb)) {
			$pageHierarchy = array_merge($pageHierarchy, $submissionCrumb);
		}
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}

	/**
	 * Display submission management instructions.
	 * @param $args (type)
	 */
	function instructions($args) {
		import('classes.submission.proofreader.ProofreaderAction');
		if (!isset($args[0]) || !ProofreaderAction::instructions($args[0], array('copy', 'proof'))) {
			Request::redirect(null, null, 'index');
		}
	}
}

?>
