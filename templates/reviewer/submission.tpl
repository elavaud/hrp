{**
 * submission.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the reviewer administration page.
 *
 * FIXME: At "Notify The Editor", fix the date.
 *
 * $Id$
 *}
{strip}
    {assign var="articleId" value=$submission->getProposalId()}
    {translate|assign:"pageTitleTranslated" key="reviewer.article.$pageToDisplay" id=$articleId}
    {assign var="pageCrumbTitle" value="reviewer.article.$pageToDisplay"}
    {include file="common/header.tpl"}
{/strip}

<ul class="menu">
    <li{if ($pageToDisplay == "submissionSummary")} class="current"{/if}><a href="{url op="submission" path=$submission->getArticleId()|to_array:"submissionSummary"}">{translate key="reviewer.article.submissionSummary"}</a></li>
    <li{if ($pageToDisplay == "submissionReview")} class="current"{/if}><a href="{url op="submission" path=$submission->getArticleId()|to_array:"submissionReview"}">{translate key="reviewer.article.submissionReview"}</a></li>
</ul>


<script type="text/javascript">
    {literal}
        <!--
        function confirmSubmissionCheck() {
            if (document.recommendation.recommendation.value=='') {
                alert('{/literal}{translate|escape:"javascript" key="reviewer.article.mustSelectDecision"}{literal}');
                return false;
            }
            return confirm('{/literal}{translate|escape:"javascript" key="reviewer.article.confirmDecision"}{literal}');
        }

        $(document).ready(function() {
            $( "#proposedDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-6 m'});
        });
        // -->
    {/literal}
</script>

<div id="submissionToBeReviewed">
    <h3>{translate key="reviewer.article.submissionToBeReviewed"}</h3>
    <table width="100%" class="data">
        <tr valign="top">
            <td width="20%" class="label">{translate key="common.proposalId"}</td>
            <td width="80%" class="value">{$submission->getProposalId()|strip_unsafe_html}</td>
        </tr>
        <tr valign="top">
            <td width="20%" class="label">{translate key="article.title"}</td>
            <td width="80%" class="value">{$abstract->getScientificTitle()|strip_unsafe_html}</td>
        </tr>
        <tr valign="top">
            <td class="label">{translate key="article.journalSection"}</td>
            <td class="value">{$submission->getSectionTitle()|escape}</td>
        </tr>
    </table>
</div>

<div class="separator"></div>

<div id="files">
    {assign var="articleId" value=$submission->getArticleId()}

    <h3>{translate key="article.files"}</h3>
    <table width="100%" class="data">
        {if ($confirmedStatus and not $declined) or not $journal->getSetting('restrictReviewerFileAccess')}
            <tr valign="top">
                <td title="{translate key="submission.originalFileInstruct"}" width="20%" class="label">[?] {translate key="submission.submissionManuscript"}</td>
                <td class="value" width="80%">
                    {if $reviewFile}
                        <a href="{url op="downloadFile" path=$articleId|to_array:$reviewFile->getFileId()}" class="file">{$reviewFile->getFileName()|escape}</a>
                        &nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatShort}
                    {else}
                        {translate key="common.none"}
                    {/if}
                </td>
            </tr>
            {if count($previousFiles)>1}
                {assign var="count" value=0}
                <tr>
                    <td title="{translate key="submission.previousProposalFileInstruct"}" class="label">[?] {translate key="submission.previousProposalFile"}</td>
                    <td width="80%" class="value">
                        {foreach name="previousFiles" from=$previousFiles item=previousFile}
                            {assign var="count" value=$count+1}
                            {if $count > 1}
                                <a href="{url op="downloadFile" path=$articleId|to_array:$previousFile->getFileId()}" class="file">{$previousFile->getFileName()|escape}</a><br />
                            {/if}
                        {/foreach}
                    </td>
                </tr>
            {/if}
            <tr valign="top">
                <td  title="{translate key="article.suppFilesAbbrevInstruct"}" class="label">[?] {translate key="article.suppFiles"}</td>
                <td class="value">
                    {assign var=sawSuppFile value=0}
                    {foreach from=$suppFiles item=suppFile}
                        {if $suppFile->getShowReviewers() }
                            {assign var=sawSuppFile value=1}
                            <a href="{url op="downloadFile" path=$articleId|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a><cite>&nbsp;&nbsp;({$suppFile->getType()})</cite><br />
                        {/if}
                    {/foreach}
                    {if !$sawSuppFile}
                        {translate key="common.none"}
                    {/if}
                </td>
            </tr>
        {else}
            <tr><td class="nodata">{translate key="reviewer.article.restrictedFileAccess"}</td></tr>
        {/if}

        <tr>
            <td class="label" title="{translate key="article.reports.instruct"}">[?] {translate key="article.reports"}</td>
            <td width="80%" class="value">
                {foreach name="reportFiles" from=$reportFiles item=reportFile}
                    <a href="{url op="downloadFile"  path=$articleId|to_array:$reportFile->getFileId()}" class="file">{$reportFile->getFileName()|escape}</a>&nbsp;&nbsp;({$reportFile->getDateUploaded()|date_format:$datetimeFormatLong})
                    <br />
                {foreachelse}
                    {translate key="common.none"}
                {/foreach}
            </td>
        </tr>  
        
        <tr>
            <td class="label" title="{translate key="article.sae.instruct"}">[?] {translate key="article.sae"}</td>
            <td width="80%" class="value">
                {foreach name="saeFiles" from=$saeFiles item=saeFile}
                    <a href="{url op="downloadFile"  path=$articleId|to_array:$saeFile->getFileId()}" class="file">{$saeFile->getFileName()|escape}</a>&nbsp;&nbsp;({$saeFile->getDateUploaded()|date_format:$datetimeFormatLong})
                    <br />
                {foreachelse}
                    {translate key="common.none"}
                {/foreach}
            </td>
        </tr>          
    </table>
</div>

<div class="separator"></div>

{include file="reviewer/$pageToDisplay.tpl"}

{include file="common/footer.tpl"}


