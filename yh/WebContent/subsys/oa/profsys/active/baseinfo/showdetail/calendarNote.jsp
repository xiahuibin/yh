<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%
  String seqId = request.getParameter("seqId")==null ? "" :request.getParameter("seqId") ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title id="title"></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath%>/cmp/Calendar.css">
<style type="text/css">
<!--
span{word-warp:break-word;word-break:break-all;}

</style>
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryUtil.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryLogic.js"></script>
<script type="text/javascript">
var  selfdefMenu = {
  	office:["downFile","dump","read"], 
    img:["downFile","dump","play"],  
    music:["downFile","dump","play"],  
    video:["downFile","dump","play"], 
    others:["downFile","dump"]
	}
function doOnload(){
  var seqId = '<%=seqId%>';
  var URL = "<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectCalendarAct/selectCalendarById.act?seqId="+seqId;
  var rtJson = getJsonRs(URL);
  if(rtJson.rtState == "1"){
    alert(rtJson.rtMsrg); 
    return ;
  }
  var prc = rtJson.rtData;
  if(prc.seqId){
    var seqId = prc.seqId;
    var userId = prc.userId;
    var content = prc.activeContent;

    var startTime = prc.startTime;
    var endTime = prc.endTime;
    var overStatus = prc.overStatus;  
    var status = prc.status;
    var statusName = '?????????';
    if(status=='1'){
      statusName='?????????';
    }
    if(status=='0'){
      statusName='?????????';
    }
    if(status=='2'){
      statusName='?????????';
    }
    if(overStatus=='1'){
      status = 3;
      statusName = '?????????';
    }
    var codeDesc = "???";
    if(prc.codeDesc&&prc.codeDesc !=''){
      codeDesc = prc.codeDesc;
    }
    var colorTypes = ["#0000FF","#0000FF","#FF0000","#00AA00"];
    document.getElementById("dateSpan").innerHTML=startTime.substr(0,16) + " - " + endTime.substr(0,16);
    document.getElementById("typeSpan").innerHTML=codeDesc;
    document.getElementById("status").innerHTML = "<font color='"+colorTypes[status]+"'><b>"+statusName+"</b></font>";
    document.getElementById("content").innerHTML=content;
    document.getElementById("activeLeader").innerHTML = prc.activeLeaderName;
    document.getElementById("activePartner").innerHTML = prc.activePartner;
    doOnloadFile(seqId,prc.attachmentId,prc.attachmentName);//??????
  }  
}

function doOnloadFile(seqId,attachmentId,attachmentName){
  var attr = $("attr");
  attachMenuSelfUtil(attr,"profsys",attachmentName ,attachmentId, '','',seqId,selfdefMenu);
}
</script>
<body class="bodyClass" topmargin="5"  onload="doOnload();">
<div class="small">
???????????????<span id="dateSpan"></span><br>
<br>
???????????????<span id="typeSpan"></span> <br>
<br>
???????????????<span id="status"></span><hr>
??????????????????<span id="activeLeader"></span> <br>
<br>
??????????????????<span id="activePartner"></span> <br>
<br>
???????????????<span id="content"></span><br>
<br>
?????????<span id="attr"></span><br>
<br>
<table align="center">
	<input type="button" value="??????" class="BigButton" onclick="javascript:parent.window.close()">&nbsp;
</table>
</div>

</body>
</html>