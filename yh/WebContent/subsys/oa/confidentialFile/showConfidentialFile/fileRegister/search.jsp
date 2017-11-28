<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %> 
<%
	String seqIdStr = request.getParameter("seqId");
	int seqId=0;
	if(seqIdStr!=""){
	  seqId=Integer.parseInt(seqIdStr);
	}
	String subject = request.getParameter("SUBJECT") == null ? "" : YHUtility.encodeSpecial(request.getParameter("SUBJECT"));// 标题包含文字
	String contentNo = request.getParameter("CONTENT_NO") == null ? "" : YHUtility.encodeSpecial(request.getParameter("CONTENT_NO"));// 排序号
	String key1 = request.getParameter("KEY1") == null ? "" : YHUtility.encodeSpecial(request.getParameter("KEY1"));// 关键字
	String key2 = request.getParameter("KEY2") == null ? "" : YHUtility.encodeSpecial(request.getParameter("KEY2"));// 关键字
	String key3 = request.getParameter("KEY3") == null ? "" : YHUtility.encodeSpecial(request.getParameter("KEY3"));// 关键字

	String attachmentDesc = request.getParameter("ATTACHMENT_DESC") == null ? "" : YHUtility.encodeSpecial(request.getParameter("ATTACHMENT_DESC"));// 附件说明包含文字
	String attachmentName = request.getParameter("ATTACHMENT_NAME") == null ? "" : YHUtility.encodeSpecial(request.getParameter("ATTACHMENT_NAME"));// 附件文件名包含文字
	String attachmentData = request.getParameter("ATTACHMENT_DATA") == null ? "" : YHUtility.encodeSpecial(request.getParameter("ATTACHMENT_DATA"));// 附件内容包含文字

	String sendTimeMin = request.getParameter("sendTime_Min") == null ? "" : YHUtility.encodeSpecial(request.getParameter("sendTime_Min"));// 最小日期
	String sendTimeMax = request.getParameter("sendTime_Max") == null ? "" : YHUtility.encodeSpecial(request.getParameter("sendTime_Max"));// 最大日期
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.net.URLEncoder"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文件查询结果</title>
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath%>/page.css">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<link rel="stylesheet" href = "<%=cssPath%>/cmp/tree.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/page.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/confidentialFile/showConfidentialFile/js/util.js"></script>
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/confidentialFile/showConfidentialFile/js/showConfidentialFilelogic.js"></script>
<script type="text/javascript">
var pageMgr = null;
function doInit(){
	getFolderName("<%=seqId%>");
	 var param = "";
	 param = "subject=" + encodeURIComponent("<%=subject%>") ;
	 param += "&contentNo=" + encodeURIComponent("<%=contentNo%>") ;
	 param += "&key1=" + encodeURIComponent("<%=key1%>") ;	 
	 param += "&key2=" + encodeURIComponent("<%=key2%>") ;
	 param += "&key3=" + encodeURIComponent("<%=key3%>") ;
	 param += "&attachmentDesc=" + encodeURIComponent("<%=attachmentDesc%>") ;
	 param += "&attachmentName=" + encodeURIComponent("<%=attachmentName%>") ;
	 param += "&attachmentData=" + encodeURIComponent("<%=attachmentData%>") ;
	 param += "&sendTimeMin=" + encodeURIComponent("<%=sendTimeMin%>") ;
	 param += "&sendTimeMax=" + encodeURIComponent("<%=sendTimeMax%>") ;
	 param += "&seqId=<%=seqId%>";
	
  var url = "<%=contextPath%>/yh/subsys/oa/confidentialFile/act/YHConfidentialContentAct/queryFileByIdJson.act?" + param;
  var cfgs = {
      dataAction: url,
      container: "listContainer",
      sortIndex: 6,
      sortDirect: "desc",
      moduleName:"confidential", 
      colums: [
         {type:"hidden", name:"seqId", text:"顺序号", dataType:"int"},
         {type:"data", name:"subject",  width: '20%', text:"文件名称", align:"left",sortDef:{type: 0, direct:"desc"}},      
         {type:"hidden", name:"attachId", text:"附件ID",align:"center",width:"1%"},
         {type:"text", name:"attach", text:"附件文件",align:"left",width:"20%",dataType:"attach"},     
         {type:"data", name:"attachmentDesc",  width: '10%', text:"附件说明", render:alignFunc}, 
         {type:"data", name:"sendTime",  width: '5', text:"发布时间", render:sendDateFunc,sortDef:{type: 0, direct:"desc"}},
         {type:"data", name:"fileSend",  width: '2', text:"报送状态", render:fileSendFunc},
         {type:"hidden", name:"sortId",  width: '1%', text:"文件夹号", dataType:"int"},
         {type:"selfdef", text:"操作", width: '1',render:searchOptsList}]
    };
    pageMgr = new YHJsPage(cfgs);
    pageMgr.show();
    var total = pageMgr.pageInfo.totalRecord;
    if(total){
      count = total;
      showCntrl('listContainer');
      var mrs = " 共 "+ total + " 条记录 ！";
      showCntrl('backDiv');
      //showCntrl('delOpt');
      //checkSelectBox();
    }else{
      $("msrg").show();
    }
}

function delete_Proces(contentId){
	var msg="确定要删除选择文件吗？这将不可恢复！"
	if(window.confirm(msg)){
		var url=requestURL + "/delCheckedFile.act?seqIdStr="+contentId;
		var json=getJsonRs(url);
		if(json.rtState == '1'){
			alert(json.rtMsrg);
			return ;				
		}
		window.location.reload();
	} 	
}

</script>
</head>
<body onload="doInit();">
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath%>/folder_search.gif" align="middle">&nbsp;<span class="Big1" id="folderName"></span> - 文件查询结果&nbsp;
    </td>
  </tr>
</table>
<br>
<div id="listContainer" style="display:none;width:100%;"></div>
<br>
<div align="center" id="backDiv" style="display: none">
  <input type="button" value="返回" class="BigButton" onclick="location.href='<%=contextPath %>/subsys/oa/confidentialFile/showConfidentialFile/fileRegister/query.jsp?seqId=<%=seqId%>'">
</div>

<div id="msrg" style="display: none">
<table class="MessageBox" align="center" width="300">
  <tr>
    <td class="msg info">
      <div class="content" style="font-size:12pt">无符合条件的文件</div>
    </td>
  </tr>
</table>
<br><center><input type="button" class="BigButton" value="返回" onclick="javascript:location.href='<%=contextPath %>/subsys/oa/confidentialFile/showConfidentialFile/fileRegister/query.jsp?seqId=<%=seqId%>'"></center>
</div>
</body>
</html>