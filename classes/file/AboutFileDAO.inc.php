<?php


import('classes.file.AboutFile');

class AboutFileDAO extends DAO {

        
	/**
	 * Constructor
	 */        
	function AboutFileDAO() {
		parent::DAO();
	}
                
        /**
	 * Insert a new about file.
	 * @param $aboutFile AboutFile
	 */
	function insertAboutFile(&$aboutFile) {
		$this->update(
			'INSERT INTO about_file
				(name, file_type, file_size, original_file_name, type)
				VALUES
				(?, ?, ?, ?, ?)',
			array(
				$aboutFile->getFileName(),
				$aboutFile->getFileType(),
				$aboutFile->getFileSize(),
				$aboutFile->getAboutFileOriginalName(),
				$aboutFile->getAboutFileType()
			)
		);

		$aboutFile->setId($this->getInsertAboutFileId());
		$this->updateLocaleFields($aboutFile);
		return $aboutFile->getId();
	}
        
	/**
	 * Update an existing about file.
	 * @param $aboutFile AboutFile
	 */
	function updateAboutFile(&$aboutFile) {
		$returner = $this->update(
			'UPDATE about_file
				SET
					name = ?,
					file_type = ?,
					file_size = ?,
					original_file_name = ?,
					type = ?
				WHERE about_file_id = ?',
			array(
				$aboutFile->getFileName(),
				$aboutFile->getFileType(),
				$aboutFile->getFileSize(),
				$aboutFile->getAboutFileOriginalName(),
				$aboutFile->getAboutFileType(),
				$aboutFile->getId()
			)
		);
		$this->updateLocaleFields($aboutFile);
		return $returner;
	}
        
        /**
	 * Retrieve an about file by ID.
	 * @param $aboutFileId int
	 * @return AboutFile
	 */
	function &getAboutFile($aboutFileId) {
		$result =& $this->retrieve(
			'SELECT * FROM about_file WHERE about_file_id = ?',
			(int) $aboutFileId
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnAboutFileFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}
        
        
        /**
	 * Retrieve all about files.
	 * @return array About Files
	 */
	function &getAboutFiles($rangeInfo = null) {
		
		$result =& $this->retrieveRange(
			'SELECT * FROM about_file',array(), $rangeInfo		
                        );
		
		$returner = new DAOResultFactory($result, $this, '_returnAboutFileFromRow');
                
		return $returner;
	}
        
        /**
	 * Retrieve an array of about files matching a particular type.
	 * @param $type int the type to match on
	 * @return array matching About Files
	 */
	function &getAboutFilesByType($type) {
		$aboutFiles = array();
		
		$result =& $this->retrieve(
			'SELECT * FROM about_file WHERE type = ?',
			(int) $type
		);
		
		while (!$result->EOF) {
			$aboutFiles[] =& $this->_returnAboutFileFromRow($result->GetRowAssoc(false));
			$result->moveNext();		
		}

		$result->Close();
		unset($result);
		return $aboutFiles;
	}
        
        /**
	 * Internal function to return a User object from a row.
	 * @param $row array
	 * @param $callHook boolean
	 * @return User
	 */
	function &_returnAboutFileFromRow(&$row, $callHook = true) {
		$aboutFile = new AboutFile();
		$aboutFile->setId($row['about_file_id']);
		$aboutFile->setFileName($row['name']);
		$aboutFile->setFileType($row['file_type']);
		$aboutFile->setFileSize($row['file_size']);
                $aboutFile->setAboutFileOrinalName($row['original_file_name']);
		$aboutFile->setAboutFileType($row['type']);
                
		$this->getDataObjectSettings('about_file_settings', 'about_file_id', $row['about_file_id'], $aboutFile);

		if ($callHook) HookRegistry::call('AboutFileDAO::_returnAboutFileFromRow', array(&$aboutFile, &$row));

		return $aboutFile;
	}
        
        function getLocaleFieldNames() {
		return array('aboutFileName', 'aboutFileDescription');
	}

	function updateLocaleFields(&$aboutFile) {
		$this->updateDataObjectSettings('about_file_settings', $aboutFile, array(
			'about_file_id' => (int) $aboutFile->getId()
		));
	}

	/**
	 * Get the ID of the last inserted about file.
	 * @return int
	 */
	function getInsertAboutFileId() {
		return $this->getInsertId('about_file', 'about_file_id');
	}
        
        /**
	 * Delete an about file by ID.
	 * @param $aboutFileId int
	 */
	function deleteAboutFileById($aboutFileId) {
            
		$this->update('DELETE FROM about_file_settings WHERE about_file_id = ?', array($aboutFileId));
		return $this->update('DELETE FROM about_file WHERE about_file_id = ?', array($aboutFileId));
	}

}

?>
