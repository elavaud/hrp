<?php

/**
 * @file classes/article/AbstractDAO.inc.php
 *
 * @class AbstractDAO
 *
 * @brief Operations for retrieving and modifying abstract objects.
 * Added by EL on March 11th 2013
 */

// $Id$

import('classes.article.ProposalAbstract');

class ProposalAbstractDAO extends DAO {


    	/**
	 * Get the abstract object of a submission.
	 * @param $abstractId int
	 * @return abstract object
	 */
	function &getAbstractById($abstractId) {

		$result =& $this->retrieve('SELECT * FROM article_abstract WHERE abstract_id = ?', (int) $abstractId);		

		$abstract =& $this->_returnAbstractFromRow($result->GetRowAssoc(false));

		$result->Close();
		unset($result);

		return $abstract;
	}

        /**
	 * Get all abstracts object of a submission.
	 * @param $abstractId int
	 * @return array Abstracts
	 */
	function &getAbstractsByArticle($abstractId) {
                $abstracts = array();
                
		$result =& $this->retrieve('SELECT * FROM article_abstract WHERE article_id = ?', (int) $abstractId);		

		while (!$result->EOF) {
                    	$row =& $result->getRowAssoc(false);
			$abstracts[$row['locale']] =& $this->_returnAbstractFromRow($row);
			$result->moveNext();
		}
		$result->Close();
		unset($result);

		return $abstracts;
	}


	/**
	 * Insert a new abstract object.
	 * @param $abstract Abstract
	 */
	function insertAbstract(&$abstract) {
		$this->update(
			'INSERT INTO article_abstract 
				(article_id, locale, scientific_title, clean_scientific_title, public_title, clean_public_title, background, objectives, study_methods, expected_outcomes, keywords)
			VALUES
				(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
			array(
				(int) $abstract->getArticleId(),
				$abstract->getLocale(),
				$abstract->getScientificTitle(),
				$abstract->getCleanScientificTitle(),
				$abstract->getPublicTitle(),
				$abstract->getCleanPublicTitle(),
				$abstract->getBackground(),
				$abstract->getObjectives(),
				$abstract->getStudyMethods(),
				$abstract->getExpectedOutcomes(),
				$abstract->getKeywords()
			)
		);		
		return true;
	}

	/**
	 * Update an existing Abstract.
	 * @param $abstract Abstract
	 */
	function updateAbstract(&$abstract) {
		$returner = $this->update(
			'UPDATE article_abstract
			SET	
				article_id = ?,
				locale = ?,
				scientific_title = ?, 
				clean_scientific_title = ?,
				public_title = ?,
				clean_public_title = ?,
				background = ?,
				objectives = ?,
				study_methods = ?,
				expected_outcomes = ?,
				keywords = ?
			WHERE	abstract_id = ?',
			array(
				(int) $abstract->getArticleId(),
				$abstract->getLocale(),
				$abstract->getScientificTitle(),
				$abstract->getCleanScientificTitle(),
				$abstract->getPublicTitle(),
				$abstract->getCleanPublicTitle(),
				$abstract->getBackground(),
				$abstract->getObjectives(),
				$abstract->getStudyMethods(),
				$abstract->getExpectedOutcomes(),
				$abstract->getKeywords(),
                                $abstract->getAbstractId()
			)
		);
		return true;
	}

	/**
	 * Delete a specific abstract by ID
	 * @param $abstractId int
	 */
	function deleteAbstract($abstractId) {
		
		$returner = $this->update('DELETE FROM article_abstract WHERE abstract_id = ?',(int) $abstractId);
		
		return $returner;
	}

        /**
	 * Delete abstracts by article ID
	 * @param $articleId int
	 */
	function deleteAbstractsByArticleId($articleId) {
		
		$returner = $this->update('DELETE FROM article_abstract WHERE article_id = ?',(int) $articleId);
		
		return $returner;
	}
        
        
        /**
	 * Delete a specific abstract by article ID and locale
	 * @param $articleId int
	 */
	function deleteAbstractsByLocaleAndArticleId($locale, $articleId) {
		
		$returner = $this->update('DELETE FROM article_abstract WHERE locale = ' . $locale . ' AND article_id = ' . $articleId);
		
		return $returner;
	}
        
        
	/**
	 * Check if an abstract exists
	 * @param $submissionId int
	 * @param $locale int optional
	 * @return boolean
	 */
	function abstractExists($submissionId, $locale = null) {
		
		if ($locale == null) $result =& $this->retrieve('SELECT count(*) FROM article_abstract WHERE article_id = ?', (int) $submissionId);
		else $result =& $this->retrieve('SELECT count(*) FROM article_abstract WHERE article_id = ? AND locale = ?', array((int) $submissionId, $locale));
		
		$returner = $result->fields[0]?true:false;
		$result->Close();
		
		return $returner;
	}

	/**
	 * Internal function to return an abstract object from a row.
	 * @param $row array
	 * @return abstract Abstract
	 */
	function &_returnAbstractFromRow(&$row) {
		$abstract = new ProposalAbstract();
		$abstract->setAbstractId($row['abstract_id']);
		$abstract->setArticleId($row['article_id']);
		$abstract->setLocale($row['locale']);
		$abstract->setScientificTitle($row['scientific_title']);
		$abstract->setPublicTitle($row['public_title']);
		$abstract->setBackground($row['background']);
		$abstract->setObjectives($row['objectives']);
		$abstract->setStudyMethods($row['study_methods']);
		$abstract->setExpectedOutcomes($row['expected_outcomes']);
		$abstract->setKeywords($row['keywords']);

		HookRegistry::call('AbstractDAO::_returnAbstractFromRow', array(&$abstract, &$row));

		return $abstract;
	}
}

?>
