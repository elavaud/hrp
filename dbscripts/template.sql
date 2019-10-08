-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 03, 2015 at 09:43 PM
-- Server version: 5.5.41-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `hrp`
--

-- --------------------------------------------------------

--
-- Table structure for table `about_file`
--

CREATE TABLE IF NOT EXISTS `about_file` (
  `about_file_id` int(2) NOT NULL AUTO_INCREMENT,
  `name` varchar(90) NOT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `type` tinyint(1) NOT NULL,
  PRIMARY KEY (`about_file_id`),
  KEY `about_file_id` (`about_file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `about_file_settings`
--

CREATE TABLE IF NOT EXISTS `about_file_settings` (
  `about_file_id` int(2) NOT NULL,
  `locale` varchar(5) NOT NULL,
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `about_file_settings_pkey` (`about_file_id`,`locale`,`setting_name`),
  KEY `about_file_settings_public_file_id` (`about_file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `access_keys`
--

CREATE TABLE IF NOT EXISTS `access_keys` (
  `access_key_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context` varchar(40) NOT NULL,
  `key_hash` varchar(40) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`access_key_id`),
  KEY `access_keys_hash` (`key_hash`,`user_id`,`context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE IF NOT EXISTS `announcements` (
  `announcement_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `type_id` bigint(20) DEFAULT NULL,
  `date_expire` datetime DEFAULT NULL,
  `date_posted` datetime NOT NULL,
  PRIMARY KEY (`announcement_id`),
  KEY `announcements_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `announcement_settings`
--

CREATE TABLE IF NOT EXISTS `announcement_settings` (
  `announcement_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `announcement_settings_pkey` (`announcement_id`,`locale`,`setting_name`),
  KEY `announcement_settings_announcement_id` (`announcement_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `announcement_types`
--

CREATE TABLE IF NOT EXISTS `announcement_types` (
  `type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) NOT NULL,
  PRIMARY KEY (`type_id`),
  KEY `announcement_types_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `announcement_type_settings`
--

CREATE TABLE IF NOT EXISTS `announcement_type_settings` (
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `announcement_type_settings_pkey` (`type_id`,`locale`,`setting_name`),
  KEY `announcement_type_settings_type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `approval_notices`
--

CREATE TABLE IF NOT EXISTS `approval_notices` (
  `approval_notice_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `committees` varchar(90) NOT NULL,
  `review_types` varchar(90) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `title` varchar(255) NOT NULL,
  `header` text,
  `body` text,
  `footer` text,
  PRIMARY KEY (`approval_notice_id`),
  KEY `approval_notice_id` (`approval_notice_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `article_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_id` varchar(32) DEFAULT NULL,
  `locale` varchar(5) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `language` varchar(10) DEFAULT 'en',
  `comments_to_ed` text,
  `citations` text,
  `date_submitted` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `date_status_modified` datetime DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `submission_progress` tinyint(4) NOT NULL DEFAULT '1',
  `submission_file_id` bigint(20) DEFAULT NULL,
  `revised_file_id` bigint(20) DEFAULT NULL,
  `review_file_id` bigint(20) DEFAULT NULL,
  `editor_file_id` bigint(20) DEFAULT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `doi` varchar(255) DEFAULT NULL,
  `fast_tracked` tinyint(4) NOT NULL DEFAULT '0',
  `hide_author` tinyint(4) NOT NULL DEFAULT '0',
  `comments_status` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`article_id`),
  KEY `articles_user_id` (`user_id`),
  KEY `articles_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_abstract`
--

CREATE TABLE IF NOT EXISTS `article_abstract` (
  `abstract_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `locale` varchar(5) CHARACTER SET utf8 NOT NULL,
  `scientific_title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `clean_scientific_title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `public_title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `clean_public_title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `background` text CHARACTER SET utf8 NOT NULL,
  `objectives` text CHARACTER SET utf8 NOT NULL,
  `study_methods` text CHARACTER SET utf8 NOT NULL,
  `expected_outcomes` text CHARACTER SET utf8 NOT NULL,
  `keywords` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`abstract_id`),
  UNIQUE KEY `locale` (`article_id`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_comments`
--

CREATE TABLE IF NOT EXISTS `article_comments` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `comment_type` bigint(20) DEFAULT NULL,
  `role_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `author_id` bigint(20) NOT NULL,
  `comment_title` varchar(255) NOT NULL,
  `comments` text,
  `date_posted` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `viewable` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `article_comments_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_details`
--

CREATE TABLE IF NOT EXISTS `article_details` (
  `article_id` bigint(20) NOT NULL,
  `student` tinyint(1) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `key_implementing_institution` int(3) NOT NULL,
  `multi_country` tinyint(1) NOT NULL,
  `countries` varchar(255) CHARACTER SET utf8 NOT NULL,
  `nationwide` tinyint(1) NOT NULL,
  `geo_areas` varchar(255) CHARACTER SET utf8 NOT NULL,
  `research_domains` varchar(16) DEFAULT NULL,
  `research_fields` varchar(255) CHARACTER SET utf8 NOT NULL,
  `human_subjects` tinyint(1) NOT NULL,
  `proposal_types` varchar(255) CHARACTER SET utf8 NOT NULL,
  `data_collection` tinyint(1) NOT NULL,
  `committee_reviewed` tinyint(1) NOT NULL,
  UNIQUE KEY `article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `article_email_log`
--

CREATE TABLE IF NOT EXISTS `article_email_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL,
  `date_sent` datetime NOT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  `event_type` bigint(20) DEFAULT NULL,
  `assoc_type` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `from_address` varchar(255) DEFAULT NULL,
  `recipients` text,
  `cc_recipients` text,
  `bcc_recipients` text,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  PRIMARY KEY (`log_id`),
  KEY `article_email_log_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_event_log`
--

CREATE TABLE IF NOT EXISTS `article_event_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_logged` datetime NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `log_level` varchar(1) DEFAULT NULL,
  `event_type` bigint(20) DEFAULT NULL,
  `assoc_type` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `message` text,
  PRIMARY KEY (`log_id`),
  KEY `article_event_log_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_files`
--

CREATE TABLE IF NOT EXISTS `article_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `source_file_id` bigint(20) DEFAULT NULL,
  `article_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `type` varchar(40) NOT NULL,
  `viewable` tinyint(4) DEFAULT NULL,
  `date_uploaded` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`file_id`),
  KEY `article_files_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_galleys`
--

CREATE TABLE IF NOT EXISTS `article_galleys` (
  `galley_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_galley_id` varchar(255) DEFAULT NULL,
  `locale` varchar(5) DEFAULT NULL,
  `article_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  `label` varchar(32) DEFAULT NULL,
  `html_galley` tinyint(4) NOT NULL DEFAULT '0',
  `style_file_id` bigint(20) DEFAULT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `views` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`galley_id`),
  UNIQUE KEY `article_galleys_public_id` (`public_galley_id`,`article_id`),
  KEY `article_galleys_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_html_galley_images`
--

CREATE TABLE IF NOT EXISTS `article_html_galley_images` (
  `galley_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  UNIQUE KEY `article_html_galley_images_pkey` (`galley_id`,`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `article_notes`
--

CREATE TABLE IF NOT EXISTS `article_notes` (
  `note_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `note` text,
  `file_id` bigint(20) NOT NULL,
  PRIMARY KEY (`note_id`),
  KEY `article_notes_article_id` (`article_id`),
  KEY `article_notes_user_id` (`user_id`),
  KEY `article_notes_file_id` (`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_risk_assessments`
--

CREATE TABLE IF NOT EXISTS `article_risk_assessments` (
  `article_id` bigint(20) NOT NULL,
  `identity_revealed` tinyint(1) NOT NULL,
  `unable_to_consent` tinyint(1) NOT NULL,
  `under_18` tinyint(1) NOT NULL,
  `dependent_relationship` tinyint(1) NOT NULL,
  `ethnic_minority` tinyint(1) NOT NULL,
  `mental_impairment` tinyint(1) NOT NULL,
  `pregnant` tinyint(1) NOT NULL,
  `new_treatment` tinyint(1) NOT NULL,
  `biological_samples` tinyint(1) NOT NULL,
  `export_human_tissue` tinyint(1) NOT NULL,
  `export_reason` tinyint(1) NOT NULL,
  `ionizing_radiation` tinyint(1) NOT NULL,
  `distress` tinyint(1) NOT NULL,
  `inducements` tinyint(1) NOT NULL,
  `sensitive_information` tinyint(1) NOT NULL,
  `repro_technology` tinyint(1) NOT NULL,
  `genetic` tinyint(1) NOT NULL,
  `stem_cell` tinyint(1) NOT NULL,
  `biosafety` tinyint(1) NOT NULL,
  `level_of_risk` tinyint(1) NOT NULL,
  `risks_list` text CHARACTER SET utf8,
  `risks_management` text CHARACTER SET utf8,
  `risks_to_team` tinyint(1) NOT NULL,
  `risks_to_subjects` tinyint(1) NOT NULL,
  `risks_to_community` tinyint(1) NOT NULL,
  `benefits_to_participants` tinyint(1) NOT NULL,
  `knowledge_on_condition` tinyint(1) NOT NULL,
  `knowledge_on_disease` tinyint(1) NOT NULL,
  `multi_institution` tinyint(1) NOT NULL,
  `conflict_of_interest` tinyint(1) NOT NULL,
  UNIQUE KEY `article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `article_search_keyword_list`
--

CREATE TABLE IF NOT EXISTS `article_search_keyword_list` (
  `keyword_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `keyword_text` varchar(60) NOT NULL,
  PRIMARY KEY (`keyword_id`),
  UNIQUE KEY `article_search_keyword_text` (`keyword_text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_search_objects`
--

CREATE TABLE IF NOT EXISTS `article_search_objects` (
  `object_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_search_object_keywords`
--

CREATE TABLE IF NOT EXISTS `article_search_object_keywords` (
  `object_id` bigint(20) NOT NULL,
  `keyword_id` bigint(20) NOT NULL,
  `pos` int(11) NOT NULL,
  UNIQUE KEY `article_search_object_keywords_pkey` (`object_id`,`pos`),
  KEY `article_search_object_keywords_keyword_id` (`keyword_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `article_settings`
--

CREATE TABLE IF NOT EXISTS `article_settings` (
  `article_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `article_settings_pkey` (`article_id`,`locale`,`setting_name`),
  KEY `article_settings_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `article_source`
--

CREATE TABLE IF NOT EXISTS `article_source` (
  `source_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `institution_id` int(4) NOT NULL,
  `amount` bigint(20) NOT NULL,
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `source_id` (`source_id`),
  KEY `article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Source of monetary and material support of a research propos' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_student`
--

CREATE TABLE IF NOT EXISTS `article_student` (
  `article_id` bigint(20) NOT NULL,
  `institution` varchar(255) CHARACTER SET utf8 NOT NULL,
  `degree` tinyint(1) NOT NULL,
  `supervisor_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `supervisor_email` varchar(90) CHARACTER SET utf8 NOT NULL,
  UNIQUE KEY `article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `article_supplementary_files`
--

CREATE TABLE IF NOT EXISTS `article_supplementary_files` (
  `supp_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `public_supp_file_id` varchar(255) DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `show_reviewers` tinyint(4) DEFAULT '0',
  `date_submitted` datetime NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`supp_id`),
  KEY `article_supplementary_files_file_id` (`file_id`),
  KEY `article_supplementary_files_article_id` (`article_id`),
  KEY `supp_public_supp_file_id` (`public_supp_file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `article_supp_file_settings`
--

CREATE TABLE IF NOT EXISTS `article_supp_file_settings` (
  `supp_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `article_supp_file_settings_pkey` (`supp_id`,`locale`,`setting_name`),
  KEY `article_supp_file_settings_supp_id` (`supp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `article_xml_galleys`
--

CREATE TABLE IF NOT EXISTS `article_xml_galleys` (
  `xml_galley_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `galley_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `label` varchar(32) NOT NULL,
  `galley_type` varchar(255) NOT NULL,
  `views` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`xml_galley_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE IF NOT EXISTS `authors` (
  `author_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `primary_contact` tinyint(4) NOT NULL DEFAULT '0',
  `seq` double NOT NULL DEFAULT '0',
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(90) NOT NULL,
  `affiliation` varchar(255) DEFAULT NULL,
  `email` varchar(90) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `user_group_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`author_id`),
  KEY `authors_submission_id` (`submission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_sources`
--

CREATE TABLE IF NOT EXISTS `auth_sources` (
  `auth_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(60) NOT NULL,
  `plugin` varchar(32) NOT NULL,
  `auth_default` tinyint(4) NOT NULL DEFAULT '0',
  `settings` text,
  PRIMARY KEY (`auth_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `books_for_review`
--

CREATE TABLE IF NOT EXISTS `books_for_review` (
  `book_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `author_type` smallint(6) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `year` smallint(6) NOT NULL,
  `language` varchar(10) NOT NULL DEFAULT 'en',
  `copy` tinyint(4) NOT NULL DEFAULT '0',
  `url` varchar(255) DEFAULT NULL,
  `edition` tinyint(4) DEFAULT NULL,
  `pages` smallint(6) DEFAULT NULL,
  `isbn` varchar(30) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_requested` datetime DEFAULT NULL,
  `date_assigned` datetime DEFAULT NULL,
  `date_mailed` datetime DEFAULT NULL,
  `date_due` datetime DEFAULT NULL,
  `date_submitted` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `editor_id` bigint(20) DEFAULT NULL,
  `article_id` bigint(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`book_id`),
  KEY `bfr_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `books_for_review_authors`
--

CREATE TABLE IF NOT EXISTS `books_for_review_authors` (
  `author_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `book_id` bigint(20) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(90) NOT NULL,
  PRIMARY KEY (`author_id`),
  KEY `bfr_book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `books_for_review_settings`
--

CREATE TABLE IF NOT EXISTS `books_for_review_settings` (
  `book_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `bfr_settings_pkey` (`book_id`,`locale`,`setting_name`),
  KEY `bfr_settings_book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `captchas`
--

CREATE TABLE IF NOT EXISTS `captchas` (
  `captcha_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(40) NOT NULL,
  `value` varchar(20) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`captcha_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `citations`
--

CREATE TABLE IF NOT EXISTS `citations` (
  `citation_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `citation_state` bigint(20) NOT NULL,
  `raw_citation` text,
  `seq` bigint(20) NOT NULL DEFAULT '0',
  `lock_id` varchar(23) DEFAULT NULL,
  PRIMARY KEY (`citation_id`),
  UNIQUE KEY `citations_assoc_seq` (`assoc_type`,`assoc_id`,`seq`),
  KEY `citations_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `citation_settings`
--

CREATE TABLE IF NOT EXISTS `citation_settings` (
  `citation_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `citation_settings_pkey` (`citation_id`,`locale`,`setting_name`),
  KEY `citation_settings_citation_id` (`citation_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `parent_comment_id` bigint(20) DEFAULT NULL,
  `num_children` int(11) NOT NULL DEFAULT '0',
  `user_id` bigint(20) DEFAULT NULL,
  `poster_ip` varchar(15) NOT NULL,
  `poster_name` varchar(90) DEFAULT NULL,
  `poster_email` varchar(90) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `body` text,
  `date_posted` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comments_submission_id` (`submission_id`),
  KEY `comments_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `completed_payments`
--

CREATE TABLE IF NOT EXISTS `completed_payments` (
  `completed_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `payment_type` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `amount` double NOT NULL,
  `currency_code_alpha` varchar(3) DEFAULT NULL,
  `payment_method_plugin_name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`completed_payment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `controlled_vocabs`
--

CREATE TABLE IF NOT EXISTS `controlled_vocabs` (
  `controlled_vocab_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbolic` varchar(64) NOT NULL,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`controlled_vocab_id`),
  UNIQUE KEY `controlled_vocab_symbolic` (`symbolic`,`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `controlled_vocab_entries`
--

CREATE TABLE IF NOT EXISTS `controlled_vocab_entries` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `controlled_vocab_id` bigint(20) NOT NULL,
  `seq` double DEFAULT NULL,
  PRIMARY KEY (`controlled_vocab_entry_id`),
  KEY `controlled_vocab_entries_cv_id` (`controlled_vocab_id`,`seq`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `controlled_vocab_entry_settings`
--

CREATE TABLE IF NOT EXISTS `controlled_vocab_entry_settings` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `c_v_e_s_pkey` (`controlled_vocab_entry_id`,`locale`,`setting_name`),
  KEY `c_v_e_s_entry_id` (`controlled_vocab_entry_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `counter_monthly_log`
--

CREATE TABLE IF NOT EXISTS `counter_monthly_log` (
  `year` bigint(20) NOT NULL,
  `month` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `count_html` bigint(20) NOT NULL DEFAULT '0',
  `count_pdf` bigint(20) NOT NULL DEFAULT '0',
  `count_other` bigint(20) NOT NULL DEFAULT '0',
  UNIQUE KEY `counter_monthly_log_key` (`year`,`month`,`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `custom_issue_orders`
--

CREATE TABLE IF NOT EXISTS `custom_issue_orders` (
  `issue_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  UNIQUE KEY `custom_issue_orders_pkey` (`issue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `custom_section_orders`
--

CREATE TABLE IF NOT EXISTS `custom_section_orders` (
  `issue_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  UNIQUE KEY `custom_section_orders_pkey` (`issue_id`,`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE IF NOT EXISTS `email_templates` (
  `email_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_key` varchar(30) NOT NULL,
  `assoc_type` bigint(20) DEFAULT '0',
  `assoc_id` bigint(20) DEFAULT '0',
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email_templates_email_key` (`email_key`,`assoc_type`,`assoc_id`),
  KEY `email_templates_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=70 ;

--
-- Dumping data for table `email_templates`
--

INSERT INTO `email_templates` (`email_id`, `email_key`, `assoc_type`, `assoc_id`, `enabled`) VALUES
(6, 'COPYEDIT_ACK', 256, 4, 0),
(7, 'COPYEDIT_AUTHOR_ACK', 256, 4, 0),
(8, 'COPYEDIT_AUTHOR_COMPLETE', 256, 4, 0),
(9, 'COPYEDIT_AUTHOR_REQUEST', 256, 4, 0),
(10, 'COPYEDIT_COMPLETE', 256, 4, 0),
(11, 'COPYEDIT_FINAL_ACK', 256, 4, 0),
(12, 'COPYEDIT_FINAL_COMPLETE', 256, 4, 0),
(13, 'COPYEDIT_FINAL_REQUEST', 256, 4, 0),
(14, 'COPYEDIT_REQUEST', 256, 4, 0),
(15, 'EDITOR_ASSIGN', 256, 4, 0),
(16, 'SECTION_DECISION_APPROVED', 256, 4, 1),
(17, 'SECTION_DECISION_DECLINE', 256, 4, 1),
(18, 'SECTION_DECISION_RESUBMIT', 256, 4, 1),
(19, 'LAYOUT_ACK', 256, 4, 0),
(20, 'LAYOUT_COMPLETE', 256, 4, 0),
(21, 'SECTION_DECISION_REVISIONS', 256, 4, 1),
(22, 'LAYOUT_REQUEST', 256, 4, 0),
(23, 'PASSWORD_RESET', 256, 4, 1),
(24, 'PASSWORD_RESET_CONFIRM', 256, 4, 1),
(25, 'PROOFREAD_ACK', 256, 4, 0),
(26, 'PROOFREAD_AUTHOR_ACK', 256, 4, 0),
(27, 'PROOFREAD_AUTHOR_COMPLETE', 256, 4, 0),
(28, 'PROOFREAD_AUTHOR_REQUEST', 256, 4, 0),
(29, 'PROOFREAD_COMPLETE', 256, 4, 0),
(30, 'PROOFREAD_LAYOUT_ACK', 256, 4, 0),
(31, 'PROOFREAD_LAYOUT_COMPLETE', 256, 4, 0),
(32, 'PROOFREAD_LAYOUT_REQUEST', 256, 4, 0),
(33, 'PROOFREAD_REQUEST', 256, 4, 0),
(34, 'REVIEW_ACK', 256, 4, 1),
(35, 'REVIEW_CANCEL', 256, 4, 1),
(36, 'USER_VALIDATE', 256, 4, 1),
(37, 'REVIEW_COMPLETE', 256, 4, 1),
(38, 'REVIEW_CONFIRM', 256, 4, 1),
(39, 'REVIEW_DECLINE', 256, 4, 1),
(40, 'REVIEW_REMIND', 256, 4, 1),
(41, 'REVIEW_REMIND_AUTO', 256, 4, 1),
(42, 'REVIEW_REMIND_AUTO_ONECLICK', 256, 4, 1),
(43, 'REVIEW_REMIND_ONECLICK', 256, 4, 1),
(44, 'REVIEW_REQUEST', 256, 4, 1),
(45, 'REVIEW_REQUEST_ATTACHED', 256, 4, 1),
(46, 'REVIEW_REQUEST_ONECLICK', 256, 4, 1),
(47, 'SUBMISSION_ACK', 256, 4, 1),
(48, 'SUBMISSION_COMMENT', 256, 4, 1),
(49, 'SUBMISSION_DECISION_REVIEWERS', 256, 4, 1),
(50, 'SUBMISSION_UNSUITABLE', 256, 4, 1),
(51, 'USER_REGISTER', 256, 4, 1),
(52, 'SECTION_DECISION_EXEMPT', 256, 4, 1),
(53, 'SECTION_DECISION_INCOMPLETE', 256, 4, 1),
(54, 'COMMITTEE_REGISTER', 256, 4, 1),
(55, 'MEETING_NEW', 256, 4, 0),
(56, 'MEETING_NEW_INVESTIGATOR', 256, 4, 0),
(57, 'MEETING_NEW_EXTERNAL_REVIEWER', 256, 4, 1),
(58, 'MEETING_CHANGE', 256, 4, 1),
(59, 'MEETING_CHANGE_INVESTIGATOR', 256, 4, 1),
(60, 'MEETING_CHANGE_EXT_REVIEWER', 256, 4, 1),
(61, 'MEETING_FINAL', 256, 4, 1),
(62, 'MEETING_FINAL_INVESTIGATOR', 256, 4, 0),
(63, 'MEETING_FINAL_EXT_REVIEWER', 256, 4, 1),
(64, 'MEETING_CANCEL', 256, 4, 1),
(65, 'MEETING_CANCEL_INVESTIGATOR', 256, 4, 1),
(66, 'MEETING_CANCEL_EXT_REVIEWER', 256, 4, 1),
(67, 'MEETING_REMIND', 256, 4, 1),
(68, 'SECTION_DECISION_FR_APPROVED', 256, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `email_templates_data`
--

CREATE TABLE IF NOT EXISTS `email_templates_data` (
  `email_key` varchar(30) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT 'en_US',
  `assoc_type` bigint(20) DEFAULT '0',
  `assoc_id` bigint(20) DEFAULT '0',
  `subject` varchar(120) NOT NULL,
  `body` text,
  UNIQUE KEY `email_templates_data_pkey` (`email_key`,`locale`,`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `email_templates_data`
--

INSERT INTO `email_templates_data` (`email_key`, `locale`, `assoc_type`, `assoc_id`, `subject`, `body`) VALUES
('EDITOR_ASSIGN', 'en_US', 256, 4, 'Editorial Assignment', '{$editorialContactName}:\r\n\r\nThe submission, "{$articleTitle}," to {$journalName} has been assigned to you to see through the editorial process in your role as Section Editor.  \r\n\r\nSubmission URL: {$submissionUrl}\r\nUsername: {$editorUsername}\r\n\r\nThank you,\r\n{$editorialContactSignature}'),
('SECTION_DECISION_APPROVED', 'en_US', 256, 4, '{$sectionName} Decision {$articleId}', 'Dear {$authorName}:\r\n\r\nWe have the pleasure to inform you that the {$sectionName} has approved the "{$reviewType}" of your proposal entitled "{$articleTitle}" with the ID {$articleId}.\r\n\r\nHowever, you will still be required to submit a copy of the future progress reports and final report of the research through your {$journalTitle} Account. For these submissions, please use the appropriate links in your “Ongoing” proposals:\r\n\r\n{$urlOngoing}\r\n\r\nYou can access to all the information about the reviews your research (including, if applicable, the decision files) by logging into your account on the {$journalTitle} and following the URL address below:\r\n\r\n{$url}\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}'),
('SECTION_DECISION_DECLINE', 'en_US', 256, 4, '{$sectionName} Decision {$articleId}', 'Dear {$authorName}:\r\n\r\nWe regret to inform you that the {$reviewType} of your proposal entitled "{$articleTitle}" with the ID {$articleId} has NOT been approved by the {$sectionName}.\r\n\r\nYou can access to all the information about the reviews your research (including, if applicable, the decision files) by logging into your account on the {$journalTitle} and following the URL address below:\r\n\r\n{$url}\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}'),
('SECTION_DECISION_RESUBMIT', 'en_US', 256, 4, '{$sectionName} Decision {$articleId}', 'Dear {$authorName}:\r\n\r\nThe {$sectionName} made a decision concerning the "{$reviewType}" of your proposal entitled "{$articleTitle}" with the ID {$articleId}.\r\n\r\nPlease see the comments below:\r\n\r\nYou can access to all the information about the reviews of your research (including, if applicable, the decision files) by logging into your account on the {$journalTitle} and following the URL address below:\r\n\r\n{$url}\r\n\r\nWe look forward to receive your proposal with the requested modifications. You may modify it and send it again by using the “Resubmit” link in your list of “draft” proposals:\r\n\r\n{$urlDrafts}\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}'),
('PASSWORD_RESET', 'en_US', 256, 4, 'Password Reset', 'Dear {userFullName}:\r\n\r\nYour password has been successfully reset for use with the {$journalName}. Please retain this username and password, as it is necessary for all work with the system.\r\n\r\nYour username: {$username}\r\nYour new password: {$password}\r\n\r\n{$principalContactSignature}'),
('PASSWORD_RESET_CONFIRM', 'en_US', 256, 4, 'Password Reset Confirmation', 'Dear {$userFullName}:\r\n\r\nWe have received a request to reset your password for the {$journalName}.\r\n\r\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.\r\n\r\nReset my password: {$url}\r\n\r\n{$principalContactSignature}'),
('PROOFREAD_AUTHOR_ACK', 'en_US', 256, 4, 'Proofreading Acknowledgement (Author)', '{$authorName}:\r\n\r\nThank you for proofreading the galleys for your manuscript, "{$articleTitle}," in {$journalName}. We are looking forward to publishing your work shortly.\r\n\r\nIf you subscribe to our notification service, you will receive an email of the Table of Contents as soon as it is published. If you have any questions, please contact me.\r\n\r\n{$editorialContactSignature}'),
('REVIEW_ACK', 'en_US', 256, 4, 'Proposal Review Acknowledgement from the {$sectionName}', 'Dear {$reviewerName}:\r\n\r\nThank you for completing the review of the proposal, "{$articleTitle}" for the {$sectionName}. We appreciate your contribution to the committee.\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}'),
('REVIEW_CANCEL', 'en_US', 256, 4, 'Request for Proposal Review Cancelled', 'Dear {$reviewerName}:\r\n\r\nThe {$sectionName} have decided at this point to cancel its request for you to review the proposal, "{$articleTitle}".  We apologize for any inconvenience this may have caused to you.\r\n\r\nIf you have any questions, please contact me.\r\n\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}'),
('USER_VALIDATE', 'en_US', 256, 4, 'Validate Your Account', 'Dear {$userFullName}\r\n\r\nYou have created an account with the Health Research Portal, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:\r\n\r\n{$activateUrl}\r\n\r\nThank you,\r\n{$principalContactSignature}'),
('REVIEW_COMPLETE', 'en_US', 256, 4, 'Proposal Review Completed {$articleId}', 'Dear {$editorialContactName}:\r\n\r\nI have now completed the review of "{$articleTitle}".\r\n\r\n{$reviewerName}'),
('REVIEW_CONFIRM', 'en_US', 256, 4, 'Able to Review {$articleId}', 'Dear {$editorialContactName}:\r\n\r\nI am able and willing to review the proposal, "{$articleTitle}".\r\nI plan to have the review completed by the latest {$reviewDueDate}.\r\n\r\n{$reviewerName}'),
('REVIEW_DECLINE', 'en_US', 256, 4, 'Unable to Review {$articleId}', 'Dear {$editorialContactName}:\r\n\r\nI regret to inform you that I am unable to review the proposal "{$articleTitle}" at this time. \r\n\r\n{$reviewerName}'),
('REVIEW_REMIND', 'en_US', 256, 4, 'Proposal Review Reminder from {$sectionName}', 'Dear {$reviewerName}:\r\n\r\nThis message is a gentle reminder for the proposal review request for the proposal, "{$articleTitle}". We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\r\n\r\nYou can access the proposal (using your user name and password) by clicking on following url address:\r\n\r\n{$submissionReviewUrl}\r\n\r\nIf you do not have your username and password for the Health Research Portal, you can use this link to get a new password (which will then be emailed to you along with your username). {$passwordResetUrl}\r\n\r\nPlease confirm your ability to complete this vital contribution to the work of the committee. I look forward to hearing from you.\r\n\r\nBest,\r\n\r\n{$editorialContactSignature}'),
('REVIEW_REMIND_AUTO', 'en_US', 256, 4, 'Automated Proposal Review Reminder from {$sectionName}}', 'Dear {$reviewerName}:\r\n\r\nThis message is a gentle reminder for the proposal review request for the proposal, "{$articleTitle}". We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\r\n\r\nYou can access the proposal (using your user name and password) by clicking on following url address:\r\n\r\n{$submissionReviewUrl}\r\n\r\nIf you do not have your username and password for the Health Research Portal, you can use this link to get a new password (which will then be emailed to you along with your username). {$passwordResetUrl}\r\n\r\nPlease confirm your ability to complete this vital contribution to the work of the ERC. I look forward to hearing from you.\r\n\r\nBest,\r\n\r\n{$editorialContactSignature}'),
('REVIEW_REMIND_AUTO_ONECLICK', 'en_US', 256, 4, 'Automated Proposal Review Reminder', 'Dear {$reviewerName}:\r\n\r\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}". We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\r\n\r\nSubmission URL: {$submissionReviewUrl}\r\n\r\nPlease confirm your ability to complete this vital contribution to the work of the ERC. I look forward to hearing from you.\r\n\r\n{$editorialContactSignature}'),
('REVIEW_REMIND_ONECLICK', 'en_US', 256, 4, 'Proposal Review Reminder', 'Dear {$reviewerName}:\r\n\r\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}".  We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\r\n\r\nSubmission URL: {$submissionReviewUrl}\r\n\r\nPlease confirm your ability to complete this vital contribution to the work of the ERC. I look forward to hearing from you.\r\n\r\n{$editorialContactSignature}'),
('REVIEW_REQUEST', 'en_US', 256, 4, 'Proposal Review Request from {$sectionName}', 'Dear {$reviewerName}:\r\n\r\nPlease review the proposal, "{$articleTitle}", which has been submitted to the {$sectionName}. \r\n\r\nPleaseclick on the link below  (using your username and password sent to you earlier)  by (date: three days after the current date) to indicate whether you will undertake the review or not, as well as to access the proposal files and to record your review and recommendation.\r\n\r\n{$submissionReviewUrl}\r\n\r\nThe review itself is due: {$reviewDueDate}.\r\n\r\nIf you can not find your username and password sent earlier, you can use this link to get a new    password (which will then be emailed to you along with your username). \r\n{$passwordResetUrl}\r\n\r\nThank you very much. \r\n\r\n{$editorialContactSignature}\r\n\r\n\r\n"{$articleTitle}"\r\n\r\n\r\nBackground:\r\n{$articleBackground}\r\n\r\nObjectives:\r\n{$articleObjectives}\r\n\r\nStudy Methods:\r\n{$articleStudyMethods}\r\n\r\nExpected Outcomes and Use of Results:\r\n{$articleExpectedOutcomes}'),
('REVIEW_REQUEST_ATTACHED', 'en_US', 256, 4, 'Proposal Review Request', 'Dear {$reviewerName}:\r\n\r\nPlease review the proposal submission "{$articleTitle}".\r\nWe hope to review your review of the proposal, along with your recommendation, via e-mail, by {$reviewDueDate}.\r\n\r\nPlease indicate in a return email by {$weekLaterDate} whether you are able and willing to do the review.\r\n\r\nThank you very much.\r\n\r\n{$editorialContactSignature}'),
('REVIEW_REQUEST_ONECLICK', 'en_US', 256, 4, 'Proposal Review Request', 'Dear {$reviewerName}:\r\n\r\nPlease review the proposal "{$articleTitle}".\r\n\r\nPlease log into the Health Research Portal site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the submission and to record your review and recommendation.\r\n\r\nThe review itself is due {$reviewDueDate}.\r\n\r\nSubmission URL: {$submissionReviewUrl}\r\n\r\nThank you very much. \r\n\r\n{$editorialContactSignature}'),
('SUBMISSION_ACK', 'en_US', 256, 4, 'Proposal Submission Acknowledgement from {$sectionName}', 'Dear {$authorName}:\r\n\r\nThank you for submitting the proposal "{$articleTitle}" for review to the {$sectionName}.\r\n\r\nThe proposal has been assigned a unique ID number of {$articleId}.\r\n\r\nWith the online proposal review management system that we are using, you will be able to track its progress through the review process by logging in to the {$journalName} using your username and password.\r\n\r\nProposal URL: {$submissionUrl}\r\nUsername: {$authorUsername}\r\n\r\nFor any enquiries, please contact me by email and specify the ID number of your proposal.\r\n\r\nThank you very much. \r\n\r\n{$sectionName}'),
('SUBMISSION_COMMENT', 'en_US', 256, 4, 'Proposal Submission Comment', 'Dear {$name}:\r\n\r\n{$commentName} has added a comment to the proposal submission, "{$articleTitle}":\r\n\r\n{$comments}'),
('SUBMISSION_DECISION_REVIEWERS', 'en_US', 256, 4, 'Decision on Proposal "{$articleTitle}"', 'As one of the reviewers for the submission, "{$articleTitle}," I am sending you the reviews and decision sent to the Responsible Technical Officer for this proposal. \r\n\r\nThank you again for your important contribution to this process.\r\n \r\n{$editorialContactSignature}\r\n\r\n{$comments}'),
('SUBMISSION_UNSUITABLE', 'en_US', 256, 4, 'Unsuitable Proposal Submission', 'Dear {$authorName}:\r\n\r\nAn initial review of "{$articleTitle}" has made it clear that this submission does not fit within the scope and focus of the Ethics Committee. \r\n\r\n\r\n{$editorialContactSignature}'),
('USER_REGISTER', 'en_US', 256, 4, 'Registration on {$journalName}', 'Dear {$userFullName}\r\n\r\nYou have now been registered as a user with the {$journalName}. We have included your username and password in this email, which are needed for online submission of research proposal for review by any of the Research Ethics Committees in {$location}, as well to track the progress of review process and to submit any progress reports to the Committees. At any point, you can ask to be removed from the portal''s list of users by contacting me.\r\n\r\nUsername: {$username}\r\nPassword: {$password}\r\n\r\nThank you,\r\n\r\n{$principalContactSignature}'),
('SECTION_DECISION_EXEMPT', 'en_US', 256, 4, '{$sectionName} Decision {$articleId}', 'Dear {$authorName}:\r\n\r\nWe are pleased to inform you that the "{$reviewType}" of your proposal entitled "{$articleTitle}" with the ID {$articleId} has been exempted from review by the {$sectionName}.\r\n\r\nHowever, you will still be required to submit a copy of the future progress reports and final report of the research through your {$journalTitle} Account. For these submissions, please use the appropriate links in your “Ongoing” proposals:\r\n\r\n{$urlOngoing}\r\n\r\nYou can access to all the information about the reviews of your research (including, if applicable, the decision files) by logging into your account on {$journalTitle} and following the URL address below:\r\n\r\n{$url}\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}'),
('SECTION_DECISION_INCOMPLETE', 'en_US', 256, 4, '{$sectionName} - {$articleId} considered as incomplete', 'Dear {$authorName}\r\n \r\nThe "{$reviewType}" of your proposal, entitled "{$articleTitle}", has been considered as incomplete on initial screening by the {$sectionName}.\r\n \r\nPlease see the comments below:\r\n\r\n\r\nYou can access to all the information about the reviews of your research (including, if applicable, the decision files) by logging into your account on the {$journalTitle} and following the URL address below:\r\n\r\n{$url}\r\n\r\nWe look forward to receive your proposal with the requested modifications. You may modify it and send it again by using the “Resubmit” link in your list of “draft” proposals:\r\n\r\n{$urlDrafts}\r\n \r\nBest regards\r\n \r\n{$editorialContactSignature}'),
('COMMITTEE_REGISTER', 'en_US', 256, 4, 'Registration with {$ercTitle}', 'Dear {$userFullName},\r\n\r\nYou are now registered as the {$ercStatus} of the {$ercTitle}.  We have included your username and password in this email, which are needed for any actions you would like to perform on this portal.\r\n\r\nUsername: {$username}\r\nPassword: {$password}\r\n\r\nIf you would like to modify your profile information like your password, your reviewing interests or even your email, please click on the following link, edit your profile and save it:\r\n\r\nEdit your profile: {$editProfile}\r\n\r\nThe health research portal is always accessible at this address:\r\nhttp://www.health.gov.fj/fijihrp\r\n\r\nWe thank you for your cooperation.\r\n\r\nCordially,\r\n\r\n{$secretaryFullName}\r\n{$secretaryFunctions}'),
('MEETING_NEW', 'en_US', 256, 4, '{$ercTitle} - Suggestion of Meeting', 'Dear {$ercAbbrev} reviewers,\r\n\r\n{$ercTitle} would like to organize a meeting in order to review the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nPlease find below the suggested date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nPlease answer through the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and, by using your username and password, you will be able to confirm your attendance as to access the meeting and proposal(s) information.\r\n\r\n{$replyUrl}\r\n\r\nBased on the responses received from all of you, the final date and location or a new suggestion of meeting will be communicated.\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_NEW_INVESTIGATOR', 'en_US', 256, 4, '{$ercTitle} - Suggestion of Meeting', 'Dear {$investigatorFullName},\r\n\r\n{$ercTitle} is organizing a meeting in order to review your proposal(s):\r\n\r\n{$submissions}\r\n\r\nPlease find below the informations concerning the meeting:\r\n\r\n{$dateLocation}\r\n\r\nPlease let us know via the {$journalName} if you would be able to attend or not to the meeting (comments or suggestions can be added). Click on the following link and, by using your username and password, you will be able to confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nThe final date and location or a new suggestion of meeting will be communicated later based on responses received from different stakeholders about their availability.\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_NEW_EXTERNAL_REVIEWER', 'en_US', 256, 4, '{$ercTitle} - Suggestion of Meeting', 'Dear {$extReviewerFullName},\r\n\r\n{$ercTitle} was honored to received you expertise concerning the review of the proposal(s):\r\n\r\n{$submissions}\r\n\r\n{$ercTitle} is now organizing a meeting in order to complete the review(s). Please find below the informations concerning the meeting:\r\n\r\n{$dateLocation}\r\n\r\nPlease answer through the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and log in using your username and password, to confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nThe final date and location or a new suggestion of meeting will be communicated later based on responses of from different stakeholders regarding their availability.\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_CHANGE', 'en_US', 256, 4, '{$ercTitle} - New suggestion of meeting', 'Dear {$ercAbbrev} reviewers,\r\n\r\nAfter consideration of all the responses received, {$ercTitle} would like to suggest you a new date and/or location for the meeting concerning the review of the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nNew suggested date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nPlease respond through the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and, using your username and password, confirm your attendance as well as to access the meeting and proposal(s) information.\r\n\r\n{$replyUrl}\r\n\r\nThe final date and location or a new suggestion of meeting will be communicated later based on the responses received from all the members.\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_CHANGE_INVESTIGATOR', 'en_US', 256, 4, '{$ercTitle} - New suggestion of meeting', 'Dear {$investigatorFullName},\r\n\r\nAfter consideration of all the responses received, {$ercTitle} would like to suggest you a new date and/or location for the meeting concerning the review of your proposal(s):\r\n\r\n{$submissions}\r\n\r\nNew suggested date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nPlease respond the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and, using your username and password, confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nThe final date and location or a new suggestion of meeting will be communicated later based on the responses received from each stakeholders.\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_CHANGE_EXT_REVIEWER', 'en_US', 256, 4, '{$ercTitle} - New suggestion of meeting', 'Dear {$extReviewerFullName},\r\n\r\nAfter consideration of all the responses received,  {$ercTitle} would like to suggest you a new date and/or location for the meeting concerning the review of the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nNew suggested date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nPlease respond via the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and, using your username and password, confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nThe final date and location or a new suggestion of meeting will be communicated later based on the responses received from all stakeholders.\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_FINAL', 'en_US', 256, 4, '{$ercTitle} - Final schedule of meeting', 'Dear {$ercAbbrev} reviewers,\r\n\r\n{$ercTitle} would like to communicate you the final schedule of the meeting concerning the review of the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nFinal date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nIf not already, please answer through the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and, using your username and password, confirm your attendance as to access the meeting and proposal(s) information.\r\n\r\n{$replyUrl}\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_FINAL_INVESTIGATOR', 'en_US', 256, 4, '{$ercTitle} - Final schedule of meeting', 'Dear {$investigatorFullName},\r\n\r\n{$ercTitle} would like to communicate you the final schedule of the meeting concerning the review of your proposal(s):\r\n\r\n{$submissions}\r\n\r\nFinal date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nIf not already, please respond via the {$journalName} if you will be able to attend the meeting (comments or suggestions can be added). Click on the following link and, using your username and password, confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_FINAL_EXT_REVIEWER', 'en_US', 256, 4, '{$ercTitle} - Final schedule of meeting', 'Dear {$extReviewerFullName},\r\n\r\n{$ercTitle} was honored to received you expertise and would like to communicate you the final schedule of the meeting concerning the review of the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nFinal date and/or location for the meeting:\r\n\r\n{$dateLocation}\r\n\r\nIf not already, please respond the {$journalName} if you will be able to attend the meeting (comments or suggestions can be added). Click on the following link and, using your username and password, confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_CANCEL', 'en_US', 256, 4, '{$ercTitle} - Cancellation of meeting', 'Dear {$ercAbbrev} reviewers,\r\n\r\n{$ercTitle} is in the regret to inform you of the cancellation of the meeting concerning the review of the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nScheduled:\r\n\r\n{$dateLocation}\r\n\r\nWe apologies for any inconvenience this decision may cause.\r\n\r\nSincerely,\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_CANCEL_INVESTIGATOR', 'en_US', 256, 4, '{$ercTitle} - Cancellation of meeting', 'Dear {$investigatorFullName},\r\n\r\n{$ercTitle} is in the regret to inform you of the cancellation of the meeting concerning the review of your proposal(s):\r\n\r\n{$submissions}\r\n\r\nScheduled:\r\n\r\n{$dateLocation}\r\n\r\nWe apologies for any inconvenience this decision may cause.\r\n\r\nSincerely,\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_CANCEL_EXT_REVIEWER', 'en_US', 256, 4, '{$ercTitle} - Cancellation of meeting', 'Dear {$extReviewerFullName},\r\n\r\n{$ercTitle} was honored to received you expertise. However we have the regret to inform you of the cancellation of the meeting concerning the review of the following proposal(s):\r\n\r\n{$submissions}\r\n\r\nScheduled:\r\n\r\n{$dateLocation}\r\n\r\nWe apologies for any inconvenience this decision may cause.\r\n\r\nSincerely,\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('MEETING_REMIND', 'en_US', 256, 4, '{$ercTitle} - Reminder of meeting', 'Dear {$addresseeFullName},\r\n\r\nThis email is a gentle reminder about the meeting scheduled:\r\n\r\n{$dateLocation}\r\n\r\nAnd concerning the proposal(s):\r\n\r\n{$submissions}\r\n\r\nIf not already, please answer through the {$journalName} if you would be able to attend the meeting (comments or suggestions can be added). Click on the following link and, by using your username and password, you will be able to confirm your attendance.\r\n\r\n{$replyUrl}\r\n\r\nWe thank you for your cooperation.\r\n\r\n{$secretaryName}\r\n{$secretaryFunctions}'),
('SECTION_DECISION_FR_APPROVED', 'en_US', 256, 4, '{$sectionName} - The final report of your proposal "{$articleId}" has been approved', 'Dear {$authorName}:\r\n\r\nWe have the pleasure to inform you that the {$sectionName} has approved the final technical report of your proposal entitled "{$articleTitle}" with the ID {$articleId}.\r\n\r\nYou can access to all the information about the reviews your research (including, if applicable, the decision files) by logging into your account on the {$journalTitle} and following the URL address below:\r\n\r\n{$url}\r\n\r\nYour final technical report has now been made publicly available on the “Research Registry” of the {$journalTitle}.\r\n\r\nBest regards,\r\n\r\n{$editorialContactSignature}');

-- --------------------------------------------------------

--
-- Table structure for table `email_templates_default`
--

CREATE TABLE IF NOT EXISTS `email_templates_default` (
  `email_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_key` varchar(30) NOT NULL,
  `can_disable` tinyint(4) NOT NULL DEFAULT '1',
  `can_edit` tinyint(4) NOT NULL DEFAULT '1',
  `from_role_id` bigint(20) DEFAULT NULL,
  `to_role_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`email_id`),
  KEY `email_templates_default_email_key` (`email_key`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=294 ;

--
-- Dumping data for table `email_templates_default`
--

INSERT INTO `email_templates_default` (`email_id`, `email_key`, `can_disable`, `can_edit`, `from_role_id`, `to_role_id`) VALUES
(218, 'NOTIFICATION', 0, 1, NULL, NULL),
(219, 'NOTIFICATION_MAILLIST', 0, 1, NULL, NULL),
(220, 'NOTIFICATION_MAILLIST_WELCOME', 0, 1, NULL, NULL),
(221, 'NOTIFICATION_MAILLIST_PASSWORD', 0, 1, NULL, NULL),
(222, 'PASSWORD_RESET_CONFIRM', 0, 1, NULL, NULL),
(223, 'PASSWORD_RESET', 0, 1, NULL, NULL),
(224, 'USER_REGISTER', 0, 1, NULL, NULL),
(225, 'USER_VALIDATE', 0, 1, NULL, NULL),
(226, 'REVIEWER_REGISTER', 0, 1, NULL, NULL),
(227, 'PUBLISH_NOTIFY', 0, 1, NULL, NULL),
(228, 'LOCKSS_EXISTING_ARCHIVE', 0, 1, NULL, NULL),
(229, 'LOCKSS_NEW_ARCHIVE', 0, 1, NULL, NULL),
(230, 'SUBMISSION_ACK', 1, 1, NULL, 65536),
(231, 'SUBMISSION_UNSUITABLE', 1, 1, 512, 65536),
(232, 'SUBMISSION_COMMENT', 0, 1, NULL, NULL),
(233, 'SUBMISSION_DECISION_REVIEWERS', 0, 1, 512, 4096),
(234, 'EDITOR_ASSIGN', 1, 1, 256, 512),
(235, 'REVIEW_CANCEL', 1, 1, 512, 4096),
(236, 'REVIEW_REQUEST', 1, 1, 512, 4096),
(237, 'REVIEW_REQUEST_ONECLICK', 1, 1, 512, 4096),
(238, 'REVIEW_REQUEST_ATTACHED', 0, 1, 512, 4096),
(239, 'REVIEW_CONFIRM', 1, 1, 4096, 512),
(240, 'REVIEW_DECLINE', 1, 1, 4096, 512),
(241, 'REVIEW_COMPLETE', 1, 1, 4096, 512),
(242, 'REVIEW_ACK', 1, 1, 512, 4096),
(243, 'REVIEW_REMIND', 0, 1, 512, 4096),
(244, 'REVIEW_REMIND_AUTO', 0, 1, NULL, 4096),
(245, 'REVIEW_REMIND_ONECLICK', 0, 1, 512, 4096),
(246, 'REVIEW_REMIND_AUTO_ONECLICK', 0, 1, NULL, 4096),
(247, 'EDITOR_DECISION_APPROVED', 0, 1, 512, 65536),
(248, 'EDITOR_DECISION_REVISIONS', 0, 1, 512, 65536),
(249, 'EDITOR_DECISION_RESUBMIT', 0, 1, 512, 65536),
(250, 'EDITOR_DECISION_DECLINE', 0, 1, 512, 65536),
(251, 'COPYEDIT_REQUEST', 1, 1, 512, 8192),
(252, 'COPYEDIT_COMPLETE', 1, 1, 8192, 65536),
(253, 'COPYEDIT_ACK', 1, 1, 512, 8192),
(254, 'COPYEDIT_AUTHOR_REQUEST', 1, 1, 512, 65536),
(255, 'COPYEDIT_AUTHOR_COMPLETE', 1, 1, 65536, 512),
(256, 'COPYEDIT_AUTHOR_ACK', 1, 1, 512, 65536),
(257, 'COPYEDIT_FINAL_REQUEST', 1, 1, 512, 8192),
(258, 'COPYEDIT_FINAL_COMPLETE', 1, 1, 8192, 512),
(259, 'COPYEDIT_FINAL_ACK', 1, 1, 512, 8192),
(260, 'LAYOUT_REQUEST', 1, 1, 512, 768),
(261, 'LAYOUT_COMPLETE', 1, 1, 768, 512),
(262, 'LAYOUT_ACK', 1, 1, 512, 768),
(263, 'PROOFREAD_AUTHOR_REQUEST', 1, 1, 512, 65536),
(264, 'PROOFREAD_AUTHOR_COMPLETE', 1, 1, 65536, 512),
(265, 'PROOFREAD_AUTHOR_ACK', 1, 1, 512, 65536),
(266, 'PROOFREAD_REQUEST', 1, 1, 512, 12288),
(267, 'PROOFREAD_COMPLETE', 1, 1, 12288, 512),
(268, 'PROOFREAD_ACK', 1, 1, 512, 12288),
(269, 'PROOFREAD_LAYOUT_REQUEST', 1, 1, 512, 768),
(270, 'PROOFREAD_LAYOUT_COMPLETE', 1, 1, 768, 512),
(271, 'PROOFREAD_LAYOUT_ACK', 1, 1, 512, 768),
(272, 'EMAIL_LINK', 0, 1, 1048576, NULL),
(273, 'SUBSCRIPTION_NOTIFY', 0, 1, NULL, 1048576),
(274, 'OPEN_ACCESS_NOTIFY', 0, 1, NULL, 1048576),
(275, 'SUBSCRIPTION_BEFORE_EXPIRY', 0, 1, NULL, 1048576),
(276, 'SUBSCRIPTION_AFTER_EXPIRY', 0, 1, NULL, 1048576),
(277, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 0, 1, NULL, 1048576),
(278, 'SUBSCRIPTION_PURCHASE_INDL', 0, 1, NULL, 2097152),
(279, 'SUBSCRIPTION_PURCHASE_INSTL', 0, 1, NULL, 2097152),
(280, 'SUBSCRIPTION_RENEW_INDL', 0, 1, NULL, 2097152),
(281, 'SUBSCRIPTION_RENEW_INSTL', 0, 1, NULL, 2097152),
(282, 'CITATION_EDITOR_AUTHOR_QUERY', 0, 1, NULL, NULL),
(283, 'BFR_REVIEW_REMINDER', 0, 1, 256, 65536),
(284, 'BFR_REVIEW_REMINDER_LATE', 0, 1, 256, 65536),
(285, 'BFR_BOOK_ASSIGNED', 0, 1, 256, 65536),
(286, 'BFR_BOOK_DENIED', 0, 1, 256, 65536),
(287, 'BFR_BOOK_REQUESTED', 0, 1, 65536, 256),
(288, 'BFR_BOOK_MAILED', 0, 1, 256, 65536),
(289, 'BFR_REVIEWER_REMOVED', 0, 1, 256, 65536),
(290, 'SWORD_DEPOSIT_NOTIFICATION', 0, 1, NULL, NULL),
(291, 'THESIS_ABSTRACT_CONFIRM', 0, 1, NULL, NULL),
(292, 'MANUAL_PAYMENT_NOTIFICATION', 0, 1, NULL, NULL),
(293, 'PAYPAL_INVESTIGATE_PAYMENT', 0, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `email_templates_default_data`
--

CREATE TABLE IF NOT EXISTS `email_templates_default_data` (
  `email_key` varchar(30) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT 'en_US',
  `subject` varchar(120) NOT NULL,
  `body` text,
  `description` text,
  UNIQUE KEY `email_templates_default_data_pkey` (`email_key`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `email_templates_default_data`
--

INSERT INTO `email_templates_default_data` (`email_key`, `locale`, `subject`, `body`, `description`) VALUES
('NOTIFICATION', 'en_US', 'New notification from ERC', 'You have a new notification from ERC:\n\n{$notificationContents}\n\nLink: {$url}\n\n{$principalContactSignature}', 'The email is sent to registered users that have selected to have this type of notification emailed to them.'),
('NOTIFICATION_MAILLIST', 'en_US', 'New notification from ERC:', 'You have a new notification from ERC:\n--\n{$notificationContents}\n\nLink: {$url}\n--\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\n{$principalContactSignature}', 'This email is sent to unregistered users on the notification mailing list.'),
('NOTIFICATION_MAILLIST_WELCOME', 'en_US', 'Welcome to the the ERC Members'' mailing list!', 'You have signed up to receive notifications from the ERC.\n			\nPlease click on this link to confirm your request and add your email address to the mailing list: {$confirmLink}\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\nYour password for disabling notification emails is: {$password}\n\n{$principalContactSignature}', 'This email is sent to an unregistered user who just registered with the notification mailing list.'),
('NOTIFICATION_MAILLIST_PASSWORD', 'en_US', 'Your notification mailing list information for ERC:', 'Your new password for disabling notification emails is: {$password}\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\n{$principalContactSignature}', 'This email is sent to an unregistered user on the notification mailing list when they indicate that they have forgotten their password or are unable to login. It provides a URL they can follow to reset their password.'),
('PASSWORD_RESET_CONFIRM', 'en_US', 'Password Reset Confirmation', 'We have received a request to reset your password for the ERC web site.\n\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.\n\nReset my password: {$url}\n\n{$principalContactSignature}', 'This email is sent to a registered user when they indicate that they have forgotten their password or are unable to login. It provides a URL they can follow to reset their password.'),
('PASSWORD_RESET', 'en_US', 'Password Reset', 'Your password has been successfully reset for use with the ERC web site. Please retain this username and password, as it is necessary for all work with the website.\n\nYour username: {$username}\nYour new password: {$password}\n\n{$principalContactSignature}', 'This email is sent to a registered user when they have successfully reset their password following the process described in the PASSWORD_RESET_CONFIRM email.'),
('USER_REGISTER', 'en_US', 'Site Registration', '{$userFullName}\n\nYou have now been registered as a user with the PHREB system. We have included your username and password in this email, which are needed for all work with our website. At any point, you can ask to be removed from the site''s list of users by contacting me.\n\nUsername: {$username}\nPassword: {$password}\n\nThank you,\n{$principalContactSignature}', 'This email is sent to a newly registered user to welcome them to the system and provide them with a record of their username and password.'),
('USER_VALIDATE', 'en_US', 'Validate Your Account', '{$userFullName}\n\nYou have created an account with {$journalName}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:\n\n{$activateUrl}\n\nThank you,\n{$principalContactSignature}', 'This email is sent to a newly registered user to welcome them to the system and provide them with a record of their username and password.'),
('REVIEWER_REGISTER', 'en_US', 'Registration as ERC Member', 'We are providing you with a username and password, which is used in all interactions with the website. \n\nUsername: {$username}\nPassword: {$password}\n\nThank you,\n{$principalContactSignature}', 'This email is sent to a newly registered reviewer to welcome them to the system and provide them with a record of their username and password.'),
('PUBLISH_NOTIFY', 'en_US', 'New Issue Published', 'Readers:\n\n{$journalName} has just published its latest issue at {$journalUrl}. We invite you to review the Table of Contents here and then visit our web site to review articles and items of interest.\n\nThanks for the continuing interest in our work,\n{$editorialContactSignature}', 'This email is sent to registered readers via the "Notify Users" link in the Editor''s User Home. It notifies readers of a new issue and invites them to visit the journal at a supplied URL.'),
('LOCKSS_EXISTING_ARCHIVE', 'en_US', 'Archiving Request for {$journalName}', 'Dear [University Librarian]\n\n{$journalName} <{$journalUrl}>, is a journal for which a member of your faculty, [name of member], serves as a [title of position]. The journal is seeking to establish a LOCKSS (Lots of Copies Keep Stuff Safe) compliant archive with this and other university libraries.\n\n[Brief description of journal]\n\nThe URL to the LOCKSS Publisher Manifest for our journal is: {$journalUrl}/gateway/lockss\n\nWe understand that you are already participating in LOCKSS. If we can provide any additional metadata for purposes of registering our journal with your version of LOCKSS, we would be happy to provide it.\n\nThank you,\n{$principalContactSignature}', 'This email requests the keeper of a LOCKSS archive to consider including this journal in their archive. It provides the URL to the journal''s LOCKSS Publisher Manifest.'),
('LOCKSS_NEW_ARCHIVE', 'en_US', 'Archiving Request for {$journalName}', 'Dear [University Librarian]\n\n{$journalName} <{$journalUrl}>, is a journal for which a member of your faculty, [name of member] serves as a [title of position]. The journal is seeking to establish a LOCKSS (Lots of Copies Keep Stuff Safe) compliant archive with this and other university libraries.\n\n[Brief description of journal]\n\nThe LOCKSS Program <http://lockss.org/>, an international library/publisher initiative, is a working example of a distributed preservation and archiving repository, additional details are below. The software, which runs on an ordinary personal computer is free; the system is easily brought on-line; very little ongoing maintenance is required.\n\nTo assist in the archiving of our journal, we invite you to become a member of the LOCKSS community, to help collect and preserve titles produced by your faculty and by other scholars worldwide. To do so, please have someone on your staff visit the LOCKSS site for information on how this system operates. I look forward to hearing from you on the feasibility of providing this archiving support for this journal.\n\nThank you,\n{$principalContactSignature}', 'This email encourages the recipient to participate in the LOCKSS initiative and include this journal in the archive. It provides information about the LOCKSS initiative and ways to become involved.'),
('SUBMISSION_ACK', 'en_US', 'Submission Acknowledgement', '{$authorName}:\n\nThank you for submitting the proposal, "{$articleTitle}" to the Ethics Review Committee. With the online proposal management system that we are using, you will be able to track its progress through the review process by logging in to the ERC web site:\n\nProposal URL: {$submissionUrl}\nUsername: {$authorUsername}\n\nIf you have any questions, please contact me. \n\n{$editorialContactSignature}', 'This email, when enabled, is automatically sent to the RTO when he or she completes the process of submitting a proposal to the ERC. It provides information about tracking the submission through the process and thanks the RTO for the submission.'),
('SUBMISSION_UNSUITABLE', 'en_US', 'Unsuitable Submission', '{$authorName}:\n\nAn initial review of "{$articleTitle}" has made it clear that this submission does not fit within the scope and focus of our Ethics Review Committee. I recommend that you consult the Standard Operating Procedure of the ERC. \n\n{$editorialContactSignature}', ''),
('SUBMISSION_COMMENT', 'en_US', 'Submission Comment', '{$name}:\n\n{$commentName} has added a comment to the proposal submission, "{$articleTitle}" in {$journalName}:\n\n{$comments}', 'This email notifies the various people involved in a proposal''s review process that a new comment has been posted.'),
('SUBMISSION_DECISION_REVIEWERS', 'en_US', 'Decision on "{$articleTitle}"', 'As one of the reviewers for the submission, "{$articleTitle}", I am sending you the reviews and decision sent to the RTO of this proposal. Thank you again for your important contribution to this process.\n \n{$editorialContactSignature}\n\n{$comments}', 'This email notifies the reviewers of a proposal that the review process has been completed.'),
('EDITOR_ASSIGN', 'en_US', 'Review Assignment', '{$editorialContactName}:\n\nThe submission, "{$articleTitle}" has been assigned to you to see through the review process in your role as Principal Reviewer.  \n\nSubmission URL: {$submissionUrl}\nUsername: {$editorUsername}\n\nThank you,\n{$editorialContactSignature}', 'This email notifies an ERC Member that the Secretariat has assigned them the task of principal reviewer.'),
('REVIEW_REQUEST', 'en_US', 'Proposal Review Request', '{$reviewerName}:\n\nPlease review the proposal, "{$articleTitle}," which has been submitted to the Ethics Review Committee. \n\nPlease log into the web site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the proposal and to record your initial review and recommendation. The web site is {$journalUrl}\n\nThe initial review itself is due {$reviewDueDate}.\n\nWe shall also inform you of the ERC Meeting Date when this proposal will be reviewed, if applicable.\n\nIf you do not have your username and password for the web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\n\n"{$articleTitle}"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}', 'This email from the Secretariat to an ERC Member requests that the ERC Member accept or decline the task of reviewing a proposal. It provides information about the submission such as the title and abstract, a review due date, and how to access the submission itself. '),
('REVIEW_REQUEST_ONECLICK', 'en_US', 'Proposal Review Request', '{$reviewerName}:\n\nPlease review the proposal, "{$articleTitle}," which has been submitted to the Ethics Review Committee. \n\nPlease log into the web site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the submission and to record your review and recommendation.\n\nThe review itself is due {$reviewDueDate}.\n\nSubmission URL: {$submissionReviewUrl}\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\n\n"{$articleTitle}"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}', 'This email from the Secretariat to an ERC Member requests that the reviewer accept or decline the task of reviewing a submission. It provides information about the submission such as the title and abstract, a review due date, and how to access the submission itself. '),
('EDITOR_DECISION_ACCEPT', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('REVIEW_REQUEST_ATTACHED', 'en_US', 'Proposal Review Request', '{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, "{$articleTitle}," and I am asking that you consider undertaking this important task for us. The Review Guidelines for this journal are appended below, and the submission is attached to this email. Your review of the submission, along with your recommendation, should be emailed to me by {$reviewDueDate}.\n\nPlease indicate in a return email by {$weekLaterDate} whether you are able and willing to do the review.\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\nReview Guidelines\n\n{$reviewGuidelines}\n', 'This email is sent by the Section Editor to a Reviewer to request that they accept or decline the task of reviewing a submission. It includes the submission as an attachment. This message is used when the Email-Attachment Review Process is selected in Journal Setup, Step 2. (Otherwise see REVIEW_REQUEST.)'),
('REVIEW_CANCEL', 'en_US', 'Request for Review Cancelled', '{$reviewerName}:\n\nWe have decided at this point to cancel our request for you to review the submission, "{$articleTitle}," for {$journalName}. We apologize for any inconvenience this may cause you and hope that we will be able to call on you to assist with this journal''s review process in the future.\n\nIf you have any questions, please contact me.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a Reviewer who has a submission review in progress to notify them that the review has been cancelled.'),
('REVIEW_CONFIRM', 'en_US', 'Able to Review', '{$editorialContactName}:\n\nI am able and willing to review the submission, "{$articleTitle}," for {$journalName}. Thank you for thinking of me, and I plan to have the review completed by its due date, {$reviewDueDate}, if not before.\n\n{$reviewerName}', 'This email is sent by a Reviewer to the Section Editor in response to a review request to notify the Section Editor that the review request has been accepted and will be completed by the specified date.'),
('REVIEW_DECLINE', 'en_US', 'Unable to Review', '{$editorialContactName}:\n\nI am afraid that at this time I am unable to review the submission, "{$articleTitle}," for {$journalName}. Thank you for thinking of me, and another time feel free to call on me.\n\n{$reviewerName}', 'This email is sent by a Reviewer to the Section Editor in response to a review request to notify the Section Editor that the review request has been declined.'),
('REVIEW_COMPLETE', 'en_US', 'Article Review Completed', '{$editorialContactName}:\n\nI have now completed my review of "{$articleTitle}" for {$journalName}, and submitted my recommendation, "{$recommendation}."\n\n{$reviewerName}', 'This email is sent by a Reviewer to the Section Editor to notify them that a review has been completed and the comments and recommendations have been recorded on the journal web site.'),
('REVIEW_ACK', 'en_US', 'Article Review Acknowledgement', '{$reviewerName}:\n\nThank you for completing the review of the submission, "{$articleTitle}," for {$journalName}. We appreciate your contribution to the quality of the work that we publish.\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to confirm receipt of a completed review and thank the reviewer for their contributions.'),
('REVIEW_REMIND', 'en_US', 'Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\n\nIf you do not have your username and password for the journal''s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to remind a reviewer that their review is due.'),
('REVIEW_REMIND_ONECLICK', 'en_US', 'Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to remind a reviewer that their review is due.'),
('REVIEW_REMIND_AUTO', 'en_US', 'Automated Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\n\nIf you do not have your username and password for the journal''s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is automatically sent when a reviewer''s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is disabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),
('REVIEW_REMIND_AUTO_ONECLICK', 'en_US', 'Automated Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is automatically sent when a reviewer''s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is enabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),
('EDITOR_DECISION_APPROVED', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('EDITOR_DECISION_REVISIONS', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('EDITOR_DECISION_RESUBMIT', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('EDITOR_DECISION_DECLINE', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('COPYEDIT_REQUEST', 'en_US', 'Copyediting Request', '{$copyeditorName}:\n\nI would ask that you undertake the copyediting of "{$articleTitle}" for {$journalName} by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 1.\n3. Consult Copyediting Instructions posted on webpage.\n4. Open the downloaded file and copyedit, while adding Author Queries as needed. \n5. Save copyedited file, and upload to Step 1 of Copyediting.\n6. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$copyeditorUsername}\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to a submission''s Copyeditor to request that they begin the copyediting process. It provides information about the submission and how to access it.'),
('COPYEDIT_COMPLETE', 'en_US', 'Copyediting Completed', '{$editorialContactName}:\n\nWe have now copyedited your submission "{$articleTitle}" for {$journalName}. To review the proposed changes and respond to Author Queries, please follow these steps:\n\n1. Log into the journal using URL below with your username and password (use Forgot link if needed).\n2. Click on the file at 1. Initial Copyedit File to download and open copyedited version. \n3. Review the copyediting, making changes using Track Changes in Word, and answer queries. \n4. Save file to desktop and upload it in 2. Author Copyedit.\n5. Click the email icon under COMPLETE and send email to the editor.\n\nThis is the last opportunity that you have to make substantial changes. You will be asked at a later stage to proofread the galleys, but at that point only minor typographical and layout errors can be corrected.\n\nManuscript URL: {$submissionEditingUrl}\nUsername: {$authorUsername}\n\nIf you are unable to undertake this work at this time or have any questions,\nplease contact me. Thank you for your contribution to this journal.\n\n{$copyeditorName}', ''),
('COPYEDIT_ACK', 'en_US', 'Copyediting Acknowledgement', '{$copyeditorName}:\n\nThank you for copyediting the manuscript, "{$articleTitle}," for {$journalName}. It will make an important contribution to the quality of this journal.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a submission''s Copyeditor to acknowledge that the Copyeditor has successfully completed the copyediting process and thank them for their contribution.'),
('COPYEDIT_AUTHOR_REQUEST', 'en_US', 'Copyediting Review Request', '{$authorName}:\n\nYour submission "{$articleTitle}" for {$journalName} has been through the first step of copyediting, and is available for you to review by following these steps.\n\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 1.\n3. Open the downloaded submission.\n4. Review the text, including copyediting proposals and Author Queries.\n5. Make any copyediting changes that would further improve the text.\n6. When completed, upload the file in Step 2.\n7. Click on METADATA to check indexing information for completeness and accuracy.\n8. Send the COMPLETE email to the editor and copyeditor.\n\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$authorUsername}\n\nThis is the last opportunity to make substantial copyediting changes to the submission. The proofreading stage, that follows the preparation of the galleys, is restricted to correcting typographical and layout errors.\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a submission''s Author to request that they proofread the work of the copyeditor. It provides access information for the manuscript and warns that this is the last opportunity the author has to make substantial changes.'),
('COPYEDIT_AUTHOR_COMPLETE', 'en_US', 'Copyediting Review Completed', '{$editorialContactName}:\n\nI have now reviewed the copyediting of the manuscript, "{$articleTitle}," for {$journalName}, and it is ready for the final round of copyediting and preparation for Layout.\n\nThank you for this contribution to my work,\n{$authorName}', 'This email is sent by the Author to the Section Editor to notify them that the Author''s copyediting process has been completed.'),
('COPYEDIT_AUTHOR_ACK', 'en_US', 'Copyediting Review Acknowledgement', '{$authorName}:\n\nThank you for reviewing the copyediting of your manuscript, "{$articleTitle}," for {$journalName}. We look forward to publishing this work.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a submission''s Author to confirm completion of the Author''s copyediting process and thank them for their contribution.'),
('COPYEDIT_FINAL_REQUEST', 'en_US', 'Copyediting Final Review', '{$copyeditorName}:\n\nThe author and editor have now completed their copyediting review of "{$articleTitle}" for {$journalName}. A "clean copy" now needs to be prepared for Layout by going through the following steps.\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 2.\n3. Open the downloaded file and incorporate all copyedits and query responses.\n4. Save clean file, and upload to Step 3 of Copyediting.\n5. Click on METADATA to check indexing information (saving any corrections).\n6. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$copyeditorUsername}\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Copyeditor requests that they perform a final round of copyediting on a submission before it enters the layout process.'),
('COPYEDIT_FINAL_COMPLETE', 'en_US', 'Copyediting Final Review Completed', '{$editorialContactName}:\n\nI have now prepared a clean, copyedited version of the manuscript, "{$articleTitle}," for {$journalName}. It is ready for Layout and the preparation of the galleys.\n\n{$copyeditorName}', 'This email from the Copyeditor to the Section Editor notifies them that the final round of copyediting has been completed and that the layout process may now begin.'),
('COPYEDIT_FINAL_ACK', 'en_US', 'Copyediting Final Review Acknowledgement', '{$copyeditorName}:\n\nThank you for completing the copyediting of the manuscript, "{$articleTitle}," for {$journalName}. This preparation of a "clean copy" for Layout is an important step in the editorial process.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Copyeditor acknowledges completion of the final round of copyediting and thanks them for their contribution.'),
('LAYOUT_REQUEST', 'en_US', 'Request Galleys', '{$layoutEditorName}:\n\nThe submission "{$articleTitle}" to {$journalName} now needs galleys laid out by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and use the Layout Version file to create the galleys according to the journal''s standards.\n3. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionLayoutUrl}\nUsername: {$layoutEditorUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor notifies them that they have been assigned the task of performing layout editing on a submission. It provides information about the submission and how to access it.'),
('LAYOUT_COMPLETE', 'en_US', 'Galleys Complete', '{$editorialContactName}:\n\nGalleys have now been prepared for the manuscript, "{$articleTitle}," for {$journalName} and are ready for proofreading. \n\nIf you have any questions, please contact me.\n\n{$layoutEditorName}', 'This email from the Layout Editor to the Section Editor notifies them that the layout process has been completed.'),
('LAYOUT_ACK', 'en_US', 'Layout Acknowledgement', '{$layoutEditorName}:\n\nThank you for preparing the galleys for the manuscript, "{$articleTitle}," for {$journalName}. This is an important contribution to the publishing process.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor acknowledges completion of the layout editing process and thanks the layout editor for their contribution.'),
('PROOFREAD_AUTHOR_REQUEST', 'en_US', 'Proofreading Request (Author)', '{$authorName}:\n\nYour submission "{$articleTitle}" to {$journalName} now needs to be proofread by folllowing these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and view PROOFING INSTRUCTIONS\n3. Click on VIEW PROOF in Layout and proof the galley in the one or more formats used.\n4. Enter corrections (typographical and format) in Proofreading Corrections.\n5. Save and email corrections to Layout Editor and Proofreader.\n6. Send the COMPLETE email to the editor.\n\nSubmission URL: {$submissionUrl}\nUsername: {$authorUsername}\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Author notifies them that an article''s galleys are ready for proofreading. It provides information about the article and how to access it.'),
('PROOFREAD_AUTHOR_COMPLETE', 'en_US', 'Proofreading Completed (Author)', '{$editorialContactName}:\n\nI have completed proofreading the galleys for my manuscript, "{$articleTitle}," for {$journalName}. The galleys are now ready to have any final corrections made by the Proofreader and Layout Editor.\n\n{$authorName}', 'This email from the Author to the Proofreader and Editor notifies them that the Author''s round of proofreading is complete and that details can be found in the article comments.'),
('PROOFREAD_AUTHOR_ACK', 'en_US', 'Proofreading Acknowledgement (Author)', '{$authorName}:\n\nThank you for proofreading the galleys for your manuscript, "{$articleTitle}," in {$journalName}. We are looking forward to publishing your work shortly.\n\nIf you subscribe to our notification service, you will receive an email of the Table of Contents as soon as it is published. If you have any questions, please contact me.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Author acknowledges completion of the initial proofreading process and thanks them for their contribution.'),
('PROOFREAD_REQUEST', 'en_US', 'Proofreading Request', '{$proofreaderName}:\n\nThe submission "{$articleTitle}" to {$journalName} now needs to be proofread by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and view PROOFING INSTRUCTIONS.\n3. Click on VIEW PROOF in Layout and proof the galley in the one or more formats used.\n4. Enter corrections (typographical and format) in Proofreading Corrections.\n5. Save and email corrections to Layout Editor.\n6. Send the COMPLETE email to the editor.\n\nManuscript URL: {$submissionUrl}\nUsername: {$proofreaderUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Proofreader requests that they perform proofreading of an article''s galleys. It provides information about the article and how to access it.'),
('PROOFREAD_COMPLETE', 'en_US', 'Proofreading Completed', '{$editorialContactName}:\n\nI have completed proofreading the galleys for the manuscript, "{$articleTitle}," for {$journalName}. The galleys are now ready to have any final corrections made by the Layout Editor.\n\n{$proofreaderName}', 'This email from the Proofreader to the Section Editor notifies them that the Proofreader has completed the proofreading process.'),
('PROOFREAD_ACK', 'en_US', 'Proofreading Acknowledgement', '{$proofreaderName}:\n\nThank you for proofreading the galleys for the manuscript, "{$articleTitle}," for {$journalName}. This work makes an important contribution to the quality of this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Proofreader confirms completion of the proofreader''s proofreading process and thanks them for their contribution.'),
('PROOFREAD_LAYOUT_REQUEST', 'en_US', 'Proofreading Request (Layout Editor)', '{$layoutEditorName}:\n\nThe submission "{$articleTitle}" to {$journalName} has been proofread by the author and proofreader, and any corrections should now be made by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal consult Proofreading Corrections to create corrected galleys.\n3. Upload the revised galleys.\n4. Send the COMPLETE email in Proofreading Step 3 to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubnmission URL: {$submissionUrl}\nUsername: {$layoutEditorUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor notifies them that an article''s galleys are ready for final proofreading. It provides information on the article and how to access it.'),
('PROOFREAD_LAYOUT_COMPLETE', 'en_US', 'Proofreading Completed (Layout Editor)', '{$editorialContactName}:\n\nThe galleys have now been corrected, following their proofreading, for the manuscript, "{$articleTitle}," for {$journalName}. This piece is now ready to publish.\n\n{$layoutEditorName}', 'This email from the Layout Editor to the Section Editor notifies them that the final stage of proofreading has been completed and the article is now ready to publish.'),
('PROOFREAD_LAYOUT_ACK', 'en_US', 'Proofreading Acknowledgement (Layout Editor)', '{$layoutEditorName}:\n\nThank you for completing the proofreading corrections for the galleys associated with the manuscript, "{$articleTitle}," for {$journalName}. This represents an important contribution to the work of this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor acknowledges completion of the final stage of proofreading and thanks them for their contribution.'),
('EMAIL_LINK', 'en_US', 'Article of Possible Interest', 'Thought you might be interested in seeing "{$articleTitle}" by {$authorName} published in Vol {$volume}, No {$number} ({$year}) of {$journalName} at "{$articleUrl}".', 'This email template provides a registered reader with the opportunity to send information about an article to somebody who may be interested. It is available via the Reading Tools and must be enabled by the Journal Manager in the Reading Tools Administration page.'),
('SUBSCRIPTION_NOTIFY', 'en_US', 'Subscription Notification', '{$subscriberName}:\n\nYou have now been registered as a subscriber in our online journal management system for {$journalName}, with the following subscription:\n\n{$subscriptionType}\n\nTo access content that is available only to subscribers, simply log in to the system with your username, "{$username}".\n\nOnce you have logged in to the system you can change your profile details and password at any point.\n\nPlease note that if you have an institutional subscription, there is no need for users at your institution to log in, since requests for subscription content will be automatically authenticated by the system.\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a registered reader that the Manager has created a subscription for them. It provides the journal''s URL along with instructions for access.'),
('OPEN_ACCESS_NOTIFY', 'en_US', 'Issue Now Open Access', 'Readers:\n\n{$journalName} has just made available in an open access format the following issue. We invite you to review the Table of Contents here and then visit our web site ({$journalUrl}) to review articles and items of interest.\n\nThanks for the continuing interest in our work,\n{$editorialContactSignature}', 'This email is sent to registered readers who have requested to receive a notification email when an issue becomes open access.'),
('SUBSCRIPTION_BEFORE_EXPIRY', 'en_US', 'Notice of Subscription Expiry', '{$subscriberName}:\n\nYour {$journalName} subscription is about to expire.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo ensure the continuity of your access to this journal, please go to the journal website and renew your subscription. You are able to log in to the system with your username, "{$username}".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a subscriber that their subscription will soon expire. It provides the journal''s URL along with instructions for access.'),
('SUBSCRIPTION_AFTER_EXPIRY', 'en_US', 'Subscription Expired', '{$subscriberName}:\n\nYour {$journalName} subscription has expired.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, "{$username}".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a subscriber that their subscription has expired. It provides the journal''s URL along with instructions for access.'),
('SUBSCRIPTION_AFTER_EXPIRY_LAST', 'en_US', 'Subscription Expired - Final Reminder', '{$subscriberName}:\n\nYour {$journalName} subscription has expired.\nPlease note that this is the final reminder that will be emailed to you.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, "{$username}".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a subscriber that their subscription has expired. It provides the journal''s URL along with instructions for access.'),
('SUBSCRIPTION_PURCHASE_INDL', 'en_US', 'Subscription Purchase: Individual', 'An individual subscription has been purchased online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUser:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an individual subscription has been purchased online. It provides summary information about the subscription and a quick access link to the purchased subscription.'),
('SUBSCRIPTION_PURCHASE_INSTL', 'en_US', 'Subscription Purchase: Institutional', 'An institutional subscription has been purchased online for {$journalName} with the following details. To activate this subscription, please use the provided Subscription URL and set the subscription status to ''Active''.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nContact Person:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an institutional subscription has been purchased online. It provides summary information about the subscription and a quick access link to the purchased subscription.'),
('SUBSCRIPTION_RENEW_INDL', 'en_US', 'Subscription Renewal: Individual', 'An individual subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUser:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an individual subscription has been renewed online. It provides summary information about the subscription and a quick access link to the renewed subscription.'),
('SUBSCRIPTION_RENEW_INSTL', 'en_US', 'Subscription Renewal: Institutional', 'An institutional subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nContact Person:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an institutional subscription has been renewed online. It provides summary information about the subscription and a quick access link to the renewed subscription.'),
('CITATION_EDITOR_AUTHOR_QUERY', 'en_US', 'Citation Editing', '{$authorFirstName},\n\nCould you please verify or provide us with the proper citation for the following reference from your article, {$articleTitle}:\n\n{$rawCitation}\n\nThanks!\n\n{$userFirstName}\nCopy-Editor, {$journalName}\n', 'This email allows copyeditors to request additional information about references from authors.'),
('BFR_REVIEW_REMINDER', 'en_US', 'Book for Review: Due Date Reminder', 'Dear {$authorName}:\n\nThis is a friendly reminder that your book review of {$bookForReviewTitle} is due {$bookForReviewDueDate}.\n\nTo submit your book review, please log into the journal website and complete the online article submission process. For your convenience, a submission URL has been provided below.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\nThank you for your contribution to the journal and I look forward to receiving your submission.\n\n{$editorialContactSignature}', 'This is an automatically generated email that is sent to a book for review author as a reminder that the due date for the review is approaching.'),
('BFR_REVIEW_REMINDER_LATE', 'en_US', 'Book for Review: Review Due', 'Dear {$authorName}:\n\nThis is a friendly reminder that your book review of {$bookForReviewTitle} was due {$bookForReviewDueDate} but has not been received yet.\n\nTo submit your book review, please log into the journal website and complete the online article submission process. For your convenience, a submission URL has been provided below.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\nThank you for your contribution to the journal and I look forward to receiving your submission.\n\n{$editorialContactSignature}', 'This is an automatically generated email that is sent to a book for review author after the review due date has passed.'),
('BFR_BOOK_ASSIGNED', 'en_US', 'Book for Review: Book Assigned', 'Dear {$authorName}:\n\nThis email confirms that {$bookForReviewTitle} has been assigned to you for a book review to be completed by {$bookForReviewDueDate}.\n\nPlease ensure that your mailing address in your online user profile is up-to-date. This address will be used to mail a copy of the book to you for the review.\n\nThe mailing address that we currently have on file is:\n{$authorMailingAddress}\n\nIf this address is incomplete or you are no longer at this address, please use the following user profile URL to update your address:\n\nUser Profile URL: {$userProfileUrl}\n \nTo submit your book review, please log into the journal website and complete the online article submission process.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\n{$editorialContactSignature}', 'This email is sent by an editor to a book review author when an editor assigns the book for review to the author.'),
('BFR_BOOK_DENIED', 'en_US', 'Book for Review', 'Dear {$authorName}:\n\nUnfortunately, I am not able to assign {$bookForReviewTitle} to you at this time for a book review.\n\nI hope you consider reviewing another book from our listing, either at this time or in the future.\n\n{$editorialContactSignature}', 'This email is sent by an editor to an interested author when a book is no longer available for review.'),
('BFR_BOOK_REQUESTED', 'en_US', 'Book for Review: Book Requested', 'Dear {$editorName}:\n\nI am interested in writing a book review of {$bookForReviewTitle}.\n\nCan you please confirm whether this book is still available for review?\n\n{$authorContactSignature}', 'This email is sent to an editor by an author interested in writing a book review for a listed book.'),
('BFR_BOOK_MAILED', 'en_US', 'Book for Review: Book Mailed', 'Dear {$authorName}:\n\nThis email confirms that I have mailed a copy of {$bookForReviewTitle} to the following mailing address from your online user profile:\n{$authorMailingAddress}\n \nTo submit your book review, please log into the journal website and complete the online article submission process.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\n{$editorialContactSignature}', 'This email is sent by an editor to a book review author when the editor has mailed a copy of the book to the author.'),
('BFR_REVIEWER_REMOVED', 'en_US', 'Book for Review', 'Dear {$authorName}:\n\nThis email confirms that you have been removed as the book reviewer for {$bookForReviewTitle}, which will be made available to other authors interested in reviewing the book.\n\nI hope you consider reviewing another book from our listing, either at this time or in the future.\n\n{$editorialContactSignature}', 'This email is sent by an editor to an interested author when a book is no longer available for review.'),
('SWORD_DEPOSIT_NOTIFICATION', 'en_US', 'Deposit Notification', 'Congratulations on the acceptance of your submission, "{$articleTitle}", for publication in {$journalName}. If you choose, you may automatically deposit your submission in one or more repositories.\n\nGo to {$swordDepositUrl} to proceed.\n\nThis email was generated by Open Journal Systems'' SWORD deposit plugin.', 'This email template is used to notify an author of optional deposit points for SWORD deposits.'),
('THESIS_ABSTRACT_CONFIRM', 'en_US', 'Thesis Abstract Submission', 'This email was automatically generated by the {$journalName} thesis abstract submission form.\n\nPlease confirm that the submitted information is correct. Upon receiving your confirmation, the abstract will be published in the online edition of the journal.\n\nSimply reply to {$thesisName} ({$thesisEmail}) with the contents of this message and your confirmation, as well as any recommended clarifications or corrections.\n\nThank you.\n\n\nTitle : {$title} \nAuthor : {$studentName}\nDegree : {$degree}\nDegree Name: {$degreeName}\nDepartment : {$department}\nUniversity : {$university}\nAcceptance Date : {$dateApproved}\nSupervisor : {$supervisorName}\n\nAbstract\n--------\n{$abstract}\n\n{$thesisContactSignature}', 'This email template is used to confirm a thesis abstract submission by a student. It is sent to the student''s supervisor, who is asked to confirm the details of the submitted thesis abstract.'),
('MANUAL_PAYMENT_NOTIFICATION', 'en_US', 'Manual Payment Notification', 'A manual payment needs to be processed for the journal {$journalName} and the user {$userFullName} (username "{$userName}").\n\nThe item being paid for is "{$itemName}".\nThe cost is {$itemCost} ({$itemCurrencyCode}).\n\nThis email was generated by Open Journal Systems'' Manual Payment plugin.', 'This email template is used to notify a journal manager contact that a manual payment was requested.'),
('PAYPAL_INVESTIGATE_PAYMENT', 'en_US', 'Unusual PayPal Activity', 'Open Journal Systems has encountered unusual activity relating to PayPal payment support for the journal {$journalName}. This activity may need further investigation or manual intervention.\n                       \nThis email was generated by Open Journal Systems'' PayPal plugin.\n\nFull post information for the request:\n{$postInfo}\n\nAdditional information (if supplied):\n{$additionalInfo}\n\nServer vars:\n{$serverVars}\n', 'This email template is used to notify a journal''s primary contact that suspicious activity or activity requiring manual intervention was encountered by the PayPal plugin.');

-- --------------------------------------------------------

--
-- Table structure for table `erc_reviewers`
--

CREATE TABLE IF NOT EXISTS `erc_reviewers` (
  `journal_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `section_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `status` tinyint(1) NOT NULL,
  KEY `journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='New table for associating a reviewer to an erc (section)' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `external_feeds`
--

CREATE TABLE IF NOT EXISTS `external_feeds` (
  `feed_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `display_homepage` tinyint(4) NOT NULL DEFAULT '0',
  `display_block` smallint(6) NOT NULL DEFAULT '0',
  `limit_items` tinyint(4) DEFAULT '0',
  `recent_items` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`feed_id`),
  KEY `external_feeds_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `external_feed_settings`
--

CREATE TABLE IF NOT EXISTS `external_feed_settings` (
  `feed_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `external_feed_settings_pkey` (`feed_id`,`locale`,`setting_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `extra_fields`
--

CREATE TABLE IF NOT EXISTS `extra_fields` (
  `extra_field_id` int(10) NOT NULL AUTO_INCREMENT,
  `type` smallint(2) NOT NULL,
  `active` smallint(1) NOT NULL,
  PRIMARY KEY (`extra_field_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Store the geographical areas, research fields, research doma' AUTO_INCREMENT=59 ;

--
-- Dumping data for table `extra_fields`
--

INSERT INTO `extra_fields` (`extra_field_id`, `type`, `active`) VALUES
(34, 2, 1),
(35, 2, 1),
(36, 2, 1),
(37, 2, 1),
(38, 2, 1),
(39, 2, 1),
(40, 2, 1),
(41, 2, 1),
(42, 2, 1),
(43, 2, 1),
(44, 2, 1),
(45, 2, 1),
(46, 2, 1),
(47, 2, 1),
(48, 2, 1),
(49, 3, 1),
(50, 3, 1),
(51, 3, 1),
(52, 3, 2),
(53, 4, 1),
(54, 4, 1),
(55, 4, 1),
(56, 4, 1),
(57, 4, 1),
(58, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `extra_field_settings`
--

CREATE TABLE IF NOT EXISTS `extra_field_settings` (
  `extra_field_id` int(10) NOT NULL,
  `locale` varchar(5) NOT NULL,
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `extra_field_settings_pkey` (`extra_field_id`,`locale`,`setting_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `extra_field_settings`
--

INSERT INTO `extra_field_settings` (`extra_field_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(34, 'en_US', 'extraFieldName', 'Accidents and Injuries', 'string'),
(35, 'en_US', 'extraFieldName', 'Child Health', 'string'),
(36, 'en_US', 'extraFieldName', 'Drug Quality', 'string'),
(37, 'en_US', 'extraFieldName', 'Family Planning', 'string'),
(38, 'en_US', 'extraFieldName', 'Gender and Sexuality', 'string'),
(39, 'en_US', 'extraFieldName', 'Health Care Seeking/Utilization', 'string'),
(40, 'en_US', 'extraFieldName', 'Health Financing', 'string'),
(41, 'en_US', 'extraFieldName', 'HIV/AIDS', 'string'),
(42, 'en_US', 'extraFieldName', 'Immunization/Vaccine Preventable Disease', 'string'),
(43, 'en_US', 'extraFieldName', 'Infectious Disease', 'string'),
(44, 'en_US', 'extraFieldName', 'Malaria', 'string'),
(45, 'en_US', 'extraFieldName', 'Non-communicable Disease', 'string'),
(46, 'en_US', 'extraFieldName', 'Nutrition', 'string'),
(47, 'en_US', 'extraFieldName', 'Reproductive Health', 'string'),
(48, 'en_US', 'extraFieldName', 'Tuberculosis', 'string'),
(49, 'en_US', 'extraFieldName', 'Maternal, Reproductive and Child Health', 'string'),
(50, 'en_US', 'extraFieldName', 'Communicable Disease Research', 'string'),
(51, 'en_US', 'extraFieldName', 'Non-communicable diseases &  Healthy Lifestyles', 'string'),
(52, 'en_US', 'extraFieldName', 'Health Systems Research', 'string'),
(53, 'en_US', 'extraFieldName', 'Clinical Trial with Human Subjects', 'string'),
(54, 'en_US', 'extraFieldName', 'Health System and Policy Research', 'string'),
(55, 'en_US', 'extraFieldName', 'Population-Based Survey', 'string'),
(56, 'en_US', 'extraFieldName', 'Qualitative Study', 'string'),
(57, 'en_US', 'extraFieldName', 'Intervention Evaluation Research', 'string'),
(58, 'en_US', 'extraFieldName', 'Operational Research', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `filters`
--

CREATE TABLE IF NOT EXISTS `filters` (
  `filter_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL DEFAULT '0',
  `display_name` varchar(255) DEFAULT NULL,
  `class_name` varchar(255) DEFAULT NULL,
  `input_type` varchar(255) DEFAULT NULL,
  `output_type` varchar(255) DEFAULT NULL,
  `is_template` tinyint(4) NOT NULL DEFAULT '0',
  `parent_filter_id` bigint(20) NOT NULL DEFAULT '0',
  `seq` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`filter_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=67 ;

--
-- Dumping data for table `filters`
--

INSERT INTO `filters` (`filter_id`, `context_id`, `display_name`, `class_name`, `input_type`, `output_type`, `is_template`, `parent_filter_id`, `seq`) VALUES
(45, 0, 'CrossRef', 'lib.pkp.classes.citation.lookup.crossref.CrossrefNlmCitationSchemaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(46, 0, 'PubMed', 'lib.pkp.classes.citation.lookup.pubmed.PubmedNlmCitationSchemaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(47, 0, 'WorldCat', 'lib.pkp.classes.citation.lookup.worldcat.WorldcatNlmCitationSchemaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(48, 0, 'FreeCite', 'lib.pkp.classes.citation.parser.freecite.FreeciteRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(49, 0, 'ParaCite', 'lib.pkp.classes.citation.parser.paracite.ParaciteRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(50, 0, 'ParsCit', 'lib.pkp.classes.citation.parser.parscit.ParscitRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(51, 0, 'RegEx', 'lib.pkp.classes.citation.parser.regex.RegexRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(52, 0, 'ABNT Citation Output', 'lib.pkp.classes.citation.output.abnt.NlmCitationSchemaAbntFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(53, 0, 'ABNT Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(54, 0, 'APA Citation Output', 'lib.pkp.classes.citation.output.apa.NlmCitationSchemaApaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(55, 0, 'APA Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(56, 0, 'MLA Citation Output', 'lib.pkp.classes.citation.output.mla.NlmCitationSchemaMlaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(57, 0, 'MLA Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(58, 0, 'Vancouver Citation Output', 'lib.pkp.classes.citation.output.vancouver.NlmCitationSchemaVancouverFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(59, 0, 'Vancouver Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(60, 0, 'NLM Journal Publishing V3.0 ref-list', 'lib.pkp.classes.importexport.nlm.PKPSubmissionNlmXmlFilter', 'class::lib.pkp.classes.submission.Submission', 'xml::*', 0, 0, 0),
(61, 0, 'ISBNdb', 'lib.pkp.classes.filter.GenericSequencerFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(62, 0, 'ISBNdb (from NLM)', 'lib.pkp.classes.citation.lookup.isbndb.IsbndbNlmCitationSchemaIsbnFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 61, 1),
(63, 0, 'ISBNdb', 'lib.pkp.classes.citation.lookup.isbndb.IsbndbIsbnNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 0, 61, 2),
(64, 0, 'NLM Journal Publishing V2.3 ref-list', 'lib.pkp.classes.filter.GenericSequencerFilter', 'class::lib.pkp.classes.submission.Submission', 'xml::*', 0, 0, 0),
(65, 0, 'NLM Journal Publishing V3.0 ref-list', 'lib.pkp.classes.importexport.nlm.PKPSubmissionNlmXmlFilter', 'class::lib.pkp.classes.submission.Submission', 'xml::*', 0, 64, 1),
(66, 0, 'NLM 3.0 to 2.3 ref-list downgrade', 'lib.pkp.classes.xslt.XSLTransformationFilter', 'xml::*', 'xml::*', 0, 64, 2);

-- --------------------------------------------------------

--
-- Table structure for table `filter_settings`
--

CREATE TABLE IF NOT EXISTS `filter_settings` (
  `filter_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `filter_settings_pkey` (`filter_id`,`locale`,`setting_name`),
  KEY `filter_settings_id` (`filter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `filter_settings`
--

INSERT INTO `filter_settings` (`filter_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(45, '', 'phpVersionMin', '5.0.0', 'string'),
(46, '', 'phpVersionMin', '5.0.0', 'string'),
(47, '', 'phpVersionMin', '5.0.0', 'string'),
(48, '', 'phpVersionMin', '5.0.0', 'string'),
(49, '', 'citationModule', 'Standard', 'string'),
(49, '', 'phpVersionMin', '5.0.0', 'string'),
(50, '', 'phpVersionMin', '5.0.0', 'string'),
(51, '', 'phpVersionMin', '5.0.0', 'string'),
(53, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.abnt.NlmCitationSchemaAbntFilter', 'string'),
(53, '', 'ordering', '2', 'int'),
(55, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.apa.NlmCitationSchemaApaFilter', 'string'),
(55, '', 'ordering', '2', 'int'),
(57, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.mla.NlmCitationSchemaMlaFilter', 'string'),
(57, '', 'ordering', '2', 'int'),
(59, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.vancouver.NlmCitationSchemaVancouverFilter', 'string'),
(59, '', 'ordering', '1', 'int'),
(61, '', 'settingsMapping', 'a:2:{s:6:"apiKey";a:2:{i:0;s:11:"seq1_apiKey";i:1;s:11:"seq2_apiKey";}s:10:"isOptional";a:2:{i:0;s:15:"seq1_isOptional";i:1;s:15:"seq2_isOptional";}}', 'object'),
(62, '', 'phpVersionMin', '5.0.0', 'string'),
(63, '', 'phpVersionMin', '5.0.0', 'string'),
(66, '', 'xsl', 'lib/pkp/classes/importexport/nlm/nlm-ref-list-30-to-23.xsl', 'string'),
(66, '', 'xslType', '2', 'int');

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE IF NOT EXISTS `groups` (
  `group_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `publish_email` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `context` bigint(20) DEFAULT NULL,
  `about_displayed` tinyint(4) NOT NULL DEFAULT '0',
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`),
  KEY `groups_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `group_memberships`
--

CREATE TABLE IF NOT EXISTS `group_memberships` (
  `user_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `about_displayed` tinyint(4) NOT NULL DEFAULT '1',
  `seq` double NOT NULL DEFAULT '0',
  UNIQUE KEY `group_memberships_pkey` (`user_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `group_settings`
--

CREATE TABLE IF NOT EXISTS `group_settings` (
  `group_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `group_settings_pkey` (`group_id`,`locale`,`setting_name`),
  KEY `group_settings_group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `institutional_subscriptions`
--

CREATE TABLE IF NOT EXISTS `institutional_subscriptions` (
  `institutional_subscription_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subscription_id` bigint(20) NOT NULL,
  `institution_name` varchar(255) NOT NULL,
  `mailing_address` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`institutional_subscription_id`),
  KEY `institutional_subscriptions_subscription_id` (`subscription_id`),
  KEY `institutional_subscriptions_domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `institutional_subscription_ip`
--

CREATE TABLE IF NOT EXISTS `institutional_subscription_ip` (
  `institutional_subscription_ip_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subscription_id` bigint(20) NOT NULL,
  `ip_string` varchar(40) NOT NULL,
  `ip_start` bigint(20) NOT NULL,
  `ip_end` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`institutional_subscription_ip_id`),
  KEY `institutional_subscription_ip_subscription_id` (`subscription_id`),
  KEY `institutional_subscription_ip_start` (`ip_start`),
  KEY `institutional_subscription_ip_end` (`ip_end`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `institutions`
--

CREATE TABLE IF NOT EXISTS `institutions` (
  `institution_id` int(5) NOT NULL AUTO_INCREMENT,
  `type` int(1) NOT NULL,
  `international` tinyint(1) NOT NULL,
  `location` varchar(8) NOT NULL,
  `name` varchar(90) NOT NULL,
  `acronym` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`institution_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `institutions`
--

INSERT INTO `institutions` (`institution_id`, `type`, `international`, `location`, `name`, `acronym`) VALUES
(1, 1, 1, 'CH', 'World Health Organization', 'WHO'),
(2, 4, 0, 'SELF', 'Self', 'SELF'),
(4, 1, 1, 'PH', 'Asian Development Bank', 'ADB'),
(5, 1, 1, 'AU', 'Australian Agency for International Development', 'AUSAID'),
(6, 3, 1, 'US', 'World Vision', 'WV'),
(7, 1, 1, 'KP', 'Korean International Cooperation Agency', 'KOICA'),
(8, 1, 1, 'JP', 'Japan International Cooperation Agency', 'JICA'),
(10, 1, 1, 'FR', 'Institut de Recherche pour le Développement', 'IRD'),
(11, 3, 1, 'FR', 'Institut Pasteur', 'IP'),
(12, 1, 1, 'US', 'United Nations Children''s Fund', 'UNICEF'),
(13, 1, 1, 'US', 'United Nations Development Program', 'UNDP'),
(14, 1, 1, 'US', 'United States Agency for International Development', 'USAID'),
(15, 1, 1, 'US', 'World Bank', 'WB');

-- --------------------------------------------------------

--
-- Table structure for table `issues`
--

CREATE TABLE IF NOT EXISTS `issues` (
  `issue_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `volume` smallint(6) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `published` tinyint(4) NOT NULL DEFAULT '0',
  `current` tinyint(4) NOT NULL DEFAULT '0',
  `date_published` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `access_status` tinyint(4) NOT NULL DEFAULT '1',
  `open_access_date` datetime DEFAULT NULL,
  `public_issue_id` varchar(255) DEFAULT NULL,
  `show_volume` tinyint(4) NOT NULL DEFAULT '0',
  `show_number` tinyint(4) NOT NULL DEFAULT '0',
  `show_year` tinyint(4) NOT NULL DEFAULT '0',
  `show_title` tinyint(4) NOT NULL DEFAULT '0',
  `style_file_name` varchar(90) DEFAULT NULL,
  `original_style_file_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`issue_id`),
  UNIQUE KEY `issues_public_issue_id` (`public_issue_id`,`journal_id`),
  KEY `issues_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `issue_settings`
--

CREATE TABLE IF NOT EXISTS `issue_settings` (
  `issue_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `issue_settings_pkey` (`issue_id`,`locale`,`setting_name`),
  KEY `issue_settings_issue_id` (`issue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `journals`
--

CREATE TABLE IF NOT EXISTS `journals` (
  `journal_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(32) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `primary_locale` varchar(5) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`journal_id`),
  UNIQUE KEY `journals_path` (`path`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `journals`
--

INSERT INTO `journals` (`journal_id`, `path`, `seq`, `primary_locale`, `enabled`) VALUES
(4, 'hrp', 1, 'en_US', 1);

-- --------------------------------------------------------

--
-- Table structure for table `journal_settings`
--

CREATE TABLE IF NOT EXISTS `journal_settings` (
  `journal_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `journal_settings_pkey` (`journal_id`,`locale`,`setting_name`),
  KEY `journal_settings_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `journal_settings`
--

INSERT INTO `journal_settings` (`journal_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(4, '', 'numPageLinks', '10', 'int'),
(4, '', 'itemsPerPage', '10', 'int'),
(4, '', 'numWeeksPerReview', '2', 'int'),
(4, 'en_US', 'privacyStatement', '<p>The names and email addresses entered in this site will be used exclusively for the stated purposes of this site and will not be made available for any other purpose or to any other party.</p>', 'string'),
(4, 'en_US', 'authorSelfArchivePolicy', 'This journal permits and encourages authors to post items submitted to the journal on personal websites or institutional repositories both prior to and after publication, while providing bibliographic details that credit, if applicable, its publication in this journal.', 'string'),
(4, 'en_US', 'copyeditInstructions', 'The copyediting stage is intended to improve the flow, clarity, grammar, wording, and formatting of the article. It represents the last chance for the author to make any substantial changes to the text because the next stage is restricted to typos and formatting corrections.   The file to be copyedited is in Word or .rtf format and therefore can easily be edited as a word processing document. The set of instructions displayed here proposes two approaches to copyediting. One is based on Microsoft Word''s Track Changes feature and requires that the copy editor, editor, and author have access to this program. A second system, which is software independent, has been borrowed, with permission, from the Harvard Educational Review. The journal editor is in a position to modify these instructions, so suggestions can be made to improve the process for this journal.   <h4>Copyediting Systems</h4> <strong>1. Microsoft Word''s Track Changes</strong> Under Tools in the menu bar, the feature Track Changes enables the copy editor to make insertions (text appears in color) and deletions (text appears crossed out in color or in the margins as deleted). The copy editor can posit queries to both the author (Author Queries) and to the editor (Editor Queries) by inserting these queries in square brackets. The copyedited version is then uploaded, and the editor is notified. The editor then reviews the text and notifies the author.  The editor and author should leave those changes with which they are satisfied. If further changes are necessary, the editor and author can make changes to the initial insertions or deletions, as well as make new insertions or deletions elsewhere in the text. Authors and editors should respond to each of the queries addressed to them, with responses placed inside the square brackets.   After the text has been reviewed by editor and author, the copy editor will make a final pass over the text accepting the changes in preparation for the layout and galley stage.   <strong>2. Harvard Educational Review </strong> <strong>Instructions for Making Electronic Revisions to the Manuscript</strong> Please follow the following protocol for making electronic revisions to your manuscript:  <strong>Responding to suggested changes.</strong> For each of the suggested changes that you accept, unbold the text. Â  For each of the suggested changes that you do not accept, re-enter the original text and <strong>bold</strong> it.  <strong>Making additions and deletions.</strong> Indicate additions by <strong>bolding</strong> the new text. Â  Replace deleted sections with: <strong>[deleted text]</strong>. Â  If you delete one or more sentence, please indicate with a note, e.g., <strong>[deleted 2 sentences]</strong>.  <strong>Responding to Queries to the Author (QAs).</strong> Keep all QAs intact and bolded within the text. Do not delete them. Â  To reply to a QA, add a comment after it. Comments should be delimited using: <strong>[Comment:]</strong> e.g., <strong>[Comment: Expanded discussion of methodology as you suggested]</strong>.  <strong>Making comments.</strong> Use comments to explain organizational changes or major revisions Â  e.g., <strong>[Comment: Moved the above paragraph from p. 5 to p. 7].</strong> Note: When referring to page numbers, please use the page numbers from the printed copy of the manuscript that was sent to you. This is important since page numbers may change as a document is revised electronically.  <h4>An Illustration of an Electronic Revision</h4> <ol> <li><strong>Initial copyedit.</strong> The journal copy editor will edit the text to improve flow, clarity, grammar, wording, and formatting, as well as including author queries as necessary. Once the initial edit is complete, the copy editor will upload the revised document through the journal Web site and notify the author that the edited manuscript is available for review.</li> <li><strong>Author copyedit.</strong> Before making dramatic departures from the structure and organization of the edited manuscript, authors must check in with the editors who are co-chairing the piece. Authors should accept/reject any changes made during the initial copyediting, as appropriate, and respond to all author queries. When finished with the revisions, authors should rename the file from AuthorNameQA.doc to AuthorNameQAR.doc (e.g., from LeeQA.doc to LeeQAR.doc) and upload the revised document through the journal Web site as directed.</li> <li><strong>Final copyedit.</strong> The journal copy editor will verify changes made by the author and incorporate the responses to the author queries to create a final manuscript. When finished, the copy editor will upload the final document through the journal Web site and alert the layout editor to complete formatting.</li> </ol>', 'string'),
(4, '', 'useLayoutEditors', '0', 'bool'),
(4, '', 'emailSignature', '________________________________________________________________________\r\nHealth Research Portal', 'string'),
(4, '', 'remindForInvite', '0', 'bool'),
(4, 'en_US', 'proofInstructions', '<p>The proofreading stage is intended to catch any errors in the galley''s spelling, grammar, and formatting. More substantial changes cannot be made at this stage, unless discussed with the Section Editor. In Layout, click on VIEW PROOF to see the HTML, PDF, and other available file formats used in publishing this item.</p> <h4>For Spelling and Grammar Errors</h4> <p>Copy the problem word or groups of words and paste them into the Proofreading Corrections box with "CHANGE-TO" instructions to the editor as follows:</p> <pre>1. CHANGE...\r\n	then the others\r\n	TO...\r\n	than the others</pre> <br /> <pre>2. CHANGE...\r\n	Malinowsky\r\n	TO...\r\n	Malinowski</pre> <br /> <h4>For Formatting Errors</h4> <p>Describe the location and nature of the problem in the Proofreading Corrections box after typing in the title "FORMATTING" as follows:</p> <br /> <pre>3. FORMATTING\r\n	The numbers in Table 3 are not aligned in the third column.</pre> <br /> <pre>4. FORMATTING\r\n	The paragraph that begins "This last topic..." is not indented.</pre>', 'string'),
(4, 'en_US', 'refLinkInstructions', '<h4>To Add Reference Linking to the Layout Process</h4> <p>When turning a submission into HTML or PDF, make sure that all hyperlinks in the submission are active.</p> <h4>A. When the Author Provides a Link with the Reference</h4> <ol> <li>While the submission is still in its word processing format (e.g., Word), add the phrase VIEW ITEM to the end of the reference that has a URL.</li> <li>Turn that phrase into a hyperlink by highlighting it and using Word''s Insert Hyperlink tool and the URL prepared in #2.</li> </ol> <h4>B. Enabling Readers to Search Google Scholar For References</h4> <ol> <li>While the submission is still in its word processing format (e.g., Word), copy the title of the work referenced in the References list (if it appears to be too common a titleâ€”e.g., "Peace"â€”then copy author and title).</li> <li>Paste the reference''s title between the %22''s, placing a + between each word: http://scholar.google.com/scholar?q=%22PASTE+TITLE+HERE%22&amp;hl=en&amp;lr=&amp;btnG=Search.</li> <li>Add the phrase GS SEARCH to the end of each citation in the submission''s References list.</li> <li>Turn that phrase into a hyperlink by highlighting it and using Word''s Insert Hyperlink tool and the URL prepared in #2.</li> </ol> <h4>C. Enabling Readers to Search for References with a DOI</h4> <ol> <li>While the submission is still in Word, copy a batch of references into CrossRef Text Query http://www.crossref.org/freeTextQuery/.</li> <li>Paste each DOI that the Query provides in the following URL (between = and &amp;): http://www.cmaj.ca/cgi/external_ref?access_num=PASTE DOI#HERE&amp;link_type=DOI.</li> <li>Add the phrase CrossRef to the end of each citation in the submission''s References list.</li> <li>Turn that phrase into a hyperlink by highlighting the phrase and using Word''s Insert Hyperlink tool and the appropriate URL prepared in #2.</li> </ol>', 'string'),
(4, '', 'displayCurrentIssue', '0', 'bool'),
(4, 'en_US', 'librarianInformation', 'We encourage research librarians to list this journal among their library''s electronic journal holdings. As well, it may be worth noting that this journal''s open source publishing system is suitable for libraries to host for their faculty members to use with journals they are involved in editing (see <a href="http://pkp.sfu.ca/ojs">Open Journal Systems</a>).', 'string'),
(4, 'en_US', 'lockssLicense', 'This journal utilizes the LOCKSS system to create a distributed archiving system among participating libraries and permits those libraries to create permanent archives of the journal for purposes of preservation and restoration. <a href="http://lockss.org/">More...</a>', 'string'),
(4, '', 'supportedLocales', 'a:1:{i:0;s:5:"en_US";}', 'object'),
(4, '', 'supportedFormLocales', 'a:1:{i:0;s:5:"en_US";}', 'object'),
(4, '', 'supportedSubmissionLocales', 'a:1:{i:0;s:5:"en_US";}', 'object'),
(4, '', 'rtAbstract', '1', 'bool'),
(4, '', 'rtCaptureCite', '1', 'bool'),
(4, '', 'rtViewMetadata', '1', 'bool'),
(4, '', 'rtSupplementaryFiles', '1', 'bool'),
(4, '', 'rtPrinterFriendly', '1', 'bool'),
(4, '', 'rtAuthorBio', '1', 'bool'),
(4, '', 'rtDefineTerms', '1', 'bool'),
(4, '', 'rtAddComment', '1', 'bool'),
(4, '', 'rtEmailAuthor', '1', 'bool'),
(4, '', 'rtEmailOthers', '1', 'bool'),
(4, '', 'allowRegReviewer', '0', 'bool'),
(4, '', 'allowRegAuthor', '1', 'bool'),
(4, '', 'allowRegReader', '0', 'bool'),
(4, '', 'submissionFee', '100', 'float'),
(4, '', 'fastTrackFee', '0', 'float'),
(4, 'en_US', 'fastTrackFeeName', 'Fast-Track Review', 'string'),
(4, 'en_US', 'fastTrackFeeDescription', 'With the payment of this fee, the review, editorial decision, and author notification on this manuscript is guaranteed to take place within 4 weeks.', 'string'),
(4, '', 'publicationFee', '0', 'float'),
(4, 'en_US', 'publicationFeeName', 'Article Publication', 'string'),
(4, 'en_US', 'publicationFeeDescription', 'If this paper is accepted for publication, you will be asked to pay an Article Publication Fee to cover publications costs.', 'string'),
(4, 'en_US', 'waiverPolicy', 'If you do not have funds to pay such fees, you will have an opportunity to waive each fee. We do not want fees to prevent the publication of worthy work.', 'string'),
(4, '', 'purchaseArticleFee', '0', 'float'),
(4, 'en_US', 'purchaseArticleFeeName', 'Purchase Article', 'string'),
(4, 'en_US', 'purchaseArticleFeeDescription', 'The payment of this fee will enable you to view, download, and print this article.', 'string'),
(4, '', 'membershipFee', '0', 'float'),
(4, 'en_US', 'membershipFeeName', 'Association Membership', 'string'),
(4, 'en_US', 'membershipFeeDescription', 'The payment of this fee will enroll you as a member in this association for one year and provide you with free access to this journal.', 'string'),
(4, 'en_US', 'donationFeeName', 'Donations to journal', 'string'),
(4, 'en_US', 'donationFeeDescription', 'Donations of any amount to this journal are gratefully received and provide a means for the editors to continue to provide a journal of the highest quality to its readers.', 'string'),
(4, '', 'journalTheme', 'hrp', 'string'),
(4, 'en_US', 'initials', 'HRP', 'string'),
(4, '', 'printIssn', '', 'string'),
(4, '', 'onlineIssn', '', 'string'),
(4, '', 'doiPrefix', '', 'string'),
(4, '', 'doiSuffix', '', 'string'),
(4, '', 'doiSuffixPattern', '', 'string'),
(4, '', 'mailingAddress', '', 'string'),
(4, '', 'useEditorialBoard', '0', 'bool'),
(4, '', 'contactName', 'Principal Contact Name', 'string'),
(4, '', 'contactEmail', 'contact@email.com', 'string'),
(4, '', 'contactPhone', '', 'string'),
(4, '', 'contactFax', '', 'string'),
(4, '', 'supportName', 'Technical contact name', 'string'),
(4, '', 'supportEmail', 'technical.contact@email.com', 'string'),
(4, '', 'supportPhone', '', 'string'),
(4, '', 'sponsors', 'a:0:{}', 'object'),
(4, '', 'publisherInstitution', '', 'string'),
(4, '', 'publisherUrl', '', 'string'),
(4, '', 'contributors', 'a:0:{}', 'object'),
(4, '', 'envelopeSender', '', 'string'),
(4, '', 'remindForSubmit', '0', 'bool'),
(4, '', 'numDaysBeforeInviteReminder', '', 'int'),
(4, '', 'numDaysBeforeSubmitReminder', '', 'int'),
(4, '', 'rateReviewerOnQuality', '0', 'bool'),
(4, '', 'restrictReviewerFileAccess', '0', 'bool'),
(4, '', 'reviewerAccessKeysEnabled', '0', 'bool'),
(4, '', 'showEnsuringLink', '0', 'bool'),
(4, '', 'mailSubmissionsToReviewers', '0', 'bool'),
(4, '', 'authorSelectsEditor', '0', 'bool'),
(4, 'en_US', 'customAboutItems', 'a:1:{i:0;a:2:{s:5:"title";s:0:"";s:7:"content";s:0:"";}}', 'object'),
(4, '', 'enableLockss', '0', 'bool'),
(4, '', 'reviewerDatabaseLinks', 'N;', 'object'),
(4, '', 'notifyAllAuthorsOnDecision', '0', 'bool'),
(4, '', 'includeCreativeCommons', '0', 'bool'),
(4, '', 'copyrightNoticeAgree', '0', 'bool'),
(4, '', 'requireAuthorCompetingInterests', '0', 'bool'),
(4, '', 'requireReviewerCompetingInterests', '0', 'bool'),
(4, '', 'metaDiscipline', '0', 'bool'),
(4, '', 'metaSubjectClass', '0', 'bool'),
(4, 'en_US', 'metaSubjectClassUrl', 'http://', 'string'),
(4, '', 'metaSubject', '0', 'bool'),
(4, '', 'metaCoverage', '0', 'bool'),
(4, '', 'metaType', '0', 'bool'),
(4, '', 'metaCitations', '0', 'bool'),
(4, '', 'metaCitationOutputFilterId', '', 'int'),
(4, '', 'copySubmissionAckPrimaryContact', '0', 'bool'),
(4, '', 'copySubmissionAckSpecified', '0', 'bool'),
(4, '', 'copySubmissionAckAddress', '', 'string'),
(4, '', 'disableUserReg', '0', 'bool'),
(4, '', 'restrictSiteAccess', '0', 'bool'),
(4, '', 'restrictArticleAccess', '0', 'bool'),
(4, '', 'articleEventLog', '1', 'bool'),
(4, '', 'articleEmailLog', '1', 'bool'),
(4, '', 'publicationFormatVolume', '0', 'bool'),
(4, '', 'publicationFormatNumber', '0', 'bool'),
(4, '', 'publicationFormatYear', '0', 'bool'),
(4, '', 'publicationFormatTitle', '0', 'bool'),
(4, '', 'initialVolume', '0', 'int'),
(4, '', 'initialNumber', '0', 'int'),
(4, '', 'initialYear', '0', 'int'),
(4, '', 'useCopyeditors', '0', 'bool'),
(4, '', 'provideRefLinkInstructions', '0', 'bool'),
(4, '', 'useProofreaders', '0', 'bool'),
(4, '', 'publishingMode', '0', 'int'),
(4, '', 'showGalleyLinks', '0', 'bool'),
(4, '', 'enableAnnouncements', '1', 'bool'),
(4, '', 'enableAnnouncementsHomepage', '1', 'bool'),
(4, '', 'numAnnouncementsHomepage', '3', 'int'),
(4, '', 'volumePerYear', '', 'int'),
(4, '', 'issuePerVolume', '', 'int'),
(4, '', 'enablePublicIssueId', '0', 'bool'),
(4, '', 'enablePublicArticleId', '0', 'bool'),
(4, '', 'enablePublicGalleyId', '0', 'bool'),
(4, '', 'enablePublicSuppFileId', '0', 'bool'),
(4, '', 'enablePageNumber', '0', 'bool'),
(4, '', 'statisticsSectionIds', 'a:1:{i:0;s:1:"5";}', 'object'),
(4, '', 'journalPaymentsEnabled', '1', 'bool'),
(4, '', 'currency', 'USD', 'string'),
(4, '', 'submissionFeeEnabled', '0', 'bool'),
(4, 'en_US', 'submissionFeeName', 'Proposal Review Fee', 'string'),
(4, '', 'publicationFeeEnabled', '0', 'bool'),
(4, '', 'fastTrackFeeEnabled', '0', 'bool'),
(4, '', 'purchaseArticleFeeEnabled', '0', 'bool'),
(4, '', 'membershipFeeEnabled', '0', 'bool'),
(4, '', 'donationFeeEnabled', '0', 'bool'),
(4, '', 'restrictOnlyPdf', '0', 'bool'),
(4, '', 'acceptSubscriptionPayments', '0', 'bool'),
(4, '', 'paymentMethodPluginName', 'ManualPayment', 'string'),
(4, 'en_US', 'readerInformation', 'We encourage readers to sign up for the publishing notification service for this journal. Use the Register link at the top of the home page for the journal. This registration will result in the reader receiving the Table of Contents by email for each new issue of the journal. This list also allows the journal to claim a certain level of support or readership. See the journal''s  Privacy Statement, which assures readers that their name and email address will not be used for other purposes.', 'string'),
(4, 'en_US', 'authorInformation', 'Interested in submitting to this journal? We recommend that you review the About the Journal page for the journal''s section policies, as well as the Author Guidelines. Authors need to register with the journal prior to submitting or, if already registered, can simply log in and begin the five-step process.', 'string'),
(4, 'en_US', 'pageHeaderTitle', 'Health Research Portal', 'string'),
(4, 'en_US', 'submissionChecklist', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:159:"<p>I agree to submit the final research report and final raw data file 	within one year and two years of the end-date mentioned in this 	research proposal.</p>";}i:1;a:2:{s:5:"order";s:1:"5";s:7:"content";s:395:"<!-- P { margin-bottom: 0.08in; direction: ltr; color: rgb(0, 0, 0); text-align: justify; }P.western { font-family: "Cambria",serif; font-size: 12pt; }P.cjk { font-family: "Cambria",serif; font-size: 12pt; }P.ctl { font-family: "Cambria",serif; font-size: 12pt; } --><p>I agree to submit an annual progress report if this research extends 	beyond one-year, else a semestrial progress report.</p>";}}', 'object'),
(4, 'mn_MN', 'metaSubjectClassUrl', 'http://', 'string'),
(4, 'en_US', 'submissionFeeDescription', '', 'string'),
(4, '', 'templates', 'a:0:{}', 'object'),
(4, '', 'abstractLocales', '', 'array'),
(4, '', 'sourceCurrency', 'USD', 'string'),
(4, '', 'convertionRate', '1', 'int'),
(4, 'en_US', 'title', 'Health Research Portal', 'string'),
(4, 'en_US', 'location', 'Please enter a covering area here', 'string'),
(4, 'en_US', 'navItems', 'a:1:{i:0;a:2:{s:4:"name";s:0:"";s:3:"url";s:0:"";}}', 'object'),
(4, 'en_US', 'progressReportGuidelines', '<p>You are going to upload a progress report. Please "browse" into your computer to find your report and click on the "Save" button to upload the report. <strong>Before</strong> uploading your report, please note the following information:</p><ul><li>Your progress report should follow the template provided in the "About" page on this system.</li><li>The upload of the progress report will result in a new round of review to the committee(s) in charge of the research.</li><li>Only 1 (one) file can be uploaded. If you wish to submit multiple documents, please merge them into one.</li></ul>', 'string'),
(4, '', 'reportDisclaimer', '', 'string'),
(4, 'en_US', 'aboutFiles', '<p>Please click on the name of a file to download it.</p>', 'string'),
(4, 'en_US', 'aboutLinks', '<p>Please click on th name of a link to access it</p>', 'string'),
(4, 'en_US', 'authorGuidelines', '<!-- P { margin-bottom: 0.08in; direction: ltr; color: rgb(0, 0, 0); text-align: justify; }P.western { font-family: "Cambria",serif; font-size: 12pt; }P.cjk { font-family: "Cambria",serif; font-size: 12pt; }P.ctl { font-family: "Cambria",serif; font-size: 12pt; } --> <p class="western" style="margin-bottom: 0in;" lang="en-GB">The following documents are required by Ethics Committees before it can start the review of the proposal. Please check if you have the required documents ready for uploading</p><ul><li>Complete research proposal with an abstract in English.</li><li>Questionnaires, 	consent form and information sheet in English. </li><li>CV of principal investigator. </li><li>If international researcher: the proof of collaboration with a local collaborator institution, as well as with a local co-investigator.</li></ul>', 'string'),
(4, 'en_US', 'protocolAmendmentGuidelines', '<p><strong>Protocol Amendment:</strong></p><p>You are currently amending your research proposal.</p><ul><li>Please correct the details of your research proposal in the step 2 of this submission process.</li><li>If you modified your main proposal file, please update it in the step 3 of this submission process.</li><li>If you modified one or multiple of your suplementary files, please update them in the step 4 of this submission process.</li><li>Please provide the main reason and details of this amendment into the "<em>Comments for the Secretariat</em>" text box of the step 5 of this submission process.</li></ul>', 'string'),
(4, 'en_US', 'completionReportGuidelines', '<p>You are going to upload a completion report. Please "browse" into  your computer to find your report and click on the "Save" button to  upload the report. <strong>Before</strong> uploading your report, please note the following information:</p><ul><li>Please upload only a <strong>PDF file</strong>.</li></ul><ul><li>Only <strong>1 (one) file</strong> can be uploaded. If you wish to submit multiple documents, please merge them into one.</li></ul><ul><li>The upload of the completion report will result in a <strong>new round of review</strong> to the committee(s) in charge of the research.</li></ul><ul><li>Once the completion report accepted by the committee(s), the research will be considered as <strong>completed</strong>.</li></ul><ul><li>All the completed and approved research reports will be made publicly available through research registry in this Portal.</li></ul>', 'string'),
(4, 'en_US', 'saeGuidelines', '<p>You are going to report a serious adverse event. Please "browse" into your  computer to find your report file click on the "Save" button to upload it. <strong>Before</strong> uploading your file, please note the following information:</p><ul><li>The upload of the report will result in a new round of review to the committee(s) in charge of the research.</li><li>Only 1 (one) file can be uploaded. If you wish to submit multiple documents, please merge them into one.</li></ul>', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `meetings`
--

CREATE TABLE IF NOT EXISTS `meetings` (
  `meeting_id` int(11) NOT NULL AUTO_INCREMENT,
  `meeting_date` datetime DEFAULT NULL,
  `meeting_length` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `investigator` tinyint(1) NOT NULL,
  `minutes_status` int(11) NOT NULL DEFAULT '256',
  `section_id` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '4',
  PRIMARY KEY (`meeting_id`),
  KEY `user_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_attendance`
--

CREATE TABLE IF NOT EXISTS `meeting_attendance` (
  `meeting_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `attending` tinyint(1) NOT NULL DEFAULT '3',
  `remarks` text CHARACTER SET utf8,
  `date_reminded` datetime DEFAULT NULL,
  `present` tinyint(1) NOT NULL,
  `reason_for_absence` text CHARACTER SET utf8 NOT NULL,
  `type_of_user` tinyint(1) NOT NULL,
  UNIQUE KEY `meeting_reviewers_pkey` (`meeting_id`,`user_id`),
  KEY `meeting_reviewers_meeting_id` (`meeting_id`),
  KEY `meeting_reviewers_reviewer_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_section_decisions`
--

CREATE TABLE IF NOT EXISTS `meeting_section_decisions` (
  `meeting_id` bigint(20) NOT NULL,
  `section_decision_id` bigint(20) NOT NULL,
  UNIQUE KEY `meeting_submissions_pkey` (`meeting_id`,`section_decision_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `metadata_descriptions`
--

CREATE TABLE IF NOT EXISTS `metadata_descriptions` (
  `metadata_description_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `schema_namespace` varchar(255) NOT NULL,
  `schema_name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `seq` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`metadata_description_id`),
  KEY `metadata_descriptions_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `metadata_description_settings`
--

CREATE TABLE IF NOT EXISTS `metadata_description_settings` (
  `metadata_description_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `metadata_descripton_settings_pkey` (`metadata_description_id`,`locale`,`setting_name`),
  KEY `metadata_description_settings_id` (`metadata_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `minutes_files`
--

CREATE TABLE IF NOT EXISTS `minutes_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) NOT NULL,
  `file_name` varchar(90) CHARACTER SET utf8 NOT NULL,
  `original_file_name` varchar(127) CHARACTER SET utf8 DEFAULT NULL,
  `file_type` varchar(255) CHARACTER SET utf8 NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `type` varchar(40) CHARACTER SET utf8 NOT NULL,
  `date_created` datetime NOT NULL COMMENT 'Or the date uploaded, or the date created',
  `article_id` bigint(20) DEFAULT NULL COMMENT 'null if attendance file',
  PRIMARY KEY (`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE IF NOT EXISTS `notes` (
  `note_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `file_id` bigint(20) DEFAULT NULL,
  `context_id` bigint(20) DEFAULT NULL,
  `contents` text,
  PRIMARY KEY (`note_id`),
  KEY `notes_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `level` bigint(20) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `contents` text,
  `param` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_localized` tinyint(4) NOT NULL DEFAULT '1',
  `product` varchar(20) DEFAULT NULL,
  `context` bigint(20) NOT NULL,
  `assoc_type` bigint(20) NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notifications_by_user` (`product`,`user_id`,`level`,`context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_settings`
--

CREATE TABLE IF NOT EXISTS `notification_settings` (
  `setting_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(64) NOT NULL,
  `setting_value` text,
  `user_id` bigint(20) NOT NULL,
  `product` varchar(20) DEFAULT NULL,
  `context` bigint(20) NOT NULL,
  PRIMARY KEY (`setting_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `oai_resumption_tokens`
--

CREATE TABLE IF NOT EXISTS `oai_resumption_tokens` (
  `token` varchar(32) NOT NULL,
  `expire` bigint(20) NOT NULL,
  `record_offset` int(11) NOT NULL,
  `params` text,
  UNIQUE KEY `oai_resumption_tokens_pkey` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `paypal_transactions`
--

CREATE TABLE IF NOT EXISTS `paypal_transactions` (
  `txn_id` varchar(17) NOT NULL,
  `txn_type` varchar(20) DEFAULT NULL,
  `payer_email` varchar(127) DEFAULT NULL,
  `receiver_email` varchar(127) DEFAULT NULL,
  `item_number` varchar(127) DEFAULT NULL,
  `payment_date` varchar(127) DEFAULT NULL,
  `payer_id` varchar(13) DEFAULT NULL,
  `receiver_id` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`txn_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `plugin_settings`
--

CREATE TABLE IF NOT EXISTS `plugin_settings` (
  `plugin_name` varchar(80) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `journal_id` bigint(20) NOT NULL,
  `setting_name` varchar(80) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `plugin_settings_pkey` (`plugin_name`,`locale`,`journal_id`,`setting_name`),
  KEY `plugin_settings_plugin_name` (`plugin_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `plugin_settings`
--

INSERT INTO `plugin_settings` (`plugin_name`, `locale`, `journal_id`, `setting_name`, `setting_value`, `setting_type`) VALUES
('coinsplugin', '', 0, 'enabled', '1', 'bool'),
('tinymceplugin', '', 0, 'enabled', '1', 'bool'),
('navigationblockplugin', '', 0, 'enabled', '1', 'bool'),
('navigationblockplugin', '', 0, 'seq', '5', 'int'),
('navigationblockplugin', '', 0, 'context', '2', 'int'),
('notificationblockplugin', '', 0, 'enabled', '1', 'bool'),
('notificationblockplugin', '', 0, 'seq', '3', 'int'),
('notificationblockplugin', '', 0, 'context', '2', 'int'),
('userblockplugin', '', 0, 'enabled', '1', 'bool'),
('userblockplugin', '', 0, 'seq', '2', 'int'),
('userblockplugin', '', 0, 'context', '2', 'int'),
('donationblockplugin', '', 0, 'enabled', '1', 'bool'),
('donationblockplugin', '', 0, 'seq', '5', 'int'),
('donationblockplugin', '', 0, 'context', '2', 'int'),
('helpblockplugin', '', 0, 'enabled', '1', 'bool'),
('helpblockplugin', '', 0, 'seq', '1', 'int'),
('helpblockplugin', '', 0, 'context', '2', 'int'),
('developedbyblockplugin', '', 0, 'enabled', '1', 'bool'),
('developedbyblockplugin', '', 0, 'seq', '0', 'int'),
('developedbyblockplugin', '', 0, 'context', '2', 'int'),
('languagetoggleblockplugin', '', 0, 'enabled', '1', 'bool'),
('languagetoggleblockplugin', '', 0, 'seq', '4', 'int'),
('languagetoggleblockplugin', '', 0, 'context', '2', 'int'),
('fontsizeblockplugin', '', 0, 'enabled', '1', 'bool'),
('fontsizeblockplugin', '', 0, 'seq', '6', 'int'),
('fontsizeblockplugin', '', 0, 'context', '2', 'int'),
('tinymceplugin', '', 4, 'enabled', '1', 'bool'),
('developedbyblockplugin', '', 4, 'enabled', '0', 'bool'),
('developedbyblockplugin', '', 4, 'seq', '4', 'int'),
('developedbyblockplugin', '', 4, 'context', '2', 'int'),
('informationblockplugin', '', 4, 'enabled', '0', 'bool'),
('informationblockplugin', '', 4, 'seq', '4', 'int'),
('informationblockplugin', '', 4, 'context', '2', 'int'),
('roleblockplugin', '', 4, 'enabled', '0', 'bool'),
('roleblockplugin', '', 4, 'seq', '2', 'int'),
('roleblockplugin', '', 4, 'context', '2', 'int'),
('subscriptionblockplugin', '', 4, 'enabled', '0', 'bool'),
('subscriptionblockplugin', '', 4, 'seq', '3', 'int'),
('subscriptionblockplugin', '', 4, 'context', '2', 'int'),
('helpblockplugin', '', 4, 'enabled', '0', 'bool'),
('helpblockplugin', '', 4, 'seq', '1', 'int'),
('helpblockplugin', '', 4, 'context', '2', 'int'),
('userblockplugin', '', 4, 'enabled', '1', 'bool'),
('userblockplugin', '', 4, 'seq', '0', 'int'),
('userblockplugin', '', 4, 'context', '2', 'int'),
('notificationblockplugin', '', 4, 'enabled', '1', 'bool'),
('notificationblockplugin', '', 4, 'seq', '1', 'int'),
('notificationblockplugin', '', 4, 'context', '2', 'int'),
('languagetoggleblockplugin', '', 4, 'enabled', '0', 'bool'),
('languagetoggleblockplugin', '', 4, 'seq', '2', 'int'),
('languagetoggleblockplugin', '', 4, 'context', '2', 'int'),
('donationblockplugin', '', 4, 'enabled', '0', 'bool'),
('donationblockplugin', '', 4, 'seq', '5', 'int'),
('donationblockplugin', '', 4, 'context', '2', 'int'),
('navigationblockplugin', '', 4, 'enabled', '0', 'bool'),
('navigationblockplugin', '', 4, 'seq', '2', 'int'),
('navigationblockplugin', '', 4, 'context', '2', 'int'),
('fontsizeblockplugin', '', 4, 'enabled', '0', 'bool'),
('fontsizeblockplugin', '', 4, 'seq', '2', 'int'),
('fontsizeblockplugin', '', 4, 'context', '2', 'int'),
('resolverplugin', '', 4, 'enabled', '1', 'bool'),
('referralplugin', '', 4, 'enabled', '1', 'bool'),
('referralplugin', '', 4, 'exclusions', '#^http://www.google.#\n#^http://www.yahoo.#', 'string'),
('webfeedplugin', '', 4, 'enabled', '1', 'bool'),
('webfeedplugin', '', 4, 'displayPage', 'homepage', 'string'),
('webfeedplugin', '', 4, 'displayItems', '1', 'bool'),
('authorbiosblockplugin', '', 4, 'enabled', '0', 'bool'),
('keywordcloudblockplugin', '', 4, 'enabled', '0', 'bool'),
('readingtoolsblockplugin', '', 4, 'enabled', '0', 'bool'),
('relateditemsblockplugin', '', 4, 'enabled', '0', 'bool'),
('webfeedblockplugin', '', 4, 'enabled', '0', 'bool'),
('authorbiosblockplugin', '', 4, 'context', '2', 'int'),
('authorbiosblockplugin', '', 4, 'seq', '2', 'int'),
('manualpayment', '', 4, 'manualInstructions', 'Instructions for payment.', 'string'),
('translatorplugin', '', 4, 'enabled', '1', 'bool'),
('relateditemsblockplugin', '', 4, 'context', '2', 'int'),
('relateditemsblockplugin', '', 4, 'seq', '3', 'int'),
('linksblockplugin', '', 4, 'enabled', '1', 'bool'),
('linksblockplugin', '', 4, 'context', '2', 'int'),
('linksblockplugin', '', 4, 'seq', '2', 'int');

-- --------------------------------------------------------

--
-- Table structure for table `processes`
--

CREATE TABLE IF NOT EXISTS `processes` (
  `process_id` varchar(23) NOT NULL,
  `process_type` tinyint(4) NOT NULL,
  `time_started` bigint(20) NOT NULL,
  `obliterated` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `processes_pkey` (`process_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `published_articles`
--

CREATE TABLE IF NOT EXISTS `published_articles` (
  `pub_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `issue_id` bigint(20) NOT NULL,
  `date_published` datetime NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `views` int(11) NOT NULL DEFAULT '0',
  `access_status` tinyint(4) NOT NULL DEFAULT '0',
  `public_article_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pub_id`),
  UNIQUE KEY `published_articles_article_id` (`article_id`),
  KEY `published_articles_issue_id` (`issue_id`),
  KEY `published_articles_public_article_id` (`public_article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `queued_payments`
--

CREATE TABLE IF NOT EXISTS `queued_payments` (
  `queued_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `payment_data` text,
  PRIMARY KEY (`queued_payment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `referrals`
--

CREATE TABLE IF NOT EXISTS `referrals` (
  `referral_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `url` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  `link_count` bigint(20) NOT NULL,
  PRIMARY KEY (`referral_id`),
  UNIQUE KEY `referral_article_id` (`article_id`,`url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `referral_settings`
--

CREATE TABLE IF NOT EXISTS `referral_settings` (
  `referral_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `referral_settings_pkey` (`referral_id`,`locale`,`setting_name`),
  KEY `referral_settings_referral_id` (`referral_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `review_assignments`
--

CREATE TABLE IF NOT EXISTS `review_assignments` (
  `review_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `decision_id` bigint(20) NOT NULL,
  `reviewer_id` bigint(20) NOT NULL,
  `competing_interests` text,
  `regret_message` text,
  `recommendation` tinyint(4) DEFAULT NULL,
  `date_assigned` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `date_confirmed` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `date_acknowledged` datetime DEFAULT NULL,
  `date_due` datetime DEFAULT NULL,
  `date_response_due` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `reminder_was_automatic` tinyint(4) NOT NULL DEFAULT '0',
  `declined` tinyint(4) NOT NULL DEFAULT '0',
  `replaced` tinyint(4) NOT NULL DEFAULT '0',
  `cancelled` tinyint(4) NOT NULL DEFAULT '0',
  `reviewer_file_id` bigint(20) DEFAULT NULL,
  `date_rated` datetime DEFAULT NULL,
  `date_reminded` datetime DEFAULT NULL,
  `quality` tinyint(4) DEFAULT NULL,
  `review_method` tinyint(4) NOT NULL DEFAULT '1',
  `step` tinyint(4) NOT NULL DEFAULT '1',
  `review_form_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `review_assignments_reviewer_id` (`reviewer_id`),
  KEY `review_assignments_form_id` (`review_form_id`),
  KEY `review_assignments_decision_id` (`decision_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `review_forms`
--

CREATE TABLE IF NOT EXISTS `review_forms` (
  `review_form_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `seq` double DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `review_form_elements`
--

CREATE TABLE IF NOT EXISTS `review_form_elements` (
  `review_form_element_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `review_form_id` bigint(20) NOT NULL,
  `seq` double DEFAULT NULL,
  `element_type` bigint(20) DEFAULT NULL,
  `required` tinyint(4) DEFAULT NULL,
  `included` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`review_form_element_id`),
  KEY `review_form_elements_review_form_id` (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `review_form_element_settings`
--

CREATE TABLE IF NOT EXISTS `review_form_element_settings` (
  `review_form_element_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `review_form_element_settings_pkey` (`review_form_element_id`,`locale`,`setting_name`),
  KEY `review_form_element_settings_review_form_element_id` (`review_form_element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `review_form_responses`
--

CREATE TABLE IF NOT EXISTS `review_form_responses` (
  `review_form_element_id` bigint(20) NOT NULL,
  `review_id` bigint(20) NOT NULL,
  `response_type` varchar(6) DEFAULT NULL,
  `response_value` text,
  KEY `review_form_responses_pkey` (`review_form_element_id`,`review_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `review_form_settings`
--

CREATE TABLE IF NOT EXISTS `review_form_settings` (
  `review_form_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `review_form_settings_pkey` (`review_form_id`,`locale`,`setting_name`),
  KEY `review_form_settings_review_form_id` (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  UNIQUE KEY `roles_pkey` (`journal_id`,`user_id`,`role_id`),
  KEY `roles_journal_id` (`journal_id`),
  KEY `roles_user_id` (`user_id`),
  KEY `roles_role_id` (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`journal_id`, `user_id`, `role_id`) VALUES
(0, 16, 1),
(4, 16, 16),
(4, 16, 256),
(4, 16, 65536);

-- --------------------------------------------------------

--
-- Table structure for table `rt_contexts`
--

CREATE TABLE IF NOT EXISTS `rt_contexts` (
  `context_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version_id` bigint(20) NOT NULL,
  `title` varchar(120) NOT NULL,
  `abbrev` varchar(32) NOT NULL,
  `description` text,
  `cited_by` tinyint(4) NOT NULL DEFAULT '0',
  `author_terms` tinyint(4) NOT NULL DEFAULT '0',
  `define_terms` tinyint(4) NOT NULL DEFAULT '0',
  `geo_terms` tinyint(4) NOT NULL DEFAULT '0',
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`context_id`),
  KEY `rt_contexts_version_id` (`version_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=989 ;

--
-- Dumping data for table `rt_contexts`
--

INSERT INTO `rt_contexts` (`context_id`, `version_id`, `title`, `abbrev`, `description`, `cited_by`, `author_terms`, `define_terms`, `geo_terms`, `seq`) VALUES
(742, 58, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(743, 58, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(744, 58, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(745, 58, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 3),
(746, 58, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 4),
(747, 58, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 5),
(748, 58, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 6),
(749, 58, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(750, 58, 'Data sets', 'Data sets', 'Provides access to agricultural statistics.', 0, 0, 0, 0, 8),
(751, 58, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 9),
(752, 58, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(753, 58, 'Web search', 'Web search', 'Enter search terms for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(754, 59, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(755, 59, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(756, 59, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(757, 59, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 3),
(758, 59, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 4),
(759, 59, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 5),
(760, 59, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 6),
(761, 59, 'Databases', 'Databases', 'Art & Architecture Databases', 0, 0, 0, 0, 7),
(762, 59, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 8),
(763, 59, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 9),
(764, 59, 'Teaching files', 'Teaching files', 'Provide educators with quick and easy access to the learning objects and lesson materials found in these databases that would help with the teaching of concepts and materials in their field.', 0, 0, 0, 0, 10),
(765, 59, 'e-Journals', 'e-Journals', 'Electronic Journals', 0, 0, 0, 0, 11),
(766, 59, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 12),
(767, 59, 'Web search', 'Web search', 'Enter a search term for Internet resources through Google search engine.', 0, 0, 0, 0, 13),
(768, 60, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(769, 60, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(770, 60, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(771, 60, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(772, 60, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 4),
(773, 60, 'Multimedia', 'Multimedia', 'Multimedia Resources', 0, 0, 0, 0, 5),
(774, 60, 'Astro data', 'Astro data', 'Provide access to astronomy data.', 0, 0, 0, 0, 6),
(775, 60, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(776, 60, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(777, 60, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(778, 60, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(779, 60, 'Web search', 'Web search', 'Enter a search term for Internet resources through Google search engine.', 0, 0, 0, 0, 11),
(780, 61, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(781, 61, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(782, 61, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(783, 61, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(784, 61, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 4),
(785, 61, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 5),
(786, 61, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(787, 61, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 7),
(788, 61, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 8),
(789, 61, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(790, 61, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 10),
(791, 62, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(792, 62, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 1),
(793, 62, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 2),
(794, 62, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 3),
(795, 62, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 4),
(796, 62, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(797, 62, 'e-Journals', 'e-Journals', 'Provide pop-up window for entering open-access and full-text e-Journals relevant to your field.', 0, 0, 0, 0, 6),
(798, 62, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 7),
(799, 62, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 8),
(800, 62, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(801, 62, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(802, 62, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(803, 63, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(804, 63, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(805, 63, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(806, 63, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(807, 63, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 4),
(808, 63, 'Relevant portals', 'Relevant portals', 'Portals related to chemistry', 0, 0, 0, 0, 5),
(809, 63, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 6),
(810, 63, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(811, 63, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(812, 63, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(813, 63, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(814, 63, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(815, 64, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(816, 64, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(817, 64, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(818, 64, 'Cognitive theory', 'Cognitive theory', 'Check the encyclopedic entries to give you the foundationof cognitive theory.', 0, 0, 0, 0, 3),
(819, 64, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 4),
(820, 64, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(821, 64, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(822, 64, 'Multimedia', 'Multimedia', 'Multimedia resources for Cognitive Sciences', 0, 0, 0, 0, 7),
(823, 64, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(824, 64, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(825, 64, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(826, 64, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(827, 65, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(828, 65, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(829, 65, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(830, 65, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(831, 65, 'Databases', 'Databases', 'Databases containing information related to Computing Science', 0, 0, 0, 0, 4),
(832, 65, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(833, 65, 'Tech. reports', 'Tech. reports', 'Provide gateway to technical report collections.', 0, 0, 0, 0, 6),
(834, 65, 'Patents', 'Patents', 'Access to Canada, U.S. and Europe patent information.', 0, 0, 0, 0, 7),
(835, 65, 'Standards', 'Standards', 'Access to standards information that is frequently consulted by computer scientists.', 0, 0, 0, 0, 8),
(836, 65, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 9),
(837, 65, 'Multimedia', 'Multimedia', 'Multimedia resources', 0, 0, 0, 0, 10),
(838, 65, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(839, 65, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 12),
(840, 65, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 13),
(841, 65, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 14),
(842, 66, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(843, 66, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(844, 66, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(845, 66, 'Working papers', 'Working papers', 'Search the largest online, free research paper collections in economics.', 0, 0, 0, 0, 3),
(846, 66, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 4),
(847, 66, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 5),
(848, 66, 'Nat''l statistics', 'Nat''l statistics', 'Provides access to statistics in economic studies.', 0, 0, 0, 0, 6),
(849, 66, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 7),
(850, 66, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 8),
(851, 66, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(852, 66, 'Government policy', 'Gov Policy', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(853, 66, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(854, 66, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(855, 67, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(856, 67, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(857, 67, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(858, 67, 'e-Journals', 'e-Journals', 'Provide pop-up window for entering open-access and full-text e-Journals relevant to your field.', 0, 0, 0, 0, 3),
(859, 67, 'Related theory', 'Related theory', 'Access to published scholarly articles and studies in the foundations of education, and in related disciplines outside the field of education, which contribute to the advancement of educational theory.', 0, 0, 0, 0, 4),
(860, 67, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 5),
(861, 67, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 6),
(862, 67, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(863, 67, 'Multimedia', 'Multimedia', 'Multimedia Content', 0, 0, 0, 0, 8),
(864, 67, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(865, 67, 'Relevant portals', 'Relevant portals', 'Education-related Portals', 0, 0, 0, 0, 10),
(866, 67, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 11),
(867, 67, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 12),
(868, 67, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 13),
(869, 68, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(870, 68, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(871, 68, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(872, 68, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 3),
(873, 68, 'Relevant portals', 'Relevant portals', 'Environmental resource portals', 0, 0, 0, 0, 4),
(874, 68, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 5),
(875, 68, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(876, 68, 'Data sets', 'Data sets', 'Provides access to statistics in environmental studies.', 0, 0, 0, 0, 7),
(877, 68, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 8),
(878, 68, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(879, 68, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 10),
(880, 69, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(881, 69, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(882, 69, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(883, 69, 'Relevant portals', 'Relevant portals', 'General Science resource portals', 0, 0, 0, 0, 3),
(884, 69, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 4),
(885, 69, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(886, 69, 'Directories', 'Directories', 'Access to information of research institutions', 0, 0, 0, 0, 6),
(887, 69, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(888, 69, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(889, 69, 'Multimedia', 'Multimedia', 'Multimedia content', 0, 0, 0, 0, 9),
(890, 69, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 10),
(891, 69, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(892, 69, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(893, 70, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(894, 70, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(895, 70, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 2),
(896, 70, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(897, 70, 'Book reviews', 'Book reviews', 'Check online scholary book review resources.', 0, 0, 0, 0, 4),
(898, 70, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 5),
(899, 70, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(900, 70, 'Quotations', 'Quotations', 'Search familiear or famous quotation resources on the Internet', 0, 0, 0, 0, 7),
(901, 70, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 8),
(902, 70, 'Resources', 'Resources', 'General Resources', 0, 0, 0, 0, 9),
(903, 70, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(904, 70, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(905, 71, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(906, 71, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(907, 71, 'Gov''t policy', 'Gov''t policy', 'Check various government resources.', 0, 0, 0, 0, 2),
(908, 71, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(909, 71, 'Lit critics', 'Literary Critics', 'Search critical and biographical websites about authors and their works that can be browsed by author, by title, or by nationality and literary period.', 0, 0, 0, 0, 4),
(910, 71, 'Book reviews', 'Book reviews', 'Click on the search urls to check for book reviews.', 0, 0, 0, 0, 5),
(911, 71, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 6),
(912, 71, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 7),
(913, 71, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 8),
(914, 71, 'Relevant portals', 'Relevant portals', 'Relevant portals', 0, 0, 0, 0, 9),
(915, 71, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 10),
(916, 71, 'Related texts', 'Related texts', 'Provide online access to full text resources in Humanities.', 0, 0, 0, 0, 11),
(917, 71, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 12),
(918, 71, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 13),
(919, 71, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 14),
(920, 71, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 15),
(921, 72, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(922, 72, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(923, 72, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(924, 72, 'Multimedia', 'Multimedia', 'Multimedia content', 0, 0, 0, 0, 3),
(925, 72, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 4),
(926, 72, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(927, 72, 'Government health sites', 'Gov Health Sites', 'Access to health information resources provided by govenment.', 0, 0, 0, 0, 6),
(928, 72, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 7),
(929, 72, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 8),
(930, 72, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 9),
(931, 72, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(932, 72, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 11),
(933, 72, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 12),
(934, 72, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 13),
(935, 73, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(936, 73, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(937, 73, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(938, 73, 'Databases', 'Databases', 'Databases', 0, 0, 0, 0, 3),
(939, 73, 'Math theory', 'Math theory', 'Access to glossary of terms ranges from undergraduate to research level.', 0, 0, 0, 0, 4),
(940, 73, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 5),
(941, 73, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 6),
(942, 73, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(943, 73, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(944, 73, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(945, 73, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(946, 73, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(947, 74, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(948, 74, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(949, 74, 'e-Journals', 'e-Journals', 'Electronic Journals', 0, 0, 0, 0, 2),
(950, 74, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 3),
(951, 74, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 4),
(952, 74, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 5),
(953, 74, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 6),
(954, 74, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 7),
(955, 74, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 8),
(956, 74, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 9),
(957, 74, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 10),
(958, 74, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(959, 74, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(960, 75, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(961, 75, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(962, 75, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(963, 75, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(964, 75, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 4),
(965, 75, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(966, 75, 'Multimedia', 'Multimedia', 'Multimedia content', 0, 0, 0, 0, 6),
(967, 75, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 7),
(968, 75, 'Databases', 'Databases', 'Databases', 0, 0, 0, 0, 8),
(969, 75, 'Relevant portals', 'Relevant portals', 'Relevant portals', 0, 0, 0, 0, 9),
(970, 75, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 10),
(971, 75, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(972, 75, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(973, 76, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(974, 76, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(975, 76, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(976, 76, 'Book reviews', 'Book reviews', 'Click on the search urls to check for book reviews.', 0, 0, 0, 0, 3),
(977, 76, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 4),
(978, 76, 'Surveys', 'Surveys', 'Access to important surveys in social science.', 0, 0, 0, 0, 5),
(979, 76, 'Soc sci data', 'Soc sci data', 'Provides access to a vast archive of social science data for research and instruction.', 0, 0, 0, 0, 6),
(980, 76, 'Social theories', 'Social theories', 'Search sites contain information on social theories.', 0, 0, 0, 0, 7),
(981, 76, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 8),
(982, 76, 'Databases', 'Databases', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 9),
(983, 76, 'Relevant portals', 'Relevant portals', 'Relevant portals', 0, 0, 0, 0, 10),
(984, 76, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 11),
(985, 76, 'Legal materials', 'Legal materials', 'Porvides free Internet access to legal materials of major countries.', 0, 0, 0, 0, 12),
(986, 76, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 13),
(987, 76, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 14),
(988, 76, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 15);

-- --------------------------------------------------------

--
-- Table structure for table `rt_searches`
--

CREATE TABLE IF NOT EXISTS `rt_searches` (
  `search_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `title` varchar(120) NOT NULL,
  `description` text,
  `url` text,
  `search_url` text,
  `search_post` text,
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`search_id`),
  KEY `rt_searches_context_id` (`context_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5125 ;

--
-- Dumping data for table `rt_searches`
--

INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(3844, 742, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(3845, 742, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(3846, 742, 'Rice bibliography', 'The Rice Bibliography was begun in 1961 and is now the world''s largest source of scientific information about rice. Almost 8,000 new references are added each year and these cover all subjects related to rice culture.', 'http://ricelib.irri.cgiar.org:81/search/w', 'http://ricelib.irri.cgiar.org:81/search/?searchtype=w&searcharg={$formKeywords}', NULL, 2),
(3847, 742, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(3848, 742, 'AgEcon Search: Research in agricultural Economics', 'AgEcon Search is designed to electronically distribute reports of scholarly research in the field of agricultural economics.', 'http://agecon.lib.umn.edu/', 'http://agecon.lib.umn.edu/cgi-bin/view.pl?bool=AND&fields=author&detail=0&keywords={$formKeywords}', NULL, 4),
(3849, 742, 'The Digital Library of the Commons (DLC)', 'DLC is a gateway to the international literature on the commons . This site contains a Working Paper Archive of author-submitted papers, as well as full-text conference papers, dissertations, working papers and pre-prints, and reports.', 'http://dlc.dlib.indiana.edu/', 'http://dlc.dlib.indiana.edu/perl/search?abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear_srchtype=ALL&_action_search=Search&abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear={$formKeywords}', NULL, 5),
(3850, 742, 'PESTIS document database', 'The Pesticide Information Service (PESTIS) is an on-line database for the pesticide use reform and sustainable agriculture communities, made available on the EcoNet computer network. It contains over 400 news items, action alerts, newsletter articles and fact sheets.', 'http://www.panna.org/resources/pestis.html', 'http://www.panna.org/system/searchResults.html?p=1&lang=en&include=&exclude=&penalty=.05&mode=&searchScope=all&q={$formKeywords}', NULL, 6),
(3851, 742, 'Common Names for Plant Diseases', 'This resource is an electronic version of: Common names for plant diseases, 1994. Published: St. Paul, Minn.: APS Press, 1994. This compilation provides an updated, combined version of lists of names published in Phytopathology News and Plant Disease.', 'http://www.apsnet.org/online/common/', 'http://www.apsnet.org/online/common/query.asp', 'scope=/online/common/names/&FreeText=on&SearchString={$formKeywords}', 7),
(3852, 742, 'Vegetable MD online', 'Vegetable MD Online was developed to provide access to the many Vegetable Disease Fact Sheets produced over the years by Media Services at Cornell. The addition of color photographs enhances the use of these sheets for plant disease diagnosis. The fact sheets also include information about planting methods, irrigation, weed control, insects, handling, field selection, and other issues related to vegetables and their cultivation.', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp?target={$formKeywords}', NULL, 8),
(3853, 742, 'VITIS-VEA', 'VITIS-VEA, Viticulture and Enology Abstracts is an international German or English-language publications database in the field of viticulture and enology. It covers grapevine morphology, physiology, and biochemistry, soil science, genetics and grapevine breeding, phytopathology and grapevine protection, cellar techniques, economics of viticulture and enology, and the microbiology of wine.', 'http://vitis-vea.zadi.de/stichwortsuche_eng.htm', 'http://vitis-vea.zadi.de/VITISVEA_ENG/SDF?STICHWORT_O=includes&FORM_F1=AUT1&FORM_SO=Ascend&STICHWORT={$formKeywords}', NULL, 9),
(3854, 742, 'World Agricultural Information Centre (WAICENT)', 'This site contains information management and dissemination on desertification, gender and sustainable development, food standards, animal genetic resources, post-harvest operations, agro-biodiversity and food systems in urban centres.', 'http://www.fao.org/waicent/index_en.asp', 'http://www.fao.org/waicent/search/simple_s_result.asp?publication=1&webpage=2&photo=3&press=5&CGIAR=1&QueryString={$formKeywords}', NULL, 10),
(3855, 742, 'FAO document repository', 'FAO Document Repository collects and disseminates on the Internet full FAO documents and publications as well as selected non-FAO publications. Three types of searches are provided and several language options are available.', 'http://www.fao.org/documents/', 'http://www.fao.org/documents/advanced_s_result.asp?form_c=AND&RecordsPerPage=50&QueryString={$formKeywords}', NULL, 11),
(3856, 743, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(3857, 743, 'FAO Glossary of Biotechnology for Food and Agriculture', 'This site provides a tabbed list of words and their definitions, but no search function.  Online searches are free.  There is a bound book version of the dictionary available for sale.', 'http://www.fao.org/biotech/index_glossary.asp', 'http://www.fao.org/biotech/find-form-n.asp', 'terms={$formKeywords}', 1),
(3858, 743, 'NAL Agricultural Thesaurus', 'NAL Agricultural Thesaurus was created to meet the needs of the United States Department of Agriculture (USDA), Agricultural Research Service (ARS), for an agricultural thesaurus. NAL Agricultural Thesaurus is for anyone describing, organizing and classifying agricultural resources such as: books, articles, catalogs, databases, patents, games, educational materials, pictures, slides, film, videotapes, software, other electronic media, or websites. It is organized into 17 subject categories.', 'http://agclass.nal.usda.gov/agt/agt.htm', 'http://agclass.nal.usda.gov/agt/mtw.exe?k=default&p=A&l=60&s=2&t=1&n=100&w={$formKeywords}', NULL, 2),
(3859, 743, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(3860, 743, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(3861, 743, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(3862, 743, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(3863, 744, 'AgEcon Search: Research in agricultural Economics', 'AgEcon Search is designed to electronically distribute reports of scholarly research in the field of agricultural economics.', 'http://agecon.lib.umn.edu/', 'http://agecon.lib.umn.edu/cgi-bin/view.pl?bool=AND&fields=key&detail=0&keywords={$formKeywords}', NULL, 0),
(3864, 744, 'CropSEARCH', 'Index to plant lists of hundreds of crop species.', 'http://www.hort.purdue.edu/newcrop/SearchEngine.html', 'http://index.cc.purdue.edu:8765/query.html?col=pumerge&charset=iso-8859-1&ht=0&qp=%2Bsite%3Ahort.purdue.edu&qs=&qc=&pw=100%25&ws=0&la=en&qm=0&st=1&nh=10&lk=1&rf=0&rq=0&si=0&puhead=header.html&pufoot=footer.html&qt={$formKeywords}', NULL, 1),
(3865, 744, 'The Digital Library of the Commons (DLC)', 'DLC is a gateway to the international literature on the commons . This site contains a Working Paper Archive of author-submitted papers, as well as full-text conference papers, dissertations, working papers and pre-prints, and reports.', 'http://dlc.dlib.indiana.edu/', 'http://dlc.dlib.indiana.edu/perl/search?abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear_srchtype=ALL&_action_search=Search&abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear={$formKeywords}', NULL, 2),
(3866, 744, 'FAS online', 'The Foreign Agricultural Service (FAS) of the U.S. Department of Agriculture (USDA) produces hundreds of documents each year that chart and analyze production, consumption, trade flows, and market opportunities for about 100 agricultural products. Includes market-and commodity-specific reports, data and statistics, news, trade leads, information on export and import programs, and more.', 'http://www.fas.usda.gov/fassearch.asp', 'http://www.fas.usda.gov/FASSearch_results_H.asp?SearchString={$formKeywords}', NULL, 3),
(3867, 744, 'PESTIS document database', 'The Pesticide Information Service (PESTIS) is an on-line database for the pesticide use reform and sustainable agriculture communities, made available on the EcoNet computer network. It contains over 400 news items, action alerts, newsletter articles and fact sheets.', 'http://www.panna.org/resources/pestis.html', 'http://www.panna.org/system/searchResults.html?p=1&lang=en&include=&exclude=&penalty=.05&mode=&searchScope=all&q={$formKeywords}', NULL, 4),
(3868, 744, 'PlantFacts', 'PlantFacts includes guides for answering plant-related questions from 46 different universities and government institutions across the United States and Canada. Over 20,000 pages of Extension fact sheets and bulletins provide a concentrated source of plant-related information. PlantFacts has merged several digital collections developed at Ohio State University to become an international knowledge bank and multimedia learning center.', 'http://plantfacts.osu.edu/', 'http://plantfacts.osu.edu/action.lasso?-Layout=input&-Search=-nothing&-Response=results_list2.lasso&-AnyError=error.lasso&searchitem={$formKeywords}', NULL, 5),
(3869, 744, 'National PLANTS database', 'Focuses on the vascular and nonvascular plants of the United States and its territories. The PLANTS database includes checklists, distributional data, crop information, plants symbols, plant growth data, references and other plant information.', 'http://plants.usda.gov/', 'http://www.nrcs.usda.gov/search.asp?site=NPDC&ct=ALL&qu={$formKeywords}', NULL, 6),
(3870, 744, 'Common Names for Plant Diseases', 'This resource is an electronic version of: Common names for plant diseases, 1994. Published: St. Paul, Minn.: APS Press, 1994. This compilation provides an updated, combined version of lists of names published in Phytopathology News and Plant Disease.', 'http://www.apsnet.org/online/common/', 'http://www.apsnet.org/online/common/query.asp', 'scope=/online/common/names/&FreeText=on&SearchString={$formKeywords}', 7),
(3871, 744, 'Rice bibliography', 'The Rice Bibliography was begun in 1961 and is now the world''s largest source of scientific information about rice. Almost 8,000 new references are added each year and these cover all subjects related to rice culture.', 'http://ricelib.irri.cgiar.org:81/search/w', 'http://ricelib.irri.cgiar.org:81/search/w?SEARCH={$formKeywords}', NULL, 8),
(3872, 744, 'Vegetable MD online', 'Vegetable MD Online was developed to provide access to the many Vegetable Disease Fact Sheets produced over the years by Media Services at Cornell. The addition of color photographs enhances the use of these sheets for plant disease diagnosis. The fact sheets also include information about planting methods, irrigation, weed control, insects, handling, field selection, and other issues related to vegetables and their cultivation.', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp?target={$formKeywords}', NULL, 9),
(3873, 744, 'VITIS-VEA', 'VITIS-VEA, Viticulture and Enology Abstracts is an international German or English-language publications database in the field of viticulture and enology. It covers grapevine morphology, physiology, and biochemistry, soil science, genetics and grapevine breeding, phytopathology and grapevine protection, cellar techniques, economics of viticulture and enology, and the microbiology of wine.', 'http://vitis-vea.zadi.de/stichwortsuche_eng.htm', 'http://vitis-vea.zadi.de/VITISVEA_ENG/SDF?STICHWORT_O=includes&FORM_F1=AUT1&FORM_SO=Ascend&STICHWORT={$formKeywords}', NULL, 10),
(3874, 745, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(3875, 745, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(3876, 745, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(3877, 745, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(3878, 745, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(3879, 745, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(3880, 745, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(3881, 746, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(3882, 746, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(3883, 746, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(3884, 746, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(3885, 746, 'E-STREAMS', 'E-STREAMS: Electronic reviews of Science & Technology References covering Engineering, Agriculture, Medicine and Science. Each issue contains 30+ STM reviews, covering new titles in Engineering, Agriculture, Medicine and Science. Each review is signed, and includes the email address of the reviewer. The reviews feature short TOCs, a list of contributors and bibliographic information.', 'http://www.e-streams.com/', 'http://www.e-streams.com/c3/cgi-bin/search.pl', 'boolean=AND&case=Insensitive&terms={$formKeywords}', 4),
(3886, 747, 'AgNIC', 'AgNIC is a guide to quality agricultural information on the Internet as selected by the National Agricultural Library, Land-Grant Universities, and other institutions.', 'http://www.agnic.org/', 'http://www.agnic.org/advsearch/?submitted=1&searchtype=AgResource&keywords={$formKeywords}', NULL, 0),
(3887, 747, 'AGRICOLA articles (NAL Web: 1982- )', 'AGRICOLA covers the areas of agriculture, agricultural administration, agricultural laws and legislation, agricultural regulations, agricultural economics, agricultural education and training, agricultural extension and advisory work, agricultural engineering, agricultural products, animal science, entomology, aquatic science, fisheries, feed science, food science, food products, forestry, geography, meteorology, climatology, history, home economics, human ecology, household textiles and clothing, human nutrition, natural resources, pesticides, plant science, pollution, soil science, rural sociology, rural development, and human parasitology. It indexes journal articles and other publications as well as audiovisual materials, maps, books, software, conference proceedings, theses, research reports and government documents.', 'http://agricola.nal.usda.gov/', 'http://agricola.nal.usda.gov/cgi-bin/Pwebrecon.cgi?BOOL1=all+of+these&FLD1=Keyword+Anywhere+%28GKEY%29&GRP1=AND+with+next+set&SAB2=&BOOL2=any+of+these&FLD2=Subject+%28SKEY%29&GRP2=AND+with+next+set&SAB3=&BOOL3=as+a+phrase&FLD3=Title+%28TKEY%29&GRP3=AND+with+next+set&SAB4=&BOOL4=as+a+phrase&FLD4=Author+Name+%28NKEY%29&PID=4294&SEQ=20060511212523&CNT=25&HIST=1&SAB1={$formKeywords}', NULL, 1),
(3888, 747, 'AgriSurf! - The Farmers Search Engine', 'From family farms to agribusiness, almost 20,000 sites "hand picked by agricultural experts" are arranged in categories, indexed, rated for speed and reliability of access, labeled with the flag of their country of origin, and may be searched using keywords. Annotations are taken from the sites'' self-descriptions.', 'http://www.agrisurf.com/agrisurfscripts/agrisurf.asp?index=_25', 'http://www.agrisurf.com/?cx=009099332680230023402%3Asp1yugldxek&cof=FORID%3A10&q={$formKeywords}', NULL, 2),
(3889, 747, 'Farms.com', 'Established in 1995, Farms.com has been instrumental in the development of the Agricultural Internet. Now recognized throughout North America as the leading Agriculture Internet resource, Farms.com has successfully combined agri-business experience with the vast power of the Internet to provide producers with the information, services, and markets they need to make sound business decisions and increase profitability.', 'http://canada.eharvest.com/', 'http://www.agrisurf.com/agrisurfscripts/inc/farms/search.asp?index=_25&rbtn=ALL&ft=on&SearchString={$formKeywords}', NULL, 3),
(3890, 747, 'Scirus', 'Scirus is the most comprehensive science-specific search engine on the Internet. Driven by the latest search engine technology, Scirus searches over 150 million science-specific Web pages.', 'http://www.scirus.com/srsapp/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 4),
(3891, 747, 'World Agricultural Information Centre (WAICENT)', 'This site contains information management and dissemination on desertification, gender and sustainable development, food standards, animal genetic resources, post-harvest operations, agro-biodiversity and food systems in urban centres.', 'http://www.fao.org/waicent/index_en.asp', 'http://www.fao.org/waicent/search/simple_s_result.asp?publication=1&webpage=2&photo=3&press=5&CGIAR=1&QueryString={$formKeywords}', NULL, 5),
(3892, 747, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 6),
(3893, 747, 'Agriculture 21', 'Contains news and features on agricultural and food-supply issues worldwide, as well as downloadable publications, links to databases, subject guides, and access to divisions of the FAO Agriculture Department. Includes search engine.', 'http://www.fao.org/ag/', 'http://www.fao.org/ag/search/agfind.asp?Find=Find&SortBy=rank[d]&Scope=/ag&CiuserParam3=agfind.asp&lang=en&FMMod=any&FSRest=<&FSRestval=any&Action=Execute&SearchString={$formKeywords}', NULL, 7),
(3894, 748, 'FAO document repository', 'FAO Document Repository collects and disseminates on the Internet full FAO documents and publications as well as selected non-FAO publications. Three types of searches are provided and several language options are available.', 'http://www.fao.org/documents/', 'http://www.fao.org/documents/advanced_s_result.asp?form_c=AND&RecordsPerPage=50&QueryString={$formKeywords}', NULL, 0),
(3895, 748, 'National Ag Safety Databases (NASD)', 'The National Ag Safety Databases (NASD) is a database of materials devoted to increased safety, health and injury prevention in agriculture, listed by topic and state. Video resources are indexed, there are special listings for conference proceedings, posters and other materials.', 'http://www.cdc.gov/search.htm', 'http://www.cdc.gov/search.do?action=search&x=0&y=0&queryText={$formKeywords}', NULL, 1),
(3896, 748, 'E-Answers', 'A collection of over 250,000 pages of full text electronic documents from the Extension Services and Agricultural Experiment Stations of over fifteen states of the United States, searchable by keyword and by region of the country. A single-stop access to a large number of useful and reputable publications on topics in agriculture, family topics, consumer issues, environment, economics, and public policy.', 'http://e-answers.adec.edu/', 'http://e-answers.adec.edu/cgi-bin/htsearch?config=ea-all&words={$formKeywords}', NULL, 2),
(3897, 748, 'National Plants Databases', 'From the U.S. Department of Agriculture Natural Resources Conservation Service, "The PLANTS Databases is a single source of standardized information about plants. . . focuse[d] on vascular plants, mosses, liverworts, hornworts, and lichens of the U.S. and its territories. The PLANTS Databases includes names, checklists, automated tools, identification information, species abstracts, distributional data, crop information, plant symbols, plant growth data, plant materials information, plant links, references, and other plant information." An FAQ section linked to the banner provides additional information.', 'http://plants.usda.gov/', 'http://www.nrcs.usda.gov/search.asp?site=NPDC&ct=ALL&qu={$formKeywords}', NULL, 3),
(3898, 749, 'Agricultural Conferences, Meetings, Seminars Calendar', 'This calendar strives to include all major national and international agricultural meetings and others of apparent scientific importance. We will incorporate local level meetings only when they seem to be scientifically significant. Meetings outside our purview will be left to appropriate local, regional, or organization-specific calendars. We do plan to create links to such calendars when they are available. Provides a central repository for information and links to information concerning upcoming agricultural conferences, with emphasis on those of scientific significance.', 'http://www.agnic.org/mtg/', 'http://www.agnic.org/events/index.html?submitted=1&searchtype=keyword&keywords={$formKeywords}', NULL, 0),
(3899, 749, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 1),
(3900, 749, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 2),
(3901, 750, 'Breeds of Livestock', 'Web site allows users to search for information on livestock by world region or by species name. Data is available on cattle, horses, swine, goats, and sheep and organized as encyclopedia entries.', 'http://www.ansi.okstate.edu/breeds/', 'http://www.google.com/search?q=site%3Aansi.okstate.edu+breeds+', NULL, 0),
(3902, 750, 'USDA Economics and Statistics System', 'USDA Economics and Statistics System contains more than 400 reports and datasets from the economics agencies of the U.S. Department of Agriculture. These materials cover U.S. and international agriculture and related topics. Most reports are text files that contain time-sensitive information. Most data sets are in spreadsheet format and include time-series data that are updated yearly.', 'http://usda.mannlib.cornell.edu/', 'http://usda.mannlib.cornell.edu/MannUsda/search.do?action=fullKeywordSearch&titlesearch=titlesearch&includeAMS=includeAMS&simple_search_term={$formKeywords}', NULL, 1),
(3903, 751, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(3904, 751, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&frm=smp.x&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&p00={$formKeywords}', NULL, 1),
(3905, 751, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is raning from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(3906, 751, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(3907, 752, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(3908, 752, 'Agriculture 21', 'This site contains news and features on agricultural and food-supply issues worldwide, as well as downloadable publications, links to databases, subject guides, and access to divisions of the FAO Agriculture Department. Includes search engine.', 'http://www.fao.org/ag/', 'http://www.fao.org/ag/search/agfind.asp?SortBy=rank%5Bd%5D&Scope=%2Fag&FSRestVal=any&Action=Execute&SearchString={$formKeywords}', NULL, 1),
(3909, 752, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(3910, 752, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 3),
(3911, 752, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 4),
(3912, 752, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 5),
(3913, 752, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 6),
(3914, 752, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 7),
(3915, 752, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 8),
(3916, 752, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 9),
(3917, 752, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 10),
(3918, 753, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(3919, 753, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(3920, 753, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(3921, 753, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(3922, 754, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(3923, 754, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(3924, 754, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(3925, 754, 'SPIRO (Architecture Slide Library, University of California - Berkeley)', 'SPIRO (slide & photograph image retrieval online) provides access to images and descriptive information about 20% of the Library''s collection of 200,000 35mm slides.', 'http://www.mip.berkeley.edu/query_forms/browse_spiro_form.html', 'http://www.mip.berkeley.edu/cgi-bin/browse_spiro_new/tmp?db_handle=browse_spiro&object=&place=&aat_term=&aat_term2=&source=&image_id=&kw=&from_date=&period=any&result_type=thumbnail_with_descr&name={$formKeywords}', NULL, 3),
(3926, 754, 'GreatBuildings.com', 'This gateway to architecture around the world and across history documents a thousand buildings and hundreds of leading architects, with 3D models, photographic images and architectural drawings, commentaries, bibliographies, web links, and more, for famous designers and structures of all kinds.', 'http://www.greatbuildings.com/search.html', 'http://www.greatbuildings.com/cgi-bin/gbc-search.cgi?search=architect&architect={$formKeywords}', NULL, 4),
(3927, 754, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 5),
(3928, 755, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(3929, 755, 'Columbia Encyclopedia', 'Serving as a "first aid" for those who read, the sixth edition of the Columbia Encyclopedia contains over 51,000 entries with 80,000 hypertext links.', 'http://www.bartleby.com/65/', 'http://www.bartleby.com/cgi-bin/texis/webinator/65search?search_type=full&query={$formKeywords}', NULL, 1),
(3930, 755, 'WordWeb Online', 'WordWeb is an international dictionary and word finder with more than 280 000 possible lookup words and phrases. It is also available as Windows software.\n\nWordWeb fully covers American, British, Australian, Canadian and Asian English spellings and words.', 'http://www.wordwebonline.com/', 'http://www.wordwebonline.com/search.pl?w={$formKeywords}', NULL, 2),
(3931, 755, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(3932, 755, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(3933, 755, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(3934, 755, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(3935, 756, 'SPIRO (Architecture Slide Library, University of California - Berkeley)', 'SPIRO (slide & photograph image retrieval online) provides access to images and descriptive information about 20% of the Library''s collection of 200,000 35mm slides.', 'http://www.mip.berkeley.edu/query_forms/browse_spiro_form.html', 'http://www.mip.berkeley.edu/cgi-bin/browse_spiro_new/tmp?db_handle=browse_spiro&object=&place=&aat_term=&aat_term2=&source=&image_id=&from_date=&period=any&result_type=thumbnail_with_descr&name=&kw={$formKeywords}', NULL, 0),
(3936, 756, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 1),
(3937, 756, 'GreatBuildings.com', 'This gateway to architecture around the world and across history documents a thousand buildings and hundreds of leading architects, with 3D models, photographic images and architectural drawings, commentaries, bibliographies, web links, and more, for famous designers and structures of all kinds.', 'http://www.greatbuildings.com/search.html', 'http://www.greatbuildings.com/cgi-bin/gbc-search.cgi?search=building&building={$formKeywords}', NULL, 2),
(3938, 757, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(3939, 757, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(3940, 757, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(3941, 757, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(3942, 757, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(3943, 757, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(3944, 757, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(3945, 758, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(3946, 758, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(3947, 758, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(3948, 758, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(3949, 759, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 0),
(3950, 759, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase.  At this point, a total of 15,000 of 750,000 records are loaded into the database.  Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/default.asp', 'http://www.crl.edu/DBSearch/catalogSearchNew.asp?sort=R&req_type=X&search={$formKeywords}', NULL, 1),
(3951, 759, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 2),
(3952, 759, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 3),
(3953, 760, 'The Art, Design, Architecture & Media Information Gateway (ADAM)', 'ADAM is being developed to provide a gateway to information about fine art, design, architecture, applied arts, media, theory, museum studies and conservation and professional practice related to any of the above. It is one of the eLib Access to Network Resources (ANR) projects and received its funding from JISC. A user survey to measure information needs and search methods, annual reports, and service usage statistics are published at the site.', 'http://www.adam.ac.uk/index.html', 'http://www.adam.ac.uk/ixbin/hixserv?_IXDB_=adam&%7BUPPER%7D%24%3Fany%3A+IX_MODE+rel%3D1+%28%24any%29+INDEX+res_keywords=.&%24+with+res_pub=.&%24sort+@descending+%24%24relevance=.&%24%3F%21x%3A%28%28collection+or+item%29+in+res_granularity%29=.&_IXSPFX_=s&submit-button=SUMMARY&%24%3Dany%3D%24={$formKeywords}', NULL, 0),
(3954, 760, 'Akropolis.net', 'The premier architecture resource on the Internet, including Architects, Interior Designers, Landscapers, employment, free web sites, free portfolios, search engine, and more.', 'http://www.akropolis.net/', 'http://www.akropolis.net/search/index.ahtml?referredby=home&action=SEARCH&words={$formKeywords}', NULL, 1),
(3955, 761, 'Artcyclopedia.com', 'This site has compiled a comprehensive index of every artist represented at hundreds of museum sites, image archives, and other online resources.  The site has started out by covering the biggest and best sites around, and has links for most well-known artists:  contains 1800 art sites, and offers over 60,000 links to an estimated 150,000 artworks by 8,100 renowned artists.', 'http://www.artcyclopedia.com/', 'http://www.artcyclopedia.com/scripts/tsearch.pl?type=2&t={$formKeywords}', NULL, 0),
(3956, 761, 'Union List of Artists Names', 'Contains biographical information about artists and architects, including variant names, pseudonyms, and language variants.', 'http://www.getty.edu/research/tools/vocabulary/ulan/', 'http://www.getty.edu/vow/ULANServlet?nation=&english=Y&role=&page=1&find={$formKeywords}', NULL, 1),
(3957, 762, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com/mind/+{$formKeywords}', NULL, 0),
(3958, 763, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(3959, 763, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&frm=smp.x&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&p00={$formKeywords}', NULL, 1),
(3960, 763, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is raning from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(3961, 763, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(3962, 764, 'ARTSEDGE', 'ARTSEDGE supports the place of arts education at the center of the curriculum through the creative and appropriate uses of technology. ARTSEDGE helps educators to teach in, through and about the arts.', 'http://artsedge.kennedy-center.org/', 'http://artsedge.kennedy-center.org/search/search_perform.cfm?advanced=false&contentTypes=&artsSubjects=&x=31&y=9&keywords={$formKeywords}', NULL, 0),
(3963, 764, 'ArtsEdNet', 'ArtsEdNet, an online service developed by the Getty Education Institute for the Arts, supports the needs of the K-12 arts education community. It focuses on helping arts educators, general classroom teachers using the arts in their curriculum, museum educators, and university', 'http://www.getty.edu/artsednet/home.html', 'http://www.google.com/search?hl=en&btnG=Search&q=site%3Awww.getty.edu%2Feducation%2F+{$formKeywords}', NULL, 1),
(3964, 765, 'Arts Journal', 'Arts Journal is a weekday digest of some of the best arts and cultural journalism. Each day Arts Journal combs through more than 100 English-language newspapers, magazines and publications featuring writing about arts and culture. Direct links to the most interesting or important stories are posted every weekday on the Arts Journal news pages. Stories from sites that charge for access are excluded as are sites which require visitors to register, with the exception of the New York Times.', 'http://www.artsjournal.com/', 'http://www.google.com/custom?domains=artsjournal.com&sitesearch=artsjournal.com&sa=GoogleSearch&cof=LW:240;L:http://www.artsjournal.com/img/logo.gif;LH:52;AH:left;S:http://www.artsjournal.com;AWFID:edabed9eb3afda60;&q={$formKeywords}', NULL, 0),
(3965, 765, 'Aesthetics On-line', 'In Aesthetics On-line you''ll find articles about aesthetics, philosophy of art, art theory and art criticism, as well as information about aesthetics events worldwide, and links to other aesthetics-related resources on the internet, including the Aesthetics-L email discussion list.', 'http://www.aesthetics-online.org/', 'http://www.aesthetics-online.org/tech/search.cgi?context=Site&terms={$formKeywords}', NULL, 1),
(3966, 765, 'Architronic', 'Architronic is a scholarly refereed journal, exploring the new ranges of architectural communication available through digital media. It is a platform for both presenting and reviewing research as a journal, and a forum for stimulating dialogue on emerging ideas.', 'http://architronic.saed.kent.edu/', 'http://www.google.com/search?q=site:architronic.saed.kent.edu+', NULL, 2),
(3967, 766, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(3968, 766, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(3969, 766, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(3970, 766, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(3971, 766, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(3972, 766, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(3973, 766, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(3974, 766, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(3975, 766, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(3976, 766, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(3977, 766, 'The ArchNewsNow', 'The ArchNewsNow (ANN) newsletter, launched in February 2002, is delivered daily to subscribers -- free of charge -- via e-mail by 9:30AM (New York time). It hyperlinks directly to the latest news and commentary gleaned from sources around the world.', 'http://www.archnewsnow.com/', 'http://www.archnewsnow.com/cgi-local/search.pl?Required={$formKeywords}', NULL, 10),
(3978, 767, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(3979, 767, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(3980, 767, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(3981, 767, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(3982, 768, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(3983, 768, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(3984, 768, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(3985, 768, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(3986, 768, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(3987, 768, 'AstroLinks', 'AstroLinks provides links that will lead you to a voluminous amount of astronomical data and information.', 'http://www.astro.univie.ac.at/', 'http://www.google.com/search?q=site%3Aastro.univie.ac.at+{$formKeywords}', NULL, 5),
(3988, 768, 'Astronomy Resources from STScI', 'Astronomical Internet resources by the Space Telescope Science Institute.', 'http://www.stsci.edu/science/net-resources.html', 'http://www.stsci.edu/resources/WebSearch?uq=&notq=&command=Submit&query={$formKeywords}', NULL, 6),
(3989, 768, 'Astrophysics Data System', 'Astrophysics Data System contains abstracts from hundreds of publications, colloquia, symposia, proceedings, and internal NASA reports, and provides free and unrestricted access to scanned images of journals, conference proceedings and books in Astronomy and Astrophysics.', 'http://adsabs.harvard.edu/abstract_service.html', 'http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?db_key=AST&sim_query=YES&aut_xct=NO&aut_logic=OR&obj_logic=OR&object=&start_mon=&start_year=&end_mon=&end_year=&ttl_logic=OR&txt_logic=OR&text=&nr_to_return=100&start_nr=1&start_entry_day=&start_entry_mon=&start_entry_year=&min_score=&jou_pick=ALL&ref_stems=&data_and=ALL&group_and=ALL&sort=SCORE&aut_syn=YES&ttl_syn=YES&txt_syn=YES&aut_wt=1.0&obj_wt=1.0&ttl_wt=0.3&txt_wt=3.0&aut_wgt=YES&obj_wgt=YES&ttl_wgt=YES&txt_wgt=YES&ttl_sco=YES&txt_sco=YES&version=1&title=&author={$formKeywords}', NULL, 7),
(3990, 768, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://fnalpubs.fnal.gov/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/wwwscan?subfile=wwwhepau&submit=Browse&rawcmd=', NULL, 8),
(3991, 768, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 9),
(3992, 768, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 10),
(3993, 769, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(3994, 769, 'Encyclopedia of Astronomy and Astrophysics', 'Encyclopedia of Astronomy and Astrophysics is the most comprehensive reference on astronomy and astrophysics ever published. Comprising more than 2.5 million words, the site provides 24-hour free trial and 30 day free institutional trial.', 'http://www.ency-astro.com/', 'http://eaa.iop.org/index.cfm?action=search.home&quick=1&field1=&newsearch=1&coll=ft&query1={$formKeywords}', NULL, 1),
(3995, 769, 'Encyclopedia Astronautica', 'Encyclopedia Astronautica is likely the best source for international space flight information.', 'http://www.astronautix.com/', 'http://www.google.com/custom?sa=Search&cof=L%3Ahttp%3A%2F%2Fwww.astronautix.com%2Fgraphics%2Fl%2Flogo.gif%3BAH%3Acenter%3BGL%3A0%3BAWFID%3A3cf675793eb3c420%3B&sitesearch=www.astronautix.com&domains=www.astronautix.com&q={$formKeywords}', NULL, 2),
(3996, 769, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(3997, 769, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(3998, 769, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(3999, 769, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(4000, 770, 'AstroLinks', 'AstroLinks provides links that will lead you to a voluminous amount of astronomical data and information.', 'http://www.astro.univie.ac.at/', 'http://www.google.com/search?q=site%3Aastro.univie.ac.at+', NULL, 0),
(4001, 770, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4002, 770, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 2),
(4003, 770, 'Astronomy Resources from STScI', 'Astronomical Internet resources by the Space Telescope Science Institute.', 'http://www.stsci.edu/science/net-resources.html', 'http://www.stsci.edu/resources/WebSearch?uq=&notq=&command=Submit&query={$formKeywords}', NULL, 3),
(4004, 770, 'Astrophysics Data System', 'Astrophysics Data System contains abstracts from hundreds of publications, colloquia, symposia, proceedings, and internal NASA reports, and provides free and unrestricted access to scanned images of journals, conference proceedings and books in Astronomy and Astrophysics.', 'http://adsabs.harvard.edu/abstract_service.html', 'http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?db_key=AST&sim_query=YES&aut_xct=NO&aut_logic=OR&obj_logic=OR&author=&object=&start_mon=&start_year=&end_mon=&end_year=&ttl_logic=OR&txt_logic=OR&text=&nr_to_return=100&start_nr=1&start_entry_day=&start_entry_mon=&start_entry_year=&min_score=&jou_pick=ALL&ref_stems=&data_and=ALL&group_and=ALL&sort=SCORE&aut_syn=YES&ttl_syn=YES&txt_syn=YES&aut_wt=1.0&obj_wt=1.0&ttl_wt=0.3&txt_wt=3.0&aut_wgt=YES&obj_wgt=YES&ttl_wgt=YES&txt_wgt=YES&ttl_sco=YES&txt_sco=YES&version=1&title={$formKeywords}', NULL, 4),
(4005, 770, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://fnalpubs.fnal.gov/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/www?AUTHOR=&C=&REPORT-NUM=&AFFILIATION=&cn=&k=&cc=&eprint=+&eprint=&topcit=&url=&J=+&*=&ps=+&DATE=&*=+&FORMAT=WWW&SEQUENCE=&TITLE={$formKeywords}', NULL, 5),
(4006, 770, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?author1=&pubdate_year=&volume=&firstpage=&src=hw&hits=10&hitsbrief=25&resourcetype=1&andorexactfulltext=and&fulltext={$formKeywords}', NULL, 6),
(4007, 770, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 7),
(4008, 771, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4009, 771, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4010, 771, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4011, 771, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4012, 772, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4013, 772, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&frm=smp.x&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&p00={$formKeywords}', NULL, 1),
(4014, 772, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is raning from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4015, 772, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4016, 772, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(4017, 773, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(4018, 774, 'HEASARC', 'HEASARC is a source of gamma-ray, X-ray, and extreme ultraviolet observations of cosmic (non-solar) sources. This site provides access to archival data, associated analysis software, data format standards, documentation, expertise in how to use them, as well as relevant educational and outreach material.', 'http://heasarc.gsfc.nasa.gov/', 'http://heasarc.gsfc.nasa.gov/cgi-bin/search/search.pl?tquery={$formKeywords}', NULL, 0),
(4019, 774, 'UK Astronomy Data Centre', 'UK Astronomy Data Centre houses a good selection of data from the UK''s ground based telescopes as well as a number of catalogues.', 'http://archive.ast.cam.ac.uk/', 'http://archive.ast.cam.ac.uk/cgi-bin/wdb/wfsurvey/wfsurvey/query?tab_date_obs=on&date_obs=&tab_utstart=on&utstart=&tab_object=on&object=&tab_runno=on&runno=&tab_fband=on&fband=&tab_fsys=on&fsys=&tab_exposure=on&exposure=&box=00+30+00&tab_ra=on&ra=&tab_dec=on&scionly=on&max_rows_returned=1500&dec={$formKeywords}', NULL, 1),
(4020, 775, 'International Astronomy Meetings List', 'International Astronomy Meetings List provides links to the meeting web page, contact e-mail addresses, and abstracts provided by NASA''s Astrophysics Data System (ADS) if, and when they are available.', 'http://cadcwww.dao.nrc.ca/meetings/meetings.html', 'http://cadcwww.dao.nrc.ca/cadcbin/wdb/cadcmisc/meetings/query?tab_meeting_no=on&meeting_no=&tab_title=on&web=&tab_location=on&location=&contact=&email=&address=&tab_date_start=on&date_start=&tab_end_date=on&end_date=&max_rows_returned=10&title=&keywords={$formKeywords}', NULL, 0),
(4021, 775, 'Scholarly Societies Project Meeting/Conference Announcement List', 'Scholarly Societies Project Meeting/Conference Announcement List is a searchable service provided by the University of Waterloo (Canada) Scholarly Societies Project.', 'http://www.lib.uwaterloo.ca/society/meetings.html', 'http://ssp-search.uwaterloo.ca/cd.cfm', 'search_type=advanced&field1=any&boolean1=and&operator1=and&field2=any&textfield2=&boolean2=and&operator2=and&field3=any&textfield3=&boolean3=and&operator3=and&founded=none&after=&before=&Go8=Search&textfield1={$formKeywords}', 1),
(4022, 776, 'Space Science Education Resource Directory', 'Space Science Education Resource Directory is a convenient way to find NASA space science products for use in classrooms, science museums, planetariums, and other settings.', 'http://teachspacescience.org/cgi-bin/ssrtop.plex', 'http://teachspacescience.org/cgi-bin/search.plex?mode=basic&bgrade=allgrades&btopic=alltopics&submit.x=47&submit.y=14&keywords={$formKeywords}', NULL, 0),
(4023, 776, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 1),
(4024, 776, 'Space Science Education Home Page -- Goddard Space Flight Center', 'Data from several NASA missions, student activities, teacher resources', 'http://gsfc.nasa.gov/education/education_home.html', 'http://search.nasa.gov/nasasearch/search/search.jsp?nasaInclude={$formKeywords}', NULL, 2),
(4025, 777, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4026, 777, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://www.canada.gc.ca/main_e.html', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(4027, 777, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4028, 777, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4029, 777, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4030, 777, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4031, 777, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4032, 777, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4033, 777, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4034, 778, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4035, 778, 'ASTRONOMY magazine', 'ASTRONOMY magazine, the world''s best selling English magazine, offers visitors a wide variety of information for both hobbyist and armchair astronomers alike.', 'http://www.astronomy.com/home.asp', 'http://www.astronomy.com/asy/default.aspx?c=se&outsideHidden=Yes&searchStr={$formKeywords}', NULL, 1),
(4036, 778, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 2),
(4037, 778, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 3);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4038, 778, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 4),
(4039, 778, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 5),
(4040, 778, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 6),
(4041, 779, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4042, 779, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4043, 779, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4044, 779, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4045, 780, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4046, 780, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(4047, 780, 'ClinicalTrials.gov', 'ClinicalTrials.gov provides patients, family members, health care professionals, and members of the public, easy and free access to information on clinical studies for a wide range of diseases and conditions.', 'http://www.clinicaltrials.gov/', 'http://www.clinicaltrials.gov/ct/search;jsessionid=6EC2379952077D66434C74BCF3542697?&submit=Search&term={$formKeywords}', NULL, 2),
(4048, 780, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(4049, 780, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4050, 780, 'Animal Info: Information on Rare, Threatened and Endangered Mammals', 'Animal Info offers information on the biology and ecology of various species as well as current status of rare and endangered mammals. Also provides links to animal interest organizations and publications. Users can search an individual species index by common and scientific name, a species group index and a country index.', 'http://www.animalinfo.org/', 'http://search.atomz.com/search/?sp-a=00081051-sp00000000&sp-q={$formKeywords}', NULL, 5),
(4051, 780, 'BioMed Central (Requires Registration)', 'BioMed Central publishes original, peer-reviewed research in all areas of biomedical research, with immediate, barrier-free access for all. BioMed Central is structured into journals, each of which covers a broad area of biology or medicine.', 'http://www.biomedcentral.com/', 'http://www.google.com/search?q=site%3Abiomedcentral.com+{$formKeywords}', NULL, 6),
(4052, 780, 'PubMed', 'This is an experimental interface to several databases published by the NLM. Included are Medline and Pre-Medline, Popline, Toxline, GenBank DNA sequences, GenBank Protein Sequences, BioMolecule 3D structures, and Complete Genomes. This resource contains links to the full text of the articles when available.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 7),
(4053, 780, 'PubMed Central: an archive of life science journals', 'PubMed Central is a digital archive of life sciences journal literature managed by the National Center', 'http://www.pubmedcentral.nih.gov/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?search=Search&db=pmc&cmd=search&pmfilter_Fulltext=on&pmfilter_Relevance=on&term={$formKeywords}', NULL, 8),
(4054, 781, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4055, 781, 'Life Sciences Dictionary from BioTech', 'Life Sciences Dictionary from BioTech comprises 8,300+ terms relating to biochemistry, biotechnology, botany, cell biology and genetics, as well as selective entries on ecology, limnology, pharmacology, toxicology and medicine.', 'http://biotech.icmb.utexas.edu/search/dict-search.html', 'http://biotech.icmb.utexas.edu/search/dict-search2.html?bo1=AND&search_type=normal&def=&&word={$formKeywords}', NULL, 1),
(4056, 781, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4057, 781, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4058, 781, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(4059, 781, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(4060, 782, 'Animal Info: Information on Rare, Threatened and Endangered Mammals', 'Animal Info offers information on the biology and ecology of various species as well as current status of rare and endangered mammals. Also provides links to animal interest organizations and publications. Users can search an individual species index by common and scientific name, a species group index and a country index.', 'http://www.animalinfo.org/', 'http://search.atomz.com/search/?sp-a=00081051-sp00000000&sp-q={$formKeywords}', NULL, 0),
(4061, 782, 'ClinicalTrials.gov', 'ClinicalTrials.gov provides patients, family members, health care professionals, and members of the public, easy and free access to information on clinical studies for a wide range of diseases and conditions.', 'http://www.clinicaltrials.gov/', 'http://www.clinicaltrials.gov/ct/search;jsessionid=6EC2379952077D66434C74BCF3542697?&submit=Search&term={$formKeywords}', NULL, 1),
(4062, 782, 'FishBase', 'The FishBase Databases contains information on over 27,000 species, over 76,000 synonyms, 137,930 common names, over 35,000 pictures, and over 30,000 references. Entries include family, order, class, English name, distribution, biology, environment, climate zone, and additional information. Entries also offer a number of links for more specific data such as synonyms, countries, key facts, pictures, FAO areas, spawning, reproduction, predators, diet composition, and more.', 'http://www.fishbase.org/home.htm', 'http://www.fishbase.org/ComNames/CommonNameSearchList.cfm?Crit1_FieldName=COMNAMES.ComName&Crit1_FieldType=CHAR&Crit1_Operator=CONTAINS&CommonName_required=Common name can not be blank&CommonName={$formKeywords}', NULL, 2),
(4063, 782, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(4064, 782, 'BioMed Central (Requires Registration)', 'BioMed Central publishes original, peer-reviewed research in all areas of biomedical research, with immediate, barrier-free access for all. BioMed Central is structured into journals, each of which covers a broad area of biology or medicine.', 'http://www.biomedcentral.com/', 'http://www.google.com/search?q=site%3Abiomedcentral.com+{$formKeywords}', NULL, 4),
(4065, 782, 'MEDLINEplus: health information', 'MEDLINEplus presents up-to-date, quality health care information from the National Library of Medicine at the National Institutes of Health. Both health professionals and consumers can depend on MEDLINEplus for accurate, current medical information. This service provides access to extensive information about specific diseases and conditions and also has links to consumer health information from the National Institutes of Health, dictionaries, news, lists of hospitals and physicians, health information in Spanish and other languages, and clinical trials.', 'http://medlineplus.gov/', 'http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SERVER2=server2&SERVER1=server1&x=25&y=7&PARAMETER={$formKeywords}', NULL, 5),
(4066, 782, 'PubMed', 'This is an experimental interface to several databases published by the NLM. Included are Medline and Pre-Medline, Popline, Toxline, GenBank DNA sequences, GenBank Protein Sequences, BioMolecule 3D structures, and Complete Genomes. This resource contains links to the full text of the articles when available.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(4067, 782, 'PubMed Central: an archive of life science journals', 'PubMed Central is a digital archive of life sciences journal literature managed by the National Center', 'http://www.pubmedcentral.nih.gov/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?search=Search&db=pmc&cmd=search&pmfilter_Fulltext=on&pmfilter_Relevance=on&term={$formKeywords}', NULL, 7),
(4068, 783, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4069, 783, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4070, 783, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4071, 783, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4072, 784, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4073, 784, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4074, 784, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4075, 784, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4076, 784, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&amp;mode=quicksearch&amp;WISindexid1=WISall&amp;WISsearch1={$formKeywords}', 4),
(4077, 785, 'Nature Biotechnology Directory', 'Nature Biotechnology Directory Website, a global information resource listing over 8,000 organizations, product and service providers in the biotechnology industry.', 'http://www.guide.nature.com/', 'http://www.biocompare.com/nature/search.asp?contentid=1&maxrecords=50&search={$formKeywords}', NULL, 0),
(4078, 785, 'Scirus', 'Scirus is the most comprehensive science-specific search engine on the Internet. Driven by the latest search engine technology, Scirus searches over 150 million science-specific Web pages.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 1),
(4079, 785, ' National Library of Medicine Gateway', 'NLM Gateway allows users to search in multiple retrieval systems at the U.S. National Library of Medicine (NLM). The current Gateway searches MEDLINE/PubMed, OLDMEDLINE, LOCATORplus, MEDLINEplus, ClinicalTrials.gov, DIRLINE, Meeting Abstracts, and HSRProj. Useful to physicians, researchers, students and the general public for an overall search of NLM''s information resources.', 'http://gateway.nlm.nih.gov/gw/Cmd', 'http://gateway.nlm.nih.gov/gw/Cmd?GM2K_FORM=GMBasicSearch&enterKey=&ORBagentPort=14610&Perform_Search.x=19&Perform_Search.y=13&UserSearchText={$formKeywords}', NULL, 2),
(4080, 785, 'BiologyBrowser', 'BiologyBrowser, produced by BIOSIS, is a free web site offering resources for the life sciences information community. An interactive portal designed "to connect life sciences researchers with free, useful resources and other like-minded scientists from all around the world." Includes annotated links to news and life science Web sites, a nomenclatural glossary for zoology, a zoological thesaurus, a forum for biologists and scientists to discuss findings, and more. Searchable.', 'http://www.biologybrowser.org/', 'http://www.biologybrowser.org/cgi-bin/search/hyperseek.cgi?howmuch=ALL&Terms={$formKeywords}', NULL, 3),
(4081, 785, 'Bioresearch Online', 'Virtual community for the bioresearch and life sciences industry featuring daily news, product updates, discussion forums, and online chat with information on manufacturing, technology, equipment, supplies, software, and careers.', 'http://www.bioresearchonline.com/', 'http://www.bioresearchonline.com/IndustrySearch/SearchResults.aspx?TabIndex=3&keyword={$formKeywords}', NULL, 4),
(4082, 785, 'Biospace', 'BioSpace is a provider of web-based resources and information to the life science industry. For 20 years BioSpace has helped to accelerate communication and discovery among business and scientific leaders in the biopharmaceutical market. With a well-established site infrastructure and loyal online audience of over 1 million unique monthly visitors, BioSpace.com offers an unparalleled distribution channel for recruitment, investment, product, event and other life science industry messages.', 'http://www.biospace.com', 'http://www.google.com/search?q=site:www.biospace.com+{$formKeywords}', NULL, 5),
(4083, 786, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com/mind/+{$formKeywords}', NULL, 0),
(4084, 787, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 0),
(4085, 788, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4086, 788, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4087, 788, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4088, 788, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4089, 788, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4090, 788, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4091, 788, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4092, 788, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4093, 788, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4094, 789, 'Biospace', 'BioSpace is a provider of web-based resources and information to the life science industry. For 20 years BioSpace has helped to accelerate communication and discovery among business and scientific leaders in the biopharmaceutical market. With a well-established site infrastructure and loyal online audience of over 1 million unique monthly visitors, BioSpace.com offers an unparalleled distribution channel for recruitment, investment, product, event and other life science industry messages.', 'http://www.biospace.com', 'http://www.biospace.com/Default.aspx', 'ctl00$DropDownList1=News&ctl00$TextBox1={$formKeywords}', 0),
(4095, 789, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 1),
(4096, 789, 'The Scientist', 'The Scientist is the online resource for the printed magazine, The Scientist. Provides access to information useful to those working in or studying the life sciences.', 'http://www.the-scientist.com/', 'http://www.the-scientist.com/search/dosearch/', 'box_type=toolbar&search_restriction=all&order_by=date&search_terms={$formKeywords}', 2),
(4097, 789, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 3),
(4098, 789, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=TITLE_CHAR&FullText_CHAR={$formKeywords}', NULL, 4),
(4099, 789, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(4100, 790, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4101, 790, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4102, 790, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4103, 790, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4104, 791, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4105, 791, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(4106, 791, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(4107, 791, 'The Corporate Library', 'The Corporate Library is intended to serve as a central repository for research, study and critical thinking about the nature of the modern global corporation, with a special focus on corporate governance and the relationship between company management, their boards and their shareowners. Use this site to retrieve biographies for the companies in the S&P 1500 Supercomposite Index. Screen on a variety of features to identify matching directors (e.g. company name, age, attendance problems, # shares held, etc.) The site also contains research reports on trends in corporate governance.', 'http://www.thecorporatelibrary.com/', 'http://thecorporatelibrary.master.com/texis/master/search/?s=SS&q={$formKeywords}', NULL, 3),
(4108, 791, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 4),
(4109, 791, 'Intute: Social Sciences', 'Intute: Social Sciences is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 5),
(4110, 791, 'Brint.com', 'Extensive information portal with news, analysis and links related to business, commerce, economics, information technology, and information resources.', 'http://www.brint.com/', 'http://portal.brint.com/cgi-bin/cgsearch/cgsearch.cgi?query={$formKeywords}', NULL, 6),
(4111, 792, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4112, 792, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4113, 792, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4114, 792, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4115, 793, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4116, 793, 'Online Dictionary of the Social Sciences', 'Online Dictionary of the Social Sciences is a searchable dictionary of terms commonly used in the social sciences. Both phrase and keyword searches are facilitated.', 'http://bitbucket.icaap.org/', 'http://bitbucket.icaap.org/dict.pl?definition={$formKeywords}', NULL, 1),
(4117, 793, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4118, 793, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4119, 793, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(4120, 793, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(4121, 794, 'The Corporate Library', 'The Corporate Library is intended to serve as a central repository for research, study and critical thinking about the nature of the modern global corporation, with a special focus on corporate governance and the relationship between company management, their boards and their shareowners. Use this site to retrieve biographies for the companies in the S&P 1500 Supercomposite Index. Screen on a variety of features to identify matching directors (e.g. company name, age, attendance problems, # shares held, etc.) The site also contains research reports on trends in corporate governance.', 'http://www.thecorporatelibrary.com/', 'http://thecorporatelibrary.master.com/texis/master/search/?s=SS&q={$formKeywords}', NULL, 0),
(4122, 794, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 1),
(4123, 794, 'Intute: Social Sciences', 'Intute: Social Sciences is  a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 2),
(4124, 795, 'Brint.com', 'Extensive information portal with news, analysis and links related to business, commerce, economics, information technology, and information resources.', 'http://www.brint.com/', 'http://portal.brint.com/cgi-bin/cgsearch/cgsearch.cgi?query={$formKeywords}', NULL, 0),
(4125, 795, 'SMEALSearch', 'SMEALSearch is a publicly available vertical digital library and search engine hosted at Penn State''s Smeal College of Business that focuses on academic business documents. SmealSearch crawls the web and harvests, catalogs, and indexes academic business documents. It is based on the computer and information science engine, CiteSeer, initially developed at NEC Research Institute by Kurt Bollacker, Lee Giles and Steve Lawrence. The search engine crawls websites of academia, commerce, research institutes, government agencies, etc. for academic business documents, including published articles, working papers, white papers, consulting reports, etc. For certain documents, SmealSearch only indexes and stores the hyperlinks to those documents. SMEALSearch generates a citation analysis for all the academic articles harvested and ranks them in order of their citation rates (the most cited articles are listed first) similar to the ranking of CiteSeer and the Google Scholar.', 'http://130.203.133.125/SMEALSearchAbout.html', 'http://130.203.133.125/cs?submit=Search+Documents&q={$formKeywords}', NULL, 1),
(4126, 795, 'Roubini Global Economics (RGE) Montor', 'Includes daily economic analysis for individual countries, and information on emerging markets, financial markets, banking, and other topics. Contains original content and links to government and news sources. Searchable.', 'http://www.rgemonitor.com/', 'http://www.rgemonitor.com/?option=com_content&task=search&kwd={$formKeywords}', NULL, 2),
(4127, 796, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4128, 796, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4129, 796, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4130, 796, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4131, 797, 'Business Week', 'Business Week''s Web site provides the full text of the current issue, plus selected articles from earlier editions. There is also a searchable archive covering three years of articles from the print magazine, although charges apply for retrieving the full articles. Other features include updated news in the Daily Briefing section and BW Plus!, offering archive articles and other content on such topics as the computer industry, women in business, and business book reviews.', 'http://www.businessweek.com/', 'http://search.businessweek.com/search97cgi/s97_cgi?action=FilterSearch&ServerKey=Primary&filter=bwfilt.hts&command=GetMenu&ResultMaxDocs=500&ResultCount=25&resulttemplate=bwarchiv.hts&querytext={$formKeywords}', NULL, 0),
(4132, 797, 'businesswire.com', 'Offers company press releases, searchable by company name, industry, region, or keyword/concept. Each company''s releases are broken down by topic, i.e., earnings, management changes, mergers/acquisitions, products, etc.', 'http://www.businesswire.com/', 'http://home.businesswire.com/portal/site/home/?epi_menuItemID=e23d7f2be635f4725e0fa455c6908a0c&epi_menuID=887566059a3aedb6efaaa9e27a808a0c&epi_baseMenuID=384979e8cc48c441ef0130f5c6908a0c&searchHereRadio=false&ndmHsc=v2*A0*J2*L1*N-1002313*Z{$formKeywords}', NULL, 1);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4133, 797, 'Fortune', 'Fortune magazine''s Web site offers the full text of the print publication back to September 1995, plus links to special features like the Fortune 500, Best Cities for Business, Investor''s Guide, and others.', 'http://www.fortune.com/fortune/', 'http://search.money.cnn.com/pages/search.jsp?Coll=moneymag_xml&QuerySubmit=true&Page=1&LastQuery=&magazine=fort&QueryText={$formKeywords}', NULL, 2),
(4134, 797, 'The McKinsey Quarterly', 'The McKinsey Quarterly, a unique print and online publication published by McKinsey & Company, the leading global management consultancy, has long been a trusted source of strategic thinking, industry scenarios, and real-world market analysis.', 'http://www.mckinseyquarterly.com/home.aspx', 'http://www.mckinseyquarterly.com/search_result.aspx', 'search_query={$formKeywords}', 3),
(4135, 797, 'Inc.com', 'Inc.com, the website for Inc. magazine, delivers advice, tools, and services, to help business owners and CEOs start, run, and grow their businesses more successfully.  Inc. magazine archives date back to 1988 and are fully searchable. Site also features products, services, and online tools for virtually every business or management task.', 'http://www.inc.com/home/', 'http://www.inc.com/cgi-bin/finder.cgi?query={$formKeywords}', NULL, 4),
(4136, 797, 'Business Finance Magazine', 'Trade magazine for finance executives. Subject areas include Budgeting & Reporting; Cost Management; Performance Management; Risk Management; E-Business; Technology & Software; more. Also includes full article archives; Webcasts; Salary Central; an events & vendor directory; Web links; Research Reports; e-Newsletters. Visitors can participate in a regularly updated slate of research projects.', 'http://www.businessfinancemag.com/', 'http://www.businessfinancemag.com/site/search/search.cfm?site=BF&qs={$formKeywords}', NULL, 5),
(4137, 798, 'Free EDGAR database of corporate information', 'EDGAR, the Electronic Data Gathering, Analysis, and Retrieval system, performs automated collection, validation, indexing, acceptance, and forwarding of submissions by companies and others who are required by law to file forms with the U.S. Securities and Exchange Commission (SEC).', 'http://sec.freeedgar.com/', 'http://sec.freeedgar.com/resultsCompanies.asp?searchfrom=new&searchtype=name&x=27&y=3&searchvalue={$formKeywords}', NULL, 0),
(4138, 798, 'ThomasRegister', '"Free access to: over 168,000 companies; 68,000 product and service categories; thousands of online suppliers catalogs and web site links; over 2 million line items available for secvure online ordering; and, over 1 million downloadable CAD drawings."', 'http://www.thomasregister.com/', 'http://www.thomasnet.com/prodsearch.html?cov=NA&which=prod&navsec=search&what={$formKeywords}', NULL, 1),
(4139, 798, 'Microsoft Investor', 'Microsoft''s investor information page -- free. Has links to information on all of the companies that it covers.', 'http://moneycentral.msn.com/investor/home.asp', 'http://moneycentral.msn.com/money.search?q={$formKeywords}', NULL, 2),
(4140, 798, 'BPubs.com', 'Business Publications Search Engine', 'http://www.bpubs.com/', 'http://www.bpubs.com/cgi/search.cgi?bool=or&query={$formKeywords}', NULL, 3),
(4141, 798, 'Global Edge', 'International business information include Country Insights'' information on all countries, along with extensive links to research resources.', 'http://globaledge.msu.edu/ibrd/ibrd.asp', 'http://globaledge.msu.edu/ibrd/busresmain.asp?search=1&SearchTerms={$formKeywords}', NULL, 4),
(4142, 798, 'Bond Markets Online', 'Bond Market Association, association for bond market professionals, provides information and education resources for bond market professionals that underwrite, trade and sell debt securities. Includes policy issues, advocacy, news, research and statistics for bond professionals and investors.', 'http://www.bondmarkets.com/', 'http://www.bondmarkets.com/search/search.pl?nocpp=1&Match=1&Realm=bondmarkets&sort-method=1&Terms={$formKeywords}', NULL, 5),
(4143, 798, 'TaxLinks', 'A link and data aggregator focusing on tax payers and tax professionals. Its strength lies in its free databases of IRS Revenue Rulings since 1960 and Revenue Procedures since 1995. TaxLinks links up with tax sites above. Again, the content of the databases may not be totally complete, but they''re free and easily accessible from the home page.', 'http://www.taxlinks.com/', 'http://www.taxlinks.com/_vti_bin/shtml.dll/search.htm', 'VTI-GROUP=0&search={$formKeywords}', 6),
(4144, 798, 'Hoover''s Online! Company Info', 'Databases of information on tens of thousands of the largest or fastest-growing public and private U.S. companies. Information provided includes company address, number of employees, key people, financial data, news items and selected Web links to company Web site, SEC filings, and current stock prices. Some information is fee-based, but quite a bit of content is still freely available.', 'http://www.hoovers.com/free/?abforward=true', 'http://www.hoovers.com/free/search/simple/xmillion/index.xhtml?page=1&which=company&query_string={$formKeywords}', NULL, 7),
(4145, 799, 'H-Net Humanities and Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www.h-net.msu.edu/', 'http://www.h-net.org/logsearch/index.cgi?type=keyword&order=relevance&list=All+lists&hitlimit=25&smonth=00&syear=1989&emonth=11&eyear=2004&phrase={$formKeywords}', NULL, 0),
(4146, 799, 'Intute: Social Sciences - Conferences and Events', 'Intute: Social Sciences - Conferences and Events provides search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(4147, 799, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 2),
(4148, 799, 'TechCalendar', 'TechCalendar is a searchable/browseable event directory, with categories such as: Internet/Online, Communications, Software & Services, Vertical Markets, Computing Platforms, and Computing Industry.', 'http://www.techweb.com/calendar/', 'http://www.tsnn.com/partner/results/results_techweb.cfm?city=&select=-1&country=-1&classid=0&Month=-1&subject={$formKeywords}', NULL, 3),
(4149, 800, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4150, 800, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://www.canada.gc.ca/main_e.html', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(4151, 800, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4152, 800, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/searchresults.asp?formname=frmAdvanced&keywordstype=1&month=&year=&pub=1&news=1&links=1&allsubjects=1&alldepts=1&alldoctypes=1&keywords={$formKeywords}', NULL, 3),
(4153, 800, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4154, 800, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/engine/search/query.pl?action=FilterSearch&filter=europaflt.hts&Collection=fullEUROPA&ResultTemplate=europarslt_ascii.hts&ResultCount=25&ResultMaxDocs=200&DefaultLG=en&ViewTemplate=europaview.hts&QueryText={$formKeywords}', NULL, 5),
(4155, 800, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4156, 800, 'Business.gov', 'Business.gov is  an online resource guide designed to provide legal and regulatory information to America''s small businesses. Entrepreneurs can use this gateway to federal, state and local information in order to quickly define their problems and find solutions on topics ranging from federal advertising laws to local zoning codes. In addition to self-help articles, interactive guides, and the ability to complete transactions on line such as applying for a Federal EIN, the site also connects users with sources of in-person help from government officials, attorneys and business counselors in their local area.', 'http://www.business.gov/', 'http://www.business.gov:80/appmanager/bg/main?_nfpb=true&_windowLabel=T209963971174660224846&_urlType=action&_pageLabel=bg_page_home&siteId=&view=search=fromSearchBox=1&numHitsPerPage=10&query={$formKeywords}', NULL, 7),
(4157, 800, 'Organization for Economic Co-operation and Development', 'The OECD groups 30 member countries sharing a commitment to democratic government and the market economy. With active relationships with some 70 other countries, NGOs and civil society, it has a global reach. Best known for its publications and its statistics, its work covers economic and social issues from macroeconomics, to trade, education, development and science and innovation.', 'http://www.oecd.org/', 'http://www.oecd.org/searchResult/0,2665,en_2649_201185_1_1_1_1_1,00.html?fpSearchExact=3&fpSearchText={$formKeywords}', NULL, 8),
(4158, 800, 'E-Commerce Information from the European Union', 'Statistics, research, and discussion lists.', 'http://europa.eu.int/information_society/ecowor/ebusiness/index_en.htm', 'http://europa.eu.int/geninfo/query/engine/search/query.pl?action=FilterSearch&filter=europaflt.hts&collection=fullEUROPA&ResultTemplate=europarslt_ascii.hts&ResultCount=25&ResultMaxDocs=200&DefaultLG=en&ViewTemplate=europaview.hts&QueryText={$formKeywords}', NULL, 9),
(4159, 800, 'Country Studies: Area Handbook Series', 'From the Library of Congress, this site provides extensive information on foreign countries.  The Country Studies Series presents a description and analysis of the historical setting and the social, economic, political, and national security systems and institutions of countries throughout the world.', 'http://lcweb2.loc.gov/frd/cs/cshome.html', 'http://search.loc.gov:8765/query.html?col=loc&qp=url%3A%2Frr%2Ffrd%2F&submit.x=11&submit.y=9&qt={$formKeywords}', NULL, 10),
(4160, 800, 'Strategis', 'This site was developed by Industry Canada and provides a searchable database of Canadian companies, business information for each sector, a list of business support services, and a guide to business laws and regulations.  Trade Data Online provides Canadian and US trade data.', 'http://strategis.ic.gc.ca/engdoc/main.html', 'http://strategis.ic.gc.ca/cio/search-recherche/search.do?language=eng&V_SEARCH.command=search&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.date.modified&searchCriteriaArray%28V_SEARCH__returnedField%29=site_product_code&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.description&searchCriteriaArray%28V_SEARCH__returnedField%29=description&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.type&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.creator&searchCriteriaArray%28V_SEARCH__returnedField%29=vdksummary&searchCriteria%28V_SEARCH__charMap%29=8859&searchCriteria%28V_SEARCH__resultsJSP%29=%2FsiteResults.do&searchCriteria%28V_SEARCH__customSearchJSP%29=%2FcustomSearch.do&searchCriteria%28V_SEARCH__documentJSP%29=%2Fdocument.do&searchCriteria%28V_SEARCH__locale%29=en_CA&searchCriteria%28V_SEARCH__baseURL%29=search.do&searchCriteria%28V_CUSTOM__searchWithin%29=false&searchCriteria%28V_CUSTOM__collection%29=industry&searchCriteria%28V_CUSTOM__details%29=show&searchCriteria%28V_SEARCH__sortSpec%29=score+desc&searchCriteria%28V_CUSTOM__operator%29=AND&searchCriteria%28V_CUSTOM__column%29=FULLTEXT&searchCriteria%28V_CUSTOM__userInput%29={$formKeywords}', NULL, 11),
(4161, 800, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www-fed-all&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=5&y=16&mw0={$formKeywords}', NULL, 12),
(4162, 800, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 13),
(4163, 800, 'THOMAS: Legislative Information on the Internet', 'Through Thomas, the Library of Congress offers the text of bills in the United States Congress, the full text of the Congressional Record, House and Senate committee reports, and historical documents.', 'http://thomas.loc.gov/', 'http://thomas.loc.gov/cgi-bin/thomas', 'congress=109&database=text&MaxDocs=1000&querytype=phrase&Search=SEARCH&query={$formKeywords}', 14),
(4164, 801, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4165, 801, 'Businesswire', 'Offers company press releases, searchable by company name, industry, region, or keyword/concept. Each company''s releases are broken down by topic, i.e., earnings, management changes, mergers/acquisitions, products, etc.', 'http://www.businesswire.com/', 'http://home.businesswire.com/portal/site/home/?epi_menuItemID=e23d7f2be635f4725e0fa455c6908a0c&epi_menuID=887566059a3aedb6efaaa9e27a808a0c&epi_baseMenuID=384979e8cc48c441ef0130f5c6908a0c&searchHereRadio=false&ndmHsc=v2*A0*J2*L1*N-1002313*Z{$formKeywords}', NULL, 1),
(4166, 801, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 2),
(4167, 801, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(4168, 801, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 4),
(4169, 801, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 5),
(4170, 801, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 6),
(4171, 801, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 7),
(4172, 801, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 8),
(4173, 801, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 9),
(4174, 801, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 10),
(4175, 801, 'CNN Finance', 'Headline financial news and markets: keep up with what''s going on in the world of finance.', 'http://cnnfn.com/', 'http://search.money.cnn.com/pages/search.jsp?QueryText={$formKeywords}', NULL, 11),
(4176, 801, 'Nikkei Business Publications Asia', 'Japan BizTech is a source for technology and business news from Japan and Asia developed by Nikkei Business Publications. It covers the latest news and research breakthroughs in the communications, electronics and computer industries in Japan and other Asian countries. An online directory for technology and business contacts throughout Asia in banking, communications, transport equipment and wholesale is available at the site.', 'http://neasia.nikkeibp.com/', 'http://neasia.nikkeibp.com/cgi-bin/search.pl?stype=&lang=eng&b=1&t=1&u=0&alt=1&l=0&default=1&d=0&k=0&au=0&terms={$formKeywords}', NULL, 12),
(4177, 802, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4178, 802, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4179, 802, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4180, 802, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4181, 803, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4182, 803, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4183, 803, 'OAIster (Open Archives Initaitive research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4184, 803, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(4185, 803, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4186, 803, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'app=allGRAYLIT&INTERFACE=1WINDOW&FORM=/DistributedSearch.html&$$AUTHOR=&$$QTITLE=&$$SUBJECT=&$$ABSTRACT=&$$START_YEAR=&$$END_YEAR=&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&COLLECTION=nepis&MAXDOCS=50&QUERY={$formKeywords}', 5),
(4187, 803, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of\nreferences to more than 11 million articles published in 4300 biomedical\njournals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(4188, 804, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4189, 804, 'General Chemistry Online: Glossary', 'Searchable and browsable by topic or letter. Part of General Chemistry Online.', 'http://antoine.frostburg.edu/chem/senese/101/glossary.shtml', 'http://antoine.frostburg.edu/cgi-bin/senese/searchglossary.cgi?shtml=%2Fchem%2Fsenese%2F101%2Fglossary.shtml&query={$formKeywords}', NULL, 1),
(4190, 804, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4191, 804, 'NIST Chemistry WebBook', 'This site provides thermochemical, thermophysical, and ion energetics data \ncompiled by NIST under the Standard Reference Data Program.', 'http://webbook.nist.gov/chemistry/', 'http://webbook.nist.gov/cgi/cbook.cgi?Units=SI&Name={$formKeywords}', NULL, 3),
(4192, 804, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(4193, 804, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(4194, 804, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(4195, 805, 'chemdex.org', 'Searchable directory of more than 7,000 chemistry related\nsites. Includes general chemistry, organizations, Web portals, biography,\nsoftware, standards, and more. Users may rate and review sites. Some features\nrequire free registration. Based at the Department of Chemistry, University of\nSheffield, England.', 'http://www.chemdex.org/', 'http://www.chemdex.org/action.php?action=search', 'current_cat_id=&table=link&form_input_search_keyword={$formKeywords}', 0),
(4196, 805, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4197, 805, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 2),
(4198, 805, 'Eric Weisstein''s World of Science--Chemistry', 'Includes extensive encyclopedias of astronomy, chemistry, mathematics, physics, and scientific biography. Entries include definitions, diagrams, formulas, cross-references, and related resources. Searchable, and browsable alphabetically or by topic. Also has a "random entry" feature. The author is a scientist with advanced degrees in physics and planetary science.', 'http://scienceworld.wolfram.com/chemistry/', 'http://scienceworld.wolfram.com/search/index.cgi?sitesearch=scienceworld.wolfram.com%2Fchemistry&q={$formKeywords}', NULL, 3),
(4199, 805, 'General Chemistry Online', 'An introduction that includes hyperlinked notes, guides,\nand articles for first semester chemistry. There is a glossary, FAQs and a\ntrivia quiz. The Toolbox provides interactive graphing, a pop-up periodic table,\nand calculators. Additionally, Tutorials contains self-guided tutorials,\nquizzes, and drills on specific topics. There is one database of 800 common\ncompound names, formulas, structures, and properties, and another for over 400\nannotated Web sites. From a chemistry professor at Frostburg State University,\nMaryland. Searchable.', 'http://antoine.frostburg.edu/chem/senese/101/', 'http://marie.frostburg.edu/cgi-bin/htsearch?method=and&config=htdig&restrict=101&exclude=print-&format=builtin-long&sort=score&words={$formKeywords}', NULL, 4),
(4200, 805, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 5),
(4201, 805, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of\nreferences to more than 11 million articles published in 4300 biomedical\njournals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(4202, 805, 'TOXNET', 'TOXNET provides a searchable collection of databases on toxicology, hazardous chemicals, and related areas.', 'http://toxnet.nlm.nih.gov/', 'http://toxnet.nlm.nih.gov/cgi-bin/sis/search', 'submit2=&amp;basicsearch=/cgi-bin/sis/htmlgen?index.html&revisesearch=/home/httpd/htdocs/index.html&revisesearch=/home/httpd/htdocs/html/index.html&second_search=1&chemsyn=1&database=toxline&database=dart&database=hsdb&database=iris&database=iter&database=genetox&database=ccris&database=tri2003&database=chemid&database=hpd&database=hazmap&Stemming=1&and=1&xfile=1&queryxxx={$formKeywords}', 7),
(4203, 806, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4204, 806, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4205, 806, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4206, 806, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4207, 807, 'ChemFinder (Requires Registration)', 'This site enabling searching of the CS database by chemical name, CAS Number, molecular formula, or molecular weight. Also provides links to many chemical information web sites.', 'http://chemfinder.cambridgesoft.com/', 'http://chemfinder.cambridgesoft.com/result.asp?polyQuery={$formKeywords}', NULL, 0),
(4208, 807, 'Scirus', 'Scirus is the most comprehensive science-specific search engine on the Internet. Driven by the latest search engine technology, Scirus searches over 150 million science-specific Web pages.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 1),
(4209, 807, 'Chemistry.Org', 'chemistry.org is the online gateway to ACS resources, products, and services for members, chemists, scientists, chemical industry professionals, educators, students, children and science enthusiasts.', 'https://portal.chemistry.org/portal/acs/corg/memberapp', 'http://google.acs.org/search?site=americanchemical&client=americanchemical&proxystylesheet=americanchemical&output=xml_no_dtd&q={$formKeywords}', NULL, 2),
(4210, 807, 'Hazardous Chemical Databases', 'This database, created at the University of Akron, will allow the user to retrieve information for any of 23,495 hazardous chemicals or ''generic'' entries based on a keyword search.', 'http://ull.chemistry.uakron.edu/erd/', 'http://ull.chemistry.uakron.edu/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=DEFAULT&restrict=&exclude=&words={$formKeywords}', NULL, 3),
(4211, 808, 'ChemCenter', 'This is a pooling of Web resources from the American Chemical Society and Chemical Abstracts Service, including STNEasy, the ACS Graduate School Finder, Chemcyclopedia and more. It will eventually feature unique resources as well.', 'http://www.chemistry.org/portal/a/c/s/1/home.html', 'http://google.acs.org/search?by=&site=americanchemical&client=americanchemical&proxystylesheet=americanchemical&output=xml_no_dtd&q={$formKeywords}', NULL, 0),
(4212, 809, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4213, 809, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4214, 809, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4215, 809, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4216, 809, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(4217, 810, 'chemistry.org Meeting Locator', 'chemistry.orgâ€™s Meeting Locator will allow you to find details about meetings, workshops, short courses, and symposia of interest to practitioners of the chemical-related sciences.', 'http://acswebapplications.acs.org/applications/meetinglocator/home.cfm', 'http://google.acs.org/search?site=americanchemical&client=americanchemical&proxystylesheet=americanchemical&output=xml_no_dtd&q=meetings+{$formKeywords}', NULL, 0),
(4218, 810, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+', NULL, 1),
(4219, 810, 'All Conferences Directory', 'All Conferences Directory is a searchable database of Computer Science and Technology conferences that organizes conferences by category and offers information regarding paper submission deadlines.', 'http://all-conferences.com/Computers/', 'http://www.allconferences.com/Search/output.php?Title={$formKeywords}', NULL, 2),
(4220, 811, 'General Chemistry Online', 'An introduction that includes hyperlinked notes, guides,\nand articles for first semester chemistry. There is a glossary, FAQs and a\ntrivia quiz. The Toolbox provides interactive graphing, a pop-up periodic table,\nand calculators. Additionally, Tutorials contains self-guided tutorials,\nquizzes, and drills on specific topics. There is one database of 800 common\ncompound names, formulas, structures, and properties, and another for over 400\nannotated Web sites. From a chemistry professor at Frostburg State University,\nMaryland. Searchable.', 'http://antoine.frostburg.edu/chem/senese/101/', 'http://marie.frostburg.edu/cgi-bin/htsearch?method=and&config=htdig&restrict=101&exclude=print-&format=builtin-long&sort=score&words={$formKeywords}', NULL, 0),
(4221, 811, 'Science Learning Network', 'Science Learning Network is a community of educators, students, schools, science museums, and other institutions demonstrating a new model for inquiry into. Contains a variety of inquiry-posed problems, information, demonstrations, and labs.', 'http://www.sln.org/', 'http://192.231.162.154:8080/query.html?col=first&ht=0&qp=&qs=&qc=&pw=600&ws=1&la=&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&si=0&qt={$formKeywords}', NULL, 1),
(4222, 811, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 2),
(4223, 812, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4224, 812, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as \n\nprovincial, territorial and municipal governments. There is a Departments and Agencies link, and \n\nthe A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which \n\noutlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian \n\nGovernment, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together \n\ninformation from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4225, 812, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4226, 812, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4227, 812, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4228, 812, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4229, 812, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4230, 812, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4231, 812, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4232, 813, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4233, 813, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/news/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(4234, 813, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(4235, 813, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(4236, 813, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 4),
(4237, 814, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4238, 814, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4239, 814, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4240, 814, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4241, 815, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4242, 815, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(4243, 815, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(4244, 815, 'Behavior and Brain Sciences', 'Behavior and Brain Sciences is running on eprints.org open archive software, a freely distributable archive system available from eprints.org.', 'http://www.bbsonline.org/perl/search', 'http://www.bbsonline.org/perl/search?title_abstract_keywords_srchtype=all&authors_srchtype=all&year=&_satisfyall=ALL&_order=order0&submit=Search&.cgifields=publication&title_abstract_keywords=&authors={$formKeywords}', NULL, 3),
(4245, 815, 'CogPrints', 'CogPrints is an electronic archive for papers in any area of Psychology, Neuroscience, and Linguistics, and many areas of Computer Science and Biology, which uses the self-archiving software of eprints.org. This archive can be searched by author, title or keyword. Both preprints and published refereed articles are included, with full contact details for each author.', 'http://cogprints.soton.ac.uk/', 'http://cogprints.ecs.soton.ac.uk/perl/search/simple?meta=&meta_merge=ALL&full=&full_merge=ALL&person_merge=ALL&date=&_satisfyall=ALL&_order=bytitle&_action_search=Search&person={$formKeywords}', NULL, 4),
(4246, 815, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 5),
(4247, 815, 'Medline', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4,300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(4248, 816, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4249, 816, 'Dictionary of Philosophy of Mind', 'Dictionary of Philosophy of Mind is a searchable database of peer-reviewed articles on concepts and individuals in the field of philosophy.', 'http://www.artsci.wustl.edu/~philos/MindDict/', 'http://search.yahoo.com/search?vp=dictionary&vs=artsci.wustl.edu&va={$formKeywords}', NULL, 1),
(4250, 816, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4251, 816, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4252, 816, 'Wordnet', 'Wordnet is an online lexical reference system whose design is inspired by current psycholinguistic theories of human lexical memory. English nouns, verbs, adjectives and adverbs are organized into synonym sets, each representing one underlying lexical concept. Different relations link the synonym sets.', 'http://www.cogsci.princeton.edu/~wn/', 'http://wordnet.princeton.edu/perl/webwn?sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=&s={$formKeywords}', NULL, 4),
(4253, 816, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(4254, 816, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(4255, 817, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4256, 817, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4257, 817, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4258, 817, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4259, 818, 'Stanford Encyclopedia of Philosophy', 'The Stanford Encyclopedia of Philosophy is a dynamic reference work that has been rapidly growing.  The goal of this project is  to produce an authoritative and comprehensive dynamic reference work devoted to the academic discipline of philosophy that will be kept up to date dynamically so as to remain useful to those in academia and the general public.', 'http://plato.stanford.edu/about.html', 'http://plato.stanford.edu/cgi-bin/webglimpse.cgi?ID=1&nonascii=on&maxfiles=50&maxlines=30&maxchars=10000&query={$formKeywords}', NULL, 0),
(4260, 818, 'MITECS: The MIT Encyclopedia of the Cognitive Sciences', 'MITECS: The MIT Encyclopedia of the Cognitive Sciences is a free online access to abstracts, bibliographies, and links from this comprehensive reference work. (To read the full-length entries you have to pay.)', 'http://cognet.mit.edu/library/erefs/mitecs/', 'http://gb-server.mit.edu/search?btnG=Search&site=mit&client=mit&proxyreload=1&proxystylesheet=http%3A%2F%2Fcognet.mit.edu%2Fgoogle-mithome.xsl&output=xml_no_dtd&as_dt=i&as_sitesearch=cognet.mit.edu&q={$formKeywords}', NULL, 1),
(4261, 819, 'Institut des Sciences Cognitives', 'The National Center for Scientific Research in France promoting study of cognition, especially in humans. Many of the working papers and links to other websites are in English.', 'http://www.isc.cnrs.fr/index_en.htm', 'http://www.google.com/custom?cof=T%3Ablack%3BLW%3A118%3BALC%3Ared%3BL%3Ahttp%3A%2F%2Fwww.isc.cnrs.fr%2Flogoisc.gif%3BLC%3Ablue%3BLH%3A76%3BBGC%3Awhite%3BAH%3Acenter%3BVLC%3Apurple%3BAWFID%3Abbb9fffe574108ac%3B&domains=www.isc.cnrs.fr&sitesearch=www.isc.cnrs.fr&q={$formKeywords}', NULL, 0),
(4262, 819, 'The Encyclopedia of Psychology', 'The Encyclopedia of Psychology is intended to facilitate browsing in any area of psychology.', 'http://www.psychology.org/', 'http://www.psychology.org/cgi-bin/links2/search.cgi?query={$formKeywords}', NULL, 1),
(4263, 819, 'Enpsychlopedia', 'Enpsychlopedia - Provides a search of psychcentral and several other mental health sites. You can access every time you want Provides a search of psychcentral and several other mental health sites. ', 'http://www.enpsychlopedia.com/', 'http://www.enpsychlopedia.com/index.php?subber=&site=&qq={$formKeywords}', NULL, 2),
(4264, 819, 'CogWeb', 'CogWeb is a research tool for exploring the relevance of the study of human cognition to communication and the arts. It is edited by Francis Steen, assistant professor in Communication Studies at UCLA. CogWeb contains several hundred items and is continually under construction.', 'http://cogweb.ucla.edu/', 'http://search.atomz.com/search/?sp-advanced=1&sp-w-control=1&sp-a=00070a1a-sp00000000&sp-c=100&sp-p=any&sp-q={$formKeywords}', NULL, 3),
(4265, 819, 'Behavior and Brain Sciences', 'Behavior and Brain Sciences is running on eprints.org open archive software, a freely distributable archive system available from eprints.org.', 'http://www.bbsonline.org/perl/search', 'http://www.bbsonline.org/perl/search?title_abstract_keywords_srchtype=all&authors=&authors_srchtype=all&year=&_satisfyall=ALL&_order=order0&submit=Search&.cgifields=publication&title_abstract_keywords={$formKeywords}', NULL, 4),
(4266, 819, 'CogPrints', 'CogPrints is an electronic archive for papers in any area of Psychology, Neuroscience, and Linguistics, and many areas of Computer Science and Biology, which uses the self-archiving software of eprints.org. This archive can be searched by author, title or keyword. Both preprints and published refereed articles are included, with full contact details for each author.', 'http://cogprints.soton.ac.uk/', 'http://cogprints.ecs.soton.ac.uk/perl/search/simple?meta=&meta_merge=ALL&full_merge=ALL&person=&person_merge=ALL&date=&_satisfyall=ALL&_order=bytitle&_action_search=Search&full={$formKeywords}', NULL, 5),
(4267, 819, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&author1=&src=ml&disp_type=&fulltext={$formKeywords}', NULL, 6),
(4268, 819, 'Medline', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4,300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 7),
(4269, 819, 'Psycoloquy', 'An Open Archive of refereed reprints of all target articles, commentaries and responses from Psycoloquy, a peer-reviewed journal of Open Peer Commentary, sponsored by the American Psychological Association, indexed in PsycINFO, and published since 1990 (Archive is complete)', 'http://psycprints.ecs.soton.ac.uk/', 'http://psycprints.ecs.soton.ac.uk/perl/search?_order=bytitle&abstract%2Fkeywords%2Ftitle_srchtype=ALL&_satisfyall=ALL&abstract%2Fkeywords%2Ftitle={$formKeywords}', NULL, 8),
(4270, 820, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4271, 820, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4272, 820, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4273, 820, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4274, 820, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(4275, 821, 'COGSCI Cognitive Science Discussion List', 'COGSCI Cognitive Science Discussion List is a website for the International Cognitive Science Discussion List.', 'http://cogsci.weenink.com/', 'https://listserv.surfnet.nl/scripts/wa.exe?S2=COGSCI&0=S&s=&f=&a=&I=-3&q={$formKeywords}', NULL, 0),
(4276, 821, 'Intute: Social Sciences - Conferences and Events', 'Intute: Social Sciences - Conferences and Events provides search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(4277, 821, 'Medical Conferences.com', 'Medical Conferences.com is the Internet''s leading conference portal for medical and health-care professionals along with the associated supporting business community. This searchable database of over 7,000 medical conferences and CME events is an invaluable resource for all healthcare professionals.', 'http://www.medicalconferences.com/', 'http://www.medicalconferences.com/scripts/search_partner.pl?PID=234523&L=&Q_DATE_STARTD=-&Q_DATE_STARTM=-&Q_DATE_STARTY=-&Q_DATE_ENDD=-&Q_DATE_ENDM=-&Q_DATE_ENDY=-&x=4&y=11&&K={$formKeywords}', NULL, 2),
(4278, 822, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(4279, 823, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 0),
(4280, 824, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4281, 824, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. In addition to Department web sites, the government has been creating Portals which bring together \ninformation from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4282, 824, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4283, 824, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4284, 824, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4285, 824, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4286, 824, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4287, 824, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4288, 824, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4289, 825, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4290, 825, 'The Scientist', 'The Scientist is the online resource for the printed magazine, The Scientist, and provides access to information useful to those working in or studying the life sciences.', 'http://www.the-scientist.com/', 'http://www.the-scientist.com/search/dosearch/', 'box_type=toolbar&search_restriction=all&order_by=date&search_terms={$formKeywords}', 1),
(4291, 825, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 2),
(4292, 825, 'Newsdirectory', 'Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 3),
(4293, 826, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4294, 826, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4295, 826, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4296, 826, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4297, 827, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4298, 827, 'Collection of Computer Science Bibliographies', 'Contains about 1,200 bibliographies with over 1 million references, including over 100,000 web links to the full text of the article.', 'http://liinwww.ira.uka.de/bibliography/index.html#about', 'http://liinwww.ira.uka.de/csbib?online=&maxnum=200&sort=year&query={$formKeywords}', NULL, 1),
(4299, 827, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4300, 827, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(4301, 827, 'NCSTRL', 'NCSTRL is an international collection of computer science research reports and papers made available for non-commercial use from a number of participating institutions and archives. NCSTRL provides access to over 20,000 technical reports in computer science.', 'http://www.ncstrl.org:8900/ncstrl/index.html', 'http://www.ncstrl.org:8900/ncstrl/servlet/search?formname=simple&group=archive&sort=rank&fulltext={$formKeywords}', NULL, 4),
(4302, 827, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 5),
(4303, 827, 'arXiv.org', 'ArXiv is an e-print service in the fields of physics, mathematics, non-linear science and computer science.', 'http://arxiv.org/', 'http://arxiv.org/search?searchtype=all&query={$formKeywords}', NULL, 6),
(4304, 827, 'devx', 'devx provides full text of more than 100,000 indexed and searchable articles, reviews, and more.', 'http://www.devx.com/', 'http://www.google.com/custom?cof=T%3A%23000000%3BLW%3A70%3BBIMG%3Ahttp%3A%2F%2Fwww.devxcom%2Fimages%2Fredesign%2Fbackground2.gif%3BALC%3A%23000099%3BL%3Ahttp%3A%2F%2Fwww.devx.com%2Fimages%2Fredesign%2Fnewlogosm2.gif%3BLC%3A%23000099%3BLH%3A70%3BBGC%3AFAFAE6%3BAH%3Aleft%3BVLC%3A%23000099%3BGL%3A0%3BAWFID%3Aaf259f950e64cb71%3B&domains=devx.com%3Bprojectcool.com%3Bvb2themax.com&sitesearch=devx.com&sa.x=16&sa.y=25&q={$formKeywords}', NULL, 7),
(4305, 827, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 8),
(4306, 828, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4307, 828, 'Webopedia', 'Webopedia is an online dictionary with definitions of technical terms related to computers and the Internet.', 'http://www.webopedia.com/', 'http://search.internet.com/www.webopedia.com?IC_QueryDatabases=www.webopedia.com&IC_QueryText={$formKeywords}', NULL, 1),
(4308, 828, 'WhatIs.com', 'WhatIs.com is an online encyclopedia of information technology terms.', 'http://whatis.techtarget.com/', 'http://whatis.techtarget.com/wsearchResults/1,290214,sid9,00.html?query={$formKeywords}', NULL, 2),
(4309, 828, 'Free On-Line Dictionary of Computing', 'FOLDOC is a searchable dictionary of acronyms, jargon, programming languages, tools, architecture, operating systems, networking, theory, conventions, standards, mathematics, telecoms, electronics, institutions, companies, projects, products, and history related to computing.', 'http://foldoc.org/', 'http://wombat.doc.ic.ac.uk/foldoc/foldoc.cgi?action=Search&query={$formKeywords}', NULL, 3),
(4310, 828, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 4),
(4311, 828, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 5),
(4312, 828, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 6),
(4313, 828, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 7),
(4314, 829, 'arXiv.org', 'ArXiv is an e-print service in the fields of physics, mathematics, non-linear science and computer science.', 'http://arxiv.org/', 'http://arxiv.org/search?searchtype=all&query={$formKeywords}', NULL, 0),
(4315, 829, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 1),
(4316, 829, 'Collection of Computer Science Bibliographies', 'Contains about 1,200 bibliographies with over 1 million references, including over 100,000 web links to the full text of the article.', 'http://liinwww.ira.uka.de/bibliography/index.html#about', 'http://liinwww.ira.uka.de/csbib?online=&maxnum=200&sort=year&query={$formKeywords}', NULL, 2),
(4317, 829, 'NCSTRL', 'NCSTRL is an international collection of computer science research reports and papers made available for non-commercial use from a number of participating institutions and archives. NCSTRL provides access to over 20,000 technical reports in computer science.', 'http://www.ncstrl.org:8900/ncstrl/index.html', 'http://www.ncstrl.org:8900/ncstrl/servlet/search?formname=simple&group=archive&sort=rank&fulltext={$formKeywords}', NULL, 3),
(4318, 829, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 4),
(4319, 829, 'devx', 'devx provides full text of more than 100,000 indexed and searchable articles, reviews, and more.', 'http://www.devx.com/', 'http://www.google.com/custom?cof=T%3A%23000000%3BLW%3A70%3BBIMG%3Ahttp%3A%2F%2Fwww.devxcom%2Fimages%2Fredesign%2Fbackground2.gif%3BALC%3A%23000099%3BL%3Ahttp%3A%2F%2Fwww.devx.com%2Fimages%2Fredesign%2Fnewlogosm2.gif%3BLC%3A%23000099%3BLH%3A70%3BBGC%3AFAFAE6%3BAH%3Aleft%3BVLC%3A%23000099%3BGL%3A0%3BAWFID%3Aaf259f950e64cb71%3B&domains=devx.com%3Bprojectcool.com%3Bvb2themax.com&sitesearch=devx.com&sa.x=16&sa.y=25&q={$formKeywords}', NULL, 5),
(4320, 829, 'HCI Bibliography: : Human-Computer Interaction Resources', 'The HCI Bibliography (HCIBIB) is a free-access bibliography on Human-Computer Interaction, with over 28,5000 records in a searchable database.', 'http://www.hcibib.org/', 'http://www.hcibib.org/gs.cgi?highlight=checked&action=Search&terms={$formKeywords}', NULL, 6),
(4321, 830, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4322, 830, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4323, 830, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4324, 830, 'O''Reilly Search', 'Search for books, articles, weblogs, conferences, and other resources published or maintained by O''Reilly & Associates, world-renowned publishers.', 'http://www.oreillynet.com/search/', 'http://catsearch.atomz.com/search/catsearch/?sp-a=sp1000a5a9&sp-f=ISO-8859-1&sp-t=cat_search&sp-advanced=1&sp-p=any&sp-d=custom&sp-date-range=-1&sp-q-1=&sp-x-1=collection&sp-c=10&sp-m=1&sp-s=0&sp-q={$formKeywords}', NULL, 3),
(4325, 830, 'Safari Tech Books Online', 'O''Reilly''s online technical reference library.', 'http://safari.oreilly.com', 'http://safari.oreilly.com/search?_formName=searchForm&searchlistbox=Entire Site&searchtextbox={$formKeywords}', NULL, 4),
(4326, 830, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 5),
(4327, 831, 'Collection of Computer Science Bibliographies', 'Collection of Computer Science Bibliographies - A searchable collection of bibliographies from various sources, covering most aspects of computer science. Access references to journal articles, conference papers, & technical reports. The collection currently contains more than 2 millions of references (mostly to journal articles, conference papers and technical reports), clustered in about 1500 bibliographies, and consists of more than 2.3 GBytes (530MB gzipped) of BibTeX entries. More than 600 000 references contain cross references to citing or cited publications. More than 1 million of references contain URLs to an online version of the paper. Abstracts are available for more than 800 000 entries. There are more than 2000 links to other sites carrying bibliographic information.', 'http://liinwww.ira.uka.de/bibliography/index.html', 'http://liinwww.ira.uka.de/mpsbib?field=&year=&sincd=&before=&results=citation&maxnum=40&online=on&query={$formKeywords}', NULL, 0),
(4328, 831, 'Engineering E-journal Search Engine (EESE)', 'The Engineering E-journal Search Engine (EESE) searches the full text of over 100 free and full text engineering e-Journals.', 'http://www.eevl.ac.uk/eese/index.html', 'http://www.eevl.ac.uk/eevl-cross-results.htm?tab=all&eevl_sect=eevl&exact=on&method=All&searchst={$formKeywords}', NULL, 1),
(4329, 831, 'CompuScience', '"CompuScience" is a bibliographic database covering literature in the field of computer science and computer technology. Dating back to 1936, the database comprises about 656.378 citations.  CompuScience is integrated in io-port.net, the portal for computer science in Germany and Europe.  CompuScience contains the abstracts of the ACM Computing Reviews and the Computer Science Section of Zentralblatt fÃ¼r Mathematik (MATH database) and the abstracts of over 95 selected journals in this area. Citations contain bibliographic information and indexing terms. Many records also include an abstract. Most citations are classified according to the Computing Reviews Classification Scheme of ACM.', 'http://www.fiz-informationsdienste.de/en/DB/compusci/index.html', 'http://www.io-port.net/ioport2004/singlefieldSearch.do?feld1=fulltext&eingabe2=&eingabe3=&eingabe4=&eingabe5=&sortierung=jahr&query=&Abschicken=Suchen&eingabe1={$formKeywords}', NULL, 2),
(4330, 832, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4331, 832, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4332, 832, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4333, 832, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4334, 833, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 0),
(4335, 834, 'Canadian Patents Database', 'Canadian Patent Database lets you access over 75 years of patent descriptions and images. You can search, retrieve and study more than 1,500,000 patent documents', 'http://patents1.ic.gc.ca/intro-e.html', 'http://patents1.ic.gc.ca/fcgi-bin/patquery_eo_el?-t=_&-l=ibm.html&-m=50&-c=/cpoti/prod/verity/coll/cpd&ERROR_MSG=Query failed with rc =&GENERAL={$formKeywords}', NULL, 0),
(4336, 834, 'Europe''s Network of Patent Databases (Esp@cenet)', 'Europe''s Network of Patent Databases (Esp@cenet) is a free service for accessing patent information. Four database files may be searched: (1)European Patents (most recent 24 months, with PDF files); (2) PCT(WO) patents (most recent 24 months, with PDF files); (3) worldwide patents (coverage depends on country, mostly back to 1960s or 1970s); and (4) Japanese patents (1976-present). Since 1970, each patent family in the collection has a representative document with a searchable English-language title and abstract.', 'http://ep.espacenet.com', 'http://v3.espacenet.com/results?AB=fiber&sf=q&FIRST=1&CY=ep&LG=en&DB=EPODOC&st=AB&Submit=SEARCH&=&=&=&=&=&kw={$formKeywords}', NULL, 1),
(4337, 834, 'USPTO', 'USPTO databases cover the period from 1 January 1976 to the most recent weekly issue date (usually each Tuesday). Also has the ability to order patents within this system.', 'http://www.uspto.gov/', 'http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2Fsearch-bool.html&r=0&f=S&l=50&FIELD1=&co1=AND&TERM2=&FIELD2=&d=ptxt&TERM1={$formKeywords}', NULL, 2),
(4338, 835, 'The International Organization for Standardization (ISO)', 'The International Organization for Standardization (ISO) is a worldwide federation of national standards bodies from some 140 countries. ISO''s work has resulted in some 12,000 International Standards, representing more than 300,000 pages in English and French.', 'http://www.iso.ch/iso/en/CatalogueListPage.CatalogueList', 'http://www.iso.ch/iso/en/CombinedQueryResult.CombinedQueryResult?queryString={$formKeywords}', NULL, 0),
(4339, 835, 'Request For Comments (RFCs)', 'The Requests for Comments (RFC) document series is a set of technical and organizational notes about the Internet (originally the ARPANET), beginning in 1969. Memos in the RFC series discuss many aspects of computer networking, including protocols, procedures, programs, and concepts, as well as meeting notes, opinions, and sometimes humor.', 'http://www.rfc-editor.org/rfcsearch.html', 'http://www.rfc-editor.org/cgi-bin/rfcsearch.pl?opt=All+Fields&num=25&filefmt=txt&search_doc=search_all&match_method=prefix&sort_method=newer&abstract=absoff&keywords=keyoff&format=ftp&searchwords={$formKeywords}', NULL, 1),
(4340, 835, 'XML.com', 'An exhaustive site on all things XML (Extensible Markup Language), from schemas and style to the Semantic Web. Largely oriented toward power users, but includes useful FAQs for newcomers. Searchable. From the O''Reilly & Associates publishing house. ', 'http://www.xml.com/', 'http://search.atomz.com/search/?sp-a=sp1000a5a9&sp-f=ISO-8859-1&sp-t=cat_search&sp-x-1=collection&sp-q-1=xml&sp-q={$formKeywords}', NULL, 2),
(4341, 836, 'All Conferences Directory', 'All Conferences Directory is a searchable database of Computer Science and Technology conferences that organizes conferences by category and offers information regarding paper submission deadlines.', 'http://all-conferences.com/Computers/', 'http://www.allconferences.com/Search/search.php3?Search={$formKeywords}', NULL, 0),
(4342, 836, 'DB and LP: Conferences and Workshops', 'DB and LP: Conferences and Workshops contains a list of computer science conferences and Workshops: past, present and future.', 'http://www.informatik.uni-trier.de/~ley/db/conf/index.a.html', 'http://www.google.com/search?hl=en&lr=&q=site%3Awww.informatik.uni-trier.de%2F+conf+{$formKeywords}', NULL, 1),
(4343, 836, 'Netlib Conferences Databases', 'The Netlib Conferences Databases contains information about upcoming conferences, lectures, and other meetings relevant to the fields of mathematics and computer science.', 'http://www.netlib.org/confdb/confsearch.html', 'http://netlib2.cs.utk.edu/cgi-bin/csearch/confdisp.pl?ip_address=160.36.58.108&ip_name=netlib-old.cs.utk.edu&tcp_port=8123&database_name=%2Fusr%2Flocal%2Fwais%2Findexes%2Fconfdb&search_term={$formKeywords}', NULL, 2),
(4344, 836, 'TechCalendar', 'TechCalendar is a searchable/browseable event directory, with categories such as: Internet/Online, Communications, Software & Services, Vertical Markets, Computing Platforms, and Computing Industry.', 'http://www.techweb.com/calendar/', 'http://www.tsnn.com/partner/results/results_techweb.cfm?city=&select=-1&country=-1&classid=120&Month=-1&subject={$formKeywords}', NULL, 3),
(4345, 837, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(4346, 838, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', NULL, 0),
(4347, 838, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 1),
(4348, 839, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4349, 839, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4350, 839, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4351, 839, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4352, 839, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4353, 839, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4354, 839, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4355, 839, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4356, 839, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4357, 840, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4358, 840, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/news/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(4359, 840, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(4360, 840, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(4361, 840, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(4362, 840, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(4363, 841, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4364, 841, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4365, 841, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4366, 841, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4367, 842, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4368, 842, 'Intute: Social Sciences', 'Intute is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 1),
(4369, 842, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 2),
(4370, 842, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 3),
(4371, 842, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4372, 842, 'IDEAc', 'IDEA: the complete RePEc database at your disposal. Working papers, journal articles, software components, author information, directory of institutions.', 'http://ideas.repec.org/', 'http://ideas.repec.org/cgi-bin/htsearch?restrict=http://ideas.repec.org/p/&config=htdig&restrict=&exclude=&sort=score&format=long&method=and&search_algorithm=exact:1&words={$formKeywords}', NULL, 5),
(4373, 842, 'World Bank Group Documents & Reports', 'The World Bank Group makes more than 14,000 documents available through the Documents & Reports website. Documents include Project appraisal reports, Economic and Sector Works, Evaluation reports and studies and working papers.', 'http://www-wds.worldbank.org/', 'http://www-wds.worldbank.org/servlet/WDS_IBank_Servlet?all=&stype=AllWords&dname=&rc=&ss=&dt=&dr=range&bdt=&edt=&rno=&lno=&cno=&pid=&tno=&sortby=D&sortcat=D&psz=20&x=34&y=8&ptype=advSrch&pcont=results&auth={$formKeywords}', NULL, 6),
(4374, 842, 'NBER', 'NBER (The National Bureau of Economic Research, Inc) is a private, nonprofit, nonpartisan research organization dedicated to promoting a greater understanding of how the economy works. Nearly 500 NBER Working papers are published each year, and many subsequently appear in scholarly journals.', 'http://papers.nber.org/', 'http://papers.nber.org/papers?module=search&action=query&default_conjunction=and&keywords={$formKeywords}', NULL, 7),
(4375, 843, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4376, 843, 'Online Glossary of Research Economics', 'An online glossary of terms in research economics.', 'http://econterms.com/', 'http://econterms.com/glossary.cgi?query={$formKeywords}', NULL, 1),
(4377, 843, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4378, 843, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4379, 843, 'AmosWeb GLOSS*arama', 'The AmosWEB GLOSS*arama, a glossary for principles students, is a searchable database of 1800 economic terms and concepts.', 'http://amosweb.com/gls/', 'http://amosweb.com/cgi-bin/gls.pl?fcd=dsp&key={$formKeywords}', NULL, 4),
(4380, 843, 'Concise Encyclopedia of Economics (CEE)', 'Concise Encyclopedia of Economics (CEE) - tutorials on various economic topics', 'http://www.econlib.org/library/CEE.html', 'http://www.econlib.org/cgi-bin/search.pl?results=0&book=Encyclopedia&andor=and&sensitive=no&query={$formKeywords}', NULL, 5),
(4381, 843, 'EH.Net Encyclopedia of Economic and Business History', 'Directed by a distinguished board, articles in this encyclopedia on both business and economic history "are written by experts, screened by a group of authorities, and carefully edited."', 'http://eh.net/encyclopedia/', 'http://eh.net/encyclopedia/search/?Search.x=37&Search.y=10& q={$formKeywords}', NULL, 6),
(4382, 843, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 7),
(4383, 843, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 8),
(4384, 843, 'bizterms.net', 'Bizterms.net provides a comprehensive dictionary of business and financial terms. Start browsing for your financial term, either by search, most popular terms, random term or simply view terms by letter.', 'http://www.bizterms.net', 'http://www.bizterms.net/index.php', 'query={$formKeywords}', 9),
(4385, 844, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4386, 844, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4387, 844, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4388, 844, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4389, 845, 'EconPapers', 'EconPapers use the RePEc bibliographic and author data, providing access to the largest collection of online Economics working papers and journal articles.  As of May 2006, there is a total of 375,364 searchable working papers, articles and software items with 273,186 items available on-line. \n\nThe majority of the full text files are freely available, but some (typically journal articles) require that you or your organization subscribe to the service providing the full text file.', 'http://econpapers.repec.org/about.htm', 'http://econpapers.repec.org/scripts/search.asp?ft={$formKeywords}', NULL, 0),
(4390, 845, 'NBER', 'NBER (The National Bureau of Economic Research, Inc) is a private, nonprofit, nonpartisan research organization dedicated to promoting a greater understanding of how the economy works. Nearly 500 NBER Working papers are published each year, and many subsequently appear in scholarly journals.', 'http://papers.nber.org/', 'http://papers.nber.org/papers?module=search&action=query&default_conjunction=and&keywords={$formKeywords}', NULL, 1),
(4391, 846, 'EDIRC', 'EDIRC: Economics Departments, Institutes and Research Centers in the World currently contains 6,321 institutions in 207 countries and territories.', 'http://edirc.repec.org/', 'http://edirc.repec.org/cgi-bin/search.cgi?boolean=AND&keyword1={$formKeywords}', NULL, 0),
(4392, 846, 'Intute: Social Sciences', 'Intute is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 1),
(4393, 846, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 2),
(4394, 846, 'World Bank Group Documents & Reports', 'The World Bank Group makes more than 14,000 documents available through the Documents & Reports website. Documents include Project appraisal reports, Economic and Sector Works, Evaluation reports and studies and working papers.', 'http://www-wds.worldbank.org/', 'http://www-wds.worldbank.org/servlet/WDS_IBank_Servlet?stype=AllWords&ptype=sSrch&pcont=results&sortby=D&sortcat=D&x=17&y=3&all={$formKeywords}', NULL, 3),
(4395, 847, 'WebEC: World Wide Web Resources in Economics', 'WebEC provides links to a variety of resources on economics. Topics include: economics and teaching; methodology and history; mathematical and quantitative methods; economics and computing; economics data; microeconomics; macroeconomics; international economics; financial economics; public economics; health, education and welfare; labor and demographics; law and economics; industrial organization; business economics; economic history; development, technological change and growth; economic systems; agriculture and natural resources; regional economics; and economics of networks.', 'http://www.helsinki.fi/WebEc/', 'http://www.google.com/search?hl=en&lr=&q=site%3Awww.helsinki.fi%2F WebEc%2F+{$formKeywords}', NULL, 0),
(4396, 848, 'Office for National Statistics (UK)', 'National Statistics is the official UK statistics site. You can view and download a wealth of economic and social data free.', 'http://www.statistics.gov.uk/', 'http://www.statistics.gov.uk/CCI/SearchRes.asp?term={$formKeywords}', NULL, 0),
(4397, 848, 'Statistics Canada', 'Statistics Canada is the official source for Canadian social and economic statistics and products.', 'http://www.statcan.ca/', 'http://www.statcan.ca:8081/english/clf/query.html?GO%21=GO%21&ht=0&qp=&qs=&qc=0&pw=100%25&la=en&qm=1&st=1&oq=&rq=0&si=0&rf=0&col=alle&qt={$formKeywords}', NULL, 1),
(4398, 849, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4399, 849, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4400, 849, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4401, 849, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4402, 850, 'H-Net', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www2.h-net.msu.edu/lists/', 'http://www2.h-net.msu.edu/logsearch/index.cgi?type=keyword&list=All+lists&hitlimit=100&field=&nojg=on&smonth=00&syear=1989&emonth=11&eyear=2004&order=relevance&phrase={$formKeywords}', NULL, 0),
(4403, 850, 'Intute: Social Sciences - Conferences and Events', 'Providing search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(4404, 850, 'INOMICS', 'INOMICS provides searches in indexes of other Web pages related to Economics.', 'http://www.conference-board.org/', 'http://www.conference-board.org/cgi-bin/MsmFind.exe?AND_ON=N&ALLCATS=X&AGE_WGT=0&EN=X&ES=X&NO_DL=X&x=57&y=11&QUERY={$formKeywords}', NULL, 2),
(4405, 851, 'Tutor 2U Economics', 'Tutor 2U Economics includes study resources, revision guides, relevant links, an updated dataroom, and a discussion forum.', 'http://www.tutor2u.com/', 'http://www.tutor2u.net/search.asp?func=search&tree=0&submit=Search+Tutor2u&myquery={$formKeywords}', NULL, 0),
(4406, 851, 'biz/ed', 'Business Education on the Internet (biz/ed) is a free information service available via the World-Wide Web which allows users to search and retrieve targeted information about business and economics held on computers around the world. The service offers a one-stop information gateway for the one million economics, business and management students and staff as well as the general public in the UK and overseas.', 'http://www.bized.co.uk/', 'http://www.bized.co.uk/cgi-bin/htsearch?config=htdig&method=and&sort=score&format=builtin-long&restrict=&exclude=&words={$formKeywords}', NULL, 1),
(4407, 851, 'EcEdWeb', 'Economic Education Website: The purpose of the Economic Education Website is to provide support for economic education in all forms and at all levels.', 'http://ecedweb.unomaha.edu/search.cfm', 'http://www.google.com/u/ecedweb?q={$formKeywords}', NULL, 2),
(4408, 852, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4409, 852, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4410, 852, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4411, 852, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4412, 852, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4413, 852, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4414, 852, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4415, 852, 'The OECD (Organisation for Economic Co-operation and Development)', 'The OECD groups 30 member countries sharing a commitment to democratic government and the market economy. With active relationships with some 70 other countries, NGOs and civil society, it has a global reach. Best known for its publications and its statistics, its work covers economic and social issues from macroeconomics, to trade, education, development and science and innovation.', 'http://www.oecd.org/home/', 'http://www.oecd.org/searchResult/0,2665,en_2649_201185_1_1_1_1_1,00.html?fpSearchExact=3&fpSearchText={$formKeywords}', NULL, 7),
(4416, 852, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 8),
(4417, 852, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 9),
(4418, 853, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4419, 853, 'The Economist', 'The Economist is the online version of the famous magazine with articles and a searchable archive.', 'http://www.economist.com/', 'http://www.economist.com/search/search.cfm?cb=46&area=1&page=index&keywords=1&frommonth=01&fromyear=1997&tomonth=02&toyear=2002&rv=2&qr={$formKeywords}', NULL, 1),
(4420, 853, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(4421, 853, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 3),
(4422, 853, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 4),
(4423, 853, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 5),
(4424, 853, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 6),
(4425, 853, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 7),
(4426, 853, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 8),
(4427, 853, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 9),
(4428, 853, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 10),
(4429, 854, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4430, 854, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4431, 854, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4432, 854, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4433, 855, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4434, 855, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://www.oaister.org/', 'http://quod.lib.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&rgn1=entire+record&rgn2=entire+record&rgn3=entire+record&c=oaister&sid=f4f5644c4d1d4282010da7f16b531fb9&searchfield=Entire+Record&op2=And&searchfield=Entire+Record&q2=&op3=And&searchfield=Entire+Record&q3=&op6=And&rgn6=norm&restype=all+types&sort=title&submit2=search&q1={$formKeywords}', NULL, 1),
(4435, 855, 'SearchERIC', 'Tools to search the abstracts and Digests produced by the ERICSM system.', 'http://www.eric.ed.gov/', 'http://www.google.com/custom?domains=www.eric.ed.gov&sa=Google+Search&sitesearch=www.eric.ed.gov&q={$formKeywords}', NULL, 2);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4436, 855, 'ERIC - Education Resources Information Center', 'ERIC - the Education Resources Information Center - is an internet-based digital library of education research and information sponsored by the Institute of Education Sciences (IES) of the U.S. Department of Education. \n\nERIC provides access to bibliographic records of journal and non-journal literature indexed from 1966 to the present. \n\nThe ERIC collection includes bibliographic records (citations, abstracts, and other pertinent data) for more than 1.2 million items indexed since 1966, including journal articles, books,  research syntheses, conference papers, technical reports, \npolicy papers, and other education-related materials.\n\nERIC currently indexes more than 600 journals, the majority of which are indexed comprehensively â€” every article in each issue is included in ERIC. Some journals are indexed selectively â€” only those articles that are education-related are selected for indexing. \n\nIn addition, contributors have given ERIC permission to display more than 115,000 full-text materials in PDF format - at no charge. These materials are generally part of the recent "grey literature" such as conference papers and reports, rather than journal articles and books. Most materials published 2004 and forward include links to other sources, including publishers'' Web sites.', 'http://eric.ed.gov/', 'http://eric.ed.gov/ERICWebPortal/Home.portal?_nfpb=true&ERICExtSearch_Operator_2=and&ERICExtSearch_SearchType_0=au&ERICExtSearch_SearchValue_2=&ERICExtSearch_SearchValue_1=&ERICExtSearch_Operator_1=and&ERICExtSearch_SearchType_1=kw&ERICExtSearch_PubDate_To=2006&ERICExtSearch_SearchType_2=kw&ERICExtSearch_SearchCount=2&ERICExtSearch_PubDate_From=0&_pageLabel=ERICSearchResult&newSearch=true&rnd=1137305171346&searchtype=advanced&ERICExtSearch_SearchValue_0={$formKeywords}', NULL, 3),
(4437, 855, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4438, 855, 'Education-Line: Electronic Texts in Education and Training', 'Education-Line: Electronic Texts in Education and Training (UK) is a searchable "electronic archive of ''gray'' (report, conference, working paper) and ''pre-print'' literature in the field of education and training." Provided by the British Education Index (BEI), this database provides access to over 1,000 papers presented at British research conferences and elsewhere. Provides links to searchable paper files from conferences sponsored by the British Educational Research Association, the European Conference on Educational Research, and others.', 'http://www.leeds.ac.uk/educol/', 'http://brs.leeds.ac.uk/cgi-bin/brs_engine?*ID=1&*DB=BEID&*PT=50&*FT=BEID&*HI=Y&TITL=&SUBJ=&*SO=TITL&SUBMIT_BUTTON=search%20button&*QQ=&AUTH={$formKeywords}', NULL, 5),
(4439, 856, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4440, 856, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 1),
(4441, 856, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 2),
(4442, 856, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 3),
(4443, 856, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 4),
(4444, 857, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4445, 857, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4446, 857, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://67.118.51.201/bol/KeyWordSearch.cfm', 'RowCount=50&Searchquery={$formKeywords}', 2),
(4447, 857, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4448, 858, 'Advancing Women in Leadership Journal [USA]', 'Advancing Women in Leadership represents the first on-line professional, refereed journal for women in leadership. The journal publishes manuscripts that report, synthesize, review, or analyze scholarly inquiry that focuses on women''s issues.', 'http://www.advancingwomen.com/awl/awl.html', 'http://www.google.com/search?&q=site%3Awww.advancingwomen.com+{$formKeywords}', NULL, 0),
(4449, 858, 'Educause Review [USA]', 'EDUCAUSE Review is the general-interest, bimonthly magazine published by EDUCAUSE. The magazine takes a broad look at current developments and trends in information technology, what these mean for higher education, and how they may affect the college/university as a whole.', 'http://www.educause.edu/apps/er/index.asp', 'http://www.educause.edu/SearchResults/706?app=krc&output=xml_no_dtd&restrict=WWW_EDUCAUSE_EDU&client=my_collection&site=my_collection&getfields=*&filter=0&opid=644&app_section=&submit=Search&top_tax_id=&PRIMARYPUBS=&Control=&CARNEGIE=&FTE=&q={$formKeywords}', NULL, 1),
(4450, 858, 'Teachers College Record [USA]', 'A peer-reviewed journal offering full-text articles from 1980-present. Thematic content collections, discussion groups, online learning modules, and book reviews.', 'http://www.tcrecord.org/About.asp', 'http://www.tcrecord.org/search.asp?x=34&y=18&kw={$formKeywords}', NULL, 2),
(4451, 858, 'The Australian Electronic Journal of Nursing Education [Australia]', 'The AEJNE is committed to enhancing the teaching learning experience across a variety of nurse contexts. The journal will be a means by which nurses can share findings, insights, experience and advice to colleagues involved in all aspects of the educational process.', 'http://www.scu.edu.au/schools/nhcp/aejne/', 'http://www.scu.edu.au/cgi/htsearch/?submit=Search&method=boolean&format=builtin-short&words={$formKeywords}', NULL, 3),
(4452, 858, 'Bilingual Research Journal [USA]', 'A peer-reviewed scholarly journal publishing research on bilingual education.', 'http://brj.asu.edu/', 'http://brj.asu.edu.master.com/texis/master/search/?s=SS&notq=&prox=&sufs=0&rorder=&rprox=&rdfreq=&rwfreq=&rlead=&q={$formKeywords}', NULL, 4),
(4453, 858, 'Current Issues in Education [USA]', 'Current Issues in Comparative Education (CICE) is an online journal based at Teachers College, Columbia University, that publishes scholarly work from a variety of academic disciplines. CICE seeks clear and significant contributions that further debate on educational policies and comparative studies.', 'http://cie.ed.asu.edu/', 'http://www.google.com/search?q=site%3Acie.asu.edu+{$formKeywords}', NULL, 5),
(4454, 858, 'Education-line [UK]', 'Education-line is a freely accessible database of the full text of conference papers, working papers and electronic literature which supports educational research, policy and practice.', 'http://www.leeds.ac.uk/educol/', 'http://brs.leeds.ac.uk/cgi-bin/brs_engine?*ID=1&*DB=BEID&*PT=50&*FT=BEID&*HI=Y&TITL=&AUTH=&SUBJ=&*SO=TITL&SUBMIT_BUTTON=search%20button&*QQ={$formKeywords}', NULL, 6),
(4455, 858, 'Education Policy Analysis Archives [USA & Mexico]', 'A peer-reviewed scholarly electronic journal publishing education policy analysis since 1993.', 'http://epaa.asu.edu/', 'http://epaa.asu.edu/cgi-bin/htsearch?method=boolean&format=builtin-long&sort=score&config=epaa.asu.edu&restrict=&exclude=&words={$formKeywords}', NULL, 7),
(4456, 858, 'Educational Insights: Electronic Journal of Graduate Student Research [Canada]', 'Educational Insights is an innovative evocative provocative intertextual space for engaging in new dialogues of enRapturing con/texts and reimagined spaces of pedagogy, inquiry, and interdisciplinarity. Our intent is to encourage a community that honours difference and polyphony, while sharing a vision of pedagogy, education, inquiry as spaces of challenge and hopeful conversations.', 'http://ccfi.educ.ubc.ca/publication/insights/v09n02/us/index.html', 'http://sitelevel.whatuseek.com/query.go?B1=Search&crid=140f069465cde402&query={$formKeywords}', NULL, 8),
(4457, 858, 'Educational Technology and Society [USA]', 'Educational Technology & Society seeks academic articles on the issues affecting the developers of educational systems and educators who implement and manage such systems.', 'http://www.ifets.info/index.php?http://www.ifets.info/aim.php', 'http://odysseus.ieee.org/query.html?col=wg&qp=url%3Aifets.ieee.org%2Fperiodical&qs=&qc=wg&ws=0&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 9),
(4458, 858, 'First Monday [USA]', 'First Monday is one of the first peer-reviewed journals on the Internet, offering critical analysis of the Internet.', 'http://www.firstmonday.org/idea.html', 'http://www.firstmonday.org/fm.search?numdocs=20&query={$formKeywords}', NULL, 10),
(4459, 858, 'Global Journal of Engineering Education [Australia]', 'Global Journal of Engineering Education (GJEE), providing the international engineering education community with a forum for discussion and the exchange of information on engineering education and industrial training at tertiary level.', 'http://www.eng.monash.edu.au/uicee/gjee/globalj.htm', 'http://ultraseek.its.monash.edu.au/query.html?rq=0&col=m0&qp=&qs=+AND+url%3Ahttp%3A%2F%2Fwww.eng.monash.edu.au%2Fuicee%2Fgjee&qc=&pw=100%25&ws=1&la=&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 11),
(4460, 858, 'Journal of American Indian Education [USA]', 'The Journal of American Indian Education is a peer reviewed scholarly journal, which publishes papers specifically related to the education of American Indians and Alaska Natives. While the focus of the Journal is on basic applied research, manuscripts that are expository in nature and present an explicative or interpretive perspective are considered for publication as well. JAIE is particularly interested in publishing manuscripts that express the viewpoint of AI/AN and research that is initiated, conducted, and interpreted by natives.', 'http://jaie.asu.edu/', 'http://www.google.com/u/arizonastate?sa=Search&domains=jaie.asu.edu&sitesearch=jaie.asu.edu&hq=inurl%3Ajaie.asu.edu&q={$formKeywords}', NULL, 12),
(4461, 858, 'Journal of Vocational and Technical Education [USA]', 'The Journal of Vocational and Technical Education (JVTE) is a non-profit, refereed national publication of Omicron Tau Theta, the national, graduate honorary society of vocational and technical education.', 'http://scholar.lib.vt.edu/ejournals/JVTE/', 'http://scholar.lib.vt.edu:8765/query.html?rq=0&qp=url%3Ahttp%3A%2F%2Fscholar.lib.vt.edu%2Fejournals%2F&col=ejournal&qp=&qs=&qc=&pw=100%25&ws=0&la=&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 13),
(4462, 858, 'Kairos: A Journal for Teachers of Writing in Webbed Environments [USA]', 'Kairos is a refereed online journal exploring the intersections of rhetoric, technology, and pedagogy.', 'http://english.ttu.edu/kairos/', 'http://www.google.com/u/Kairos?hq=inurl%3Aenglish.ttu.edu%2Fkairos&btnG=Search+Kairos&q={$formKeywords}', NULL, 14),
(4463, 858, 'Language, Learning, and Technology [USA]', 'Online journal devoted to technology and language education research for foreign and second language.', 'http://llt.msu.edu/', 'http://www.google.com/u/llt?q={$formKeywords}', NULL, 15),
(4464, 858, 'Medical Education Online: An Electronic Journal [USA]', 'Medical Education Online (MEO) is a forum for disseminating information on educating physicians and other health professionals. Manuscripts on any aspect of the process of training health professionals will be considered for peer-reviewed publication in an electronic journal format. In addition MEO provides a repository for resources such as curricula, data sets, syllabi, software, and instructional material developers wish to make available to the health education community.', 'http://www.med-ed-online.org/', 'http://www.google.com/search?&q=site%3Awww.med-ed-online.org+{$formKeywords}', NULL, 16),
(4465, 858, 'National CROSSTALK, The National Center for Public Policy and Higher Education [USA]', 'The Center publishes the National CROSSTALK to provide action-oriented analyses of state and federal policies affecting education beyond high school.', 'http://www.highereducation.org/crosstalk/index.html', 'http://www.google.com/search?&q=site%3Awww.highereducation.org%2Fcrosstalk%2F+{$formKeywords}', NULL, 17),
(4466, 858, 'Philosophy of Education: Yearbook of the Philosophy of Education Society [USA]', 'Annual collections of some of the best work in the field of Educational Philosophy.', 'http://www.ed.uiuc.edu/EPS/PES-Yearbook/', 'http://www.googlesyndicatedsearch.com/u/pesyearbook?h1=en&hq=inurl%3Awww.ed.uiuc.edu%2Feps%2Fpes-yearbook&btnG=go&q={$formKeywords}', NULL, 18),
(4467, 858, 'Practical Assessment, Research and Evaluation [USA]', 'Practical Assessment, Research and Evaluation (PARE) is an on-line journal published by the edresearch.org and the Department of Measurement, Statistics, and Evaluation at the University of Maryland, College Park. Its purpose is to provide education professionals access to refereed articles that can have a positive impact on assessment, research, evaluation, and teaching practice, especially at the local education agency (LEA) level.', 'http://pareonline.net/', 'http://www.google.com/custom?domains=pareonline.net%2Fgetvn.asp&sa=Google+Search&sitesearch=pareonline.net%2Fgetvn.asp&client=pub-8146434030680546&forid=1&channel=9117733086&ie=ISO-8859-1&oe=ISO-8859-1&flav=0000&sig=cmg6qt6VP1GSt2jo&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFDD%3BLBGC%3AFFFFDD%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A50%3BLW%3A341%3BL%3Ahttp%3A%2F%2Fpareonline.net%2Fprac3.gif%3BS%3Ahttp%3A%2F%2F%3BFORID%3A1%3B&hl=en&q={$formKeywords}', NULL, 19),
(4468, 858, 'The Qualitative Report [USA]', 'The Qualitative Report (ISSN 1052-0147) is a peer-reviewed, on-line journal devoted to writing and discussion of and about qualitative, critical, action, and collaborative inquiry and research.', 'http://www.nova.edu/ssss/QR/index.html', 'http://www.nova.edu/bin/QR.pl?Search+Criteria={$formKeywords}', NULL, 20),
(4469, 858, 'Reading Online: An Electronic Journal of the International Reading Association [USA]', 'A journal for literacy educators K-12; includes articles, commentaries, reviews, and discussion forums.', 'http://www.readingonline.org/', 'http://www.readingonline.org/search/search.asp?QueryForm=&sc=articles&sm=all&qu={$formKeywords}', NULL, 21),
(4470, 858, 'Teaching English as a Second Language [USA]', 'TESL-EJ, Teaching English as a Second Language Electronic Journal, is a fully-refereed academic journal for the English as a Second Language, English as a Foreign Language.', 'http://www-writing.berkeley.edu/TESL-EJ/', 'http://www.google.com/u/berkeleywriting?sa=Google+Search&domains=www-writing.berkeley.edu%2FTESL-EJ%2F&sitesearch=www-writing.berkeley.edu&q={$formKeywords}', NULL, 22),
(4471, 859, 'Education Theory', 'Educational Theory is a quarterly journal of philosophy of education and related disciplines.', 'http://www.ed.uiuc.edu/EPS/Educational-Theory/', 'http://www.google.com/search?&q=site%3Awww.ed.uiuc.edu%2FEPS%2FEducational-Theory %2F+{$formKeywords}', NULL, 0),
(4472, 860, 'Education Research', 'RAND posts reports of its public policy research on education topics. Issues such as K-12 assessment and accountability, school reform, teachers and teaching, higher education, military education and training, and worker training are addressed.', 'http://www.rand.org/research_areas/education/', 'http://vivisimo.rand.org/vivisimo/cgi-bin/query-meta?v%3Aproject=pubs&input-form=simple&Go=Search&query={$formKeywords}', NULL, 0),
(4473, 860, 'ERIC Digests', 'ERIC Digests include:  \n\n- short reports (1,000 - 1,500 words) on topics of prime current interest in education. There are a large variety of topics covered including teaching, learning, libraries, charter schools, special education, higher education, home schooling, and many more. \n\n- targeted specifically for teachers, administrators, policymakers, and other practitioners, but generally useful to the broad educational community.  \n\n- designed to provide an overview of information on a given topic, plus references to items providing more detailed information.  \n\n- produced by the former 16 subject-specialized ERIC Clearinghouses, and reviewed by experts and content specialists in the field.  \n\n- funded by the Office of Educational Research and Improvement (OERI), of the U.S. Department of Education (ED).  \n\n- The full-text ERIC Digest database contains over 3000 Digests with the latest updates being added to this site in July 2005.', 'http://www.ericdigests.org/', 'http://www.google.com/custom?domains=ericdigests.org&sitesearch=ericdigests.org&q={$formKeywords}', NULL, 1),
(4474, 860, 'ED Pubs Online Ordering System', 'ED Pubs Online Ordering System is intended to help users identify and order U.S. Department of Education products. All publications are provided at no cost to the general public by the U.S. Department of Education. ', 'http://www.edpubs.org/webstore/Content/search.asp', 'http://www.edpubs.org/webstore/EdSearch/SearchResults.asp?Search=True&CQQUERYTYPE=2&CQFULLTEXT={$formKeywords}', NULL, 2),
(4475, 860, 'Education-Line: Electronic Texts in Education and Training', 'Education-Line: Electronic Texts in Education and Training (UK) is a searchable "electronic archive of ''gray'' (report, conference, working paper) and ''pre-print'' literature in the field of education and training." Provided by the British Education Index (BEI), this database provides access to over 1,000 papers presented at British research conferences and elsewhere. Provides links to searchable paper files from conferences sponsored by the British Educational Research Association, the European Conference on Educational Research, and others.', 'http://www.leeds.ac.uk/educol/', 'http://brs.leeds.ac.uk/cgi-bin/brs_engine?*ID=1&*DB=BEID&*PT=50&*FT=BEID&*HI=Y&TITL=&AUTH=&SUBJ=&*SO=TITL&SUBMIT_BUTTON=search%20button&*QQ={$formKeywords}', NULL, 3),
(4476, 860, 'SearchERIC', 'Tools to search the abstracts and Digests produced by the ERICSM system.', 'http://www.eric.ed.gov/', 'http://www.google.com/custom?domains=www.eric.ed.gov&sa=Google+Search&sitesearch=www.eric.ed.gov&q={$formKeywords}', NULL, 4),
(4477, 860, 'ERIC - Education Resources Information Center', 'ERIC - the Education Resources Information Center - is an internet-based digital library of education research and information sponsored by the Institute of Education Sciences (IES) of the U.S. Department of Education. \n\nERIC provides access to bibliographic records of journal and non-journal literature indexed from 1966 to the present. \n\nThe ERIC collection includes bibliographic records (citations, abstracts, and other pertinent data) for more than 1.2 million items indexed since 1966, including journal articles, books,  research syntheses, conference papers, technical reports, \npolicy papers, and other education-related materials.\n\nERIC currently indexes more than 600 journals, the majority of which are indexed comprehensively â€” every article in each issue is included in ERIC. Some journals are indexed selectively â€” only those articles that are education-related are selected for indexing. \n\nIn addition, contributors have given ERIC permission to display more than 115,000 full-text materials in PDF format - at no charge. These materials are generally part of the recent "grey literature" such as conference papers and reports, rather than journal articles and books. Most materials published 2004 and forward include links to other sources, including publishers'' Web sites.', 'http://eric.ed.gov/', 'http://eric.ed.gov/ERICWebPortal/Home.portal?_nfpb=true&ERICExtSearch_SearchType_0=kw&_pageLabel=ERICSearchResult&newSearch=true&rnd=1189800475852&searchtype=keyword&ERICExtSearch_SearchValue_0={$formKeywords}', NULL, 5),
(4478, 860, 'Education Review (ER)', 'Education Review publishes reviews of recent books in education, covering the entire range of education scholarship and practice.', 'http://edrev.asu.edu/index.html', 'http://edrev.asu.edu/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=edrev.asu.edu&restrict=&exclude=&words={$formKeywords}', NULL, 6),
(4479, 861, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingentaconnect.com/', 'http://www.ingentaconnect.com/search?form_name=advanced&title_type=tka&author=&journal=&journal_type=words&volume=&issue=&database=1&year_from=2002&year_to=2007&pageSize=20&x=42&y=13&title={$formKeywords}', NULL, 0),
(4480, 861, 'ebrary', 'Independent researchers who do not have access to ebrary''s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4481, 861, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4482, 861, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4483, 862, 'H-Net, Humanities & Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www2.h-net.msu.edu/lists/', 'http://www2.h-net.msu.edu/logsearch/index.cgi?type=boolean&hitlimit=25&field=&nojg=on&smonth=00&syear=1989&emonth=11&eyear=2004&order=relevance&phrase={$formKeywords}', NULL, 0),
(4484, 862, 'JISCmail', 'The National Academic Mailing List Service, known as ''JISCmail'', is one of a number of JANET services provided by JANET(UK) (www.ja.net) and funded by the JISC (www.jisc.ac.uk) to benefit learning, teaching and research communities. The Science and Technology Facilities Council (www.scitech.ac.uk) currently operates and develops the JISCmail service on behalf of JANET(UK).', 'http://www.jiscmail.ac.uk/index.htm', 'http://www.jiscmail.ac.uk/cgi-bin/listsearcher.cgi?', 'chk_wds=chk_wds&opt=listsearcher&thecriteria={$formKeywords}', 1),
(4485, 863, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(4486, 864, 'BBC Learning', 'BBC Online - Education BBC Education. Access to excellent learning resources for adults and children. Lots of subjects - history, science, languages, health, work skills, culture, technology, arts, literature, business, nature, life, leisure.', 'http://www.bbc.co.uk/learning', 'http://www.bbc.co.uk/cgi-bin/search/results.pl?go.x=0&go.y=0&go=go&uri=%2Flearning%2F&q={$formKeywords}', NULL, 0),
(4487, 864, 'Educator''s Reference Desk', 'The people who created AskERIC announce a new service and name to access the resources you''ve come to depend on for over a decade. While the U.S. Department of Education will discontinue the AskERIC service December 19th, you will still have access to the resources you''ve come to depend upon. Through The Educator''s Reference Desk (http://www.eduref.org) you can access AskERIC''s 2,000+ lesson plans, 3,000+ links to online education information, and 200+ question archive responses. While the question answer service will no longer be active, The Educator''s Reference Desk provides a search interface to the ERIC Databases, providing access to over one million bibliographic records on educational research, theory, and practice.', 'http://www.eduref.org/', 'http://www.google.com/search?&q=site%3Awww.eduref.org+{$formKeywords}', NULL, 1),
(4488, 864, 'Marco Polo', 'MarcoPolo: Internet Content for the Classroom is a nonprofit consortium of premier national and international education organizations and the MCI Foundation dedicated to providing the highest quality Internet content and professional development to teachers and students throughout the United States.', 'http://www.marcopolo-education.org/', 'http://www.marcopolosearch.org/mpsearch/Search_Results.asp?orgn_id=2&log_type=1&hdnFilter=&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 2),
(4489, 864, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', NULL, 3),
(4490, 864, 'Community Learning Network', 'Community Learning Network is designed to help K-12 teachers integrate technology into the classroom.', 'http://www.cln.org/', 'http://www.openschool.bc.ca/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=htdig_cln&restrict2=&submit2=Search&words={$formKeywords}', NULL, 4),
(4491, 864, 'Educational Media Reviews Online', 'Educational Media Reviews Online is a database of video, DVD, and CD-ROM reviews on materials from major educational and documentary distributors. The reviews are written primarily by librarians and teaching faculty in institutions across the United States and Canada.', 'http://libweb.lib.buffalo.edu/emro/about.asp', 'http://libweb.lib.buffalo.edu/emro/EmroResults.asp?Title=&Subject=%25&Reviewer=&Year=%25&Rating=%25&Distributor=&Format=%25&Submit=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0&Keyword={$formKeywords}', NULL, 5),
(4492, 864, 'Gateway to Educational Materials (GEM)', 'This site offers a one-stop educational resource to Internet lesson plans, curriculum units, and activities pertaining to all K-12 subjects. Users can browse sites by subject or keyword, desired grade or education level. They can also search by subject, keyword, title, and full-text of the site description. Sources include the AskERIC Virtual Library, the Eisenhower National Clearinghouse, Math Forum, Microsoft Encarta, the North Carolina Department of Public Instruction, and the US Department of Education.', 'http://www.thegateway.org/', 'http://64.119.44.148/portal_seamarksearch/makesearch?isliteral=yes&operator=contains&form.submitted=1&dimension=fulltext&ss=Go&value={$formKeywords}', NULL, 6),
(4493, 864, 'Merlot', 'Merlot is a free and open resource designed primarily for faculty and students in higher education. With a continually growing collection of online learning materials, peer reviews and assignments, MERLOT helps faculty enhance instruction.', 'http://www.merlot.org/Home.po', 'http://www.merlot.org/merlot/materials.htm?keywords={$formKeywords}', NULL, 7),
(4494, 864, 'SMETE', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/public/find/search_results.jhtml?_DARGS=/smete/home_body.jhtml&_D:/smete/forms/SimpleSearchForm.keyword=&/smete/forms/SimpleSearchForm.operation=simpleSearch&_D:/smete/forms/SimpleSearchForm.operation=&&/smete/forms/SimpleSearchForm.keyword={$formKeywords}', NULL, 8),
(4495, 865, 'National Center for Education Statistics', 'The site of the Department of Education''s major statistical agency has a catalog of publications available, with text and tables from some of the publications.', 'http://nces.ed.gov/', 'http://search.nces.ed.gov/search?output=xml_no_dtd&client=nces&proxystylesheet=nces&site=nces&q={$formKeywords}', NULL, 0),
(4496, 865, 'Federal Resources for Educational Excellence', 'Federal Resources For Educational Excellence: More than 30 Federal agencies formed a working group in 1997 to make hundreds of education resources supported by agencies across the U.S. Federal government easier to find. The result of that work is the FREE web site. Subjects include: Arts, Educational technology, Foreign languages, Health and Safety, Language arts, Mathematics, Physical education, Science, Social studies, and Vocational education.', 'http://free.ed.gov/template.cfm?template=About%20FREE', 'http://free.ed.gov/searchres.cfm', 'searchword={$formKeywords}', 1),
(4497, 865, 'EdResearch Online', 'The EdResearch Online database hasover 12,000 online education research documents and articles. These form a subset of the Australian Education Index.', 'http://cunningham.acer.edu.au/dbtw-wpd/sample/edresearch.htm', 'http://cunningham.acer.edu.au/dbtw-wpd/exec/dbtwpub.dll', 'MF=&AC=QBE_QUERY&NP=2&RL=0&QF0=AUTHOR | CORPORATE AUTHOR | TITLE | SUBJECTS | ORGANISATIONS | ABSTRACT | GEOGRAPHICAL | ADDED AUTHORS | ADDED CORPORATE | IDENTIFIERS | JOURNAL TITLE | ISSN&TN=edresearchonline&DF=Web_Full&RF=Web_Brief&MR=50&DL=0&QI0={$formKeywords}', 2),
(4498, 865, 'National Clearinghouse for Educational Facilities', 'This site''s resources include "free information about K-12 school planning, design, financing, construction, operations and maintenance." The Libraries/Media Centers section includes a bibliography of books and articles covering all aspects of construction management, architecture, and cost estimation. Disaster planning, health, and environmental issues receive consideration. Check the links for other professional organizations, government programs and agencies, research centers, products, and services. Click on Gallery to view project graphics. Searchable.', 'http://www.edfacilities.org/', 'http://www.edfacilities.org/search/index.cfm', 'RequestTimeout=300&SearchSortField1=NCEFDate&SearchSortOrder1=DESC&SearchScope=All&SearchLogic=AND&SearchKeywords={$formKeywords}', 3),
(4499, 865, 'Education Development Center', 'The EDC is an international, non-profit organization with more than 335 continuing projects focused on the enhancement of eduThis site''s resources include "free information about K-12 school planning, design, financing, construction, operations and maintenance." The Libraries/Media Centers section includes a bibliography of books and articles covering all aspects of construction management, architecture, and cost estimation. Disaster planning, health, and environmental issues receive consideration. Check the links for other professional organizations, government programs and agencies, research centers, products, and services. Click on Gallery to view project graphics. Searchable.cational methods and initiatives.  The Center''s site includes information related the use of technology in education.', 'http://main.edc.org/', 'http://google2.edc.org/search?site=newsroom&client=edc_main&proxystylesheet=edc_main&output=xml_no_dtd&filter=0&q={$formKeywords}', NULL, 4),
(4500, 865, 'ENC Online: Eisenhower National Clearinghouse for Mathematics and Science Education', 'Established in 1992 with funding from the U.S. Department of Education, the mission of the clearinghouse is to "acquire and catalog mathematics and science curriculum resources, creating the most comprehensive collection in the nation; provide the best selection of math and science education resources on the Internet; support teachers'' professional development in math, science, and the effective use of technology; serve all K-12 educators, parents, and students with free products and services."\n\nENC.ORG is now goENC.COM!', 'http://www.goenc.com/', 'http://www.goenc.com/search/default.asp?page=1&pagelength=10&grade=G0&resourceType=R0&go=Search&searchText={$formKeywords}', NULL, 5),
(4501, 866, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4502, 866, 'Government of Canada homepage', 'This is the primary internet portal for information on the Government of Canada, its programmes, services, new initiatives and products, and for information about Canada. Among its features are three audience-based gateways that provide access to information and services for: Canadians, Non-Canadians, and Canadian business.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.collectionscanada.ca/fed/searchResults.jsp?SourceQuery=&ResultCount=5&PageNum=1&MaxDocs=-1&SortSpec=score+desc&Language=eng&Sources=amicus&Sources=mikan&Sources=web&QueryText.x=11&QueryText.y=13&QueryText={$formKeywords}', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=&kl=XX&op=a&q={$formKeywords}', 1),
(4503, 866, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4504, 866, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4505, 866, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4506, 866, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu/geninfo/query/resultaction.jsp?', 'qtype=simple&Collection=EuropaFull&ResultTemplate=/result_en.jsp&DefaultLG=en&ResultCount=10&html=&QueryText={$formKeywords}', 5),
(4507, 866, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4508, 866, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?ms0=%A0&mt0=all&st=AS&rn=2&parsed=true&db=www-fed-all&mw0={$formKeywords}', NULL, 7),
(4509, 866, 'Canada Site', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4510, 867, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4511, 867, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(4512, 867, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=', 'Content=&searchword={$formKeywords}', 2),
(4513, 867, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(4514, 867, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(4515, 867, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 5),
(4516, 867, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(4517, 867, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.themoscowtimes.com/indexes/01.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(4518, 867, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(4519, 867, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(4520, 868, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4521, 868, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4522, 868, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4523, 868, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4524, 869, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4525, 869, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering & Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4526, 869, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4527, 869, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4528, 869, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4529, 869, 'National Environmental Publications Internet Site (NEPIS)', 'The National Environmental Publications Information System began in 1997, to offer over 9,000 full text, online documents of the United States Environmental Protection Agency. Documents that are not available online can be ordered from the agency through NEPIS.', 'http://nepis.epa.gov/', 'http://nepis.epa.gov/Exe/ZyNET.exe?User=ANONYMOUS&Password=anonymous&Client=EPA&SearchBack=ZyActionL&SortMethod=h&SortMethod=-&MaximumDocuments=15&Display=hpfr&ImageQuality=r85g16%2Fr85g16%2Fx150y150g16%2Fi500&DefSeekPage=x&ZyAction=ZyActionS&Toc=&TocEntry=&QField=&QFieldYear=&QFieldMonth=&QFieldDay=&UseQField=&Docs=&IntQFieldOp=0&ExtQFieldOp=0&File=&SeekPage=&Back=ZyActionL&BackDesc=Contents+page&MaximumPages=1&ZyEntry=0&TocRestrict=n&SearchMethod=1&Time=&FuzzyDegree=0&Index=National+Environmental+Publications+Info&Query={$formKeywords}', NULL, 5),
(4530, 870, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4531, 870, 'NAL Agricultural Thesaurus', 'NAL Agricultural Thesaurus was created to meet the needs of the United States Department of Agriculture (USDA), Agricultural Research Service (ARS), for an agricultural thesaurus. NAL Agricultural Thesaurus is for anyone describing, organizing and classifying agricultural resources such as: books, articles, catalogs, databases, patents, games, educational materials, pictures, slides, film, videotapes, software, other electronic media, or websites. It is organized into 17 subject categories.', 'http://agclass.nal.usda.gov/agt/agt.htm', 'http://search.nal.usda.gov/query.html?charset=iso-8859-1&ht=0&qp=&qs=-url%3Atektran&qc=-&pw=100%25&ws=0&la=en&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&si=1&x=15&y=8&qt={$formKeywords}', NULL, 1),
(4532, 870, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4533, 870, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4534, 870, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(4535, 870, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(4536, 871, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 0),
(4537, 871, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4538, 871, 'National Environmental Publications Internet Site (NEPIS)', 'The National Environmental Publications Information System began in 1997, to offer over 9,000 full text, online documents of the United States Environmental Protection Agency. Documents that are not available online can be ordered from the agency through NEPIS.', 'http://nepis.epa.gov/', 'http://nepis.epa.gov/Exe/ZyNET.exe?User=ANONYMOUS&Password=anonymous&Client=EPA&SearchBack=ZyActionL&SortMethod=h&SortMethod=-&MaximumDocuments=15&Display=hpfr&ImageQuality=r85g16%2Fr85g16%2Fx150y150g16%2Fi500&DefSeekPage=x&ZyAction=ZyActionS&Toc=&TocEntry=&QField=&QFieldYear=&QFieldMonth=&QFieldDay=&UseQField=&Docs=&IntQFieldOp=0&ExtQFieldOp=0&File=&SeekPage=&Back=ZyActionL&BackDesc=Contents+page&MaximumPages=1&ZyEntry=0&TocRestrict=n&SearchMethod=1&Time=&FuzzyDegree=0&Index=National+Environmental+Publications+Info&Query={$formKeywords}', NULL, 2),
(4539, 871, 'National Library for the Environment', 'A universal, timely, and easy-to-use single-point entry to quality environmental data and information for the use of all participants in the environmental enterprise.', 'http://www.ncseonline.org/nle/index.cfm?&CFID=8843778&CFTOKEN=66834254', 'http://www.ncseonline.org/NLE/CRS/detail.cfm?quickKeyword={$formKeywords}', NULL, 3),
(4540, 872, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4541, 872, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4542, 872, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4543, 872, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4544, 872, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4545, 872, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4546, 872, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4547, 873, 'EnviroLink', 'The EnviroLink Network has served as the online clearinghouse for environmental information since 1991.', 'http://www.envirolink.org/', 'http://www.envirolink.org/newsearch.html?searchfor={$formKeywords}', NULL, 0),
(4548, 874, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4549, 874, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4550, 874, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4551, 874, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4552, 875, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/mind/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 0),
(4553, 876, 'Climate Data Inventories', 'Climate data inventories comprises a partial inventory of NCDC data sets and a complete list of weather observation stations, including inventory/station lists for U.S. and global surface data and inventory/station lists for U.S. and global upper air data.', 'http://lwf.ncdc.noaa.gov/oa/climate/climateinventories.html', 'http://crawl.ncdc.noaa.gov/search?site=ncdc&output=xml_no_dtd&client=ncdc&lr=&proxystylesheet=ncdc&oe=&q={$formKeywords}', NULL, 0),
(4554, 876, 'U.S. Geological Survey', 'The U.S. Geological Survey provides information to describe and understand the Earth. This information is used to: minimize loss of life and property from natural disasters; manage water, biological, energy, and mineral resources; enhance and protect the quality of life; and contribute to wise economic and physical development. This site describes its programs, projects, publications, research, jobs, library, and educational resources. It also provides links to news releases.', 'http://www.usgs.gov/', 'http://search.usgs.gov/query.html?col=usgs&col=top2000&ht=0&qp&qs=&qc=&pw=100%25&ws=1&la=&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&si=0=&qt={$formKeywords}', NULL, 1),
(4555, 877, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4556, 877, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4557, 877, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4558, 877, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4559, 878, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4560, 878, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(4561, 878, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(4562, 878, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(4563, 878, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(4564, 878, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(4565, 878, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(4566, 878, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(4567, 878, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(4568, 878, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(4569, 879, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4570, 879, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4571, 879, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4572, 879, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4573, 880, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4574, 880, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science.  The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4575, 880, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4576, 880, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(4577, 880, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4578, 880, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 5),
(4579, 880, 'NASA Technical Report Server', 'NASA Technical Report Server (NTRS) is to provide students, educators, and the public access to NASA''s technical literature. NTRS also collects scientific and technical information from sites external to NASA to broaden the scope of information available to users.', 'http://ntrs.nasa.gov/index.jsp?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 6),
(4580, 880, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 7),
(4581, 880, 'KOSMOI', 'KOSMOI includes educational articles, books, posters, & web links for all interested in the wonders of our Cosmos, on Science, Space, Technology, Nature, & Web Design. Updated daily.', 'http://kosmoi.com/', 'http://www.google.com/custom?sa=Search&cof=GIMP%3A%23cccccc%3BT%3A%23ffdd99%3BLW%3A468%3BALC%3Ared%3BL%3Ahttp%3A%2F%2Fencyclozine.com%2FPictures%2FBanner%2FEncycloZine2.jpg%3BGFNT%3A%23999999%3BLC%3A%23ffcc33%3BLH%3A60%3BBGC%3Ablack%3BAH%3Acenter%3BVLC%3A%23ffcc66%3BGL%3A2%3BGALT%3A%23ffffff%3BAWFID%3A29728ead1ae72975%3B&domains=EncycloZine.com%3BKosmoi.com%3BEluzions.com&sitesearch=Kosmoi.com&q={$formKeywords}', NULL, 8),
(4582, 881, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4583, 881, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 1),
(4584, 881, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 2),
(4585, 881, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 3),
(4586, 881, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 4),
(4587, 882, 'Science Books and Films', 'Science Books and Films is the AAAS review journal for science materials for all ages, including reviews and recommendations for books, videos, software, and web sites.', 'http://sbfonline.com/', 'http://sbfonline.com/sample/search.cgi?title_query_type=all&author_query_type&author=&other=&type=B&type=F&type=S&title={$formKeywords}', NULL, 0),
(4588, 882, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 1),
(4589, 882, 'National Academy Press(NAP)', 'The National Academy Press (NAP) publishes over 200 books a year on a wide range of topics in science, engineering, and health, capturing the most authoritative views on important issues in science and health policy.', 'http://books.nap.edu/books/0309070317/html/177.html', 'http://search.nap.edu/nap-cgi/napsearch.cgi?term={$formKeywords}', NULL, 2),
(4590, 882, 'E-STREAMS', 'E-STREAMS: Electronic reviews of Science & Technology References covering Engineering, Agriculture, Medicine and Science. Each issue contains 30+ STM reviews, covering new titles in Engineering, Agriculture, Medicine and Science. Each review is signed, and includes the email address of the reviewer. The reviews feature short TOCs, a list of contributors and bibliographic information.', 'http://www.e-streams.com/', 'http://www.e-streams.com/c3/cgi-bin/search.pl', 'boolean=AND&case=Insensitive&terms={$formKeywords}', 3),
(4591, 882, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 4),
(4592, 882, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 5),
(4593, 882, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 6),
(4594, 883, 'Science.gov', 'Science.gov is a gateway to over 50 million pages of authoritative selected science information provided by U.S. government agencies, including research and development results.', 'http://www.science.gov', 'http://www.science.gov/scigov/search.html?expression={$formKeywords}', NULL, 0),
(4595, 883, 'SciCentral', 'A directory of links to "today''s breaking science news." Browsable by topic, including biosciences, health sciences, physics, chemistry, earth and space, and engineering. Also includes links to related journals, databases, job opportunities, and conferences.', 'http://scicentral.com/', 'http://www.google.com/custom?client=pub-2641291926759270&forid=1&channel=1291454416&ie=ISO-8859-1&oe=ISO-8859-1&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23FFFFFF%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A9999FF%3BGIMP%3A9999FF%3BLH%3A50%3BLW%3A78%3BL%3Ahttp%3A%2F%2Fwww.scicentral.com%2Fimages%2Fscclogo_for_google.gif%3BS%3Ahttp%3A%2F%2Fwww.scicentral.com%3BFORID%3A1%3B&hl=en&q={$formKeywords}', NULL, 1),
(4596, 884, 'Channel 4 Science', 'Channel 4''s science site covers a wide range of current scientific issues from science in society to science in medicine. The site is split into broad sections, each containing related topics, articles and programme information. There are resources at the end of the articles with listings of related Web Sites and reading material. The site also contains a helpful glossary and an "Ask an expert" facility for posing scientific queries to a body of scientific experts.', 'http://www.channel4.com/science/index.html', 'http://search.channel4.com/search?&sort=date%3AD%3AL%3Ad1&output=xml_no_dtd&ie=UTF-8&oe=UTF-8&client=standard_c4&proxystylesheet=standard_c4&q={$formKeywords}', NULL, 0),
(4597, 884, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science.  The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4598, 884, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?author1=&pubdate_year=&volume=&firstpage=&src=hw&hits=10&hitsbrief=25&resourcetype=1&andorexactfulltext=and&fulltext={$formKeywords}', NULL, 2),
(4599, 884, 'FirstGov for Science', 'Science.gov is a gateway to authoritative selected science information provided by U.S. Government agencies, including research and development results.  It enables you to search 47 million pages in real time.', 'http://science.gov/', 'http://www.science.gov/search30/search.html?expression={$formKeywords}', NULL, 3),
(4600, 884, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 4),
(4601, 884, 'CASI Technical Report Server', 'CASI Technical Report Server contains bibliographic citations and abstracts to unclassified documents announced in Scientific and technical aerospace reports, plus the document series produced by NASA''s predecessor, The National Advisory Committee for Aeronautics, and the NASA open literature file containing citations and abstracts to literature in the fields of aeronautics, space science, chemistry, engineering, geosciences, life sciences, mathematics, computer sciences, and physics.', 'http://www.sti.nasa.gov/RECONselect.html', 'http://ntrs.nasa.gov/index.cgi?method=search&limit=25&offset=0&mode=simple&order=DESC&keywords={$formKeywords}', NULL, 5),
(4602, 884, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 6),
(4603, 884, 'KOSMOI', 'KOSMOI includes educational articles, books, posters, & web links for all interested in the wonders of our Cosmos, on Science, Space, Technology, Nature, & Web Design. Updated daily.', 'http://kosmoi.com/', 'http://www.google.com/custom?sa=Search&cof=GIMP%3A%23cccccc%3BT%3A%23ffdd99%3BLW%3A468%3BALC%3Ared%3BL%3Ahttp%3A%2F%2Fencyclozine.com%2FPictures%2FBanner%2FEncycloZine2.jpg%3BGFNT%3A%23999999%3BLC%3A%23ffcc33%3BLH%3A60%3BBGC%3Ablack%3BAH%3Acenter%3BVLC%3A%23ffcc66%3BGL%3A2%3BGALT%3A%23ffffff%3BAWFID%3A29728ead1ae72975%3B&domains=EncycloZine.com%3BKosmoi.com%3BEluzions.com&sitesearch=Kosmoi.com&q={$formKeywords}', NULL, 7),
(4604, 884, 'PhilSci Archive', 'PhilSci Archive is an electronic archive for preprints in the philosophy of science.', 'http://philsci-archive.pitt.edu/', 'http://philsci-archive.pitt.edu/perl/search?_order=bytitle&abstract%2Fkeywords%2Ftitle_srchtype=ALL&_satisfyall=ALL&_action_search=Search&abstract%2Fkeywords%2Ftitle={$formKeywords}', NULL, 8),
(4605, 885, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4606, 885, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4607, 885, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4608, 885, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4609, 885, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(4610, 886, 'Scholarly Societies Project Meeting/Conference Announcement List', 'Scholarly Societies Project Meeting/Conference Announcement List is a searchable service provided by the University of Waterloo.', 'http://www.scholarly-societies.org/', 'http://ssp-search.uwaterloo.ca/cd.cfm?search_type=advanced&field1=any&boolean1=and&operator1=and&field2=any&textfield2=&boolean2=and&operator2=and&field3=any&textfield3=&boolean3=and&operator3=and&founded=none&&textfield1={$formKeywords}', NULL, 0),
(4611, 887, 'Ask the Experts', 'Ask the Experts is provided by the Scientific American magazine. Questions and answers are archived and organized.', 'http://www.sciam.com/askexpert', 'http://www.google.com/search?q=site%3Asciam.com+%22ask+the+experts%22%2B+', NULL, 0),
(4612, 887, 'EurekAlert!', 'EurekAlert! is an online press service created by the American Association for the Advancement of Science (AAAS). The primary goal of EurekAlert! is to provide a forum where research institutions, universities, government agencies, corporations and the like can distribute science-related news to reporters and news media. The secondary goal of EurekAlert! is to archive these press releases and make them available to the public in an easily retrievable system.', 'http://www.eurekalert.org/links.php', 'http://search.eurekalert.org/e3/query.html?col=ev3rel&qc=ev3rel&x=8&y=9&qt={$formKeywords}', NULL, 1),
(4613, 887, 'Mad Science Net: The 24-hour exploding laboratory', 'Mad Science Net: The 24-hour exploding laboratory is a collective cranium of scientists providing answers to your questions.', 'http://www.madsci.org/', 'http://www.madsci.org/cgi-bin/search?Submit=Submit+Query&or=AND&words=1&index=MadSci+Archives&MAX_TOTAL=25&area=All+areas&grade=All+grades&query={$formKeywords}', NULL, 2),
(4614, 887, 'JISCmail', 'The National Academic Mailing List Service, known as ''JISCmail'', is one of a number of JANET services provided by JANET(UK) (www.ja.net) and funded by the JISC (www.jisc.ac.uk) to benefit \nlearning, teaching and research communities. The Science and Technology Facilities Council (www.scitech.ac.uk) currently operates and develops the JISCmail service on behalf of JANET(UK).', 'http://www.jiscmail.ac.uk/about/index.htm', 'http://www.jiscmail.ac.uk/../cgi-bin/listsearcher.cgi?opt=listsearcher&listname=&alpha=&category=&chk_phrase=&chk_wds=ON&thecriteria={$formKeywords}', NULL, 3),
(4615, 888, 'Research Channel Programs: Stanford Science Online Videos', 'ResearchChannel is a consortium of research universities and corporate research divisions dedicated to broadening the access to and appreciation of our individual and collective activities, ideas, and opportunities in basic and applied research.', 'http://www.researchchannel.org/program/displayseries.asp?collid=134', 'http://www.researchchannel.org/search/sitesearch.aspx?RecordsPerPage=5&Order=Rank&keywords=program&Query={$formKeywords}', NULL, 0),
(4616, 888, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?', 'formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', 1),
(4617, 888, 'Science Learning Network', 'Science Learning Network is a community of educators, students, schools, science museums, and other institutions demonstrating a new model for inquiry into. Contains a variety of inquiry-posed problems, information, demonstrations, and labs.', 'http://www.sln.org/', 'http://192.231.162.154:8080/query.html?col=first&ht=0&qp=&qs=&qc=&pw=600&ws=1&la=&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&si=0&qt={$formKeywords}', NULL, 2),
(4618, 888, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 3),
(4619, 889, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(4620, 890, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4621, 890, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4622, 890, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4623, 890, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4624, 890, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4625, 890, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4626, 890, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4627, 890, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4628, 890, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4629, 891, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4630, 891, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/news/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(4631, 891, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(4632, 891, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(4633, 891, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 4),
(4634, 891, 'BBC Online: Science & Nature', 'The BBC online science and nature services which contain a wealth of information, resources and current news divided into clearly defined categories.  These categories include the human body, genes, prehistoric life, space and animals. A Hot Topics section explores the science behind the latest news.', 'http://www.bbc.co.uk/sn/', 'http://www.bbc.co.uk/cgi-bin/search/results.pl?uri=%2Fsn%2F&q={$formKeywords}', NULL, 5),
(4635, 891, 'Energy Science News', 'Published by the Office of Science, U.S. Department of Energy.  The purpose of this newsletter is to inform scientists, engineers, educators, students, and the public about the progress of scientific research supported by the Office of Science.', 'http://www.eurekalert.org/doe/', 'http://search.eurekalert.org/e3/query.html?col=ev3rel+ev3feat&ht=0&qp=%2Binstitution%3ADOE+OR+%2Bfunder%3A%22US+Department+of+Energy%22&qs=&qc=ev3rel+ev3feat&pw=%25&ws=0&la=&si=1&fs=&ex=&rq=0&oq=&qm=0&ql=&st=1&nh=10&lk=1&rf=1&qt={$formKeywords}', NULL, 6),
(4636, 891, 'ScienceDaily', 'Latest research news.', 'http://www.sciencedaily.com/index.htm', 'http://www.sciencedaily.com/search/?topic=all&dates=1995&dates=2005&sort=relevance&keyword={$formKeywords}', NULL, 7),
(4637, 892, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4638, 892, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4639, 892, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4640, 892, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4641, 893, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4642, 893, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 1),
(4643, 893, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4644, 893, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(4645, 894, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4646, 894, 'Columbia Encyclopedia', 'Serving as a "first aid" for those who read, the sixth edition of the Columbia Encyclopedia contains over 51,000 entries with 80,000 hypertext links.', 'http://www.bartleby.com/65/', 'http://www.bartleby.com/cgi-bin/texis/webinator/65search?search_type=full&query={$formKeywords}', NULL, 1),
(4647, 894, 'Encyclopedia.com', 'Online version of the Concise Electronic Encyclopedia. Entries are very short, so this site is better suited for fact checking than research.', 'http://www.encyclopedia.com/', 'http://www.encyclopedia.com/searchpool.asp?target={$formKeywords}', NULL, 2),
(4648, 894, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(4649, 894, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(4650, 894, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(4651, 894, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(4652, 895, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4653, 895, 'The Government of Canada', 'ou can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4654, 895, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4655, 895, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4656, 895, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4657, 895, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4658, 895, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4659, 896, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4660, 896, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4661, 896, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4662, 896, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4663, 897, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 0),
(4664, 897, 'New York Review of Books', 'Lengthy reviews from the well-respected print publication. The keyword-searchable archive covers 1983 to the present, with some free, many pay-per-view.', 'http://www.nybooks.com/index', 'http://www.nybooks.com/archives/search?author_name=%20&reviewed_author=&reviewed_item=&form=&year=&title={$formKeywords}', NULL, 1),
(4665, 897, 'CM : Canadian Review of Materials', 'CM: Canadian Review of Materials is an electronic reviewing journal. CM reviews Canadiana of interest to children and young adults, including publications produced in Canada, or published elsewhere but of special interest or significance to Canada, such as those having a Canadian writer, illustrator or subject. We review books, video and audio recordings and CD-ROMs.', 'http://www.umanitoba.ca/cm/', 'http://google.cc.umanitoba.ca/search?btnG=Search&sort=date%3AD%3AL%3Ad1&output=xml_no_dtd&site=default_collection&ie=UTF-8&oe=UTF-8&client=default_frontend&proxystylesheet=default_frontend&as_dt=i&as_sitesearch=http%3A%2F%2Fwww.umanitoba.ca%2Foutreach%2Fcm&q={$formKeywords}', NULL, 2),
(4666, 897, 'Leonardo Digital Book Reviews', 'Leonardo Digital Book reviews from the International Society for the Arts, Sciences and Technology', 'http://www.leonardo.info/', 'http://www.google.com/search?hl=en&btnG=Search&q=site%3Awww.leonardo.info%2Freviews%2F+{$formKeywords}', NULL, 3),
(4667, 898, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase. At this point, a total of 15,000 of 750,000 records are loaded into the database. Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/content.asp?l1=5&l2=23&l3=44&l4=25', 'http://www.crl.edu/DBSearch/dissertationsSummary.asp?language=English&title={$formKeywords}', NULL, 0),
(4668, 898, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 1),
(4669, 898, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 2),
(4670, 898, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 3),
(4671, 899, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 0),
(4672, 900, 'Bartlett''s Familiar Quotations', 'A collection of passages, phrases, and proverbs traced to their sources in ancient and modern literature (1919 edition).', 'http://www.bartleby.com/100/', 'http://www.bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=col100%20&x=9&y=11&query={$formKeywords}', NULL, 0),
(4673, 900, 'Quotations Page', 'Searchable database of several quotation resources on the Internet. See the Quotations Collections for a description of each.', 'http://www.quotationspage.com/', 'http://www.quotationspage.com/search.php3?Author=&C=mgm&C=motivate&C=classic&C=coles&C=lindsly&C=poorc&C=net&C=devils&C=contrib&x=60&y=11&Search={$formKeywords}', NULL, 1),
(4674, 901, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4675, 901, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4676, 901, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4677, 901, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4678, 902, 'BBC Learning', 'BBC Online - Education BBC Education. Access to excellent learning resources for adults and children. Lots of subjects - history, science, languages, health, work skills, culture, technology, arts, literature, business, nature, life, leisure.', 'http://www.bbc.co.uk/learning/', 'http://www.bbc.co.uk/cgi-bin/search/results.pl?go.x=0&go.y=0&go=go&uri=%2Flearning%2F&q={$formKeywords}', NULL, 0),
(4679, 902, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 1),
(4680, 902, 'High Beam Research', 'High Beam Research is a single search engine for all subjects. Will search and deliver results by email. Abstract and text for subscribers only.', 'http://www.highbeam.com/library/index.asp', 'http://www.highbeam.com/Search.aspx?st=NL&nml=True&t=&a=&src=ALM&src=BOOKS&src=DICT&src=ENCY&src=MAGS&src=MAPS&src=NEWS&src=PICS&src=THES&src=TRAN&src=WHITEPAPER&count=10&offset=0&sort=RK&sortdir=D&pst=INCLUDE_ALL&cn=&storage=ALL&display=ALL&sponsor=ALL&docclass=ALL&relatedid=&bid=&embargo=False&q={$formKeywords}', NULL, 2),
(4681, 902, 'RAND Research', 'For more than 50 years, the RAND Corporation has pursued its nonprofit mission by conducting research on importand and complicated problems. Initially, RAND (the name of which was derived from a contraction of the term research and development) focused on issues of national security. Eventually, RAND expanded its intellectual reserves to offer insight into other areas, such as business, education, health, law, and science. RAND''s innovative approach to problem solving has become the benchmark for all other "think tanks" that followed. Hot Topics in RAND Research analyzes education and world issues.', 'http://www.rand.org/hot_topics/index.html', 'http://vivisimo.rand.org/vivisimo/cgi-bin/query-meta?input-form=simple&Go=Search&query={$formKeywords}', NULL, 3),
(4682, 903, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4683, 903, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(4684, 903, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(4685, 903, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(4686, 903, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(4687, 903, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(4688, 903, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(4689, 903, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(4690, 903, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(4691, 903, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(4692, 904, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4693, 904, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4694, 904, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4695, 904, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4696, 905, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4697, 905, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 1),
(4698, 905, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4699, 905, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(4700, 905, 'Anthropological index', 'The Anthropological Index is a regionally arranged subject and author index to periodical articles in all areas of anthropology. It is produced by the Museum of Mankind Library.', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'Default_Years=#1957#1958#1959#1960#1961#1962#1963#1964#1965#1966#1967#1968#1969#1970#1971#1972#1973#1974#1975#1976#1977#1978#1979#1980#1981#1982#1983#1984#1985#1986#1987#1988#1989#1990#1991#1992#1993#1994#1995#1996#1997#1998#1999#2000#2001#2002#2003#2004#2005#Recent&Year=Recent&Text_w=&Text=&Author_w=&Subject1=&Subject2=&Subject3=&Email=You@whereever.edu&Refer=on&Author={$formKeywords}', 4),
(4701, 905, 'The English Server', 'The English Server contains humanities texts online with over 18,000 works, covering history, race, art & architecture, government and other topics.', 'http://eserver.org/', 'http://www.google.com/u/EServer?q={$formKeywords}', NULL, 5),
(4702, 905, 'IATH: Institute for Advanced Technology in the Humanities', 'IATH: Institute for Advanced Technology in the Humanities, from the University of Virginia at Charlottesville, provides access to web-based humanities research archives and reports, essays, and the current issue of Postmodern Culture, the Internet''s oldest peer-reviewed electronic journal in the humanities.', 'http://jefferson.village.virginia.edu/', 'http://www.google.com/u/iath?sa=Google+Search+of+IATH&domains=village.virginia.edu&sitesearch=village.virginia.edu&q={$formKeywords}', NULL, 6),
(4703, 905, 'The Online books Page', 'The Online books Page is the most comprehensive website that facilitates access to books that are freely readable over the Internet.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?amode=words&tmode=words&title=&author={$formKeywords}', NULL, 7),
(4704, 905, 'Perseus Digital Library', 'Perseus Digital library is designed to be resources for the study of the ancient world. Originally begun with coverage of the Archaic and Classical Greek world, has now expanded to Latin text and tools, Renaissance materials, and Papyri. Contains hundreds of texts by the major ancient authors and lexica and morphological databases and catalog entries for over 2,800 vases, sculptures, coins, buildings, and sites, including over 13,000 photographs of such objects.', 'http://www.perseus.tufts.edu/', 'http://www.perseus.tufts.edu/cgi-bin/vor?x=22&y=15&lookup={$formKeywords}', NULL, 8),
(4705, 905, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 9),
(4706, 906, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4707, 906, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 1),
(4708, 906, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 2),
(4709, 906, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 3),
(4710, 906, 'The Internet Encyclopedia of Philosophy', 'This encyclopedia contains articles adapted from public domain sources, adaptations of material written by the editor for classroom purposes, and original contributions by professional philosophers around the Internet.', 'http://www.utm.edu/research/iep/', 'http://www.google.com/search?hl=en&lr=&q=site%3Awww.utm.edu%2Fresearch%2Fiep%2F+{$formKeywords}', NULL, 4),
(4711, 906, 'Stanford Encyclopedia of Philosophy', 'Stanford Encyclopedia of Philosophy is a searchable encyclopedia of philosophy providing in-depth explanations for terms.', 'http://plato.stanford.edu/', 'http://plato.stanford.edu/cgi-bin/webglimpse.cgi?nonascii=on&errors=0&maxfiles=50&maxlines=30&maxchars=10000&ID=1&query={$formKeywords}', NULL, 5),
(4712, 906, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 6),
(4713, 906, 'WordNet', 'WordNet, an electronic lexical database, is considered to be the most important resource available to researchers in computational linguistics, text analysis, and many related areas. Its design is inspired by current psycholinguistic and computational theories of human lexical memory. English nouns, verbs, adjectives, and adverbs are organized into synonym sets, each representing one underlying lexicalized concept. Different relations link the synonym sets.', 'http://www.cogsci.princeton.edu/~wn/', 'http://wordnet.princeton.edu/perl/webwn?sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=&s={$formKeywords}', NULL, 7),
(4714, 907, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4715, 907, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://www.canada.gc.ca/main_e.html', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(4716, 907, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4717, 907, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4718, 907, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4719, 907, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4720, 907, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4721, 908, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4722, 908, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4723, 908, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4724, 908, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4725, 909, 'Literary Index (Gale Group)', 'This is "a master index to the major literature products published by Gale," including Contemporary Authors and Literature Criticism from 1400-1800. Also indexes print reference titles from Charles Scribner''s Sons, St. James Press, and Twayne Publishers. Many of these resources, commonly found in libraries, "contain complete biographies on authors and critical essays on their writings."', 'http://www.galenet.com/servlet/LitIndex', 'http://www.galenet.com/servlet/LitIndex/hits?ttlRad=ti&n=10&NA=&r=s&origSearch=true&o=DocTitle&l=8&c=1&secondary=false&u=LitIndex&t=KW&s=2&TI={$formKeywords}', NULL, 0),
(4726, 909, 'Internet Public Library Online Literary Criticism Collection', 'Browse the Internet Public Library''s collection of links to websites on western and non-western literary criticism. Organized by author, title of work studied and by literary period within a particular national tradition.', 'http://www.ipl.org/div/litcrit/', 'http://www.ipl.org/div/searchresults/?where=searchresults&words={$formKeywords}', NULL, 1),
(4727, 909, 'Poetry Portal', 'This is a very comprehensive and informative collection of links about poetry online, events, courses, styles, and publishing. The site also covers "ezines, poetry sites, audio poetry, literary appreciation, criticism and reviews, poetry courses, workshops, conferences, book and trade news, literary chit-chat and trade news, plus sources to improve your own writing and get it published."', 'http://www.poetry-portal.com/', 'http://www.google.com/search?hl=en&q=site%3Awww.poetry-portal.com+{$formKeywords}', NULL, 2),
(4728, 910, 'Bryn Mawr Classical Review', 'Bryn Mawr Classical Review contains full text of every book review published since 1990 in the Bryn Mawr Classical Review. Articles are indexed both by issue and by the title of the book.', 'http://ccat.sas.upenn.edu/bmcr/', 'http://ccat.sas.upenn.edu/cgi-bin/bmcr/bmcr_search?action=search&lookup={$formKeywords}', NULL, 0),
(4729, 910, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 1),
(4730, 910, 'The New York Times Books', 'The New York Times Books, updated daily, includes the entire Sunday Book reviews and a searchable archive of over 50,000 NYT book reviews dating back to 1980, bestseller lists and more (Need to sign up).', 'http://www.nytimes.com/auth/login?Tag=/&URI=/books/', 'http://query.nytimes.com/search/query?ppds=ctaxAbodyS&v1=Top%2FFeatures%2FBooks%2FBook+Reviews&sort=closest_newest&v2={$formKeywords}', NULL, 2),
(4731, 910, 'Early Modern Literary Studies', 'Early Modern Literary Studies (ISSN 1201-2459) is a refereed journal serving as a formal arena for scholarly discussion and as an academic resource for researchers in the area. Articles in EMLS examine English literature, literary culture, and language during the sixteenth and seventeenth centuries; responses to published papers are also published as part of a Readers'' Forum. Reviews evaluate recent work as well as academic tools of interest to scholars in the field. EMLS is committed to gathering and to maintaining links to the most useful and comprehensive internet resources for Renaissance scholars, including archives, electronic texts, discussion groups, and beyond.', 'http://www.shu.ac.uk/emls/emlshome.html', 'http://www.shu.ac.uk/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&matchesperpage=10&config=emls&restrict=&exclude=&words={$formKeywords}', NULL, 3),
(4732, 911, 'Anthropological index', 'The Anthropological Index is a regionally arranged subject and author index to periodical articles in all areas of anthropology. It is produced by the Museum of Mankind Library.', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'Default_Years=2001#2002#2003#2004#2005#Recent&Year=#1957#1958#1959#1960#1961#1962#1963#1964#1965#1966#1967#1968#1969#1970#1971#1972#1973#1974#1975#1976#1977#1978#1979#1980#1981#1982#1983#1984#1985#1986#1987#1988#1989#1990#1991#1992#1993#1994#1995#1996#1997#1998#1999#2000#2001#2002#2003#2004#2005#Recent&Text_w=&Author_w=&Subject1=&Subject2=&Subject3=&Email=You@whereever.edu&Refer=on&Author=&Text={$formKeywords}', 0),
(4733, 911, 'The English Server', 'The English Server contains humanities texts online with over 18,000 works, covering history, race, art & architecture, government and other topics.', 'http://eserver.org/', 'http://www.google.com/u/EServer?q={$formKeywords}', NULL, 1),
(4734, 911, 'IATH: Institute for Advanced Technology in the Humanities', 'IATH: Institute for Advanced Technology in the Humanities, from the University of Virginia at Charlottesville, provides access to web-based humanities research archives and reports, essays, and the current issue of Postmodern Culture, the Internet''s oldest peer-reviewed electronic journal in the humanities.', 'http://jefferson.village.virginia.edu/', 'http://www.google.com/u/iath?sa=Google+Search+of+IATH&domains=village.virginia.edu&sitesearch=village.virginia.edu&q={$formKeywords}', NULL, 2),
(4735, 911, 'NetSERF: the Internet connection for medieval resources', 'Detailed topical arrangement of links to a large number of sites pertaining to medieval history and culture.', 'http://www.netserf.org/', 'http://www.netserf.org/Features/Search/default.cfm?Search_Action=Process&Phrase_required=You must provide a search phrase with this option.&phrase={$formKeywords}', NULL, 3),
(4736, 911, 'The Online books Page', 'The Online books Page is the most comprehensive website that facilitates access to books that are freely readable over the Internet.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?author=&amode=words&tmode=words&title={$formKeywords}', NULL, 4),
(4737, 911, 'Perseus Digital Library', 'Perseus Digital library is designed to be resources for the study of the ancient world. Originally begun with coverage of the Archaic and Classical Greek world, has now expanded to Latin text and tools, Renaissance materials, and Papyri. Contains hundreds of texts by the major ancient authors and lexica and morphological databases and catalog entries for over 2,800 vases, sculptures, coins, buildings, and sites, including over 13,000 photographs of such objects.', 'http://www.perseus.tufts.edu/', 'http://www.perseus.tufts.edu/cgi-bin/vor?x=22&y=15&lookup={$formKeywords}', NULL, 5),
(4738, 911, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 6),
(4739, 911, 'Dictionary of Canadian Biography Online', 'A collection of authoritative biographies portraying noteworthy persons of both sexes (with the exception of those still living). This first phase presents persons who died between the years 1000 and 1920', 'http://www.biographi.ca/EN/index.html', 'http://www.biographi.ca/EN/Results.asp?ToDo=&Show=&Data1=&Data2=&Data3=&Data4=&Data5=&Data6=&&Data7=&Data8=&Data9=&Data10=&txtSearch={$formKeywords}', NULL, 7),
(4740, 912, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase. At this point, a total of 15,000 of 750,000 records are loaded into the database. Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/content.asp?l1=5&l2=23&l3=44&l4=25', 'http://www.crl.edu/DBSearch/dissertationsSummary.asp?language=English&title={$formKeywords}', NULL, 0),
(4741, 912, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 1),
(4742, 912, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 2),
(4743, 912, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 3),
(4744, 913, 'AAD', 'Access to archival Databases (AAD) System has approximately 350 data files with millions of records available online that are highly structured, such as in databases. The series selected for AAD identify specific persons, geographic areas, organizations, or dates. Some of these series serve as indexes to accessioned archival records in non-electronic formats. Includes a link to search descriptions of NARA''s non-electronic records through NARA''s online catalogue, ARC.', 'http://aad.archives.gov/aad', 'http://search.nara.gov/query.html?rq=0&qp=&rq=0&col=4ardor&col=3ourdoc&col=2pres&col=1arch&qs=&qc=&pw=100%25&ws=0&la=&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 0),
(4745, 913, 'Making of America: the Cornell University Library MOA collection', 'A digital library of primary sources in American social history from the antebellum period through reconstruction. The collection is particularly strong in the subject areas of education, psychology, American history, sociology, religion, and science and technology.', 'http://cdl.library.cornell.edu/moa/', 'http://cdl.library.cornell.edu/cgi-bin/moa/sgml/moa-idx?&type=simple&slice=1&layer=first&coll=both&year1=1815&ear2=1926&q1={$formKeywords}', NULL, 1),
(4746, 913, 'UIUC Digital Gateway to Cultural Heritage Materials', 'This gateway is using the OAI Protocol for harvesting metadata, and exposing it with a search interface to enhance resource discoverability for materials that represent cultural heritage. The repository includes metadata records donated by 39 institutions over 1.3 million records.', 'http://nergal.grainger.uiuc.edu/cgi/b/bib/bib-idx', 'http://nergal.grainger.uiuc.edu/cgi/b/bib/bib-idx?type=simple&xc=1&q6=&rgn6=identifier&rgn1=entire+record&op6=And&q1={$formKeywords}', NULL, 2),
(4747, 913, 'A2A - Access to Archives', 'Contains catalogues describing archives held throughout England and dating from the 900s to the present day.', 'http://www.a2a.org.uk/', 'http://www.a2a.org.uk/search/doclist.asp?nb=0&nbKey=1&com=1&properties=0601&keyword={$formKeywords}', NULL, 3),
(4748, 913, 'Archives Hub (UK)', 'A national gateway to descriptions of archives in UK universities and colleges.', 'http://www.archiveshub.ac.uk/', 'http://www.archiveshub.ac.uk/cgi-bin/deadsearch.cgi?server=SF&fieldidx1=descriptionWord&bool=AND&numreq=25&firstrec=1&format=sgml&noframes=0&maxrecs=50&firstrec=1&fieldcont1={$formKeywords}', NULL, 4),
(4749, 913, 'Catholic Encyclopedia', 'Contains full and authoritative information on Catholic interests, action, and doctrine.', 'http://www.newadvent.org/cathen/index.html', 'http://www.google.com/custom?domains=NewAdvent.org&sa=Search+New+Advent&sitesearch=NewAdvent.org&client=pub-8168503353085287&forid=1&ie=ISO-8859-1&oe=ISO-8859-1&safe=active&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3A336699%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BFORID%3A1%3B&hl=en&q={$formKeywords}', NULL, 5),
(4750, 913, 'Literature, Arts, and Medicine Databases', 'The Literature, Arts, & Medicine Database is an annotated multimedia listing of prose, poetry, film, video and art that was developed to be a dynamic, accessible, comprehensive resource for teaching and research in MEDICAL HUMANITIES, and for use in health/pre-health, graduate and undergraduate liberal arts and social science settings.', 'http://litmed.med.nyu.edu/Main?action=aboutDB', 'http://google.med.nyu.edu/search?btnG=search&access=p&entqr=0&output=xml_no_dtd&sort=date%3AD%3AL%3Ad1&ud=1&client=litmed_test&oe=UTF-8&ie=UTF-8&proxystylesheet=litmed_test&site=litmed_test&q={$formKeywords}', NULL, 6),
(4751, 913, 'Map Collection, Perry-Castaneda', 'Displays selected digitized images from the printed map collection housed at the University of Texas at Austin.', 'http://www.lib.utexas.edu/maps/index.html', 'http://www.lib.utexas.edu:8080/search/utlol/search.jsp?collections=utlol&collections=utdatabases&queryText={$formKeywords}', NULL, 7),
(4752, 914, 'Archives Portal', 'UNESCO, the United Nations Educational, Scientific, and Cultural Organization, provides a list of links to archives around the world with a Web presence.', 'http://portal.unesco.org/ci/en/ev.php-URL_ID=5761&URL_DO=DO_TOPIC&URL_SECTION=201.html', 'http://www.unesco.org/cgi-bin/webworld/portal_archives/cgi/search.cgi?search2=GO&query={$formKeywords}', NULL, 0),
(4753, 914, 'Digital South Asia Library', 'On-line information about contemporary and historical South Asia - including full-text documents, statistical data, electronic images, cartographic representations, and pedagogical resources for language instruction.', 'http://dsal.uchicago.edu/', 'http://www.google.com/u/dsal?sa=Search&q={$formKeywords}', NULL, 1),
(4754, 914, 'History Guide', 'Subject gateway to scholarly relevant information in history with a focus on Anglo-American history and the history of Central and Western Europe.', 'http://www.historyguide.de/', 'http://www.historyguide.de/allegrosuche.php?start=0&suchterm={$formKeywords}', NULL, 2),
(4755, 914, 'Dante Project (Dartmouth)', 'Searchable collection of texts including the Italian text of the Divine Comedy and commentaries.', 'http://dante.dartmouth.edu/', 'http://dante.dartmouth.edu/search_view.php?commentary[]=0&language=any&cantica=0&canto=&line={$formKeywords}', 'Cmd=Search&query={$formKeywords}', 3),
(4756, 914, 'Romantic Circles: Byron, the Shelleys, Keats and their Contemporaries', 'A Web site that provides scholarly resources for the study of Romantic-period literature and culture.', 'http://www.rc.umd.edu/', 'http://www.rc.umd.edu/cgi-bin/search/search.pl?Match=1&Realm=Editions&submit=Search&Terms={$formKeywords}', NULL, 4),
(4757, 914, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 5),
(4758, 915, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4759, 915, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4760, 915, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4761, 915, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4762, 916, 'Electronic Text Center', 'Electronic Text Center reflects over 5,000 publicly accessible texts on history, literature, philosophy, religion, history of science. Texts are in English and other languages, including Latin, Japanese and Chinese.', 'http://etext.lib.virginia.edu/', 'http://etext.virginia.edu/etcbin/ot2www-ebooks?specfile=%2Ftexts%2Fenglish%2Febooks%2Febooks.o2w&docs=TEI2&sample=1-100&grouping=work&query={$formKeywords}', NULL, 0),
(4763, 916, 'IPL Online Texts Collection', 'IPL Online Texts Collection contains over 19,000 titles that can be browsed by author, by title, or by Dewey Decimal Classification.', 'http://www.ipl.org/reading/books/', 'http://www.ipl.org/div/searchresults/?where=allv&words={$formKeywords}', NULL, 1),
(4764, 916, 'Linguistic Data Consortium', 'Linguistic Data Consortium supports language-related education, research and technology development by creating and sharing linguistic resources including data, tools and standards.', 'http://www.ldc.upenn.edu/', 'http://www.ldc.upenn.edu/Catalog/catalogSearchResults.jsp?ldc_catalog_id=&name=&author=&languages=&years=&types=&datasources=&projects=&applications=&and_or=1&and_or2=1&desc={$formKeywords}', NULL, 2),
(4765, 916, 'Oxford Text Archive', 'Oxford Text Archive contains Scholarly electronic texts and linguistic corpora across the range of humanities disciplines, with emphasis on resources of more than 1,500 literary works by many major authors in Greek, Latin, English and a dozen or more other languages.', 'http://ota.ahds.ac.uk/', 'http://ota.ahds.ac.uk/search/search.perl?search=SIMPLE&author=&title={$formKeywords}', NULL, 3),
(4766, 916, 'Project Gutenberg', 'Project Gutenberg is the definitive Web site for this project to put out-of-copyright books online in full-text. More than 6,000 texts online so far.', 'http://www.gutenberg.net/', 'http://www.gutenberg.org/catalog/world/results?author=&etestnr=&title={$formKeywords}', NULL, 4),
(4767, 917, 'H-Net Humanities and Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www.h-net.org/', 'http://www.h-net.org/logsearch/index.cgi?&type=keyword&hitlimit=25&field=&nojg=on&smonth=00&syear=1989&emonth=11&eyear=2004&order=relevance&phrase={$formKeywords}', NULL, 0),
(4768, 917, 'Humanist', 'Humanist is an international electronic seminar on the application of computers in the humanities. Its primary aim is to provide a forum for discussion of intellectual, scholarly, pedagogical, and social issues and for exchange of information among members.', 'http://www.princeton.edu/~mccarty/humanist/index.html', 'http://lists.village.virginia.edu/cgi-bin/AT-Humanistsearch.cgi?sp=sp&searchButton.x=15&searchButton.y=14&search={$formKeywords}', NULL, 1),
(4769, 918, 'EDSITEment', 'EDSITEment is a constantly growing collection of the most valuable online resources for teaching English, history, art history, and foreign languages.', 'http://edsitement.neh.gov/', 'http://marcopolosearch.org/MPSearch/Search_Results.asp?orgn_id=5&log_type=1&hdnFilter=+AND+%28%7Bsubject_social%241%7D%29&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 0),
(4770, 919, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4771, 919, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(4772, 919, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(4773, 919, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(4774, 919, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(4775, 919, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 5),
(4776, 919, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(4777, 919, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(4778, 919, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(4779, 919, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(4780, 920, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4781, 920, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4782, 920, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4783, 920, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4784, 921, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4785, 921, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(4786, 921, 'Scirus', 'Scirus searches both free and access controlled journal sources. It currently covers the Web, ScienceDirect, MEDLINE on BioMedNet, Beilstein on ChemWeb, Neuroscion, BioMed Central and Patents from the USPTO.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 2),
(4787, 921, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(4788, 921, 'Centers for Disease Control and Prevention (CDC)', 'The CDC Web site provides access to the full text of MMWR and other CDC publications and data archives. Publications are searchable through CDC Wonder.', 'http://www.cdc.gov/', 'http://www.cdc.gov/search.do?action=search&x=0&y=0&queryText={$formKeywords}', NULL, 4),
(4789, 921, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 5),
(4790, 921, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(4791, 921, 'NetPrints', 'NetPrints provides a place for authors to archive their completed studies before, during, or after peer review by other agencies. Its scope is original research into clinical medicine and health.', 'http://clinmed.netprints.org/search.dtl', 'http://www.google.com/search?hl=en&q=site%3Aclinmed.netprints.org+{$formKeywords}', NULL, 7),
(4792, 921, 'Intute: Health & Life Sciences', 'The Health and Life Sciences pages of Intute is a free online service providing you with access to the very best web resources for education and research, evaluated and selected by a network of subject specialists. There are over 31,000 resource descriptions listed here that are freely accessible for keyword searching or browsing.\n\nThis service was formerly known as BIOME.', 'http://www.intute.ac.uk/healthandlifesciences/', 'http://www.intute.ac.uk/healthandlifesciences/cgi-bin/search.pl?submit.x=20&submit.y=16&submit=Go&limit=0&subject=healthandlifesciences&term1={$formKeywords}', NULL, 8),
(4793, 922, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4794, 922, 'ADAM Medical Encyclopedia', 'The ADAM Medical Encyclopedia includes over 4,000 articles about diseases, tests, symptoms, injuries, and surgeries. It also contains an extensive library of medical photographs and illustrations.', 'http://www.nlm.nih.gov/medlineplus/encyclopedia.html', 'http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SHOWTOPICS=5&SERVER2=server2&SERVER1=server1&ASPECT=-1&START=0&END=0&x=29&y=10&PARAMETER={$formKeywords}', NULL, 1),
(4795, 922, 'Life Sciences Dictionary from BioTech', 'Life Sciences Dictionary from BioTech comprises 8,300+ terms relating to biochemistry, biotechnology, botany, cell biology and genetics, as well as selective entries on ecology, limnology, pharmacology, toxicology and medicine.', 'http://biotech.icmb.utexas.edu/search/dict-search.html', 'http://biotech.icmb.utexas.edu/search/dict-search2.html?bo1=AND&search_type=normal&def=&word={$formKeywords}', NULL, 2),
(4796, 922, 'MedTerms Medical Dictionary Index', 'MedTerms Medical Dictionary Index is a doctor-produced encyclopedic medical dictionary, almost daily updated. Can be browsed by using the A to Z Index above or by typing the term in the Search Box below and click.', 'http://www.medicinenet.com/script/main/AlphaIdx.asp?li=MNI&p=A_DICT', 'http://www.medicinenet.com/script/main/srchCont.asp?li=MNI&ArtTypeID=DICT&op=MM&SRC={$formKeywords}', NULL, 3),
(4797, 922, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 4),
(4798, 922, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 5),
(4799, 922, 'On-Line Medical Dictionary', 'The dictionary started in early 1997 and has grown, to contain over 46,000 definitions totalling 17.5 megabytes. Entries are cross-referenced to each other and to related resources elsewhere on the net. It is freely available on the Internet via the World-Wide Web.  OMD is a searchable dictionary created by Dr Graham Dark and contains terms relating to biochemistry, cell biology, chemistry, medicine, molecular biology, physics, plant biology, radiobiology, science and technology. It includes: acronyms, jargon, theory, conventions, standards, institutions, projects, eponyms, history, in fact anything to do with medicine or science.', 'http://cancerweb.ncl.ac.uk/cgi-bin/omd?', 'http://cancerweb.ncl.ac.uk/cgi-bin/omd?query={$formKeywords}', NULL, 6),
(4800, 922, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 7),
(4801, 922, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 8),
(4802, 923, 'Centers for Disease Control and Prevention (CDC)', 'The CDC Web site provides access to the full text of MMWR and other CDC publications and data archives. Publications are searchable through CDC Wonder.', 'http://www.cdc.gov/', 'http://www.cdc.gov/search.do?action=search&x=0&y=0&queryText={$formKeywords}', NULL, 0),
(4803, 923, 'ClinicalTrials.gov', 'ClinicalTrials.gov (National Institutes of Health) provides information for patients about clinical research studies.', 'http://www.clinicaltrials.gov', 'http://search.nhsdirect.nhs.uk/kbroker/nhsdirect/nhsdirect/search.lsim?hs=0&sm=0&ha=1054&sc=nhsdirect&mt=0&sb=0&nh=3&qt={$formKeywords}', NULL, 1),
(4804, 923, 'Scirus', 'Scirus searches both free and access controlled journal sources. It currently covers the Web, ScienceDirect, MEDLINE on BioMedNet, Beilstein on ChemWeb, Neuroscion, BioMed Central and Patents from the USPTO.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 2),
(4805, 923, 'Emedicine', 'Emedicine is a directory of free online medical articles and up-to-date, searchable, peer-reviewed medical textbooks for physicians, veterinarians, medical students, physician assistants, nurse practitioners, nurses and the public.', 'http://www.emedicine.com/', 'http://www.emedicine.com/cgi-bin/foxweb.exe/searchengine@/em/searchengine?boolean=and&book=all&maxhits=100&HiddenURL=&query={$formKeywords}', NULL, 3),
(4806, 923, 'HealthWeb', 'Provides links to evaluated information resources selected by librarians and information professionals at academic medical centers in the Midwest. The goal is to meet the health information needs of both health care professionals and consumers. A collaborative project of the health sciences libraries of the Greater Midwest Region (GMR), of the National Network of Libraries of Medicine (NN/LM), and of the Committee for Institutional Cooperation.', 'http://www.healthweb.org/', 'http://www.healthweb.org/quicksearch_results5.cfm?StartRow=1&maxrows=25&Criteria_required=You+Must+enter+a+Keyword&where=1&criteria={$formKeywords}', NULL, 4),
(4807, 923, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&author1=&src=ml&disp_type=&fulltext={$formKeywords}', NULL, 5),
(4808, 923, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(4809, 923, 'MEDLINEplus', 'MEDLINEplus will direct you to information to help answer health questions. It brings together, by health topic, authoritative information from the world''s largest medical library, the National Library of Medicine at the National Institutes of Health. Designed for both health professionals and consumers, this service provides extensive information about specific diseases and conditions.', 'http://medlineplus.gov/', 'http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SERVER2=server2&SERVER1=server1&PARAMETER={$formKeywords}', NULL, 7),
(4810, 923, 'NetPrints', 'NetPrints provides a place for authors to archive their completed studies before, during, or after peer review by other agencies. Its scope is original research into clinical medicine and health.', 'http://clinmed.netprints.org/search.dtl', 'http://www.google.com/search?hl=en&q=site%3Aclinmed.netprints.org+{$formKeywords}', NULL, 8),
(4811, 923, 'Intute: Health & Life Sciences', 'The Health and Life Sciences pages of Intute is a free online service providing you with access to the very best web resources for education and research, evaluated and selected by a network of subject specialists. There are over 31,000 resource descriptions listed here that are freely accessible for keyword searching or browsing.', 'http://www.intute.ac.uk/healthandlifesciences/', 'http://www.intute.ac.uk/healthandlifesciences/cgi-bin/search.pl?submit.x=20&submit.y=16&submit=Go&limit=0&subject=healthandlifesciences&term1={$formKeywords}', NULL, 9),
(4812, 924, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(4813, 925, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4814, 925, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4815, 925, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4816, 925, 'National Academy Press(NAP)', 'The National Academy Press (NAP) publishes over 200 books a year on a wide range of topics in science, engineering, and health, capturing the most authoritative views on important issues in science and health policy.', 'http://books.nap.edu/books/0309070317/html/177.html', 'http://search.nap.edu/nap-cgi/napsearch.cgi?term={$formKeywords}', NULL, 3),
(4817, 925, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 4),
(4818, 926, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4819, 926, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4820, 926, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4821, 926, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4822, 926, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(4823, 927, 'Canadian Health Network', 'Canadian Health Network (Canada) The Canadian Health Network (CHN) is a growing network, bringing together the best information resources of leading Canadian and international health information.', 'http://www.canadian-health-network.ca/servlet/ContentServer?pagename=CHN-RCS/Page/HomePageTemplate&cid=1038611684536&c=Page&lang=En', 'http://www.canadian-health-network.ca/servlet/ContentServer?cid=1046357853421&pagename=CHN-RCS%2FPage%2FSearchPageTemplate&c=Page&lang=En&orderBy=ORDER_RANK&searchType=ALL_WORDS&logSearch=true&searchStr={$formKeywords}', NULL, 0),
(4824, 927, 'Directgov', 'Directgov is replacing UK online as the place to turn to for the latest and widest range of public service information from the UK government.', 'http://www.direct.gov.uk/Homepage/fs/en', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 1),
(4825, 927, 'HealthInsite', 'HealthInsite (Australia) aims to improve the health of Australians by providing easy access to quality information about human health.', 'http://www.healthinsite.gov.au', 'http://www.healthinsite.gov.au/search97cgi/s97_cgi?Action=FilterSearch&Filter=ve_quick_search_filter.hts&ResultErrorTemplate=ve_error.hts&ResultCount=10&ResultMaxDocs=600&gl_search_collection=full&searchtype=simple&collection=healthinsite_coll&SortSpec=Score+desc+VDKDate_Modified+desc+VdkMeta_Title+asc+vdktarget_comp_num+asc&ResultTemplate=ve_search_results_new.hts&gl_search_text={$formKeywords}', NULL, 2);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4826, 927, 'NHS Direct', 'NHS Direct (UK) is a gateway to health information on the Internet in the United Kingdom. NHS Direct Online provides health advice and is supported by a 24 hour nurse advice and information help line.', 'http://www.nhsdirect.nhs.uk', 'http://search.nhsdirect.nhs.uk/kbroker/nhsdirect/nhsdirect/search.lsim?hs=0&sm=0&ha=1054&sc=nhsdirect&mt=0&sb=0&nh=3&qt={$formKeywords}', NULL, 3),
(4827, 927, 'PubMed Central', 'PubMed Central is a free online archive of full-text, peer-reviewed research papers in the life sciences.', 'http://pubmedcentral.nih.gov/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=pmc&cmd=search&pmfilter_Fulltext=on&pmfilter_Relevance=on&term={$formKeywords}', NULL, 4),
(4828, 928, 'Hardin Meta Directory of Internet Health Resources', 'List of lists compiled by the Hardin Library of the Health Sciences at the University of Iowa. Divided into longer, medium-sized and shorter lists of links. The Hardin MD Clean Bill of Health Award is given to the best sites that have connection rates of at least 93%.', 'http://www.lib.uiowa.edu/hardin/md/index.html', 'http://search.atomz.com/search/?sp-a=00050f6e-sp00000000&sp-q={$formKeywords}', NULL, 0),
(4829, 928, 'AMEDEO', 'AMEDEO has been created to serve the needs of healthcare professionals.  AMEDEO''s core components include weekly emails with bibliographic lists about new scientific publications, personal Web pages for one-time download of available abstracts, and an overview of the medical literature published in relevant journals over the past 12 to 24 months.', 'http://www.amedeo.com', 'http://www.google.com/custom?sa=Search&sitesearch=www.amedeo.com&q={$formKeywords}', NULL, 1),
(4830, 929, 'AMA Physician Select', 'This American Medical Association site provides addresses, specialties, education and other background information on licensed physicians in the U.S. and its possessions. Search by physician name or medical specialty.', 'http://www.ama-assn.org/aps/amahg.htm', 'http://search.ama-assn.org/Search/query.html?qc=public+amnews&qt={$formKeywords}', NULL, 0),
(4831, 929, 'Diseases Databases Ver 1.6; Medical lists and links', 'Diseases Databases Ver 1.6: medical lists and links - a cross-referenced index of human disease, medications, symptoms, signs, abnormal investigation findings etc.; provides a medical textbook-like index and search portal.', 'http://www.diseasesdatabase.com/begin.asp?gif=1', 'http://www.diseasesdatabase.com/item_choice.asp? bytSearchType=0&strUserInput={$formKeywords}', NULL, 1),
(4832, 929, 'Drugs.com', 'Drugs.com is a free resource for medical professionals and consumers providing convenient and reliable drug information. Drug monographs are presented at both professional (USPDI), and consumer levels. The drug information could be found by browsing the alphabetical listing of the drugs or by search using generic or trade name. The drug interaction guide allows check for drug-drug and drug-food interactions.', 'http://www.drugs.com/', 'http://www.drugs.com/search.php?is_main_search=1&searchterm={$formKeywords}', NULL, 2),
(4833, 929, 'National Center for Biotechnology Information', 'In addition to maintaining the GenBank nucleic acid sequence database, the National Center for Biotechnology Information (NCBI) provides data analysis and retrieval and resources that operate on the data in GenBank and a varity of other biological data made available through NCBI''s Web site. NCBI data retrieval resources include Entrez, PubMed, LocusLink and the Taxonomy Browser. Data analysis resources include BLAST, Electronic PCR, OrfFinder, RefSeq, UniGene, Databases of Single Nucleotide Polymorphisms (dbSNP), Human Genome Sequencing pages, GeneMap ''99, Davis Human-Mouse Homology Map, Cancer Chromosome Abberation Project (CCAP) pages, Entrez Genomes, Clusters of Orthologous Groups (COGs) database, Retroviral Genotyping Tools, Cancer Genome Anatomy Project (CGAP) pages, SAGEmap, Online Mendelian Inheritance in Man (OMIM) and the Molecular Modeling Databases (MMDB).', 'http://www.ncbi.nlm.nih.gov/', 'http://www.ncbi.nlm.nih.gov/gquery/gquery.fcgi?term={$formKeywords}', NULL, 3),
(4834, 929, 'RxList', 'RxList: The Internet drug index - Searchable cross index of US prescription products for both consumers and medical professionals', 'http://www.rxlist.com/', 'http://www.rxlist.com/cgi/rxlist.cgi?drug=acetaminophen', NULL, 4),
(4835, 930, 'EurekAlert!', 'EurekAlert! is an online press service created by the American Association for the Advancement of Science (AAAS). The primary goal of EurekAlert! is to provide a forum where research institutions, universities, government agencies, corporations and the like can distribute science-related news to reporters and news media. The secondary goal of EurekAlert! is to archive these press releases and make them available to the public in an easily retrievable system.', 'http://www.eurekalert.org/links.php', 'http://search.eurekalert.org/e3/query.html?col=ev3rel&qc=ev3rel&qt={$formKeywords}', NULL, 0),
(4836, 930, 'Mad Science Net: The 24-hour exploding laboratory', 'Mad Science Net: The 24-hour exploding laboratory is a collective cranium of scientists providing answers to your questions.', 'http://www.madsci.org/', 'http://www.madsci.org/cgi-bin/search?Submit=Submit+Query&or=AND&words=1&index=MadSci+Archives&MAX_TOTAL=25&area=All+areas&grade=All+grades&query={$formKeywords}', NULL, 1),
(4837, 931, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 0),
(4838, 932, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4839, 932, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4840, 932, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4841, 932, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4842, 932, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4843, 932, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4844, 932, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4845, 932, 'Health Canada', 'Health Canada is the federal department responsible for helping the people of Canada maintain and improve their health.  Health Canada is committed to improving the lives of all of Canada''s people and to making this country''s population among the healthiest in the world as measured by longevity, lifestyle and effective use of the public health care system.', 'http://search.hc-sc.gc.ca/cgi-bin/query?mss=hcsearch', 'http://search.hc-sc.gc.ca/cgi-bin/query?mss=hcresult&pg=aq&enc=iso88591&ft=adverse+drug&doc=all&results=any&exclude=&r=&kl=en&subsite=both&search=Search&q={$formKeywords}', NULL, 7),
(4846, 932, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 8),
(4847, 932, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 9),
(4848, 933, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4849, 933, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 1),
(4850, 933, 'The Scientist', 'The Scientist is the online resource for the printed magazine, The Scientist. Provides access to information useful to those working in or studying the life sciences.', 'http://www.the-scientist.com/', 'http://www.the-scientist.com/search/dosearch/', 'box_type=toolbar&search_restriction=all&order_by=date&search_terms={$formKeywords}', 2),
(4851, 933, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 3),
(4852, 933, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(4853, 933, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(4854, 934, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4855, 934, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4856, 934, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4857, 934, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4858, 935, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4859, 935, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4860, 935, 'OAIster (Open Archives Inititive research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4861, 935, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(4862, 935, 'EULER', 'EULER provides a world reference and delivery service, transparent to the end user and offering full coverage of the mathematics literature world-wide, including bibliographic data, peer reviews and/or abstracts, indexing, classification and search, transparent access to library services, co-operating with commercial information providers (publishers, bookstores).', 'http://www.emis.ams.org/projects/EULER/', 'http://www.emis.de/projects/EULER/search?q={$formKeywords}', NULL, 4),
(4863, 935, 'Math Archives: Topics in Mathematics', 'A large, searchable collection of categorized teaching materials, software, and Web links. While not annotated, keywords for each site provide insight into the site''s offerings.', 'http://archives.math.utk.edu/topics/', 'http://www.google.com/search?q=site%3Aarchives.math.utk.edu+topics+{$formKeywords}', NULL, 5),
(4864, 935, 'MathSearch', 'an excellent tool for searching the contents of more than 80,000 mathematics pages world wide, via Sydney University work, network security, digital signal processing and related topics.', 'http://www.maths.usyd.edu.au:8000/MathSearch.html', 'http://www.maths.usyd.edu.au:8000/s/search/p?p2=&p3=&p4=&p1={$formKeywords}', NULL, 6),
(4865, 935, 'MPRESS/MATHNET', 'MPRESS/MathNet is a concept/installation to provide quality indexing of mathematical preprints (servers). It is in itself operated in a distributed way. MPRESS improves access to the full texts of preprints in mathematics by means of metadata and provides comprehensive and easily searchable information on the preprints available.', 'http://mathnet.preprints.org/', 'http://mathnet.preprints.org/cgi-bin/harvest/MPRESS.pl.cgi?title=&metaquery=&keyword=&query=&broker=FraGer&errorflag=0&wordflag=off&opaqueflag=off&csumflag=off&maxobjflag=10000&maxlineflag=10000&maxresultflag=10000&author={$formKeywords}', NULL, 7),
(4866, 935, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 8),
(4867, 936, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4868, 936, 'Wolfram Research''s Mathematical Functions', 'More than 37,000 facts about mathematical functions as of July 2003. This site was created as a resource for the educational, mathematical, and scientific communities. It contains the world''s most encyclopedic collection of information about mathematical functions. The site also details the interrelationships between the special functions of mathematical physics and the elementary functions of mathematical analysis as well as the interrelationships between the functions in each group.', 'http://functions.wolfram.com/', 'http://functions.wolfram.com/search/index.cgi?filter=1&q={$formKeywords}', NULL, 1),
(4869, 936, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4870, 936, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4871, 936, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(4872, 936, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(4873, 937, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4874, 937, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4875, 937, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4876, 937, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4877, 938, 'MacTutor History of Mathematics', 'Includes biographies of more than 1100 mathematicians and a special index of women mathematicians.', 'http://www-groups.dcs.st-and.ac.uk/%7Ehistory/index.html', 'http://www-history.mcs.st-andrews.ac.uk/Search/historysearch.cgi?SUGGESTION={$formKeywords}', NULL, 0),
(4878, 939, 'Eric Weisstein''s MathWorld', 'Eric Weisstein''s MathWorld is a comprehensive mathematics information bank. The site currently consists of some 10,228 searchable entries, 89,364 cross-references, 4,205 figures, 125 animated graphics, 964 live Java applets and receives an average of 135 updates and new entries each month.', 'http://mathworld.wolfram.com/', 'http://mathworld.wolfram.com/search/?x=0&y=0&query={$formKeywords}', NULL, 0),
(4879, 940, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 0),
(4880, 940, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4881, 940, 'EULER', 'EULER provides a world reference and delivery service, transparent to the end user and offering full coverage of the mathematics literature world-wide, including bibliographic data, peer reviews and/or abstracts, indexing, classification and search, transparent access to library services, co-operating with commercial information providers (publishers, bookstores).', 'http://www.emis.ams.org/projects/EULER/', 'http://www.emis.de/projects/EULER/search?q={$formKeywords}', NULL, 2),
(4882, 940, 'Math Archives: Topics in Mathematics', 'A large, searchable collection of categorized teaching materials, software, and Web links. While not annotated, keywords for each site provide insight into the site''s offerings.', 'http://archives.math.utk.edu/topics/', 'http://www.google.com/search?q=site%3Aarchives.math.utk.edu+topics+{$formKeywords}', NULL, 3),
(4883, 940, 'MathSearch', 'An excellent tool for searching the contents of more than 80,000 mathematics pages world wide, via Sydney University work, network security, digital signal processing and related topics.', 'http://www.maths.usyd.edu.au:8000/MathSearch.html', 'http://www.maths.usyd.edu.au:8000/s/search/p?p2=&p3=&p4=&p1={$formKeywords}', NULL, 4),
(4884, 940, 'MPRESS/MATHNET', 'MPRESS/MathNet is a concept/installation to provide quality indexing of mathematical preprints (servers). It is in itself operated in a distributed way. MPRESS improves access to the full texts of preprints in mathematics by means of metadata and provides comprehensive and easily searchable information on the preprints available.', 'http://mathnet.preprints.org/', 'http://mathnet.preprints.org/cgi-bin/harvest/MPRESS.pl.cgi?author=&keyword=&title=&metaquery=&broker=FraGer&errorflag=0&wordflag=off&opaqueflag=off&csumflag=off&maxobjflag=10000&maxlineflag=10000&maxresultflag=10000&query={$formKeywords}', NULL, 5),
(4885, 940, 'SIAM Review', 'The SIAM Review consists of five sections, all containing articles of broad interest. Survey and Review features papers with a deliberately integrative and up-to-date perspective on a major topic in applied or computational mathematics or scientific computing.', 'http://epubs.siam.org/sam-bin/dbq/toclist/SIREV', 'http://epubs.siam.org/search/search.pl', 'field1=anyfield&jrnlname=all&boolean1=and&search_field=anyfield&quicksearchstring={$formKeywords}', 6),
(4886, 940, 'Zentralblatt MATH', 'Zentralblatt MATH is the world''s most complete and longest running abstracting and reviewing service in pure and applied mathematics. The Zentralblatt MATH Database contains more than 2.0 million entries drawn from more than 2300 serials and journals, which are listed in this Database of Serials and Journals.', 'http://www.zblmath.fiz-karlsruhe.de/serials/', 'http://www.zblmath.fiz-karlsruhe.de/serials/?hits_per_page=10&is=&bi={$formKeywords}', NULL, 7),
(4887, 941, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4888, 941, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4889, 941, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4890, 941, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(4891, 941, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(4892, 942, 'The Mathematical Atlas: A Gateway to Modern Mathematics', 'This searchable site provides a collection of articles about the many subfields of math and includes definitions, brief biographies, and explanations. Each topic includes a history, related areas, and subfields as well as related print and Internet resources. It also includes an introduction to the Mathematics Subject Classification (MSC) scheme on which the site''s arrangement is based.', 'http://www.math-atlas.org/', 'http://www.math.niu.edu/cgi-bin/ffw.cgi/known-math?&go=Search&key={$formKeywords}', NULL, 0),
(4893, 942, 'MathForum''s Search All Epigone Discussions', 'MathForum''s Search All Epigone Discussions provides resources, materials, activities, person-to-person interactions, and educational products and services that enrich and support teaching and learning in an increasingly technological world. The Math Forum''s Epigone discussion archives include mathematics and math education-related newsgroups, mailing lists, and Web-based discussions.', 'http://mathforum.com/discussions/epi-search/all.html', 'http://mathforum.org/search/results.html?bool_type=and&whole_words=yes&match_case=no&ctrlfile=/var/www/search/ctrl/all.search.ctrl&textsearch={$formKeywords}', NULL, 1),
(4894, 942, 'AMS Meetings & Conferences', 'Meetings & Conferences, provided by the American Mathematical Society (AMS), contains a comprehensive list of important meetings information.', 'http://www.ams.org/meetings/', 'http://www.google.com/search?q=site%3Awww.ams.org%2Fmeetings%2F+{$formKeywords}', NULL, 2),
(4895, 943, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?', 'formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', 0),
(4896, 943, 'MSTE', 'MSTE serves as a model-builder for innovative, standards-based, technology-intensive mathematics and science instruction at the K-16 levels.', 'http://www.mste.uiuc.edu/', 'http://www.google.com/custom?ie=UTF-8&oe=UTF-8&sa=&cof=GALT%3A%2393AAC6%3BS%3Ahttp%3A%2F%2Fwww.mste.uiuc.edu%2F%3BGL%3A1%3BVLC%3Aorange%3BAH%3Acenter%3BBGC%3A%233d4b66%3BLH%3A255%3BLC%3Aorange%3BGFNT%3A%2393AAC6%3BL%3Ahttp%3A%2F%2Fwww.mste.uiuc.edu%2Fimages%2Fmstelogo.gif%3BALC%3A%23d3d3d3%3BLW%3A600%3BT%3A%23FFFFFF%3BGIMP%3A%2393AAC6%3BAWFID%3A174a51c6937b9927%3B&domains=http%3A%2F%2Fwww.mste.uiuc.edu%2F&sitesearch=http%3A%2F%2Fwww.mste.uiuc.edu%2F&q={$formKeywords}', NULL, 1),
(4897, 943, 'Illuminations', 'This site is to improve the teaching and learning of mathematics. This site offers interactive lessons for students, lesson plans for teachers, and math applets, all arranged by grade level. Includes a large collection of Web resources, arranged by concept and grade, and the standards for teaching math. From the National Council of Teachers of Mathematics (NCTM).', 'http://illuminations.nctm.org/', 'http://marcopolosearch.org/MPSearch/Search_Results.asp?orgn_id=6&log_type=1&hdnFilter=&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 2),
(4898, 943, 'MarcoPolo Internet Content for the Classroom', 'MarcoPolo Internet Content for the Classroom is a consortium of premier national education organizations, state education agencies and the MarcoPolo Education Foundation dedicated to providing the highest quality Internet content and professional development to teachers and students throughout the United States. Subjects include: Arts, Economics, Foreign Language, Geography, Language Arts, Mathematics, Philosophy & Religion, Science, and Social Studies.', 'http://www.marcopolo-education.org/home.aspx', 'http://www.marcopolosearch.org/mpsearch/Search_Results.asp?orgn_id=2&log_type=1&hdnFilter=&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 3),
(4899, 943, 'The Math Forum', 'The Math Forum gateway provides easy access to high quality resources for mathematicians and math teachers, and it provides resources that cover the use and administration of Internet sites as well as other educational resources. Among its features are the following: five ways to search with well written instructions for using each type; interactive sites; multilingual sites; choice of resource listings by knowledge levels from elementary to research level; and resources displayed in either an outline form or as an annotated listing with the ability to switch back and forth between the two.', 'http://mathforum.org/grepform.html', 'http://mathforum.org/search/results.html?bool_type=and&whole_words=yes&match_case=no&ctrlfile=%2Fvar%2Fwww%2Fsearch%2Fctrl%2Fall.search.ctrl&textsearch={$formKeywords}', NULL, 4),
(4900, 943, 'PBS Mathline', 'PBS Mathline features a specific math topic for teachers of grades K-12. Each month an in-depth article is linked to related resources, and daily facts related to the topic. PBS Mathline also offers an extensive professional development program.', 'http://www.pbs.org/teachersource/math.htm', 'http://www.pbs.org/teachersource/search/standards_results.shtm?start=1&end=20&subjects=NULL&grades=NULL&query={$formKeywords}', NULL, 5),
(4901, 943, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 6),
(4902, 943, 'Ask Dr. Math', 'Search the archives for elementary through college level questions and answers. Sponsored by Drexel University.', 'http://www.mathforum.org/library/drmath/', 'http://mathforum.org/library/drmath/results.html?textsearch_bool_type=and&textsearch_whole_words=no&textsearch={$formKeywords}', NULL, 7),
(4903, 944, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4904, 944, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4905, 944, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4906, 944, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4907, 944, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4908, 944, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4909, 944, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4910, 944, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(4911, 944, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(4912, 945, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4913, 945, 'Notice of the American Mathematical Society', 'Notices of the American Mathematical Society is one of the world''s most widely read periodicals for professional mathematicians.', 'http://www.ams.org/noticessearch/', 'http://www.google.com/custom?sa=Search+Notices&cof=S%3Ahttp%3A%2F%2Fwww.ams.org%2Fnotices%3BGL%3A0%3BVLC%3A%23004080%3BAH%3Aleft%3BBGC%3A%23ffffff%3BLH%3A55%3BLC%3A+%23004080%3BL%3Ahttp%3A%2F%2Fwww.ams.org%2Fimages%2Fnotices-search-banner.gif%3BALC%3A%23ff2b2b%3BLW%3A1200%3BT%3A%23000000%3BAWFID%3A39742761a368da0f%3B&domains=www.ams.org%2Fnotices&sitesearch=www.ams.org%2Fnotices&q={$formKeywords}', NULL, 1),
(4914, 945, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(4915, 945, 'Science News Online', 'Science News Online is one of the most useful science news magazines is now online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week. They''ve archived them back to 1994.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(4916, 945, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(4917, 945, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(4918, 946, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4919, 946, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4920, 946, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(4921, 946, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4922, 947, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4923, 947, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(4924, 947, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(4925, 947, 'Music Theory Online', 'This site is the refereed, electronic journal of the Society for Music Theory, Inc..', 'http://www.societymusictheory.org/mto/', 'http://www.google.com/u/smt?sa=Google+Search&q={$formKeywords}', NULL, 3),
(4926, 947, 'Music Education Resource Base: including the Canadian Music Index', 'MERB/CMI is a bibliographic database of more than 28,000 resources in music and music education from 31 Canadian and International journals and other sources covering the period 1956 through the present. The journals are fully indexed by title, author, and subject.', 'http://www.fmpweb.hsd.uvic.ca/merb/index.htm', 'http://www.fmpweb.hsd.uvic.ca/merb/FMPro?-DB=MERBSUB.fp5&-lay=Layout+%232&-format=search_results.htm&-error=search_error.htm&-max=all&-lop=and&-SortField=Title&-SortOrder=Ascending&-op=eq&Show+to+web=yes&-op=cn&-Find=Go&SUBJECT={$formKeywords}', NULL, 4),
(4927, 948, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4928, 948, 'Columbia Encyclopedia', 'Serving as a "first aid" for those who read, the sixth edition of the Columbia Encyclopedia contains over 51,000 entries with 80,000 hypertext links.', 'http://www.bartleby.com/65/', 'http://www.bartleby.com/cgi-bin/texis/webinator/65search?search_type=full&query={$formKeywords}', NULL, 1),
(4929, 948, 'Encyclopedia.com', 'Online version of the Concise Electronic Encyclopedia. Entries are very short, so this site is better suited for fact checking than research.', 'http://www.encyclopedia.com/', 'http://www.encyclopedia.com/searchpool.asp?target={$formKeywords}', NULL, 2),
(4930, 948, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(4931, 948, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(4932, 948, 'Grove Concise Music Dictionary', 'GroveMusic powered by Gramophone.', 'http://www.gramophone.co.uk/', 'http://www.gramophone.co.uk/grove_popup.asp?grove={$formKeywords}', NULL, 5),
(4933, 948, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 6),
(4934, 948, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 7),
(4935, 949, 'Electronic Musician', 'Full-text articles from current issue and back issues to September 1999', 'http://industryclick.com/magazine.asp?magazineid=33&SiteID=15', 'http://industryclick.com/advsearchresults.asp?SiteID=15&MagazineID=33&CodeID=&selectSearch=mag%3B33&Go.x=12&Go.y=9&qry={$formKeywords}', NULL, 0),
(4936, 949, 'The Journal of Seventeenth-Century Music (JSCM)', 'The Journal of Seventeenth-Century Music (JSCM) is published by the Society for Seventeenth-Century Music to provide a refereed forum for scholarly studies of the musical cultures of the seventeenth century. These include historical and archival studies, performance practice, music theory, aesthetics, dance, and theater. JSCM also publishes critical reviews and summary listings of recently published books, scores, and electronic media.', 'http://sscm-jscm.press.uiuc.edu', 'http://sscm-jscm.press.uiuc.edu/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=scm&restrict=&exclude=&words={$formKeywords}', NULL, 1),
(4937, 950, 'Music Theory Online', 'This site is the refereed, electronic journal of the Society for Music Theory, Inc..', 'http://www.societymusictheory.org/mto/', 'http://www.google.com/u/smt?sa=Google+Search&q={$formKeywords}', NULL, 0),
(4938, 950, 'Music Education Resource Base: including the Canadian Music Index', 'MERB/CMI is a bibliographic database of more than 28,000 resources in music and music education from 31 Canadian and International journals and other sources covering the period 1956 through the present. The journals are fully indexed by title, author, and subject.', 'http://www.fmpweb.hsd.uvic.ca/merb/index.htm', 'http://www.fmpweb.hsd.uvic.ca/merb/FMPro?-DB=MERBSUB.fp5&-lay=Layout+%232&-format=search_results.htm&-error=search_error.htm&-max=all&-lop=and&-SortField=Title&-SortOrder=Ascending&-op=eq&Show+to+web=yes&-op=cn&-Find=Go&SUBJECT={$formKeywords}', NULL, 1),
(4939, 951, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(4940, 951, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(4941, 951, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(4942, 951, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(4943, 951, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(4944, 951, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(4945, 951, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(4946, 952, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(4947, 952, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(4948, 952, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(4949, 952, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(4950, 953, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 0),
(4951, 953, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase. At this point, a total of 15,000 of 750,000 records are loaded into the database. Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/default.asp', 'http://www.crl.edu/DBSearch/catalogSearchNew.asp?sort=R&req_type=X&search={$formKeywords}', NULL, 1),
(4952, 953, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 2),
(4953, 953, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 3),
(4954, 954, 'Aria Databases', 'The Aria Databases is a diverse collection of information on over 1000 operatic arias. Designed for singers and non-singers alike, the Databases includes translations and aria texts of most arias as well as a collection of MIDI files of operatic arias and ensembles.', 'http://www.aria-database.com/', 'http://www.aria-database.com/cgi-bin/aria-search.pl', 'numbers=1|20&all-or-results=all&aria=&language=All&detail=yes&composer=&role=&opera=&low=A&below=2&high=A&above=3&pointless=yes&database-select=aria&input-choose=keyword&keyword={$formKeywords}', 0),
(4955, 954, 'Operabase', 'A powerful search tool allows you to search the details of over 38,000 opera performances since autumn 2001 by any combination of opera title, composer, date, location.', 'http://operabase.com/en/', 'http://operabase.com/oplist.cgi?id=none&lang=en&by=&loc=&near=0&stype=rel&srel=0&sd=1&sm=1&sy=1999&etype=rel&erel=0&ed=31&em=7&ey=2004&full=n&sort=V&is={$formKeywords}', NULL, 1),
(4956, 954, 'AMG All-Media (All-Music) Guide', 'From the paper copy publishers of the standard reference All Music Guide, this site contains ratings and reviews of more than 400,000 record albums. Search by artist, album, song, style, or label. Access information on new releases, music styles, music maps (guides to the evolution of a musical genre), articles, and a glossary. Entries on artists include a musician/musical group''s history, roots and influences, musical style, discography, guest performances, and reviews.', 'http://www.allmusic.com/', 'http://www.allmusic.com/cg/amg.dll?OPT1=1&P=amg&SQL={$formKeywords}', NULL, 2),
(4957, 954, 'Classical Net', 'Classical Net features more than 3200 CD/DVD/Book reviews, as well as 6000 files and over 4000 links to other classical music web sites.', 'http://www.classical.net/', 'http://search.mercora.com/msearch/search.jsp?pattern={$formKeywords}', NULL, 3),
(4958, 954, 'AHDS Performing Arts', 'AHDS Performing Arts collects, documents, preserves and promotes the use of digital resources to support research and teaching across the broad field of the performing arts: music, film, broadcast arts, theatre, dance.', 'http://ahds.ac.uk/performingarts/', 'http://ahds.ac.uk/performingarts/search/index.htm?submit=Search%21&query={$formKeywords}', NULL, 4),
(4959, 955, 'MusicMoz', 'The Open Music Project. A comprehensive directory of all things music, edited by volunteers, this site lists and accepts submissions of music-related reviews, articles, factual information, biographies, and websites.', 'http://musicmoz.org/', 'http://musicmoz.org/search/search.cgi?search={$formKeywords}', NULL, 0),
(4960, 956, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 0),
(4961, 957, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(4962, 957, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(4963, 957, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.qestia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(4964, 957, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(4965, 958, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(4966, 958, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(4967, 958, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(4968, 958, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(4969, 958, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(4970, 958, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(4971, 958, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(4972, 958, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(4973, 958, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(4974, 958, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(4975, 959, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(4976, 959, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(4977, 959, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(4978, 959, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(4979, 960, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(4980, 960, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4981, 960, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(4982, 960, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(4983, 960, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(4984, 960, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://fnalpubs.fnal.gov/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/wwwscan?subfile=wwwhepau&submit=Browse&rawcmd={$formKeywords}', NULL, 5),
(4985, 960, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 6),
(4986, 960, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/index.jsp?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 7),
(4987, 960, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 8),
(4988, 960, 'SPIRES', 'SPIRES provides search more than 450,000 high-energy physics related articles, including journal papers, preprints, e-prints, technical reports, conference papers and theses.', 'http://www.slac.stanford.edu/spires/hep/', 'http://www.slac.stanford.edu/spires/find/hep/www?TITLE=&C=&REPORT-NUM=&AFFILIATION=&cn=&k=&cc=&eprint=+&eprint=&topcit=&url=&J=+&*=&ps=+&DATE=&*=+&FORMAT=WWW&SEQUENCE=&AUTHOR={$formKeywords}', NULL, 9),
(4989, 960, 'HighWire', 'HighWire contains 11,785,877 articles in over 4,500 Medline journals, as well as 404,484 free full text articles from 322 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 10),
(4990, 961, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(4991, 961, 'Eric Weisstein''s World of Physics', 'Online encyclopedia of physics terms and formulas. Full searchable, and also browsable alphabetically and by topic. Part of Eric''s Treasure Troves of Science.', 'http://scienceworld.wolfram.com/physics/', 'http://scienceworld.wolfram.com/search/?q={$formKeywords}', NULL, 1),
(4992, 961, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(4993, 961, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(4994, 961, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(4995, 961, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(4996, 962, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://lss.fnal.gov/ird/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/wwwbrief?r=fermilab&AUTHOR=&r=&REPORT-NUM=&r=&DATE=&*=+&r=fermilab&format=wwwbrief&TITLE={$formKeywords}', NULL, 0),
(4997, 962, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(4998, 962, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 2),
(4999, 962, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 3),
(5000, 962, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/index.jsp?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 4),
(5001, 962, 'Physics Documents Worldwide (PhysDoc)', 'Physics Documents Worldwide (PhysDoc) offers lists of links to document sources, such as preprints, research reports, annual reports, and list of publications of worldwide distributed physics institutions and individual physicists, ordered by continent, country and town.', 'http://physnet.uni-oldenburg.de/PhysNet/physdoc.html#search', 'http://www.physnet.de/PhysNet/physdocsearch.html?errorflag=0&caseflag=on&wordflag=on&maxobjflag=200&opaqueflag=on&descflag=on&csumflag=off&verbose=off&broker=PhysDoc&domain=physnet.de&query={$formKeywords}', NULL, 5),
(5002, 962, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 6),
(5003, 962, 'CERN Document Server', 'Over 650,000 bibliographic records, including 320,000 fulltext documents, of interest to people working in particle physics and related areas. Covers preprints, articles, books, journals, photographs, and much more.', 'http://cdsweb.cern.ch/?ln=en', 'http://cdsweb.cern.ch/search.py?sc=1&ln=en&f=&cc=CERN+Document+Server&c=Articles+%26+Preprints&c=Books+%26+Proceedings&c=Presentations+%26+Talks&c=Periodicals+%26+Progress+Reports&c=Multimedia+%26+Outreach&c=Archives&p={$formKeywords}', NULL, 7),
(5004, 962, 'HighWire', 'HighWire contains 11,785,877 articles in over 4,500 Medline journals, as well as 404,484 free full text articles from 322 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?author1=&pubdate_year=&volume=&firstpage=&src=hw&hits=10&hitsbrief=25&resourcetype=1&andorexactfulltext=and&fulltext={$formKeywords}', NULL, 8),
(5005, 963, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(5006, 963, 'National Academy Press(NAP)', 'The National Academy Press (NAP) publishes over 200 books a year on a wide range of topics in science, engineering, and health, capturing the most authoritative views on important issues in science and health policy.', 'http://books.nap.edu/books/0309070317/html/177.html', 'http://search.nap.edu/nap-cgi/napsearch.cgi?term={$formKeywords}', NULL, 1),
(5007, 963, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 2),
(5008, 963, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 3),
(5009, 963, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 4),
(5010, 964, 'Physics Today Events Calendar', 'Events such as conferences and meetings collected by Physics Today.', 'http://www.aip.org/cal/eventhome.jsp', 'http://www.aip.org/cal/results.jsp?category=&country=&month=&year=2006&image2.x=30&image2.y=6&subject={$formKeywords}', NULL, 0),
(5011, 964, 'PhysicsWeb - Calendar', 'PhysicsWeb - Calendar provides information on physics conferences, workshops, and summer schools.', 'http://www.physicsweb.org/events/', 'http://physicsworld.com/cws/Search.do?section=events&query={$formKeywords}', NULL, 1),
(5012, 965, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(5013, 965, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(5014, 965, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(5015, 965, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(5016, 966, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(5017, 967, 'PhysLink.com Astronomy Education Resources', 'The PhysLink.com is a comprehensive physics and astronomy online education, research and reference web site.  Contains links to related news, jobs, societies, reference sources, scientific journals, and high-tech companies.', 'http://www.physlink.com/Education/Astronomy.cfm', 'http://physlink.master.com/texis/master/search/?s=SS&q={$formKeywords}', NULL, 0),
(5018, 967, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 1),
(5019, 968, 'CERN Document Server (CDS)', 'Over 650,000 bibliographic records, including 320,000 fulltext documents, of interest to people working in particle physics and related areas. Covers preprints, articles, books, journals, photographs, and much more.', 'http://cdsweb.cern.ch/', 'http://cdsweb.cern.ch/search.py?f=&c=&p={$formKeywords}', NULL, 0),
(5020, 969, 'Nature Physics Portal', 'The Nature physics portal is a one-stop resource for physicists, providing highlights of the latest research in Nature and elsewhere.  Nature Physics Portal online contains the physics content of the current issue, including Articles, Letters to Nature, Brief Communications, News and Views and portal extras.', 'http://www.nature.com/physics/index.html', 'http://search.nature.com/search/?sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp_t=results&sp_q_1=Physics&sp-x-2=ujournal&sp-p-2=phrase&sp-x-1=subject&sp-p-1=phrase&sp-q={$formKeywords}', NULL, 0),
(5021, 970, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(5022, 970, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(5023, 970, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(5024, 970, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(5025, 970, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(5026, 970, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(5027, 970, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(5028, 970, 'FYI: The AIP Bulletin of Science Policy News', 'FYI: The AIP Bulletin of Science Policy News summarizes science policy developments in Washington, D.C. affecting the physics and astronomy community. Summaries are approximately one page long and are issued two or more times every week.', 'http://www.aip.org/enews/fyi/searchfyi.html', 'http://www.aip.org/servlet/Searchfyi?collection=K2NEWFYI&filename=%2Fweb2%2Faipcorp%2Ffyi%2F2004&SEARCH-97.x=64&SEARCH-97.y=18&queryText={$formKeywords}', NULL, 7),
(5029, 970, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 8),
(5030, 970, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 9),
(5031, 971, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(5032, 971, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(5033, 971, 'Physics News Update: AIP Bulletin of Physics News', 'Physics News Update: AIP Bulletin of Physics News is a digest of physics news items arising from physics meetings, physics journals, newspapers and magazines, and other news sources. Subscriptions are free as a way of broadly disseminating information about physics and physicists.', 'http://www.aip.org/physnews/update/', 'http://www.aip.org/servlet/Searchphys?SearchPage=%2Fphysnews%2Fupdate%2Fsearch.htm&collection=K2PHYSNEWS&queryText={$formKeywords}', NULL, 2),
(5034, 971, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(5035, 971, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(5036, 971, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(5037, 972, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(5038, 972, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(5039, 972, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(5040, 972, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(5041, 973, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(5042, 973, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(5043, 973, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(5044, 973, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 3),
(5045, 973, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 4),
(5046, 973, 'Intute: Social Sciences', 'Intute: Social Sciences is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 5),
(5047, 973, 'SocioSite', 'SocioSite gives access to the worldwide scene of social sciences. The intention is to provide a comprehensive listing of all sociology resources on the Internet.', 'http://www.pscw.uva.nl/sociosite/', 'http://www.google.com/u/sociosite?sa=sociosite&domains=www2.fmg.uva.nl&sitesearch=www2.fmg.uva.nl&hq=inurl:www2.fmg.uva.nl/sociosite&q={$formKeywords}', NULL, 6),
(5048, 973, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 7),
(5049, 974, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(5050, 974, 'Online Dictionary of the Social Sciences', 'Online Dictionary of the Social Sciences is a searchable dictionary of terms commonly used in the social sciences. Both phrase and keyword searches are facilitated.', 'http://bitbucket.icaap.org/', 'http://bitbucket.icaap.org/dict.pl?fuzzy={$formKeywords}', NULL, 1),
(5051, 974, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 2),
(5052, 974, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(5053, 974, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(5054, 974, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(5055, 975, 'CIAO (Columbia International Affairs Online)', 'Established as a collaboration between the Columbia University libraries and Columbia University Press with a grant from the Andrew W. Mellon Foundation, CIAO comprises a collection of theory and research materials in the field of international affairs. Working papers from university research institutes, policy briefs, country data, journal abstracts, and conference proceedings, all from 1991 - present, are among the materials available from this resource.', 'http://www.ciaonet.org/', 'http://usearch.cc.columbia.edu/ciao/query.html?qp=url%3Awps&qp=url%3Aolj&qp=url%3Apbei&qp=url%3Abook&qp=url%3Acasestudy&op1=%2B&fl1=&ty1=w&tx1=&dt=in&inthe=2147483647&op0=&fl0=&ty0=w&qt=&ht=0&qp=&qs=&col=ciao&qc=ciao&pw=100%25&ws=0&la=en&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&si=0&ql=a&x=34&y=8&tx0={$formKeywords}', NULL, 0),
(5056, 975, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 1),
(5057, 975, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 2),
(5058, 975, 'Intute: Social Sciences', 'Intute: Social Sciences is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 3),
(5059, 975, 'SocioSite', 'SocioSite gives access to the worldwide scene of social sciences. The intention is to provide a comprehensive listing of all sociology resources on the Internet.', 'http://www.pscw.uva.nl/sociosite/', 'http://www.google.com/u/sociosite?sa=sociosite&domains=www2.fmg.uva.nl&sitesearch=www2.fmg.uva.nl&hq=inurl:www2.fmg.uva.nl/sociosite&q={$formKeywords}', NULL, 4),
(5060, 975, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 5),
(5061, 976, 'Anthropology Review Databases (ARD)', 'The Anthropology Review Databases is intended to improve the level of access of anthropologists to anthropological literature by making them more aware of what is being published and helping them to evaluate its relevance to their own interests.', 'http://wings.buffalo.edu/ARD/', 'http://wings.buffalo.edu/ARD/cgi/search.cgi?authors=&subject=&date1=&date2=&medium=&reviewer=&title={$formKeywords}', NULL, 0),
(5062, 976, 'Books-on-Law', 'Books-on-Law reviewing new and forthcoming scholarly and trade books related to law; from JURIST: The Law Professors'' Network', 'http://jurist.law.pitt.edu/lawbooks/', 'http://search.freefind.com/find.html?id=9814374&pageid=r&mode=ALL&query={$formKeywords}', NULL, 1),
(5063, 976, 'Law and Politics Book reviews', 'The Law and Politics Book reviews is sponsored by the Law and Courts Section of the American Political Science Association. The electronic medium enables us to review almost every book about the legal process and politics, to do longer reviews than are usually published, and to make the reviews available within six months of our receipt of the book.', 'http://www.bsos.umd.edu/gvpt/lpbr/', 'http://www.searchum.umd.edu/search?btnG=Search&output=xml_no_dtd&proxystylesheet=UMCP&as_sitesearch=http://www.bsos.umd.edu/gvpt/lpbr&client=UMCP&site=UMCP&q={$formKeywords}', NULL, 2),
(5064, 977, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(5065, 977, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(5066, 977, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(5067, 977, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(5068, 978, 'The Gallup Organization', 'The Gallup site allows for topic keyword searches and also has a topic index, listing major issues such as Abortion, Campaign Finance, Illegal Drugs, and Taxes, with retrospective poll results, sometimes dating back to the 1950s, included for each.', 'http://www.gallup.com/', 'http://www.gallup.com/search/results.aspx?SearchConType=&SearchTypeAll=any&SearchTypeExa=any&SearchTypeAny=any&SearchTypeNon=any&SearchTextExa=&SearchTextAny=&SearchTextNon=&SearchSiteInd=&SearchSiteAll=&SearchDateBef=&SearchDateAft=&SearchDateBMo=&SearchDateAMo=&SearchDateBDa=&SearchDateADa=&SearchDateBYe=&SearchDateAYe=&SearchTextAll={$formKeywords}', NULL, 0),
(5069, 978, 'Public Agenda Online', 'Sponsored by fourteen public service-oriented foundations, Public Agenda Online offers 21 issue guides for such topics as Abortion, Crime, the Federal Budget, Race, and Welfare. Analytical essays, summaries of news articles, and graphs representing poll results enhance Public Agenda''s extensive coverage of each topic.', 'http://www.publicagenda.org/', 'http://www.publicagenda.org/search/search_details.cfm', 'StartRow=1&searchstring={$formKeywords}', 1),
(5070, 978, 'PollingReport.com', 'PollingReport.com is an independent, nonpartisan resource on trends in American public opinion.', 'http://www.pollingreport.com/', 'http://www.pollingreport.com/_vti_bin/shtml.exe/search.htm', 'VTI-GROUP=0&search={$formKeywords}', 2),
(5071, 979, 'Inter-university Consortium for Political and Social Research (ICPSR)', 'Inter-university Consortium for Political and Social Research (ICPSR) contains social data archives include nearly 5,000 titles and over 45,000 individual files over 300 institutions in the world.', 'http://www.icpsr.umich.edu/', 'http://search.icpsr.umich.edu/ICPSR/query.html?nh=25&rf=3&ws=0&op0=%2B&fl0=&ty0=w&col=abstract&col=series&col=uncat&op1=-&tx1=restricted&ty1=w&fl1=availability%3A&op2=%2B&tx2=ICPSR&ty2=w&fl2=archive%3A&tx0={$formKeywords}', NULL, 0),
(5072, 979, 'The OECD Statistics Portal', 'The OECD Statistics Portal collects the statistics needed for its analytical work from statistical agencies of its Member countries. The OECD promotes and develops international statistical standards and co-ordinates statistical activities with other international agencies.', 'http://www.oecd.org/statsportal/0,2639,en_2825_293564_1_1_1_1_1,00.html', 'http://www.oecd.org/searchResult/0,2665,en_2825_293564_1_1_1_1_1,00.html?searchText=&fpDepartment=293564&fpSearchExact=3&fpSearchText={$formKeywords}', NULL, 1),
(5073, 979, 'Australian Social Science Data Archive', 'ASSDA is a member of the International Federation of Data Organisations (IFDO) through which it maintains contacts with data organisations abroad actively engaged in providing the social science community with computerised data and documentation. Links to other data archives.', 'http://assda.anu.edu.au/', 'http://assda.anu.edu.au/htdig/htsearch?method=and&format=builtin-long&sort=score&config=assda&restrict=http://assda.anu.edu.au/&exclude=&words={$formKeywords}', NULL, 2),
(5074, 979, 'UK Data Archive', 'The Data Archive at the University of Essex houses the largest collection of accessible computer-readable data in the social sciences and humanities in the United Kingdom. It is a national resource centre, disseminating data throughout the United Kingdom and, by arrangement with other national archives, internationally. Founded in 1967, it now houses approximately seven thousand datasets of interest to researchers in all sectors and from many different disciplines.', 'http://www.data-archive.ac.uk/', 'http://www.data-archive.ac.uk/search/allSearch.asp?ct=xmlAll&zoom_and=1&q1={$formKeywords}', NULL, 3),
(5075, 979, 'Social Science Data on the Internet', 'Social Science Data on the Internet is an extensive collection of 873 Internet sites of numeric social science statistical data, data catalogs, data libraries, social science gateways, and financial and economic census files.', 'http://odwin.ucsd.edu/idata/', 'http://odwin.ucsd.edu/cgi-bin/easy_search2?print=notitle&file+Data+on+the+Net=%2Fdata%2Fdata.html&amp;skip=search.html&header=%2Fheader%2Fheader&search={$formKeywords}', NULL, 4),
(5076, 980, 'CTheory (Requires registration)', 'An international, electronic review of books on theory, technology and culture. Sponsored by the Canadian Journal of Political and Social Theory, reviews are posted periodically of key books in contemporary discourse as well as theorisations of major "event-scenes" in the mediascape.', 'http://www.ctheory.net/', 'http://www.google.com/search?q=site%3Awww.ctheory.net+{$formKeywords}', NULL, 0),
(5077, 981, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(5078, 981, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(5079, 981, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(5080, 981, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(5081, 982, 'Country Studies: Area Handbook Series', 'From the Library of Congress, this site provides extensive information on foreign countries.  The Country Studies Series presents a description and analysis of the historical setting and the social, economic, political, and national security systems and institutions of countries throughout the world.', 'http://lcweb2.loc.gov/frd/cs/cshome.html', 'http://search.loc.gov:8765/query.html?col=loc&qp=url%3A%2Frr%2Ffrd%2F&submit.x=11&submit.y=9&qt={$formKeywords}', NULL, 0),
(5082, 982, 'International Monetary Fund (IMF)', 'International Monetary Fund (IMF). Searchable and browsable database of IMF publications, including IMF Country Reports, Working Papers, Occasional Papers, and Policy Discussion Papers. Some reports listed on the site are not full-text but are available in print in the UCB main library.', 'http://www.imf.org/external/pubind.htm', 'http://www.imf.org/external/pubs/cat/shortres.cfm?auth_ed=&subject=&ser_note=All&datecrit=During&YEAR=Year&Lang_F=All&brtype=Date&submit=Search&TITLE={$formKeywords}', NULL, 1),
(5083, 982, 'Inter-American Development Bank Project Documents', 'Inter-American Development Bank Project Documents. Project documents from the Inter-American Development Bank, browseable by country and economic sector. Includes both proposed and approved projects.', 'http://www.iadb.org/exr/pic/index.cfm?language=english', 'http://search.iadb.org/search.asp?ServerKey=Primary&collection=newcoll&language=English&ResultTemplate=default1.hts&ResultStyle=normal&ViewTemplate=docview.hts&Querytext={$formKeywords}', NULL, 2),
(5084, 982, 'CIA World Fact Book', 'Unclassified since 1971, The Central Intelligence Agency''s annual World Fact Book provides a reliable resource for information on independent states, dependencies, areas of special sovereignty, uninhabitable regions, and oceans (a total of 267 entries). Each entry typically includes concise physical and demographic statistics, an economic overview, as well as communications, transportation, and military information.', 'https://www.cia.gov/library/publications/the-world-factbook/index.html', 'https://www.cia.gov/search?NS-search-page=results&NS-tocstart-pat=/text/HTML-advquery-tocstart.pat', 'NS-search-type=NS-boolean-query&NS-max-records=20&NS-sort-by=&NS-max-records=20&NS-collection=Everything&NS-query={$formKeywords}', 3),
(5085, 983, 'Australian Social Science Data Archive', 'ASSDA is a member of the International Federation of Data Organisations (IFDO) through which it maintains contacts with data organisations abroad actively engaged in providing the social science community with computerised data and documentation. Links to other data archives.', 'http://assda.anu.edu.au/', 'http://assda.anu.edu.au/htdig/htsearch?method=and&format=builtin-long&sort=score&config=assda&restrict=http://assda.anu.edu.au/&exclude=&words={$formKeywords}', NULL, 0),
(5086, 983, 'Social Science Research Network - SSRN (Austin, Texas, USA)', 'Social Science Research Network (SSRN) is devoted to the rapid worldwide dissemination of social science research and is composed of a number of specialized research networks in each of the social sciences.', 'http://www.ssrn.com/', 'http://papers.ssrn.com/sol3/results.cfm', 'searchTitle=Title&searchAbstract=Abstract&txtAuthorsFName=&txtAuthorsLName=&optionDateLimit=0&Form_Name=Abstract_Search&txtKey_Words={$formKeywords}', 1),
(5087, 983, 'SocioSite', 'SocioSite is a multi-purpose guide for sociologists. Based in the Netherlands, it includes useful links to sites around the world.', 'http://www2.fmg.uva.nl/sociosite/', 'http://www.google.com/search?q=site:www2%2Efmg%2Euva%2Enl%2Fsociosite%2F+', NULL, 2),
(5088, 983, 'Statistical Resources on the Web', 'This site, created and maintained by University of Michigan Documents Center, is organized by broad subject area, such as Foreign or Statistics, in order to facilitate research.', 'http://www.lib.umich.edu/govdocs/statsnew.html', 'http://www.google.com/u/umlib?hl=en&lr=&ie=ISO-8859-1&domains=www.lib.umich.edu&sitesearch=www.lib.umich.edu&q=inurl%3Agovdocs+-govdocs%2Fadnotes%2F+%0D%0A-govdocs%2Fgodort%2F&q={$formKeywords}', NULL, 3),
(5089, 984, 'H-Net Humanities and Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www.h-net.msu.edu/', 'http://www.h-net.org/logsearch/index.cgi?type=keyword&order=relevance&list=All+lists&hitlimit=25&smonth=00&syear=1989&emonth=11&eyear=2004&phrase={$formKeywords}', NULL, 0),
(5090, 984, 'Intute: Social Sciences - Conferences and Events', 'Intute: Social Sciences - Conferences and Events provides search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(5091, 984, 'Sociology Online', 'Sociology Online is a site for students of sociology, criminology and social theory. The site has slideshows, quizzes, and documents, as well as a Socio-News page.', 'http://www.sociologyonline.co.uk/', 'http://ccgi.sociologyonline.force9.co.uk/cgi-bin/site/searchnews.pl?dosearch', 'match=keywords&searchin=(All)&author=(All)&category=(All)&newsfrom=(All)&resultnumber=10&sort=new&multipage=on&linkcompression=10&highlight=on&searchquery={$formKeywords}', 2),
(5092, 985, 'The Australasian Legal Information Institute (AustLII)', 'Australasian Legal Information Institute (AustLII) provides free Internet access to Australian legal materials. AustLII''s broad public policy agenda is to improve access to justice through better access to information. To that end, it has become one of the largest sources of legal materials on the net, with over seven gigabytes of raw text materials and over 1.5 million searchable documents.', 'http://www.austlii.org/', 'http://www.austlii.edu.au/cgi-bin/sinocgi.cgi?method=any&meta=%2Fau&results=50&submit=Search&rank=on&callback=on&query={$formKeywords}', NULL, 0),
(5093, 985, 'The Legal Information Institute (US)', 'Legal Information Institute (US) is an extensive materials on the law that has overviews of more than 100 legal topics, including: links to the laws and related Web resources; Constitutions & Codes has both state and federal; Court Opinions, available judicial opinion, federal and state; Law by Source, federal, state, and international; Current Awareness includes Eye on the Courts (news on important court decisions); Directories, links to organizations and journals (law reviews); as well as directories of judges, lawyers, and law schools.', 'http://www.law.cornell.edu/', 'http://www.law.cornell.edu/wex/index.php/Special:Search?fulltext=Search&search={$formKeywords}', NULL, 1),
(5094, 985, 'The British and Irish Legal Information Institute (BAILII)', 'British and Irish Legal Information Institute (BAILII) provides access to the most comprehensive set of British and Irish primary legal materials that are available for free and in one place on the Internet. As of September 2001, BAILII included 19 databases covering 5 jurisdictions. The system contains over two gigabytes of legal materials and around 275,000 searchable documents with about 10 million internal hypertext links.', 'http://www.bailii.org/', 'http://www.bailii.org/cgi-bin/sino_search_1.cgi?sort=rank&method=boolean&highlight=1&mask_path=/&query={$formKeywords}', NULL, 2),
(5095, 985, 'CanLII', 'CanLII is a permanent resource in Canadian Law that was initially built as a prototype site in the field of public and free distribution of Canadian primary legal material.', 'http://www.canlii.org/en/index.html', 'http://www.canlii.org/eliisa/search.do?language=en&searchTitle=Search+all+CanLII+Databases&searchPage=eliisa%2FmainPageSearch.vm&id=&startDate=&endDate=&legislation=legislation&caselaw=courts&boardTribunal=tribunals&text={$formKeywords}', NULL, 3),
(5096, 985, 'The World Legal Information Institute (WorldLII)', 'The World Legal Information Institute (WorldLII) is a free, independent and non-profit global legal research facility.', 'http://www.worldlii.org/', 'http://www.worldlii.org/form/search/?method=any&meta=%2Fworldlii&results=50&submit=Search&rank=on&callback=on&query={$formKeywords}', NULL, 4),
(5097, 985, 'FindLaw', 'FindLaw is one of the best examples of a subject-specific metasite. More than just an extremely well-organized directory of selected Internet law resources, FindLaw also offers a search tool for legal Web pages, the largest free database of full-text Supreme Court cases, a search engine and directory of online law reviews, a collection of state codes, interactive continuing education courses, and legal online discussions.', 'http://www.findlaw.com/', 'http://lawcrawler.findlaw.com/scripts/lc.pl?submit=search&sites=findlaw.com&entry={$formKeywords}', NULL, 5),
(5098, 985, 'Jurist: The Law Professors'' Network', 'Jurist-Law professors on the web provides links to the home pages of over fifty law professors, to over fifty pre- and post-prints of articles (in nine subjects from business law to regulation), and to twenty meta-pages, maintained by law professors, on topics from administrative to tax law. Also included are a large list of online law course pages, three lectures, and pointers to other resources. Essentially an annotated tour through the law resources of the Internet conducted by professors of law.', 'http://www.law.pitt.edu/hibbitts/jurist.htm', 'http://www.picosearch.com/cgi-bin/ts.pl?index=110412&opt=ALL&SEARCH=Search+JURIST+5000&query={$formKeywords}', NULL, 6),
(5099, 986, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(5100, 986, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://publications.gc.ca/helpAndInfo/abtpbs-e.htm', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(5101, 986, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 2),
(5102, 986, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 3),
(5103, 986, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www-fed-all&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=5&y=16&mw0={$formKeywords}', NULL, 4),
(5104, 986, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 5),
(5105, 986, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 6),
(5106, 986, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 7),
(5107, 986, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 8),
(5108, 986, 'Eur-Lex -- The portal to European Union law', 'Eur-Lex (European Union Law). Free service with access to the The Official Journal of the European Union, full-text of EU Treaties, consolidated versions of existing legislation and recent judgments by the Court of Justice.', 'http://europa.eu.int/eur-lex/en/index.html', 'http://europa.eu.int/search/s97.vts?Action=FilterSearch&COLLECTION=EURLEXfiles&Filter=EUROPA_filter.hts&ResultTemplate=eur-lex_res-en.hts&QueryMode=Simple&SearchPage=%2Feur-lex%2Fen%2Findex.html&SearchIn=http%3A%2F%2Feuropa.eu.int%2Feur-lex%2Fen&SortField=Score&SortOrder=desc&StartDate=&HTMLonly=&ResultCount=25&queryText={$formKeywords}', NULL, 9),
(5109, 986, 'Rulers', 'This site contains lists of heads of state and heads of government (and, in certain cases, de facto leaders not occupying either of those formal positions) of all countries and territories, going back to about 1700 in most cases. Also included are the subdivisions of various countries, recent foreign ministers of all countries, and a selection of international organizations, religious leaders and a chronicle of relevant events since 1996.', 'http://www.rulers.org/', 'http://www.google.com/search?q=site%3Arulers.org&q={$formKeywords}', NULL, 10),
(5110, 986, 'Thomas Legislative Information on the Internet', 'Through Thomas, the Library of Congress offers the text of bills in the United States Congress, the full text of the Congressional Record, House and Senate committee reports, and historical documents.', 'http://thomas.loc.gov/', 'http://thomas.loc.gov/cgi-bin/thomas', 'congress=109&database=text&MaxDocs=1000&querytype=phrase&Search=SEARCH&query={$formKeywords}', 11),
(5111, 987, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(5112, 987, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(5113, 987, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(5114, 987, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(5115, 987, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(5116, 987, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 5),
(5117, 987, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(5118, 987, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(5119, 987, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(5120, 987, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(5121, 988, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(5122, 988, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(5123, 988, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(5124, 988, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3);

-- --------------------------------------------------------

--
-- Table structure for table `rt_versions`
--

CREATE TABLE IF NOT EXISTS `rt_versions` (
  `version_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `version_key` varchar(40) NOT NULL,
  `locale` varchar(5) DEFAULT 'en_US',
  `title` varchar(120) NOT NULL,
  `description` text,
  PRIMARY KEY (`version_id`),
  KEY `rt_versions_journal_id` (`journal_id`),
  KEY `rt_versions_version_key` (`version_key`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=77 ;

--
-- Dumping data for table `rt_versions`
--

INSERT INTO `rt_versions` (`version_id`, `journal_id`, `version_key`, `locale`, `title`, `description`) VALUES
(58, 4, 'Agriculture', 'en_US', 'Agriculture', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(59, 4, 'Art_Architecture', 'en_US', 'Art & Architecture', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(60, 4, 'Astrophysics', 'en_US', 'Astrophysics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(61, 4, 'Biology', 'en_US', 'Biology', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(62, 4, 'Business', 'en_US', 'Business', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(63, 4, 'Chemistry', 'en_US', 'Chemistry', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(64, 4, 'Cognitive_Science', 'en_US', 'Cognitive Science', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(65, 4, 'Computer_Science', 'en_US', 'Computer Science', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(66, 4, 'Economics', 'en_US', 'Economics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(67, 4, 'Education', 'en_US', 'Education', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(68, 4, 'Environment', 'en_US', 'Environment', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(69, 4, 'General_Science', 'en_US', 'General Science', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(70, 4, 'Generic', 'en_US', 'Generic', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(71, 4, 'Humanities', 'en_US', 'Humanities', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(72, 4, 'Life_Sciences', 'en_US', 'Life Sciences', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(73, 4, 'Mathematics', 'en_US', 'Mathematics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(74, 4, 'Music', 'en_US', 'Music', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(75, 4, 'Physics', 'en_US', 'Physics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(76, 4, 'Social_Sciences', 'en_US', 'Social Sciences', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.');

-- --------------------------------------------------------

--
-- Table structure for table `scheduled_tasks`
--

CREATE TABLE IF NOT EXISTS `scheduled_tasks` (
  `class_name` varchar(255) NOT NULL,
  `last_run` datetime DEFAULT NULL,
  UNIQUE KEY `scheduled_tasks_pkey` (`class_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE IF NOT EXISTS `sections` (
  `section_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `review_form_id` bigint(20) DEFAULT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `editor_restricted` tinyint(4) NOT NULL DEFAULT '0',
  `meta_indexed` tinyint(4) NOT NULL DEFAULT '0',
  `meta_reviewed` tinyint(4) NOT NULL DEFAULT '1',
  `abstracts_not_required` tinyint(4) NOT NULL DEFAULT '0',
  `hide_title` tinyint(4) NOT NULL DEFAULT '0',
  `hide_author` tinyint(4) NOT NULL DEFAULT '0',
  `hide_about` tinyint(4) NOT NULL DEFAULT '0',
  `disable_comments` tinyint(4) NOT NULL DEFAULT '0',
  `abstract_word_count` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`section_id`),
  KEY `sections_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `section_decisions`
--

CREATE TABLE IF NOT EXISTS `section_decisions` (
  `section_decision_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `review_type` tinyint(1) NOT NULL,
  `round` tinyint(4) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `decision` tinyint(4) NOT NULL,
  `comments` text,
  `date_decided` datetime NOT NULL,
  PRIMARY KEY (`section_decision_id`),
  UNIQUE KEY `article_id` (`article_id`,`review_type`,`round`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `section_editors`
--

CREATE TABLE IF NOT EXISTS `section_editors` (
  `journal_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `can_edit` tinyint(4) NOT NULL DEFAULT '1',
  `can_review` tinyint(4) NOT NULL DEFAULT '1',
  UNIQUE KEY `section_editors_pkey` (`journal_id`,`section_id`,`user_id`),
  KEY `section_editors_journal_id` (`journal_id`),
  KEY `section_editors_section_id` (`section_id`),
  KEY `section_editors_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `section_settings`
--

CREATE TABLE IF NOT EXISTS `section_settings` (
  `section_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `section_settings_pkey` (`section_id`,`locale`,`setting_name`),
  KEY `section_settings_section_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(40) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `ip_address` varchar(39) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created` bigint(20) NOT NULL DEFAULT '0',
  `last_used` bigint(20) NOT NULL DEFAULT '0',
  `remember` tinyint(4) NOT NULL DEFAULT '0',
  `data` text,
  `acting_as` bigint(20) NOT NULL DEFAULT '0',
  UNIQUE KEY `sessions_pkey` (`session_id`),
  KEY `sessions_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `acting_as`) VALUES
('67sopgl30hsaqglc1d5e2d23t2', 16, '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:35.0) Gecko/20100101 Firefox/35.0', 1422986815, 1422987092, 0, 'userId|s:2:"16";username|s:5:"admin";', 0);

-- --------------------------------------------------------

--
-- Table structure for table `signoffs`
--

CREATE TABLE IF NOT EXISTS `signoffs` (
  `signoff_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbolic` varchar(32) NOT NULL,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL,
  `file_id` bigint(20) DEFAULT NULL,
  `file_revision` bigint(20) DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `date_underway` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `date_acknowledged` datetime DEFAULT NULL,
  `stage_id` bigint(20) DEFAULT NULL,
  `user_group_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`signoff_id`),
  UNIQUE KEY `signoff_symbolic` (`assoc_type`,`assoc_id`,`symbolic`,`user_id`,`stage_id`,`user_group_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1080 ;

--
-- Dumping data for table `signoffs`
--

INSERT INTO `signoffs` (`signoff_id`, `symbolic`, `assoc_type`, `assoc_id`, `user_id`, `file_id`, `file_revision`, `date_notified`, `date_underway`, `date_completed`, `date_acknowledged`, `stage_id`, `user_group_id`) VALUES
(99, 'SIGNOFF_COPYEDITING_INITIAL', 257, 17, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(100, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 17, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(101, 'SIGNOFF_COPYEDITING_FINAL', 257, 17, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(102, 'SIGNOFF_LAYOUT', 257, 17, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(103, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 17, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(104, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 17, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(105, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 17, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1009, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1008, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1007, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 2, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1006, 'SIGNOFF_LAYOUT', 257, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1005, 'SIGNOFF_COPYEDITING_FINAL', 257, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1004, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 2, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1003, 'SIGNOFF_COPYEDITING_INITIAL', 257, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1002, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(120, 'SIGNOFF_COPYEDITING_INITIAL', 257, 20, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(121, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 20, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(122, 'SIGNOFF_COPYEDITING_FINAL', 257, 20, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(123, 'SIGNOFF_LAYOUT', 257, 20, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(124, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 20, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(125, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 20, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(126, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 20, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(127, 'SIGNOFF_COPYEDITING_INITIAL', 257, 21, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(128, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 21, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(129, 'SIGNOFF_COPYEDITING_FINAL', 257, 21, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(130, 'SIGNOFF_LAYOUT', 257, 21, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(131, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 21, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(132, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 21, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(133, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 21, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(134, 'SIGNOFF_COPYEDITING_INITIAL', 257, 22, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(135, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 22, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(136, 'SIGNOFF_COPYEDITING_FINAL', 257, 22, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(137, 'SIGNOFF_LAYOUT', 257, 22, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(138, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 22, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(139, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 22, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(140, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 22, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(141, 'SIGNOFF_COPYEDITING_INITIAL', 257, 23, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(142, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 23, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(143, 'SIGNOFF_COPYEDITING_FINAL', 257, 23, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(144, 'SIGNOFF_LAYOUT', 257, 23, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(145, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 23, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(146, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 23, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(147, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 23, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(148, 'SIGNOFF_COPYEDITING_INITIAL', 257, 24, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(149, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 24, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(150, 'SIGNOFF_COPYEDITING_FINAL', 257, 24, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(151, 'SIGNOFF_LAYOUT', 257, 24, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(152, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 24, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(153, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 24, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(154, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 24, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(155, 'SIGNOFF_COPYEDITING_INITIAL', 257, 25, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(156, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 25, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(157, 'SIGNOFF_COPYEDITING_FINAL', 257, 25, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(158, 'SIGNOFF_LAYOUT', 257, 25, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(159, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 25, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(160, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 25, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(161, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 25, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(162, 'SIGNOFF_COPYEDITING_INITIAL', 257, 26, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(163, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 26, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(164, 'SIGNOFF_COPYEDITING_FINAL', 257, 26, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(165, 'SIGNOFF_LAYOUT', 257, 26, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(166, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 26, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(167, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 26, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(168, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 26, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(169, 'SIGNOFF_COPYEDITING_INITIAL', 257, 27, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(170, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 27, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(171, 'SIGNOFF_COPYEDITING_FINAL', 257, 27, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(172, 'SIGNOFF_LAYOUT', 257, 27, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(173, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 27, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(174, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 27, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(175, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 27, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(176, 'SIGNOFF_COPYEDITING_INITIAL', 257, 28, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(177, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 28, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(178, 'SIGNOFF_COPYEDITING_FINAL', 257, 28, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(179, 'SIGNOFF_LAYOUT', 257, 28, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(180, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 28, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(181, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 28, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(182, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 28, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(197, 'SIGNOFF_COPYEDITING_INITIAL', 257, 31, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(198, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 31, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(199, 'SIGNOFF_COPYEDITING_FINAL', 257, 31, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(200, 'SIGNOFF_LAYOUT', 257, 31, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(201, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 31, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(202, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 31, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(203, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 31, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(204, 'SIGNOFF_COPYEDITING_INITIAL', 257, 32, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(205, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 32, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(206, 'SIGNOFF_COPYEDITING_FINAL', 257, 32, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(207, 'SIGNOFF_LAYOUT', 257, 32, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(208, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 32, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(209, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 32, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(210, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 32, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(211, 'SIGNOFF_COPYEDITING_INITIAL', 257, 33, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(212, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 33, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(213, 'SIGNOFF_COPYEDITING_FINAL', 257, 33, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(214, 'SIGNOFF_LAYOUT', 257, 33, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(215, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 33, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(216, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 33, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(217, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 33, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(218, 'SIGNOFF_COPYEDITING_INITIAL', 257, 34, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(219, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 34, 126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(220, 'SIGNOFF_COPYEDITING_FINAL', 257, 34, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(221, 'SIGNOFF_LAYOUT', 257, 34, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(222, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 34, 126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(223, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 34, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(224, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 34, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(253, 'SIGNOFF_COPYEDITING_INITIAL', 257, 39, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(254, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 39, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(255, 'SIGNOFF_COPYEDITING_FINAL', 257, 39, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(256, 'SIGNOFF_LAYOUT', 257, 39, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(257, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 39, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(258, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 39, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(259, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 39, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(260, 'SIGNOFF_COPYEDITING_INITIAL', 257, 40, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(261, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 40, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(262, 'SIGNOFF_COPYEDITING_FINAL', 257, 40, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(263, 'SIGNOFF_LAYOUT', 257, 40, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(264, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 40, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(265, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 40, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(266, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 40, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(959, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 43, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(958, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 43, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(957, 'SIGNOFF_LAYOUT', 257, 43, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(956, 'SIGNOFF_COPYEDITING_FINAL', 257, 43, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(955, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 43, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(954, 'SIGNOFF_COPYEDITING_INITIAL', 257, 43, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(980, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 65, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(979, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 65, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(978, 'SIGNOFF_LAYOUT', 257, 65, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(977, 'SIGNOFF_COPYEDITING_FINAL', 257, 65, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(976, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 65, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(975, 'SIGNOFF_COPYEDITING_INITIAL', 257, 65, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(967, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 58, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(966, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 58, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(965, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 58, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(964, 'SIGNOFF_LAYOUT', 257, 58, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(961, 'SIGNOFF_COPYEDITING_INITIAL', 257, 58, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(962, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 58, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(963, 'SIGNOFF_COPYEDITING_FINAL', 257, 58, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(316, 'SIGNOFF_COPYEDITING_INITIAL', 257, 54, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(317, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 54, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(318, 'SIGNOFF_COPYEDITING_FINAL', 257, 54, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(319, 'SIGNOFF_LAYOUT', 257, 54, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(320, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 54, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(321, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 54, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(322, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 54, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(323, 'SIGNOFF_COPYEDITING_INITIAL', 257, 55, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(324, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 55, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(325, 'SIGNOFF_COPYEDITING_FINAL', 257, 55, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(326, 'SIGNOFF_LAYOUT', 257, 55, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(327, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 55, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(328, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 55, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(329, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 55, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(330, 'SIGNOFF_COPYEDITING_INITIAL', 257, 56, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(331, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 56, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(332, 'SIGNOFF_COPYEDITING_FINAL', 257, 56, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(333, 'SIGNOFF_LAYOUT', 257, 56, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(334, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 56, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(335, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 56, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(336, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 56, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(337, 'SIGNOFF_COPYEDITING_INITIAL', 257, 57, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(338, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 57, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(339, 'SIGNOFF_COPYEDITING_FINAL', 257, 57, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(340, 'SIGNOFF_LAYOUT', 257, 57, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(341, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 57, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(342, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 57, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(343, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 57, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(344, 'SIGNOFF_COPYEDITING_INITIAL', 257, 59, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(345, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 59, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(346, 'SIGNOFF_COPYEDITING_FINAL', 257, 59, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(347, 'SIGNOFF_LAYOUT', 257, 59, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(348, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 59, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(349, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 59, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(350, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 59, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(351, 'SIGNOFF_COPYEDITING_INITIAL', 257, 61, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(352, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 61, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(353, 'SIGNOFF_COPYEDITING_FINAL', 257, 61, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(354, 'SIGNOFF_LAYOUT', 257, 61, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(355, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 61, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(356, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 61, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(357, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 61, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(358, 'SIGNOFF_COPYEDITING_INITIAL', 257, 68, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(359, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 68, 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(360, 'SIGNOFF_COPYEDITING_FINAL', 257, 68, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(361, 'SIGNOFF_LAYOUT', 257, 68, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(362, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 68, 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(363, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 68, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(364, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 68, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(365, 'SIGNOFF_COPYEDITING_INITIAL', 257, 60, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(366, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 60, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(367, 'SIGNOFF_COPYEDITING_FINAL', 257, 60, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(368, 'SIGNOFF_LAYOUT', 257, 60, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(369, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 60, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(370, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 60, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(371, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 60, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(372, 'SIGNOFF_COPYEDITING_INITIAL', 257, 83, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(373, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 83, 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(374, 'SIGNOFF_COPYEDITING_FINAL', 257, 83, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(375, 'SIGNOFF_LAYOUT', 257, 83, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(376, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 83, 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(377, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 83, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(378, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 83, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(379, 'SIGNOFF_COPYEDITING_INITIAL', 257, 84, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(380, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 84, 53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(381, 'SIGNOFF_COPYEDITING_FINAL', 257, 84, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(382, 'SIGNOFF_LAYOUT', 257, 84, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(383, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 84, 53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(384, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 84, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(385, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 84, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(387, 'SIGNOFF_COPYEDITING_INITIAL', 257, 87, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(388, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 87, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(389, 'SIGNOFF_COPYEDITING_FINAL', 257, 87, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(390, 'SIGNOFF_LAYOUT', 257, 87, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(391, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 87, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(392, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 87, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(393, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 87, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(394, 'SIGNOFF_COPYEDITING_INITIAL', 257, 91, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(395, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 91, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(396, 'SIGNOFF_COPYEDITING_FINAL', 257, 91, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(397, 'SIGNOFF_LAYOUT', 257, 91, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(398, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 91, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(399, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 91, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(400, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 91, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(401, 'SIGNOFF_COPYEDITING_INITIAL', 257, 92, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(402, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 92, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(403, 'SIGNOFF_COPYEDITING_FINAL', 257, 92, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(404, 'SIGNOFF_LAYOUT', 257, 92, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(405, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 92, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(406, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 92, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(407, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 92, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(408, 'SIGNOFF_COPYEDITING_INITIAL', 257, 94, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(409, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 94, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(410, 'SIGNOFF_COPYEDITING_FINAL', 257, 94, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(411, 'SIGNOFF_LAYOUT', 257, 94, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(412, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 94, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(413, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 94, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(414, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 94, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(415, 'SIGNOFF_COPYEDITING_INITIAL', 257, 95, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(416, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 95, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(417, 'SIGNOFF_COPYEDITING_FINAL', 257, 95, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(418, 'SIGNOFF_LAYOUT', 257, 95, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(419, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 95, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(420, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 95, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(421, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 95, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(422, 'SIGNOFF_COPYEDITING_INITIAL', 257, 96, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(423, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 96, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(424, 'SIGNOFF_COPYEDITING_FINAL', 257, 96, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(425, 'SIGNOFF_LAYOUT', 257, 96, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(426, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 96, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(427, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 96, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(428, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 96, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(429, 'SIGNOFF_COPYEDITING_INITIAL', 257, 98, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(430, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 98, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(431, 'SIGNOFF_COPYEDITING_FINAL', 257, 98, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(432, 'SIGNOFF_LAYOUT', 257, 98, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(433, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 98, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(434, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 98, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(435, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 98, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(436, 'SIGNOFF_COPYEDITING_INITIAL', 257, 100, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(437, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 100, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(438, 'SIGNOFF_COPYEDITING_FINAL', 257, 100, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(439, 'SIGNOFF_LAYOUT', 257, 100, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(440, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 100, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(441, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 100, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(442, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 100, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(443, 'SIGNOFF_COPYEDITING_INITIAL', 257, 101, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(444, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 101, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(445, 'SIGNOFF_COPYEDITING_FINAL', 257, 101, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(446, 'SIGNOFF_LAYOUT', 257, 101, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(447, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 101, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(448, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 101, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(449, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 101, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(450, 'SIGNOFF_COPYEDITING_INITIAL', 257, 102, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(451, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 102, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(452, 'SIGNOFF_COPYEDITING_FINAL', 257, 102, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(453, 'SIGNOFF_LAYOUT', 257, 102, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(454, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 102, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(455, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 102, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(456, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 102, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(457, 'SIGNOFF_COPYEDITING_INITIAL', 257, 99, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(458, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 99, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(459, 'SIGNOFF_COPYEDITING_FINAL', 257, 99, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(460, 'SIGNOFF_LAYOUT', 257, 99, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(461, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 99, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(462, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 99, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(463, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 99, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(464, 'SIGNOFF_COPYEDITING_INITIAL', 257, 97, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(465, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 97, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(466, 'SIGNOFF_COPYEDITING_FINAL', 257, 97, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(467, 'SIGNOFF_LAYOUT', 257, 97, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(468, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 97, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(469, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 97, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(470, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 97, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(471, 'SIGNOFF_COPYEDITING_INITIAL', 257, 103, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(472, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 103, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(473, 'SIGNOFF_COPYEDITING_FINAL', 257, 103, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(474, 'SIGNOFF_LAYOUT', 257, 103, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(475, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 103, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(476, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 103, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(477, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 103, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(478, 'SIGNOFF_COPYEDITING_INITIAL', 257, 104, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(479, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 104, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(480, 'SIGNOFF_COPYEDITING_FINAL', 257, 104, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(481, 'SIGNOFF_LAYOUT', 257, 104, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(482, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 104, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(483, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 104, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(484, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 104, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(485, 'SIGNOFF_COPYEDITING_INITIAL', 257, 105, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(486, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 105, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(487, 'SIGNOFF_COPYEDITING_FINAL', 257, 105, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(488, 'SIGNOFF_LAYOUT', 257, 105, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(489, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 105, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(490, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 105, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(491, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 105, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(492, 'SIGNOFF_COPYEDITING_INITIAL', 257, 106, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(493, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 106, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(494, 'SIGNOFF_COPYEDITING_FINAL', 257, 106, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(495, 'SIGNOFF_LAYOUT', 257, 106, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(496, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 106, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(497, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 106, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(498, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 106, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(499, 'SIGNOFF_COPYEDITING_INITIAL', 257, 107, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(500, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 107, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(501, 'SIGNOFF_COPYEDITING_FINAL', 257, 107, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(502, 'SIGNOFF_LAYOUT', 257, 107, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(503, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 107, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(504, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 107, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(505, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 107, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(506, 'SIGNOFF_COPYEDITING_INITIAL', 257, 108, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(507, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 108, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(508, 'SIGNOFF_COPYEDITING_FINAL', 257, 108, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(509, 'SIGNOFF_LAYOUT', 257, 108, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(510, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 108, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(511, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 108, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(512, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 108, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(513, 'SIGNOFF_COPYEDITING_INITIAL', 257, 109, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(514, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 109, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(515, 'SIGNOFF_COPYEDITING_FINAL', 257, 109, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(516, 'SIGNOFF_LAYOUT', 257, 109, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(517, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 109, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(518, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 109, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(519, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 109, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(520, 'SIGNOFF_COPYEDITING_INITIAL', 257, 110, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(521, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 110, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(522, 'SIGNOFF_COPYEDITING_FINAL', 257, 110, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(523, 'SIGNOFF_LAYOUT', 257, 110, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(524, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 110, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(525, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 110, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(526, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 110, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(527, 'SIGNOFF_COPYEDITING_INITIAL', 257, 111, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(528, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 111, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(529, 'SIGNOFF_COPYEDITING_FINAL', 257, 111, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(530, 'SIGNOFF_LAYOUT', 257, 111, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(531, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 111, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(532, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 111, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(533, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 111, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(534, 'SIGNOFF_COPYEDITING_INITIAL', 257, 112, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(535, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 112, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(536, 'SIGNOFF_COPYEDITING_FINAL', 257, 112, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(537, 'SIGNOFF_LAYOUT', 257, 112, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(538, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 112, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(539, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 112, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(540, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 112, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(541, 'SIGNOFF_COPYEDITING_INITIAL', 257, 113, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(542, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 113, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(543, 'SIGNOFF_COPYEDITING_FINAL', 257, 113, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(544, 'SIGNOFF_LAYOUT', 257, 113, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(545, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 113, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(546, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 113, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(547, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 113, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(548, 'SIGNOFF_COPYEDITING_INITIAL', 257, 114, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(549, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 114, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(550, 'SIGNOFF_COPYEDITING_FINAL', 257, 114, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(551, 'SIGNOFF_LAYOUT', 257, 114, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(552, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 114, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(553, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 114, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(554, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 114, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(555, 'SIGNOFF_COPYEDITING_INITIAL', 257, 115, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(556, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 115, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(557, 'SIGNOFF_COPYEDITING_FINAL', 257, 115, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(558, 'SIGNOFF_LAYOUT', 257, 115, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(559, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 115, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(560, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 115, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(561, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 115, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(562, 'SIGNOFF_COPYEDITING_INITIAL', 257, 116, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(563, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 116, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(564, 'SIGNOFF_COPYEDITING_FINAL', 257, 116, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(565, 'SIGNOFF_LAYOUT', 257, 116, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(566, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 116, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(567, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 116, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(568, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 116, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(569, 'SIGNOFF_COPYEDITING_INITIAL', 257, 117, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(570, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 117, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(571, 'SIGNOFF_COPYEDITING_FINAL', 257, 117, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(572, 'SIGNOFF_LAYOUT', 257, 117, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(573, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 117, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(574, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 117, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(575, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 117, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(576, 'SIGNOFF_COPYEDITING_INITIAL', 257, 118, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(577, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 118, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(578, 'SIGNOFF_COPYEDITING_FINAL', 257, 118, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(579, 'SIGNOFF_LAYOUT', 257, 118, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(580, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 118, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(581, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 118, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(582, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 118, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(583, 'SIGNOFF_COPYEDITING_INITIAL', 257, 119, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(584, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 119, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(585, 'SIGNOFF_COPYEDITING_FINAL', 257, 119, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(586, 'SIGNOFF_LAYOUT', 257, 119, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(587, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 119, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(588, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 119, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(589, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 119, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(590, 'SIGNOFF_COPYEDITING_INITIAL', 257, 120, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(591, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 120, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(592, 'SIGNOFF_COPYEDITING_FINAL', 257, 120, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(593, 'SIGNOFF_LAYOUT', 257, 120, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(594, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 120, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(595, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 120, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(596, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 120, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(597, 'SIGNOFF_COPYEDITING_INITIAL', 257, 121, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(598, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 121, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(599, 'SIGNOFF_COPYEDITING_FINAL', 257, 121, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(600, 'SIGNOFF_LAYOUT', 257, 121, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(601, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 121, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(602, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 121, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(603, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 121, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(604, 'SIGNOFF_COPYEDITING_INITIAL', 257, 122, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(605, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 122, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(606, 'SIGNOFF_COPYEDITING_FINAL', 257, 122, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(607, 'SIGNOFF_LAYOUT', 257, 122, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(608, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 122, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(609, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 122, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(610, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 122, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(611, 'SIGNOFF_COPYEDITING_INITIAL', 257, 123, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(612, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 123, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(613, 'SIGNOFF_COPYEDITING_FINAL', 257, 123, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(614, 'SIGNOFF_LAYOUT', 257, 123, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(615, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 123, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(616, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 123, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(617, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 123, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(618, 'SIGNOFF_COPYEDITING_INITIAL', 257, 124, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(619, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 124, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(620, 'SIGNOFF_COPYEDITING_FINAL', 257, 124, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(621, 'SIGNOFF_LAYOUT', 257, 124, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(622, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 124, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(623, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 124, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(624, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 124, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(625, 'SIGNOFF_COPYEDITING_INITIAL', 257, 125, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(626, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 125, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(627, 'SIGNOFF_COPYEDITING_FINAL', 257, 125, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(628, 'SIGNOFF_LAYOUT', 257, 125, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(629, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 125, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(630, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 125, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(631, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 125, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(632, 'SIGNOFF_COPYEDITING_INITIAL', 257, 126, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(633, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 126, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(634, 'SIGNOFF_COPYEDITING_FINAL', 257, 126, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(635, 'SIGNOFF_LAYOUT', 257, 126, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(636, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 126, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(637, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 126, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(638, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 126, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(639, 'SIGNOFF_COPYEDITING_INITIAL', 257, 127, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(640, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 127, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(641, 'SIGNOFF_COPYEDITING_FINAL', 257, 127, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(642, 'SIGNOFF_LAYOUT', 257, 127, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(643, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 127, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(644, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 127, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(645, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 127, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(646, 'SIGNOFF_COPYEDITING_INITIAL', 257, 128, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(647, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 128, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(648, 'SIGNOFF_COPYEDITING_FINAL', 257, 128, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(649, 'SIGNOFF_LAYOUT', 257, 128, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(650, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 128, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(651, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 128, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(652, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 128, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(653, 'SIGNOFF_COPYEDITING_INITIAL', 257, 129, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(654, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 129, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(655, 'SIGNOFF_COPYEDITING_FINAL', 257, 129, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(656, 'SIGNOFF_LAYOUT', 257, 129, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(657, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 129, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(658, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 129, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(659, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 129, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(660, 'SIGNOFF_COPYEDITING_INITIAL', 257, 130, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(661, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 130, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(662, 'SIGNOFF_COPYEDITING_FINAL', 257, 130, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(663, 'SIGNOFF_LAYOUT', 257, 130, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(664, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 130, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(665, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 130, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(666, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 130, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(667, 'SIGNOFF_COPYEDITING_INITIAL', 257, 131, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(668, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 131, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(669, 'SIGNOFF_COPYEDITING_FINAL', 257, 131, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(670, 'SIGNOFF_LAYOUT', 257, 131, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(671, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 131, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(672, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 131, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(673, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 131, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(674, 'SIGNOFF_COPYEDITING_INITIAL', 257, 132, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(675, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 132, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(676, 'SIGNOFF_COPYEDITING_FINAL', 257, 132, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(677, 'SIGNOFF_LAYOUT', 257, 132, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(678, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 132, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(679, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 132, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(680, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 132, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(681, 'SIGNOFF_COPYEDITING_INITIAL', 257, 133, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(682, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 133, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(683, 'SIGNOFF_COPYEDITING_FINAL', 257, 133, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(684, 'SIGNOFF_LAYOUT', 257, 133, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(685, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 133, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(686, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 133, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(687, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 133, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(688, 'SIGNOFF_COPYEDITING_INITIAL', 257, 134, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(689, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 134, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(690, 'SIGNOFF_COPYEDITING_FINAL', 257, 134, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(691, 'SIGNOFF_LAYOUT', 257, 134, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(692, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 134, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(693, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 134, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(694, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 134, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(695, 'SIGNOFF_COPYEDITING_INITIAL', 257, 135, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(696, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 135, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(697, 'SIGNOFF_COPYEDITING_FINAL', 257, 135, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(698, 'SIGNOFF_LAYOUT', 257, 135, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(699, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 135, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `signoffs` (`signoff_id`, `symbolic`, `assoc_type`, `assoc_id`, `user_id`, `file_id`, `file_revision`, `date_notified`, `date_underway`, `date_completed`, `date_acknowledged`, `stage_id`, `user_group_id`) VALUES
(700, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 135, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(701, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 135, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(702, 'SIGNOFF_COPYEDITING_INITIAL', 257, 136, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(703, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 136, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(704, 'SIGNOFF_COPYEDITING_FINAL', 257, 136, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(705, 'SIGNOFF_LAYOUT', 257, 136, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(706, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 136, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(707, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 136, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(708, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 136, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(709, 'SIGNOFF_COPYEDITING_INITIAL', 257, 137, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(710, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 137, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(711, 'SIGNOFF_COPYEDITING_FINAL', 257, 137, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(712, 'SIGNOFF_LAYOUT', 257, 137, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(713, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 137, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(714, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 137, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(715, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 137, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(716, 'SIGNOFF_COPYEDITING_INITIAL', 257, 138, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(717, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 138, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(718, 'SIGNOFF_COPYEDITING_FINAL', 257, 138, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(719, 'SIGNOFF_LAYOUT', 257, 138, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(720, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 138, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(721, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 138, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(722, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 138, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(723, 'SIGNOFF_COPYEDITING_INITIAL', 257, 139, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(724, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 139, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(725, 'SIGNOFF_COPYEDITING_FINAL', 257, 139, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(726, 'SIGNOFF_LAYOUT', 257, 139, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(727, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 139, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(728, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 139, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(729, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 139, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(730, 'SIGNOFF_COPYEDITING_INITIAL', 257, 140, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(731, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 140, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(732, 'SIGNOFF_COPYEDITING_FINAL', 257, 140, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(733, 'SIGNOFF_LAYOUT', 257, 140, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(734, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 140, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(735, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 140, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(736, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 140, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(737, 'SIGNOFF_COPYEDITING_INITIAL', 257, 141, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(738, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 141, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(739, 'SIGNOFF_COPYEDITING_FINAL', 257, 141, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(740, 'SIGNOFF_LAYOUT', 257, 141, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(741, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 141, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(742, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 141, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(743, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 141, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(744, 'SIGNOFF_COPYEDITING_INITIAL', 257, 142, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(745, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 142, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(746, 'SIGNOFF_COPYEDITING_FINAL', 257, 142, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(747, 'SIGNOFF_LAYOUT', 257, 142, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(748, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 142, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(749, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 142, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(750, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 142, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(751, 'SIGNOFF_COPYEDITING_INITIAL', 257, 143, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(752, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 143, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(753, 'SIGNOFF_COPYEDITING_FINAL', 257, 143, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(754, 'SIGNOFF_LAYOUT', 257, 143, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(755, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 143, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(756, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 143, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(757, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 143, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(758, 'SIGNOFF_COPYEDITING_INITIAL', 257, 144, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(759, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 144, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(760, 'SIGNOFF_COPYEDITING_FINAL', 257, 144, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(761, 'SIGNOFF_LAYOUT', 257, 144, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(762, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 144, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(763, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 144, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(764, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 144, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(765, 'SIGNOFF_COPYEDITING_INITIAL', 257, 145, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(766, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 145, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(767, 'SIGNOFF_COPYEDITING_FINAL', 257, 145, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(768, 'SIGNOFF_LAYOUT', 257, 145, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(769, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 145, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(770, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 145, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(771, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 145, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(772, 'SIGNOFF_COPYEDITING_INITIAL', 257, 146, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(773, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 146, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(774, 'SIGNOFF_COPYEDITING_FINAL', 257, 146, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(775, 'SIGNOFF_LAYOUT', 257, 146, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(776, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 146, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(777, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 146, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(778, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 146, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(779, 'SIGNOFF_COPYEDITING_INITIAL', 257, 147, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(780, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 147, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(781, 'SIGNOFF_COPYEDITING_FINAL', 257, 147, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(782, 'SIGNOFF_LAYOUT', 257, 147, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(783, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 147, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(784, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 147, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(785, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 147, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(786, 'SIGNOFF_COPYEDITING_INITIAL', 257, 148, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(787, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 148, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(788, 'SIGNOFF_COPYEDITING_FINAL', 257, 148, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(789, 'SIGNOFF_LAYOUT', 257, 148, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(790, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 148, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(791, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 148, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(792, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 148, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(793, 'SIGNOFF_COPYEDITING_INITIAL', 257, 149, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(794, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 149, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(795, 'SIGNOFF_COPYEDITING_FINAL', 257, 149, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(796, 'SIGNOFF_LAYOUT', 257, 149, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(797, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 149, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(798, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 149, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(799, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 149, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(800, 'SIGNOFF_COPYEDITING_INITIAL', 257, 150, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(801, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 150, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(802, 'SIGNOFF_COPYEDITING_FINAL', 257, 150, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(803, 'SIGNOFF_LAYOUT', 257, 150, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(804, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 150, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(805, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 150, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(806, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 150, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(807, 'SIGNOFF_COPYEDITING_INITIAL', 257, 151, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(808, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 151, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(809, 'SIGNOFF_COPYEDITING_FINAL', 257, 151, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(810, 'SIGNOFF_LAYOUT', 257, 151, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(811, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 151, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(812, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 151, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(813, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 151, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(989, 'SIGNOFF_COPYEDITING_INITIAL', 257, 11, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(990, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 11, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(991, 'SIGNOFF_COPYEDITING_FINAL', 257, 11, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(992, 'SIGNOFF_LAYOUT', 257, 11, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(828, 'SIGNOFF_COPYEDITING_INITIAL', 257, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(829, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 15, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(830, 'SIGNOFF_COPYEDITING_FINAL', 257, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(831, 'SIGNOFF_LAYOUT', 257, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(832, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 15, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(833, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(834, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(835, 'SIGNOFF_COPYEDITING_INITIAL', 257, 14, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(836, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 14, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(837, 'SIGNOFF_COPYEDITING_FINAL', 257, 14, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(838, 'SIGNOFF_LAYOUT', 257, 14, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(839, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 14, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(840, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 14, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(841, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 14, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(993, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 11, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(994, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 11, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(996, 'SIGNOFF_COPYEDITING_INITIAL', 257, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(997, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 1, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(998, 'SIGNOFF_COPYEDITING_FINAL', 257, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(924, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 7, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(923, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 7, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(922, 'SIGNOFF_LAYOUT', 257, 7, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(921, 'SIGNOFF_COPYEDITING_FINAL', 257, 7, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(920, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 7, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(919, 'SIGNOFF_COPYEDITING_INITIAL', 257, 7, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(999, 'SIGNOFF_LAYOUT', 257, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1000, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 1, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1001, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(925, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 7, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1050, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 16, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1049, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 16, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1048, 'SIGNOFF_LAYOUT', 257, 16, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1047, 'SIGNOFF_COPYEDITING_FINAL', 257, 16, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1046, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 16, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1045, 'SIGNOFF_COPYEDITING_INITIAL', 257, 16, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(891, 'SIGNOFF_COPYEDITING_INITIAL', 257, 9, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(892, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 9, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(893, 'SIGNOFF_COPYEDITING_FINAL', 257, 9, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(894, 'SIGNOFF_LAYOUT', 257, 9, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(895, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 9, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(896, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 9, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(897, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 9, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(898, 'SIGNOFF_COPYEDITING_INITIAL', 257, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(899, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 10, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(900, 'SIGNOFF_COPYEDITING_FINAL', 257, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(901, 'SIGNOFF_LAYOUT', 257, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(902, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 10, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(903, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(904, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 10, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(960, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 43, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(912, 'SIGNOFF_COPYEDITING_INITIAL', 257, 13, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(913, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 13, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(914, 'SIGNOFF_COPYEDITING_FINAL', 257, 13, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(915, 'SIGNOFF_LAYOUT', 257, 13, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(916, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 13, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(917, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 13, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(918, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 13, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(968, 'SIGNOFF_COPYEDITING_INITIAL', 257, 62, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(969, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 62, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(970, 'SIGNOFF_COPYEDITING_FINAL', 257, 62, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(971, 'SIGNOFF_LAYOUT', 257, 62, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(972, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 62, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(973, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 62, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(974, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 62, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(981, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 65, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(982, 'SIGNOFF_COPYEDITING_INITIAL', 257, 66, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(983, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 66, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(984, 'SIGNOFF_COPYEDITING_FINAL', 257, 66, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(985, 'SIGNOFF_LAYOUT', 257, 66, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(986, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 66, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(987, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 66, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(988, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 66, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(995, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 11, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1010, 'SIGNOFF_COPYEDITING_INITIAL', 257, 12, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1011, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 12, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1012, 'SIGNOFF_COPYEDITING_FINAL', 257, 12, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1013, 'SIGNOFF_LAYOUT', 257, 12, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1014, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 12, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1015, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 12, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1016, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 12, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1017, 'SIGNOFF_COPYEDITING_INITIAL', 257, 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1018, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 3, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1019, 'SIGNOFF_COPYEDITING_FINAL', 257, 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1020, 'SIGNOFF_LAYOUT', 257, 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1021, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 3, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1022, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1023, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1024, 'SIGNOFF_COPYEDITING_INITIAL', 257, 4, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1025, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 4, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1026, 'SIGNOFF_COPYEDITING_FINAL', 257, 4, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1027, 'SIGNOFF_LAYOUT', 257, 4, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1028, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 4, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1029, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 4, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1030, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 4, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1031, 'SIGNOFF_COPYEDITING_INITIAL', 257, 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1032, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 5, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1033, 'SIGNOFF_COPYEDITING_FINAL', 257, 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1034, 'SIGNOFF_LAYOUT', 257, 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1035, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 5, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1036, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1037, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1038, 'SIGNOFF_COPYEDITING_INITIAL', 257, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1039, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 6, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1040, 'SIGNOFF_COPYEDITING_FINAL', 257, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1041, 'SIGNOFF_LAYOUT', 257, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1042, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 6, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1043, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1044, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1051, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 16, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1052, 'SIGNOFF_COPYEDITING_INITIAL', 257, 18, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1053, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 18, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1054, 'SIGNOFF_COPYEDITING_FINAL', 257, 18, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1055, 'SIGNOFF_LAYOUT', 257, 18, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1056, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 18, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1057, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 18, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1058, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 18, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1059, 'SIGNOFF_COPYEDITING_INITIAL', 257, 19, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1060, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 19, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1061, 'SIGNOFF_COPYEDITING_FINAL', 257, 19, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1062, 'SIGNOFF_LAYOUT', 257, 19, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1063, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 19, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1064, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 19, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1065, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 19, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1066, 'SIGNOFF_COPYEDITING_INITIAL', 257, 30, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1067, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 30, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1068, 'SIGNOFF_COPYEDITING_FINAL', 257, 30, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1069, 'SIGNOFF_LAYOUT', 257, 30, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1070, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 30, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1071, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 30, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1072, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 30, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1073, 'SIGNOFF_COPYEDITING_INITIAL', 257, 29, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1074, 'SIGNOFF_COPYEDITING_AUTHOR', 257, 29, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1075, 'SIGNOFF_COPYEDITING_FINAL', 257, 29, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1076, 'SIGNOFF_LAYOUT', 257, 29, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1077, 'SIGNOFF_PROOFREADING_AUTHOR', 257, 29, 120, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1078, 'SIGNOFF_PROOFREADING_PROOFREADER', 257, 29, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1079, 'SIGNOFF_PROOFREADING_LAYOUT', 257, 29, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `site`
--

CREATE TABLE IF NOT EXISTS `site` (
  `redirect` bigint(20) NOT NULL DEFAULT '0',
  `primary_locale` varchar(5) NOT NULL,
  `min_password_length` tinyint(4) NOT NULL DEFAULT '6',
  `installed_locales` varchar(255) NOT NULL DEFAULT 'en_US',
  `supported_locales` varchar(255) DEFAULT NULL,
  `original_style_file_name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `site`
--

INSERT INTO `site` (`redirect`, `primary_locale`, `min_password_length`, `installed_locales`, `supported_locales`, `original_style_file_name`) VALUES
(4, 'en_US', 6, 'en_US', 'en_US', 'hrp.css');

-- --------------------------------------------------------

--
-- Table structure for table `site_settings`
--

CREATE TABLE IF NOT EXISTS `site_settings` (
  `setting_name` varchar(255) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `site_settings_pkey` (`setting_name`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `site_settings`
--

INSERT INTO `site_settings` (`setting_name`, `locale`, `setting_value`, `setting_type`) VALUES
('contactEmail', 'en_US', 'contact@hrp.com', 'string'),
('contactName', 'en_US', 'Health Research Portal Administrator', 'string'),
('title', 'en_US', 'Health Research Portal', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `static_pages`
--

CREATE TABLE IF NOT EXISTS `static_pages` (
  `static_page_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  PRIMARY KEY (`static_page_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `static_page_settings`
--

CREATE TABLE IF NOT EXISTS `static_page_settings` (
  `static_page_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` longtext,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `static_page_settings_pkey` (`static_page_id`,`locale`,`setting_name`),
  KEY `static_page_settings_static_page_id` (`static_page_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE IF NOT EXISTS `subscriptions` (
  `subscription_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `type_id` bigint(20) NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `membership` varchar(40) DEFAULT NULL,
  `reference_number` varchar(40) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`subscription_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription_types`
--

CREATE TABLE IF NOT EXISTS `subscription_types` (
  `type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `cost` double NOT NULL,
  `currency_code_alpha` varchar(3) NOT NULL,
  `non_expiring` tinyint(4) NOT NULL DEFAULT '0',
  `duration` smallint(6) DEFAULT NULL,
  `format` smallint(6) NOT NULL,
  `institutional` tinyint(4) NOT NULL DEFAULT '0',
  `membership` tinyint(4) NOT NULL DEFAULT '0',
  `disable_public_display` tinyint(4) NOT NULL,
  `seq` double NOT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription_type_settings`
--

CREATE TABLE IF NOT EXISTS `subscription_type_settings` (
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `subscription_type_settings_pkey` (`type_id`,`locale`,`setting_name`),
  KEY `subscription_type_settings_type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `temporary_files`
--

CREATE TABLE IF NOT EXISTS `temporary_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`file_id`),
  KEY `temporary_files_user_id` (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `theses`
--

CREATE TABLE IF NOT EXISTS `theses` (
  `thesis_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `degree` smallint(6) NOT NULL,
  `degree_name` varchar(255) DEFAULT NULL,
  `department` varchar(255) NOT NULL,
  `university` varchar(255) NOT NULL,
  `date_approved` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `url` text,
  `abstract` text,
  `comment` text,
  `student_first_name` varchar(40) NOT NULL,
  `student_middle_name` varchar(40) DEFAULT NULL,
  `student_last_name` varchar(90) NOT NULL,
  `student_email` varchar(90) NOT NULL,
  `student_email_publish` tinyint(4) DEFAULT '0',
  `student_bio` text,
  `supervisor_first_name` varchar(40) NOT NULL,
  `supervisor_middle_name` varchar(40) DEFAULT NULL,
  `supervisor_last_name` varchar(90) NOT NULL,
  `supervisor_email` varchar(90) NOT NULL,
  `discipline` varchar(255) DEFAULT NULL,
  `subject_class` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `coverage_geo` varchar(255) DEFAULT NULL,
  `coverage_chron` varchar(255) DEFAULT NULL,
  `coverage_sample` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `language` varchar(10) DEFAULT 'en',
  `date_submitted` datetime NOT NULL,
  PRIMARY KEY (`thesis_id`),
  KEY `theses_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(40) NOT NULL,
  `salutation` varchar(40) DEFAULT NULL,
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(90) NOT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `initials` varchar(5) DEFAULT NULL,
  `email` varchar(90) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `phone` varchar(24) DEFAULT NULL,
  `fax` varchar(24) DEFAULT NULL,
  `mailing_address` varchar(255) DEFAULT NULL,
  `country` varchar(90) DEFAULT NULL,
  `locales` varchar(255) DEFAULT NULL,
  `date_last_email` datetime DEFAULT NULL,
  `date_registered` datetime NOT NULL,
  `date_validated` datetime DEFAULT NULL,
  `date_last_login` datetime NOT NULL,
  `must_change_password` tinyint(4) DEFAULT NULL,
  `auth_id` bigint(20) DEFAULT NULL,
  `auth_str` varchar(255) DEFAULT NULL,
  `disabled` tinyint(4) NOT NULL DEFAULT '0',
  `disabled_reason` text,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_username` (`username`),
  UNIQUE KEY `users_email` (`email`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=131 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `salutation`, `first_name`, `middle_name`, `last_name`, `gender`, `initials`, `email`, `url`, `phone`, `fax`, `mailing_address`, `country`, `locales`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`) VALUES
(16, 'admin', 'bc2c8e435784523054d9697d5a29bf0b', '', 'admin', '', 'admin', '', '', 'testtest.admin@admin.admin', '', '765434567890', '', '', '', '', '2012-05-31 14:38:00', '2011-11-17 14:15:48', NULL, '2015-02-04 02:06:59', 0, NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE IF NOT EXISTS `user_settings` (
  `user_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `assoc_type` bigint(20) DEFAULT '0',
  `assoc_id` bigint(20) DEFAULT '0',
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `user_settings_pkey` (`user_id`,`locale`,`setting_name`,`assoc_type`,`assoc_id`),
  KEY `user_settings_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_settings`
--

INSERT INTO `user_settings` (`user_id`, `locale`, `setting_name`, `assoc_type`, `assoc_id`, `setting_value`, `setting_type`) VALUES
(16, '', 'filterEditor', 256, 4, '0', 'int'),
(16, '', 'filterSection', 256, 4, '0', 'int'),
(16, 'en_US', 'biography', 0, 0, '', 'string'),
(16, 'en_US', 'signature', 0, 0, '', 'string'),
(16, 'en_US', 'gossip', 0, 0, '', 'string'),
(16, 'en_US', 'affiliation', 0, 0, '', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `versions`
--

CREATE TABLE IF NOT EXISTS `versions` (
  `major` int(11) NOT NULL DEFAULT '0',
  `minor` int(11) NOT NULL DEFAULT '0',
  `revision` int(11) NOT NULL DEFAULT '0',
  `build` int(11) NOT NULL DEFAULT '0',
  `date_installed` datetime NOT NULL,
  `current` tinyint(4) NOT NULL DEFAULT '0',
  `product_type` varchar(30) DEFAULT NULL,
  `product` varchar(30) DEFAULT NULL,
  `product_class_name` varchar(80) DEFAULT NULL,
  `lazy_load` tinyint(4) NOT NULL DEFAULT '0',
  `sitewide` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `versions_pkey` (`product`,`major`,`minor`,`revision`,`build`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `versions`
--

INSERT INTO `versions` (`major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.auth', 'ldap', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'authorBios', 'AuthorBiosBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'information', 'InformationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'keywordCloud', 'KeywordCloudBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'navigation', 'NavigationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'notification', 'NotificationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'readingTools', 'ReadingToolsBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'relatedItems', 'RelatedItemsBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'role', 'RoleBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'subscription', 'SubscriptionBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'user', 'UserBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'donation', 'DonationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'help', 'HelpBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'developedBy', 'DevelopedByBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'languageToggle', 'LanguageToggleBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.blocks', 'fontSize', 'FontSizeBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'abnt', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'apa', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'bibtex', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'cbe', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'endNote', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'mla', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'proCite', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'refMan', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'refWorks', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.citationFormats', 'turabian', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.gateways', 'metsGateway', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.gateways', 'resolver', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'announcementFeed', 'AnnouncementFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'booksForReview', 'BooksForReviewPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'coins', 'CoinsPlugin', 1, 0),
(1, 1, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'counter', 'CounterPlugin', 1, 1),
(1, 1, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'customBlockManager', 'CustomBlockManagerPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'customLocale', 'CustomLocalePlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'externalFeed', 'ExternalFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'googleAnalytics', 'GoogleAnalyticsPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'openAds', 'OpenAdsPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'openAIRE', 'OpenAIREPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'phpMyVisites', 'PhpMyVisitesPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'referral', 'ReferralPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'roundedCorners', 'RoundedCornersPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'sehl', 'SehlPlugin', 1, 0),
(1, 2, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'staticPages', 'StaticPagesPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'sword', 'SwordPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'thesis', 'ThesisPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'thesisFeed', 'ThesisFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'tinymce', 'TinyMCEPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'translator', 'TranslatorPlugin', 1, 1),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'webFeed', 'WebFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.generic', 'xmlGalley', 'XmlGalleyPlugin', 1, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.implicitAuth', 'shibboleth', '', 0, 1),
(1, 1, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'crossref', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'doaj', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'erudit', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'mets', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'native', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'pubmed', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'quickSubmit', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.importexport', 'users', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.oaiMetadataFormats', 'dc', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.oaiMetadataFormats', 'marc', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.oaiMetadataFormats', 'marcxml', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.oaiMetadataFormats', 'nlm', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.oaiMetadataFormats', 'rfc1807', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.paymethod', 'manual', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.paymethod', 'paypal', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.reports', 'articles', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.reports', 'reviews', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.reports', 'subscriptions', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.reports', 'views', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'classicBlue', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'classicBrown', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'classicGreen', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'classicNavy', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'classicRed', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'custom', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'desert', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'lilac', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'night', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'redbar', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'steel', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'uncommon', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'vanilla', '', 0, 0),
(1, 0, 0, 0, '2011-11-17 14:15:48', 1, 'plugins.themes', 'hrp', '', 0, 0),
(2, 3, 4, 0, '2011-11-17 14:14:27', 1, 'core', 'ojs2', '', 0, 1),
(1, 0, 0, 0, '2014-04-10 14:47:16', 1, 'plugins.blocks', 'links', 'LinksBlockPlugin', 1, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
