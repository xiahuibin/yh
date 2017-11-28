<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%
String sessionToken = (String)session.getAttribute("sessionToken");

String smsRef = YHSysProps.getString("$SMS_REF_SEC");
if (smsRef == null || "".equals(smsRef.trim())) {
  smsRef = "30";
}

String smsCallCount = YHSysProps.getString("$SMS_REF_MAX");
if (smsCallCount == null || "".equals(smsCallCount.trim())) {
  smsCallCount = "3";
}

String smsInterval = YHSysProps.getString("$SMS_CALLSOUND_INTERVAL");
if (smsInterval == null || "".equals(smsInterval.trim())) {
  smsInterval = "3";
}

%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="/yh/core/frame/5/styles/style3/css/index1.css"/>
<link rel="stylesheet" type="text/css" href="/yh/core/frame/5/styles/style3/css/oa.css"/>

<link rel="stylesheet" type="text/css" href="<%=cssPath%>/index1.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/core/frame/webos/styles/style1/cmp/css/cmp-all.css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery-1.4.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.droppable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.selectable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.sortable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.yh.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.autolayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.fitlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.cardlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.freelayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.floatlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.columnlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.gridlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.module.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.container.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.panel.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.window.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.tip.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.button.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.borderlayout.js"></script>
<script type="text/javascript" src="js/calendar.js"></script>
<script type="text/javascript" src="js/index.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/frame/common/sms/sms.js"></script>
<script type="text/javascript">
var sessionToken = "<%=sessionToken%>";

function resetSmsCallCount() {
  smsCallCount = parseNumber("<%=smsCallCount%>", 3);
}
function parseNumber(value, defValue) {
  if (isNaN(value)) {
    return defValue;
  }
  return value * 1;
}
var bodyCards = [];

$(document).ready(function() {
  getTitle();
  queryInfo();
  window.bodyLayout = $('body').layout({
    'listeners': {
      'resize': function(){
        westLayout.resizeAll();
        mainLayout.resizeAll();
      }
    },
    north: {
      'fxSpeen': 'slow',
      size: 'auto'
    },
    south: {
      size: 'auto'
    },
    west: {
      'fxSpeed': 'slow',
      size: 'auto'
    },
    center: {
      
    }
  });
  
  initLeftTbar($('#menuExplorer'), imgsSrc, 0, function(i) {
    card.setActiveItem(i);
  });
  
  window.westLayout = $('#westContainer').layout({
    'listeners': {
      'resize': function(){
        leftLayout.resizeAll();
      }
    },
    north: {
      size: 'auto'
    },
    center: {
    }
  });
  
  window.mainLayout = $('#mainContainer').layout({
    north: {
      size: 'auto'
    },
    center: {
    }
  });
  
  //$('#northContainer').load('banner.jsp');
  $('#southContainer').load('statusbar.jsp');
  window.leftLayout = $('#leftPanel').layout({
    'listeners': {
      'resize': function(){
        $('#leftPanel .ui-layout-center:first').resize();
      }
    },
    south: {
      size: 'auto'
    },
    west: {
      size: 'auto'
    },
    east: {
      size: 'auto'
    },
    center: {
    }
  });
  
  var loadHandler = [
      function(el, index) {
        var body = el.children().eq(1);
        var height = el.children().eq(0).height();
        body.css({'height': (el.innerHeight() - height) + 'px'});
        if (!el.data('resize')) {
          $(el.parent()).resize(function() {
            body.css({'height': (el.innerHeight() - height) + 'px'});
          });
          el.data('resize', true);
        }
        bodyCards[0] = new YH.layouts.CardLayout({
          el: body,
          lazyLoad: true,
          loadHandler: [
            initMenu,
            initShortcut,
            initFav
          ],
          activeItem: 0
        });
      },
      function(el, index) {
        var body = el.children().eq(1);
        var height = el.children().eq(0).height();
        body.css({'height': (el.innerHeight() - height) + 'px'});
        if (!el.data('resize')) {
          $(window).resize(function() {
            body.css({'height': (el.innerHeight() - height) + 'px'});
          });
          el.data('resize', true);
        }
        bodyCards[1] = new YH.layouts.CardLayout({
          el: body,
          lazyLoad: true,
          reload: true,
          loadHandler: [
            function(element, elindex) {
              if (!window['onlineIframe']) {
                element.append('<iframe name="onlineIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
              }
              window['onlineIframe'].location.href = '<%=contextPath%>/core/frame/onlinetree.jsp';
            },
            function(element, elindex) {
              if (!window['allusersIframe']) {
                element.append('<iframe name="allusersIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
              }
              window['allusersIframe'].location.href = '<%=contextPath%>/core/frame/allusertree.jsp';
            }
          ],
          activeItem: 0
        });
      },
      function(el, index) {
        var body = el.children().eq(1);
        var height = el.children().eq(0).height();
        body.css({'height': (el.innerHeight() - height) + 'px'});
        if (!el.data('resize')) {
          $(window).resize(function() {
            body.css({'height': (el.innerHeight() - height) + 'px'});
          });
          el.data('resize', true);
        }
        bodyCards[2] = new YH.layouts.CardLayout({
          el: body,
          lazyLoad: true,
          loadHandler: [
                        function(element, elindex) {//提醒类
                            if (!window['remindboxIframe']) {
                              var iframe = '<iframe name="remindboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
                              element.append(iframe);
                            }
                            window['remindboxIframe'].location.href = '<%=contextPath%>/core/funcs/sms/jpanel/inboxSms.jsp?pageNo=0&pageSize=5&im=1';
                          },
                        function(element, elindex) {//收讯
                          if (!window['inboxIframe']) {
                            var iframe = '<iframe name="inboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
                            element.append(iframe);
                          }
                          window['inboxIframe'].location.href = '<%=contextPath%>/core/funcs/message/jpanel/inboxMessage.jsp?pageNo=0&pageSize=5&im=1';
                        },
                        function(element, elindex) {  //发讯
                          if (!window['sentboxIframe']) {
                            var iframe = '<iframe name="sentboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
                            element.append(iframe);
                          }
                          window['sentboxIframe'].location.href = '<%=contextPath%>/core/funcs/message/jpanel/sentboxMessage.jsp?pageNo=0&pageSize=5&im=1';
                        },
                        function(element, elindex) {  //分享
                            if (!window['shareboxIframe']) {
                              var iframe = '<iframe name="shareboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
                              element.append(iframe);
                            }
                            window['shareboxIframe'].location.href = '<%=contextPath%>/core/funcs/message/jpanel/weixun_share/weixun_share.jsp?pageNo=0&pageSize=5&im=1';
                          }
        ],
          activeItem: 0
        });
      },
      function(el, index) {
        var body = el.children().eq(1);
        var height = el.children().eq(0).height();
        body.css({'height': (el.innerHeight() - height) + 'px'});
        if (!el.data('resize')) {
          $(window).resize(function() {
            body.css({'height': (el.innerHeight() - height) + 'px'});
          });
          el.data('resize', true);
        }
        bodyCards[3] = new YH.layouts.CardLayout({
          el: body,
          lazyLoad: true,
          loadHandler: [
            function(element, elindex) {
              if (!window['searchIframe']) {
                element.append('<iframe name="searchIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
                window['searchIframe'].location.href = '<%=contextPath%>/core/funcs/search/index.jsp';
              }
            }
          ],
          activeItem: 0
        });
      }
    ];
  
  if (useSearchFunc === "0") {
    loadHandler.pop();
    $('#search').remove();
  }
  window.card = new YH.layouts.CardLayout({
    el: $('#tabpanelLv1'),
    lazyLoad: true,
    loadHandler: loadHandler,
    activeItem: 0
  });
  
  initUserInfo();
  initUserStatus();
  initTime();
  fillShortcut();
  window['main-body-desktop'].location.href = "<%=contextPath %>/core/frame/2/desktop.jsp";
  queryLogoutMsrg();

  function initSms() {
    setTimeout(function() {
	    if (!userinfo.seqId) {
	      initSms();
	      return;
	    }
      sms.initialize({
        type: "classic",
        smsOn: userinfo.smsOn,
        callSound: userinfo.callSound,
        userId: userinfo.seqId,
        smsCallCount: parseNumber("<%=smsCallCount%>", 3),
        smsInterval: parseNumber("<%=smsInterval%>", 3),
        smsRef: parseNumber("<%=smsRef%>", 30)
      });
    }, 100);
  }
  initSms();
});
</script>
</head>
<body>
<!--  
  <div class="ui-layout-north" id="northContainer" style="min-width:700px;">
	  <div class="banner_bg">
		  <div id="logo">
		    <img id="logoImg" src="" style="display:none"/>
		  </div>
		  <div class="banner_overflow_x_scroll">
		    <div class="banner_scroll_up">
		      <a href="javascript:void(0);" onclick="return false;" style="display:none;" id="shortcutBtnDown">
		        <img onmouseover="this.src='<%=imgPath %>/banner/scroll_up_mouseon.jpg'" onmouseout="this.src='<%=imgPath %>/banner/scroll_up.jpg'" src="<%=imgPath %>/banner/scroll_up.jpg"></img>
		      </a>
		    </div>
		    <div class="banner-shortcutlist-container">
		      <table id="bannerShortcut" style="position:relative;top:0px;" cellspacing="0" cellpadding="0" border="0">
		        <thead>
		        </thead>
		        <tbody id="bannerShortcutTb">
		        </tbody>
		      </table>
		    </div>
		    <div class="banner_scroll_down">
		      <a href="javascript:void(0);" onclick="return false;" style="display:none;" id="shortcutBtnUp">
		        <img onmouseover="this.src='<%=imgPath %>/banner/scroll_down_mouseon.jpg'" onmouseout="this.src='<%=imgPath %>/banner/scroll_down.jpg'" src="<%=imgPath %>/banner/scroll_down.jpg"></img>
		      </a>
		    </div>
		  </div>
		  <div id="wthAndTime">
		    <div id="time">
		      <div class="left">
		        
		      </div>
		      <div class="right">
		        
		      </div>
		      <div class="clear"></div>
		    </div>
		  </div>
	  </div>
  </div>
  --> 
  
     <div id="rightHeaderBar" class="ui-layout-north right-funcsbar">
  <div>
 	    <div id="taskbar_center" >
	    	<div id="tabs_container" >
	    	</div>
    	</div>
 			<div id="taskbar_right">
	   	      <a title="更换皮肤" href="javascript:;" id="theme"></a>
	    	</div>
	    </div>
  	     <div id="center" style="z-index: 100; display: none;">
	    <!-- 主题切换 -->
	    <div id="theme_panel" class="over-mask-layer">
	       <div class="center" id="theme_slider"></div>
	       <div class="close">
	          <a class="btn-black-a" href="javascript:;" onClick="jQuery('#theme').click();" hidefocus="hidefocus">关闭</a>
	       </div>
	       <div class="bottom"></div>
	    </div>
		  <div id="overlay_panel" style="display: none;"></div>
	  </div>
     <!--  
       <div class="right-callright">
         <a id="callRight" href="javascript:void(0)" onclick="collapseLeft();return false;"></a>
       </div>
       -->
       <img src="yiheng.JPG" style="height: 50px; width: 240px;">
       <div class="right-logout">
         <a href="javascript:doLogoutMsg()" onclick=""></a>
       </div>
       <!--  
       <div class="right-control">
         <a href="javascript:void(0)" onclick="dispParts('<%=contextPath %>/core/funcs/setdescktop/control.jsp');return false;"></a>
       </div>
       -->
   <!-- 
       <div class="right-switch">
         <a href="javascript:void(0)" onclick="webosHome()"></a>
       </div>
   -->      
       <div class="right-desktop"  style="position: absolute ;right:150px;">
         <a href="javascript:void(0)" onclick="dispDesk();"></a>
       </div>
       <!-- 
       <div class="rightbar-up">
         <div style="cursor:pointer;"><img onclick="collapseUp()" id="rightBarUp" src="<%=imgPath%>/mainframe/call_up.jpg"/></div>
       </div>
        -->
       <div style="position: relative;left:300px;top:-53px">
       <div class="right-user">
         <img id="rightBarUser"/>
         <div class="right-username" onclick="editUserInfo()" id="username">
           <input type="text" id="usernameText" readonly onfocus="this.blur()">
         </div>
       </div>
       
       <div class="right-editInfoCtn">
         <div class="right-editInfo" id="editInfo"><input type="text" id="editInfoText" /></div>
       </div>
       
       <div class="right-status">
         <img id="rightBarStatus" src="<%=imgPath%>/U01.gif"/><div style="position:absolute;top:0px;left:20px;" class="right-userstatus" id="userstatus" style="">
         <input type="text" id="userStatusText" readonly onfocus="this.blur()"></div>
       </div>
     </div>
     </div>
  <div class="ui-layout-south" id="southContainer">
  </div>
  <div class="ui-layout-west" id="westContainer">
    <div class="leftmenu-north-lv1 ui-layout-north">
      <div class="leftmenu-north-lv1-menu" id="menuExplorer">
      </div>
      <a href="javascript:void();" class="left-callLeft" onclick="collapseLeft();return false;"></a>
    </div>
    <div id=leftPanel class="ui-layout-center">
      <div id="tabpanelLv1" class="ui-layout-center leftContent">
      
        <div id="navigation">
          <div class="leftmenu-north-lv2">
          </div>
          <div class="leftmenu-body">
            <div id="menu"></div>
            <div id="shortcut"></div>
            <div id="fav"></div>
          </div>
        </div>
        
        <div id="organization">
          <div class="leftmenu-north-lv2">
          </div>
          <div class="leftmenu-body">
            <div id="onlineUsers"></div>
            <div id="allUsers"></div>
          </div>
        </div>
        
        <div id="sms">
          <div class="leftmenu-north-lv2">
          </div>
          <div class="leftmenu-body">
            <div id="remind"></div>
            <div id="smsReceived"></div>
            <div id="smsSend"></div>
            <div id="share"></div>
          </div>
        </div>
        
        <div id="search">
          <div class="leftmenu-north-lv2">
          </div>
          <div class="leftmenu-body">
            <div id="searchContent"></div>
          </div>
        </div>
      </div>
      <div class="ui-layout-west leftmenu-west">
      </div>
      <div class="ui-layout-east leftmenu-east">
      </div>
      <div class="ui-layout-south leftmenu-south">
      </div>
    </div>
  </div>
  <div class="ui-layout-center" id="mainContainer">
 
   <div class="ui-layout-center">
     <iframe id="main-body-desktop" name="main-body-desktop" src="about:blank" frameborder="0" style="width:100%;height:100%;position:absolute;left: 0; top: 0;">
     </iframe>
     <iframe id="main-body-parts" name="main-body-parts" frameborder="0" style="border:none;display:none;width:100%;height:100%;position:absolute;">
     </iframe>
   </div>
  </div>
  <div id="smsFlash" onclick="sms.showShortMsrg()">
    <button style="cursor:pointer;width:65px; height:55px;background:transparent; border:0px; padding:0px;"> 
      <embed src="<%=contextPath %>/core/frame/wav/9.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="65" height="55" wmode="transparent">
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="<%=contextPath %>/core/frame/inc/swflash.cab" width="65" height="55" style="cursor:pointer;">
	        <param name="movie" value="<%=contextPath %>/core/frame/wav/9.swf" />
	        <param name="quality" value="high" />
	        <param name="wmode" value="transparent"/>
        </object>
      </embed>
    </button>
  </div>

  <div id="contentTipMan" class="content-tip">
    <ul>
        <li><a href="javascript:void(0);" onclick="changeStatus(1);return false;"><img src="<%=imgPath%>/U01.gif"/>&nbsp;联机</a></li>
        <li><a href="javascript:void(0);" onclick="changeStatus(2);return false;"><img src="<%=imgPath%>/U02.gif"/>&nbsp;忙碌</a></li>
        <li><a href="javascript:void(0);" onclick="changeStatus(3);return false;"><img src="<%=imgPath%>/U03.gif"/>&nbsp;离开</a></li>
    </ul>
  </div>
  <div id="contentTipWoman" class="content-tip">
    <ul>
        <li><a href="javascript:void(0);" onclick="changeStatus(1);return false;"><img src="<%=imgPath%>/U11.gif"/>&nbsp;联机</a></li>
        <li><a href="javascript:void(0);" onclick="changeStatus(2);return false;"><img src="<%=imgPath%>/U12.gif"/>&nbsp;忙碌</a></li>
        <li><a href="javascript:void(0);" onclick="changeStatus(3);return false;"><img src="<%=imgPath%>/U13.gif"/>&nbsp;离开</a></li>
    </ul>
  </div>
</body>
</html>