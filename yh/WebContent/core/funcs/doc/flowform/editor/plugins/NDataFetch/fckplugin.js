﻿//得到控件对象
var FCKObject = plugins({comName:"NDataFetch"
  ,item:"NDataFetch"
  ,page:"ndatafetch.jsp"
  ,inco:"data.gif"
  ,width:500
  ,height:350
  ,dlgTitle:"表单数据控件属性"
  ,btnTitle:"表单数据控件"
});
//为控件对象注测行为
//注册add 方法
function add(code){
  FCK.InsertHtml(code);
 // alert(code);
}
FCKObject.RegisterAction('Add',add);
//注册右键菜单命令
addMenuItem(new Object() , "deleteDataSelect" , deleteDs);

function deleteDs(){
  if(confirm("确定要删除？")){
    FCK.InsertHtml("") ;
  }
}
var DSMenuListener = new Object() ;
DSMenuListener.AddItems = function( contextMenu, tag, tagName ){
  if(tagName == 'BUTTON'
    && tag.className == "FETCH"){
    contextMenu.AddSeparator();
    contextMenu.AddItem('deleteDataSelect','删除控件');
    contextMenu.AddItem('NDataFetch','表单数据控件属性');
  }
}
FCK.ContextMenu.RegisterListener( DSMenuListener ) ;