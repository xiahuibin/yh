<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp"%>

<%@ page import="yh.core.funcs.system.act.YHSystemAct"%>
<%
String useUsbKeyStr = (String)request.getAttribute("useUsbKey");
String secKeyUserStr = (String)request.getAttribute("secKeyUser");
String verificationCodeStr = (String)request.getAttribute("verificationCode");
String ieTitle = (String)request.getAttribute("ieTitle");
String useYHErpStr = YHSysProps.getString("useYHErp");

if (YHUtility.isNullorEmpty(ieTitle)) {
  ieTitle = StaticData.SOFTTITLE;
}

if (YHUtility.isNullorEmpty(useUsbKeyStr) || YHUtility.isNullorEmpty(secKeyUserStr)) {
  request.getRequestDispatcher("/yh/core/funcs/system/act/YHSystemAct/prepareLoginIn.act").forward(request, response);
  return;
}

boolean useUsbKey = "1".equals(useUsbKeyStr);
boolean secKeyUser = "1".equals(secKeyUserStr);
boolean useYHErp = "1".equals(useYHErpStr);
boolean verificationCode = "1".equals(verificationCodeStr);



Integer randomInt = (Integer)request.getSession().getAttribute("RANDOM_NUMBER");

int randomNum = 123456;
if (randomInt != null) {
  randomNum = randomInt;
}
String template = YHSystemAct.queryTemplate(request);
template = contextPath + "/core/templates/" + template;
%>
<html>
<head>
<title><%=ieTitle %></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="author" content="<%=StaticData.SOFTKEYWORD%>" />
<meta name="keywords" content="<%=StaticData.SOFTKEYWORD%>" />
<meta name="description" content="<%=StaticData.SOFTKEYWORD%>" />
<style type="text/css">
* {
	margin: 0;
	padding: 0;
}
</style>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/login.css" />
<script type="text/javascript" src="<%=contextPath%>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/tdPass.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/rsa.js"></script>
<script type="text/javascript">
var useUsbKey = <%=useUsbKey%>;
var secKeyUser = <%=secKeyUser%>;
var useYHErp = <%=useYHErp%>;
var randomNum = "<%=randomNum%>";
function checkUserName(inputStr) {
  var tmpValue = inputStr;
  //?????????????????????????????????????????????????????????????????????""
  if (tmpValue.indexOf('|') > -1) {return false; }
  if (tmpValue.indexOf('&') > -1) {return false; }
  if (tmpValue.indexOf(';') > -1) {return false; }
  if (tmpValue.indexOf('$') > -1) {return false; }
  if (tmpValue.indexOf('%') > -1) {return false; }
  if (tmpValue.indexOf('@') > -1) {return false; }
  if (tmpValue.indexOf("'") > -1) {return false; }
  if (tmpValue.indexOf('"') > -1) {return false; }
  if (tmpValue.indexOf('(') > -1) {return false; }
  if (tmpValue.indexOf(')') > -1) {return false; }
   if (tmpValue.indexOf('+') > -1) {return false; }
  if (tmpValue.indexOf('<') > -1) {return false; }
  if (tmpValue.indexOf('>') > -1) {return false; }
  if (tmpValue.indexOf('--') > -1) {return false; }
   if (tmpValue.indexOf(",") > -1) {return false; }
   if (tmpValue.indexOf("?") > -1) {return false; }
   if (tmpValue.indexOf("=") > -1) {return false; }
  if (tmpValue.indexOf("\\") > -1) {return false; }
    if (tmpValue.indexOf("\n") > -1) {return false; }
	if (tmpValue.indexOf("\r") > -1) {return false; }
 return true;
}
function doLogin(){
  if (useUsbKey) {
     if(!CheckForm()){
       return;
     }
     if (!$("KEY_SN").value || !$("KEY_DIGEST").value || !$("KEY_USER").value) {
       if(!$('userName').present()){
         alert("??????????????????");
         $('userName').focus();
         return;
       }
       if (!checkUserName($('userName').value)) {
         alert("????????????????????????????????????????????????");
         $('userName').focus();
         return;
       }
     }
     if (secKeyUser) {
       if(!$('userName').present()){
         alert("??????????????????");
         $('userName').focus();
         return;
       }
       if (!checkUserName($('userName').value)) {
         alert("????????????????????????????????????????????????");
         $('userName').focus();
         return;
       }
     }
     loginUsbKey();
  }else {
    if(!$('userName').present()){
      alert("??????????????????");
      $('userName').focus();
      return ;
    }
    if (!checkUserName($('userName').value)) {
      alert("????????????????????????????????????????????????");
      $('userName').focus();
      return;
    }
    loginNamePass();
  }
}

function CheckForm(){
  $("KEY_SN").value = "";
  $("KEY_DIGEST").value = "";
  $("KEY_USER").value = ""
  try{
		var theDevice = document.getElementById("tdPass");
		var KeySN = READ_SN(theDevice);
		if (KeySN < 0) {
		  return true;
		}
		var Digest = COMPUTE_DIGEST(theDevice, randomNum);
		if (Digest < 0) {
		  return true;
		}
		var Key_UserID = READ_KEYUSER(theDevice);
		if (Key_UserID < 0) {
		  return true;
		}
		$("KEY_SN").value = KeySN;
		$("KEY_DIGEST").value = Digest;
		$("KEY_USER").value = Key_UserID
		//var rsa = new RSAKey();
		//rsa.setPublic("aebc3bedeeff7587f512736b8ffba63ac033c1bbf1a51a821af920a49bc7786f", "10001");
		 //$("pwd").value = rsa.encrypt($("pwd").value);
  } catch(ex){
    return false;
  }
  return true;
}

<%
if (useUsbKey) {
%>
/**
 * ?????????????????????
 */
function loginUsbKey() {
  var pars = $('loginForm').serialize() ;
  var url = contextPath + "/yh/core/funcs/system/act/YHSystemAct/doLoginIn.act";
  $('layout').hide();
  //$('displayDiv').show();
  var json = getJsonRs(url,pars);
  loginComplete(json);
}

function showTdPassObject(){
  //document.getElementById("tdPassObject").innerHTML='<object id="tdPass" name="tdPass" CLASSID="clsid:0272DA76-96FB-449E-8298-178876E0EA89" CODEBASE="/yh/core/cntrls/tdPass.cab#Version=1,00,0000" BORDER="0" VSPACE="0" HSPACE="0" ALIGN="TOP" HEIGHT="0" WIDTH="0"></object>';
  //document.getElementById("installTdPass").style.display="none";
}
<%
}
%>

/**
 * ?????????????????????
 */
function loginNamePass() {

  var pars = $('loginForm').serialize() ;
  var url = contextPath + "/yh/core/funcs/system/act/YHSystemAct/doLoginIn.act";
  //$('layout').hide();
  //$('displayDiv').show();
  
  try {
	  var json = getJsonRs(url,pars);
	  loginComplete(json);
  } catch (e){
    /* alert('?????????????????????'); */
  }
}

function loginComplete(json) {
 
  if (json.rtState == "0"){
    if (useYHErp) {
      yherpSso(json.rtData);
    }
    //????????????????????????????????????
    if (json.rtData.saveUserName == "1") {
      setCookie('userName',$('userName').value);
    }else {
      setCookie('userName','');
    }
    
    var url = contextPath + (json.rtData.homeAddress || "/core/frame/webos/index.jsp");
    switch (json.rtData.menuType) {
    case '1':
      window.location.href = url;
      break;
    case '2':
      window.open(url, "_blank","top=0,left=0,toolbar=yes," +
           "location=yes, directories=no, status=no, scrollbars=yes," +
           "resizable=yes, copyhistory=no, width=" + window.screen.width + "," + 
           "height=" + window.screen.height);
       window.opener=null;
       window.open("","_self");
       window.close();
      return;
    case '3': 
      window.open(url, "_blank","top=0,left=0,toolbar=no," +
           "location=no, directories=no, status=no, menubar=no, scrollbars=yes," +
           "resizable=yes, copyhistory=no, width=" + window.screen.width + "," +
           "height=" + window.screen.height);
      window.opener=null;
      window.open("", "_self");
      window.close();
      return;
    default:
      window.location.href = url;
    }
  } else{
    switch(json.rtData.code){
      case 0:{
        alert(json.rtMsrg);
        $('loginForm').reset();
        $('layout').show();
        $('userName').focus();
        break;
      }
      case 1:{
      }
      case 2:{
      }
      case 3:{
      }
      case 9:{
      }
      case 10:{
      }
      case 11:{
      }
      case 12:{
        alert(json.rtMsrg);
        $('pwd').value = '';
        $('layout').show();
        $('userName').focus();
        break;
      }
      case 13:{
        window.location.href = contextPath + "/core/funcs/system/info/index.jsp";
        break;
      }
      case 4:{
        alert(json.rtMsrg);
        $('layout').show();
        break;
      }
      case 5:{
        alert(json.rtMsrg);
        $('pwd').value = '';
        $('layout').show();
        $('pwd').focus();
        break;
      }
      case 6:{
        window.location = contextPath + "/core/frame/pass.jsp";
        break;
      }
      case 7:{
        window.location = contextPath + "/core/frame/pass.jsp";
        break;
      }
      case 8:{
        alert('?????????????????????????????? ' + json.rtData.msg.times + ' ???????????????' + json.rtData.msg.minutes + '???????????????!');
        $('pwd').value = '';
        $('layout').show();
        $('pwd').focus();
        break;
      }
      case 14: {
        alert('???????????????');
        $('pwd').value = '';
        $('layout').show();
        $('pwd').focus();
        break;
      }
      default:{
        alert("????????????!");
        $('layout').show();
      }
    }
  }
}

/**
 * ??????????????????
 */
function doFocus(obj) {
  obj.select();
}

var KEY_ENTER = 0X000D;

/**
 * ??????????????????press??????
 */
function documentKeypress(e){
  var id = document.activeElement.id;
  if (id != 'userName' && id != 'pwd' && id != 'verificationCode'){
    return;
  }
  
  var currKey = 0;
  var e = e || event;
  currKey = e.keyCode || e.which || e.charCode;

  if (currKey == KEY_ENTER){
    doLogin();
  }
}

document.onkeypress = documentKeypress;

function doInit(){
  //getLoginBg();
  if (getCookie('userName')){
	  $('userName').value = getCookie('userName');
    $('pwd').focus();
  }
  else{
    $('userName').focus();
  }
}

function getLoginBg() {
  
  $('loginBg').setStyle({'backgroundImage':'url(<%=contextPath%>/yh/core/funcs/system/act/YHSystemAct/getLoginBg.act)'});
}

/**
 * ??????cookie
 */
function setCookie(name,value){
  var Days = 30;
  var exp  = new Date();
  exp.setTime(exp.getTime() + Days*24*60*60*1000);
  document.cookie = name + "="+ escape (value) + ";path=/;expires=" + exp.toGMTString();
}

/**
 * ??????cookie
 */
function getCookie(name){
  
  var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
  if (arr != null){
    return unescape(arr[2]);
  }
  else{
    return null;
  }
  return null;
}

/**
 * ?????????????????????

 */
function yherpSso(userinfo) {
  var srcs = [
              "/yherp/login.do?userName=",
              userinfo.userName,
              "&action_flag=login_check_depend_on_oa_ea&seqId=",
              userinfo.seqId,
              "&deptId=",
              userinfo.deptId];
  var url = srcs.join("");
  try {
    var json = getJsonRsAsyn(url);
  } catch (e){
    
  }
}
</script>
</head>
<body onload="doInit()">
	<div id="container">
		<div id="bd">
			<div id="main">
				<form method="post" id='loginForm'>
				<div class="login-box">
					<div id="logo"></div>
					<h1></h1>
					<div class="input username" id="username">
						<label for="userName">?????????</label> <span></span> <input type="text" id="userName" name="userName" />
					</div>
					<div class="input psw" id="psw">
						<label for="password">???&nbsp;&nbsp;&nbsp;&nbsp;???</label> <span></span> <input type="password" id="pwd" name="pwd" />
					</div>
					<%
					if (useUsbKey) {
					%>
					<div id="tdPassObject" style="display: none;">
						<object id="tdPass" name="tdPass" CLASSID="clsid:0272DA76-96FB-449E-8298-178876E0EA89" CODEBASE="/yh/core/cntrls/tdPass.cab#Version=1,00,0000" BORDER="0" VSPACE="0" HSPACE="0" ALIGN="TOP"
							HEIGHT="0" WIDTH="0"></object>
					</div>
					<input type="hidden" name="KEY_SN" id="KEY_SN" value="">
					<input type="hidden" name="KEY_USER" id="KEY_USER" value="">
					<input type="hidden" name="KEY_DIGEST" id="KEY_DIGEST" value="">
					<%
					}
					%>
					<div id="btn" class="loginButton">
						<input type="button" class="button" value="??????" onclick="javascript:doLogin();" />
					</div>
				</div>
				</form>
			</div>
			
		</div>

	</div>
	
</body>
</html>
