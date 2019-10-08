{include file="sectionEditor/minutes/menu.tpl"}

{literal}
    <script type="text/javascript">
        function checkSize(){
            var fileToUpload = document.getElementById('uploadMinutesFile');
            var check = fileToUpload.files[0].fileSize;
            var valueInKb = Math.ceil(check/1024);
            if (check > 5242880){
                alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
                return false
            }
        }
    </script>
{/literal}

<br/>

<h3>{translate key="editor.meeting.details"}</h3>
<div class="separator"></div>
<div id="details">
    <table width="100%" class="data">
        <tr>
            <td class="label" width="20%">{translate key="editor.meeting.id"}</td>
            <td class="value" width="80%"><a href="{url op="viewMeeting" path=$meeting->getId()}">#{$meeting->getPublicId()}</a></td>
        </tr>
        <tr>
            <td class="label" width="20%">{translate key="editor.meeting.schedule"}</td>
            <td class="value" width="80%">{$meeting->getDate()|date_format:$dateFormatLong}</td>
        </tr>
        <tr>
            <td class="label" width="20%">{translate key="editor.meeting.status"}</td>
            <td class="value" width="80%">{$meeting->getStatusKey()}</td>
        </tr>
        <tr>
            <td class="label" width="20%">{translate key="editor.minutes.status"}</td>
            <td class="value" width="80%">
                {$meeting->getMinutesStatusKey()}							
            </td>
        </tr>
    </table>
</div>

<br/>

<div id="sections">
    {assign var="statusMap" value=$meeting->getStatusMap()}
    <h3>{translate key="editor.minutes.files"}</h3>
    <form method="post" action="{url op="uploadFile" path=$meeting->getId()|to_array:1}" enctype="multipart/form-data">
        <table class="listing" width="100%">
            <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
            <tr class="heading" valign="bottom">
                <td width="20%">{translate key="common.type"}</td>
                <td width="50%">{translate key="common.file.s"}</td>
                <td width="30%" align="right">{translate key="common.action"}</td>
            </tr>
            <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
            <tr valign="bottom">
                <td>{translate key="editor.minutes.template"}</td>
                <td colspan="2">
                    <a href="{url op="donwloadMinutesTemplate" path=$meeting->getId()}">{translate key="editor.minutes.downloadTemplate"}</a>
                </td>
            </tr>
            <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
            <tr valign="bottom">
                <td width="20%">{translate key="editor.minutes.attendance"}</td>
                <td width="50%">
                    {if $generatedAttendanceFile}
                        <a href="{url op="downloadMinutes" path=$meeting->getId()|to_array:$generatedAttendanceFile->getFileId()}">{$generatedAttendanceFile->getFileName()}</a>
                    {else}
                        {translate key="editor.minutes.noFileGenerated"}
                    {/if}
                </td>
                <td width="30%" align="right">
                    <a href="{url op="generateAttendance" path=$meeting->getId()}">{if $generatedAttendanceFile}{translate key="editor.minutes.replaceAttendance"}{else}{translate key="editor.minutes.generateAttendance"}{/if}</a>
                </td>
            </tr>
            <tr><td colspan="3" class="separator">&nbsp;</td></tr>
            {assign var=countUpFile value=0}
            {foreach from=$uploadedAttendanceFiles item=uploadedAttendanceFile}
                {assign var=countUpAttFile value=$countUpAttFile+1}
                <tr valign="bottom">
                    <td width="20%">{if $countUpAttFile == 1}{translate key="editor.minutes.uploaded"}{else}&nbsp;{/if}</td>
                    <td width="50%">
                        <a href="{url op="downloadMinutes" path=$meeting->getId()|to_array:$uploadedAttendanceFile->getFileId()}">{$uploadedAttendanceFile->getFileName()}</a>
                    </td>
                    <td width="30%" align="right">
                        <a href="{url op="deleteUploadedFile" path=$meeting->getId()|to_array:$uploadedAttendanceFile->getFileId()}">{translate key="common.delete"}</a>
                    </td>
                </tr>
            {foreachelse}
                <tr valign="bottom">
                    <td width="20%">{translate key="editor.minutes.uploaded"}</td>
                    <td colspan="2">
                        {translate key="editor.minutes.noFileUploaded"}
                    </td>
                </tr>
            {/foreach}
            <tr><td>&nbsp;</td><td colspan="2" class="separator">&nbsp;</td></tr>
            <tr valign="bottom">
                <td width="20%">&nbsp;</td>
                <td width="50%">
                    <input type="file" name="uploadMinutesFile" id="uploadMinutesFile"  class="uploadField" />
                </td>
                <td width="30%" align="right">
                    <input name="submitUploadMinutesFile" type="submit" class="button" value="{translate key="common.upload"}" />
                </td>
            </tr>
            <tr><td colspan="3" class="endseparator">&nbsp;</td></tr>	
        </table>
    </form>
</div>
<br/>
{if $meeting->isMinutesComplete()}
	<input type="button" value="{translate key="editor.minutes.setFinalAndDownload"}" class="button defaultButton" onclick="document.location.href='{url op="downloadMinutes" path=$meeting->getId() }'" />		
{/if}
<input type="button" class="button" onclick="document.location.href='{url op="viewMeeting" path=$meeting->getId()}'" value="{translate key="common.back"}" />
{include file="common/footer.tpl"}
