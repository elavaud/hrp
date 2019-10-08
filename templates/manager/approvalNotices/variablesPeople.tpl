{**
 * variablesPeople.tpl
 *
 * Section of approvalNoticeForm.tpl
 * Display a list of possible variables realted to People
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
    <tr><td colspan="3"><b>{translate key="manager.approvalNotice.key.class.people.investigators"}</b></td></tr>
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.invNAA1Line.name"}</td>
        <td width="20%" align="left">{literal}{$invNAA1Line}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.invNAA1Line.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.invNAAMLines.name"}</td>
        <td width="20%" align="left">{literal}{$invNAAMLines}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.invNAAMLines.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr><td colspan="3"><b>{translate key="manager.approvalNotice.key.class.people.primInvestigator"}</b></td></tr>
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>

    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.primInvName.name"}</td>
        <td width="20%" align="left">{literal}{$primInvName}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.primInvName.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.primInvAff.name"}</td>
        <td width="20%" align="left">{literal}{$primInvAff}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.primInvAff.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr><td colspan="3"><b>{translate key="manager.approvalNotice.key.class.people.coInvestigators"}</b></td></tr>
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.coInvNAA1Line.name"}</td>
        <td width="20%" align="left">{literal}{$coInvNAA1Line}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.coInvNAA1Line.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.coInvNAAMLines.name"}</td>
        <td width="20%" align="left">{literal}{$coInvNAAMLines}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.coInvNAAMLines.explanation"}</td>
    </tr>        
    <tr><td colspan="3" class="headseparator">&nbsp;</td></tr>
    <tr><td colspan="3"><b>{translate key="manager.approvalNotice.key.class.committee"}</b></td></tr>
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
