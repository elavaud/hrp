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
    {assign var="pageTitle" value="institution.delete"}
    {assign var="pageCrumbTitle" value="institution.delete"}
    {include file="common/header.tpl"}
{/strip}

{literal}
     <script type="text/javascript">
         
        var countKII = "{/literal}{$countKII}{literal}";
        var countSources = "{/literal}{$countSources}{literal}";
        var confirmMessage = "{/literal}{translate key="institution.delete.replacementWarning"}{literal}";
                
        $(document).ready(
            function() {
                if (countKII > 0 || countSources > 0) {
                    $('#replaceInstitutionMessage').show();
                    $('#replaceInstitutionWarning').show();
                    $('#replaceInstitutionField').show();
                    if ($('#replacementInstitution option[value="NA"]').length > 0){
                        $('#replacementInstitution option[value="NA"]').remove();
                    }
                } else {
                 
                    $('#replaceInstitutionMessage').hide();
                    $('#replaceInstitutionWarning').hide();
                    $('#replaceInstitutionField').hide();            
                    if (!$('#replacementInstitution option[value="NA"]').length > 0){
                        $('#replacementInstitution').append('<option value="NA"></option>');
                    }
                    $('#replacementInstitution').val('NA');            
                }
                
                $('#deleteButton').click(function () {return confirm(confirmMessage);});
            }
        );
    </script>
{/literal}

<form name="institutionDelete" method="post" action="{url op="deleteInstitution" path="$institutionId"}">
    {include file="common/formErrors.tpl"}
    
    <h3>{$institutionToDelete->getInstitutionName()}&nbsp;({$institutionToDelete->getInstitutionAcronym()})</h3>
    <p><i>{translate key=$institutionToDelete->getInstitutionTypeKey()}<br/>{$institutionToDelete->getInstitutionLocationText()}</i></p>
    
    <div id="institutionForm">
        <table class="data" width="100%">
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top">
                <td width="70%" class="label">{fieldLabel name="countKII" key="institution.countKII"}</td>
                <td width="70%" class="value">{$countKII}</td>
            </tr>
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top">
                <td width="70%" class="label">{fieldLabel name="countKII" key="institution.countSources"}</td>
                <td width="70%" class="value">{$countSources}</td>
            </tr>
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceInstitutionMessage">
                <td colspan="2">{translate key="institution.delete.replacementMessage"}</td>
            </tr>
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceInstitutionWarning">
                <td colspan="2"><b><font color="red">{translate key="institution.delete.replacementWarning"}</font></b></td>
            </tr>
            <tr valign="top"><td colspan="2">&nbsp;</td></tr>
            <tr valign="top" id="replaceInstitutionField">
                <td width="20%" class="label">{fieldLabel name="replacementInstitution" required="true" key="institution.replacement"}</td>
                <td width="80%" class="value">
                    <select name="replacementInstitution" id="replacementInstitution" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$institutionsList selected=$replacementInstitution}
                    </select>
                </td>
            </tr>
        </table>
    </div>

<p><input type="submit" value="{translate key="institution.delete"}" id="deleteButton" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="institutions" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

{include file="common/footer.tpl"}