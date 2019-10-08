<?php

/**
 * @file classes/journal/ExtraFieldDAO.inc.php
 *
 *
 * @class ExtraFieldDAO
 * @ingroup journal
 *
 * @brief Class for Extra Field data access
 */

// $Id$

import ('classes.journal.ExtraField');

class ExtraFieldDAO extends DAO {

    	/**
	 * Constructor
	 */        
	function ExtraFieldDAO() {
		parent::DAO();
	}
        
	/*
	 * Returns all extra fields of a certain type
	 * @param $type int
         * @param $rangeInfo
         */
	function &getAllExtraFieldsByType($type, $rangeInfo = null) {

		$params = array($type);		
		$result =& $this->retrieveRange(
			'SELECT * FROM extra_fields WHERE type = ?',
				count($params)===1?array_shift($params):$params,
				$rangeInfo);

		$extraFields = new DAOResultFactory($result, $this, '_returnExtraFieldFromRow');
		return $extraFields;
	}


        /**
	 * Insert a new extra field.
	 * @param $extraField Extra Field
	 */
	function insertExtraField(&$extraField) {
		$this->update(
			'INSERT INTO extra_fields
				(type, active)
				VALUES
				(?, ?)',
			array(
				$extraField->getExtraFieldType(),
				$extraField->getExtraFieldActive()
			)
		);

		$extraField->setExtraFieldId($this->getInsertExtraFieldId());
		$this->updateLocaleFields($extraField);
		return $extraField->getId();
	}
        
	/**
	 * Update an existing extra field.
	 * @param $extraField Extra Field
	 */
	function updateExtraField(&$extraField) {
		$returner = $this->update(
			'UPDATE extra_fields
				SET
					type = ?,
					active = ?
				WHERE extra_field_id = ?',
			array(
				$extraField->getExtraFieldType(),
				$extraField->getExtraFieldActive(),
				$extraField->getExtraFieldId()
			)
		);
		$this->updateLocaleFields($extraField);
		return $returner;
	}
        
        /**
	 * Retrieve an extra field by ID.
	 * @param $extraFieldId int
	 * @return Extra Field
	 */
	function &getExtraField($extraFieldId) {
		$result =& $this->retrieve(
			'SELECT * FROM extra_fields WHERE extra_field_id = ?',
			(int) $extraFieldId
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnExtraFieldFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}
        
        /**
	 * Internal function to return a extra field object from a row.
	 * @param $row array
	 * @param $callHook boolean
	 * @return Extra Field
	 */
	function &_returnExtraFieldFromRow(&$row, $callHook = true) {
		$extraField = new ExtraField();
		$extraField->setId($row['extra_field_id']);
                $extraField->setExtraFieldId($row['extra_field_id']);
		$extraField->setExtraFieldType($row['type']);
		$extraField->setExtraFieldActive($row['active']);
                
		$this->getDataObjectSettings('extra_field_settings', 'extra_field_id', $row['extra_field_id'], $extraField);

		if ($callHook) HookRegistry::call('ExtraFieldDAO::_returnExtraFieldFromRow', array(&$extraField, &$row));

		return $extraField;
	}
        
        function getLocaleFieldNames() {
		return array('extraFieldName');
	}

	function updateLocaleFields(&$extraField) {
		$this->updateDataObjectSettings('extra_field_settings', $extraField, array(
			'extra_field_id' => (int) $extraField->getExtraFieldId()
		));
	}

	/**
	 * Get the ID of the last inserted extra field.
	 * @return int
	 */
	function getInsertExtraFieldId() {
		return $this->getInsertId('extra_fields', 'extra_field_id');
	}
        
        /**
	 * Delete an extra field by ID.
	 * @param $extraFieldId int
	 */
	function deleteExtraFieldById($extraFieldId) {
            
		$this->update('DELETE FROM extra_field_settings WHERE extra_field_id = ?', array($extraFieldId));
		return $this->update('DELETE FROM extra_fields WHERE extra_field_id = ?', array($extraFieldId));
	}
        
        /*
         * Get a map of translation keys for extra fields (keys in plural)
         */
        function getExtraFieldsTypeMap(){
		static $extraFieldsTypeMap;
		if (!isset($extraFieldsTypeMap)) {
			$extraFieldsTypeMap = array(
                                EXTRA_FIELD_GEO_AREA => 'manager.extraFields.geoAreas',
                                EXTRA_FIELD_RESEARCH_FIELD => 'manager.extraFields.researchFields',
                                EXTRA_FIELD_RESEARCH_DOMAIN => 'manager.extraFields.researchDomains',
                                EXTRA_FIELD_PROPOSAL_TYPE => 'manager.extraFields.proposalTypes'
			);
		}
		return $extraFieldsTypeMap;
        }
        
        /*
         * Get an array of extra fields ID and localized names
	 * @param $type int
         */
        function getExtraFieldsList($type, $active = null) {
		$extraFields = array();
		$extraFieldsList = array();
                
                if ($active) {
                        $result =& $this->retrieve('SELECT * FROM extra_fields WHERE type = '.$type.' AND active = '.$active);
                } else {
                        $result =& $this->retrieve('SELECT * FROM extra_fields WHERE type = '.$type);
                }

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$extraFields[] =& $this->_returnExtraFieldFromRow($row);
			$result->moveNext();
		}

		$result->Close();
		unset($result);
                
                foreach ($extraFields as $extraField){
                    $extraFieldsList = $extraFieldsList + array($extraField->getExtraFieldId() => $extraField->getLocalizedExtraFieldName());
                }
                asort($extraFieldsList);
		return $extraFieldsList;
        }
        
        /*
         * Return a string of localized names
         * @param $extraFieldsIdArray Array
         * @return string
         */
        function getLocalizedNames($extraFieldsIdArray){
            if ($extraFieldsIdArray) {
                $returner = (string) '';
                foreach ($extraFieldsIdArray as $extraFieldId) {
                    $extraField =& $this->getExtraField($extraFieldId);
                    if ($returner == ''){
                        if (isset($extraField)) {
                            $returner = $extraField->getLocalizedExtraFieldName();
                        } else {
                            $returner = $extraFieldId;
                        }
                    } else {
                        if (isset($extraField)) {
                            $returner = $returner.', '.$extraField->getLocalizedExtraFieldName();
                        } else {
                            $returner = $returner.', '.$extraFieldId;
                        }                        
                    }
                }
                return $returner;
            } else {
                return null;
            }
        }
        
        /**
         * Get a random ID of a field by type
         * @param int $type
         * @return int
         */
        function getRandomFieldIdByType($type){
                $result =  $this->retrieve('SELECT `extra_field_id` FROM `extra_fields` WHERE `type` = '.$type.' ORDER BY RAND() LIMIT 0,1;');
                $row = $result->GetRowAssoc(false);
                return $row['extra_field_id'];
        }
}

?>