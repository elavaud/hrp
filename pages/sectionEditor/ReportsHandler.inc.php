<?php

/**
* class MeetingsHandler for SectionEditor and Editor Roles (Secretary)
* page handler class for minutes-related operations
* @var unknown_type
*/
define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);
// Filter section
define('FILTER_SECTION_ALL', 0);

import('classes.handler.Handler');

class ReportsHandler extends Handler {
	/**
	* Constructor
	**/
	function ReportsHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
		// FIXME This is kind of evil
		$page = Request::getRequestedPage();
		if ( $page == 'sectionEditor' )
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_SECTION_EDITOR)));
		elseif ( $page == 'editor' )
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));
	
	}

	/**
	* Setup common template variables.
	* @param $subclass boolean set to true if caller is below this handler in the hierarchy
	*/
	function setupTemplate() {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_OJS_AUTHOR, LOCALE_COMPONENT_OJS_MANAGER));
		$templateMgr =& TemplateManager::getManager();
		$isEditor = Validation::isEditor();
		
		if (Request::getRequestedPage() == 'editor') {
			$templateMgr->assign('helpTopicId', 'editorial.editorsRole');
		
		} else {
			$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole');
		}
		
		$roleSymbolic = $isEditor ? 'editor' : 'sectionEditor';
		$roleKey = $isEditor ? 'user.role.coordinator' : 'user.role.sectionEditor';
		$pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, 'user'), $roleKey), array(Request::url(null, $roleSymbolic, 'submissionsReport'), 'editor.reports.reportGenerator'));
		
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}

	
	/**
	* Added by igmallare 10/10/2011
	* Display the meeting attendance report form
	* @param $args (type)
	*/
	function meetingAttendanceReport($args, &$request){
		import ('classes.meeting.form.MeetingAttendanceReportForm');
		parent::validate();
		$this->setupTemplate();
		$meetingAttendanceReportForm= new MeetingAttendanceReportForm($args, $request);
		$isSubmit = Request::getUserVar('generateMeetingAttendance') != null ? true : false;
		
		if ($isSubmit) {
			$meetingAttendanceReportForm->readInputData();
			if($meetingAttendanceReportForm->validate()){	
					$this->generateMeetingAttendanceReport($args);
			}else{
				if ($meetingAttendanceReportForm->isLocaleResubmit()) {
					$meetingAttendanceReportForm->readInputData();
				}
				$meetingAttendanceReportForm->display($args);
			}
		}else {
			$meetingAttendanceReportForm->display($args);
		}
	}
	
	/**
	* Added by igmallare 10/11/2011
	* Generate csv file for the meeting attendance report
	* @param $args (type)
	*/
	function generateMeetingAttendanceReport($args) {
		parent::validate();
		$this->setupTemplate();
		$ercMembers = Request::getUserVar('ercMembers');
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$userDao = DAORegistry::getDAO('UserDAO');
		
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=meetingAttendanceReport-' . date('Ymd') . '.csv');
		
		$columns = array(
		'lastname' => Locale::translate('user.lastName'),
		'firstname' => Locale::translate('user.firstName'),
		'middlename' => Locale::translate('user.middleName'),
		'meeting_date' => Locale::translate('editor.reports.meetingDate'),
		'present' => Locale::translate('editor.reports.isPresent'),
		'reason_for_absence' => Locale::translate('editor.reports.reason')
		);
		$yesNoArray = array('present');
		$yesnoMessages = array( 0 => Locale::translate('common.no'), 1 => Locale::translate('common.yes'));
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));
		
		foreach ($ercMembers as $member) {
			$user = $userDao->getUser($member);
			list($meetingsIterator) =  $meetingDao->getMeetingReportByReviewerId($member, $fromDate, $toDate);
		
			$meetings = array();
			while ($row =& $meetingsIterator->next()) {
				foreach ($columns as $index => $junk) {
					if (in_array($index, $yesNoArray)) {
						$columns[$index] = $yesnoMessages[$row[$index]];
					} elseif ($index == "lastname") {
						$columns[$index] = $user->getLastName();
					} elseif ($index == "firstname") {
						$columns[$index] = $user->getFirstName();
					} elseif ($index == "middlename") {
						$columns[$index] = $user->getMiddleName();
					} else {
						$columns[$index] = $row[$index];
					}
				}
				String::fputcsv($fp, $columns);
				unset($row);
			}
		}
		fclose($fp);
	}
	
	/**
	* Added by MSB 10/11/2011
	* Generate csv file for the submission report
	* @param $args (type)
	*/
	function submissionsReport($args) {
		import ('classes.submission.sectionEditor.SubmissionsReportForm');
		parent::validate();
		$this->setupTemplate();
		$submissionsReportForm= new SubmissionsReportForm($args);
		$isSubmit = Request::getUserVar('generateSubmissionsReport') != null ? true : false;
	
		if ($isSubmit) {
			$submissionsReportForm->readInputData();
			if($submissionsReportForm->validate()){
				$this->generateSubmissionsReport($args);
			}else{
				if ($submissionsReportForm->isLocaleResubmit()) {
					$submissionsReportForm->readInputData();
				}
				$submissionsReportForm->display($args);
			}
		}else {
			$submissionsReportForm->display($args);
		}
	}
	
	
	/**
	 * Generate csv file for the submission report
	 * @param $args (type)
	 */
	function generateSubmissionsReport($args) {
		parent::validate();
		$this->setupTemplate();
	
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		
		//Get user filter decision
                $submissionsAndCriterias = $this->_getFilteredSubmissions($journalId);
                $submissions = $submissionsAndCriterias[0];
                $criterias = $submissionsAndCriterias[1];
                
                $reportType = Request::getUserVar('reportType');
                
                switch($reportType){
                    case 0:
                        $this->_CSVReport($submissions, $criterias);
                        break;
                    case 1:
                        $this->_simpleChart($submissions, $criterias, $reportType);
                        break;                    
                    case 2:
                        $this->_simpleChart($submissions, $criterias, $reportType);
                        break;                    
                    default :
                        break;
                }
	}
        
        /*
         * Internal function for obtaining the submissions after user filters
         */
        function _getFilteredSubmissions($journalId) {
            
		$sectionId = Request::getUserVar('decisionCommittee');
		$decisionType = Request::getUserVar('decisionType');
		$decisionStatus = Request::getUserVar('decisionStatus');
		$decisionAfter = Request::getUserVar('decisionAfter');
		$decisionBefore = Request::getUserVar('decisionBefore');
                
		$studentResearch = Request::getUserVar('studentInitiatedResearch');
		$startAfter = Request::getUserVar('startAfter');
		$startBefore = Request::getUserVar('startBefore');
		$endAfter = Request::getUserVar('endAfter');
		$endBefore = Request::getUserVar('endBefore');
		$kiiField = Request::getUserVar('KII');
		$multiCountry = Request::getUserVar('multicountry');
		$countries = Request::getUserVar('countries');
		$geoAreas = Request::getUserVar('geoAreas');
		$researchDomains = Request::getUserVar('researchDomains');
                $researchFields = Request::getUserVar('researchFields');
		$withHumanSubjects = Request::getUserVar('withHumanSubjects');
		$proposalTypes = Request::getUserVar('proposalTypes');
		$dataCollection = Request::getUserVar('dataCollection');

                $budgetOption = Request::getUserVar('budgetOption');
		$budget = Request::getUserVar('budget');
		$sources = Request::getUserVar('sources');
                
		$identityRevealed = Request::getUserVar('identityRevealed');
		$unableToConsent = Request::getUserVar('unableToConsent');
		$under18 = Request::getUserVar('under18');
		$dependentRelationship = Request::getUserVar('dependentRelationship');
		$ethnicMinority = Request::getUserVar('ethnicMinority');
		$impairment = Request::getUserVar('impairment');
		$pregnant = Request::getUserVar('pregnant');
		$newTreatment = Request::getUserVar('newTreatment');
		$bioSamples = Request::getUserVar('bioSamples');
		$exportHumanTissue = Request::getUserVar('exportHumanTissue');
		$exportReason = Request::getUserVar('exportReason');
                $radiation = Request::getUserVar('radiation');
		$distress = Request::getUserVar('distress');
		$inducements = Request::getUserVar('inducements');
		$sensitiveInfo = Request::getUserVar('sensitiveInfo');
		$reproTechnology = Request::getUserVar('reproTechnology');
		$genetic = Request::getUserVar('genetic');
		$stemCell = Request::getUserVar('stemCell');
		$biosafety = Request::getUserVar('biosafety');
                

                $editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');

                $submissions =& $editorSubmissionDao->getEditorSubmissionsReport(
                        $journalId, $sectionId, $decisionType, $decisionStatus, $decisionAfter, $decisionBefore,
                        $studentResearch, $startAfter, $startBefore, $endAfter, $endBefore, $kiiField, $multiCountry, 
                            $countries, $geoAreas, $researchDomains, $researchFields, $withHumanSubjects, $proposalTypes, $dataCollection,
                        $budgetOption, $budget, $sources,
                        $identityRevealed, $unableToConsent, $under18, $dependentRelationship, $ethnicMinority, $impairment, 
                            $pregnant, $newTreatment, $bioSamples, $exportHumanTissue, $exportReason, $radiation, $distress, $inducements, 
                            $sensitiveInfo, $reproTechnology, $genetic, $stemCell, $biosafety);
                
                $criterias = $this->_getCriterias(
                        $sectionId, $decisionType, $decisionStatus, $decisionAfter, $decisionBefore,
                        $studentResearch, $startAfter, $startBefore, $endAfter, $endBefore, $kiiField, $multiCountry, 
                            $countries, $geoAreas, $researchDomains, $researchFields, $withHumanSubjects, $proposalTypes, $dataCollection,
                        $budgetOption, $budget, $sources,
                        $identityRevealed, $unableToConsent, $under18, $dependentRelationship, $ethnicMinority, $impairment, 
                            $pregnant, $newTreatment, $bioSamples, $exportHumanTissue, $exportReason, $radiation, $distress, $inducements, 
                            $sensitiveInfo, $reproTechnology, $genetic, $stemCell, $biosafety                        
                        );
                                                
		return array( 0 => $submissions->toArray(), 1 => $criterias);            
        }
        
        /*
         * Internal function - Get criterias of the research (user filters)
         */
        function &_getCriterias(
                        $sectionId, $decisionType, $decisionStatus, $decisionAfter, $decisionBefore,
                        $studentResearch, $startAfter, $startBefore, $endAfter, $endBefore, $kiiField, $multiCountry, 
                            $countries, $geoAreas, $researchDomains, $researchFields, $withHumanSubjects, $proposalTypes, $dataCollection,
                        $budgetOption, $budget, $sources,
                        $identityRevealed, $unableToConsent, $under18, $dependentRelationship, $ethnicMinority, $impairment, 
                            $pregnant, $newTreatment, $bioSamples, $exportHumanTissue, $exportReason, $radiation, $distress, 
                            $inducements, $sensitiveInfo, $reproTechnology, $genetic, $stemCell, $biosafety
                        ){

                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');

                $criterias = array();	
                
                if ($decisionType && $decisionStatus) {
                    $decisionTypesMap = array(
                        INITIAL_REVIEW => 'submission.initialReview',
                        PROGRESS_REPORT => 'submission.progressReport',
                        PROTOCOL_AMENDMENT => 'submission.protocolAmendment',
                        SERIOUS_ADVERSE_EVENT => 'submission.seriousAdverseEvents',
                        FINAL_REPORT => 'submission.finalReport'
                    );
                    $decisionStatusMap = array(
                        98 => 'editor.reports.aDecisionsIUR',
                        99 => 'editor.reports.aDecisionsEUR',
                        SUBMISSION_SECTION_DECISION_APPROVED => 'editor.article.decision.approved',
                        SUBMISSION_SECTION_DECISION_RESUBMIT => 'editor.article.decision.resubmit',
                        SUBMISSION_SECTION_DECISION_DECLINED => 'editor.article.decision.declined'
                    );
                    if ($sectionId != 0) {
                        $sectionDao =& DAORegistry::getDAO('SectionDAO');
                        $section =& $sectionDao->getSection($sectionId);
                        $string = Locale::translate('editor.reports.fromCommittee').' '.$section->getLocalizedAbbrev();
                    } else {
                        $string = Locale::translate('editor.reports.fromCommittee').' '.Locale::translate('editor.reports.anyCommittee');
                    }                   
                    array_push($criterias, (Locale::translate('editor.reports.oneDecisionIs').': '.Locale::translate($decisionTypesMap[$decisionType]).' '.Locale::translate($decisionStatusMap[$decisionStatus]).' '.$string));                    
                }
                if ($decisionAfter && $decisionAfter != "") {
                    if ($decisionStatus != 98) {array_push($criterias, (Locale::translate('editor.reports.criterias.decisionAfter').' '.$decisionAfter.' '.Locale::translate('editor.reports.dateInclusive')));}
                    else {array_push($criterias, (Locale::translate('editor.reports.criterias.submittedAfter').' '.$decisionAfter.' '.Locale::translate('editor.reports.dateInclusive')));}
                }
                if ($decisionBefore && $decisionBefore != "") {
                    if ($decisionStatus != 98) {array_push($criterias, (Locale::translate('editor.reports.criterias.decisionBefore').' '.$decisionBefore.' '.Locale::translate('editor.reports.dateInclusive')));}
                    else {array_push($criterias, (Locale::translate('editor.reports.criterias.submittedBefore').' '.$decisionBefore.' '.Locale::translate('editor.reports.dateInclusive')));}
                }
                
                $proposalDetails = new ProposalDetails();
                if ($studentResearch) {array_push($criterias, (Locale::translate('proposal.studentInitiatedResearch').': '.Locale::translate($proposalDetails->getYesNoKey($studentResearch))));}
                if ($startAfter && $startAfter != "") {array_push($criterias, (Locale::translate('editor.reports.researchStartAfter').' '.$startAfter.' '.Locale::translate('editor.reports.dateInclusive')));}
                if ($startBefore && $startBefore != "") {array_push($criterias, (Locale::translate('editor.reports.researchStartBefore').' '.$startBefore.' '.Locale::translate('editor.reports.dateInclusive')));}
                if ($endAfter && $endAfter != "") {array_push($criterias, (Locale::translate('editor.reports.researchEndAfter').' '.$endAfter.' '.Locale::translate('editor.reports.dateInclusive')));}
                if ($endBefore && $endBefore != "") {array_push($criterias, (Locale::translate('editor.reports.researchEndBefore').' '.$endBefore.' '.Locale::translate('editor.reports.dateInclusive')));}
                $kiiField = array_filter($kiiField);
                if(!empty($kiiField)){
                    $string = Locale::translate('proposal.keyImplInstitution').': ';
                    for($i = 0; $i < count($kiiField); $i++){
                        $institution = $institutionDao->getInstitutionById($kiiField[$i]);
                        if($i == 0) {$string .= $institution->getInstitutionName();}
                        else {$string .= ' '.Locale::translate('common.or').' '.$institution->getInstitutionName();}
                    }
                    array_push($criterias, $string);
                    unset($string);
                }
                if ($multiCountry) {
                    array_push($criterias, (Locale::translate('proposal.multiCountryResearch').': '.Locale::translate($proposalDetails->getYesNoKey($multiCountry))));                    
                    if ($multiCountry == PROPOSAL_DETAIL_YES){
                        $countries = array_filter($countries);
                        if(!empty($countries)){
                            $string = Locale::translate('common.country').': ';
                            for($i = 0; $i < count($countries); $i++){
                                $countryDao =& DAORegistry::getDAO('CountryDAO');
                                if($i == 0) {$string .= $countryDao->getCountry($countries[$i]);}
                                else {$string .= ' '.Locale::translate('common.or').' '.$countryDao->getCountry($countries[$i]);}
                            }
                            array_push($criterias, $string);
                            unset($string);
                        }                    
                    }
                }
                $geoAreas = array_filter($geoAreas);
                if(!empty($geoAreas)){
                    $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                    $string = Locale::translate('proposal.geoArea').': ';
                    for($i = 0; $i < count($geoAreas); $i++){
                        $extraField =& $extraFieldDao->getExtraField($geoAreas[$i]);
                        if($i == 0) {$string .= (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                        else {$string .= ' '.Locale::translate('common.or').' '.(isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                        unset($extraField);
                    }
                    array_push($criterias, $string);
                    unset($string);
                }
                $researchDomains = array_filter($researchDomains);
                if(!empty($researchDomains)){
                    $string = Locale::translate('proposal.researchDomains').': ';
                    for($i = 0; $i < count($researchDomains); $i++){
                        $extraField =& $extraFieldDao->getExtraField($researchDomains[$i]);
                        if($i == 0) {$string .= (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                        else {$string .= ' '.Locale::translate('common.or').' '.(isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                        unset($extraField);
                    }
                    array_push($criterias, $string);
                    unset($string);
                }
                $researchFields = array_filter($researchFields);
                if(!empty($researchFields)){
                    $string = Locale::translate('proposal.researchField').': ';
                    for($i = 0; $i < count($researchFields); $i++){
                        $extraField =& $extraFieldDao->getExtraField($researchFields[$i]);
                        if($i == 0) {$string .= (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                        else {$string .= ' '.Locale::translate('common.or').' '.(isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                        unset($extraField);
                    }
                    array_push($criterias, $string);
                    unset($string);
                }
                if ($withHumanSubjects) {
                    array_push($criterias, (Locale::translate('proposal.withHumanSubjects').': '.Locale::translate($proposalDetails->getYesNoKey($withHumanSubjects))));                    
                    if ($withHumanSubjects == PROPOSAL_DETAIL_YES){
                        $proposalTypes = array_filter($proposalTypes);
                        if(!empty($proposalTypes)){                            
                            $string = Locale::translate('proposal.proposalType').': ';
                            for($i = 0; $i < count($proposalTypes); $i++){
                                $extraField =& $extraFieldDao->getExtraField($proposalTypes[$i]);
                                if($i == 0) {$string .= (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                                else {$string .= ' '.Locale::translate('common.or').' '.(isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);}
                                unset($extraField);
                            }
                            array_push($criterias, $string);
                            unset($string);
                        }                    
                    }
                }
                if ($dataCollection) {array_push($criterias, (Locale::translate('proposal.dataCollection').': '.Locale::translate($proposalDetails->getYesNoKey($dataCollection))));}

                if ($budget && $budget != "") {array_push($criterias, (Locale::translate('proposal.fundsRequired').' '.$budgetOption.' '.$budget));}
                $sources = array_filter($sources);
                if(!empty($sources)){
                    $string = Locale::translate('proposal.source').': ';
                    for($i = 0; $i < count($sources); $i++){
                        $institution = $institutionDao->getInstitutionById($sources[$i]);
                        if($i == 0) {$string .= $institution->getInstitutionName();}
                        else {$string .= ' '.Locale::translate('common.or').' '.$institution->getInstitutionName();}
                    }
                    array_push($criterias, $string);
                    unset($string);
                }
                
                $riskAssessment = new RiskAssessment();
                if ($identityRevealed != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.identityRevealed').' '.Locale::translate($riskAssessment->getYesNoKey($identityRevealed))));}
                if ($unableToConsent != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.unableToConsent').' '.Locale::translate($riskAssessment->getYesNoKey($unableToConsent))));}
                if ($under18 != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.under18').' '.Locale::translate($riskAssessment->getYesNoKey($under18))));}
                if ($dependentRelationship != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.dependentRelationship').' '.Locale::translate($riskAssessment->getYesNoKey($dependentRelationship))));}
                if ($ethnicMinority != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.ethnicMinority').' '.Locale::translate($riskAssessment->getYesNoKey($ethnicMinority))));}
                if ($impairment != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.impairment').' '.Locale::translate($riskAssessment->getYesNoKey($impairment))));}
                if ($pregnant != null) {array_push($criterias, (Locale::translate('proposal.researchIncludesHumanSubject').' '.Locale::translate('proposal.pregnant').' '.Locale::translate($riskAssessment->getYesNoKey($pregnant))));}
                if ($newTreatment != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.newTreatment').' '.Locale::translate($riskAssessment->getYesNoKey($newTreatment))));}
                if ($bioSamples != null) {
                    array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.bioSamples').' '.Locale::translate($riskAssessment->getYesNoKey($bioSamples))));
                    if ($bioSamples == RISK_ASSESSMENT_YES){
                        if ($exportHumanTissue != null) {
                            array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.exportHumanTissue').' '.Locale::translate($riskAssessment->getYesNoKey($exportHumanTissue))));                            
                            if ($exportHumanTissue == RISK_ASSESSMENT_YES){
                                if ($exportReason != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.exportReason').' '.Locale::translate($riskAssessment->getExportReasonKey())));}            
                            }
                        }                    
                    }
                }
                if ($radiation != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.radiation').' '.Locale::translate($riskAssessment->getYesNoKey($radiation))));}
                if ($distress != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.distress').' '.Locale::translate($riskAssessment->getYesNoKey($distress))));}
                if ($inducements != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.inducements').' '.Locale::translate($riskAssessment->getYesNoKey($inducements))));}
                if ($sensitiveInfo != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.sensitiveInfo').' '.Locale::translate($riskAssessment->getYesNoKey($sensitiveInfo))));}
                if ($reproTechnology != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.reproTechnology').' '.Locale::translate($riskAssessment->getYesNoKey($reproTechnology))));}
                if ($genetic != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.genetic').' '.Locale::translate($riskAssessment->getYesNoKey($genetic))));}
                if ($stemCell != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.stemCell').' '.Locale::translate($riskAssessment->getYesNoKey($stemCell))));}
                if ($biosafety != null) {array_push($criterias, (Locale::translate('proposal.researchIncludes').' '.Locale::translate('proposal.biosafety').' '.Locale::translate($riskAssessment->getYesNoKey($biosafety))));}
                
                return $criterias;
        }
        
        function _CSVReport($proposals, $criterias){
                
                $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                $countryDao =& DAORegistry::getDAO('CountryDAO');
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');

                $journal =& Request::getJournal();

                header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=' . str_replace(' ', '', $journal->getLocalizedInitials()) . '-' . date('YMd') . '-' . Locale::translate('editor.report') . '.csv');
		
		$fp = fopen('php://output', 'wt');
                
                $columns = $this->_getColumnsOfCSV();
                
		//Write into the csv
		String::fputcsv($fp, array_values($columns));
		
		foreach ($proposals as $proposal) {
                    $decisions = $proposal->getDecisions();
                    $investigators = $proposal->getAuthors();    
                    $abstract = $proposal->getLocalizedAbstract();    
                    $proposalDetails = $proposal->getProposalDetails();    
                    $studentResearch = $proposalDetails->getStudentResearchInfo();    
                    $sources = $proposal->getSources();    
                    $riskAssessment = $proposal->getRiskAssessment();
                    
                    // Set up the for loops in case of multi entries for one proposal
                    if(array_key_exists('committee', $columns)){$decisionsCount = count($decisions);} 
                    else {$decisionsCount = 1;}
                    if(Request::getUserVar('checkAllInvestigators')){$investigatorsCount = count($investigators);} 
                    else {$investigatorsCount = 1;}
                    if(array_key_exists('countries', $columns)){
                        $countries = $proposalDetails->getCountries();
                        if($countries){
                            $countriesArray = explode(",", $countries);
                            $countriesCount = count($countriesArray);                            
                        } else {$countriesCount = 1;}
                    } else {$countriesCount = 1;}
                    if(array_key_exists('nationwide', $columns)){
                        $geoAreas = $proposalDetails->getCountries();
                        if($geoAreas){
                            $geoAreasArray = explode(",", $geoAreas);
                            $geoAreasCount = count($geoAreasArray);                            
                        } else {$geoAreasCount = 1;}
                    } else {$geoAreasCount = 1;}
                    if(array_key_exists('researchDomain', $columns)){
                        $researchDomainsArray = $proposalDetails->getResearchDomainsArray();
                        if($researchDomainsArray){
                            $researchDomainsCount = count($researchDomainsArray);                            
                        } else {$researchDomainsCount = 1;}
                    } else {$researchDomainsCount = 1;}
                    if(array_key_exists('researchField', $columns)){
                        $researchFields = $proposalDetails->getResearchFields();
                        if($researchFields){
                            $researchFieldsArray = explode("+", $researchFields);
                            $researchFieldsCount = count($researchFieldsArray);                            
                        } else {$researchFieldsCount = 1;}
                    } else {$researchFieldsCount = 1;}
                    if(array_key_exists('proposalType', $columns)){
                        $proposalTypes = $proposalDetails->getProposalTypes();
                        if($proposalTypes){
                            $proposalTypesArray = explode("+", $proposalTypes);
                            $proposalTypesCount = count($proposalTypesArray);                            
                        } else {$proposalTypesCount = 1;}
                    } else {$proposalTypesCount = 1;}
                    if(array_key_exists('sourceInstitution', $columns)){$sourcesCount = count($sources);} 
                    else {$sourcesCount = 1;}
                    
                    
                    // Loop through all the possible mutli entries and write the data
                    for($dI = 0; $dI < $decisionsCount; $dI++){
                        for($iI = 0; $iI < $investigatorsCount; $iI++){
                            for($cI = 0; $cI < $countriesCount; $cI++){
                                for($aI = 0; $aI < $geoAreasCount; $aI++){
                                    for($rdI = 0; $rdI < $researchDomainsCount; $rdI++){                                        
                                        for($fI = 0; $fI < $researchFieldsCount; $fI++){
                                            for($tI = 0; $tI < $proposalTypesCount; $tI++){
                                                for($sI = 0; $sI < $sourcesCount; $sI++){
                                                    foreach ($columns as $index => $junk) {

                                                        // General
                                                        if ($index == 'proposalId') {
                                                            $columns[$index] = $proposal->getProposalId();
                                                        } elseif ($index == 'committee') {
                                                            $columns[$index] = $decisions[$dI]->getSectionAcronym();
                                                        } elseif ($index == 'decisionType') {
                                                            $columns[$index] = Locale::translate($decisions[$dI]->getReviewTypeKey());
                                                        } elseif ($index == 'decisionStatus') {
                                                            $columns[$index] = Locale::translate($decisions[$dI]->getReviewStatusKey());
                                                        } elseif ($index == 'decisionDate') {
                                                            $columns[$index] = date("d-M-Y", strtotime($decisions[$dI]->getDateDecided()));
                                                        } elseif ($index == 'submitDate') {
                                                            $columns[$index] = date("d-M-Y", strtotime($proposal->getDateSubmitted()));
                                                        }

                                                        // Investigator(s)
                                                        elseif ($index == 'investigator') {
                                                            $columns[$index] = $this->_removeCommaForCSV($investigators[$iI]->getFullName(true));
                                                        } elseif ($index == 'investigatorAffiliation') {
                                                            $columns[$index] = $this->_removeCommaForCSV($investigators[$iI]->getAffiliation());
                                                        } elseif ($index == 'investigatorEmail') {
                                                            $columns[$index] = $investigators[$iI]->getEmail();
                                                        } 

                                                        // Titles and abstract 
                                                        elseif ($index == 'scientificTitle') {
                                                            $columns[$index] = $this->_replaceQuoteCSV($abstract->getCleanScientificTitle());
                                                        } elseif ($index == 'publicTitle') {
                                                            $columns[$index] = $this->_replaceQuoteCSV($abstract->getCleanPublicTitle());
                                                        } elseif ($index == 'background') {
                                                            $columns[$index] = $this->_replaceQuoteCSV($abstract->getBackground());
                                                        } elseif ($index == 'objectives') {
                                                            $columns[$index] = $this->_replaceQuoteCSV($abstract->getObjectives());
                                                        } elseif ($index == 'studyMethods') {
                                                            $columns[$index] = $this->_replaceQuoteCSV($abstract->getStudyMethods());
                                                        } elseif ($index == 'expectedOutcomes') {
                                                            $columns[$index] = $this->_replaceQuoteCSV($abstract->getExpectedOutcomes());
                                                        } 

                                                        // Proposal Details
                                                        elseif ($index == 'studentInstitution') {
                                                            if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) {$columns[$index] = $studentResearch->getInstitution();}
                                                            else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'studentAcademicDegree') {
                                                            if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES) {$columns[$index] = Locale::translate($studentResearch->getDegreeKey());}
                                                            else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'startDate') {
                                                            $columns[$index] = $proposalDetails->getStartDate();
                                                        } elseif ($index == 'endDate') {
                                                            $columns[$index] = $proposalDetails->getEndDate();
                                                        } elseif ($index == 'kii') {
                                                            $institution = $institutionDao->getInstitutionById($proposalDetails->getKeyImplInstitution());
                                                            $columns[$index] = $institution->getInstitutionName();
                                                        } elseif ($index == 'countries') {
                                                            if($proposalDetails->getMultiCountryResearch() == PROPOSAL_DETAIL_YES){$columns[$index] = $countryDao->getCountry($countriesArray[$cI]);}
                                                            else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'nationwide') {
                                                            if($proposalDetails->getMultiCountryResearch() != PROPOSAL_DETAIL_YES){
                                                                $extraField =& $extraFieldDao->getExtraField($geoAreasArray[$aI]);
                                                                $columns[$index] = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);
                                                                unset($extraField);
                                                            } else {$columns[$index] = Locale::translate('editor.reports.nationwide');}
                                                        } elseif ($index == 'researchDomain') {
                                                            if($researchDomainsArray){
                                                                $extraField =& $extraFieldDao->getExtraField($researchDomainsArray[$rdI]);
                                                                $columns[$index] = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);
                                                                unset($extraField);
                                                            } else {$columns[$index] = Locale::translate('common.dataNotProvided');}
                                                        } elseif ($index == 'researchField') {
                                                            if($researchFieldsArray){
                                                                $extraField =& $extraFieldDao->getExtraField($researchFieldsArray[$fI]);
                                                                $columns[$index] = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);
                                                                unset($extraField);
                                                            } else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'proposalType') {
                                                            if($proposalDetails->getHumanSubjects() != PROPOSAL_DETAIL_YES){
                                                                $extraField =& $extraFieldDao->getExtraField($proposalTypesArray[$tI]);
                                                                $columns[$index] = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : null);
                                                                unset($extraField);
                                                            } else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'dataCollection') {
                                                            $columns[$index] = Locale::translate($proposalDetails->getDataCollectionKey());
                                                        } 

                                                        // Sources of Monetary or Material Support
                                                        elseif ($index == 'totalBudget') {
                                                            $columns[$index] = $proposal->getTotalBudget();
                                                        } elseif ($index == 'sourceInstitution') {
                                                            $institution = $institutionDao->getInstitutionById($sources[$sI]->getInstitutionId());
                                                            $columns[$index] = $institution->getInstitutionName();
                                                        } elseif ($index == 'sourceAmount') {
                                                            $columns[$index] = $sources[$sI]->getSourceAmount();
                                                        } 

                                                        // Risk Assesment
                                                        elseif ($index == 'identityRevealed') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getIdentityRevealed()));
                                                        } elseif ($index == 'unableToConsent') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getUnableToConsent()));
                                                        } elseif ($index == 'under18') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getUnder18()));
                                                        } elseif ($index == 'dependentRelationship') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getDependentRelationship()));
                                                        } elseif ($index == 'ethnicMinority') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getEthnicMinority()));
                                                        } elseif ($index == 'impairment') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getImpairment()));
                                                        } elseif ($index == 'pregnant') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getPregnant()));
                                                        } elseif ($index == 'newTreatment') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getNewTreatment()));
                                                        } elseif ($index == 'bioSamples') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getBioSamples()));
                                                        } elseif ($index == 'exportHumanTissue') {
                                                            if ($riskAssessment->getBioSamples() == RISK_ASSESSMENT_YES){$columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getExportHumanTissue()));}
                                                            else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'exportReason') {
                                                            if ($riskAssessment->getBioSamples() == RISK_ASSESSMENT_YES && $riskAssessment->getExportHumanTissue() == RISK_ASSESSMENT_YES){$columns[$index] = Locale::translate($riskAssessment->getExportReasonKey());}
                                                            else {$columns[$index] = Locale::translate('editor.reports.notApplicable');}
                                                        } elseif ($index == 'radiation') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getRadiation()));
                                                        } elseif ($index == 'distress') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getDistress()));
                                                        } elseif ($index == 'inducements') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getInducements()));
                                                        } elseif ($index == 'sensitiveInfo') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getSensitiveInfo()));
                                                        } elseif ($index == 'reproTechnology') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getReproTechnology()));
                                                        } elseif ($index == 'genetic') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getGenetic()));
                                                        } elseif ($index == 'stemCell') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getStemCell()));
                                                        } elseif ($index == 'biosafety') {
                                                            $columns[$index] = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getBiosafety()));
                                                        }                                                

                                                    }						
                                                    String::fputcsv($fp, $columns);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
		}
                
                // Display or not the search criterias on the bottom of the CSV file
                if(Request::getUserVar('checkShowCriterias')){
                    String::fputcsv($fp, array(''));
                    String::fputcsv($fp, array(''));
                    if (!empty($criterias)) {
                        $i = 0;
                        foreach ($criterias as $criteria) {
                            if ($i != 0) {
                                $criteria = Locale::translate('common.and').' '.$criteria;
                                String::fputcsv($fp, array('', $criteria));
                            } else {
                                    String::fputcsv($fp, array(Locale::translate('editor.reports.criterias'), $criteria));
                            }	
                            $i++;			
                        }
                    }                    
                } 
		
		fclose($fp);
            
        }
        
        /*
         * Internal function for getting the user' selection of columns for the CSV
         * @return columns Array
         */
        function &_getColumnsOfCSV(){
            
                $journal =& Request::getJournal();
            
		// Implement the columns of the CSV 
		$columns = array();
		
                // General
		if (Request::getUserVar('checkProposalId')){
			$columns = $columns + array('proposalId' => Locale::translate("common.proposalId"));
		}
		if (Request::getUserVar('checkDecisions')){
			$columns = $columns + array('committee' => Locale::translate("editor.article.committee"));
			$columns = $columns + array('decisionType' => Locale::translate("editor.reports.decisionType"));
			$columns = $columns + array('decisionStatus' => Locale::translate("editor.reports.decisionStatus"));
			$columns = $columns + array('decisionDate' => Locale::translate("editor.reports.decisionDate"));
		}
		if (Request::getUserVar('checkDateSubmitted')){
			$columns = $columns + array('submitDate' =>  Locale::translate("editor.reports.submitDate"));
		}
                
                // Investigator(s)
		if (Request::getUserVar('checkName')){
			$columns = $columns + array('investigator' => Locale::translate("editor.reports.author"));
		}
		if (Request::getUserVar('checkAffiliation')){
			$columns = $columns + array('investigatorAffiliation' => Locale::translate("editor.reports.authorAffiliation"));
		}
		if (Request::getUserVar('checkEmail')){
			$columns = $columns + array('investigatorEmail' => Locale::translate("editor.reports.authorEmail"));
		}
                
                // Titles and Abstract
		if (Request::getUserVar('checkScientificTitle')){
			$columns = $columns + array('scientificTitle' => Locale::translate("editor.reports.scientificTitle"));
		}
		if (Request::getUserVar('checkPublicTitle')){
			$columns = $columns + array('publicTitle' => Locale::translate("editor.reports.publicTitle"));
		}
                if (Request::getUserVar('checkBackground')){
			$columns = $columns + array('background' => Locale::translate("proposal.background"));
		}
                if (Request::getUserVar('checkObjectives')){
			$columns = $columns + array('objectives' => Locale::translate("proposal.objectives"));
		}
                if (Request::getUserVar('checkStudyMethods')){
			$columns = $columns + array('studyMethods' => Locale::translate("proposal.studyMethods"));
		}
                if (Request::getUserVar('checkExpectedOutcomes')){
			$columns = $columns + array('expectedOutcomes' => Locale::translate("proposal.expectedOutcomes"));
		}
                
                // Proposal Details
		if (Request::getUserVar('checkStudentResearch')){
			$columns = $columns + array('studentInstitution' => Locale::translate("editor.reports.studentInstitution"));
			$columns = $columns + array('studentAcademicDegree' => Locale::translate("editor.reports.studentAcademicDegree"));
		}
		if (Request::getUserVar('checkResearchDates')){
			$columns = $columns + array('startDate' => Locale::translate("proposal.startDate"));
			$columns = $columns + array('endDate' => Locale::translate("proposal.endDate"));
                }                
		if (Request::getUserVar('checkKii')){
			$columns = $columns + array('kii' => Locale::translate("proposal.keyImplInstitution"));
		}
		if (Request::getUserVar('checkMultiCountry')){
			$columns = $columns + array('countries' => Locale::translate("proposal.multiCountryResearch"));
		}
		if (Request::getUserVar('nationwide')){
			$columns = $columns + array('nationwide' => Locale::translate("proposal.nationwide"));
		}                
		if (Request::getUserVar('checkResearchDomain')){
			$columns = $columns + array('researchDomain' => Locale::translate("proposal.researchDomains"));
		}
                if (Request::getUserVar('checkResearchField')){
			$columns = $columns + array('researchField' => Locale::translate("proposal.researchField"));
		}
		if (Request::getUserVar('checkProposalType')){
			$columns = $columns + array('proposalType' => Locale::translate("editor.reports.proposalType"));
		}
		if (Request::getUserVar('checkDataCollection')){
			$columns = $columns + array('dataCollection' => Locale::translate("editor.reports.dataCollection"));
		}
                
                // Sources of Monetary and Material Support
		if (Request::getUserVar('checkTotalBudget')){
			$columns = $columns + array('totalBudget' => Locale::translate("proposal.fundsRequired").' ('.$journal->getSetting('sourceCurrency').')');
		}
		if (Request::getUserVar('checkSources')){
			$columns = $columns + array('sourceInstitution' => Locale::translate("editor.reports.spreadsheet.sourceInstitution"));
			$columns = $columns + array('sourceAmount' => Locale::translate("editor.reports.spreadsheet.sourceAmount").' ('.$journal->getSetting('sourceCurrency').')');                        
		}
                
                // Risk Assessment
		if (Request::getUserVar('checkIdentityRevealed')){
			$columns = $columns + array('identityRevealed' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.identityRevealedAbb'));
		}
		if (Request::getUserVar('checkUnableToConsent')){
			$columns = $columns + array('unableToConsent' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.unableToConsentAbb'));
		}
		if (Request::getUserVar('checkUnder18')){
			$columns = $columns + array('under18' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.under18Abb'));
		}
		if (Request::getUserVar('checkDependentRelationship')){
			$columns = $columns + array('dependentRelationship' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.dependentRelationshipAbb'));
		}
		if (Request::getUserVar('checkEthnicMinority')){
			$columns = $columns + array('ethnicMinority' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.ethnicMinorityAbb'));
		}
		if (Request::getUserVar('checkImpairment')){
			$columns = $columns + array('impairment' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.impairmentAbb'));
		}
		if (Request::getUserVar('checkPregnant')){
			$columns = $columns + array('pregnant' => Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.pregnantAbb'));
		}
		if (Request::getUserVar('checkNewTreatment')){
			$columns = $columns + array('newTreatment' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.newTreatmentAbb'));
		}
		if (Request::getUserVar('checkBioSamples')){
			$columns = $columns + array('bioSamples' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.bioSamplesAbb'));
			$columns = $columns + array('exportHumanTissue' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.exportHumanTissueAbb'));
			$columns = $columns + array('exportReason' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.exportReason'));                        
                }
		if (Request::getUserVar('checkRadiation')){
			$columns = $columns + array('radiation' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.radiationAbb'));
		}
		if (Request::getUserVar('checkDistress')){
			$columns = $columns + array('distress' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.distressAbb'));
		}
		if (Request::getUserVar('checkInducements')){
			$columns = $columns + array('inducements' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.inducementsAbb'));
		}
		if (Request::getUserVar('checkSensitiveInfo')){
			$columns = $columns + array('sensitiveInfo' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.sensitiveInfoAbb'));
		}
		if (Request::getUserVar('checkReproTechnology')){
			$columns = $columns + array('reproTechnology' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.reproTechnologyAbb'));
		}
		if (Request::getUserVar('checkGenetic')){
			$columns = $columns + array('genetic' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.geneticsAbb'));
		}
		if (Request::getUserVar('checkStemCell')){
			$columns = $columns + array('stemCell' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.stemCellAbb'));
		}
		if (Request::getUserVar('checkBiosafety')){
			$columns = $columns + array('biosafety' => Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.biosafetyAbb'));
		}
                
                return $columns;
            
        }
        
        /*
         * Internal function for removing the comma(s) of a string before a CSV export
         */
        function _removeCommaForCSV($string){
            //also remove newlines
            $string = preg_replace('/\s+/', ' ', trim($string));
            return str_replace(',', '', $string);
        }
        
        /*
         * Internal function for replacing all double quotes of a string by single quote and brace it with double quote
         */
        function _replaceQuoteCSV($string){
            //also remove newlines
            $string = preg_replace('/\s+/', ' ', trim($string));
            return '"'.str_replace('"', "'", $string).'"';
        }
        
        function _simpleChart($proposals, $criterias, $reportType){
            
            $countryDao =& DAORegistry::getDAO('CountryDAO');
            $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
            
            $this->setupTemplate();
            $journal =& Request::getJournal();
                
            $measurement = Request::getUserVar('measurement');
            $chartOptions = Request::getUserVar('chartOptions');
            
            import('classes.lib.libchart.classes.libchart');
            
            if ($reportType == 1) {$pieChart = new PieChart();}
            elseif ($reportType == 2) {$pieChart = new VerticalBarChart();}
            
            $dataSet = new XYDataSet();
            $dataSetArray = array();
            
            $keyNA = Locale::translate('editor.reports.notApplicable');
            $keyN = Locale::translate('editor.reports.nationwide');
            $keyWHS = Locale::translate('editor.reports.chart.withoutHumanSubjects');
            
            if ($measurement == 0){$endTitle = Locale::translate('common.bySomebody').' '.Locale::translate('editor.reports.measurement.proposalNmbre');} 
            else {$endTitle = Locale::translate('common.bySomebody').' '.Locale::translate('editor.reports.measurement.cumulatedBudget');}
            
            foreach ($proposals as $proposal){
                if ($measurement == 0){ $toSumUp = (int) 1;} 
                else {$toSumUp = (int) $proposal->getTotalBudget();}
                $proposalDetails = $proposal->getProposalDetails();
                $riskAssessment = $proposal->getRiskAssessment();
                if ($chartOptions == 'studentResearch'){
                    if ($proposalDetails->getStudentResearch() == PROPOSAL_DETAIL_YES){
                        $studentResearchInfo = $proposalDetails->getStudentResearchInfo();
                        $key = Locale::translate($studentResearchInfo->getDegreeKey());
                        if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                        else {$dataSetArray[$key] = (int) $toSumUp;}
                        unset($key);
                    } else {
                        if(array_key_exists($keyNA, $dataSetArray)){$dataSetArray[$keyNA] = $dataSetArray[$keyNA] + $toSumUp;} 
                        else {$dataSetArray[$keyNA] = (int) $toSumUp;}
                    }
                } elseif ($chartOptions == 'kii') {
                    $key = $proposalDetails->getKeyImplInstitutionAcronym();
                    if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                    else {$dataSetArray[$key] = (int) $toSumUp;}
                    unset($key);                    
                } elseif ($chartOptions == 'multiCountry') {
                    if ($proposalDetails->getMultiCountryResearch() == PROPOSAL_DETAIL_YES) {
                        $countries = $proposalDetails->getCountries();
                        $countries = explode(',', $countries);
                        foreach ($countries as $country) {
                            $key = $countryDao->getCountry($country);
                            if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                            else {$dataSetArray[$key] = (int) $toSumUp;}      
                            unset($key);
                        }
                    } else {
                        if(array_key_exists($keyNA, $dataSetArray)){$dataSetArray[$keyNA] = $dataSetArray[$keyNA] + $toSumUp;} 
                        else {$dataSetArray[$keyNA] = (int) $toSumUp;}      
                    }
                } elseif ($chartOptions == 'nationwide') {
                    if ($proposalDetails->getNationwide() != PROPOSAL_DETAIL_YES) {
                        $geoAreas = $proposalDetails->getGeoAreasArray();
                        foreach ($geoAreas as $geoArea) {
                            $extraField =& $extraFieldDao->getExtraField($geoArea);
                            $key = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : '-');
                            if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                            else {$dataSetArray[$key] = (int) $toSumUp;}
                            unset($key);
                            unset($extraField);
                        }
                    } else {
                        if(array_key_exists($keyN, $dataSetArray)){$dataSetArray[$keyN] = $dataSetArray[$keyN] + $toSumUp;} 
                        else {$dataSetArray[$keyN] = (int) $toSumUp;}
                    }               
                } elseif ($chartOptions == 'proposalTypes') {
                    if ($proposalDetails->getHumanSubjects() == PROPOSAL_DETAIL_YES) {
                        $proposalTypes = $proposalDetails->getProposalTypesArray();
                        foreach ($proposalTypes as $proposalType) {
                            $extraField =& $extraFieldDao->getExtraField($proposalType);
                            $key = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : '-');
                            if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                            else {$dataSetArray[$key] = (int) $toSumUp;}
                            unset($key);
                            unset($extraField);
                        }
                    } else {
                        if(array_key_exists($keyWHS, $dataSetArray)){$dataSetArray[$keyWHS] = $dataSetArray[$keyWHS] + $toSumUp;} 
                        else {$dataSetArray[$keyWHS] = (int) $toSumUp;}
                    }
                } elseif ($chartOptions == 'researchDomains') {
                    $researchDomains = $proposalDetails->getResearchDomainsArray();
                    foreach ($researchDomains as $researchDomain) {
                        $extraField =& $extraFieldDao->getExtraField($researchDomain);
                        $key = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : '-');
                        if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                        else {$dataSetArray[$key] = (int) $toSumUp;}     
                        unset($key);
                        unset($extraField);
                    }
                } elseif ($chartOptions == 'researchFields') {
                    $researchFields = $proposalDetails->getResearchFieldsArray();
                    foreach ($researchFields as $researchField) {
                        $extraField =& $extraFieldDao->getExtraField($researchField);
                        $key = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : '-');
                        if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                        else {$dataSetArray[$key] = (int) $toSumUp;}     
                        unset($key);
                        unset($extraField);
                    }
                } elseif ($chartOptions == 'dataCollection') {
                    $key = Locale::translate($proposalDetails->getDataCollectionKey());
                    if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                    else {$dataSetArray[$key] = (int) $toSumUp;}
                    unset($key);                    
                } elseif ($chartOptions == 'exportHumanTissue') {
                    if ($riskAssessment->getBioSamples() == RISK_ASSESSMENT_YES) {
                        $key = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->getExportHumanTissue()));
                        if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                        else {$dataSetArray[$key] = (int) $toSumUp;}
                        unset($key);                                            
                    } else {
                        if(array_key_exists($keyNA, $dataSetArray)){$dataSetArray[$keyNA] = $dataSetArray[$keyNA] + $toSumUp;} 
                        else {$dataSetArray[$keyNA] = (int) $toSumUp;}                        
                    }
                } elseif ($chartOptions == 'exportReason') {
                    if ($riskAssessment->getBioSamples() == RISK_ASSESSMENT_YES && $riskAssessment->getExportHumanTissue() == RISK_ASSESSMENT_YES) {
                        $key = Locale::translate($riskAssessment->getExportReasonKey());
                        if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                        else {$dataSetArray[$key] = (int) $toSumUp;}
                        unset($key);
                    } else {
                        if(array_key_exists($keyNA, $dataSetArray)){$dataSetArray[$keyNA] = $dataSetArray[$keyNA] + $toSumUp;} 
                        else {$dataSetArray[$keyNA] = (int) $toSumUp;}                        
                    }
                } else {
                    $key = Locale::translate($riskAssessment->getYesNoKey($riskAssessment->$chartOptions()));
                    if(array_key_exists($key, $dataSetArray)){$dataSetArray[$key] = $dataSetArray[$key] + $toSumUp;} 
                    else {$dataSetArray[$key] = (int) $toSumUp;}
                    unset($key);                    
                }
            }
                                
            switch ($chartOptions) {
                case 'studentResearch': $pieChart->setTitle(Locale::translate('proposal.studentInitiatedResearch').' '.$endTitle); break;
                case 'kii': $pieChart->setTitle(Locale::translate('proposal.keyImplInstitution').' '.$endTitle); break;
                case 'multiCountry': $pieChart->setTitle(Locale::translate('proposal.multiCountryResearch').' '.$endTitle); break;
                case 'nationwide': $pieChart->setTitle(Locale::translate('proposal.nationwide').' '.$endTitle); break;
                case 'proposalTypes': $pieChart->setTitle(Locale::translate('proposal.proposalType').' '.$endTitle); break;
                case 'researchDomains': $pieChart->setTitle(Locale::translate('proposal.researchDomains').' '.$endTitle); break;                
                case 'researchFields': $pieChart->setTitle(Locale::translate('proposal.researchField').' '.$endTitle); break;
                case 'dataCollection': $pieChart->setTitle(Locale::translate('proposal.dataCollection').' '.$endTitle); break;
                case 'getIdentityRevealed': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.identityRevealedAbb').' '.$endTitle); break;
                case 'getUnableToConsent': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.unableToConsentAbb').' '.$endTitle); break;
                case 'getUnder18': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.under18Abb').' '.$endTitle); break;
                case 'getDependentRelationship': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.dependentRelationshipAbb').' '.$endTitle); break;
                case 'getEthnicMinority': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.ethnicMinorityAbb').' '.$endTitle); break;
                case 'getImpairment': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.impairmentAbb').' '.$endTitle); break;
                case 'getPregnant': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.subjects").' - '.Locale::translate('proposal.pregnantAbb').' '.$endTitle); break;
                case 'getNewTreatment': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.newTreatmentAbb').' '.$endTitle); break;
                case 'getBioSamples': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.bioSamplesAbb').' '.$endTitle); break;
                case 'exportHumanTissue': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.exportHumanTissueAbb').' '.$endTitle); break;
                case 'exportReason': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.exportReason').' '.$endTitle); break;
                case 'getRadiation': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.radiationAbb').' '.$endTitle); break;
                case 'getDistress': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.distressAbb').' '.$endTitle); break;
                case 'getInducements': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.inducementsAbb').' '.$endTitle); break;
                case 'getSensitiveInfo': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.sensitiveInfoAbb').' '.$endTitle); break;
                case 'getReproTechnology': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.reproTechnologyAbb').' '.$endTitle); break;
                case 'getGenetic': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.geneticsAbb').' '.$endTitle); break;
                case 'getStemCell': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.stemCellAbb').' '.$endTitle); break;
                case 'getBiosafety': $pieChart->setTitle(Locale::translate("editor.reports.riskAssessment.researchIncludes").' - '.Locale::translate('proposal.biosafetyAbb').' '.$endTitle); break;
            }

            foreach ($dataSetArray as $key => $value){
        	$dataSet->addPoint(new Point($key.' ('.$value.')', $value));                        
            }
            
            $pieChart->setDataSet($dataSet);
            $pieChart->render("classes/lib/libchart/images/".$journal->getLocalizedInitials(). '-'.Locale::translate('editor.reports.chart').".png");
            
            $templateMgr =& TemplateManager::getManager();
            
            $templateMgr->assign('chartLocation', "/classes/lib/libchart/images/".$journal->getLocalizedInitials(). '-'.Locale::translate('editor.reports.chart').".png");
            $templateMgr->assign('criterias', $criterias);
                
            $templateMgr->display('sectionEditor/reports/showChart.tpl');
        }
}

?>
