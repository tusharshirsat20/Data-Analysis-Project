<?php

$filep=fopen("testfile.txt", "r");
$filec=fopen("result.csv", "w");
//echo fread($file,filesize("testfile.txt"));
$count=0;
$c=0;
echo "HELLO WORLD !!! ";

while( !feof($filep) ){
 	
	$line=fgets($filep); 
	if( preg_match("/^\s*$/i", $line) ){
		continue;
	}

	if( preg_match_all("/s\d{9}/i", $line) ){
		
		preg_match_all("/s\d{9}|([a-z]+\s[a-z]*\s[a-z]*)|\d{8}[a-z]/i", $line, $arr1 );
		$seatno=$arr1[0][0];
		$name=$arr1[0][1];
		$mname=$arr1[0][2];
		$prnno=$arr1[0][3];
		file_put_contents("result.csv", $arr1[0][0].",".$arr1[0][1].",".$arr1[0][2].",".$arr1[0][3].",",FILE_APPEND);	
	}
	
	if( preg_match("/SEM.:1/i", $line)){
		file_put_contents("result.csv","SEM 1".",",FILE_APPEND);
	}
	if( preg_match("/SEM.:2/i", $line)){

		file_put_contents("result.csv","\n".$seatno.",".$name.",".$mname.",".$prnno.",SEM 2,",FILE_APPEND);
	}
	
	if (preg_match("/21\d{4}[A-Z]*(?=\s)|20\d{4}[A-Z]*(?=\s)/", $line)) {   // 21\d{4}[A-B]*(?=\s)|20\d{4}[A-B]*(?=\s)    
	// to select the lines contaning marks

		$c=$c+1;
		if( preg_match_all("/\w+[+$#\/]*\w*|---|#/i", $line, $arr3) ){      //\w+\+*\/*\w*|---     //to only select marks

			foreach ($arr3[0] as $value) {  //\w+\+*\$*\/*\w*|---  		  
				//print_r($value); 				
				file_put_contents("result.csv",$value.",",FILE_APPEND);	
			}   //echo "<br>";
			if ($c==20) {
				file_put_contents("result.csv","\n",FILE_APPEND);
				$c=0;
			}

		} //inner if
	} //outer if

//$count=$count+1;
} // end while

fclose($filec);
fclose($filep);

?>