{**
 * index.tpl
 *
 * About the Journal index.
 *
 * $Id$
 *}
{strip}
    {assign var="pageTitle" value="about.aboutTheJournal"}
    {assign var="pageCrumbTitle" value="about.$pageToDisplay"}
    {include file="common/header.tpl"}
{/strip}

<ul class="menu">
    <li{if ($pageToDisplay == "governance")} class="current"{/if}><a href="{url op="index" path="governance"}">{translate key='about.governance'}</a></li>
    <li{if ($pageToDisplay == "committees")} class="current"{/if}><a href="{url op="index" path="committees"}">{translate key='about.committees'}</a></li>
    <li{if ($pageToDisplay == "grants")} class="current"{/if}><a href="{url op="index" path="grants"}">{translate key='about.grants'}</a></li>
    <li{if ($pageToDisplay == "files")} class="current"{/if}><a href="{url op="index" path="files"}">{translate key='about.files'}</a></li>
    <li{if ($pageToDisplay == "contactlinks")} class="current"{/if}><a href="{url op="index" path="contactlinks"}">{translate key='about.contactlinks'}</a></li>
</ul>
<br/>
<div>
<p>{$aboutHeader}</p>
</div>
<br/>
{include file="about/$pageToDisplay.tpl"}
<br/>
{include file="common/footer.tpl"}

