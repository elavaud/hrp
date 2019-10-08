{**
 * variablesAbstract.tpl
 *
 * Section of approvalNoticeForm.tpl
 * Display a list of possible variables available related to the abstract of the research proposal
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
        <td width="20%">{translate key="manager.approvalNotice.key.scienTitle.name"}</td>
        <td width="20%" align="left">{literal}{$scienTitle}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.scienTitle.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.publicTitle.name"}</td>
        <td width="20%" align="left">{literal}{$publicTitle}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.publicTitle.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>   
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.abstractFull.name"}</td>
        <td width="20%" align="left">{literal}{$abstractFull}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.abstractFull.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.background.name"}</td>
        <td width="20%" align="left">{literal}{$background}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.background.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.objectives.name"}</td>
        <td width="20%" align="left">{literal}{$objectives}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.objectives.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.studyMethods.name"}</td>
        <td width="20%" align="left">{literal}{$studyMethods}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.studyMethods.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.expectedOutcomes.name"}</td>
        <td width="20%" align="left">{literal}{$expectedOutcomes}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.expectedOutcomes.explanation"}</td>
    </tr> 
    <tr><td colspan="3" class="endseparator">&nbsp;</td></tr>
</table>