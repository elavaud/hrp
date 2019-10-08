<?php

define ('STATUS_NEW', 0);
define ('STATUS_FINAL', 1);
define ('STATUS_RESCHEDULED', 2);
define ('STATUS_CANCELLED', 3);

import('classes.meeting.Meeting');
                                
class MeetingAction extends Action {

	/**
	 * Constructor.
	 */
	function MeetingAction() {
		parent::Action();
	}
	

	function cancelMeeting($meetingId, $user = null){
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		
		/*Only the author can cancel the meeting*/
		if ($meeting->getUploader() == $user->getSecretaryCommitteeId()) {
			if (!HookRegistry::call('Action::cancelMeeting', array(&$meetingId))) {
				//$meetingDao->cancelMeeting($meetingId);
				$meetingDao->updateStatus($meetingId, STATUS_CANCELLED);
			} return $meetingId;		
		}
		return false;
	}
	
	/*
	 * Save the meeting
	 * @param $meetingId (int)
	 * @param $selectedSubmissions (array)
	 * @param $meetingDate (datetime)
	 * @param $meetingLength (int)
	 * @param $investigator (bool): specify if the investigator(s) is/are invited
	 */
	
	function saveMeeting($meetingId, $sectionDecisionsId, $meetingDate, $meetingLength, $investigator, $location = null, $final = null){
	
		$user =& Request::getUser();
				
		$journal =& Request::getJournal();
		$journalId = $journal->getId();

                $meetingDao =& DAORegistry::getDAO('MeetingDAO');
		
		/**
		 * Parse date
		* */
		if ($meetingDate != null) {
			$meetingDateParts = explode('-', $meetingDate);
			$tmp = explode(' ', $meetingDateParts[2]);
			$meetingTime = $tmp[1];
			$meetingTimeMarker = $tmp[2];
			$meetingTimeParts = explode(':', $meetingTime);
			$hour = intval($meetingTimeParts[0]);
			
			if(strcasecmp($meetingTimeMarker, 'pm') == 0) {
				if($hour != 12) $hour += 12;
			}
			else {
				if($hour == 12) $hour = 0;
			}
			$meetingDate = mktime($hour, (int)$meetingTimeParts[1], 0, (int)$meetingDateParts[1], (int)$meetingDateParts[2], (int)$meetingDateParts[0]);
		}
                
                $hasChanged = false;
                
		if($meetingId == null || $meetingId == 0) {
                        $isNew = true;
                        $meeting = new Meeting();
                } else {
			$isNew = false;
			$meeting = $meetingDao->getMeetingById($meetingId);
			 if($meetingDate - strtotime($meeting->getDate()) != 0) $hasChanged = true;
                         elseif ($location != $meeting->getLocation()) $hasChanged = true;
                } 
                
                         
                $meeting->setUploader($user->getSecretaryCommitteeId());
                $meeting->setDate($meetingDate);
                $meeting->setLength($meetingLength);
                $meeting->setLocation($location);
                $meeting->setInvestigator($investigator);
                $meeting->setMinutesStatus(MINUTES_STATUS_INCOMPLETE);
                
                if ($final) $meeting->setStatus(STATUS_FINAL);
                elseif ($isNew) $meeting->setStatus(STATUS_NEW);
                else $meeting->setStatus(STATUS_RESCHEDULED);
                
                if ($isNew) $meeting->setId($meetingDao->insertMeeting($meeting));
                
                // Set attendances
                if ($isNew || $hasChanged) {

                        $ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');

                        // Insert Attendance of the external reviewers & Investigators
                        $articleDao =& DAORegistry::getDAO('ArticleDAO');
                        $sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
                        foreach ($sectionDecisionsId as $sectionDecisionId){

                                // For external reviewers
                                $sectionDecision =& $sectionDecisionDao->getSectionDecision($sectionDecisionId);
                                $reviewAssignments =& $sectionDecision->getReviewAssignments();
                                foreach ($reviewAssignments as $reviewAssignment) {
                                        $isReviewer = $ercReviewersDao->ercReviewerExists($journalId, $user->getSecretaryCommitteeId(), $reviewAssignment->getReviewerId());
                                        if (!$isReviewer) {
                                                $meetingAttendance = new MeetingAttendance();
                                                $meetingAttendance->setMeetingId($meeting->getId());
                                                $meetingAttendance->setUserId($reviewAssignment->getReviewerId());
                                                $meetingAttendance->setTypeOfUser(MEETING_EXTERNAL_REVIEWER);
                                                $meetingAttendance->setIsAttending(MEETING_NO_REPLY);
                                                $meetingAttendance->setWasPresent(MEETING_NO_REPLY);
                                                $meetingAttendance->setReasonForAbsence('');
                                                $meeting->addMeetingAttendance($meetingAttendance);
                                        }
                                }

                                // For investigator
                                if ($investigator == 1)	{
                                        $article =& $articleDao->getArticle($sectionDecision->getArticleId());
                                        $meetingAttendance = new MeetingAttendance();
                                        $meetingAttendance->setMeetingId($meeting->getId());
                                        $meetingAttendance->setUserId($article->getUserId());
                                        $meetingAttendance->setTypeOfUser(MEETING_INVESTIGATOR);
                                        $meetingAttendance->setIsAttending(MEETING_NO_REPLY);
                                        $meetingAttendance->setWasPresent(MEETING_NO_REPLY);
                                        $meetingAttendance->setReasonForAbsence('');
                                        $meeting->addMeetingAttendance($meetingAttendance);
                                }			
                        }

                        // Insert Attendance of the reviewers
                        $reviewers =& $ercReviewersDao->getReviewersBySectionId($journalId, $user->getSecretaryCommitteeId());						
                        foreach($reviewers as $reviewer) {
                                $meetingAttendance = new MeetingAttendance();
                                $meetingAttendance->setMeetingId($meeting->getId());
                                $meetingAttendance->setUserId($reviewer->getId());
                                $meetingAttendance->setTypeOfUser(MEETING_ERC_MEMBER);
                                $meetingAttendance->setIsAttending(MEETING_NO_REPLY);
                                $meetingAttendance->setWasPresent(MEETING_NO_REPLY);
                                $meetingAttendance->setReasonForAbsence('');
                                $meeting->addMeetingAttendance($meetingAttendance);
                        }

                        // Insert Attendance of the secretary(ies)
                        $sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
                        $secretaries =& $sectionEditorsDao->getEditorsBySectionId($journalId, $user->getSecretaryCommitteeId());
                        foreach($secretaries as $secretary) {
                                $meetingAttendance = new MeetingAttendance();
                                $meetingAttendance->setMeetingId($meeting->getId());
                                $meetingAttendance->setUserId($reviewer->getId());
                                if (!$secretary->getId() == $user->getId()) $meetingAttendance->setIsAttending(MEETING_REPLY_ATTENDING);
                                else $meetingAttendance->setIsAttending(MEETING_NO_REPLY);
                                $meetingAttendance->setWasPresent(MEETING_NO_REPLY);
                                $meetingAttendance->setReasonForAbsence('');
                                $meeting->addMeetingAttendance($meetingAttendance);                                        
                        }
			
                }
			 			 			 		

		/**
		 * Store submissions to be discussed
		 */
		if (count($sectionDecisionsId) > 0) {
                        $oldSectionDecisions = $meeting->getMeetingSectionDecisions();
                        foreach ($oldSectionDecisions as $oldSectionDecision) {
                                $isHere = false;
                                for ($i=0;$i<count($sectionDecisionsId);$i++) {
                                        if ($oldSectionDecision->getSectionDecisionId() == $sectionDecisionsId[$i]) $isHere = true;
                                }
                                if (!$isHere) $meeting->removeMeetingSectionDecision($oldSectionDecision->getSectionDecisionId());
                                
                        }

                        for ($i=0;$i<count($sectionDecisionsId);$i++) {
                                $isHere = false;
                                foreach ($oldSectionDecisions as $oldSectionDecision) {
                                        if ($oldSectionDecision->getSectionDecisionId() == $sectionDecisionsId[$i]) $isHere = true;
                                }
                                if (!$isHere) {
                                        $meetingSectionDecision = new MeetingSectionDecision();
                                        $meetingSectionDecision->setMeetingId($meeting->getId());
                                        $meetingSectionDecision->setSectionDecisionId($sectionDecisionsId[$i]);
                                        $meeting->addMeetingSectionDecision($meetingSectionDecision);                                    
                                }
			}
		}
		
                $meetingDao->updateMeeting($meeting);
                
                if ($final) Request::redirect(null, null, 'notifyUsersMeeting', array($meeting->getId(), 'MEETING_FINAL'));
                elseif ($isNew) Request::redirect(null, null, 'notifyUsersMeeting', array($meeting->getId(), 'MEETING_NEW'));
                elseif ($hasChanged) Request::redirect(null, null, 'notifyUsersMeeting', array($meeting->getId(), 'MEETING_CHANGE'));                
                else Request::redirect(null, null, 'viewMeeting', array($meeting->getId()));
                
		return $meeting->getId();
	}
	
	/**
	 * Notify reviewers of new meeting set by section editor
	 * Added by ayveemallare 7/12/2011
	 * Last modified by EL on February 26th 2013
	 * And moved from SectionEditorAction to here
	 */

	function notifyReviewersMeeting($meeting, $informationType, $reviewerAttendances, $mSectionDecisions, $send = false) {
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');

                // EL on February 26th 2013
		// Definition of the variable
		$submissions = (string)'';
		$num=1;

		foreach($mSectionDecisions as $mSectionDecision) {
			$sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
			$submissions .= $num.". '".$sectionDecision->getLocalizedProposalTitle()."' ".Locale::translate('common.bySomebody').' '.$sectionDecision->getAuthorString()."\n";
			$num++;
		}

		$userDao =& DAORegistry::getDAO('UserDAO');
		$reviewers = array();
		foreach($reviewerAttendances as $reviewerAttendance) {
			$reviewer = $userDao->getUser($reviewerAttendance->getUserId());
			array_push($reviewers, $reviewer);
		}

		$reviewerAccessKeysEnabled = $journal->getSetting('reviewerAccessKeysEnabled');

		$preventAddressChanges = $reviewerAccessKeysEnabled;

		import('classes.mail.MailTemplate');
		$email = new MailTemplate($informationType);

		if($preventAddressChanges) {
			$email->setAddressFieldsEnabled(false);
		}

		if($send && !$email->hasErrors()) {
			HookRegistry::call('MeetingAction::notifyReviewersMeeting', array(&$meeting, &$informationType, &$reviewers, &$submissions, &$email));
			// EL on February 26th 2013
			// Replaced "reviewerAccessKyesEnabled" by "reviewerAccessKeysEnabled"	
			if($reviewerAccessKeysEnabled) {
				import('lib.pkp.classes.security.AccessKeyManager');
				import('pages.reviewer.ReviewerHandler');
				$accessKeyManager = new AccessKeyManager();
			}
				
			if($preventAddressChanges) {
				// Ensure that this messages goes to the reviewers, and the reviewers ONLY.
				$email->clearAllRecipients();
				foreach($reviewers as $reviewer) {
					$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
				}
			}
			$email->send();
			return true;
		} else {
			if(!Request::getUserVar('continued') || $preventAddressChanges) {
				foreach($reviewers as $reviewer) {
					$email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
				}
			}
			
			// CC the secretary(ies) of the committee
			$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			$secretaries =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $user->getSecretaryCommitteeId());
			foreach ($secretaries as $secretary) $email->addCc($secretary->getEmail(), $secretary->getFullName());
			
							
			if(!Request::getUserVar('continued')) {
				$dateLocation = (string)'';
				if($meeting->getDate() != null) {
					$dateLocation .= Locale::translate('editor.reports.meetingDate').': '.strftime('%B %d, %Y %I:%M %p', strtotime($meeting->getDate()))."\n";
				}
				if($meeting->getLength() != null) {
					$dateLocation .= Locale::translate('editor.meeting.length').': '.$meeting->getLength()."mn\n";
				}
				if($meeting->getLocation() != null) {
					$dateLocation .= Locale::translate('editor.meeting.location').': '.$meeting->getLocation()."\n";
				}
				$replyUrl = Request::url(null, 'reviewer', 'viewMeeting', $meeting->getId()
					, $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array()
				);
				$sectionDao =& DAORegistry::getDAO('SectionDAO');
				$erc =& $sectionDao->getSection($meeting->getUploader());
				$paramArray = array(
					'ercTitle' => $erc->getLocalizedTitle(),
					'ercAbbrev' => $erc->getLocalizedAbbrev(),
					'submissions' => $submissions,
					'dateLocation' => $dateLocation,
					'replyUrl' => $replyUrl,
					'secretaryName' => $user->getFullName(),
					'secretaryFunctions' => $user->getErcFunction($meeting->getUploader())
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyUsersMeeting', array($meeting->getId(), $informationType)));
			return false;
		}
		return true;
	}

	/**
	 * Notify an investigator of a new meeting set by section editor
	 */

	function notifyExternalReviewerMeeting($meeting, $informationType, $externalReviewerAttendance, $attendanceIncrementNumber, $mSectionDecisions, $send = false) {
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$num=1;
		$submissions = (string)'';

		foreach($mSectionDecisions as $mSectionDecision) {
			$sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
			$reviewAssignments =& $sectionDecision->getReviewAssignments();
			foreach ($reviewAssignments as $reviewAssignment) {
				if ($reviewAssignment->getReviewerId() == $externalReviewerAttendance->getUserId()){
					$submissions .= $num.". '".$sectionDecision->getLocalizedProposalTitle()."' ".Locale::translate('common.bySomebody').' '.$sectionDecision->getAuthorString()."\n";
					$num++;
				}
			}
		}

		$reviewerAccessKeysEnabled = $journal->getSetting('reviewerAccessKeysEnabled');

		$preventAddressChanges = $reviewerAccessKeysEnabled;
		
		$userDao =& DAORegistry::getDAO('UserDAO');
		$extReviewer =& $userDao->getUser($externalReviewerAttendance->getUserId());

		import('classes.mail.MailTemplate');
		$email = new MailTemplate($informationType);
		
		if($preventAddressChanges) {
			$email->setAddressFieldsEnabled(false);
		}
		
		if($send && !$email->hasErrors()) {
			HookRegistry::call('MeetingAction::notifyExternalReviewerMeeting', array(&$meeting, &$informationType, &$extReviewer, $attendanceIncrementNumber, &$submissions, &$email));

			if($reviewerAccessKeysEnabled) {
				import('lib.pkp.classes.security.AccessKeyManager');
				import('pages.reviewer.ReviewerHandler');
				$accessKeyManager = new AccessKeyManager();
			}
				
			if($preventAddressChanges) {
				// Ensure that this messages goes to the reviewers, and the reviewers ONLY.
				$email->clearAllRecipients();
				$email->addRecipient($extReviewer->getEmail(), $extReviewer->getFullName());
			}
			
			$email->send();
			return true;
		} else {
			if(!Request::getUserVar('continued') || $preventAddressChanges) {
				$email->addRecipient($extReviewer->getEmail(), $extReviewer->getFullName());
			}
			
			// CC the secretary(ies) of the committee
			$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			$secretaries =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $user->getSecretaryCommitteeId());
			foreach ($secretaries as $secretary) $email->addCc($secretary->getEmail(), $secretary->getFullName());
			
							
			if(!Request::getUserVar('continued')) {
				$dateLocation = (string)'';
				if($meeting->getDate() != null) {
					$dateLocation .= Locale::translate('editor.reports.meetingDate').': '.strftime('%B %d, %Y %I:%M %p', strtotime($meeting->getDate()))."\n";
				}
				if($meeting->getLength() != null) {
					$dateLocation .= Locale::translate('editor.meeting.length').': '.$meeting->getLength()."mn\n";
				}
				if($meeting->getLocation() != null) {
					$dateLocation .= Locale::translate('editor.meeting.location').': '.$meeting->getLocation()."\n";
				}
				$dateLocation .= Locale::translate('editor.meeting.numberOfProposalsToReview').': '.count($mSectionDecisions)."\n";
				
				$replyUrl = Request::url(null, 'reviewer', 'viewMeeting', $meeting->getId(), $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array());
				
				$sectionDao =& DAORegistry::getDAO('SectionDAO');
				$erc =& $sectionDao->getSection($meeting->getUploader());
				$paramArray = array(
					'ercTitle' => $erc->getLocalizedTitle(),
					'extReviewerFullName' => $extReviewer->getFullName(),
					'submissions' => $submissions,
					'dateLocation' => $dateLocation,
					'replyUrl' => $replyUrl,
					'secretaryName' => $user->getFullName(),
					'secretaryFunctions' => $user->getErcFunction($meeting->getUploader())
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyExternalReviewersMeeting', array($meeting->getId(), $attendanceIncrementNumber, $informationType)));
			return false;
		}
		return true;
	}
	
	/**
	 * Notify an investigator of a new meeting set by section editor
	 * Added by EL on February 28th 2013
	 * And moved from SectionEditorAction to here
	 */

	function notifyInvestigatorMeeting($meeting, $informationType, $investigatorAttendance, $attendanceIncrementNumber, $mSectionDecisions, $send = false) {
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$num=1;
		$submissions = (string)'';

		foreach($mSectionDecisions as $mSectionDecision) {
			$sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
			$submission = $articleDao->getArticle($sectionDecision->getArticleId(), $journal->getId(), false);
			$abstract = $submission->getLocalizedAbstract();
			if ($submission->getUserId() == $investigatorAttendance->getUserId()) {
				$submissions .= $num.". '".$abstract->getScientificTitle()."'\n";
				$num++;
			}
		}

		$userDao =& DAORegistry::getDAO('UserDAO');
		$investigator =& $userDao->getUser($investigatorAttendance->getUserId());

		import('classes.mail.MailTemplate');
		$email = new MailTemplate($informationType);

		if($send && !$email->hasErrors()) {
			HookRegistry::call('MeetingAction::notifyInvestigatorMeeting', array(&$meeting, &$informationType, &$investigator, $attendanceIncrementNumber, &$submissions, &$email));
			$email->send();
			return true;
		} else {
			if(!Request::getUserVar('continued')) {
				// Add email of the submitter
				$email->addRecipient($investigator->getEmail(), $investigator->getFullName());

				// Add emails of the investigator(s) if different from the submitter
				foreach($mSectionDecisions as $mSectionDecision) {
                                        $sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
					$submission = $articleDao->getArticle($sectionDecision->getArticleId(), $journal->getId(), false);
					if ($submission->getUserId() == $investigatorAttendance->getUserId()) {
						$authors = $submission->getAuthors();
						foreach ($authors as $author) {
							if ($author->getEmail() != $investigator->getEmail()) $email->addRecipient($author->getEmail(), $author->getFirstName().' '.$author->getLastName());	
						}
					}
				}
			}
			
			// CC the secretary(ies) of the committee
			$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			$secretaries =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $user->getSecretaryCommitteeId());
			foreach ($secretaries as $secretary) $email->addCc($secretary->getEmail(), $secretary->getFullName());
			
							
			if(!Request::getUserVar('continued')) {
				$dateLocation = (string)'';
				if($meeting->getDate() != null) {
					$dateLocation .= Locale::translate('editor.reports.meetingDate').': '.strftime('%B %d, %Y %I:%M %p', strtotime($meeting->getDate()))."\n";
				}
				if($meeting->getLength() != null) {
					$dateLocation .= Locale::translate('editor.meeting.length').': '.$meeting->getLength()."mn\n";
				}
				if($meeting->getLocation() != null) {
					$dateLocation .= Locale::translate('editor.meeting.location').': '.$meeting->getLocation()."\n";
				}
				$dateLocation .= Locale::translate('editor.meeting.numberOfProposalsToReview').': '.count($mSectionDecisions)."\n";
				
				$replyUrl = (string)'';
				$investigatorFullName = (string)$investigator->getFullName();
				$urlFirst = true;
				foreach($mSectionDecisions as $mSectionDecision) {
                                        $sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
                                        $submission = $articleDao->getArticle($sectionDecision->getArticleId(), $journal->getId(), false);
                                        if ($urlFirst) { 
						$replyUrl .= Request::url(null, 'author', 'submissionReview', $sectionDecision->getArticleId());
						$urlFirst = false;
					} else $replyUrl .= '    '.Locale::translate("common.or").':    '.Request::url(null, 'author', 'submissionReview', $sectionDecision->getArticleId());
					// Add name of the investigators if different from submitter
					if ($submission->getUserId() == $investigatorAttendance->getUserId()) {
						$authors = $submission->getAuthors();
						foreach ($authors as $author) {
							if (($author->getFirstName() != $investigator->getFirstName()) || ($author->getLastName() != $investigator->getLastName())) $investigatorFullName .= ', '.$author->getFirstName().' '.$author->getLastName();
						}
					}					
				}
				
				
				
				$sectionDao =& DAORegistry::getDAO('SectionDAO');
				$erc =& $sectionDao->getSection($meeting->getUploader());
				$paramArray = array(
					'ercTitle' => $erc->getLocalizedTitle(),
					'investigatorFullName' => $investigatorFullName,
					'submissions' => $submissions,
					'dateLocation' => $dateLocation,
					'replyUrl' => nl2br($replyUrl),
					'secretaryName' => $user->getFullName(),
					'secretaryFunctions' => $user->getErcFunction($meeting->getUploader())
				);
				$email->assignParams($paramArray);
			}
			$email->displayEditForm(Request::url(null, null, 'notifyInvestigatorsMeeting', array($meeting->getId(), $attendanceIncrementNumber, $informationType)));
			return false;
		}
		return true;
	}

	/**
	 * Remind reviewers of a meeting
	 * Added by ayveemallare 7/12/2011
	 * Moved from sectionEditorAction by EL on March 5th
	 */

	function remindUserMeeting($meeting, $addresseeId, $mSectionDecisions, $send = false) {
		$journal =& Request::getJournal();
		$user = & Request::getUser();
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		
                $submissions = (string)'';
		$num=1;
		foreach($mSectionDecisions as $mSectionDecision) {
			$sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
			$submissions .= $num.". '".$sectionDecision->getLocalizedProposalTitle()."' ".Locale::translate('common.bySomebody').' '.$sectionDecision->getAuthorString(true)."\n";
			$num++;
		}
		$userDao =& DAORegistry::getDAO('UserDAO');
		$addressee = $userDao->getUser($addresseeId);

		$reviewerAccessKeysEnabled = $journal->getSetting('reviewerAccessKeysEnabled');

		$preventAddressChanges = $reviewerAccessKeysEnabled;

		import('classes.mail.MailTemplate');
		$email = new MailTemplate('MEETING_REMIND');

		if($preventAddressChanges) {
			$email->setAddressFieldsEnabled(false);
		}
		if($send && !$email->hasErrors()) {
			HookRegistry::call('MeetingAction::remindUserMeeting', array(&$meeting, &$addressee, &$submissions, &$email));

			// EL on February 26th 2013
			// Replaced "reviewerAccessKyesEnabled" by "reviewerAccessKeysEnabled"			
			if($reviewerAccessKeysEnabled) {
				import('lib.pkp.classes.security.AccessKeyManager');
				import('pages.reviewer.ReviewerHandler');
				$accessKeyManager = new AccessKeyManager();
			}
				
			if($preventAddressChanges) {
				// Ensure that this messages goes to the reviewers, and the reviewers ONLY.
				$email->clearAllRecipients();
				$email->addRecipient($addressee->getEmail(), $addressee->getFullName());
			}
			$email->send();
				
			$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
			$meetingAttendanceDao->updateDateReminded(Core::getCurrentDate(), $addresseeId, $meeting);
			return true;
		} else {
			if(!Request::getUserVar('continued') || $preventAddressChanges) {
				$email->addRecipient($addressee->getEmail(), $addressee->getFullName());
			}
			if(!Request::getUserVar('continued')) {
				$dateLocation = (string)'';
				if($meeting->getDate() != null) {
					$dateLocation .= Locale::translate('editor.reports.meetingDate').': '.strftime('%B %d, %Y %I:%M %p', strtotime($meeting->getDate()))."\n";
				}
				if($meeting->getLength() != null) {
					$dateLocation .= Locale::translate('editor.meeting.length').': '.$meeting->getLength()."mn\n";
				}
				if($meeting->getLocation() != null) {
					$dateLocation .= Locale::translate('editor.meeting.location').': '.$meeting->getLocation()."\n";
				}
				$dateLocation .= Locale::translate('editor.meeting.numberOfProposalsToReview').': '.count($mSectionDecisions)."\n";
                                
                                $meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
				$type = $meetingAttendanceDao->getTypeOfUser($meeting->getId(), $addressee->getId());
				
				$replyUrl = (string)'';
				if ($type == MEETING_INVESTIGATOR) {
					$urlFirst = true;
					foreach ($mSectionDecisions as $mSectionDecision){
                                                $sectionDecision = $sectionDecisionDao->getSectionDecision($mSectionDecision->getSectionDecisionId());
						if ($urlFirst) {
							$replyUrl .= Request::url(null, 'author', 'submissionReview', $sectionDecision->getArticleId());
							$urlFirst = false;
						} else $replyUrl .= '   '.Locale::translate("common.or").':   '.Request::url(null, 'author', 'submissionReview', $sectionDecision->getArticleId());					
					}
				} elseif ($type == MEETING_SECRETARY) {
					$replyUrl = Request::url(null, 'sectionEditor', 'viewMeeting', $meeting->getId());
				} elseif (($type == MEETING_EXTERNAL_REVIEWER) || ($type == MEETING_ERC_MEMBER)) {
					$replyUrl = Request::url(null, 'reviewer', 'viewMeeting', $meeting->getId(), $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array());
				} else return false;
				
				$replyUrl = Request::url(null, 'reviewer', 'viewMeeting', $meeting->getId()
					// EL on february 26th 2013
					// Undefined - replaced "reviewerAccessKeyEnabled" by "reviewerAccessKeysEnabled"
					, $reviewerAccessKeysEnabled?array('key' => 'ACCESS_KEY'):array()
				);
				
				$sectionDao =& DAORegistry::getDAO('SectionDAO');
				$erc =& $sectionDao->getSection($meeting->getUploader());
				
				$paramArray = array(
					'ercTitle' => $erc->getLocalizedTitle(),
					'addresseeFullName' => $addressee->getFullName(),
					'submissions' => $submissions,
					'dateLocation' => $dateLocation,
					'replyUrl' => $replyUrl,
					'secretaryName' => $user->getFullName(),
					'secretaryFunctions' => $user->getErcFunction($meeting->getUploader())
				);
				$email->assignParams($paramArray);
			}
			// EL on February 26th 2013
			// Replaced submissionsIds by submissionIds
			// + moved the paramters as additional parameters
			$email->displayEditForm(Request::url(null, null, 'remindUserMeeting', array($meeting->getId(), $addresseeId)));
			return false;
		}
		return true;
	}
			
	function setMeetingFinal($meetingId, $user=null){
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);

		/*Only the secretary can set the meeting final*/
		if ($meeting->getUploader() == $user->getSecretaryCommitteeId()) {
			if (!HookRegistry::call('Action::setMeetingFinal', array(&$meetingId))) {
				$meetingDao->updateStatus($meetingId, STATUS_FINAL);
			}
			return $meetingId;	
		}
		return false;
	}

	/**
	 * Reply the attendance of the user
	 */
	function replyAttendanceForUser($meetingId, $userId, $attendance){
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');

		$meetingAttendance = $meetingAttendanceDao->getMeetingAttendance($meetingId, $userId);

		$meetingAttendance->setIsAttending($attendance);
		
		$meetingAttendanceDao->updateReplyOfAttendance($meetingAttendance);
		return true;	
	}	
}
