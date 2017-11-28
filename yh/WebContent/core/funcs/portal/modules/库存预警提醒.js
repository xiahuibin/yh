{ 
  tbar: [{
    id: 'close'
  }, {
    id: 'more',
    preventDefault: true,
    handler: function(e, t, p) {
      openUrl({
        text: "库存预警提醒",
        url: contextPath + '/springViews/erp/dbWarnManage'
      });
    }
  }],
  width: "500px",
  "items":[{
    xtype: "grid",
    loader: {
      url: contextPath + "/yh/core/funcs/notify/act/YHNotifyShowAct/queryAllDbWarnRemind.act"
    },
    rowRender: function(i, e) {
      var icon = "";
      function deskPurchaseRemind(seqId){
        var img = document.getElementById("img_" + seqId + "");
        if(img){
          document.getElementById("img_" + seqId + "").style.display= "none";
        }
        var param=e.proId+","+e.whId;
        var URL = contextPath + '/springViews/erp/warn/show.jsp?param='+param;
        myleft= (screen.availWidth-500) / 2;
        window.open(URL, "deskPurchaseRemind", "height=600,width=600,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,top=100,left=" + myleft + ", resizable=yes");    
      }
      var a = $("<a href='javascript:void(0);'></a>");
       a.click(function() {
        deskPurchaseRemind(e.seqId);
        var imgObj = $('#imgId'+i);
        if(icon == null || icon == "")
        {
        	return ;
        }else if(imgObj != null && imgObj != 'undefined'){
        	imgObj.remove();
        	return;
        }
      });
       
      var sumNum = $('<span class="title"></span>').html(e.sumNum);
      var warnNum = $('<span class="desc"></span>').html(e.warn_num);
      var whName = $('<span class="time"></span>').html(e.whName);
      var proName = $('<span class="time"></span>').html(e.pro_name);
      var status = '';
	      
      return a.append("仓库名称：").append("【").append(whName).append("】").append("&nbsp;").append("产品名称：【").append(proName).append("】&nbsp;").append("库存总量：").append(sumNum).append("&nbsp;").append("库存预警值：").append(warnNum);
    }
  }],
  "xtype": "panel",
  height: "auto",
  cls: "window-height",
  "cmpCls": "jq-window",
  "title": "库存预警提醒"
}