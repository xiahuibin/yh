package yh.subsys.inforesouce.act;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import yh.core.data.YHRequestDbConn;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.subsys.inforesouce.data.YHNode;

public class YHTouchGraphAct {
  private Map<String , YHNode> map= new HashMap();
  private Map<String , String[]> map2 = new HashMap();
  public String getArray(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    String ids = request.getParameter("id");
    if (YHUtility.isNullorEmpty(ids)) {
      ids = "28";
    }
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      this.setMap();
      StringBuffer sb = new StringBuffer("{centerNode:");
      String[] ss = ids.split(",");
      YHNode cNode = null;
      if (ss.length > 1) {
        String nodeName = "";
        for (String s : ss) {
          if (!"".equals(s)) {
            YHNode node = (YHNode)map.get(s);
            if (node != null) {
              String tmp = node.getNodeName();
              if (!this.findId(nodeName, tmp))
                nodeName += tmp + ",";
            }
          }
        }
        cNode = new YHNode(ids,true,nodeName,120,"","");
      } else {
        cNode = map.get(ss[0]);
      }
      String str = cNode.toJson();
      sb.append(str);
      sb.append(",nodes:[");
      Set<String> set = map.keySet();
      for (String tmp : set) {
        if (!this.findId(ids, tmp)) {
          YHNode node = (YHNode)map.get(tmp);
          sb.append(node.toJson() + ",");
        }
      }
      sb.deleteCharAt(sb.length() - 1);
      sb.append("]}");
      String data = sb.toString();
      request.setAttribute(YHActionKeys.RET_DATA, data);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "");
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  /**
   * ??????id????????????str??????
   * @param str
   * @param id
   * @return
   */
  public  boolean findId(String str, String id) {
    if(str == null || id == null || "".equals(str) || "".equals(id)){
      return false;
    }
    String[] aStr = str.split(",");
    for(String tmp : aStr){
      if(tmp.equals(id)){
        return true;
      }
    }
    return false;
  }
  public String getSubject(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    String ids = request.getParameter("id");
    String subject = request.getParameter("subject");
    if (YHUtility.isNullorEmpty(ids)) {
      ids = "28";
    }
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      this.setMap();
      this.setAllSubject();
      StringBuffer sb = new StringBuffer("{centerNode:");
      
      YHNode cNode = null;
      String[] ss = ids.split(",");
      if (ss.length > 1) {
        String nodeName = "";
        for (String s : ss) {
          if (!"".equals(s)) {
            YHNode node = (YHNode)map.get(s);
            if (node != null) {
              String tmp = node.getNodeName();
              if (!this.findId(nodeName, tmp))
                nodeName += tmp + ",";
            }
          }
        }
        cNode = new YHNode(ids,true,nodeName,120,"","");
      } else {
        cNode = map.get(ss[0]);
      }
      String str = cNode.toJson();
      sb.append(str);
      String[] ssb = map2.get(subject);
      sb.append(",nodes:[");
      for (String tmp : ssb) {
        sb.append(toJson(tmp) + ",");
      }
      sb.deleteCharAt(sb.length() - 1);
      sb.append("]}");
      String data = sb.toString();
      request.setAttribute(YHActionKeys.RET_DATA, data);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "");
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String toJson(String value) {
    StringBuffer sb = new StringBuffer();
    sb.append("{id:'" + value + "'");
    sb.append(",isRect:false" );
    sb.append(",nodeName:'" + value + "'");
    sb.append(",len:300");
    sb.append(",title:'" + value + "'");
    sb.append(",relation:'" + value + "'");
    sb.append("}");
    return sb.toString();
  }
  public void setAllSubject() {
    String[] ss1 = {"??????","??????","??????"
        ,"??????","??????" ,"??????" ,"??????","??????" ,"??????" };
    map2.put("??????", ss1);
    String[] ss2 = {"??????","??????","??????","??????","??????" ,"??????","??????","??????" ,"??????" ,"??????","??????","??????"};
    map2.put("????????????", ss2);
    String[] ss3 = {"??????" ,"??????" ,"??????","??????" ,"??????","??????" ,"??????" ,"???"};
    map2.put("??????", ss3);
    String[] ss4 = {"????????????" ,"??????" ,"??????" ,"??????","??????","??????" };
    map2.put("??????", ss4);
    String[] ss5 = {"??????","??????","??????"
        ,"??????","??????" ,"??????"};
    map2.put("????????????", ss5);
  }
  public void setMap() {
    YHNode node1 = new YHNode("7",true,"?????????????????????.doc",120,"","");
    map.put("7", node1);
    YHNode node2 = new YHNode("3",false,"??????",290,"","");
    map.put("3", node2);
    YHNode node3 = new YHNode("4",false,"??????",370,"","");
    map.put("4", node3);
    YHNode node4 = new YHNode("5",false,"??????",200,"","");
    map.put("5", node4);
    YHNode node5 = new YHNode("10",false,"??????",400,"","");
    map.put("10", node5);
    YHNode node6 = new YHNode("11",false,"??????",220,"","");
    map.put("11", node6);
    YHNode node27 = new YHNode("27",true,"???????????????????????????.doc",350,"","");
    map.put("27", node27);
    YHNode node28 = new YHNode("28",false,"??????",350,"","");
    map.put("28", node28);
    YHNode node29 = new YHNode("29",false,"??????",400,"","");
    map.put("29", node29);
    YHNode node39 = new YHNode("39",false,"?????????",380,"","");
    map.put("39", node39);
    YHNode node40 = new YHNode("40",false,"?????????",280,"","");
    map.put("40", node40);
    YHNode node9 = new YHNode("2",true,"???????????????????????????.doc",330,"","");
    map.put("2", node9);
    YHNode node30 = new YHNode("30",false,"??????",330,"","");
    map.put("30", node30);
    YHNode node31 = new YHNode("31",false,"??????",320,"","");
    map.put("31", node31);
    YHNode node33 = new YHNode("33",false,"??????",330,"","");
    map.put("33", node33);
    YHNode node32 = new YHNode("32",true,"????????????????????????.doc",300,"","");
    map.put("32", node32);
    YHNode node36 = new YHNode("36",false,"??????",440,"","");
    map.put("36", node36);
    YHNode node44 = new YHNode("44",true,"???????????????????????????.doc",230,"","");
    map.put("44", node44);
//    YHNode node45 = new YHNode("45",true,"????????????????????????.doc",200,"","");
//    map.put("45", node45);
  }
}
