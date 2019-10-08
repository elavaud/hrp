{**
 * submissionReview.tpl
 *
 * Show the reviewer administration page.
 *
 * $Id$
 *}
 {if $past == '1'} 
    <h3>{translate key="reviewer.article.pastAssignments"}</h3>
    {foreach from=$pastDecisionsAndAssignments item=pDAA}
        {assign var="ds" value="decision"}
        {assign var="as" value="assignment"}                                                        
        {assign var="decision" value=$pDAA[$ds]}
        {assign var="assignment" value=$pDAA[$as]}
        <h6>{$decision->getSectionAcronym()} - {translate key=$decision->getReviewTypeKey()} - {$decision->getRound()}</h6>
        <table width="100%">
            <tr valign="top">
                <td width="50%">
                    <table width="100%" class="data">
                        <tr valign="top">
                            <td class="label" width="40%">{translate key="reviewer.article.schedule.request"}</td>
                            <td class="value" width="60%">{if $assignment->getDateNotified()}{$assignment->getDateNotified()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
                        </tr>
                        <tr valign="top">
                            <td class="label">{translate key="reviewer.article.schedule.response"}</td>
                            <td class="value">{if $assignment->getDateConfirmed()}{$assignment->getDateConfirmed()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
                        </tr>
                        <tr valign="top">
                            <td class="label">{translate key="reviewer.article.schedule.submitted"}</td>
                            <td class="value">{if $assignment->getDateCompleted()}{$assignment->getDateCompleted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
                        </tr>
                        <tr valign="top">
                            <td class="label">{translate key="reviewer.article.schedule.due"}</td>
                            <td class="value">{if $assignment->getDateDue()}{$assignment->getDateDue()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
                        </tr>
                        {assign var="meetings" value=$decision->getMeetings()}
                        {if !empty($meetings)}
                            {assign var="firstMeeting" value=1}
                            <tr>
                                <td class="label">{translate key="common.queue.long.viewMeeting"}</td>
                                <td class="value">
                                    {foreach from=$meetings item=meeting}
                                        {if $firstMeeting != 1}, {/if}<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">{$meeting->getPublicId()|escape}</a>
                                        {assign var="firstMeeting" value=0}
                                    {/foreach}
                                </td>
                            </tr>
                        {/if}                       
                    </table>
                </td>
                <td width="50%">
                    <table width="100%" class="data">
                        <tr valign="top">
                            <td width="40%" class="label">{translate key="submission.reviewForm"}
                            <td width="60%" class="value">
                                {if $assignment->reviewFormResponseExists()}
                                    <a href="{url op="editReviewFormResponse" path=$assignment->getReviewId|to_array:$assignment->getReviewFormId()}" class="icon">{icon name="comment"}</a>
                                {else}
                                    &mdash;
                                {/if} 
                            </td>
                        </tr>
                        {assign var="reviewerFile" value=$assignment->getReviewerFile()}
                        <tr valign="top">
                            <td width="40%" class="label">{translate key="reviewer.article.uploadedFile"}</td>
                            <td width="60%" class="value">
                                {if $reviewerFile}
                                    <a href="{url op="downloadFile" path=$articleId|to_array:$reviewerFile->getFileId():$assignment->getReviewId()}" class="file">{$reviewerFile->getFileName()|escape}</a>
                                {else}
                                    &mdash;
                                {/if}
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="label" width="40%">{translate key="reviewer.article.schedule.decision"}</td>
                            <td class="value" width="60%">
                                {if $assignment->getCancelled()}
                                    {translate key="common.cancelled"}
                                {elseif $assignment->getDeclined()}
                                    {translate key="submissions.declined"}
                                {else}
                                    {assign var=recommendation value=$assignment->getRecommendation()}
                                    {if $recommendation === '' || $recommendation === null}
                                        &mdash;
                                    {else}
                                        {translate key=$reviewerRecommendationOptions.$recommendation}
                                    {/if}
                                {/if}
                            </td>
                        </tr>
                        <tr valign="top">
                            <td class="label" width="40%">{translate key="submission.decision"}</td>
                            <td class="value" width="60%">{translate key=$decision->getReviewStatusKey()}</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

    {/foreach}
    <div class="separator"></div>
 {/if}
 
 {if $otherDecisionsExist == '1'} 
    <h3>{translate key="submission.otherdecision.s"}</h3>
    <div id="otherDecisions">
        {foreach from=$otherDecisions item=otherDecision}
            <table width="100%" class="data">
                <tr valign="middle">
                    <td colspan="2"><h6>{$otherDecision->getSectionAcronym()} - {translate key=$otherDecision->getReviewTypeKey()} - {$otherDecision->getRound()}</h6></td>
                </tr>
                <tr>
                    <td width="20%" class="label">{translate key="submission.decision"}</td>
                    <td width="80%" class="value">{translate key=$otherDecision->getReviewStatusKey()}</td>
                </tr>
                <tr>
                    <td class="label">{translate key="common.queue.long.viewMeeting"}</td>
                    <td class="value">
                        {assign var="meetings" value=$otherDecision->getMeetings()}
                        {assign var="firstMeeting" value=1}
                        {foreach from=$meetings item=meeting}
                            {if $firstMeeting != 1}, {/if}
                            <a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">{$meeting->getPublicId()|escape}</a><br/>
                            {assign var="firstMeeting" value=0}
                        {/foreach}
                    </td>
                </tr>                                
            </table>
        {/foreach}
    </div>     
    <div class="separator"></div> 
 {/if} 
 
 {if $undergoing == '1'} 
    <h3>{$undergoingDecision->getSectionAcronym()} - {translate key=$undergoingDecision->getReviewTypeKey()} - {$undergoingDecision->getRound()}</h3>
    
    {assign var="reviewId" value=$undergoingAssignment->getReviewId()}
    <div id="reviewSchedule">
        <h6>{translate key="reviewer.article.reviewSchedule"}</h6>
        <table width="100%" class="data">
            <tr valign="top">
                <td class="label" width="20%">{translate key="reviewer.article.schedule.request"}</td>
                <td class="value" width="80%">{if $undergoingAssignment->getDateNotified()}{$undergoingAssignment->getDateNotified()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
            </tr>
            <tr valign="top">
                <td class="label">{translate key="reviewer.article.schedule.response"}</td>
                <td class="value">{if $undergoingAssignment->getDateConfirmed()}{$undergoingAssignment->getDateConfirmed()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
            </tr>
            <tr valign="top">
                <td class="label">{translate key="reviewer.article.schedule.submitted"}</td>
                <td class="value">{if $undergoingAssignment->getDateCompleted()}{$undergoingAssignment->getDateCompleted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
            </tr>
            <tr valign="top">
                <td class="label">{translate key="reviewer.article.schedule.due"}</td>
                <td class="value">{if $undergoingAssignment->getDateDue()}{$undergoingAssignment->getDateDue()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
            </tr>
            {if $undergoingAssignment->getDateCompleted() || $undergoingAssignment->getDeclined() == 1 || $undergoingAssignment->getCancelled() == 1}
                <tr valign="top">
                    <td class="label">{translate key="reviewer.article.schedule.decision"}</td>
                    <td class="value">
                        {if $undergoingAssignment->getCancelled()}
                            {translate key="common.cancelled"}
                        {elseif $undergoingAssignment->getDeclined()}
                            {translate key="submissions.declined"}
                        {else}
                            {assign var=recommendation value=$undergoingAssignment->getRecommendation()}
                            {if $recommendation === '' || $recommendation === null}
                                &mdash;
                            {else}
                                {translate key=$reviewerRecommendationOptions.$recommendation}
                            {/if}
                        {/if}
                    </td>
                </tr>
            {/if}
            {assign var="meetings" value=$undergoingDecision->getMeetings()}
            {if !empty($meetings)}
                {assign var="firstMeeting" value=1}
                <tr>
                    <td class="label">{translate key="common.queue.long.viewMeeting"}</td>
                    <td class="value">
                        {foreach from=$meetings item=meeting}
                            {if $firstMeeting != 1}, {/if}<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">{$meeting->getPublicId()|escape}</a>
                            {assign var="firstMeeting" value=0}
                        {/foreach}
                    </td>
                </tr>
            {/if}             
        </table>
    </div>

    <div id="reviewSteps">
        <h6>{translate key="reviewer.article.reviewSteps"}</h6>

        {include file="common/formErrors.tpl"}

        {assign var="currentStep" value=1}

        <table width="100%" class="data">
            <tr valign="top">
                {* FIXME: Should be able to assign primary editorial contact *}
                <td width="3%">{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                <td width="97%"><span class="instruct">{translate key="reviewer.article.notifyEditorA"} {translate key="reviewer.article.notifyEditorB"}</span></td>
            </tr>
            <tr valign="top">
                <td>&nbsp;</td>
                <td>
                    {translate key="submission.response"}&nbsp;&nbsp;&nbsp;&nbsp;
                    {if $undergoingAssignment->getDateConfirmed() == ''}
                        {url|assign:"acceptUrl" op="confirmReview" reviewId=$reviewId}
                        {url|assign:"declineUrl" op="confirmReview" reviewId=$reviewId declineReview=1}

                        {if !$undergoingAssignment->getCancelled()}
                            {translate key="reviewer.article.canDoReview"} {icon name="mail" url=$acceptUrl}
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            {translate key="reviewer.article.cannotDoReview"} {icon name="mail" url=$declineUrl}
                        {else}
                            {url|assign:"url" op="confirmReview" reviewId=$reviewId}
                            {translate key="reviewer.article.canDoReview"} {icon name="mail" disabled="disabled" url=$acceptUrl}
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            {url|assign:"url" op="confirmReview" reviewId=$reviewId declineReview=1}
                            {translate key="reviewer.article.cannotDoReview"} {icon name="mail" disabled="disabled" url=$declineUrl}
                        {/if}
                    {else}
                        {if $undergoingAssignment->getDeclined() != '1'}{translate key="submission.accepted"}{else}{translate key="submission.rejected"}{/if}
                    {/if}
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            {if $journal->getLocalizedSetting('reviewGuidelines') != ''}
                <tr valign="top">
                <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                    <td><span class="instruct">{translate key="reviewer.article.consultGuidelines"}</span></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            {/if}
            <tr valign="top">
                <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                <td><span class="instruct">{translate key="reviewer.article.downloadSubmission"}</span></td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            {if $currentJournal->getSetting('requireReviewerCompetingInterests')}
                <tr valign="top">
                    <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                    <td>
                        {url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}
                        <span class="instruct">{translate key="reviewer.article.enterCompetingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</span>
                        {if not $confirmedStatus or $declined or $undergoingAssignment->getCancelled() or $undergoingAssignment->getRecommendation()}<br/>
                            {$undergoingAssignment->getCompetingInterests()|strip_unsafe_html|nl2br}
                        {else}
                            <form action="{url op="saveCompetingInterests" reviewId=$reviewId}" method="post">
                                <textarea {if $cannotChangeCI}disabled="disabled" {/if}name="competingInterests" class="textArea" id="competingInterests" rows="5" cols="40">{$undergoingAssignment->getCompetingInterests()|escape}</textarea><br />
                                <input {if $cannotChangeCI}disabled="disabled" {/if}class="button defaultButton" type="submit" value="{translate key="common.save"}" />
                            </form>
                        {/if}
                    </td>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            {/if}{* $currentJournal->getSetting('requireReviewerCompetingInterests') *}

            {if $undergoingAssignment->getReviewFormId()}
                <tr valign="top">
                    <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                    <td><span class="instruct">{translate key="reviewer.article.enterReviewForm"}</span></td>
                </tr>
                <tr valign="top">
                    <td>&nbsp;</td>
                    <td>
                        {translate key="submission.reviewForm"} 
                        {if $confirmedStatus and not $declined}
                            <a href="{url op="editReviewFormResponse" path=$reviewId|to_array:$undergoingAssignment->getReviewFormId()}" class="icon">{icon name="comment"}</a>
                        {else}
                            {icon name="comment" disabled="disabled"}
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            {else}
                <tr valign="top">
                    <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                    <td><span class="instruct">{translate key="reviewer.article.enterReviewA"}</span></td>
                </tr>
                <tr valign="top">
                    <td>&nbsp;</td>
                    <td>
                        {translate key="common.chatRoom"}&nbsp; 
                        {if $confirmedStatus and not $declined}
                            <a href="javascript:openComments('{url op="viewPeerReviewComments" path=$articleId|to_array:$reviewId}');" class="icon">{icon name="comment"}</a>
                        {else}
                            {icon name="comment" disabled="disabled"}
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            {/if}
            <tr valign="top">
                <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                <td><span class="instruct">{translate key="reviewer.article.uploadFile"}</span></td>
            </tr>
            <tr valign="top">
                <td>&nbsp;</td>
                <td>
                    <table class="data" width="100%">
                        {assign var="reviewerFile" value=$undergoingAssignment->getReviewerFile()}
                        {if $reviewerFile}
                            {assign var=uploadedFileExists value="1"}
                            <tr valign="top">
                                <td class="label" width="20%">
                                    {translate key="reviewer.article.uploadedFile"}
                                </td>
                                <td class="value" width="80%">
                                    <a href="{url op="downloadFile" path=$articleId|to_array:$reviewerFile->getFileId():$undergoingAssignment->getReviewId()}" class="file">{$reviewerFile->getFileName()|escape}</a>
                                    &nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatLong}&nbsp;
                                    {if ($undergoingAssignment->getRecommendation() === null || $undergoingAssignment->getRecommendation() === '') && (!$undergoingAssignment->getCancelled())}
                                        <a class="action" href="{url op="deleteReviewerVersion" path=$reviewId|to_array:$reviewerFile->getFileId():$articleId}">{translate key="common.delete"}</a>
                                    {/if}
                                </td>
                            </tr>
                        {else}
                            <tr valign="top">
                                <td class="label" width="20%">
                                    {translate key="reviewer.article.uploadedFile"}
                                </td>
                                <td class="nodata">
                                    {translate key="common.none"}
                                </td>
                            </tr>
                        {/if}
                    </table>
                    &nbsp;
                    {if $undergoingAssignment->getRecommendation() === null || $undergoingAssignment->getRecommendation() === ''}
                        <form method="post" action="{url op="uploadReviewerVersion"}" enctype="multipart/form-data">
                            <input type="hidden" name="reviewId" value="{$reviewId|escape}" />
                            <input type="file" name="upload" {if not $confirmedStatus or $declined or $undergoingAssignment->getCancelled()}disabled="disabled"{/if} class="uploadField" />
                            <input type="submit" name="submit" value="{if $uploadedFileExists}{translate key="common.replaceFile"}{else}{translate key="common.upload"}{/if}" {if not $confirmedStatus or $declined or $undergoingAssignment->getCancelled()}disabled="disabled"{/if} class="button" />
                        </form>

                        {if $currentJournal->getSetting('showEnsuringLink')}
                            <span class="instruct">
                                <a class="action" href="javascript:openHelp('{get_help_id key="editorial.sectionEditorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.article.ensuringBlindReview"}</a>
                            </span>
                        {/if}
                    {/if}
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr valign="top">
                <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
                <td><span class="instruct">{translate key="reviewer.article.selectRecommendation"}</span></td>
            </tr>
            <tr valign="top">
                <td>&nbsp;</td>
                <td>
                    <table class="data" width="100%">
                        <tr valign="top">
                            <td class="label" width="30%">{translate key="submission.recommendation"}</td>
                            <td class="value" width="70%">
                                {if $undergoingAssignment->getRecommendation() !== null && $undergoingAssignment->getRecommendation() !== ''}
                                    {assign var="recommendation" value=$submission->getRecommendation()}
                                    <strong>{translate key=$reviewerRecommendationOptions.$recommendation}</strong>&nbsp;&nbsp;
                                    {$undergoingAssignment->getDateCompleted()|date_format:$dateFormatShort}
                                {else}
                                    <form name="recommendation" method="post" action="{url op="recordRecommendation"}">
                                        <input type="hidden" name="reviewId" value="{$reviewId|escape}" />
                                        <select name="recommendation" {if not $confirmedStatus or $declined or $undergoingAssignment->getCancelled() or (!$reviewFormResponseExists and !$uploadedFileExists)}disabled="disabled"{/if} class="selectMenu">
                                            {html_options_translate options=$reviewerRecommendationOptions selected=''}
                                        </select>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="submit" name="submit" onclick="return confirmSubmissionCheck()" class="button" value="{translate key="reviewer.article.submitReview"}" {if not $confirmedStatus or $declined or $undergoingAssignment->getCancelled() or (!$reviewFormResponseExists and !$undergoingAssignment->getMostRecentPeerReviewComment() and !$uploadedFileExists)}disabled="disabled"{/if} />
                                    </form>					
                                {/if}
                            </td>		
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>


    <div class="separator"></div>

{/if}

{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
	<div class="separator"></div>

	<div id="reviewerGuidelines">
		<h3>{translate key="reviewer.article.reviewerGuidelines"}</h3>
		<p>{$journal->getLocalizedSetting('reviewGuidelines')|nl2br}</p>
	</div>
{/if}



