<?php


import('pages.manager.ManagerHandler');

class AboutFilesHandler extends ManagerHandler {
    
        var $aboutFileDao;
    
	/**
	 * Constructor
	 **/
	function AboutFilesHandler() {
		parent::ManagerHandler();
		$this->aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
	}

	/**
	 * Display the files associated with a journal.
	 */
	function aboutFiles() {
		$this->validate();
		$this->setupTemplate(true);
                
		$rangeInfo =& Handler::getRangeInfo('files');
                
                $templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('pageHierarchy', array(array(Request::url(null, 'manager'), 'manager.journalManagement')));
		$templateMgr->assign('files', $this->aboutFileDao->getAboutFiles($rangeInfo));
                
		$templateMgr->display('manager/aboutFiles/index.tpl');	
	}

        /**
	 * Upload a new file.
	 */
	function aboutFileEdit($args = array()) {
		$this->validate();
		$this->setupTemplate(true);

		import('classes.manager.form.AboutFileForm');
                
		$aboutFileForm = new AboutFileForm(!isset($args) || empty($args) ? null : ((int) $args[0]));
		if ($aboutFileForm->isLocaleResubmit()) {
			$aboutFileForm->readInputData();
		} else {
			$aboutFileForm->initData();
		}
		$aboutFileForm->display();
	}

        /**
	 * Save changes to a section.
	 */
	function updateAboutFile($args, &$request) {
		$this->validate();
		$this->setupTemplate(true);

		import('classes.manager.form.AboutFileForm');
		$aboutFileForm = new AboutFileForm(!isset($args) || empty($args) ? null : ((int) $args[0]));

		$aboutFileForm->readInputData();
		if (!HookRegistry::call('AboutFilesHandler::updateAboutFile', array(&$aboutFileForm))) {
                        if ($request->getUserVar('uploadAboutFile')) {
                                $aboutFileForm->uploadAboutFile('aboutFile', $request->getUserVar('type'));
                        }

                        if ($aboutFileForm->validate()) {
                                $aboutFileForm->execute();
                                Request::redirect(null, null, 'aboutFiles');
                        } else {
                                $aboutFileForm->display();
                        }
                    
                }
	}
        
	function aboutFileDelete($args) {
		$this->validate();
		$fileId = isset($args[0]) ? (int) $args[0] : 0;
                
		import('classes.file.AboutFileManager');
                
		$aboutFileManager = new AboutFileManager();
                $aboutFileManager->deleteAboutFile($fileId);
                
		Request::redirect(null, null, 'aboutFiles');
	}
        
        
        /**
	 * Upload a new file.
	 */
	function aboutFileDownload($args = array()) {
		$this->validate();
		$this->setupTemplate(true);
		$fileId = isset($args[0]) ? (int) $args[0] : 0;
                
		import('classes.file.AboutFileManager');
                
		$aboutFileManager = new AboutFileManager();
                
                $aboutFileManager->downloadFile($fileId);
                
		Request::redirect(null, null, 'aboutFiles');
	}

}
?>
