/*
 * version 1.0
 * class:Dtree
 * 1.对象化形式,所有配置信息，放置到config中，提供缺省值设置,类中的方法，采用了封装形式写
 * 使用形式是：构造对象 >> 对非缺省的配置信息进行设置 >> 调用show方法显示 >> 对树进行操作
 * 2.修改了图片写法：imgPath + "/dtree/minus.gif";
 * 3.节点超链接事件响应，Javascript响应优先，超链接次之
 * 4.增加当前选中节点支持，方法getCurrNode()，没有选中则返回null,以及getNode()方法
 * 5.增加如下方法支持
 * addNode(nodeJsonObj)
 * removeNode(nodeId)
 * 6. 节点数据里，增加了图片和扩展数据，扩展数据放置到a标签中extData
 * 7.修改了顶层节点缩进



 * 8.标准化了节点的数据结构,与服务器交互统一采用json对象形式
 * 9. 增加新方法支持



 * getFirstNode()  : nodeId
 * open(nodeId)
 * close(nodeId)
 * click(nodeId)
 * 10.修正了在IE,fireFox,缩进兼容的问题



 * 11.增加了树id，一个页面不同的树指定不同的id，可以保证一个页面存在多棵树
 * 12.增加接口getCheckedList();修正checkbox的事件函数执行问题



 * 13.增加数据isChecked，主要是当加载时判断checkbox是否选中
 * 14.解决了一些 bug,增加了接口updateNode,nodeClick 等接口。


 * 15.解决ie6,7下不能选 中问题



 * 16.加入了点击第二个图标或者文字时只展开下一级不收缩功能 update by lh 2010-3-2
 * 17.解决中文url，乱码问题 update by lh 2010-3-23
 * 18.添加取得对应结点的根结点getRootNode,以及取得父级结点getParentNode.如果给定节点就是父结点或者是根元素则返回本身结点update by lh 2010-3-29
 */
/*
 提供的数据对象


 {rtState:"0", rtMsrg:"成功返回!", rtData:[
      {nodeId:'5',name:'1.1.3',isChecked:true,isHaveChild:1,extData:'1.1.3',imgAddrss:''}
      ,{nodeId:'4',name:'1.1.2',isHaveChild:0,extData:'1.1.3',imgAddrss:''}
      ,{nodeId:'9',name:'1.1.1',isHaveChild:0}
      ]}
*/
var DTree = Class.create();
DTree.prototype = {
  initialize: function(parameters) {
    this.config(parameters);
  },
  config:function(parameters){
   /*parameters:
    * {treeId,bindToContainerId,requestUrl,isOnceLoad,treeStructure,checkboxPara,linkPara,contextMenu}
    * treeId 字符串  树的Id
    * bindToContainerId 字符串  容器Id 默认为boby
    * requestUrl 字符串 请求路径
    * isOnceLoad 布尔  是否一次加载 默认为false
    * treeStructure :
    *    {isNoTree,regular}
    *     isNoTree  布尔  树的节点的nodeId是否编码  默认为false
    *     regular   字符串  如果树的节点的nodeId是否编码，需指字编码规则形如2,2,4,5，第段用逗号分割
    * checkboxPara:
    *     {isHaveCheckbox,disCheckedFuncheckedFun}
    *     isHaveCheckbox 布尔 是否有选框  默认为false
    *     disCheckedFun 函数  如果有选框，则当取消选择时要执行的函数,函数参数为此节点的ID
    *     checkedFun 函数 如果有选框，则当选择时要执行的函数,函数参数为此节点的ID
    *     expandEvent 布尔 是否有扩展事件函数



    * linkPara:
    *     {clickFunc,linkAddress,target}
    *     clickFunc 函数 点击链接时要执行的函数,函数参数为此节点的ID
    *     linkAddress 字符串 点击链接时要打开的地址,如果指定了上面的函数，点击链接时将不会打开此地址
    *     target 字符串 指定点击链接时在什么地方打开上面的链接地址，默为为一个'_blank'
    * contextmenu:
    *     右键执行的函数


    * onmuseover:
    *     移动的函数



    * isHaveTitle:
    *      结点的是否有title,且后台需给对应的字段
    * sort:desc,asc
    */
    this.treeId = parameters.treeId ? parameters.treeId : "";
    var bindNode = $(parameters.bindToContainerId) ? $(parameters.bindToContainerId) : document.body;
    this.isOnceLoad = parameters.isOnceLoad;
    if (!parameters.requestUrl) {
      alert("参数parameters.requestUrl不能为空");
      return;
    }
    this.requestUrl = parameters.requestUrl ? parameters.requestUrl : '';
    this.checkboxPara = parameters.checkboxPara ? parameters.checkboxPara : {isHaveCheckbox:false};
    this.linkPara = parameters.linkPara ? parameters.linkPara : {};
    this.treeStructure = parameters.treeStructure ? parameters.treeStructure :{isNoTree:false,regular:'3,2,2,4'};
    this.contextMenu = parameters.contextMenu;
    this.onmuseover = parameters.onmuseover;
    this.onmuseout = parameters.onmuseout;
    this.aOnmuseover = parameters.aOnmuseover;
    this.aDblclick = this.linkPara.dblclickFunc;
    this.isHaveTitle =  parameters.isHaveTitle;
    this.isWrodWrap = parameters.isWrodWrap ?  parameters.isWrodWrap : false;
    this.sortPara = parameters.sort ;
    
    this.setHowEncode(this.treeId);
    this.setImage(imgPath);
    this.isUserModule = parameters.isUserModule;
    this.root = "0";
    this.rootUl = document.createElement("ul");
    this.rootUl.id = this.ulEncode + this.root;
    this.rootUl.style.listStyle = "none";
    this.rootUl.style.whiteSpace = 'nowrap'; 
    this.maxLength = 0;
    this.rootUl.className = 'dtree-rootul';
    
    
    this.isIe7 = this.decideBrowser();
    this.isIe = document.all ? true : false;
    bindNode.tree = this;
    bindNode.appendChild(this.rootUl);
    this.isNoTree = this.treeStructure.isNoTree;
    this.regular = new Array();
    if(this.isNoTree){
      this.regular = this.treeStructure.regular.split(",");
      if(this.regular.length <1){
        alert("指定的编码规则不对");
        return;
      }
    }
    this.tmpCheckeList = "";
    this.currNodeId = "";
  },
  setHowEncode:function(encode){
    this.ulEncode = encode + '-ul-';
    this.liEncode = encode + '-li-';
    this.aEncode = encode + '-a-';
    this.imgEncode = encode + '-img-';
    this.img1Encode = encode + '-img1-';
    this.img2Encode = encode + '-img2-';
    this.checkboxEncode = encode + '-checkbox-';
  },
  setImage:function(path){
    this.minus = path + "/dtree/minus.gif";
    this.blank = path + "/dtree/blank.gif";
    this.item = path + "/dtree/folder.gif";
    this.plus = path + "/dtree/plus.gif";
    this.loading = path + "/dtree/loading.gif";
  },
  show:function(){
    if(this.isOnceLoad){
      this.onceLoadTree();
    }else{
      if(!this.isNoTree)
        this.treeLoad(this.root);
      else{ 
        this.treeLoad(this.root, this.regular[0]);
      }
    }
  },
  treeLoad:function(parentId,length){
    var parentNode = $(this.ulEncode + parentId);
    var parentImage = $(this.img1Encode + parentId);
      
    if(parentNode && parentNode.hasChildNodes()){
      if(parentNode.style.display=="none"){
        parentImage.src = this.minus;
        parentNode.style.display="";
      }else{
        if (parentImage) {
          parentImage.src = this.plus;
          parentNode.style.display="none";
        }
      }
    }else{
      this.getNodes(parentId, length,false);
    }
  },
  getNodes:function(parentId,length,flag){
    this.getNodesOnLoading(parentId);
    
    var url = "";
    if(this.isNoTree){
      if(parentId == this.root){
        url =  this.requestUrl;
      }else{
        url =  this.requestUrl + parentId;
      }
      url = url+ "&length="+length;
    }
    else{
      url =  this.requestUrl + parentId;
    }
    url = encodeURI(url);
    //var date1 = new Date();
    var json = getJsonRs(url);
    
    var parentNode = $(this.ulEncode + parentId);
    if(parentNode.hasChildNodes()){
      parentNode.removeChild(parentNode.firstChild);
    }
    
    if(json.rtState == '0'){
      if (json.rtData.length > 0) {
        var nodes = json.rtData;
        //var date1 = new Date();
        this.maxLength = 0 ;
        for(var i = 0; i < nodes.size(); i++){
          var nodeJsonObj = nodes[i];
          if (!nodeJsonObj) {
            continue;
          }
          nodeJsonObj.parentId = parentId;
          this.loadNode(nodeJsonObj , parentNode);
        }
//        var date2 = new Date();
//        var date3 = date2 - date1;
//        $('useTime').update(date3);
        if(this.checkboxPara.isHaveCheckbox && flag){
          var lis = parentNode.getElementsByTagName("li");
          var nodes = parentNode.getElementsByTagName("input");
          for(var i = 0 ;i < nodes.length ;i++){
            var n = nodes[i];
            n.checked = true;
            if(this.checkboxPara.checkedFun && this.checkboxPara.expandEvent){
              this.checkboxPara.checkedFun(n.id.substr(this.checkboxEncode.length));
            }
            this.tmpCheckeList = "," + n.id.substr(this.checkboxEncode.length);
          }
          for(var i = 0 ;i<lis.length; i++){
            var childLi = lis[i];
            this.setAllChildCheckboxChecked(childLi.id.substr(this.liEncode.length));
          }
        }
      } else {
        var parentLi = parentNode.parentNode;
        parentLi.firstChild.src = this.blank;
        parentLi.removeChild(parentNode);
        var lastChild = parentLi.lastChild;
        if (lastChild) {
          lastChild.isHaveChild = false;
        }
      }
    }
  },
  getNodesOnLoading:function(parentId){
    var parentNode = $(this.ulEncode + parentId);
    parentNode.style.display = "";
    var img = document.createElement("img");
    img.id = this.imgEncode + parentId;
    img.src = this.loading;
    parentNode.appendChild(img);
  },
  loadNode:function(nodeJsonObj, parentNode){
    var nodeId = nodeJsonObj.nodeId;
    var name = nodeJsonObj.name;
    var isHaveChild = (nodeJsonObj.isHaveChild == 1?true:false);
    var parentId = this.root;
    if(nodeJsonObj.parentId){
      parentId = nodeJsonObj.parentId; 
    }
    var extData = '';
    var imgAddress = this.item;
    if(nodeJsonObj.extData){
      extData = nodeJsonObj.extData;
    }
    if(nodeJsonObj.imgAddress){
      imgAddress =  nodeJsonObj.imgAddress;
    }
    var isChecked = false;
    if(nodeJsonObj.isChecked){
      isChecked = nodeJsonObj.isChecked;
    }
    if (!parentNode) {
      parentNode = $(this.ulEncode + parentId);
    } 
    if(parentNode != this.rootUl){
//      if(this.isIe){
//        if(this.isIe7 || this.isUserModule){
//          parentNode.style.marginLeft = '20px';//IE7
//          parentNode.style.marginRight = '0px';
//        }else{
//          parentNode.style.marginLeft = '-20px';//IE8
//          parentNode.style.marginRight = '0px';
//        }
//      }else{
//        parentNode.style.paddingLeft = '20px';//fireFox
//        parentNode.style.paddingRight = '0px';
//      }
    }
    var li = document.createElement("li");
    li.style.listStyle = "none";
    li.className = "";
    li.id = this.liEncode + nodeId;
    var img1 = new Element("img");
    img1.id = this.img1Encode + nodeId;
    if(isHaveChild){
      img1.src = this.plus;
    }else{
      img1.src = this.blank;
    }
    img1.observe('click',this.imageAndAClick.bindAsEventListener(this,nodeId , false));
    var img2 = new Element("img");
    img2.src = imgAddress;
    img2.style.paddingRight = '3px';
    img2.id = this.img2Encode + nodeId;
    img2.observe('click',this.imageAndAClick.bindAsEventListener(this,nodeId , true));
    if(this.contextMenu){
      img2.observe("contextmenu",this.contextMenu.bindAsEventListener(this,nodeId));
    }
    var checkboxWidth = 0 ;
    if(this.checkboxPara.isHaveCheckbox){
      var checkbox = new Element("input");
      checkbox.id = this.checkboxEncode + nodeId;
      checkbox.type = "checkbox";
      
      checkbox.observe('click',this.checkboxClick.bindAsEventListener(this,nodeId,checkbox ));
    }
   
    var a = new Element("a");
    a.id = this.aEncode + nodeId;
    a.isHaveChild = isHaveChild;
    a.parentId = parentId;
    a.extData = extData;
    if(this.linkPara.clickFunc){
      a.href = "javascript:void(0)";
      a.observe('click',this.linkPara.clickFunc.bind(window,nodeId , this.treeId));
    }else if(this.linkPara.linkAddress){
      if(this.linkPara.linkAddress.indexOf("javascript:") < 0) {
        a.setAttribute("href", this.linkPara.linkAddress + nodeId);
        if(this.linkPara.target){
          this.linkPara.target = '_blank';
        }
        a.target = this.linkPara.target;
      }
    }else{
      a.href = "javascript:void(0)";
    }
    if (this.isHaveTitle && nodeJsonObj.title) {
      a.title = nodeJsonObj.title;
    }
    if(this.contextMenu){
      a.observe("contextmenu",this.contextMenu.bindAsEventListener(this,nodeId));
    }
    a.observe('click',this.imageAndAClick.bindAsEventListener(this,nodeId , true));
    if (this.aDblclick) {
      a.observe('dblclick', this.aDblclick.bindAsEventListener(this, nodeId, true));
    }
    
    a.update(name);
   // parentNode.style.whiteSpace = 'nowrap'; 
    li.appendChild(img1);
    li.appendChild(img2);
    if(this.checkboxPara.isHaveCheckbox){
      li.appendChild(checkbox);
    }
    li.appendChild(a);
    if(this.onmuseover){
      $(li).observe("mouseover",this.onmuseover.bindAsEventListener(this,nodeId  , a , li));
    }
    if(this.onmuseout){
      $(li).observe("mouseout",this.onmuseout.bindAsEventListener(this,nodeId , a , li));
    }
    if (nodeJsonObj.appendHtml) {
      Element.insert(li , nodeJsonObj.appendHtml);
    }
    if (this.aOnmuseover) {
      a.observe("mouseover",this.aOnmuseover.bindAsEventListener(this,nodeId  , a , li));
    }
    if(isHaveChild){
      var ul = document.createElement("ul");
      ul.id = this.ulEncode + nodeId;
      ul.style.display = "none";
      ul.className = "";
      li.appendChild(ul);
    }
    parentNode.appendChild(li);
    if(parentId != this.root && !this.isOnceLoad){
      var parentImage = $(this.img1Encode + parentId);
      parentImage.src = this.minus;
    }
    if(this.checkboxPara.isHaveCheckbox){
      if(isChecked){
        checkbox.checked = true;
      }
    }
    
  },
   setAllChildCheckboxChecked:function(id){
     var ul = $(this.ulEncode + id);
     if(ul!=null){
       if(ul.hasChildNodes()){
         var parentImage = $(this.img1Encode + id);
         parentImage.src = this.minus;
         ul.style.display = "";
         var lis = ul.getElementsByTagName("li");
         var nodes = ul.getElementsByTagName("input");
         for(var i = 0 ;i < nodes.length ;i++){
           var n = nodes[i];
           n.checked = true;
           if(this.checkboxPara.checkedFun && this.checkboxPara.expandEvent){
             this.checkboxPara.checkedFun(n.id.substr(this.checkboxEncode.length));
           }
           this.tmpCheckeList += "," + n.id.substr(this.checkboxEncode.length);
         }
         for(var i = 0 ;i<lis.length; i++){
           var li = lis[i];
           this.setAllChildCheckboxChecked(li.id.substr(this.liEncode.length));
         }
       }else{
         if(!this.isOnceLoad){
           var length = id.length;
           if(this.isNoTree){
             length = this.getChildNodeLength(id.length);
           }
           this.getNodes(id, length, true);
         }
       }
     }
   },
   setAllChildCheckBoxDisChecked:function(id){
     var ul = $(this.ulEncode + id);
     if(ul != null){
       var nodes = ul.getElementsByTagName("input");
       for(var i = 0 ;i < nodes.length ;i++){
         var n = nodes[i];
         if(n.checked != false){
           n.checked = false;
           if(this.checkboxPara.disCheckedFun && this.checkboxPara.expandEvent){
             this.checkboxPara.disCheckedFun(n.id.substr(this.checkboxEncode.length));
           }
           this.tmpCheckeList += "," + n.id.substr(this.checkboxEncode.length);
         }
       }
     }
   },
   setParentNodeCheckbox:function(node){
     var id = node.id.substr(this.checkboxEncode.length);
     var li = $(this.liEncode + id);
     var parentlu = li.parentNode;
     id = parentlu.id.substr(this.ulEncode.length);
     if(id == this.root){
       return ;
     }
     var parentCheckbox = $(this.checkboxEncode + id);
     if(parentCheckbox.checked){
       return;
     }
     parentCheckbox.checked = true;
     if(this.checkboxPara.checkedFun && this.checkboxPara.expandEvent){
       this.checkboxPara.checkedFun(id);
     }
     this.tmpCheckeList += "," + id;
     this.setParentNodeCheckbox(parentCheckbox);
   },
   setParentNodeDisCheckbox:function(node){
     var id = node.id.substr(this.checkboxEncode.length);
     li = $(this.liEncode + id);
     var parentlu = li.parentNode;
     id = parentlu.id.substr(this.ulEncode.length);
     if(id == this.root){
       return ;
     }
     var lis = parentlu.childNodes;
     for(var i = 0 ;i < lis.length ;i++ ){
       li = lis[i];
       var checkbox =  $( this.checkboxEncode +li.id.substr(this.liEncode.length) );
       if(checkbox.checked){
         return ;
       }
     }
     var parentCheckbox = $(this.checkboxEncode + id);
     parentCheckbox.checked = false;
     if(this.checkboxPara.disCheckedFun && this.checkboxPara.expandEvent){
       this.checkboxPara.disCheckedFun(id);
     }
     this.tmpCheckeList += "," + id;
     this.setParentNodeDisCheckbox(parentCheckbox);
   },
   imageAndAClick:function(){
     var id = arguments[1];
     var flag = arguments[2];
     var a = $(this.aEncode + id);
     if(a){
       if(this.currNodeId){
         if($(this.aEncode + this.currNodeId)){
           $(this.aEncode + this.currNodeId).style.backgroundColor = "";
         }
       }
       this.currNodeId = id;
       //a.style.backgroundColor = "#F7F7F7";
       
       var isHaveChild = a.isHaveChild;
       if(isHaveChild){
         var node = $(this.ulEncode + id);
         //点的是第一个图标或者是收缩状态



         if(!flag || node.style.display == "none"){
           if(this.isNoTree){
             var length = this.getChildNodeLength(id.length);
             this.treeLoad(id,length);
           }else{
             this.treeLoad(id);
           }
         }
       }
     }else{
       alert('指定的节点不存在！');
     }
    // this.click(id);
   },
   checkboxClick:function(){
     var id = arguments[1];
     var checkbox = arguments[2];
     this.currNodeId = id;
     
     if(checkbox.checked){
       if(this.checkboxPara.checkedFun){
         this.checkboxPara.checkedFun(id);
       }
       this.tmpCheckeList = id;
       this.setAllChildCheckboxChecked(id);
       this.setParentNodeCheckbox(checkbox);
       if(this.checkboxPara.getList){
         this.checkboxPara.getList(this.tmpCheckeList);
       }
     }else{
       if(this.checkboxPara.disCheckedFun){
         this.checkboxPara.disCheckedFun(id);
       }
       this.tmpCheckeList = id;
       this.setAllChildCheckBoxDisChecked(id);
       this.setParentNodeDisCheckbox(checkbox);
       if(this.checkboxPara.getList){
         this.checkboxPara.getList(this.tmpCheckeList);
       }
     }
     
   },
   removeNode:function(id){
     var li = $(this.liEncode + id);
     if(li == null){
       alert('没有找到你要删除的结点!');
       return ;
     }
     var parentNode = li.parentNode;
     parentNode.removeChild(li);
     if(this.currNodeId == id){
       this.currNodeId = '';
     }
     if(!parentNode.hasChildNodes()){
       var hisParentNode = parentNode.parentNode;
       if(hisParentNode.id == this.ulEncode + this.root){
         return;
       }
       hisParentNode.removeChild(parentNode);
       var parentImage1 = hisParentNode.firstChild;
       if (parentImage1) {
         parentImage1.src = this.blank;
       }
       var parentA = hisParentNode.lastChild;
       if (parentA) {
         parentA.isHaveChild = false;
       }
     }
   },
   getCurrNode:function(){
     if(this.currNodeId){
       return this.getNode(this.currNodeId);
     }else{
       return null;
     }
   },
   getNode:function(id){
     if(id && $(this.liEncode + id)){
       var nodeJsonObj = new Object();
       var a = $(this.aEncode + id);
       var img2 = $(this.img2Encode + id);
       nodeJsonObj.nodeId = id;
       nodeJsonObj.name = a.innerHTML.replace("&amp;", "&");;
       nodeJsonObj.extData = a.extData;
       nodeJsonObj.isHaveChild = a.isHaveChild;
       nodeJsonObj.parentId =  a.parentId;
       if(this.isNoTree && nodeJsonObj.parentId == this.root){
         nodeJsonObj.parentId = "";
       }
       nodeJsonObj.imgAddress = img2.src;
       return nodeJsonObj;
     }else{
       return null;
     }
   },
   onceLoadTree:function(){
     this.getNodesOnLoading(this.root);
     var tree = getJsonRs(this.requestUrl);
     var parentNode = $(this.ulEncode + this.root);
     if(parentNode.hasChildNodes()){
       parentNode.removeChild(parentNode.firstChild);
     }
     if(tree.rtState == '0'){
       if(tree.rtData.length>0){
         var rootNode = {nodeId:this.root,isHaveChild:1};
         this.sortNode(tree.rtData);
         this.onceLoadChildNodes(rootNode,tree.rtData);
       }
     }
   },
   sortNode:function (nodes) {
     if (!this.sortPara) {
       return ;
     }
     var s = this.sortPara;
     nodes.sort(function(x , y){
       var sortNoX = 0;
       if (x.sortNo) {
         sortNoX = x.sortNo;
       }
       var sortNoY = 0;
       if (y.sortNo) {
         sortNoY = y.sortNo;
       }
       if (sortNoY >= sortNoX) {
         if (s.toUpperCase() == 'DESC') {
           return 1;
         } else {
           return 0;
         }
       } else {
         if (s.toUpperCase() == 'DESC') {
           return 0;
         } else {
           return 1;
         }
       }
     });
   },
   onceLoadChildNodes:function(parentNode,nodes){
     var parentId = parentNode.nodeId;
     var parentUl = $(this.ulEncode + parentId);
     if(parentUl != null)
       if(parentId == this.root){
         parentUl.style.display = '';
       }else{
         parentUl.style.display = 'none';
       }
     if(parentNode.isHaveChild == 1){
       for(var i = 0 ;i < nodes.length ;i++){
         var node = nodes[i];
         if(!this.isNoTree){
           if(node.parentId == parentId){
             this.loadNode(node);
             this.onceLoadChildNodes(node, nodes);
           }
         }else{
           var isHaveParentStr = false;
           var length = this.regular[0];
           if(parentId == this.root || this.startWith(node.nodeId,parentId)){
             isHaveParentStr = true;
             if(parentId != this.root){
               length = this.getChildNodeLength(parentId.length);
             }
           }
           if( isHaveParentStr && node.nodeId.length == parseInt(length)){
             node.parentId = parentId;
             this.loadNode(node);
             this.onceLoadChildNodes(node, nodes);
           }
         }
       }
     }
   },
   startWith:function(nodeId,parentId){
     if(parentId==null||parentId=="")
       return true;
       if(nodeId.substr(0,parentId.length)==parentId)
       return true;
       else
       return false;
       return true;
   },
   getChildNodeLength:function(length){
     var j = 0;
     for(var i = 0; i<this.regular.length ; i++){
       j= parseInt(j) + parseInt(this.regular[i]);
       if(length == j){
         length = parseInt(j) + parseInt(this.regular[i+1]);
         break;
       }
     }
     return length;
   },
   getChildNode:function(nodeId) {
     var ulId = this.ulEncode + nodeId;
     var ul = $(ulId);
     var liId = [];
     if (ul) {
       var lis = ul.childNodes;
       for (var i = 0 ; i < lis.length ;i++) {
         var li = lis[i];
         this.liEncode;
         liId.push(li.id.substr(this.liEncode.length));
       }
     }
     return liId;
   },
   getParentNodeLength:function(length){
     var j = 0;
     for(var i = 0; i<this.regular.length ; i++){
       j= parseInt(j) + parseInt(this.regular[i]);
       if(length == j){
         length = parseInt(j) - parseInt(this.regular[i]);
         break;
       }
     }
     return length;
   },
   addNode:function(nodeJsonObj , flag){
     var parentId = this.root;
     if(nodeJsonObj.parentId){
       parentId = nodeJsonObj.parentId; 
     }else{
       if(this.isNoTree){
         if(!this.checkNoId(nodeJsonObj.nodeId.length)){
           alert('你指定的nodeId:' + nodeJsonObj.nodeId + '的编码不对!');
           return;
         }
         var parentIdLength = this.getParentNodeLength(nodeJsonObj.nodeId.length);
         var parentId = nodeJsonObj.nodeId.substring(0,parentIdLength);
         nodeJsonObj.parentId = parentId;
       }
     }
     var parentNode = $(this.ulEncode + parentId);
     if(!parentNode){
       var parentImage1 = $(this.img1Encode + parentId);
       if(!parentImage1){
         alert('没有找到指定的父节点');
         return ;
       }
       var parentLi = parentImage1.parentNode;
       parentImage1.src = this.minus;
       var parentA = $(this.aEncode + parentId);
       parentA.isHaveChild = true;
       parentNode = document.createElement("ul");
       parentNode.id = this.ulEncode + parentId;
       parentLi.appendChild(parentNode);
     }else{
       var parentA = $(this.aEncode + parentId);
       if(parentA 
           && parentA.isHaveChild 
           && parentNode.style.display == "none"){
         if(this.isNoTree){
           if(parentId == this.root){
             parentId = "";
           }
           var length = this.getChildNodeLength(parentId.length);
           this.treeLoad(parentId, length);
         }else{
           this.treeLoad(parentId);
         }
       }
     }
     var node = $(this.liEncode  + nodeJsonObj.nodeId);
     if (!node || flag) {
       this.loadNode(nodeJsonObj);
     }
   },
   checkNoId:function(length){
     var j = 0;
     for(var i = 0; i<this.regular.length ; i++){
       j= parseInt(j) + parseInt(this.regular[i]);
       if(length == j){
         return true;
       }
     }
     return false;
   },
   getFirstNode:function(){
     var firstLi = this.rootUl.firstChild;
     return this.getNode(firstLi.id.substr(this.liEncode.length));
   },
   open:function(nodeId){
     var parentNode = $(this.ulEncode + nodeId);
     if(parentNode){
       if(this.isNoTree){
         var length =  this.getChildNodeLength(nodeId.length);
       }
       var parentImage = parentNode.parentNode.firstChild;
       if(parentNode.hasChildNodes()){
         if(parentNode.style.display=="none"){
           parentImage.src = this.minus;
           parentNode.style.display="";
         }
       }else{
         this.getNodes(nodeId, length,false);
       }
     }else{
       return ;
       ///alert('没有你指定的节点或你指定的节点没有子节点！');
     }
   },
   close:function(nodeId){
     var parentNode = $(this.ulEncode + nodeId);
     if(parentNode){
       var parentImage = parentNode.parentNode.firstChild;
       if(parentNode.hasChildNodes()){
         if(parentNode.style.display != "none"){
           parentImage.src = this.plus;
           parentNode.style.display="none";
         }
       } 
     }else{
       return ;
       //alert('没有你指定的节点或你指定的节点没有子节点！');
     }
   },
   click:function(id){
     this.linkPara.clickFunc(id);
   },
   nodeClick:function(id){
     this.imageAndAClick(null,id);
   },
   getCheckedList:function(){
     var checkboxList = this.rootUl.getElementsByTagName("input");
     var checkedList = "";
     for(var i = 0 ;i < checkboxList.length; i++){
       var checkbox = checkboxList[i];
       if(checkbox.checked){
         if(checkedList){
           checkedList += "," + checkbox.id.substr(this.checkboxEncode.length);
         }else{
           checkedList = checkbox.id.substr(this.checkboxEncode.length);
         }
       }
     }
     return checkedList;
   },
   //暂不支持，修改一些动态值，只能修改nodeId,name,extData 
  //{ nodeId:'5',name:'1.1.3',isChecked:true,isHaveChild:1,extData:'1.1.3',imgAddrss:''
   updateNode:function(oldId,node){
     
     var isHaveChild =  this.getNode(oldId).isHaveChild;
     if(isHaveChild){
       var ul = $(this.ulEncode + oldId);
       this.addNode(node, true);
       var newli = $(this.liEncode + node.nodeId);
       newli.removeChild(newli.lastChild);
       ul.id = this.ulEncode + node.nodeId;
       ul.style.display = "none";
       newli.appendChild(ul);
       var lis = ul.childNodes;
       for (var i = 0 ; i < lis.length ;i++) {
         var li = lis[i];
         var nos = li.childNodes;
         var a = nos[2];
         a.parentId = node.nodeId;
       }
       if(this.currNodeId == oldId){
         this.currNodeId = node.nodeId;
         $(this.aEncode + this.currNodeId).style.backgroundColor = ""; 
       }
       this.removeNode(oldId);
     }else{
       this.removeNode(oldId);
       this.addNode(node);
     }
   },
   getRootNode:function(nodeId){
     var parent = this.getParentNode(nodeId);
     if (parent.parentId == 0) {
       return parent;
     } else {
       return this.getRootNode(parent.nodeId);
     }
   },
   getParentNode:function(nodeId){
     var node = this.getNode(nodeId);
     if (node.parentId == 0) {
       return node;
     }
     var parent = this.getNode(node.parentId);
     return parent;
   },
   decideBrowser:function(){
     var isIE=!!window.ActiveXObject;
     var isIE6=isIE&&!window.XMLHttpRequest;
     var isIE8=isIE&&!!document.documentMode;
     var isIE7=isIE&&!isIE6&&!isIE8;
     if (isIE){
       if (isIE6){
         return true;
       }else if (isIE8){
         return false;
       }else if (isIE7){
         return true;
       }
     }
   }
};

