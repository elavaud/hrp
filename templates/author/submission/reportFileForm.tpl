{**
 * reportFileForm.tpl
 *
 * Submit a report file.
 *
 * $Id$
 *}

{strip}
    {if $type == "progress"}
        {assign var="pageTitle" value="author.submit.addProgressReport"}
        {assign var="pageCrumbTitle" value="submission.progressReports"}
    {else}
        {if $status == STATUS_COMPLETED}
            {assign var="pageTitle" value="author.submit.modifyCompletionReport"}
            {assign var="pageCrumbTitle" value="submission.completionReports"}
        {else}
            {assign var="pageTitle" value="author.submit.addCompletionReport"}
            {assign var="pageCrumbTitle" value="submission.completionReports"}
        {/if}
    {/if}
    {include file="common/header.tpl"}
{/strip}

{literal}
    <script type="text/javascript">
        $(document).ready(function() {
           $('#fileType').change(function(){
                var isOtherSelected = false;
                $.each($('#fileType').val(), function(key, value){
                    if(value == "{/literal}{translate key="common.other"}{literal}") {
                        isOtherSelected = true;
                    }
                });
                if(isOtherSelected) {
                    $('#divOtherFileType').show();
                } else {
                    $('#divOtherFileType').hide();
                }
            });
        });

        function checkSize(){
                var fileToUpload = document.getElementById('uploadReportFile');
                var check = fileToUpload.files[0].fileSize;
                var valueInKb = Math.ceil(check/1024);
                if (check > 5242880){
                        alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
                        return false
                } 
        }
    </script>
{/literal}

<form name="reportFile" method="post" action="{url page=$rolePath op="saveReportFile" path=$fileId}" onSubmit="return checkSize()" enctype="multipart/form-data">
    
    <input type="hidden" name="articleId" value="{$articleId|escape}" />
    <input type="hidden" name="from" value="{$from|escape}" />
    <input type="hidden" name="type" value="{$type|escape}" />
    
    {include file="common/formErrors.tpl"}

    <p>{if $type == "progress"}{$progressReportGuidelines}{else}{$completionReportGuidelines}{/if}</p>
    
    <div id="fileUpload">
        <table id="showReviewers" width="100%" class="data">
            <tr valign="top">
                <td class="label">
                    {fieldLabel name="uploadReportFile" key="common.upload"}
                </td>
                <td class="value" colspan="2">
                    <input type="file" name="uploadReportFile" id="uploadReportFile" class="uploadField" />&nbsp;&nbsp;{translate key="author.submit.supplementaryFiles.saveToUpload"}
                </td>
            </tr>
        </table>
    </div>

    <div class="separator"></div>

    <p>
        <input type="submit" value="{translate key="common.save"}" class="button defaultButton" id="saveButton" /> 
        <input type="button" value="{translate key="common.cancel"}" class="button" onclick="history.go(-1)" />
    </p>

    <p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</form>

{include file="common/footer.tpl"}