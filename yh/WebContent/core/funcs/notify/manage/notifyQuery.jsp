<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page  import="yh.core.funcs.person.data.*"%>
<%
 YHPerson user = (YHPerson)request.getSession().getAttribute("LOGIN_USER");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; earset=UTF-8">
<link rel="stylesheet" href = "<%=cssPath%>/cmp/Calendar.css">
<link rel="stylesheet" href="<%=cssPath %>/page.css">
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath %>/cmp/tab.css" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Calendarfy.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/select.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript">
var field = 'SEND_TIME'; 
var ascDesc = '1';
function checkForm()
{
	var operation1 = document.getElementById("operation1");
	var operation2 = document.getElementById("operation2");
	var operation3 = document.getElementById("operation3");
	var regex = /^((\d{2}(([02468][048])|([13579][26]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|([1-2][0-9])))))|(\d{2}(([02468][1235679])|([13579][01345789]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))/; //????????????
	   if(document.form1.beginDate.value!=""){
	     if(!regex.test(document.form1.beginDate.value)){
	   	 alert("???????????????????????????");
	   	 document.form1.beginDate.value = "";
	   	 document.form1.beginDate.focus();
	       return false;
	     }
	   }
	   if(document.form1.endDate.value!=""){
	       if(!regex.test(document.form1.endDate.value)){
	     	 alert("???????????????????????????");
	     	document.form1.endDate.value = "";
	     	 document.form1.endDate.focus();
	         return false;
	       }
	  }

   if(document.form1.beginDate.value>document.form1.endDate.value && document.form1.endDate.value !="") {
	   alert("????????????????????????????????????");
	   return false;
   }
   if(operation1.checked){
	    loadData();
   }else if(operation2.checked)
   {
   	  msg='??????????????????????????????????????????';
      if(window.confirm(msg)){
         document.form1.action = contextPath + "/yh/core/funcs/notify/act/YHNotifyHandleAct/deleteSelNotify.act";  
         $("form1").submit(); 
      }   
   }else if(operation3.checked){     
      document.form1.action= contextPath + "/yh/core/funcs/notify/act/YHNotifyHandleAct/toExcel.act";
      $("form1").submit();
   }
   return true;
}

function loadData(){
//	  $('freshLoad').className = "pgBtn pgLoad";
	  //$('pageIndex').value = pageIndex;
//	  $('pgSearchInfo').innerHTML = "???????????????,?????????.....";
	  var url = "<%=contextPath%>/yh/core/funcs/notify/act/YHNotifyHandleAct/queryNotify.act";
	  var json = getJsonRs(url, mergeQueryString($("form1")));
	  document.getElementById("queryParams").style.display = "none";
	  document.getElementById("queryResult").style.display = "";
	  $("dataBody").update();
	  if(json.rtState == "0"){
	    var rtData = json.rtData;
	    var pageData = rtData.pageData;
	    var listData = rtData.listData;
	    if(listData.length > 0){
	      for(var i = 0 ;i < listData.length ;i ++){
	        var data = listData[i];
	        addRow(data, i);
	       
	      }
	    }else{
	      $('hasData').style.display = "none";
	      $('noData').style.display = "";
	    }
	  }else{
	    document.body.innerHTML = json.rtMsrg;
	  } 
	}

function addRow(data , i){
  var toNameTitle = data.toNameTitle;
  var toNameStr = data.toNameStr;
  var privNameTitle = data.privNameTitle;
  var privNameStr = data.privNameStr;
  var userNameTitle = data.userNameTitle;
  var userNameStr = data.userNameStr;
  var title = toNameTitle + privNameTitle + userNameTitle;
  var str = toNameStr + privNameStr + userNameStr;  
	 var td = "<td>&nbsp;<input type='checkbox' name='deleteFlag' value='" + data.seqId +"'>"+"</td>"
            + "<td nowrap align='center'><u title='??????:" + data.deptName + "' style='cursor:pointer'>"+data.fromName+"</u></td>"
            + "<td nowrap align='center'>" + data.typeName +"</td>"
            + "<td style='cursor:pointer' title='" + data.toNameTitle  +"' onClick='show_toobject(" + data.seqId + ");'>" + str + "</td>"
            + "<td><a href=javascript:open_notify('" + data.seqId + "','" + data.format + "'); title='" + data.subjectTitle + "'>" + data.subject + "</a></td>"
            + " <td align='left'>"+ data.sendTime.substring(0,19) +"</td>"
            + " <td nowrap align='center'>" + data.beginDate +"</td>"
            + "<td nowrap align='center'>" + data.endDate +"</td>";
    var notifyStatusStr = data.notifyStatusStr;
    if(notifyStatusStr=="") {
      td = td + "<td nowrap align='center'>" + data.publishDesc + "</td>";
    }else {
      td = td + "<td nowrap align='center'>" + notifyStatusStr + "</td>";
    }
    td = td + "<td><a href='javascript:show_reader(" + data.seqId + ");' title='????????????'> ????????????</a>&nbsp;<a href='/yh/core/funcs/notify/manage/notifyAdd.jsp?seqId=" + data.seqId + "'> ??????</a>";
    var notifyStatus = data.notifyStatus;
    var publish = data.publish;
    if(notifyStatus=="1"&&publish=="1"){
        td = td + "&nbsp;<a href='/yh/yh/core/funcs/notify/act/YHNotifyHandleAct/changeState.act?seqId="+data.seqId+"&operation=1'> ????????????</a>"
    }else if(notifyStatus=="2"&&publish=="1"){
  	  td = td + "&nbsp;<a href='/yh/yh/core/funcs/notify/act/YHNotifyHandleAct/changeState.act?seqId="+data.seqId+"&operation=2'>??????</a>"
    }else if(notifyStatus=="3"&&publish=="1"){
  	  td = td + "&nbsp;<a href='/yh/yh/core/funcs/notify/act/YHNotifyHandleAct/changeState.act?seqId="+data.seqId+"&operation=3'>??????</a>"
    }
	           
	  var className = "TableLine2" ;    
	  if(i%2 == 0){
	    className = "TableLine1" ;
	  }
	  var tr = new Element("tr" , {"class" : className}).update(td);
	  $('dataBody').appendChild(tr);  
	  
	}


function doInit(){
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

		  var url =contextPath+'/yh/core/funcs/notify/act/YHNotifyHandleAct/getnotifyType.act';
		  var json = getJsonRs(url);
		  if (json.rtState == "0"){
			  var rtData = json.rtData;
				var typeData = rtData.typeData;
				 $("typeId").options.add(new Option('??????',''));
				 if(typeData.length > 0){
				     for(var i = 0 ;i < typeData.length ;i ++){
				       var optionStr = typeData[i];
				       $("typeId").options.add(new Option(optionStr.typeDesc,optionStr.typeId)); 
				     }
				  }
			} else{
		      alert(json.rtMsrg);
		    }	  
}


function ClearUser(TO_ID, TO_NAME){
	  if(TO_ID=="" || TO_ID=="undefined" || TO_ID== null){
		TO_ID="TO_ID";
		TO_NAME="TO_NAME";
	  }
	  document.getElementsByName(TO_ID)[0].value="";
	  document.getElementsByName(TO_NAME)[0].value="";
}



function delete_mail(pageIndex,showLength)
{  
  var deleteAllFlags = document.getElementsByName("deleteFlag");
  var delete_str="";
  for(i=0;i<deleteAllFlags.length;i++)
  {

	  if(deleteAllFlags[i].checked) {
		  delete_str += deleteAllFlags[i].value + "," ;   //SMS_BODY  seqID
	 }	
  }
  if(delete_str=="")
  {
     alert("??????????????????????????????????????????????????????");
     return;
  }

  msg='???????????????????????????????????????';
  if(window.confirm(msg))
  {   
	  var par = 'pageIndex='+pageIndex+'&showLength=' +showLength+'&delete_str=' +delete_str;

      var url =contextPath+'/yh/core/funcs/notify/act/YHNotifyHandleAct/deleteCheckNotify.act';
	  var json = getJsonRs(url,par);
	  if (json.rtState == "0"){
		  window.location.href = "<%=contextPath%>/core/funcs/notify/manage/notifyList.jsp";
		} else{
	      alert(json.rtMsrg);
	    }
  }
}

function cancel_top()
{  
  var deleteAllFlags = document.getElementsByName("deleteFlag");
  var delete_str="";
  for(i=0;i<deleteAllFlags.length;i++)
  {

	  if(deleteAllFlags[i].checked) {
		  delete_str += deleteAllFlags[i].value + "," ;   //SMS_BODY  seqID
	 }	
  }
  if(delete_str=="")
  {
     alert("????????????????????????????????????????????????");
     return;
  }

  msg='?????????????????????????????????????????????';
  if(window.confirm(msg))
  {   
	 // var par = 'pageIndex='+pageIndex+'&showLength=' +showLength+'&delete_str=' +delete_str;

      var url =contextPath+'/yh/core/funcs/notify/act/YHNotifyHandleAct/cancelTop.act?delete_str='+delete_str;
	  var json = getJsonRs(url);
	  if (json.rtState == "0"){
		  window.location.href = "<%=contextPath%>/core/funcs/notify/manage/notifyQuery.jsp";
		} else{
	      alert(json.rtMsrg);
	    }
  }
}

function end_notify()
{  
  var deleteAllFlags = document.getElementsByName("deleteFlag");
  var delete_str="";
  for(i=0;i<deleteAllFlags.length;i++)
  {

	  if(deleteAllFlags[i].checked) {
		  delete_str += deleteAllFlags[i].value + "," ;   //SMS_BODY  seqID
	 }	
  }
  
  if(delete_str=="")
  {
     alert("????????????????????????????????????????????????");
     return;
  }

  msg='???????????????????????????????????????';
  if(window.confirm(msg))
  {   
	  var par = 'delete_str=' +delete_str + '&operation=2';
      var url =contextPath + '/yh/core/funcs/notify/act/YHNotifyHandleAct/changeStateGroup.act';
	  var json = getJsonRs(url,par);
	  if (json.rtState == "0"){
		  window.location.href = "<%=contextPath%>/core/funcs/notify/manage/notifyList.jsp";
		} else{
	      alert(json.rtMsrg);
	    }
  }
}


function back() {
	
	window.location.href = "/yh/core/funcs/notify/manage/notifyQuery.jsp";
}

function delete_all()
{
 msg='???????????????????????????????????????\n???????????????????????????????????????????????????????????????OK???';
 if(window.prompt(msg,"") == "OK")
 { 
	var url =contextPath+'/yh/core/funcs/notify/act/YHNotifyHandleAct/deleteAllNotify.act';
	var json = getJsonRs(url);
	if (json.rtState == "0"){
		window.location.reload();
	} else{
      alert(json.rtMsrg);
    }
 }
}

function show_toobject(seqId)
{
  URL="/yh/core/funcs/notify/manage/showObject.jsp?seqId="+seqId;
  myleft=(screen.availWidth-500)/2;
  window.open(URL,"read_notify","height=250,width=600,status=0,toolbar=no,menubar=no,location=no,scrollbars=yes,top=150,left="+myleft+",resizable=yes");
}

function my_affair(seqId)
{
  myleft=(screen.availWidth-250)/2;
  mytop=(screen.availHeight-200)/2;
  URL="/yh/core/funcs/notify/manage/note.jsp?seqId="+seqId;
  window.open(URL,"","height=200,width=250,status=0,toolbar=no,menubar=no,location=no,scrollbars=auto,resizable=no,top="+mytop+",left="+myleft);
}

function open_notify(seqId,format)
{
 URL="/yh/core/funcs/notify/show/readNotify.jsp?isManage=1&seqId="+seqId;
 myleft=(screen.availWidth-780)/2;
 mytop=100
 mywidth=780;
 myheight=500;
 if(format=="1")
 {
    myleft=0;
    mytop=0
    mywidth=screen.availWidth-15;
    myheight=screen.availHeight-60;
 }
 window.open(URL,"????????????","height="+myheight+",width="+mywidth+",status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,top="+mytop+",left="+myleft+",resizable=yes");
}

function show_reader(seqId)
{
  URL="/yh/core/funcs/notify/show/showReader.jsp?seqId="+seqId;
  myleft=(screen.availWidth-500)/2;
  window.open(URL,"read_notify","height=500,width=700,status=0,toolbar=no,menubar=no,location=no,scrollbars=yes,top=150,left="+myleft+",resizable=yes");
}

function checkAll(field) {
	  var deleteFlags = document.getElementsByName("deleteFlag");
	  for(var i = 0; i < deleteFlags.length; i++) {
	    deleteFlags[i].checked = field.checked;
	  }
	}
</script>
</head>
<body onload="doInit();">
<div id="queryParams">
<table border="0" width="90%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img align="absMiddle" src="<%=imgPath%>/search.gif"><span class="big3"> ??????????????????</span>
    </td>
  </tr>
</table>

<form method="post" id="form1" name="form1" onsubmit="return checkForm();">
<table class="TableBlock" width="550" align="center">
   <%if(user.isAdminRole()){%>
    <tr>
      <td nowrap class="TableData">?????????:</td>
      <td class="TableData">
        <input type="hidden" id="user" name="fromId" value="">
        <textarea cols=30 id="userDesc" name="fromName" rows=2 class="BigStatic" wrap="yes" readonly></textarea>
        <a href="javascript:;" class="orgAdd" onClick="javascript:selectUser(['user', 'userDesc'] , 5);">??????</a>
        <a href="javascript:;" class="orgClear" onClick="ClearUser('fromId','fromName')">??????</a>
      </td>
    </tr>
   <%}%>   
    <tr>
      <td nowrap class="TableData" width="100"> ?????????</td>
      <td class="TableData">
      <select name="format" class="BigSelect">
        <option value="" selected>??????</option>
        <option value="0">????????????</option>
        <option value="1">MHT??????</option>
        <option value="2">????????????</option>
      </select>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData"> ?????????</td>
      <td class="TableData">
        <select id="typeId" name="typeId" class="BigSelect">
        </select>&nbsp;
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ???????????????</td>
      <td class="TableData">
      <select name="publish" class="BigSelect">
        <option value="" selected>??????</option>
        <option value="0">?????????</option>
        <option value="1">?????????</option>
      </select>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ???????????????</td>
      <td class="TableData">
      <select name="top" class="BigSelect">
        <option value="" selected>??????</option>
        <option value="0">?????????</option>
        <option value="1">?????????</option>
      </select>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ?????????</td>
      <td class="TableData">
        <input type="text" name="subject" size="33" maxlength="100" class="BigInput" value="">
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ???????????????</td>
      <td class="TableData">
        <input type="text" id = "beginDate" name="beginDate" class="BigInput" size="10" maxlength="10"  value="">
        <img id="beginDateImg" src="<%=imgPath%>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
                    ???&nbsp;
       <input type="text" id = "endDate" name="endDate" class="BigInput" size="10" maxlength="10"  value="">
        <img id="endDateImg" src="<%=imgPath%>/calendar.gif" align="absMiddle" border="0" style="cursor:pointer">
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ?????????</td>
      <td class="TableData">
        <input type="text" name="content" size="33" maxlength="200" class="BigInput" value="">
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ???????????????</td>
      <td class="TableData">
      <select name="stat" class="BigSelect">
        <option value="" selected>??????</option>
        <option value="1">?????????</option>
        <option value="2">?????????</option>
        <option value="3">?????????</option>
      </select>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData" width="100"> ?????????</td>
      <td class="TableData">
        <input type="radio" name="operation" id="operation1" value="1" checked><label for="operation1">??????</label>
        <input type="radio" name="operation" id="operation2" value="2"><label for="operation2">??????</label>
        <input type="radio" name="operation" id="operation3" value="3"><label for="operation3">??????excel??????</label>
      </td>
    </tr>
    <tr align="center" class="TableControl">
      <td colspan="2" nowrap>
         <input type="hidden" id="dtoClass" name="dtoClass" value="yh.core.funcs.notify.data.YHNotify"/>
         <input type="button" value="??????" class="BigButton" onClick="checkForm();">&nbsp;&nbsp;
        <input type="reset" value="??????" class="BigButton">&nbsp;&nbsp;
      </td>
    </tr>
  </table>
</form>
</div>
<div id="queryResult" style="display:none">
<table border="0" width="90%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img align="absMiddle" src="<%=imgPath%>/search.gif"><span class="big3"> ??????????????????</span>
    </td>
  </tr>
</table>

<div id="hasData">
  <table class="TableList" width="100%">
    <tr class="TableHeader">
      <td nowrap align="center">??????</td>
      <td nowrap align="center">?????????</td>
      <td nowrap align="center">??????</td>
      <td nowrap align="center">????????????</td>
      <td nowrap align="center">??????</td>
      <td nowrap align="center">????????????</td>
      <td nowrap align="center">????????????</td>
      <td nowrap align="center">????????????</td>
      <td nowrap align="center">??????</td>
      <td nowrap align="center" width='120'>??????</td>
    </tr>
    <tbody id="dataBody"></tbody>
     <tr class="TableControl">
      <td colspan="10">
      <input type="checkbox" name="allbox" id="allbox_for" onClick="javascript:checkAll(this);"><label for="allbox_for">??????</label> &nbsp;
      <a href="javascript:delete_mail();" title="????????????????????????"><img src="<%=imgPath%>/delete.gif" align="absMiddle">??????????????????</a>&nbsp;
      <a href="javascript:cancel_top();" title="??????????????????"><img src="<%=imgPath%>/user_group.gif" align="absMiddle">????????????</a>&nbsp;
      <a href="javascript:end_notify();" title="????????????????????????" ><img src="<%=imgPath%>/inout.gif" align="absMiddle">?????? </a>&nbsp;
      </td>
   </tr>
  </table>
  <br><center><input type="button" class="BigButton" value="??????" onclick="goBack();return false;"></center>
  <script>
    function goBack(){
     window.location.href= contextPath + "/core/funcs/notify/manage/notifyQuery.jsp";
    }
  </script>
 </div>
 <div id="noData" style="display:none">
 <TABLE class=MessageBox width=280 align=center>
<TBODY>
<TR>
<TD class="msg info">
<DIV class=content 
style="FONT-SIZE: 12pt">????????????????????????</DIV></TD></TR></TBODY></TABLE>
<DIV align=center>
<INPUT class=BigButton onclick="back();" type=button value=??????> 
</DIV>
</div>
</div>
<script>
function bindValidDtFunc() {
	bindAssertDateTimePrcBatch([{id:"beginDate", type:"d"}, {id:"endDate", type:"d"}]);
}
bindValidDtFunc();
</script>
</body>
</html>