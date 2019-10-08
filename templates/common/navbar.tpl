{**
 * navbar.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Navigation Bar
 *
 *}
 <div id="navbar">
	<ul class="menu">
		<li id="home"><a href="{url page="index"}">{translate key="navigation.home"}</a></li>
		<li id="about"><a href="{url page="about"}">{translate key="navigation.about"}</a></li>

		{if $isUserLoggedIn}
			<li id="userHome"><a href="{url journal="hrp" page="user"}">{translate key="navigation.userHome"}</a></li>
		{else}
			<li id="login"><a href="{url page="login"}">{translate key="navigation.login"}</a></li>
			{if !$hideRegisterLink}
				<li id="register"><a href="{url page="user" op="register"}">{translate key="navigation.register"}</a></li>
			{/if}
		{/if}{* $isUserLoggedIn *}

		{if !$currentJournal || $currentJournal->getSetting('publishingMode') != $smarty.const.PUBLISHING_MODE_NONE}
			<li id="search"><a href="{url page="search" op="advancedResults"}">{translate key="navigation.search"}</a></li>
		{/if}

{** - Removed Current and Archives links in navigation bar - spf 
		{if $currentJournal && $currentJournal->getSetting('publishingMode') != $smarty.const.PUBLISHING_MODE_NONE}
			<li id="current"><a href="{url page="issue" op="current"}">{translate key="navigation.current"}</a></li>
			<li id="archives"><a href="{url page="issue" op="archive"}">{translate key="navigation.archives"}</a></li>
		{/if}
**}
		{if $enableAnnouncements}
			<li id="announcements"><a href="{url page="announcement"}">{translate key="announcement.announcements"}</a></li>
		{/if}{* enableAnnouncements *}

		{call_hook name="Templates::Common::Header::Navbar::CurrentJournal"}

	</ul>
</div>

