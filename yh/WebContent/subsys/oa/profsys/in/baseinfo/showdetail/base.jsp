<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.text.SimpleDateFormat"%>
<%
  SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
String curDateStr = sf.format(new Date());
  String seqId = request.getParameter("seqId");
  if(seqId == null){
    seqId = "";
  }
%>
<html>
<head>
<title>项目基本信息</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%=cssPath%>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath%>/cmp/Calendar.css">
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/fck/fckeditor/fckeditor.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attach.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryUtil.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryLogic.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Calendarfy.js"></script>

<script type="text/javascript">
var upload_limit=1,limit_type="php,php3,php4,php5,";
var oFCKeditor = new FCKeditor('PROFSYS_LEADER_CONTENT');//初始化

var oFCKeditorUnit = new FCKeditor('PROFSYS_UNIT_CONTENT');
var oFCKeditorNote = new FCKeditor('PROFSYS_NOTE_CONTENT');
function getContent(id,fckId){
  var oEditor = FCKeditorAPI.GetInstance(fckId) ;
  $(id).value=oEditor.GetXHTML();
}

var  selfdefMenu = {
  	office:["downFile","dump","read"], 
    img:["downFile","dump","play"],  
    music:["downFile","dump","play"],  
    video:["downFile","dump","play"], 
    others:["downFile","dump"]
	}

function doOnloadFile(){
  var attr = $("attr");
  var seqId  = $("seqId").value;
  attachMenuSelfUtil(attr,"profsys",$('attachmentName').value ,$('attachmentId').value, '','',seqId,selfdefMenu);
}
function upload_attach(){
  if(checkForm()){
	 $("form1").submit();
  }  
}

//浮动菜单文件的删除



function deleteAttachBackHand(attachName,attachId,attrchIndex){
	var url= "<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectAct/deleleFile.act?attachId=" + attachId +"&attachName=" + encodeURIComponent(attachName) + "&seqId=" + attrchIndex;
	 var rtJson = getJsonRs(url); 
	  if(rtJson.rtState == "1"){
	    alert(rtJson.rtMsrg); 
	    return ;
	  }else{
	   prcsJson=rtJson.rtData;
	   var updateFlag=prcsJson.updateFlag;
	   if(updateFlag=='1'){
	     return true;
	   }else{
		  return false;
	   }
	}
}


function doInit() {
  var seqId = '<%=seqId%>';
  if(parent.projId && parent.projId != ''){
    seqId = parent.projId;
  }
  if(seqId != ''){
    parent.projId = seqId;
    //给其他tab页放开 
    var tabs = parent.tabs;
    showTabs(tabs);
    getProjectById(seqId);
  }
}
function showTabs(tabs){
  tabs.setDisable(false , 1);
  tabs.setDisable(false , 2);
  tabs.setDisable(false , 3);
  tabs.setDisable(false , 4);
}
function getProjectById(seqId){
  var requestURL = "<%=contextPath%>/yh/subsys/oa/profsys/act/in/YHInProjectAct/getProjectById.act?seqId=" + seqId; 
  var json=getJsonRs(requestURL); 
  if(json.rtState == '1'){ 
    alert(json.rtMsrg); 
    return ; 
  } 
  var prc = json.rtData; 
  if(prc.seqId){
    var seqId = prc.seqId;
    $("projNum").innerHTML = prc.projNum;
    doProjStatus(prc.projStatus) 
    //$("projGroupName").innerHTML = prc.projGroupName;
    $("projGroupName").innerHTML = prc.budgetItem;
    $("projArriveTime").innerHTML = prc.projArriveTime.substr(0,10);
    $("projLeaveTime").innerHTML = prc.projLeaveTime.substr(0,10);
    $("countryTotal").innerHTML = prc.countryTotal;
    $("projVisitType").innerHTML = prc.projVisitTypeName;
    $("projActiveType").innerHTML = prc.projActiveTypeName;
    $("projLeaderName").innerHTML = prc.projLeaderName;
    $("projManagerName").innerHTML = prc.projManagerName;
    $("projViwerName").innerHTML = prc.projViwerName;
    $("projDeptName").innerHTML = prc.projDeptName;
    $("pTotal").innerHTML = prc.pTotal;
    $("pYx").innerHTML = prc.pYx;
    $("pCouncil").innerHTML = prc.pCouncil;
    $("pGuest").innerHTML = prc.pGuest;
    $("purposeCountry").innerHTML = prc.purposeCountry;
    $("projLeaderDescription").innerHTML = prc.projLeaderDescription;
    $("projUnitDescription").innerHTML = prc.projUnitDescription;
    $("projNote").innerHTML = prc.projNote;
    $("attachmentName").value = prc.attachmentName;
    $("attachmentId").value = prc.attachmentId;
    if(prc.attachmentId != ''){
      doOnloadFile();
    }
  }
}
function doProjStatus(projStatus) {
  //自动 判断状态


  var curDateStr = '<%=curDateStr%>';
  var projArriveTime = $("projArriveTime").value;
  var projLeaveTime = $("projLeaveTime").value;
  var projStatusStr = "";
  if(projArriveTime != '' && projLeaveTime != '' ){
    if(curDateStr>projArriveTime){
      projStatusStr = "<font color='green'><b>已接待</b></font>";
    }else if(curDateStr<projArriveTime){
      projStatusStr = "<font color='red'><b>准备中</b></font>";
    }else{
      projStatusStr = "<font color='blue'><b>接待中</b></font>";
    }
  }
  if(projStatus=='1'){
    projStatusStr = "<font color='black'><b>已结束</b></font>";
  }
  $("projStatus").innerHTML = projStatusStr;
}
</script>
</head>
<body onLoad="doInit()">
 <table class="TableBlock" border="0" width="80%" align="center">
    <tr>
      <td nowrap class="TableContent" width="90">项目编号：</td>
      <td nowrap class="TableData"  id="projNum">
       </td>
      <td nowrap class="TableContent">接待状态：</td>
      <td nowrap class="TableData" id="projStatus">

      </td>               
    </tr>    <tr>
      <td nowrap class="TableContent" width="90">团组名称：</td>
      <td nowrap class="TableData" colspan="3" id="projGroupName"> 
    </td>
    </tr> 
    <tr>
    <td nowrap class="TableContent" width="90">来访类别：</td>
      <td nowrap class="TableData" id="projVisitType" >

      </td>
     <td nowrap class="TableContent" width="90">负责人：</td>
      <td nowrap class="TableData" id="projLeaderName">  </td> 
    </tr> 
    <tr>
      <td nowrap class="TableContent" width="90">项目类别：</td>
      <td nowrap class="TableData" id="projActiveType" >
      </td> 
       <td nowrap class="TableContent" width="90">执行负责人：</td>
      <td nowrap class="TableData" id="projManagerName" > </td> 
      </tr>
      <tr>
      <td nowrap class="TableContent">到京时间：</td>
      <td nowrap class="TableData" id="projArriveTime">  </td>
      <td nowrap class="TableContent">离京时间：</td>
      <td nowrap class="TableData" id="projLeaveTime">  
   </td>
    </tr>
     <tr>
      <td nowrap class="TableContent">来访国家：</td>
      <td nowrap class="TableData"  colspan="3" id="purposeCountry">
      </td>    
    </tr>
    <tr>
      <td nowrap class="TableContent">出访国家总数：</td>
      <td nowrap class="TableData"  colspan="3" id="countryTotal">
      </td>    
    </tr>
    <tr>
      <td nowrap class="TableContent">参与总人数：</td>
      <td nowrap class="TableData"  id="pTotal">
      </td>    
      <td nowrap class="TableContent">参与外办人员：</td>
      <td nowrap class="TableData" id="pYx">
     </td>    
     </tr>
    <tr>
      <td nowrap class="TableContent">参与理事人数：</td>
      <td nowrap class="TableData"  id="pCouncil">
      </td>    
      <td nowrap class="TableContent">参与外宾人数：</td>
      <td nowrap class="TableData" id="pGuest">
      </td>    
    </tr>
    <tr>
      <td nowrap class="TableContent">参与部门：</td>
      <td class="TableData" colspan="3" id="projDeptName">   </td>
    </tr>
    <tr>
     <td nowrap class="TableContent">项目审批人：</td>
     <td nowrap class="TableData" colspan="3"  id="projViwerName"> </td>
   </tr>
    <tr>
      <td nowrap class="TableContent">主要领导情况：</td>
      <td nowrap class="TableData" colspan="3"  id="projLeaderDescription">

     </td>
    </tr>
        <tr>
      <td nowrap class="TableContent">组团单位情况：</td>
      <td nowrap class="TableData" colspan="3"  id="projUnitDescription">
    </td>
    </tr>
    
    <tr>
      <td nowrap class="TableContent">备注：</td>
      <td class="TableData" colspan="3" id="projNote" >
</td>
    </tr>
      <tr id="attr_tr">
      <td nowrap class="TableData">附件文档：</td>
      <td class="TableData" colspan="3">

      <input type = "hidden" id="attachmentName" name="attachmentName"></input>
       <input type = "hidden" id="attachmentId" name="attachmentId"></input>
        <span id="attr">无附件</span>
      </td>
    </tr>
    <tr align="center" class="TableControl">
      <td colspan="4" nowrap>
      <input type="hidden" name="OP" value="">
      <input type="hidden" name="projType" id="projType" value="0">
      <input type="hidden" name="seqId" id="seqId" value="<%=seqId %>">
      <input type="button" value="关闭" class="BigButton" onclick="javascript:parent.opener.location.reload();   parent.window.close()">&nbsp;
      </td>
  </tr>
 </table>
</body>
</html>
