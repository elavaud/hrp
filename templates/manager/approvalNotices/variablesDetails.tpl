{**
 * variablesDetails.tpl
 *
 * Section of approvalNoticeForm.tpl
 * Display a list of possible variables available related to the details of the research proposal
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
        <td width="20%">{translate key="manager.approvalNotice.key.proposalId.name"}</td>
        <td width="20%" align="left">{literal}{$proposalId}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.proposalId.explanation"}</td>
    </tr> 
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>         
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
        <td width="20%">{translate key="manager.approvalNotice.key.KII.name"}</td>
        <td width="20%" align="left">{literal}{$KII}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.KII.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.countries.name"}</td>
        <td width="20%" align="left">{literal}{$countries}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.countries.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.geoAreas.name"}</td>
        <td width="20%" align="left">{literal}{$geoAreas}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.geoAreas.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.resDomains.name"}</td>
        <td width="20%" align="left">{literal}{$resDomains}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.resDomains.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.resFields.name"}</td>
        <td width="20%" align="left">{literal}{$resFields}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.resFields.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>   
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.propType.name"}</td>
        <td width="20%" align="left">{literal}{$propType}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.propType.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>               
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.dataCollType.name"}</td>
        <td width="20%" align="left">{literal}{$dataCollType}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.dataCollType.explanation"}</td>
    </tr>         
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr><td colspan="3"><b>{translate key="manager.approvalNotice.key.class.details.student"}</b></td></tr>
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.studentInstitution.name"}</td>
        <td width="20%" align="left">{literal}{$studentInstitution}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.studentInstitution.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.studentDegree.name"}</td>
        <td width="20%" align="left">{literal}{$studentDegree}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.studentDegree.explanation"}</td>
    </tr>   
    <tr><td colspan="3" class="separator">&nbsp;</td></tr>            
    <tr valign="top">
        <td width="20%">{translate key="manager.approvalNotice.key.studentSupName.name"}</td>
        <td width="20%" align="left">{literal}{$studentSupName}{/literal}</td>
        <td width="60%" align="left">{translate key="manager.approvalNotice.key.studentSupName.explanation"}</td>
    </tr>
    <tr><td colspan="3" class="endseparator">&nbsp;</td></tr>
</table>