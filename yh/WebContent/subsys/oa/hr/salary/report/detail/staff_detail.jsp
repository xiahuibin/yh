<%@ page language="java" contentType="text/html; charset=gbk"
    pageEncoding="gbk"%>
<%@ include file="/core/inc/header.jsp" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%><html>
<%
SimpleDateFormat curTime = new SimpleDateFormat("yyyy��MM��");
String date=curTime.format(new Date());
String USER_ID=request.getParameter("userId");
String FLOW_ID=request.getParameter("flowId");
%>




<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title>Ա����������</title>
<link rel="stylesheet" href = "<%=cssPath%>/style.css">
<link rel="stylesheet" href="<%=cssPath%>/page.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/page.js"></script>
<script type="text/javascript" >
  var startTime="";
  var endTime="";


  function doInit(){
    doUserNameFunc();
    doAttendance();
  
  }

//��ȡԱ������
function doUserNameFunc(){ 
  var name='';
  var url = contextPath + "/yh/subsys/oa/hr/manage/act/YHHrStaffIncentiveAct/getUserName.act";
  var rtJson = getJsonRs(url, "userIdStr=<%=USER_ID%>");
 
  if (rtJson.rtState == "0") {
     name= rtJson.rtData ;
  } else {
    alert(rtJson.rtMsrg); 
  }
  
  $('staffName').innerHTML=name;

}

function doAttendance(){
    
  var url = contextPath + "/yh/subsys/oa/hr/salary/report/act/YHHrReportAct/getAttendance.act";
  var rtJson = getJsonRs(url, "userIdStr=<%=USER_ID%>&flowId=<%=FLOW_ID%>");
 
   if (rtJson.rtState == "0") {
      var data=rtJson.rtData;
	  if(data.lateCount!=0) data.lateCount="<font color='red'>"+data.lateCount+"</font>";
	  if(data.ealyCount!=0) data.ealyCount="<font color='red'>"+data.ealyCount+"</font>";
	  if(data.outCount!=0) data.outCount="<font color='red'>"+data.outCount+"</font>";
	  if(data.leaveCount!=0) data.leaveCount="<font color='red'>"+data.leaveCount+"</font>";
	  if(data.evectionCount!=0) data.evectionCount="<font color='red'>"+data.evectionCount+"</font>";
	  if(data.overtimeCount!=0) data.overtimeCount="<font color='red'>"+data.overtimeCount+"</font>";
	  if(data.awardCount!=0) data.awardCount="<font color='red'>"+data.awardCount+"</font>";
	  if(data.punishCount!=0) data.punishCount="<font color='red'>"+data.punishCount+"</font>";
	  if(data.calCount!=0) data.calCount="<font color='red'>"+data.calCount+"</font>";
	  if(data.calCount1!=0) data.calCount1="<font color='red'>"+data.calCount1+"</font>";
	  if(data.diaryCount!=0) data.diaryCount="<font color='red'>"+data.diaryCount+"</font>";
	  if(data.checkCount!=0) data.checkCount="<font color='red'>"+data.checkCount+"</font>";

	  bindJson2Cntrl(data); 
	  startTime=data.startDate;
	  endTime=data.endDate;
	 
	  //��ʾ�·�
	  var date=startTime.replace('-','��').replace('-','��').substr(0,8);
	  $('date').innerHTML=date;
     } else {
     alert(rtJson.rtMsrg); 
  }
}

function openDetail(index){
  if(index==1){ //�ٵ�
  window.open('selectduty.jsp?userId=<%=USER_ID%>&startTime='+startTime+'&endTime='+endTime,"",'height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
  else if(index==2){//����
  window.open('selectduty.jsp?userId=<%=USER_ID%>&startTime='+startTime+'&endTime='+endTime,"",'height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
  else if(index==3){//���
  window.open('out.jsp?userId=<%=USER_ID%>&flowId=<%=FLOW_ID%>','','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
  else if(index==4){//���
  window.open('leave.jsp?userId=<%=USER_ID%>&flowId=<%=FLOW_ID%>','','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
  else if(index==5){//����
  window.open('evection.jsp?userId=<%=USER_ID%>&flowId=<%=FLOW_ID%>','','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
  else if(index==6){//�Ӱ�
  window.open('overtime.jsp?userId=<%=USER_ID%>&flowId=<%=FLOW_ID%>','','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
 
  else if(index==7){//����
  window.open('award.jsp?userId=<%=USER_ID%>&startTime='+startTime+'&endTime='+endTime,'','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
 else if(index==8){//�ͷ�
  window.open('punish.jsp?userId=<%=USER_ID%>&startTime='+startTime+'&endTime='+endTime,'','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
 else if(index==9){//��־
  window.open('diary.jsp?userId=<%=USER_ID%>&startTime='+startTime+'&endTime='+endTime,'','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }
 else if(index==10){//����
  window.open('score.jsp?userId=<%=USER_ID%>&startTime='+startTime+'&endTime='+endTime,'','height=700,width=900,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,left=800,top=270,resizable=yes');
  }


}






</script>

<body class="bodycolor" topmargin="5" onLoad="doInit();">
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath%>/meeting.gif" width="17" height="17"><span class="big3"><span id="staffName"></span>��������(<span id="date"></span>)</span><br>
    </td>
  </tr>
</table>

<table class="TableBlock" width="90%" align="center">
  <tr>
    <td nowrap align="left" class="TableContent">��Ŀ</td>
    <td nowrap align="left" class="TableContent" >����Ŀ</td>
    <td nowrap align="center" class="TableContent">����</td>
    <td nowrap align="center" class="TableContent"  >����</td>
  </tr>
  <tr>
    <td nowrap align="left" rowspan=6 class="TableContent">����</td>
    <td nowrap align="left" class="TableContent" >�ٵ�</td>
    <td nowrap align="center" class="TableData" ><div id="lateCount"></div></td>
    <td nowrap align="center" class="TableData" ><a  href="javascript:openDetail(1);" >��ϸ</a></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >����</td>  
    <td nowrap align="center" class="TableData" ><div id="ealyCount"></div></td>
    <td nowrap align="center" class="TableData" ><font color="#0066CC"><a  href="javascript:openDetail(2);" >��ϸ</a></font></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >���</td>
    <td nowrap align="center" class="TableData" ><div id="outCount"></div></td>
    <td nowrap align="center" class="TableData" ><font color="#0066CC"><a  href="javascript:openDetail(3);" >��ϸ</a></font></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >���</td>
    <td nowrap align="center" class="TableData" ><div id="leaveCount"></div></td>
    <td nowrap align="center" class="TableData" ><font color="#0066CC"><a  href="javascript:openDetail(4);" >��ϸ</a></font></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >����</td>  
    <td nowrap align="center" class="TableData" ><div  id="evectionCount"></div></td>
    <td nowrap align="center" class="TableData" ><font color="#0066CC"><a  href="javascript:openDetail(5);" >��ϸ</a></font></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >�Ӱ�</td>  
    <td nowrap align="center" class="TableData" ><div id="overtimeCount"></div></td>
    <td nowrap align="center" class="TableData" ><a  href="javascript:openDetail(6);" >��ϸ</a></td>
  </tr>
  <tr>
    <td nowrap align="left" rowspan=2 class="TableContent">����</td>
    <td nowrap align="left" class="TableContent" >����</td>  
    <td nowrap align="center" class="TableData" ><div id="awardCount"></div></td>
    <td nowrap align="center" class="TableData" ><a  href="javascript:openDetail(7);" >��ϸ</a></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >�ͷ�</td>
    <td nowrap align="center" class="TableData" ><div id="punishCount"></div></td>
    <td nowrap align="center" class="TableData" ><a  href="javascript:openDetail(8);" >��ϸ</a></td>
  </tr>
  <tr>
    <td nowrap align="left" rowspan=2 class="TableContent">�ճ�</td>
    <td nowrap align="left" class="TableContent" >����</td>  
    <td nowrap align="center" class="TableData" ><div id="calCount"></div></td>
    <td nowrap align="center" class="TableData" ></td>
  </tr>
  <tr>
  	<td nowrap align="left" class="TableContent" >�����</td>
    <td nowrap align="center" class="TableData" ><div id="calCount1"></div></td>
    <td nowrap align="center" class="TableData" ></td>
  </tr>
  <tr>
    <td nowrap align="left"  class="TableContent">��־</td>
    <td nowrap align="left" class="TableContent" >����</td>  
    <td nowrap align="center" class="TableData" ><div id="diaryCount"></div></td>
    <td nowrap align="center" class="TableData" ><a  href="javascript:openDetail(9);" >��ϸ</a></td>
  </tr>
  <tr>
    <td nowrap align="left"  class="TableContent">����</td>
    <td nowrap align="left" class="TableContent" >����</td>  
    <td nowrap align="center" class="TableData" ><div id="checkCount"></div></td>
    <td nowrap align="center" class="TableData" ><a  href="javascript:openDetail(10);" >��ϸ</a></td>
  </tr>
  <tr align="center" class="TableControl">
    <td colspan="4">
      <input type="button" value="�ر�" class="BigButton" onClick="window.close();" title="�رմ���">
    </td>
  </tr>
</table>
</body>

</html>
