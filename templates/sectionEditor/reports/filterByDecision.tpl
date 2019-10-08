{**
* filterByDecision.tpl
*
* Generate report - filter by decision part 
**}

<p><b><a id="showOrHideDecisionTableClick" class="action" style="cursor: pointer;">{translate key="editor.reports.oneDecisionIs"}</a></b></p>
<input type="hidden" id="decisionTableShow" name="decisionTableShow" />

<table width="100%" class="data" id="decisionTable">
    <tr valign="top">
        <td width="20%"></td>
        <td width="15%"></td>
        <td width="65%"></td>
    </tr>
    <tr valign="top"><td colspan="3" class="label"><i>{translate key='editor.reports.hideWillErase'}</i></td></tr>
    <tr valign="top"><td colspan="3" class="label">&nbsp;</td></tr>
    <tr valign="top"><td colspan="3" class="label">{translate key='editor.reports.oneDecisionIs.instruct'}</td></tr>
    <tr valign="top"><td colspan="3" class="label">&nbsp;</td></tr>
    <tr valign="top">
        <td class="label">{translate key="editor.reports.fromCommittee"}</td>            
        <td class="value" colspan="2">
            <select name="decisionCommittee" id="decisionCommittee" class="selectMenu">
                {html_options options=$sectionOptions selected=$decisionCommittee}
            </select>
        </td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="common.type"}</td>            
        <td class="value" colspan="2">
            <select name="decisionType" id="decisionType" class="selectMenu">
                {html_options_translate options=$decisionTypes selected=$decisionType}
            </select>                
        </td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="common.status"}</td>            
        <td class="value" colspan="2">
            <select name="decisionStatus" id="decisionStatus" class="selectMenu">
                {html_options_translate options=$decisionOptions selected=$decisionStatus}
            </select>                
        </td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="editor.reports.dateAfter"}</td>            
        <td class="value" colspan="2">
            <input type="text" class="textField" name="decisionAfter" id="decisionAfter" size="20" maxlength="255" /><i>&nbsp;({translate key="editor.reports.dateInclusive"})</i>
        </td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="editor.reports.dateBefore"}</td>            
        <td class="value" colspan="2">
            <input type="text" class="textField" name="decisionBefore" id="decisionBefore" size="20" maxlength="255" /><i>&nbsp;({translate key="editor.reports.dateInclusive"})</i>
        </td>
    </tr>
    <tr valign="top"><td colspan="3" class="label">&nbsp;</td></tr>
</table>
