{**
 * active.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show reviewer's active proposals.
 *
 * $Id$
 *}
 

{if !$dateFrom}
	{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
	{assign var="dateTo" value="--"}
{/if}

 <form method="post" name="submit" action="{url op='index' path='active'}">
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
	<select name="dateSearchField" size="1" class="selectMenu">
		{html_options_translate options=$dateFieldOptions selected=$dateSearchField}
	</select>
	{translate key="common.between"}
	{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	{translate key="common.and"}
	{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<br/>
    <br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
</form>

<br/><br/><br/>

<div id="submissions">
	<table class="listing" width="100%">
		<tr><td colspan="6"><strong>{translate key="common.reviewerActiveProposals"}</strong></td></tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr class="heading" valign="bottom">
			<td width="10%">{translate key="common.id"}</td>
			<td width="45%">{sort_heading key="article.title" sort='title'}</td>
                        <td width="15%" align="right">{translate key="submissions.reviewRound"}</td>
			<td width="10%" align="right"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="common.assigned" sort='assignDate'}</td>
			<td width="10%" align="right"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submission.due" sort='dueDate'}</td>
			<td width="10%" align="right"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{translate key="common.confirmed"}</td>
                </tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		{assign var="count" value=0}
		{iterate from=submissions item=submission}
			{assign var="articleId" value=$submission->getProposalId()}
			{assign var="abstract" value=$submission->getLocalizedAbstract()}
                        {assign var="undergoingDecision" value=$submission->getUndergoingDecision()}
                        {assign var="rrAssignment" value=$submission->getUndergoingAssignment()}

                        <tr valign="top">
				<td>{$articleId|escape}</td>
				<td><a href="{url op="submission" path=$submission->getArticleId()}" class="action">{$abstract->getScientificTitle()|escape}</a></td>
                                <td align="right">{translate key=$undergoingDecision->getReviewTypeKey()} - {$undergoingDecision->getRound()}</td>
				<td align="right">{$rrAssignment->getDateNotified()|date_format:$dateFormatLong}</td>
                                <td align="right">{$rrAssignment->getDateDue()|date_format:$dateFormatLong}</td>
				<td align="right">
					{if $rrAssignment->getDateConfirmed()!=null && !$rrAssignment->getDeclined()}
				 		{$rrAssignment->getDateConfirmed()|date_format:$dateFormatLong}
					{elseif $rrAssignment->getDeclined()}
						<span class="disabled">{translate key="submissions.declined"}</span>
					{else}
						&mdash;
					{/if}
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
			</tr>
			{assign var="count" value=$count+1}
		{/iterate}
		{if $submissions->wasEmpty()}
			<tr>
				<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
			</tr>
			<tr>
				<td colspan="6" class="endseparator">&nbsp;</td>
			</tr>
		{else}
			<tr>
				<td colspan="4" align="left">{page_info iterator=$submissions}</td>
				<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions sort=$sort sortDirection=$sortDirection}</td>
			</tr>
		{/if}
	</table>
</div>

