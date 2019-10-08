<?php

/**
 * @file LinksBlockPlugin.inc.php
 *
 * @class LinksBlockPlugin
 * @ingroup plugins_blocks_links
 *
 * @brief Class for "links" block plugin
 */

// $Id$


import('lib.pkp.classes.plugins.BlockPlugin');

class LinksBlockPlugin extends BlockPlugin {
	/**
	 * Determine whether the plugin is enabled. Overrides parent so that
	 * the plugin will be displayed during install.
	 */
	function getEnabled() {
		if (!Config::getVar('general', 'installed')) return true;
		return parent::getEnabled();
	}

	/**
	 * Install default settings on system install.
	 * @return string
	 */
	function getInstallSitePluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * Install default settings on journal creation.
	 * @return string
	 */
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * Get the display name of this plugin.
	 * @return String
	 */
	function getDisplayName() {
		return Locale::translate('plugins.block.links.displayName');
	}

	/**
	 * Get a description of the plugin.
	 */
	function getDescription() {
		return Locale::translate('plugins.block.links.description');
	}


	function getContents(&$templateMgr) {
                $navMenuItems = $templateMgr->get_template_vars('navMenuItems');
                foreach ($navMenuItems as $navMenuKey => $navMenuItem){
                    $navMenuItems[$navMenuKey] = array_filter($navMenuItem);
                }
                $navMenuItems = array_filter($navMenuItems);
                $templateMgr->assign('countNavMenuItems', count($navMenuItems));
                return parent::getContents($templateMgr);
	}
}

?>
