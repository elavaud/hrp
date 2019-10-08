{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Journal management index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="manager.journalManagement"}
{include file="common/header.tpl"}
{/strip}
<div id="managementPages">
<h3>{translate key="manager.managementPages"}</h3>

<ul class="plain">
	{if $announcementsEnabled}
		<li>&#187; <a href="{url op="announcements"}">{translate key="manager.announcements"}</a></li>
	{/if}
	<!--<li>&#187; <a href="{url op="files"}">{translate key="manager.filesBrowser"}</a></li>-->
	<li>&#187; <a href="{url op="aboutFiles"}">{translate key="manager.aboutFiles"}</a></li>
	<li>&#187; <a href="{url op="approvalNotices"}">{translate key="manager.approvalNotices"}</a></li>
        <li>&#187; <a href="{url op="sections"}">{translate key="section.sections"}</a></li>
        <li>&#187; <a href="{url op="institutions"}">{translate key="manager.institutions"}</a></li>
        <li>&#187; <a href="{url op='extraFields' path='geoAreas'}">{translate key="manager.extraFields.geoAreas"}</a></li>
        <li>&#187; <a href="{url op='extraFields' path='researchFields'}">{translate key="manager.extraFields.researchFields"}</a></li>
        <li>&#187; <a href="{url op='extraFields' path='researchDomains'}">{translate key="manager.extraFields.researchDomains"}</a></li>
        <li>&#187; <a href="{url op='extraFields' path='proposalTypes'}">{translate key="manager.extraFields.proposalTypes"}</a></li>        
        <li>&#187; <a href="{url op="reviewForms"}">{translate key="manager.reviewForms"}</a></li>
        <li>&#187; <a href="{url op="languages"}">{translate key="common.languages"}</a></li>

	<!-- <li>&#187; <a href="{url op="groups"}">{translate key="manager.groups"}</a></li>-->
	<li>&#187; <a href="{url op="emails"}">{translate key="manager.emails"}</a></li>
        {** Commented out - spf 1 Dec 2011
	<li>&#187; <a href="{url page="rtadmin"}">{translate key="manager.readingTools"}</a></li> *}
	<li>&#187; <a href="{url op="setup"}">{translate key="manager.setup"}</a></li>
	<!--
	<li>&#187; <a href="{url op="statistics"}">{translate key="manager.statistics"}</a></li>
	-->
	<li>&#187; <a href="{url op="payments"}">{translate key="manager.payments"}</a></li>
	{if $publishingMode == $smarty.const.PUBLISHING_MODE_SUBSCRIPTION}
		<li>&#187; <a href="{url op="subscriptionsSummary"}">{translate key="manager.subscriptions"}</a></li>
	{/if}
	<li>&#187; <a href="{url op="plugins"}">{translate key="manager.plugins"}</a></li>
        {*
	<li>&#187; <a href="{url op="importexport"}">{translate key="manager.importExport"}</a></li> 
        *}
	{call_hook name="Templates::Manager::Index::ManagementPages"}
</ul>
</div>
<div id="managerUsers">
<h3>{translate key="manager.users"}</h3>

<ul class="plain">
	<li>&#187; <a href="{url op="createUser" source=$managementUrl}">{translate key="manager.people.createUser"}</a></li>
	<li>&#187; <a href="{url op="enrollSearch"}">{translate key="manager.people.allSiteUsers"}</a></li> <br/>
	{url|assign:"managementUrl" page="manager"}
	{call_hook name="Templates::Manager::Index::Users"}
	<li>&#187; <a href="{url op="people" path="managers"}">{translate key="manager.people.seeEnrolled"} {translate key="user.role.managers"}</a></li>
	<li>&#187; <a href="{url op="people" path="editors"}">{translate key="manager.people.seeEnrolled"} {translate key="user.role.coordinators"}</a></li>
	<li>&#187; <a href="{url op="people" path="sectionEditors"}">{translate key="manager.people.seeEnrolled"} {translate key="user.role.sectionEditors"}</a></li> 
	<li>&#187; <a href="{url op="people" path="reviewers"}">{translate key="manager.people.seeEnrolled"} {translate key="user.role.reviewers"}</a></li>
	<li>&#187; <a href="{url op="people" path="extReviewers"}">{translate key="manager.people.seeEnrolled"} {translate key="user.ercrole.extReviewers"}</a></li>
	<li>&#187; <a href="{url op="people" path="authors"}">{translate key="manager.people.seeEnrolled"} {translate key="user.role.authors"}</a></li>
	{call_hook name="Templates::Manager::Index::Roles"}
</ul>
</div>
{include file="common/footer.tpl"}

