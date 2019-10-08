<?php
/**
 *  TCPDFMerger (originally Pdf_concat) created by AbhishekG
 *  http://blog.abhishekg.com/2012/05/concatenate-pdf-in-php/
 * 
 */
import('classes.lib.fpdi.fpdi');
import('classes.lib.tcpdf.tcpdf');

class TCPDFMerger extends FPDI {
     var $files = array();
 
     function setFiles($files) {
          $this->files = $files;
     }
 
     function concat() {
          $this->setPrintHeader(false);
          $this->setPrintFooter(false);         
          foreach($this->files AS $file) {
               $pagecount = $this->setSourceFile($file);
               for ($i = 1; $i <= $pagecount; $i++) {
                    $tplidx = $this->ImportPage($i);
                    $s = $this->getTemplatesize($tplidx);
                    $this->AddPage('P', array($s['w'], $s['h']));
                    $this->useTemplate($tplidx);
               }
          }
     }    
}