 <?php

/**
 * @file classes/form/validation/FormValidatorArrayRadios.inc.php
 *
 * Copyright (c) 2000-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class FormValidatorArray
 * @ingroup form_validation
 *
 * @brief Form validation check that checks an array of fields.
 */

import('lib.pkp.classes.form.validation.FormValidator');

class FormValidatorArrayRadios extends FormValidator {

	/** @var array Array of fields to check */
	var $twoDimenstion;
    
        /** @var array Array of fields to check */
	var $_radiofields;

	/** @var array Array of field names where an error occurred */
	var $_errorFields;

	/**
	 * Constructor.
	 * @param $form Form the associated form
	 * @param $field string the name of the associated field
	 * @param $type string the type of check, either "required" or "optional"
	 * @param $message string the error message for validation failures (i18n key)
	 * @param $radiofields array all the radio buttons to check.
         * @param $twoDim boolean specify if if this is a 2 dimensional array
	 */
	function FormValidatorArrayRadios(&$form, $field, $type, $message, $radiofields, $twoDim = false) {
		parent::FormValidator($form, $field, $type, $message);
		$this->twoDimenstion = $twoDim;
		$this->_radiofields = $radiofields;
		$this->_errorFields = array();
	}


	//
	// Setters and Getters
	//
	/**
	 * Get array of fields where an error occurred.
	 * @return array
	 */
	function getErrorFields() {
		return $this->_errorFields;
	}


	//
	// Public methods
	//
	/**
	 * @see FormValidator::isValid()
	 * Value is valid if it is empty and optional or all field values are set.
	 * @return boolean
	 */
	function isValid() {
		if ($this->getType() == FORM_VALIDATOR_OPTIONAL_VALUE) return true;
                $data = $this->getFieldValue();
		if (!is_array($data)) return false;
                $isValid = true;
		foreach ($data as $key => $value) {
                    if (is_array($value) && $this->twoDimenstion) {
                        foreach($this->_radiofields as $radioFieldKey => $radioFieldValue){
                            foreach ($value as $subkey => $subvalue) {
                                if ($subkey == $radioFieldValue) {
                                    unset ($this->_radiofields[$radioFieldKey]);
                                }
                            }
                        }
                        foreach($value as $subkey => $subvalue ) {
                            if( isset( $subvalue ) && $subvalue != "") {
                               unset( $value[$subkey] );
                            }                                 
                        }
                        if (!empty($value) || !empty($this->_radiofields)){
                            $isValid = false;
                            array_push($this->_errorFields, $this->getField()."[{$key}]");
                        }                               
                    } elseif(is_array($value) && !$this->twoDimenstion) {
                        foreach($value as $subkey => $subvalue ) {
                            if( empty( $subvalue ) )
                            {
                               unset( $value[$subkey] );
                            }
                        }
                        if (empty($value)){
                            $isValid = false;
                            array_push($this->_errorFields, $this->getField()."[{$key}]");
                        }
                    } elseif(!is_array($value)) {
                        if (is_null($value) || trim((string)$value) == '') {
                            $isValid = false;
                            array_push($this->_errorFields, $this->getField()."[{$key}]");
                        }
                    }
		}
                if (!$this->twoDimenstion) {
                    foreach($this->_radiofields as $radioField){
                        if (!isset($data[$radioField])) {
                            $isValid = false;
                        }
                    }                    
                }

		return $isValid;
	}
}

?>