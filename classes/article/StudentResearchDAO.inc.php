<?php

/**
 * @file classes/article/StudentResearchDAO.inc.php
 *
 * @class StudentResearchDAO
 *
 * @brief Operations for retrieving and modifying details on student research objects.
 */

// $Id$

import('classes.article.StudentResearch');

class StudentResearchDAO extends DAO{

        /**
	 * Constructor.
	 */
	function StudentResearchDAO() {
		parent::DAO();
        }

        /**
	 * Get the student research details for a submission.
	 * @param $submissionId int
	 * @return studentResearch object
	 */
	function &getStudentResearchByArticleId($submissionId) {

		$result =& $this->retrieve(
			'SELECT * FROM article_student WHERE article_id = ? LIMIT 1',
			(int) $submissionId
		);

		$studentResearch =& $this->_returnStudentResearchFromRow($result->GetRowAssoc(false));

		$result->Close();
		unset($result);

		return $studentResearch;
	}

	/**
	 * Insert a new student research object.
	 * @param $studentResearch object
	 */
	function insertStudentResearch(&$studentResearch) {
		$this->update(
			'INSERT INTO article_student
				(article_id, institution, degree, supervisor_name, supervisor_email)
				VALUES			
                                (?, ?, ?, ?, ?)',
			array(
				(int) $studentResearch->getArticleId(),
				(string) $studentResearch->getInstitution(),
				(int) $studentResearch->getDegree(),
				(string) $studentResearch->getSupervisorName(),
				(string) $studentResearch->getSupervisorEmail()
			)
		);
		
		return true;
	}

	/**
	 * Update an existing student research object.
	 * @param $studentResearch student research object
	 */
	function updateStudentResearch(&$studentResearch) {
		$returner = $this->update(
			'UPDATE article_student
			SET	
				institution = ?,
				degree = ?, 
				supervisor_name = ?,
				supervisor_email = ?
			WHERE	article_id = ?',
			array(
				(string) $studentResearch->getInstitution(),
				(int) $studentResearch->getDegree(),
				(string) $studentResearch->getSupervisorName(),
				(string) $studentResearch->getSupervisorEmail(),
				(int) $studentResearch->getArticleId()
			)
		);
		return true;
	}

	/**
	 * Delete a specific student research by article ID
	 * @param $submissionId int
	 */
	function deleteStudentResearch($submissionId) {
		$returner = $this->update(
			'DELETE FROM article_student WHERE article_id = ?',
			$submissionId
		);
		return $returner;
	}

	/**
	 * Check if a student research exists
	 * @param $submissionId int
	 * @return boolean
	 */
	function studentResearchExists($submissionId) {
		$result =& $this->retrieve('SELECT count(*) FROM article_student WHERE article_id = ?', (int) $submissionId);
		$returner = $result->fields[0]?true:false;
		$result->Close();
		return $returner;
	}
        
        /**
	 * Internal function to return a student research object from a row.
	 * @param $row array
	 * @return StudentResearch object
	 */
	function &_returnStudentResearchFromRow(&$row) {
            
		$studentResearch = new StudentResearch();
                
		$studentResearch->setArticleId($row['article_id']);
		$studentResearch->setInstitution($row['institution']);
		$studentResearch->setDegree($row['degree']);
		$studentResearch->setSupervisorName($row['supervisor_name']);
                $studentResearch->setSupervisorEmail($row['supervisor_email']);

		HookRegistry::call('StudentResearchDAO::_returnStudentResearchFromRow', array(&$studentResearch, &$row));

		return $studentResearch;
	}
        
        function getAcademicDegreesArray(){
            return array(
                STUDENT_DEGREE_UNDERGRADUATE => Locale::translate('proposal.undergraduate'),
                STUDENT_DEGREE_MASTER => Locale::translate('proposal.master'),
                STUDENT_DEGREE_POST_DOC => Locale::translate('proposal.postDoc'),
                STUDENT_DEGREE_PHD => Locale::translate('proposal.phd'),
                STUDENT_DEGREE_OTHER => Locale::translate('common.other')
            );
        }

}

?>
