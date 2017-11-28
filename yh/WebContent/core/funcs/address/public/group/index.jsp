<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*,yh.core.funcs.system.censorwords.data.YHCensorWords" %>
<%@ page import="yh.core.data.YHRequestDbConn, yh.core.global.YHBeanKeys" %>
<%@ page import="yh.core.funcs.person.data.YHPerson" %>
<%
  YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>分组管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href = "<%=cssPath%>/cmp/Calendar.css">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<link rel="stylesheet" href = "<%=cssPath%>/cmp/tree.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/address/public/js/publicUtil.js"></script>
<script type="text/javascript">
var loginUserId = <%=loginUser.getSeqId()%>;
var isAdmin = <%=loginUser.isAdmin()%>;

function doInit(){
  var url = "<%=contextPath%>/yh/core/funcs/address/act/YHAddressAct/getPublicManageGroup.act";
  var rtJson = getJsonRs(url);
  var flag = 0;
  if(rtJson.rtState == "0"){
    var table=new Element('table',{ "width":"100%","class":"TableBlock","align":"center"})
     .update("<tbody id='tbody'><tr class='TableHeader'>"
       + "<td nowrap width='' align='center'>分组名称</td>"
       + "<td nowrap width='300' align='center'>操作</td></tr>"
       + "<tr class='TableData' align='center'>"
       + "<td nowrap align='center'>默认</td>"
       + "<td nowrap align='left'>"
       <% if (loginUser.isAdmin()) { %>
       + "<a href="
       + "javascript:clearGroup('0','默认');"
       + ">清空</a>&nbsp;&nbsp;"
       + "<a href="
       + "javascript:importAddressPublic('0');"
       + ">导入</a>&nbsp;"
       <% } %>
       + "<a href="
       + "javascript:expFoxMail('0','默认');"
       + ">导出Foxmail格式</a>&nbsp;"
       + "<a href="
       + "javascript:expOutLook('0','默认');"
       + ">导出OutLook格式</a>&nbsp;"
       + "<a href="
       + "javascript:printFunc('0');"
       + "> 打印</a>"
       + "</td>"
       + "</tr><tbody>");
    $('listDiv').appendChild(table);
  	for(var i = 0; i < rtJson.rtData.length; i++){
      flag++;
      var seqId = rtJson.rtData[i].seqId;
  	  var groupName = rtJson.rtData[i].groupName;
      var privFlag = rtJson.rtData[i].privFlag;
  	  var privDept = rtJson.rtData[i].privDept;
  	  var privRole = rtJson.rtData[i].privRole;
  	  var privUser = rtJson.rtData[i].privUser;
  	  var trColor = (flag % 2 == 0) ? "TableLine1" : "TableLine2";
  	  var tr=new Element('tr',{'class':trColor});			
      table.firstChild.appendChild(tr);
      var trStr = "<td align='center'>"					
        + groupName + "</td><td align='left'>"	;
        if(privFlag == 1){
          trStr += "<a   href=\"javascript:void(0)\" onclick=\"clearGroup('"+seqId+"','"+groupName.escapeHTML().replace(/'/g,"\\\'").replace("\"","\\\"") + "')\">清空</a>&nbsp;&nbsp;"
        + "<a href="
        + "javascript:importAddressPublic('"+seqId+"');"
        + ">导入</a>&nbsp;";
         }
        trStr += "<a   href=\"javascript:void(0)\" onclick=\"expFoxMail('"+seqId+"','"+groupName.escapeHTML().replace(/'/g,"\\\'").replace("\"","\\\"") + "')\">导出Foxmail格式</a>&nbsp;"
        + "<a   href=\"javascript:void(0)\" onclick=\"expOutLook('"+seqId+"','"+groupName.escapeHTML().replace(/'/g,"\\\'").replace("\"","\\\"") + "')\">导出OutLook格式</a>&nbsp;"
        + "<a href="
        + "javascript:printFunc('"+seqId+"');"
        + "> 打印</a>"
        + "</td>";
       tr.update(trStr);
  	}
  }else{
  	alert(rtJson.rtMsrg); 
  }
}

function support(groupNames, seqId){
  var URL = "/yh/core/funcs/system/address/manage/support.jsp?seqId="+seqId+"&groupName="+encodeURIComponent(groupNames);
  openDialog(URL,'480', '280');
}

function confirmDelete() {
  if(confirm("确认要删除该分组吗？注意：该分组下的联系人将全部转入到默认分组中！")) {
    return true;
  }else {
    return false;
  }
}

function confirmClear(groupName) {
  if(confirm("确认要清空["+groupName+"]分组的联系人吗？")) {
    return true;
  }else {
    return false;
  }
}

//管理分组：清空联系人
function clearGroup(seqId,groupName){
  if(!confirmClear(groupName)) {
  	return ;
  } 
  var url = "<%=contextPath%>/yh/core/funcs/address/act/YHAddressAct/clearPublicManageGroup.act";
  var rtJson = getJsonRs(url,"seqId="+seqId);
  if(rtJson.rtState == "0"){
    window.location.reload();
  }else{
	alert(rtJson.rtMsrg); 
  }
}

//默认分组：清空联系人
function clearGroups(){
  var groupName = "默认";
  if(!confirmClear(groupName)) {
  	return ;
  } 
  window.location.reload();
}

</script>
</head>
<body topmargin="5" onload="doInit()">

<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath%>/notify_open.gif" align="absmiddle"><span class="big3">&nbsp;管理分组</span>
    </td>
  </tr>
</table>
<br>
<div id="listDiv" align="center"></div>

</body>
</html>