{**
 * index.tpl
 *
 * Reviewer index.
 *
 * $Id$
 *}

{strip}
	{assign var="pageTitle" value="common.queue.long.meetingProposals"}
	{include file="common/header.tpl"}
{/strip}

{if !$dateFrom}
	{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
	{assign var="dateTo" value="--"}
{/if}
<ul class="menu">
	<li><a href="{url journal=$journalPath page="reviewer" path="active"}">{translate key="common.queue.short.reviewAssignments"}</a></li>
	<li class="current"><a href="{url op="meetings"}">{translate key="reviewer.meetings"}</a></li>
</ul>
<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="common.queue.long.meetingList"}</a></li>
	{if $isReviewer}
		<li class="current"><a href="{url op="proposalsFromMeetings"}">{translate key="common.queue.long.meetingProposals"}</a></li>
	{/if}
</ul>

<div class="separator"></div>
<br/>
 
{if !$dateFrom}
	{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
	{assign var="dateTo" value="--"}
{/if}

<form method="post" name="submit" action="{url op='proposalsFromMeetings'}">
	<input type="hidden" name="sort" value="id"/>
	<input type="hidden" name="sortDirection" value="ASC"/>
	<select name="searchField" size="1" class="selectMenu">
		{html_options_translate options=$fieldOptions selected=$searchField}
	</select>
	<select name="searchMatch" size="1" class="selectMenu">
		<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
		<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
		<option value="startsWith"{if $searchMatch == 'startsWith'} selected="selected"{/if}>{translate key="form.startsWith"}</option>
	</select>
	<input type="text" size="15" name="search" class="textField" value="{$search|escape}" />
	<br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
	<br/>
	<br/>
</form>

<div id="submissions">
	<table class="listing" width="100%">
		<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		<tr class="heading" valign="bottom">
			<td width="10%">{translate key="common.proposalId"}</td>
			<td width="40%">{sort_heading key="article.title" sort='title'}</td>
			<td width="20%">{translate key="submissions.reviewRound"}</td>
			<td width="15%">{translate key="submission.decision"}</td>
			<td width="15%">{translate key="editor.meeting.id"}</td>
		</tr>
		<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		{iterate from=meetingSubmissions item=meetingSubmission}
			{assign var="abstract" value=$meetingSubmission->getLocalizedAbstract()}
			{assign var="sectionDecisions" value=$meetingSubmission->getMeetingsDecisions()}
			{assign var="firstDecision" value = 1}
                        {foreach from=$sectionDecisions item=decision}
                            {assign var="meetings" value=$decision->getMeetings()}
                            {assign var="firstMeeting" value = 1}
                            {foreach from=$meetings item=meeting}
                                <tr valign="top">
                                        <td>{if $firstDecision ne 0}{$meetingSubmission->getProposalId()|escape}{else}&nbsp;{/if}</td>
                                        <td>{if $firstDecision ne 0}
                                            {assign var="articleId" value = $meetingSubmission->getArticleId()}
                                            {if $map.$articleId}
                                                <a href="{url op="submission" path=$articleId}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."}</a>
                                            {else}
                                                <a href="{url op="viewProposalFromMeeting" path=$articleId}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."}</a>
                                            {/if}
                                            {else}&nbsp;{/if}
                                        </td>
                                        <td>{if $firstMeeting == 1}{translate key=$decision->getReviewTypeKey()} - {$decision->getRound()}{else}&nbsp;{/if}</td>	
                                        <td>{if $firstMeeting == 1}{translate key=$decision->getReviewStatusKey()}{else}&nbsp;{/if}</td>
                                        <td><a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">{$meeting->getPublicId()|escape}</a></td>
                                </tr>	
                                {assign var="firstMeeting" value = 0}
                                {assign var="firstDecision" value = 0}
                            {/foreach}
                        {/foreach}

			<td colspan="5" class="separator">&nbsp;</td>
		{/iterate}
		{if $meetingSubmissions->wasEmpty()}
			<tr>
				<td colspan="3" class="nodata">{translate key="submissions.noSubmissions"}</td>
			</tr>
			<tr>
				<td colspan="3" class="endseparator">&nbsp;</td>
			</tr>
		{else}
			<tr>
				<td colspan="3" align="left">{page_info iterator=$meetingSubmissions}</td>
				<td colspan="3" align="right">{page_links anchor="meetingSubmissions" name="meetingSubmissions" iterator=$meetingSubmissions sort=$sort sortDirection=$sortDirection}</td>
			</tr>
		{/if}
	</table>
</div>

{include file="common/footer.tpl"}

