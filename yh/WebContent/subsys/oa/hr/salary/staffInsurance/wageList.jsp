<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
	<%@ page  import="yh.subsys.oa.hr.salary.insurancePara.salItem.data.*"%> 
	<%@ page  import="yh.subsys.oa.hr.salary.submit.data.*"%> 
	
<%@ page  import="java.util.List"%>
<%@ page  import="java.util.Map"%>

<html>
<head>
<%
 String personNum="0"; 
 String deptId= request.getParameter("deptId");
 if(deptId == null){
	  deptId="";
 }
 List<YHSalItem> listSalItem = (List<YHSalItem>)request.getAttribute("listSalItem");
 String title = "";
 for(int i=0; i<listSalItem.size(); i++){
	    title += "S" + listSalItem.get(i).getSlaitemId() + ",";
	  }
 int count =0;
 int count1 =0;
 int yesOther =0;
 yesOther = (Integer)request.getAttribute("yesOtherId");
 List<YHSalPerson> listPerson = (List<YHSalPerson>)request.getAttribute("listPerson");
 List<Map> listSalItemData = (List<Map>)request.getAttribute("listSalItemData");
 String slaItemId = (String)request.getAttribute("slaItemId");
 
 
 YHHrInsurancePara insurance = null;
 double pensionPPay = 0.00;
 double pensionPPayAdd = 0.00;
 double pensonUPay = 0.00;
 double pensonUPayAdd = 0.00;
 double healthPPay = 0.00;
 double healthPPayAdd = 0.00;
 double healthUPPay =0.00;
 double healthUPPayAdd =0.00;
 double unemploymentPPay =0.00;
 double unemploymentPPayAdd =0.00;
 double unemploymentUPay =0.00;
 double unemploymentUPayAdd =0.00;
 double housingPPay =0.00;
 double housingPPayAdd =0.00;
 double housingUPay =0.00;
 double housingUPayAdd =0.00;
 double injuryUPay=0.00;
 double injuryUPayAdd=0.00;
 double maternityUPay = 0.00;
 double maternityUPayAdd = 0.00;

 List<YHHrInsurancePara> insuranceList = (List<YHHrInsurancePara>)request.getAttribute("hrInsurancePara");
 if(insuranceList!=null && insuranceList.size()>0){
	   insurance = insuranceList.get(0);
	   pensionPPay = insurance.getPensionPPay();
	   pensionPPayAdd = insurance.getPensionPPayAdd();
	   pensonUPay = insurance.getPensionUPay();
	   pensonUPayAdd = insurance.getPensionUPayAdd();
	   healthPPay = insurance.getHealthPPay();
	   healthPPayAdd = insurance.getHealthPPayAdd();
	   healthUPPay = insurance.getHealthUPay();
	   healthUPPayAdd = insurance.getHealthUPayAdd();
	   unemploymentPPay = insurance.getUnemploymentPPay();
	   unemploymentPPayAdd = insurance.getUnemploymentPPayAdd();
	   unemploymentUPay = insurance.getUnemploymentUPay();
	   unemploymentUPayAdd = insurance.getUnemploymentUPayAdd();
	   housingPPay =insurance.getHousingPPay();
	   housingPPayAdd =insurance.getHousingPPayAdd();
	   housingUPay =insurance.getHousingUPay();
	   housingUPayAdd =insurance.getHousingUPayAdd();
	   injuryUPay =insurance.getInjuryUPay();
	   injuryUPayAdd = insurance.getInjuryUPayAdd();
	   maternityUPay = insurance.getMaternityUPay();
	   maternityUPayAdd = insurance.getMaternityUPayAdd();
	   //yesOther = insurance.getYesOther();
	}
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
<script type="text/javascript">
function goto(){
		window.location.href= contextPath + "/yh/subsys/oa/hr/salary/insurancePara/salItem/act/YHSalaryItemAct/getSalaryItemJson.act";
	}
function doSubmit(){
	 var itemName = $("ITEM_NAME").value;
	 if(itemName.replaceAll(" ","") == "" || itemName == "null"){
	      alert("??????????????????????????????");
	      return false;
   }
	 $("form1").submit();
}
function doInit(){
	var temp ="deptId="+<%=deptId%>;
	var url = "<%=contextPath %>/yh/subsys/oa/hr/salary/staffInsurance/act/YHWageBaseSetAct/wageBaseSetAct.act";
	var rtJson = getJsonRs(url,temp);
    if(rtJson.rtState == "1"){
		alert(rtJson.rtMsrg);
		return;
	}
  var personNum1 = rtJson.rtData.data;
  $('person').innerHTML = personNum1+"???";//????????????????????????
	//alert(personNum1);
  whereDeptId();//??????????????????	
  notEnglish();//????????????????????? ??????
}
function notEnglish() {
	
	$$('input').each(function(e, i) {// ??????Html???????????????????????????
		if (e.type != 'text') {
	    return;
	  }
		e.onkeyup = function() {//?????????????????????????????? ??????  ??????????????????????????????
		    var data = e.value;
		    if(isNaN(data)){
		    	e.value = '';
	       return;
		   }
	    return;
	  }
  });
}
function whereDeptId(){
  var temp ="deptId="+<%=deptId%>;	
  var url = "<%=contextPath %>/yh/subsys/oa/hr/salary/staffInsurance/act/YHWageBaseSetAct/whereDeptIdAct.act";
  var rtJson = getJsonRs(url,temp);
  var dataObj=eval(rtJson);
  if(rtJson.rtState == "1"){
		alert(rtJson.rtMsrg);
		return;
	}
	var deptIds = rtJson.rtData.data;
	$('deptID').innerHTML = "["+deptIds+"]";
}
function calculate(){
	var tabObj = document.getElementById("cal_table");    
	 var rowCount = tabObj.rows.length; 
	 var cellCount = tabObj.rows(0).cells.length;
	 for(var i=1;i < rowCount ;i++)    
	 {   
		 var objAllbase = document.getElementById("ALL_BASE_"+i);
		 if(objAllbase){
		//??????  
	   	  var ALL_BASE = parseFloat(eval("document.getElementById('ALL_BASE_"+i+"')").value);
	   	  var PENSION_U=ALL_BASE * <%=pensonUPay%>/ 100 +<%=pensonUPayAdd%>;
	   	  var PENSION_P=ALL_BASE * <%=pensionPPay%>/ 100 + <%=pensionPPayAdd%>;
	   	  eval("document.getElementById('PENSION_U_"+i+"')").value=FormatNumber(PENSION_U,2);
	      eval("document.getElementById('PENSION_P_"+i+"')").value=FormatNumber(PENSION_P,2);
	   	  eval("document.getElementById('PENSION_BASE_"+i+"')").value = FormatNumber(PENSION_U + PENSION_P,2);
	   	 //??????
	   	  var MEDICAL_U=ALL_BASE * <%=healthUPPay%> / 100 + <%=healthUPPayAdd%>;
	   	  var MEDICAL_P=ALL_BASE * <%=healthPPay%> / 100 + <%=healthPPayAdd%>;
	   	  eval("document.getElementById('MEDICAL_U_"+i+"')").value=FormatNumber(MEDICAL_U,2);
	   	  eval("document.getElementById('MEDICAL_P_"+i+"')").value=FormatNumber(MEDICAL_P,2);
	   	  eval("document.getElementById('MEDICAL_BASE_"+i+"')").value = FormatNumber(MEDICAL_U + MEDICAL_P,2);
	   	  //??????
	   	  var MATERNITY_U=ALL_BASE * <%=maternityUPay%> / 100 + <%=maternityUPayAdd%>;
	   	  eval("document.getElementById('FERTILITY_U_"+i+"')").value=FormatNumber(MATERNITY_U,2);
	   	  eval("document.getElementById('FERTILITY_BASE_"+i+"')").value = FormatNumber(MATERNITY_U,2);
	   	//??????
	   	  var UNEMPLOYMENT_U=ALL_BASE * <%=unemploymentUPay%> / 100 +<%=unemploymentUPayAdd%> ;
	   	  var UNEMPLOYMENT_P=ALL_BASE * <%=unemploymentPPay%> / 100 + <%=unemploymentPPayAdd%>;
	   	  eval("document.getElementById('UNEMPLOYMENT_U_"+i+"')").value=FormatNumber(UNEMPLOYMENT_U,2);
	   	  eval("document.getElementById('UNEMPLOYMENT_P_"+i+"')").value=FormatNumber(UNEMPLOYMENT_P,2);
	   	  eval("document.getElementById('UNEMPLOYMENT_BASE_"+i+"')").value = FormatNumber(UNEMPLOYMENT_U + UNEMPLOYMENT_P,2);
	   	 //??????
	   	  var INJURIES_U=ALL_BASE * <%=injuryUPay%> / 100 + <%=injuryUPayAdd%>;
	   	  eval("document.getElementById('INJURIES_U_"+i+"')").value=FormatNumber(INJURIES_U,2);
	   	  eval("document.getElementById('INJURIES_BASE_"+i+"')").value = FormatNumber(INJURIES_U,2);
	   	 //???????????????
	   	  var HOUSING_U=ALL_BASE * <%=housingUPay%> / 100 + <%=housingUPayAdd%>;
	   	  var HOUSING_P=ALL_BASE * <%=housingPPay%> / 100 + <%=housingPPayAdd%>;
	   	  eval("document.getElementById('HOUSING_U_"+i+"')").value=FormatNumber(HOUSING_U,2);
	   	  eval("document.getElementById('HOUSING_P_"+i+"')").value=FormatNumber(HOUSING_P,2);
	   	  eval("document.getElementById('HOUSING_BASE_"+i+"')").value = FormatNumber(HOUSING_U + HOUSING_P,2);  
		 }else{
         return;
			 } 	
	 }
}
function FormatNumber(srcStr,nAfterDot)
{ 
   var srcStr,nAfterDot; 
   var resultStr,nTen; 
   srcStr = ""+srcStr+""; 
   strLen = srcStr.length; 
   dotPos = srcStr.indexOf("."); 
   if(dotPos == -1)
   { 
      resultStr = srcStr+"."; 
      for(i=0;i<nAfterDot;i++)
      { 
         resultStr = resultStr+"0"; 
      } 
      //return resultStr;
      return resultStr=="NaN.00"?"":resultStr;  
   }else{ 
      if((strLen - dotPos - 1) >= nAfterDot)
      { 
         nAfter = dotPos + nAfterDot + 1; 
         nTen =1; 
         for(j=0;j<nAfterDot;j++)
         { 
            nTen = nTen*10; 
         } 
         resultStr = Math.round(parseFloat(srcStr)*nTen)/nTen; 
         //return resultStr;
         return resultStr=="NaN.00"?"":resultStr;
      }else{ 
         resultStr = srcStr; 
         for(i=0;i<(nAfterDot - strLen + dotPos + 1);i++)
         { 
            resultStr = resultStr+"0"; 
         } 
         //return resultStr; 
         return resultStr=="NaN.00"?"":resultStr;
      } 
   } 
}
function doSubmit(){
	var pars = Form.serialize($('form1')); 
	var url = "<%=contextPath%>/yh/subsys/oa/hr/salary/staffInsurance/act/YHWageBaseSetAct/setSubmitInfo.act"; 
	var json = getJsonRs(url,pars); 
	if(json.rtState == "0"){ 
		alert("?????????????????????"); 
	}else{ 
	  alert("??????????????????"); 
	}
}
</script>
</head>
<body topmargin="5" class="bodycolor" onload="doInit();">
<form enctype="multipart/form-data" action="<%=contextPath%>/yh/subsys/oa/hr/salary/staffInsurance/act/YHWageBaseSetAct/addWageBaseAct.act" method="post" name="form1" id="form1">
<table cellspacing="0" cellpadding="3" border="0" width="100%" class="small">
  <input type="hidden" id="total" name="total" value="<%=listPerson.size()==0?0:listPerson.size()%>">
  <input type="hidden" id="title" name="title" value="<%=title%>">
	 <tbody>
		 <tr>
			 <td class="Big">
			    	<img align="absmiddle" src="<%=imgPath %>/notify_open.gif"><span class="big3"> <a name="bottom"><span id="deptID"></span>????????????????????????- <span id="person"></span></a></span>
			    	<a name="bottom"></a>
			    	<div style="width:150px; top:5px; right:20px; position:absolute; left:695px;" id="OP_BTN" name="OP_BTN">
				      <a name="bottom">   
					    	<input type="button" onclick="calculate()" class="BigButtonA" value="??????">
					      <input type="button" title="??????" class="BigButtonA" value="??????" class="BigButton" name="button" onclick="doSubmit();">
				      </a>
			     </div>
			  <a name="bottom"></a>
			</td>
		</tr>
	</tbody>
</table>
<%
  String[] params = null;
%>
<table align="center" id="cal_table" class="TableBlock">
	 <tbody>
	  <tr align="center" class="TableHeader">
	    <td nowrap="" width="100px"><b>??????</b></td>
	    <%if(listSalItem!=null && listSalItem.size()>0){
	    	params = new String[listSalItem.size()];
	    	 for(int i=0; i<listSalItem.size(); i++){%>  
	    <td nowrap="" width="100px" align="center" style="cursor:pointer" onclick=""><b><%=listSalItem.get(i).getItemName() %></b>
	    </td>
	    <input type="hidden" name="userNames" id="<%=listSalItem.get(i).getSlaitemId() %>" value="<%=listSalItem.get(i).getSlaitemId()%>">
	    <%}
	    	 count ++;
	    }%>
	    <%if(yesOther==1){ %>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>???????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>
	      <td nowrap="" align="center" style=""><b>????????????</b></td>      
	    </tr>
	    <%} %>
	    <%
	    String userNameId="";
	    String userName ="";
	    int userId;
	    if(listPerson!=null && listPerson.size()>0){ 
	    	//System.out.println(listPerson.size());
	     for(int i = 0; i < listPerson.size(); i++){
	        userName	= listPerson.get(i).getUserName();
	        userId = listPerson.get(i).getUserId();
	        	  count1 ++;
	        %>
	  <tr align="center" class="TableLine1">
      <td nowrap="" ><%=listPerson.get(i).getUserName() %>
         <input type="hidden" id="sdId_<%=i %>" name="seqId_<%=i %>" value="<%=listPerson.get(i).getSdId() %>">
         <input type="hidden" id="hsdId_<%=i %>" name="seqId_<%=i %>" value="<%=listPerson.get(i).getHsdId() %>">
         <input type="hidden" id="userId_<%=i %>" name="userId_<%=i %>" value="<%=listPerson.get(i).getUserId() %>">
         <input type="hidden" id="userName_<%=i %>" name="userName_<%=i %>" value="<%=listPerson.get(i).getUserName() %>">
      </td>
        <%  List<String> slist = listPerson.get(i).getSlist();
            Map<String,Double> smap = listPerson.get(i).getSmap();
            for(int j = 0; j < slist.size(); j++){//???????????????????????????????????????
              String s = (String)slist.get(j);//s??????s1-s50 ?????????
              double value = smap.get(s) == null ? 0.00 : smap.get(s);//??????????????? map??????s????????????
              %>
              <!-- //???????????????titleList[j]???????????????????????????S1-S50  ????????? '_i' ????????????????????????????????????????????? -->
         <td nowrap="" align="center"><input type="text" size="10" value="<%=value %>" class="SmallInput" name="<%=s %>_<%=i %>" id="<%=s %>_<%=i %>" style="text-align: right;"></td>   
          <%} %> 
        
	     <%if(yesOther==1){ %>	 
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getAllBase() %>" class="SmallInput" name="<%=userName %>_ALL_BASE" id="ALL_BASE_<%=count1 %>" style="text-align: right;"> </td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getPensionBase() %>" class="SmallInput" name="<%=userName %>_PENSION_BASE" id="PENSION_BASE_<%=count1 %>" style="text-align: right;"> </td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getPensionU() %>" class="SmallInput" name="<%=userName %>_PENSION_U" id="PENSION_U_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getPensionP() %>" class="SmallInput" name="<%=userName %>_PENSION_P" id="PENSION_P_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getMedicalBase() %>" class="SmallInput" name="<%=userName %>_MEDICAL_BASE" id="MEDICAL_BASE_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getMedicalU() %>" class="SmallInput" name="<%=userName %>_MEDICAL_U" id="MEDICAL_U_<%=count1 %>" style="text-align: right;"></td>                   
		  	  <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getMedicalP() %>" class="SmallInput" name="<%=userName %>_MEDICAL_P" id="MEDICAL_P_<%=count1 %>" style="text-align: right;"> </td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getFertilityBase() %>" class="SmallInput" name="<%=userName %>_FERTILITY_BASE" id="FERTILITY_BASE_<%=count1 %>" style="text-align: right;"> </td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getFertilityU() %>" class="SmallInput" name="<%=userName %>_FERTILITY_U" id="FERTILITY_U_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getUnemploymentBase() %>" class="SmallInput" name="<%=userName %>_UNEMPLOYMENT_BASE" id="UNEMPLOYMENT_BASE_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getUnemploymentU() %>" class="SmallInput" name="<%=userName %>_UNEMPLOYMENT_U" id="UNEMPLOYMENT_U_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getUnemploymentP() %>" class="SmallInput" name="<%=userName %>_UNEMPLOYMENT_P" id="UNEMPLOYMENT_P_<%=count1 %>" style="text-align: right;"></td>                   
		  	  <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getInjuriesBase() %>" class="SmallInput" name="<%=userName %>_INJURIES_BASE" id="INJURIES_BASE_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getInjuriesU() %>" class="SmallInput" name="<%=userName %>_INJURIES_U" id="INJURIES_U_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getHousingBase() %>" class="SmallInput" name="<%=userName %>_HOUSING_BASE" id="HOUSING_BASE_<%=count1 %>" style="text-align: right;"></td>                   
		  	 <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getHousingU() %>" class="SmallInput" name="<%=userName %>_HOUSING_U" id="HOUSING_U_<%=count1 %>" style="text-align: right;"></td>                   
		     <td nowrap="" align="center"><input type="text" size="10" value="<%=listPerson.get(i).getHousingP() %>" class="SmallInput" name="<%=userName %>_HOUSING_P" id="HOUSING_P_<%=count1 %>" style="text-align: right;"></td>                      
	  	<%} %>
	  	
	     </tr>
	      <%
	     } %>
  <% }%>        
	</tbody>
</table>
<br>
<div align="center">
</div>
</form>
</body>
</html>