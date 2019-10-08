<?php

/**
 * @file classes/submission/reviewer/ReviewerSubmissionDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ReviewerSubmissionDAO
 * @ingroup submission
 * @see ReviewerSubmission
 *
 * @brief Operations for retrieving and modifying ReviewerSubmission objects.
 */

// $Id$


import('classes.submission.reviewer.ReviewerSubmission');

class ReviewerSubmissionDAO extends DAO {
	var $articleDao;
	var $authorDao;
	var $userDao;
	var $reviewAssignmentDao;
	var $articleFileDao;
	var $suppFileDao;
	var $articleCommentDao;
	var $sectionDecisionDao;

	/**
	 * Constructor.
	 */
	function ReviewerSubmissionDAO() {
		parent::DAO();
		$this->articleDao =& DAORegistry::getDAO('ArticleDAO');
		$this->authorDao =& DAORegistry::getDAO('AuthorDAO');
		$this->userDao =& DAORegistry::getDAO('UserDAO');
		$this->reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$this->articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$this->suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$this->articleCommentDao =& DAORegistry::getDAO('ArticleCommentDAO');
		$this->sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
	}

	/**
	 * Retrieve a reviewer submission by review ID.
	 * @param $reviewId int
	 * @return ReviewerSubmission
	 */
	function &getReviewerSubmission($reviewId) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$result =& $this->retrieve(
			'SELECT	a.*,
				r.reviewer_id,
				u.first_name, u.last_name,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN section_decisions sd ON (a.article_id = sd.article_id)
				LEFT JOIN review_assignments r ON (sd.section_decision_id = r.decision_id)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
                                LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_settings stpl ON (sdec.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (sdec.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				LEFT JOIN section_settings sapl ON (sdec.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (sdec.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
			WHERE	r.review_id = ? AND sdec2.section_decision_id IS NULL',
			array(
				'title',
				$primaryLocale,
				'title',
				$locale,
				'abbrev',
				$primaryLocale,
				'abbrev',
				$locale,
				$reviewId
			)
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnReviewerSubmissionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}
	
        /**
	 * Retrieve a reviewer submission by article and reviewer ID.
	 * @param $articleId int
	 * @param $reviewerId int
	 * @return ReviewerSubmission
	 */
	function &getReviewerSubmissionByArticleAndReviewerId($articleId, $reviewerId) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$result =& $this->retrieve(
			'SELECT	a.*,
				r.reviewer_id,
				u.first_name, u.last_name,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN section_decisions sd ON (a.article_id = sd.article_id)
				LEFT JOIN review_assignments r ON (sd.section_decision_id = r.decision_id)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_settings stpl ON (sdec.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (sdec.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				LEFT JOIN section_settings sapl ON (sdec.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (sdec.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
			WHERE	a.article_id = ? AND r.reviewer_id = ? GROUP BY a.article_id',
			array(
				'title',
				$primaryLocale,
				'title',
				$locale,
				'abbrev',
				$primaryLocale,
				'abbrev',
				$locale,
				$articleId,
                                $reviewerId
			)
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnReviewerSubmissionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}
        
	/**
	 * Retrieve a reviewer submission from meeting by article ID.
	 * @param $articleId int
	 * @param $reviewerId int
	 * @return ReviewerSubmission
	 */
	function &getReviewerSubmissionFromMeeting($articleId) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$result =& $this->retrieve(
			'SELECT	a.*,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
                                LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				LEFT JOIN section_settings stpl ON (sdec.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (sdec.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				LEFT JOIN section_settings sapl ON (sdec.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (sdec.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
			WHERE	a.article_id = ? AND sdec2.section_decision_id IS NULL',
			array(
				'title',
				$primaryLocale,
				'title',
				$locale,
				'abbrev',
				$primaryLocale,
				'abbrev',
				$locale,
				$articleId
			)
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnReviewerSubmissionFromRow($result->GetRowAssoc(false), false);
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Internal function to return a ReviewerSubmission object from a row.
	 * @param $row array
	 * @return ReviewerSubmission
	 * Last modified EL on March 4th 2013
	 */
	function &_returnReviewerSubmissionFromRow(&$row, $assignedReviewer = true) {
		$reviewerSubmission = new ReviewerSubmission();
                
                // Reviewer
                if ($assignedReviewer) {
                    $reviewerSubmission->setReviewerId($row['reviewer_id']);
                    if (isset($row['first_name']) && isset($row['last_name'])) $reviewerSubmission->setReviewerFullName($row['first_name'].' '.$row['last_name']);                    
                }
                
                // Files
                import('classes.file.ArticleFileManager');
		$reviewerSubmission->setSubmissionFile($this->articleFileDao->getArticleFile($row['submission_file_id']));
		$reviewerSubmission->setRevisedFile($this->articleFileDao->getArticleFile($row['revised_file_id']));
		$reviewerSubmission->setReportFiles($this->articleFileDao->getArticleFilesByType($row['article_id'], ARTICLE_FILE_REPORT));
		$reviewerSubmission->setSAEFiles($this->articleFileDao->getArticleFilesByType($row['article_id'], ARTICLE_FILE_SAE));
		$reviewerSubmission->setSuppFiles($this->suppFileDao->getSuppFilesByArticle($row['article_id']));
		$reviewerSubmission->setReviewFile($this->articleFileDao->getArticleFile($row['review_file_id']));
		if (isset($row['reviewer_file_id'])) $reviewerSubmission->setReviewerFile($this->articleFileDao->getArticleFile($row['reviewer_file_id']));

		// Comments
		if (isset($row['review_id'])) $reviewerSubmission->setMostRecentPeerReviewComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_PEER_REVIEW, $row['review_id']));

		// Committee Decisions
		$reviewerSubmission->setDecisionsAndAssignments($this->sectionDecisionDao->getSectionDecisionsByArticleId($row['article_id']));

		// Article attributes
		$this->articleDao->_articleFromRow($reviewerSubmission, $row);

		
		
		HookRegistry::call('ReviewerSubmissionDAO::_returnReviewerSubmissionFromRow', array(&$reviewerSubmission, &$row));
		
		return $reviewerSubmission;
	}

	/**
	 * Update an existing review submission.
	 * @param $reviewSubmission ReviewSubmission
	 */
	function updateReviewerSubmission(&$reviewerSubmission) {
		return $this->update(
			sprintf('UPDATE review_assignments
				SET	decision_id = ?,
					reviewer_id = ?,
					competing_interests = ?,
					recommendation = ?,
					declined = ?,
					replaced = ?,
					cancelled = ?,
					date_assigned = %s,
					date_notified = %s,
					date_confirmed = %s,
					date_completed = %s,
					date_acknowledged = %s,
					date_due = %s,
					reviewer_file_id = ?,
					quality = ?
				WHERE	review_id = ?',
				$this->datetimeToDB($reviewerSubmission->getDateAssigned()), $this->datetimeToDB($reviewerSubmission->getDateNotified()), $this->datetimeToDB($reviewerSubmission->getDateConfirmed()), $this->datetimeToDB($reviewerSubmission->getDateCompleted()), $this->datetimeToDB($reviewerSubmission->getDateAcknowledged()), $this->datetimeToDB($reviewerSubmission->getDateDue())),
			array(
				$reviewerSubmission->getLastSectionDecisionId(),
				$reviewerSubmission->getReviewerId(),
				$reviewerSubmission->getCompetingInterests(),
				$reviewerSubmission->getRecommendation(),
				$reviewerSubmission->getDeclined(),
				$reviewerSubmission->getReplaced(),
				$reviewerSubmission->getCancelled(),
				$reviewerSubmission->getReviewerFileId(),
				$reviewerSubmission->getQuality(),
				$reviewerSubmission->getReviewId()
			)
		);
	}

	function &getReviewerSubmissionByReviewerAndDecisionId($reviewerId, $decisionId, $journalId, $active = true) {
	$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$sql = 'SELECT	a.*,
				r.reviewer_id,
				u.first_name, u.last_name,
				ab.clean_scientific_title AS submission_title,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN section_decisions sd ON (a.article_id = sd.article_id)
				LEFT JOIN review_assignments r ON (sd.section_decision_id = r.decision_id)
				LEFT JOIN article_abstract ab ON (ab.article_id = a.article_id)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
                                LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_settings stpl ON (sdec.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (sdec.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				LEFT JOIN section_settings sapl ON (sdec.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (sdec.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
			WHERE	a.journal_id = ? AND 
                                sdec2.section_decision_id IS NULL AND
				r.reviewer_id = ? AND
				r.decision_id = ? AND
				r.date_notified IS NOT NULL';

		if ($active) {
			$sql .=  ' AND r.date_completed IS NULL AND r.declined <> 1 AND (r.cancelled = 0 OR r.cancelled IS NULL)';
		} else {
			$sql .= ' AND (r.date_completed IS NOT NULL OR r.cancelled = 1 OR r.declined = 1)';
		}
                $sql .= ' GROUP BY a.article_id';
		$result =& $this->retrieve(
			$sql,
			array(
				'title', // Section title
				$primaryLocale,
				'title',
				$locale,
				'abbrev', // Section abbreviation
				$primaryLocale,
				'abbrev',
				$locale,
				$journalId,
				$reviewerId,
				$decisionId
			)
		);
		$review = null;
		$review =& $this->_returnReviewerSubmissionFromRow($result->GetRowAssoc(false));
		
		$result->Close();
		unset($result);

		return $review;
	}
	
	/**
	 * Get all submissions for a reviewer of a journal.
	 * Added filtering
	 * Last Updated by EL 4/03/2013
	 * @param $reviewerId int
	 * @param $journalId int
	 * @param $rangeInfo object
	 * @return array ReviewerSubmissions
	 */
	function &getReviewerSubmissionsByReviewerId($reviewerId, $journalId, $active = true, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$params = array(
				'proposalCountry',
				'proposalCountry',
				$locale,
				$journalId,
				$reviewerId);
		$searchSql = '';
		
		if (!empty($search)) switch ($searchField) {
			case SUBMISSION_FIELD_TITLE:
				if ($searchMatch === 'is') {
					$searchSql = ' AND LOWER(ab.scientific_title) = LOWER(?)';
				} elseif ($searchMatch === 'contains') {
					$searchSql = ' AND LOWER(ab.scientific_title) LIKE LOWER(?)';
					$search = '%' . $search . '%';
				} else { // $searchMatch === 'startsWith'
					$searchSql = ' AND LOWER(ab.scientific_title) LIKE LOWER(?)';
					$search = $search . '%';
				}
				$params[] = $search;
				break;
			case SUBMISSION_FIELD_AUTHOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'aa.', $params);
				break;
			case SUBMISSION_FIELD_EDITOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'sd.', $params);
				break;
			case SUBMISSION_FIELD_REVIEWER:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 're.', $params);
				break;
			case SUBMISSION_FIELD_COPYEDITOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'ce.', $params);
				break;
			case SUBMISSION_FIELD_LAYOUTEDITOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'le.', $params);
				break;
			case SUBMISSION_FIELD_PROOFREADER:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'pe.', $params);
				break;
		}
		if (!empty($dateFrom) || !empty($dateTo)) switch($dateField) {
			case SUBMISSION_FIELD_DATE_SUBMITTED:
				if (!empty($dateFrom)) {
					$searchSql .= ' AND a.date_submitted >= ' . $this->datetimeToDB($dateFrom);
				}
				if (!empty($dateTo)) {
					$searchSql .= ' AND a.date_submitted <= ' . $this->datetimeToDB($dateTo);
				}
				break;
		}
				
		$sql = 'SELECT	DISTINCT a.*,
				r.reviewer_id,
				u.first_name, u.last_name,
				ab.clean_scientific_title AS submission_title
			FROM	articles a
				LEFT JOIN section_decisions sd ON (a.article_id = sd.article_id)
				LEFT JOIN authors aa ON (aa.submission_id = a.article_id AND aa.primary_contact = 1)
				LEFT JOIN review_assignments r ON (sd.section_decision_id = r.decision_id)
				LEFT JOIN article_abstract ab ON (ab.article_id = a.article_id)
				LEFT JOIN article_settings appc ON (a.article_id = appc.article_id AND appc.setting_name = ? AND appc.locale = a.locale)
				LEFT JOIN article_settings apc ON (a.article_id = apc.article_id AND apc.setting_name = ? AND apc.locale = ?)
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
			WHERE	a.journal_id = ? AND
				r.reviewer_id = ? AND
				r.date_notified IS NOT NULL AND
				r.date_due IS NOT NULL';	
				
		if ($active) {
			$sql .=  ' AND r.date_completed IS NULL AND r.declined <> 1 AND (r.cancelled = 0 OR r.cancelled IS NULL) AND (sd.decision = '.SUBMISSION_SECTION_DECISION_FULL_REVIEW.' OR sd.decision = '.SUBMISSION_SECTION_DECISION_EXPEDITED.')';
		} else {
			$sql .= ' AND (r.date_completed IS NOT NULL OR r.cancelled = 1 OR r.declined = 1 OR sd.decision = '.SUBMISSION_SECTION_DECISION_APPROVED.' OR sd.decision = '.SUBMISSION_SECTION_DECISION_RESUBMIT.' OR sd.decision = '.SUBMISSION_SECTION_DECISION_DECLINED.' OR sd.decision = '.SUBMISSION_SECTION_DECISION_DONE.')';
		}
		
		$result =& $this->retrieveRange(
			$sql . ' ' . $searchSql. ' GROUP BY a.article_id' . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
			count($params)===1?array_shift($params):$params,
			$rangeInfo
		);

		$returner = new DAOResultFactory($result, $this, '_returnReviewerSubmissionFromRow');
		return $returner;
	}


	/**
	 * Get all submissions subject to a meeting where the reviewer is invited
	 * Added by EL on March 4th 2013
	 * @param $reviewerId int
	 * @param $journalId int
	 * @param $rangeInfo object
	 * @return array ReviewerSubmissions
	 */
	function &getReviewerMeetingSubmissionsByReviewerId($reviewerId, $journalId, $searchField = null, $searchMatch = null, $search = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$params = array($reviewerId);
		$searchSql = '';
		
		if (!empty($search)) switch ($searchField) {
			case SUBMISSION_FIELD_TITLE:
				if ($searchMatch === 'is') {
					$searchSql = ' AND LOWER(ab.scientific_title) = LOWER(?)';
				} elseif ($searchMatch === 'contains') {
					$searchSql = ' AND LOWER(ab.scientific_title) LIKE LOWER(?)';
					$search = '%' . $search . '%';
				} else {
					$searchSql = ' AND LOWER(ab.scientific_title) LIKE LOWER(?)';
					$search = $search . '%';
				}
				$params[] = $search;
				break;
			case SUBMISSION_FIELD_AUTHOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'aa.', $params);
				break;
		}
		
		$sql = 'SELECT	DISTINCT a.*,
				ma.user_id as reviewer_id,
				u.first_name, u.last_name,
				ab.clean_scientific_title AS submission_title
			FROM	articles a
                                LEFT JOIN section_decisions sd ON (sd.article_id = a.article_id)
				LEFT JOIN authors aa ON (aa.submission_id = a.article_id AND aa.primary_contact = 1)
				LEFT JOIN article_abstract ab ON (ab.article_id = a.article_id)
				LEFT JOIN meeting_section_decisions msd ON (sd.section_decision_id = msd.section_decision_id)
				LEFT JOIN meeting_attendance ma ON (msd.meeting_id = ma.meeting_id)
				LEFT JOIN users u ON (ma.user_id = u.user_id)
			WHERE	ma.user_id = ?';	
		
		$result =& $this->retrieveRange(
			$sql . ' ' . $searchSql. ' GROUP BY a.article_id' . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
			count($params)===1?array_shift($params):$params,
			$rangeInfo
		);
                
		$returner = new DAOResultFactory($result, $this, '_returnReviewerSubmissionFromRow');
		return $returner;
	}
		

	/**
	 * FIXME Move this into somewhere common (SubmissionDAO?) as this is used in several classes.
	 */
	function _generateUserNameSearchSQL($search, $searchMatch, $prefix, &$params) {
		$first_last = $this->_dataSource->Concat($prefix.'first_name', '\' \'', $prefix.'last_name');
		$first_middle_last = $this->_dataSource->Concat($prefix.'first_name', '\' \'', $prefix.'middle_name', '\' \'', $prefix.'last_name');
		$last_comma_first = $this->_dataSource->Concat($prefix.'last_name', '\', \'', $prefix.'first_name');
		$last_comma_first_middle = $this->_dataSource->Concat($prefix.'last_name', '\', \'', $prefix.'first_name', '\' \'', $prefix.'middle_name');
		if ($searchMatch === 'is') {
			$searchSql = " AND (LOWER({$prefix}last_name) = LOWER(?) OR LOWER($first_last) = LOWER(?) OR LOWER($first_middle_last) = LOWER(?) OR LOWER($last_comma_first) = LOWER(?) OR LOWER($last_comma_first_middle) = LOWER(?))";
		} elseif ($searchMatch === 'contains') {
			$searchSql = " AND (LOWER({$prefix}last_name) LIKE LOWER(?) OR LOWER($first_last) LIKE LOWER(?) OR LOWER($first_middle_last) LIKE LOWER(?) OR LOWER($last_comma_first) LIKE LOWER(?) OR LOWER($last_comma_first_middle) LIKE LOWER(?))";
			$search = '%' . $search . '%';
		} else { // $searchMatch === 'startsWith'
			$searchSql = " AND (LOWER({$prefix}last_name) LIKE LOWER(?) OR LOWER($first_last) LIKE LOWER(?) OR LOWER($first_middle_last) LIKE LOWER(?) OR LOWER($last_comma_first) LIKE LOWER(?) OR LOWER($last_comma_first_middle) LIKE LOWER(?))";
			$search = $search . '%';
		}
		$params[] = $params[] = $params[] = $params[] = $params[] = $search;
		return $searchSql;
	}
	/**
	 * Get count of active and complete assignments
	 * @param reviewerId int
	 * @param journalId int
	 */
	function getSubmissionsCount($reviewerId, $journalId) {
		$submissionsCount = array();
		$submissionsCount[0] = 0;
		$submissionsCount[1] = 0;

		$sql = 'SELECT	r.date_completed, r.declined, r.cancelled
			FROM	articles a
				LEFT JOIN section_decisions sd ON (a.article_id = sd.article_id)
				LEFT JOIN review_assignments r ON (sd.section_decision_id = r.decision_id)
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
			WHERE	a.journal_id = ? AND
				r.reviewer_id = ? AND
				r.date_notified IS NOT NULL';

		$result =& $this->retrieve($sql, array($journalId, $reviewerId));
		
		while (!$result->EOF) {
			if ($result->fields['date_completed'] == null && $result->fields['declined'] != 1 && $result->fields['cancelled'] != 1) {
				$submissionsCount[0] += 1;
			} else {
				$submissionsCount[1] += 1;
			}
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $submissionsCount;
	}
	
/**
	 * Get count of active and complete assignments
	 * @param reviewerId int
	 * @param journalId int
	 */
	function getSubmissionsForERCReviewCount($reviewerId, $journalId) {
		$submissionsCount = array();
		$submissionsCount[0] = 0;
		$submissionsCount[1] = 0;

		$sql = 'SELECT	r.date_completed, r.declined, r.cancelled, sd.decision
			FROM	articles a
				LEFT JOIN section_decisions sd ON (sd.article_id = a.article_id)
				LEFT JOIN review_assignments r ON (sd.section_decision_id = r.decision_id)
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
			WHERE	a.journal_id = ? AND
				r.reviewer_id = ? AND
				r.date_notified IS NOT NULL AND
				r.date_due IS NOT NULL';

		$result =& $this->retrieve($sql, array($journalId, $reviewerId));
		
		while (!$result->EOF) {
			if ($result->fields['date_completed'] == null && $result->fields['declined'] != 1 && $result->fields['cancelled'] != 1 && ($result->fields['decision'] == 7 || $result->fields['decision'] == 8)) {
				$submissionsCount[0] += 1;
			} else {
				$submissionsCount[1] += 1;
			}
			$result->moveNext();
		}

		$result->Close();
		unset($result);
		
		return $submissionsCount;
	}
	
	/**
	 * Map a column heading value to a database value for sorting
	 * @param string
	 * @return string
	 */
	function getSortMapping($heading) {
		switch ($heading) {
			case 'id': return 'a.article_id';
			case 'assignDate': return 'r.date_assigned';
			case 'dueDate': return 'r.date_due';
			case 'section': return 'section_abbrev';
			case 'title': return 'submission_title';
			case 'review': return 'r.recommendation';
			default: return null;
		}
	}
	
}

?>
