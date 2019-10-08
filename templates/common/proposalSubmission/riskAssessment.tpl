{**
 * riskAssessment.tpl
 *
 * Risk Assessment section of the Step 2 of author article submission.
 *
 *}

       
<div id="riskAssessment">
    
    <h3>{translate key="proposal.riskAssessment"}</h3>
    
    <table width="100%" class="data">
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
        <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
        <tr valign="top" id="identityRevealedField">
            <td width="40%" class="label">{fieldLabel name="identityRevealed" required="true" key="proposal.identityRevealed"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[identityRevealed]' options=$riskAssessmentYesNoArray selected=$riskAssessment.identityRevealed separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="unableToConsentField">
            <td width="40%" class="label">{fieldLabel name="unableToConsent" required="true" key="proposal.unableToConsent"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[unableToConsent]' options=$riskAssessmentYesNoArray selected=$riskAssessment.unableToConsent separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="under18Field">
            <td width="40%" class="label">{fieldLabel name="under18" required="true" key="proposal.under18"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[under18]' options=$riskAssessmentYesNoArray selected=$riskAssessment.under18 separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="dependentRelationshipField">
            <td width="40%" class="label">{fieldLabel name="dependentRelationship" required="true" key="proposal.dependentRelationship"}<br/><i>{translate key="proposal.dependentRelationshipInstruct"}</i></td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[dependentRelationship]' options=$riskAssessmentYesNoArray selected=$riskAssessment.dependentRelationship separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="ethnicMinorityField">
            <td width="40%" class="label">{fieldLabel name="ethnicMinority" required="true" key="proposal.ethnicMinority"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[ethnicMinority]' options=$riskAssessmentYesNoArray selected=$riskAssessment.ethnicMinority separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
           </td>
        </tr>
        <tr valign="top" id="impairmentField">
            <td width="40%" class="label">{fieldLabel name="impairment" required="true" key="proposal.impairment"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[impairment]' options=$riskAssessmentYesNoArray selected=$riskAssessment.impairment separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="pregnantField">
            <td width="40%" class="label">{fieldLabel name="pregnant" required="true" key="proposal.pregnant"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[pregnant]' options=$riskAssessmentYesNoArray selected=$riskAssessment.pregnant separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
    </table>
            
    <table width="100%" class="data">
        <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludes"}</b></td></tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
        <tr valign="top" id="newTreatmentField">
            <td width="40%" class="label">{fieldLabel name="newTreatment" required="true" key="proposal.newTreatment"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[newTreatment]' options=$riskAssessmentYesNoArray selected=$riskAssessment.newTreatment separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="bioSamplesField">
            <td width="40%" class="label">{fieldLabel name="bioSamples" required="true" key="proposal.bioSamples"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[bioSamples]' options=$riskAssessmentYesNoArray selected=$riskAssessment.bioSamples separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="exportHumanTissueField">
            <td width="40%" class="label">{fieldLabel name="exportHumanTissue" required="true" key="proposal.exportHumanTissue"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[exportHumanTissue]' options=$riskAssessmentYesNoArray selected=$riskAssessment.exportHumanTissue separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>                
        <tr valign="top" id="exportReasonField">
            <td width="40%" class="label">{fieldLabel name="exportReason" required="true" key="proposal.exportReason"}</td>
            <td width="60%" class="value">
                <select name="riskAssessment[exportReason]" id="exportReasonSelect" class="selectMenu">
                    <option value=""></option>
                    {html_options options=$riskAssessmentExportReasonArray selected=$riskAssessment.exportReason}
                </select>
            </td>
        </tr>                
        <tr valign="top" id="radiationField">
            <td width="40%" class="label">{fieldLabel name="radiation" required="true" key="proposal.radiation"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[radiation]' options=$riskAssessmentYesNoArray selected=$riskAssessment.radiation separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="distressField">
            <td width="40%" class="label">{fieldLabel name="distress" required="true" key="proposal.distress"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[distress]' options=$riskAssessmentYesNoArray selected=$riskAssessment.distress separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="inducementsField">
            <td width="40%" class="label">{fieldLabel name="inducements" required="true" key="proposal.inducements"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[inducements]' options=$riskAssessmentYesNoArray selected=$riskAssessment.inducements separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="sensitiveInfoField">
            <td width="40%" class="label">{fieldLabel name="sensitiveInfo" required="true" key="proposal.sensitiveInfo"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[sensitiveInfo]' options=$riskAssessmentYesNoArray selected=$riskAssessment.sensitiveInfo separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="reproTechnologyField">
            <td width="40%" class="label">{fieldLabel name="reproTechnology" required="true" key="proposal.reproTechnology"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[reproTechnology]' options=$riskAssessmentYesNoArray selected=$riskAssessment.reproTechnology separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="geneticField">
            <td width="40%" class="label">{fieldLabel name="genetic" required="true" key="proposal.genetic"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[genetic]' options=$riskAssessmentYesNoArray selected=$riskAssessment.genetic separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="stemCellField">
            <td width="40%" class="label">{fieldLabel name="stemCell" required="true" key="proposal.stemCell"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[stemCell]' options=$riskAssessmentYesNoArray selected=$riskAssessment.stemCell separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="biosafetyField">
            <td width="40%" class="label">{fieldLabel name="genetics" required="true" key="proposal.biosafety"}</td>
            <td width="60%" class="value">
                {html_radios name='riskAssessment[biosafety]' options=$riskAssessmentYesNoArray selected=$riskAssessment.biosafety separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
    </table>

    <table width="100%" class="data">
        <tr valign="top"><td colspan="2"><b>{translate key="proposal.potentialRisk"}</b></td></tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
        <tr valign="top" id="riskLevelField">
            <td title="{translate key="proposal.riskLevelInstruct"}" width="30%" class="label">[?] {fieldLabel name="riskLevel" required="true" key="proposal.riskLevel"}</td>
            <td width="70%" class="value">
                <select name="riskAssessment[riskLevel]" class="selectMenu" id="riskLevel">
                    <option value=""></option>
                    {html_options options=$riskAssessmentLevelsOfRisk selected=$riskAssessment.riskLevel}
                </select>
            </td>
        </tr>
        <tr valign="top" id="listRisksField">
            <td width="30%" class="label">{fieldLabel name="listRisks" required="true" key="proposal.listRisks"}</td>
            <td width="70%" class="value">
                <textarea name="riskAssessment[listRisks]" class="textArea" id="listRisks" rows="5" cols="40">{$riskAssessment.listRisks|escape}</textarea><br/>
            </td>
        </tr>
        <tr valign="top" id="howRisksMinimizedField">
            <td width="30%" class="label">{fieldLabel name="howRisksMinimized" required="true" key="proposal.howRisksMinimized"}</td>
            <td width="70%" class="value">
                <textarea name="riskAssessment[howRisksMinimized]" class="textArea" id="howRisksMinimized" rows="5" cols="40">{$riskAssessment.howRisksMinimized|escape}</textarea><br/>
            </td>
        </tr>
        <tr valign="top" id="riskApplyToField">
            <td width="30%" class="label">{fieldLabel name="riskApplyTo" key="proposal.riskApplyTo"}</td>
            <td width="70%" class="value">
                <input type="checkbox" name="riskAssessment[risksToTeam]" value="1" {if $riskAssessment.risksToTeam == '1'} checked="checked" {/if}/>{translate key="proposal.researchTeam"}<br/>
                <input type="checkbox" name="riskAssessment[risksToSubjects]" value="1" {if $riskAssessment.risksToSubjects == '1'} checked="checked" {/if}/>{translate key="proposal.researchSubjects"}<br/>
                <input type="checkbox" name="riskAssessment[risksToCommunity]" value="1" {if $riskAssessment.risksToCommunity == '1'} checked="checked" {/if}/>{translate key="proposal.widerCommunity"}
            </td>
        </tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
    </table>

    <table width="100%" class="data">
        <tr valign="top"><td colspan="2"><b>{translate key="proposal.potentialBenefits"}</b></td></tr>
        <tr valign="top"><td colspan="2">&nbsp;</td></tr>
        <tr valign="top" id="benefitsFromTheProjectField">
            <td width="30%" class="label">{fieldLabel name="benefitsFromTheProject" key="proposal.benefitsFromTheProject"}</td>
            <td width="70%" class="value">
                <input type="checkbox" name="riskAssessment[benefitsToParticipants]" value="1" {if $riskAssessment.benefitsToParticipants == '1'} checked="checked" {/if}/>{translate key="proposal.directBenefits"}<br/>
                <input type="checkbox" name="riskAssessment[knowledgeOnCondition]" value="1" {if $riskAssessment.knowledgeOnCondition == '1'} checked="checked" {/if}/>{translate key="proposal.participantCondition"}<br/>
                <input type="checkbox" name="riskAssessment[knowledgeOnDisease]" value="1" {if $riskAssessment.knowledgeOnDisease == '1'} checked="checked" {/if}/>{translate key="proposal.diseaseOrCondition"}
            </td>
        </tr>
        <tr valign="top" id="multiInstitutionsField">
            <td width="30%" class="label">{fieldLabel name="multiInstitutions" required="true" key="proposal.multiInstitutions"}</td>
            <td width="70%" class="value">
                {html_radios name='riskAssessment[multiInstitutions]' options=$riskAssessmentYesNoArray selected=$riskAssessment.multiInstitutions separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        <tr valign="top" id="conflictOfInterestField">
            <td title="{translate key="proposal.conflictOfInterestInstruct"}" width="30%" class="label">{fieldLabel name="riskAssessment-conflictOfInterest" required="true" key="proposal.conflictOfInterest"}</td>
            <td width="70%" class="value">
                {html_radios name="riskAssessment[conflictOfInterest]" options=$riskAssessmentConflictOfInterestArray selected=$riskAssessment.conflictOfInterest separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
    </table>
</div>
            
<div class="separator"></div>