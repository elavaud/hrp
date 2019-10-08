<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/StudentResearch.inc.php
 *
 *
 * @brief Student Research class.
 */

// For degrees
define ('STUDENT_DEGREE_UNDERGRADUATE', 1);
define ('STUDENT_DEGREE_MASTER', 2);
define ('STUDENT_DEGREE_POST_DOC', 3);
define ('STUDENT_DEGREE_PHD', 4);
define ('STUDENT_DEGREE_OTHER', 5);
define ('STUDENT_DEGREE_NOT_PROVIDED', 9);

class StudentResearch extends DataObject {
	
        
	/**
	 * Constructor.
	 */
	function StudentResearch() {
	}

        
	/**
	 * Set article id.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		return $this->setData('articleId', $articleId);
	}    
	/**
	 * Get article id.
	 * @return int
	 */
	function getArticleId() {
		return $this->getData('articleId');
	}

 
	/**
	 * Set the institution of the student(s).
	 * @param $institution string
	 */
	function setInstitution($institution) {
		return $this->setData('institution', $institution);
	}       
	/**
	 * Get the institution of the student(s).
	 * @return string
	 */
	function getInstitution() {
		return $this->getData('institution');
	}


        /**
	 * Set the academic degree concerned by the research.
	 * @param $degree int
	 */
	function setDegree($degree) {
		return $this->setData('degree', $degree);
	}
	/**
	 * Get the academic degree concerned by the research.
	 * @return int
	 */
	function getDegree() {
		return $this->getData('degree');
	}
        /**
	 * Get a map for degree constant to locale key.
	 * @return array
	 */
	function &getDegreeMap() {
		static $degreeMap;
		if (!isset($degreeMap)) {
			$degreeMap = array(
                                STUDENT_DEGREE_NOT_PROVIDED => 'common.dataNotProvided',
				STUDENT_DEGREE_UNDERGRADUATE => 'proposal.undergraduate',
				STUDENT_DEGREE_MASTER => 'proposal.master',
				STUDENT_DEGREE_POST_DOC => 'proposal.postDoc',
				STUDENT_DEGREE_PHD => 'proposal.phd',
				STUDENT_DEGREE_OTHER => 'common.other'
			);
		}
		return $degreeMap;
	}
	/**
	 * Get a locale key for the degree
	 * @param $value
	 */
	function getDegreeKey() {
		$degreeMap =& $this->getDegreeMap();
		return $degreeMap[$this->getDegree()];
	}
        

	/**
	 * Set the full name and title of the supervisor.
	 * @param $supervisorName string
	 */
	function setSupervisorName($supervisorName) {
		return $this->setData('supervisorName', $supervisorName);
	}
	/**
	 * Get the full name and title of the supervisor.
	 * @return string
	 */
	function getSupervisorName() {
		return $this->getData('supervisorName');
	}


        /**
	 * Set the email of the supervisor.
	 * @param $supervisorEmail string
	 */
	function setSupervisorEmail($supervisorEmail) {
		return $this->setData('supervisorEmail', $supervisorEmail);
	}
	/**
	 * Get the email of the supervisor.
	 * @return string
	 */
	function getSupervisorEmail() {
		return $this->getData('supervisorEmail');
	}
}
?>
