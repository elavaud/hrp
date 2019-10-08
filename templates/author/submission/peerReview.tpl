{**
 * peerReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's peer review table.
 *
 * $Id$
 *}
<div id="peerReview">
	<h3>{translate key="submission.peerReview"}</h3>

	{foreach from=$sectionDecisions item=sDecision}
		{assign var="reviewerFiles" value=$sDecision->getAuthorViewableReviewFiles()}
		{assign var="editorFiles" value=$sDecision->getDecisionFiles()}
	
		<table class="data" width="100%">
			<tr>
				<td colspan="2" class="separator">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td class="label" width="20%"><b>{$sDecision->getSectionAcronym()} - {translate key=$sDecision->getReviewTypeKey()} - {$sDecision->getRound()}</b></td>
				<td class="value" width="80%"><b>{translate key=$sDecision->getReviewStatusKey()}</b></td>
			</tr>
			<tr valign="top">
				<td class="label" width="20%">{translate key="common.dateDecided"}:</td>
				<td class="value" width="80%">{$sDecision->getDateDecided()|date_format:$dateFormatLong}</td>
			</tr>
			{if $reviewerFiles}
				<tr valign="top">
					<td class="label" width="20%">
						{translate key="submission.reviewFiles"}
					</td>
					<td class="value" width="80%">
						{foreach from=$reviewerFiles item=reviewerFile}
									<a href="{url op="downloadFile" path=$submission->getId()|to_array:$reviewerFile->getFileId()}" class="file">{$reviewerFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatLong}<br />
						{/foreach}
					</td>
				</tr>
			{/if}
			{if $editorFiles}
				<tr valign="top">
					<td class="label" width="20%">
						{translate key="submission.decisionFile"}
					</td>
					<td class="value" width="80%">
						{foreach from=$editorFiles item=editorFile}
							<a href="{url op="downloadFile" path=$submission->getId()|to_array:$editorFile->getFileId()}" class="file">{$editorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$editorFile->getDateModified()|date_format:$dateFormatLong}<br />
						{/foreach}
					</td>
				</tr>
			{/if}
			
			{assign var="meetings" value=$sDecision->getInvestigatorMeetings()}

			{if $meetings|@count gt 0}

				<div class="separator"></div>
				{include file="author/submission/meeting.tpl"}

			{/if}
		</table>
	{/foreach}
</div>
