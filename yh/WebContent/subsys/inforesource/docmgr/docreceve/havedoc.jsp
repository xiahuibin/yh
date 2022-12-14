 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page  import="java.util.List, yh.subsys.inforesouce.docmgr.data.YHDocReceive,java.net.URLEncoder,yh.subsys.inforesouce.docmgr.data.YHDocConst"%>

<%
 List<YHDocReceive>docs = (List)request.getAttribute("docs");
 String flag = (String)request.getAttribute("ftype");
 if(flag==null || flag == ""){
    flag = "0";
 }
 String column = (String)request.getAttribute("column");
 String asc = (String)request.getAttribute("asc");
 String col = "";
 String ord = "";
 if(column != null && column != ""){
    col = column;
 }
 if(asc != null && asc != ""){
   ord = asc;
 }
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="<%=cssPath %>/page.css"/>
<link rel="stylesheet" href = "<%=cssPath %>/Calendar.css"/>
<link rel="stylesheet" href="<%=cssPath%>/views.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath%>/style.css" type="text/css" />
<link rel="stylesheet" href ="<%=cssPath %>/cmp/tab.css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Calendarfy.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/js/orgselect.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/subsys/inforesource/docmgr/docreceve/js/common.js" ></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/workflow.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/workflow/workflowUtility/utility.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/subsys/inforesource/docmgr/docreceve/js/MultiUserSelect.js" ></script>
<script type="text/Javascript" src="<%=contextPath%>/subsys/inforesource/docmgr/docreceve/js/common.js" ></script>
<script type="text/Javascript">

var constName = '<%=YHDocConst.constName%>';
var centerName = '<%=YHDocConst.centerName%>';

  function sendTo(seqId, id){//userId?????????Id
    var userId = document.getElementById(id).value;
    if( !userId || userId == "0" ){
      alert("??????????????????");
      return false;
    }
    window.location.href = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/updateDocReceive.act?seqId=" + seqId +"&userId="+ userId;
    return true;
  }

  function alarmTo(seqId, toId, docNo){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/alarmToRead.act";
    var param = "seqId="+ seqId + "&toId=" + toId + "&docNo="+docNo;
    var rtJson = getJsonRs(url, param);
    if(rtJson.rtState != "0"){
      alert("????????????");
    }else{
      alert("????????????");
    }
  }

  function selectAll(n){
    var boj = document.getElementsByName(n);	
    var ckObj = document.getElementById("allbox_for");
    var ischeck = ckObj.checked;
    if(ischeck == true && boj){  //??????

      for(var i=0; i<boj.length; i++){
        if(boj[i].checked == false && boj[i].disabled == false){
          boj[i].checked =true;
        }
      }
    }
    if(ischeck == false && boj){//?????????

      for(var i=0; i<boj.length; i++){
        if(boj[i].checked == true){
          boj[i].checked = false;
        }
      }
    }
  }

  function checkBoxSel(id){
    var cobj = document.getElementById(id);
    var ckObj = document.getElementById("allbox_for");
    var ischeck = cobj.checked;
    if(ischeck == false){    //??????

      ckObj.checked = false;
    }
  }

  /**
  *  ????????????
  */
  function beanchAlarm(name){
    var boj = document.getElementsByName(name);	
    var f1 = 0;
    for(var i=0; i<boj.length; i++){
      if(boj[i].checked == false){
        f1 = f1 + 0;
      }else{
        f1 = f1 + 1;
      }
    }
   if(f1 > 0){
     checkAlarm();
   }else if(f1 == 0){
     alert("??????????????????!");
   }
  }

  /**
   *  ??????????????????
   */
   function beanchConfrim(name){
     var boj = document.getElementsByName(name);	
     var f1 = 0;
     var userId = "";
     var seqIds = "";
     for(var i=0; i<boj.length; i++){
       if(boj[i].checked == false){
         f1 = f1 + 0;
       }else{
         f1 = f1 + 1;
         var uId = "userId_"+boj[i].id;
         var val = $(uId).value;
         var wh = document.getElementById("wh_"+boj[i].id).innerText;
          seqIds += boj[i].id +",";
          userId += document.getElementById("userId_"+boj[i].id).value+",";
         if(!val){
           alert("?????????:"+ wh +"?????????????????????");
           return;
         }
       }
     }
    if(f1 > 0){
      seqIds = seqIds.substring(0, seqIds.lastIndexOf(","));
      userId = userId.substring(0, userId.lastIndexOf(","));
      $("seqIds").value = seqIds;
      $("userIds").value = userId;
      checkConfirm();
    }else if(f1 == 0){
      alert("??????????????????!");
    }
   }

  function checkAlarm(){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/beanchAlarm.act";
    $("form1").action = url;
    $("form1").submit();
    return false;
  }

  function checkConfirm(){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/beanChConfirm.act";
    $("form1").action = url;
    $("form1").submit();
    return false;
  }

  function checkDetail(runId, status){
    if(runId != null && runId != "" && runId > 0){
      if(status == 0){
        formViewByName(runId, constName);
      }else{
        formViewByName(runId, centerName);
      }
     
    }else{
      alert("?????????????????????,?????????????????????");
    }
  }

  function edit(seqId){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/editDoc.act?seqId="+ seqId;
    window.open(url);
  }

  function cancel(seqId){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/cancel.act?seqId="+ seqId;
    var rtJson = getJsonRs(url);
    if(rtJson.rtState == "1"){
      alert(rtJson.rtMsrg); 
      return ;
    }else{
      alert(rtJson.rtMsrg); 
      window.location.href = window.location.href;
    }
    return;
  }

  /**
  *  ????????????
  */
  function doPrint(name){
    var boj = document.getElementsByName(name);	
    var f1 = 0;
    var printIds = "";
    for(var i=0; i<boj.length; i++){
      if(boj[i].checked == false){
        f1 = f1 + 0;
      }else{
        f1 = f1 + 1;
        printIds += boj[i].id + ",";
      }
    }
   if(f1 > 0){
     printIds = printIds.substring(0, printIds.length-1);
     var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/print.act?printIds="+ printIds;
     var myleft = (screen.availWidth-780)/2 ;
     window.open(url,"read_vote","height=600,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,top=150,left="+myleft+",resizable=yes");
     
   }else if(f1 == 0){
     alert("??????????????????!");
   }
  }

  function siglePrint(seqId){
    var url = contextPath + "/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/print.act?printIds="+ seqId;
    var myleft = (screen.availWidth-780)/2 ;
    window.open(url,"read_vote","height=600,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,top=150,left="+myleft+",resizable=yes");
  }

  function clearValue(id, name){
    document.getElementById(id).value = "";
    document.getElementById(name).value = "";
  }

  function printDetail(){
    var url = contextPath + "/subsys/inforesource/docmgr/docreceve/detail.jsp";
    openWin(url);
  }

  function orderListioner(){
    var obj = document.getElementsByTagName("u");
    for(var i=0; i<obj.length; i++){
      obj[i].attachEvent("onclick", myFunc);   
    }
  }

  function myFunc(obj){
    var o= obj.srcElement["id"];
    var tt = document.getElementById(o);
    var nodes = tt.childNodes;
    if(!nodes[1] || nodes[1].src == ""){
      tt.innerHTML += "<img src='"+ imgUp +"' id='"+ o +"'>";
      createOrder(o, "asc");
    }else{
         if(nodes[1].src.indexOf(imgUp)>-1){
            nodes[1].src = imgDown;
            createOrder(o, "desc");
          }else if(nodes[1].src.indexOf(imgDown)>-1){
            nodes[1].src = imgUp;
            createOrder(o, "asc");
          }
     }
    removeNode(o);
    document.getElementById("form1").submit();
  }

  function removeNode(id){
    var obj = document.getElementsByTagName("u");
    for(var i=0; i<obj.length; i++){
      var nId = obj[i].id;
      if(nId && nId!= id){
        var tt = document.getElementById(nId);
        var nodes = tt.childNodes;
        if(nodes[1]){
          tt.removeChild(nodes[1]);
        }
      }
    }
  }

  
  function createOrder(colum, method){
    document.getElementById("colum").value = colum;
    document.getElementById("asc").value = method;
  }

  function doInit(){
    orderListioner();
    var col = "<%=col%>";
    var ord = "<%=ord %>";
    if(col){
      var tt = document.getElementById(col);
      $("colum").value = col;
      if(!ord){
        tt.innerHTML += "<img src='"+ imgUp +"' id='"+ col +"'/>";
        $("asc").value = ord;
      }else if(ord == "asc"){
        tt.innerHTML += "<img src='"+ imgUp +"' id='"+ col +"'/>";
        $("asc").value = ord;
      }else if(ord == "desc"){
        tt.innerHTML += "<img src='"+ imgDown +"' id='"+ col +"'/>";
        $("asc").value = ord;
      }
    }
  }
  var bm = "";
  /**
  *????????????????????????????????????
  */
  function doBeanChSelUser(name){
    var oq = beanchSel(name);
    if(oq){
      var url = contextPath + "/subsys/inforesource/docmgr/docreceve/beachwrite.jsp?bm="+bm;
      window.open(url, "window","height=200,width=350,status=0,toolbar=no,menubar=no,location=no,scrollbars=yes,left=450,top=200,resizable=no");
    }
  }

  /**
   *  ?????????????????????

   */
   function beanchSel(name){
     var boj = document.getElementsByName(name);	
     var f1 = 0;
     var flag = 0;
     var sum = 0;
     for(var i=0; i<boj.length; i++){
       if(boj[i].checked == false){
         f1 = f1 + 0;
       }else{
         f1 = f1 + 1;
         var uId = "userId_"+boj[i].id;
         var val = $(uId).value;
         var wh = document.getElementById("wh_"+boj[i].id).innerText;
         bm = document.getElementById("hid_"+boj[i].id).value; //??????id
         for(var j=i; j<boj.length; j++){
           if(boj[j].checked == true){
             var dept = document.getElementById("hid_"+boj[j].id).value; //??????id
             if(bm != dept){
                alert("???????????????????????????????????????");
                return false;
             }
           }
         }
       }
     }
    if(f1 > 0){
      return true;
     }else if(f1 == 0){
      alert("??????????????????!");
      return false;
    }
   }

  /**
  * ???????????????????????????Id
  */
   function beanchUser(name, pid){
     var boj = document.getElementsByName("selAll");
     if(boj){	
	     for(var i=0; i<boj.length; i++){
	       if(boj[i].checked == true){
	         var uId = "userId_"+boj[i].id;
	         var uName = "userName_"+boj[i].id;
	         $(uName).value = name;
	         $(uId).value = pid;
	       }
	     }
     }
   }
</script>
</head>
 
<body class="bodycolor" topmargin="5" onload="doInit();">
 <form action="<%=contextPath %>/yh/subsys/inforesouce/docmgr/act/YHDocReceiveAct/faDocReceive.act" id="form1" name="form1" method="post">
      <input type="hidden" value="" id="colum" name="colum"/>
      <input type="hidden" value="" id="asc"  name="asc"/>
      <input type="hidden" value="<%=flag%>" id="ftype"  name="ftype"/>
      <input type="hidden" value="" id="seqIds"  name="seqIds"/>
      <input type="hidden" value="" id="userIds"  name="userIds"/>
  </form>
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
<tr>
  <td class="Big"><img src="/yh/core/styles/style3/img/book.gif" width="22" height="18"><span class="big3"> 
   <%
     if("1".equalsIgnoreCase(flag)){%>
                ????????????
   <%}else{%>
               ????????????
   <%}%>
  </span>&nbsp;
  </td>
  <td valign="bottom" class="small1" align="center">???<span class="big4">&nbsp;<%=docs.size() %></span>&nbsp;?????????

  </td>
</tr>
</table>

<form id="form1" name="form1">
<table class="TableList" width="95%" align="center">
<tr class="TableHeader">
  <%
    if(!"1".equalsIgnoreCase(flag)){%>
      <td nowrap align="center">??????&nbsp;</td>
   <%} %>
  <td nowrap align="center" style="cursor:pointer;" ><u id="TITLE ">??????</u>&nbsp;</td>
  <td nowrap align="center" style="cursor:pointer;"><u id="DOC_NO">??????</u>&nbsp;</td>  
  <td nowrap align="center" style="cursor:pointer;"><u id="COPIES">??????</u>&nbsp;</td>
   <td nowrap align="center" style="cursor:pointer;"><u id="CONF_LEVEL">??????</u>&nbsp;</td>
  <td nowrap align="center" style="cursor:pointer;"><u id="DOC_TYPE">??????</u>&nbsp;</td>
  <td nowrap align="center" style="cursor:pointer;"><u id="FROMUNITS">????????????</u>&nbsp;</td>
  <td nowrap align="center" style="cursor:pointer;"><u id="SPONSOR">????????????</u>&nbsp;</td>
  <td nowrap align="center" style="cursor:pointer;"><u id="CREATE_USER_ID">?????????</u>&nbsp;</td>
  <td nowrap align="center">??????&nbsp;</td>
</tr>
<%
  for(int i=0; i<docs.size(); i++){
    String spo = docs.get(i).getSponsor();
  %>
    <tr class="TableLine1">
    <%
    if(!"1".equalsIgnoreCase(flag)){%>
      <td nowrap align="center">
      <%
        if(spo == null || spo == ""){%>
           <input type="checkbox" id="<%=docs.get(i).getSeq_id() %>" name="selAll" disabled/>&nbsp;
        <%} else{%>
           <input type="checkbox" id="<%=docs.get(i).getSeq_id() %>" name="selAll" onclick="checkBoxSel('<%=docs.get(i).getSeq_id() %>')" value="<%=docs.get(i).getSeq_id() %>"/>&nbsp;
           <input type="hidden" id="hid_<%=docs.get(i).getSeq_id() %>" value="<%=spo%>"/>
        <%}%>
     </td>
    <%} %>
		  <td align="center"><%=docs.get(i).getTitle() %>&nbsp;</td>
		  <td align="center" id="wh_<%=docs.get(i).getSeq_id() %>"><%=docs.get(i).getDocNo() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getCopies() %>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getConfLevelName()%>&nbsp;</td>
		  <td align="center"><%=docs.get(i).getDocTypeName() %>&nbsp;</td>   
		  <td align="center"><%=docs.get(i).getFromUnits() %>&nbsp;</td>
      <td align="center"><%=docs.get(i).getSponsorName() %>&nbsp;</td>
		  <%
		   if(!"1".equalsIgnoreCase(flag)){
		    if(docs.get(i).getSponsor()!=null && docs.get(i).getSponsor()!=""){%>
		      <td align="center">
           <input type="hidden" id="userId_<%=docs.get(i).getSeq_id() %>" name="userId_<%=docs.get(i).getSeq_id() %>" value="" />
           <input type="text"  id="userName_<%=docs.get(i).getSeq_id() %>" name="userName_<%=docs.get(i).getSeq_id() %>" class="" style="width:50px;height:13px;" value="" readonly/>
           <a href="javascript:void(0);" class="orgAdd" onclick="selectSingleUserByDept(['userId_<%=docs.get(i).getSeq_id() %>', 'userName_<%=docs.get(i).getSeq_id() %>'],'<%=docs.get(i).getSponsor() %>')" title="???????????????">??????</a>
           <a href="javascript:void(0);" class="orgClear" onclick="javascript:clearValue('userId_<%=docs.get(i).getSeq_id() %>','userName_<%=docs.get(i).getSeq_id() %>');" title="???????????????">??????</a>
	  	</td>
		  <%}else{%>
		    <td align="center">&nbsp;</td>
		  <% }
		    }else{%>
		      <td align="center"><%=docs.get(i).getToUserName() %>&nbsp;</td>
		    <%}
		  %>
	  	
		  <td nowrap align="center">
		     <%
		       if("1".equalsIgnoreCase(flag)){%>
		         <a href="javascript:cancel('<%=docs.get(i).getSeq_id() %>');" >??????</a>	&nbsp;	
		         <a href="javascript:void(0);" onclick="checkDetail('<%=docs.get(i).getRunId() %>','<%=docs.get(i).getStatus() %>');">???????????????</a>	&nbsp;	    
		      <%}else{%>
		         <%
		        if(spo == null || spo == ""){%>
		           <a href="javascript:edit('<%=docs.get(i).getSeq_id() %>');">??????</a>	&nbsp;	
		           <a href="javascript:printDetail();">???????????????</a>
		       <%}else{%>
		          <a href="javascript:void(0);" onclick="sendTo('<%=docs.get(i).getSeq_id() %>', 'userId_<%=docs.get(i).getSeq_id() %>')">????????????</a>	&nbsp;	    
		          <a href="javascript:siglePrint('<%=docs.get(i).getSeq_id() %>');">??????</a>	&nbsp;	
		       <%}%>
		      <%}%>
		      
	    </td>
   </tr>
 <%}%>
  <%
   if(!"1".equalsIgnoreCase(flag) && docs != null && docs.size() >0){%>
     <tr class="TableControl">
      <td colspan="19">
      <input type="checkbox" name="allbox" id="allbox_for" onclick="selectAll('selAll');"><label for="allbox_for">??????</label> &nbsp;
      <!-- <a href="javascript:beanchAlarm('selAll');" title="????????????"><img src="<%=imgPath%>/msg.png" align="absMiddle">????????????</a>&nbsp; -->
	    <a href="javascript:beanchConfrim('selAll');" title="????????????"><img src="<%=imgPath%>/folder_edit.gif" align="absMiddle">????????????</a>&nbsp;
	     <a href="javascript:doPrint('selAll');" title="????????????"><img src="<%=imgPath%>/folder_edit.gif" align="absMiddle">????????????</a>&nbsp;
	     <a href="javascript:doBeanChSelUser('selAll');" title="?????????????????????"><img src="<%=imgPath%>/user_group.gif" align="absMiddle">?????????????????????</a>&nbsp;
      </td>
   </tr>
 <%}%>
</table>
</form>
</body>
</html>

