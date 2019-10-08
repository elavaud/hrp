{**
* showChart.tpl
*
* Display the generated chart 
**}

{strip}
    {assign var="pageTitle" value="editor.reports.chart"}
    {assign var="pageCrumbTitle" value="editor.reports.chart"}
    {include file="common/header.tpl"}
{/strip}

<img alt="Pie chart"  src="{$chartLocation}"/>

<table>
    <tr>
        <td width="30%">&nbsp;</td>
        <td width="70%">&nbsp;</td>
    </tr>
    {foreach from=$criterias key=i item=criteria}        
        <tr>
            <td class="label">{if $i == 0}<b>{translate key="editor.reports.criterias"}</b>{else}&nbsp;{/if}</td>
            <td class="value">{$criteria|escape}</td>
        </tr> 
    {/foreach}
</table>

{include file="common/footer.tpl"}