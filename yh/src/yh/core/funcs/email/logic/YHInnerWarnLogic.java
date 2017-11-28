package yh.core.funcs.email.logic;

import java.sql.Connection;
import java.util.Map;

import org.apache.log4j.Logger;

import yh.core.funcs.sms.data.YHSmsBack;
import yh.core.funcs.sms.logic.YHSmsUtil;

public class YHInnerWarnLogic {

	private Logger log = Logger.getLogger(YHInnerWarnLogic.class);
  /**
   * 短信提示
   * 
   * @param conn
   * @param request
   * @param emailId
   * @param emailBodyId
   * @param userId
   * @return
   * @throws Exception
   */
  public boolean smsRmind(Connection conn,Map<String,Object> map) throws Exception {
    String subject = "预警信息！主题："+map.get("whName")+"的"+map.get("pro_name")+"库存不足请补充！";
    String param=map.get("proId")+","+map.get("whId");
    String remindUrl = "/springViews/erp/warn/show.jsp?param="+param;
    YHSmsBack sb = new YHSmsBack();
    sb.setContent(subject);
    sb.setSmsType("2");
    sb.setToId("1");
    sb.setFromId(Integer.parseInt(map.get("wpId").toString()));
    sb.setRemindUrl(remindUrl);
    YHSmsUtil.smsBack(conn, sb);
    return false;
  }

  }

  
