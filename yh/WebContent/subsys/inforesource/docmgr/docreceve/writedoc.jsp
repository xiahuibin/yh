 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.subsys.oa.book.data.*"%>
<%@ page  import="java.util.List, yh.subsys.inforesouce.docmgr.data.YHDocReceive, yh.subsys.inforesouce.docmgr.data.YHDocConst"%>

<%
 List<YHDocReceive>docs = (List)request.getAttribute("docs");
 String flag = (String)request.getAttribute("ftype");
 YHPerson user = (YHPerson)request.getSession().getAttribute("LOGIN_USER");
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="<%=cssPath %>/page.css"/>
<link rel="stylesheet" href ="<%=cssPath %>/style.css"/>
<link rel="stylesheet" href = "<%=cssPath %>/Calendar.css"/>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attach.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Calendarfy.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/fck/fckeditor/fckeditor.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/swfupload/swfupload.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/swfupload/fileprogress.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/swfupload/handlers.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/funcs/notify/js/openWin.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/cmp/select.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/workflow.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/utility.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/subsys/inforesource/docmgr/docreceve/js/common.js" ></script>
<script type="text/Javascript">

var constName = '<%=YHDocConst.constName%>';

var centerName = '<%=YHDocConst.centerName%>';

  function read(seqId){
    window.location.href = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/updateReadDocReceive.act?seqId=" + seqId;
    return true;
  }

  function cost_balance(seqId){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/findDocFileAjax.act?seqId="+seqId;
    var rtJson = getJsonRs(url); 
   
    if(rtJson.rtState == "1"){
  	alert(rtJson.rtMsrg); 
  	return ;
    }
    var prcs = rtJson.rtData[0];
    var prcs2 = rtJson.rtData[1];
    
    var docNo = prcs.docNo;
    var grade = prcs.confLevel;
    var migrade = prcs.confLevelName;
    var reDate = prcs.resDate;
    var sponsor = prcs.sponsor;
    var fromUnits = prcs.fromUnits;
    var oppDocNo = prcs.oppDocNo;
    var title = prcs.title;
    var pishi = prcs.instruct;
    var runId = prcs.runId;
    var toUserName = prcs.toUserName;
    var deptName = prcs2.deptName;
    var status = prcs.status;
   //var param = '??????='+ grade + "&??????="+ encodeURIComponent(migrade) +"&????????????="+ reDate +"&?????????="+encodeURIComponent(toUserName)+
   //            "&????????????="+encodeURIComponent(fromUnits)+"&????????????="+encodeURIComponent(oppDocNo)+"&??????="+encodeURIComponent(title)+
    //           "&????????????="+encodeURIComponent(pishi)+"&??????ID="+seqId +"&??????="+ docNo+ "&?????????="+encodeURIComponent('<%=user.getUserName()%>')+
    //           "&??????="+encodeURIComponent(deptName) ;
    var param = 'grade='+ grade + "&migrade="+ encodeURIComponent(migrade) +"&reDate="+ reDate +"&toUserName="+encodeURIComponent(toUserName);
        param += "&fromUnits="+encodeURIComponent(fromUnits)+ "&oppDocNo="+encodeURIComponent(oppDocNo)+"&title="+encodeURIComponent(title);
        param += "&pishi="+encodeURIComponent(pishi)+ "&seqId="+seqId +"&docNo="+ docNo + "&useName="+encodeURIComponent('<%=user.getUserName()%>') ;
        param += "&deptName="+encodeURIComponent(deptName) +"&runId="+ runId;
    if(runId != null && runId != "" && runId > 0){
      if(status == 0){
        formViewByName(runId, constName);
      }else if(status == 1){
        formViewByName(runId, centerName);
      }
      return;
    }/*else{
     // createNewWork(encodeURIComponent(constName),param);
    //}*/
    var openUrl = contextPath + "/subsys/inforesource/docmgr/docreceve/doctypeindex.jsp?"+param;
    window.open(openUrl);
  }

  
</script>
</head>
 
<body class="bodycolor" topmargin="5">
 
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
<tr>
  <td class="Big"><img src="/yh/core/styles/style3/img/book.gif" width="22" height="18"><span class="big3"> 
          ????????????
  </span>&nbsp;
  </td>
  <td valign="bottom" class="small1" align="center">???<span class="big4">&nbsp;<%=docs.size() %></span>&nbsp;?????????
  </td>
</tr>
</table>
 
<table class="TableList" width="95%" align="center">
<tr class="TableHeader">
  <td nowrap align="center">??????&nbsp;</td>
  <td nowrap align="center">??????&nbsp;</td>  
  <td nowrap align="center">??????&nbsp;</td>
  <td nowrap align="center">????????????&nbsp;</td>
  <td nowrap align="center">??????&nbsp;</td>
  <td nowrap align="center">??????&nbsp;</td>
  <td nowrap align="center">?????????&nbsp;</td>
  <td nowrap align="center">??????&nbsp;</td>
  <td nowrap align="center" >??????&nbsp;</td>
</tr>
<%
  for(int i=0; i<docs.size(); i++){%>
    <tr class="TableLine1">
		  <td align="center"><%=docs.get(i).getTitle() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getDocNo() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getCopies() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getFromUnits() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getConfLevelName() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getDocTypeName() %>&nbsp;</td>     
		  <td align="center"><%=docs.get(i).getFromUserName() %>&nbsp;</td> 
		  <%if(docs.get(i).getRunId()!=null && docs.get(i).getRunId()!=""){%>
		  <td align="center"><a href="javascript:flowView('<%=docs.get(i).getNext().getRunId() %>','<%=docs.get(i).getNext().getFlowId() %>','','');"><%=docs.get(i).getNext().getPrcsName() %></a>&nbsp;</td>
		  <%}else{%>
		    <td align="center"><font color="red"><%=docs.get(i).getNext().getPrcsName() %></font>&nbsp;</td> 
		  <%}%> 
		  <td nowrap align="center">
		     <%
		       if(1 == (docs.get(i).getSendStauts())){%>
		         <a href="javascript:void(0);" onclick="cost_balance('<%=docs.get(i).getSeq_id() %>'); return false;"><%if(docs.get(i).getRunId()==null || docs.get(i).getRunId()==""){%>??????<%}else{%>??????<%}%></a>	&nbsp;	    
		      <%}%>&nbsp;
	    </td>
   </tr>
 <%}%>
</table>
</body>
</html>

