<?php

/**
 * @file classes/submission/author/AuthorSubmissionDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmissionDAO
 * @ingroup submission
 * @see AuthorSubmission
 *
 * @brief Operations for retrieving and modifying AuthorSubmission objects.
 */

// $Id$
import('classes.submission.author.AuthorSubmission');

class AuthorSubmissionDAO extends DAO {
	var $articleDao;
	var $authorDao;
	var $userDao;
	var $articleFileDao;
	var $suppFileDao;
	var $copyeditorSubmissionDao;
	var $articleCommentDao;
	var $galleyDao;
	var $sectionDecisionDao;
	
	/**
	 * Constructor.
	 */
	function AuthorSubmissionDAO() {
		parent::DAO();
		$this->articleDao =& DAORegistry::getDAO('ArticleDAO');
		$this->authorDao =& DAORegistry::getDAO('AuthorDAO');
		$this->userDao =& DAORegistry::getDAO('UserDAO');
		$this->articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$this->suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$this->copyeditorSubmissionDao =& DAORegistry::getDAO('CopyeditorSubmissionDAO');
		$this->articleCommentDao =& DAORegistry::getDAO('ArticleCommentDAO');
		$this->galleyDao =& DAORegistry::getDAO('ArticleGalleyDAO');
		$this->sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
	}

        /**
	 * Insert a new author submission.
	 * @param $authorSubmission AuthorSubmission
	 */
	function insertAuthorSubmission(&$authorSubmission) {
            $this->articleDao->insertArticle($authorSubmission);
            
            // Insert section decisions for this article
            $sectionDecisions =& $authorSubmission->getDecisions();
            for ($i=0, $count=count($sectionDecisions); $i < $count; $i++) {
                    $sectionDecisions[$i]->setArticleId($authorSubmission->getId());
                    $this->sectionDecisionDao->insertSectionDecision($sectionDecisions[$i]);
            }
            
            return $authorSubmission->getId();
        }

	/**
	 * Retrieve a author submission by article ID.
	 * @param $articleId int
	 * @return AuthorSubmission
	 */
	function &getAuthorSubmission($articleId) {
		$result =& $this->retrieve(
			'SELECT	a.*
			FROM articles a
			WHERE	a.article_id = '.$articleId
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnAuthorSubmissionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Internal function to return a AuthorSubmission object from a row.
	 * @param $row array
	 * @return AuthorSubmission
	 */
	function &_returnAuthorSubmissionFromRow(&$row) {
		$authorSubmission = new AuthorSubmission();

		// Article attributes
		$this->articleDao->_articleFromRow($authorSubmission, $row);
		
		// Editor Decisions
		$authorSubmission->setDecisions($this->sectionDecisionDao->getSectionDecisionsByArticleId($row['article_id']));
		
		// Comments
		$authorSubmission->setMostRecentEditorDecisionComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_SECTION_DECISION, $row['article_id']));
		$authorSubmission->setMostRecentCopyeditComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_COPYEDIT, $row['article_id']));
		$authorSubmission->setMostRecentProofreadComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_PROOFREAD, $row['article_id']));
		$authorSubmission->setMostRecentLayoutComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_LAYOUT, $row['article_id']));

		// Files
		$authorSubmission->setSubmissionFile($this->articleFileDao->getArticleFile($row['submission_file_id']));
		$authorSubmission->setRevisedFile($this->articleFileDao->getArticleFile($row['revised_file_id']));
		$authorSubmission->setReportFiles($this->articleFileDao->getArticleFilesByType($row['article_id'], ARTICLE_FILE_REPORT));
		$authorSubmission->setSuppFiles($this->suppFileDao->getSuppFilesByArticle($row['article_id']));
		$authorSubmission->setSAEFiles($this->articleFileDao->getArticleFilesByType($row['article_id'], ARTICLE_FILE_SAE));

                $authorSubmission->setGalleys($this->galleyDao->getGalleysByArticle($row['article_id']));

		HookRegistry::call('AuthorSubmissionDAO::_returnAuthorSubmissionFromRow', array(&$authorSubmission, &$row));

		return $authorSubmission;
	}

	/**
	 * Update an existing author submission.
	 * @param $authorSubmission AuthorSubmission
	 */
	function updateAuthorSubmission(&$authorSubmission) {
		// Update article
            
		// Update section decisions
		$sectionDecisions = $authorSubmission->getDecisions();
		if (is_array($sectionDecisions)) {
			foreach ($sectionDecisions as $sectionDecision) {
				if ($sectionDecision->getId() == null) $this->sectionDecisionDao->insertSectionDecision($sectionDecision);
				else $this->sectionDecisionDao->updateSectionDecision($sectionDecision);
			}
		}
            
            
		if ($authorSubmission->getArticleId()) {
			$article =& $this->articleDao->getArticle($authorSubmission->getArticleId());

			// Only update fields that an author can actually edit.
			$article->setRevisedFileId($authorSubmission->getRevisedFileId());
			$article->setDateStatusModified($authorSubmission->getDateStatusModified());
			$article->setLastModified($authorSubmission->getLastModified());
			// FIXME: These two are necessary for designating the
			// original as the review version, but they are probably
			// best not exposed like this.
			$article->setReviewFileId($authorSubmission->getReviewFileId());
			$article->setEditorFileId($authorSubmission->getEditorFileId());

			$this->articleDao->updateArticle($article);
		}

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
	//
	// Miscellaneous
	//

	/**
	 * Get count of active and complete assignments
	 * @param authorId int
	 * @param journalId int
	 */
	function getSubmissionsCount($authorId, $journalId) {
		$submissionsCount = array();
		$submissionsCount[0] = 0;
		$submissionsCount[1] = 0;
		$submissionsCount[2] = 0;
		$submissionsCount[3] = 0;

		$sql = 'SELECT COUNT(DISTINCT a.article_id) as review_count
				FROM articles a			
					LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
					LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				WHERE	a.user_id = ? 
					AND a.journal_id = ? AND sdec2.section_decision_id IS NULL';
					
		$sql0 = ' AND ((a.status = ' . STATUS_QUEUED . ' AND a.submission_progress <> 0 ) 
                            OR (a.status = ' . STATUS_REVIEWED . ' 
                            AND (sdec.decision = '.SUBMISSION_SECTION_DECISION_INCOMPLETE.' OR sdec.decision = '.SUBMISSION_SECTION_DECISION_RESUBMIT.')
                        ))';
				
		$sql1 = ' AND a.status = ' . STATUS_QUEUED . ' AND a.submission_progress = 0';
				
		$sql2 = ' AND (a.status = '.STATUS_REVIEWED.' 
				AND (sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED . '
				OR sdec.decision = ' . SUBMISSION_SECTION_DECISION_EXEMPTED . '
				) AND a.submission_progress = 0)';
				
		$sql3 = ' AND a.status = ' . STATUS_COMPLETED;
				
		$result0 =& $this->retrieve($sql.$sql0, array($authorId, $journalId));
		$result1 =& $this->retrieve($sql.$sql1, array($authorId, $journalId));
		$result2 =& $this->retrieve($sql.$sql2, array($authorId, $journalId));
		$result3 =& $this->retrieve($sql.$sql3, array($authorId, $journalId));

		$submissionsCount[0] = $result0->Fields('review_count');
		$result0->Close();
		unset($result0);
		$submissionsCount[1] = $result1->Fields('review_count');
		$result1->Close();
		unset($result1);
		$submissionsCount[2] = $result2->Fields('review_count');
		$result2->Close();
		unset($result2);
		$submissionsCount[3] = $result3->Fields('review_count');
		$result3->Close();
		unset($result3);

		return $submissionsCount;
	}

	/**
	 * Map a column heading value to a database value for sorting
	 * @param string
	 * @return string
	 */
	function getSortMapping($heading) {
		switch ($heading) {
			case 'status': return 'a.status, sdec.decision';
			case 'round': return 'sdec.review_type, sdec.round';
			case 'submitDate': return 'a.date_submitted';
			case 'title': return 'submission_title';
			case 'active': return 'a.submission_progress';
			case 'views': return 'galley_views';
			default: return null;
		}
	}


	/**
	 * Retrieve unfiltered author submissions
	 */
	function &_getUnfilteredAuthorSubmissions($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $additionalWhereSql = '', $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();

		$params = array(
				$locale,
				$authorId,
				$journalId
		);
		
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
											  					
		$sql = 'SELECT DISTINCT
					a.*,
					ab.clean_scientific_title AS submission_title,
					aa.last_name AS author_name,
					(SELECT SUM(g.views) FROM article_galleys g WHERE (g.article_id = a.article_id AND g.locale = ?)) AS galley_views
				FROM	articles a
					LEFT JOIN authors aa ON (aa.submission_id = a.article_id AND aa.primary_contact = 1)
					LEFT JOIN article_abstract ab ON (ab.article_id = a.article_id)
                                        LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
                                        LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				WHERE	a.user_id = ? 
					AND a.journal_id = ? AND sdec2.section_decision_id IS NULL'.
					(!empty($additionalWhereSql)?" AND ($additionalWhereSql)":'');

                $result =& $this->retrieveRange($sql . ' ' . $searchSql . ' GROUP BY a.article_id' . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
			$params,
			$rangeInfo
		);

		return $result;
	}


	/**
	 * Get all proposals to submit for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorProposalsToSubmitIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo,
                        ' (a.status = ' . STATUS_QUEUED . ' AND a.submission_progress <> 0 ) 
                                OR (a.status = ' . STATUS_REVIEWED . ' 
                                    AND (sdec.decision = '.SUBMISSION_SECTION_DECISION_INCOMPLETE.' OR sdec.decision = '.SUBMISSION_SECTION_DECISION_RESUBMIT.')
                                )',
                                $rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

        
	/**
	 * Get all proposals in review for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorProposalsInReviewIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo,
				'a.status = ' . STATUS_QUEUED . ' AND a.submission_progress = 0', 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all ongoing proposals for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorOngoingResearchesIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo,
				'(a.status = '.STATUS_REVIEWED.' 
				AND (sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED . '
				OR sdec.decision = ' . SUBMISSION_SECTION_DECISION_EXEMPTED . '
				) AND a.submission_progress = 0)', 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all completed proposals for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorCompletedResearchesIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo,
				'a.status = '.STATUS_COMPLETED, 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all archives proposals for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorArchivesIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		
		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo,
				'a.status = ' . STATUS_ARCHIVED . ' 
				OR a.status = ' . STATUS_WITHDRAWN . '
                                OR (a.status = ' . STATUS_REVIEWED . ' AND sdec.decision = ' . SUBMISSION_SECTION_DECISION_DECLINED . ')', 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}
}

?>
