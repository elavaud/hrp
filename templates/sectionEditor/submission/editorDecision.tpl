{**
 * editorDecision.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the editor decision table.
 *
 * $Id$
 *}
 
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>

{literal}
    <script type="text/javascript">
        $(document).ready(function() {
            $("#approvalDate").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
        });
        function checkSize(){
            var fileToUpload = document.getElementById('finalDecisionFile');
            var check = fileToUpload.files[0].fileSize;
            var valueInKb = Math.ceil(check/1024);
            if (check > 5242880){
                alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
                return false
            } 
        }
    </script>
{/literal}

{if $lastDecision->isSecretary($userId) == true}
    {assign var="lastDecisionStatus" value=$lastDecision->getDecision()}
    {if $lastDecisionStatus == SUBMISSION_SECTION_DECISION_FULL_REVIEW || $lastDecisionStatus == SUBMISSION_SECTION_DECISION_EXPEDITED} 
        <div>
            {if $reviewAssignmentCount>0}
                {include file="sectionEditor/submission/peerReview.tpl"}
            {else}
                {include file="sectionEditor/submission/peerReviewSelection.tpl"}
            {/if}
            <div class="separator"></div>
        </div>
    {/if}
    {if $authorFees}
        {include file="sectionEditor/submission/authorFees.tpl"}
        <div class="separator"></div>
    {/if}
{/if}

<div id="editorDecision">
    <h3>{translate key="submission.editorDecision"}</h3>

    {foreach from=$sectionDecisions item="sectionDecision"}

        {assign var="isSecretary" value=$sectionDecision->isSecretary($userId)}
        {assign var="committee" value=$sectionDecision->getSection()}
        {assign var="decision" value=$sectionDecision->getDecision()}
        <p><br/><b>{$committee->getLocalizedAbbrev()} - {translate key=$sectionDecision->getReviewTypeKey()} - {translate key="submission.round" round=$sectionDecision->getRound()}</b></p>

        <table id="table1" width="100%" class="data">

            <tr valign="top" id="reviewStatus">
                    <td title="{translate key="submission.reviewStatusInstruct"}" class="label" width="20%">[?] {translate key="submission.reviewStatus"}</td>
                    <td width="80%" class="value">
                            {translate key=$sectionDecision->getReviewStatusKey()} &nbsp; ({$sectionDecision->getDateDecided()|date_format:$datetimeFormatLong})
                    </td>
            </tr>
            {if $isSecretary == true}
                {if $decision == SUBMISSION_SECTION_DECISION_EXPEDITED || $decision == SUBMISSION_SECTION_DECISION_FULL_REVIEW || ($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && !$sectionDecision->getComments())}
                    <form method="post" action="{url op="downloadApprovalNoticeTemplate"}">
                        <input type="hidden" name="articleId" value="{$submission->getId()}" />
                        <tr valign="top">
                            <td title="editor.approvalNotice.templates.instruct" class="label" width="20%">[?] {translate key="editor.approvalNotice.templates"}</td>
                            <td width="80%" class="value">
                                <select id="noticeTemplate" name="noticeTemplate" size="1" class="selectMenu">
                                    {html_options options=$templates}
                                </select>
                                <input type="submit" name="submit" value="{translate key="common.download"}"  class="button" />
                            </td>
                        </tr>
                    </form>
                {/if}
                <form method="post" action="{url op="recordDecision"}" onSubmit="return checkSize()" enctype="multipart/form-data">
                    <input type="hidden" name="articleId" value="{$submission->getId()}" />
                    {if $decision == SUBMISSION_SECTION_NO_DECISION}
                        <tr valign="top" id="reviewSelection">
                            <td title="{translate key="editor.article.selectInitialReviewInstruct"}" class="label" width="20%">[?] {translate key="editor.article.selectInitialReview"}</td>
                            <td width="80%" class="value">
                                    <select id="decision" name="decision" size="1" class="selectMenu">
                                            {html_options_translate options=$initialReviewOptions selected=1}
                                    </select>
                                    <input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmInitialReview"}')" name="submit" value="{translate key="editor.article.record"}"  class="button" />			
                            </td>
                        </tr>
                    {elseif $decision == SUBMISSION_SECTION_DECISION_COMPLETE}
                        <tr valign="top" id="reviewSelection">
                            <td title="{translate key="editor.article.selectReviewProcessInstruct"}" class="label" width="20%">[?] {translate key="editor.article.selectReviewProcess"}</td>
                            <td width="80%" class="value">
                                <select id="decision" name="decision" size="1" class="selectMenu">
                                    {if $sectionDecision->getReviewType() == REVIEW_TYPE_INITIAL}
                                        {html_options_translate options=$reviewOptions selected=0}
                                    {else}
                                        {html_options_translate options=$reviewOptionsWithoutExempted selected=0}
                                    {/if}                                                            
                                </select>
                                <input type="submit" id="notFullReview" onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmExemption"}')" name="submit" value="{translate key="editor.article.record"}"  class="button" />
                            </td>
                        </tr>
                    {elseif $decision == SUBMISSION_SECTION_DECISION_EXPEDITED || $decision == SUBMISSION_SECTION_DECISION_FULL_REVIEW || ($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && !$sectionDecision->getComments())}
                        {if $decision == SUBMISSION_SECTION_DECISION_EXPEDITED || $decision == SUBMISSION_SECTION_DECISION_FULL_REVIEW}	
                            <tr id="finalDecisionSelection">
                                <td title="{translate key="editor.article.selectDecisionInstruct"}" class="label" width="20%">[?] {translate key="editor.article.selectDecision"}</td>
                                <td width="80%" class="value">
                                    <select id="decision" name="decision" {if $authorFees && !$submissionPayment && $submission->getTotalBudget() > 5000}disabled="disabled"{/if} size="1" class="selectMenu">
                                        {if $sectionDecision->getReviewType() == REVIEW_TYPE_INITIAL}
                                            {html_options_translate options=$sectionDecisionOptions selected=0}
                                        {else}
                                            {html_options_translate options=$sectionDecisionOptionsWithoutDeclined selected=0}
                                        {/if}
                                    </select> 
                                    {if $authorFees && !$submissionPayment && $submission->getTotalBudget() > 5000}
                                        <i>{translate key="editor.article.payment.paymentConfirm"}</i>
                                    {/if}			
                                </td>		
                            </tr>
                        {else}
                            {assign var="reasonsMap" value=$sectionDecision->getReasonsForExemptionMap()}
                            <tr valign="top">
                                <td title="{translate key="editor.article.reasonsForExemptionInstruct"}" class="label">[?] {translate key="editor.article.reasonsForExemption"}</td>
                                <td class="value"> {translate key="editor.article.exemption.instructions"}</td>
                            </tr>
                            {foreach from=$reasonsMap item=reasonLocale key=reasonVal}
                                <tr valign="top">
                                    <td class="label" align="center">
                                        <input type="checkbox" name="exemptionReasons[]" id="reason{$reasonVal}" value={$reasonVal}/>				
                                    </td>
                                    <td class="value">
                                        <label for="reason{$reasonVal}">{translate key=$reasonLocale}</label>
                                    </td>
                                </tr>
                            {/foreach}
                        {/if}
                        <tr id="approvalDateRow">
                            <td title="{translate key="editor.article.setApprovalDateInstruct"}" class="label">[?] {translate key="editor.article.setApprovalDate"}</td>
                            <td class="value">
                                <input type="text" name="approvalDate" id="approvalDate" class="textField" size="19" />
                            </td>
                        </tr>
                        <tr id="uploadFinalDecisionFile">
                            <td title="{translate key="editor.article.uploadFinalDecisionFileInstruct"}" class="label" width="20%">[?] {translate key="editor.article.uploadFinalDecisionFile"}</td>
                            <td width="80%" class="value">
                                <input type="file" class="uploadField" name="finalDecisionFile" id="finalDecisionFile"/>
                                <input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmDecision"}')" name="submit" value="{translate key="editor.article.uploadRecordDecision"}"  class="button" >
                                {if $sectionDecision->getReviewType() != REVIEW_TYPE_INITIAL}<br/><i>{translate key="editor.submissionReview.decisionFileNotRequired"}</i>{/if}
                            </td>
                        </tr>
                    {/if}
                </form>
            {/if}
            {if $decision == SUBMISSION_SECTION_DECISION_APPROVED || $decision == SUBMISSION_SECTION_DECISION_RESUBMIT || $decision == SUBMISSION_SECTION_DECISION_DECLINED || ($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && $sectionDecision->getComments())}
                {if $decision == SUBMISSION_SECTION_DECISION_APPROVED || $decision == SUBMISSION_SECTION_DECISION_RESUBMIT || $decision == SUBMISSION_SECTION_DECISION_DECLINED}
                    {assign var="reviewAssignments" value=$sectionDecision->getReviewAssignmentsDone()}
                    <tr valign="top" id="decisionFile">
                        <td title="{translate key="editor.article.peerReviewsInstruct"}" class="label">[?] {translate key="editor.article.peerReviews"}</td>
                        <td class="value">{$reviewAssignments|@count} {translate key="editor.article.recommendationAvailable"}</td>
                    </tr>
                    {assign var="reviewerCount" value=0}
                    {foreach from=$reviewAssignments item="reviewAssignment"}
                        {assign var="reviewerCount" value=$reviewerCount+1}
                        <tr valign="top" id="reviewAssignment">
                            <td class="label">&nbsp;</td>
                            <td class="value">
                                <table width="100%" class="data">
                                    <tr style="vertical-align:middle" id="reviewAssignment">
                                        <td width="20%" class="label">{if $isSecretary == true} {$reviewAssignment->getReviewerFullName()|escape} {else} {translate key="user.ercrole.ercMember"} &nbsp; {$reviewerCount} {/if}</td>
                                        <td width="80%" class="value">
                                            <table width="100%" class="data">
                                                {if $reviewAssignment->reviewFormResponseExists()}
                                                <tr style="vertical-align:middle" id="reviewFormResponse">
                                                    <td title="{translate key="submission.reviewFormResponseInstruct"}" width="30%" class="label">[?] {translate key="submission.reviewForm"}
                                                    <td width="70%" class="value">
                                                        <a href="javascript:openComments('{url op="viewReviewFormResponse" path=$submission->getId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="comment"}</a>
                                                    </td>
                                                </tr>
                                                {/if}
                                                {assign var="reviewerFile" value=$reviewAssignment->getReviewerFile()}
                                                {if $reviewerFile}
                                                    <tr style="vertical-align:middle" id="reviewerFile">
                                                        <td title="{translate key="reviewer.article.uploadedFileInstruct"}" width="30%" class="label">[?] {translate key="reviewer.article.uploadedFile"}</td>
                                                        <td width="70%" class="value"><a href="{url op="downloadFile" path=$submission->getId()|to_array:$reviewerFile->getFileId()}" class="file">{$reviewerFile->getFileName()|escape}</a></td>
                                                    </tr>
                                                {/if}
                                                {if $reviewAssignment->getRecommendation() !== null && $reviewAssignment->getRecommendation() !== ''}
                                                    <tr style="vertical-align:middle" id="reviewerFile">
                                                        <td title="{translate key="reviewer.article.recommendationInstruct"}" width="30%" class="label">[?] {translate key="reviewer.article.recommendation"}</td>
                                                        <td width="70%" class="value">
                                                            {assign var="recommendation" value=$reviewAssignment->getRecommendation()}
                                                            {translate key=$reviewerRecommendationOptions.$recommendation}
                                                        </td>
                                                    </tr>
                                                {/if}
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/foreach}
                {elseif ($decision == SUBMISSION_SECTION_DECISION_EXEMPTED && $sectionDecision->getComments())}
                    {assign var="reasons" value=$sectionDecision->getProposalReasonsForExemption()}
                    {assign var="reasonsMap" value=$sectionDecision->getReasonsForExemptionMap()}
                    <tr style="vertical-align:middle">
                        <td class="label">[?] {translate key="editor.article.reasonsForExemption"}</td>
                        <td class="value">
                            {foreach from=$reasonsMap item=reasonLocale key=reasonVal}
                                {if $reasons[$reasonVal] == 1}
                                    {translate key=$reasonLocale}<br/>
                                {/if}
                            {/foreach}	
                        </td>
                    </tr>				
                {/if}
                {assign var="decisionFiles" value=$sectionDecision->getDecisionFiles()}
                <tr valign="top" id="decisionFile">
                    <td title="{translate key="editor.article.finalDecisionFileInstruct"}" class="label">[?] {translate key="editor.article.finalDecisionFile"}</td>
                    <td class="value">
                        {foreach from=$decisionFiles item="decisionFile"}
                            <a href="{url op="downloadFile" path=$sectionDecision->getArticleId()|to_array:$decisionFile->getFileId()}" class="file">{$decisionFile->getFileName()|escape}</a><br />
                        {foreachelse}
                            {translate key="common.none"}
                        {/foreach}
                    </td>
                </tr>
            {/if}

            {assign var="meetings" value=$sectionDecision->getMeetings()}

            {if $meetings|@count gt 0}
                <tr>
                    <td title="{translate key="editor.article.meetingInstruct"}" class="label" width="20%">[?] {translate key="editor.meeting.s"}</td>
                    <td class="value" width="80%">
                        {foreach from=$meetings item="meeting"}
                            <a href="{url op="viewMeeting" path=$meeting->getId()}">{$meeting->getPublicId()} {$meeting->getDate()|date_format:$datetimeFormatLong}</a><br/>
                        {/foreach}
                    </td>
                </tr>
            {/if}
        </table>
    {/foreach}
</div>