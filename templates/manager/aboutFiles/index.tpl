{**
 * index.tpl
 *
 * About Files manager.
 *
 *}
{strip}
	{assign var="pageTitle" value="manager.aboutFiles"}
	{include file="common/header.tpl"}
{/strip}

<p>{translate key="manager.aboutFiles.description"}</p>

<div id="files">
	<h3>{translate key="common.file.s"}</h3>
	<table class="listing" width="100%">
		<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
		<tr>
			<td width="35%">{translate key="common.originalFileName"}</td>
			<td width="35%">{translate key="common.fileName"}</td>
			<td width="15%">{translate key="common.fileType"}</td>
			<td width="15%">{translate key="common.action"}</td>
		</tr>
		<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
		{iterate from=files item=file}
			<tr>
				<td>{$file->getAboutFileOriginalName()|strip_unsafe_html|truncate:60:"..."}</td>
				<td><a href="{url op="aboutFileDownload" path=$file->getId()}">{$file->getLocalizedAboutFileName()|strip_unsafe_html|truncate:60:"..."}</a></td>
				<td>{translate key=$file->getAboutFileTypeKey()|escape}</td>
				<td><a href="{url op="aboutFileEdit" path=$file->getId()}" class="action" >{translate key="common.edit"}</a> || <a href="{url op="aboutFileDelete" path=$file->getId()}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="manager.aboutFiles.delete"}')">{translate key="common.delete"}</a></td>
			</tr>
    		<tr>
				<td colspan="4" class="{if $files->eof()}end{/if}separator">&nbsp;</td>
			</tr>
		{/iterate}
		{if $files->wasEmpty()}
			<tr>
				<td colspan="4" class="nodata">{translate key="manager.files.emptyDir"}</td>
			</tr>
			<tr>
				<td colspan="4" class="endseparator">&nbsp;</td>
			</tr>
		{else}
			<tr>
				<td colspan="2" align="left">{page_info iterator=$files}</td>
				<td colspan="2" align="right">{page_links anchor="files" name="files" iterator=$files}</td>
			</tr>
		{/if}
	</table>
</div>

<p><a href="{url op="aboutFileEdit"}" class="action" >{translate key="manager.aboutFiles.uploadNewFile"}</a></p>

{include file="common/footer.tpl"}

