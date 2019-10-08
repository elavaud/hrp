{**
 * proposalDetails.tpl
 *
 * Proposal details section of the Step 2 of author article submission.
 *
 *}


<div id="proposalDetails">
    <h3>{translate key="submission.proposalDetails"}</h3>

    <table width="100%" class="data">

        <tr valign="top" id="studentInitiatedResearchField">
            <td title="{translate key="proposal.studentInitiatedResearchInstruct"}" width="20%" class="label">[?] {fieldLabel name="proposalDetails-studentInitiatedResearch" required="true" key="proposal.studentInitiatedResearch"}</td>
            <td width="80%" class="value">
                {html_radios name='proposalDetails[studentInitiatedResearch]' options=$proposalDetailYesNoArray selected=$proposalDetails.studentInitiatedResearch separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
                <table width="100%" class="data"  id="studentInfo">
                    <tr valign="top">
                        <td title="{translate key="proposal.studentInstitutionInstruct"}" width="20%" class="label">[?] {fieldLabel name="studentResearch-studentInstitution" required="false" key="proposal.studentInstitution"}</td>
                        <td width="80%" class="value">
                            <input type="text" class="textField" name="studentResearch[studentInstitution]" id="studentInstitution" value="{$studentResearch.studentInstitution|escape}" size="40" maxlength="255" />
                        </td>
                    </tr>
                    <tr valign="top">
                        <td title="{translate key="proposal.academicDegreeInstruct"}" width="20%" class="label">[?] {fieldLabel name="studentResearch-academicDegree" required="false" key="proposal.academicDegree"}</td>
                        <td width="80%" class="value">
                            <select name="studentResearch[academicDegree]" id="academicDegree" class="selectMenu">
                                <option value=""></option>
                                {html_options options=$academicDegreesArray selected=$studentResearch.academicDegree}
                            </select>
                        </td>
                    </tr>
                    <tr valign="top" id="supervisor"><td colspan="2"><b>{translate key="proposal.studentSupervisor"}</b></td></tr>
                    <tr valign="top" id="supervisorNameField">
                        <td title="{translate key="proposal.studentSupervisorNameInstruct"}" width="20%" class="label">[?] {fieldLabel name="studentResearch-supervisorName" required="false" key="proposal.studentSupervisorName"}</td>
                        <td width="80%" class="value">
                            <input type="text" class="textField" name="studentResearch[supervisorName]" id="supervisorName" value="{$studentResearch.supervisorName|escape}" size="50" maxlength="255" />
                        </td>
                    </tr>
                    <tr valign="top" id="supervisorEmailField">
                        <td title="{translate key="proposal.studentSupervisorEmailInstruct"}" width="20%" class="label">[?] {fieldLabel name="studentResearch-supervisorEmail" required="false" key="user.email"}</td>
                        <td width="80%" class="value">
                            <input type="text" class="textField" name="studentResearch[supervisorEmail]" id="supervisorEmail" value="{$studentResearch.supervisorEmail|escape}" size="50" maxlength="255" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr valign="top" id="startDateField">
            <td title="{translate key="proposal.startDateInstruct"}" width="20%" class="label">[?] {fieldLabel name="proposalDetails-startDate" required="true" key="proposal.startDate"}</td>
            <td width="80%" class="value"><input type="text" class="textField" name="proposalDetails[startDate]" id="startDate" value="{$proposalDetails.startDate|escape}" size="20" maxlength="255" /></td>
        </tr>

        <tr valign="top" id="endDateField">
            <td title="{translate key="proposal.endDateInstruct"}" width="20%" class="label">[?] {fieldLabel name="proposalDetails-endDate" required="true" key="proposal.endDate"}</td>
            <td width="80%" class="value"><input type="text" class="textField" name="proposalDetails[endDate]" id="endDate" value="{$proposalDetails.endDate|escape}" size="20" maxlength="255" /></td>
        </tr>

        <tr valign="top" id="keyImplInstitutionField">
            <td title="{translate key="proposal.keyImplInstitution.instruct"}" width="20%" class="label">[?] {fieldLabel name="proposalDetails-keyImplInstitution" required="true" key="proposal.keyImplInstitution"}</td>
            <td width="80%" class="value">
                <select name="proposalDetails[keyImplInstitution]" id="keyImplInstitution" class="selectMenu">
                    <option value=""></option>
                    {html_options options=$institutionsList selected=$proposalDetails.keyImplInstitution}
                </select>
            </td>
        </tr>

        <tr valign="top" id="otherInstitution"  style="display:none">
            <td width="20%" class="label">&nbsp;</td>
            <td width="80%" class="value">
                <table width="80%" class="data">
                    <tr valign="top">
                        <td colspan="2">{translate key="proposal.otherKeyImplInstitution.instruct"}</td>
                    </tr>                        
                    <tr valign="top">
                        <td width="20%" class="label">{fieldLabel required="true" key="institution.name"}</td>
                        <td width="80%" class="value"><input type="text" name="proposalDetails[otherInstitutionName]" value="{$proposalDetails.otherInstitutionName}" id="otherInstitutionName" size="40" maxlength="120" class="textField" /></td>
                    </tr>
                    <tr valign="top">
                        <td width="20%" class="label">{fieldLabel required="true" key="institution.acronym"}</td>
                        <td width="80%" class="value"><input type="text" name="proposalDetails[otherInstitutionAcronym]" value="{$proposalDetails.otherInstitutionAcronym}" id="otherInstitutionAcronym" size="20" maxlength="60" class="textField" /></td>
                    </tr>
                    <tr valign="top">
                        <td width="20%" class="label">{fieldLabel required="true" key="institution.type"}</td>
                        <td width="80%" class="value">
                            <select name="proposalDetails[otherInstitutionType]" id="otherInstitutionType" class="selectMenu">
                                <option value=""></option>
                                {html_options options=$institutionTypes selected=$proposalDetails.otherInstitutionType}
                            </select>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td width="20%" class="label">{fieldLabel name="international" required="true" key="institution.location"}</td>
                        <td width="80%" class="value">
                            {html_radios name='proposalDetails[international]' options=$internationalArray selected=$proposalDetails.international separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
                        </td>
                    </tr>
                    <tr valign="top" id="locationCountryRow">
                        <td width="20%" class="label">&nbsp;</td>
                        <td width="80%" class="value">
                            <select name="proposalDetails[locationCountry]" id="locationCountry" class="selectMenu">
                                <option value=""></option>
                                {html_options options=$geoAreasList selected=$proposalDetails.locationCountry}
                            </select>
                        </td>
                    </tr>
                    <tr valign="top" id="locationInternationalRow">
                        <td width="20%" class="label">&nbsp;</td>
                        <td width="80%" class="value">
                            <select name="proposalDetails[locationInternational]" id="locationInternational" class="selectMenu">
                                <option value=""></option>
                                {html_options options=$coutryList selected=$proposalDetails.locationInternational}
                            </select>
                        </td>
                    </tr>                      
                </table>
            </td>
        </tr>

        <tr valign="top" id="multiCountryResearchField">
            <td title="{translate key="proposal.multiCountryResearchInstruct"}" width="20%" class="label">[?] {fieldLabel name="proposalDetails-multiCountryResearch" required="true" key="proposal.multiCountryResearch"}</td>
            <td width="80%" class="value">
                {html_radios name='proposalDetails[multiCountryResearch]' options=$proposalDetailYesNoArray selected=$proposalDetails.multiCountryResearch separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        {foreach from=$proposalDetails.countries key=i item=country}
            <tr valign="top" {if $i == 0}id="firstMultiCountry"{else}class="multiCountrySupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span style="font-style: italic;">{fieldLabel name="proposalDetails-multiCountry" required="true" key="proposal.multiCountry"}</span>&nbsp;&nbsp;
                    <select name="proposalDetails[countries][]" id="multiCountry" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$coutryList selected=$proposalDetails.countries[$i]}
                    </select>
                    <a class="removeMultiCountry" style="{if $i == 0}display: none; {/if}cursor: pointer;">&nbsp;&nbsp;{translate key="common.remove"}</a>
                </td>
            </tr>
        {/foreach}
        <tr id="addAnotherCountry">
            <td width="20%">&nbsp;</td>
            <td><a id="addAnotherCountryClick" style="cursor: pointer;">{translate key="proposal.addAnotherCountry"}</a></td>
        </tr> 

        <tr valign="top" id="nationwideField">
            <td width="20%" class="label">{fieldLabel name="proposalDetails-nationwide" required="true" key="proposal.nationwide"}</td>
            <td width="80%" class="value">
                {html_radios name='proposalDetails[nationwide]' options=$nationwideRadioButtons selected=$proposalDetails.nationwide separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        {foreach from=$proposalDetails.geoAreas key=i item=country}
            <tr valign="top" {if $i == 0}id="firstGeoArea"{else}class="geoAreaSupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span style="font-style: italic;">{fieldLabel name="proposalDetails-geoArea" required="true" key="proposal.geoArea"}</span>&nbsp;&nbsp;
                    <select name="proposalDetails[geoAreas][]" id="geoArea" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$geoAreasList selected=$proposalDetails.geoAreas[$i]}
                    </select>
                    <a class="removeProposalProvince" style="{if $i == 0}display: none; {/if}cursor: pointer;">{translate key="common.remove"}</a>
                </td>
            </tr>
        {/foreach}
        <tr id="addAnotherArea">
            <td width="20%">&nbsp;</td>
            <td><a id="addAnotherAreaClick" style="cursor: pointer;">{translate key="proposal.addAnotherArea"}</a></td>
        </tr>        

        {foreach from=$proposalDetails.researchDomains key=i item=rDomain}
            <tr valign="top"  {if $i == 0}id="firstResearchDomain"{else}class="researchDomainSupp"{/if}>
                <td width="20%" class="researchDomainTitle">{if $i == 0}{fieldLabel name="proposalDetails-researchDomain" required="true" key="proposal.researchDomains"}{else}&nbsp;{/if}</td>
                <td class="noResearchDomainTitle" style="display: none;">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="proposalDetails[researchDomains][]" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$researchDomainsList selected=$proposalDetails.researchDomains[$i]}
                    </select>
                    <a class="removeResearchDomain" style="{if $i == 0}display: none; {/if}cursor: pointer;">{translate key="common.remove"}</a>
                </td>
            </tr>           
        {/foreach}
        <tr id="addAnotherDomain">
            <td width="20%">&nbsp;</td>
            <td><a id="addAnotherDomainClick" style="cursor: pointer;">{translate key="proposal.addAnotherResearchDomain"}</a></td>
        </tr>

        
        {foreach from=$proposalDetails.researchFields key=i item=field}
            <tr valign="top"  {if $i == 0}id="firstResearchField"{else}class="researchFieldSupp"{/if}>
                <td width="20%" class="researchFieldTitle">{if $i == 0}{fieldLabel name="proposalDetails-researchField" required="true" key="proposal.researchField"}{else}&nbsp;{/if}</td>
                <td class="noResearchFieldTitle" style="display: none;">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="proposalDetails[researchFields][]" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$researchFieldsList selected=$proposalDetails.researchFields[$i]}
                    </select>
                    <a class="removeResearchField" style="{if $i == 0}display: none; {/if}cursor: pointer;">{translate key="common.remove"}</a>
                </td>
            </tr>           
        {/foreach}
        <tr id="addAnotherField">
            <td width="20%">&nbsp;</td>
            <td><a id="addAnotherFieldClick" style="cursor: pointer;">{translate key="proposal.addAnotherFieldOfResearch"}</a></td>
        </tr>
        <tr valign="top" id="otherResearchFieldField" {if $isOtherResearchFieldSelected == false}style="display: none;"{/if}>
            <td width="20%" class="label">&nbsp;</td>
            <td width="80%" class="value">
                <span style="font-style: italic;">{fieldLabel name="proposalDetails-otherResearchField" key="proposal.otherResearchField"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="proposalDetails[otherResearchField]" id="otherResearchField" value="{$proposalDetails.otherResearchField|escape}" size="30" maxlength="255" />
            </td>
        </tr>

        <tr valign="top" id="HumanSubjectField">
            <td width="20%" class="label">{fieldLabel name="proposalDetails-withHumanSubjects" required="true" key="proposal.withHumanSubjects"}</td>
            <td width="80%" class="value">
                {html_radios name='proposalDetails[withHumanSubjects]' options=$proposalDetailYesNoArray selected=$proposalDetails.withHumanSubjects separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>
        {foreach from=$proposalDetails.proposalTypes key=i item=type}
            <tr valign="top" {if $i == 0}id="firstProposalType"{else}class="proposalTypeSupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span style="font-style: italic;">{fieldLabel name="proposalDetails-proposalType" required="false" key="proposal.proposalType"}</span>&nbsp;&nbsp;
                    <select name="proposalDetails[proposalTypes][]" id="proposalType" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$proposalTypesList selected=$proposalDetails.proposalTypes[$i]}
                    </select>
                    <a class="removeProposalType" style="{if $i == 0}display: none; {/if}cursor: pointer;">{translate key="common.remove"}</a>
                </td>
            </tr>
        {/foreach}
        <tr id="addAnotherType">
            <td width="20%">&nbsp;</td>
            <td width="40%"><a id="addAnotherTypeClick" style="cursor: pointer;">{translate key="proposal.addAnotherProposalType"}</a></td>
        </tr>    
        <tr valign="top" id="otherProposalTypeField">
            <td width="20%" class="label">&nbsp;</td>
            <td width="80%" class="value">
                <span style="font-style: italic;">{fieldLabel name="proposalDetails-otherProposalType" key="proposal.otherProposalType" required="true"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="proposalDetails[otherProposalType]" id="otherProposalType" value="{$proposalDetails.otherProposalType|escape}" size="30" maxlength="255" />
            </td>
        </tr>

        <tr valign="top" id="dataCollectionField">
            <td width="20%" class="label" title='{translate key="proposal.dataCollection.instruct"}'>[?] {fieldLabel name="proposalDetails-dataCollection" required="true" key="proposal.dataCollection"}</td>
            <td width="80%" class="value">
                <select name="proposalDetails[dataCollection]" class="selectMenu">
                    <option value=""></option>
                    {html_options options=$dataCollectionArray selected=$proposalDetails.dataCollection}
                </select>
            </td>
        </tr>

        <tr valign="top" id="otherErcField">
            <td width="20%" class="label">{fieldLabel name="proposalDetails-reviewedByOtherErc" required="true" key="proposal.reviewedByOtherErc"}</td>
            <td width="80%" class="value">
                {html_radios name='proposalDetails[reviewedByOtherErc]' options=$proposalDetailYesNoArray selected=$proposalDetails.reviewedByOtherErc separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            </td>
        </tr>

        <tr valign="top" id="otherErcDecisionField">
            <td width="20%" class="label">&nbsp;</td>
            <td width="80%" class="value">
                <span style="font-style: italic;">{fieldLabel name="proposalDetails-otherErcDecision" required="false" key="proposal.otherErcDecision"}</span>&nbsp;&nbsp;
                <select name="proposalDetails[otherErcDecision]" id="otherErcDecision" class="selectMenu">
                    <option value=""></option>
                    {html_options options=$otherErcDecisionArray selected=$proposalDetails.otherErcDecision}
                </select>
            </td>
        </tr>
    </table>
</div>
                
<div class="separator"></div>