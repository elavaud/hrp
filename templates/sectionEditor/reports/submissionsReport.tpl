{**
* submissionsReport.tpl
*
* Generate report - spreadsheet or charts 
**}

{strip}
    {assign var="pageTitle" value="editor.reports.reportGenerator"}
    {assign var="pageCrumbTitle" value="editor.reports.submissions"}
    {include file="common/header.tpl"}
{/strip}

<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<script type="text/javascript" src="{$baseUrl|cat:"/js/reports.js"}"></script>

{include file="sectionEditor/reports/javascript.tpl"}

{include file="common/formErrors.tpl"}

<form method="post" action="{url op="submissionsReport"}">

    <div id="filterBy">
        <h5>{translate key="editor.reports.filterBy"}</h5>
        <p>{translate key="editor.reports.filterBy.instruct"}</p>
        
        {include file="sectionEditor/reports/filterByDecision.tpl"}
        
        {include file="sectionEditor/reports/filterByDetails.tpl"}
                    
        {include file="sectionEditor/reports/filterBySources.tpl"}

        {include file="sectionEditor/reports/filterByRisks.tpl"}

    </div>  

    <div id="generate">
                
        <h5>{translate key="editor.reports.generate"}</h5>

        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%">{translate key="editor.reports.type"}</td>
                <td width="80%">
                    <select name="reportType" id="reportType" class="selectMenu">
                        <option value=""></option>
                        {html_options_translate options=$reportTypeOptions}
                    </select>
                </td>
            </tr>
        </table>

        {include file="sectionEditor/reports/spreadsheet.tpl"}
        
        {include file="sectionEditor/reports/pieChart.tpl"}
        
    </div>
	
    <br/><br/>
    <input id="defaultButton" type="submit" name="generateSubmissionsReport" value="{translate key="editor.reports.generateReport"}" class="button defaultButton" />
    <input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" />

</form>

{include file="common/footer.tpl"}