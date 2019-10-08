{**
 * institutionForm.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form to create/modify an institution
 *
 *	Last updated by	JAA March 11, 2013
 * $Id$
 *}
{strip}
	{assign var="pageTitle" value="manager.aboutFiles.aboutFile"}
	{assign var="pageCrumbTitle" value="manager.aboutFiles.aboutFile"}
	{include file="common/header.tpl"}
{/strip}

{literal}
<script type="text/javascript">
function checkSize(){
	var fileToUpload = document.getElementById('aboutFileUpload');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880 && ($('input[name^="name"]:checked').val() != '') && ($('input[name^="type"]:checked').val() != '')){
		alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
		return false
	}
}
</script>
{/literal}

<form name="aboutFile" method="post" action="{url op="updateAboutFile" path="$aboutFileId"}" enctype="multipart/form-data">

	{include file="common/formErrors.tpl"}
	<div id="aboutFileForm">
		<table class="data" width="100%">
			<!--
			{if count($formLocales) > 1}
				<tr valign="top">
					<td width="20%" class="label">{fieldLabel name="formLocale" key="form.formLanguage"}</td>
					<td width="80%" class="value">
						{if $aboutFileId}{url|assign:"aboutFileFormUrl" op="aboutFileEdit" path=$aboutFileId escape=false}
						{else}{url|assign:"aboutFileFormUrl" op="aboutFileEdit" path=$aboutFileId escape=false}
						{/if}
						{form_language_chooser form="aboutFile" url=$aboutFileFormUrl}
						<span class="instruct">{translate key="form.formLanguage.description"}</span>
					</td>
				</tr>
			{/if}
			-->
			{foreach from=$abstractLocales item=localeName key=localeKey}
				{assign var="aboutFileName" value=$aboutFileNames[$localeKey]}
				<tr valign="top">
					<td width="20%" class="label">{$localeName} {fieldLabel name="aboutFileName" required="true" key="manager.aboutFiles.name"}</td>
					<td width="80%" class="value"><input type="text" name="aboutFileNames[{$localeKey|escape}][name]" value="{$aboutFileName.name|escape}" id="name" size="40" maxlength="120" class="textField" /></td>
				</tr>
				{assign var="aboutFileDescription" value=$aboutFileDescriptionArray[$localeKey]}
				<tr valign="top">
					<td width="20%" class="label">{$localeName} {fieldLabel name="aboutFileDescription" key="manager.aboutFiles.fileDescription"}</td>
                                        <td width="80%" class="value"><textarea name="aboutFileDescriptionArray[{$localeKey|escape}][description]" id="description"  rows="3" cols="40" maxlength="600" class="textArea">{$aboutFileDescription.description|escape}</textarea></td>
				</tr>
			{/foreach}
			<tr valign="top">
				<td class="label">{fieldLabel name="type" required="true" key="manager.aboutFiles.type"}</td>
				<td class="value">
					<select name="type" size="1" id="type" class="selectMenu">
						{html_options_translate options=$aboutFileTypes selected=$type}
					</select>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="submissionFile">
		<table class="data" width="100%">
			{if $aboutFile}
				<tr valign="top">
					<td width="20%" class="label">{translate key="common.originalFileName"}</td>
					<td width="80%" class="value"><a href="{url op="aboutFileDownload" path=$aboutFile->getId()}">{$aboutFile->getAboutFileOriginalName()|escape}</a></td>
				</tr>
				<tr valign="top">
					<td width="20%" class="label">{translate key="common.fileSize"}</td>
					<td width="80%" class="value">{$aboutFile->getNiceFileSize()}</td>
				</tr>
			{else}
				<tr valign="top">
					<td colspan="2" class="nodata">{translate key="manager.aboutFiles.noFile"}</td>
				</tr>
			{/if}
		</table>
	</div>

	<div class="separator"></div>

	<div id="addUploadFile">
		<table class="data" width="100%">
			<tr>
				<td width="30%" class="label">
					{if $aboutFile}
						{fieldLabel name="aboutFile" key="manager.aboutFiles.replaceFile"}
					{else}
						{fieldLabel name="aboutFile" key="manager.aboutFiles.uploadNewFile"}
					{/if}
				</td>
				<td width="70%" class="value">
					<input type="file" class="uploadField" name="aboutFile" id="aboutFileUpload" /> 
					<input name="uploadAboutFile" type="submit" class="button" value="{translate key="common.upload"}"/>
				</td>
			</tr>
			<tr>
		</table>
	</div>

	<div class="separator"></div>
	
	<p>
	<input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> 
	<input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="aboutFiles" escape=false}'" />
	</p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}

