var TANGER_OCX_bDocOpen = false;
var TANGER_OCX_strOp;
var TANGER_OCX_filename;
var TANGER_OCX_attachName;
var TANGER_OCX_attachURL; //for use with OpenFromURL
var TANGER_OCX_actionURL; //For auto generate form fiields
var TANGER_OCX_OBJ; //The Control
var TANGER_OCX_user; //登录用户

//以下为V1.7新增函数示例

//从本地增加图片到文档指定位置
function AddPictureFromLocal()
{
  if(TANGER_OCX_bDocOpen)
  {
    TANGER_OCX_OBJ.AddPicFromLocal(
  "", //路径
  true,//是否提示选择文件
  true,//是否浮动图片
  100,//如果是浮动图片，相对于左边的Left 单位磅
  100); //如果是浮动图片，相对于当前段落Top
  };
}

//从URL增加图片到文档指定位置
function AddPictureFromURL(URL)
{
  if(TANGER_OCX_bDocOpen)
  {
    TANGER_OCX_OBJ.AddPicFromURL(
  URL,//URL 注意；URL必须返回Word支持的图片类型。
  true,//是否浮动图片
  150,//如果是浮动图片，相对于左边的Left 单位磅
  150);//如果是浮动图片，相对于当前段落Top
  };
}

//从本地增加印章文档指定位置
function AddSignFromLocal(key)
{
   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.AddSignFromLocal(
  TANGER_OCX_user,//当前登陆用户
  "",//缺省文件
  true,//提示选择
  0,//left
  0,//top
  key)
   }
}

//从URL增加印章文档指定位置
function AddSignFromURL(URL,key)
{
   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.AddSignFromURL(
  TANGER_OCX_user,//当前登陆用户
  URL,//URL
  50,//left
  50, //top
  key)
   }
}

//开始手写签名
function DoHandSign(key)
{
   if(TANGER_OCX_bDocOpen)
   {
  TANGER_OCX_OBJ.DoHandSign(
  TANGER_OCX_user,//当前登陆用户 必须
  0,//笔型0－实线 0－4 //可选参数
  0x000000ff, //颜色 0x00RRGGBB//可选参数
  2,//笔宽//可选参数
  100,//left//可选参数
  50, //top//可选参数
  null,
  key);
   }
}

//开始全屏手写签名
function DoHandSign2(key)
{
   if(TANGER_OCX_bDocOpen)
   {
  TANGER_OCX_OBJ.DoHandSign2(
  TANGER_OCX_user,//当前登陆用户 必须
  key, //SignKey
  0,//left//可选参数
  0,//top
  0,//relative=0，表示按照屏幕位置批注
  100 //缩放100%，表示原大小
        );
   }
}

//开始手工绘图，可用于手工批示
function DoHandDraw()
{
  if(TANGER_OCX_bDocOpen)
  {
  TANGER_OCX_OBJ.DoHandDraw(
  0,//笔型0－实线 0－4 //可选参数
  0x00ff0000,//颜色 0x00RRGGBB//可选参数
  3,//笔宽//可选参数
  200,//left//可选参数
  50//top//可选参数
  );
  }
}

//开始全屏手工绘图，可用于手工批示
function DoHandDraw2()
{
  if(TANGER_OCX_bDocOpen)
  {
  TANGER_OCX_OBJ.DoHandDraw2();
  }
}

//检查签名结果
function DoCheckSign(key)
{
  if(TANGER_OCX_bDocOpen)
  {
     var ret = TANGER_OCX_OBJ.DoCheckSign(false,key);

     //可选参数 IsSilent 缺省为FAlSE，表示弹出验证对话框,否则，只是返回验证结果到返回值
     //alert(ret);
  }
}
//以下为以前版本的函数和实用函数
//此函数用来加入一个自定义的文件头部
function TANGER_OCX_AddDocHeader( strHeader )
{
  var i,cNum = 15;
  var lineStr = "";
  try
  {
    for(i=0;i<cNum;i++) lineStr += "_";  //生成下划线
    with(TANGER_OCX_OBJ.ActiveDocument.Application)
    {
      Selection.HomeKey(6,0); // go home
      Selection.TypeText(strHeader);
      Selection.TypeParagraph();  //换行
      Selection.TypeText(lineStr);  //插入下划线
      // Selection.InsertSymbol(95,"",true); //插入下划线
      Selection.TypeText("★");
      Selection.TypeText(lineStr);  //插入下划线
      Selection.TypeParagraph();
      //Selection.MoveUp(5, 2, 1); //上移两行，且按住Shift键，相当于选择两行
      Selection.HomeKey(6,1);  //选择到文件头部所有文本
      Selection.ParagraphFormat.Alignment = 1; //居中对齐
      with(Selection.Font)
      {
        NameFarEast = "宋体";
        Name = "宋体";
        Size = 22;
        Bold = true;
        Italic = false;
        Underline = 0;
        UnderlineColor = 0;
        StrikeThrough = false;
        DoubleStrikeThrough = false;
        Outline = false;
        Emboss = false;
        Shadow = false;
        Hidden = false;
        SmallCaps = false;
        AllCaps = false;
        Color = 255;
        Engrave = false;
        Superscript = false;
        Subscript = false;
        Spacing = 0;
        Scaling = 100;
        Position = 0;
        Kerning = 0;
        Animation = 0;
        DisableCharacterSpaceGrid = false;
        EmphasisMark = 0;
      }
      Selection.MoveDown(5, 3, 0); //下移3行
    }
  }
  catch(err){
    //alert("错误：" + err.number + ":" + err.description);
  }
  finally{
  }
}

//如果原先的表单定义了OnSubmit事件，保存文档时首先会调用原先的事件。
function TANGER_OCX_doFormOnSubmit()
{
  var form = document.forms[0];
    if (form.onsubmit)
  {
      var retVal = form.onsubmit();
      if (typeof retVal == "boolean" && retVal == false)
        return false;
  }
  return true;
}

/*此函数在较低版本的IE浏览器中，用来代替
//Javascript的escape函数。
function TANGER_OCX_encodeObjValue(value)
{
  var t;
  t = value.replace(/%/g,"%25");
  return(t.replace(/&/g,"%26"));
}
*/
//此函数用来产生自动将表单数据创建成为
//控件的SaveToURL函数所需要的参数。返回
//一个paraObj对象。paraObj.FFN包含表单的
//最后一个<input type=file name=XXX>的name
//paraObj.PARA包含了表单的其它数据，比如：
//f1=v1&f2=v2&f3=v3.其中,v1.v2.v3是经过
//Javascript的escape函数编码的数据。如果IE
//的版本较低，可以使用上面注释掉的TANGER_OCX_encodeObjValue
//函数代替下面的escape函数。
function TANGER_OCX_genDominoPara(paraObj)
{
  var fmElements = document.forms[0].elements;
  var i,j,elObj,optionItem;
  for (i=0;i< fmElements.length;i++ )
  {
    elObj = fmElements[i];
    switch(elObj.type)
    {
      case "file":
        paraObj.FFN = elObj.name;
        break;
      case "reset":
        break;
      case "radio":
      case "checkbox":
        if (elObj.checked)
        {
          paraObj.PARA += ( elObj.name+"="+escape(elObj.value)+"&");
        }
        break;
      case "select-multiple":
        for(j=0;j<elObj.options.length;j++)
        {
          optionItem = elObj.options[j];
          if (optionItem.selected)
          {
            paraObj.PARA += ( elObj.name+"="+escape(optionItem.value)+"&");
          }
        }
        break;
      default: // text,Areatext,selecte-one,password,submit,etc.
        if(elObj.name)
        {
          paraObj.PARA += ( elObj.name+"="+escape(elObj.value)+"&");
        }
        break;
    }
  }
}

//设置文档为只读
function TANGER_OCX_SetReadOnly(boolvalue)
{
  var appName,i;
  try
  {
    if (boolvalue) TANGER_OCX_OBJ.IsShowToolMenu = false;
    with(TANGER_OCX_OBJ.ActiveDocument)
    {
      appName = new String(Application.Name);
      if( (appName.toUpperCase()).indexOf("WORD") > -1 ) //Word
      {
        if (ProtectionType != -1 &&  !boolvalue)
        {
          Unprotect();
        }
        if (ProtectionType == -1 &&  boolvalue)
        {
          Protect(2,true,"");
        }
      }
      else if ( (appName.toUpperCase()).indexOf("EXCEL") > -1 ) //EXCEL
      {
        for(i=1;i<=Application.Sheets.Count;i++)
        {
          if(boolvalue)
          {
            Application.Sheets(i).Protect("",true,true,true);
          }
          else
          {
            Application.Sheets(i).Unprotect("");
          }
        }
        if(boolvalue)
        {
          Application.ActiveWorkbook.Protect("",true);
        }
        else
        {
          Application.ActiveWorkbook.Unprotect("");
        }
      }
      else
      {
      }
    }
  }
  catch(err){
    //alert("错误：" + err.number + ":" + err.description);
  }
  finally{
  }
}

//允许或禁止用户从控件拷贝数据
function TANGER_OCX_SetNoCopy(boolvalue)
{
  TANGER_OCX_OBJ.IsNoCopy = boolvalue;
}

//允许或禁止文件－>新建菜单
function TANGER_OCX_EnableFileNewMenu(boolvalue)
{
  TANGER_OCX_OBJ.EnableFileCommand(0) = boolvalue;
}
//允许或禁止文件－>打开菜单
function TANGER_OCX_EnableFileOpenMenu(boolvalue)
{
  TANGER_OCX_OBJ.EnableFileCommand(1) = boolvalue;
}
//允许或禁止文件－>保存菜单
function TANGER_OCX_EnableFileSaveMenu(boolvalue)
{
  TANGER_OCX_OBJ.EnableFileCommand(3) = boolvalue;
}
//允许或禁止文件－>另存为菜单
function TANGER_OCX_EnableFileSaveAsMenu(boolvalue)
{
  TANGER_OCX_OBJ.EnableFileCommand(4) = boolvalue;
}
//允许或禁止文件－>打印菜单
function TANGER_OCX_EnableFilePrintMenu(boolvalue)
{
  TANGER_OCX_OBJ.EnableFileCommand(5) = boolvalue;
}
//允许或禁止文件－>打印预览菜单
function TANGER_OCX_EnableFilePrintPreviewMenu(boolvalue)
{
  TANGER_OCX_OBJ.EnableFileCommand(6) = boolvalue;
}

//允许或禁止显示修订工具栏和工具菜单（保护修订）
function TANGER_OCX_EnableReviewBar(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.CommandBars("Reviewing").Enabled = boolvalue;
  TANGER_OCX_OBJ.ActiveDocument.CommandBars("Track Changes").Enabled = boolvalue;
  TANGER_OCX_OBJ.IsShowToolMenu = boolvalue;  //关闭或打开工具菜单
}

//打开或者关闭修订模式
function TANGER_OCX_SetReviewMode(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = boolvalue;
}

//进入或退出痕迹保留状态，调用上面的两个函数
function TANGER_OCX_SetMarkModify(boolvalue)
{
  TANGER_OCX_SetReviewMode(boolvalue);
  //TANGER_OCX_EnableReviewBar(!boolvalue);
}

//显示/不显示修订文字
function TANGER_OCX_ShowRevisions(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.ShowRevisions = boolvalue;
}

//打印/不打印修订文字
function TANGER_OCX_PrintRevisions(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.PrintRevisions = boolvalue;
}

//设置用户名
function TANGER_OCX_SetDocUser(cuser)
{
  with(TANGER_OCX_OBJ.ActiveDocument.Application)
  {
    UserName = cuser;
  }
}

//设置页面布局
function TANGER_OCX_ChgLayout()
{
  try
  {
    TANGER_OCX_OBJ.showdialog(5); //设置页面布局
  }
  catch(err){
    alert("错误：" + err.number + ":" + err.description);
  }
  finally{
  }
}

//打印文档
function TANGER_OCX_PrintDoc()
{
  try
  {
    TANGER_OCX_OBJ.printout(true);
  }
  catch(err){
    alert("错误：" + err.number + ":" + err.description);
  }
  finally{
  }
}
//此函数在网页装载时被调用。用来获取控件对象并保存到TANGER_OCX_OBJ
//同时，可以设置初始的菜单状况，打开初始文档等等。
function TANGER_OCX_SetInfo()
{
  var info;
  TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
  TANGER_OCX_EnableFileNewMenu(false);
  TANGER_OCX_EnableFileOpenMenu(false);
  TANGER_OCX_EnableFileSaveMenu(false);
  TANGER_OCX_EnableFileSaveAsMenu(false);
  try
  {
    TANGER_OCX_actionURL = document.forms[0].action;
    TANGER_OCX_strOp = document.all.item("TANGER_OCX_op").innerHTML;
    TANGER_OCX_filename = document.all.item("TANGER_OCX_filename").innerHTML;
    TANGER_OCX_attachName = document.all.item("TANGER_OCX_attachName").innerHTML;
    TANGER_OCX_attachURL = document.all.item("TANGER_OCX_attachURL").innerHTML;
    TANGER_OCX_user = document.all.item("TANGER_OCX_user").innerHTML;

    re=/&amp;/g;
    TANGER_OCX_attachURL=TANGER_OCX_attachURL.replace(re,"&");

    if (TANGER_OCX_OBJ.IsHiddenOpenURL)
    {
      TANGER_OCX_attachURL = TANGER_OCX_HiddenURL(TANGER_OCX_attachURL);
    }
    //alert(TANGER_OCX_attachURL);

    switch(TANGER_OCX_strOp)
    {
      case "1":
        info = "新Word文档";
        TANGER_OCX_OBJ.CreateNew("Word.Document");
        break;
      case "2":
        info = "新Excel工作表";
        TANGER_OCX_OBJ.CreateNew("Excel.Sheet");
        break;
      case "3":
        info = "新PowserPoint幻灯片";
        TANGER_OCX_OBJ.CreateNew("PowerPoint.Show");
        break;
      case "4":
        info = "编辑文档";
        if(TANGER_OCX_attachURL)
        {
        	encodeURI(TANGER_OCX_attachURL);
          TANGER_OCX_OBJ.BeginOpenFromURL(encodeURI(TANGER_OCX_attachURL));
        }
        else
        {
          TANGER_OCX_OBJ.CreateNew("Word.Document");
        }
        break;
      case "5":
        info = "阅读文档";
        if(TANGER_OCX_attachURL)
        {
          TANGER_OCX_OBJ.OpenFromURL(TANGER_OCX_attachURL,true);
        }
        break;
      default:
        info = "未知操作";
    }
    //document.all.item("TANGER_OCX_info").innerHTML = info + "&nbsp;&nbsp;" + TANGER_OCX_filename;
    if(TANGER_OCX_filename.indexOf(".ppt")<0 && TANGER_OCX_filename.indexOf(".PPT")<0 )
       TANGER_OCX_SetDocUser(TANGER_OCX_user);
  }
  catch(err){
    //alert("错误：" + err.number + ":" + err.description);
    msg='不能使用微软Office软件打开文档！\n\n是否尝试使用金山WPS文字处理软件打开文档？';
    /*
    if(window.confirm(msg))
    {
       if(TANGER_OCX_strOp==4)
         TANGER_OCX_OBJ.OpenFromURL(TANGER_OCX_attachURL,false,"WPS.Document");
       else
         TANGER_OCX_OBJ.OpenFromURL(TANGER_OCX_attachURL,true,"WPS.Document");
    }
    */
  }
  finally{
  }
}
//此函数在文档关闭时被调用。
function TANGER_OCX_OnDocumentClosed()
{
  TANGER_OCX_bDocOpen = false;
}
//此函数用来保存当前文档。主要使用了控件的SaveToURL函数。
//有关此函数的详细用法，请参阅编程手册。
function TANGER_OCX_SaveDoc(op_flag)
{
  var retStr=new String;
  var newwin,newdoc;
  var paraObj = new Object();
  paraObj.PARA="";
  paraObj.FFN ="";
  try
  {
    if(!TANGER_OCX_doFormOnSubmit())return;
    TANGER_OCX_genDominoPara(paraObj);
    //alert(paraObj.PARA);
    //alert(paraObj.FFN);
    alert(TANGER_OCX_actionURL);
    alert(TANGER_OCX_filename);
    if(!paraObj.FFN)
    {
      alert("参数错误：控件的第二个参数没有指定。");
      return;
    }
    if(!TANGER_OCX_bDocOpen)
    {
      alert("没有打开的文档。");
      return;
    }
    switch(TANGER_OCX_strOp)
    {
      case "1":
      case "2":
      case "3":
      case "4":
        retStr = TANGER_OCX_OBJ.SaveToURL(TANGER_OCX_actionURL,paraObj.FFN,paraObj.PARA,TANGER_OCX_filename);
        //newwin = window.open("OFFICE_SAVE","_blank","left=200,top=200,width=400,height=200,status=0,toolbar=0,menubar=0,location=0,scrollbars=0,resizable=0",false);
        //newdoc = newwin.document;
        //newdoc.open();
        //newdoc.close();
        window.alert(retStr);
        if(op_flag==1)
        {
                 close_op_flag=1;
                 window.close();
        }
        break;
      case "5":
        alert("文档处于阅读状态，您不能保存到服务器。");
      default:
        break;
    }
  }
  catch(err){
    alert("不能保存到URL：" + err.number + ":" + err.description);
  }
  finally{
  }
}

//此函数在文档打开时被调用。
function TANGER_OCX_OnDocumentOpened(str, obj)
{
  var s, s2;
  try
  {
    TANGER_OCX_bDocOpen = true;
    if( 0==str.length)
    {
      str = TANGER_OCX_filename;
    }
    //TANGER_OCX_OBJ.Caption = TANGER_OCX_filename + " - 在线文档编辑器";
    TANGER_OCX_OBJ.Caption = TANGER_OCX_filename;
    s = "未知应用程序";
    if(obj)
    {
      switch(TANGER_OCX_strOp)
      {
        case "1":
        case "2":
        case "3":
        case "4":
          TANGER_OCX_SetReadOnly(false);
          break;
        case "5":
          TANGER_OCX_SetReadOnly(true);
          break;
        default:
          break;
      }
      s = obj.Application.Name;
    }
    //document.all.item("TANGER_OCX_mes").innerHTML =  str + "&nbsp;&nbsp;应用程序: " + s;
  }
  catch(err){
    window.status = "OnDocumentOpened事件的Script产生错误。" + err.number + ":" + err.description;
  }
  finally{
  }
}