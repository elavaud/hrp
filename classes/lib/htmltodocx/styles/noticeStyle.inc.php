<?php

// This style defines the elements of a docx approval notice
function htmltodocx_styles_notice($columnHeaderTwips = null) {
  
  // Set the width of each colmun in twips, 
  // based on the number of columns: 
  // the table should fit the entire page.
  if($columnHeaderTwips){
      $tdColumnsWidth = array('width' => $columnHeaderTwips, 'valign' => 'center');
  } else {
      $tdColumnsWidth = array('valign' => 'center');
  }

  
  // Set of default styles - 
  // to set initially whatever the element is:
  // NB - any defaults not set here will be provided by PHPWord.
  $styles['default'] = 
    array (
      'size' => 11,
    );
  
  // Element styles:
  // The keys of the elements array are valid HTML tags;
  // The arrays associated with each of these tags is a set
  // of PHPWord style definitions.
  $styles['elements'] = 
    array (
      'h1' => array (
        'bold' => TRUE,
        'size' => 20,
        ),
      'h2' => array (
        'bold' => TRUE,
        'size' => 15,
        'spaceAfter' => 150,
        ),
      'h3' => array (
        'size' => 12,
        'bold' => TRUE,
        'spaceAfter' => 100,
        ),
      'li' => array (
        ),
      'ol' => array (
        'spaceBefore' => 200,
        ),
      'ul' => array (
        'spaceAfter' => 150,
        ),
      'b' => array (
        'bold' => TRUE,
        ),
      'em' => array (
        'italic' => TRUE,
        ),
      'i' => array (
        'italic' => TRUE,
        ),
      'strong' => array (
        'bold' => TRUE,
        ),
      'b' => array (
        'bold' => TRUE,
        ),
      'sup' => array (
        'superScript' => TRUE,
        'size' => 6,
        ), // Superscript not working in PHPWord 
      'u' => array (
        'underline' => PHPWord_Style_Font::UNDERLINE_SINGLE,
        ),
      'a' => array (
        'color' => '0000FF',
        'underline' => PHPWord_Style_Font::UNDERLINE_SINGLE,
        ),
      'table' => array (
          'valign' => 'center',
// Note that applying a table style in PHPWord applies the relevant style to
        // ALL the cells in the table. So, for example, the borderSize applied here
        // applies to all the cells, and not just to the outer edges of the table:
        ),
      'th' => array (
        ),
      'td' => $tdColumnsWidth,
      );
      
  // Classes:
  // The keys of the classes array are valid CSS classes;
  // The array associated with each of these classes is a set
  // of PHPWord style definitions.
  // Classes will be applied in the order that they appear here if
  // more than one class appears on an element.
  $styles['classes'] = 
    array (
      'underline' => array (
        'underline' => PHPWord_Style_Font::UNDERLINE_SINGLE,
        ),
       'purple' => array (
        'color' => '901391',
       ),
       'green' => array (
        'color' => '00A500',
       ),
      );
  
  // Inline style definitions, of the form:
  // array(css attribute-value - separated by a colon and a single space => array of
  // PHPWord attribute value pairs.    
  $styles['inline'] = 
    array(
      'text-decoration: underline' => array (
        'underline' => PHPWord_Style_Font::UNDERLINE_SINGLE,
      ),
      'text-align: left' => array (
        'align' => 'left',
      ),
      'text-align: center' => array (
        'align' => 'center',
      ),
      'text-align: right' => array (
        'align' => 'right',
      ),
      'float: left' => array (
        'align' => 'left',
      ),
      'float: center' => array (
        'align' => 'center',
      ),
      'float: right' => array (
        'align' => 'right',
      ),
    );
    
  return $styles;
}