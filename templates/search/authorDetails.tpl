{**
 * authorDetails.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Index of published articles by author.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="search.authorDetails"}
{include file="common/header.tpl"}
{/strip}

<div id="authorDetails">
    {url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=''|strip_tags}
    <h5>{$fAuthor->getFullName()|escape} {icon name="mail" url=$url}</h5>
    {if $fAuthor->getAllAffiliations()}<b>{translate key="user.affiliation"}:&nbsp;</b>{$fAuthor->getAllAffiliations()}{else}&nbsp,{/if}
    <h4>{translate key="search.authorResearchProposals"}:</h4><br/>
    <ul>
        {foreach from=$articles item=article}
            {assign var="abstract" value=$article->getLocalizedAbstract()}
            {assign var="proposalDetails" value=$article->getProposalDetails()}
            <li>
                <a href="{url op="viewProposal" path=$article->getId()}" class="action">{$abstract->getScientificTitle()|escape}</a>
                <br/>{$proposalDetails->getLocalizedResearchFieldText()|escape}<br/>&nbsp;
            </li>
        {/foreach}
    </ul>
</div>
{include file="common/footer.tpl"}

