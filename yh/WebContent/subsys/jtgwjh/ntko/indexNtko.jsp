<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="yh.subsys.jtgwjh.docSend.logic.YHDocSendLogic"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
  YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
  String seqId = request.getParameter("seqId") == null ? "" : request.getParameter("seqId");
  String op = request.getParameter("op") == null ? "" : request.getParameter("op");
  String attachmentName = request.getParameter("attachmentName") == null ? "" : request.getParameter("attachmentName");
  String attachmentId = request.getParameter("attachmentId") == null ? "" : request.getParameter("attachmentId");
  String moudle = request.getParameter("moudle")== null ? "" : request.getParameter("moudle");
  String signKey = request.getParameter("signKey") == null ? "" : request.getParameter("signKey");
  String print = request.getParameter("print") == null ? "" : request.getParameter("print");

  boolean isStamp = YHDocSendLogic.isStamp(request);
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%=cssPath %>/page.css">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/page.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attach.js"></script>
<script type="text/javascript" src="tanger.js"></script>
<script type="text/javascript" src="tangerUtil.js"></script>
<title>????????????---<%=attachmentName %> </title>
<style media="all" type="text/css">		
	h2{
		color:#FFFFFF;
		font-size:90%;
		font-family:arial;
		margin:10px 10px 10px 10px;
		font-weight:bold;
	}
	
	h2 span{
		font-size:105%;
		font-weight:normal;
	}
	
	ul{
		margin:0px 0px 0px 0px;
		padding:0px 0px 0px 0px;
	}
	
	li{
		margin:0px 10px 3px 10px;
		padding:2px;
		list-style-type:none;
		display:block;
		background-color:#DA1074;
		width:177px;
	}
	
	li a{
		width:100%;
	}
	
	li a:link,
	li a:visited{
		color:#FFFFFF;
		font-family:verdana;
		font-size:70%;
		text-decoration:none;
		display:block;
		margin:0px 0px 0px 0px;
		padding:0px;
		width:100%;
	}
	
	li a:hover{
		color:#FFFFFF;
		text-decoration:underline;
	}
	
	#sideBar{
		position: absolute;
		width: auto;
		height: auto;
		top: 0px;
		right:-7px;
		background-image:url(images/background.gif);
		background-position:top left;
		background-repeat:repeat-y;
		z-index: 20;
	}
	
	#sideBarTab{
		float:left;
		height:137px;
		width:28px;
	}
	#ifraClass{
	  position: absolute;
		width: 200px;
		height: 615px;
		top: 0px;
		right:-7px;		
		background-position:top left;
		background-repeat:repeat-y;
		z-index: 10;
	}
</style>

<script type="text/javascript">
  var isStamp = '<%=isStamp %>'; 
  var seqId = '<%=seqId %>';
  var op = "<%=op %>"; 
  var print = "<%=print %>"; 
  var attachmentName = "<%=attachmentName %>";
  var attachmentId = "<%=attachmentId %>";
  var moudle = "<%=moudle %>";
  var TANGER_OCX_str;//??????????????????URL
  var TANGER_OCX_obj;//????????????????????????
  var secOcRevision;//????????????/????????????
  var secOcMarkDefault;//?????????/????????????
  var secOcMark;//??????????????????
  var logPage ;//??????????????????
  var nowDocStyle = "";
  var delFlag = false;
  function doInit(){
   //???????????????????????????????????????????????????????????????????????????TANGER_OCX_OBJ
   //????????????????????????????????????????????????????????????????????????


   delFlag = false;
   
   /*var url = contextPath + "/yh/subsys/jtgwjh/ntko/act/YHDocAct/getBookmark.act";
   var json = getJsonRs(url , "seqId=<%=seqId %>");
   if (json.rtState == "0") {
      var docStyle = json.rtData.docStyle;
      var contentStyle = json.rtData.content;
      for (var i = 0 ;i < docStyle.length ;i ++) {
        var doc = docStyle[i];
        if(doc) {
          var option = new Element("option");
          option.update(doc);
          option.value = doc;
          $('docStyle').appendChild(option);
        }
      }
      for (var i = 0 ;i < contentStyle.length ;i ++) {
        var content = contentStyle[i];
        if(content) {
          var option = new Element("option");
          option.update(content);
          option.value = content;
          $('docContent').appendChild(option);
        }
      }
      var docStyleThis = json.rtData.docStyleThis;
      $('docStyle').value = docStyleThis;
   }*/
   
   if(op == 5 && print == 1){
      op = 6;
    }
   var param = encodeURI("attachmentName=" + attachmentName + "&attachmentId=" + attachmentId + "&module=" + moudle);
   if(!fileExits(param)){
     document.body.innerHTML = " ????????????"+ attachmentName + "<br>????????????????????????????????????????????????????????????????????????????????????OA????????????<br>";
     return ;
   }
   if(op == 4){
     var isCanEditObj = isCanEidt(attachmentId);
     if(isCanEditObj && false){
       if(isCanEditObj.isCanEidt == 1){
         var msrg = " ?????????<input type=hidden id=\"canEditUser\" value=\"" + isCanEditObj.userId + "\"><span id=\"canEditUserDesc\"></span> ???????????????????????????????????????";
         WarningMsrg( msrg, $(document.body),"info" );
         bindDesc([{cntrlId:"canEditUser", dsDef:"PERSON,SEQ_ID,USER_NAME"} ]);
         return ;
       }else{
         lockRef(attachmentId);
         var time = (isCanEditObj.sysTime)*1000;
       }
     }
   }
   var URL = contextPath + "/yh/core/funcs/office/ntko/act/YHNtkoAct/upload.act?" + param;
   $('TANGER_OCX_attachURL').innerHTML = URL;
    var secOcObj = getMarkSetting();
    
    if(secOcObj){
      secOcRevision = secOcObj.secOcRevision;
      secOcMarkDefault = secOcObj.secOcMarkDefault;
      secOcMark = secOcObj.secOcMark;
      if (secOcMark == "") {
        secOcMark = "0";
      }
      if(!secOcMarkDefault){
        secOcMarkDefault = "0";
      }
    }
    setOpView(op ,secOcMark,secOcMarkDefault,attachmentName);
    TANGER_OCX_SetInfo();
    if(op == 5){
      TANGER_OCX_EnableFilePrintMenu(false);//????????????
    }
    logPage = getLogPageMgr("list",attachmentId);

  }

//window.attachEvent('onbeforeunload',ColseDoc);
var showit = false;	
function downDoc() {
  downLoadFile(attachmentName ,  attachmentId, moudle);
}
function showMate(){ 
  document.getElementById("sideBarContents").style.display="none";
	document.getElementById("imgshow").src = "images/slide-button.gif";
	document.getElementById("sideBarContents").style.display="none";
   if(showit == false){//????????????
     document.getElementById("ifraClass").style.display="";
     document.getElementById("sideBarContents").style.display="";
     document.getElementById("imgshow").src = "images/slide-button-active.gif";
     showit = true;
   }else{
     document.getElementById("sideBarContents").style.display="none";
     document.getElementById("ifraClass").style.display="none";
     document.getElementById("imgshow").src = "images/slide-button.gif";
     showit = false;
   }
}
function getRunData(){
  //return [["??????","eeeeee"]];
  return [];
}
/**
 * ????????????
 */
function initMateTree(){
  var guid = $("attachmentId").value; 
  if(guid){
   window["tree"].initMateTree(guid);
  }
}
function useStyle() {
  var docStyle = document.getElementById("docStyle").value;
  var docName = encodeURIComponent(docStyle);
  if (docStyle == nowDocStyle ) {
    return ;
  }
  var flag = TANGER_OCX_OBJ.ActiveDocument.TrackRevisions;
  TANGER_OCX_SetMarkModify(false);
  TANGER_OCX_AddDocMod1('word/' + docName,'word/tail/' + docName);
  TANGER_OCX_SetMarkModify(flag);
  nowDocStyle = docStyle;
}
function createNewDoc() {
  
  var msg = "???????????????????????????";
  if (!window.confirm(msg)) {
    return ;
  }
  parent.delDocAction(<%=seqId %>);
  //parent.newDOC();
  //var url = parent.getDocParam();
  //TANGER_OCX_bDocOpen = false;
  //window.location.href = url;
}
function hidden() {
  $('operateTable').hide();
  $('showTd').show();
}
function hidden() {
  $('operateTable').hide();
  $('showTd').show();
}
function showOp() {
  $('showTd').hide();
  $('operateTable').show();
}
function setContent(select) {
  var text = select.value;
  if(!confirm("???????????????????????????????????????????????????")) {
    setContentFree(select);
    return ;
  }
  if (!text) {
    return ;
  }
  try {
    var contentName = encodeURIComponent(text);
    var URL = 'docContent/' + contentName;
    curSel = TANGER_OCX_OBJ.ActiveDocument.Application.Selection;
    var flag = TANGER_OCX_OBJ.ActiveDocument.TrackRevisions;
    TANGER_OCX_SetMarkModify(false);
    //????????????
    curSel.HomeKey(6,1);
    curSel.Delete();
    curSel.EndKey(6,1);
    curSel.Delete();
    TANGER_OCX_OBJ.AddTemplateFromURL(URL);
    setContentFree(select);
    setContentFree($('docStyle'));
    nowDocStyle = "";
    TANGER_OCX_SetMarkModify(flag);
  } catch(err)
  {
    alert("?????????" + err.number + ":" + err.description);
  }
}
function setContentFree(select) {
  var option = select.options;
  for (var i = 0 ;i < option.length ;i++) {
    var tmp = option[i];
    if (!tmp.value) {
      tmp.selected = true;
      break;
    }
  }
}

function closeNTKO(){
  TANGER_OCX_OBJ.close();
}

function wordStamp(){
  TANGER_OCX_SaveDoc(0);
  parent.$('isStamp').value = '1';
  if(parent.$('saveControl')){
    parent.$('saveControl').style.display = 'none';
  }
  parent.$('sendControl').style.display = 'none';
  location.href = "/yh/subsys/jtgwjh/sendDoc/stamp/stampWord.jsp?seqId="+seqId+"&flag=1&flagClose=1";
}
</script>
</head>
<body onload="doInit()" style="margin-left:5px;padding:0px">
<form name="form1" id="form1" method="post" action="<%=contextPath %>/yh/core/funcs/office/ntko/act/YHNtkoAct/updateFile.act" enctype="multipart/form-data">
<table width=100% height=100% class="small" cellspacing="1" cellpadding="3" align="center" >
<tr width=100%>
<td valign=top width=100>
  <table id="operateTable" class="TableBlock" width="100%" align="center">
  <tr class="TableHeader"  onclick="hidden()">
       <td nowrap align="center" style="cursor:pointer;background-color:#cccccc"><<&nbsp;&nbsp;???????????????</td>
     </tr>
     <tr class="TableHeader" style="display:none" id="doc_fun">
     
       <td nowrap align="center">????????????</td>
     </tr>
     <tr id="doc_fun_save" class="TableLine1" onclick="TANGER_OCX_SaveDoc(0);getLog();" style="cursor:pointer;line-height:20px;display:none">
       <td nowrap align="center">????????????</td>
     </tr>
     <tr id="doc_fun_pageSet" class="TableLine2" onclick="TANGER_OCX_ChgLayout()" style="cursor:pointer;line-height:20px;display:none">
       <td nowrap align="center">????????????</td>
     </tr>
     <tr id="doc_fun_print" class="TableLine1" onclick="TANGER_OCX_PrintDoc()" style="cursor:pointer;line-height:20px;display:none">
       <td nowrap align="center">??????</td>
     </tr>
     <tr  id="doc_fun_log" class="TableLine2" onclick="ShowLog()" style="cursor:pointer;line-height:20px;display:none">
       <td nowrap align="center">????????????</td>
     </tr>
      
   <!-- tr class="TableHeader" id="doc_edit2">
     <td nowrap align="center">????????????</td>
   </tr>
   <tr  class="TableLine2">
   <td   align=center>
   <select name="docContent" onchange="setContent(this)" id="docContent"  style="width:100px">
   <option value="" selected>????????????</option>
   </select>
   </td>
   </tr>
   <tr  class="TableLine1">
   <td   align=center>
   
   <select name="docStyle" id="docStyle"  onchange="useStyle()" style="width:100px">
   <option value="" selected>??????????????????</option>
   </select>
   </td>
   </tr>
   
   <tr class="TableLine2" style="display:none" >
       <td nowrap align="center">
       <input type="button" value="??????" class="SmallButton" onclick="useStyle()"/>
   </td>
     </tr>
    <tr class="TableLine1" onclick="upateBookmark()" style="cursor:pointer;line-height:20px;">
       <td nowrap align="center">????????????</td>
     </tr>
     <tr class="TableLine2" onclick="downDoc()" style="cursor:pointer;line-height:20px">
       <td nowrap align="center">????????????</td>
     </tr> -->
     <tr class="TableLine1" onclick="createNewDoc()" style="cursor:pointer;line-height:20px">
       <td nowrap align="center" title="????????????????????????????????????">????????????</td>
     </tr>
   
   <tr class="TableHeader" style="display:none" id="doc_edit">
     <td nowrap align="center">????????????</td>
   </tr>
   <tr  id="doc_edit_redWord" onclick="return selectword();" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableData" align="center">????????????</td>
   </tr>
   <tr id="doc_edit_addPic"  onclick="wordStamp()" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableData" align="center">????????????</td>
   </tr>
   <!-- tr id="doc_edit_saveMark" onclick="MY_SetMarkModify(true)" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableControl" align="center" id="mflag1" >???????????? </td>
   </tr>
   <tr id="doc_edit_noMark" onclick="MY_SetMarkModify(false)" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableData" align="center" id="mflag2" >???????????? </td>
   </tr> -->
   <tr id="doc_edit_showRev" onclick="MY_ShowRevisions(true)" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableData" align="center" id="sflag1">????????????</td>
   </tr>
   <tr id="doc_edit_disRev" onclick="MY_ShowRevisions(false)" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableControl" align="center" id="sflag2">????????????</td>
   </tr>
   <!-- tr id="doc_edit_addPic"  onclick="AddPictureFromLocal()" style="cursor:pointer;line-height:20px;display:none">
     <td nowrap class="TableData" align="center">????????????</td>
   </tr> -->
  </table>
  </td>
  <TD id="showTd" style="display:none;width:14px;color:blue;cursor:pointer"  onclick="showOp()" valign="top">
  >>???????????????


  </TD>
<td width=100% valign="top">
<div style="z-index:-1;"> 
<object  id="TANGER_OCX" classid="<%=StaticData.Classid%>" codebase="<%=contextPath %>/core/cntrls/<%=StaticData.Codebase%>" width="99%" height="800">
<param name="wmode" value="transparent">
<param name="BorderStyle" value="1">
<param name="BorderColor" value="14402205">
<param name="TitlebarColor" value="14402205">
<param name="TitlebarTextColor" value="0">
<param name="Caption" value="Office??????????????????">
<param name="IsShowToolMenu" value="-1">
<param name="IsHiddenOpenURL" value="0">
<param name="IsUseUTF8URL" value="1">
<param name="MakerCaption" value="<%=StaticData.MakerCaption%>">
<param name="MakerKey" value="<%=StaticData.MakerKey%>">
<param name="ProductCaption" value="<%=StaticData.ProductCaption%>">
<param name="ProductKey" value="<%=StaticData.ProductKey%>">
<SPAN STYLE="color:red"><br>???????????????????????????????????????IE??????????????????????????????????????????IE?????????????????????</SPAN>
</object>
</div>
<div id="ocLog" style="display:none;padding-left:40px;" >
  <div align="center"><h2>????????????</h2></div>
  <div id="list"style="display:none;"></div>
   <div id="msrg" align="center" ></div>
  <div align="center" style="padding-bottom:10px;">
  <input type="button" class="BigButton" onclick="getLog();" value="????????????">
  <input type="button" class="BigButton" onclick="ShowLog();" value="????????????">
</div>
</div>
</td>
</tr>
</table>
<script language="JScript" for=TANGER_OCX event="OnDocumentClosed()">
  //?????????????????????????????????


  TANGER_OCX_OnDocumentClosed();
</script>
<script language="JScript" for=TANGER_OCX event="OnWordWPSSelChange(obj)">
  //?????????????????????????????????

  isMustSave = true;
 // TANGER_OCX_OnDocumentClosed();
</script>
<script language="JScript" for=TANGER_OCX event="OnDocumentOpened(TANGER_OCX_str,TANGER_OCX_obj)">
  TANGER_OCX_OBJ.Titlebar = false;
  TANGER_OCX_OnDocumentOpened(TANGER_OCX_str, TANGER_OCX_obj);
  //pageNumber();
  TANGER_OCX_SetReadOnly(false);
  if(findStr(TANGER_OCX_filename,".doc")){
    if(secOcRevision == "1") {
      TANGER_OCX_ShowRevisions(true);
    } else{
      TANGER_OCX_ShowRevisions(false);
    } 
    if(op != 4 && op != 7){
      TANGER_OCX_SetReadOnly(true);
      TANGER_OCX_EnableFilePrintMenu(false);
      TANGER_OCX_EnableFilePrintPreviewMenu(false);
    }
  }
  if (secOcMark == "0" || secOcMark == "2") {//??????????????????
    if (secOcMarkDefault == "0") {//?????????????????????
      TANGER_OCX_SetMarkModify(false);
    } else if (secOcMarkDefault == "1") { //??????????????????
      TANGER_OCX_SetMarkModify(true);
    }
  } else if (secOcMark == "1") {//??????????????????
    TANGER_OCX_SetMarkModify(true);
  } else if (secOcMark == "3") {//?????????????????????
    TANGER_OCX_SetMarkModify(false);
  }
</script>
<span id="TANGER_OCX_op" style="display:none"><%=op %></span>
<span id="TANGER_OCX_filename" style="display:none"><%=attachmentName %></span>
<span id="TANGER_OCX_attachName" style="display:none"><%=attachmentName %></span>
<span id="TANGER_OCX_attachURL" style="display:none"></span>
<span id="TANGER_OCX_user" style="display:none"><%=loginUser.getUserName() %></span>




<INPUT type=hidden NAME="attachmentId" id="attachmentId" value="<%=attachmentId %>">
<INPUT TYPE=hidden NAME="attachmentName" id="attachmentName" value="<%=attachmentName %>">
<INPUT TYPE=hidden NAME="moudle"  id="moudle" value="<%=moudle %>">
<input type="hidden" id="docSize" name="docSize" value="">
<input style="display:none" type="file" name="ATTACHMENT">
</FORM>

<iframe id="ifraClass" src="" style="display:none;"></iframe>
</body>
</html>