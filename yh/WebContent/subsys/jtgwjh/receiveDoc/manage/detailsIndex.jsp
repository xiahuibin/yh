<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%

String seqId = request.getParameter("seqId") == null ? "" : request.getParameter("seqId") ;
String hostIp = request.getLocalAddr();
String serviceName = request.getServerName();
int port = request.getLocalPort();
  

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">


<style type="text/css">


</style>
<link rel="stylesheet" href = "<%=cssPath %>/style.css">
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath %>/cmp/ExchangeSelect.css" type="text/css" />

<link rel="stylesheet" href="/yh/subsys/jtgwjh/css/style.css" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/ExchangeSelect1.0.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/fck/fckeditor/fckeditor.js"></script> 
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attach.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryUtil.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryLogic.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath%>/subsys/jtgwjh/receiveDoc/js/jhDocReceive.js"></script>
<script type="text/javascript" src="<%=contextPath%>/subsys/jtgwjh/receiveDoc/js/designer.js"></script>
<script type="text/javascript">
var tabs = null;

var menu = ["??????????????????","??????","????????????"];
//     {title:"??????",onload:showUserInfo.bind(window, "publicInfo"),useTextContent:true ,contentUrl:"<%=contextPath %>/subsys/servicehall/visaformprint/setting/web/public.jsp",useIframe:false}
         
function doInit() {

  
  doOnload();
 // doLoadAip();
}


var seqId = '<%=seqId%>';
var upload_limit=1,limit_type="php,php3,php4,php5,";
/**
 * ??????
 */
function doOnload() {
  if(seqId > 0){
    getInfo(seqId);
    doOnloadFile();
  }

}
//????????????
function getInfo(seqId){
  var requestURL = "<%=contextPath%>/yh/subsys/jtgwjh/docReceive/act/YHJhDocrecvInfoAct/selectById.act?seqId=" + seqId ;
  var json = getJsonRs(requestURL);
  if (json.rtState == '1') { 
    alert(json.rtMsrg); 
    return ; 
  } else {
    var prc = json.rtData;
    bindJson2Cntrl(prc);
    //?????????????????????????????????  Strat
    var attachId = prc.attachmentId;
    var attachName = prc.attachmentName;
    var docId = prc.mainDocId;
    var docName = prc.mainDocName;
    var attachIdArr = attachId.split(",");
    var attachNameArr = attachName.split("*");
    var newAttachId = "";
    var newAttachName = "";
    for(var i = 0 ;i<attachIdArr.length ;i++){
      if(attachIdArr[i] && docId != attachIdArr[i]){
        newAttachId = newAttachId + attachIdArr[i] + ",";
        newAttachName = newAttachName + attachNameArr[i] + "*";
      }
    }
    if(newAttachId){
      newAttachId = newAttachId.substring(0,newAttachId.length-1);
      newAttachName = newAttachName.substring(0,newAttachName.length-1);
    }
    $("attachmentId").value = newAttachId;
    $("attachmentName").value = newAttachName;
    //end
    
    var docType = prc.docType;
    var docTypeStr = "??????";
    if(docType == '1'){
      docTypeStr = "??????";
    }
    $("docType").update(docTypeStr);
    
    var urgentType = prc.urgentType;
    var urgentTypeStr = "??????";
    if(urgentType == '1'){
      urgentTypeStr = "??????";
    }else  if(urgentType == '2'){
      urgentTypeStr = "??????";
    }

    $("urgentType").update(urgentTypeStr);
    
    
    var securityLevel = prc.securityLevel;
    var securityLevelStr = "??????";
    if(securityLevel == '1'){
      securityLevelStr = "??????";
    }else if(securityLevel == '2'){
      securityLevelStr = "??????";
    }
    $("securityLevel").update(securityLevelStr);
    
    //????????????
    var handStatus = prc.handStatus;
    var handStatusStr = "????????????";
    if(handStatus == '1'){
      handStatusStr = "?????????";
    }else if(handStatus == '2'){
      handStatusStr = "?????????";
    }
    $("handStatusStr").update(handStatusStr);
    
    var statusStr = "?????????";
    var status = prc.status;
    if(status == '1'){
      statusStr = "?????????";
    }else if(status == '2'){
      statusStr = "?????????";
    }
    $("printStatusStr").update(statusStr);
    $("printCount").update(prc.printCount + "???");
    
    var isSign = prc.isSign;
    var isSignStr = "???";
    if(isSign == "0"){
      isSignStr = "???";
    }
    $("isSignStr").update(isSignStr);
    
  }
}

var  selfdefMenu = {
    office:["downFile","read"], 
    img:["downFile","play"],  
    music:["downFile","play"],  
    video:["downFile","play"], 
    others:["downFile"]
  }

function doOnloadFile(){
  var attr = $("attr");
  var seqId  = $("seqId").value;
  attachMenuSelfUtil(attr,$("moduel").value,$('attachmentName').value ,$('attachmentId').value, '','',seqId,selfdefMenu);
}
var isUploadBackFun = false;
//????????????
function upload_attach(){
  if(checkForm()){
    $("btnFormFile").click();
  }  
}

//?????????????????????????????????
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


function returnInfo(){
  window.location.href = "waitReceive.jsp";
}

function doReceive(){
  var requestURL = "<%=contextPath%>/yh/subsys/jtgwjh/docReceive/act/YHJhDocrecvInfoAct/recvMessage.act"; 
  
  var json=getJsonRs(requestURL); 
  if (json.rtState == '1') { 
    alert(json.rtMsrg); 
    return ; 
  } else {
    var prc = json.rtData;
    alert("???????????????")
    window.location.reload();
  }
}





//function document.onkeydown(){
//if(event.keyCode==13){
	//event.keyCode=9;
//}
//}
var argObj = null;
var _userName = "sys_admin";
var seqId = '<%=seqId%>';
var charactersType = '';//???????????????
var PRINT_COUNT_ALL = 1;
function doOnload2(printCountValue,printStratNoValue,printEndNoValue,isPrintSign,printCountAll){
  PRINT_COUNT_ALL = printCountAll;
  setObjHeight();
  window.setTimeout("getModulField(" + printCountValue + "," + printStratNoValue + "," + printEndNoValue + "," + isPrintSign + "," + printCountAll + ")",800);

  
 // if(m<10){timer=window.setTimeout("showImg()",2000);}
 // else{window.clearTimeout(timer); alert("??????????????????")}
  //}


}
/*
* ?????????????????????
*/
var printCountName = "printCount";

var printStratName = "printStratNo";
var printEndNoName = "printEndNo";

var isPrintSign = "1";
var isPrintSignName = "printSign";
/* printCountName:????????????????????????
printStratName :????????????
printEndNoName:????????????
 isPrintSignName:?????????????????? 0???????????????1?????????*/
function getModulField(printCountValue,printStratNoValue,printEndNoValue,printSign,printCountAll){
var obj = $("HWPostil1");
var printCount = obj.GetValue(printCountName);//????????????
var printStratNo = obj.GetValue(printStratName);//????????????
var printEndNo = obj.GetValue(printEndNoName);//????????????
 isPrintSign = obj.GetValue(isPrintSignName);//????????????
if(!printCount){
  var vRet = obj.InsertNote(printCountName,0,3,1000,1000,3000,1000);???
  
  obj.SetValue(printCountName,printCountValue);
  obj.SetValue(printCountName,":PROP:BORDER:0");//?????????
  obj.SetValue(printCountName,":PROP:FRONTCOLOR:-1");//????????????
  obj.SetValue(printCountName, ":PROP::LABEL:3");//????????????
  obj.SetValue(printCountName, ":PROP:FONTSIZE:14");//?????????1
  obj.SetValue(printCountName,":PROP:FRONTCOLOR:16777215");//??????
}
if(!printStratNo){
  var vRet = obj.InsertNote(printStratName,0,3,6667,6033,3000,1500);
  obj.SetValue(printStratName,"")???;
  if(isNumber(printStratNoValue)){
    obj.SetValue(printStratName,printStratNoValue)???;
  }else{
    obj.SetValue(printStratName,"0")???;
  }

}else{
  printCountValue =   obj.GetValueEx(printCountName,2,"",0,"");

}
obj.SetValue(printStratName,":PROP:BORDER:0");//?????????
obj.SetValue(printStratName,":PROP:FRONTCOLOR:-1");//????????????
obj.SetValue(printStratName, ":PROP::LABEL:3");//????????????
obj.SetValue(printStratName, ":PROP:FONTSIZE:16");//?????????1
obj.SetValue(printStratName,":PROP:FACENAME:????????????");
obj.SetValue(printStratName,":PROP:FONTBOLD:1");//??????
//obj.SetValue(printStratName,":PROP:FRONTCOLOR:16777215");//??????



if(!isPrintSign){

  var vRet = obj.InsertNote(isPrintSignName,0,3,20,1000,2000,1000);???
  obj.SetValue(isPrintSignName,printSign);
  obj.SetValue(isPrintSignName,":PROP:BORDER:0");//?????????
  obj.SetValue(isPrintSignName,":PROP:FRONTCOLOR:-1");//????????????
  obj.SetValue(isPrintSignName, ":PROP::LABEL:3");//????????????
  obj.SetValue(isPrintSignName, ":PROP:FONTSIZE:14");//?????????1
  obj.SetValue(isPrintSignName,":PROP:FRONTCOLOR:16777215");//??????
}
isPrintSign  =   obj.GetValueEx(isPrintSignName,2,"",0,"");
/*
 *??????????????????
 */
 $("printInfo").update("???????????????" + (parseInt(printCountAll,10) - parseInt(printCountValue,10)) + " / " + printCountAll);

if(!printEndNo){
  var vRet = obj.InsertNote(printEndNoName,0,3,7000,1000,3000,1000);
  obj.SetValue(printEndNoName,"")???;

  if(isNumber(printStratNoValue)){
    obj.SetValue(printEndNoName,printEndNoValue)???;
  }else{
    obj.SetValue(printEndNoName,"0")???;
  }
  obj.SetValue(printEndNoName,":PROP:BORDER:0");//?????????
  obj.SetValue(printEndNoName,":PROP:FRONTCOLOR:-1");//????????????
  obj.SetValue(printEndNoName, ":PROP::LABEL:3");//????????????
  obj.SetValue(printEndNoName, ":PROP:FONTSIZE:14");//?????????1
  obj.SetValue(printEndNoName,":PROP:FRONTCOLOR:16777215");//?????????
}

obj.Logout();
}
/*
* ????????????????????????????????????????????????
*/
function setObjHeight(){
var height = ((document.documentElement || document.body).scrollHeight - 125) + 'px';
$('HWPostil1').style.height = height ;
//alert(height)
//$("fieldList").style.height =((document.documentElement || document.body).scrollHeight - 63) + 'px';
}
//???????????????

function doInitPrint(type){
 chekePrintCount(type);

}
var printCountValue = 0;
/*
* ??????????????????
*/
function chekePrintCount(index){
  type = 0;//????????????
	var obj = $("HWPostil1");
	if(isPrintSign == '0'){//???????????????
	  obj.PrintDoc(1,1);
	}else{
	  var printCount = obj.GetValue(printCountName);//????????????
		var value = obj.GetValueEx(printCountName,2,"",0,"");
		printCountValue = value;
		if(value<=0){
		  alert("??????????????????????????????????????????");
		}else{
		  var obj = $("HWPostil1");
		  if(index=='1'){
		    obj.ForceSignType2 = 1;//????????????
		  }else {
		    obj.ForceSignType2 = 0;
		  }
		  var ratInt = obj.PrintDoc(1,1);//?????????????????????
		  if(ratInt > 0){
		    //alert("aaa");
	     	alert("????????????????????????????????????");
		
		    //updateAipToService();
		  }
		}
	}
	
}


/*
* ???aip???????????????????????????
*/
function updateAipToService() {
var filePath = $("filePath").value ;
var  attachmentName = "";

try{   
  var webObj=document.getElementById("HWPostil1");
      webObj.HttpInit();
      webObj.HttpAddPostCurrFile("FileBlody");  
      var port = '<%=port%>';
      returnValue = webObj.HttpPost("http://<%=serviceName%>:" +port+ "/yh/subsys/jtgwjh/receiveDoc/saveFile/saveAip.jsp?filePath=" + encodeURIComponent(filePath) + "&fileName=" + encodeURIComponent(attachmentName));
      if("ok" == returnValue){
        //alert("???????????????"); 
      }else if("failed" == returnValue){
        alert("???????????????");
      }
      //window.location.href  = "index.jsp" ;
}catch(e){
  alert(e);
}
}


/**
 * ??????????????????
 */
function updatePrintStatus(seqId){
  var requestURL = "<%=contextPath%>/yh/subsys/jtgwjh/docReceive/act/YHJhDocrecvInfoAct/updateStatus.act?seqId=" + seqId + "&status=2" ; 
  var json=getJsonRs(requestURL); 
  if (json.rtState == '1') { 
    alert(json.rtMsrg); 
    return ; 
  } else {

  }
}

function doLoadAip(){
//var content = loadAIPById(modulId);
  var prc = loadMinAIP(seqId) ;
  if (prc.seqId) {
	  // ??????"HWPostil1"???NotifyCtrlReady?????????????????????????????????????????????????????????
	  $("seqId").value = seqId;
	  var obj = $("HWPostil1");
	  //obj.ShowDefMenu = false; //????????????
	// obj.ShowToolBar = false; //???????????????
	
	  obj.JSEnv = 1;
	  obj.ShowScrollBarButton = 1;
	
	  var attachmentId = prc.mainDocId;
	  var attachmentName = prc.mainDocName;
	  //?????????????????????
	  if(attachmentId && attachmentName ){
	    $("returnNull").style.display = "none";
	    var printCountValue = prc.printCount;//?????????????????????
	    var printStratNoValue = prc.printNoStart;//????????????????????????
	    var printEndNoValue = prc.printNoEnd;//???????????????????????????

	    var webPort = prc.port;//???????????????
	    filePath = prc.filePath;
	    var attachmentIdArra = attachmentId.split("_");
	    var attachmentIdDate = attachmentIdArra[0];
	    var fileName =attachmentName;
	    var serviceName = prc.serviceName ;
	    var filePath = prc.filePath;
	    var printCountAll = prc.printCount;
	    var attachmentIdDate = attachmentId.substr(0,4);
	    var fileName = attachmentIdArra[1] + "_" + attachmentName;
	    filePath = filePath + attachmentIdDate + "/" + fileName;

	    var vRet = obj.Login( _userName , 5, 32767, "", "");//????????????
	    var obj = $("HWPostil1");
	    //var t = "http://" + serviceName + ":" + webPort+  "<%=contextPath %>/getFile?uploadFileNameServer=" + filePath ;
	    var Int =  obj.LoadFile("http://" + serviceName + ":" + webPort+  "<%=contextPath %>/getFile?uploadFileNameServer=" + encodeURIComponent(filePath) );
	   // alert(Int)
	    if(obj.IsOpened()){//??????????????????????????????

	      updateDocMainOpen(seqId); 
	    }
	  // alert(Int);
	    if(!Int){
	      doOnload2(printCountValue,printStratNoValue,printEndNoValue,prc.isSign,printCountAll);
	    }
	    // obj.SaveTo(localFilePath + "\\" + fileName ,"aip",0);

	    //obj.LoadFileBase64(content);

	    // obj.InTabSortMode  =1;  
	    // obj.SilentMode =1  ;
	    obj.AppendTipInfo = "aaaa";//????????????

	    obj.CurrPenColor = 255;
	    //obj.CurrXYMode=0;//?????????????????????????????????1?????????

	    obj.SetPageMode(8,222);
	    $("filePath").value = filePath;

	     
	    // var tt1 = obj.ProtectDoc(3,"111",1);//???????????????????????????

	    // var tt1 = obj.ProtectDoc(3,"",0);//???????????????????????????
	    // var tt  =  obj. ProtectObject("",0,16,'','11111');
	    // alert(tt1  +":"+ tt);

	  
	    
	  }else{
	   // $("projectDiv").style.display = "none";
	    var table = new Element('table',{ "class":"MessageBox" ,"align":"center","width":"340" }).update("<tr>"
	        + "<td class='msg info'><div class='content' style='font-size:12pt'>?????????????????????!</div></td></tr>"
	        );
	    
	    $("aipDiv").style.display = "none";
	    $("returnNull").style.display = "";
    //  <input type="button" value="??????" onclick="window.close();" class="BigButton">
    
    
    var div = new Element("div",{"align":"center"});
	    var button = new Element('input',{
	      "class":"BigButton",
	      "value":"??????",
	      "type":"button"});
	    button.onclick = function(){
	      window.close();
	    }
	    div.insert(button);
	    $('returnNull').update(table); 
	    $('returnNull').insert(div); 
	  }
  }
}

/*
 * ?????????????????????????????????
 */
function updateDocMainOpen(seqId)
{

  var url = "<%=contextPath%>/yh/subsys/jtgwjh/docReceive/act/YHJhDocrecvInfoAct/updateDocMainOpen.act?seqId=" + seqId ;
  var rtJson = getJsonRs(url);
  if (rtJson.rtState == "0")
  {
    var openState = rtJson.rtData.openType;
    if(openState == '1'){
      alert("???AIP?????????????????????????????????????????????...");
      window.close();
    }
  }else {
    alert(rtJson.rtMsrg);
    return false;
  }
}

/**
 * ????????????
 */
function checkClose(){
  clearSessionToken();
}


/*
 * ??????sessionToken
 */
function clearSessionToken()
{
  var url = "<%=contextPath%>/yh/subsys/jtgwjh/docReceive/act/YHJhDocrecvInfoAct/clearSessionToken.act?seqId=" + seqId ;
  var rtJson = getJsonRs(url);
  if (rtJson.rtState == "0")
  {
    var openState = rtJson.rtData.openType;
    //if(openState == '1'){
     // alert("???AIP?????????????????????????????????????????????...");
     // window.close();
   // }
  }else {
    alert(rtJson.rtMsrg);
    return false;
  }
}
/**
 * tab?????????
 */
var isClickDocMian = false;
function navTabChange(flag){
  
  switch(flag){
  
  case 1 : $('tab_1').className = 'tab_on_1';
          $('tab_2').className = 'tab_2';
          $("formInfo").style.display = "";
          $("printAllInfo").style.display = "none";
          break;

  
   case 2 : 
     $('tab_1').className = 'tab_1';
     $('tab_2').className = 'tab_on_2';
    $("formInfo").style.display = "none";
    $("printAllInfo").style.display = "";
     if(!isClickDocMian){
       doLoadAip();
       isClickDocMian = true;
     }

    break;
  }
}

</script>
<SCRIPT LANGUAGE=javascript FOR=HWPostil1 EVENT=JSNotifyBeforeAction(lActionType,lType,strName,strValue,plContinue);>
JSNotifyBeforeAction(lActionType,lType,strName,strValue,1);
</SCRIPT>


<body onload="doInit();" style="overflow-x;"  onbeforeunload="checkClose();" >

<div style="position: fixed;height:40px;background-color: #E5E5E5;top: 5px;width: 100%;">
  <ul class="navTab" >
    <li title="??????" class="tab_on_1" id="tab_1" onclick="navTabChange(1)"/>
    <li title="??????" class="tab_2" id="tab_2" onclick="navTabChange(2)"/>
  </ul>
  <!-- >div id="formControl">
    <input type="button" title="??????" onclick="doSubmit();" class="newButton newButtonSave" onmouseover="saveControlOver(1)" onmouseout="saveControlOver(0)" id="saveControl">
  </div -->
</div>

<div id="formInfo" style="margin-top:50px;">

<table border="0" width="90%" cellspacing="0" cellpadding="3"
  class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/notify_open.gif"
      align="middle">&nbsp;<span class="big3">????????????</span></td>
  </tr>
</table>
<br>
<form id="form1" name="form1">
	<table class="TableBlock" width="80%" align="center">
		 <tr>

      <td nowrap class="TableContent">??????????????? </td>
      <td class="TableData"colspan="3"  id="sendDeptName" name="sendDeptName" ></td>
	  </tr>
	  <tr>
      <td nowrap class="TableContent">??????????????? </td>
      <td class="TableData"colspan="3" name="docTitle" id="docTitle" ></td>
	  </tr>
    <tr>
      <td nowrap class="TableContent">????????? </td>
      <td class="TableData" id="docNo" colspan="3"></td>
    </tr>
	  <tr>
      <td nowrap class="TableContent" style="width: 147px;">??????????????? </td>
      <td class="TableData" id="docType"></td>
      <td nowrap class="TableContent" style="width: 147px;">??????????????? </td>
      <td class="TableData"  id="urgentType"  ></td>
	  </tr>
    <tr>
      <td nowrap class="TableContent">????????? </td>
      <td class="TableData"  id="securityLevel"></td>
      <td nowrap class="TableContent">?????????????????? </td>
      <td class="TableData" id="printCount" ></td>
    </tr>
    
     <tr>
      <td nowrap class="TableContent">??????????????? </td>
      <td class="TableData"  id="handStatusStr"></td>
      <td nowrap class="TableContent">??????????????? </td>
      <td class="TableData" id="printStatusStr" ></td>
    </tr>
    
      <tr>
      <td nowrap class="TableContent">????????????????????? </td>
      <td class="TableData"  id="isSignStr"></td>
      <td nowrap class="TableContent"> </td>
      <td class="TableData" id="" ></td>
    </tr>
    <tr>
      <td nowrap class="TableContent">????????? </td>
      <td class="TableData" colspan="5" id="remark"></td>
    </tr>
    <tr id="attr_tr">
      <td nowrap class="TableContent">???????????????</td>
      <td class="TableData" colspan="3">

      <input type = "hidden" id="attachmentName" name="attachmentName"></input>
      <input type = "hidden" id="attachmentId" name="attachmentId"></input>
        <span id="attr">?????????</span>
      </td>
    </tr>
  
    <tr align="center" class="TableControl">
      <td colspan='4' nowrap>
      <input type="hidden" name="dtoClass" value="yh.subsys.jtgwjh.docReceive.data.YHJhDocrecvInfo">
      <input type="hidden" id="seqId" name="seqId" value="">
      <input type="hidden" id="moduel" name="moduel" value="docReceive">
      <input type="hidden" name="careContent" id="careContent" value="">
      <input type="button" value="??????" onclick="window.close();" class="BigButton">
      </td>
    </tr>
  </table>
</form>
</div>

<!-- ???????????? -->

<div id="printAllInfo" style="display:none;margin-top:50px;">
<div id="returnNull" style="margin-top:100px;"></div>
<div id="aipDiv">
<table class="" align="center" style="width:100%;height:100%;">
     <tr>
      <td class="TableData" align="center">
<input type="button" value="??????" class="BigButton" onclick="doInitPrint('0');"></input>&nbsp;
        <input type="button" value="??????" onclick="window.close();" class="BigButton">
<input type="hidden" value="??????" class="BigButton" onclick="doInitPrint('1');"></input>&nbsp;


&nbsp;&nbsp;<span id="printInfo"></span>

<input type="hidden" value="" id="seqId" name="seqId"></input>

<input type="hidden" value="" id="filePath" name="filePath"></input>	    </td>

    </tr>
    <tr  style="width:100%;height:100%;">
        <td class="TableData"  style="width:100%;height:100%;">


<OBJECT id=HWPostil1  style="WIDTH:100%;HEIGHT:500px;"  classid=clsid:FF3FE7A0-0578-4FEE-A54E-FB21B277D567 codeBase='<%=contextPath %>/subsys/jtgwjh/setting/aip/HWPostil.cab#version=3.0.9.4' />
    </td>
    </tr>
    
    
</table>
<div id="11">
<input type="hidden" name="seqId" id="seqId"></input>
  <input type="hidden" name="filePath" id="filePath"></input>
  
  
</div>
</div>



</div>



</body>
</html>