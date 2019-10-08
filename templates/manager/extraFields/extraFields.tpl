{**
 * extraFields.tpl
 *
 * Display list of extra fields according the type selected.
 *
 * $Id$
 *}

 {strip}
    {assign var="pageTitle" value="$pageTitle"}
    {include file="common/header.tpl"}
{/strip}

<br/>

<div id="extraFields">
    <table width="100%" class="listing" id="dragTable">
	<tr>
            <td class="headseparator" colspan="3">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
            <td width="70%">{translate key="common.name"}</td>
            <td width="15%">{translate key="common.active"}</td>
            <td width="15%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
            <td class="headseparator" colspan="3">&nbsp;</td>
	</tr>
        {iterate from=extraFields item=extraField name=extraField}
            <tr valign="top" class="data">
                <td class="drag">{$extraField->getLocalizedExtraFieldName()}</td>
                <td class="drag">{translate key=$extraField->getExtraFieldActiveKey()}</td>
                <td align="right" class="nowrap">
                    <a href="{url op='editExtraField' path=$type|to_array:$extraField->getExtraFieldId()}" class="action">{translate key="common.edit"}</a>
                    &nbsp;|&nbsp;
                    <a href="{url op='deleteExtraFieldForm' path=$type|to_array:$extraField->getExtraFieldId()}" class="action">{translate key="common.delete"}</a>
                    &nbsp;
                </td>
            </tr>
        {/iterate}
	<tr>
            <td colspan="3" class="endseparator">&nbsp;</td>
	</tr>
        {if $extraFields->wasEmpty()}
            <tr>
                <td colspan="3" class="nodata">{translate key="common.none"}</td>
            </tr>
            <tr>
                <td colspan="3" class="endseparator">&nbsp;</td>
            </tr>
        {else}
            <tr>
                <td align="left">{page_info iterator=$extraFields}</td>
                <td colspan="3" align="right">{page_links anchor="extraFields" name="extraFields" iterator=$extraFields type=$type}</td>
            </tr>
        {/if}
    </table>
    <br><a class="action" href="{url op="editExtraField" path=$type}">{translate key=$newExtraField}</a>
    {if $type == 'researchFields' || $type == 'proposalTypes'}
        &nbsp;&nbsp;||&nbsp;&nbsp;
        <a class="action" href="{url op="manageOthersForm" path=$type}">{translate key="manager.extraFields.others"}</a>&nbsp;{translate key="manager.extraFields.others.def"}
    {/if}
</div>

{include file="common/footer.tpl"}