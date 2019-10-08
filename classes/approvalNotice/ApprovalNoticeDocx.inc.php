<?php

/**
 * @defgroup approvalNotice
 */

/**
 * @file ApprovalNoticeDocx.inc.php
 *
 * @class ApprovalNoticeDocx
 * @ingroup approvalNotice
 * @see ApprovalNoticeDAO, ApprovalNotice, classes/lib/htmltodcx/*
 *
 * @brief Create a template.
 */

import('classes.lib.htmltodocx.phpword.PHPWord');
import('classes.lib.htmltodocx.simplehtmldom.simple_html_dom');
import('classes.lib.htmltodocx.htmltodocx_converter.h2d_htmlconverter');
import('classes.lib.htmltodocx.styles.noticeStyle');

class ApprovalNoticeDocx {

    // Header, body and footer in html
    var $header;
    var $body;
    var $footer;
    
    // SevtionEditorSubmission Object
    var $sectionEditorSubmission;
    
    // Name of the file to download
    var $fileName = 'ApprovalNotice';
    
    /**
     * Constructor
     * @param $approvalNotice ApprovalNotice object
     * @param $sectionEditorSubmission ApprovalNotice object, null if just for preview
     */
    function ApprovalNoticeDocx($approvalNotice, $sectionEditorSubmission){
            Locale::requireComponents(array(LOCALE_COMPONENT_APPLICATION_COMMON, LOCALE_COMPONENT_PKP_SUBMISSION));
            // Set variables
            $this->header = $approvalNotice->getCleanHtml('getApprovalNoticeHeader');
            $this->body = $approvalNotice->getCleanHtml('getApprovalNoticeBody'); 
            $this->footer = $approvalNotice->getCleanHtml('getApprovalNoticeFooter');//.'<br/><p style="text-align: center;">{PAGE}</p>';
            $this->sectionEditorSubmission = $sectionEditorSubmission;
            
    }
    
    /**
     * Private function to return the right column width in twips,
     * in order to ensure the table take the full available space of the docx
     * @param type $html
     * @return int Number of twips
     */
    private function _getColumnWidthByHtml($html){
            if(substr_count($html, '<td') && substr_count($html, '<tr')) {
                return round(11906 / (substr_count($html, '<td') / substr_count($html, '<tr')));
            } else {
                return null;
            }
    }
    
    /**
     * Private function of obtaining the simple html dom object with the html loaded in it
     * @param type $html
     * @return $html_dom_array Array of simple_html_dom tags
     */
    private function &_getHtmlDomArray($html) {
            $html_dom = new simple_html_dom();
            $html_dom->load('<html><body>' . $html . '</body></html>');
            $html_dom_array = $html_dom->find('html',0)->children();    
            return $html_dom_array;
    }    
    
    /**
     * Private function to get the settings according to the context (header/body/footer)
     * @param type $context ('header', 'section' or footer)
     * @return $settings Array of settings
     */
    private function &_getSettings($context = 'section'){
            $baseRoot = Config::getVar('general', 'base_url');
            switch ($context){
                case 'header':
                    $styleSheet = htmltodocx_styles_notice($this->_getColumnWidthByHtml($this->header));
                    break;
                case 'footer':
                    $styleSheet = htmltodocx_styles_notice($this->_getColumnWidthByHtml($this->footer));
                    break;
                default :
                    $styleSheet = htmltodocx_styles_notice($this->_getColumnWidthByHtml($this->body));
                    break;
            }
            $settings = array(
              'phpword_object' => &$phpword_object, // Must be passed by reference.
              'base_root' => substr($baseRoot, 0, -1),
              'base_path' => '/pages/manager/',
              'context' => $context, // Possible values - section, footer or header.
              'table_allowed' => TRUE, // Note, if you are adding this html into a PHPWord table you should set this to FALSE: tables cannot be nested in PHPWord.
              'treat_div_as_paragraph' => TRUE, // If set to TRUE, each new div will trigger a new line in the Word document.
              'style_sheet' => $styleSheet // This is an array (the "style sheet") - returned by htmltodocx_styles_example() here (in styles.inc) - see this function for an example of how to construct this array.
              ); 
            return $settings;
    }
    
    /**
     * Get an array of all the keys to replace by the submission variables in the template
     * @param $sectionEditorSubmission SectionEditorSubmissionArray
     * @return array Array
     */
    private function _getReplacementsArray($sectionEditorSubmission){
        
        // Obtain the objects for providing the information
        $abstract = $sectionEditorSubmission->getLocalizedAbstract();
        $details = $sectionEditorSubmission->getProposalDetails();
        $student = $details->getStudentResearchInfo();
        $decision = $sectionEditorSubmission->getLastSectionDecision();
        $committee = $decision->getSection();
        $secretary =& Request::getUser();
        $journal =& Request::getJournal();
        $ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
        $chairInArray =& $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $committee->getId(), REVIEWER_CHAIR);
        $viceChairInArray =& $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $committee->getId(), REVIEWER_VICE_CHAIR);
        
        // investigators
        $coInvestigators = $investigators = $sectionEditorSubmission->getAuthors();
        foreach ($investigators as $iKey => $investigator){
            if ($investigator->getPrimaryContact()){
                $primaryInvestigator = $investigator;
                unset($coInvestigators[$iKey]);
            }
        }
        $investigatorsOneLine = $primaryInvestigator->getFullName().' ('.$primaryInvestigator->getAffiliation().')';
        $investigatorsMultiLines = $primaryInvestigator->getFullName().', '.$primaryInvestigator->getAffiliation();
        $coInvestigatorsOneLine = (string) '';
        $coInvestigatorsMultiLines = (string) '';
        foreach ($coInvestigators as $investigator) {
            $investigatorsOneLine .= ', '.$investigator->getFullName().' ('.$investigator->getAffiliation().')';
            $investigatorsMultiLines .= '<br/>'.$investigator->getFullName().', '.$investigator->getAffiliation();  
            if ($coInvestigatorsOneLine == '') {
                $coInvestigatorsOneLine = $investigator->getFullName().' ('.$investigator->getAffiliation().')';
            } else {
                $coInvestigatorsOneLine .= ', '.$investigator->getFullName().' ('.$investigator->getAffiliation().')';
            }
            if ($coInvestigatorsMultiLines == '') {
                $coInvestigatorsMultiLines = $investigator->getFullName().', '.$investigator->getAffiliation();                
            } else {
                $coInvestigatorsMultiLines .= '<br/>'.$investigator->getFullName().', '.$investigator->getAffiliation().')';
            }
        }
        
        // Set the name of the file to download
        $this->fileName = $sectionEditorSubmission->getProposalId().'-'.$committee->getLocalizedAbbrev().'-'.preg_replace('/\s+/', '', Locale::translate($decision->getReviewTypeKey())).'-'.$decision->getRound();
        
        
        // If modification, see pages.manager.ApprovalNoticesHandler.inc.php _createSampleProposal AND templates.manager.approvalNotices.approvalNoticeForm.tpl
        return array(
            '{$proposalId}' => ($sectionEditorSubmission->getProposalId()) ? $sectionEditorSubmission->getProposalId() : '',
            '{$comName}' => ($committee->getLocalizedTitle()) ? $committee->getLocalizedTitle() : '',
            '{$comAcronym}' => ($committee->getLocalizedAbbrev()) ? $committee->getLocalizedAbbrev() : '',
            '{$comSecName}' => ($secretary) ? $secretary->getFullName() : '',
            '{$comChairName}' => (!empty($chairInArray)) ? $chairInArray[0]->getFullName() : '',
            '{$comViceChairName}' => (!empty($viceChairInArray)) ? $viceChairInArray[0]->getFullName() : '',  
            '{$subRoundDate}' => ($sectionEditorSubmission->getDateSubmitted()) ? $sectionEditorSubmission->getDateSubmitted() : '',
            '{$reviewType}' => ($decision->getReviewTypeKey()) ? Locale::translate($decision->getReviewTypeKey()) : '',
            '{$reviewRound}' => ($decision->getRound()) ? $decision->getRound() : '',
            '{$invNAA1Line}' => ($investigatorsOneLine) ? $investigatorsOneLine : '',
            '{$invNAAMLines}' => ($investigatorsMultiLines) ? $investigatorsMultiLines : '',
            '{$primInvName}' => ($primaryInvestigator->getFullName()) ? $primaryInvestigator->getFullName() : '',
            '{$primInvAff}' => ($primaryInvestigator->getAffiliation()) ? $primaryInvestigator->getAffiliation() : '',
            '{$coInvNAA1Line}' => ($coInvestigatorsOneLine) ? $coInvestigatorsOneLine : '',
            '{$coInvNAAMLines}' => ($coInvestigatorsMultiLines) ? $coInvestigatorsMultiLines : '',
            '{$scienTitle}' => ($abstract->getScientificTitle()) ? $abstract->getScientificTitle() : '',
            '{$publicTitle}' => ($abstract->getPublicTitle()) ? $abstract->getPublicTitle() : '',
            '{$abstractFull}' => ($abstract->getWholeAbstract()) ? str_replace('\n', '<br/>', $abstract->getWholeAbstract()) : '',
            '{$background}' => ($abstract->getBackground()) ? $abstract->getBackground() : '',
            '{$objectives}' => ($abstract->getObjectives()) ? $abstract->getObjectives() : '',
            '{$studyMethods}' => ($abstract->getStudyMethods()) ? $abstract->getStudyMethods() : '',
            '{$expectedOutcomes}' => ($abstract->getExpectedOutcomes()) ? $abstract->getExpectedOutcomes() : '',
            '{$studentInstitution}' => ($student->getInstitution()) ? $student->getInstitution() : '',
            '{$studentDegree}' => ($student->getDegreeKey()) ? Locale::translate($student->getDegreeKey()) : '',
            '{$studentSupName}' => ($student->getSupervisorName()) ? $student->getSupervisorName() : '',
            '{$resStartDate}' => ($details->getStartDate()) ? $details->getStartDate() : '',
            '{$resEndDate}' => ($details->getEndDate()) ? $details->getEndDate() : '',
            '{$KII}' => ($details->getKeyImplInstitutionName()) ? $details->getKeyImplInstitutionName() : '',
            '{$countries}' => ($details->getLocalizedMultiCountryText()) ? $details->getLocalizedMultiCountryText() : '',
            '{$geoAreas}' => ($details->getLocalizedGeoAreasText()) ? $details->getLocalizedGeoAreasText() : '',
            '{$resDomains}' => ($details->getLocalizedResearchDomainsText()) ? $details->getLocalizedResearchDomainsText() : '',
            '{$resFields}' => ($details->getLocalizedResearchFieldText()) ? $details->getLocalizedResearchFieldText() : '',
            '{$propType}' => ($details->getLocalizedProposalTypeText()) ? $details->getLocalizedProposalTypeText() : '',
            '{$dataCollType}' => ($details->getDataCollectionKey()) ? Locale::translate($details->getDataCollectionKey()) : '',
            '{$todayDate}' => date('d-m-Y')
        );
    }
    
    /**
     * Replace the keys in the header, body and footer by the values from the proposal
     * @param type $sectionEditorSubmission
     */
    private function _replaceHTMLs($sectionEditorSubmission){
        $map = $this->_getReplacementsArray($sectionEditorSubmission);
        foreach ($map as $key => $value) {
            $this->header = str_replace($key, $value, $this->header);
            $this->body = str_replace($key, $value, $this->body);
            $this->footer = str_replace($key, $value, $this->footer);
        }
    }
    
    
    
    /**
     * @return boolean
     */
    function downloadApprovalNotice(){
                $phpword_object = new PHPWord();
                $section = $phpword_object->createSection();
                $header = $section->createHeader();
                $footer = $section->createFooter();
                
                // Replace the keys by the values of the proposal
                $this->_replaceHTMLs($this->sectionEditorSubmission);
                
                // Convert the HTML and put it into the PHPWord object
                $headerDomArray = $this->_getHtmlDomArray($this->header);
                $headerDomArray = $headerDomArray[0];
                $bodyDomArray = $this->_getHtmlDomArray($this->body);
                $bodyDomArray = $bodyDomArray[0];
                $footerDomArray = $this->_getHtmlDomArray($this->footer);
                $footerDomArray = $footerDomArray[0];                
                htmltodocx_insert_html($header, $headerDomArray->nodes, $this->_getSettings('header'));
                htmltodocx_insert_html($section, $bodyDomArray->nodes, $this->_getSettings());
                htmltodocx_insert_html($footer, $footerDomArray->nodes, $this->_getSettings('footer'));
                
                // Always include the page number in the footer
                $footer->addPreserveText(Locale::translate('submission.approvalNotice.pageNumberOfTotalPages.page').' {PAGE} '.Locale::translate('submission.approvalNotice.pageNumberOfTotalPages.of').' {NUMPAGES}', null, array('size' => 6, 'align'=>'center'));
                
                // Save File
                $h2d_file_uri = tempnam('', 'htd');
                $objWriter = PHPWord_IOFactory::createWriter($phpword_object, 'Word2007');
                

                $objWriter->save($h2d_file_uri);

                // Download the file:
                header('Content-Description: File Transfer');
                header('Content-Type: application/octet-stream');
                header('Content-Disposition: attachment; filename='.$this->fileName.'.docx');
                header('Content-Transfer-Encoding: binary');
                header('Expires: 0');
                header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
                header('Pragma: public');
                header('Content-Length: ' . filesize($h2d_file_uri));
                ob_clean();
                flush();
                $status = readfile($h2d_file_uri);
                unlink($h2d_file_uri);
                
                return true;
    }
}   

?>