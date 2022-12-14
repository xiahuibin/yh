var messageActionPath = contextPath + '/yh/core/funcs/webinfo/act/YHWebInfoAct';
function FCKeditor_OnComplete( editorInstance )
{
  editorInstance.Events.AttachEvent( 'OnBlur' , FCKeditor_OnBlur ) ;
  editorInstance.Events.AttachEvent( 'OnFocus', FCKeditor_OnFocus ) ;
}

function FCKeditor_OnBlur( editorInstance )
{
  editorInstance.ToolbarSet.Collapse() ;
}

function FCKeditor_OnFocus( editorInstance )
{
  editorInstance.ToolbarSet.Expand() ;
}

function doInit(){
  $('fileCount').value = '0';
  getWebInfoList(0,10);
}
function getDate(){
  var gdCurDate=new Date();
  var giYear=gdCurDate.getFullYear();
  var giMonth=gdCurDate.getMonth()+1;
  var giDay=gdCurDate.getDate();
  var giHour = gdCurDate.getHours();
  var giMinutes = gdCurDate.getMinutes();
  var date = giYear + "-" + giMonth + "-" + giDay +" " + giHour + ":" + giMinutes;
  return date;
}
function addWebInof(){
  var flag = checkAddForm();
  if(flag){
    if(!confirm('内容已修改，还未保存如果继续内容将丢失！是否继续！')){
      return false;
    }
  }
  setEditor('','','',optName ? optName : "",getDate(),'',new Array(),true);
  var fckEditorDiv = $('fckEditor');
  fckEditorDiv.show();
  Form.focusFirstElement('webInfoForm');
}

function setEditor(fileName,content,webInfoTitle,webInfoUser,webInfoDate,webInfoKeyWord,attachments,isSave){
 
  $('attachFile').value = '';
 
  $('fileName').value = fileName;
 
  $('webInfoTitle').value = webInfoTitle;
  
  $('webInfoUser').value = webInfoUser;
  
  $('webInfoDate').value = webInfoDate;
 
  $('webInfoKeyWord').value = webInfoKeyWord;
 
  removeAllChildren($('attachmentName'));
  removeAllChildren($('attachmentPath'));
  removeAllChildren($('uploadDiv'));
  $('fileCount').value = '0';
  for(var i =0 ; i < attachments.length ;i++){
    var attachment = attachments[i];
    var aName = attachment.fileName;
    var aPath = attachment.filePath;
    addAttachment(aName , aPath);
  }
  
  var fckEditorDiv = $('fckEditor');
  var submitOld = $('submitButton');
  if(submitOld != null){
    fckEditorDiv.removeChild(submitOld);
  }
  var cancleButtonOld  = $('cancleButton');
  if(cancleButtonOld != null){
    fckEditorDiv.removeChild(cancleButtonOld);
  }
  var submit = $C('input');
  submit.id = 'submitButton';
  submit.className = 'ArrowButton';
  submit.setAttribute('type','button');
  
  if(isSave){
    submit.setAttribute('value','提交');
 
    Event.observe($(submit),"click",saveWebInfo.bindAsEventListener(this));
  }else{
    submit.setAttribute('value','修改');
    Event.observe($(submit),"click",updateWebInfo.bindAsEventListener(this));
  }
  var cancle = $C('input');
  cancle.id = 'cancleButton';
  cancle.className = 'ArrowButton';
  cancle.setAttribute('type','button');
  cancle.setAttribute('value','取消');
  
  $(cancle).observe("click",cancleAddWebInfo.bindAsEventListener(this));
 
 
  fckEditorDiv.appendChild(submit);
  fckEditorDiv.appendChild(cancle);
  var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
  oEditor.SetData(content);
 
}
function $C(tag){
  return document.createElement(tag);
}
function createWebInfo(parentDiv,i,title1,keyWord,date,user,content,path,attachments,isReturn){
  
  var divDate = $C('div');
  with(divDate){
    id = 'webInfoDate-' + i;
    className = 'dateDivStyle';
    appendChild(document.createTextNode('时间：'+date));
  }
 
  var divTitle = $C('div');
  with(divTitle){
    id = 'webInfoTitle-' + i;
    className = 'titleDivStyle';
    appendChild(document.createTextNode('标题：'+title1));
  }
 
  var divUser = $C('div');
  with(divUser){
    id = 'webInfoUser-' + i;
    className = 'userDivStyle';
    appendChild(document.createTextNode('发布人：'+user));
  }
  var divHead = $C('div');
  with(divHead){
    id = 'webInfoHead-' + i;
    className = 'webInfoHeadDivStyle';
    appendChild(divDate);
    appendChild(divTitle);
    appendChild(divUser);
  }
 
  var divContent = $C('div');
  with(divContent){
    id = 'webInfoContent-' + i;
    className = 'contentDivStyle';
    innerHTML = content;
  }
  
  var divKey = $C('div');
  with(divKey){
    id = 'webInfoKey-' + i;
    className = 'keyWordDivStyle';
    appendChild(document.createTextNode('关键字：'+keyWord));
  }
  var divAttachment = $C('div');
  if(attachments.length>0){
    with(divAttachment){
      id = 'attachment-' + i;
      
      className = 'attachmentDivStyle';
    }
    var attachmentStr = '附件:';
    for(var i = 0 ;i<attachments.length ; i++){
      var attachment = attachments[i];
      var aName = attachment.fileName;
      var aPath = attachment.filePath;
      attachmentStr += '<a href="javascript:readAttachment(\'' + aPath + '\')">' + aName + '</a>,';
    }
    divAttachment.innerHTML = attachmentStr;
  }
 
  var divEditor = $C('div');
  with(divEditor){
    id = 'webInfoEditor-' + i;
    className = 'editDivStyle';
    var button = $C('input');
    button.setAttribute('type','buttton');
    button.value = '编辑';
    button.className = 'ArrowButton';
    button.type = 'button';
    $(button).observe("click",editWebInfo.bindAsEventListener(this,path));
    appendChild(button);
  }
 
  var divDelete = $C('div');
  with(divDelete){
    id = 'webInfoDelete-' + i;
    className = 'deleteDivStyle';
    var button = $C('input');
    button.setAttribute('type','buttton');
    button.className = 'ArrowButton';
    button.value = '删除';
    button.type = 'button';
    $(button).observe("click",deleteWebInfo.bindAsEventListener(this,path));
    appendChild(button);
  }
  var divRead = $C('div');
  with(divRead){
    id = 'webInfoRead-' + i;
    className = 'readDivStyle';
    var button = $C('input');
    button.setAttribute('type','buttton');
    button.className = 'SmallButtonW';
    button.type = 'button';
    if(!isReturn){
      button.value = '查看全文';
      $(button).observe("click",readContent.bindAsEventListener(this,path));
    }else{
      button.value = '返回';
      button.onclick = function(){
        getWebInfoList(0,10);
      }
    }
    appendChild(button);
  }

  
  var webInfoPath = $C('input');
  with(webInfoPath){
    type = 'hidden';
    id = 'webInfoPath-'+i;
    value = path;
  }
  
  var divFoot = $C('div');
  with(divFoot){
    id = 'webInfoFoot-' + i;
    className = 'webInfoFootDivStyle';
    appendChild(divKey);
    appendChild(divAttachment);
    appendChild(divEditor);
    appendChild(divDelete);
    appendChild(divRead);
    appendChild(webInfoPath);
  }
  var divWebInfo =  $C('div');
  with(divWebInfo){
    id = 'divWebInfo-' + i;
    className = 'webInfoDivStyle';
    appendChild(divHead);
    appendChild(divContent);
    appendChild(divFoot);
  }
  parentDiv.appendChild(divWebInfo);
 
}
function saveWebInfo(){
  if(!checkWebInfoForm()){
    alert("检查失败");
    return false;
  }
 
  var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
 
  var param = $('webInfoForm').serialize()+'&content='+ encodeURIComponent(oEditor.GetXHTML());
  param = param  + '&baseFilePath=' + $F('baseFilePath');
  var json = getJsonRs(messageActionPath + "/doSave.act", param);
  if(json.rtState == '0'){
    alert(json.rtMsrg);
    cancleAddWebInfo();
    removeAllChildren('container');
    getWebInfoList(0,10);
  }else{
    alert(text);
  }
}
function updateWebInfo(){
  if(!checkWebInfoForm()){
    return false;
  }
  var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
  var param = $('webInfoForm').serialize()+'&content='+ encodeURIComponent(oEditor.GetXHTML());
  param = param  + '&baseFilePath=' + $F('baseFilePath');
 
  var  json = getJsonRs(messageActionPath + "/doUpdate.act", param);
  if(json.rtState == '0'){
    alert(json.rtMsrg);
    cancleAddWebInfo();
    removeAllChildren('container');
    //alert($F('stepTo')-1 + ":" + $F('listLength'));
    getWebInfoList(parseInt($F('stepTo'))-1,$F('listLength'));
  }else{
    alert(text);
  }
}
 
function checkWebInfoForm(){
 
  var msg = $('msg');
  var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
  // 是否所有的字段都已填写？
 
  var valid = $('webInfoTitle').present() && $('webInfoUser').present() && $('webInfoDate').present()&& oEditor.GetXHTML( true )!="";
 
  if (valid) {
    msg.update('带*项为必填').style.color = 'blue';
 
    return true;
  }
  else {
    msg.update('带*项为必填').style.color = 'red';
    return false;
  }
 
}
function cancleAddWebInfo(){
  $('msg').update('带*项为必填').style.color = 'blue';
  setEditor('','','','',getDate(),'',new Array(),true);
  $('fckEditor').hide();
}
function getWebInfoList(pageIndex,listLength){
  var url = messageActionPath + '/getWebInfoList.act';
  var param = 'pageIndex=' +  pageIndex + '&listLength=' + listLength + '&' + $('searchStr').serialize();
  param = param  + '&baseFilePath=' + $F('baseFilePath');
  var json = getJsonRs(url, param);
 
  var parentDiv = $('container');
  var pageCount = json.pageCount;
  var webInfoCount = json.webInfoCount;
  var pageIndex = json.pageIndex;
  var listLength = json.listLength;
  var searchStr = json.searchStr;
  $('searchStr').value = searchStr;
  $('pageCount').innerHTML = pageCount;
  $('webInfoCount').innerHTML = webInfoCount;
 
  removeAllChildren($('stepTo'));
  for(var i = 1 ; i <= parseInt(pageCount) ; i++){
    var option = $C('option');
    option.value = i;
    option.appendChild(document.createTextNode(i));
    $('stepTo').appendChild(option);
  }
  $('stepTo').value = parseInt(pageIndex) + 1;
  $('listLength').value = listLength;
  addEvent(pageIndex,pageCount);
  removeAllChildren(parentDiv);
  var codes = json.list;
  for(var i = 0 ;i < codes.length ;i++){
    var code = codes[i];
    
    var title1 = code.webInfoTitle;
    var keyWord = code.webInfoKeyWord;
    var date = code.webInfoDate;
    var path = code.fileName;
    var user = code.webInfoUser;
    var content = unescape(code.content);
   
    createWebInfo(parentDiv,i,title1,keyWord,date,user,content,path,code.attachments,false);
  }
}
function addEvent(pageIndex,pageCount){
 
  var listLength = $F('listLength');
 
  $('lastPage').onclick = function(){
    getWebInfoList(parseInt(pageCount) - 1,listLength);
  };
  if(parseInt(pageIndex) + 1> parseInt(pageCount) - 1){
    $('nextPage').onclick = function(){
      getWebInfoList(parseInt(pageCount)-1,listLength);
    };
  }else{
    $('nextPage').onclick=function(){
      getWebInfoList(parseInt(pageIndex) + 1,listLength);
    };
  }
  if(parseInt(pageIndex) - 1 < 0){
    $('previousPage').onclick=function(){
      getWebInfoList(0,listLength);
    };
  }else{
    $('previousPage').onclick=function(){
      getWebInfoList(parseInt(pageIndex) - 1,listLength);
    };
  }
 
}
function removeAllChildren(parentNode){
  parentNode = $(parentNode);
  while(parentNode.firstChild){
    var oldNode = parentNode.removeChild(parentNode.firstChild);
    oldNode = null;
  }
}
function editWebInfo(){
  var pathName = arguments[1];
  var url = messageActionPath + '/getWebInfoByName.act';
  var param = 'name=' + pathName;
  param = param  + '&baseFilePath=' + $F('baseFilePath');
  var json = getJsonRs(url, param);
 
  if(json.rtState!=null){
    var msg = '错误的状态：' + json.rtState + ',提示：' + json.rtMsrg + ',' + json.rtData;
    alert(msg);
    return ;
  }
  
  var title1 = json.webInfoTitle;
  var keyWord = json.webInfoKeyWord;
  var date = json.webInfoDate;
  var fileName = json.fileName;
  var user = json.webInfoUser;
  var content = unescape(json.content);
  setEditor(fileName,content,title1,user,date,keyWord,json.attachments,false);
  var fckEditorDiv = $('fckEditor');
  fckEditorDiv.show();
  Form.focusFirstElement('webInfoForm');
}
function deleteWebInfo(){
  if(!confirm('你确定删除它')){
    return ;
  }
  var pathName = arguments[1];
  var url = messageActionPath + '/doDelete.act';
  var param = 'name=' + pathName;
  param = param  + '&baseFilePath=' + $F('baseFilePath');
  var json = getJsonRs(url, param);
 
  if(json.rtState == '0'){
    alert(json.rtMsrg);
    cancleAddWebInfo();
    removeAllChildren('container');
    getWebInfoList(0,10);
  }else{
    alert(text);
  }
}
function goToPage(){
  var pageIndex = arguments[1];
  getWebInfoList(pageIndex,$F('listLength'));
}
function pageChange(selected){
  var pageIndex = parseInt($F(selected))-1;
  getWebInfoList(pageIndex,$F('listLength'));
}
function addAttachment(aName,aPath){
  var count = parseInt($F('fileCount'))+1;
  var attachmentName = $('attachmentName');
  var attachmentPath = $('attachmentPath');
  var input = $C('input');
  with(input){
    type = 'hidden';
    id = 'fileName-'+count;
    name = 'fileName-'+count;
    value = aName;
  }
  $('attachmentName').appendChild(input);
  input = $C('input');
  with(input){
    type = 'hidden';
    id = 'filePath-'+count;
    name = 'filePath-'+count;
    value = aPath;
  }
  $('attachmentPath').appendChild(input);
  var div = $C('div');
  div.id = 'fileDiv-' + count;
  div.name = 'fileDiv-' + count;
  
  var readStr = '<a href="javascript:readAttachment(\'' + aPath + '\')">阅读</a>';
  var downStr = '<a href="javascript:downAttachment(\'' + aPath + '\')">下载</a>';
  var deleteStr = '<a href="javascript:deleteAttachment(\'' + aPath + '\')">删除</a>';
  if(aPath.indexOf('.doc') != -1||aPath.indexOf('.docx') != -1){
    div.innerHTML = aName + '||' + readStr + '||' + downStr + '||' + deleteStr ;
  }else{
    div.innerHTML = aName + '||'  + downStr + '||' + deleteStr ; 
  }
  $('uploadDiv').appendChild(div);
  $('fileCount').value = count;
  $('attachmentForm').hide();
}
function deleteAttachment(aPath){
  if(!confirm('你确定删除它')){
    return ;
  }
  var fileName = $F('fileName');
  var url = messageActionPath + '/deleteAttachment.act';
  var param = 'attachmentPath=' + aPath + '&fileName='+ fileName;
  param = param  + '&baseFilePath=' + $F('baseFilePath');
  var json = getJsonRs(url, param);
  if(json.rtState == '0'){
    var id ;
    var attachments = $('attachmentPath').getElementsByTagName('input');
    for(var i = 0 ; i < attachments.length ; i++){
      var attachment = attachments[i];
      if(attachment.value == aPath){
        id = attachment.id.substr(9);
        $('attachmentPath').removeChild(attachment);
        break;
      }
    }
    $('attachmentName').removeChild($('fileName-'+id));
    $('uploadDiv').removeChild($("fileDiv-"+id));
    $('fileCount').value =  parseInt($F('fileCount')) - 1;
   
  }else{
    alert(text);
  }
}
function checkAttachForm(){
  if($('attachFile').present()){
    return true;
  }else{
    alert('文件为空');
    $('attachFile').focus();
    return false;
  }
}
function checkAddForm(){
  if($('webInfoTitle').present()){
    return true;
  }
  else return false;
  if($('webInfoUser').present()){
    return true;
  }
  else return false;
  if(oEditor.GetXHTML( true )!=""){
    return true;
  }
  else return false;
}
function showAttachmentForm(){
  $('attachFile').value = '';
  $('attachmentForm').show();
}
function downAttachment(aPath){
  
  var url = contextPath + '/getFile?uploadFileNameServer=' + $F('baseFilePath') + '/attachment/' + aPath;
  window.open(url);
}
function readAttachment(aPath){
  if(aPath.indexOf('.doc') != -1 || aPath.indexOf('.xls') != -1 ){
    var url = contextPath + '/core/funcs/webinfo/office.jsp?'
    + 'filePath=' + $F('baseFilePath')
    + '&attachmentName=' + aPath;
    window.open(encodeURI(url)); 
  }
}
function readContent(){
  var pathName = arguments[1];
  var url = messageActionPath + '/getWebInfoByName.act';
  var param = 'name=' + pathName ;
  param = param  + '&baseFilePath=' + $F('baseFilePath');
  var json = getJsonRs(url, param);
 
  if(json.rtState!=null){
    var msg = '错误的状态：' + json.rtState + ',提示：' + json.rtMsrg + ',' + json.rtData;
    alert(msg);
    return ;
  }
  var title1 = json.webInfoTitle;
  var keyWord = json.webInfoKeyWord;
  var date = json.webInfoDate;
  var fileName = json.fileName;
  var user = json.webInfoUser;
  var content = unescape(json.content);
  var parentDiv = $('container');
  var pageCount = 1;
  var webInfoCount = 1;
  var pageIndex = 0;
  var listLength = 10;
  var searchStr = "";
  $('searchStr').value = searchStr;
  $('pageCount').innerHTML = pageCount;
  $('webInfoCount').innerHTML = webInfoCount;
 // $('webInfoCount').innerHTML = webInfoCount;
  removeAllChildren($('stepTo'));
  for(var i = 1 ; i <= parseInt(pageCount) ; i++){
    var option = $C('option');
    option.value = i;
    option.appendChild(document.createTextNode(i));
    $('stepTo').appendChild(option);
  }
  $('stepTo').value = parseInt(pageIndex) + 1;
  $('listLength').value = listLength;
  addEvent(pageIndex,pageCount);
  removeAllChildren(parentDiv);
  createWebInfo(parentDiv,1,title1,keyWord,date,user,content,fileName,json.attachments,true);
  
}
