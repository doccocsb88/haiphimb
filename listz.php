<?php
#################################################
#				IPOS MOVIE 1.2					#
#		contact: ichphien_pro@yahoo.com			#
#			Phone: 0121 665 111 5				#
#				licence: phimb.net				#
#################################################
define('ipos',true);
require_once('../ip.api/config.php');
header('Content-Type: application/json; charset=utf-8');

$value	=	explode("/",$_GET["v"]);
$key	=	replace($value[0]);
$action	=	replace($value[1]);
$order	=	replace($value[2]);
$page	=	intval($value[3]);
$order1	= 	replace($value[4]);

$ipad 	= 	strpos($_SERVER['HTTP_USER_AGENT'],"iPad");
if($ipad) {
	$num	= 	20;
	//$sql_ipad	=	"AND a.phim_img_big != ''";
}
else
	$num	= 	10;
if (!$page) 	
$page 	= 	1;
$limit 	= 	($page-1)*$num;
if($limit<0) 	
$limit	=	0;

//538c7f456122cca4d87bf6de9dd958b5
if($key=="538c7f456122cca4d87bf6de9dd958b5") {
	if($action=="home") {
		if($order=="carousel")
			$slq_where	=	"a.phimhot = 1 $sql_ipad";
		elseif($order=="new")
			$slq_where	=	"a.phimid > 0";
		elseif($order=="phim-bo-da-hoan-thanh")
			$slq_where	=	"a.phimbo = 1";
		elseif($order=="phim-xem-nhieu") {
			$slq_where	=	"a.viewed_day > 0";
			$slq_order	=	"ORDER BY a.viewed_day DESC LIMIT $limit,$num";
		}
	}
	elseif($action=="relate") {
		$danhmucten_kd	=	$order;
		$categoryA	=	$db->database("danhmucid,danhmucten","category","danhmucten_kd = '$danhmucten_kd'");
		$slq_where	=	"a.theloai LIKE '%,".$categoryA[0][0].",%' AND a.website = 1";
		$slq_order	=	"ORDER BY RAND() LIMIT $page";
	}
	elseif($action=="country") {
		$quocgiaten_kd	=	$order;
		$country	=	$db->database("quocgiaid,quocgiaten","country","quocgiaten_kd = '$quocgiaten_kd'");
		$slq_where	=	"a.quocgia LIKE '%,".$country[0][0].",%' AND a.website = 1";
	}
    elseif($action=="cat") {
		$quocgiaten_kd	=	$order;
		$country	=	$db->database("quocgiaid,quocgiaten","country","quocgiaten_kd = '$quocgiaten_kd'");
		$slq_where	=	"a.theloai LIKE '%,".$country[0][0].",%' AND a.website = 1";
	
		if($order1=="carousel")
			$slq_where	.=	" AND a.phimhot = 1";
		elseif($order1=="phim-bo-da-hoan-thanh")
			$slq_where	.=	" AND a.phimbo = 1";
		elseif($order1=="phim-xem-nhieu")
			$slq_order	=	"ORDER BY a.viewed_day DESC LIMIT $limit,$num";
        
	}
    elseif($action=="catx") {
        $quocgiaten_kd	=	$order;
        //sua phan nay giong voi relate
        $country	=	$db->database("danhmucid,danhmucten","category","danhmucten_kd = '$quocgiaten_kd'");
        $slq_where	=	"a.theloai LIKE '%,".$country[0][0].",%' AND a.website = 1";
        
        if($order1=="carousel")
            $slq_where	.=	" AND a.phimhot = 1";
        elseif($order1=="phim-bo-da-hoan-thanh")
        $slq_where	.=	" AND a.phimbo = 1";
        elseif($order1=="phim-xem-nhieu")
        $slq_order	=	"ORDER BY a.viewed_day DESC LIMIT $limit,$num";
    
    }
	elseif($action=="search") {
		$keys		=	str_replace("-"," ",$order);
		$slq_where	=	"b.timkiem like '%$keys%' $web_where_sql AND a.website = 1";
		$sql_data	=	"LEFT JOIN ".DATABASE_FX."film_info b ON (a.phimid = b.phimid)";
	}
	if(!$slq_order)	$slq_order	=	"ORDER BY a.phimtime DESC LIMIT $limit,$num";
	$arr	=	$db->database("a.phimid,a.tenphim,a.tentienganh,a.phimimg,a.phim_img_big","film a $sql_data","$slq_where $slq_order");
	if($arr) {
		for($i=0;$i<count($arr);$i++) {
			$arr_[]	=	array(
				"id"			=>	$arr[$i][0],
				"name"			=>	$arr[$i][1],
				"subname"		=>	$arr[$i][2],
				"img"			=>	$arr[$i][3],
				"img_landscpae"		=>	$arr[$i][4]
			);
		}
	}
	$json	=	str_replace(':null',':""',json_encode($arr_));
	echo $json;
}
?>