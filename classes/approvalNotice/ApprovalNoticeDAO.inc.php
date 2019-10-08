<?php

/**
 * @file ApprovalNoticeDAO.inc.php
 *
 * @class ApprovalNoticeDAO
 * @ingroup approvalNotice
 * @see ApprovalNotice
 *
 * @brief Operations for retrieving and modifying approval notice objects.
 */

import('classes.approvalNotice.ApprovalNotice');

class ApprovalNoticeDAO extends DAO {
    
	/**
	 * Retrieve an approval notice by approval notice ID.
	 * @param $approvalNoticeId int
	 * @return ApprovalNotice
	 */
	function &getApprovalNotice($approvalNoticeId) {
		$result =& $this->retrieve(
			'SELECT * FROM approval_notices WHERE approval_notice_id = ?', $approvalNoticeId
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnApprovalNoticeFromRow($result->GetRowAssoc(false));
		}
		$result->Close();
		return $returner;
	}

	/**
	 * Internal function to return an approval notice object from a row.
	 * @param $row array
	 * @return ApprovalNotice
	 */
	function &_returnApprovalNoticeFromRow(&$row) {
		$approvalNotice = new ApprovalNotice();
		$approvalNotice->setId($row['approval_notice_id']);
		$approvalNotice->setCommittees($row['committees']);
		$approvalNotice->setReviewTypes($row['review_types']);
		$approvalNotice->setActive($row['active']);
		$approvalNotice->setApprovalNoticeTitle($row['title']);
		$approvalNotice->setApprovalNoticeHeader($row['header']);
		$approvalNotice->setApprovalNoticeBody($row['body']);
		$approvalNotice->setApprovalNoticeFooter($row['footer']);

		return $approvalNotice;
	}

	/**
	 * Insert a new approval notice.
	 * @param $approvalNotice Approval Notice
	 * @return int
	 */
	function insertApprovalNotice(&$approvalNotice) {
		$this->update('INSERT INTO approval_notices
				(committees, review_types, active, title, header, body, footer)
				VALUES
				(?, ?, ?, ?, ?, ?, ?)',
			array(
				$approvalNotice->getCommittees(),
				$approvalNotice->getReviewTypes(),
				$approvalNotice->getActive(),
                                $approvalNotice->getApprovalNoticeTitle(),
                                $approvalNotice->getApprovalNoticeHeader(),
                                $approvalNotice->getApprovalNoticeBody(),
                                $approvalNotice->getApprovalNoticeFooter()
			)
		);
		$approvalNotice->setId($this->getInsertApprovalNoticeId());
		return $approvalNotice->getId();
	}

	/**
	 * Update an existing approval notice.
	 * @param $approvalNotice ApprovalNotice object
	 * @return boolean
	 */
	function updateObject(&$approvalNotice) {
		$returner = $this->update(
                        'UPDATE approval_notices
				SET
					committees = ?,
					review_types = ?,
					active = ?,
                                        title = ?,
                                        header = ?,
                                        body = ?,
                                        footer = ?
				WHERE approval_notice_id = ?',
			array(
				$approvalNotice->getCommittees(),
				$approvalNotice->getReviewTypes(),
				$approvalNotice->getActive(),
                                $approvalNotice->getApprovalNoticeTitle(),
                                $approvalNotice->getApprovalNoticeHeader(),
                                $approvalNotice->getApprovalNoticeBody(),
                                $approvalNotice->getApprovalNoticeFooter(),
				$approvalNotice->getId()
			)
		);
		return $returner;
	}

	function updateApprovalNotice(&$approvalNotice) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->updateObject($approvalNotice);
	}

	/**
	 * Delete an approval notice.
	 * @param $approvalNotice ApprovalNotice
	 * @return boolean
	 */
	function deleteObject($approvalNotice) {
		return $this->deleteApprovalNoticeById($approvalNotice->getId());
	}

	function deleteApprovalNotice($approvalNotice) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->deleteObject($approvalNotice);
	}

	/**
	 * Delete an approval notice by ID.
	 * @param $approvalNoticeId int
	 * @return boolean
	 */
	function deleteApprovalNoticeById($approvalNoticeId) {
		return $this->update('DELETE FROM approval_notices WHERE approval_notice_id = ?', $approvalNoticeId);
	}

        /**
	 * Retrieve an array of approval notices matching a particular type and committee.
	 * @param $committee int
         * @param $type int
	 * @return array of approval notice objects
	 */
	function &getApprovalNoticesByCommitteeAndTypeId($committee, $type) {
                $approvalNotices = array();
		
                $result =& $this->retrieve(
			'SELECT approval_notice_id, title FROM approval_notices'
                        . ' WHERE active = '.APPROVAL_NOTICE_ACTIVE
                        . ' AND (committees LIKE "%'.$committee.'%"'
                        . ' OR committees LIKE "%'.APPROVAL_NOTICE_COMMITTEE_ALL.'%")'
                        . ' AND (review_types LIKE "%'.$type.'%"'
                        . ' OR review_types LIKE "%'.APPROVAL_NOTICE_TYPE_ALL.'%")'
                        . ' ORDER BY title DESC'
		);
                
		while (!$result->EOF) {
                        $row = $result->GetRowAssoc(false);
			$approvalNotices[$row['approval_notice_id']] =& $row['title'];
			$result->moveNext();		
		}
                $result->Close();
		unset($result);		

		return $approvalNotices;
	}

	/**
	 * Retrieve an iterator of all approval notices.
	 * @param $rangeInfo string
	 * @return object DAOResultFactory containing matching Approval Notices
	 */
	function &getApprovalNotices($rangeInfo = null) {
		$result =& $this->retrieveRange(
			'SELECT *
			FROM approval_notices
			ORDER BY approval_notice_id DESC ',
			array(),
			$rangeInfo
		);

		$returner = new DAOResultFactory($result, $this, '_returnApprovalNoticeFromRow');
		return $returner;
	}

	/**
	 * Get the ID of the last inserted approval notice.
	 * @return int
	 */
	function getInsertApprovalNoticeId() {
		return $this->getInsertId('approval_notices', 'approval_notice_id');
	}
        
        
        /**
	 * Get a map for review type  to locale key.
	 * @return array
	 */
	function getReviewTypeMap() {
                return $reviewTypeMap = array(
                        APPROVAL_NOTICE_TYPE_ALL => 'common.all',
                        REVIEW_TYPE_INITIAL => 'submission.initialReview',
                        REVIEW_TYPE_PR => 'submission.progressReport',
                        REVIEW_TYPE_AMENDMENT => 'submission.protocolAmendment',
                        REVIEW_TYPE_SAE => 'submission.seriousAdverseEvents',
                        REVIEW_TYPE_FR => 'submission.finalReport'
                );
	}
        
        /**
	 * Get a map for if the notice is active.
	 * @return array
	 */
	function getActiveMap() {
                return $docTypeMap = array(
                        APPROVAL_NOTICE_ACTIVE => Locale::translate('common.yes'),
                        APPROVAL_NOTICE_INACTIVE => Locale::translate('common.no')
                );
	}
}

?>
