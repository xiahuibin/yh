<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文件类型查询</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath%>/cmp/Calendar.css" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Calendarfy.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/select.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript"	src="<%=contextPath%>/core/funcs/workflow/flowrun/documentsType/js/documentsTypeLogic.js"></script>
<script type="text/javascript">
function doInit(){
  getFlowType();
}

function doSubmit(){
	var query = $("form1").serialize(); 
	location.href = "<%=contextPath %>/core/funcs/workflow/flowrun/documentsType/search.jsp?" + query
}

function getFlowType() {
  var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocAct/getFlowType.act";  
  var json = getJsonRs(url);
  if (json.rtState == "0") {
    var type = json.rtData;
    if (type.length > 0) {
      for (var i = 0 ;i < type.length ;i++) {
        var name = type[i].flowName;
        var seqId = type[i].seqId;
        var option = new Element("option");
        option.value = seqId;
        option.update(name);
        $('flowType').appendChild(option);
      }
    } else {
      $('flowType').update("<option value=''>未定义流程</option>");
    }
  }
}
</script>
</head>
<body onload="doInit();">
<table border="0" width="80%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img align="absMiddle" src="<%=imgPath %>/infofind.gif"><span class="big3"> 文件类型查询</span></td>
  </tr>
</table>
<br>
<form action=""  method="post" name="form1" id="form1" >
  <table class="TableBlock" width="450" align="center">
	  <tr>
      <td nowrap class="TableData" width="100">文件名称：</td>
      <td class="TableData" >
        <input type="text" name="documentsName" id="documentsName" size="14" class="BigInput" value="">
      </td> 
   </tr>
    <tr>
      <td nowrap class="TableData">绑定流程：</td>
      <td class="TableData">
        <select name="flowType" id="flowType" style="width:124px;">
          <option value=""></option>
        </select>
      </td>
    </tr>
    <tr>
    <tr>
      <td nowrap class="TableData">文件字：</td>
      <td class="TableData">
         <input type="hidden" name="documentsFont" id="documentsFont" value="">
         <input type="text" name="documentsFontDesc" id="documentsFontDesc" size="14" class="BigStatic" readonly value=""></input>&nbsp;
        <a href="javascript:;" class="orgAdd" onClick="loadWindow(1)">选择</a>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">套红模板：</td>
      <td class="TableData">
        <input type="text" name="documentsWordModel" id="documentsWordModel" size="14" class="BigInput" value="">
      </td>
    </tr>
    <tr align="center" class="TableControl">
      <td colspan="2" nowrap>
        <input type="button" value="查询" onclick="doSubmit();" class="BigButton">&nbsp;&nbsp;
        <input type="reset" value="重填" class="BigButton">&nbsp;&nbsp;
      </td>
    </tr>
 </table>
</form>
</body>
</html>