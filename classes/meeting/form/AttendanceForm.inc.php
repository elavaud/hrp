<?php

/**
 * @defgroup sectionEditor_form
 */


import('lib.pkp.classes.form.Form');

class AttendanceForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $meetingAttendances;
	var $quorum;
	var $journalId;
	/**
	 * Constructor.
	 */
	function AttendanceForm($meetingId, $journalId) {
		parent::Form('sectionEditor/minutes/generateAttendance.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$this->journalId =$journalId;
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);		

		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');	
		$this->meetingAttendances =& $meetingAttendanceDao->getMeetingAttendancesByMeetingId($meetingId);
		
		//import('classes.meeting.MeetingAttendance');
		
		$this->addCheck(new FormValidator($this, 'adjourned', 'required', 'editor.minutes.adjournedRequired'));
		$this->addCheck(new FormValidator($this, 'venue', 'required', 'editor.minutes.venueRequired'));
		
		$this->addCheck(new FormValidatorArray($this, 'guest_attendance', 'required', 'editor.minutes.generateAttendance.requiredAttendance',array('attendance','guestId')));
		$this->addCheck(new FormValidatorCustom($this, 'guest_attendance', 'required', 'editor.minutes.generateAttendance.requiredReasonOfAbsence', create_function('$guest_attendance,$form', 
		'
		foreach($guest_attendance as $key=>$reviewer){
			if(isset($reviewer["attendance"]) && ($reviewer["attendance"]=="absent") && !isset($reviewer["reason"])) return false;
		} return true;
		'
		), array(&$this)));	
	}

	/**
	 * Initialize form
	 * */
	
	
	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$meeting =& $this->meeting;
		$meetingAttendances =& $this->meetingAttendances;
	
		$attendance  = $this->getData('guest_attendance');
		$suppGuestNames = $this->getData("suppGuestName");
		if (!$suppGuestNames) $suppGuestNames = array('');
		$suppGuestAffiliations = $this->getData("suppGuestAffiliation");
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('meetingAttendances', $meetingAttendances);
		
		$templateMgr->assign_by_ref('attendance', $attendance);
		$templateMgr->assign_by_ref('suppGuestNames', $suppGuestNames);
		$templateMgr->assign_by_ref('suppGuestAffiliations', $suppGuestAffiliations);

		$templateMgr->assign('adjourned', $this->getData('adjourned'));
		$templateMgr->assign('venue', $this->getData('venue'));
		$templateMgr->assign('announcements', $this->getData('announcements'));
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array("adjourned", 
				  "venue", 
				  "announcements", 
				  "guest_attendance",
				  "suppGuestName",
				  "suppGuestAffiliation"
		));
	}
	
	/**
	 *
	 * @return userId int
	 */
	function execute() {

		$meeting =& $this->meeting;
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meetingAttendanceDao =& DAORegistry::getDAO("MeetingAttendanceDAO");
		$quorum = 0;
		
		$guestAttendances  = $this->getData('guest_attendance');
		foreach($guestAttendances as $index=>$item) {
			$guestId = $index;
			$meetingAttendance = new MeetingAttendance();
			$meetingAttendance->setMeetingId($meeting->getId());
			$meetingAttendance->setUserId($guestId);
			if ($guestAttendances[$guestId]['attendance'] =="absent"){
				$meetingAttendance->setWasPresent(2);
				$meetingAttendance->setReasonForAbsence($guestAttendances[$guestId]["reason"]);
			} else {
				$meetingAttendance->setWasPresent(1);
				$meetingAttendance->setReasonForAbsence(null);
				$quorum++;
			}
						
			$meetingAttendanceDao->updateAttendanceOfUser($meetingAttendance);
		}
		
		$this->quorum = $quorum;	 
		$meeting->updateMinutesStatus(MINUTES_STATUS_ATTENDANCE);
		$meetingDao->updateMinutesStatus($meeting);		 
	}

	function savePdf() {
		$meeting =& $this->meeting;		
		$meetingAttendanceDao =& DAORegistry::getDAO("MeetingAttendanceDAO");
		$meetingAttendances =& $meetingAttendanceDao->getMeetingAttendancesByMeetingId($meeting->getId());
		$suppGuestNames = $this->getData("suppGuestName");
		$suppGuestAffiliations = $this->getData("suppGuestAffiliation");
		$meetingDateTime = date( "d F Y g:ia", strtotime( $meeting->getDate() ) );
		$meetingDate = date( "d F Y", strtotime( $meeting->getDate() ) );
		$details = Locale::translate('editor.meeting.attendanceReport.intro1').' '.$this->getData("venue").' '.Locale::translate('common.date.on').' '.$meetingDateTime.' '.Locale::translate('editor.meeting.attendanceReport.intro2').' '.$this->quorum.' '.Locale::translate('editor.meeting.attendanceReport.intro3').' '.$this->getData('adjourned') .".";
		$journal = Request::getJournal();
                $user = Request::getUser();
                
                import('classes.lib.tcpdf.pdf');
                
                $pdf = new PDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
                                                
                $pdf->SetCreator(PDF_CREATOR);
                
                $pdf->SetAuthor($user->getFullName());
                
                $pdf->SetTitle($journal->getJournalTitle());
                
                $pdf->SetSubject($meeting->getPublicId().' - '.Locale::translate('editor.minutes.attendance'));                
                                
                // set default header data
                $pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE.' 020', PDF_HEADER_STRING);

                // set header and footer fonts
                $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
                $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

                // set default monospaced font
                $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

                // set margins
                $pdf->SetMargins(PDF_MARGIN_LEFT, 58, PDF_MARGIN_RIGHT);
                $pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
                $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

                // set auto page breaks
                $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

                // set image scale factor
                $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
                
                $pdf->AddPage();
                $pdf->SetFont('dejavusans','B',13);                
                
		$sectionDao =& DAORegistry::getDAO("SectionDAO");
		$erc =& $sectionDao->getSection($meeting->getUploader());
		
                $pdf->SetFont('dejavusans','I',13);                
                $pdf->MultiCell(0,6,$erc->getSectionTitle(), 0, 'C');
                $pdf->MultiCell(0,6,Locale::translate('editor.meeting.attendanceReport.meetingDate').' '.$meetingDate, 0, 'C');
                $pdf->ln();
                        
                $memberCount = 0;
                $pdf->SetFont('dejavusans','BU',12);
                $pdf->MultiCell(0,6,Locale::translate('editor.meeting.attendanceReport.membersPresent'), 0, 'L');
                $pdf->ln();
                $pdf->SetFont('dejavusans','',12);
		foreach($meetingAttendances as $meetingAttendance) {
			if($meetingAttendance->getWasPresent() == 1) {
                                $member =& $meetingAttendance->getUser();
                                $pdf->MultiCell(0,6,$member->getFullName(), 0, 'L');
				$memberCount++;									
			}
		}
		if($memberCount == 0) $pdf->MultiCell(0,6,Locale::translate('common.none'), 0, 'L');
                $pdf->ln();
                
		$memberCount = 0;
                $pdf->SetFont('dejavusans','BU',12);
                $pdf->MultiCell(0,6,Locale::translate('editor.meeting.attendanceReport.membersAbsent'), 0, 'L');
                $pdf->ln();
                $pdf->SetFont('dejavusans','',12);

		foreach($meetingAttendances as $meetingAttendance) {
			if($meetingAttendance->getWasPresent() == 2) {
                                $member =& $meetingAttendance->getUser();
                                $pdf->MultiCell(0,6,$member->getFullName().' ('.Locale::translate('editor.meeting.attendanceReport.reasonForAbsence').' '.$meetingAttendance->getReasonForAbsence().')', 0, 'L');
				$memberCount++;																	
			}			
		}
		if($memberCount == 0) $pdf->MultiCell(0,6,Locale::translate('common.none'), 0, 'L');
                $pdf->ln();
                
		if(count($suppGuestNames)>0) {
			$suppGuestCount = 0;
			foreach($suppGuestNames as $key=>$guest) {
				if($guest!="" && $guest!=null) {
                                        if ($suppGuestCount == 0) {
                                            $pdf->SetFont('dejavusans','BU',12);
                                            $pdf->MultiCell(0,6,Locale::translate('editor.meeting.attendanceReport.suppGuest'), 0, 'L');
                                            $pdf->ln();
                                            $pdf->SetFont('dejavusans','',12);
                                        }
                                        $pdf->MultiCell(0,6,$guest.' ('.$suppGuestAffiliations[$key].')', 0, 'L');
					$suppGuestCount++;
				}
			}
                        $pdf->ln();
		}
			 
                $pdf->MultiCell(0,6,$details, 0, 'L');
                $pdf->ln();
                
                if($this->getData("announcements")) {
                    $pdf->SetFont('dejavusans','BU',12);
                    $pdf->MultiCell(0,6,Locale::translate('editor.meeting.attendanceReport.announcements'), 0, 'L');
                    $pdf->ln();
                    $pdf->SetFont('dejavusans','',12);
                    $pdf->MultiCell(0,6,$this->getData("announcements"), 0, 'L');
                    $pdf->ln();
                }
		
                $pdf->SetFont('dejavusans','BU',12);
                $pdf->MultiCell(0,6,Locale::translate('editor.meeting.attendanceReport.submittedBy'), 0, 'L');
                $pdf->ln();
                $pdf->SetFont('dejavusans','',12);
                $pdf->MultiCell(0,6,$user->getFullName(), 0, 'L');
                $pdf->ln();
					
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meeting->getId());
		$minutesFileManager->handleWrite($pdf, MINUTES_FILE_ATTENDANCE);
	}
}

?>
