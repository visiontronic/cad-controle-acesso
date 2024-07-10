<?php
date_default_timezone_set('UTC');
$URL_CAD = '';
$ip = $_SERVER['REMOTE_ADDR'];
		
if(isset($_GET['cardid'])&&isset($_GET['cjihao'])&&isset($_GET['mjihao'])&&isset($_GET['status'])&&isset($_GET['time'])){
	$result = new TestResult();

	$info = new TestInfo();
	$info->cardid = intval($_GET['cardid']);
	$info->cjihao = intval($_GET['cjihao']);
	$info->mjihao = intval($_GET['mjihao']);
	$info->time = date('U');
	if($info->cardid % 2 == 0){
		$URL_CAD = "http://127.0.0.1:8081/datasnap/rest/TMetodosCDA/QRCodeReader/" . $ip ."||" . rawurlencode(strval($_GET['cardid']));
		$info->status = 1;
		$info->output = 2;
		$info->cardid = "123456";
	}else{
		$URL_CAD = "http://127.0.0.1:8081/datasnap/rest/TMetodosCDA/QRCodeReader/" . $ip ."||" . rawurlencode(strval($_GET['cardid']));
		$info->status = 1;
		$info->output = 2;
		$info->cardid = "89ABCDEF";
	}
	$result->data[] = $info;
}else{
	$result = new Result();
	$result->code = -1;
}
echo json_encode($result);
CallAPI('GET', $URL_CAD, false);

class Result {
	public $code = 0;
	public $message = '';
}

class TestResult extends Result {
	public $data = array();

}

class TestInfo {
	public $cardid;
	public $cjihao;
	public $mjihao;
	public $status;
	public $time;
	public $output;
}

function CallAPI($method, $url, $data = false)
{
	$curl = curl_init();

    curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
    curl_setopt($curl, CURLOPT_USERPWD, "F11B789184F71A120A7F:5DAFD53225197EEE5CCD");
    
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_TIMEOUT_MS, 100);
    
    $result = curl_exec($curl);
    
    curl_close($curl);
    
    return $result;
}
?>
