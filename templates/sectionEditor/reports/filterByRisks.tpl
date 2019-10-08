{**
* filterByRisks.tpl
*
* Generate report - filter by risks part 
**}

<p><b><a id="showOrHideRiskAssessmentTableClick" class="action" style="cursor: pointer;">{translate key="proposal.riskAssessment"}</a></b></p>
<input type="hidden" id="riskAssessmentTableShow" name="riskAssessmentTableShow" />        

<table width="100%" class="data" id="riskAssessmentTable">
    <tr valign="top">
        <td width="40%"></td>
        <td width="60%"></td>
    </tr>            
    <tr valign="top"><td colspan="2" class="label"><i>{translate key='editor.reports.hideWillErase'}</i></td></tr>
    <tr valign="top"><td colspan="2" class="label">&nbsp;</td></tr>

    <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
    <tr valign="top"><td colspan="2">&nbsp;</td></tr>
    <tr valign="top" id="identityRevealedField">
        <td class="label">{fieldLabel name="identityRevealed" required="true" key="proposal.identityRevealed"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='identityRevealed' options=$riskAssessmentYesNoArray selected=$identityRevealed separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearIdentityRevealed" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>
        </td>
    </tr>
    <tr valign="top" id="unableToConsentField">
        <td class="label">{fieldLabel name="unableToConsent" required="true" key="proposal.unableToConsent"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='unableToConsent' options=$riskAssessmentYesNoArray selected=$unableToConsent separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearUnableToConsent" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>
        </td>
    </tr>
    <tr valign="top" id="under18Field">
        <td class="label">{fieldLabel name="under18" required="true" key="proposal.under18"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='under18' options=$riskAssessmentYesNoArray selected=$under18 separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearUnder18" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="dependentRelationshipField">
        <td class="label">{fieldLabel name="dependentRelationship" required="true" key="proposal.dependentRelationship"}<br/><i>{translate key="proposal.dependentRelationshipInstruct"}</i></td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='dependentRelationship' options=$riskAssessmentYesNoArray selected=$dependentRelationship separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearDependentRelationship" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="ethnicMinorityField">
        <td class="label">{fieldLabel name="ethnicMinority" required="true" key="proposal.ethnicMinority"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='ethnicMinority' options=$riskAssessmentYesNoArray selected=$ethnicMinority separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearEthnicMinority" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="impairmentField">
        <td class="label">{fieldLabel name="impairment" required="true" key="proposal.impairment"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='impairment' options=$riskAssessmentYesNoArray selected=$impairment separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearImpairment" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="pregnantField">
        <td class="label">{fieldLabel name="pregnant" required="true" key="proposal.pregnant"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='pregnant' options=$riskAssessmentYesNoArray selected=$pregnant separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearPregnant" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top"><td colspan="2">&nbsp;</td></tr>

    <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludes"}</b></td></tr>
    <tr valign="top"><td colspan="2">&nbsp;</td></tr>
    <tr valign="top" id="newTreatmentField">
        <td class="label">{fieldLabel name="newTreatment" required="true" key="proposal.newTreatment"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='newTreatment' options=$riskAssessmentYesNoArray selected=$newTreatment separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearNewTreatment" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="bioSamplesField">
        <td class="label">{fieldLabel name="bioSamples" required="true" key="proposal.bioSamples"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='bioSamples' options=$riskAssessmentYesNoArray selected=$bioSamples separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearBioSamples" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="exportHumanTissueField">
        <td class="label">{fieldLabel name="exportHumanTissue" required="true" key="proposal.exportHumanTissue"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='exportHumanTissue' options=$riskAssessmentYesNoArray selected=$exportHumanTissue separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearExportHumanTissue" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>        
    <tr valign="top" id="exportReasonField">
        <td width="40%" class="label">{fieldLabel name="exportReason" required="true" key="proposal.exportReason"}</td>
        <td width="60%" class="value">
            <select name="exportReason" id="exportReasonSelect" class="selectMenu">
                <option value=""></option>
                {html_options options=$riskAssessmentExportReasonArray selected=$exportReason}
            </select>
        </td>
    </tr>                
    <tr valign="top" id="radiationField">
        <td class="label">{fieldLabel name="radiation" required="true" key="proposal.radiation"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='radiation' options=$riskAssessmentYesNoArray selected=$radiation separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearRadiation" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="distressField">
        <td class="label">{fieldLabel name="distress" required="true" key="proposal.distress"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='distress' options=$riskAssessmentYesNoArray selected=$distress separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearDistress" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="inducementsField">
        <td class="label">{fieldLabel name="inducements" required="true" key="proposal.inducements"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='inducements' options=$riskAssessmentYesNoArray selected=$inducements separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearInducements" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="sensitiveInfoField">
        <td class="label">{fieldLabel name="sensitiveInfo" required="true" key="proposal.sensitiveInfo"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='sensitiveInfo' options=$riskAssessmentYesNoArray selected=$sensitiveInfo separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearSensitiveInfo" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="reproTechnologyField">
        <td class="label">{fieldLabel name="reproTechnology" required="true" key="proposal.reproTechnology"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='reproTechnology' options=$riskAssessmentYesNoArray selected=$reproTechnology separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearReproTechnology" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="geneticField">
        <td class="label">{fieldLabel name="genetic" required="true" key="proposal.genetic"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='genetic' options=$riskAssessmentYesNoArray selected=$genetic separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearGenetic" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="stemCellField">
        <td class="label">{fieldLabel name="stemCell" required="true" key="proposal.stemCell"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='stemCell' options=$riskAssessmentYesNoArray selected=$stemCell separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearStemCell" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
    <tr valign="top" id="biosafetyField">
        <td class="label">{fieldLabel name="genetics" required="true" key="proposal.biosafety"}</td>
        <td class="value">
            {html_radios class='riskAssessmentRadio' name='biosafety' options=$riskAssessmentYesNoArray selected=$biosafety separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearBiosafety" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>                
        </td>
    </tr>
</table>
