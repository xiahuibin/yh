<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp"%>
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
String type1 = request.getParameter("type")==null?"":request.getParameter("type");
%>
<html>
<head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title></title>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/index1.css" />
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/fonts/iconfont.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/core/frame/webos/styles/style1/cmp/css/cmp-all.css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery-ui.custom.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.yh.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.autolayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.fitlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.freelayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.floatlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.columnlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.gridlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.cardlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.module.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.container.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.panel.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.window.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.tip.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.button.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.borderlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/frame/2/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/frame/2/js/index.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/frame/common/sms/sms.js"></script>

</head>
<body onload="doInit()">

	<div class="index_top ui-layout-north right-funcsbar" id="rightHeaderBar">
		<div class="top_left">
			<img src="<%=imgPath%>/systop/systemlogo.png" />
		</div>
		<div class="nav" id="nmenu"></div>
		<div class="top_right">
			<ul>
				<li class="clear">
					<a id="username" href="javascript:void(0)" style="margin-left: 0px;"><i class="iconfont">&#xe606;</i><span id='usernameText' style="vertical-align: top;"></span></a>| 
					<a href="javascript:dispDesk();"><i class="iconfont">&#xe60a;</i>桌面</a>| 
					<a href="javascript:doLogoutMsg()"><i class="iconfont">&#xe60e;</i>注销</a></li>
				<li class="mt8" id="time"></li>
			</ul>
		</div>
		<div class="clear"></div>
		<!-- crumbs -->
		<div class="crumbs">
			<div class="fl">
				<div class="nav-header">
					<span class="pf-name">功能导航</span>
				</div>
			</div>
			<div class="fl">
				<span class="crumbs-label">首页</span>
			</div>
			<div class="clear"></div>
		</div>
		<!-- crumbs end -->
		
	</div>


	<div class="ui-layout-south" id="southContainer"></div>
	<div class="ui-layout-west" id="westContainer">
		<div id=leftPanel class="ui-layout-center">
			<div id="tabpanelLv1" class="ui-layout-center leftContent">

				<div id="navigation">
					<div class="leftmenu-north-lv2" style="display: none;"></div>
					<div class="leftmenu-body" style="top: 0px;">
						<div>
							<ul class="menu-lv1" style='padding-top: 15px;'>
								<li style="height: auto;">
									<ul id="menu" class="menu-lv2">
									</ul>
								</li>
							</ul>
						</div>
						<div id="shortcut"></div>
						<div id="fav"></div>
					</div>
				</div>

				<div id="organization">
					<div class="leftmenu-north-lv2"></div>
					<div class="leftmenu-body">
						<div id="onlineUsers"></div>
						<div id="allUsers"></div>
					</div>
				</div>

				<div id="sms">
					<div class="leftmenu-north-lv2"></div>
					<div class="leftmenu-body">
						<div id="remind"></div>
						<div id="smsReceived"></div>
						<div id="smsSend"></div>
						<div id="share"></div>
					</div>
				</div>

				<div id="search">
					<div class="leftmenu-north-lv2"></div>
					<div class="leftmenu-body">
						<div id="searchContent"></div>
					</div>
				</div>
			</div>
			<div class="ui-layout-west leftmenu-west"></div>
			<div class="ui-layout-east leftmenu-east"></div>
			<div class="ui-layout-south leftmenu-south"></div>
		</div>
	</div>
	<div class="ui-layout-center" id="mainContainer">

		<div class="ui-layout-center">
			<iframe id="main-body-desktop" name="main-body-desktop" src="about:blank" frameborder="0" style="width: 100%; height: 100%; position: absolute; left: 0; top: 0;"> </iframe>
			<iframe id="main-body-parts" name="main-body-parts" frameborder="0" style="border: none; display: none; width: 100%; height: 100%; position: absolute;"> </iframe>
		</div>
	</div>
	<div id="smsFlash" onclick="sms.showShortMsrg()">
		<button style="cursor: pointer; width: 65px; height: 55px; background: transparent; border: 0px; padding: 0px;">
			<embed src="<%=contextPath %>/core/frame/wav/9.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="65" height="55"
				wmode="transparent">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="<%=contextPath %>/core/frame/inc/swflash.cab" width="65" height="55" style="cursor: pointer;">
				<param name="movie" value="<%=contextPath %>/core/frame/wav/9.swf" />
				<param name="quality" value="high" />
				<param name="wmode" value="transparent" />
			</object>
			</embed>
		</button>
	</div>
	<div id="onlineTreeDiv" class="onlineTreeDiv" style="">
		<iframe frameborder="0" width="100%" height="100%" scrolling="auto" id="onlineTreeFrame"></iframe>
	</div>
	
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
		
			
			$("body").click(function(){
				$("#onlineTreeDiv").hide("slow"); 
			});
			//theme();
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
		  $('#southContainer').load('<%=contextPath %>/core/frame/2/statusbar.jsp');
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
		        body.css({'height': (el.innerHeight()) + 'px'});
		        if (!el.data('resize')) {
		          $(el.parent()).resize(function() {
		            body.css({'height': (el.innerHeight()) + 'px'});
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
		        body.css({'height': (el.innerHeight()) + 'px'});
		        if (!el.data('resize')) {
		          $(window).resize(function() {
		            body.css({'height': (el.innerHeight()) + 'px'});
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
		        body.css({'height': (el.innerHeight() ) + 'px'});
		        if (!el.data('resize')) {
		          $(window).resize(function() {
		            body.css({'height': (el.innerHeight() ) + 'px'});
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
		        body.css({'height': (el.innerHeight() ) + 'px'});
		        if (!el.data('resize')) {
		          $(window).resize(function() {
		            body.css({'height': (el.innerHeight() ) + 'px'});
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
		  
		  //initUserInfo();
		  //initUserStatus();
		  initTime();
		  //fillShortcut();
		  window['main-body-desktop'].location.href = "<%=contextPath %>/core/frame/2/desktop.jsp";
		  
		  $("#main-body-desktop").bind("load", function(){
			$("#main-body-desktop").contents().find("body").click(function(){
				$("#onlineTreeDiv").hide("slow"); 
			});
		  }); 
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
		
		/**
		 * 默认界面主题
		 * @return
		 */
		
		function theme(){
		  var url = "<%=contextPath%>/yh/core/funcs/system/interfaces/act/YHInterFacesAct/getTheme.act";
		  $.ajax({
				type: "GET",
				dataType: "text",
				url: url,
				success: function(text){
				var rtJson = YH.parseJson(text); 
			   if (rtJson.rtState == "0") {
			     var select = document.getElementById("theme");
			     //select.value = "0";
			     for(var i = 0; i < rtJson.rtData.length; i++) {
			       var option = document.createElement("option");
			       option.value = rtJson.rtData[i].value;
			       option.innerHTML = rtJson.rtData[i].text;
			       select.appendChild(option);
			     }
			   } 
			   }});
		}
		
		function changeTheme()
		{
			var theme = parseInt("<%=styleIndex %>");
			if(theme == 3)
			{
				theme = 1;
			}
			else{
				theme++;
			}
			var url="<%=contextPath%>/yh/core/funcs/system/interfaces/act/YHInterFacesAct/changeTheme.act?theme="+theme+"&date="+new Date();
			$.ajax({
				type: "post",
				dataType: "text",
				url: url,
				success: function(data){
				var rtJson = YH.parseJson(data); 
			   	if (rtJson.rtState == "0") {
			   		window.location.reload(true);
					}
			   }});
			
		}
		
		function nsearch(){ 
			var k = $("#scon").val();
			dispParts('<%=contextPath%>/core/funcs/search/index.jsp?im=true&keyword=' + k,0)
		}
		function doInit(){
			var type = "<%=type1%>" ;
			if(type == "openAccount"){
				window.parent.parent.location.href='yhindex.jsp';
				return true;
			}else{
				return false;
			}
		}
		</script>
</body>
</html>