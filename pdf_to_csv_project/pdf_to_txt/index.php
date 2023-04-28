<?php
	include "pdf_to_txt_converter.php";
	include "txt_to_csv_converter.php";
	
	convertToTxt("S.E.-2015.pdf","testfile2.txt");
	convertToCsv("testfile2.txt","SE2020");

?>
