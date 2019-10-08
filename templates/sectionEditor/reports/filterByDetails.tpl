{**
* filterByDetails.tpl
*
* Generate report - filter by details part 
**}

<p><b><a id="showOrHideDetailsTableClick" class="action" style="cursor: pointer;">{translate key="submission.proposalDetails"}</a></b></p>
<input type="hidden" id="detailsTableShow" name="detailsTableShow" />        

<table width="100%" class="data" id="detailsTable">    
    <tr valign="top">
        <td width="20%"></td>
        <td width="12%"></td>
        <td width="68%"></td>
    </tr>            
    <tr valign="top"><td colspan="3" class="label"><i>{translate key='editor.reports.hideWillErase'}</i></td></tr>
    <tr valign="top"><td colspan="3" class="label">&nbsp;</td></tr>            
    <tr valign="top">
        <td class="label">{translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value" colspan="2">
            {html_radios name='studentInitiatedResearch' options=$proposalDetailYesNoArray selected=$studentInitiatedResearch separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearStudentResearch" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>
        </td>
    </tr>

    <tr valign="top">
        <td class="label">{translate key="editor.reports.researchStartAfter"}</td>            
        <td class="value" colspan="2">
            <input type="text" class="textField" name="startAfter" id="startAfter" size="20" maxlength="255" /><i>&nbsp;({translate key="editor.reports.dateInclusive"})</i>
        </td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="editor.reports.researchStartBefore"}</td>            
        <td class="value" colspan="2">
            <input type="text" class="textField" name="startBefore" id="startBefore" size="20" maxlength="255" /><i>&nbsp;({translate key="editor.reports.dateInclusive"})</i>
        </td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="editor.reports.researchEndAfter"}</td>            
        <td class="value" colspan="2">
            <input type="text" class="textField" name="endAfter" id="endAfter" size="20" maxlength="255" /><i>&nbsp;({translate key="editor.reports.dateInclusive"})</i>
        </td>
    </tr>            
    <tr valign="top">
        <td class="label">{translate key="editor.reports.researchEndBefore"}</td>            
        <td class="value" colspan="2">
            <input type="text" class="textField" name="endBefore" id="endBefore" size="20" maxlength="255" /><i>&nbsp;({translate key="editor.reports.dateInclusive"})</i>
        </td>
    </tr>

    <tr valign="top" id="firstKII">
        <td class="KIITitle">{translate key="proposal.keyImplInstitution"}</td>
        <td width="80%" class="value" colspan="2">
            <select name="KII[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$institutionsList}
            </select>
            <a class="removeKII" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>           
    <tr id="addAnotherKII">
        <td class="label">&nbsp;</td>
        <td colspan="2"><a id="addAnotherKIIClick" style="cursor: pointer;">{translate key="editor.reports.addAnotherKII"}</a></td>
    </tr>

    <tr valign="top">
        <td class="label">{translate key="proposal.multiCountryResearch"}</td>            
        <td class="value" colspan="2">
            {html_radios name='multiCountryResearch' options=$proposalDetailYesNoArray selected=$multiCountryResearch separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearMultiCountryResearch" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>
        </td>
    </tr>
    <tr valign="top" id="firstCountry">
        <td class="label">&nbsp;</td>
        <td class="countryTitle">{translate key="common.country"}</td>
        <td class="value">
            <select name="countries[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$coutryList}
            </select>
            <a class="removeCountry" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>            
    <tr id="addAnotherCountry">
        <td class="label">&nbsp;</td>
        <td class="label">&nbsp;</td>                
        <td><a id="addAnotherCountryClick" style="cursor: pointer;">{translate key="proposal.addAnotherCountry"}</a></td>
    </tr>

    <tr valign="top" id="firstGeoArea">
        <td class="geoAreaTitle">{translate key="proposal.geoArea"}</td>
        <td class="value" colspan="2">
            <select name="geoAreas[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$geoAreasList}
            </select>
            <a class="removeGeoArea" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>            
    <tr id="addAnotherArea">
        <td class="label">&nbsp;</td>
        <td class="value" colspan="2">               
            <a id="addAnotherAreaClick" style="cursor: pointer;">{translate key="proposal.addAnotherArea"}</a>
        </td>
    </tr> 

    <tr valign="top" id="firstResearchDomain">
        <td class="researchDomainTitle">{translate key="proposal.researchDomains"}</td>
        <td class="value" colspan="2">
            <select name="researchDomains[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$researchDomainsList}
            </select>
            <a class="removeResearchDomain" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>            
    <tr id="addAnotherResearchDomain">
        <td class="label">&nbsp;</td>
        <td class="value" colspan="2">               
            <a id="addAnotherResearchDomainClick" style="cursor: pointer;">{translate key="proposal.addAnotherResearchDomain"}</a>
        </td>
    </tr>

    <tr valign="top" id="firstResearchField">
        <td class="researchFieldTitle">{translate key="proposal.researchField"}</td>
        <td class="value" colspan="2">
            <select name="researchFields[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$researchFieldsList}
            </select>
            <a class="removeResearchField" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>            
    <tr id="addAnotherResearchField">
        <td class="label">&nbsp;</td>
        <td class="value" colspan="2">               
            <a id="addAnotherResearchFieldClick" style="cursor: pointer;">{translate key="proposal.addAnotherFieldOfResearch"}</a>
        </td>
    </tr>

    <tr valign="top">
        <td class="label">{translate key="proposal.withHumanSubjects"}</td>            
        <td class="value" colspan="2">
            {html_radios name='withHumanSubjects' options=$proposalDetailYesNoArray selected=$withHumanSubjects separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
            <a id="clearWithHumanSubjects" style="cursor: pointer;">{translate key="editor.reports.clearField"}</a>
        </td>
    </tr>
    <tr valign="top" id="firstProposalType">
        <td class="label">&nbsp;</td>
        <td class="proposalTypeTitle">{translate key="proposal.proposalType"}</td>
        <td class="value">
            <select name="proposalTypes[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$proposalTypesList}
            </select>
            <a class="removeType" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>            
    <tr id="addAnotherType">
        <td class="label">&nbsp;</td>
        <td class="label">&nbsp;</td>                
        <td><a id="addAnotherTypeClick" style="cursor: pointer;">{translate key="proposal.addAnotherProposalType"}</a></td>
    </tr>            

    <tr valign="top">
        <td class="label">{translate key="proposal.dataCollection"}</td>            
        <td class="value" colspan="2">
            <select name="dataCollection" id="dataCollection" class="selectMenu">
                <option value=""></option>
                {html_options options=$dataCollectionArray selected=$dataCollection}
            </select>                
        </td>
    </tr>
    <tr valign="top"><td colspan="3" class="label">&nbsp;</td></tr>            
</table>