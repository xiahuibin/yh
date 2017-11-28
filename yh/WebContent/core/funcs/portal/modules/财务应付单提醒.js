{
  tbar: [{
    id: 'close'
  }, {
    id: 'more',
    preventDefault: true,
    handler: function(e, t, p) {
      openUrl({
        text: "财务应付单提醒",
        url: contextPath + "/springViews/erp/finance/financeRemind/moneyOutManage.jsp"
      });
    }
  }],
  
  width: "500px",
  "items":[{
    xtype: "grid",
    loader: {
      url: contextPath + "/yh/core/funcs/notify/act/YHNotifyShowAct/queryAllFinanceInRemind.act"
    },
    rowRender: function(i, e) {
      var icon = "";
      function deskFinanceInRemind(seqId){
        var img = document.getElementById("img_" + seqId + "");
        if(img){
          document.getElementById("img_" + seqId + "").style.display= "none";
        }
        var URL = contextPath + '/springViews/erp/finance/financeRemind/moneyOutManage.jsp?status='+e.status;
        myleft= (screen.availWidth-500) / 2;
        window.open(URL, "deskFinanceInRemind", "height=600,width=800,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,top=100,left=" + myleft + ", resizable=yes");    
      }
      var a = $("<a href='javascript:void(0);'></a>");
       a.click(function() {
        deskFinanceInRemind(e.seqId);
        var imgObj = $('#imgId'+i);
        if(icon == null || icon == "")
        {
        	return ;
        }else if(imgObj != null && imgObj != 'undefined'){
        	imgObj.remove();
        	return;
        }
      });
       
      var code = $('<span class="title"></span>').html(e.code);
      var seqId = $('<span class="desc"></span>').html(e.seqId);
      var status = '';
      
		if(e.status=='0'){
			status = $('<span class="time"></span>').html("新建状态");
		}else if(e.status==1){
			status = $('<span class="time"></span>').html("审核中");
		}else if(e.status==2){
			status = $('<span class="time"></span>').html("审核通过");
		}else if(e.status==3){
			status = $('<span class="time"></span>').html("审核没通过");
		}else if(e.status==4){
			status = $('<span class="time"></span>').html("执行中");
		}else{
			status = $('<span class="time"></span>').html("已完成");
		}
	      
      return a.append("应付单编号：").append("【").append(code).append("】").append("&nbsp;").append("应付单状态：").append(status);
    }
  }],
  "xtype": "panel",
  height: "auto",
  cls: "window-height",
  "cmpCls": "jq-window",
  "title": "财务应付单提醒"
}