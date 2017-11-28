<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>新建人士信息</title>
<link rel="stylesheet" href="<%=contextPath%>/core/styles/style1/css/cmp/Calendar.css">
<link rel="stylesheet" href="<%=cssPath%>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath%>/style.css">
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
<script type="text/Javascript" src="<%=contextPath %>/core/js/cmp/select.js"></script>
<script type="text/javascript">
var oFCKeditor = new FCKeditor('orgActive');
var oFCContact = new FCKeditor('orgContact');
var oFCNote = new FCKeditor('orgNote');

var upload_limit=1,limit_type="php,php3,php4,php5,";
//图片插入到正文
function InsertImage(src) { 
  var oEditor = FCKeditorAPI.GetInstance('orgActive') ; //FCK实例 
  if (oEditor.EditMode == FCK_EDITMODE_WYSIWYG ) { 
    oEditor.InsertHtml( "<img src = '"+ src + "'/>") ; 
  }
  var oFCContact = FCKeditorAPI.GetInstance('orgContact') ; //FCK实例 
  if (oFCContact.EditMode == FCK_EDITMODE_WYSIWYG ) { 
    oFCContact.InsertHtml( "<img src = '"+ src + "'/>") ; 
  }
  var oFCNote = FCKeditorAPI.GetInstance('orgNote') ; //FCK实例 
  if (oFCNote.EditMode == FCK_EDITMODE_WYSIWYG ) { 
    oFCNote.InsertHtml( "<img src = '"+ src + "'/>") ; 
  } 
}
function checkForm() {
  if ($("perNum").value == "") {
    alert("人员编号必填!");
    $("perNum").focus();
    $("perNum").select();
    return false;
  }
  if ($("perPositionName").value == "") {
    alert("职务必填!");
    $("perPositionName").focus();
    $("perPositionName").select();
    return false;
  }
  if ($("perName").value == "") {
    alert("姓名必填!");
    $("perName").focus();
    $("perName").select();
    return false;
  }
  if(!isValidDateStr($("perBirthday").value)  && $("perBirthday").value != ""){
    alert("出生日期格式不对，应形如 1999-01-01"); 
    $("perBirthday").focus(); 
    $("perBirthday").select(); 
    return false; 
  }
  return true;
}
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
  if (isUploadBackFun) {
    checkForm2();
    isUploadBackFun = false;
   }
}
//有附件，也执行上传附件

function jugeFile(){
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
  return true;
}
function doInit() {
//时间
  var parameters = {
      inputId:'perBirthday',
      property:{isHaveTime:false}
      ,bindToBtn:'date1'
  };
  new Calendar(parameters);
}
//提交信息
function checkForm2() {
  var FCK = FCKeditorAPI.GetInstance('orgNote'); // 获得表单设计器的顶层对象FCK，该方法定义位置fckeditorapi.js第47行
  var FORM_MODE = FCK.EditingArea.Mode;
  // 获取编辑区域的常量——源文件模式
  var editingAreaFrame = document.getElementById('orgNote___Frame');
  var editModeSourceConst = editingAreaFrame.contentWindow.FCK_EDITMODE_SOURCE;// 常量FCK_EDITMODE_SOURCE的定义位置_source/fckconstants.js
  if(FORM_MODE == editModeSourceConst) {
    FCK.Commands.GetCommand('Source').Execute();
  } 
  var FORM_HTML = FCK.EditingArea.Window.document.body.innerHTML;
  document.getElementById("perNote").value = FORM_HTML;

  var FCK2 = FCKeditorAPI.GetInstance('orgContact'); // 获得表单设计器的顶层对象FCK，该方法定义位置fckeditorapi.js第47行
  var FORM_MODE2 = FCK2.EditingArea.Mode;
  // 获取编辑区域的常量——源文件模式
  var editingAreaFrame2 = document.getElementById('orgContact___Frame');
  var editModeSourceConst2 = editingAreaFrame2.contentWindow.FCK_EDITMODE_SOURCE;// 常量FCK_EDITMODE_SOURCE的定义位置_source/fckconstants.js
  if(FORM_MODE2 == editModeSourceConst2) {
    FCK2.Commands.GetCommand('Source').Execute();
  } 
  var FORM_HTML2 = FCK2.EditingArea.Window.document.body.innerHTML;
  document.getElementById("perExperience").value = FORM_HTML2;

  var FCK3 = FCKeditorAPI.GetInstance('orgActive'); // 获得表单设计器的顶层对象FCK，该方法定义位置fckeditorapi.js第47行
  var FORM_MODE3 = FCK3.EditingArea.Mode;
  // 获取编辑区域的常量——源文件模式
  var editingAreaFrame3 = document.getElementById('orgActive___Frame');
  var editModeSourceConst3 = editingAreaFrame3.contentWindow.FCK_EDITMODE_SOURCE;// 常量FCK_EDITMODE_SOURCE的定义位置_source/fckconstants.js
  if(FORM_MODE3 == editModeSourceConst3) {
    FCK3.Commands.GetCommand('Source').Execute();
  } 
  var FORM_HTML3 = FCK3.EditingArea.Window.document.body.innerHTML;
  document.getElementById("perResume").value = FORM_HTML3;
  
  if (checkForm()) {
    if (jugeFile()) {//如果有没有上传的文件，则进行上传
      $("formFile").submit();
      isUploadBackFun = true;
      return ;
    }
    var pars = $('form1').serialize() ;
    var requestURL = "<%=contextPath%>/yh/subsys/oa/profsys/source/person/act/YHSourcePersonAct/addPerson.act";
    var json = getJsonRs(requestURL,pars);
    if (json.rtState == '1') { 
      alert(json.rtMsrg); 
      return ; 
    } else {
      window.location.href = "<%=contextPath%>/subsys/oa/profsys/source/person/news/add.jsp";
    }
  }
}
</script>
</head>
<body class="bodycolor" topmargin="5px" onLoad="doInit();">

<table border="0" width="90%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td>
    <img src="<%=imgPath%>/notify_new.gif" align="absmiddle"><span class="big3"> 新建人士信息</span>&nbsp;&nbsp;
    </td>
  </tr>
</table>
<br>
<form id="form1" method="post" name="form1">
<input type="hidden" name="dtoClass" value="yh.subsys.oa.profsys.source.person.data.YHSourcePerson">
<table class="TableBlock" width="80%" align="center">
    <tr>
      <td nowrap class="TableContent" >人员编号：<span style="color:red">*</span></td>
      <td nowrap class="TableData">
        <input type="text" class="BigInput" name="perNum" id="perNum" value="" size=20>
      </td>       
      <td nowrap class="TableContent" >职务：<span style="color:red">*</span></td>
      <td nowrap class="TableData">
      <input type="hidden" class="BigInput" name="perPosition" id="perPosition" size=10 readonly>
       <textarea cols=20 name="perPositionName" id="perPositionName" rows=1 class="BigStatic" wrap="yes" readonly></textarea>
         
      <a href="javascript:;" class="orgAdd" onClick="selectRole(['perPosition','perPositionName']);">添加</a>
      <a href="javascript:;" class="orgClear" onClick="$('perPosition').value='';$('perPositionName').value='';">清空 </a>
      </td>       
    </tr>
    <tr>
      <td nowrap class="TableContent">姓名：<span style="color:red">*</span></td>
      <td nowrap class="TableData">
        <input type="text" class="BigInput" name="perName" id="perName" value="" size=20>
      </td>
      <td nowrap class="TableContent" >性别：</td>
      <td nowrap class="TableData">
      <select name="perSex" id="perSex">
       <option value="1">男</option>
       <option value="2">女</option>
      </select>  
    </td> 
    </tr>
    <tr>
       <td nowrap class="TableContent">出生日期：</td>
      <td nowrap class="TableData">  
       <INPUT type="text" name="perBirthday" id="perBirthday" class=BigInput size="10" value="">
        <img id="date1" src="<%=imgPath%>/calendar.gif" align="absMiddle" border="0" style="cursor: hand">
      </td>
      <td nowrap class="TableContent">国籍：</td>
      <td nowrap class="TableData">
        <input type="text" class="BigInput" name="perNation" id="perNation" value="" size=20>
      </td>
    </tr>
    <tr>
     <td nowrap class="TableContent" width="90">职业：</td>
      <td class="TableData" colspan="3">
       <input id="perVocation" name="perVocation" type="text" value="" size="20" maxlength="30">
      </td>     
   </tr>
   <tr>
      <td nowrap class="TableContent">简介：</td>
      <td class="TableData" colspan="3">
      <div><script language=JavaScript>    
         oFCKeditor.Config["CustomConfigurationsPath"] = contextPath + "/core/funcs/diary/js/fckconfig.js"; 
         oFCKeditor.BasePath = "/yh/core/js/cmp/fck/fckeditor/";  
         oFCKeditor.Height = "150px";
         oFCKeditor.SkinPath = oFCKeditor.BasePath + 'skins/silver/' ; 
         oFCKeditor.ToolbarSet="DiaryBar";
         oFCKeditor.Create();
         </script>
      </div>
        <input type="hidden" id="perResume" name="perResume" value=""/>
     </td>
    </tr>
    <tr>
      <td nowrap class="TableContent">来华经历：</td>
      <td class="TableData" colspan="3">
      <div><script language=JavaScript>    
         oFCContact.Config["CustomConfigurationsPath"] = contextPath + "/core/funcs/diary/js/fckconfig.js"; 
         oFCContact.BasePath = "/yh/core/js/cmp/fck/fckeditor/";  
         oFCContact.Height = "150px";
         oFCContact.SkinPath = oFCContact.BasePath + 'skins/silver/' ; 
         oFCContact.ToolbarSet="DiaryBar";
         oFCContact.Create();
         </script>
      </div>
      <input type="hidden" id="perExperience" name="perExperience" value="" style="display:none" />
      </td>
    </tr>   
    <tr>
      <td nowrap class="TableContent">备注：</td>
      <td class="TableData" colspan="3">
      <div><script language=JavaScript>    
         oFCNote.Config["CustomConfigurationsPath"] = contextPath + "/core/funcs/diary/js/fckconfig.js"; 
         oFCNote.BasePath = "/yh/core/js/cmp/fck/fckeditor/";  
         oFCNote.Height = "150px";
         oFCNote.SkinPath = oFCNote.BasePath + 'skins/silver/' ; 
         oFCNote.ToolbarSet="DiaryBar";
         oFCNote.Create();
         </script>
      </div>
      <input type="hidden" id="perNote" name="perNote" value="" style="display:none" />
     </td>
    </tr>
      <tr id="attr_tr">
      <td nowrap class="TableData">附件文档：</td>
      <td class="TableData" colspan="3">
      <input type="hidden" id="attachmentName" name="attachmentName"></input>
       <input type="hidden" id="attachmentId" name="attachmentId"></input>
        <span id="showAtt">无附件</span>
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
      <td colspan="5" nowrap>
        <input type="button" value="保存" class="BigButton" onclick="checkForm2();">&nbsp;
        <input type="button" value="返回" class="BigButton" onClick="javascript:history.back();">
      </td>
    </tr>
  </table>
</form>
<form id="formFile" action="<%=contextPath%>/yh/subsys/oa/profsys/act/out/YHProjectAct/uploadFile.act" method="post" enctype="multipart/form-data" target="commintFrame">
  <input id="btnFormFile" name="btnFormFile" type="submit" style="display:none;"></input>
  </form>
  <iframe widht="0" height="0" name="commintFrame" id="commintFrame"></iframe> 
</body>
</html>