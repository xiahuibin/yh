<?php
include_once('function.php');
include_once("inc/conn.php");
//����������
ob_clean();
/*
header("Content-Type: text/html; charset=utf-8");
mysql_query("set names utf8",$connection);
*/
$Key=mysql_real_escape_string(strip_tags(unEscape($Key)),$connection); //����HTML��ǩ����ת��������
$START_ID=stripslashes($_POST['START_ID']);
$Search_Start_ID=stripslashes($_POST['Search_Start_ID']);
if($Key=="")
$query="select * from  WEIXUN_SHARE order by WEIXUN_ID desc limit $START_ID,8";
else
$query="select WEIXUN_SHARE.* from WEIXUN_SHARE,USER where WEIXUN_SHARE.UID=USER.UID  and (CONTENT like '%$Key%' or USER_NAME like '%$Key%') order by WEIXUN_ID desc limit $Search_Start_ID,8";

$cursor= exequery($connection,$query);
$num=0;
while($ROW=mysql_fetch_array($cursor))
{
	$WeixunList.=GetWeixun($ROW['WEIXUN_ID'],$ROW['CONTENT'],$ROW['ADDTIME'],$ROW['UID']);
	$num=$num+1;
}
//$result[]=array('list'=>$WeixunList,'num'=>$num);
//$result=urlencode(iconv('gb2312','utf-8',$resultarray['list'])); 

//echo json_encode($result);
echo $WeixunList.$num;
?>
