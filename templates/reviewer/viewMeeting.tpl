{**
 * viewMeeting.tpl
 *
 * Show the view meeting for reviewer page.
 *
 *
 * $Id$
 *}
 
{strip}
	{assign var="meetingPublicId" value=$meeting->getPublicId()}
	{translate|assign:"pageTitleTranslated" key="common.queue.long.viewMeeting" id=$meetingPublicId}
	{assign var="pageCrumbTitle" value="common.queue.long.viewMeeting"}
	{include file="common/header.tpl"}
{/strip}

{literal}
	<script type="text/javascript">
	
		function editAnswer(){
    		$('#replyMeetingForm').show();
    		$('#editAnswer').hide();
    		$('#editAnswerHide').show();	
		}

		function editAnswerHide(){
    		$('#replyMeetingForm').hide();
    		$('#editAnswer').show();
    		$('#editAnswerHide').hide();		
		}
    	
	</script>
{/literal}

<ul class="menu">
	<li><a href="{url journal=$journalPath page="reviewer" path="active"}">{translate key="common.queue.short.reviewAssignments"}</a></li>
	<li class="current"><a href="{url op="meetings"}">{translate key="reviewer.meetings"}</a></li>
</ul>
<ul class="menu">
	<li class="current"><a href="{url op="meetings"}">{translate key="common.queue.long.meetingList"}</a></li>
	{if $isReviewer}
		<li><a href="{url op="proposalsFromMeetings"}">{translate key="common.queue.long.meetingProposals"}</a></li>
	{/if}
</ul>

<div class="separator"></div>
<br/>

<div id="details">
	<h2>{translate key="reviewer.meetings.details"}</h2>
	<div class="separator"></div>
	<table width="100%" class="data">
		<tr valign="top">
			<td class="label" width="20%">{translate key="editor.meeting.id"}</td>
			<td class="value" width="80%">{$meeting->getPublicId()}</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">{translate key="reviewer.meetings.erc"}</td>
			<td class="value" width="80%">{$erc->getLocalizedTitle()}</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">{translate key="editor.meeting.schedule"}</td>
			<td class="value" width="80%">{$meeting->getDate()|date_format:$datetimeFormatLong}</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">{translate key="editor.meeting.length"}</td>
			<td class="value" width="80%">{$meeting->getLength()} mn</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">{translate key="editor.meeting.location"}</td>
			<td class="value" width="80%">{$meeting->getLocation()}</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">{translate key="reviewer.meetings.scheduleStatus"}</td>
			<td class="value" width="80%">{$meeting->getStatusKey()}</td>
		</tr>
	</table>
</div>
<br/>

<div id="submissions">
	<h2>{translate key="reviewer.meetings.submissions"}</h2>
	<div class="separator"></div>
	<table width="100%" class="listing">
		<tr class="heading" valign="bottom">
			<td width="10%">{translate key="article.article"} {translate key="common.id"}</td>
			<td width="20%">{translate key="article.authors"}</td>
			<td width="40%">{translate key="article.title"}</td>
			<td width="15%">{translate key="submissions.reviewRound"}</td>
			<td width="15%">{translate key="common.status"}</td>
		</tr>
		<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
	
		{assign var="decisionCount" value=0}
		{foreach from=$sectionDecisions item=decision}
			{assign var="key" value=$decision->getId()}
			{if $isReviewer}
				<tr valign="top">
					<td>{$decision->getProposalId()|escape}</td>
   					<td>{$decision->getAuthorString()|truncate:40:"..."|escape}</td>		
   					<td>
                                            {if $map.$key}
                                                <a href="{url op="submission" path=$map.$key}" class="action">{$decision->getLocalizedProposalTitle()|strip_unsafe_html|truncate:60:"..."}</a>
                                            {else}
                                                <a href="{url op="viewProposalFromMeeting" path=$decision->getArticleId()}" class="action">{$decision->getLocalizedProposalTitle()|strip_unsafe_html|truncate:60:"..."}</a>
                                            {/if}
                                        </td>
                                        <td>{translate key=$decision->getReviewTypeKey()} - {$decision->getRound()}</td>
					<td>{translate key=$decision->getReviewStatusKey()}</td>
				</tr>
				<tr><td colspan="5" class="separator"></td></tr>
				{assign var="decisionCount" value=$submissionCount+1}
			{elseif $map.$key}
   				<tr valign="top">
					<td>{$decision->getProposalId()|escape}</td>
   					<td>{$decision->getAuthorString()|truncate:40:"..."|escape}</td>
   					<td><a href="{url op="submission" path=$map.$key}" class="action">{$decision->getLocalizedProposalTitle()|strip_unsafe_html|truncate:60:"..."}</a></td>
                                        <td>{translate key=$decision->getReviewTypeKey()} - {$decision->getRound()}</td>
					<td>{translate key=$decision->getReviewStatusKey()}</td>
				</tr>
				<tr><td colspan="5" class="separator"></td></tr>
				{assign var="decisionCount" value=$submissionCount+1}
			{/if}
		{/foreach}
	
		{if empty($sectionDecisions)}
			<tr>
				<td colspan="5" class="nodata">{translate key="submissions.noSubmissions"}</td>
			</tr>
		{/if}
		<tr>
			<td colspan="5" class="endseparator">&nbsp;</td>
		</tr>
		{if !empty($sectionDecisions)}
			<tr>
				<td colspan="5" align="left">{$decisionCount} {translate key="submissions.proposal.s"}</td>
			</tr>
		{/if}
	</table>
</div>
<br/>

<div id="reply">
	<h2>{translate key="reviewer.meetings.reply"}</h2>
	<div class="separator"></div>
	<a name="reply"></a>
	{assign var="meetingAttendance" value=$meeting->getMeetingAttendanceOfUser($userId)}
	<table width="100%" class="listing" {if $meetingAttendance->getIsAttending() == 3}style="display: none;"{/if}>
		<tr valign="top">
			<td class="label" width="30%">{translate key="reviewer.article.schedule.isAttending"}</td>
			<td class="value" width="70%">{if  $meetingAttendance->getIsAttending() == 1 }{translate key="common.yes"}{elseif  $meetingAttendance->getIsAttending() == 2 }{translate key="common.no"}{else}{translate key="common.undecided"}{/if}</td>
		</tr>
		<tr valign="top">
			<td class="label" width="30%">{translate key="reviewer.article.schedule.remarks"}</td>
			<td class="value" width="70%">{if $meetingAttendance->getRemarks() != null}{$meetingAttendance->getRemarks()}{else}&mdash;{/if}</td>
		</tr>
		<tr valign="top" id="editAnswer">
			<td class="label" width="30%">&nbsp;</td>
			<td class="value" width="70%"><a href="#reply" onclick="editAnswer()" class="action"  id="editAnswer">{translate key="reviewer.article.schedule.editAnswer"}</a></td>
		</tr>
		<tr valign="top" id="editAnswerHide" style="display: none;">
			<td class="label" width="30%">&nbsp;</td>
			<td class="value" width="70%"><a href="#reply" onclick="editAnswerHide()" class="action" id="editAnswerHide">{translate key="reviewer.article.schedule.editAnswerHide"}</a></td>
		</tr>
	</table>
	<form method="post" action="{url op="replyMeeting"}" >
		<table width="100%" class="data" id="replyMeetingForm" {if $meetingAttendance->getIsAttending() != 3}style="display: none;"{/if}>
			<tr><td colspan="2" class="headseparator">&nbsp;</td></tr>
			<tr valign="top">
				<td class="label" width="30%">{translate key="reviewer.article.schedule.isAttending"} </td>
				<td class="value" width="70%">	
					<input type="radio" name="isAttending" id="acceptMeetingSchedule" value="1" {if  $meetingAttendance->getIsAttending() == 1 } checked="checked"{/if} > </input> {translate key="common.yes"}
					<input type="radio" name="isAttending" id="regretMeetingSchedule" value="2" {if  $meetingAttendance->getIsAttending() == 2 } checked="checked"{/if} > </input> {translate key="common.no"}
					<input type="radio" name="isAttending" id="undecidedMeetingSchedule" value="0" {if  $meetingAttendance->getIsAttending() == 0 } checked="checked"{/if} > </input> {translate key="common.undecided"}
				</td>
			</tr> 
			<tr>
				<td class="label" width="30%">{translate key="reviewer.article.schedule.remarks"} </td>
				<td class="value" width="70%">
					<textarea class="textArea" name="remarks" id="proposedDate" rows="5" cols="40" />{$meetingAttendance->getRemarks()|escape}</textarea>
				</td>
			</tr>
			<tr>
				<td class="label"></td>
				<td class="value">
					<input type="hidden" id="meetingId" name="meetingId" value={$meeting->getId()}> </input>
					<input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="meetings" escape=false}'" />
				</td>
			</tr>
		</table>
	</form>
</div>
{include file="common/footer.tpl"}
