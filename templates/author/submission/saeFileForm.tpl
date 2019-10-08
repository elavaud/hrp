{**
 * saeFileForm.tpl
 *
 * Submit a Serious Adverse Event file.
 *
 * $Id$
 *}

{strip}
    {assign var="pageTitle" value="author.submit.submitSAE"}
    {assign var="pageCrumbTitle" value="author.submit.submitSAE.short"}
    {include file="common/header.tpl"}
{/strip}

{literal}
    <script type="text/javascript">
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

<form name="reportFile" method="post" action="{url page=$rolePath op="saveAdverseEvent" path=$fileId}" onSubmit="return checkSize()" enctype="multipart/form-data">
    
    <input type="hidden" name="articleId" value="{$articleId|escape}" />
    <input type="hidden" name="from" value="{$from|escape}" />
    
    {include file="common/formErrors.tpl"}

    <p>{$saeGuidelines}</p>
    
    <div id="fileUpload">
        <table width="100%" class="data">
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