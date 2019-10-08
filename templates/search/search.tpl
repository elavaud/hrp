{**
 * search.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Site/journal search form.
 *
 * $Id$
 *}

{literal}
    <script type="text/javascript">        
        function clearAll(){
            $('#advancedQuery').val("");
            $('#dateFromYear').val("");
            $('#dateFromMonth').val("");
            $('#dateFromDay').val("");
            $('#dateToYear').val("");
            $('#dateToMonth').val("");
            $('#dateToDay').val("");
            $('#proposalCountry').val("ALL");
            $('input:radio[name="status"]').attr('checked', false);
        }
    </script>
    <style type="text/css">
        img.imagecenter {
            vertical-align: middle;
        }
    </style>    
{/literal}

<ul class="menu">
    <li class="current"><img src="{$baseUrl}/lib/pkp/templates/images/icons/action_forward.gif" alt="&#8226;" class="imagecenter"/>&nbsp;<a href="{url op="advancedResults"}">{translate key="search.research"}</a></li>
    <li><img src="{$baseUrl}/lib/pkp/templates/images/icons/arrow_right.gif" alt="&#8226;" class="imagecenter"/>&nbsp;<a href="{url op="authors"}">{translate key='search.investigators'}</a></li>
</ul>
<br/>

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}
<div id="advancedSearch">
    <form method="post" name="search" action="{url op="advancedResults"}">
        <table width='100%' class="data">
            <tr><td colspan="4">&nbsp;</td></tr>
            <tr valign="top">
                <td width="25%"><b>{translate key="search.fromTitle"}</b></td>
                <td colspan="3"><input type="text" id="advancedQuery" name="query" size="40" maxlength="255" value="{$query|escape}" class="textField" /></td>
            </tr>
            <tr valign="top">
                <td width="25%"><b>{translate key="search.startDate"} {translate key="search.dateFrom"}</b></td>
                <td width="35%">
                    {html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" year_extra='id="dateFromYear"' month_empty="" month_extra='id="dateFromMonth"' day_empty="" day_extra='id="dateFromDay"' start_year="-5" end_year="+1"} &nbsp;&nbsp;({translate key="search.inclusive"})&nbsp;&nbsp;
                </td>
                <td width="5%"><b>{translate key="search.dateTo"}</b>&nbsp;&nbsp;</td>
                <td width="35%">
                    {html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" year_extra='id="dateToYear"' month_empty="" month_extra='id="dateToMonth"' day_empty="" day_extra='id="dateToDay"' start_year="-5" end_year="+1"} &nbsp;&nbsp;({translate key="search.inclusive"})
                    <input type="hidden" name="dateToHour" value="23" />
                    <input type="hidden" name="dateToMinute" value="59" />
                    <input type="hidden" name="dateToSecond" value="59" />
                </td>
            </tr>
            <tr valign="top">
                <td width="25%"><b>{translate key="proposal.geoArea"}</b></td>
                <td width="35%">
                    <select name="proposalCountry" id="proposalCountry" class="selectMenu">
                        <option value="ALL">{translate key="common.all"}</option>
                        {html_options options=$proposalCountries selected=$countryCode}
                    </select>
                </td>
                <td width="5%"><b>{translate key="common.status"}</b></td>
                <td width="35%">
                    <input type="radio" name="status" value="1" {if $statusFilter == 1}checked="checked"{/if}/> {translate key="common.complete"}
                    &nbsp;&nbsp;
                    <input type="radio" name="status" value="2" {if $statusFilter == 2}checked="checked"{/if}/> {translate key="common.ongoing"}
                </td>
            </tr>
        </table>
        <p>
            <input type="submit" value="{translate key="common.search"}" class="button defaultButton" />
            &nbsp;&nbsp;&nbsp;&nbsp;<a  class="action" style="cursor: pointer;" onclick="clearAll()">Clear fields</a>
            &nbsp;&nbsp;&nbsp;&nbsp;<a onclick="showExportOptions()" class="action" id="showExportOptions" style="cursor: pointer;">{translate key="search.exportSearchResults"}</a>
            &nbsp;&nbsp;&nbsp;&nbsp;<a onclick="hideExportOptions()" class="action" id="hideExportOptions" style="cursor: pointer;">{translate key="search.hideExportOptions"}</a><br />
        </p>
    </form>
</div>
