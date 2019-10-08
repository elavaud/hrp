{**
 * institutions.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Display list of institutions in journal management.
 *
 * $Id$
 *}

 {strip}
    {assign var="pageTitle" value="institution.institutions"}
    {include file="common/header.tpl"}
{/strip}

<br/>

<div id="institution">
    <table width="100%" class="listing" id="dragTable">
	<tr>
            <td class="headseparator" colspan="5">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
            <td width="35%">{sort_heading key="institution.name" sort="name"}</td>
            <td width="15%">{sort_heading key="institution.acronym" sort="acronym"}</td>
            <td width="15%">{sort_heading key="institution.location" sort="location"}</td>
            <td width="20%">{sort_heading key="institution.type" sort="type"}</td>
            <td width="15%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
            <td class="headseparator" colspan="5">&nbsp;</td>
	</tr>
        {iterate from=institutions item=institution name=institutions}
            <tr valign="top" class="data">
                <td class="drag">{$institution->getInstitutionName()}</td>
                <td class="drag">{$institution->getInstitutionAcronym()}</td>
                <td class="drag">{$institution->getInstitutionLocationText()}</td>
                <td class="drag">{translate key=$institution->getInstitutionTypeKey()}</td>
                <td align="right" class="nowrap">
                    <a href="{url op='editInstitution' path=$institution->getInstitutionId()}" class="action">{translate key="common.edit"}</a>
                    &nbsp;|&nbsp;
                    <a href="{url op='deleteInstitutionForm' path=$institution->getInstitutionId()}" class="action">{translate key="common.delete"}</a>
                    &nbsp;
                </td>
            </tr>
        {/iterate}
	<tr>
            <td colspan="5" class="endseparator">&nbsp;</td>
	</tr>
        {if $institutions->wasEmpty()}
            <tr>
                <td colspan="5" class="nodata">{translate key="manager.institutions.noneCreated"}</td>
            </tr>
            <tr>
                <td colspan="5" class="endseparator">&nbsp;</td>
            </tr>
        {else}
            <tr>
                <td align="left">{page_info iterator=$institutions}</td>
                <td colspan="5" align="right">{page_links anchor="institutions" name="institutions" iterator=$institutions sort=$sort sortDirection=$sortDirection}</td>
            </tr>
        {/if}
    </table>
    <a class="action" href="{url op="createInstitution"}">{translate key="manager.institutions.create"}</a>
</div>

{include file="common/footer.tpl"}