<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title></title>
<link href="<%=cssPath %>/style.css" rel="stylesheet" type="text/css" />
<link href="<%=cssPath %>/cmp/tab.css" rel="stylesheet" type="text/css" />
<script type="text/Javascript" src="<%=contextPath%>/core/js/datastructs.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/sys.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/prototype.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/smartclient.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/tab.js" ></script>
<script type="text/javascript">
function doInit(){
  var ca =  [{title:"未办理", contentUrl:contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/readDocReceive1.act?ftype=1",useIframe:true}
    ,{title:"已办结", contentUrl:contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/readDocReceive1.act?ftype=1&hasEnd=1",useIframe:true}]
  buildTab(ca , "content");
}

</script>
</head>

<body onload="doInit();">
<div id="content"></div>
</body>
</html>