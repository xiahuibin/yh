<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE  html  PUBLIC  "-//W3C//DTD  HTML  4.01  Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/mytable.css"/>
<link  rel="stylesheet"  href="<%=cssPath%>/style.css">
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/extResources/css/jq-yhtheme.css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery-1.4.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.sortable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.yh.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.autolayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.columnlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.container.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.panel.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.cardlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.columnlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.module.js"></script>
<style>
  body {
    overflow:auto;
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
  .column {
    height: 100%;
    padding-bottom: 150px;
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
</style>
<script type="text/javascript">
var cfg = {
    style: {
    },
    /*tbar: [{
      id: 'close',
      handler: function(e, target, panel) {
        panel.hide();
      }
    },{
      id: 'more',
      handler: function(e, target, panel) {
        alert('??????????????????' + cfg.moreLink);
      }
    }],*/
    items:[
      
    ],
    width: '650px',
    height: 'auto',
    title: '???????????????'
  };
$(document).ready(function() {
  cfg.el = '#example';
  window.panel = new YH.Panel(cfg);
});
var grid = {
  xtype: 'grid',
  title: '??????',
  moreLink: 'dddd',
  loader: {
    url: '<%=contextPath%>/yh/core/funcs/news/act/YHImgNewsAct/leatImagNews.act'
  },
  //data: [{runId:1454,prcsId:1,flowId:341,prcsFlag:'1',flowPrcs:'1',flowName:'?????????????????????????????????',runName:'?????????????????????????????????(2010-07-19 09:45:00)',flowType:'1',formId:381,prcsName:'??????'},{runId:1457,prcsId:1,flowId:341,prcsFlag:'2',flowPrcs:'1',flowName:'?????????????????????????????????',runName:'?????????????????????????????????(2010-07-19 09:45:55)',flowType:'1',formId:381,prcsName:'??????'},{runId:1468,prcsId:1,flowId:81,prcsFlag:'2',flowPrcs:'1',flowName:'??????',runName:'??????(2010-07-20 17:23:13)',flowType:'2',formId:61,prcsName:''},{runId:1466,prcsId:1,flowId:402,prcsFlag:'2',flowPrcs:'1',flowName:'??????????????????',runName:'??????????????????(2010-07-20 16:27:40)',flowType:'2',formId:121,prcsName:''},{runId:1459,prcsId:1,flowId:402,prcsFlag:'2',flowPrcs:'1',flowName:'??????????????????',runName:'??????????????????(2010-07-20 15:21:11)',flowType:'2',formId:121,prcsName:''},{runId:1453,prcsId:1,flowId:381,prcsFlag:'2',flowPrcs:'1',flowName:'??????????????????',runName:'??????????????????(2010-07-15 17:18:25)',flowType:'1',formId:401,prcsName:''}],
  rowRender: function(i, e) {
    var content = $('<div></div>');
    $.each(e.cells, function(index, el) {
      var element;
      if (el.type == '' || el.type.toLowerCase() == 'text') {
        element = $('<span></span>');
        element.html(el.text);
      }
      else if (el.type.toLowerCase() == 'link' || el.type.toLowerCase() == 'img'){
        element = $('<a></a>');
        element.html(el.text);
      }
      else {
        elment = $('<span></span>');
      }

      $.each(el, function(key, value) {
        try {
	        element.attr(key, value);
        } catch (e) {

        }
      });
      content.append(element);
    });
    return content;
  }
};

var img = {
  title: '??????',
  path: 'image.jpg',
  xtype: 'image',
  describe: '234234234234',
  link: 'http://localhost/'
};

var imgbox = {
  title: '????????????',
  /*
  data: [
  {
    text: '1111',
    src: 'image.jpg',
    href: 'http://www.google.com.hk/'
  },{
    text: '1111',
    src: 'icon64_help.png',
    href: 'http://www.google.com.hk/'
  },{
    text: '1111',
    src: 'icon64_info.png',
    href: 'http://www.google.com.hk/'
  }],*/
  loader: {
    url: '<%=contextPath%>/yh/core/funcs/news/act/YHImgNewsAct/leatImagNews.act'
  },
  xtype: 'imgbox'
};

var modules = {
  'gird': grid,
  'img': img,
  'imgbox': imgbox
};

function cfgContent(type) {
  var item = modules[type]
  cfg.items = [item];
  panel.items = [item];
  panel.reload();
}

function cfgTitle(title) {
  cfg.title = title;
  panel.title = title;
  panel.reload();
}

function save() {
  alert(YH.jsonToString(cfg));
}
</script>
</head>
<body>
  <br>
  <br>
  <div id="example" style="margin:0 auto;"></div>
  <br><br>
  <table style="margin:0 auto;width:500px;" class="TableBlock">
    <tbody>
      <tr>
	      <td class="TableHeader" colspan="2">
	        ????????????????????????:
	      </td>
      </tr>
      <tr class="TableData">
        <td>
          ??????????????????:
        </td>
         <td>
          <input type="button" class="BigButton" value="????????????" onclick="cfgContent('gird')"/>
          <input type="button" class="BigButton" value="????????????" onclick="cfgContent('img')"/>
          <input type="button" class="BigButton" value="????????????" onclick="cfgContent('imgbox')"/>
        </td>
      </tr>
      <tr class="TableData">
	      <td>
	      ??????????????????:
	      </td>
	      <td>
        <input type="text" id="name"/>
          <input type="button" class="BigButton" value="??????" onclick="cfgTitle($('#name').val())">
        </td>
      </tr>
      <tr class="TableData">
        <td>
          ????????????
        </td>
        <td>
          <input type="button" class="BigButton" value="????????????" onclick="save()">
        </td>
      </tr>
    </tbody>
  </table>
</body>
</html>