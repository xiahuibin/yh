<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ include file="/core/funcs/doc/workflowUtility/workflowheader.jsp" %>
<%
String runId = request.getParameter("runId");
String flowId = request.getParameter("flowId");
String prcsId = request.getParameter("prcsId");

String sIsManage = request.getParameter("isManage");
if (sIsManage == null ) {
  sIsManage = "false";
}
String flowPrcs = "0";
if ("1".equals(prcsId)) {
  flowPrcs = "1";
}
boolean isManage = Boolean.valueOf(sIsManage);
String sortId = request.getParameter("sortId");
if (sortId == null) {
  sortId = "";
}
String skin = request.getParameter("skin");
String skinJs = "messages";
if (skin != null && !"".equals(skin)) {
  skinJs = "messages_" + skin;
} else {
  skin = "";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" href ="<%=cssPath %>/style.css">
<link rel="stylesheet" href = "<%=cssPath %>/cmp/ExchangeSelect.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/ExchangeSelect1.0.js"></script>
  <script type="text/javascript" src="<%=contextPath %><%=moduleContextPath %>/lables/<%=skinJs %>.js"></script>
<script type="text/javascript" src="<%=contextPath %><%=moduleContextPath %>/workflowUtility/skin.js"></script>
<script type="text/javascript" src="openWin.js"></script>
<script type="text/javascript" src="turnnextfree.js"></script>
<script type="text/javascript">
var runId = '<%=runId%>';
var flowId = '<%=flowId%>';
var prcsId= '<%=prcsId%>';
var isManage = <%=isManage%>;
var sortId = "<%=sortId%>";
var skin = "<%=skin%>";

var prcsOpUserNameSpan;
var prcsUserNameSpan ;
var prcsOpUser;
var prcsUser;
var topFlagInput;
</script>
</head>
<body onload="doInit()">
<form name="turnForm" id="turnForm" method="post" action="">
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/green_arrow.gif" align="absmiddle">&nbsp;&nbsp;<span class="big3" id="flowNameSpan">  - ??????????????????</span><br>
    </td>
  </tr>
</table>
<br>
<table id="prcsTable" class="TableList" width="95%">
    <tr>
      <td  class="TableHeader" nowrap colspan="2"><div style="float:left;font-weight:bold"><img src="<%=imgPath %>/workflow.gif" align="absmiddle"> ??????????????????<%=runId %> - <span id="runNameSpan"></span></div></td>
    </tr>
   <tbody id=prcsListTbody>
   
   </tbody>
   <tr class="TableData">
       <td>???<span class=big4 style="color:red"><%=Integer.parseInt(prcsId) + 1 %></span>??????(????????????)<br><font id="preSetDiv" color=red style="display:none">????????????????????????</font></td>
       <td id=prcsText></td>
    </tr>
    <tbody id="preListTbody"></tbody>
   <tr class="TableControl" height=30 id="previewDiv" style='display:none'>
      <td colspan="2">
       <input type="button" value="+ ???????????????????????????"  onClick="addPre()" title="????????????????????????????????????????????????" name="button">
       <span id="delBtn" style="display:none">
       <input type="button" value="- ??????????????????????????????"  onClick="delPre()" title="??????????????????????????????" name="button">
      </span>
      </td>
    </tr>
   
 	   <tr class="TableContent">
      <td colspan="2" height="20px"><div style="margin-bottom:5px;font-weight:bold"> ????????????</div>
       <div>
       <span id="sms2RemindSpan" style="display:none"><input type="checkbox" name="sms2Remind" id="sms2Remind"><img src="<%=imgPath %>/mobile_sms.gif"><label for="sms2Remind"><u style="cursor:pointer">????????????</u></label></span>
       <input type="checkbox" name="smsRemind" id="smsRemind"><img src="<%=imgPath %>/sms.gif"><label for="smsRemind"><u style="cursor:pointer">????????????</u></label>

    <input type="checkbox" name="webMailRemind" id="webMailRemind" style="display:none" >
    <img src="<%=imgPath %>/webmail.gif" style="display:none" ><label for="webMailRemind" style="display:none"><u style="cursor:pointer">Internet??????</u></label></div>
???????????????<input type="text" onmouseover="this.focus()" onfocus="this.select()" id="smsContent" name="smsContent" value="" size="100" maxlength="100" class="SmallInput">
     </td>
    </tr>
    <tr class="TableContent">
      <td nowrap colspan="2">
      <font color=red>?????????</font>????????????????????????????????????????????????????????????????????????????????????
      </td>
    </tr>
    <tr class="TableControl">
      <td nowrap align="center" colspan="2">
        <input type="hidden"  name="runId" id="runId" value="<%=runId %>">
        <input type="hidden"  name="OP"  id="OP" value="">
        <input type="hidden"  name="prcsId" id="prcsId" value="<%=prcsId %>">
        <input type="hidden" name="flowId" id=flowId value="<%=flowId %>">
		<input type="hidden"  name="freeItemOld" id=freeItemOld value="">
		     <input type="hidden" value="<%=sortId %>" id="sortId" name="sortId"/>

        <input type="button"  value="??????" onclick="turnNext()" class="SmallButtonW" name="mybutton">&nbsp;&nbsp;
     <% if (!isManage) { %>
      <input type="button" onclick="location='../inputform/index.jsp?skin=<%=skin %>&sortId=<%=sortId %>&runId=<%=runId %>&flowId=<%=flowId %>&prcsId=<%=prcsId %>&flowPrcs=<%=flowPrcs %>'" class=SmallButtonW value="????????????"/>????
     <%} %>
     <input type="button" onclick="TurnNext_forwardPage()"  class=SmallButtonW value="????????????"/>????
       <select name="operation" style="display:none" class="BigSelect" onchange="alert('?????????????????????....')">
       <option value="" selected>????????????...</option>
       <option value="notify">????????????</option>
		<option value="mail_to">??????</option>
		<option value="SaveFile">??????</option>
		<option value="roll">??????</option>
    </select>
      </td>
    </tr>
</table>
</form>
</body>
</html>