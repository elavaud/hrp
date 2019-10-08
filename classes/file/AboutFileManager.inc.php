<?php

/**
 * @file classes/file/AboutFileManager.inc.php
 *
 *
 * @class AboutFileManager
 * @ingroup file
 * @see AboutFileDAO
 *
 * @brief Class defining operations for about file management.
 */

// $Id$


import('lib.pkp.classes.file.FileManager');
import('classes.file.AboutFile');

class AboutFileManager extends FileManager {

        /** @var string the path to location of the files */
	var $filesDir;

	/**
	 * Constructor
	 */
	function AboutFileManager() {
		parent::FileManager();
		$this->filesDir = str_replace('classes','public/about/', dirname(realpath(__DIR__)));
	}

	/**
	 * Retrieve file information by file ID.
	 * @return TemporaryFile
	 */
	function &getFile($fileId) {
		$aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
		$aboutFile =& $aboutFileDao->getAboutFile($fileId);
		return $aboutFile;
	}

	/**
	 * Read a file's contents.
	 * @param $output boolean output the file's contents instead of returning a string
	 * @return boolean
	 */
	function readFile($fileId, $output = false) {
		$aboutFile =& $this->getFile($fileId);

		if (isset($aboutFile)) {
			$filePath = $this->filesDir . $aboutFile->getFileName();
			return parent::readFile($filePath, $output);
		} else {
			return false;
		}
	}

	/**
	 * Delete a file by ID.
	 * @param $fileId int
	 */
	function deleteFile($fileId) {
                
                if ($fileId != 0) {
                    $aboutFile =& $this->getFile($fileId);

                    parent::deleteFile($this->filesDir . $aboutFile->getFileName());
                }
	}
        
        /**
	 * Delete a file by ID.
	 * @param $fileId int
	 */
	function deleteAboutFile($fileId) {
                
                if ($fileId != 0) {
                    $aboutFile =& $this->getFile($fileId);

                    parent::deleteFile($this->filesDir . $aboutFile->getFileName());

                    $aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
                    $aboutFileDao->deleteAboutFileById($fileId);
                }
	}

	/**
	 * Download a file.
	 * @param $fileId int the file id of the file to download
	 * @param $inline print file as inline instead of attachment, optional
	 * @return boolean
	 */
	function downloadFile($fileId, $inline = false) {
		$aboutFile =& $this->getFile($fileId);
		if (isset($aboutFile)) {
			$filePath = $this->filesDir . $aboutFile->getFileName();
			return parent::downloadFile($filePath, null, $inline);
		} else {
			return false;
		}
	}

	/**
	 * View a file inline (variant of downloadFile).
	 * @see PKPTemporaryFileManager::downloadFile
	 */
	function viewFile($fileId) {
		$this->downloadFile($fileId, true);
	}

	/**
	 * Parse the file extension from a filename/path.
	 * @param $fileName string
	 * @return string
	 */
	function parseFileExtension($fileName) {
		$fileParts = explode('.', $fileName);
		if (is_array($fileParts)) {
			$fileExtension = $fileParts[count($fileParts) - 1];
		}

		// FIXME Check for evil
		if (!isset($fileExtension) || strstr($fileExtension, 'php') || strlen($fileExtension) > 6 || !preg_match('/^\w+$/', $fileExtension)) {
			$fileExtension = 'txt';
		}

		return $fileExtension;
	}

	/**
	 * Upload the file and add it to the database.
	 * @param $fileName string index into the $_FILES array
	 * @return object The new AboutFile or false on failure
	 */
	function handleUpload($fileName, $type, $aboutFileId = 0) {
            
                if (HookRegistry::call('AboutFileManager::handleUpload', array(&$fileName, &$type, &$result))) return $result;

		if (!$this->fileExists($this->filesDir, 'dir')) {
			// Try to create destination directory
			$this->mkdirtree($this->filesDir);
		}
		$newFileName = $this->generateFilename($fileName);
                
		if (!$newFileName) return false;

                if ($this->uploadFile($fileName, $this->filesDir . $newFileName)) {
                        $aboutFileDao =& DAORegistry::getDAO('AboutFileDAO');
                        
                        if ($aboutFileId == 0 || $aboutFileId == null) $aboutFile = new AboutFile();
                        else $aboutFile =& $aboutFileDao->getAboutFile($aboutFileId);
                        
			$aboutFile->setFileName($newFileName);
			$aboutFile->setAboutFileType($type);
                        $aboutFile->setAboutFileOrinalName(AboutFileManager::truncateFileName($_FILES[$fileName]['name'], 127));                        
			$aboutFile->setFileType($_FILES[$fileName]['type']);
			$aboutFile->setFileSize($_FILES[$fileName]['size']);
			
                        if ($aboutFileId == 0 || $aboutFileId == null) $aboutFileId = $aboutFileDao->insertAboutFile($aboutFile);
                        else $aboutFileDao->updateAboutFile($aboutFile);
                        
			return $aboutFileId;
		} else {
			return false;
		}
	}
        
        /**
	 * PRIVATE routine to generate a filename for an article file. Sets the filename
	 * field in the articleFile to the generated value.
	 * @param $originalName The name of the original file
	 */
	function generateFilename(&$fileName) {
            
		$fileExtension = $this->parseFileExtension($this->getUploadedFileName($fileName));
                
                $fname = $this->getUploadedFileName($fileName);
                
                $fnameWithoutExtension = substr($fname, 0, -(strlen($fileExtension)+1));  // returns "abcde"

                $replace="_"; 
                $pattern="/([[:alnum:]_\.-]*)/u"; 
                $bad_chars=preg_replace($pattern,$replace,$fnameWithoutExtension);
                $bad_arr=str_split($bad_chars); 
                $newFileName=str_replace($bad_arr,$replace,$fnameWithoutExtension);
                
                $i = 1;
                while (file_exists($this->filesDir.$newFileName.'.'.$fileExtension)) {
                    $newFileName = $newFileName.'-'.$i;
                    $i++;
                }

                return $newFileName.'.'.$fileExtension;
	}

}

?>
