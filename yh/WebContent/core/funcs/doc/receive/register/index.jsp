<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<html>
<head>
<title>收文登记</title>
<link href="<%=cssPath %>/style.css" rel="stylesheet" type="text/css" />
<link href="<%=cssPath %>/cmp/tab.css" rel="stylesheet" type="text/css" />
<script type="text/Javascript" src="<%=contextPath%>/core/js/datastructs.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/sys.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/prototype.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/smartclient.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/tab.js" ></script>
<script type="text/javascript">
function doInit(){
  var ca =  [{title:"未登记", contentUrl:contextPath + "/core/funcs/doc/receive/register/register.jsp",useIframe:true}
  ,{title:"已登记", contentUrl:contextPath + "/core/funcs/doc/receive/register/index1.jsp",useIframe:true}];
  buildTab(ca , "content");
}

</script>
</head>

<body onload="doInit();">
<div id="content"></div>
</body>
</html>