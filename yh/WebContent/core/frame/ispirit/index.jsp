<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.core.global.YHRegistProps" %>
<%@ page import="yh.core.funcs.person.data.YHPerson" %>
<%@ page import="yh.core.util.auth.YHRegistUtility" %>
<%
YHPerson person = (YHPerson)request.getSession().getAttribute("LOGIN_USER");
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
response.setHeader("PRagma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
int remainDays = YHRegistUtility.remainDays();
String onlineRefStr = YHSysProps.getString("$ONLINE_REF_SEC");
if (onlineRefStr == null || "".equals(onlineRefStr.trim())) {
  onlineRefStr = "3600";
}
%>
<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/index2.css"/>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/ispirit.css"/>
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/extResources/css/jq-yhtheme.css" />
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/jquery.ui.sortable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.yh.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.container.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.panel.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.window.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.tip.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/yh.layouts.autolayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.cardlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.menu.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/js/jquery/ux/jquery.ux.borderlayout.js"></script>
<script type="text/javascript" src="<%=contextPath %>/core/frame/2/js/index.js"></script>
<script type="text/Javascript" src="<%=contextPath%>/core/frame/ispirit/n12/js/ipanel_org.js" ></script>
<script type="text/javascript">
var bodyCards = new Array();
var sessionToken = "<%=sessionToken%>";
//??????????????????
var imgsSrc = [{
  src: imgPath + '/mainframe/explorer.png',
  selectedSrc: imgPath + '/mainframe/explorer_selected.png',
  imgs: [{
    src: imgPath + '/mainframe/all.png',
    selectedSrc: imgPath + '/mainframe/all_selected.png'
  },{
    src: imgPath + '/mainframe/shortcut.png',
    selectedSrc: imgPath + '/mainframe/shortcut_selected.png'
  },{
    src: imgPath + '/mainframe/fav.png',
    selectedSrc:imgPath + '/mainframe/fav_selected.png'
  }]
}, {
  src:imgPath + '/mainframe/org.png',
  selectedSrc: imgPath + '/mainframe/org_selected.png',
  imgs:[{
    src: imgPath + '/mainframe/online.png',
    selectedSrc: imgPath + '/mainframe/online_selected.png'
  },{
    src: imgPath + '/mainframe/all.png',
    selectedSrc: imgPath + '/mainframe/all_selected.png'
  },{
	    src: imgPath + '/mainframe/latist.png',
	    selectedSrc: imgPath + '/mainframe/latist_selected.png'
	  },{
		    src: imgPath + '/mainframe/group.png',
		    selectedSrc: imgPath + '/mainframe/group_selected.png'
		}]
}, {
  src: imgPath + '/mainframe/sms.png',
  selectedSrc: imgPath + '/mainframe/sms_selected.png',
  imgs:[{
    src: imgPath + '/mainframe/remind.png',
    selectedSrc:  imgPath + '/mainframe/remind_selected.png'
  },{
    src: imgPath + '/mainframe/send.png',
    selectedSrc:  imgPath + '/mainframe/send_selected.png'
  },
  {
  src: imgPath + '/mainframe/recive.png',
  selectedSrc:  imgPath + '/mainframe/recive_selected.png'
  },{
  src:  imgPath + '/mainframe/share.png',
  selectedSrc: imgPath + '/mainframe/share_selected.png'
   }
  ]
}, {
  src:imgPath + '/mainframe/search.png',
  selectedSrc: imgPath + '/mainframe/search_selected.png'
}];
var checkTimeout = parseNumber("<%=smsRef%>", 30);
var shortMsrgTimer = null;
//??????????????????
var smsCallCount = parseNumber("<%=smsCallCount%>", 3);

//??????????????????
var smsInterval = parseNumber("<%=smsInterval%>", 3);
var smsAlertTimer = null;

function resetSmsCallCount() {
  smsCallCount = parseNumber("<%=smsCallCount%>", 3);
}
function parseNumber(value, defValue) {
  if (isNaN(value)) {
    return defValue;
  }
  return value * 1;
}

</script>
<style>
body {
  width: 100%;
  height: 100%;
  background-color:#FFFFFF;
}
.leftmenu-north-lv2{

}
.leftmenu-north-lv1 {
}
#search{
  background-color:#FFFFFF;
}
#usercount {
  width: 100%;
}

</style>
</head>
<body>
  <div id="leftmenu-north-main-lv1" class="ui-layout-north leftmenu-north-lv1">
    <div class="leftmenu-north-lv1-menu" id="menuExplorer">
    </div>
  </div>
  <div id="leftPanel" class="ui-layout-center">
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
            <div id="recent"></div>
          <div id="group"></div>
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
        <div class="leftmenu-north-lv2" style="height:10px;">
        </div>
        <div class="leftmenu-body">
          <div id="searchContent"></div>
        </div>
      </div>
    </div>
    <div class="ui-layout-south leftmenu-south" style="background-color:#FFFFFF;">
    </div>
  </div>
 <div align="center" class="ui-layout-south statusbar-usercount" id="usercount">
      <a onclick="selectTab(1);return false;" href="javascript:void(0)">
            ???&nbsp;<span size="3" id="userCountInput" style="text-align:center;border:none;background-color:transparent;width:30px;"></span>&nbsp;?????????

      </a>
  </div>
  <div id="flashPlayer" style="visibility: hidden;"></div>
<script type="text/javascript"><!--
initLeftTbar($('#menuExplorer'), imgsSrc, 0, function(i) {
  card.setActiveItem(i);
});
if( navigator.userAgent.indexOf("MSIE 9.0")>0){
  window.westLayout = $('body').layout({
    'listeners': {
      'resize': function(){
        leftLayout.resizeAll();
      }
    },
    'north': {
      size: 33
    },
    'center': {
    },
    'south': {
      size: 33
    }
  });
}else {
  window.westLayout = $('body').layout({
    'listeners': {
      'resize': function(){
        leftLayout.resizeAll();
      }
    },
    'north': {
      size: "33"
    },
    'center': {
      //size: "auto"
    },
    'south': {
      size: "auto"
    }
  });
}
window.leftLayout = $('#leftPanel').layout({
  'listeners': {
    'resize': function(){
      $('#leftPanel .ui-layout-center:first').resize();
    }
  },
  south: {
    size: 0
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
        reload: true,
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
            window['onlineIframe'].location.href = '<%=contextPath%>/core/frame/ispirit/n12/org/onlinetree.jsp';
          },
          function(element, elindex) {
            if (!window['allusersIframe']) {
              element.append('<iframe name="allusersIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
            }
            window['allusersIframe'].location.href = '<%=contextPath%>/core/frame/ispirit/n12/org/allusertree.jsp';
          },
          function(element, elindex) {
              if (!window['recentIframe']) {
                element.append('<iframe name="recentIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
              }
              window['recentIframe'].location.href = '<%=contextPath%>/core/frame/ispirit/n12/org/recent.jsp';
            },
            function(element, elindex) {
              if (!window['groupIframe']) {
                element.append('<iframe name="groupIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
              }
              window['groupIframe'].location.href = '<%=contextPath%>/core/frame/ispirit/n12/org/imGroup.jsp';
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
        reload: true,
        loadHandler: [
          function(element, elindex) {//?????????
              if (!window['remindboxIframe']) {
                var iframe = '<iframe name="remindboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
                element.append(iframe);
              }
              window['remindboxIframe'].location.href = '<%=contextPath%>/core/funcs/sms/jpanel/inboxSms.jsp?pageNo=0&pageSize=5&im=1';
            },
          function(element, elindex) {//??????
            if (!window['inboxIframe']) {
              var iframe = '<iframe name="inboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
              element.append(iframe);
            }
            window['inboxIframe'].location.href = '<%=contextPath%>/core/funcs/message/jpanel/inboxMessage.jsp?pageNo=0&pageSize=5&im=1';
          },
          function(element, elindex) {  //??????
            if (!window['sentboxIframe']) {
              var iframe = '<iframe name="sentboxIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>';
              element.append(iframe);
            }
            window['sentboxIframe'].location.href = '<%=contextPath%>/core/funcs/message/jpanel/sentboxMessage.jsp?pageNo=0&pageSize=5&im=1';
          },
          function(element, elindex) {  //??????
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
        reload: true,
        loadHandler: [
          function(element, elindex) {
            if (!window['searchIframe']) {
              element.append('<iframe name="searchIframe" border="0" frameborder="0" cellspacing="0" style="overflow:auto;width:100%;height:99%;border:none;background-color:transparent;" allowTransparency="true" src="about:blank"></iframe>');
              window['searchIframe'].location.href = '<%=contextPath%>/core/frame/ispirit/n12/search/index.jsp?im=1';
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

(function() {
  function initUserCound() {
    var url = "<%=contextPath%>/yh/core/funcs/setdescktop/syspara/act/YHSysparaAct/queryUserCount.act";
    $.ajax({
      type: "GET",
      dataType: "text",
      url: url,
      success: function(text){
        var json = YH.parseJson(text);
        if (json.rtState == '0') {
            document.getElementById("userCountInput").innerHTML = json.rtData;
          //$('#userCountInput').val(json.rtData);
        }
      }
    });
  }
    
  initUserCound();
  
   var onlineRef = '<%=onlineRefStr%>';
  if (isNaN(onlineRef)) {
    onlineRef = 120;
  }
  doInit();
  setInterval(initUserCound, onlineRef * 1000);
})();

/**
 * ??????????????????????????????
 * @param src   ???javascript:?????????????????????javascript:???????????????

 *              ??????openFlag=1???url?????????????????????(????????????openWidth=?/openHeight=??????????????????????)
 * @return
 */
function dispParts(src, openFlag){
  if (src) {
    if (/javascript:/.exec(src)) {
      //????????????javascript:???src?????????????????????


      try {
        eval(src);
      } catch (e) {
        
      }
    }
    else {
      //?????????????&??????URL
      var srcList = src.split(/[?&]/);
      var url = '';
      var paras = '';
      
      if (srcList.length > 1) {
        $.each(srcList, function(i, e) {
          if (e == 'openFlag=1') {
            openFlag = 1;
          }
          else if (/^openHeight=:/.exec(e)) {
            paras += e.replace('openHeight','height') + ',';
          }
          else if (/^openWidth=:/.exec(e)) {
            paras += e.replace('openWidth','width') + ',';
          }
          else if (url.indexOf('?') > 0) {
            url += e + '&';
          }
          else {
            url += e + '?';
          }
        });
      }
      else {
        url = src;
      }
      
      if (openFlag == 1) {
        //???openFlag=1??????????????????????????????
        window.open(encodeURI(url), '', paras);
      }
      else{
        try {
	        if(typeof(window.external.OA_SMS) != 'undefined') {
	          var path = contextPath + "/core/frame/ispirit/frame.jsp?url=" + encodeURI(url).replace('?', '&');
		        window.external.OA_SMS(path, "", "OPEN_URL");
	        }
        } catch (e) {

        } finally {

        }
      }
    }
  }
}

try {
	if(typeof(window.external.OA_SMS) != 'undefined') {  //????????????
	  window.external.OA_SMS("<%=person.getUserName()%>", "<%=person.getSeqId()%>", "NAME");
	}
} catch (e) {

} finally {

}

function checkShortMsrg() { 
  if (sms.shortMsrgTimer) {
    clearTimeout(sms.shortMsrgTimer);
  }
  var self = this;
  var rtJson = null;

  var url = contextPath + "/yh/core/funcs/message/act/YHMessageAct/remindCheck.act";
  $.ajax({
    type: "GET",
    dataType: "text",
    url: url,
    success: function(text){
      var rtJson = YH.parseJson(text);
      if (rtJson.rtState == '0') {
        if (rtJson.rtData == 0) {
        //????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        } else if (rtJson.rtData > 0) {
          oaSmsOpen(rtJson.rtData);
        } else if (rtJson.rtData < 0){
          //????????????????????????
          doLogout();
        }
      }
    },
    complete: function() {
      sms.shortMsrgTimer = setTimeout(function() {
        checkShortMsrg.call(self)
      }, 60 * 1000);
    }
  });
}


/* function ispirit_js(op_str)
{
   if(op_str=="show_sms")
   {
     sms_mon();
   }
   else if(op_str=="sms_mon")
   {
     sms_mon();
   }
   else if(op_str=="set_sms_ref")
   {
      //parent.status_bar.set_sms_ref();
   }
   else if(op_str=="set_no_sms")
   {
      //parent.status_bar.set_no_sms();
   }
} */

/**
 * ????????????yh??????
 */
 
var  bIMLogin=false;       // ????????????im?????????
var module_ie_im="im";     //???????????????im??????

function ispirit_js(op_str)
{
  // setBody();
   if(op_str=="show_sms")       //??????????????????   ??????????????????????????????????????????
   {
	   sms_mon();
   }
   else if(op_str == "show_module")    //??????OA??????????????????  *
   {  
	   show_module(arguments[1]);
   }
   else if(op_str=="sms_mon")    //?????????????????? ??????    ??????????????????
   {
	   //sms_mon();
	   show_sms();
   }
   else if(op_str=="set_sms_ref")      //???????????????????????????????????????10??????
   {
	   set_sms_ref();
	   bIMLogin = true;
	
	   // frames['status_bar'].set_sms_ref(); */
	   
   }
   else if(op_str=="set_no_sms")    //??????OA?????????????????????
   {
	   //set_no_sms();
	   //frames['status_bar'].set_no_sms();
   }
   else if(op_str=="update_org")             //??????org??????
   {
	  // update_org();
   }
   else if(op_str=="new_msg_remind")        //??????OA?????????????????????????????????????????????
   {
    
      //ispirit_new_msg_remind(arguments[1]);
   }
   else if(op_str=="cancel_msg_remind")    //??????OA??????????????????????????????????????????
   {
    
         //ispirit_cancel_msg_remind(arguments[1]);
   }
   else if(op_str=="send_email")    //??????????????????????????????
   {
    /*   if(arguments.length >= 3)
         frames['ipanel'].send_email1(arguments[1], arguments[2]) */
         send_email1(arguments[1], arguments[2])
   }
   else if(op_str=="weixun_share")    //????????????
   {
   /*   if(arguments.length > 2 && frames['ipanel'].frames['blank'])
         frames['ipanel'].frames['blank'].location = '/general/ipanel/ispirit_api.php?API=weixun_share&SHARE_FLAG=' + arguments[2] + '&CONTENT=' + escape(arguments[1]);
   */    
      weixun_share(arguments[2] ,arguments[1]);
   }
   else if(op_str=="on_status")      //??????????????????
   {
	    setUserStatus(arguments[1]);
	  //  update_org();
   }
   else if(op_str=="show_im_panel")          //??????OA?????????
   {
	   window.external.OA_SMS("/yh/core/frame/2/index.jsp","","OPEN_URL");
	   
   }
   else if(op_str=="get_client_type")  //????????????????????????
   {
	   //var status = get_client_type(arguments[1], arguments[2]);
	   //alert(status);
	   return "2";
    
   }
   else if(op_str=="recent_changed")  //??????OA????????????????????????
   {
      //ispirit_recent_changed();
   }
}



function sms_mon() {   //???????????????????????????
	
 // sms.checkShortMsrg();
//  return;
  var url = contextPath + "/yh/core/funcs/sms/act/YHSmsAct/remindCheck.act";

  $.ajax({
    type: "GET",
    dataType: "text",
    url: url,
    success: function(text){
      var rtJson = YH.parseJson(text);
      if (rtJson.rtState == '0') {
        if (rtJson.rtData == 0) {
        //????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        } else if (rtJson.rtData > 0) {
          oaSmsOpen(rtJson.rtData);
          
        //  window.external.OA_SMS("","","OPEN_NOC"); //????????????
        } else if (rtJson.rtData < 0){
          //????????????????????????
          doLogout();
        }
      }
    },
    complete: function() {
    }
  });
}


function checkMessage() {   //????????????;
	  var url = contextPath + "/yh/core/funcs/sms/act/YHSmsAct/remindCheck1.act";
    var count=false;
	  $.ajax({
	    type: "GET",
	    dataType: "text",
	    url: url,
	    async:false,
	    success: function(text){
	    	    if(text!="0"){
	    	    	 count =true;
	    	    }
	    	
	    },
	    complete: function() {
	    	
	    }
	  });
	
	  return count;
}



 function show_sms()
 {   
    var count= checkMessage();
    
    if(count){
       var url = contextPath+"/yh/core/funcs/message/act/YHMessageAct/get_msg.act?IM_FLAG=1";
       $.ajax({
         type: "GET",
         dataType: "text",
         url: url,
         success: function(text){
           var rtJson = YH.parseJson(text);
           if (rtJson.rtState == '0') {
        	   
        	   rtJson=rtJson.rtData.data;
              // alert(rtJson.length);lll
              if(typeof(window.external.OA_SMS) != 'undefined') {
                for(var i=0; i<rtJson.length; i++)
                {
                   window.external.OA_MSG("RECEIVE_MSG", rtJson[i].from_uid, rtJson[i].time, rtJson[i].type, rtJson[i].content, rtJson[i].from_name);
                }
              }
              
           }
         },
         complete: function() {
         }
       });
       
    }
       

 }
 
/*
 * show_module
 */
 function set_sms_ref()
 {

	    smsInterval=10000;
	//  alert(smsInterval);
	   // ??????????????????
	  // sms_mon = 
       setInterval(sms_mon,smsInterval);
	   
	   //??????????????????
	  //show_sms =  
      setInterval(show_sms,smsInterval);
 }
 

 
 
 function show_module(module_id){
 var windowtype = ''
 if(module_id == "email"){            // ??????
    windowtype = 'MAX';
    URL ="/yh/core/funcs/email/index.jsp";        
 }else if(module_id == "person_info"){  //????????????
    URL ="/yh/core/funcs/userinfo/person.jsp?userId=<%=person.getSeqId()%>&windows=1";    
 }else if(module_id == "index"){        //??????
    windowtype = 'MAX';
    URL ="/yh/core/frame/2/index.jsp";   
 }else if(module_id == "group_msg"){     //????????????
    windowtype = '416,300';
    URL ="/yh/core/funcs/message/smsgSend.jsp";   
 }
 

 if(window.top.module_ie_im== "IE"){
	 <%
	 
	 Cookie[] cookie = request.getCookies();
	 String userName = new String();
	 if ( cookie != null ) {
	 for (int i = 0; i < cookie.length; i++) {
		 Cookie myCookie = cookie[i];
			 if (myCookie.getName().equals("userName")) {
			   userName = myCookie.getValue();
		 }
	 }
	}
	 
	 
	 %>
    var data="url="+encodeURI(URL);
    var toIEUrl=contextPath+"/core/frame/ispirit/n12/org/toIE.jsp?uid=<%=person.getSeqId()%>&"+data;
    window.open(toIEUrl); 

 }else{
	 window.external.OA_SMS(URL,windowtype,"OPEN_URL");
 }

}


function oaSmsOpen(count) {
  try {
		if(typeof(window.external.OA_SMS) != 'undefined') {
		  window.external.OA_SMS("", "1", "OPEN");
		}
  } catch (e) {

  } finally {

  }
	//sms.smsCallSound();
}

queryInfo();

<%-- function initSms() {
  setTimeout(function() {
    if (!userinfo.seqId) {
      initSms();
      return;
    }
    sms.initialize({
      type: "ispirit",
      smsOn: userinfo.smsOn,
      callSound: userinfo.callSound,
      userId: userinfo.seqId,
      smsCallCount: parseNumber("<%=smsCallCount%>", 3),
      smsInterval: parseNumber("<%=smsInterval%>", 3),
      smsRef: parseNumber("<%=smsRef%>", 30),
      showSmsButton: oaSmsOpen
    });
  }, 100);
}
initSms();
 --%>
/*
 * ????????????
 */
function send_email1(TO_UID,TO_NAME)
{
   URL="<%=contextPath%>/core/funcs/email/new/index.jsp?toId="+TO_UID;;
   window.external.OA_SMS(URL,"","OPEN_URL");
   
}

function weixun_share(shareFlag,content){
	var url=contextPath + "/yh/core/funcs/system/ispirit/n12/weixun_share/act/YHWeiXunShareAct/addWeiXun.act?content="+  encodeURIComponent(content);
	  $.ajax({
	    type: "GET",
	    dataType: "text",
	    url: url,
	    success: function(text){
	      var rtJson = YH.parseJson(text);
	      if (rtJson.rtState == '0') {
	      }
	    },
	    complete: function() {
	     
	    }
	  });
}

function setUserStatus(content){
	  var url="/yh/yh/core/funcs/system/ispirit/n12/weixun_share/act/YHWeiXunShareAct/setUserStatus.act?content="+ escape(content);
	  
	    $.ajax({
	      type: "GET",
	      dataType: "text",
	      url: url,
	      success: function(text){
	        var rtJson = YH.parseJson(text);
	        if (rtJson.rtState == '0') {
	     
	        }
	      },
	      complete: function() {
	       
	      }
	    });
	}


function set_im_on_status(){  //???????????????
    
	if(typeof(window.external.OA_SMS) != 'undefined'){  //??????????????????
    window.external.OA_SMS("IS_UN","1","INIT");  //0 GBK,1 UTF-8
//     window.external.OA_SMS("UPLOAD_MAX_FILESIZE","1024","INIT");  ???????????????????????????
    
    var on_status="<%=person.getOnStatus()%>";
    if(on_status==""){
    	on_status="1";
    }
<%
  String status=person.getMyStatus();
  if(status==null || "null".equals(status)){
    status="";
  }
%>
    window.external.OA_SMS("MY_STATUS","<%=status%>","INIT");  //0 GBK,1 UTF-8  
    window.external.OA_SMS("ON_STATUS",on_status,"INIT");  //1?????????2?????????3?????????  ??????
    var orgName=getOrgName();
    window.external.OA_SMS("WINDOW_CAPTION",orgName,"INIT");  //??????????????????
	}
}

function get_client_type(uId,deptId){ //??????????????????
	 var url="/yh/yh/core/funcs/system/ispirit/n12/weixun_share/act/YHWeiXunShareAct/getUserStatus.act?uId="+ escape(uId)+"&deptId="+deptId;
	 var status="";
     $.ajax({
       type: "GET",
       async:false,
       dataType: "text",
       url: url,
       success: function(text){//alert(text);
       status=text;
       
       },
       complete: function() {
        
       }
     });
// alert(status);
	return status;
	
}



function moduleIE(){
	
	   var url = "/yh/yh/core/funcs/system/security/act/YHSecurityAct/getSecrityImModule.act";
	   $.ajax({
	       type: "GET",
	       async:false,
	       dataType: "text",
	       url: url,
	       success: function(text){
	    	  var rtJson = YH.parseJson(text);
	    	    if (rtJson.rtState == "0") {
	    	        var data=rtJson.rtData;
	    	       
	    	        if(data.paraValue == "IE"){
	    	          module_ie_im="IE";
	    	        }
	    	      }else {
	    	        alert(rtJson.rtMsrg); 
	    	      }
	       
	       },
	       complete: function() {
	        
	       }
	     });

}


function getOrgName(){
     var name="";
     var url = "/yh/yh/core/funcs/system/ispirit/n12/org/act/YHIsPiritOrgAct/getOrgName.act";
     $.ajax({
         type: "GET",
         async:false,
         dataType: "text",
         url: url,
         success: function(text){
          var rtJson = YH.parseJson(text);
            if (rtJson.rtState == "0") {
                var data=rtJson.rtData;
                name=data.data;
              }else {
                alert(rtJson.rtMsrg); 
              }
         
         },
         complete: function() {
          
         }
       });
     
     return name;

}

function menu_lv(){
	//????????????
	jQuery("#menu ul.menu-lv1 li a").live("mouseover",function(){
		 jQuery(this).parent().first().removeClass("null");
		 jQuery(this).parent().first().addClass("li-hover");
	      
	});
	
	 jQuery("#menu ul.menu-lv1 li a").live("mouseout",function(){

		 jQuery(this).parent().first().removeClass("li-hover");
		 jQuery(this).parent().first().addClass("null");
	 });
}

//var sms_mon;
//var show_sms;
 function doInit(){
	 sms_mon();
	 show_sms();
	 moduleIE();   //??????????????????
	 //??????????????????
	 set_im_on_status();
	 menu_lv();
	 //setBody();
     setTimeout(setBody , 2000);
 }
 
function setBody(){
  if(navigator.userAgent.indexOf("MSIE 9.0") > 0){
	   setBody2();
	 }else{
	   setBody1();
    }
}

 
 function setBody1(){
    var ajustHeight =  $('#leftmenu-north-main-lv1').outerHeight();
    var iFrame =  $('#tabpanelLv1');
    var width = getTotalWidth() + "px";
    var sourthHeight =  $('#usercount').outerHeight();
    var height = (getTotalHeight() - ajustHeight - sourthHeight)+ "px";
    
    //$('#leftmenu-north-main-lv1').width(width);
    //$('#leftPanel').width(width);
    //$('#leftPanel').height(height);
    
     $('#leftmenu-north-main-lv1').css("width",width);
    $('#leftPanel').css("width",width);
    $('#leftPanel').css("height",height);
    
    iFrame.height(height);
    iFrame.width(width); 
    //alert(getTotalHeight() + ":" + ajustHeight + ":" + sourthHeight);
    //$('#leftmenu-north-main-lv1').css("width","100%");
    //$('#leftPanel').css("width","100%");
  }


 function setBody2(){
    var ajustHeight =  $('#leftmenu-north-main-lv1').outerHeight();
    var iFrame =  $('#tabpanelLv1');
    var width =getTotalWidth();
    var sourthHeight =  $('#usercount').outerHeight();
    var height = (getTotalHeight() - ajustHeight - sourthHeight);


    //$('#leftmenu-north-main-lv1').height("33px");
    $('#leftmenu-north-main-lv1').width(width);
    $('#leftPanel').width(width);
    $('#leftPanel').height(height);
   // $('#leftPanel').css("bottom","20px");
    iFrame.height(height);
    iFrame.width(width); 

    $('#leftmenu-north-main-lv1').css("width","100%");
    $('#leftPanel').css("width","100%");
  }

 function getTotalWidth (){ 
    if($.browser.msie){ 
    return document.compatMode == "CSS1Compat"? document.documentElement.clientWidth : document.body.clientWidth; 
    } 
    else{ 
    return self.innerWidth; 
    } 
} 

function getTotalHeight(){ 
    if($.browser.msie){ 
    return document.compatMode == "CSS1Compat"? document.documentElement.clientHeight : document.body.clientHeight; 
    } 
    else { 
    return self.innerHeight; 
    } 
} 
 
--></script>
</body>
</html>
