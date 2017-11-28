<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript">
var jso = [
       	  {title:"标记管理", content:"", contentUrl:"<%=contextPath %>/core/funcs/specialflag/specialflaglist.jsp",useIframe:true}
          ,{title:"添加标记", content:"", contentUrl:"<%=contextPath %>/core/funcs/specialflag/specialflaginput.jsp",  useIframe:true}
          ];
</script>
</head>
<body onload="buildTab(jso,'contentDiv',800)">
<div id="contentDiv"></div>
</body>
</html>