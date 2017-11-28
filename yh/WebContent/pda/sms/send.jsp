<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="yh.core.funcs.person.data.YHPerson" %>
<%@ page import="yh.oa.tools.StaticData"%>
<%
String contextPath = request.getContextPath();
if (contextPath.equals("")) {
  contextPath = "/yh";
}
YHPerson loginPerson = (YHPerson)session.getAttribute("LOGIN_USER");
int flag = (Integer) request.getAttribute("flag") == null ? 0 : (Integer) request.getAttribute("flag");
%>
<!doctype html>
<html>
<head>
<title><%=StaticData.SOFTTITLE%></title>
<meta name="viewport" content="width=device-width" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/pda/style/list.css" />
</head>
<body>
<div id="list_top">
  <div class="list_top_left"><a class="ButtonBack" href="<%=contextPath %>/yh/pda/sms/act/YHPdaSmsAct/doint.act?P=<%= loginPerson.getSeqId()%>"></a></div>
  <span class="list_top_center">写新短信</span>
</div>
<div id="list_main" class="list_main">
<%if(flag == 1){ %>
  <div id="message" class='message'>短信发送成功</div>
<%}else{%>
  <div id="message" class='message'>短信发送失败,<br>可能是指定的收信人姓名不存在</div>
<%}%>
</div>
<div id="list_bottom">
    <div class="list_bottom_right"><a class="ButtonHome" href="<%=contextPath %>/pda/main.jsp?P=<%=loginPerson.getSeqId() %>"></a></div>
</div>
</body>
<script type="text/javascript" src="<%=contextPath %>/pda/js/logic.js"></script>
</html>