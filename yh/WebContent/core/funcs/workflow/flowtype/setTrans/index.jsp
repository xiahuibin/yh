<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.core.funcs.person.data.YHPerson,yh.core.funcs.workflow.util.YHWorkFlowUtility" %>
<%
YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
String userPrivOther  = loginUser.getUserPrivOther();
boolean isAdmin = false;
if (loginUser.isAdminRole() 
    || YHWorkFlowUtility.findId(userPrivOther , "1")){
  isAdmin = true;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" href = "<%=cssPath %>/style.css">
<link rel="stylesheet" href = "<%=cssPath %>/cmp/Calendar.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/orgselect.js"></script>
 <script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript">
function check_all()
{
   var STR;
   for(var i=0;i<document.form1.flowId.options.length;i++)
   {
     document.form1.flowId.options[i].selected = true;
     STR+=document.form1.flowId.options[i].value+",";
   }
   document.form1.flowIdStr.value=STR;
}

function cancel_all()
{
   for(var i=0;i<document.form1.flowId.options.length;i++)
           document.form1.flowId.options[i].selected = false;
   document.form1.flowIdStr.value="";
}
function doInit(){
  loadFlowType();
  var beginParameters = {
      inputId:'beginDate',
      property:{isHaveTime:false}
      ,bindToBtn:'beginDateImg'
  };
  new Calendar(beginParameters);
  var endParameters = {
      inputId:'endDate',
      property:{isHaveTime:false}
      ,bindToBtn:'endDateImg'
  };
  new Calendar(endParameters);
}
//????????????
function loadFlowType(){
  var url = contextPath+'/yh/core/funcs/workflow/act/YHFlowTypeAct/getFlowTypeJson.act';
  var json = getJsonRs(url);
  var rtData = json.rtData;   
  for(var i = 0 ;i < rtData.length ; i ++) {      
    var opt = document.createElement("option") ;      
    opt.value = rtData[i].seqId ;      
    opt.innerHTML = rtData[i].flowName ;      
    $('flowId').appendChild(opt) ;                        
  }    
} 
function CheckForm(){
   var STR="";
   for(var i=0;i<document.form1.flowId.options.length;i++)
   {
     if(document.form1.flowId.options[i].selected == true)
       STR+=document.form1.flowId.options[i].value+",";
   }
   document.form1.flowIdStr.value=STR;
   if(document.form1.flowIdStr.value=="")
   {
     alert("?????????????????????!");
     return (false);
   }
   if(document.form1.userId.value=="")
   { alert("????????????????????????!");
     return (false);
   }
   if(document.form1.toId.value=="")
   { alert("????????????????????????!");
     return (false);
   }
   var beginDate = document.getElementById('beginDate');
   var endDate = document.getElementById("endDate");  
   var endRun =  document.getElementById("endRun").value;
   var beginRun =  document.getElementById("beginRun").value;
 
   if(isNaN(endRun) || isNaN(beginRun) ){
     alert("????????????????????????!!");
     return false;
   } else {
     if (beginRun && endRun && parseInt(beginRun) > parseInt(endRun)) {
       alert("??????????????????????????????????????????!");
     }
   }
   
   var beginInt;
   var endInt;
   var beginArray = beginDate.value.split("-");
   var endArray = endDate.value.split("-");
   for(var i = 0 ; i<beginArray.length; i++){
     beginInt = parseInt(" " + beginArray[i]+ "",10);  
     endInt = parseInt(" " + endArray[i]+ "",10);
     if((beginInt - endInt) > 0){
       alert("????????????????????????????????????!");
       endDate.focus();
       endDate.select();
       return false;
     }else if(beginInt - endInt<0){
       break;
     }  
   }
   var url = contextPath+'/yh/core/funcs/workflow/act/YHFlowTypeCorAct/trans.act';
   var json = getJsonRs(url , $('form1').serialize());
   if (json.rtState ==  '0') {
     alert('???????????????');
     $('form1').reset();
   }
}
</script>
</head>
<body onload="doInit()">
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath %>/notify_new.gif" align="absmiddle"><span class="big3"> ????????????</span>
    </td>
  </tr>
</table>

<form   method="post" name="form1"  id="form1">
<table width="450" class="TableList" cellpadding="3" align="center" >
   <tr>
    <td nowrap class="TableContent">???????????????</td>
    <td nowrap class="TableData">
   <select type="multiple" name="flowId" id="flowId" Multiple style="width:280px;height:200px;">
    </select>
    <BR>
  <input type="button" class="SmallButton" value="??????" name="CHECK_ALL" id="CHECK_ALL" onclick="check_all();">
  <input type="button" class="SmallButton" value="??????" name="CANCEL_ALL" id="CHECK_ALL" onclick="cancel_all();">&nbsp;??????Ctrl?????????
    </td>
   </tr>
<% 
if (isAdmin) {
%>
   <tr>
    <td nowrap class="TableContent">???????????????</td>
    <td nowrap class="TableData">
    <input type="text" class="SmallInput" size=20 readOnly name="USER_NAME" id="USER_NAME">
    <INPUT type="hidden" name="userId" id="userId">
    <a href="javascript:;" class="orgAdd" onClick="selectSingleUser(['userId', 'USER_NAME'])">??????</a>
    <a href="javascript:;" class="orgClear" onClick="$('userId').value='';$('USER_NAME').value='';">??????</a>
    </td>
   </tr>
<%} %>
   <tr>
    <td nowrap class="TableContent">???????????????</td>
    <td nowrap class="TableData">
    <input type="text" class="SmallInput" size=20 readOnly name="TO_NAME" id="TO_NAME">
    <INPUT type="hidden" name="toId" id="toId">
    <a href="javascript:;" class="orgAdd" onClick="selectSingleUser(['toId', 'TO_NAME'])">??????</a>
    <a href="javascript:;" class="orgClear" onClick="$('toId').value='';$('TO_NAME').value='';">??????</a>
    </td>
   </tr>
   <tr>
      <td nowrap class="TableContent"> ???????????????</td>
      <td class="TableData">
        ??????<input type="text" name="beginDate" id="beginDate" size="10" maxlength="10" class="BigInput" readonly>
        <img id="beginDateImg" src="<%=imgPath %>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer" onclick="">
        ??????<input type="text" name="endDate" id="endDate" size="10" maxlength="10" class="BigInput" readonly>
        <img id="endDateImg"  src="<%=imgPath %>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer" onclick="">
      </td>
    </tr>
   <tr>
      <td nowrap class="TableContent"> ??????????????????</td>
      <td class="TableData">
        ??????<input type="text" name="beginRun" id="beginRun" size="6" maxlength="10" class="BigInput">
        ??????<input type="text" name="endRun"  id="endRun" size="6" maxlength="10" class="BigInput">
      </td>
    </tr>
    <td nowrap  class="TableFooter" colspan="2" align="center">
        <input type="hidden" name="flowIdStr" id="flowIdStr">
        <input type="button"  value="????????????" class="BigButton" onclick="CheckForm()" title="????????????">
    </td>
 
</table>
 </form>
</body>
</html>