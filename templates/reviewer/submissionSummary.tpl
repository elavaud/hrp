{**
 * submission.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the reviewer administration page.
 *
 * FIXME: At "Notify The Editor", fix the date.
 *
 * $Id$
 *}

<div id="Authors">
	<h4>{translate key="article.authors"}</h4>
	<table class="listing" width="100%">
		{foreach name=authors from=$submission->getAuthors() item=author}
			<tr valign="top">
				<td width="20%" class="label">{if $author->getPrimaryContact()}{translate key="user.role.primaryInvestigator"}{else}{translate key="user.role.coinvestigator"}{/if}</td>
        		<td class="value">
					{$author->getFullName()|escape}<br />
					{$author->getEmail()|escape}<br />
					{if ($author->getAffiliation()) != ""}{$author->getAffiliation()|escape}<br/>{/if}
					{if ($author->getPhoneNumber()) != ""}{$author->getPhoneNumber()|escape}<br/>{/if}
        		</td>
    		</tr>
		{/foreach}
	</table>
	<div class="separator"></div>
</div>

<div id="titleAndAbstract">

	<h4><br/>{translate key="submission.titleAndAbstract"}</h4>
	
	{assign var="abstracts" value=$submission->getAbstracts()}
	
	{foreach from=$abstractLocales item=localeName key=localeKey}
	
            {assign var="abstract" value=$abstracts[$localeKey]}
            
            {if $abstract}

		<h6>{$localeName} {translate key="common.language"}</h6>
		
		<table class="listing" width="100%">
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.scientificTitle"}</td>
        		<td class="value">{$abstract->getScientificTitle()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.publicTitle"}</td>
        		<td class="value">{$abstract->getPublicTitle()}</td>
    		</tr>
    		<tr><td colspan="2">&nbsp;</td></tr>
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.background"}</td>
        		<td class="value">{$abstract->getBackground()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.objectives"}</td>
        		<td class="value">{$abstract->getObjectives()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.studyMethods"}</td>
        		<td class="value">{$abstract->getStudyMethods()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.expectedOutcomes"}</td>
        		<td class="value">{$abstract->getExpectedOutcomes()}</td>
    		</tr>
    		<tr><td colspan="2">&nbsp;</td></tr>
    		<tr valign="top">
        		<td class="label" width="20%">{translate key="proposal.keywords"}</td>
        		<td class="value">{$abstract->getKeywords()}</td>
    		</tr>
		</table>
                
            {/if}
            
	{/foreach}
	<div class="separator"></div>
</div>

<div id="proposalDetails">
	<h4><br/>{translate key="submission.proposalDetails"}</h4>

	{assign var="proposalDetails" value=$submission->getProposalDetails()}
	
	<table class="listing" width="100%">
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.studentInitiatedResearch"}</td>
        	<td class="value">{translate key=$proposalDetails->getYesNoKey($proposalDetails->getStudentResearch())}</td>
    	</tr>
    	{if ($proposalDetails->getStudentResearch()) == PROPOSAL_DETAIL_YES}
			{assign var="studentResearch" value=$proposalDetails->getStudentResearchInfo()}
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="proposal.studentInstitution"}: {$studentResearch->getInstitution()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="proposal.academicDegree"}: {translate key=$studentResearch->getDegreeKey()}</td>
    		</tr>
        	<tr valign="top" id="supervisor"><td class="label" width="20%">&nbsp;</td><td class="value"><b>{translate key="proposal.studentSupervisor"}</b></td></tr>
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="proposal.studentSupervisorName"}: {$studentResearch->getSupervisorName()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="user.email"}: {$studentResearch->getSupervisorEmail()}</td>
    		</tr>
        	<tr valign="top"><td class="label" width="20%">&nbsp;</td><td class="value">&nbsp;</td></tr>
    	{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.startDate"}</td>
        	<td class="value">{$proposalDetails->getStartDate()}</td>
   	 	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.endDate"}</td>
        	<td class="value">{$proposalDetails->getEndDate()}</td>
    	</tr>
        <tr valign="top">
            <td class="label" width="20%">{translate key="proposal.keyImplInstitution"}</td>
            <td class="value">{$proposalDetails->getKeyImplInstitutionName()}</td>
        </tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.multiCountryResearch"}</td>
        	<td class="value">{translate key=$proposalDetails->getYesNoKey($proposalDetails->getMultiCountryResearch())}</td>
    	</tr>
        {if ($proposalDetails->getMultiCountryResearch()) == PROPOSAL_DETAIL_YES}
            <tr valign="top">
                <td class="label" width="20%">&nbsp;</td>
                <td class="value">{$proposalDetails->getLocalizedMultiCountryText()}</td>
            </tr>
    	{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.nationwide"}</td>
        	<td class="value">{translate key=$proposalDetails->getNationwideKey()}</td>
   	 	</tr>
    	{if $proposalDetails->getNationwide() == PROPOSAL_DETAIL_NO || $proposalDetails->getNationwide() == PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS}
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{$proposalDetails->getLocalizedGeoAreasText()}</td>
    		</tr>
        {/if}
        <tr valign="top">
                <td class="label" width="20%">{translate key="proposal.researchDomains"}</td>
                <td class="value">{$proposalDetails->getLocalizedResearchDomainsText()}</td>
        </tr>	    	
        <tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.researchField"}</td>
        	<td class="value">{$proposalDetails->getLocalizedResearchFieldText()}</td>
    	</tr>	
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.withHumanSubjects"}</td>
        	<td class="value">{translate key=$proposalDetails->getYesNoKey($proposalDetails->getHumanSubjects())}</td>
    	</tr>
    	{if ($proposalDetails->getHumanSubjects()) == PROPOSAL_DETAIL_YES}
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{$proposalDetails->getLocalizedProposalTypeText()}</td>
   			</tr>
    	{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.dataCollection"}</td>
        	<td class="value">{translate key=$proposalDetails->getDataCollectionKey()}</td>
    	</tr>   
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.reviewedByOtherErc"}</td>
        	<td class="value">{translate key=$proposalDetails->getCommitteeReviewedKey()}</td>
    	</tr>
	</table>
	<div class="separator"></div>
</div>

<div id="sourceOfMonetary">
    <h4><br/>{translate key="proposal.sourceOfMonetary"}</h4>
    <div class="separator"></div>
    <table class="listing" width="100%">
        {assign var="sources" value=$submission->getSources()}
        {foreach from=$sources item=source}
            <tr valign="top">
                <td width="30%" class="label">{$source->getSourceInstitutionName()}</td>
                <td width="70%" class="value">{$source->getSourceAmountString()}&nbsp;&nbsp;{$sourceCurrency->getCodeAlpha()|escape}</td>
            </tr>
        {/foreach}    
    </table>
    <p><b>{translate key="proposal.fundsRequired"}</b>&nbsp;&nbsp;&nbsp;&nbsp;{$submission->getTotalBudgetString()}&nbsp;&nbsp;{$sourceCurrency->getName()|escape}&nbsp;({$sourceCurrency->getCodeAlpha()|escape})</p>
</div>

<div id=riskAssessments>
    <h4><br/>{translate key="proposal.riskAssessment"}</h4>

    {assign var="riskAssessment" value=$submission->getRiskAssessment()}

    <table class="listing" width="100%">
        <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
        <tr valign="top" id="identityRevealedField">
            <td class="label" width="30%">{translate key="proposal.identityRevealed"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getIdentityRevealed())}</td>
        </tr>
        <tr valign="top" id="unableToConsentField">
            <td class="label" width="20%">{translate key="proposal.unableToConsent"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getUnableToConsent())}</td>
        </tr>
        <tr valign="top" id="under18Field">
            <td class="label" width="20%">{translate key="proposal.under18"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getUnder18())}</td>
        </tr>
        <tr valign="top" id="dependentRelationshipField">
            <td class="label" width="20%">{translate key="proposal.dependentRelationship"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getDependentRelationship())}</td>
        </tr>
        <tr valign="top" id="ethnicMinorityField">
            <td class="label" width="20%">{translate key="proposal.ethnicMinority"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getEthnicMinority())}</td>
        </tr>
        <tr valign="top" id="impairmentField">
            <td class="label" width="20%">{translate key="proposal.impairment"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getImpairment())}</td>
        </tr>
        <tr valign="top" id="pregnantField">
            <td class="label" width="20%">{translate key="proposal.pregnant"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getPregnant())}</td>
        </tr>
        <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
        <tr valign="top" id="newTreatmentField">
            <td class="label" width="20%">{translate key="proposal.newTreatment"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getNewTreatment())}</td>
        </tr>
        <tr valign="top" id="bioSamplesField">
            <td class="label" width="20%">{translate key="proposal.bioSamples"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getBioSamples())}</td>
        </tr>
        {if ($riskAssessment->getBioSamples()) == RISK_ASSESSMENT_YES}
            <tr valign="top" id="exportHumanTissueField">
                <td class="label" width="20%">{translate key="proposal.exportHumanTissue"}</td>
                <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getExportHumanTissue())}</td>
            </tr>
        {/if}
        {if (($riskAssessment->getBioSamples()) == RISK_ASSESSMENT_YES) && (($riskAssessment->getExportHumanTissue()) == RISK_ASSESSMENT_YES)}
            <tr valign="top" id="exportReasonField">
                <td class="label" width="20%">{translate key="proposal.exportReason"}</td>
                <td class="value">{translate key=$riskAssessment->getExportReasonKey()}</td>
            </tr>                           
        {/if}                    
        <tr valign="top" id="radiationField">
            <td class="label" width="20%">{translate key="proposal.radiation"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getRadiation())}</td>
        </tr>
        <tr valign="top" id="distressField">
            <td class="label" width="20%">{translate key="proposal.distress"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getDistress())}</td>
        </tr>
        <tr valign="top" id="inducementsField">
            <td class="label" width="20%">{translate key="proposal.inducements"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getInducements())}</td>
        </tr>
        <tr valign="top" id="sensitiveInfoField">
            <td class="label" width="20%">{translate key="proposal.sensitiveInfo"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getSensitiveInfo())}</td>
        </tr>
        <tr valign="top" id="reproTechnologyField">
            <td class="label" width="20%">{translate key="proposal.reproTechnology"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getReproTechnology())}</td>
        </tr>
        <tr valign="top" id="geneticsField">
            <td class="label" width="20%">{translate key="proposal.genetic"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getGenetic())}</td>
        </tr>
        <tr valign="top" id="stemCellField">
            <td class="label" width="20%">{translate key="proposal.stemCell"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getStemCell())}</td>
        </tr>
        <tr valign="top" id="biosafetyField">
            <td class="label" width="20%">{translate key="proposal.biosafety"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getBiosafety())}</td>
        </tr>
        <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.potentialRisk"}</b></td></tr>
        <tr valign="top" id="riskLevelField">
            <td class="label" width="20%">{translate key="proposal.riskLevel"}</td>
            <td class="value">{translate key=$riskAssessment->getRiskLevelKey()}</td>
        </tr>
        {if $riskAssessment->getRiskLevel() != RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL}
            <tr valign="top" id="listRisksField">
                <td class="label" width="20%">{translate key="proposal.listRisks"}</td>
                <td class="value">{$riskAssessment->getListRisks()}</td>
            </tr>
            <tr valign="top" id="howRisksMinimizedField">
                <td class="label" width="20%">{translate key="proposal.howRisksMinimized"}</td>
                <td class="value">{$riskAssessment->getHowRisksMinimized()}</td>
            </tr>
        {/if}
        <tr valign="top" id="riskApplyToField">
            <td class="label" width="20%">{translate key="proposal.riskApplyTo"}</td>
            <td class="value">{$riskAssessment->getLocalizedRisksApplyToString()}</td>
        </tr>
        <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.potentialBenefits"}</b></td></tr>
        <tr valign="top" id="benefitsFromTheProjectField">
            <td class="label" width="20%">{translate key="proposal.benefitsFromTheProject"}</td>
            <td class="value">{$riskAssessment->getLocalizedBenefitsToString()}</td>
        </tr>
        <tr valign="top" id="multiInstitutionsField">
            <td class="label" width="20%">{translate key="proposal.multiInstitutions"}</td>
            <td class="value">{translate key=$riskAssessment->getYesNoKey($riskAssessment->getMultiInstitutions())}</td>
        </tr>
        <tr valign="top" id="conflictOfInterestField">
            <td class="label" width="20%">{translate key="proposal.conflictOfInterest"}</td>
            <td class="value">{translate key=$riskAssessment->getConflictOfInterestKey()}</td>
        </tr>
    </table>
</div>

<div class="separator"></div>


