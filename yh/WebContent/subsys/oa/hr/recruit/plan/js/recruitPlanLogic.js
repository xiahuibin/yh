/**
 * 获取下拉框选项
 * getSecretFlag("T_COURSE_TYPE","tCourseTypes");
 * @param parentNo	代码编号
 * @param optDiv	绑定的div
 * @param extValue  要选中的值

 * @return
 */
function getSecretFlag(parentNo,optDiv,extValue){
	var requestURLStr = contextPath + "/yh/subsys/oa/hr/setting/act/YHHrCodeAct/selectChildCode.act?parentNo=" + parentNo;
	var rtJson = getJsonRs(requestURLStr);
	if(rtJson.rtState == "1"){
	  alert(rtJson.rtMsrg); 
	  return ;
	}
	var prcs = rtJson.rtData;
	var selects = document.getElementById(optDiv);
	for(var i=0;i<prcs.length;i++){
	  var prc = prcs[i];
	  var option = document.createElement("option"); 
	  option.value = prc.seqId; 
	  option.innerHTML = prc.codeName; 
	  selects.appendChild(option);
	  if(extValue && (extValue == prc.value)){
      option.selected = true;
    }
	}
}

/**
 * 截取时间
 * @param cellData
 * @param recordIndex
 * @param columInde
 * @return
 */
function splitDateFunc(cellData, recordIndex,columInde) {
	var str = "";
	if(cellData){
		str = cellData.substr(0,10);
	}
  return "<center>" + str + "</center>";
}

/**
 * 操作
 * @param cellData
 * @param recordIndex
 * @param columIndex
 * @return
 */
function opts(cellData, recordIndex, columIndex){
	var seqId = this.getCellData(recordIndex,"seqId");
	var planStatus = this.getCellData(recordIndex,"planStatus");
	var planStatusStr = "";
	if(planStatus == 0)
	  planStatusStr = "<a href=javascript:doEdit(" + seqId + ")>编辑</a>&nbsp;&nbsp;";
	return "<center>"
				+ "<a href=javascript:detail(" + seqId + ")>详细信息</a>&nbsp;&nbsp;"
				+ planStatusStr
				+ "<a href=javascript:deleteSingle(" + seqId + ")>删除</a>"
				+ "</center>";
}
function doEdit(seqId){
	location.href = contextPath + "/subsys/oa/hr/recruit/plan/modify.jsp?seqId=" + seqId;
}
/**
 * 详细信息
 * @param seqId
 * @return
 */
function detail(seqId){
  var URL = contextPath + "/subsys/oa/hr/recruit/plan/detail.jsp?seqId=" + seqId;
  newWindow(URL,'820', '500');
}
/**
 * 打开新窗口  newWindow(URL,'740', '540');
 * @param url
 * @param width
 * @param height
 * @return
 */
function newWindow(url,width,height){
	var locX=(screen.width-width)/2;
	var locY=(screen.height-height)/2;
	window.open(url, "meeting", 
			"height=" +height + ",width=" + width +",status=1,toolbar=no,menubar=no,location=no,scrollbars=yes, top=" 
			+ locY + ", left=" + locX + ", resizable=yes");
}
function deleteSingle(seqId){
	if(!window.confirm("确认要删除该招聘计划信息 ？")){
		return ;
	}
	var requestURLStr = contextPath + "/yh/subsys/oa/hr/recruit/plan/act/YHHrRecruitPlanAct";
	var url = requestURLStr + "/deleteFile.act";
	var rtJson = getJsonRs(url, "seqId=" + seqId );
	if (rtJson.rtState == "0") {
		window.location.reload();
	}else {
	 alert(rtJson.rtMsrg); 
	}
}
/**
 * 删除多个文件
 * @return
 */
function deleteAll(){
  var idStrs = checkMags('deleteFlag');
  if(!idStrs) {
    alert("要删除招聘计划信息，请至少选择其中一个。");
    return;
  }
  if(!window.confirm("确认要删除已选中的招聘计划信息 ？")) {
    return ;
  } 
	var requestURLStr = contextPath + "/yh/subsys/oa/hr/recruit/plan/act/YHHrRecruitPlanAct";
	var url = requestURLStr + "/deleteFile.act";
	var rtJson = getJsonRs(url, "seqId=" + idStrs );
	if (rtJson.rtState == "0") {
		window.location.reload();
	}else {
	 alert(rtJson.rtMsrg); 
	}
}
function checkBoxRender(cellData, recordIndex, columIndex){
  var diaId = this.getCellData(recordIndex,"seqId");
    return "<center><input type=\"checkbox\" name=\"deleteFlag\" value=\"" + diaId + "\" onclick=\"checkSelf()\" ></center>";
}

/**
 * 全选
 * @param field
 * @return
 */
function checkAll(field) {
  var deleteFlags = document.getElementsByName("deleteFlag");
  for(var i = 0; i < deleteFlags.length; i++) {
    deleteFlags[i].checked = field.checked;
  }
}

function checkSelf(){
  var allCheck = $('checkAlls');
  if(allCheck.checked){
    allCheck.checked = false;
  }
}
//取得选中选项
function checkMags(cntrlId){
  var ids= ""
  var checkArray = $$('input');
  for(var i = 0 ; i < checkArray.length ; i++){
    if(checkArray[i].name == cntrlId && checkArray[i].checked ){
      if(ids != ""){
        ids += ",";
      }
      ids += checkArray[i].value;
    }
  }
  return ids;
}
/**
 * 判断小数位后２位
 * @param aValue
 * @return
 */
function isNumbers(aValue) { 
  var digitSrc = "0123456789"; 
  aValue = "" + aValue; 
  if (aValue.substr(0, 1) == "-") { 
    aValue = aValue.substr(1, aValue.length - 1); 
  } 
  var strArray = aValue.split("."); 
  // 含有多个“.” 
  if (strArray.length > 2) { 
    return false; 
  } 
  var tmpStr = ""; 
  for (var i = 0; i < strArray.length; i++) { 
    tmpStr += strArray[i]; 
  } 
  for (var i = 0; i < tmpStr.length; i++) { 
    var tmpIndex = digitSrc.indexOf(tmpStr.charAt(i)); 
    if (tmpIndex < 0) { 
  // 有字符不是数字 
      return false; 
    } 
  } 
  if(aValue.indexOf(".") != -1){
    var str = aValue.substr(aValue.indexOf(".")+1, aValue.length-1);
    if(str.length > 2){
      return false;
    }
    if(str.length == 0){
      return false;
    }
  }
  return true;
}




