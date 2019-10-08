<?php

/**
 * Last update on February 2013
 * EL
**/

import('classes.meeting.MeetingSectionDecision');

class MeetingSectionDecisionDAO extends DAO {

	
	function MeetingSectionDecisionDAO() {
		parent::DAO();
	}
	
	/**
	 * Get MeetingSectionDecision object
	 * @param $meetingId int
	 * @return array
	 */
	function &getMeetingSectionDecisionsByMeetingId($meetingId) {
		$meetingSectionDecisions = array();
		$result =& $this->retrieve(
			'SELECT * FROM meeting_section_decisions WHERE meeting_id = ?',
			(int) $meetingId
		);
		
		while (!$result->EOF) {
			$meetingSectionDecisions[] =& $this->_returnMeetingSectionDecisionFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		
		$result->Close();
		unset($result);

		return $meetingSectionDecisions;
	}
        
        /*
	 * Delete all submissions in a meeting
	 */

	function deleteMeetingSectionDecisionsByMeetingId($meetingId){
		return $this->update(
			'DELETE FROM meeting_section_decisions WHERE meeting_id = ?',
			(int) $meetingId
		);
	}

	/**
	 * Return the section decision
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return section_decision_id
	 */
	function &_returnMeetingSectionDecisionFromRow(&$row) {
            
            	$meetingSectionDecision = new MeetingSectionDecision();
                
                $meetingSectionDecision->setMeetingId($row['meeting_id']);
                $meetingSectionDecision->setSectionDecisionId($row['section_decision_id']);
                
		HookRegistry::call('MeetingSectionDecsisionDAO::_returnMeetingSectionDecisionFromRow', array(&$meetingSectionDecision, &$row));

                return $meetingSectionDecision;
	}
	
	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}
	
	/** 
	 * Insert new section decision for the meeting discussion
	 * Insert a new data object
	 * @param int $meetingId
	 * @param int $SubmissionId
	 */
	function insertMeetingSectionDecision($meetingSectionDecision) {
		$this->update (
			'INSERT INTO meeting_section_decisions
			(meeting_id, section_decision_id)
			VALUES (?, ?)',
			array($meetingSectionDecision->getMeetingId(), $meetingSectionDecision->getSectionDecisionId())
		);
	}
	
	/**
	 * Remove section decision from meeting discussion
	 * Update a data object
	 * @param int $meetingId 
	 * @param int $submissionId
	 */
	function deleteMeetingSectionDecision($meetingId, $decisionId) {
		return $this->update(
			'DELETE FROM meeting_section_decisions WHERE meeting_id = ? AND section_decision_id = ?',
			array(
			$meetingId,
			$decisionId)
		);
	}

        /**
	 * check if an attendance already exist
	 * @param Meeting $meetingId
	 */
	function meetingSectionDecisionsExists($meetingId, $decisionId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM meeting_section_decisions WHERE meeting_id = ? AND section_decision_id = ?', array($meetingId, $decisionId)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}
        
        /**
         * Get meeting "real" section decisions by attendance id and article id
	 * @param Meeting $articleId
	 * @param Meeting $userId
	 * @return array
         */
        function getUserMeetingSectionDecisions($articleId, $userId){
                $sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
                $decisions = array();
                
                $result =& $this->retrieve(
			'SELECT sd.*, a.public_id FROM section_decisions sd'
                        . ' LEFT JOIN articles a ON (a.article_id = sd.article_id)'
                        . ' LEFT JOIN meeting_section_decisions msd ON (msd.section_decision_id = sd.section_decision_id)'
                        . ' LEFT JOIN meeting_attendance ma ON (ma.meeting_id = msd.meeting_id)'
                        . ' WHERE a.article_id = ' . $articleId . ' AND ma.user_id = ' . $userId
                        . ' GROUP BY sd.section_decision_id'
		);
                
                while (!$result->EOF) {
			$decisions[] =& $sectionDecisionDao->_returnSectionDecisionFromRow($result->GetRowAssoc(false));
			$result->moveNext();		
		}
                
		return $decisions;
        }

	
}
