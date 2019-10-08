{**
 * extraFieldDeleteForm.tpl
 *
 * Form for deleting / replacing an extrafield
 *
 * $Id$
 *}
{strip}
    {assign var="pageTitle" value="$pageTitle"}
    {assign var="pageCrumbTitle" value="$pageTitle"}
    {include file="common/header.tpl"}
{/strip}

{literal}
     <script type="text/javascript">
         
        var countProposals = "{/literal}{$countProposals}{literal}";
        var countInstitutions = "{/literal}{$countInstitutions}{literal}";
        var countCommittees = "{/literal}{$countCommittees}{literal}";
        var confirmMessage = "{/literal}{translate key=$replacementWarning}{literal}";
                
        $(document).ready(
            function() {
                if (countProposals > 0 || countInstitutions > 0 || countCommittees > 0) {
                    $('#replaceMessage').show();
                    $('#replaceWarning').show();
                    $('#replaceField').show();
                    if ($('#replacement option[value="NA"]').length > 0){
                        $('#replacement option[value="NA"]').remove();
                    }
                } else {
                 
                    $('#replaceMessage').hide();
                    $('#replaceWarning').hide();
                    $('#replaceField').hide();            
                    if (!$('#replacement option[value="NA"]').length > 0){
                        $('#replacement').append('<option value="NA"></option>');
                    }
                    $('#replacement').val('NA');            
                }
                
                $('#deleteButton').click(function () {return confirm(confirmMessage);});
            }
        );
    </script>
{/literal}

<form name="deleteExtraField" method="post" action="{url op="deleteExtraField" path=$type|to_array:$extraFieldId}">
    {include file="common/formErrors.tpl"}
    
    <h3>{$extraFieldToDelete->getLocalizedExtraFieldName()}</h3>
    <p><i>{translate key="common.active"}:&nbsp;{translate key=$extraFieldToDelete->getExtraFieldActiveKey()}</i></p>
    
    <div id="institutionForm">
        <table class="data" width="100%">
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top">
                <td width="50%" class="label">{fieldLabel name="countKII" key="manager.extraFields.replacement.proposalsNumber"}</td>
                <td width="50%" class="value">{$countProposals}</td>
            </tr>
            {if $type == 'geoAreas'}
                <tr valign="top">
                    <td width="50%" class="label">{fieldLabel name="countKII" key="manager.extraFields.replacement.institutionsNumber"}</td>
                    <td width="50%" class="value">{$countInstitutions}</td>
                </tr>
                <tr valign="top">
                    <td width="50%" class="label">{fieldLabel name="countKII" key="manager.extraFields.replacement.committeesNumber"}</td>
                    <td width="50%" class="value">{$countCommittees}</td>
                </tr>                
            {/if}
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceMessage">
                <td colspan="2">{translate key=$replacementMessage}</td>
            </tr>
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceWarning">
                <td colspan="2"><b><font color="red">{translate key=$replacementWarning}</font></b></td>
            </tr>
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceField">
                <td width="20%" class="label">{fieldLabel name="replacement" required="true" key="manager.extraFields.replacement"}</td>
                <td width="80%" class="value">
                    <select name="replacement" id="replacement" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$extraFieldsList selected=$replacement}
                    </select>
                </td>
            </tr>
        </table>
    </div>

<p><input type="submit" value="{translate key="common.delete"}" id="deleteButton" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="extraFields" path="$type" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

{include file="common/footer.tpl"}