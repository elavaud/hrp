{**
 * block.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Common site sidebar menu -- "Developed By" block.
 *
 * $Id$
 *}
<div class="block" id="sidebarLinks">
    {if $countNavMenuItems > 0}
	<span class="blockTitle">{translate key="common.links"}</span>
        <ul>
            {foreach from=$navMenuItems item=navItem}
                {if $navItem.url != '' && $navItem.name != ''}
                    <li>
                        <a href="{if $navItem.isAbsolute}{$navItem.url|escape}{else}{$navItem.url|escape}{/if}" target="_blank">
                            {if $navItem.isLiteral}
                                {$navItem.name|escape}
                            {else}
                                {translate key=$navItem.name}
                            {/if}
                        </a>
                    </li>
                {/if}                
            {/foreach}
        </ul>
    {/if}
</div>	
