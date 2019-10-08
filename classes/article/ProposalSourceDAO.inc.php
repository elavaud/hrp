<?php

/**
 * @file classes/article/ProposalSourceDAO.inc.php
 *
 * @class ProposalSourceDAO
 *
 * @brief Operations for retrieving and modifying proposal source objects.
 */

// $Id$

import('classes.article.ProposalSource');

class ProposalSourceDAO extends DAO{
 
        /**
	 * Constructor.
	 */
	function ProposalSourceDAO() {
		parent::DAO();
        }

        /**
	 * Get a specific proposal source by source ID.
	 * @param $sourceId int
	 * @return proposalSource object
	 */
	function &getProposalSourceBySourceId($sourceId) {

		$result =& $this->retrieve(
			'SELECT * FROM article_source WHERE source_id = ? LIMIT 1',
			(int) $sourceId
		);

		$proposalSource =& $this->_returnProposalSourceFromRow($result->GetRowAssoc(false));

		$result->Close();
		unset($result);

		return $proposalSource;
	}

        /**
	 * Get all the sources of monetary and material support of a specific proposal.
	 * @param $articleId int
	 * @return proposalSource object
	 */
	function &getProposalSourcesByArticleId($articleId) {
		$sources = array();

		$result =& $this->retrieve(
			'SELECT * FROM article_source WHERE article_id = ? ORDER BY amount',
			(int) $articleId
		);

		while (!$result->EOF) {
			$sources[] =& $this->_returnProposalSourceFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $sources;
	}
        
	/**
	 * Insert a new source of monetary and material support
	 * @param $proposalSource object
	 */
	function insertProposalSource(&$proposalSource) {
		$this->update(
			'INSERT INTO article_source
				(article_id, institution_id, amount)
				VALUES			
                                (?, ?, ?)',
			array(
				(int) $proposalSource->getArticleId(),
				(int) $proposalSource->getInstitutionId(),
				(int) $proposalSource->getSourceAmount()
			)
		);

		$proposalSource->setSourceId($this->getInsertSourceId());
		return $proposalSource->getSourceId();
	}

	/**
	 * Update an existing proposal source object.
	 * @param $proposalSource ProposalSource object
	 */
	function updateProposalSource(&$proposalSource) {
		$returner = $this->update(
			'UPDATE article_source
			SET	article_id = ?,
				institution_id = ?,
				amount = ?
			WHERE	source_id = ?',
			array(
				$proposalSource->getArticleId(),
				$proposalSource->getInstitutionId(),
				$proposalSource->getSourceAmount(),
				$proposalSource->getSourceId()
			)
		);
		return $returner;
	}

	/**
	 * Delete a specific proposal source by source ID
	 * @param $sourceId int
	 */
	function deleteProposalSourceById($sourceId) {
		$returner = $this->update(
			'DELETE FROM article_source WHERE source_id = ?',
			$sourceId
		);

		return $returner;
	}
        
        /**
	 * Delete sources by research proposals.
	 * @param $articleId int
	 */
	function deleteSourcesByArticle($articleId) {
		$sources =& $this->getProposalSourcesByArticleId($articleId);
		foreach ($sources as $source) {
			$this->deleteProposalSourceById($source->getSourceId());
		}
	}
        
        /**
	 * Internal function to return a proposal source object from a row.
	 * @param $row array
	 * @return ProposalSource object
	 */
	function &_returnProposalSourceFromRow(&$row) {
            
		$proposalSource = new ProposalSource();
                
		$proposalSource->setSourceId($row['source_id']);
		$proposalSource->setArticleId($row['article_id']);
		$proposalSource->setInstitutionId($row['institution_id']);
		$proposalSource->setSourceAmount($row['amount']);
                
		HookRegistry::call('ProposalSourceDAO::_returnProposalSourceFromRow', array(&$proposalSource, &$row));
                
		return $proposalSource;
	}
        
        
        /**
	 * Get the ID of the last inserted source.
	 * @return int
	 */
	function getInsertSourceId() {
		return $this->getInsertId('article_source', 'source_id');
	}
        
        /*
         * Count the number of sources using a specific institution
         */
        function getCountSourcesByInstitution($institutionId) {
            $result = $this->retrieve('SELECT count(*) FROM article_source WHERE institution_id = ?', (int) $institutionId);
            
            $returner = isset($result->fields[0]) ? $result->fields[0] : 0;

            $result->Close();
            unset($result);
            return $returner;            
        }
        
        /*
         * Replace the institution by another institution
         */
        function replaceInstitutionSource($oldInstitutionId, $replacementInstitutionId) {
		return $this->update('UPDATE article_source SET institution_id = '.$replacementInstitutionId.' WHERE institution_id = '.$oldInstitutionId);
        }
        
        /*
         * count how many proposal sources has already been entered or not.
         */
        function countSources() {
            $result = $this->retrieve('SELECT count(*) FROM article_source');
            
            $returner = isset($result->fields[0]) ? $result->fields[0] : 0;

            $result->Close();
            unset($result);
            return $returner;            
        }        
        
        /*
         * The currency has been changed and all the sources of monetary should be change with the new currency using the exchange rate
	 * @param $exchangeRate int
         */
        function changeCurrency($exchangeRate) {
		return $this->update('UPDATE article_source SET amount = amount*'.$exchangeRate);
        }         
}

?>
