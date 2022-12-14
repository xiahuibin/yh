<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page  import="yh.subsys.oa.hr.manage.staff_license.data.*"%> 
<%@ page  import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
String userName = (String)request.getAttribute("userName");
List<YHHrStaffLicense> licenseList = (List<YHHrStaffLicense>)request.getAttribute("licenseXxInfoList");
YHHrStaffLicense license = licenseList.get(0);
String  status  =(String)license.getStatus();
String stype = (String)license.getLicenseType();

%>
<title>Insert title here</title>
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/meeting/js/util.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/hr/setting/codeJs/hrCodeJs.js"></script>
<script type="text/javascript">
function goto(){
		window.location.href= contextPath + "/yh/subsys/oa/hr/manage/staff_license/act/YHNewLicenseInfoAct/findLicenseInfo.act";
	}


function showAttachment(){
	var attachmentId = "<%=YHUtility.null2Empty(license.getAttachmentId())%>";
	var attachmentName = "<%= YHUtility.encodeSpecial(YHUtility.null2Empty(license.getAttachmentName()))%>";
	
	if(attachmentId){
		$("returnAttId").value = attachmentId;
		$("returnAttName").value = attachmentName;
		var selfdefMenu = {
      office:["downFile","read","edit"], 
      img:["downFile","play"],  
      music:["downFile","play"],  
      video:["downFile","play"], 
      others:["downFile"]
 	 }
  	attachMenuSelfUtil("attr","hr",$('returnAttName').value ,$('returnAttId').value, '','','<%=license.getSeqId()%>',selfdefMenu);
	}
}

function doInit(){
	showAttachment();
 var sta = <%=status%>;
 var types = <%=stype%>;
 var objState = getCodeById(sta);
 var objStype = getCodeById(types);
 var stateType = objStype.codeName;
 var stateName = objState.codeName;
 
 $('licenseType').innerHTML = stateType;
 $('licenseState').innerHTML = stateName;
 
 //alert(stateName +"=="+stateType);
}


</script>


</head>
<body topmargin="5" class="bodycolor" onload="doInit();">
<table cellspacing="0" cellpadding="3" border="0" width="100%" class="small">
  <tbody><tr>
    <td class="Big"><img height="17" width="17" src="<%=imgPath %>/meeting.gif"><span class="big3"> ??????????????????</span><br>
    </td>
  </tr>
</tbody></table>
<br>
<table align="center" width="90%" class="TableBlock">
<tbody><tr>
    <td nowrap="" align="left" width="120" class="TableContent">?????????</td>
    <td nowrap="" align="left" width="180" class="TableData"><%=userName==null?"":userName %></td>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
 
    <td nowrap="" align="left" width="180" class="TableData" id="licenseType" name ="licenseType"></td>
  </tr>
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td nowrap="" align="left" width="180" class="TableData"><%=license.getLicenseNo() %></td>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td align="left" width="180" class="TableData"><%=license.getLicenseName() %></td>
  </tr>
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td nowrap="" align="left" width="180" class="TableData"><%=license.getGetLicenseDate()==null?"":license.getGetLicenseDate() %></td>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td align="left" width="180" class="TableData"><%=license.getEffectiveDate()==null?"":license.getEffectiveDate() %></td>
  </tr>
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <%if(license.getExpirationPeriod().equalsIgnoreCase("1")){ %>
    <td nowrap="" align="left" width="180" class="TableData">???</td>
    <%}else{ %>
    <td nowrap="" align="left" width="180" class="TableData">???</td>
    <%} %>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td align="left" width="180" class="TableData"><%=license.getExpireDate()==null?"":license.getExpireDate() %></td>
  </tr>
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td align="left" width="180" class="TableData"><%=license.getNotifiedBody() %></td>
    <td nowrap="" align="left" width="120" class="TableContent">?????????</td>
    <td nowrap="" align="left" width="180" class="TableData" id="licenseState" name="licenseState"></td>
  </tr>
  <%
  	if(!YHUtility.isNullorEmpty(license.getAttachmentId())){
  %>
  
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent" >???????????????</td>
     <td nowrap align="left" class="TableData" colspan="3">
			<input type = "hidden" id="returnAttId" name="returnAttId"></input>
			<input type = "hidden" id="returnAttName" name="returnAttName"></input>
			<span id="attr"></span>
    </td>
  </tr>
  <%
  	}
  
  %>
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent">?????????</td>
    <td align="left" colspan="3" class="TableData"><%=license.getRemark()==null?"":license.getRemark() %></td>
  </tr>
  
  <tr>
    <td nowrap="" align="left" width="120" class="TableContent">???????????????</td>
    <td nowrap="" align="left" colspan="3" class="TableData"><%=license.getAddTime()==null?"":license.getAddTime() %></td>
  </tr>
  <tr align="center" class="TableControl">
      <td colspan="4">
       <input type="button" value="??????" class="BigButton" onClick="javascript:goto(); return false;">
      </td>
  </tr>
</tbody></table>

</body>
</html>