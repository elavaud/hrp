{**
* spreadsheet.tpl
*
* Generate report - if pie chart to generate 
**}

<table width="100%" class="data" id="pieChartTable">
    <tr valign="top">
        <td width="20%" class="label">{translate key="editor.reports.measurement"}</td>
        <td width="80%" class="value">
            <select name="measurement" id="measurement" class="selectMenu">
                {html_options_translate options=$measurementOptions}
            </select>
        </td>
    </tr>
    <tr valign="top">
        <td width="20%" class="label">{translate key="editor.reports.chart.theme"}</td>
        <td width="80%" class="value">
            <select name="chartOptions" id="chartOptions" class="selectMenu">
                {html_options options=$chartOptions}
            </select>
        </td>
    </tr>
</table>
