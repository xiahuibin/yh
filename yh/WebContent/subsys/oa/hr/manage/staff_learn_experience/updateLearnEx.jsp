<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page  import="java.util.List"%>
<%@ page  import="yh.subsys.oa.hr.manage.staffLearnExperience.data.*"%> 
<html>
<head>
<%
String userName = (String)request.getAttribute("userName");
List<YHHrStaffLearnExperience> learnList = (List<YHHrStaffLearnExperience>)request.getAttribute("learnExsInfoList");
YHHrStaffLearnExperience learnEx = learnList.get(0);

String startdate="";//开始日期
String enddate = "";//结束日期
String startDate = String.valueOf(learnEx.getStartDate());
if(!YHUtility.isNullorEmpty(startDate) && startDate!="null"){
	startdate =	startDate.substring(0,10);
	}
String endDate = String.valueOf(learnEx.getEndDate());
if(!YHUtility.isNullorEmpty(endDate) && endDate!="null"){
	enddate =	endDate.substring(0,10);
	}
%>
<title>新建学习经历信息</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href = "<%=cssPath%>/cmp/Calendar.css">
<link rel="stylesheet" type="text/css" href="/inc/js/jquery/page/css/page.css"/>
<link rel="stylesheet" type="text/css" href="/theme/<?=$LOGIN_THEME?>/calendar.css"/>
<style>
.tip {position:absolute;display:none;text-align:center;font-size:9pt;font-weight:bold;z-index:65535;background-color:#DE7293;color:white;padding:5px}
.auto{text-overflow:ellipsis;white-space:nowrap;overflow:hidden;}
</style>
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
<script type="text/javascript" src="<%=contextPath %>/subsys/oa/hr/setting/codeJs/hrCodeJs.js"></script>
<script type="text/javascript">
/*****************附件上传开始*****************************/
var upload_limit=1,limit_type=limitUploadFiles;
var isUploadBackFun = false;
/*****************附件上传结束*****************************/
 function doOnload(){
	//时间
	  var parameters = {
	      inputId:'START_DATE',
	      property:{isHaveTime:false}
	      ,bindToBtn:'date1'
	  };
	  new Calendar(parameters);
	  var parameters = {
	      inputId:'END_DATE',
	      property:{isHaveTime:false}
	      ,bindToBtn:'date2'
	  };
	  new Calendar(parameters);
	  showAttachment();
}
 /** 
  * 替换s1为s2 
  */ 
  String.prototype.replaceAll = function(s1,s2){ 
     return this.replace(new RegExp(s1,"gm"),s2); 
  }
function CheckForm(){
	 var seqid = $("seqid").value;
	 var userName = $("userName").value;
	 if(userName.replaceAll(" ","") == "" || userName == "null"){
	      alert("单位员工不能为空");
	      return false;
   }
	if(document.form1.START_DATE.value!="" && document.form1.END_DATE.value!="" && document.form1.START_DATE.value > document.form1.END_DATE.value)
	   { 
	      alert("开始日期不能大于结束日期！");
	      return (false);
	   }                                    
	document.form1.action = contextPath +"/yh/subsys/oa/hr/manage/staffLearnExperience/act/YHNewLearnExperienceAct/updateLearnExperienceInfo.act?seqid="+seqid;
	document.form1.submit();
	return true;
	
}

function showAttachment(){
	var attachmentId = "<%=YHUtility.null2Empty(learnEx.getAttachmentId())%>";
	var attachmentName = "<%= YHUtility.encodeSpecial(YHUtility.null2Empty(learnEx.getAttachmentName()))%>";
	
	if(attachmentId){
		$("returnAttId").value = attachmentId;
		$("returnAttName").value = attachmentName;
		var selfdefMenu = {
         office:["downFile","dump","read","edit","deleteFile"], 
         img:["downFile","dump","play","deleteFile"],  
         music:["downFile","play","deleteFile"],  
         video:["downFile","play","deleteFile"], 
         others:["downFile","deleteFile"]
 	 }
  	attachMenuSelfUtil("attr","hr",$('returnAttName').value ,$('returnAttId').value, '','','<%=learnEx.getSeqId()%>',selfdefMenu);
	}
}

//删除附件
function deleteAttachBackHand(attachName,attachId,attrchIndex) { 
  var url = "<%=contextPath%>/yh/subsys/oa/hr/manage/staffLearnExperience/act/YHNewLearnExperienceAct/delFloatFile.act?delAttachId=" + attachId + "&seqId=<%=learnEx.getSeqId()%>";
  //var json = getJsonRs(url);
  var json=getJsonRs(url);
  if(json.rtState =='1'){
    alert(json.rtMsrg);
    return false;
  }else{
    prcsJson=json.rtData;
    var updateFlag=prcsJson.updateFlag;
    if(updateFlag == "1"){
      return true;
    }else{
      return false;
    }
  }
}

</script>
</head>
<body class="bodycolor" topmargin="5" onLoad="doOnload();">
<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td><img src="<%=imgPath %>/notify_new.gif" align="absmiddle"><span class="big3"> 新建学习经历信息</span>&nbsp;&nbsp;
    </td>
  </tr>
</table>
<br>
<form enctype="multipart/form-data" action="<%=contextPath%>/yh/subsys/oa/hr/manage/act/YHHrStaffIncentiveAct/addStaffincentiveInfo.act"  method="post" name="form1" id="form1" onsubmit="">
<table class="TableBlock" width="80%" align="center">
   <tr>
      <td nowrap class="TableData">单位员工：<font style="color:red">*</font></td>
      <td class="TableData">
        <input type="text" name="userName" id="userName" size="12" class="BigStatic" readonly value="<%=userName==null?"":userName %>">&nbsp;
        <INPUT type="hidden" name="userId" id="userId" value="<%=learnEx.getStaffName()==null?"":learnEx.getStaffName() %>">
        <a href="javascript:;" class="orgAdd" onClick="selectSingleUser(['userId', 'userName'],null,null,1)">选择</a>  
        <a href="javascript:;" class="orgClear" onClick="$('userId').value='';$('userName').value='';">清空</a>
      </td>
      <td nowrap class="TableData">所学专业：</td>
      <td class="TableData">
        <INPUT type="text" name="MAJOR" id="MAJOR"  class=BigInput size="15" value="<%=learnEx.getMajor()==null?"":learnEx.getMajor() %>">
         <input type="hidden" name="seqid" id = "seqid" value="<%=learnEx.getSeqId() %>"></input>
      </td>
    </tr>
    <tr>
    	 <td nowrap class="TableData">开始日期：</td>
      <td class="TableData">
       <input type="text" name="START_DATE" id="START_DATE" size="15" maxlength="10" class="BigInput" readonly value="<%=startdate==null?"":startdate %>"/>
       <img src="<%=imgPath%>/calendar.gif" id="date1" name="date1" align="absMiddle" border="0" style="cursor:hand">
      </td>
    	<td nowrap class="TableData">结束日期：</td>
      <td class="TableData">
       <input type="text" name="END_DATE" id="END_DATE" size="15" maxlength="10" class="BigInput" readonly value="<%=enddate==null?"":enddate %>" />
       <img src="<%=imgPath%>/calendar.gif" id="date2" name="date2" align="absMiddle" border="0" style="cursor:hand">
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">所获学历：</td>
      <td class="TableData">
        <INPUT type="text"name="ACADEMY_DEGREE" id="ACADEMY_DEGREE" class=BigInput size="15" value="<%=learnEx.getAcademyDegree()==null?"":learnEx.getAcademyDegree() %>">
      </td>
      <td nowrap class="TableData">所获学位：</td>
      <td class="TableData">
       <INPUT type="text"name="DEGREE" id="DEGREE" class=BigInput size="15" value="<%=learnEx.getDegree()==null?"":learnEx.getDegree() %>">
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">曾任班干：</td>
      <td class="TableData">
        <INPUT type="text"name="POSITION" id="POSITION" class=BigInput size="15" value="<%=learnEx.getPosition()==null?"":learnEx.getPosition() %>">
      </td>
      <td nowrap class="TableData">证明人：</td>
      <td class="TableData">
       <INPUT type="text" name="WITNESS" id="WITNESS" class=BigInput size="15" value="<%=learnEx.getWitness()==null?"":learnEx.getWitness() %>">
    </tr>
    <tr>
      <td nowrap class="TableData">所在院校：</td>
      <td class="TableData" colspan=3>
        <textarea name="SCHOOL" id="SCHOOL" cols="78" rows="3" class="BigInput" ><%=learnEx.getSchool()==null?"":learnEx.getSchool() %></textarea>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">院校所在地：</td>
      <td class="TableData" colspan=3>
        <textarea name="SCHOOL_ADDRESS" id="SCHOOL_ADDRESS" cols="78" rows="3" class="BigInput" ><%=learnEx.getSchoolAddress()==null?"":learnEx.getSchoolAddress() %></textarea>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">获奖情况：</td>
      <td class="TableData" colspan=3>
        <textarea name="AWARDING" id="AWARDING" cols="78" rows="3" class="BigInput" ><%=learnEx.getAwarding()==null?"":learnEx.getAwarding() %></textarea>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">所获证书：</td>
      <td class="TableData" colspan=3>
        <textarea name="CERTIFICATES" id="CERTIFICATES" cols="78" rows="3" class="BigInput"><%=learnEx.getCertificates()==null?"":learnEx.getCertificates() %></textarea>
      </td>
    </tr>
    <tr>
      <td nowrap class="TableData">备注：</td>
      <td class="TableData" colspan=3>
        <textarea name="REMARK" id="REMARK" cols="78" rows="3" class="BigInput"><%=learnEx.getRemark()==null?"":learnEx.getRemark() %></textarea>
      </td>
    </tr> 
    <tr id="attr_tr">
      <td noWrap="nowrap" class="TableData">附件文档: </td>
      <td class="TableData" noWrap="nowrap" colspan="3">
       	<input type = "hidden" id="returnAttId" name="returnAttId"></input>
				<input type = "hidden" id="returnAttName" name="returnAttName"></input>
			<span id="attr"></span>
      </td>
    </tr>
    <tr id="fileShowId">
      <td nowrap class="TableContent">附件上传：</td>
      <td class="TableData" id="fsUploadRow" colspan="3">
          <script>ShowAddFile();</script>
	    <script></script>
	    <script></script> 
			<input type="hidden" name="ATTACHMENT_ID_OLD" id="ATTACHMENT_ID_OLD" value="">
			<input type="hidden" name="ATTACHMENT_NAME_OLD"	id="ATTACHMENT_NAME_OLD" value="">
			<%--插入图片 --%>
			<input type="hidden" id="moduel" name="moduel" value="">
      <input type="hidden" id="imgattachmentId" name="imgattachmentId">
			<input type="hidden" id="imgattachmentName" name="imgattachmentName">
      &nbsp;</td>
    </tr>
    <tr align="center" class="TableControl">
      <td colspan=4 nowrap>
        <input type="button" onclick="javascript:CheckForm(); return false;" value="保存" name="button"  class="BigButton">
      </td>
    </tr>
  </table>
</form>
</body>
</html>