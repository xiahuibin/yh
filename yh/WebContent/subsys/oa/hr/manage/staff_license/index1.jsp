<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %> 
<%@ page  import="java.util.List"%>
<%@ page  import="java.lang.*"%>
<%@ page  import="yh.subsys.oa.book.data.*"%> 
<%@ page  import="yh.subsys.oa.hr.manage.staff_license.data.*"%> 
<html>
<head>
<%
	YHPage pages = (YHPage)request.getAttribute("page");
  List<YHHrStaffLicense> licenseList = (List<YHHrStaffLicense>)request.getAttribute("licenseInfoList");
  
  
%>
<title>证照管理 </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/select.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/hr/setting/codeJs/hrCodeJs.js"></script>
<script Language="JavaScript">
   function LicenseInfo(LicenseSeqId){ ///yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/findLicenseInfo.act
    var url  = contextPath + "/yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/findLicenseXxInfo.act?LicenseSeqId="+ LicenseSeqId;
    window.location.href=url;
   
   }

   function gotoPage(currNo){
     $("currNo").value = currNo;
    // var url  = contextPath + "/yh/subsys/oa/book/act/YHBookQueryAct/findBooks.act?currNo="+ currNo;   
    // window.location.href= url;
     $("form1").submit();
   }

   function jumpToPage(){
     var start = 1;
     var end = <%=pages.getTotalPageNum()%>;
     var pageNo = $("currentNo").value;
     if(!isInteger(pageNo)&&pageNo!=0){
       alert("请填写整数");
       $("currentNo").focus();
       return false;
     }
     else if(pageNo > end || pageNo <start){
       alert("页号应在"+start+"-"+end +"之间");
       $("currentNo").focus();
       return false;
     }else{
       gotoPage(pageNo);
     }
   }

  function deleteLicenseInfo(deleteSeqId){
   var msg ="确定要删除该类别吗？";
   if(!window.confirm(msg)){
   }else{
     var noHiddenId = document.getElementById("noHiddenId").value;
     if(noHiddenId && noHiddenId!="null"){
       window.location.href = contextPath + "/yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/delLicenseInfo.act?HiddenId="+deleteSeqId;  
       return true;
      }
    }
   
  }
  //全选
  function checkAll(field){
	   var allSelect = document.getElementsByName("bookSelect");
	   for(var i = 0; i<allSelect.length; i++){
	      allSelect[i].checked = field.checked;
	   }
  }
  //单选
  function checkOne(one){
    if(!one.checked){   
	     document.all("allbox").checked=false;
	   }
  }
  // 删除所选证照信息
  function deleteCheckBook(){
    var allSelect = document.getElementsByName("bookSelect");
    var deleteStr = "";
    for(var i = 0; i<allSelect.length; i++){
       if(allSelect[i].checked){
         deleteStr += allSelect[i].value +",";
       }
    }  
    if(deleteStr == ""){
       alert("要删除证照信息，请至少选择其中一条");
       return ;
    }
    msg = '确定要删除所选证照信息吗?';
    if(window.confirm(msg)){
       var par = 'deleteStr='+deleteStr;
       var url = contextPath + '/yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/deleteLicenseInfo.act';
       var json = getJsonRs(url,par);
       if (json.rtState == "0"){//删除后 重新提交查询页面
				 $("form1").submit();
				 return true;
		  } else{
         alert(json.rtMsrg);
      }
      }
   }
 function updateLicense(licenseId){
	 var url  = contextPath + "/yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/upLicenseInfo.act?licenseId="+ licenseId;
	  window.location.href=url;
 }

 
</script>
</head>

<body class="bodycolor" topmargin="5" >
<%
  if(pages.getTotalRowNum() > 0){%>    

<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small" >
  <tr>
    <td class="Big"><img src="<%=imgPath%>/notify_open.gif" WIDTH="22" HEIGHT="20" align="absmiddle"><span class="big3">证照管理 </span><br>
    </td>
    <td valign="bottom" align="right">
    <span class="small1">当前为第<b><%=pages.getFirstResult()+1 %></b>至<b><%=pages.getLastResult()%></b>条 (第<%=pages.getCurrentPageIndex()%>页，共<%=pages.getTotalPageNum()%>页，每页最多<%=pages.getPageSize() %>条)</small>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </td>
    </tr>
</table>

<table class="TableList"  width="95%" align="center">
<form method="post" name="from2" id ="from2" action="#">
  <tr class="TableHeader">
      <td nowrap align="center">选择</td>
      <td nowrap align="center">单位员工</td>
      <td nowrap align="center">证照类型</td>
      <td nowrap align="center">证照编号</td>
      <td nowrap align="center">证照名称</td>
      <td nowrap align="center">状态</td>
      <td nowrap align="center">操作</td>
  </tr>
 <%
 	for(int i=0; i<licenseList.size(); i++){%>
 	  <tr class="TableLine1">
 	  <td nowrap align="center"><input type="checkbox" id="bookSelect" name="bookSelect" value="<%=licenseList.get(i).getSeqId() %>" onClick="checkOne(this);">&nbsp;</td>
    <td nowrap align="center"><%=licenseList.get(i).getStaffName()==null?"":licenseList.get(i).getStaffName() %>&nbsp;</td>
    <td nowrap align="center"><%=licenseList.get(i).getLicenseType()==null?"":licenseList.get(i).getLicenseType() %>&nbsp;</td>
    <td nowrap align="center"><%=licenseList.get(i).getLicenseNo() %>&nbsp;</td>
    <td nowrap align="center"><%=licenseList.get(i).getLicenseName() %>&nbsp;</td>
    <td nowrap align="center"><%=licenseList.get(i).getStatus()==null?"":licenseList.get(i).getStatus() %>&nbsp;</td>
    <td nowrap align="center" width="80">
    	    <a href="javascript:void(0);" onclick="LicenseInfo(<%=licenseList.get(i).getSeqId() %>);return false;">详细信息 </a> 
    	     <a href="javascript:void(0);" onclick="updateLicense(<%=licenseList.get(i).getSeqId() %>);return false;">修改</a>
    	     <a href="javascript:void(0);" onclick="deleteLicenseInfo(<%=licenseList.get(i).getSeqId() %>);return false;">删除 </a>	
    <input type="hidden" value="<%= licenseList.get(i).getSeqId()%>" id="noHiddenId" name="noHiddenId"/>
    </td>
  </tr>
 <%} %> 
 <%
   if(pages.getTotalPageNum() >0){%>
     <tr class="TableControl">
			<td colspan="2" align="left">
				<input type="checkbox" name="allbox" id="allbox" onClick="checkAll(this);"><label for="allbox_for" style="cursor:pointer"><u><b>全选</b></u></label>&nbsp;
        <a href="javascript:deleteCheckBook();" title="删除所选证照信息"><img src="<%=imgPath %>/delete.gif">删除</a>
	    	 </td>
			 <td colspan="5" align="right">
			   <%if(pages.getCurrentPageIndex() >1){%>
			      <input type="button"  value="首页" class="BigButton"   onclick="gotoPage(1)"> &nbsp;&nbsp;
			   	  <input type="button"  value="上一页" class="BigButton"  onclick="gotoPage(<%=pages.getCurrentPageIndex()-1 %>)"> &nbsp;&nbsp;
			   	<%}%>
			   <%if(pages.getCurrentPageIndex() < pages.getTotalPageNum()){%>
			   	  <input type="button"  value="下一页" class="BigButton"  onclick="gotoPage(<%=pages.getCurrentPageIndex()+1 %>)"> &nbsp;&nbsp;
			   	  <input type="button"  value="末页" class="BigButton"   onclick="gotoPage(<%=pages.getTotalPageNum() %>)"> &nbsp;&nbsp;
			   	<%}%>
			   页数
			   <input type="text" name="currentNo" id="currentNo" value="<%=pages.getCurrentPageIndex()%>" class="SmallInput" size="2"> <input type="button"  value="转到" class="SmallButton" onclick="jumpToPage();" title="转到指定的页面">&nbsp;&nbsp;
			</td>
   </tr>
  <%}%> 
  </form>
</table>
<%} else{%>
 <table align="center" width="340" class="MessageBox">
         <tbody>
          <tr>
				    <td class="msg info">
				      <h4 class="title" align="left">提示</h4>
				      <div style="font-size: 12pt;" class="content">没有符合条件的证照信息！</div>
				    </td>
          </tr>
        </tbody>
      </table>  
<%}%>
<br>
<form action="<%=contextPath%>/yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/findLicenseInfo.act" method="get" name="form1" id="form1">
  <input type="hidden" name="currNo" id="currNo" value=""/> 
</form>
</body>
</html>
