<?php

/**
 * Last update on February 2013
 * EL
**/

import('classes.meeting.Meeting');
import('lib.pkp.classes.db.DBRowIterator');

class MeetingDAO extends DAO {

	var $meetingAttendanceDao;
        
	var $meetingSectionDecisionDao;
        
	/**
	 * Constructor
	 */        
	function MeetingDAO() {
		parent::DAO();
		$this->meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
                $this->meetingSectionDecisionDao =& DAORegistry::getDAO('MeetingSectionDecisionDAO');
	}

	/**
	 * Get meeting object
	 * @param $meeting int
	 * @return Meeting
	 */
	function &getMeetingsOfSection($sectionId, $sortBy = null, $rangeInfo = null, $sortDirection = SORT_DIRECTION_ASC, $status=null, $minutesStatus=null, $dateFrom=null, $dateTo=null) {
		$sql = 'SELECT meeting_id, meeting_date, section_id, minutes_status, status FROM meetings as a WHERE section_id = ?';
		$searchSql = '';
		
		if (!empty($dateFrom) || !empty($dateTo)) {
			if (!empty($dateFrom)) {
				$searchSql .= ' AND meeting_date >= ' . $this->datetimeToDB($dateFrom);
			}
			if (!empty($dateTo)) {
				$searchSql .= ' AND meeting_date <= ' . $this->datetimeToDB($dateTo);
			}
		}
		if(!empty($status)) {
			$searchSql .= ' AND status = ' . $status;
		}
		
		if(!empty($minutesStatus)) {
			$searchSql .= ' AND minutes_status = ' . $minutesStatus;
		}
		
		
		$result =& $this->retrieveRange(
			$sql. ' ' . $searchSql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''), 
			(int) $sectionId, $rangeInfo
		);
			
		$returner = new DAOResultFactory($result, $this, '_returnMeetingFromRow');
		return $returner;
	}
	
	/**
	 * Get meeting object
	 * @param $meeting int
	 * @return Meeting
	 */
	function &getMeetingById($meetingId) {
		$meeting = null;

                $result =& $this->retrieve(
			'SELECT * FROM meetings WHERE meeting_id = ?',
			(int) $meetingId
		);
		
		$meeting =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
		
		$result->Close();
		unset($result);

		return $meeting;
	}
	
	/**
	 * Get all meetings to be attended by reviewer
	 * Added by ayveemallare 7/6/2011
	 * 
	 * @param unknown_type $reviewerId
	 */
	function &getMeetingsByReviewerId($reviewerId, $sortBy = null, $rangeInfo = null, $sortDirection = SORT_DIRECTION_ASC,
		$status=null, $replyStatus=null, $dateFrom=null, $dateTo=null) {
		
		$sql = 
			'SELECT * 
			FROM meetings a INNER JOIN meeting_attendance b
			ON a.meeting_id = b.meeting_id WHERE b.user_id= ?';
		
		$searchSql = '';
		
		if (!empty($dateFrom) || !empty($dateTo)) {
			if (!empty($dateFrom)) {
				$searchSql .= ' AND meeting_date >= ' . $this->datetimeToDB($dateFrom);
			}
			if (!empty($dateTo)) {
				$searchSql .= ' AND meeting_date <= ' . $this->datetimeToDB($dateTo);
			}
		}
		if(!empty($status)) {
			$searchSql .= ' AND status = ' . $status;
		}
		if(!empty($replyStatus)) {
			$searchSql .= ' AND attending = ' . $replyStatus;
		}
		
		$result =& $this->retrieveRange(
			$sql. ' ' . $searchSql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''), 
			(int) $reviewerId, $rangeInfo );
			
		$returner = new DAOResultFactory($result, $this, '_returnMeetingFromRow');
		return $returner;
	}
	
	
	function getMeetingReportByReviewerId($reviewerId, $dateFrom=null, $dateTo=null)  {
		$sql = 
			'SELECT * 
			FROM meetings a INNER JOIN meeting_attendance b
			ON a.meeting_id = b.meeting_id WHERE b.user_id= ?';
		
		$searchSql = '';
		
		if (!empty($dateFrom) || !empty($dateTo)) {
			if (!empty($dateFrom)) {
				$searchSql .= ' AND meeting_date >= ' . $this->datetimeToDB($dateFrom);
			}
			if (!empty($dateTo)) {
				$searchSql .= ' AND meeting_date <= ' . $this->datetimeToDB($dateTo);
			}
		}
		if(!empty($status)) {
			$searchSql .= ' AND status = ' . $status;
		}
		if(!empty($replyStatus)) {
			$searchSql .= ' AND attending = ' . $replyStatus;
		}
		
		$result =& $this->retrieveRange(
			$sql. ' ' . $searchSql .  ' ORDER BY ' .$this->getSortMapping('meetingDate') . ' ' .$this->getDirectionMapping(SORT_DIRECTION_ASC), 
			(int) $reviewerId, $rangeInfo );
		
		$meetingsReturner = new DBRowIterator($result);

		return array($meetingsReturner);
	}
	/**
	 * Get meeting by meetingId and reviewerId
	 * Added by ayveemallare 7/6/2011
	 * 
	 * @param int $meetingId
	 * @param int $reviewerId
	 */
	function &getMeetingByMeetingAndUserId($meetingId, $reviewerId) {
		$meeting = null;
		$result =& $this->retrieve(
			'SELECT * 
			FROM meetings a INNER JOIN meeting_attendance b
			ON a.meeting_id = b.meeting_id WHERE a.meeting_id = ? AND b.user_id= ?',
			array((int) $meetingId, (int) $reviewerId));
		
		$meeting =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
		
		$result->Close();
		unset($result);

		return $meeting;
	}

	
	/**
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return Meeting
	 */
	function &_returnMeetingFromRow(&$row) {
		$meeting = new Meeting();
		if (isset($row['meeting_id'])) $meeting->setId($row['meeting_id']);
		if (isset($row['meeting_date'])) $meeting->setDate($row['meeting_date']);
		if (isset($row['meeting_length'])) $meeting->setLength($row['meeting_length']);
		if (isset($row['location'])) $meeting->setLocation($row['location']);
		if (isset($row['investigator'])) $meeting->setInvestigator($row['investigator']);
		if (isset($row['section_id'])) $meeting->setUploader($row['section_id']);
		if (isset($row['minutes_status'])) $meeting->setMinutesStatus($row['minutes_status']);
		if (isset($row['status'])) $meeting->setStatus($row['status']);
                
                $meeting->setMeetingAttendances($this->meetingAttendanceDao->getMeetingAttendancesByMeetingId($row['meeting_id']));

                $meeting->setMeetingSectionDecisions($this->meetingSectionDecisionDao->getMeetingSectionDecisionsByMeetingId($row['meeting_id']));

		HookRegistry::call('MeetingDAO::_returnMeetingFromRow', array(&$meeting, &$row));
		return $meeting;
	}

	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}

	function insertMeeting($meeting) {
		$this->update(
			sprintf('INSERT INTO meetings (
                                        meeting_date, 
                                        meeting_length, 
                                        location, 
                                        investigator, 
                                        section_id, 
                                        minutes_status
                                 ) VALUES (%s, ?, ?, ?, ?, ?)',
                                
			$this->datetimeToDB($meeting->getDate())),
			array($meeting->getLength(), 
                                $meeting->getLocation(), 
                                $meeting->getInvestigator(), 
                                $meeting->getUploader(), 
                                $meeting->getMinutesStatus()
                        )
		);
                
		$meeting->setId($this->getInsertMeetingId());
                
                foreach ($meeting->getMeetingAttendances() as $mAttendance){
                    $this->meetingAttendanceDao->insertMeetingAttendance($mAttendance);
                }
                
                foreach ($meeting->getMeetingSectionDecisions() as $mDecision){
                    $this->meetingSectionDecisionDao->insertMeetingSectionDecision($mDecision);
                }

                return $meeting->getId();
                
	}
	
	
	function updateMeeting($meeting) {
		$this->update(
			sprintf('UPDATE meetings SET meeting_date = %s, meeting_length = ?, location = ?, investigator = ? where meeting_id = ?',$this->datetimeToDB($meeting->getDate())),
			array($meeting->getLength(), $meeting->getLocation(), $meeting->getInvestigator(), $meeting->getId())
		);

                // update meeting attendances for this meeting
		$mAttendances =& $meeting->getMeetingAttendances();
		for ($i=0, $count=count($mAttendances); $i < $count; $i++) {
			if ($this->meetingAttendanceDao->attendanceExists($meeting->getId(), $mAttendances[$i]->getUserId())) {
				$this->meetingAttendanceDao->updateAttendanceOfUser($mAttendances[$i]);
			} else {
				$this->meetingAttendanceDao->insertMeetingAttendance($mAttendances[$i]);
			}
		}

		// Remove deleted meeting attendance
		$removedMeetingAttendances = $meeting->getRemovedMeetingAttendance();
		for ($i=0, $count=count($removedMeetingAttendances); $i < $count; $i++) {
			$this->meetingAttendanceDao->deleteMeetingAttendance($meeting->getId(), $mAttendances[$i]->getUserId());
		}

                // update meeting section decisions for this meeting
		$mSectionDecisions =& $meeting->getMeetingSectionDecisions();
		for ($i=0, $count=count($mSectionDecisions); $i < $count; $i++) {
			if (!$this->meetingSectionDecisionDao->meetingSectionDecisionsExists($meeting->getId(), $mSectionDecisions[$i]->getSectionDecisionId())) {
				$this->meetingSectionDecisionDao->insertMeetingSectionDecision($mSectionDecisions[$i]);
			}
		}

		// Remove deleted meeting section decisions
		$removedMeetingSectionDecisions = $meeting->getRemovedMeetingSectionFecisions();
		for ($i=0, $count=count($removedMeetingSectionDecisions); $i < $count; $i++) {
			$this->meetingSectionDecisionDao->deleteMeetingSectionDecision($meeting->getId(), $mSectionDecisions[$i]->getSectionDecisionId());
		}

	}
	
	/**
	 * Okay na. Update minutes_status
	 * @param Meeting $meeting
	 */
	function updateMinutesStatus($meeting) {
		$this->update(
			'UPDATE meetings SET minutes_status = ? where meeting_id = ?',
			array($meeting->getMinutesStatus(), $meeting->getId())
		);
	}
	
	function getSortMapping($heading) {
		switch ($heading) {
			case 'id': return 'a.meeting_id';
			case 'meetingDate': return 'meeting_date';
			case 'meetingLength': return 'meeting_length';
			case 'replyStatus': return 'attending';
			case 'scheduleStatus': return 'status';
			default: return null;
		}
	}
	
	/**
	 * Update meeting/schedule status
	 */
	
	function updateStatus($meetingId, $status){
		$this->update(
			'UPDATE meetings SET status = ? where meeting_id = ?',
			array($status, $meetingId)
		);
	} 
	
	function cancelMeeting($meetingId){
		$this->update(
			'DELETE a,b,c FROM meetings AS a
			 LEFT JOIN meeting_section_decisions AS b ON (b.meeting_id = a.meeting_id)
			 LEFT JOIN meeting_attendance AS c ON (c.meeting_id = b.meeting_id)
			 WHERE c.meeting_id = ?',
			(int) $meetingId
		);
	}

	/**
	 * Get meetings object by decision ID
	 * @param $sectionDecisionId int
	 * @return Meeting
	 */
	function &getMeetingsBySectionDecisionId($sectionDecisionId) {
		
		$meetings = array();
		
		$sql = 'SELECT m.* 
				FROM meetings m
					LEFT JOIN meeting_section_decisions msd ON (msd.meeting_id =  m.meeting_id)
				WHERE msd.section_decision_id = ? ORDER BY m.meeting_date';
		
		$result =& $this->retrieveRange($sql, (int) $sectionDecisionId);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$meetings[] = $this->_returnMeetingFromRow($row);
			$result->moveNext();
		}
							
		return $meetings;
	}
	
	/**
	 * Count the number of previous meetings for the specific section
	 * Used for the generation of the meeting public id
	 * @param $ercId int
	 * @param $meetingId int
	 * Added by EL on April 2013
	 */
	 function countPreviousMeetingsOfERC($ercId, $meetingId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM meetings WHERE section_id = ? AND meeting_id < ?', array($ercId, $meetingId)
		);
		$returner = isset($result->fields[0])? $result->fields[0] + 1 : 0;

		$result->Close();
		unset($result);
		return $returner;
	 }	
         
         
         /**
	 * Get the ID of the last inserted author.
	 * @return int
	 */
	function getInsertMeetingId() {
		return $this->getInsertId('meetings', 'meeting_id');
	}

}

?>
