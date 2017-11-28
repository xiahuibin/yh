function ShowDoc() {
  $('ocLog').style.display = "none";
  $('TANGER_OCX').style.display = "block";
}
/**
 * 日志处理
 * 
 * @return
 */
function ShowLog() {
  logPage.show();
  var total = logPage.pageInfo.totalRecord;
  if(total){
    showCntrl('list');
  }else{
    WarningMsrg('该文档暂无日志记录', 'msrg');
  }
  if ($('ocLog').style.display == "none") {
    $('ocLog').style.display = "block";
    $('TANGER_OCX').style.display = "none";
    if ($('ocLog').innerText == "")
      GetLog();
  } else {
    $('ocLog').style.display = "none";
    $('TANGER_OCX').style.display = "block";
  }
}
/**
 * 得到日志
 * 
 * @param req
 * @return
 */
function GetLog(req) {/*
                       * if (isUndefined(req)) { } else if (req.status == 200) {
                       * $('ocLog').innerHTML = req.responseText; }
                       */
  $('TANGER_OCX').style.display = "";
  alert('开发中');
}

function isUndefined() {
  return false;
}
/**
 * 保留痕迹
 * 
 * @param flag
 * @return
 */
function MY_SetMarkModify(flag) {
  if (flag) {
    //$('mflag1').className = "TableControl";
    //$('mflag2').className = "TableData";
  } else {
    //$('mflag1').className = "TableData";
    //$('mflag2').className = "TableControl";
  }
  TANGER_OCX_SetMarkModify(flag);
}
/**
 * 显示/隐藏痕迹
 * 
 * @param flag
 * @return
 */
function MY_ShowRevisions(flag) {
  if (flag) {
    $('sflag1').className = "TableControl";
    $('sflag2').className = "TableData";
  } else {
    $('sflag1').className = "TableData";
    $('sflag2').className = "TableControl";
  }
  TANGER_OCX_ShowRevisions(flag);
}

function SelSign() {
  var SelSign = $("SelSign");
  if (SelSign.style.display == "") {
    SelSign.style.display = "none";
  } else {
    SelSign.style.display = "";
  }
}
function SelSignFromURL(div_id, dir_field, name_field, disk_id) {
  alert("开发中");
}
/**
 * 隐藏显示控件
 * 
 * @param cntrlId
 * @return
 */
function showCntrl(cntrlId) {
  if ($(cntrlId)) {
    if ($(cntrlId).style.display) {
      $(cntrlId).style.display = '';
    } else {
      $(cntrlId).style.display = 'none';
    }
  }
}
 /**
  * 设置控件的现实

  * @param op
  * @param secOcMark
  * @param secOcMarkDefault
  * @return
  */
 function setOpView(op, secOcMark, secOcMarkDefault,attachMentName,secOcRevision) {
   if (op == 4 || op == 6) {
     showCntrl("doc_fun");
     if (op == 4) {
       showCntrl("doc_fun_save");
       showCntrl("doc_fun_save_local");
       showCntrl("doc_fun_pageSet");
     }
     showCntrl("doc_fun_print");
     showCntrl("doc_fun_log");
   }
  // showCntrl("doc_fun_save");
   //secOcMark[0allow_save | 1 must_save| 2 allow_save| 3 forbid_save]
   if (!isExtName(attachMentName,".ppt")) {//文件编辑的现实

     if (op == 4 && (!isExtName(attachMentName,".xls")
         && !isExtName(attachMentName,".et")
         && !isExtName(attachMentName,".ett"))) {
       if (secOcMark == "2" || secOcMark == "0") {// 允许保留
         if (secOcMarkDefault == "0") {// 默认不保留

           //$("mflag1").className = "TableData";
           //$("mflag2").className = "TableControl";
         } else if (secOcMarkDefault == "1") {// 默认保留
           //$("mflag1").className = "TableControl";
           //$("mflag2").className = "TableData";
         }
       } else if (secOcMark == "1") {// 强制保留
         //$("mflag1").className = "TableControl";
         //$("mflag2").style.display = "none";
       } else if (secOcMark == "3") {// 强制不保留

         //$("mflag2").className = "TableControl";
         //$("mflag1").style.display = "none";
       }
       showCntrl("doc_edit");
       //showCntrl("doc_edit_saveMark");
       //showCntrl("doc_edit_noMark");
       if(secOcRevision == "1" ){
         MY_ShowRevisions(true);
       }else{
         MY_ShowRevisions(false);
       }
       showCntrl("doc_edit_showRev");
       showCntrl("doc_edit_disRev");
       
       showCntrl("doc_edit_redWord");
       if(isStamp == 'true'){
        showCntrl("doc_edit_addPic");
       }
     }
     showCntrl("e_id");//电子印章的显示

     showCntrl("e_id_check");
     if (op == 4) {
       showCntrl("e_id_handSign2");
       showCntrl("e_id_handDraw2");
       showCntrl("e_id_handSign1");
       showCntrl("e_id_handDraw1");
       showCntrl("e_id_addSign1");
       //showCntrl("e_id_addSign2");
       //showCntrl("e_id_addSign3");
     }
   }
 }
/**
 * 套红模板
 * @return
 */
function selectword() {   
  var URL = contextPath + "/core/funcs/office/ntko/wordModelView.jsp?secOcMark=" + secOcMark;
  var myleft =( screen.availWidth - 650) / 2;
  window.open(URL,"formul_edit","height=350,width=400,status=0,toolbar=no,menubar=no,location=no,scrollbars=yes,top=150,left="+myleft+",resizable=yes");
}
function findStr(str,search){
  var i = (str.toString()).indexOf(search);
  if(i == -1){
    return false;
  }else{
    return true;
  }
}

/**
 * 消息提示
 * @param msrg
 * @param cntrlId 绑定消息的控件

 * @param type  消息类型[info|error||warning|forbidden|stop|blank] 默认为info
 * @return
 */
function WarningMsrg(msrg, cntrlId,type ) {
  var msrgDom = "<table class=\"MessageBox\" align=\"center\" width=\"380\">";
  if(!type){
    type = "info";
  }
  msrgDom += " <tr>  <td class=\"msg " + type + "\">"
  msrgDom +=  "<div class=\"content\" style=\"font-size:12pt\">" + msrg + "</div>"
      + " </td> </tr> </table>";
  $(cntrlId).innerHTML = msrgDom;
}
/**
 *取得系统相关设置
 * @return
 */
function getMarkSetting(){
  var URL = contextPath + "/yh/core/funcs/office/ntko/act/YHNtkoAct/getOcMarkSet.act";
  var rtJson = getJsonRs(URL);
  if(rtJson.rtState == "0"){
    return rtJson.rtData;
  }else {
    return "";
  }
}

/**
 * 
 * @param op
 * @return
 */
function lockRef(attachmentId,lockOp){
  var url = contextPath + "/yh/core/funcs/office/ntko/act/YHNtkoAct/lockRef.act?attachmentId=" + attachmentId + "lockOp=" + lockOp ;
  var rtJson = getJsonRs(url);
  if(rtJson.rtState == "0"){
    if(rtJson.rtData.sysTime){
      setTimeout("lockRef('" + attachmentId + "');",rtJson.rtData.sysTime*1000);
    }
  }else {
    alert(rtJson.rtMsrg);
  }
}

function isCanEidt(attachmentId){
  var url = contextPath + "/yh/core/funcs/office/ntko/act/YHNtkoAct/isCanEdit.act?attachmentId=" + attachmentId;
  var rtJson = getJsonRs(url);
  if(rtJson.rtState == "0"){
   return rtJson.rtData;
  }else {
    alert(rtJson.rtMsrg);
    return "";
  }
}
/**
 * 取得日志
 * @param attachId
 * @return
 */
function getLogPageMgr(cntrlId,attachId){
  var url =  contextPath + "/yh/core/funcs/office/ntko/act/YHNtkoAct/getOcLog.act?attachId=" + attachId;
  var cfgs = {
    dataAction: url,
    container: cntrlId,
    colums: [
       {type:"hidden", name:"seqId", width: 60, dataType:"int"},
       {type:"data", name:"logTime", text:"时间", width: 200, dataType:"dateTime",format:'yyyy-mm-dd'},   
       {type:"data", name:"logUid", text:"人员", width: 150,render:userRender},
       {type:"data", name:"logType", text:"操作", width: 120,render:renderLogType},
       {type:"data", name:"ip", text:"IP", width: 200}   
       ]
  };
  var pageMgr = new YHJsPage(cfgs);
  return pageMgr;
}

function getLog(){
  logPage.refreshPage(0);
  //logPage.show();
  var total = logPage.pageInfo.totalRecord;
  if(total){
    $('list').style.display = "";
    if ($('msrg')) {
      $('msrg').hide();
    }
  }else{
    $('list').style.display = "none";
    WarningMsrg('该文档暂无日志记录', 'msrg');
  }
}
/**
 * 
 * @param cellData
 * @param recordIndex
 * @param columIndex
 * @return
 */
function userRender(cellData, recordIndex, columIndex) {
  //alert(cellData);
  var emailBodyId = this.getCellData(recordIndex,"emailBodyId");
  var cellDataStr = cellData.toString();
  var userName = getUserNameById(cellData);
  return "<span id=\"span_" + recordIndex + "_" + columIndex + "\">" + userName + "</span>";
}
/**
 * 取得用户姓名
 * @return
 */
function getUserNameById(userId){
  var url = contextPath + "/yh/core/funcs/diary/act/YHDiaryAct/getUserName.act";
  var rtJson = getJsonRs(url , "userId=" +  userId);
  if(rtJson.rtState == '0'){
    return rtJson.rtData;
  }
}
function renderLogType(cellData, recordIndex, columIndex){
  if(cellData == "1" || cellData == "5"){
    return "<span id=\"span_" + recordIndex + "_" + columIndex + "\">下载</span>";
  }else{
    return "<span id=\"span_" + recordIndex + "_" + columIndex + "\">保存</span>";
  }
}
function isExtName(fileName,extName){
  if(!fileName){
    return;
  }
  if(!extName){
    return;
  }
  var index = fileName.lastIndexOf(".");
  var extName2 = "";

  if (index >= 0) {
    extName2 = fileName.substring(index).toLowerCase();
  }
  if(extName2 == extName){
    return true;
  }else{
    return false;
  }
}

function crc32 ( str ) {
  // Calculate the crc32 polynomial of a string
  // 
  // version: 1004.2314
  // discuss at: http://phpjs.org/functions/crc32 // + original by:
  // Webtoolkit.info (http://www.webtoolkit.info/)
  // + improved by: T0bsn
  // - depends on: utf8_encode
  // * example 1: crc32('Kevin van Zonneveld');
  // * returns 1: 1249991249 
  str = this.Utf8Encode(str);
  var table = "00000000 77073096 EE0E612C 990951BA 076DC419 706AF48F E963A535 9E6495A3 0EDB8832 79DCB8A4 E0D5E91E 97D2D988 09B64C2B 7EB17CBD E7B82D07 90BF1D91 1DB71064 6AB020F2 F3B97148 84BE41DE 1ADAD47D 6DDDE4EB F4D4B551 83D385C7 136C9856 646BA8C0 FD62F97A 8A65C9EC 14015C4F 63066CD9 FA0F3D63 8D080DF5 3B6E20C8 4C69105E D56041E4 A2677172 3C03E4D1 4B04D447 D20D85FD A50AB56B 35B5A8FA 42B2986C DBBBC9D6 ACBCF940 32D86CE3 45DF5C75 DCD60DCF ABD13D59 26D930AC 51DE003A C8D75180 BFD06116 21B4F4B5 56B3C423 CFBA9599 B8BDA50F 2802B89E 5F058808 C60CD9B2 B10BE924 2F6F7C87 58684C11 C1611DAB B6662D3D 76DC4190 01DB7106 98D220BC EFD5102A 71B18589 06B6B51F 9FBFE4A5 E8B8D433 7807C9A2 0F00F934 9609A88E E10E9818 7F6A0DBB 086D3D2D 91646C97 E6635C01 6B6B51F4 1C6C6162 856530D8 F262004E 6C0695ED 1B01A57B 8208F4C1 F50FC457 65B0D9C6 12B7E950 8BBEB8EA FCB9887C 62DD1DDF 15DA2D49 8CD37CF3 FBD44C65 4DB26158 3AB551CE A3BC0074 D4BB30E2 4ADFA541 3DD895D7 A4D1C46D D3D6F4FB 4369E96A 346ED9FC AD678846 DA60B8D0 44042D73 33031DE5 AA0A4C5F DD0D7CC9 5005713C 270241AA BE0B1010 C90C2086 5768B525 206F85B3 B966D409 CE61E49F 5EDEF90E 29D9C998 B0D09822 C7D7A8B4 59B33D17 2EB40D81 B7BD5C3B C0BA6CAD EDB88320 9ABFB3B6 03B6E20C 74B1D29A EAD54739 9DD277AF 04DB2615 73DC1683 E3630B12 94643B84 0D6D6A3E 7A6A5AA8 E40ECF0B 9309FF9D 0A00AE27 7D079EB1 F00F9344 8708A3D2 1E01F268 6906C2FE F762575D 806567CB 196C3671 6E6B06E7 FED41B76 89D32BE0 10DA7A5A 67DD4ACC F9B9DF6F 8EBEEFF9 17B7BE43 60B08ED5 D6D6A3E8 A1D1937E 38D8C2C4 4FDFF252 D1BB67F1 A6BC5767 3FB506DD 48B2364B D80D2BDA AF0A1B4C 36034AF6 41047A60 DF60EFC3 A867DF55 316E8EEF 4669BE79 CB61B38C BC66831A 256FD2A0 5268E236 CC0C7795 BB0B4703 220216B9 5505262F C5BA3BBE B2BD0B28 2BB45A92 5CB36A04 C2D7FFA7 B5D0CF31 2CD99E8B 5BDEAE1D 9B64C2B0 EC63F226 756AA39C 026D930A 9C0906A9 EB0E363F 72076785 05005713 95BF4A82 E2B87A14 7BB12BAE 0CB61B38 92D28E9B E5D5BE0D 7CDCEFB7 0BDBDF21 86D3D2D4 F1D4E242 68DDB3F8 1FDA836E 81BE16CD F6B9265B 6FB077E1 18B74777 88085AE6 FF0F6A70 66063BCA 11010B5C 8F659EFF F862AE69 616BFFD3 166CCF45 A00AE278 D70DD2EE 4E048354 3903B3C2 A7672661 D06016F7 4969474D 3E6E77DB AED16A4A D9D65ADC 40DF0B66 37D83BF0 A9BCAE53 DEBB9EC5 47B2CF7F 30B5FFE9 BDBDF21C CABAC28A 53B39330 24B4A3A6 BAD03605 CDD70693 54DE5729 23D967BF B3667A2E C4614AB8 5D681B02 2A6F2B94 B40BBE37 C30C8EA1 5A05DF1B 2D02EF8D";

  var crc = 0;
  var x = 0;    
  var y = 0;

  crc = crc ^ (-1);
  for (var i = 0, iTop = str.length; i < iTop; i++) {
      y = ( crc ^ str.charCodeAt( i ) ) & 0xFF;       
      x = "0x" + table.substr( y * 9, 8 );
      crc = ( crc >>> 8 ) ^ x;
  }
  return crc ^ (-1);
}
function Utf8Encode(string) { 
  string = string.replace(/\r\n/g,"\n"); 
  var utftext = ""; 
  for (var n = 0; n < string.length; n++) { 
    var c = string.charCodeAt(n); 
    if (c < 128) { 
      utftext += String.fromCharCode(c); 
    } else if((c > 127) && (c < 2048)) { 
      utftext += String.fromCharCode((c >> 6) | 192); 
      utftext += String.fromCharCode((c & 63) | 128); 
    } else { 
      utftext += String.fromCharCode((c >> 12) | 224); 
      utftext += String.fromCharCode(((c >> 6) & 63) | 128); 
      utftext += String.fromCharCode((c & 63) | 128); 
    } 

  } 

  return utftext; 
}
//删除文本框

function DelTextBox(){
var shapes = TANGER_OCX_OBJ.ActiveDocument.Shapes;
var sCount = shapes.Count;
for(sCount;sCount>0;sCount--){
var shape = shapes.Item(sCount);
if(shape.Type==17){
shape.Delete();
}
}
}
function TANGER_OCX_AddDocMod1(URL,URL1){
  try{
    //选择对象当前文档的所有内容
    var BookMarkName = "zhengwen";
    var curSel = null ;
    
    curSel = TANGER_OCX_OBJ.ActiveDocument.Application.Selection;
    if (nowDocStyle) {
      TANGER_OCX_OBJ.ActiveDocument.BookMarks("tail").Select();
      if (curSel != null) {
        curSel.Delete();
      }
      
      TANGER_OCX_OBJ.ActiveDocument.BookMarks("head").Select();
      if (curSel != null) {
        curSel.Delete();
      }
      
      if ( TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists("head")) {
        TANGER_OCX_OBJ.ActiveDocument.BookMarks("head").Delete();
      }
      if ( TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists("tail")) {
        TANGER_OCX_OBJ.ActiveDocument.BookMarks("tail").Delete();
      }
      if (!$('docStyle').value) {
        return ;
      }
    } 
    if (!nowDocStyle) {
      curSel.TypeParagraph();
    }
    //插入模板
    curSel.HomeKey(6);
    TANGER_OCX_OBJ.AddTemplateFromURL(URL);
    
    if(!TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists(BookMarkName))
    {
      alert("Word 模板中不存在名称为：\""+BookMarkName+"\"的书签！");
      return;
    }
    TANGER_OCX_OBJ.ActiveDocument.BookMarks(BookMarkName).Select();
    curSel.CopyFormat();
    curSel.EndKey(6,1);
    curSel.PasteFormat();
    TANGER_OCX_OBJ.ActiveDocument.BookMarks(BookMarkName).Select();
    curSel.Delete();
    curSel.Delete(1,1);
    curSel.EndKey(6); 
    TANGER_OCX_OBJ.AddTemplateFromURL(URL1); 
    setDataToBookmark();
    curSel.CopyFormat();
  }
  catch(err)
  {
    alert("错误：" + err.number + ":" + err.description);
  }
}
function upateBookmark() {
  var flag = TANGER_OCX_OBJ.ActiveDocument.TrackRevisions;
  TANGER_OCX_SetMarkModify(false);
  setDataToBookmark();
  TANGER_OCX_SetMarkModify(flag);
}
function setDataToBookmark() {
  var runData = getRunData();
  if(runData !="" && runData.length > 0)
  {
   for(i=0;i < runData.length;i++)
   { 
     var BookMarkName = runData[i][0];
     if (!BookMarkName) {
       continue;
     }
     if(TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists(BookMarkName)) { 
        var str = runData[i][1];
        var patrn = /^[0-9]{1,20}$/;
        if (str && str.length == 2 && !patrn.exec(str) 
            && BookMarkName != "密级"
             && BookMarkName != "保密期限") {
          var str1 = str.substr(0,1);
          str = str1 + "  " + str.substr(1,1) ;
        }
        if (BookMarkName == "签发人" && !str) {
          str = "　　　";
        }
        if (BookMarkName == "成文日期" ) {
          str = getBigDate(str);
        }
        TANGER_OCX_OBJ.SetBookmarkValue(BookMarkName,str);
        if (!str && TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists(BookMarkName + "l")) {
          TANGER_OCX_OBJ.SetBookmarkValue(BookMarkName + "l","");
        }
      }
    }
    if(TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists("年月日")){
      var d = new Date();
      var dateStr = d.getYear() + "年" + (d.getMonth() + 1)+ "月" + d.getDate() + "日";
      while (dateStr.length < "2010年12月16日".length) {
        dateStr = " " + dateStr;
      }
      TANGER_OCX_OBJ.SetBookmarkValue("年月日",dateStr);
    }
    if(TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists("大写年月日")){
      var d = new Date();
      var dateStr = changeToBigYear(d.getYear().toString()) + "年" + changeToBigMonth(d.getMonth() + 1)+ "月" + changeToBigDate(d.getDate()) + "日";
      while (dateStr.length < "二〇一〇年十三月二十五日".length) {
        dateStr = " " + dateStr;
      }
      TANGER_OCX_OBJ.SetBookmarkValue("大写年月日",dateStr);
    }
  }
}
function getSmaillDate(str) {
  if (!str) {
    return "";
  }
  var strs = str.split("-");
  var year = strs[0];
  var month = strs[1];
  var day = strs[2];
  var dateStr = year + "年" + month+ "月" + day + "日";
  while (dateStr.length < "2010年12月16日".length) {
    dateStr = " " + dateStr;
  }
  return dateStr;
}
function getBigDate(str) {
  if (!str) {
    return "";
  }
  var strs = str.split("-");
  var year = strs[0];
  if (strs[1].charAt(0) == '0') {
    strs[1] = strs[1].substr(1);
  }
  if (strs[2].charAt(0) == '0') {
    strs[2] = strs[2].substr(1);
  }
  var month = parseInt(strs[1]);
  var day = parseInt(strs[2]);
  var dateStr = changeToBigYear(year) + "年" + changeToBigMonth(month)+ "月" + changeToBigDate(day) + "日";
  while (dateStr.length < "二〇一〇年十三月二十五日".length) {
    dateStr = " " + dateStr;
  }
  return dateStr;
}
/*
转化成大写的年月日

*/
function changeToBigYear(num) {
  
  var result = "";
  for (var i = 0 ;i < num.length ;i ++) {
    y = num.charAt(i);
    var y1 = "";
    if (y== 0) {
      y1 = "○";
    } else if(y == 1) {
      y1 = "一";
    } else if (y== 2) {
      y1 = "二";
    } else if (y==3) {
      y1 = "三";
    } else if (y == 4) {
      y1 = "四";
    } else if (y == 5) {
      y1 = "五";
    } else if (y == 6) {
      y1 = "六";
    } else if (y == 7) {
      y1 = "七";
    } else if (y == 8) {
      y1 = "八";
    } else if (y == 9) {
      y1 = "九";
    }
    result += y1;
  }
  return result;
}
function changeToBigMonth(y) {
  var y1 = "";
  if(y == 1) {
    y1 = "一";
  } else if (y== 2) {
    y1 = "二";
  } else if (y==3) {
    y1 = "三";
  } else if (y == 4) {
    y1 = "四";
  } else if (y == 5) {
    y1 = "五";
  } else if (y == 6) {
    y1 = "六";
  } else if (y == 7) {
    y1 = "七";
  } else if (y == 8) {
    y1 = "八";
  } else if (y == 9) {
    y1 = "九";
  } else if (y == 10) {
    y1 = "十";
  } else if (y == 11) {
    y1 = "十一";
  }else if (y == 12) {
    y1 = "十二";
  }
  return y1;
      
}
function changeToBigDate(y) {
  var y1 = "";
  if(y == 1) {
    y1 = "一";
  } else if (y== 2) {
    y1 = "二";
  } else if (y==3) {
    y1 = "三";
  } else if (y == 4) {
    y1 = "四";
  } else if (y == 5) {
    y1 = "五";
  } else if (y == 6) {
    y1 = "六";
  } else if (y == 7) {
    y1 = "七";
  } else if (y == 8) {
    y1 = "八";
  } else if (y == 9) {
    y1 = "九";
  } else if (y == 10) {
    y1 = "十";
  } else if (y == 11) {
    y1 = "十一";
  } else if (y == 12) {
    y1 = "十二";
  }else if (y == 13) {
    y1 = "十三";
  }else if (y == 14) {
    y1 = "十四";
  }else if (y == 15) {
    y1 = "十五";
  }else if (y == 16) {
    y1 = "十六";
  }else if (y == 17) {
    y1 = "十七";
  }else if (y == 18) {
    y1 = "十八";
  }else if (y == 19) {
    y1 = "十九";
  }else if (y == 20) {
    y1 = "二十";
  }else if (y == 21) {
    y1 = "二十一";
  }else if (y == 22) {
    y1 = "二十二";
  }else if (y == 23) {
    y1 = "二十三";
  }else if (y == 24) {
    y1 = "二十四";
  }else if (y == 25) {
    y1 = "二十五";
  }else if (y == 26) {
    y1 = "二十六";
  }else if (y == 27) {
    y1 = "二十七";
  }else if (y == 28) {
    y1 = "二十八";
  }else if (y == 29) {
    y1 = "二十九";
  }else if (y == 30) {
    y1 = "三十";
  }else if (y == 31) {
    y1 = "三十一";
  }
  return y1;
      
}
//页码设置
/*
名称   值  描述 
wdAlignPageNumberCenter   1  居中。 
wdAlignPageNumberInside   3  只在页脚内部左对齐。 
wdAlignPageNumberLeft     0  左对齐。 
wdAlignPageNumberOutside  4  只在页脚外部右对齐。 
wdAlignPageNumberRight    2  右对齐。 
*/
function pageNumber(){
  //curSel = TANGER_OCX_OBJ.ActiveDocument.Application.Selection;
  //TANGER_OCX_OBJ.ActiveDocument.Sections(1).PageSetup.OddAndEvenPagesHeaderFooter = true;
 // TANGER_OCX_OBJ.ActiveDocument.Sections(1).Footers(1).PageNumbers..NumberStyle = "";
 // var foot = TANGER_OCX_OBJ.ActiveDocument.Sections(1).Footers(1);
 // foot.PageNumbers.Add(2,true);
//  
//  var bulding = TANGER_OCX_OBJ.ActiveDocument.AttachedTemplate.BuildingBlockEntries("普通数字 3");
//  bulding.Insert(foot.Range, true);

  //TANGER_OCX_OBJ.ActiveDocument.AttachedTemplate.BuildingBlockEntries("普通数字 3");
  //TANGER_OCX_OBJ.ActiveDocument.Sections(2).Footers(1).PageNumbers.Add(0,true);
}


