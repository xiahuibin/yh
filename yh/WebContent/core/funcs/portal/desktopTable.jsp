<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%
  //用户禁止查看桌面
  String userId = "";

  YHPerson person = (YHPerson)request.getSession().getAttribute("LOGIN_USER");
  
  if (person != null){
    userId = person.getUserId();
    String viewFlag = person.getNotViewTable();
    
    if (viewFlag == null || "".equals(viewFlag.trim())){
      viewFlag = "0";
    }
    
    if ("1".equals(viewFlag.trim())){
      //转向一个空桌面页面
      response.sendRedirect(contextPath + "/core/ext/frame/portal/noneDesktop.jsp");
    }
  }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Custom Layouts and Containers - Portal Example</title>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/index1.css"/>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/extResources/css/jq-yhtheme.css" />
<style>
	.ui-sortable-placeholder { 
	  border: 1px dotted black;
	  background:#EEEEEE;
	  visibility: visible !important;
	}
  .ui-sortable-placeholder * { 
    visibility: hidden;
  }
  ul,ol {
    margin:0;
    padding:0;
  }
  .column {
  }
  body {
    overflow-x:hidden;
  }
  ul {
    margin:0;
    padding:0;
  }
  li {
    line-height: 20px;
  }
  
  .jq-Container-tabheader a {
    font-size: 12px;
  }
  .module {
    border: none;
  }
  
  .yh-imgbox {
    position:relative;
    height: 100px;
    overflow:hidden;
  }
  .yh-imgbox-container {
    position:absolute;
    height: 100px;
    overflow:hidden;
    width:100%;
  }
  
  .yh-imgbox-imgs {
    position:absolute;
  }
  
  .yh-imgbox-texts {
    position:absolute;
    top:0px;
    left:180px;
  }
  
  .yh-imgbox-imgs img {
    height: 100px;
    width: 150px;
    display:block;
  }
  
  .yh-imgbox-texts span {
    cursor:pointer;
    display:block;
    line-height: 20px;
  }
  
  #container {
    width:100%;
    height:100%;
    background-color:white;
  }
  
  #config {
    display:none;
    position:absolute;
    top: -100px;
    height: 100px;
    width: 100%;
    background-color:#EbEbEb;
  }
   .ui-resizable { 
    position: relative;
  }
  .ui-resizable-handle {
    position: absolute;
    font-size: 0.1px;
    z-index: 99999; 
    display: block;
  }
  .ui-resizable-disabled .ui-resizable-handle, .ui-resizable-autohide .ui-resizable-handle { 
    display: none; 
  }
  .ui-resizable-n { 
    cursor: n-resize;
    height: 7px; 
    width: 100%; 
    top: -5px; 
    left: 0; 
  }
  .ui-resizable-s {
    cursor: s-resize; 
    height: 7px; 
    width: 100%; 
    bottom: -5px; 
    left: 0; 
  }
  .ui-resizable-e { 
    cursor: e-resize; 
    width: 7px; 
    right: -5px; 
    top: 0; 
    height: 100%; 
  }
  .ui-resizable-w { 
    cursor: w-resize; 
    width: 7px; 
    left: -5px; 
    top: 0; 
    height: 100%;
  }
  .ui-resizable-se { 
    cursor: se-resize; 
    width: 12px; 
    height: 12px; 
    right: 1px; 
    bottom: 1px;
  }
  .ui-resizable-sw { 
    cursor: sw-resize; 
    width: 9px; 
    height: 9px; 
    left: -5px; 
    bottom: -5px; 
  }
  .ui-resizable-nw { 
    cursor: nw-resize; 
    width: 9px; 
    height: 9px; 
    left: -5px; 
    top: -5px; 
  }
  .ui-resizable-ne { 
    cursor: ne-resize; 
    width: 9px; 
    height: 9px; 
    right: -5px; 
    top: -5px;
  }
</style>
<!-- resizable的样式 -->
<style>
	.ui-resizable { 
	  position: relative;
	}
	.ui-resizable-handle {
	  position: absolute;
	  font-size: 0.1px;
	  z-index: 99999; 
	  display: block;
	}
	.ui-resizable-disabled .ui-resizable-handle, .ui-resizable-autohide .ui-resizable-handle { 
	  display: none; 
	}
	.ui-resizable-n { 
	  cursor: n-resize;
	  height: 7px; 
	  width: 100%; 
	  top: -5px; 
	  left: 0; 
	}
	.ui-resizable-s {
	  cursor: s-resize; 
	  height: 7px; 
	  width: 100%; 
	  bottom: -5px; 
	  left: 0; 
	}
	.ui-resizable-e { 
	  cursor: e-resize; 
	  width: 7px; 
	  right: -5px; 
	  top: 0; 
	  height: 100%; 
	}
	.ui-resizable-w { 
	  cursor: w-resize; 
	  width: 7px; 
	  left: -5px; 
	  top: 0; 
	  height: 100%;
	}
	.ui-resizable-se { 
	  cursor: se-resize; 
	  width: 12px; 
	  height: 12px; 
	  right: 1px; 
	  bottom: 1px;
	}
	.ui-resizable-sw { 
	  cursor: sw-resize; 
	  width: 9px; 
	  height: 9px; 
	  left: -5px; 
	  bottom: -5px; 
	}
	.ui-resizable-nw { 
	  cursor: nw-resize; 
	  width: 9px; 
	  height: 9px; 
	  left: -5px; 
	  top: -5px; 
	}
	.ui-resizable-ne { 
	  cursor: ne-resize; 
	  width: 9px; 
	  height: 9px; 
	  right: -5px; 
	  top: -5px;
	}
  table {
    border: 1px solid #D3D3D3;
  }
  td.ui-selecting { 
    background: #FECA40; 
  }
  td.ui-selected { 
    background: #F39814; 
    color: white; 
  }
  #selectable { 
    list-style-type: none; 
    margin: 0; 
    padding: 0; 
  }
  td { 
    vertical-align: top;
    boder:1px soild black;
    width:80px;
    height:80px;
    border: 1px solid #D3D3D3;
  }
</style>
<link rel="stylesheet" type="text/css" href="<%=cssPath %>/mytable.css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.sortable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.droppable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.yh.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.panel.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.window.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.module.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.container.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.columnlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.selectable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.tableoperation.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.tip.js"></script>
<script type="text/javascript">

var userId = '<%=userId%>';
var module = new Object();

var toggleTool = {
  id: 'toggle',
  handler: function(e, target, panel){
    panel.toggle(500);
  }
};

var closeTool = {
  id:'close',
  handler: function(e, target, panel){
    showCfg();
    var btn = $('<div></div>');
    btn.css({
      'height': '30px',
      'width': '100px',
      'cursor': 'pointer',
      'background-color': '#EbEbEb',
      'border': '1px solid #606275'
    });
    btn.draggable({
      revert: true
    });
    btn.attr('id', panel.getId());
    btn.html(panel.getTitle());
    btn.data('file', panel.file);
    var sawdow = $('#sawdow' + panel.getId()).append(btn);
    sawdow.children('input').attr('checked', false);

    panel.destroy();
    delete panels[panel.getId()];
  }
}

var tools = [closeTool, toggleTool];

var panels = {};
var userPort = [];

$(document).ready(function(){
  renderPortal();
  initCfgOptionEvent();
  window.tableOp = new YH.TableOperation({
    table: '#grid',
    selectable: {
      delay: 100,
      distance: 20,
      metaKey: false,                 //取消按住ctrl键多选功能
      cancel: '.jq-panel-header'      //在ie中拖动panel时不选中
    },
    sortable: {
      connectWith: 'td',
      handle: '.jq-panel-tl',
      revert: true,
      tolerance: 'pointer',       //通过鼠标的位置计算拖动的位置*重要属性*
      activate: function(event, ui) {
        ui.item.css({
          'width': ui.placeholder.innerWidth()
        });
      
        ui.placeholder.css({
          'height': ui.item.innerHeight()
        });
      },
      start: function(event, ui) {
      },
      stop: function(event, ui) {
      }
    }
  });

  var menu = new YH.Menu({
    classes: ['menu-lv3'],
    data: [{
      text: "合并单元格",
      handleClick: function(node, t) {
        tableOp.mergeCells();
        tip.hide();
        clearTimeout(menu.timer);
      }
    },{
      text: "拆分单元格",
      handleClick: function(node, t) {
        tableOp.splitCells();
        tip.hide();
        clearTimeout(menu.timer);
      }
    },{
      text: "之前加入行",
      handleClick: function(node, t) {
        tableOp.addRow('before');
        tip.hide();
        clearTimeout(menu.timer);
      }
    },{
      text: "之后加入行",
      handleClick: function(node, t) {
        tableOp.addRow('after');
        tip.hide();
        clearTimeout(menu.timer);
      }
    },{
      text: "之前插入列",
      handleClick: function(node, t) {
      }
    },{
      text: "之后插入列",
      handleClick: function(node, t) {
      }
    },{
      text: "取消选择",
      handleClick: function(node, t) {
        tableOp.unselect();
        tip.hide();
      }
    },{
      text: "显示/隐藏配置栏",
      handleClick: function(node, t) {
        if (!$('#config').data('show')) { 
	        showCfg();
        }
        else {
	        hideCfg();
        }
        tip.hide();
      }
    }],
    selClass: 'menu-selected'
  });
  menu.render('body');

  var tip = new YH.Tip({
    event: 'rightClick',
    delay: 2,
    items: [menu],
    target: 'body'
  });
  
});
function renderPortal() {
  var url = contextPath + "/yh/core/funcs/portal/act/YHPortalAct/listPorts.act";
  $.ajax({
    type: "GET",
    dataType: "text",
    url: url,
    success: function(text){
      var json = YH.parseJson(text);
      if (json.rtState == '0') {
        var data = json.rtData;
        $.each(data.records, function(i, e) {
          var file = e.file;
          var id = e.id;
          userPort.push(id);
          var title = e.file.replace(/.js/, "");
          
          var el = $('<div class="module"></div>');
          el.attr('id', id);
          el.data('seqId', e.id);
          $('#container').append(el);
          
          if (e.viewType == '1') {
            tools.push(closeTool);
          }

          $.post("<%= contextPath%>/yh/core/funcs/portal/act/YHPortalAct/viewPort.act", {file:file}, function(d) {
            var cfg = YH.parseJson(d);
            cfg.tbar = tools;
            cfg.id = id;
            cfg.el = el;
            cfg.file = file;
            if (cfg.moreLink) {
              cfg.tbar.push({
                id: 'more',
                handler: function(e, target, panel) {
                  alert('查看更多链接' + cfg.moreLink);
                }
              });
            }
            
            cfg.width = e.width || cfg.width;
            cfg.height = e.height || cfg.height;
            
            panels[id] = new YH.Panel(cfg);
          }, 'text');

        });
       }
       listAllPorts();
     }
  });
}

function initCfgOptionEvent() {
  
  $('td').droppable({
    drop: function(event, ui) {
      var el = ui.draggable;
      if (el.parent()[0] && el.parent()[0].tagName != 'TD') {
        
	      var sawdow = $('#sawdow' + el.attr('id'));
	      sawdow.children('input').attr('checked', true);
	      
        el.empty();
        el.css({
          border: 'none',
          top: 0,
          left: 0,
          position: 'relative'
        });
        el.appendTo(this);
        el.draggable('disable');
        addPanel(el.data('file'), el, el.attr('id'));
      }
    }
  });
}
/**
 * 保存桌面模块位置
 */
function savePortal() {
  var params = {};
  $.each(panels, function(k, v) {
    var id = v.getId();
    var w = v.getAbsWidth();
    var h = v.getAbsContentHeight();
    var x = v.getPosX();
    var y = v.getPosY();
    params[id] = [w, h, x, y];
  });

  var url = contextPath + "/yh/core/funcs/portal/act/YHPortalAct/updateUserPorts.act";
  $.ajax({
    type: "POST",
    dataType: "text",
    data: params,
    url: url,
    success: function(text){
      hideCfg();
    }
  });
}

/**
 * 显示配置面板
 */
function showCfg() {
  if (!$('#config').data('show')) {
	  $('#config').show();
	  $('#container').animate({top: '100px'});
	  $('#config').data('show', true);
  }
}

/**
 * 隐藏配置面板
 */
function hideCfg() {
  if ($('#config').data('show')) {
    $('#config').hide();
    $('#container').animate({top: '0px'});
    $('#config').data('show', false);
  }
}

/**
 * 初始化配置面板
 */
function listAllPorts() {
  var url = contextPath + "/yh/core/funcs/portal/act/YHPortalAct/listAllPorts.act";
  $.ajax({
    type: "GET",
    dataType: "text",
    url: url,
    success: function(text){
      var json = YH.parseJson(text);
      if (json.rtState == '0') {
        var data = json.rtData;
        $.each(data.records, function(i, e) {
          if (e.file) {
            var sawdow = $('<div></div>');
            sawdow.attr('id', 'sawdow' + e.id);
            sawdow.css({
              'height': '30px',
              'float': 'left',
              'padding': '10px',
              'width': '150px',
              'border': '1px solid #606275'
            });
            sawdow.html('<span style="position:absolute;">' + e.file.replace('.js', '') + '</span>');
            sawdow.append('<input type="checkbox" disabled style="float:right;">');
	          $('#config').append(sawdow);

	          if ($.inArray(e.id, userPort) < 0) {
	            var btn = $('<div></div>');
	            btn.css({
	              'height': '30px',
	              'width': '100px',
	              'cursor': 'pointer',
	              'background-color': '#EbEbEb',
	              'border': '1px solid #606275'
	            });
	            sawdow.append(btn);
	            btn.draggable({
	              revert: true
		          });
	            btn.attr('id', e.id)
	            btn.html(e.file.replace('.js', ''));
	            btn.data('file', e.file);
			      }
	          else {
		          sawdow.children('input').attr('checked', true);
		        }
          }
        });
        $('#config').append('<div style="clear:both;"></div>');
      }
    }
  });
}

function addPanel(file, el, id) {
  $.post("<%= contextPath%>/yh/core/funcs/portal/act/YHPortalAct/viewPort.act", {file:file}, function(d) {
    var cfg = YH.parseJson(d);
    cfg.tbar = tools;
    cfg.id = id;
    cfg.el = el;
    if (cfg.moreLink) {
      cfg.tbar.push({
        id: 'more',
        handler: function(e, target, panel) {
          alert('查看更多链接' + cfg.moreLink);
        }
      });
    }

    cfg.file = file;
    cfg.width = '100%';
    cfg.style = {
      'margin': '5px 5px 5px 5px'
    };
    panels[id] = new YH.Panel(cfg);
  }, 'text');
}
</script>
</head>
<body>
  <div id="container" style="position:absolute;">
  <div id="config">
    <input type="button" onclick="savePortal()" style="float:right;" value="保存"/>
  </div>
   <table id="grid" class="resizable" width="100%">
    <tr>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
    </tr>
    <tr>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
    </tr>
    <tr>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
    </tr>
    <tr>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
      <td class="ui-state-default">
      </td>
    </tr>
  </table>
  </div>
</body>
</html>