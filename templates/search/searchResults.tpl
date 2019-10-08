{**
 * searchResults.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Display article search results.
 *
 * $Id$
 *}
{strip}
{assign var=pageTitle value="search.research"}
{include file="common/header.tpl"}
{/strip}

{include file="search/search.tpl"}

<script type="text/javascript">
{literal}
function showExportOptions(){
	$('#exportOptions').show();
	$('#showExportOptions').hide();
	$('#hideExportOptions').show();
}

function hideExportOptions(){
	$('#exportOptions').hide();
	$('#hideExportOptions').hide();
	$('#showExportOptions').show();
}

$(document).ready(
	function (){
		$('#exportOptions').hide();
		$('#hideExportOptions').hide();
	}
);
// -->
{/literal}
</script>

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

<br/>

<form name="generate" action="{url op="generateCustomizedCSV"}" method="post"  id="exportOptions">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<input type="hidden" name="region" value="{$region|escape}"/>
	<input type="hidden" name="statusFilter" value="{$statusFilter|escape}"/>
	<input type="hidden" name="dateFrom" value="{$dateFrom|escape}"/>
	<input type="hidden" name="dateTo" value="{$dateTo|escape}"/>
	
	<table class="data" width="100%">
		<tr><i><br />{translate key="search.exportIntruct"}<br /></i></tr>
		<tr>
			<td colspan="4" class="headseparator"></td>
		</tr>
		<tr>
			<td><br /><strong>{translate key="user.role.authors"}:</strong></td>
		</tr>
		<tr valign="top">
			<td width="20%" class="value">
				<input type="checkbox" name="investigatorName" checked="checked"/>&nbsp;{translate key="common.fullName"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="investigatorAffiliation"/>&nbsp;{translate key="user.affiliation"}
			</td>
		</tr>
		<tr>
			<td colspan="4" class="separator"></td>
		</tr>
		<tr>
			<td><strong>{translate key="article.metadata"}:</strong></td>
		</tr>
		<tr valign="top">
			<td width="20%" class="value">
				<input type="checkbox" name="scientificTitle" checked="checked"/>&nbsp;{translate key="proposal.scientificTitle"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="publicTitle"/>&nbsp;{translate key="proposal.publicTitle"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="researchField" checked="checked"/>&nbsp;{translate key="proposal.researchField"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="researchDomain" checked="checked"/>&nbsp;{translate key="proposal.researchDomains"}
			</td>                        
		</tr>
		<tr valign="top">
			<td width="20%" class="value">
				<input type="checkbox" name="proposalType" checked="checked"/>&nbsp;{translate key="proposal.proposalType"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="duration" checked="checked"/>&nbsp;{translate key="search.researchDates"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="area" checked="checked"/>&nbsp;{translate key='proposal.geoArea'}
			</td>
		</tr>
		<tr valign="top">
			<td width="20%" class="value">
				<input type="checkbox" name="kii" checked="checked"/>&nbsp;{translate key="proposal.keyImplInstitution"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="dataCollection"/>&nbsp;{translate key="proposal.dataCollection"}
			</td>
			<td width="20%" class="value">
				<input type="checkbox" name="status" checked="checked"/>&nbsp;{translate key="common.status"}
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<input type="checkbox" name="studentResearch" checked="checked"/>&nbsp;{translate key="search.studentExport"}
			</td>
			<td></td>
		</tr>
		<tr>
			<td colspan="4" class="endseparator">&nbsp;</td>
		</tr>
	</table>
	<p><input type="submit" value="{translate key="common.export"}" class="button defaultButton"/>
</form>

<br/>
<h4>{if $statusFilter == 1}{translate key="common.complete"}:<br/>{elseif $statusFilter == 2}{translate key="common.ongoing"}:<br/>{/if}{if $query}{translate key="help.searchResultsFor"} '{$query}' {else}{translate key="common.search"} {/if}{if $dateFrom != '--'}{translate key="search.dateFrom"} {$dateFrom|date_format:$dateFormatLong} {/if}{if $dateFrom != '--' && $dateTo != '--'}{translate key="search.operator.and"} {/if}{if $dateTo != '--'}{translate key="search.dateTo"} {$dateTo|date_format:$dateFormatLong} {/if}{if $country}{translate key="search.takingPlaceIn"} {$country} {/if}: {$count} {translate key="search.results"}. </h4>
<div id="results">
	<table width="100%" class="listing">
		<tr class="heading" valign="bottom">
			<td>{sort_heading key='article.title' sort="title"}</td>
			<td>{sort_heading key='proposal.keyImplInstitution' sort="kii"}</td>
			<td>{sort_heading key='search.region' sort="region"}</td>
			<td>{sort_heading key='search.researchField' sort="researchField"}</td>
			<td>{sort_heading key='search.researchDates' sort="researchDates"}</td>
			<td>{sort_heading key="common.status" sort="status"}</td>
		</tr>
		<tr>
			<td colspan="6" class="headseparator">&nbsp;</td>
		</tr>
		<p></p>
		{iterate from=results item=result}
			<tr valign="bottom">
				{assign var="abstract" value=$result->getLocalizedAbstract()}
				{assign var="proposalDetails" value=$result->getProposalDetails()}
				<td><a href="{url op="viewProposal" path=$result->getId()}" class="action">{$abstract->getScientificTitle()|escape}</a></td>
				<td>{$proposalDetails->getKeyImplInstitutionName()}</td>
				<td>
					{if $proposalDetails->getMultiCountryResearch() == PROPOSAL_DETAIL_YES}
						{$proposalDetails->getLocalizedMultiCountryText()}
					{elseif $proposalDetails->getNationwide() == PROPOSAL_DETAIL_YES}
						{translate key="proposal.nationwide"}
					{else}
						{$proposalDetails->getLocalizedGeoAreasText()}
					{/if}
				</td>
				<td>{$proposalDetails->getLocalizedResearchFieldText()}</td>
				<td>{$proposalDetails->getStartDate()} {translate key="search.dateTo"} {$proposalDetails->getEndDate()}</td>
				<td>
                                    {if $result->getStatus() == STATUS_COMPLETED}
                                        {translate key="common.queue.short.completedResearches"}
                                	{assign var="finalReport" value=$result->getPublishedFinalReport()}
                                	<br/><a href="{url op="downloadFinalReport" path=$result->getArticleId()|to_array:$finalReport->getFileId()}" class="file">{translate key="search.downloadFinalReport"}</a>
                                    {else}
                                        {translate key="common.queue.short.ongoingResearches"}
                                    {/if}
                                </td>
			</tr>
			<tr>
				<td colspan="6" class="{if $results->eof()}end{/if}separator">&nbsp;</td>
			</tr>
		{/iterate}
		{if $results->wasEmpty()}
			<tr>
				<td colspan="6" class="nodata">{translate key="search.noResults"}</td>
			</tr>
			<tr>
				<td colspan="6" class="endseparator">&nbsp;</td>
			</tr>
		{else}
			<tr>
				<td colspan="4" align="left">{page_info iterator=$results}</td>
				<td align="right" colspan="2">{page_links anchor="results" iterator=$results name="search" query=$query dateFrom=$dateFrom dateTo=$dateTo proposalCountry=$country status=$statusFilter sort=$sort sortDirection=$sortDirection}</td>
			</tr>
		{/if}
	</table>
</div>	

{include file="common/footer.tpl"}

