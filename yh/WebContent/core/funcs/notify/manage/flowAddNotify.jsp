<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.core.funcs.person.data.YHPerson,yh.core.global.YHSysProps" %>
<%@ page import="yh.core.funcs.workflow.act.YHFlowSaveFileAct" %>
<%
  String seqId = request.getParameter("seqId");
  if (seqId == null) {
	  seqId = "";
  }
  String isFw = request.getParameter("isFw");
  if (isFw == null || isFw=="") {
    isFw = "";
  }
  
  String flowId= request.getParameter("flowId");
  String runId= request.getParameter("runId");
  String prcsId= request.getParameter("prcsId");
  String flowPrcs= request.getParameter("flowPrcs");
  
  String title=request.getParameter("title");
  if(title==null || title.equals("")){
  YHFlowSaveFileAct fs=new YHFlowSaveFileAct();
    title=fs.getRunName(request);
  }else{
  title= URLDecoder.decode(title,"UTF-8");
  }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath%>/cmp/Calendar.css">
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath %>/cmp/swfupload.css" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attach.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/fck/fckeditor/fckeditor.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/funcs/notify/js/openWin.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/select.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/Javascript" src="js/flowAddNotify.js" ></script>
<script type="text/javascript" src="js/interfaceLogic.js"></script>
<script type="text/javascript">
var upload_limit=1,limit_type="<%=YHSysProps.getLimitUploadFiles()%>"; 
var oa_upload_limit="<%=YHSysProps.getLimitUploadFiles()%>";

var seqId = "<%=seqId%>";
var isFw = "<%=isFw%>";

var runId = '<%=runId%>';
var flowId = '<%=flowId%>';
var prcsId = '<%=prcsId%>';
var flowPrcs = '<%=flowPrcs%>';

function removeAllChild(node){
	  var trs = $(node).childNodes;
	  for(i = trs.length - 1; i >= 0; i--) {
	    $(node).removeChild(trs[i]);
	  } 
	}  
function getAttachments(){
	  var param = 'runId=' + runId + '&flowId=' + flowId +'&prcsId=' + prcsId +"&flowPrcs=" + flowPrcs;
	  var url = contextPath + "/yh/core/funcs/workflow/act/YHAttachmentAct/getAttachments.act";
	  var json = getJsonRs(url , param);
	  var attachmentName="";
	  var attachmentId="";
	  if(json.rtState == '0'){
		    var attachment = json.rtData;
		    if(attachment.length > 0){
		    	var str="";
		      for(var i = 0 ;i < attachment.length ;i ++){
		        var attach = attachment[i];
		        attachmentName+=attach.attachmentName+"*";
		        attachmentId+=attach.attachmentId+",";
		        str+=addAttachment(attach);
		      }
		      $("showAtt").innerHTML=str;
		      $("attachmentId").value=attachmentId;
		      $("attachmentName").value=attachmentName;
		    }else{
		    	$("showAtt").innerHTML="?????????";
		    }
		  }
}
function getAttachImage(ext) {
	  var imgSrc = "";
	  if(ext == 'gif' || ext == 'jpg' || ext == 'bmp' || ext == 'png'){
	    imgSrc = imgPath + "/gif.gif";
	  }else if(ext == 'doc' || ext == 'docx'){
	    imgSrc = imgPath + "/doc.gif";
	  }else if(ext == 'xlsx' || ext == 'xls'){
	    imgSrc = imgPath + "/xls.gif";
	  }else if(ext == 'ppt' || ext == 'pptx'){
	    imgSrc = imgPath + "/ppt.gif";
	  }else if(ext == 'exe'){
	    imgSrc = imgPath + "/exe.gif";
	  }else if(ext == 'chm'){
	    imgSrc = imgPath + "/chm.gif";
	  }else if(ext== 'txt'){
	    imgSrc = imgPath + "/txt.gif";
	  }else if (ext == 'rar' || ext == 'zip') {
	    imgSrc = imgPath + "/rar.gif";
	  } else{
	    imgSrc = imgPath + "/defaut.gif";
	  }
	  return imgSrc;
	}
function downAction(id,name){
	 downLoadFile(name ,  id, "workflow");
	}
function addAttachment(attachment){
	  var ext = attachment.ext;
	  var imgStr = getAttachImage(ext);
	  var str = "<a href='javascript:void(0)' onclick='downAction( \""+ attachment.attachmentId +"\", \""+ attachment.attachmentName +"\")'><img src='" + imgStr + "'/>&nbsp;" + attachment.attachmentName + "</a><br/>";
	  return str; 
	}
	
function doMyInit(){
	getAttachments();
	doInit();
	
}

 function showSubject(){
   var actionSize = $('actionSize').value;
   var actionLight = $('actionLight').value;
   var actionFont = $('actionFont').value;
   var actionLights = $('actionLights').value;
   var actionColor = $('actionColor').value;
   var actionFlag = $('actionLightFlag').value;
   
   var subjectFont = "font-family:" + actionFont + ";font-size:" + actionSize + ";color:" + actionColor + ";filter:" + actionFlag + "(Direction=120, color=" + actionLights + ");";
   $('subjectMainShow').innerHTML = $('subject').value;
   $('subjectMainShow').setStyle(subjectFont);
   
   $('subject_tr').style.display = "";
 }
</script>
</head>
<body onload="doMyInit();">
<table border="0" width="90%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td><img src="<%=contextPath %>/core/styles/imgs/green_plus.gif"><span class="big1" id="notifytitle"> ???????????????????????????</span>&nbsp;&nbsp;
    <!--
      <a id="status" href="javascript:;" class="dropdown" onclick="showMenuStatus(event);" hidefocus="true"><span id="name" style="color: #00A00">????????????</span></a>&nbsp;
        -->
    </td>
  </tr>
</table>
<form  action="<%=contextPath %>/yh/core/funcs/notify/act/YHNotifyHandleAct/addFlowNotify.act"  method="post" name="notifyForm" id="notifyForm">
<table class="TableBlock" width="95%" align="center">
    <tr>
      <td nowrap class="TableData" width='15%'><select name="typeId" id="typeId" style="background: white;width: 100px" title="??????????????????????????????????????????->????????????????????????????????????">
          <option value="">??????????????????</option>
        </select></td>
      <td class="TableData" >
        <input type="text" name="subject" id="subject" size="55" maxlength="200" class="BigInput" value="<%=title %>" style="color: #8896A0"
         onMouseOver="if($F('subject')=='?????????????????????...') document.getElementById('subject').style.color='#000000';" 
         onMouseOut="if($F('subject')=='?????????????????????...') document.getElementById('subject').style.color='#8896A0';" 
         onFocus="if($F('subject')=='?????????????????????...') {document.getElementById('subject').value='';document.getElementById('subject').style.color='#000000';}">
      </td>
    </tr>
	<tr id="subject_tr" style="display: none;height:50px;">
   <td nowrap class="TableData" >??????</td>
   <td class="TableData">
     <span id="subjectMainShow"></span>
   </td>
	</tr>
	<tr>
	  <td nowrap class="TableData">???????????????</td>
	  <td nowrap class="TableData">
	      <input type="hidden" name="FONT_FAMILY" value="">
	      <input type="hidden" name="FONT_SIZE" value="">
	      <input type="hidden" name="FONT_COLOR" value="">
	      <!-- <input type="hidden" name="print" value="">
	      <input type="hidden" name="download" value=""> -->
	      <input type="hidden" name="FONT_FILTER" value="">
	  <span style="padding-top:5px;padding-left:10px;">
	   <a id="showMeunA" href="#" onclick="showFont(event);"><span id="actionNameFont">??????</span></a><img src="<%=imgPath%>/cal_list.gif" align="absmiddle">&nbsp;
	  </span>
	  <span style="padding-top:5px;padding-left:10px;">
	   <a id="showMeunB" href="#" onclick="showSize(event);"><span id="actionNameSize">??????</span></a><img src="<%=imgPath%>/cal_list.gif" align="absmiddle">&nbsp;
	  </span>
	  <span style="padding-top:5px;padding-left:10px;">
	   <a id="showMeunC" href="#" onclick="showColor(event);"><span id="actionNameColor">??????</span></a><img src="<%=imgPath%>/cal_list.gif" align="absmiddle">&nbsp;
	  </span>
	  <span style="padding-top:5px;padding-left:10px;display:none;">
	   <a id="showMeunD" href="#" onclick="showLight(event);"><span id="actionNameLight">??????</span></a><img src="<%=imgPath%>/cal_list.gif" align="absmiddle">&nbsp;
	  </span>
	  <span style="padding-top:5px;padding-left:10px;"><a href="#" onclick="showSubject();">??????</a></span>
	  <input type="hidden" name="actionFont" id="actionFont" value="">
	  <input type="hidden" name="actionSize" id="actionSize" value="">
	  <input type="hidden" name="actionLight" id="actionLight" value="">
	  <input type="hidden" name="actionLights" id="actionLights" value="">
	  <input type="hidden" name="actionColor" id="actionColor" value="">
	  <input type="hidden" name="actionLightFlag" id="actionLightFlag" value="">
	  <input type="hidden" name="subjectFont" id="subjectFont" value="">
	  </td>
	</tr>
    <tr>
      <td nowrap class="TableData">??????????????????<br><a href="javascript:;" id="href_txt" onClick="javascript:changeRange();">????????????????????????</a></td>
      <td class="TableData">
        <input type="hidden" id="dept" name="toId" value="">
        <textarea cols=40 id="deptDesc" name="toName" rows=2 class="BigStatic" wrap="yes" readonly></textarea>
        <a href="javascript:;" class="orgAdd" onClick="javascript:selectDept(['dept','deptDesc'] , 5);">??????</a>
       <a href="javascript:;" class="orgClear" onClick="ClearUser('toId','toName')">??????</a>
       &nbsp;&nbsp;&nbsp;&nbsp;
      </td>
    </tr>
   <tr id="rang_user" style="display:none">
      <td nowrap class="TableData">??????????????????</td>
      <td class="TableData">
        <input type="hidden" id="user" name="userId" value="">
        <textarea cols=40 id="userDesc" name="userName" rows=2 class="BigStatic" wrap="yes" readonly></textarea>
        <a href="javascript:;" class="orgAdd" onClick="javascript:selectUser(['user', 'userDesc'] , 5);">??????</a>
        <a href="javascript:;" class="orgClear" onClick="ClearUser('userId','userName')">??????</a>
      </td>
   </tr>
   <tr id="rang_role" style="display:none;">
      <td nowrap class="TableData">??????????????????</td>
      <td class="TableData">
        <input type="hidden" id="role" name="privId" value="">
        <textarea cols=40 id="roleDesc" name="privName" rows=2 class="BigStatic" wrap="yes" readonly></textarea>
        <a href="javascript:;" class="orgAdd" onClick="javascript:selectRole(['role', 'roleDesc'] , 5);">??????</a>
        <a href="javascript:;" class="orgClear" onClick="ClearUser('privId','privName')">??????</a><br>
        ????????????????????????????????????????????????

      </td>
   </tr>
    <tr id="url_address" style="display:none">
      <td nowrap class="TableData">?????????????????????</td>
      <td class="TableData">
        <input type="text" id="urlAdd" name="urlAdd" size="55" maxlength="200" class="BigInput" value="">
      </td>
    </tr>
     <tr id="sendTimeTr" style="display:none">
      <td nowrap class="TableData">???????????????</td>
      <td class="TableData">
        <input type="text" id="sendTime" name="sendTime" class="BigInput" size="15" maxlength="19" value="" >
         <img id="sendTimeImg" src="<%=imgPath%>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
          &nbsp;&nbsp;<a href="javascript:resetTime();">?????????????????????</a>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">????????????</td>
      <td class="TableData">
    <input type="text" id = "beginDate" name="beginDate" class="BigInput" size="10" maxlength="10" value="">
        <img id="beginDateImg" src="<%=imgPath%>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
        ??? <input type="text" id = "endDate" name="endDate" class="BigInput" size="10" maxlength="10" value="">
        <img id="endDateImg" src="<%=imgPath%>/calendar.gif" align="absMiddle" border="0"  style="cursor:pointer">

        ?????????????????????
      </td>
     </tr>
   <tr id="attr_tr">
      <td nowrap class="TableData">??????: </td>
      <td class="TableData" id="showAttachment">
        <span id="showAtt">
        </span>
      </td>
    </tr>
  	<tr>
      <td nowrap class="TableData"> ??????????????????</td>
      <td class="TableData">
              <input type="checkbox" name="download" id="download" checked><label for="DOWNLOAD">????????????Office??????</label>&nbsp;&nbsp;
              <input type="checkbox" name="print" id="print" checked><label for="PRINT">????????????Office??????</label>&nbsp;&nbsp;&nbsp;<font color="gray">???????????????????????????????????????</font>   
      </td>
    </tr>
    
    <tr id="notifyAuditingSingle">
      <td nowrap class="TableData"> &nbsp;???????????????</td>
      <td class="TableData">
          <span id="smsRemindDiv" >
           <input type="checkbox" name="mailRemind" id="mailRemind" ><label for="mailRemind">????????????????????????   </label>&nbsp;&nbsp;
           </span>
           <span id="remidDiv" >
           <input type="checkbox" name="remind" id="remind" ><label for="remind">????????????????????????   </label>&nbsp;&nbsp;
           </span>
      </td>
    </tr>
    <tr id="notifyAuditingSingleTop">
      <td nowrap class="TableData"> &nbsp;?????????</td>
      <td class="TableData"><input type="checkbox" name="top" id="top"><label for="top">???????????????????????????????????????</label>
      &nbsp;&nbsp;<input type="text" name="topDays" id="topDays2" size="3" maxlength="4" class="BigInput" value="0">&nbsp;?????????????????????0??????????????????

      </td>
    </tr>

    
   <tr id="editor">
   		<td class="TableData" colspan='2' id="contentTd">
   
        </td>
    </tr>
   
    <tr align="center" class="TableControl">
      <td colspan="2" nowrap>
        <span id="notifyAuditingSinglepublish">
         <input type="button" value="??????" class="BigButton" onClick="sendForm('1');">&nbsp;&nbsp;
        </span>
        <span id="notifyAuditingSingleFlow" style="display:none">
        <input type="button" value="????????????" class="BigButton" onClick="sendForm('2');">&nbsp;&nbsp;
        </span>
        <span style="display:none">
        <input type="button" value="??????" class="BigButton" onClick="sendForm('0');">&nbsp;&nbsp;
        </span>
         <span id="editBack" style="display:none">
           <input type="button" value="??????" class="BigButton" onClick="goBack();">
          </span>
     </td>
  </tr>
 </table>
 <input type="hidden" id="format" name="format" value="0">
  <input type="hidden" id="content" name="content" value="">
  <input type="hidden" id="isFw" name="isFw" value="">
  <input type="hidden" id="publish" name="publish" value="">
  <input type="hidden" id="runId" name="runId" value="<%=runId%>">
  <input type="hidden" id="flowId" name="flowId" value="<%=flowId%>">
  <input type="hidden" id="attachmentId" name="attachmentId" value="">
  <input type="hidden" id="attachmentName" name="attachmentName" value="">
  <input type="hidden" id="seqId" name="seqId" value="">
  <input type="hidden" name="op" value="">
</form>
<input type="hidden"  id="prnt"  value=""/>
<input type="hidden"  id="down"  value=""/>
</body>
<script type="text/javascript"><!--
/**
 * ??????????????????????????????
 */
function  jugeFile(){
  var formDom  = document.getElementById("formFile");
  var inputDoms  = formDom.getElementsByTagName("input"); 
  for(var i=0; i<inputDoms.length; i++){
    var idval = inputDoms[i].id;
		if(idval.indexOf("ATTACHMENT")!=-1){
			return true;
		}
  } 
  return false; 
}
function bindValidDtFunc() {
	bindAssertDateTimePrcBatch([{id:"beginDate", type:"d"}, {id:"endDate", type:"d"}]);
}

function bindValidDtFuncDt() {
	bindAssertDateTimePrcBatch([{id:"sendTime", type:"dt"}]);
}
bindValidDtFunc();
bindValidDtFuncDt();
--></script>
</html>