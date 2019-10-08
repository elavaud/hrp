{**
 * sourcesOfMonetary.tpl
 *
 * Source of monetary section of the Step 2 of author article submission.
 *
 *}

    
<div id="sources">

    <h3>{translate key="proposal.sourceOfMonetary"}</h3>

    <span><i><br/>{translate key="proposal.source.amount.instruct"}</i><br/>&nbsp;</span>
    <span><br/>{translate key="proposal.source.instruct2"}<br/>&nbsp;</span>
    
    
    {foreach name=sources from=$sources key=sourceIndex item=source}
        <table width="100%" style="border-top: dotted 1px #C0C0C0 !important; padding-bottom:10px; padding-top: 10px;" {if $sourceIndex == 0} id="firstSource"{else} class="sourceSuppClass" {/if}> 
            {if $source.sourceId}
                <tr><td colspan="5"><input type="hidden" name="sources[{$sourceIndex|escape}][sourceId]" value="{$source.sourceId|escape}" /></td></tr>
            {/if}
            <tr>
                <td title='{translate key="proposal.source.instruct"}' width="10%" class="label">[?] {fieldLabel required="true" key="proposal.source"}</td>
                <td width="45%" class="value">
                    <select name="sources[{$sourceIndex|escape}][institution]" class="selectMenu" id="sources-{$sourceIndex|escape}-institution">
                        <option value=""></option>
                        {html_options options=$sourcesList selected=$source.institution}
                    </select>
                </td>
                <td width="10%" class="label">&nbsp;&nbsp;{fieldLabel required="true" key="proposal.source.amount"}</td>
                <td width="20%" class="value">
                    <input type="text" class="sourceAmount" name="sources[{$sourceIndex|escape}][amount]" id="sources-{$sourceIndex|escape}-amount" value="{$source.amount|escape}" size="10" maxlength="40"/>
                </td>
                <td width="5%">
                    {$sourceCurrency->getCodeAlpha()|escape}
                </td>
                <td rowspan="2" width="10%" valign="middle">
                    <a class="removeSource" style="cursor: pointer;{if $sourceIndex == 0} display: none;{/if}">&nbsp;&nbsp;{translate key="common.remove"}</a>
                </td>
            </tr>
            <tr id="sources-{$sourceIndex|escape}-otherInstitution">
                <td width="10%">&nbsp;</td>
                <td colspan="5">
                    <table width="100%">
                        <tr valign="top">
                            <td colspan="2">{translate key="proposal.otherSource.instruct"}</td>
                        </tr>                        
                        <tr valign="top">
                            <td width="20%" class="label">{fieldLabel required="true" key="institution.name"}</td>
                            <td width="80%" class="value"><input type="text" name="sources[{$sourceIndex|escape}][otherInstitutionName]" value="{$source.otherInstitutionName|escape}" id="sources-{$sourceIndex|escape}-otherInstitutionName" size="40" maxlength="120" class="textField" /></td>
                        </tr>
                        <tr valign="top">
                            <td width="20%" class="label">{fieldLabel required="true" key="institution.acronym"}</td>
                            <td width="80%" class="value"><input type="text" name="sources[{$sourceIndex|escape}][otherInstitutionAcronym]" value="{$source.otherInstitutionAcronym|escape}" id="sources-{$sourceIndex|escape}-otherInstitutionAcronym" size="20" maxlength="60" class="textField" /></td>
                        </tr>
                        <tr valign="top">
                            <td width="20%" class="label">{fieldLabel required="true" key="institution.type"}</td>
                            <td width="80%" class="value">
                                <select name="sources[{$sourceIndex|escape}][otherInstitutionType]" id="sources-{$sourceIndex|escape}-otherInstitutionType" class="selectMenu">
                                    <option value=""></option>
                                    {html_options options=$institutionTypes selected=$source.otherInstitutionType}
                                </select>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td width="20%" class="label">{fieldLabel required="true" key="institution.location"}</td>
                            <td width="80%" class="value" id="sources-{$sourceIndex|escape}-locationInternationalCol">
                                {html_radios name="sources[`$sourceIndex`][international]" options=$internationalArray selected=$source.international separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
                            </td>
                        </tr>
                        <tr valign="top" id="sources-{$sourceIndex|escape}-locationCountryRow">
                            <td width="20%" class="label">&nbsp;</td>
                            <td width="80%" class="value">
                                <select name="sources[{$sourceIndex|escape}][locationCountry]" id="sources-{$sourceIndex|escape}-locationCountry" class="selectMenu">
                                    <option value=""></option>
                                    {html_options options=$geoAreasList selected=$source.locationCountry}
                                </select>
                            </td>
                        </tr>
                        <tr valign="top" id="sources-{$sourceIndex|escape}-locationInternationalRow">
                            <td width="20%" class="label">&nbsp;</td>
                            <td width="80%" class="value">
                                <select name="sources[{$sourceIndex|escape}][locationInternational]" id="sources-{$sourceIndex|escape}-locationInternational" class="selectMenu">
                                    <option value=""></option>
                                    {html_options options=$coutryList selected=$source.locationInternational}
                                </select>
                            </td>
                        </tr>                          
                    </table>
                </td>
            </tr>
        </table>
    {/foreach}
    <p><a id="addAnotherSource" style="cursor: pointer;" >{translate key="proposal.source.add"}</a></p>
    <table width="100%" class="data">
        <tr><td><br/></td></tr>
        <tr valign="top" id="totalBudget">
            <td width="20%" class="label"><b>{translate key="proposal.fundsRequired"}</b></td>
            <td width="80%" class="value"><span id="totalBudgetVar"></span>&nbsp;&nbsp;{$sourceCurrency->getName()|escape}&nbsp;({$sourceCurrency->getCodeAlpha()|escape})</td>
        </tr>
    </table>

</div>

<div class="separator"></div>       