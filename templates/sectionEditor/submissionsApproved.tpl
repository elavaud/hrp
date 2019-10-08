{**
 * submissionsApproved.tpl
 *
 * Show section secretary's submissions approved.
 *
 * $Id$
 *}
<br/><br/>
<div id="submissions">

<table class="listing" width="100%">
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="common.proposalId"}</td>
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="40%">{sort_heading key="article.title" sort="title"}</td>
		<td width="20%" align="right">{sort_heading key="submissions.dateApproved" sort="dateApproved"}</td>
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
<p></p>
{iterate from=submissions item=submission}	
    {assign var="lastDecision" value=$submission->getLastSectionDecision()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
	{assign var="articleId" value=$submission->getArticleId()}
    {assign var="proposalId" value=$submission->getProposalId()}
	<tr valign="top">
		<td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
   		<td>{$submission->getFirstAuthor()|truncate:20:"..."|escape}</td>
        <td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$abstract->getScientificTitle()|truncate:60:"..."|escape}</a></td>
		<td align="right">{$lastDecision->getDateDecided()|date_format:$dateFormatLong}</td>		
	</tr>
	<tr>
		<td colspan="4" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="4" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="2" align="left">{page_info iterator=$submissions}</td>
		<td align="right" colspan="2">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>