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

.clearfix {
display:block;
margin:0;
padding:0;
bottom:0;
position:fixed;
width:100%;
z-index:88888;
}

.m-chat .chatnote {
float:left;
height:25px;
line-height:25px;
position:absolute;
}
.m-chat {
-moz-background-clip:border;
-moz-background-inline-policy:continuous;
-moz-background-origin:padding;
background:transparent url(http://xnimg.cn/imgpro/chat/xn-pager.png) repeat-x scroll 0 -396px;
border-left:1px solid #B5B5B5;
display:block;
height:25px;
margin:0 15px;
position:relative;
}
.operateLeft{
	float: left;
	font-size: 12px;
	text-align: right;
	width: 80px;
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #999;
}
.operateRight{
	float: left;
	font-size: 12px;
	text-align: left;

}
</style>
<link rel="stylesheet" href = "<%=cssPath %>/style.css">
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath %>/cmp/ExchangeSelect.css" type="text/css" />
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
  var jso = [
            {title:"????????????", useTextContent:true , contentUrl:"<%=contextPath %>/subsys/jtgwjh/receiveDoc/manage/detailsForm.jsp?seqId=<%=seqId%>", useIframe:false}
             ,{title:"??????",  useTextContent:true,onload:showUserInfo.bind(window, "docMain"),contentUrl:"<%=contextPath %>/subsys/jtgwjh/receiveDoc/manage/print.jsp?seqId=<%=seqId%>", useIframe:false}
                   ];

  
  //onload:showUserInfo.bind(window, "americaInfo")
  tabs = buildTab(jso, 'contentDiv', 800);
  
  doOnload();

}
/**
 * ??????????????????
 */
function showUserInfo(){
	var id = arguments[0]; 
	var nationNo = "";
	if(id == "docMain"){//??????
		//getPublicInfo();
		//alert("aaa");
	  doLoadAip();
	}

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
    
    
    var docKind = prc.docKind;
    var docKindStr = "??????";
    if(docKind == '1'){
      docKindStr = "??????";
    }
    $("docKind").update(docKindStr);
    
    $("securityTime").update(prc.securityTime + "???");
    $("printCount").update(prc.printCount + "???");
    $("attachCount").update(prc.attachCount + "???");
    $("pageCount").update(prc.pageCount + "???");
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
function doOnload2(printCountValue,printStratNoValue,printEndNoValue,printCountAll){
  PRINT_COUNT_ALL = printCountAll;
  getModulField(printCountValue,printStratNoValue,printEndNoValue,printCountAll);
  setObjHeight();
}
/*
* ?????????????????????
*/
var printCountName = "printCount";
var printStratName = "printStratNo";
var printEndNoName = "printEndNo";
function getModulField(printCountValue,printStratNoValue,printEndNoValue,printCountAll){
var obj = $("HWPostil1");

var printCount = obj.GetValue(printCountName);//????????????
var printStratNo = obj.GetValue(printStratName);//????????????
var printEndNo = obj.GetValue(printEndNoName);//????????????
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
  var vRet = obj.InsertNote(printStratName,0,3,4000,1000,3000,1000);
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
obj.SetValue(printStratName, ":PROP:FONTSIZE:14");//?????????1
//obj.SetValue(printStratName,":PROP:FRONTCOLOR:16777215");//??????
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
var height = ((document.documentElement || document.body).scrollHeight - 120) + 'px';
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
	    alert("aaa");
	
	    //updateAipToService();
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


function doLoadAip(){
  
  
//var content = loadAIPById(modulId);
  var prc = loadMinAIP(seqId) ;
  if (prc.seqId) {
	  // ??????"HWPostil1"???NotifyCtrlReady?????????????????????????????????????????????????????????
	  $("seqId").value = seqId;
	  var obj = $("HWPostil1");
	  obj.ShowDefMenu = false; //????????????
	  obj.ShowToolBar = false; //???????????????
	
	  obj.JSEnv = 1;
	  obj.ShowScrollBarButton = 1;
	
	  var attachmentId = prc.mainDocId;
	  var attachmentName = prc.mainDocName;
	  //?????????????????????
	  if(attachmentId && attachmentName ){
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
	    obj.LoadFile("http://" + serviceName + ":" + webPort+  "<%=contextPath %>/getFile?uploadFileNameServer=" + encodeURIComponent(filePath) );
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

	    doOnload2(printCountValue,printStratNoValue,printEndNoValue,printCountAll);
	    
	  }else{
	   // $("projectDiv").style.display = "none";
	    var table = new Element('table',{ "class":"MessageBox" ,"align":"center","width":"340" }).update("<tr>"
	        + "<td class='msg info'><div class='content' style='font-size:12pt'>?????????????????????!</div></td></tr>"
	        );
	    
	    $("aipDiv").style.display = "none";
	    $("returnNull").style.display = "";
	
	    $('returnNull').update(table); 
	  }
  }
}





</script>



<body onload="doInit()" style="overflow-x;">

<div id="contentDiv" ></div>



<SCRIPT LANGUAGE=javascript FOR=HWPostil1 EVENT=JSNotifyBeforeAction(lActionType,lType,strName,strValue,plContinue);>
JSNotifyBeforeAction(lActionType,lType,strName,strValue,1);
</SCRIPT>
</body>
</html>