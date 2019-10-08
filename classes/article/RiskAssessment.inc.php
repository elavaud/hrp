<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/RiskAssessment.inc.php
 *
 *
 * @brief risk assessment class.
 * Added by EL on March 11th 2013
 */
define ('RISK_ASSESSMENT_NO', 0);
define ('RISK_ASSESSMENT_YES', 1);
define ('RISK_ASSESSMENT_NOT_PROVIDED', 2);

define ('RISK_ASSESSMENT_NO_LAB_CAPACITY', 0);
define ('RISK_ASSESSMENT_REQUIRE_QUALITY_ASSURANCE', 1);

define ('RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL', 1);
define ('RISK_ASSESSMENT_MINORE_THAN_MINIMAL', 2);
define ('RISK_ASSESSMENT_MORE_THAN_MINIMAL', 3);

define ('RISK_ASSESSMENT_CONFLICT_OF_INTEREST_YES', 1);
define ('RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NO', 2);
define ('RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NOT_SURE', 3);

class RiskAssessment extends DataObject {
	
	/**
	 * Constructor.
	 */
	function RiskAssessment() {
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
	 * Get identityRevealed.
	 * @return int
	 */
	function getIdentityRevealed() {
		return $this->getData('identityRevealed');
	}

	/**
	 * Set identityRevealed (yes/no).
	 * @param $identityRevealed int
	 */
	function setIdentityRevealed($identityRevealed) {
		return $this->setData('identityRevealed', $identityRevealed);
	}

	/**
	 * Get unableToConsent.
	 * @return int
	 */
	function getUnableToConsent() {
		return $this->getData('unableToConsent');
	}

	/**
	 * Set unableToConsent (yes/no).
	 * @param $unableToConsent int
	 */
	function setUnableToConsent($unableToConsent) {
		return $this->setData('unableToConsent', $unableToConsent);
	}

	/**
	 * Get under18.
	 * @return int
	 */
	function getUnder18() {
		return $this->getData('under18');
	}

	/**
	 * Set under18 (yes/no).
	 * @param $under18 int
	 */
	function setUnder18($under18) {
		return $this->setData('under18', $under18);
	}

	/**
	 * Get dependentRelationship.
	 * @return int
	 */
	function getDependentRelationship() {
		return $this->getData('dependentRelationship');
	}

	/**
	 * Set dependentRelationship (yes/no).
	 * @param $dependentRelationship int
	 */
	function setDependentRelationship($dependentRelationship) {
		return $this->setData('dependentRelationship', $dependentRelationship);
	}

	/**
	 * Get ethnicMinority.
	 * @return int
	 */
	function getEthnicMinority() {
		return $this->getData('ethnicMinority');
	}

	/**
	 * Set ethnicMinority (yes/no).
	 * @param $ethnicMinority int
	 */
	function setEthnicMinority($ethnicMinority) {
		return $this->setData('ethnicMinority', $ethnicMinority);
	}

	/**
	 * Get impairment.
	 * @return int
	 */
	function getImpairment() {
		return $this->getData('impairment');
	}

	/**
	 * Set impairment (yes/no).
	 * @param $impairment int
	 */
	function setImpairment($impairment) {
		return $this->setData('impairment', $impairment);
	}

	/**
	 * Get pregnant.
	 * @return int
	 */
	function getPregnant() {
		return $this->getData('pregnant');
	}

	/**
	 * Set pregnant (yes/no).
	 * @param $pregnant int
	 */
	function setPregnant($pregnant) {
		return $this->setData('pregnant', $pregnant);
	}

	/**
	 * Get newTreatment.
	 * @return int
	 */
	function getNewTreatment() {
		return $this->getData('newTreatment');
	}

	/**
	 * Set newTreatment (yes/no).
	 * @param $newTreatment int
	 */
	function setNewTreatment($newTreatment) {
		return $this->setData('newTreatment', $newTreatment);
	}

	/**
	 * Get bioSamples.
	 * @return int
	 */
	function getBioSamples() {
		return $this->getData('bioSamples');
	}

	/**
	 * Set bioSamples (yes/no).
	 * @param $bioSamples int
	 */
	function setBioSamples($bioSamples) {
		return $this->setData('bioSamples', $bioSamples);
	}
                
	/**
	 * Get if the research involves exporting human tissue outside of the country.
	 * @return int
	 */
	function getExportHumanTissue() {
		return $this->getData('exportHumanTissue');
	}

	/**
	 * Set if the research involves exporting human tissue outside of the country (yes/no).
	 * @param $exportHumanTissue int
	 */
	function setExportHumanTissue($exportHumanTissue) {
		return $this->setData('exportHumanTissue', $exportHumanTissue);
	}
                
	/**
	 * Get if the the reason of the export outside the country of the biological sample.
	 * @return int
	 */
	function getExportReason() {
		return $this->getData('exportReason');
	}

	/**
	 * Set if the the reason of the export outside the country of the biological sample.
	 * @param $exportReason int
	 */
	function setExportReason($exportReason) {
		return $this->setData('exportReason', $exportReason);
	}
        /**
	 * Get a map for export reasons constants to locale key.
	 * @return array
	 */
	function &getExportReasonMap() {
		static $exportReasonMap;
		if (!isset($exportReasonMap)) {
			$exportReasonMap = array(
                                RISK_ASSESSMENT_NO_LAB_CAPACITY => 'proposal.noLabCapacity',
				RISK_ASSESSMENT_REQUIRE_QUALITY_ASSURANCE => 'proposal.requireQualityAssusrance'
			);
		}
		return $exportReasonMap;
	}
	/**
	 * Get a locale key for export reasons
	 * @param $value
	 */
	function getExportReasonKey() {
		$exportReasonMap =& $this->getExportReasonMap();
		return $exportReasonMap[$this->getExportReason()];
	}
        
        
	/**
	 * Get radiation.
	 * @return int
	 */
	function getRadiation() {
		return $this->getData('radiation');
	}

	/**
	 * Set radiation (yes/no).
	 * @param $radiation int
	 */
	function setRadiation($radiation) {
		return $this->setData('radiation', $radiation);
	}

	/**
	 * Get distress.
	 * @return int
	 */
	function getDistress() {
		return $this->getData('distress');
	}

	/**
	 * Set distress (yes/no).
	 * @param $distress int
	 */
	function setDistress($distress) {
		return $this->setData('distress', $distress);
	}

	/**
	 * Get inducements.
	 * @return int
	 */
	function getInducements() {
		return $this->getData('inducements');
	}

	/**
	 * Set inducements (yes/no).
	 * @param $inducements int
	 */
	function setInducements($inducements) {
		return $this->setData('inducements', $inducements);
	}

	/**
	 * Get sensitiveInfo.
	 * @return int
	 */
	function getSensitiveInfo() {
		return $this->getData('sensitiveInfo');
	}

	/**
	 * Set sensitiveInfo (yes/no).
	 * @param $sensitiveInfo int
	 */
	function setSensitiveInfo($sensitiveInfo) {
		return $this->setData('sensitiveInfo', $sensitiveInfo);
	}

	/**
	 * Get reproTechnology.
	 * @return int
	 */
	function getReproTechnology() {
		return $this->getData('reproTechnology');
	}

	/**
	 * Set reproTechnology (yes/no).
	 * @param $reproTechnology int
	 */
	function setReproTechnology($reproTechnology) {
		return $this->setData('reproTechnology', $reproTechnology);
	}

	/**
	 * Get genetic.
	 * @return int
	 */
	function getGenetic() {
		return $this->getData('genetic');
	}

	/**
	 * Set genetic (yes/no).
	 * @param $genetic int
	 */
	function setGenetic($genetic) {
		return $this->setData('genetic', $genetic);
	}

	/**
	 * Get stemCell.
	 * @return int
	 */
	function getStemCell() {
		return $this->getData('stemCell');
	}

	/**
	 * Set stemCell (yes/no).
	 * @param $stemCell int
	 */
	function setStemCell($stemCell) {
		return $this->setData('stemCell', $stemCell);
	}

	/**
	 * Get biosafety.
	 * @return int
	 */
	function getBiosafety() {
		return $this->getData('biosafety');
	}

	/**
	 * Set biosafety (yes/no).
	 * @param $biosafety int
	 */
	function setBiosafety($biosafety) {
		return $this->setData('biosafety', $biosafety);
	}        
        
	/**
	 * Get riskLevel.
	 * @return int
	 */
	function getRiskLevel() {
		return $this->getData('riskLevel');
	}

	/**
	 * Set riskLevel (yes/no).
	 * @param $riskLevel int
	 */
	function setRiskLevel($riskLevel) {
		return $this->setData('riskLevel', $riskLevel);
	}
        /**
	 * Get a map for yes/no/not provided constant to locale key.
	 * @return array
	 */
	function &getRiskLevelMap() {
		static $riskLevelMap;
		if (!isset($riskLevelMap)) {
			$riskLevelMap = array(
                                RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL => 'proposal.riskLevelNoMore',
				RISK_ASSESSMENT_MINORE_THAN_MINIMAL => 'proposal.riskLevelMinore',
				RISK_ASSESSMENT_MORE_THAN_MINIMAL => 'proposal.riskLevelMore'
			);
		}
		return $riskLevelMap;
	}
	
	/**
	 * Get a locale key for yes/no/not provided
	 * @param $value
	 */
	function getRiskLevelKey() {
		$riskLevelMap =& $this->getRiskLevelMap();
		return $riskLevelMap[$this->getRiskLevel()];
	}
        
	/**
	 * Get listRisks.
	 * @return string
	 */
	function getListRisks() {
		return $this->getData('listRisks');
	}

	/**
	 * Set listRisks (yes/no).
	 * @param $listRisks string
	 */
	function setListRisks($listRisks) {
		return $this->setData('listRisks', $listRisks);
	}

	/**
	 * Get howRisksMinimized.
	 * @return string
	 */
	function getHowRisksMinimized() {
		return $this->getData('howRisksMinimized');
	}

	/**
	 * Set howRisksMinimized.
	 * @param $identityRevealed string
	 */
	function setHowRisksMinimized($howRisksMinimized) {
		return $this->setData('howRisksMinimized', $howRisksMinimized);
	}

	/**
	 * Get risksToTeam.
	 * @return int
	 */
	function getRisksToTeam() {
		return $this->getData('risksToTeam');
	}

	/**
	 * Set risksToTeam (yes/no).
	 * @param $risksToTeam int
	 */
	function setRisksToTeam($risksToTeam) {
		return $this->setData('risksToTeam', $risksToTeam);
	}
	
	/**
	 * Get risksToSubjects.
	 * @return int
	 */
	function getRisksToSubjects() {
		return $this->getData('risksToSubjects');
	}

	/**
	 * Set risksToSubjects (yes/no).
	 * @param $risksToSubjects int
	 */
	function setRisksToSubjects($risksToSubjects) {
		return $this->setData('risksToSubjects', $risksToSubjects);
	}
	
	/**
	 * Get risksToCommunity.
	 * @return int
	 */
	function getRisksToCommunity() {
		return $this->getData('risksToCommunity');
	}

	/**
	 * Set risksToCommunity (yes/no).
	 * @param $risksToCommunity int
	 */
	function setRisksToCommunity($risksToCommunity) {
		return $this->setData('risksToCommunity', $risksToCommunity);
	}
	
        /**
	 * Get risksToTeam.
	 * @return int
	 */
	function getLocalizedRisksApplyToString() {
                $firstRisk = true;
                $riskApplyTo = (string) '';
                if ($this->getRisksToTeam() == RISK_ASSESSMENT_YES) {
                    $riskApplyTo = Locale::translate('proposal.researchTeam');
                    $firstRisk = false;
                }
                if ($this->getRisksToSubjects() == RISK_ASSESSMENT_YES) {
                    if ($firstRisk) $riskApplyTo = Locale::translate('proposal.researchSubjects');
                    else $riskApplyTo .= ' & '.Locale::translate('proposal.researchSubjects');
                    $firstRisk = false;
                } 
                if ($this->getRisksToCommunity() == RISK_ASSESSMENT_YES) {
                    if ($firstRisk) $riskApplyTo = Locale::translate('proposal.widerCommunity');
                    else $riskApplyTo .= ' & '.Locale::translate('proposal.widerCommunity');
                    $firstRisk = false;
                } 
                
                if ($riskApplyTo == '') $riskApplyTo = Locale::translate('proposal.nobody');
                
		return $riskApplyTo;
	}

	/**
	 * Get benefitsToParticipants.
	 * @return int
	 */
	function getBenefitsToParticipants() {
		return $this->getData('benefitsToParticipants');
	}

	/**
	 * Set benefitsToParticipants (yes/no).
	 * @param $benefitsToParticipants int
	 */
	function setBenefitsToParticipants($benefitsToParticipants) {
		return $this->setData('benefitsToParticipants', $benefitsToParticipants);
	}
	
	/**
	 * Get knowledgeOnCondition.
	 * @return int
	 */
	function getKnowledgeOnCondition() {
		return $this->getData('knowledgeOnCondition');
	}

	/**
	 * Set knowledgeOnCondition (yes/no).
	 * @param $knowledgeOnCondition int
	 */
	function setKnowledgeOnCondition($knowledgeOnCondition) {
		return $this->setData('knowledgeOnCondition', $knowledgeOnCondition);
	}
	
	/**
	 * Get knowledgeOnDisease.
	 * @return int
	 */
	function getKnowledgeOnDisease() {
		return $this->getData('knowledgeOnDisease');
	}

	/**
	 * Set knowledgeOnDisease (yes/no).
	 * @param $knowledgeOnDisease int
	 */
	function setKnowledgeOnDisease($knowledgeOnDisease) {
		return $this->setData('knowledgeOnDisease', $knowledgeOnDisease);
	}
        
        /**
	 * Get risksToTeam.
	 * @return int
	 */
	function getLocalizedBenefitsToString() {
                $firstBenefit = true;
                $benefitsTo = (string) '';
                if ($this->getBenefitsToParticipants() == RISK_ASSESSMENT_YES) {
                    $benefitsTo = Locale::translate('proposal.directBenefits');
                    $firstBenefit = false;
                }
                if ($this->getKnowledgeOnCondition() == RISK_ASSESSMENT_YES) {
                    if ($firstBenefit) $benefitsTo = Locale::translate('proposal.participantCondition');
                    else $benefitsTo .= ' & '.Locale::translate('proposal.participantCondition');
                    $firstBenefit = false;
                } 
                if ($this->getKnowledgeOnDisease() == RISK_ASSESSMENT_YES) {
                    if ($firstBenefit) $benefitsTo = Locale::translate('proposal.diseaseOrCondition');
                    else $benefitsTo .= ' & '.Locale::translate('proposal.diseaseOrCondition');
                    $firstBenefit = false;
                } 
                
                if ($benefitsTo == '') $benefitsTo = Locale::translate('proposal.noBenefits');
                
		return $benefitsTo;
	}
        
        
	/**
	 * Get multiInstitutions.
	 * @return int
	 */
	function getMultiInstitutions() {
		return $this->getData('multiInstitutions');
	}

	/**
	 * Set multiInstitutions (yes/no).
	 * @param $multiInstitutions int
	 */
	function setMultiInstitutions($multiInstitutions) {
		return $this->setData('multiInstitutions', $multiInstitutions);
	}

	/**
	 * Get conflictOfInterest.
	 * @return int
	 * Modified and moved to the Risk Assessment part by EL on March 9th 2013
	 */
	function getConflictOfInterest() {
		return $this->getData('conflictOfInterest');
	}

	/**
	 * Set conflictOfInterest (yes/no).
	 * @param $conflictOfInterest int
	 * Modified and moved to the Risk Assessment part by EL on March 9th 2013
	 */
	function setConflictOfInterest($conflictOfInterest) {
		return $this->setData('conflictOfInterest', $conflictOfInterest);
	}
        /**
	 * Get a map for yes/no/not provided constant to locale key.
	 * @return array
	 */
	function &getConflictOfInterestMap() {
		static $conflictOfInterestMap;
		if (!isset($conflictOfInterestMap)) {
			$conflictOfInterestMap = array(
                                RISK_ASSESSMENT_CONFLICT_OF_INTEREST_YES => 'common.yes',
				RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NO => 'common.no',
				RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NOT_SURE => 'common.notSure'
			);
		}
		return $conflictOfInterestMap;
	}	

	/**
	 * Get a locale key for yes/no/not provided
	 * @param $value
	 */
	function getConflictOfInterestKey() {
		$conflictOfInterestMap =& $this->getConflictOfInterestMap();
		return $conflictOfInterestMap[$this->getConflictOfInterest()];
	}
        
        /**
	 * Get a map for yes/no/not provided constant to locale key.
	 * @return array
	 */
	function &getYesNoMap() {
		static $yesNoMap;
		if (!isset($yesNoMap)) {
			$yesNoMap = array(
                                RISK_ASSESSMENT_NOT_PROVIDED => 'common.dataNotProvided',
				RISK_ASSESSMENT_NO => 'common.no',
				RISK_ASSESSMENT_YES => 'common.yes'
			);
		}
		return $yesNoMap;
	}	
	/**
	 * Get a locale key for yes/no/not provided
	 * @param $value
	 */
	function getYesNoKey($value) {
		$yesNoMap =& $this->getYesNoMap();
		return $yesNoMap[$value];
	}
        
        
}
?>
