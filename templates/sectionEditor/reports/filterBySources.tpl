{**
* filterBySources.tpl
*
* Generate report - filter by sources part 
**}



<p><b><a id="showOrHideSourcesTableClick" class="action" style="cursor: pointer;">{translate key="proposal.sourceOfMonetary"}</a></b></p>
<input type="hidden" id="sourcesTableShow" name="sourcesTableShow" />        

<table width="100%" class="data" id="sourcesTable">
    <tr valign="top">
        <td width="20%"></td>
        <td width="20%"></td>
        <td width="30%"></td>
        <td width="30%"></td>
    </tr>            
    <tr valign="top"><td colspan="4" class="label"><i>{translate key='editor.reports.hideWillErase'}</i></td></tr>
    <tr valign="top"><td colspan="4" class="label">&nbsp;</td></tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.fundsRequired"}</td>
        <td class="value">
            <select name="budgetOption" id="decisionCommittee" class="selectMenu">
                {html_options_translate options=$budgetOptions selected=$budgetOption}
            </select>            
        </td>
        <td class="value">
            <input type="text" name="budget" value="{$budget|escape}" id="budget" size="20" maxlength="60" class="textField" />
            &nbsp;{$sourceCurrency->getCodeAlpha()|escape}
        </td>
        <td class="label"><span><i>{translate key="proposal.source.amount.instruct"}</i></span></td>
    </tr>            
    <tr valign="top" id="firstSource">
        <td class="sourceTitle">{translate key="proposal.source"}</td>
        <td class="value" colspan="3">
            <select name="sources[]" class="selectMenu">
                <option value=""></option>
                {html_options options=$institutionsList}
            </select>
            <a class="removeSource" style="display: none; cursor: pointer;">{translate key="common.remove"}</a>
        </td>
    </tr>
    <tr id="addAnotherSource">
        <td class="label">&nbsp;</td>
        <td colspan="3"><a id="addAnotherSourceClick" style="cursor: pointer;">{translate key="proposal.source.add"}</a></td>
    </tr>
    
</table>    
