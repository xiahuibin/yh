<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ include file="/core/funcs/doc/workflowUtility/workflowheader.jsp" %>
<%@ page import="yh.core.funcs.person.data.YHPerson" %>
<%@ page import="yh.core.funcs.doc.receive.data.YHDocConst" %>
<%
YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);

String sortId = request.getParameter("sortId");
if (sortId == null) {
  sortId = "";
}
String webroot = request.getRealPath("/");
String sortName = YHDocConst.getProp(webroot  , YHDocConst.DOC_RECEIVE_FLOW_SORT) ;
if (sortName == null) {
  sortName = "";
}
String skin = "receive";
  //request.getParameter("skin");
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
<script type="text/javascript" src="<%=contextPath %><%=moduleContextPath %>/workflowUtility/utility.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/page.js"></script>
  <script type="text/javascript" src="<%=contextPath %><%=moduleContextPath %>/lables/<%=skinJs %>.js"></script>
<script type="text/javascript" src="<%=contextPath %><%=moduleContextPath %>/workflowUtility/skin.js"></script>
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
   
   if(!pageMgr){
     pageMgr = new YHJsPage(cfgs);
     pageMgr.show();
   }else{
     pageMgr.search();
   }
   var total = pageMgr.pageInfo.totalRecord;
   if(total){
     if( $('flowRunOpTab')){
        $('flowRunOpTab').style.display = "";
      }
   }else{
     if( $('flowRunOpTab')){
       $('flowRunOpTab').style.display = "none";
     }
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
   var url =  contextPath + "/yh/core/funcs/doc/flowrunRec/act/YHWorkQueryAct/getWorkList.act";
 
   var styleself = {background:"#cbe1f5"};

   cfgs = {
     dataAction: url,
     container: "listContainer",
     paramFunc: getParam,
     moduleName:"doc",
     showRecordCnt: true,
     colums: [
       <% if (loginUser.isAdmin()) { %>
        {type:"selfdef", align:"center", text:"??????", width:"7%",render:checkBoxRender},
        <% } %>
        {type:"data", name:"runId", text:"?????????",width:"5%",render:flowRunIdRender},//,selfStyle:styleself ???????????????????????????

        {type:"data", name:"title", text:"??????", width:"26%",render:flowNameRender}, 
        {type:"data", name:"sendDocNo", text:"????????????", width:"5%"}, 
        {type:"data", name:"sendDocNo", text:"????????????", width:"5%"}, 

        {type:"data", name:"beginTime", text:"????????????", width:"17%", dataType:"dateTime",format:'yyyy-mm-dd'},
        {type:"hidden", name:"endTime"},
        {type:"hidden", name:"attachId"},
        {type:"hidden", name:"attachName"},
        {type:"selfdef", name:"attach", text:"????????????", width:"17%", render:attachRender},
        {type:"selfdef", name:"status", text:"??????", width:"7%",render:flowStautsRender},
        {type:"selfdef", text:"??????",width:"18%", render:opRender},
        {type:"hidden", name:"flowId"},
        {type:"hidden", name:"listFldsStr"},
        {type:"hidden", name:"flowName"},
        {type:"hidden", name:"freeOther"},
        {type:"hidden", name:"flowType"},
        {type:"hidden", name:"manageUser"},
        {type:"hidden", name:"queryUser"},
        {type:"hidden", name:"commentPriv"},
        {type:"hidden", name:"focusUser"},
        {type:"hidden", name:"editPriv"},
        {type:"hidden", name:"flowType"},
        {type:"hidden", name:"manageUserDept"},
        {type:"hidden", name:"queryUserDept"}
        ]
   };
 }
 --></script>
 
</head>
<body onload="doInit()">
<form  name="queryForm" id="queryForm">
<input type=hidden value="<%=sortId %>" id="sortId" name="sortId"/>
<table id="flowTable" border="0" width="100%"  class="TableList"  >
  <tr class="TableLine1">
  <td align="left"> 
  ?????????
  <select name="flowList" id="flowList" style="width:100px">
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
  
  ???

  <input type="text" id="startTime" name="startTime" size="10" maxlength="19" readonly class="BigStatic" value="">
  <img id="beginDateImg" src="<%=imgPath %>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
      ???

  <input type="text" id="endTime" name="endTime" size="10" maxlength="19"  readonly class="BigStatic">
  <img id="endDateImg" src="<%=imgPath %>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
  <a href="javascript:empty_date()">??????</a>
    </td> 
  </tr><tr class="TableLine2">
  <td align="left"> 
  ????????????<input type="text" id="runId" name="runId" size="6" class="SmallInput" value="">&nbsp;&nbsp;
    ?????????<input type="text" id="title" name="title" size="20" class="SmallInput" value="">&nbsp;&nbsp;
      ???????????????<input type="text" id="sendDocNo" name="sendDocNo" size="20" class="SmallInput" value="">&nbsp;&nbsp;
      ???????????????<input type="text" id="fromDeptName" name="fromDeptName" size="20" class="SmallInput" value="">
    <input id="queryBtn" type="button" class="BigButton" onclick="doQuery()" value="????????????">
    </div>
  </td> 
  </tr>
  </table>
  </form>
  <div style="padding-top:10px"></div>
  
  <div id = "listContainer"> </div>
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