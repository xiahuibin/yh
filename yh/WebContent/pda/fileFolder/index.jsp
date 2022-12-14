<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="yh.core.funcs.person.data.YHPerson" %>
<%@ page import="yh.pda.fileFolder.data.YHPdaFileFolder" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="yh.core.util.YHUtility" %>
<%@ page import="yh.oa.tools.StaticData"%>
<%
String contextPath = request.getContextPath();
if (contextPath.equals("")) {
  contextPath = "/yh";
}
YHPerson loginPerson = (YHPerson)session.getAttribute("LOGIN_USER");
List fileFolders = (List) request.getAttribute("fileFolders");
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
  <div class="list_top_left"><a class="ButtonBack" href="<%=contextPath %>/pda/main.jsp?P=<%=loginPerson.getSeqId() %>"></a></div>
  <span class="list_top_center">ๆ็ๆไปถ</span>
</div>
<div id="list_main" class="list_main">
<%
int pageSize = (Integer)request.getAttribute("pageSize");
int thisPage = (Integer)request.getAttribute("thisPage");
int totalPage = (Integer)request.getAttribute("totalPage");
int count = fileFolders.size();
for(int i = 0 ; i < count ; i++){
  if(i >= pageSize)
    break;
  YHPdaFileFolder fileFolder = (YHPdaFileFolder)fileFolders.get(i);
  int seqId = fileFolder.getSeqId();
  String subject = fileFolder.getSubject();
  Date sendTime = fileFolder.getSendTime();
  String attachmentId = fileFolder.getAttachmentId() == null ? "" : fileFolder.getAttachmentId();
  String attachmentName = fileFolder.getAttachmentName() == null ? "" : fileFolder.getAttachmentName();
  String content = fileFolder.getContent();
  String prs = "&seqId="+seqId
              +"&subject="+YHUtility.encodeURL(subject)
              +"&sendTime="+sendTime.toString()
              +"&attachmentId="+attachmentId
              +"&attachmentName="+attachmentName
              +"&content="+content;
  %>
<a class="list_item" href="<%=contextPath %>/pda/fileFolder/read.jsp?P=<%=loginPerson.getSeqId() %><%=prs %>" hidefocus="hidefocus" >
   <div class="list_item_subject"><%=i+1+(thisPage-1)*pageSize %>.<%=subject %></div>
   <div class="list_item_time"><%=sendTime.toString().substring(0,19) %></div>
   <div class="list_item_arrow"></div>
</a>
<% 
}
if(count==0)
  out.println("<div id=\"message\" class=\"message\">ไธชไบบๆไปถๆๆ?น็ฎๅฝๆ?ๆไปถ</div>");
%>
</div>
<div id="list_bottom">
  <div class="list_bottom_left">
  <div id="pageArea" class="pageArea">
           ็ฌฌ<span id="pageNumber" class="pageNumber"><%=thisPage %>/<%=totalPage %></span>้กต

    <%if(thisPage == 1 || thisPage == 0){ %>
      <a href="javascript:void(0);" id="pageFirst" class="pageFirstDisable" title="้ฆ้กต"></a>
      <a href="javascript:void(0);" id="pagePrevious" class="pagePreviousDisable" title="ไธไธ้กต"></a>
    <%} else{%>
      <a href="<%=contextPath %>/yh/pda/fileFolder/act/YHPdaFileFolderAct/search.act?P=<%=loginPerson.getSeqId() %>&thisPage=1" id="pageFirst" class="pageFirst" title="้ฆ้กต"></a>
      <a href="<%=contextPath %>/yh/pda/fileFolder/act/YHPdaFileFolderAct/search.act?P=<%=loginPerson.getSeqId() %>&thisPage=<%=thisPage-1 %>" id="pagePrevious" class="pagePrevious" title="ไธไธ้กต"></a>
    <%}
      if(thisPage == totalPage ){%>
      <a href="javascript:void(0);" id="pageNext" class="pageNextDisable" title="ไธไธ้กต"></a>
      <a href="javascript:void(0);" id="pageLast" class="pageLastDisable" title="ๆซ้กต"></a>
    <%} else{%>
    <a href="<%=contextPath %>/yh/pda/fileFolder/act/YHPdaFileFolderAct/search.act?P=<%=loginPerson.getSeqId() %>&thisPage=<%=thisPage+1 %>" id="pageNext" class="pageNext" title="ไธไธ้กต"></a>
    <a href="<%=contextPath %>/yh/pda/fileFolder/act/YHPdaFileFolderAct/search.act?P=<%=loginPerson.getSeqId() %>&thisPage=<%=totalPage %>" id="pageLast" class="pageLast" title="ๆซ้กต"></a>
    <%} %>
  </div>
  </div>
  <div class="list_bottom_right"><a class="ButtonHome" href="<%=contextPath %>/pda/main.jsp?P=<%=loginPerson.getSeqId() %>"></a></div>
</div>
</body>
<script type="text/javascript" src="<%=contextPath %>/pda/js/logic.js"></script>
</html>
