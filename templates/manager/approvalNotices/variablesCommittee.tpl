{**
 * variablesCommittee.tpl
 *
 * Section of approvalNoticeForm.tpl
 * Display a list of possible variables realted to the committee review the proposal
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
        <td width="20%">{translate key="manager.approvalNotice.key.comName.name"}</td>
        <td width="20%" align="left">{literal}{$comName}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.comName.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.comAcronym.name"}</td>
        <td width="20%" align="left">{literal}{$comAcronym}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.comAcronym.explanation"}</td>
    </tr>    
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>        
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.reviewType.name"}</td>
        <td width="20%" align="left">{literal}{$reviewType}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.reviewType.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.reviewRound.name"}</td>
        <td width="20%" align="left">{literal}{$reviewRound}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.reviewRound.explanation"}</td>
    </tr>      
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr><td colspan="3"><b>{translate key="manager.approvalNotice.key.class.people"}</b></td></tr>
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.comSecName.name"}</td>
        <td width="20%" align="left">{literal}{$comSecName}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.comSecName.explanation"}</td>
    </tr>   
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.comChairName.name"}</td>
        <td width="20%" align="left">{literal}{$comChairName}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.comChairName.explanation"}</td>
    </tr>   
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.comViceChairName.name"}</td>
        <td width="20%" align="left">{literal}{$comViceChairName}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.comViceChairName.explanation"}</td>
    </tr>
    <tr><td colspan="3" class="endseparator">&nbsp;</td></tr>
</table>
