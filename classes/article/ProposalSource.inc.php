<?php

/**
 * @file classes/article/ProposalSource.inc.php
 *
 * @class ProposalSource
 * @ingroup article
 * @see ProposalSourceDAO
 *
 * @brief Source of monetary and material support of a proposal.
 */


class ProposalSource extends DataObject {
        
        var $institutionDao;
	
        /**
	 * Constructor.
	 */
	function ProposalSource() {
                $this->institutionDao =& DAORegistry::getDAO('InstitutionDAO');
	}

	//
	// Get/set methods
	//

	/**
	 * Get source id.
	 * @return int
	 */
	function getSourceId() {
		return $this->getData('sourceId');
	} 

	/**
	 * Set source id.
	 * @param $sourceId int
	 */
	function setSourceId($sourceId) {
		return $this->setData('sourceId', $sourceId);
	}

        
        /**
	 * Get article id.
	 * @return int
	 */
	function getArticleId() {
		return $this->getData('articleId');
	}

	/**
	 * Set article id.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		return $this->setData('articleId', $articleId);
	}

        /**
	 * Get institution ID.
	 * @return int
	 */
	function getInstitutionId() {
		return $this->getData('institutionId');
	}

	/**
	 * Set institution ID.
	 * @param $institutionId int
	 */
	function setInstitutionId($institutionId) {
		return $this->setData('institutionId', $institutionId);
	}

        
        /**
	 * Get source amount.
	 * @return int
	 */
	function getSourceAmount() {
		return $this->getData('sourceAmount');
	}

	/**
	 * Set source amount.
	 * @param $sourceAmount int
	 */
	function setSourceAmount($sourceAmount) {
		return $this->setData('sourceAmount', $sourceAmount);
	}
        
        /**
	 * Get source amount to display in a readable manner ("12 345 678" instead of "12345678").
	 * @return string
	 */
	function getSourceAmountString() {
		$sourceAmountString = (string) $this->getData('sourceAmount');
                $sourceAmountReversed = strrev($sourceAmountString);
                $sourceAmountReversedArray = str_split($sourceAmountReversed, 3);
                $stringToReturn = (string) "";
                foreach (array_reverse($sourceAmountReversedArray) as $sourceAmountReversedItem) {
                    $stringToReturn = $stringToReturn.' '.strrev($sourceAmountReversedItem);
                }
                return $stringToReturn;
	}
        
        /**
	 * Get the name of the institution of the source.
	 * @return int
	 */
	function getSourceInstitutionName() {
                $institution =& $this->getSourceInstitution();
		return $institution->getInstitutionName();
	}
                
        /**
	 * Get the acronym of the institution of the source.
	 * @return int
	 */
	function getSourceInstitutionAcronym() {
                $institution =& $this->getSourceInstitution();
		return $institution->getInstitutionAcronym();
	}
                
        /**
	 * Get the name of the institution of the source.
	 * @return int
	 */
	function getSourceInstitution() {
		return $this->institutionDao->getInstitutionById($this->getInstitutionId());
        }
}
?>
