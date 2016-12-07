<?php

$ret = '';
if ('1' === $_GET['type']) {

    $handle = popen("tail -n 50 observer1.log 2>&1", 'r');
    while (!feof($handle)) {
        $buffer = fgets($handle);
        $ret.=$buffer;
    }
} else {
    $ret =  file_get_contents("observer2.log");
}
echo $ret;
//$file = "1.txt";
//$size = 100;
//$f = fopen($file, 'r');
//while (true) {
//    if (!feof($f)) {
//        echo fread($f, $size);
//    }
//}
//fclose($f);
//
//exit;

//ob_start();
//$handle = popen("tail -f 1.txt 2>&1", 'r');
//while(!feof($handle)) {
//$buffer = fgets($handle);
//echo "$buffer\n";
//ob_flush();
//flush();
//}
//ob_end();
//pclose($handle);

//ob_start();
//  print "\n--endofsection\n";
//
//  $pmt = array("-", "\\", "|", "/" );
//  for( $i = 0; $i <10; $i ++ ){
//     sleep(1);
//     print "Content-type: text/plain\n\n";
//     print "Part $i\t".$pmt[$i % 4];
//     print "--endofsection\n";
//     ob_flush();
//     flush();
//  }
//  print "Content-type: text/plain\n\n";
//  print "The end\n";
//  print "--endofsection--\n";
//  ob_end();