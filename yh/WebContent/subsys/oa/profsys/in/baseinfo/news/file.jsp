<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String seqId = request.getParameter("seqId") == null ? "0" :  request.getParameter("seqId");
SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
YHPerson person = (YHPerson) request.getSession().getAttribute(YHConst.LOGIN_USER);
%>
<html>
<head>
<title>项目相关文档管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<%=contextPath%>/core/styles/style1/css/cmp/Calendar.css">
<link rel="stylesheet" href="<%=cssPath%>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath %>/page.css">

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
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/page.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/fck/fckeditor/fckeditor.js"></script> 
<script Language="JavaScript">

var upload_limit=1,limit_type="php,php3,php4,php5,";
function InsertImage(src) { 
  var oEditorNote = FCKeditorAPI.GetInstance('PROFSYS_NOTE');//FCK实例 
  if (oEditorNote.EditMode == FCK_EDITMODE_WYSIWYG ) { 
    oEditorNote.InsertHtml( "<img src = '"+ src + "'/>") ; 
  }
  var oEditorContent = FCKeditorAPI.GetInstance('PROFSYS_CONTENT') ; //FCK实例 
  if (oEditorContent.EditMode == FCK_EDITMODE_WYSIWYG ) { 
    oEditorContent.InsertHtml( "<img src = '"+ src + "'/>") ; 
  } 
}
function getContent(id,fckId){//FCK传值
  var oEditor = FCKeditorAPI.GetInstance(fckId) ;
  $(id).value=oEditor.GetXHTML();
}
function doOnload() {
  var projId = parent.projId;
  if (projId) {
    document.getElementById("projId").value = projId;
  }
  selectInMem();
}
function doInit(){
  if (checkForm()) {
    getContent('fileContent','PROFSYS_CONTENT');
    getContent('fileNote','PROFSYS_NOTE');
    if (jugeFile()) {//如果有没有上传的文件，则进行上传
      $("formFile").submit();
      isUploadBackFun = true;
      return;
    }
    var pars = $('form1').serialize() ;
    var requestURL = "<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectFileAct/addUpdateProjectFile.act";
    var json = getJsonRs(requestURL,pars);
    if (json.rtState == '1') { 
      alert(json.rtMsrg); 
      return ; 
    } else {
      alert("保存成功!");
      window.location.reload();
    }
  }

  
}
//添加项目相关文档
var isUploadBackFun = false;
//附件上传
function upload_attach(){
  if(checkForm()){
    $("btnFormFile").click();
  }  
}
function handleSingleUpload(rtState,rtMsrg,rtData) {
  var data = rtData.evalJSON(); 
  $('attachmentId').value += "," + data.attrId;
  $('attachmentName').value += "*" + data.attrName;
  attachMenuUtil("showAtt","profsys",null,$('attachmentName').value ,$('attachmentId').value,false);
  removeAllFile();
  if(isUploadBackFun){
    doInit();
  }
  return true;
}
//有附件，也执行上传附件

function jugeFile() {
  var formDom  = document.getElementById("formFile");
  var inputDoms  = formDom.getElementsByTagName("input"); 
  for (var i=0; i<inputDoms.length; i++) {
    var idval = inputDoms[i].id;
    if(idval.indexOf("ATTACHMENT") != -1){
      return true;
    }
  } 
  return false; 
}
//上传后可以显示浮动菜单

function deleteAttachBackHand(attachName,attachId,attrchIndex) { 
  var attachNameOld = $('attachmentName').value; 
  var attachIdOld = $('attachmentId').value; 
  var attachNameArrays = attachNameOld.split("*"); 
  var attachIdArrays = attachIdOld.split(","); 
  var attaName = ""; 
  var attaId = ""; 
  for (var i = 0 ; i < attachNameArrays.length ; i++) {
    if (!attachIdArrays[i] || attachIdArrays[i] == attachId) { 
        continue; 
    }
    attaName += attachNameArrays[i] + "*"; 
    attaId += attachIdArrays[i] + ","; 
  }
  $('attachmentId').value = attaId; 
  $('attachmentName').value = attaName;
  //doInit();
  var url= "<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectFileAct/deleleFile.act?attachId=" + attachId +"&attachName=" + encodeURIComponent(attachName) + "&seqId=" + attrchIndex;
  var rtJson = getJsonRs(url); 
    if(rtJson.rtState == "1"){
    alert(rtJson.rtMsrg); 
    return ;
  }
  return true;
}

//查询是否有项目相关文档

var pageMgr = null;
var cfgs = null;
function selectInMem(){
  var projId = parent.projId;
  var url = "<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectFileAct/queryOutFileByProjId.act?projId=" + projId + "&projFileType=0";
   cfgs = {
    dataAction: url,
    container: "giftList",
    moduleName:"profsys",  
    colums: [
       {type:"hidden", name:"seqId", text:"ID",align:"center", width:"1%"},
       {type:"text", name:"fileNum", text:"文档编号", width: "7%",align:"center"},
       {type:"text", name:"fileName", text:"文档名称", width: "7%",align:"center"},
       {type:"text", name:"fileType", text:"文档类别", width: "7%",align:"center"},
       {type:"text", name:"fileCreator", text:"创建人", width: "7%",align:"center"},
       {type:"text", name:"fileTitle", text:"文档主题词", width: "7%",align:"center"},
       {type:"hidden", name:"attachId", text:"附件ID",align:"center",width:"1%"},
       {type:"text", name:"attach", text:"附件",align:"center",width:"10%",dataType:"attach"},
       {type:"selfdef",name:"opts",align:"center",align:"center", text:"操作", width:"10%",render:toOpts}]
  };
  pageMgr = new YHJsPage(cfgs);
  pageMgr.show();
  var total = pageMgr.pageInfo.totalRecord;
  if (total <= 0) {
    var table = new Element('table',{ "class":"MessageBox" ,"align":"center","width":"340" }).update("<tr>"
        + "<td class='msg info'><div class='content' style='font-size:12pt'>尚未添加项目相关文档！</div></td></tr>"
        );
    $('giftList').style.display = "none";
    $('returnNull').update(table); 
  }
}
function toOpts(cellData, recordIndex, columInde){
  var seqId = this.getCellData(recordIndex,"seqId");
  return "<a href='#' onclick='getFileById(" + seqId + ");'>编辑</a> "
         +"<a href='javascript:deleteFileById(" + seqId + ");'> 删除 </a> ";
}
function deleteFileById(seqId){
  var msg="确定要删除该项 吗?";
  if(window.confirm(msg)){
    var requestURL = "<%=contextPath%>/yh/subsys/oa/profsys/act/out/YHOutProjectFileAct/deleteFileById.act?seqId=" + seqId; 
    var json=getJsonRs(requestURL); 
    if(json.rtState == '1'){ 
      alert(json.rtMsrg); 
      return ; 
    }
    alert("删除成功！");
    window.location.reload();
  }
}
//修改
function getFileById(seqId) {
    var requestURL = "<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectFileAct/getFileById.act?seqId=" + seqId; 
    var json = getJsonRs(requestURL);
    if (json.rtState == '1'){ 
      alert(json.rtMsrg); 
      return ;
    }
    var prc = json.rtData; 
    if (prc.seqId) {
      var seqId = prc.seqId;
      $("seqId").value = prc.seqId;
      $("fileNum").value = prc.fileNum;
      $("fileName").value = prc.fileName;
      $("fileType").value = prc.fileType;
      $("fileCreator").value = prc.fileCreator;
      $("fileTitle").value = prc.fileTitle;
      $("projDate").value = prc.projDate;
      $("projCreator").value = prc.projCreator;
      $("fileCreator").value = prc.projCreatorName;
      var oFCKFileContent = FCKeditorAPI.GetInstance('PROFSYS_CONTENT') ;
      oFCKFileContent.SetData(prc.fileContent);
      var oFCKFileNote = FCKeditorAPI.GetInstance('PROFSYS_NOTE') ;
      oFCKFileNote.SetData(prc.fileNote);
      
      $("attachmentName").value = prc.attachmentName;
      $("attachmentId").value = prc.attachmentId;
      //attachMenuUtil("showAtt","profsys",null,$('attachmentName').value ,$('attachmentId').value,false);
      doOnloadFile();
    }
}

var  selfdefMenu = {
  	office:["downFile","dump","read","deleteFile"], 
    img:["downFile","dump","play","deleteFile"],  
    music:["downFile","dump","play","deleteFile"],  
    video:["downFile","dump","play","deleteFile"], 
    others:["downFile","dump","deleteFile"]
	}
function doOnloadFile(){
  var seqId  = $("seqId").value;
  attachMenuSelfUtil("showAtt","profsys",$('attachmentName').value ,$('attachmentId').value, '','',seqId,selfdefMenu);
}
//表单验证
function checkForm() {
   if ($("fileNum").value == "") {
     alert("文档编号必填!");
     $("fileNum").focus();
     $("fileNum").select();
     return false;
   }
   if ($("fileName").value == "") {
    alert("文档名称必填!");
    $("fileName").focus();
    $("fileName").select();
    return false;
   }
   return true;
}
</script>
</head>
<body  topmargin="5" onLoad="doOnload();">
<input type="hidden" id="qRen" name="qRen" value="">
<table border="0" width="50%" cellspacing="0" cellpadding="3" class="small">
  <tr><td>
  <img src="<%=imgPath%>/notify_new.gif" align="absmiddle"/>
  <span class="big3">添加项目相关文档</span><td></tr>
</table>
<form id="form1" name="form1">
<div id="seqIdDiv"></div>
<input type="hidden" name="dtoClass" value="yh.subsys.oa.profsys.data.YHProjectFile">
<input type="hidden" name="projFileType" id="projFileType" value="0">
<input type="hidden" name="projId" id="projId" value="">
<input type="hidden" name="seqId" id="seqId" value="">
<table class="TableBlock" border="0" width="80%" align="center">
    <tr>
      <td nowrap class="TableContent">文档编号：<span style="color:red">*</span></td>
      <td nowrap class="TableData">
        <input type="text" class="BigInput" name="fileNum" id="fileNum" value="" size="10" maxLength="20">
      </td>
    <td nowrap class="TableContent">文档名称：<span style="color:red">*</span></td>
      <td nowrap class="TableData">
        <input type="text" class="BigInput" name="fileName" id="fileName" value="" size="10" maxLength="20">
      </td> 
    </tr>
    <tr>
      <td nowrap class="TableContent">文档类别：</td>
      <td nowrap class="TableData">
        <input type="text" class="BigInput" name="fileType" id="fileType" value="" size="10" maxLength="20">
      </td>
       <td nowrap class="TableContent">创建人：<span style="color:red">*</span></td>
      <td nowrap class="TableData">
       <input type="hidden" name="projCreator" id="projCreator" value="<%=person.getSeqId()%>">
       <input type="hidden" name="projDate" id="projDate" value="<%=sf.format(new Date())%>">
       <input type="text" name="fileCreator" id="fileCreator" value="<%=person.getUserName()%>" readonly>
      </td> 
    </tr>
    <tr>
      <td nowrap class="TableContent" width="90">文档主题词：</td>
      <td class="TableData" colspan="3">
        <textarea name="fileTitle" id="fileTitle" cols="45" rows="2" class="BigInput"></textarea>
      </td>     
    </tr>
    <tr>
      <td nowrap class="TableContent">内容：</td>
      <td class="TableData" colspan="3">
     <div><script language=JavaScript>    
     var oFCKContent = new FCKeditor('PROFSYS_CONTENT');
     oFCKContent.Config["CustomConfigurationsPath"] = contextPath + "/core/funcs/diary/js/fckconfig.js"; 
     oFCKContent.BasePath = "/yh/core/js/cmp/fck/fckeditor/";  
     oFCKContent.Height = "300px";
     oFCKContent.SkinPath = oFCKContent.BasePath + 'skins/silver/' ; 
     oFCKContent.ToolbarSet="DiaryBar";
     oFCKContent.Create();
     </script>
           <input type = "hidden" id="fileContent" name="fileContent"></input>
</div>
</td>
    </tr>
     <tr>
      <td nowrap class="TableContent">备注：</td>
      <td class="TableData" colspan="3">
  <div><script language=JavaScript>    
  var oFCKNote = new FCKeditor('PROFSYS_NOTE');
  oFCKNote.Config["CustomConfigurationsPath"] = contextPath + "/core/funcs/diary/js/fckconfig.js"; 
  oFCKNote.BasePath = "/yh/core/js/cmp/fck/fckeditor/";  
  oFCKNote.Height = "300px";
  oFCKNote.SkinPath = oFCKNote.BasePath + 'skins/silver/' ; 
  oFCKNote.ToolbarSet="DiaryBar";
  oFCKNote.Create();
         </script>
               <input type = "hidden" id="fileNote" name="fileNote"></input>
</div>
       </td>
    </tr>   
    <tr id="attr_tr">
      <td nowrap class="TableData">附件文档：</td>
      <td class="TableData" colspan="3">
      <input type = "hidden" id="attachmentName" name="attachmentName"></input>
       <input type = "hidden" id="attachmentId" name="attachmentId"></input>
        <span id="showAtt"></span>
      </td>
    </tr>
    <tr height="25">
      <td nowrap class="TableData">附件选择：</td>
      <td class="TableData" colspan="3">
        <input type="hidden" id="moduel" name="moduel" value="profsys">
       <script>ShowAddFile();ShowAddImage();</script>
     <script>$("ATTACHMENT_upload_div").innerHTML='<a href="javascript:upload_attach();">上传附件</a>'</script>  
      </td>
    </tr>
   <tr align="center" class="TableControl">
      <td colspan="4" nowrap>
 <div id="but">
      <input type="button" value="保存" class="BigButton" onclick="javascript:doInit();">&nbsp;
      <input type="button" value="关闭" class="BigButton" onclick="javascript:parent.opener.location.reload();parent.window.close()">&nbsp;
      </div>
      </td>
  </tr> 
</table>
 </form>
  <form id="formFile" action="<%=contextPath%>/yh/subsys/oa/profsys/act/YHProjectCalendarAct/uploadFile.act" method="post" enctype="multipart/form-data" target="commintFrame">
  <input id="btnFormFile" name="btnFormFile" type="submit" style="display:none;"></input>
  </form>
  <iframe widht="0" height="0" name="commintFrame" id="commintFrame"></iframe> 
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="3">
 <tr>
   <td background="<%=imgPath%>/dian1.gif" width="100%"></td>
 </tr>
</table>
 
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr><td>
  <img src="<%=imgPath %>/user_group.gif" align="absmiddle"/>
  <span class="big3">项目相关文档列表</span>
  <td></tr>
</table>
<div id="giftList"></div>
<div id="returnNull"></div>
</body>
</html>