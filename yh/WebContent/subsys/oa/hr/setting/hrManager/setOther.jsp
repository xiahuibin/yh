<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/hr/examManage/js/paperManageLogic.js"></script>
<script type="text/javascript">

function doInit(){
  getHrSetUserLogin();
  getHrRetireAge();
}

function getHrSetUserLogin(){
  var url = "<%=contextPath%>/yh/subsys/oa/hr/setting/act/YHHrSetOtherAct/getHrSetUserLogin.act";
  var rtJson = getJsonRs(url);
  if(rtJson.rtState == "0"){
    if(rtJson.rtData == 1){
      document.getElementById("yesOther1").checked = true;
    }else if(rtJson.rtData == 0){
      document.getElementById("yesOther2").checked = true;
    }
  }else{
    alert(rtJson.rtMsrg); 
  }
}

function getHrRetireAge(){
	var url = "<%=contextPath%>/yh/subsys/oa/hr/setting/act/YHHrSetOtherAct/getHrRetireAge.act";
	var rtJson = getJsonRs(url);
	if(rtJson.rtState == "0"){
		var data = rtJson.rtData;
		$("manAge").value = data.manAge;
		$("womenAge").value = data.womenAge;
	}else{
		alert(rtJson.rtMsrg); 
	}
}
function doSubmit(){
	if(checkForm()){
		var pars = Form.serialize($('form1'));
	  var url = "<%=contextPath%>/yh/subsys/oa/hr/setting/act/YHHrSetOtherAct/setOtherValue.act";
	  var rtJson = getJsonRs(url,pars);
	  if(rtJson.rtState == "0"){
		  $("showFormDiv").hide();
		  $("remindDiv").show();
	  }else{
	    alert(rtJson.rtMsrg); 
	  }
	}
}

function checkForm(){//checkForm
	var manAge = $("manAge").value.trim();
	var womenAge = $("womenAge").value.trim();
	if(manAge){
		if(!isNumber(manAge)){
			alert("????????????????????????????????????");
			return false;
		}
	}
	if(womenAge){
		if(!isNumber(womenAge)){
			alert("????????????????????????????????????");
			return false;
		}
	}
	return true;
}
function showForm(){
	window.location.reload();
}
</script>
</head>
<body onload="doInit()" topmargin="5">
<div id = "showFormDiv" >
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath%>/training.gif" align="absmiddle"><span class="big3"> OA??????????????????</span>
    </td>
  </tr>
</table>

<form action=""  method="post" name="form1" id="form1">  
 <table class="TableList" width="90%">
  <tr class="TableHeader" align="center">
    <td width="120">??????</td>
    <td>??????</td>
    <td width="250"  colspan="2">??????</td>
  </tr>
  <tr class="TableData" align="center" height="30">
    <td width="250"><b>?????????????????????????????????OA???????????? ???</b></td>
    <td align="left">
       <input type="radio" name="yesOther" id="yesOther1" value="1" ><label for="yesOther1">???</label>
       <input type="radio" name="yesOther" id="yesOther2" value="0" ><label for="yesOther2">???</label>
    </td>
    <td width="300" align="left" colspan="2">
       ????????????????????????????????????????????????????????????????????????????????????????????????OA???????????????????????????????????????
    </td>
  </tr>
  <tr class="TableData" align="center" height="30">
    <td width="250"><b>?????????????????? ???</b></td>
    <td align="left" colspan="3">
      ??????<input type="text" name="manAge" id="manAge" class="BigInput" size="4" maxlength="3" value="">??? &nbsp;
      ??????<input type="text" name="womenAge" id="womenAge" class="BigInput" size="4" maxlength="3" value="">??? &nbsp;
    </td>
  </tr>  
   <tr>
    <td nowrap  class="TableControl" colspan="4" align="center">
      <input type="button" value="??????" class="BigButton" onclick="doSubmit();">&nbsp;&nbsp;
    </td>
   </tr> 
 </table>
</form>
</div>
<div id="remindDiv" style="display: none">
<table class="MessageBox" align="center" width="320">
  <tr>
    <td class="msg info">
      <h4 class="title">??????</h4>
      <div class="content" style="font-size:12pt">???????????????</div>
    </td>
  </tr>
</table>
<br><center>
	 <input type="button" class="BigButton" value="??????" onclick="showForm();">
</center>
</div>

</body>
</html>