<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.core.funcs.person.data.YHPerson,yh.core.funcs.workflow.util.YHWorkFlowUtility" %>
<%
YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
String userPrivOther  = loginUser.getUserPrivOther();
boolean isAdmin = false;
if (loginUser.isAdminRole() 
    || YHWorkFlowUtility.findId(userPrivOther , "1")){
  isAdmin = true;
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href = "<%=cssPath %>/style.css">
<style>
#search{
   width:189px;
   margin-left:0px;
   border:1px solid #154B76;
   background: url('img/bg_input_text.png') top left repeat-x;
   filter:alpha(opacity=80);-moz-opacity:0.8;opacity:0.8;
}
#search:hover{
   border:1px solid #99CC00;
   background: url('img/bg_input_text_hover.png') top left repeat-x;
}

#search input.SmallInput {font-size: 9pt; border:0px; color:#8896A0;width:155px;background:none;}
#search input.SmallInput:hover {border:0px; color:#000000;}
</style>
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/utility.js"></script>
<script type="text/Javascript" src="<%=contextPath %>/core/js/cmp/DTree1.0.js" ></script>
<script type="text/javascript">
function editFlow(id){
  if (id) {
    parent.mainFrame.location = "main.jsp?flowId=" + id;
  }else{
    parent.mainFrame.location = "edit.jsp";
  }
}
var tree =null;
function doInit(){
 tree = new DTree({bindToContainerId:'sortList'
   ,requestUrl:contextPath + '/yh/core/funcs/workflow/act/YHFlowSortAct/getSortList.act?id='
   ,isOnceLoad:false//??????????????????
   ,linkPara:{clickFunc:openNode}//??????????????????a????????????????????????
 });
 tree.show(); 
}
function openNode(nodeId) {
  if (nodeId.indexOf("T") >= 0) {
    id = nodeId.substr(1);
    parent.mainFrame.location = "main.jsp?flowId=" + id;
  } else {
    var  node  =  tree.getNode(nodeId);
    parent.mainFrame.location = "list.jsp?sortId=" + nodeId + "&sortName=" + encodeURI(node.name);
  }
}
function actionFuntion(tmp){
  var arra = tmp.extData.split(":");
  editFlow(arra[0]);
}
function iconActionFuntion(tmp){ 
  var arra = tmp.extData.split(":");
  //??????????????? ??????
  if (arra[1] == '2') {
	return ;
  }
  openFlowDesign(arra[0]);
}
var interval=null,key="";
var KWORD;
function CheckSend()
{
	KWORD=$("kword");
	if(KWORD.value=="????????????...")
	   KWORD.value="";
  if(KWORD.value=="" && $('search_icon').src.indexOf("/images/quicksearch.gif")==-1)
	{
	   $('search_icon').src= imgPath + "/quicksearch.gif";
	}
	if(key!=KWORD.value)
	{
     key=KWORD.value;
     var pageURL = parent.mainFrame.location.toString();     
     if(pageURL.indexOf("search.jsp")>0)
	     parent.mainFrame.doSearch(KWORD.value);
	   else
	   	 parent.mainFrame.location = "search.jsp?searchKey="+KWORD.value;
	   if($('search_icon').src.indexOf( imgPath + "/quicksearch.gif")>=0)
	   {
	   	   $('search_icon').src = imgPath + "/closesearch.gif";
	   	   $('search_icon').title="???????????????";
	   	   $('search_icon').onclick=function(){
	   	   	                          KWORD.value='????????????...';
	   	   	                          $('search_icon').src= imgPath + "/quicksearch.gif";
	   	   	                          $('search_icon').title="";
                                    $('search_icon').onclick=null;};
	   }
  }
}
</script>
</head>
<body onload='doInit()'> 
<br>
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/notify_new.gif" align="absmiddle"><span class="big3"> ????????????</span><br>
    </td>
  </tr>
</table>
<br>
<div align="center">

<input type="button"  value="????????????" class="BigButtonC" onClick="editFlow()" title="????????????">
</div>
<br>
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/notify_open.gif" align="absmiddle"><span class="big3"> ????????????</span><br>
    </td>
  </tr>
</table>
<div id="search">
<input type="text" id="kword" name="kword" value="????????????..." onfocus="interval=setInterval(CheckSend,100);" onblur="clearInterval(interval);if(KWORD.value=='')KWORD.value='????????????...';" class="SmallInput" /><img id="search_icon" src="<%=imgPath %>/quicksearch.gif" align=absmiddle style="cursor:pointer;" />
</div>
<br/>
<div id='sortList'></div>

<%
if (isAdmin) {
%>
<br>
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/edit.gif" align="absmiddle"><span class="big3"> ????????????</span><br>
    </td>
  </tr>
</table>
<br>
<div align="center">
<input type="button" class="BigButton" onclick="parent.mainFrame.location='setTrans/index.jsp'" value="????????????"><br><br>
</div>
<%} %>
</body>
</html>