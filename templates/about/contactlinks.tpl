{**
 * links.tpl
 *
 * Display all the links.
 *
 * $Id$
 *}

<div id="contact">
    <h2>{translate key="about.contacts"}</h2>
    
    <table width="100%">
        <tr>
            <td width="30%" valign="top">
                <b>{translate key="about.contact.principalContact"}</b>
            </td>
            <td width="70%" valign="top">
                {if $CTitle != ''}
                    {$CTitle}
                    {if $CName != ''} {$CName}{/if}                    
                {else}
                    {if $CName != ''}{$CName}{/if}                                        
                {/if}
                {if $CAffiliation != ''}<br/>{$CAffiliation}{/if}
                {if $CPhone != ''}<br/>{translate key="about.contact.phone"}: {$CPhone}{/if}
                {if $CFax != ''}<br/>{translate key="about.contact.fax"}: {$CFax}{/if}
                {if $CAddress != ''}<br/>{translate key="common.mailingAddress"}: {$CAddress}{/if}
                {if $CEmail != ''}<br/>{translate key="about.contact.email"}: {mailto address=$CEmail|escape encode="hex"}{/if}
            </td>
        </tr>
        <tr><td colspan="2"><br/></td></tr>
        <tr>
            <td width="30%" valign="top">
                <b>{translate key="about.contact.subPrincipalContact"}</b>
            </td>
            <td width="70%" valign="top">
                {if $SName != ''}{$SName}{/if}
                {if $SPhone != ''}<br/>{translate key="about.contact.phone"}: {$SPhone}{/if}
                {if $SEmail != ''}<br/>{translate key="about.contact.email"}: {mailto address=$SEmail|escape encode="hex"}{/if}
            </td>
        </tr>
    </table>
    <p>{$aboutOtherContacts}</p>

</div>
<br/> 
<div id="links">
    <h2>{translate key="about.links"}<br/></h2>
    <p>{$aboutLinks}</p>

    {if $countNavMenuItems > 0}
       <table width="100%">
           <tr><td colspan="2">&nbsp;</tr>
           {foreach from=$navMenuItems item=navItem}
               {if $navItem.url != '' && $navItem.name != ''}
                   <tr>
                       <td width="5%">&nbsp;</td>
                       <td width="95%"><a href="{if $navItem.isAbsolute}{$navItem.url|escape}{else}{$navItem.url|escape}{/if}"  target="_blank">
                           <b>&#8226;&nbsp;
                               {if $navItem.isLiteral}
                                   {$navItem.name|escape}
                               {else}
                                   {translate key=$navItem.name}
                               {/if}
                           </b>
                       </a>
                       </td>
                   </tr>
               {/if}                
           {/foreach}
       </table>
    {/if}

</div>

