<?php

/**
 * @defgroup approvalNotices
 */

/**
 * @file ApprovalNotice.inc.php
 *
 * @class ApprovalNotice
 * @ingroup approvalNotice
 * @see ApprovalNoticeDAO
 *
 * @brief Basic class describing an approval notice.
 */
import('classes.article.SectionDecision');

define ('APPROVAL_NOTICE_TYPE_ALL', 0);
define ('APPROVAL_NOTICE_COMMITTEE_ALL', 0);

define ('APPROVAL_NOTICE_ACTIVE', 0);
define ('APPROVAL_NOTICE_INACTIVE', 1);

class ApprovalNotice extends DataObject {
    
	//
	// Get/set methods
	//
    

	/**
	 * Get the ID of the approval notice.
	 * @return int
	 */
	function getApprovalNoticeId() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getId();
	}
	/**
	 * Set the ID of the approval notice.
	 * @param $approvalNoticeId int
	 */
	function setApprovalNoticeId($approvalNoticeId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->setId($approvalNoticeId);
	}
        

	/**
	 * Get a string of committees concerned.
	 * @return string
	 */
	function getCommittees() {
		return $this->getData('committees');
	}
	/**
	 * Get an array of committees concerned.
	 * @return array
	 */
	function getCommitteesArray() {
                $committees = $this->getCommittees();
                if($committees == '' || $committees == null) {
                    return null;
                } else {                
                    return explode("+", $committees);
                }
        }
	/**
	 * Set committees for this annoucement.
	 * @param $committees string
	 */
	function setCommittees($committees) {
		return $this->setData('committees', $committees);
	}
        /**
	 * Set committees for this annoucement from an array.
	 * @param $committees Array
	 */
	function setCommitteesFromArray($committees) {
                return $this->setCommittees(implode("+", $committees));
	}
        
        
        /**
	 * Get a string of the review types concerned.
	 * @return string
	 */
	function getReviewTypes() {
		return $this->getData('reviewTypes');
	}
	/**
	 * Get an array of review types concerned.
	 * @return array
	 */
	function getReviewTypesArray() {
                $reviewTypes = $this->getReviewTypes();
                if($reviewTypes == '' || $reviewTypes == null) {
                    return null;
                } else {                
                    return explode("+", $reviewTypes);
                }
        }
	/**
	 * Set review types concerned for this annoucement.
	 * @param $reviewTypes string
	 */
	function setReviewTypes($reviewTypes) {
		return $this->setData('reviewTypes', $reviewTypes);
	}
        /**
	 * Set review types concerned for this annoucement from an array.
	 * @param $reviewTypes Array
	 */
	function setReviewTypesFromArray($reviewTypes) {
                return $this->setReviewTypes(implode("+", $reviewTypes));
	}
        
        
	/**
	 * Get if the notice is active.
	 * @return int
	 */
	function getActive() {
		return $this->getData('active');
	}
	/**
	 * Set if the notice is active.
	 * @param $active int
	 */
	function setActive($active) {
		return $this->setData('active', $active);
	}
        
        
	/**
	 * Get approval notice title.
	 * @return text
	 */
	function getApprovalNoticeTitle() {
		return $this->getData('title');
	}
	/**
	 * Set approval notice title.
	 * @param $title text
	 */
	function setApprovalNoticeTitle($title) {
		return $this->setData('title', $title);
	}

	
	/**
	 * Get approval notice header.
	 * @return text
	 */
	function getApprovalNoticeHeader() {
		return $this->getData('header');
	}
	/**
	 * Set approval notice header.
	 * @param $header text
	 */
	function setApprovalNoticeHeader($header) {
		return $this->setData('header', $header);
	}
        
        
	/**
	 * Get approval notice body.
	 * @return text
	 */
	function getApprovalNoticeBody() {
		return $this->getData('body');
	}
	/**
	 * Set approval notice body.
	 * @param $body text
	 */
	function setApprovalNoticeBody($body) {
		return $this->setData('body', $body);
	}
        
        
	/**
	 * Get approval notice footer.
	 * @return text
	 */
	function getApprovalNoticeFooter() {
		return $this->getData('footer');
	}
	/**
	 * Set approval notice footer.
	 * @param $footer text
	 */
	function setApprovalNoticeFooter($footer) {
		return $this->setData('footer', $footer);
	}
        
        /**
         * Get list of acronmys of the concerned committees
         * @return string
         */
        function getCommitteesAcronyms(){
                $acronyms = (string)'';
                $committeesArray = $this->getCommitteesArray();
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
                foreach ($committeesArray as $committeeId) {
                    if ($committeeId == 0) {
                        if ($acronyms == '') {
                            $acronyms = Locale::translate('common.all');
                        } else {
                            $acronyms = $acronyms.', '.Locale::translate('common.all');
                        }
                    } else {
                        $committee =& $sectionDao->getSection($committeeId);
                        if ($acronyms == '') {
                            $acronyms = $committee->getLocalizedAbbrev();
                        } else {
                            $acronyms = $acronyms.', '.$committee->getLocalizedAbbrev();
                        }                        
                    }
                }
                return $acronyms;
        }
        
        /**
	 * Get a map for review type  to locale key.
	 * @return array
	 */
	function getReviewTypeMap() {
                return $reviewTypeMap = array(
                        APPROVAL_NOTICE_TYPE_ALL => 'common.all',
                        REVIEW_TYPE_INITIAL => 'submission.initialReview',
                        REVIEW_TYPE_PR => 'submission.progressReport',
                        REVIEW_TYPE_AMENDMENT => 'submission.protocolAmendment',
                        REVIEW_TYPE_SAE => 'submission.seriousAdverseEvents',
                        REVIEW_TYPE_FR => 'submission.finalReport'
                );
	}
        
        /**
         * Get list of all the concerned review types
         * @return string
         */
        function getReviewTypesList(){
            Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION));
            $reviewTypesString = (string) '';
            $reviewTypes = $this->getReviewTypesArray();
            $reviewtypeMap = $this->getReviewTypeMap();
            foreach ($reviewTypes as $reviewType) {
                if ($reviewTypesString == "") {
                    $reviewTypesString = Locale::translate($reviewtypeMap[$reviewType]);
                } else {
                    $reviewTypesString = $reviewTypesString.', '.Locale::translate($reviewtypeMap[$reviewType]);                    
                }
            }
            return $reviewTypesString;
        }
        
        /**
         * Clean the html for htmldocx converter
         * @param $function string function to get the rw html
         * @return $html the html cleaned
         */
        function getCleanHtml($function) {
            $html = $this->$function();
            $ps = $matches =array();
            $count = preg_match_all('/<td style="text-align:[^>]*>(.*?)<\/td>/is', $html, $matches);
            for ($i = 0; $i < $count; ++$i) {
                $ps[] = $matches[0][$i];
            }
            foreach ($ps as $item) {
                    $toReplace = $item;
                    $alignment = preg_replace('/<td style="text-align: /is', '', $item);
                    $alignment = preg_replace('/">.*/is', '', $alignment);
                    $replacement = preg_replace('/ style="text-align: '.$alignment.'">/is', '><p style="text-align: '.$alignment.'">', $item);
                    $replacement = preg_replace('~</td>~is', '</p></td>', $replacement);
                    $html = preg_replace('~'.$toReplace.'~is', $replacement, $html);
            }
            return $html;
        }
        
        /**
         * get a map of keys if the notice is active or not
         * @return array
         */
        function getActiveMap(){
            return array(
                APPROVAL_NOTICE_ACTIVE => 'common.yes',
                APPROVAL_NOTICE_INACTIVE => 'common.no'
            );
        }
        
        /**
         * Get the translation key if the notice is active or not.
         * @return key (string)
         */
        function getActiveKey(){
            $map = $this->getActiveMap();
            if ($this->getActive() != null) {
                return $map[$this->getActive()];
            } else {
                return null;
            }
        }
}

?>
