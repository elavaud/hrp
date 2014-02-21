<?php

/**
 * @file classes/journal/InstitutionDAO.inc.php
 *
 *
 * @class InstitutionDAO
 * @ingroup journal
 *
 * @brief Class for institutions data access
 */

// $Id$

import ('classes.journal.Institution');

class InstitutionDAO extends DAO {

	/*
	 *Returns all institution in the database
	 * 
         */
	function &getAllInstitutions($sortBy, $sortDirection, $rangeInfo = null) {

		$params = array();
		$sql = 'SELECT * FROM institutions';
		
		$result =& $this->retrieveRange(
			$sql.($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
				count($params)===1?array_shift($params):$params,
				$rangeInfo);

		$institution = new DAOResultFactory($result, $this, '_returnInstitutionFromRow');
		return $institution;
	}
        
        
        /*
	 *Returns an array of the institution IDs and names
	 * 
         */
	function &getInstitutionsList() {
		$institutions = array();

		$result =& $this->retrieve(
			'SELECT * FROM institutions ORDER BY name'
		);

		while (!$result->EOF) {
                        $row = $result->GetRowAssoc(false);
			$institutions = $institutions + array($row['institution_id'] => $row['name']);
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $institutions;
	}
        
	
	function getSortMapping($heading) {
		switch ($heading) {
			case 'name': return 'name';
			case 'type': return 'type';
			case 'location': return 'location';
			case 'acronym': return 'acronym';
                        default: return 'name';
		}
	}

	/*
	 * Return institution object using the institutionID
	 */
	function getInstitutionById($institutionId){
		$result =& $this->retrieve(
			"SELECT * FROM institutions WHERE institution_id = ".$institutionId
		);
		$institution = $this->_returnInstitutionFromRow($result->GetRowAssoc(false));
		
		return $institution;
	}

	function insertInstitution(&$institution){
            $this->update(
			'INSERT INTO institutions
				(type, location, name, acronym)
				VALUES
				(?,?,?,?)',
			array(
				$institution->getInstitutionType(),
				$institution->getInstitutionLocation(),
				$institution->getInstitutionName(),
				$institution->getInstitutionAcronym()
                        )
		);
		$institution->setId($this->getInsertInstitutionId());
		return $institution->getId();
        }
	
	function deleteInstitutionById($institutionId) {
		return $this->update('DELETE FROM institutions WHERE institution_id = ?', array($institutionId));
	}
	
	function updateInstitution(&$institution){

		return $this->update(
			'UPDATE institutions
				SET
					type = ?,
					location = ?,
					name = ?,
                                        acronym = ?
				WHERE institution_id = ?',
			array(
				$institution->getInstitutionType(),
				$institution->getInstitutionLocation(),
				$institution->getInstitutionName(),
				$institution->getInstitutionAcronym(),
				$institution->getInstitutionId()                            
			)
		);
	}
        
	/**
	 * Internal function to return a Institution object from a row.
	 * @param $row array
	 * @return Section
	 */
	function &_returnInstitutionFromRow(&$row) {
		$institution = new Institution();
		$institution->setInstitutionId($row['institution_id']);
		$institution->setInstitutionType($row['type']);
		$institution->setInstitutionLocation($row['location']);
		$institution->setInstitutionName($row['name']);
		$institution->setInstitutionAcronym($row['acronym']);

		HookRegistry::call('InstitutionDAO::_returnInstitutionFromRow', array(&$institution, &$row));

		return $institution;
	}
        
        
        
        /**
	 * Get a list of all the available type of institution.
	 * @return int
	 */
	function getInstitutionTypes() {
                $sourceTypesList = array(
                    INSTITUTION_TYPE_PUBLIC => Locale::translate('institution.type.public'),
                    INSTITUTION_TYPE_PRIVATE_PROFIT => Locale::translate('institution.type.privateProfit'),
                    INSTITUTION_TYPE_PRIVATE_NON_PROFIT => Locale::translate('institution.type.privateNonProfit'),
                    INSTITUTION_TYPE_PRIVATE_INDIVIDUAL => Locale::translate('institution.type.privateIndividual'),
                );                
		return $sourceTypesList;
	}
        
        
        /**
	 * Check if a institution exists with the specified name.
	 * @param $name string
	 * @param $institutionId int optional, ignore matches with this institution ID
	 * @return boolean
	 */
	function institutionExistsByName($name, $institutionId = null) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM institutions WHERE name = ?' . (isset($institutionId) ? ' AND institution_id != ?' : ''),
			isset($institutionId) ? array($name, (int) $institutionId) : array($name)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);
		return $returner;
	}
        
        
        /**
	 * Check if a institution exists with the specified acronym.
	 * @param $acronym string
	 * @param $institutionId int optional, ignore matches with this institution ID
	 * @return boolean
	 */
	function institutionExistsByAcronym($acronym, $institutionId = null) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM institutions WHERE acronym = ?' . (isset($institutionId) ? ' AND institution_id != ?' : ''),
			isset($institutionId) ? array($acronym, (int) $institutionId) : array($acronym)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}
        
        
        /**
	 * Get the ID of the last inserted institution.
	 * @return int
	 */
	function getInsertInstitutionId() {
		return $this->getInsertId('institutions', 'institution_id');
	}        
}

?>