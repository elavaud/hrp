<?php

/**
 * @file classes/manager/form/setup/JournalSetupStep3Form.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class JournalSetupStep3Form
 * @ingroup manager_form_setup
 *
 * @brief Form for Step 3 of journal setup.
 */



import('classes.manager.form.setup.JournalSetupForm');

class JournalSetupStep3Form extends JournalSetupForm {
	/**
	 * Constructor.
	 */
	function JournalSetupStep3Form() {
		parent::JournalSetupForm(
			3,
			array(
				'authorGuidelines' => 'string',
				'submissionChecklistInfo' => 'string',
				'ethics' => 'string',
        			'submissionChecklist' => 'object',
                                'sourceCurrency' => 'string',
                                'convertionRate' => 'int',
                                'progressReportGuidelines' => 'string',
                                'completionReportGuidelines' => 'string',
                                'protocolAmendmentGuidelines' => 'string',
                                'saeGuidelines' => 'string'/*,
                                'abstractLocales' => 'array',
                                'copyrightNotice' => 'string',
				'includeCreativeCommons' => 'bool',
				'copyrightNoticeAgree' => 'bool',
				'requireAuthorCompetingInterests' => 'bool',
				'requireReviewerCompetingInterests' => 'bool',
				'competingInterestGuidelines' => 'string',
				'metaDiscipline' => 'bool',
				'metaDisciplineExamples' => 'string',
				'metaSubjectClass' => 'bool',
				'metaSubjectClassTitle' => 'string',
				'metaSubjectClassUrl' => 'string',
				'metaSubject' => 'bool',
				'metaSubjectExamples' => 'string',
				'metaCoverage' => 'bool',
				'metaCoverageGeoExamples' => 'string',
				'metaCoverageChronExamples' => 'string',
				'metaCoverageResearchSampleExamples' => 'string',
				'metaType' => 'bool',
				'metaTypeExamples' => 'string',
				'metaCitations' => 'bool',
				'metaCitationOutputFilterId' => 'int',
				'copySubmissionAckPrimaryContact' => 'bool',
				'copySubmissionAckSpecified' => 'bool',
				'copySubmissionAckAddress' => 'string'*/
			)
		);
		$this->addCheck(new FormValidator($this, 'sourceCurrency', 'required', 'manager.setup.form.sourceCurrencyRequired'));
                                
                $this->addCheck(new FormValidatorCustom($this, 'convertionRate', 'required', 'manager.setup.form.exchangeRateInstruct2', 
                        function($convertionRate) {
                            $convertionRate = preg_replace('/\s+/', '', $convertionRate);
                            $convertionRate = trim($convertionRate);
                            if(preg_match('/^[0-9]+([\.,][0-9]*)?$/',$convertionRate)){
                                $convertionRate = rtrim($convertionRate, " \t\n\r\0\x0B.,0" );
                                if ($convertionRate != "") {
                                    return true;
                                } else {
                                    return false;
                                } 
                            } else {
                                return false;
                            }
                        }));
                
                $this->addCheck(new FormValidatorEmail($this, 'copySubmissionAckAddress', 'optional', 'user.profile.form.emailRequired'));
	}

	/**
	 * Get the list of field names for which localized settings are used.
	 * @return array
	 */
	function getLocaleFieldNames() {
		return array('authorGuidelines', 'submissionChecklistInfo', 'ethics', 'submissionChecklist', 'progressReportGuidelines', 'completionReportGuidelines', 'protocolAmendmentGuidelines', 'saeGuidelines'/*, 'copyrightNotice', 'metaDisciplineExamples', 'metaSubjectClassTitle', 'metaSubjectClassUrl', 'metaSubjectExamples', 'metaCoverageGeoExamples', 'metaCoverageChronExamples', 'metaCoverageResearchSampleExamples', 'metaTypeExamples', 'competingInterestGuidelines'*/);
	}

	/**
	 * Display the form
	 * @param $request Request
	 * @param $dispatcher Dispatcher
	 */
	function display($request, $dispatcher) {
                
		$templateMgr =& TemplateManager::getManager($request);
		// Add extra style sheets required for ajax components
		// FIXME: Must be removed after OMP->OJS backporting
		$templateMgr->addStyleSheet($request->getBaseUrl().'/styles/ojs.css');

		// Add extra java script required for ajax components
		// FIXME: Must be removed after OMP->OJS backporting
		$templateMgr->addJavaScript('lib/pkp/js/grid-clickhandler.js');
		$templateMgr->addJavaScript('lib/pkp/js/modal.js');
		$templateMgr->addJavaScript('lib/pkp/js/lib/jquery/plugins/validate/jquery.validate.min.js');
		$templateMgr->addJavaScript('lib/pkp/js/jqueryValidatorI18n.js');

		import('classes.mail.MailTemplate');
		$mail = new MailTemplate('SUBMISSION_ACK');
		if ($mail->isEnabled()) {
			$templateMgr->assign('submissionAckEnabled', true);
		}

		// Citation editor filter configuration
		//
		// 1) Check whether PHP5 is available.
		if (!checkPhpVersion('5.0.0')) {
			Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION));
			$citationEditorError = 'submission.citations.editor.php5Required';
		} else {
			$citationEditorError = null;
		}
		$templateMgr->assign('citationEditorError', $citationEditorError);

		if (!$citationEditorError) {
			// 2) Add the filter grid URLs
			$parserFilterGridUrl = $dispatcher->url($request, ROUTE_COMPONENT, null, 'grid.filter.ParserFilterGridHandler', 'fetchGrid');
			$templateMgr->assign('parserFilterGridUrl', $parserFilterGridUrl);
			$lookupFilterGridUrl = $dispatcher->url($request, ROUTE_COMPONENT, null, 'grid.filter.LookupFilterGridHandler', 'fetchGrid');
			$templateMgr->assign('lookupFilterGridUrl', $lookupFilterGridUrl);

			// 3) Create a list of all available citation output filters.
			$router =& $request->getRouter();
			$journal =& $router->getContext($request);
			import('lib.pkp.classes.metadata.MetadataDescription');
			$inputSample = new MetadataDescription('lib.pkp.classes.metadata.nlm.NlmCitationSchema', ASSOC_TYPE_CITATION);
			$outputSample = 'any string';
			$filterDao =& DAORegistry::getDAO('FilterDAO');
			$metaCitationOutputFilterObjects =& $filterDao->getCompatibleObjects($inputSample, $outputSample, $journal->getId());
			foreach($metaCitationOutputFilterObjects as $metaCitationOutputFilterObject) {
				$metaCitationOutputFilters[$metaCitationOutputFilterObject->getId()] = $metaCitationOutputFilterObject->getDisplayName();
			}
			$templateMgr->assign_by_ref('metaCitationOutputFilters', $metaCitationOutputFilters);
		}
                
		$currencyDao =& DAORegistry::getDAO('CurrencyDAO');
		$currencies =& $currencyDao->getCurrencies();
		$currenciesArray = array();
		foreach ($currencies as $currency) {
                        $currenciesArray[$currency->getCodeAlpha()] = $currency->getName() . ' (' . $currency->getCodeAlpha() . ')';
		}                
		$templateMgr->assign('currencies', $currenciesArray);                
                
                $originalSourceCurrencyAlpha = $journal->getSetting('sourceCurrency');
                $originalSourceCurrency = $currencyDao->getCurrencyByAlphaCode($originalSourceCurrencyAlpha);
		$templateMgr->assign('originalSourceCurrency', $originalSourceCurrency->getName().' ('.$originalSourceCurrencyAlpha.')');                
                
		$proposalSourceDao =& DAORegistry::getDAO('ProposalSourceDAO');
		$templateMgr->assign('countSources', $proposalSourceDao->countSources());                
                
		parent::display($request, $dispatcher);
	}
        
	function execute() {
		$proposalSourceDao =& DAORegistry::getDAO('ProposalSourceDAO');
                if ($proposalSourceDao->countSources() > 0){
                    $journal = Request::getJournal();
                    $originalSourceCurrencyAlpha = $journal->getSetting('sourceCurrency');
                    $formSourceCurrencyApha = $this->getData('sourceCurrency');
                    if ($originalSourceCurrencyAlpha != $formSourceCurrencyApha) {
                        $exchangeRate = $this->getData('convertionRate');
                        $exchangeRate = preg_replace('/\s+/', '', $exchangeRate);
                        $exchangeRate = trim($exchangeRate);
                        if(preg_match('/^[0-9]+([\.,][0-9]*)?$/',$exchangeRate)){
                            $exchangeRate = rtrim($exchangeRate, " \t\n\r\0\x0B.,0" );
                            if ($exchangeRate != "") {
                                $exchangeRate = str_replace(",", ".", $exchangeRate);
                                $proposalSourceDao->changeCurrency($exchangeRate);
                            } else {
                                return null;
                            }
                        } else {
                            return null;  
                        }
                    }
                }                
		return parent::execute();
	}        
        
}

?>
