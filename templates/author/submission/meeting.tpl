{**
 * meeting.tpl
 *
 * Display meeting information
 *
 *}
 
<table width="100%">
	<tr>
		<td class="label" width="20%">{translate key="reviewer.meeting"}</td>
		<td class="value" width="80%">
			<table width="100%" class="data">
				{foreach from=$meetings item=meeting}
                                    {if $meeting->getStatus() != STATUS_CANCELLED}
					{assign var="meetingAttendance" value=$meeting->getMeetingAttendanceOfUser($submission->getUserId())}
					<tr>
						<td width="50%" valign="top">
							<table width="100%" class="data">
								<tr>
									<td colspan="2"><b>{translate key="reviewer.meetings.details"}</b></td>
								</tr>
								<tr>
									<td class="label" width="40%">{translate key="editor.meeting.id"}</td>
									<td class="value" width="60%">{$meeting->getPublicId()}</td>
								</tr>
								<tr>
									<td class="label" width="40%">{translate key="editor.meeting.schedule"}</td>
									<td class="value" width="60%">{$meeting->getDate()|date_format:$datetimeFormatLong}</td>
								</tr>
								<tr>
									<td class="label" width="40%">{translate key="editor.meeting.length"}</td>
									<td class="value" width="60%">{$meeting->getLength()} mn</td>
								</tr>
									<tr>
										<td class="label" width="40%">{translate key="editor.meeting.location"}</td>
										<td class="value" width="60%">{$meeting->getLocation()}</td>
									</tr>
								<tr>
									<td class="label" width="40%">{translate key="reviewer.meetings.scheduleStatus"}</td>
									<td class="value" width="60%">{$meeting->getStatusKey()}</td>
								</tr>
								<tr>
									<td class="label" width="40%">{translate key="reviewer.meetings.lastReply"}:</td>
									<td class="value" width="60%">
                                                                            {if $meetingAttendance}
										{if $meetingAttendance->getIsAttending() != 3}
											{if $meetingAttendance->getIsAttending() == 1}
												{translate key="common.yes"}
											{elseif $meetingAttendance->getIsAttending() == 2}
												{translate key="common.no"}
											{elseif $meetingAttendance->getIsAttending() == 0}
												{translate key="common.undecided"}
											{/if}
											{if $meetingAttendance->getRemarks() != ''}
												({$meetingAttendance->getRemarks()})
											{/if}
										{else}
											{translate key="reviewer.meetings.replyStatus.awaitingReply"}
										{/if}
                                                                            {/if}
									</td>
								</tr>
							</table>
						</td>
						<td width="50%" valign="top">
							{if $smarty.now|date_format:"%Y/%m/%d" < $meeting->getDate()|date_format:"%Y/%m/%d" && $meeting->getStatus() != $smarty.const.STATUS_CANCELLED} 

							<form method="post" action="{url op="replyMeeting"}" >
								<table width="100%" class="data">
									<tr>
										<td colspan="2"><b>{translate key="reviewer.meetings.replyStatus"}</b></td>
									</tr>
									<tr valign="top">
										<td class="label">{translate key="reviewer.article.schedule.isAttending"} </td>
										<td class="value">	
											<input type="radio" name="isAttending" value="1" {if $meetingAttendance->getIsAttending() == 1}checked="checked"{/if}> </input> {translate key="common.yes"}
											<input type="radio" name="isAttending" value="2" {if $meetingAttendance->getIsAttending() == 2}checked="checked"{/if}> </input> {translate key="common.no"}
											<input type="radio" name="isAttending" value="0" {if $meetingAttendance->getIsAttending() == 0}checked="checked"{/if}> </input> {translate key="common.undecided"}
										</td>
									</tr> 
									<tr>
										<td class="label">{translate key="reviewer.article.schedule.remarks"} </td>
										<td class="value">
											<textarea class="textArea" name="remarks" rows="2" cols="30" />{$meetingAttendance->getRemarks()|escape}</textarea>
										</td>
									</tr>
									<tr>
										<td class="label">&nbsp;</td>
										<td class="value">
											<input type="hidden" name="meetingId" value={$meetingAttendance->getMeetingId()}> </input>
											<input type="hidden" name="submissionId" value={$submission->getId()}> </input>
											<input type="submit" value="{translate key="common.save"}" class="button defaultButton" />
										</td>
									</tr>
								</table>
							</form>
							{/if}
						</td>
					</tr>
                                    {else}
                                        {$meeting->getStatusKey()}
                                    {/if}
				{/foreach}
			</table>
		</td>
	</tr>
</table>
