{**
 * files.tpl
 *
 * Display all the public files.
 *
 * $Id$
 *}
 
 <div>
    <h2>{translate key="about.files"}</h2>
    <p>{$aboutFiles}</p>

    {if $countPolicyFiles > 0}
        <div id="policyFiles">
             <h3>{translate key="common.file.policy"}</h3>
             <table width="100%">
                  <tr><td colspan="2">&nbsp;</tr>
                  {foreach from=$policyFiles item=policyFile}
                       <tr>
                            <td width="5%">&nbsp;</td>
                            <td width="5%" valign='top'><img src="{$baseUrl}/lib/pkp/templates/images/icons/download.gif" alt="&#8226;"/></td>
                            <td width="90%">
                                <a href="{url op="downloadAboutFile" path=$policyFile->getId()}"><b>{$policyFile->getLocalizedAboutFileName()|escape}</b></a>
                                 &nbsp;({$policyFile->getFileExtension()}, {$policyFile->getNiceFileSize()})
                                {if $policyFile->getLocalizedAboutFileDescription() != ''}<br/>{$policyFile->getLocalizedAboutFileDescription()}{/if}
                                <br/>&nbsp;
                            </td>
                       </tr>
                  {/foreach}
             </table>
        </div>
   {/if}

   {if $countUserManuals > 0}
        <div id="userManuals">
            <h3>{translate key="common.file.usermanuals"}</h3>
            <table width="100%">
                <tr><td colspan="2">&nbsp;</tr>
                {foreach from=$userManuals item=userManual}
                    <tr>
                        <td width="5%">&nbsp;</td>
                        <td width="5%" valign='top'><img src="{$baseUrl}/lib/pkp/templates/images/icons/download.gif" alt="&#8226;"/></td>
                        <td width="90%">
                            <a href="{url op="downloadAboutFile" path=$userManual->getId()}"><b>{$userManual->getLocalizedAboutFileName()|escape}</b></a>
                             &nbsp;({$userManual->getFileExtension()}, {$userManual->getNiceFileSize()})
                            {if $userManual->getLocalizedAboutFileDescription() != ''}<br/>{$userManual->getLocalizedAboutFileDescription()}{/if}
                            <br/>&nbsp;
                        </td>
                    </tr>
                {/foreach}
            </table>
        </div>
   {/if}

   {if $countTemplates > 0}
        <div id="templates">
            <h3>{translate key="common.file.templates"}</h3>
            <table width="100%">
                <tr><td colspan="2">&nbsp;</tr>
                {foreach from=$templates item=template}
                    <tr>
                        <td width="5%">&nbsp;</td>
                        <td width="5%" valign='top'><img src="{$baseUrl}/lib/pkp/templates/images/icons/download.gif" alt="&#8226;"/></td>
                        <td width="90%">
                            <a href="{url op="downloadAboutFile" path=$template->getId()}"><b>{$template->getLocalizedAboutFileName()|escape}</b></a>
                             &nbsp;({$template->getFileExtension()}, {$template->getNiceFileSize()})
                            {if $template->getLocalizedAboutFileDescription() != ''}<br/>{$template->getLocalizedAboutFileDescription()}{/if}
                            <br/>&nbsp;
                        </td>
                    </tr>
                {/foreach}
            </table>
        </div>
   {/if}

   {if $countMiscellaneousFiles > 0}
        <div id="miscellaneous">
            <h3>{translate key="common.file.miscellaneous"}</h3>
            <table width="100%">
                <tr><td colspan="2">&nbsp;</tr>
                {foreach from=$miscellaneousFiles item=miscellaneousFile}
                    <tr>
                        <td width="5%">&nbsp;</td>
                        <td width="5%" valign='top'><img src="{$baseUrl}/lib/pkp/templates/images/icons/download.gif" alt="&#8226;"/></td>
                        <td width="90%">
                            <a href="{url op="downloadAboutFile" path=$miscellaneousFile->getId()}"><b>{$miscellaneousFile->getLocalizedAboutFileName()|escape}</b></a>
                            &nbsp;({$miscellaneousFile->getFileExtension()}, {$miscellaneousFile->getNiceFileSize()})
                            {if $miscellaneousFile->getLocalizedAboutFileDescription() != ''}<br/>{$miscellaneousFile->getLocalizedAboutFileDescription()}{/if}
                            <br/>&nbsp;
                        </td>
                    </tr>
                {/foreach}
            </table>
        </div>
   {/if}

</div>