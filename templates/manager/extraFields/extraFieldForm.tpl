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
    {assign var="pageTitle" value="$pageTitle"}
    {assign var="pageCrumbTitle" value="$pageTitle"}
    {include file="common/header.tpl"}
{/strip}


 <form name="externalField" method="post" action="{url op="updateExtraField" path=$type|to_array:$extraFieldId}">
    {if $warning != null}<p>{translate key=$warning}</p>{/if}
    {include file="common/formErrors.tpl"}
    <div id="extraFieldForm">
        <table class="data" width="100%">
            {foreach from=$locales item=localeName key=localeKey}
                {assign var="extraFieldName" value=$extraFieldNames[$localeKey]}
                <tr valign="top">
                        <td width="20%" class="label">{$localeName} {fieldLabel name="extraFieldName" required="true" key="common.name"}</td>
                        <td width="80%" class="value"><input type="text" name="extraFieldNames[{$localeKey|escape}]" value="{$extraFieldName|escape}" id="extraFieldName" size="40" maxlength="120" class="textField" /></td>
                </tr>
            {/foreach}
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="active" required="true" key="common.active"}</td>
                <td width="80%" class="value">
                    {html_radios name='active' options=$yesNoArray selected=$active separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
                </td>
            </tr>    
            <tr><td>&nbsp;</td><td><span><i>{translate key="manager.extraFields.active.definition"}</i></span></td></tr>
        </table>
    </div>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="extraFields" path="$type" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}

