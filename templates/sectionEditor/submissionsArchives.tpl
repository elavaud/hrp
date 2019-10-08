{**
 * submissionsArchives.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show section editor's submission archive.
 *
 * $Id$
 *}
<br/><br/>
<div id="submissions">

<table class="listing" width="100%">
	<tr><td class="headseparator" colspan="5">&nbsp;</td></tr>
	<tr valign="bottom" class="heading">
		<td width="15%">{translate key="common.proposalId"}</td>
		<td width="15%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.title" sort="title"}</td>
		<td width="15%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
<p></p>
{iterate from=submissions item=submission}
	{assign var="status" value=$submission->getStatus()}

    {assign var="lastDecision" value=$submission->getLastSectionDecision()}
    {assign var="decisionValue" value=$lastDecision->getDecision()}

	{assign var="abstract" value=$submission->getLocalizedAbstract()}
    {assign var="articleId" value=$submission->getArticleId()}
    {assign var="proposalId" value=$submission->getProposalId()}
	<tr valign="top">
		<td>{$proposalId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
	   	<td>{$submission->getFirstAuthor()|truncate:20:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
        <td><a href="{url op="submissionReview" path=$articleId}" class="action">{$abstract->getScientificTitle()|truncate:60:"..."|escape}</a></td>
		<td align="right">
        	{if $status==STATUS_WITHDRAWN}
            	{translate key="submission.status.withdrawn"}
            {elseif $status==STATUS_ARCHIVED || $status==STATUS_REVIEWED || $status==STATUS_COMPLETED}
            	{translate key=$lastDecision->getReviewStatusKey()}
            {else}
            	BUG!
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="5" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="5" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="5" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="3" align="left">{page_info iterator=$submissions}</td>
		<td align="right" colspan="2">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
		
</table>
</div>

