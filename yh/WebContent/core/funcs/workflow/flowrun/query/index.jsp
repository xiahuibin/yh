<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.core.funcs.person.data.YHPerson" %>
<%
YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
String sortId = request.getParameter("sortId");
if (sortId == null) {
  sortId = "";
}
String sortName = request.getParameter("sortName");
if (sortName == null) {
  sortName = "";
}
String skin = request.getParameter("skin");
String skinJs = "messages";
if (skin != null && !"".equals(skin)) {
  skinJs = "messages_" + skin;
} else {
  skin = "";
}
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href = "<%=cssPath %>/cmp/Calendar.css">
<link rel="stylesheet" href="<%=cssPath %>/page.css">
<link rel="stylesheet" href ="<%=cssPath %>/style.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
 <script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/orgselect.js"></script>
<script type="text/javascript" src="js/index.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/utility.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/page.js"></script>
  <script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/lables/<%=skinJs %>.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/skin.js"></script>
<script type="text/javascript"><!--
 var loginUserId = <%=loginUser.getSeqId()%>;
 var isAdmin = <%=loginUser.isAdmin()%>;
 var isOaAdmin = <%=loginUser.isAdminRole()%>;
 var cfgs = null;
 var pageMgr = null;
 var sortId = "<%=sortId%>";
 var sortName = "<%=sortName%>";
 var skin = "<%=skin%>";
  
 function doQuery(){
   var beginDate = document.getElementById('startTime');
   var endDate = document.getElementById("endTime");  
   var ss =  document.queryForm.runId.value;
  // alert(ss);
   if(isNaN(ss)){
     alert("????????????????????????!!");
     return false;
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
   var header = getHeader();
   var column = getColumn(header);
   cfgs.colums = column;
  // if(!pageMgr){
     pageMgr = new YHJsPage(cfgs);
     pageMgr.show();
     pageMgr.search();
  // }else{
    // pageMgr.search();
  // }
   var total = pageMgr.pageInfo.totalRecord;
   if(total){
     $('listContainer').style.display = "";
     if( $('flowRunOpTab')){
        $('flowRunOpTab').style.display = "";
      }
     $('msrg').style.display = "none";
   }else{
     WarningMsrg('?????????????????????!', 'msrg','info');
     $('msrg').style.display = "";
     if( $('flowRunOpTab')){
       $('flowRunOpTab').style.display = "none";
     }
     $('listContainer').style.display = "none";
   }
 }
 function getHeader() {
   var flowId = $('flowList').value;
   if (flowId != '0') {
     var url = contextPath + "/yh/core/funcs/workflow/act/YHMyWorkAct/getHeader.act?flowId=" + flowId;
     var json = getJsonRs(url);
     if (json.rtState == '0') {
       var header = json.rtMsrg;
       return header;
     }
   } else {
    return "";
   }
 }
 function query() {
   location.href='flowList.jsp?skin='+ skin +'&sortId=' + sortId ;
 }
 function doInit(){
   skinObjectToSpan(flowrun_query_index);
   if (sortName) {
     sortId = getSortIdsByName(sortName);
     $('sortId').value = sortId;
   }
   loadFlowType() ;
   var beginParameters = {
       inputId:'startTime',
       property:{isHaveTime:false}
       ,bindToBtn:'beginDateImg'
   };
   new Calendar(beginParameters);
   var endParameters = {
       inputId:'endTime',
       property:{isHaveTime:false}
       ,bindToBtn:'endDateImg'
   };
   new Calendar(endParameters);
   $('runId').focus();
   var param = getParam();
   var url =  contextPath + "/yh/core/funcs/workflow/act/YHWorkQueryAct/getWorkList1.act";
   var styleself = {background:"#cbe1f5"};
   var columns = getColumn();
   cfgs = {
     dataAction: url,
     container: "listContainer",
     paramFunc: getParam,
     moduleName:"flow",
     showRecordCnt: true,
     colums:columns
   };
}
 
function getColumn(column) {
  var cols =  [
               <% if (loginUser.isAdmin()) { %>
               {type:"selfdef", align:"center", text:"??????", width:"7%",render:checkBoxRender},
               <% } %>
               {type:"data", name:"runId", text:"?????????",width:"8%",render:flowRunIdRender},//,selfStyle:styleself ???????????????????????????
               {type:"data", name:"runName", text:tooltipMsg1, width:"26%",render:flowNameRender}, 
               {type:"data", name:"beginTime", text:"????????????", width:"17%", dataType:"dateTime",format:'yyyy-mm-dd'},
               {type:"hidden", name:"endTime"},
               {type:"hidden", name:"attachId"},
               {type:"hidden", name:"attachName"},
               {type:"selfdef", name:"attach", text:"????????????", width:"17%", render:attachRender},
               {type:"selfdef", name:"status", text:"??????", width:"7%",render:flowStautsRender}];
     if(column) {
       var headers = column.split(",");
       for (var i= 0 ; i< headers.length ; i++) {
         if (headers[i]) {
           cols.push({type:"data", name:headers[i], text:headers[i], width:"5%"});
         }
       }
     }
     cols.push({type:"selfdef", text:"??????",width:"18%", render:opRender});
     cols.push({type:"hidden", name:"flowId"});
     cols.push({type:"hidden", name:"listFldsStr"});
     cols.push({type:"hidden", name:"flowName"});
     cols.push({type:"hidden", name:"freeOther"});
     cols.push({type:"hidden", name:"flowType"});
     cols.push({type:"hidden", name:"manageUser"});
     cols.push({type:"hidden", name:"queryUser"});
     cols.push({type:"hidden", name:"commentPriv"});
     cols.push({type:"hidden", name:"focusUser"});
     cols.push({type:"hidden", name:"editPriv"});
     cols.push({type:"hidden", name:"flowType"});
     cols.push({type:"hidden", name:"manageUserDept"});
     cols.push({type:"hidden", name:"queryUserDept"});
  return cols;
}


 
 --></script>
 
</head>
<body onload="doInit()">
<form  name="queryForm" id="queryForm">
<input type=hidden value="<%=sortId %>" id="sortId" name="sortId"/>
<table id="flowTable" border="0" width="100%"  class="TableList"  >
  <tr class="TableLine1">
  <td align="left"> 
  ?????????  <select name="flowList" onmouseover="this.setStyle({'width':'auto'})" onChange="this.setStyle({'width':'100px'})" id="flowList" style="width:100px">
  <option value="0" id="span1"></option>
  </select>&nbsp;&nbsp;
  
  ?????????<select name="flowStatus" id="flowStatus">
  <option value="ALL">????????????</option>
  <option value="0">????????????</option>
  <option value="1">????????????</option>
  </select>&nbsp;&nbsp;
   ?????????
  <select name="flowQueryType" id="flowQueryType" onchange="setUserChange(this.value)">
  <option value="0">????????????</option>
  <option value="1">????????????</option>
  <option value="2" selected>????????????</option>
  <option value="3" >????????????</option>
  <option value="4" >????????????</option>
  <option value="5" >???????????????</option>
  </select>
  <span id="setUser" style="display:none">
  <INPUT style="VERTICAL-ALIGN: top" class=SmallStatic value="" readOnly size=10 id=toName name=toName>
   <A class=orgAdd onclick="selectSingleUser(['toId' , 'toName'])" href="javascript:;">??????</A> 
   <INPUT value=liuhan type=hidden name=toId id=toId> 
  </span>
  ???  <input type="text" id="startTime" name="startTime" size="10" maxlength="19" readonly class="BigStatic" value="">
  <img id="beginDateImg" src="<%=imgPath %>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
      ???
  <input type="text" id="endTime" name="endTime" size="10" maxlength="19"  readonly class="BigStatic">
  <img id="endDateImg" src="<%=imgPath %>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
  <a href="javascript:empty_date()">??????</a>
    </td> 
  </tr><tr class="TableLine2">
  <td align="left"> 
  ?????????<input type="text" id="runId" name="runId" size="6" class="SmallInput" value="">&nbsp;
    ??????/??????<input type="text" id="runName" name="runName" size="20" class="SmallInput" value="">
    <input id="queryBtn" type="button" class="BigButton" onclick="doQuery()" value="????????????">
  <input id="queryBtn" type="button" title="????????????,??????????????????????????????" class="BigButton" onclick="query()" value="????????????">
    </div>
  </td> 
  </tr>
  </table>
  </form>
  <div style="padding-top:10px"></div>
  
  <div id = "listContainer" style="display:none"> </div>
  <% if (loginUser.isAdmin()) { %>
  <table class="TableBlock no-top-border" border=0 width="100%" style="margin:0;display:none" id="flowRunOpTab" >
  <tr class="TableData">
  <td colspan="10">
 	&nbsp;&nbsp;<input type="checkbox" name="allbox" id="allbox_for" onClick="javascript:checkAll(this);">
  <label for="allbox_for" style="cursor:pointer"><u><b>??????</b></u></label> &nbsp;
   <input type="button"  onclick="exportZip()"  value="??????ZIP" class="BigButton"  title="????????????"> &nbsp;
  <input type="button"  onclick="delWorkFlow()"  value="??????????????????" class="BigButtonC" > &nbsp; 
  <input type="button"  onclick="endWorkFlow()"  value="????????????" class="BigButton"  title="????????????">
  </td>
  </tr>
  </table>
  <% } %>

  <div id="msrg" align=center style="display:none">
  </div>    
</body>
</html>