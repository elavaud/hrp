<?php

/**
 * @file NewSearchHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class NewSearchHandler
 * @ingroup pages_search
 *
 * @brief Handle site index requests. 
 */

// $Id$


import('classes.search.ArticleSearch');
import('classes.handler.Handler');

class NewSearchHandler extends Handler {
	/**
	 * Constructor
	 **/
	function NewSearchHandler() {
		parent::Handler();
		$this->addCheck(new HandlerValidatorCustom($this, false, null, null, create_function('$journal', 'return !$journal || $journal->getSetting(\'publishingMode\') != PUBLISHING_MODE_NONE;'), array(Request::getJournal())));
	}

	/**
	 * Show the advanced form
	 */
	function index() {
		$this->validate();
		$this->advanced();
	}

	/**
	 * Show the advanced form
	 */
	function search() {
		$this->validate();
		$this->advanced();
	}

	/**
	 * Show advanced search form.
	 */
	function advanced() {
		$this->validate();
		$this->setupTemplate(false);
		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('query', Request::getUserVar('query'));
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                $countries =& $extraFieldDao->getExtraFieldsList(EXTRA_FIELD_GEO_AREA);
                $templateMgr->assign_by_ref('proposalCountries', $countries);	
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		
		$templateMgr->display('search/search.tpl');
	}

	/**
	 * Show basic search results.
	 */
	function results() {
		$this->validate();
		$this->advancedResults();
	}

	/**
	 * Show advanced search results.
	 */
	function advancedResults() {
		
		$this->validate();
		$this->setupTemplate(true);
				
		$query = Request::getUserVar('query');
		
		$fromDate = Request::getUserVar('dateFrom');
		if(!$fromDate) $fromDate = Request::getUserDateVar('dateFrom', 1, 1);

		$toDate = Request::getUserVar('dateTo');		
		if(!$toDate) $toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		
		$country = Request::getUserVar('proposalCountry');
		
		$status = Request::getUserVar('status');
		if($status != '1' && $status != '2') $status = false;
		
		$rangeInfo =& Handler::getRangeInfo('search');
		
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'title';
		
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == SORT_DIRECTION_ASC || $sortDirection == SORT_DIRECTION_DESC)) ? $sortDirection : SORT_DIRECTION_ASC;

		$templateMgr =& TemplateManager::getManager();
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
                
                if ($fromDate == '--') $fromDate = null;
                if ($toDate == '--') $toDate = null;                
                if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
		$results =& $articleDao->searchProposalsPublic($query, $fromDate, $toDate, $country, $status, $rangeInfo, $sort, $sortDirection);

		$templateMgr->assign('formattedDateFrom', $fromDate);
		$templateMgr->assign('formattedDateTo', $toDate);
										
		$templateMgr->assign('statusFilter', $status);
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('query', $query);
		$templateMgr->assign('region', $country);
                $extraField =& $extraFieldDao->getExtraField($country);
		$templateMgr->assign('country', (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null));
		$templateMgr->assign('countryCode', $country);
                $templateMgr->assign('proposalCountries', $extraFieldDao->getExtraFieldsList(EXTRA_FIELD_GEO_AREA));	
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);

		$templateMgr->assign('count', $results->getCount());		
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
                
                
		$templateMgr->display('search/searchResults.tpl');
	}
	
	function generateCustomizedCSV($args) {
		parent::validate();
		$this->setupTemplate();
		$query = Request::getUserVar('query');

		$region = Request::getUserVar('region');
		$statusFilter = Request::getUserVar('statusFilter');
				
		$fromDate = Request::getUserVar('dateFrom');
		//if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);		
		$toDate = Request::getUserVar('dateTo');
		//if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$columns = array();
		
		$investigatorName = false;
		if (Request::getUserVar('investigatorName')) {
			$columns = $columns + array('investigator' => Locale::translate('search.investigator'));
			$investigatorName = true;
		}
					
		$investigatorAffiliation = false;
		if (Request::getUserVar('investigatorAffiliation')) {
			$columns = $columns + array('investigator_affiliation' => Locale::translate('search.investigatorAffiliation'));
			$investigatorAffiliation = true;
		}
							
		$investigatorEmail = false;
		if (Request::getUserVar('investigatorEmail')) {
			$columns = $columns + array('investigator_email' => Locale::translate('search.investigatorEmail'));
			$investigatorEmail = true;
		}
		
		if (Request::getUserVar('scientificTitle')) {
			$columns = $columns + array('title' => Locale::translate('article.scientificTitle'));
		}

                $researchDomain = false;
		if (Request::getUserVar('researchDomain')) {
			$columns = $columns + array('research_domain' => Locale::translate('proposal.researchDomains'));
			$researchDomain = true;
		}
		
		$researchField = false;
		if (Request::getUserVar('researchField')) {
			$columns = $columns + array('research_field' => Locale::translate('search.researchField'));
			$researchField = true;
		}
		
		$proposalType = false;
		if (Request::getUserVar('proposalType')) {
			$columns = $columns + array('proposal_type' => Locale::translate('article.proposalType'));
			$proposalType = true;
		}
		
		$duration = false;
		if (Request::getUserVar('duration')) {
			$columns = $columns + array('duration' => Locale::translate('search.duration'));
			$duration = true;
		}

		$area = false;
		if (Request::getUserVar('area')) {
			$columns = $columns + array('area' => Locale::translate('common.area'));
			$area = true;
		}
		
		$dataCollection = false;
		if (Request::getUserVar('dataCollection')) {
			$columns = $columns + array('data_collection' => Locale::translate('search.dataCollection'));
			$dataCollection = true;
		}
		
		$status = false;
		if (Request::getUserVar('status')) {
			$columns = $columns + array('status' => Locale::translate('search.status'));
			$status = true;
		}

		$studentResearch = false;
		if (Request::getUserVar('studentResearch')) {
			$columns = $columns + array('student_institution' => Locale::translate('article.studentInstitution'));
			$columns = $columns + array('academic_degree' => Locale::translate('article.academicDegree'));
			$studentResearch = true;
		}

		$kii = false;
		if (Request::getUserVar('kii')) {
			$columns = $columns + array('kii' => Locale::translate('proposal.keyImplInstitution'));
			$kii = true;
		}
		
		$dateSubmitted = false;
		if (Request::getUserVar('dateSubmitted')) {
			$columns = $columns + array('date_submitted' => Locale::translate('search.dateSubmitted'));
			$dateSubmitted = true;
		}		
		
		
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=searchResults-' . date('Ymd') . '.csv');
				
		
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));

                $articleDao =& DAORegistry::getDAO('ArticleDAO');
		
		$results = $articleDao->searchCustomizedProposalsPublic($query, $region, $statusFilter, $fromDate, $toDate, $investigatorName, $investigatorAffiliation, $investigatorEmail, $researchDomain, $researchField, $proposalType, $duration, $area, $dataCollection, $status, $studentResearch, $kii, $dateSubmitted);

                foreach ($results as $result) {
			$abstract = $result->getLocalizedAbstract();
			$proposalDetails = $result->getProposalDetails();
			$studentInfo = $proposalDetails->getStudentResearchInfo();
                        foreach ($columns as $index => $junk) {
				if ($index == 'investigator') {
					$columns[$index] = $result->getPrimaryAuthor();
				} elseif ($index == 'investigator_affiliation') {
					$columns[$index] = $this->_removeCommaForCSV($result->getInvestigatorAffiliation());
				} elseif ($index == 'investigator_email') {
					$columns[$index] = $result->getAuthorEmail();
				} elseif ($index == 'title') {
					$columns[$index] = $abstract->getScientificTitle();
				} elseif ($index == 'research_domain') {
					$columns[$index] = $proposalDetails->getLocalizedResearchDomainsText();
				} elseif ($index == 'research_field') {
					$columns[$index] = $proposalDetails->getLocalizedResearchFieldText();
				} elseif ($index == 'proposal_type') {
					$columns[$index] = $proposalDetails->getLocalizedProposalTypeText();
				} elseif ($index == "duration") {
					$columns[$index] = $proposalDetails->getStartDate()." to ".$proposalDetails->getEndDate();
				} elseif ($index == 'area') {
					if ($proposalDetails->getMultiCountryResearch() == PROPOSAL_DETAIL_YES) $columns[$index] = "Multi-country Research";
					elseif ($proposalDetails->getNationwide() == PROPOSAL_DETAIL_YES) $columns[$index] = "Nationwide Research";
					else  $columns[$index] = $proposalDetails->getLocalizedGeoAreasText();
				} elseif ($index == 'data_collection') {
					$columns[$index] = Locale::translate($proposalDetails->getDataCollectionKey());
				} elseif ($index == 'status') {
					if ($result->getStatus() == '11') $columns[$index] = 'Complete';
					else $columns[$index] = 'Ongoing';
				} elseif ($index == 'student_institution') {
					if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) $columns[$index] = $studentInfo->getInstitution(); else $columns[$index] = "Non Student Research";
				} elseif ($index == 'academic_degree') {
					if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) $columns[$index] = Locale::translate($studentInfo->getDegreeKey());else $columns[$index] = "Non Student Research";
				} elseif ($index == 'kii') {
					$columns[$index] = $proposalDetails->getKeyImplInstitutionName();
				} elseif ($index == 'date_submitted') {
					$columns[$index] = $result->getDateSubmitted();
				} 
			}
			String::fputcsv($fp, $columns);
		}
		fclose($fp);
		unset($columns);
	}
	
        
        /*
         * Internal function for removing the comma(s) of a string before a CSV export
         */
        function _removeCommaForCSV($string){
            //also remove newlines
            $string = preg_replace('/\s+/', ' ', trim($string));
            return str_replace(',', '', $string);
        }
        
	function viewProposal($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->setupTemplate(true, $articleId);
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$submission = $articleDao->getArticle($articleId);
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('query', Request::getUserVar('query'));
		
		$proposal = $articleDao->getArticle($articleId);
		$templateMgr->assign_by_ref('finalReport', $proposal->getPublishedFinalReport());
			
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
		
		$templateMgr->display('search/viewProposal.tpl');
	}
	/**
	 * Setup common template variables.
	 * @param $subclass boolean set to true if caller is below this handler in the hierarchy
	 */
	function setupTemplate($subclass = false, $articleId = null) {
		parent::setupTemplate();
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('helpTopicId', 'user.searchAndBrowse');
		if ($articleId == null) {$templateMgr->assign('pageHierarchy',
			$subclass ? array(array(Request::url(null, 'search', 'advancedResults'), 'navigation.search'))
				: array()
		);
		} else {
			$templateMgr->assign('pageHierarchy',
			$subclass ? array(array(Request::url(null, 'search', 'advancedResults'), 'navigation.search'), array(Request::url('hrp', 'search','advancedResults'), 'search.searchResults'))
				: array()
			);
		}
			

		$journal =& Request::getJournal();
		if (!$journal || !$journal->getSetting('restrictSiteAccess')) {
			$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
		}
	}
        
	/**
	 * Download published final report
	 * @param $args ($articleId, fileId)
	 */
	function downloadFinalReport($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;
		
		import("classes.file.ArticleFileManager");
		$articleFileManager = new ArticleFileManager($articleId);
		return $articleFileManager->downloadFile($fileId);
	}

}

?>
