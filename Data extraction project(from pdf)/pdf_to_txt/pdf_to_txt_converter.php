<?php

	include '../../../../home/tushar/vendor/autoload.php';

	function convertToTxt($pdfName,$fileName) 			//pdfName is the name of pdf file to be converted;fileName is the name of txt file that the pdf file is converted into
	{
		$parser = new \Smalot\PdfParser\Parser();
		$pdf    = $parser->parseFile($pdfName);
		$text = $pdf->getText();
		
		$myfile = fopen($fileName, "w");
		fwrite($myfile,$text);
		fclose($myfile);
	}

?>
