{**
 * toSubmit.tpl
 *
 * Show the details of proposals to submit.
 *
 * $Id$
 *}

<div id="submissions">
<table class="listing" width="100%">
	<tr class="heading" valign="bottom">
		<td width="15%">{translate key="common.proposalId"}</td>
		<td width="15%"><span class="disabled">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="40%">{sort_heading key="article.title" sort="title"}</td>
		<td width="15%">{sort_heading key="submissions.reviewRound" sort="round"}</td>
		<td width="15%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>

{iterate from=submissions item=submission}
    {assign var="status" value=$submission->getStatus()}
    {assign var="progress" value=$submission->getSubmissionProgress()}

    {assign var="lastDecision" value=$submission->getLastSectionDecision()}
    {assign var="lastDecisionType" value=$lastDecision->getReviewType()}

    {assign var="abstract" value=$submission->getLocalizedAbstract()}
    {assign var="articleId" value=$submission->getArticleId()}
    {assign var="proposalId" value=$submission->getProposalId()}

    <tr valign="top">
        <td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
        <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
        {if $status == STATUS_QUEUED}
            <td><a href="{url op="submit" path=$progress articleId=$articleId}" class="action">{if $abstract && $abstract->getScientificTitle()}{$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
        {else}
            <td><a href="{url op="submission" path=$articleId}" class="action">{if $abstract && $abstract->getScientificTitle()}{$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
        {/if}
        <td>
            {$lastDecision->getSectionAcronym()} - {translate key=$lastDecision->getReviewTypeKey()} - {$lastDecision->getRound()}
        </td>
        <td align="right">
            {if $status == STATUS_QUEUED}
                {translate key="submission.status.draft"}<br/><a href="{url op="deleteSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmDelete"}')">{translate key="common.delete"}</a>        
            {else}
            	{translate key=$lastDecision->getReviewStatusKey()}<br />
                {if $lastDecisionType == REVIEW_TYPE_PR}
                    <a href="{url op="addProgressReport" path=$articleId}" class="action">{translate key="form.resubmit"}</a><br />
                {elseif $lastDecisionType == REVIEW_TYPE_FR}
                    <a href="{url op="addCompletionReport" path=$articleId}" class="action">{translate key="form.resubmit"}</a><br />
                {elseif $lastDecisionType == REVIEW_TYPE_SAE}
                    <a href="{url op="addAdverseEvent" path=$articleId}" class="action">{translate key="form.resubmit"}</a><br />
                {else}
                    <a href="{url op="resubmit" path=$articleId}" class="action">{translate key="form.resubmit"}</a><br />
                {/if}
                <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>
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
		<td colspan="2" align="left">{page_info iterator=$submissions}</td>
		<td colspan="3" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>
