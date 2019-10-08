{**
 * variablesDates.tpl
 *
 * Section of approvalNoticeForm.tpl
 * Display a list of possible dates available
 *
 * $Id$
 *}
<table width="100%" class="listing">
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr class="heading" valign="bottom">
        <td width="20%">{translate key="common.name"}</td>
        <td width="20%" align="left">{translate key="manager.approvalNotice.key"}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.information"}</td>
    </tr>    
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.todayDate.name"}</td>
        <td width="20%" align="left">{literal}{$todayDate}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.todayDate.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.resStartDate.name"}</td>
        <td width="20%" align="left">{literal}{$resStartDate}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.resStartDate.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.resEndDate.name"}</td>
        <td width="20%" align="left">{literal}{$resEndDate}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.resEndDate.explanation"}</td>
    </tr>   
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.subRoundDate.name"}</td>
        <td width="20%" align="left">{literal}{$subRoundDate}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.subRoundDate.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="endseparator">&nbsp;</td></tr>
</table>
