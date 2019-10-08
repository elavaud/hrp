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
    {assign var="pageTitle" value="institution.institution"}
    {assign var="pageCrumbTitle" value="institution.institution"}
    {include file="common/header.tpl"}
{/strip}

 {literal}
     <script type="text/javascript">
         
        var INSTITUTION_NATIONAL = "{/literal}{$smarty.const.INSTITUTION_NATIONAL}{literal}";
        var INSTITUTION_INTERNATIONAL = "{/literal}{$smarty.const.INSTITUTION_INTERNATIONAL}{literal}";
        
        function showLocation () {
            var value = $("input:radio[name='international']:checked").val();
            if (value === INSTITUTION_NATIONAL) {
                $('#locationCountryRow').show();
                if ($('#locationCountry option[value="0"]').length > 0){
                    $('#locationCountry option[value="0"]').remove();
                }                
                $('#locationInternationalRow').hide();
                if (!$('#locationInternational option[value="0"]').length > 0){
                    $('#locationInternational').append('<option value="0"></option>');
                }
                $('#locationInternational').val("0");                
            } else if (value === INSTITUTION_INTERNATIONAL) {
                $('#locationCountryRow').hide();
                if (!$('#locationCountry option[value="0"]').length > 0){
                    $('#locationCountry').append('<option value="0"></option>');
                }
                $('#locationCountry').val("0");                   
                $('#locationInternationalRow').show();
                if ($('#locationInternational option[value="0"]').length > 0){
                    $('#locationInternational option[value="0"]').remove();
                }                  
            } else {
                $('#locationCountryRow').hide();
                if (!$('#locationCountry option[value="0"]').length > 0){
                    $('#locationCountry').append('<option value="0"></option>');
                }
                $('#locationCountry').val("0");                 
                
                $('#locationInternationalRow').hide();
                if (!$('#locationInternational option[value="0"]').length > 0){
                    $('#locationInternational').append('<option value="0"></option>');
                }
                $('#locationInternational').val("0");                 
            }
        }
        
        $(document).ready(
            function() {
                $("input:radio[name='international']").change(showLocation);
                showLocation();
            }
        );
     </script>
 {/literal}
 
 <form name="institution" method="post" action="{url op="updateInstitution" path="$institutionId"}">

    {include file="common/formErrors.tpl"}
    <div id="institutionForm">
        <table class="data" width="100%">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="name" required="true" key="institution.name"}</td>
                <td width="80%" class="value"><input type="text" name="name" value="{$name}" id="name" size="40" maxlength="120" class="textField" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="acronym" required="true" key="institution.acronym"}</td>
                <td width="80%" class="value"><input type="text" name="acronym" value="{$acronym}" id="acronym" size="20" maxlength="60" class="textField" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="type" required="true" key="institution.type"}</td>
                <td width="80%" class="value">
                    <select name="type" id="type" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$institutionTypes selected=$type}
                    </select>
                </td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="international" required="true" key="institution.location"}</td>
                <td width="80%" class="value">
                    {html_radios name='international' options=$internationalArray selected=$international separator='&nbsp;&nbsp;&nbsp;&nbsp;'}
                </td>
            </tr>
            <tr valign="top" id="locationCountryRow">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="locationCountry" id="locationCountry" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$regions selected=$locationCountry}
                    </select>
                </td>
            </tr>
            <tr valign="top" id="locationInternationalRow">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="locationInternational" id="locationInternational" class="selectMenu">
                        <option value=""></option>
                        {html_options options=$countries selected=$locationInternational}
                    </select>
                </td>
            </tr>            
        </table>
    </div>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="institutions" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}

