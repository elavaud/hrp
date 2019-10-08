{**
 * manageOtherExtraFieldsForm.tpl
 *
 * Form for replacing the "other" fields (research fields, proposal types), manually entered by submitters of research proposals
 *
 * $Id$
 *}
{strip}
    {assign var="pageTitle" value="manager.extraFields.others"}
    {assign var="pageCrumbTitle" value="manager.extraFields.others"}
    {include file="common/header.tpl"}
{/strip}

{literal}
     <script type="text/javascript">
         
        var confirmMessage = "{/literal}{translate key="manager.extraFields.others.warning"}{literal}";
                
        $(document).ready(
            function() {
                $('#deleteButton').click(function () {return confirm(confirmMessage);});
            }
        );
    </script>
{/literal}

<form name="manageOthers" method="post" action="{url op="manageOthers" path=$type}">
    {include file="common/formErrors.tpl"}
    
    <p>{translate key=$pageInfo}</p>
    
    <div id="replaceOtherFieldForm">
        <table class="listing" width="100%">
            {assign var="position" value="left"}
            {foreach from=$otherFields key=otherFieldKey item=otherFieldValue}
                {if $position == "left"}
                <tr valign="top">
                    <td width="20%" align="left"><input type="checkbox" name="selectedOtherFields[]" value="{$otherFieldKey}" />{$otherFieldValue}</td>
                    {assign var="position" value="middle"}
                {elseif $position == "middle"}
                    <td width="20%" align="left"><input type="checkbox" name="selectedOtherFields[]" value="{$otherFieldKey}" />{$otherFieldValue}</td>
                    {assign var="position" value="right"}
                {else}
                    <td width="20%" align="left"><input type="checkbox" name="selectedOtherFields[]" value="{$otherFieldKey}" />{$otherFieldValue}</td>
                    <td width="40%" align="left">&nbsp;</td>
                    {assign var="position" value="left"}
                </tr>
                {/if}
            {/foreach}
            {if $position == "middle"}
                <td width="20%" align="left">&nbsp;</td>
                <td width="20%" align="left">&nbsp;</td>
                <td width="40%" align="left">&nbsp;</td>
            </tr>
            {elseif $position == "right"}
                <td width="20%" align="left">&nbsp;</td>
                <td width="40%" align="left">&nbsp;</td>
            </tr>
            {/if}
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceField">
                <td width="20%" class="label">{fieldLabel name="replacement" required="true" key="manager.extraFields.replacement"}</td>
                <td colspan="3" class="value">
                    <select name="replacement" id="replacement" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$extraFieldsList selected=$replacement}
                    </select>
                </td>
            </tr>
        </table>
    </div>

<p><input type="submit" value="{translate key="manager.extraFields.replace"}" id="deleteButton" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="extraFields" path="$type" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

{include file="common/footer.tpl"}