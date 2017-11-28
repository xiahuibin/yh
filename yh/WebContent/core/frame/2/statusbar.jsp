<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<%@ page import="yh.core.global.YHRegistProps" %>
<%@ page import="yh.core.util.auth.YHRegistUtility" %>
<%@page import="yh.core.util.ReloadLicenseUtil"%>
<html>
<head>
<title></title>
</head>
<%
response.setHeader("PRagma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String statusRefStr = YHSysProps.getString("$STATUS_REF_SEC");
if (statusRefStr == null || "".equals(statusRefStr.trim())) {
  statusRefStr = "3600";
}
int remainDays = YHRegistUtility.remainDays();
String onlineRefStr = YHSysProps.getString("$ONLINE_REF_SEC");
if (onlineRefStr == null || "".equals(onlineRefStr.trim())) {
  onlineRefStr = "3600";
}

String machineCode = "";
try {
	machineCode = YHRegistUtility.getMchineCode();
}	catch (Exception e) {
  
}

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table cellspacing="0" cellpadding="0" border="0" width="100%" class="status-content">
  <tr>
    <td width="100" align="center" class="statusbar-usercount" id="usercount">
       <a id="userCountDiv"  href="javascript:void(0)">
             共&nbsp;<span size="3" id="userCountInput" style="text-align:center;border:none;background-color:transparent;width:30px;"></span>&nbsp;人在线

       </a>
    </td>
    <td>
	    <div id="status">
			  <div id="statusContent" style="position:relative;top:0px;"></div>
			</div>
    </td>

	<td width="135">
		<a href="<%=contextPath%>/core/funcs/email/index.jsp" title="邮件" id="r_email" class="remindImg" target="main-body-parts" style="float: left;display: block;margin-top: -12px;margin-right: 7px;"><i class="iconfont" style="font-size: 35px;">&#xe60f;</i></a>
		<a href="<%=contextPath%>/core/funcs/mobilesms/index.jsp" title="短信" id="r_sms" class="remindImg" target="main-body-parts" style="float: left;display: block;margin-top: -6px;margin-right: 7px;"><i class="iconfont" style="font-size: 30px;">&#xe60d;</i></a>
		<a href="<%=contextPath%>/core/funcs/sms/index11.jsp" title="短讯" id="r_blog" class="remindImg" target="main-body-parts" style="float: left;display: block;margin-top: -1px;margin-right: 7px;"><i class="iconfont" style="font-size: 25px;">&#xe627;</i></a>
	</td>
	</td>

  </tr>
</table>
<script type="text/javascript">
	$("#userCountDiv").click(function(e){
		e.stopPropagation()
		if($("#onlineTreeDiv").css('display') == "none"){
			$("#onlineTreeDiv").show("slow");
			$("#onlineTreeFrame").attr("src","<%=contextPath%>/core/frame/onlinetree.jsp");
			
		}else{
			$("#onlineTreeDiv").hide("slow"); 
		}
	}); 
	
	
	YH.remind = {};
	
	$(".remindImg").each(function(){
		$(this).click(function(){ 
			if(YH.remind[this.id] && YH.remind[this.id] > 0){
				clearInterval(YH.remind[this.id]);
				YH.remind[this.id] = 0;
				$(this).css("margin-top",0);
			}
			dispParts("<%=contextPath %>" + $(this).attr("lang"),0);
		});
	});
	
	function remind(type){
		$(".remindImg").each(function(index){
			if(index == type){
				YH.remind[this.id] = setInterval("anremind('"+this.id+"')",100)
			}
		});
	}
	
	function anremind(id){
		var mt = $("#" + id).css("margin-top");
		mt = parseInt(mt.replace("px",""),10);
		if(mt == 3){
			$("#" + id).css("margin-top",1);
		}else{
			$("#" + id).css("margin-top",3);
		}
	}
	function initUserCound() {
	  var url = "<%=contextPath%>/yh/core/frame/act/YHClassicInterfaceAct/queryUserCount.act";
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
	
	function initStatus() {
	  var url = "<%=contextPath%>/yh/core/frame/act/YHClassicInterfaceAct/queryStatusText.act";
	  $.ajax({
	    type: "GET",
	    dataType: "text",
	    url: url,
	    success: function(text){
	      var json = YH.parseJson(text);
	      if (json.rtState == '0') {
	        $('#statusContent').html(json.rtData.TEXT || '<%=StaticData.VERSIONDESC%>');
		      var lineHeight = $("#status").height();
		      var top = 0;
		      var height = $('#statusContent').height();
		      
		      function scroll() {
		        if (top < 2 * lineHeight - height) {
	            top = lineHeight;
	          }
		        $('#statusContent').animate({
		          'top': top -= lineHeight
			      }, 'slow');
		      }
		      
		      var marquee = 5000;
		      
		      if (!isNaN(json.rtData.MARQUEE)) {
		        maruqee = json.rtData.MARQUEE * 1000;
		      }
		      
		      var t = setInterval(scroll, marquee);
	      }
	    }
	  });
	}
	initStatus();
	initUserCound();
	 
	var statusRef = '<%=statusRefStr%>';
	if (isNaN(statusRef)) {
	  statusRef = 3600;
	}
	setInterval(initStatus, statusRef * 1000);
	
	 var onlineRef = '<%=onlineRefStr%>';
	if (isNaN(onlineRef)) {
	  onlineRef = 120;
	}
	setInterval(initUserCound, onlineRef * 1000);
</script>
</body>
</html>