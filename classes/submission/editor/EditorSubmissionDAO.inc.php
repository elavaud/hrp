<?php

/**
 * @file classes/editor/EditorSubmissionDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class EditorSubmissionDAO
 * @ingroup submission
 * @see EditorSubmission
 *
 * @brief Operations for retrieving and modifying EditorSubmission objects.
 */

// $Id$


import('classes.submission.editor.EditorSubmission');
import('classes.submission.sectionEditor.SectionEditorSubmissionDAO');

// Bring in editor decision constants
import('classes.submission.common.Action');
import('classes.submission.author.AuthorSubmission');

class EditorSubmissionDAO extends DAO {
	var $articleDao;
	var $authorDao;
	var $userDao;
	var $sectionDecisionDao;

	/**
	 * Constructor.
	 */
	function EditorSubmissionDAO() {
		parent::DAO();
		$this->articleDao =& DAORegistry::getDAO('ArticleDAO');
		$this->authorDao =& DAORegistry::getDAO('AuthorDAO');
		$this->userDao =& DAORegistry::getDAO('UserDAO');
		$this->sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
	}

	/**
	 * Retrieve an editor submission by article ID.
	 * @param $articleId int
	 * @return EditorSubmission
	 */
	function &getEditorSubmission($articleId) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$result =& $this->retrieve(
			'SELECT
				a.*,
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
			$returner =& $this->_returnEditorSubmissionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Internal function to return an EditorSubmission object from a row.
	 * @param $row array
	 * @return EditorSubmission
	 */
	function &_returnEditorSubmissionFromRow(&$row) {
		$editorSubmission = new EditorSubmission();

		// Article attributes
		$this->articleDao->_articleFromRow($editorSubmission, $row);

		$editorSubmission->setDecisions($this->sectionDecisionDao->getSectionDecisionsByArticleId($row['article_id']));

		HookRegistry::call('EditorSubmissionDAO::_returnEditorSubmissionFromRow', array(&$editorSubmission, &$row));

		return $editorSubmission;
	}


	/**
	 * Get all unfiltered submissions for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $additionalWhereSql String additional SQL "where" clause info
	 * @param $rangeInfo object
	 * @return array result
	 */
	
	function &_getUnfilteredEditorSubmissions($journalId, $sectionId = null, $editorId = 0, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $additionalWhereSql, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC, $havingSql = null) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$params = array(
			'title', // Section title
			$primaryLocale,
			'title',
			$locale,
			'abbrev', // Section abbrev
			$primaryLocale,
			'abbrev',
			$locale,
			$journalId
		);
		$searchSql = '';
		$researchFieldSql = '';
		$countrySql = '';

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
			case SUBMISSION_FIELD_ID:
				if ($searchMatch === 'is') {
					$searchSql = ' AND LOWER(COALESCE(aid.setting_value, atid.setting_value)) = LOWER(?)';
				} elseif ($searchMatch === 'contains') {
					$searchSql = ' AND LOWER(COALESCE(aid.setting_value, atid.setting_value)) LIKE LOWER(?)';
					$search = '%' . $search . '%';
				} else { // $searchMatch === 'startsWith'
					$searchSql = ' AND LOWER(COALESCE(aid.setting_value, atid.setting_value)) LIKE LOWER(?)';
					$search = $search . '%';
				}
				$params[] = $search;
				break;
			case SUBMISSION_FIELD_AUTHOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'aa.', $params);
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
			case SUBMISSION_FIELD_DATE_APPROVED:
				if (!empty($dateFrom)) {
					$searchSql .= ' AND sdec.date_decided >= ' . $this->datetimeToDB($dateFrom);
				}
				if (!empty($dateTo)) {
					$searchSql .= ' AND sdec.date_decided <= ' . $this->datetimeToDB($dateTo);
				}
				break;
		}
		
		if (!empty($researchFieldField)) {
			$researchFieldSql = ' AND LOWER(ad.research_fields) LIKE LOWER(?)';
			$researchFieldField = '%'.$researchFieldField.'%';
			$params[] = $researchFieldField;
		}
		if (!empty($countryField)) {
			$countrySql = ' AND LOWER(ad.geo_areas) LIKE LOWER(?)';
			$countryField = '%'.$countryField.'%';
			$params[] = $countryField;
		}

                
		$sql = 'SELECT DISTINCT
				a.*,
				ab.clean_scientific_title AS submission_title,
				aap.first_name AS afname, aap.last_name AS alname, 
				aap.affiliation as investigatoraffiliation, aap.email as email,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN authors aa ON (aa.submission_id = a.article_id)
				LEFT JOIN authors aap ON (aap.submission_id = a.article_id AND aap.primary_contact = 1)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN section_editors se ON (se.section_id = sdec.section_id)
				
				LEFT JOIN section_settings stpl ON (sdec.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (sdec.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				
				LEFT JOIN section_settings sapl ON (sdec.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (sdec.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
				
				LEFT JOIN article_abstract ab ON (a.article_id = ab.article_id)
                                
                                LEFT JOIN article_details ad ON (a.article_id = ad.article_id)
                                
                                LEFT JOIN article_student ast ON (a.article_id = ast.article_id)
                                
                                LEFT JOIN article_source asrce ON (a.article_id = asrce.article_id)

                                LEFT JOIN article_risk_assessments ara ON (a.article_id = ara.article_id)

                         WHERE a.journal_id = ?' .
				(!empty($additionalWhereSql)?" $additionalWhereSql":'');
				
		if ($sectionId) {
			$searchSql .= ' AND sdec.section_id = ?';
			$params[] = $sectionId;
		}

		if ($editorId) {
			$searchSql .= ' AND ed.user_id = ?';
			$params[] = $editorId;
		}

		$result =& $this->retrieveRange(
			$sql . ' ' . $searchSql . $researchFieldSql . $countrySql. ' GROUP BY a.article_id' . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : '').$havingSql,
			count($params)===1?array_shift($params):$params,
			$rangeInfo
		);
		return $result;
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
	 * Get all submissions unassigned for a journal.
	 * for including resubmitted proposals into unassigned
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	function &getEditorSubmissionsUnassigned($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED . ' AND (ea.edit_id IS NULL AND a.submission_progress = 0) OR (sdec.decision = 5 AND a.submission_progress = 0)', //and not draft aglet 9/26/2011
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all submissions in review for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	//function &getEditorSubmissionsInReviewIterator($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
	function &getEditorSubmissionsInReviewIterator($editorId, $journalId, $Id, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$rawSubmissions =& $this->_getUnfilteredEditorSubmissions(
					$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED 
			// EL on April 2013: no edit assignments anymore
			//. ' AND e.can_review = 1 '
			,
			$rangeInfo, $sortBy, $sortDirection
				);
		$submissions = new DAOResultFactory($rawSubmissions, $this, '_returnEditorSubmissionFromRow');
		return $submissions;
	}

	/**
	 * Get all submissions in editing for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	function &getEditorSubmissionsInEditingIterator($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED . ' AND ea.edit_id IS NOT NULL AND sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED,
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all submissions archived for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 * ARTICLE STATUS = 9 if proposal is withdrawn
	 * Edited by aglet
	 * Last Update: 6/4/2011
	 */
	function &getEditorSubmissionsArchivesIterator($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, null, null,
			' AND a.status <> '. STATUS_QUEUED,
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all submissions for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	function &getEditorSubmissions($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, null, null,
			null,
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}
	
	/**
	 * Function used for counting purposes for right nav bar
	 * Edited: removed AND a.submission_progress = 0				
	 * Edited by aglet
	 * Last Update: 6/4/2011				
	 */
	function &getEditorSubmissionsCount($journalId) {
		$submissionsCount = array();
		for($i = 0; $i < 3; $i++) {
			$submissionsCount[$i] = 0;
		}

		$result =& $this->retrieve(
			"SELECT	COUNT(*) AS unassigned_count
			FROM	articles a
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
                                LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				LEFT JOIN section_editors se ON (sdec.section_id = se.section_id)
			WHERE	a.journal_id = ? AND sdec2.section_decision_id IS NULL".
				" AND (a.submission_progress = 0 AND a.status = " . STATUS_QUEUED . "
				) OR (sdec.decision = 5 AND a.submission_progress = 0)",
			array((int) $journalId)
		);
		
		$submissionsCount[0] = $result->Fields('unassigned_count');
		$result->Close();

		$result =& $this->retrieve(
			'SELECT	COUNT(*) AS review_count
			FROM	articles a
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				LEFT JOIN section_editors se ON (sdec.section_id = se.section_id)
			WHERE	a.journal_id = ?
				AND a.status = ' . STATUS_QUEUED . '
				AND sdec2.section_decision_id IS NULL ',
			array((int) $journalId)
		);
		
		$submissionsCount[1] = $result->Fields('review_count');
		$result->Close();
		
		$result =& $this->retrieve(
			'SELECT	COUNT(*) AS editing_count
			FROM	articles a
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				LEFT JOIN section_editors se ON (sdec.section_id = se.section_id)
			WHERE	a.journal_id = ?
				AND a.status = ' . STATUS_QUEUED . '
				AND sdec2.section_decision_id IS NULL
				AND sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED,
			array((int) $journalId)
		);
		
		$submissionsCount[2] = $result->Fields('editing_count');
		$result->Close();

		return $submissionsCount;
	}

	//
	// Miscellaneous
	//

	/**
	 * Get the editor decisions for an editor.
	 * @param $userId int
	 */
	function transferSectionDecisions($oldUserId, $newUserId) {
		$this->update(
			'UPDATE section_decisions SET section_id = ? WHERE section_id = ?',
			array($newUserId, $oldUserId)
		);
	}

	/**
	 * Get the ID of the last inserted editor assignment.
	 * @return int
	 */
	function getInsertEditId() {
		return $this->getInsertId('edit_assignments', 'edit_id');
	}

	/**
	 * Map a column heading value to a database value for sorting
	 * @param string
	 * @return string
	 */
	function getSortMapping($heading) {
		switch ($heading) {
			case 'id': return 'a.article_id';
			case 'submitDate': return 'a.date_submitted';
			case 'section': return 'section_abbrev';
			case 'authors': return 'author_name';
			case 'title': return 'submission_title';
			case 'active': return 'a.submission_progress';
			case 'subCopyedit': return 'copyedit_completed';
			case 'subLayout': return 'layout_completed';
			case 'subProof': return 'proofread_completed';
			case 'status': return 'a.status';
			case 'country': return 'appc.setting_value';
			case 'decision': return 'sdec.decision';
			case 'researchField': return 'atu.setting_value';
			default: return null;
		}
	}
	
	/**
	*Added by MSB, Oct12, 2011
	**/
	function getDecisionMapping($decision){
		switch ($decision){
			case 'editor.article.decision.approved': 	return SUBMISSION_SECTION_DECISION_APPROVED;
			case 'editor.article.decision.resubmit': 	return SUBMISSION_SECTION_DECISION_RESUBMIT;
			case 'editor.article.decision.declined': 	return SUBMISSION_SECTION_DECISION_DECLINED;
			case 'editor.article.decision.complete': 	return SUBMISSION_SECTION_DECISION_COMPLETE;
			case 'editor.article.decision.incomplete':	return SUBMISSION_SECTION_DECISION_INCOMPLETE;
			case 'editor.article.decision.exempted': 	return SUBMISSION_SECTION_DECISION_EXEMPTED;
			case 'editor.article.decision.fullReview': 	return SUBMISSION_SECTION_DECISION_FULL_REVIEW;
			case 'editor.article.decision.expedited':	return SUBMISSION_SECTION_DECISION_EXPEDITED;
		}
	}

	function &getEditorSubmissionsForErcReview($editorId, $journalId, $Id) {
		$editorSubmissions = array();
		$result =& $this->_getUnfilteredEditorSubmissions(
			$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, null, null,
			' AND a.status = ' . STATUS_QUEUED . ' AND 
			// EL on April 2013: no edit assignments anymore
			//e.can_review = 1 AND 
			(sdec.decision = ' . SUBMISSION_SECTION_DECISION_FULL_REVIEW . ')',
			$rangeInfo, $sortBy, $sortDirection
		);

		while (!$result->EOF) {
			$editorSubmissions[] =& $this->_returnEditorSubmissionFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $editorSubmissions;
	}
	
	function &getEditorSubmissionsInReview($editorId, $journalId, $Id, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$editorSubmissions = array();
		$result =& $this->_getUnfilteredEditorSubmissions(
			$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED
			 // EL on April 2013: no edit assignments anymore
			 //. ' AND e.can_review = 1 '
			 ,
			$rangeInfo, $sortBy, $sortDirection
		);

		while (!$result->EOF) {
			$editorSubmissions[] =& $this->_returnEditorSubmissionFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $editorSubmissions;
	}
	

	function &getEditorSubmissionsArchives($editorId, $journalId, $Id, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null,$rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$editorSubmissions = array();
		$result = $this->_getUnfilteredEditorSubmissions(
			$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND (a.status <> ' . STATUS_QUEUED . ')',
			$rangeInfo, $sortBy, $sortDirection
		);

       //Array format necessary for pagination in .tpl
       $returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
return $returner;
	}	
	
	
   /**
	* Get all submissions for a report.
	* @param $journalId int
	* @param $sectionId int
	* @param $editorId int
	* @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	* @param $searchMatch string "is" or "contains" or "startsWith"
	* @param $search String to look in $searchField for
	* @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	* @param $dateFrom String date to search from
	* @param $dateTo String date to search to
	* @param $countryFields Array of countries
	* @param $decisionFields Array of decisions
	* @param $researchFieldFields Array of researchFields
	* @param $rangeInfo object
	* @return array EditorSubmission
	*/
	function &getEditorSubmissionsReport(
                        $journalId, $sectionId = 0, $decisionType = INITIAL_REVIEW, $decisionStatus = SUBMISSION_SECTION_DECISION_APPROVED, $decisionAfter = null, $decisionBefore = null,
                        $studentResearch = null, $startAfter = null, $startBefore = null, $endAfter = null, $endBefore = null, $kiiField = array(), $multiCountry = null, $countries = array(), $geoAreas = array(), $researchDomains = array(), $researchFields = array(), $withHumanSubjects = null, $proposalTypes = array(), $dataCollection = null,
                        $budgetOption = "<=", $budget = null, $sources = array(),
                        $identityRevealed = null, $unableToConsent = null, $under18 = null, $dependentRelationship = null, $ethnicMinority = null, $impairment = null, $pregnant = null, $newTreatment = null, $bioSamples = null, $exportHumanTissue = null, $exportReason = null, $radiation = null, $distress = null, $inducements = null, $sensitiveInfo = null, $reproTechnology = null, $genetic = null, $stemCell = null, $biosafety = null
                        ) {
                
            if ($sectionId == 0) {$sectionId = null;}
            
            $sql = "";
            if ($decisionType) {$sql .= " AND sdec.review_type = ".$decisionType;}
            if ($decisionStatus) {
                if ($decisionStatus == 99) {$sql .= " AND (sdec.decision = 1 OR sdec.decision = 2 OR sdec.decision = 3 OR sdec.decision = 6)";}
                elseif ($decisionStatus == SUBMISSION_SECTION_DECISION_APPROVED) {$sql .= " AND (sdec.decision = 1 OR sdec.decision = 6)";}
                elseif ($decisionStatus != 98) {$sql .= " AND sdec.decision = ".$decisionStatus;}
            } 
            if ($decisionAfter && $decisionAfter != "") {
                $decisionAfter = date("Y-m-d", strtotime($decisionAfter));
                if ($decisionStatus != 98) {$sql .= " AND sdec.date_decided >= ".$this->datetimeToDB($decisionAfter);}
                else {$sql .= " AND a.date_submitted >= ".$this->datetimeToDB($decisionAfter);}
            }
            if ($decisionBefore && $decisionBefore != "") {
                $decisionBefore = date("Y-m-d", strtotime($decisionBefore));
                if ($decisionStatus != 98) {$sql .= " AND sdec.date_decided <= ".$this->datetimeToDB($decisionBefore);}
                else {$sql .= " AND a.date_submitted <= ".$this->datetimeToDB($decisionBefore);}
            }

            if ($studentResearch) {$sql .= " AND ad.student = '".$studentResearch."'";}
            if ($startAfter && $startAfter != "") {
                $startAfter = date("Y-m-d", strtotime($startAfter));
                $sql .= " AND ad.start_date >= ".$this->datetimeToDB($startAfter);
            }
            if ($startBefore && $startBefore != "") {
                $startBefore = date("Y-m-d", strtotime($startBefore));
                $sql .= " AND ad.start_date <= ".$this->datetimeToDB($startBefore);
            }
            if ($endAfter && $endAfter != "") {
                $endAfter = date("Y-m-d", strtotime($endAfter));
                $sql .= " AND ad.end_date >= ".$this->datetimeToDB($endAfter);
            }
            if ($endBefore && $endBefore != "") {
                $endBefore = date("Y-m-d", strtotime($endBefore));
                $sql .= " AND ad.end_date <= ".$this->datetimeToDB($endBefore);
            }
            $kiiField = array_filter($kiiField);
            if(!empty($kiiField)){
                $sql .= " AND (";
                for($i = 0; $i < count($kiiField); $i++){
                    if($i == 0) {$sql .= "ad.key_implementing_institution = ".$kiiField[$i];}
                    else {$sql .= " OR ad.key_implementing_institution = ".$kiiField[$i];}
                }
                $sql .= ")";
            }
            if ($multiCountry) {
                $sql .= " AND ad.multi_country = '".$multiCountry."'";
                if ($multiCountry == PROPOSAL_DETAIL_YES){
                    $countries = array_filter($countries);
                    if(!empty($countries)){
                        $sql .= " AND (";
                        for($i = 0; $i < count($countries); $i++){
                            if($i == 0) {$sql .= "ad.countries LIKE '%".$countries[$i]."%'";}
                            else {$sql .= " OR ad.countries LIKE '%".$countries[$i]."%'";}
                        }
                        $sql .= ")";                        
                    }                    
                }
            }
            $geoAreas = array_filter($geoAreas);
            if(!empty($geoAreas)){
                $sql .= " AND (";
                for($i = 0; $i < count($geoAreas); $i++){
                    if($i == 0) {$sql .= "ad.geo_areas LIKE '%".$geoAreas[$i]."%'";}
                    else {$sql .= " OR ad.geo_areas LIKE '%".$geoAreas[$i]."%'";}
                }
                $sql .= ")";
            }
            $researchDomains = array_filter($researchDomains);
            if(!empty($researchDomains)){
                $sql .= " AND (";
                for($i = 0; $i < count($researchDomains); $i++){
                    if($i == 0) {$sql .= "ad.research_domains LIKE '%".$researchDomains[$i]."%'";}
                    else {$sql .= " OR ad.research_domains LIKE '%".$researchDomains[$i]."%'";}
                }
                $sql .= ")";
            }
            $researchFields = array_filter($researchFields);
            if(!empty($researchFields)){
                $sql .= " AND (";
                for($i = 0; $i < count($researchFields); $i++){
                    if($i == 0) {$sql .= "ad.research_fields LIKE '%".$researchFields[$i]."%'";}
                    else {$sql .= " OR ad.research_fields LIKE '%".$researchFields[$i]."%'";}
                }
                $sql .= ")";
            }
            if ($withHumanSubjects) {
                $sql .= " AND ad.human_subjects = '".$withHumanSubjects."'";
                if ($withHumanSubjects == PROPOSAL_DETAIL_YES){
                    $proposalTypes = array_filter($proposalTypes);
                    if(!empty($proposalTypes)){
                        $sql .= " AND (";
                        for($i = 0; $i < count($proposalTypes); $i++){
                            if($i == 0) {$sql .= "ad.proposal_types LIKE '%".$proposalTypes[$i]."%'";}
                            else {$sql .= " OR ad.proposal_types LIKE '%".$proposalTypes[$i]."%'";}
                        }
                        $sql .= ")";                        
                    }                    
                }
            }
            if ($dataCollection) {$sql .= " AND ad.data_collection = '".$dataCollection."'";}
            
            $havingSql = '';
            if ($budget && $budget != ""){
                $havingSql .= " HAVING SUM(asrce.amount) ".$budgetOption." ".$budget;
            }
            $sources = array_filter($sources);
            if(!empty($sources)){
                $sql .= " AND (";
                for($i = 0; $i < count($sources); $i++){
                    if($i == 0) {$sql .= "asrce.institution_id = ".$sources[$i];}
                    else {$sql .= " OR asrce.institution_id = ".$sources[$i];}
                }
                $sql .= ")";
            }
            
            if ($identityRevealed != null) {$sql .= " AND ara.identity_revealed = '".$identityRevealed."'";}
            if ($unableToConsent != null) {$sql .= " AND ara.unable_to_consent = '".$unableToConsent."'";}
            if ($under18 != null) {$sql .= " AND ara.under_18 = '".$under18."'";}
            if ($dependentRelationship != null) {$sql .= " AND ara.dependent_relationship = '".$dependentRelationship."'";}
            if ($ethnicMinority != null) {$sql .= " AND ara.ethnic_minority = '".$ethnicMinority."'";}
            if ($impairment != null) {$sql .= " AND ara.mental_impairment = '".$impairment."'";}
            if ($pregnant != null) {$sql .= " AND ara.pregnant = '".$pregnant."'";}
            if ($newTreatment != null) {$sql .= " AND ara.new_treatment = '".$newTreatment."'";}
            if ($bioSamples != null) {
                $sql .= " AND ara.biological_samples = '".$bioSamples."'";
                if ($bioSamples == RISK_ASSESSMENT_YES){
                    if ($exportHumanTissue != null) {
                        $sql .= " AND ara.export_human_tissue = '".$exportHumanTissue."'";
                        if ($exportHumanTissue == RISK_ASSESSMENT_YES){
                            if ($exportReason != null) {$sql .= " AND ara.export_reason = '".$exportReason."'";}            
                        }
                    }                    
                }
            }
            if ($radiation != null) {$sql .= " AND ara.ionizing_radiation = '".$radiation."'";}
            if ($distress != null) {$sql .= " AND ara.distress = '".$distress."'";}
            if ($inducements != null) {$sql .= " AND ara.inducements = '".$inducements."'";}
            if ($sensitiveInfo != null) {$sql .= " AND ara.sensitive_information = '".$sensitiveInfo."'";}
            if ($reproTechnology != null) {$sql .= " AND ara.repro_technology = '".$reproTechnology."'";}
            if ($genetic != null) {$sql .= " AND ara.genetic = '".$genetic."'";}
            if ($stemCell != null) {$sql .= " AND ara.stem_cell = '".$stemCell."'";}
            if ($biosafety != null) {$sql .= " AND ara.biosafety = '".$biosafety."'";}

            $result =& $this->_getUnfilteredEditorSubmissions(
            $journalId, $sectionId, null,
            null, null, null,
            SUBMISSION_FIELD_DATE_SUBMITTED, null, null, null, null,
            $sql,
            null, null, null, $havingSql
            );

            $returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
            
            return $returner;
	}
	
}

?>
