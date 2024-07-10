<?php
$result = '';
$ip = $_SERVER['REMOTE_ADDR'];
if($ip == "127.0.0.1"){
	if(isset($_GET['placa'])){
		$placa = strval($_GET['placa']);
		if ((strlen($placa) > 0) and (strlen($placa) <= 10)){
			$informacoesDaPlacaEmJSON = shell_exec('python placa.py ' . $placa);
			//$informacoesDaPlaca = json_decode($informacoesDaPlacaEmJSON);
			//print_r($informacoesDaPlaca);
			//echo $informacoesDaPlaca;
			$result = $informacoesDaPlacaEmJSON;
		}else{
			$result = '';
		}
	}
}else{
	$result = 'NÃO AUTORIZADO!';
}
echo $result;
?>