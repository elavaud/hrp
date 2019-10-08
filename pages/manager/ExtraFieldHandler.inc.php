<?php

/**
 * @file ExtraFieldHandler.inc.php
 * @class ExtraFieldHandler
 * @ingroup pages_manager
 *
 * @brief Handle requests for exrta fields management functions.
 */

// $Id$

import('pages.manager.ManagerHandler');

class ExtraFieldHandler extends ManagerHandler {
    
	/**
	 * Constructor
	 **/
	function ExtraFieldHandler() {
		parent::ManagerHandler();
	}
        
	/**
	 * Display a list of the extra fields according to the type.
	 */
	function extraFields($args) {
                $this->validate();
                $this->setupTemplate();

                if (isset($args) && !empty($args)) {
                    $extraFieldDao =& DAORegistry::getDAO('ExtraFieldDAO');
                    
                    $type = $args[0];
                    switch ($type) {
                        case 'geoAreas':
                            $typeConst = (int) EXTRA_FIELD_GEO_AREA;
                            break;
                        case 'researchFields':
                            $typeConst = (int) EXTRA_FIELD_RESEARCH_FIELD;
                            break;
                        case 'researchDomains':
                            $typeConst = (int) EXTRA_FIELD_RESEARCH_DOMAIN;
                            break;
                        case 'proposalTypes':
                            $typeConst = (int) EXTRA_FIELD_PROPOSAL_TYPE;
                            break;
                    }
                    
                    if (!$typeConst) {
                        Request::redirect(null, 'manager');
                    }
                    $newExtraField = 'manager.extraFields.'.$type.'.new';
                    
                    $rangeInfo =& Handler::getRangeInfo('extraFields');

                    $extraFields =& $extraFieldDao->getAllExtraFieldsByType($typeConst, $rangeInfo);

                    $templateMgr =& TemplateManager::getManager();
                    //$templateMgr->assign('pageHierarchy', array(array(Request::url(null, 'manager'), 'manager.journalManagement')));
                    $templateMgr->assign('type', $type);
                    $templateMgr->assign('newExtraField', $newExtraField);
                    $extraFieldsTypeMap = $extraFieldDao->getExtraFieldsTypeMap();
                    $templateMgr->assign('pageTitle', $extraFieldsTypeMap[$typeConst]);
                    $templateMgr->assign_by_ref('extraFields', $extraFields);
                    $templateMgr->display('manager/extraFields/extraFields.tpl');                    
                } else {
                    Request::redirect(null, 'manager');
                }
	}
	
	/**
	 * Delete an extra field.
	 */
	function deleteExtraField($args) {
		if (isset($args) && !empty($args)) {
                        import('classes.manager.form.ExtraFieldDeleteForm');   
                        $type = $args[0];
                        $extraFieldId = $args[1];
                        
                        $this->validate();
                        $this->setupTemplate($type);  
                        
                        $extraFieldDeleteForm = new ExtraFieldDeleteForm($type, $extraFieldId);
                        
                        $extraFieldDeleteForm->readInputData();
                        if ($extraFieldDeleteForm->validate()) {
                                $extraFieldDeleteForm->execute();
                                Request::redirect(null, null, 'extraFields', $type);
                        } else {
                                $extraFieldDeleteForm->display();
                        }                        
		}
		else {
                    Request::redirect(null, null);
                }
	}
	
	/**
	 * Save changes to an extra field.
	 */
	function updateExtraField($args = array()) {

                if (isset($args) && !empty($args)) {
                
                    import('classes.manager.form.ExtraFieldForm');                
                    $type = $args[0];
                    $extraFieldId = $args[1];
                    
                    $this->validate();
                    $this->setupTemplate($type);

                    if ($extraFieldId) {
                        $extraFieldForm = new ExtraFieldForm($type, $extraFieldId);
                    } else {
                        $extraFieldForm = new ExtraFieldForm($type);
                    }

                    $extraFieldForm->readInputData();
                    if ($extraFieldForm->validate()) {
                        $extraFieldForm->execute();
                        Request::redirect(null, null, 'extraFields', $type);
                    } else {
                        $extraFieldForm->display();
                    }
		} else {
                    Request::redirect(null, 'manager');
                }
	}
	
	/**
	 * Display form to create/edit an extra field.
	 * @param $args array optional, if set the first parameter is the ID of the institution to edit
	*/
	function editExtraField($args) {                
                if (isset($args) && !empty($args)) {
                    import('classes.manager.form.ExtraFieldForm');
                    $type = $args[0];
                    
                    $this->validate();
                    $this->setupTemplate($type);                    
                    
                    if (isset($args[1])) {
                        $extraFieldForm = new ExtraFieldForm($type, $args[1]);
                    } else {
                        $extraFieldForm = new ExtraFieldForm($type);
                    }

                    $extraFieldForm->initData();

                    $extraFieldForm->display();
                } else {
                    Request::redirect(null, 'manager');
                }
	}
	
	/**
	 * Display form to delete a institution.
	 * @param $args array, the first parameter is the type and the second the ID of the extra field to edit
	*/
	function deleteExtraFieldForm($args) {
		if (isset($args) && !empty($args)) {
                    $type = $args[0];
                    $extraFieldId = $args[1];
                    
                    $this->validate();
                    $this->setupTemplate($type);

                    import('classes.manager.form.ExtraFieldDeleteForm');                    
                    
                    $extraFieldDeleteForm = new ExtraFieldDeleteForm($type, $extraFieldId);
                    
                    $extraFieldDeleteForm->initData();

                    $extraFieldDeleteForm->display();
                    
                    
                } else {
                    Request::redirect(null, null);
                }
	}
        
        /*
         * Lunch the form for managing the "Other" fields, manually entered by submitters of research proposal
	 * @param $args array, the first parameter is the type of the "other" extra fields to manage
         */
        function manageOthersForm($args){
		if (isset($args) && !empty($args)) {
                    $type = $args[0];
                    
                    $this->validate();
                    $this->setupTemplate($type);

                    import('classes.manager.form.ManageOtherExtraFieldsForm');                    
                    
                    $manageOtherExtraFieldsForm = new ManageOtherExtraFieldsForm($type);
                    
                    $manageOtherExtraFieldsForm->initData();

                    $manageOtherExtraFieldsForm->display();
                } else {
                    Request::redirect(null, null);
                }
        }
        
        /*
         * Execute the form for managing the "Other" fields, manually entered by submitters of research proposal
	 * @param $args array, the first parameter is the type of the "other" extra fields to manage
         */
        function manageOthers($args){
		if (isset($args) && !empty($args)) {
                        import('classes.manager.form.ManageOtherExtraFieldsForm');   
                        $type = $args[0];
                        
                        $this->validate();
                        $this->setupTemplate($type);  
                        
                        $manageOtherExtraFieldsForm = new ManageOtherExtraFieldsForm($type);
                        
                        $manageOtherExtraFieldsForm->readInputData();
                        if ($manageOtherExtraFieldsForm->validate()) {
                                $manageOtherExtraFieldsForm->execute();
                                Request::redirect(null, null, 'extraFields', $type);
                        } else {
                                $manageOtherExtraFieldsForm->display();
                        }                        
		}
		else {
                    Request::redirect(null, null);
                }
        }        
        
	function setupTemplate($subclass = false) {
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_PKP_READER));
		parent::setupTemplate(true);
		if ($subclass) {
			$templateMgr =& TemplateManager::getManager();
			$templateMgr->append('pageHierarchy', array(Request::url(null, 'manager', 'extraFields', $subclass), 'manager.extraFields.'.$subclass));
		}
	}
}

?>
