<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%

	String staffDept = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffDept")));
	String staffName = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffName")));
	String staffEName = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffEName")));
	String workStatus = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("workStatus")));
	String staffNo = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffNo")));
	String workNo = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("workNo")));
	String staffSex = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffSex")));
	String staffCardNo = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffCardNo")));
	String birthdayMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("birthdayMin")));
	String birthdayMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("birthdayMax")));
	
	String ageMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("ageMin")));
	String ageMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("ageMax")));
	String staffNationality = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffNationality")));
	String staffNativePlace = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffNativePlace")));
	String workType = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("workType")));
	String staffDomicilePlace = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffDomicilePlace")));
	String staffMaritalStatus = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffMaritalStatus")));
	String staffHealth = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffHealth")));
	String staffPoliticalStatus = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffPoliticalStatus")));
	String administrationLevel = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("administrationLevel")));
	
	String staffOccupation = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffOccupation")));
	String computerLevel = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("computerLevel")));
	String staffHighestSchool = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffHighestSchool")));
	String staffHighestDegree = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffHighestDegree")));
	String staffMajor = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("staffMajor")));
	String graduationSchool = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("graduationSchool")));
	String jobPosition = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("jobPosition")));
	String presentPosition = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("presentPosition")));
	String graduationMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("graduationMin")));
	String graduationMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("graduationMax")));
	
	String joinPartyMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("joinPartyMin")));
	String joinPartyMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("joinPartyMax")));
	String beginningMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("beginningMin")));
	String beginningMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("beginningMax")));
	String employedMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("employedMin")));
	String employedMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("employedMax")));
	String workAgeMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("workAgeMin")));
	String workAgeMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("workAgeMax")));
	String jobAgeMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("jobAgeMin")));
	String jobAgeMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("jobAgeMax")));
	
	
	String leaveTypeMin = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("leaveTypeMin")));
	String leaveTypeMax = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("leaveTypeMax")));
	String foreignLanguage1 = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("foreignLanguage1")));
	String foreignLanguage2 = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("foreignLanguage2")));
	String foreignLanguage3 = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("foreignLanguage3")));
	String foreignLevel1 = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("foreignLevel1")));
	String foreignLevel2 = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("foreignLevel2")));
	String foreignLevel3 = YHUtility.encodeSpecial(YHUtility.null2Empty(request.getParameter("foreignLevel3")));


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>????????????</title>
<link  rel="stylesheet"  href  =  "<%=cssPath%>/cmp/ExchangeSelect.css">
<link  rel="stylesheet"  href  ="<%=cssPath%>/style.css">
<script  type="text/Javascript"  src="<%=contextPath%>/core/js/datastructs.js"  ></script>
<script  type="text/Javascript"  src="<%=contextPath%>/core/js/sys.js"  ></script>
<script  type="text/Javascript"  src="<%=contextPath%>/core/js/prototype.js"  ></script>
<script  type="text/Javascript"  src="<%=contextPath%>/core/js/smartclient.js"  ></script>
<script  type="text/Javascript"  src="<%=contextPath%>/core/js/cmp/ExchangeSelect1.0.js"  ></script>
<script type="text/javascript">
var selectbox;

var param = "";
param = "staffDept=" + encodeURIComponent("<%=staffDept%>");
param += "&staffName=" + encodeURIComponent("<%=staffName%>");
param += "&staffEName=" + encodeURIComponent("<%=staffEName%>");
param += "&workStatus=" + encodeURIComponent("<%=workStatus%>");
param += "&staffNo=" + encodeURIComponent("<%=staffNo%>");
param += "&workNo=" + encodeURIComponent("<%=workNo%>");
param += "&staffSex=" + encodeURIComponent("<%=staffSex%>");
param += "&staffCardNo=" + encodeURIComponent("<%=staffCardNo%>");
param += "&birthdayMin=" + encodeURIComponent("<%=birthdayMin%>");
param += "&birthdayMax=" + encodeURIComponent("<%=birthdayMax%>");

param += "&ageMin=" + encodeURIComponent("<%=ageMin%>");
param += "&ageMax=" + encodeURIComponent("<%=ageMax%>");
param += "&staffNationality=" + encodeURIComponent("<%=staffNationality%>");
param += "&staffNativePlace=" + encodeURIComponent("<%=staffNativePlace%>");
param += "&workType=" + encodeURIComponent("<%=workType%>");
param += "&staffDomicilePlace=" + encodeURIComponent("<%=staffDomicilePlace%>");
param += "&staffMaritalStatus=" + encodeURIComponent("<%=staffMaritalStatus%>");
param += "&staffHealth=" + encodeURIComponent("<%=staffHealth%>");
param += "&staffPoliticalStatus=" + encodeURIComponent("<%=staffPoliticalStatus%>");
param += "&administrationLevel=" + encodeURIComponent("<%=administrationLevel%>");

param += "&staffOccupation=" + encodeURIComponent("<%=staffOccupation%>");
param += "&computerLevel=" + encodeURIComponent("<%=computerLevel%>");
param += "&staffHighestSchool=" + encodeURIComponent("<%=staffHighestSchool%>");
param += "&staffHighestDegree=" + encodeURIComponent("<%=staffHighestDegree%>");
param += "&staffMajor=" + encodeURIComponent("<%=staffMajor%>");
param += "&graduationSchool=" + encodeURIComponent("<%=graduationSchool%>");
param += "&jobPosition=" + encodeURIComponent("<%=jobPosition%>");
param += "&presentPosition=" + encodeURIComponent("<%=presentPosition%>");
param += "&graduationMin=" + encodeURIComponent("<%=graduationMin%>");
param += "&graduationMax=" + encodeURIComponent("<%=graduationMax%>");

param += "&joinPartyMin=" + encodeURIComponent("<%=joinPartyMin%>");
param += "&joinPartyMax=" + encodeURIComponent("<%=joinPartyMax%>");
param += "&beginningMin=" + encodeURIComponent("<%=beginningMin%>");
param += "&beginningMax=" + encodeURIComponent("<%=beginningMax%>");
param += "&employedMin=" + encodeURIComponent("<%=employedMin%>");
param += "&employedMax=" + encodeURIComponent("<%=employedMax%>");
param += "&workAgeMin=" + encodeURIComponent("<%=workAgeMin%>");
param += "&workAgeMax=" + encodeURIComponent("<%=workAgeMax%>");
param += "&jobAgeMin=" + encodeURIComponent("<%=jobAgeMin%>");
param += "&jobAgeMax=" + encodeURIComponent("<%=jobAgeMax%>");

param += "&leaveTypeMin=" + encodeURIComponent("<%=leaveTypeMin%>");
param += "&leaveTypeMax=" + encodeURIComponent("<%=leaveTypeMax%>");
param += "&foreignLanguage1=" + encodeURIComponent("<%=foreignLanguage1%>");
param += "&foreignLanguage2=" + encodeURIComponent("<%=foreignLanguage2%>");
param += "&foreignLanguage3=" + encodeURIComponent("<%=foreignLanguage3%>");
param += "&foreignLevel1=" + encodeURIComponent("<%=foreignLevel1%>");
param += "&foreignLevel2=" + encodeURIComponent("<%=foreignLevel2%>");
param += "&foreignLevel3=" + encodeURIComponent("<%=foreignLevel3%>");



function doInit(){
	selected = [];
	disSelected = [{value:'staffName',text:'??????'},
	 	          	{value:'staffEName',text:'?????????'},
	 	          	{value:'deptId',text:'??????'},
	 	          	{value:'staffSex',text:'??????'},
	 	          	{value:'staffNo',text:'??????'},
	 	          	{value:'workNo',text:'??????'},
	 	          	{value:'staffCardNo',text:'???????????????'},
	 	          	{value:'staffBirth',text:'????????????'},
	 	          	{value:'staffAge',text:'??????'},
	 	          	{value:'staffNativePlace',text:'??????'},
	 	          	{value:'staffNationality',text:'??????'},
	 	          	{value:'staffMaritalStatus',text:'????????????'},
	 	          	{value:'staffPoliticalStatus',text:'????????????'},
	 	          	{value:'workStatus',text:'????????????'},
	 	          	{value:'joinPartyTime',text:'????????????'},
	 	          	{value:'staffPhone',text:'????????????'},
	 	          	{value:'staffMobile',text:'????????????'},
	 	          	{value:'staffLittleSmart',text:'?????????'},
	 	          	{value:'staffMsn',text:'MSN'},
	 	          	{value:'staffQq',text:'QQ'},
	 	          	{value:'staffEmail',text:'????????????'},
	 	          	{value:'homeAddress',text:'????????????'},
	 	          	{value:'jobBeginning',text:'??????????????????'},
	 	          	{value:'otherContact',text:'??????????????????'},
	 	          	{value:'workAge',text:'?????????'},
	 	          	{value:'staffHealth',text:'????????????'},
	 	          	{value:'staffDomicilePlace',text:'???????????????'},
	 	          	{value:'staffType',text:'????????????'},
	 	          	{value:'datesEmployed',text:'????????????'},
	 	          	{value:'staffHighestSchool',text:'??????'},
	 	          	{value:'staffHighestDegree',text:'??????'},
	 	          	{value:'graduationDate',text:'????????????'},
	 	          	{value:'staffMajor',text:'??????'},
	 	          	{value:'graduationSchool',text:'????????????'},
	 	          	{value:'computerLevel',text:'???????????????'},
	 	          	{value:'foreignLanguage1',text:'????????????1'},
	 	          	{value:'foreignLanguage2',text:'????????????2'},
	 	          	{value:'foreignLanguage3',text:'????????????3'},
	 	          	{value:'foreignLevel1',text:'????????????1'},
	 	          	{value:'foreignLevel2',text:'????????????2'},
	 	          	{value:'foreignLevel3',text:'????????????3'},
	 	          	{value:'staffSkills',text:'??????'},
	 	          	{value:'workType',text:'??????'},
	 	          	{value:'administrationLevel',text:'????????????'},
	 	          	{value:'staffOccupation',text:'????????????'},
	 	          	{value:'jobPosition',text:'??????'},
	 	          	{value:'presentPosition',text:'??????'},
	 	          	{value:'jobAge',text:'???????????????'},
	 	          	{value:'beginSalsryTime',text:'????????????'},
	 	          	{value:'leaveType',text:'?????????'},
	 	          	{value:'resume',text:'??????'},
	 	          	{value:'surety',text:'????????????'},
	 	          	{value:'certificate',text:'????????????'},
	 	          	{value:'insure',text:'??????????????????'},
	 	          	{value:'bodyExamim',text:'????????????'},
	 	          	{value:'remark',text:'??? ???'}
	 	          
 	];
	new ExchangeSelectbox({containerId:'selectItemDiv' 
		,selectedArray:selected 
		,disSelectedArray:disSelected 
		,isOneLevel:false 
		 ,isSort:true
		,selectedChange:exchangeHandler 
		});

	
}
function exchangeHandler(ids){ 
	//alert(ids);
	if(ids){
		$("fieldName").value = ids;
	}
	
}
function exreport(){
	//var query = $("form1").serialize();
	//alert($("fieldName").value);
	var selectValue = $("fieldName").value;
	location.href = "<%=contextPath%>/yh/subsys/oa/hr/manage/staffInfo/act/YHHrStaffInfoQueryAct/exportToCSV.act?" + param + "&selectValue=" + selectValue;
	//var url = "<%=contextPath%>/yh/subsys/oa/hr/manage/staffInfo/act/YHHrStaffInfoQueryAct.act?" + param + "&selectValue=" + selectValue;
	//alert(url);
	
}


</script>
</head>
<body onload="doInit();">

<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/send.gif" width="18" HEIGHT="18"><span class="big3"> ??????EXCEL????????????</span>
    </td>
  </tr>
</table>
<br>


<form action="" method="post" name="form1" id="form1">
 <table align="center" width="95%" class="TableBlock">

     <tr>
      <td nowrap class="TableHeader" colspan="4">
         <img src="<%=imgPath %>/green_arrow.gif"> &nbsp;????????????
      </td>
    </tr>
  <tr>
  <td nowrap class="TableData" colspan="4" align="center"><br>
  	<div id="selectItemDiv"></div>
</td>
  </tr>
    <tfoot align="center" class="TableFooter">
    <td nowrap colspan="4" align="center">
        <input type="reset" value="??????" class="BigButton" onClick="exreport()">&nbsp;&nbsp;
        <input type="button" value="??????" class="BigButton" onClick="window.location.href='<%=contextPath %>/subsys/oa/hr/manage/query/query.jsp';">
        <input type="hidden" name="fieldName" id="fieldName" value="">
      </td>
    </tfoot>
  </table>
</form>





</body>
</html>