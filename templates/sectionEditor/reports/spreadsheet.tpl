{**
* spreadsheet.tpl
*
* Generate report - if spreadsheet to generate 
**}

<table width="100%" class="data" id="spreadsheetTable">
    <tr valign="top">
        <td width="25%"></td>
        <td width="25%"></td>
        <td width="25%"></td>
        <td width="25%"></td>
    </tr>
    <tr><td colspan="4">{translate key="editor.reports.spreadsheet.instruct"}</td></tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><i>{translate key="editor.reports.spreadsheet.multiEntries.instruct"}</i></td></tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><input type="checkbox" name="checkShowCriterias"/>{translate key="editor.reports.criterias.check"}</td></tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><b>{translate key="editor.reports.spreadsheet.general"}</b></td></tr>
    <tr>
        <td><input type="checkbox" name="checkProposalId" checked="checked"/>{translate key="common.proposalId"}</td>
        <td><input type="checkbox" name="checkDecisions"/>{translate key="editor.reports.spreadsheet.decisions"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
        <td><input type="checkbox" name="checkDateSubmitted"/>{translate key="submissions.submit"}</td>
        <td>&nbsp;</td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><b>{translate key="article.authors"}</b></td></tr>
    <tr>
        <td><input type="checkbox" name="checkName" checked="checked"/>{translate key="common.name"}</td>
        <td><input type="checkbox" name="checkAffiliation" checked="checked"/>{translate key="user.affiliation"}</td>
        <td><input type="checkbox" name="checkEmail"/>{translate key="user.email"}</td>
        <td><input type="checkbox" name="checkAllInvestigators"/>{translate key="editor.reports.spreadsheet.allInvestigators"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><b>{translate key="submission.titleAndAbstract"}</b></td></tr>
    <tr>
        <td><input type="checkbox" name="checkScientificTitle" checked="checked"/>{translate key="proposal.scientificTitle"}</td>
        <td><input type="checkbox" name="checkPublicTitle"/>{translate key="proposal.publicTitle"}</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td><input type="checkbox" name="checkBackground"/>{translate key="proposal.background"}</td>
        <td><input type="checkbox" name="checkObjectives"/>{translate key="proposal.objectives"}</td>
        <td><input type="checkbox" name="checkStudyMethods"/>{translate key="proposal.studyMethods"}</td>
        <td><input type="checkbox" name="checkExpectedOutcomes"/>{translate key="proposal.expectedOutcomes"}</td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><b>{translate key="submission.proposalDetails"}</b></td></tr>
    <tr>
        <td><input type="checkbox" name="checkStudentResearch"/>{translate key="proposal.studentInitiatedResearch"}</td>
        <td><input type="checkbox" name="checkResearchDates"/>{translate key="editor.reports.spreadsheet.researchDates"}</td>
        <td><input type="checkbox" name="checkKii" checked="checked"/>{translate key="proposal.keyImplInstitution"}</td>
        <td><input type="checkbox" name="checkMultiCountry"/>{translate key="proposal.multiCountryResearch"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
    </tr>
    <tr>
        <td><input type="checkbox" name="checkNationwide"/>{translate key="proposal.nationwide"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
        <td><input type="checkbox" name="checkResearchDomain"/>{translate key="proposal.researchDomains"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
        <td><input type="checkbox" name="checkResearchField"/>{translate key="proposal.researchField"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
        <td><input type="checkbox" name="checkProposalType"/>{translate key="proposal.proposalType"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
    </tr>
    <tr>
        <td><input type="checkbox" name="checkDataCollection"/>{translate key="proposal.dataCollection"}</td>
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><b>{translate key="proposal.sourceOfMonetary"}</b></td></tr>
    <tr>
        <td><input type="checkbox" name="checkTotalBudget"/>{translate key="proposal.fundsRequired"}</td>
        <td><input type="checkbox" name="checkSources"/>{translate key="editor.reports.spreadsheet.detailedSources"}&nbsp;{translate key="editor.reports.spreadsheet.multiEntries"}</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>    
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4"><b>{translate key="proposal.riskAssessment"}</b></td></tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4">{translate key="proposal.researchIncludesHumanSubject"}</td></tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkIdentityRevealed"/>{translate key="proposal.identityRevealed"}</td>
        <td colspan="2"><input type="checkbox" name="checkUnableToConsent"/>{translate key="proposal.unableToConsent"}</td>
    </tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkUnder18"/>{translate key="proposal.under18"}</td>
        <td colspan="2"><input type="checkbox" name="checkDependentRelationship"/>{translate key="proposal.dependentRelationship"}</td>
    </tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkEthnicMinority"/>{translate key="proposal.ethnicMinority"}</td>
        <td colspan="2"><input type="checkbox" name="checkImpairment"/>{translate key="proposal.impairment"}</td>
    </tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkPregnant"/>{translate key="proposal.pregnant"}</td>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr><td colspan="4">{translate key="proposal.researchIncludes"}</td></tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkNewTreatment"/>{translate key="proposal.newTreatment"}</td>
        <td colspan="2"><input type="checkbox" name="checkBioSamples"/>{translate key="proposal.bioSamples"}</td>
    </tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkRadiation"/>{translate key="proposal.radiation"}</td>
        <td colspan="2"><input type="checkbox" name="checkDistress"/>{translate key="proposal.distress"}</td>
    </tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkInducements"/>{translate key="proposal.inducements"}</td>
        <td colspan="2"><input type="checkbox" name="checkSensitiveInfo"/>{translate key="proposal.sensitiveInfo"}</td>
    </tr>
    <tr>
        <td colspan="2"><input type="checkbox" name="checkReproTechnology"/>{translate key="proposal.reproTechnology"}</td>
        <td colspan="2"><input type="checkbox" name="checkGenetic"/>{translate key="proposal.genetic"}</td>
    </tr>    
    <tr>
        <td colspan="2"><input type="checkbox" name="checkStemCell"/>{translate key="proposal.stemCell"}</td>
        <td colspan="2"><input type="checkbox" name="checkBiosafety"/>{translate key="proposal.biosafety"}</td>
    </tr>    
</table>
