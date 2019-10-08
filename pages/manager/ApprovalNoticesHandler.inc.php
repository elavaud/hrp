<?php

/**
 * @see ApprovalNoticeDAO
 *
 * @brief Basic page for managing the approval notices.
 */

import('pages.manager.ManagerHandler');

class ApprovalNoticesHandler extends ManagerHandler {
    
        var $approvalNoticeDao;
    
	/**
	 * Constructor
	 **/
	function ApprovalNoticesHandler() {
		parent::ManagerHandler();
		$this->approvalNoticeDao =& DAORegistry::getDAO('ApprovalNoticeDAO');
	}

	/**
	 * Display the files associated with a journal.
	 */
	function approvalNotices() {
		$this->validate();
		$this->setupTemplate(true);
                
		$rangeInfo =& Handler::getRangeInfo('notices');
                
                $templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('pageHierarchy', array(array(Request::url(null, 'manager'), 'manager.journalManagement')));
		$templateMgr->assign('notices', $this->approvalNoticeDao->getApprovalNotices($rangeInfo));
                
		$templateMgr->display('manager/approvalNotices/index.tpl');	
	}

        /**
	 * Create / Edit approval notice.
	 */
	function approvalNoticeEdit($args = array()) {
		$this->validate();
		$this->setupTemplate(true);

		import('classes.manager.form.ApprovalNoticeForm');
                
		$approvalNoticeForm = new ApprovalNoticeForm(!isset($args) || empty($args) ? null : ((int) $args[0]));
		if ($approvalNoticeForm->isLocaleResubmit()) {
			$approvalNoticeForm->readInputData();
		} else {
			$approvalNoticeForm->initData();
		}
		$approvalNoticeForm->display();
	}

        /**
	 * Save changes to an approval notice.
	 */
	function updateApprovalNotice($args, &$request) {
		$this->validate();
		$this->setupTemplate(true);

		import('classes.manager.form.ApprovalNoticeForm');
		$approvalNoticeForm = new ApprovalNoticeForm(!isset($args) || empty($args) ? null : ((int) $args[0]));

		$approvalNoticeForm->readInputData();
		if (!HookRegistry::call('ApprovalNoticesHandler::updateApprovalNotice', array(&$approvalNoticeForm))) {
                        if ($approvalNoticeForm->validate()) {
                                $approvalNoticeForm->execute();
                                Request::redirect(null, null, 'approvalNotices');
                        } else {
                                $approvalNoticeForm->display();
                        }
                    
                }
	}
        
	function approvalNoticeDelete($args) {
		$this->validate();

		if (isset($args) && !empty($args)) {
			$aNoticeId = (int) $args[0];
                        $this->approvalNoticeDao->deleteApprovalNoticeById($aNoticeId);
		}
		Request::redirect(null, null, 'approvalNotices');
	}
        
        
        /**
	 * preview an approval notice.
	 */
	function approvalNoticePreview($args = array()) {
		$this->validate();
		$this->setupTemplate(true);
		$aNoticeId = isset($args[0]) ? (int) $args[0] : 0;
                
                $approvalNotice =& $this->approvalNoticeDao->getApprovalNotice($aNoticeId);
                
                import('classes.approvalNotice.ApprovalNoticeDocx');                
                $aprovalNoticeDocx = new ApprovalNoticeDocx($approvalNotice, $this->_createSampleProposal($approvalNotice));
                
                $aprovalNoticeDocx->downloadApprovalNotice();
                Request::redirect(null, null, 'approvalNotices');
	}
        
        /**
         * Private function for returning a sample research proposal
         * @param type $approvalNotice
         * @return \SectionEditorSubmission
         */
        private function _createSampleProposal($approvalNotice){
            
            $institutionDao =& DAORegistry::getDAO('InstitutionDAO');
            $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
            $sectionDao =& DAORegistry::getDAO('SectionDAO');
            
            // Create the submission
            import('classes.submission.sectionEditor.SectionEditorSubmission');                
            $sectionEditorSubmission = new SectionEditorSubmission();
            $sectionEditorSubmission->setProposalId('2014.76.RV');
            $sectionEditorSubmission->setDateSubmitted('2014-06-13 14:57:17');
            
            // Create the decision
            import('classes.article.SectionDecision');                
            $sectionDecision = new SectionDecision();
            $sectionDecision->setSectionId($sectionDao->getRandomSectionId());
            $reviewTypes = $approvalNotice->getReviewTypesArray();
            if($reviewTypes[0] != APPROVAL_NOTICE_TYPE_ALL) {
                $sectionDecision->setReviewType($reviewTypes[0]);
            } else {
                $sectionDecision->setReviewType(1);                
            }
            $sectionDecision->setRound(2);
            $sectionEditorSubmission->setDecisions(array(0 => $sectionDecision));
                    
            // Create the investigators
            import('classes.article.Author');                
            $firstInvestigator = new Author();
            $firstInvestigator->setFirstName('Jane');
            $firstInvestigator->setLastName('Roe');
            $firstInvestigator->setPrimaryContact(1);
            $firstInvestigator->setAffiliation('World Health Organization, Western Pacific Regional Office');
            $coInvestigator1 = new Author();
            $coInvestigator1->setFirstName('John');
            $coInvestigator1->setLastName('Doe');
            $coInvestigator1->setPrimaryContact(0);
            $coInvestigator1->setAffiliation('National Public Health Institution');
            $coInvestigator2 = new Author();
            $coInvestigator2->setFirstName('Marie');
            $coInvestigator2->setMiddleName('Elizabeth');            
            $coInvestigator2->setLastName('Watson');
            $coInvestigator2->setPrimaryContact(0);
            $coInvestigator2->setAffiliation('HUYBN');
            $coInvestigator3 = new Author();
            $coInvestigator3->setFirstName('Pascal');
            $coInvestigator3->setLastName('Lavaud');
            $coInvestigator3->setPrimaryContact(0);
            $coInvestigator3->setAffiliation('Cabinet MEDICAL, Avenue Bollée');
            $sectionEditorSubmission->setAuthors(array(0 => $firstInvestigator, 1 => $coInvestigator1, 2 => $coInvestigator2, 3 => $coInvestigator3));
            
            // Create the abstract
            import('classes.article.ProposalAbstract');                
            $abstract = new ProposalAbstract();
            $abstract->setLocale('en_US');
            $abstract->setScientificTitle('Here, the scientific title of the concerned health research proposal will appear.');
            $abstract->setPublicTitle('Here, the public title of the concerned health research proposal will appear.');
            $abstract->setBackground('Here, the background of the concerned health research proposal will appear. Here, the background of the concerned health research proposal will appear. Here, the background of the concerned health research proposal will appear. Here, the background of the concerned health research proposal will appear. Here, the background of the concerned health research proposal will appear. Here, the background of the concerned health research proposal will appear. Here, the background of the concerned health research proposal will appear.');
            $abstract->setObjectives('Here, the objectives of the concerned health research proposal will appear. Here, the objectives of the concerned health research proposal will appear. Here, the objectives of the concerned health research proposal will appear. Here, the objectives of the concerned health research proposal will appear. Here, the objectives of the concerned health research proposal will appear.');
            $abstract->setStudyMethods('Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear. Here, the study methods of the concerned health research proposal will appear.');
            $abstract->setExpectedOutcomes('Here, the expected outcomes of the concerned health research proposal will appear. Here, the expected outcomes of the concerned health research proposal will appear. Here, the expected outcomes of the concerned health research proposal will appear. Here, the expected outcomes of the concerned health research proposal will appear. Here, the expected outcomes of the concerned health research proposal will appear. Here, the expected outcomes of the concerned health research proposal will appear.');
            $sectionEditorSubmission->setAbstracts(array(0 => $abstract));
            
            // Create proposal details
            import('classes.article.ProposalDetails');                
            $details = new ProposalDetails();
            import('classes.article.StudentResearch');                
            $studentResearch = new StudentResearch();
            $studentResearch->setInstitution('National University of Public Health');
            $studentResearch->setDegree(STUDENT_DEGREE_PHD);
            $studentResearch->setSupervisorName('Dr. Arwin Wagala');
            $details->setStudentResearchInfo($studentResearch);
            $details->setStartDate('2014-04-08');
            $details->setEndDate('2017-09-02');
            $details->setKeyImplInstitution($institutionDao->getRandomInstitutionId());
            $details->setMultiCountryResearch(PROPOSAL_DETAIL_YES);
            $details->setCountries('GE,AM');
            $details->setGeoAreas($extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_GEO_AREA).'+'.$extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_GEO_AREA).'+'.$extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_GEO_AREA));
            $details->setResearchDomains($extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_RESEARCH_DOMAIN));
            $details->setResearchFields($extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_RESEARCH_FIELD).'+'.$extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_RESEARCH_FIELD));
            $details->setProposalTypes($extraFieldDao->getRandomFieldIdByType(EXTRA_FIELD_PROPOSAL_TYPE));
            $details->setDataCollection(PROPOSAL_DETAIL_BOTH_DATA_COLLECTION);
            $sectionEditorSubmission->setProposalDetails($details);
            
            return $sectionEditorSubmission;
            
        }

}
?>
