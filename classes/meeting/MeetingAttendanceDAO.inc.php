<?php

/**
 * Last update on March 2013
 * EL
**/

import('classes.meeting.MeetingAttendance');
import('classes.meeting.Meeting');

class MeetingAttendanceDAO extends DAO {
    
	var $userDao;

        /**
	 * Constructor
	 */
	function MeetingAttendanceDAO() {
		parent::DAO();
		$this->userDao =& DAORegistry::getDAO('UserDAO');
	}

	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}

	
	/** 
	 * Insert new user for the meeting discussion
	 * Insert a new data object
	 * @param int $meetingId
	 * @param int $userId
	 * @param int $typeOfUser
	 */
	function insertMeetingAttendance($mAttendance) {
		$this->update(
			sprintf(
			'INSERT INTO meeting_attendance
			(meeting_id, user_id, attending, remarks, date_reminded, present, reason_for_absence, type_of_user)
			VALUES (?, ?, ?, ?, %s, ?, ?, ?)',
			$this->datetimeToDB($mAttendance->getDateReminded())),
			array($mAttendance->getMeetingId(), 
                            $mAttendance->getUserId(), 
                            $mAttendance->getIsAttending(),
                            $mAttendance->getRemarks(),
                            $mAttendance->getWasPresent(),
                            $mAttendance->getReasonForAbsence(),
                            $mAttendance->getTypeOfUser() 
                        )
                ); 
	}

	/** 
	 * Get a specific meeting attendance
	 * @param int $meetingId
	 * @param int $userId
	 * Added by EL on March 6th 2013
	 */
	function getMeetingAttendance($meetingId, $userId) {
		$result =& $this->retrieve(
			'SELECT *
			 FROM meeting_attendance
			 WHERE meeting_id = ? AND user_id = ? ORDER BY type_of_user',
			array((int) $meetingId, (int) $userId)
		);
		return $this->_returnMeetingAttendanceFromRow($result->GetRowAssoc(false));	
	}
	
	function &getMeetingAttendancesByMeetingId($meetingId) {
		
		$meetingAttendances = array();
		$result =& $this->retrieve(
			'SELECT *
			 FROM meeting_attendance
			 WHERE meeting_id = ? ORDER BY type_of_user',
			(int) $meetingId
		);
		
		while (!$result->EOF) {
			$meetingAttendances[] =& $this->_returnMeetingAttendanceFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		$result->Close();
		unset($result);

		return $meetingAttendances;
	}

	function &getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, $typeOfUser) {
		
		$meetingAttendances = array();
		$result =& $this->retrieve(
			'SELECT *
			 FROM meeting_attendance
			 WHERE meeting_id = ? and type_of_user = ?',
			array((int) $meetingId, (int) $typeOfUser)
		);
		
		while (!$result->EOF) {
			$meetingAttendances[] =& $this->_returnMeetingAttendanceFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		$result->Close();
		unset($result);

		return $meetingAttendances;
	}

	/**
	 * Return the submission_id
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return submission_id
	 */
	function &_returnMeetingAttendanceFromRow(&$row) {

                $meetingAttendance = new MeetingAttendance();
		$meetingAttendance->setMeetingId($row['meeting_id']);
		$meetingAttendance->setUserId($row['user_id']);
		$meetingAttendance->setIsAttending($row['attending']);
		$meetingAttendance->setRemarks($row['remarks']);
		$meetingAttendance->setDateReminded($row['date_reminded']);
		$meetingAttendance->setTypeOfUser($row['type_of_user']);
		
                $user =& $this->userDao->getUser($meetingAttendance->getUserId());

                $meetingAttendance->setUser($user);

                if (isset($row['present'])) $meetingAttendance->setWasPresent($row['present']);
		if (isset($row['reason_for_absence'])) $meetingAttendance->setReasonForAbsence($row['reason_for_absence']);
		
		HookRegistry::call('MeetingAttendanceDAO::_returnMeetingAttendanceFromRow', array(&$meetingAttendance, &$row));
		return $meetingAttendance;
	}
	

        /**
	 * Update a whole meeting attendance 
	 * @param Meeting $meeting
	 */
	function updateMeetingAttendance($meetingAttendance) {
		$this->update(sprintf(
			'UPDATE meeting_attendance 
                            SET attending = ?, remarks = ?, date_reminded = %s, present = ?, reason_for_absence = ?, type of user = ?
			WHERE meeting_id = ? AND user_id = ?',
			$this->datetimeToDB($mAttendance->getDateReminded())),
			array($meetingAttendance->getIsAttending(),
			$meetingAttendance->getRemarks(),
			$meetingAttendance->getWasPresent(),                            
			$meetingAttendance->getReasonForAbsence(),                            
			$meetingAttendance->getTypeOfUser(),                            
                        $meetingAttendance->getMeetingId(), 
			$meetingAttendance->getUserId())
		);
	}

        
        /**
	 * Update meeting_attendance table to save user response 
	 * @param Meeting $meeting
	 */
	function updateReplyOfAttendance($meetingAttendance) {
		$this->update(
			'UPDATE meeting_attendance SET attending = ?, remarks = ?
			WHERE meeting_id = ? AND user_id = ?',
			array($meetingAttendance->getIsAttending(),
			$meetingAttendance->getRemarks(), 
			$meetingAttendance->getMeetingId(), 
			$meetingAttendance->getUserId())
		);
	}
	
	function updateDateReminded($dateReminded, $userId, $meeting) {
		$this->update(
			sprintf('UPDATE meeting_attendance SET date_reminded = %s
			WHERE meeting_id = ? AND user_id = ?',
			$this->datetimeToDB($dateReminded)), array($meeting->getId(), $userId));
	}
	
	function resetReplyOfUsers($meeting) {
		$this->update(
			'UPDATE meeting_attendance SET attending = 3, remarks = NULL
			WHERE meeting_id = ?', $meeting->getId()
		);
	}
	
	/**
	 * Update meeting_attendance table to save attendance in meeting 
	 * @param Meeting $meeting
	 */
	function updateAttendanceOfUser($meetingAttendance) {
		$this->update(
			'UPDATE meeting_attendance SET present = ?, reason_for_absence = ?
			WHERE meeting_id = ? AND user_id = ?',
			array($meetingAttendance->getWasPresent(),
			$meetingAttendance->getReasonForAbsence(), 
			$meetingAttendance->getMeetingId(), 
			$meetingAttendance->getUserId())
		);
	}

	/**
	 * check if an attendance already exist
	 * @param Meeting $meetingId
	 */
	function attendanceExists($meetingId, $userId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM meeting_attendance WHERE meeting_id = ? AND user_id = ?', array($meetingId, $userId)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}
	
	/*
	 * Get type of user
	 * @param Meeting ID $meetingId
	 * @param User ID $userId
	 */
	function getTypeOfUser($meetingId, $userId) {
		$result =& $this->retrieve(
			'SELECT type_of_user FROM meeting_attendance WHERE meeting_id = ? AND user_id = ?', array($meetingId, $userId)
		);
		$returner = isset($result->fields[0]) ? $result->fields[0] : 0;

		$result->Close();
		unset($result);

		return $returner;
	}

	/*
	 * Get attendances by user ID and submission ID
	 * @param User ID $meetingId
	 * @param Submission ID $userId
	 * Added by EL on March 12th 2013
	 */
	function getAttendancesByUserIdAndDecisionId($userId, $decisionId) {

                $meetingDao =& DAORegistry::getDAO('MeetingDAO');
		
		$meetingsAndAttendances = array();
		
		$result =& $this->retrieve(
			'SELECT ma.*,
			 FROM meeting_attendance ma 
			 	LEFT JOIN users u ON (ma.user_id = u.user_id )
			 	LEFT JOIN meeting_section_decisions msd ON (ma.meeting_id = msd.meeting_id)
			 	LEFT JOIN meetings m ON (ma.meeting_id = m.meeting_id)
			 WHERE ma.user_id = ? AND msd.section_decision_id = ? 
			 ORDER BY m.meeting_date',
			array((int) $userId, (int) $decisionId)
		);
		
		while (!$result->EOF) {
			$meetingAttendance =& $this->_returnMeetingAttendanceFromRow($result->GetRowAssoc(false));
			$meeting =& $meetingDao->_returnMeetingFromRow($result->GetRowAssoc(false));
			$meetingsAndAttendances[] = array('meeting' => $meeting, 'attendance' => $meetingAttendance);
			$result->MoveNext();
		}
		
		$result->Close();
		unset($result);

		return $meetingsAndAttendances;
	}
        
        
        function deleteMeetingAttendance($meetingId, $userId){
		$this->update(
			'DELETE * FROM meeting_attendance WHERE meeting_id = ? and user_id = ?',
			array($meetingId, $userId)
		);
	}	
        
}

?>
