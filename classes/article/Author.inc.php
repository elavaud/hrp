<?php

/**
 * @file classes/article/Author.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class Author
 * @ingroup article
 * @see AuthorDAO
 *
 * @brief Article author metadata class.
 */


import('lib.pkp.classes.submission.PKPAuthor');

class Author extends PKPAuthor {
	/**
	 * Constructor.
	 */
	function Author() {
		parent::PKPAuthor();
	}

	//
	// Get/set methods
	//

	/**
	 * Get ID of article.
	 * @return int
	 */
	function getArticleId() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getSubmissionId();
	}

	/**
	 * Set ID of article.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->setSubmissionId($articleId);
	}

	/**
	 * Get the localized competing interests statement for this author
	 */
	function getLocalizedCompetingInterests() {
		return $this->getLocalizedData('competingInterests');
	}

	function getAuthorCompetingInterests() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedCompetingInterests();
	}

	/**
	 * Get author competing interests.
	 * @param $locale string
	 * @return string
	 */
	function getCompetingInterests($locale) {
		return $this->getData('competingInterests', $locale);
	}

	/**
	 * Set author competing interests.
	 * @param $competingInterests string
	 * @param $locale string
	 */
	function setCompetingInterests($competingInterests, $locale) {
		return $this->setData('competingInterests', $competingInterests, $locale);
	}
        
        /**
         * Get all the research fields of authors having the same email address (localized)
         */
        function getAllResearchFieldsText(){
		$authorDao =& DAORegistry::getDAO('AuthorDAO');
		$proposalDetailsDao =& DAORegistry::getDAO('ProposalDetailsDAO');
                
                // get all the authors with the same email
                $authors = $authorDao->getAuthorsByEmail($this->getEmail());

                $researchFields = array();
                
                // Get all the research fields of every submissions by the author
                foreach ($authors as $author) {
                    $proposalDetails = $proposalDetailsDao->getProposalDetailsByArticleId($author->getSubmissionId());
                    $rFields = $proposalDetails->getResearchFields(); 
                    $researchFieldCodeArray = explode("+", $rFields);
                    foreach ($researchFieldCodeArray as $rField) {
                        $researchFields[] = $rField;
                    }
                }

                // clean the arry of duplicates
                $researchFieldsCleaned = array_unique($researchFields);
                
                $researchFieldTextArray = array();
                $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                foreach($researchFieldsCleaned as $rFieldCode) {
                    $extraField =& $extraFieldDao->getExtraField($rFieldCode);
                    $fieldText = (isset($extraField) ? $extraField->getLocalizedExtraFieldName() : '');
                    array_push($researchFieldTextArray, $fieldText);
                    unset($extraField);
                }
                
                $researchFieldText = "";
                foreach($researchFieldTextArray as $i => $rfText) {
                    $researchFieldText = $researchFieldText . $rfText;
                    if($i < count($researchFieldTextArray)-1) $researchFieldText = $researchFieldText . ", ";
                }

                return $researchFieldText;
        }
        
        
        /**
         * Get all the affiliations of authors having the same email address
         */
        function getAllAffiliations(){
		$authorDao =& DAORegistry::getDAO('AuthorDAO');
                
                // get all the authors with the same email
                $authors = $authorDao->getAuthorsByEmail($this->getEmail());

                $affiliations = array();
                
                // Get all the research fields of every submissions by the author
                foreach ($authors as $author) {
                    $affiliations[] = $author->getAffiliation();
                }

                // clean the arry of duplicates
                $affiliationsCleaned = array_unique($affiliations);
                
                $affiliationsText = (string) '';

                foreach($affiliationsCleaned as $affiliation) {
                    if ($affiliationsText === ''){
                        $affiliationsText = $affiliation;
                    } else {
                        $affiliationsText = $affiliationsText.', '.$affiliation;
                    }
                }
                
                return $affiliationsText;
        }

}

?>
