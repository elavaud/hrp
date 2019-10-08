<?php

/**
 * @file classes/author/form/submit/AuthorSubmitStep2Form.inc.php
 *
 * @class AuthorSubmitStep2Form
 * @ingroup author_form_submit
 *
 * @brief Form for Step 2 of author article submission.
 */

import('classes.author.form.submit.AuthorSubmitForm');
import('classes.form.validation.FormValidatorArrayRadios');

class AuthorSubmitStep2Form extends AuthorSubmitForm {

	/**
	 * Constructor.
	 */
	function AuthorSubmitStep2Form(&$article, &$journal) {
		parent::AuthorSubmitForm($article, 2, $journal);
		
                
                $this->addCheck(new FormValidatorCustom($this, 'authors', 'required', 'author.submit.form.authorRequired', 
                        function($authors) {
                            return count($authors) > 0; 
                        }));
                        
		$this->addCheck(new FormValidatorArray($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', array('firstName', 'lastName', 'affiliation', 'phone')));				
		$this->addCheck(new FormValidatorArray($this, 'abstracts', 'required', 'author.submit.form.abstractRequiredFields', array('scientificTitle', 'publicTitle', 'background', 'objectives', 'studyMethods', 'expectedOutcomes', 'keywords')));
		$this->addCheck(new FormValidatorArrayRadios($this, 'proposalDetails', 'required', 'author.submit.form.proposalDetails', array('studentInitiatedResearch', 'international', 'multiCountryResearch', 'nationwide', 'withHumanSubjects', 'reviewedByOtherErc')));
                
                $this->addCheck(new FormValidatorCustom($this, 'proposalDetails', 'required', 'author.submit.form.KIINameAlreadyUsed', 
                        function($proposalDetails) {
                            $institutionDao = DAORegistry::getDAO("InstitutionDAO");
                            if($institutionDao->institutionExistsByName($proposalDetails["otherInstitutionName"])) {
                                return false;
                            } else {
                                return true;
                            }
                        }));

                $this->addCheck(new FormValidatorCustom($this, 'proposalDetails', 'required', 'author.submit.form.KIIAcronymAlreadyUsed', 
                        function($proposalDetails) {
                            $institutionDao = DAORegistry::getDAO("InstitutionDAO"); 
                            if ($institutionDao->institutionExistsByAcronym($proposalDetails["otherInstitutionAcronym"])) {
                                return false;
                            } else {
                                return true;
                            }
                        }));
                        
                $this->addCheck(new FormValidatorArray($this, 'studentResearch', 'required', 'author.submit.form.studentResearch'));
		//$this->addCheck(new FormValidatorArray($this, 'sources', 'required', 'author.submit.form.sourceRequiredFields', array('institution', 'amount', 'otherInstitutionName', 'otherInstitutionAcronym', 'otherInstitutionType', 'locationCountry', 'locationInternational')));                
                $this->addCheck(new FormValidatorArrayRadios($this, "sources", 'required', 'author.submit.form.sourceRequiredFields', array('international'), true));                
                
                $this->addCheck(new FormValidatorArrayCustom($this, 'sources', 'required', 'author.submit.form.sourceNameAlreadyUsed', 
                        function($otherInstitutionName) {
                            $institutionDao = DAORegistry::getDAO("InstitutionDAO"); 
                            if($institutionDao->institutionExistsByName($otherInstitutionName)) {
                                return false; 
                            } else {
                                return true;
                            }
                        }, array(), false, array('otherInstitutionName')));
                        
                $this->addCheck(new FormValidatorArrayCustom($this, 'sources', 'required', 'author.submit.form.sourceAccronymAlreadyUsed', 
                        function($otherInstitutionAcronym) {
                            $institutionDao = DAORegistry::getDAO("InstitutionDAO"); 
                            if($institutionDao->institutionExistsByAcronym($otherInstitutionAcronym)) {
                                return false; 
                            } else {
                                return true;
                            }
                         }, array(), false, array('otherInstitutionAcronym'))); 
                         
                $this->addCheck(new FormValidatorArrayCustom($this, 'sources', 'required', 'author.submit.form.nonNumericValue', 
                        function($amount) {
                            return ctype_digit($amount);
                         }, array(), false, array('amount')));                          
                         
                $this->addCheck(new FormValidatorCustom($this, 'sources', 'required', 'author.submit.form.sameSource', 
                        function($sources) {
                            $institutionArray = array();
                            foreach($sources as $source) {
                                if ($source["institution"] != "OTHER" && $source["institution"] != "") {
                                    array_push($institutionArray, $source["institution"]);
                                }
                            }
                            if (count($institutionArray) != count(array_unique($institutionArray))) {
                                return false;
                            }
                            else {
                                return true;
                            }
                         })); 
                         
                if(isset($_POST['proposalDetails'])) {         
                    $this->addCheck(new FormValidatorCustom($this, 'sources', 'required', 'author.submit.form.sameInstitutionEntries', 
                            function($sources, $KIIOtherInstitutionName, $KIIOtherInstitutionAcronym) {
                                $institutionNameArray = array(); 
                                $institutionAcronymArray = array(); 
                                foreach($sources as $source){
                                    if($source["otherInstitutionName"] != "NA") {
                                        array_push($institutionNameArray, $source["otherInstitutionName"]);
                                    }
                                    if($source["otherInstitutionAcronym"] != "NA") {
                                        array_push($institutionAcronymArray, $source["otherInstitutionAcronym"]);
                                    }
                                }
                                if($KIIOtherInstitutionName != "NA") {
                                    array_push($institutionNameArray, $KIIOtherInstitutionName);
                                }
                                if($KIIOtherInstitutionAcronym != "NA") {
                                    array_push($institutionAcronymArray, $KIIOtherInstitutionAcronym);
                                }
                                if(count($institutionNameArray) != count(array_intersect_key($institutionNameArray,array_unique(array_map('strtolower',$institutionNameArray))))) {
                                    return false;
                                } elseif (count($institutionAcronymArray) != count(array_intersect_key($institutionAcronymArray,array_unique(array_map('strtolower',$institutionAcronymArray))))) {
                                    return false;
                                }
                                else {
                                    return true;
                                }
                             }, array($_POST["proposalDetails"]["otherInstitutionName"], $_POST["proposalDetails"]["otherInstitutionAcronym"])));
                }
                
                $this->addCheck(new FormValidatorArrayRadios($this, "riskAssessment", 'required', 'author.submit.form.riskAssessment', array('identityRevealed', 'unableToConsent', 'under18', 'dependentRelationship', 'ethnicMinority', 'impairment', 'pregnant', 'newTreatment', 'bioSamples', 'exportHumanTissue', 'exportReason', 'radiation', 'distress', 'inducements', 'sensitiveInfo', 'reproTechnology', 'genetic', 'stemCell', 'biosafety', 'multiInstitutions', 'conflictOfInterest')));
        }

	/**
	 * Initialize form data from current article.
	 */
	function initData() {
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		if (isset($this->article)) {
			$article =& $this->article;
                        // Initialize th proposal details
                        $proposalDetails =& $article->getProposalDetails();

                        $countriesArray = $proposalDetails->getCountries();
			$countries = explode(",", $countriesArray);
                        
                        $geoAreas = $proposalDetails->getGeoAreasArray();
                        if($geoAreas == null){
                            $geoAreas = array(0 => '');
                        }
                        
                        $researchDomainsArray = $proposalDetails->getResearchDomainsArray();
                        if($researchDomainsArray == null){
                            $researchDomainsArray = array(0 => '');
                        }
                        
                        $researchFieldsArray = $proposalDetails->getResearchFieldsArray();
                        if ($researchFieldsArray == null) {
                            $researchFieldsArray = array(0 => '');
                        } else {
                            $i = 0;     
                            foreach ($researchFieldsArray as $field){
                                if (preg_match('#^Other\s\(.+\)$#', $field)){
                                        $tempField = $field;
                                    $field = preg_replace('#^Other\s\(.+\)$#','OTHER', $field);
                                    $tempField = preg_replace('#^Other\s\(#','', $tempField);
                                    $tempField = preg_replace('#\)$#','', $tempField);
                                    $proposalDetails->setOtherResearchField($tempField);
                                }
                                $test = array($i => $field);
                                $researchFieldsArray = array_replace($researchFieldsArray, $test);
                                $i++;
                                unset ($field);
                            }                            
                        }

                        $proposalTypesArray = $proposalDetails->getProposalTypesArray();
                        if ($proposalTypesArray == null) {
                            $proposalTypesArray = array(0 => '');
                        } else {
                            $f = 0;
                            foreach ($proposalTypesArray as $type){
                                if (preg_match('#^Other\s\(.+\)$#', $type)){
                                    $tempType = $type;
                                    $type = preg_replace('#^Other\s\(.+\)$#','OTHER', $type);
                                    $tempType = preg_replace('#^Other\s\(#','', $tempType);
                                    $tempType = preg_replace('#\)$#','', $tempType);
                                    $proposalDetails->setOtherProposalType($tempType);
                                }
                                $test2 = array($f => $type);
                                $proposalTypesArray = array_replace ($proposalTypesArray, $test2);
                                $f++;
                                unset ($type);
                            }
                        }
                        
                        $committeeReviewed = $proposalDetails->getCommitteeReviewed();
                        if ($committeeReviewed == "2" || $committeeReviewed == "3") {
                            $reviewedByOtherErc = "2";
                            $otherErcDecision = $committeeReviewed;
                        } elseif ($committeeReviewed == "1") {
                            $reviewedByOtherErc = $committeeReviewed;
                            $otherErcDecision = $committeeReviewed;
                        } else {
                            $reviewedByOtherErc = null;
                            $otherErcDecision = "1";                            
                        }
                        
                        $proposalDetailsArray = array(
                            'studentInitiatedResearch' => $proposalDetails->getStudentResearch(),
                            'startDate' => $proposalDetails->getStartDate(),
                            'endDate' => $proposalDetails->getEndDate(),
                            'keyImplInstitution' => $proposalDetails->getKeyImplInstitution(),
                            'multiCountryResearch' => $proposalDetails->getMultiCountryResearch(),
                            'countries' => $countries,
                            'nationwide' => $proposalDetails->getNationwide(),
                            'geoAreas' => $geoAreas,
                            'researchDomains' => $researchDomainsArray,
                            'researchFields' => $researchFieldsArray,
                            'otherResearchField' => $proposalDetails->getOtherResearchField(),
                            'withHumanSubjects' => $proposalDetails->getHumanSubjects(),
                            'proposalTypes' => $proposalTypesArray,
                            'otherProposalType' => $proposalDetails->getOtherProposalType(),
                            'dataCollection' => $proposalDetails->getDataCollection(),
                            'reviewedByOtherErc' => $reviewedByOtherErc,
                            'otherErcDecision' => $otherErcDecision
                        );
                        
                        // Student research
                        $studentResearch =& $proposalDetails->getStudentResearchInfo();
                        $studentResearchArray = array(
                            'studentInstitution' => $studentResearch->getInstitution(), 
                            'academicDegree' => $studentResearch->getDegree(),
                            'supervisorName' => $studentResearch->getSupervisorName(),
                            'supervisorEmail' => $studentResearch->getSupervisorEmail()                            
                        );
			
                        
                        // Risk Assessments
			$riskAssessment =& $article->getRiskAssessment();
			$riskAssessmentArray = array(	
                            'identityRevealed' => $riskAssessment->getIdentityRevealed(),
                            'unableToConsent' => $riskAssessment->getUnableToConsent(),
                            'under18' => $riskAssessment->getUnder18(),
                            'dependentRelationship' => $riskAssessment->getDependentRelationship(),
                            'ethnicMinority' => $riskAssessment->getEthnicMinority(),
                            'impairment' => $riskAssessment->getImpairment(),
                            'pregnant' => $riskAssessment->getPregnant(),
                            'newTreatment' => $riskAssessment->getNewTreatment(),
                            'bioSamples' => $riskAssessment->getBioSamples(),
                            'exportHumanTissue' => $riskAssessment->getExportHumanTissue(),
                            'exportReason' => $riskAssessment->getExportReason(),
                            'radiation' => $riskAssessment->getRadiation(),
                            'distress' => $riskAssessment->getDistress(),
                            'inducements' => $riskAssessment->getInducements(),
                            'sensitiveInfo' => $riskAssessment->getSensitiveInfo(),
                            'reproTechnology' => $riskAssessment->getReproTechnology(),
                            'genetic' => $riskAssessment->getGenetic(),
                            'stemCell' => $riskAssessment->getStemCell(),
                            'biosafety' => $riskAssessment->getBiosafety(),
                            'riskLevel' => $riskAssessment->getRiskLevel(),
                            'listRisks' => $riskAssessment->getListRisks(),
                            'howRisksMinimized' => $riskAssessment->getHowRisksMinimized(),
                            'risksToTeam' => $riskAssessment->getRisksToTeam(),
                            'risksToSubjects' => $riskAssessment->getRisksToSubjects(),
                            'risksToCommunity' => $riskAssessment->getRisksToCommunity(),
                            'benefitsToParticipants' => $riskAssessment->getBenefitsToParticipants(),
                            'knowledgeOnCondition' => $riskAssessment->getKnowledgeOnCondition(),
                            'knowledgeOnDisease' => $riskAssessment->getKnowledgeOnDisease(),
                            'conflictOfInterest' => $riskAssessment->getConflictOfInterest(),
                            'multiInstitutions' => $riskAssessment->getMultiInstitutions()			
			);
			                                                						
			$this->_data = array(
				'authors' => array(),

                            	'abstracts' => array(),

                            	'proposalDetails' => $proposalDetailsArray,
                            
				'sources' => array(),

                                'studentResearch' => $studentResearchArray,
                                
                                'riskAssessment' => $riskAssessmentArray,
                            
				'section' => $sectionDao->getSection($article->getSectionId())                                 
			);
			
                       
			$authors =& $article->getAuthors();
			for ($i=0, $count=count($authors); $i < $count; $i++) {
				array_push(
					$this->_data['authors'],
					array(
						'authorId' => $authors[$i]->getId(),
						'firstName' => $authors[$i]->getFirstName(),
						'middleName' => $authors[$i]->getMiddleName(),
						'lastName' => $authors[$i]->getLastName(),
						'affiliation' => $authors[$i]->getAffiliation(),
						'phone' => $authors[$i]->getPhoneNumber(),
						'email' => $authors[$i]->getEmail()
					)
				);
				if ($authors[$i]->getPrimaryContact()) {
					$this->setData('primaryContact', $i);
				}
			}

                        
                        $sources =& $article->getSources();
                        if (empty($sources)) {
                            array_push ($sources, new ProposalSource());
                        }
                        for ($i=0, $count=count($sources); $i < $count; $i++) {
                            array_push(
                                    $this->_data['sources'],
                                    array(
                                            'sourceId' => $sources[$i]->getSourceId(),
                                            'institution' => $sources[$i]->getInstitutionId(),
                                            'amount' => $sources[$i]->getSourceAmount()
                                    )
                            );
                        }
			
                        
                        $journal = Request::getJournal();
                        $abstracts =& $article->getAbstracts();
                        foreach ($journal->getSupportedLocaleNames() as $localeKey => $localeValue) {
                            if (isset($abstracts[$localeKey])) {
                                $this->_data['abstracts'][$localeKey] = array(
                                        'abstractId' => $abstracts[$localeKey]->getAbstractId(),
                                        'scientificTitle' => $abstracts[$localeKey]->getScientificTitle(),
                                        'publicTitle' => $abstracts[$localeKey]->getPublicTitle(),
                                        'background' => $abstracts[$localeKey]->getBackground(),
                                        'objectives' => $abstracts[$localeKey]->getObjectives(),
                                        'studyMethods' => $abstracts[$localeKey]->getStudyMethods(),
                                        'expectedOutcomes' => $abstracts[$localeKey]->getExpectedOutcomes(),
                                        'keywords' => $abstracts[$localeKey]->getKeywords(),
                                    );
                            }
                        }


		}
		return parent::initData();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array(
				'authors',
				'deletedAuthors',
				'primaryContact',				
				'abstracts',                
                                'proposalDetails',                            
				'studentResearch',                            
				'sources',
                                'riskAssessment'
			)
		);

                // Load the section. This is used in the step 2 form to
		// determine whether or not to display indexing options.
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$this->_data['section'] =& $sectionDao->getSection($this->article->getSectionId());

		/*
		if ($this->_data['section']->getAbstractsNotRequired() == 0) {
			$this->addCheck(new FormValidatorLocale($this, 'abstract', 'required', 'author.submit.form.abstractRequired', $this->getRequiredLocale()));
		}
		*/
	}

	/**
	 * Get the names of fields for which data should be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
		return array();
	}

	/**
	 * Display the form.
	 */
	function display() {
                $journal = Request::getJournal();
                
		$countryDao =& DAORegistry::getDAO('CountryDAO');
                $proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                $studentResearchDao =& DAORegistry::getDAO('StudentResearchDAO');
                $extraFieldDAO =& DAORegistry::getDAO('ExtraFieldDAO');
		$institutionDao =& DAORegistry::getDAO('InstitutionDAO');
		$riskAssessmentDao =& DAORegistry::getDAO('RiskAssessmentDAO');
		$currencyDao =& DAORegistry::getDAO('CurrencyDAO');
                
                $geoAreas =& $extraFieldDAO->getExtraFieldsList(EXTRA_FIELD_GEO_AREA, EXTRA_FIELD_ACTIVE);
                $proposalTypesList =& $extraFieldDAO->getExtraFieldsList(EXTRA_FIELD_PROPOSAL_TYPE, EXTRA_FIELD_ACTIVE);
                $proposalTypesListWithOther = $proposalTypesList + array('OTHER' => Locale::translate('common.other'));
                $researchDomainsList =& $extraFieldDAO->getExtraFieldsList(EXTRA_FIELD_RESEARCH_DOMAIN, EXTRA_FIELD_ACTIVE);
                $researchFieldsList =&  $extraFieldDAO->getExtraFieldsList(EXTRA_FIELD_RESEARCH_FIELD, EXTRA_FIELD_ACTIVE);
                $researchFieldsListWithOther = $researchFieldsList + array('OTHER' => Locale::translate('common.other'));
                
                $institutionsList = $institutionDao->getInstitutionsList();
                $institutionsListWithOther = $institutionsList + array('OTHER' => Locale::translate('common.other'));
                $sourcesList = $institutionsListWithOther + array('KII' => Locale::translate('proposal.keyImplInstitution'));
                $sourceCurrencyId = $journal->getSetting('sourceCurrency');
                
		$templateMgr =& TemplateManager::getManager();
                
		if (Request::getUserVar('addAuthor') || Request::getUserVar('delAuthor')  || Request::getUserVar('moveAuthor')) {
			$templateMgr->assign('scrollToAuthor', true);
		}
                                
                $templateMgr->assign('abstractLocales', $journal->getSupportedLocaleNames());
                $templateMgr->assign('coutryList', $countryDao->getCountries());
                $templateMgr->assign('proposalTypesList', $proposalTypesListWithOther);
                $templateMgr->assign('researchDomainsList',$researchDomainsList);                
                $templateMgr->assign('researchFieldsList', $researchFieldsListWithOther);
                $templateMgr->assign('proposalDetailYesNoArray', $proposalDetailsDao->getYesNoArray());
                $templateMgr->assign('nationwideRadioButtons', $proposalDetailsDao->getNationwideRadioButtons());
                $templateMgr->assign('dataCollectionArray', $proposalDetailsDao->getDataCollectionArray());
                $templateMgr->assign('otherErcDecisionArray', $proposalDetailsDao->getOtherErcDecisionArray());
                $templateMgr->assign('academicDegreesArray', $studentResearchDao->getAcademicDegreesArray());
                $templateMgr->assign('geoAreasList', $geoAreas);
                $templateMgr->assign('institutionsList', $institutionsListWithOther);
                $templateMgr->assign('sourceCurrency', $currencyDao->getCurrencyByAlphaCode($sourceCurrencyId));
                $templateMgr->assign('sourcesList', $sourcesList);
                $templateMgr->assign('institutionTypes', $institutionDao->getInstitutionTypes());
                $templateMgr->assign('internationalArray', $institutionDao->getInstitutionInternationalArray());
                $templateMgr->assign('riskAssessmentYesNoArray', $riskAssessmentDao->getYesNoArray());
                $templateMgr->assign('riskAssessmentExportReasonArray', $riskAssessmentDao->getExportReasonArray());
                $templateMgr->assign('riskAssessmentLevelsOfRisk', $riskAssessmentDao->getLevelOfRiskArray());
                $templateMgr->assign('riskAssessmentConflictOfInterestArray', $riskAssessmentDao->getConflictOfInterestArray());

                parent::display();
	}

	/**
	 * Save changes to article.
	 * @param $request Request
	 * @return int the article ID
	 */
	function execute(&$request) {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $this->article;
                
		// Retrieve the previous citation list for comparison.
		$previousRawCitationList = $article->getCitations();

                
                ///////////////////////////////////////////
		////////////// Update Authors /////////////
                ///////////////////////////////////////////

                $authors = $this->getData('authors');
		for ($i=0, $count=count($authors); $i < $count; $i++) {
			if ($authors[$i]['authorId'] > 0) {
			// Update an existing author
				$author =& $article->getAuthor($authors[$i]['authorId']);
				$isExistingAuthor = true;
			} else {
				// Create a new author
				$author = new Author();
				$isExistingAuthor = false;
			}

			if ($author != null) {
				$author->setSubmissionId($article->getId());
				if (isset($authors[$i]['firstName'])) $author->setFirstName($authors[$i]['firstName']);
				if (isset($authors[$i]['middleName'])) $author->setMiddleName($authors[$i]['middleName']);
				if (isset($authors[$i]['lastName'])) $author->setLastName($authors[$i]['lastName']);
				if (isset($authors[$i]['affiliation'])) $author->setAffiliation($authors[$i]['affiliation']);
				if (isset($authors[$i]['phone'])) $author->setPhoneNumber($authors[$i]['phone']);
				if (isset($authors[$i]['email'])) $author->setEmail($authors[$i]['email']);
				$author->setPrimaryContact($this->getData('primaryContact') == $i ? 1 : 0);
				$author->setSequence($authors[$i]['seq']);

				if ($isExistingAuthor == false) {
					$article->addAuthor($author);
				}
			}
			unset($author);
		}

                // Remove deleted authors
		$deletedAuthors = explode(':', $this->getData('deletedAuthors'));
		for ($i=0, $count=count($deletedAuthors); $i < $count; $i++) {
			$article->removeAuthor($deletedAuthors[$i]);
		}
                
                ///////////////////////////////////////////
		//////////// Update Abstract(s) ///////////
                ///////////////////////////////////////////
                
		import('classes.article.ProposalAbstract');
                $journal = Request::getJournal();
                $abstracts = $this->getData('abstracts');
                foreach ($journal->getSupportedLocaleNames() as $localeKey => $localeValue) {
                    if ($abstracts[$localeKey]['abstractId'] > 0) {
                        $abstract = $article->getAbstractByLocale($localeKey);
                        $isExistingAbstract = true;
                    } else {
                        $abstract = new ProposalAbstract();
                        $isExistingAbstract = false;
                    }
                    
                    if ($abstract != null) {
                        
                        $abstract->setArticleId($article->getId());		
                        $abstract->setLocale($localeKey);
                        $abstract->setScientificTitle($abstracts[$localeKey]['scientificTitle']);
                        $abstract->setPublicTitle($abstracts[$localeKey]['publicTitle']);
                        $abstract->setBackground($abstracts[$localeKey]['background']);
                        $abstract->setObjectives($abstracts[$localeKey]['objectives']);
                        $abstract->setStudyMethods($abstracts[$localeKey]['studyMethods']);
                        $abstract->setExpectedOutcomes($abstracts[$localeKey]['expectedOutcomes']);		
                        $abstract->setKeywords($abstracts[$localeKey]['keywords']);
                        if ($isExistingAbstract == false) {
                                $article->addAbstract($abstract);
                        }

                    }
                    unset($abstract);
                }

                ///////////////////////////////////////////
		///////// Update Proposal Details /////////
                ///////////////////////////////////////////
                
                $proposalDetailsData = $this->getData('proposalDetails');
                        
                import('classes.article.ProposalDetails');
		$proposalDetails = new ProposalDetails();
                
		$institutionDao =& DAORegistry::getDAO('InstitutionDAO');
                import ('classes.journal.Institution');
                
                
		$proposalDetails->setArticleId($article->getId());
                
                $proposalDetails->setStudentResearch($proposalDetailsData['studentInitiatedResearch']);
                
                $proposalDetails->setStartDate($proposalDetailsData['startDate']);
                
                $proposalDetails->setEndDate($proposalDetailsData['endDate']);
                                
                if($proposalDetailsData['keyImplInstitution'] == "OTHER"){
                    $institution = new Institution();
                    $institution->setInstitutionName($proposalDetailsData['otherInstitutionName']);
                    $institution->setInstitutionAcronym($proposalDetailsData['otherInstitutionAcronym']);
                    $institution->setInstitutionType($proposalDetailsData['otherInstitutionType']);
                    $institution->setInstitutionInternational($proposalDetailsData['international']);                    
                    if($proposalDetailsData['international'] == INSTITUTION_NATIONAL){
                        $institution->setInstitutionLocation($proposalDetailsData['locationCountry']);
                    } elseif($proposalDetailsData['international'] == INSTITUTION_INTERNATIONAL){
                        $institution->setInstitutionLocation($proposalDetailsData['locationInternational']);
                    }
                    $institutionId = $institutionDao->insertInstitution($institution);
                    $proposalDetails->setKeyImplInstitution($institutionId);
                    unset($institution);
                } else {
                    $proposalDetails->setKeyImplInstitution($proposalDetailsData['keyImplInstitution']);                    
                }
                
                $proposalDetails->setMultiCountryResearch($proposalDetailsData['multiCountryResearch']);
                
                if ($proposalDetailsData['multiCountryResearch'] == PROPOSAL_DETAIL_YES) {
                    $countriesArray = $proposalDetailsData['countries'];
                    $countries = implode(",", $countriesArray);
                    $proposalDetails->setCountries($countries);                    
                }
		
                $proposalDetails->setNationwide($proposalDetailsData['nationwide']);
                
                if ($proposalDetailsData['nationwide'] != PROPOSAL_DETAIL_YES) {
                    $geoAreasArray = $proposalDetailsData['geoAreas'];
                    $proposalDetails->setGeoAreasFromArray($geoAreasArray);
                }

                $researchDomainsArray = $proposalDetailsData['researchDomains'];
                $proposalDetails->setResearchDomainsFromArray($researchDomainsArray);

                $researchFieldsArray = $proposalDetailsData['researchFields'];
                foreach($researchFieldsArray as $i => $field) {
                        if($field == "OTHER") {
                                $otherField = $proposalDetailsData['otherResearchField'];
                                if($otherField != "") {
                                        $researchFieldsArray[$i] = "Other (". $otherField .")";
                                }
                        }
                }   
                $proposalDetails->setResearchFieldsFromArray($researchFieldsArray);
                
                $proposalDetails->setHumanSubjects($proposalDetailsData['withHumanSubjects']);    

                if ($proposalDetailsData['withHumanSubjects'] == PROPOSAL_DETAIL_YES) {
                    $proposalTypesArray = $proposalDetailsData['proposalTypes'];
                    foreach($proposalTypesArray as $i => $type) {
                            if($type == "OTHER") {
                                    $otherType = $proposalDetailsData['otherProposalType'];
                                    if($otherType != "") {
                                            $proposalTypesArray[$i] = "Other (". $otherType .")";
                                    }
                            }
                    }
                    $proposalDetails->setProposalTypesFromArray($proposalTypesArray);
                }
                
                $proposalDetails->setDataCollection($proposalDetailsData['dataCollection']);
                
                if ($proposalDetailsData['reviewedByOtherErc'] == PROPOSAL_DETAIL_YES) {
                    $proposalDetails->setCommitteeReviewed($proposalDetailsData['otherErcDecision']);    
                } else $proposalDetails->setCommitteeReviewed(PROPOSAL_DETAIL_NO);    
                
                // Update or insert student research
                import('classes.article.StudentResearch');
		$studentResearchInfo = new StudentResearch();
                $studentResearchInfo->setArticleId($article->getId());
                $studentResearchData = $this->getData('studentResearch');
                $studentResearchInfo->setInstitution($studentResearchData['studentInstitution']);
                $studentResearchInfo->setDegree($studentResearchData['academicDegree']);
                $studentResearchInfo->setSupervisorName($studentResearchData['supervisorName']);
                $studentResearchInfo->setSupervisorEmail($studentResearchData['supervisorEmail']);
                
                $proposalDetails->setStudentResearchInfo($studentResearchInfo);
                $article->setProposalDetails($proposalDetails);
                
                ///////////////////////////////////////////
		//////// Update Sources of Monetary ///////
                ///////////////////////////////////////////
                
                $sources = $article->getSources();
                $sourcesData = $this->getData('sources');
                
                //Remove sources
                foreach ($sources as $source) {
                    $isPresent = false;
                    foreach ($sourcesData as $sourceData) {
                        if (!empty($sourceData['sourceId'])) {
                            if ($source->getSourceId() == $sourceData['sourceId']) {
                                $isPresent = true;
                            }
                        }
                    }
                    if (!$isPresent) {
                        $article->removeSource($source->getSourceId());
                    }
                    unset($source);
                    
                }

                for ($i=0, $count=count($sourcesData); $i < $count; $i++) {
                    if (!empty($sourcesData[$i]['sourceId'])) {
                        // Update an existing source
                        $source =& $article->getSource($sourcesData[$i]['sourceId']);
                        $isExistingSource = true;
                    } else {
                        // Create a new source
                        $source = new ProposalSource();
                        $isExistingSource = false;
                    }
                    if ($source != null) {
                        $source->setArticleId($article->getId());

                        if ($sourcesData[$i]['institution'] == "OTHER") {                        
                            $institution = new Institution();
                            $institution->setInstitutionName($sourcesData[$i]['otherInstitutionName']);
                            $institution->setInstitutionAcronym($sourcesData[$i]['otherInstitutionAcronym']);
                            $institution->setInstitutionType($sourcesData[$i]['otherInstitutionType']);
                            $institution->setInstitutionInternational($sourcesData[$i]['international']);                    
                            if($sourcesData[$i]['international'] == INSTITUTION_NATIONAL){
                                $institution->setInstitutionLocation($sourcesData[$i]['locationCountry']);
                            } elseif($proposalDetailsData['international'] == INSTITUTION_INTERNATIONAL){
                                $institution->setInstitutionLocation($sourcesData[$i]['locationInternational']);
                            }                            
                            $institutionId = $institutionDao->insertInstitution($institution);
                            $source->setInstitutionId($institutionId);
                            unset($institution);
                        } elseif ($sourcesData[$i]['institution'] == "KII") {
                            $source->setInstitutionId($proposalDetails->getKeyImplInstitution());
                        } else {
                            $source->setInstitutionId($sourcesData[$i]['institution']);
                        }

                        $source->setSourceAmount($sourcesData[$i]['amount']);
                        
                        if (!$isExistingSource) {
                            $article->addSource($source);
                        }
                    }
                    unset($source);
                } 

                
                ///////////////////////////////////////////
		///////////// Risk Assessment /////////////
                ///////////////////////////////////////////

                import('classes.article.RiskAssessment');
		$riskAssessment = new RiskAssessment();
                $riskAssessmentData = $this->getData('riskAssessment');
                
                $riskAssessment->setArticleId($article->getId());
                $riskAssessment->setIdentityRevealed($riskAssessmentData['identityRevealed']);
                $riskAssessment->setUnableToConsent($riskAssessmentData['unableToConsent']);
                $riskAssessment->setUnder18($riskAssessmentData['under18']);
                $riskAssessment->setDependentRelationship($riskAssessmentData['dependentRelationship']);
                $riskAssessment->setEthnicMinority($riskAssessmentData['ethnicMinority']);
                $riskAssessment->setImpairment($riskAssessmentData['impairment']);
                $riskAssessment->setPregnant($riskAssessmentData['pregnant']);
                $riskAssessment->setNewTreatment($riskAssessmentData['newTreatment']);
                $riskAssessment->setBioSamples($riskAssessmentData['bioSamples']);
                $riskAssessment->setExportHumanTissue($riskAssessmentData['exportHumanTissue']);
                $riskAssessment->setExportReason($riskAssessmentData['exportReason']);
                $riskAssessment->setRadiation($riskAssessmentData['radiation']);
                $riskAssessment->setDistress($riskAssessmentData['distress']);
                $riskAssessment->setInducements($riskAssessmentData['inducements']);
                $riskAssessment->setSensitiveInfo($riskAssessmentData['sensitiveInfo']);
                $riskAssessment->setReproTechnology($riskAssessmentData['reproTechnology']);
                $riskAssessment->setGenetic($riskAssessmentData['genetic']);
                $riskAssessment->setStemCell($riskAssessmentData['stemCell']);
                $riskAssessment->setBiosafety($riskAssessmentData['biosafety']);
                $riskAssessment->setRiskLevel($riskAssessmentData['riskLevel']);
                $riskAssessment->setListRisks($riskAssessmentData['listRisks']);
                $riskAssessment->setHowRisksMinimized($riskAssessmentData['howRisksMinimized']);

                $riskAssessment->setRisksToTeam(isset($riskAssessmentData['risksToTeam']) ? 1 : 0);
                $riskAssessment->setRisksToSubjects(isset($riskAssessmentData['risksToSubjects']) ? 1 : 0);
                $riskAssessment->setRisksToCommunity(isset($riskAssessmentData['risksToCommunity']) ? 1 : 0);
                $riskAssessment->setBenefitsToParticipants(isset($riskAssessmentData['benefitsToParticipants']) ? 1 : 0);
                $riskAssessment->setKnowledgeOnCondition(isset($riskAssessmentData['knowledgeOnCondition']) ? 1 : 0);
                $riskAssessment->setKnowledgeOnDisease(isset($riskAssessmentData['knowledgeOnDisease']) ? 1 : 0);

                $riskAssessment->setMultiInstitutions($riskAssessmentData['multiInstitutions']);
                $riskAssessment->setConflictOfInterest($riskAssessmentData['conflictOfInterest']);           
                $article->setRiskAssessment($riskAssessment);
		
		

                //update step
                if ($article->getSubmissionProgress() <= $this->step) {
			$article->stampStatusModified();
			$article->setSubmissionProgress($this->step + 1);
		}                

		parent::execute();

		// Save the article
		$articleDao->updateArticle($article);

		// Update references list if it changed.
		$citationDao =& DAORegistry::getDAO('CitationDAO');
		$rawCitationList = $article->getCitations();
		if ($previousRawCitationList != $rawCitationList) {
			$citationDao->importCitations($request, ASSOC_TYPE_ARTICLE, $article->getId(), $rawCitationList);
		}
		return $this->articleId;
	}
}

?>
