<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%
  String startDateStr = request.getParameter("startDate") == null ? "" :   request.getParameter("startDate");
  String endDateStr = request.getParameter("endDate") == null ? "" :   request.getParameter("endDate") ;
  String userId = request.getParameter("userId") == null ? "" :  request.getParameter("userId");
  String attachmentName = request.getParameter("attachmentName") == null ? "" :   YHUtility.encodeSpecial(request.getParameter("attachmentName")) ;
  String subject = request.getParameter("subject") == null ? "" :   YHUtility.encodeSpecial(request.getParameter("subject")) ;
  String key1 = request.getParameter("key1") == null ? "" :   YHUtility.encodeSpecial(request.getParameter("key1") );
  String key2 = request.getParameter("key2") == null ? "" :   YHUtility.encodeSpecial(request.getParameter("key2")) ;
  String key3 = request.getParameter("key3") == null ? "" :  YHUtility.encodeSpecial(request.getParameter("key3"));
  String diaType = request.getParameter("diaType") == null ? "" :  request.getParameter("diaType") ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%=cssPath %>/page.css">
<link rel="stylesheet" href ="<%=cssPath %>/style.css">
<script type="text/javascript" src="<%=contextPath %>/core/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/tab.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/datastructs.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/smartclient.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/page.js"></script>
<script type="text/javascript" src="<%=contextPath%>/core/js/cmp/Menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/cmp/attachMenu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryUtil.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/funcs/diary/js/diaryLogic.js"></script>
<title>????????????</title>
<script type="text/javascript">
function bindsubjectRenderAction() {
  
}
var pageMgr = null;
var userId = "<%=userId%>";
function doInit() {
  var param = "attachmentName=<%=attachmentName%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>&subject=<%=subject%>&key1=<%=key1%>&key2=<%=key2%>&key3=<%=key3%>&userId=<%=userId%>&diaType=<%=diaType%>";
  param = encodeURI(param);
  var url =  contextPath + "/yh/core/funcs/diary/act/YHDiaryAct/searchDiarySelf.act?" + param;
  var cfgs = {
    dataAction: url,
    container: "listContainer",
    moduleName:"diary",
    colums: [
       {type:"selfdef", text:"??????", width: 40,render:checkBoxRender},
       {type:"hidden", name:"seqId", text:"?????????", width: 150, dataType:"int"},
       {type:"data", name:"diaDate", text:"??????", width: 150, dataType:"date"},       
       {type:"data", name:"subject", text:"????????????", width: 150,render:subjectRender, bindAction:bindsubjectRenderAction},
       {type:"data", name:"attach", text:"??????", width: 350, dataType:"attach"},
       {type:"hidden", name:"attachId"},
       {type:"selfdef", text:"??????", width: 40,render:commentRender},
       {type:"selfdef", text:"??????",width: 200, render:optRender}]
  };
  pageMgr = new YHJsPage(cfgs);
  pageMgr.show();
  var total = pageMgr.pageInfo.totalRecord;
  if(total){
    showCntrl('listContainer');
    var mrs = " ??? "+ total + " ????????? ???";
    WarningMsrg(mrs, 'msrg');
    showCntrl('delOpt');
  }else{
    WarningMsrg('??????????????????', 'msrg');
  }
}
function bindTitle(userId){
  var userName = getUserNameById(userId);
  $('ser_title').innerHTML = "["+ userName + "--- ??????????????????]";
}
/**
 * subject ????????????
 */
function optRender(cellData, recordIndex, columIndex) {
  var cntrl = $("sub_" + recordIndex + "_" + columIndex);
  var diaDate =  this.getCellData(recordIndex,"diaDate");
  var diaId = this.getCellData(recordIndex,"seqId");
  var html = "<a id=\"a1_" + recordIndex + "_" + columIndex + "\" href=\"javascript:showReader('"+ diaId + "');\">????????????</a>" + "&nbsp;";
  if(!isLocked(cutDate(diaDate))){
    html += "<a id=\"a2_" + recordIndex + "_" + columIndex + "\" href=\"javascript:editDiary('"+ diaId + "');\">??????</a>";
  }
  return html; 
}
/**
 * subject ??????
 */
function subjectRender(cellData, recordIndex, columIndex) {
  //alert(cellData);
  var diaId = this.getCellData(recordIndex,"seqId");
  return "<A  id=\"sub_" + recordIndex + "_" + columIndex + "\" href=\"" + contextPath + "/core/funcs/diary/comment/index.jsp?diaId=" + diaId + "\">" + cellData + "</A >";
}
/**
 * 
 */
 function checkBoxRender(cellData, recordIndex, columIndex){
   var diaId = this.getCellData(recordIndex,"seqId");
   var diaDate =  this.getCellData(recordIndex,"diaDate");
   var count = isComment(diaId);
   if(count != "0" || isLocked(cutDate(diaDate))){
      return "";
    }
   return "<input type=\"checkbox\" name=\"check_diay_search\" value=\"" + diaId + "\" onclick=\"checkSelf()\" >";
 }
 
 function commentRender(cellData, recordIndex, columIndex){
   var diaId = this.getCellData(recordIndex,"seqId");
   var count = isComment(diaId);
   if(count != "0" ){
      return "<A  id=\"comment_" + recordIndex + "_" + columIndex + "\"  href=\"" + contextPath + "/core/funcs/diary/comment/index.jsp?diaId=" + diaId + "\"> ?????? </A >";
    }
   return "";
 }
 function checkSearchAll(){
   var checkArray = $$('input');
   for(var i = 0 ; i < checkArray.length ; i++){
     if(checkArray[i].name == "check_diay_search" ){
      checkArray[i].checked = $('allbox').checked ;
     }
   }
 }
 function checkSelf(){
    var allCheck = $('allbox');
    if(allCheck.checked){
      allCheck.checked = false;
    }
}
 function del(){
   var ids = "";
   var checkArray = $$('input');
   for(var i = 0 ; i < checkArray.length ; i++){
     if(checkArray[i].name == "check_diay_search" && checkArray[i].checked ){
       if(ids != ""){
         ids += ",";
       }
       ids += checkArray[i].value;
     }
   }
   deleteDiary(ids);
 }
 function goBack(){
   location = contextPath + "/core/funcs/diary/query/index.jsp";
 }
</script>
</head>
<body onload="doInit()">
<div align="center" class="Big1">
<b id="ser_title"></b>
</div>
<br>

<table border="0" width="100%" cellspacing="0" cellpadding="3" class="small">
  <tr>
    <td class="Big"><img src="<%=imgPath%>/diary.gif" WIDTH="18" HEIGHT="18" align="absmiddle"><span class="big3"> ????????????</span>
    </td>
  </tr>
</table>
<div id="listContainer" style="display:none">
</div>
<div id="delOpt" style="display:none">
  <input type="checkbox"  id="allbox" onClick="checkSearchAll();">
  <label for="allbox">??????</label> &nbsp;
  <input type="button"  value="??????" class="SmallButton" onClick="del();" title="??????????????????"> &nbsp;
</div>
<div id="msrg">
</div>
<center>
 <input type="button" class="SmallButton" onclick="javascript:goBack()" value="??????"></input>
</center>
</body>
</html>