<?php


class MeetingSectionDecision extends DataObject {

	function MeetingSectionDecision() {
		parent::DataObject();
	}
	
	function setMeetingId($meetingId){
			$this->setData('meetingId', $meetingId);
	}
	
	function getMeetingId() {
		return $this->getData('meetingId');
	}
	
	function setSectionDecisionId($decisionId) {
		$this->setData('decisionId', $decisionId);
	}
	
	function getSectionDecisionId() {
		return $this->getData('decisionId');
	}
}

?>