package yh.core.funcs.menu.act;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import yh.core.data.YHRequestDbConn;
import yh.core.funcs.menu.data.YHSysFunction;
import yh.core.funcs.menu.data.YHSysMenu;
import yh.core.funcs.menu.logic.YHSysMenuLogic;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.person.data.YHUserPriv;
import yh.core.funcs.system.security.data.YHSecurity;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.core.util.db.YHDBUtility;
import yh.core.util.db.YHORM;
import yh.core.util.form.YHFOM;

public class YHSysMenuAct {
  private static Logger log = Logger.getLogger(YHSysMenuAct.class);
  
  YHSysMenuLogic menuLogic = new YHSysMenuLogic();
  ArrayList<YHSysFunction> functionList = null;
  public String listSysMenu(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      ArrayList<YHSysMenu> menuList = null;
      YHORM orm = new YHORM();
      List<Map> list = new ArrayList();
      Map fi = null;
      //menuList = (ArrayList<YHSysMenu>)orm.loadListSingle(dbConn, YHSysMenu.class, fi);
      menuList = menuLogic.menuList(dbConn);
      request.setAttribute("menuList", menuList);
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/funcs/menu/sysmenulist.jsp";
  }
  
  public String listSysFunction(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String menuId = request.getParameter("menuId");
    if(menuId.length() > 2) {
      menuId = menuId.substring(0, 2);
    }
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHORM orm = new YHORM();
      functionList = menuLogic.listFunction(dbConn, menuId);
      request.setAttribute("functionList", functionList);
      String sql = "select IMAGE, MENU_NAME from SYS_MENU where MENU_ID = '" + menuId + "'";
      stmt = dbConn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()) {
        String image = rs.getString("IMAGE");
        String menuName = rs.getString("MENU_NAME");
        request.setAttribute("image", image);
        request.setAttribute("menuName", menuName);
      }
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/funcs/menu/sysfunctionlist.jsp?menuId=" + menuId;
  }
  
  public String getSysMenu(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    String seqId = request.getParameter("seqId");
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHSysMenu menu = null;
      String data = null;
      YHORM orm = new YHORM();
      menu = (YHSysMenu)orm.loadObjSingle(dbConn, YHSysMenu.class, Integer.parseInt(seqId));
      if(menu == null) {
        menu = new YHSysMenu();
      }
      data = YHFOM.toJson(menu).toString();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"??????????????????");
      request.setAttribute(YHActionKeys.RET_DATA, data);
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String getSysFunction(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    response.setCharacterEncoding("UTF-8");
    Connection dbConn = null;
    String data = null;
    String seqId = request.getParameter("seqId");
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String query = "select * from oa_sys_func where SEQ_ID = " + seqId;
      Statement stm1 = null;
      ResultSet rs1 = null;
      StringBuffer  d = new StringBuffer();
      d.append("{");
      try {
        stm1 = dbConn.createStatement();
        rs1 = stm1.executeQuery(query);
        if (rs1.next()) {
          d.append("seqId:" + rs1.getInt("SEQ_ID"));
          d.append(",menuId:'" + rs1.getString("MENU_ID") + "'");
          d.append(",funcName:'" + YHUtility.encodeSpecial(rs1.getString("FUNC_NAME")) + "'");
          d.append(",funcCode:'" + YHUtility.encodeSpecial(rs1.getString("FUNC_CODE")) + "'");
          d.append(",icon:'" + YHUtility.encodeSpecial(rs1.getString("ICON")) + "'");
        }
      } catch (Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm1, rs1, null);
      }
      d.append("}");
      data = d.toString();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"??????????????????");
      request.setAttribute(YHActionKeys.RET_DATA, data);
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String addSysMenu(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    String menuId = null;
    String menuName = null;
    String image = null;
    int num = 0;
    int no = 0;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);     
      dbConn = requestDbConn.getSysDbConn();
      YHSysMenu menu = (YHSysMenu)YHFOM.build(request.getParameterMap());
      menuId = menu.getMenuId();
      if(YHUtility.isNullorEmpty(menuId)) {
        return "/core/inc/rtjson.jsp";
      }
      menuName = menu.getMenuName();
      if(YHUtility.isNullorEmpty(menuName)) {
        return "/core/inc/rtjson.jsp";
      }
      image = menu.getImage();
      if(YHUtility.isNullorEmpty(image)) {
        return "/core/inc/rtjson.jsp";
      }
      no = menuLogic.selectMenuName(dbConn, menuName);
      if(no >= 1) {
        request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
        request.setAttribute(YHActionKeys.RET_MSRG, "?????????????????????, ???????????????");
        return "/core/inc/rtjson.jsp";
      }
      num = menuLogic.selectMenu(dbConn, menuId);
      if(num >= 1) {
        request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
        request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????????????????, ???????????????");
        return "/core/inc/rtjson.jsp";
      }
      
      YHORM orm = new YHORM();
      orm.saveSingle(dbConn, menu);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"???????????????????????????");
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String addSysFunction(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    String menuId = null;
    int num = 0;
    String menuSort = null;
    String funcName = "";
    String funcCode = "";
    String icon = "";
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);     
      dbConn = requestDbConn.getSysDbConn();
      YHSysFunction function = (YHSysFunction)YHFOM.build(request.getParameterMap());
      menuId = function.getMenuId();
      menuSort = function.getMenuSort();
      if(YHUtility.isNullorEmpty(menuSort)) {
        return "/core/inc/rtjson.jsp";
      }
      if(menuSort.length() != 2) {
        return "/core/inc/rtjson.jsp";
      }
      funcName = function.getFuncName();
      if(YHUtility.isNullorEmpty(funcName)) {
        return "/core/inc/rtjson.jsp";
      }
      funcCode = function.getFuncCode();
      if(YHUtility.isNullorEmpty(funcCode)){
        funcCode = "org";
      }else{
        funcCode = function.getFuncCode();
      }
      icon = function.getIcon();
      if(YHUtility.isNullorEmpty(icon)){
        icon = "edit.gif";
      }else{
        icon = function.getIcon();
      }
      num = menuLogic.selectFunction(dbConn, menuId, menuSort);
      if(num >= 1) {
        String flagSrc = menuId + menuSort;
        request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
        request.setAttribute(YHActionKeys.RET_MSRG, "???????????????" + menuSort + "?????????,??????????????????");
        return "/core/inc/rtjson.jsp";
      }
      Map map = new HashMap();
      map.put("menuId", "" + function.getMenuId() + function.getMenuSort() + "");
      map.put("funcName", function.getFuncName());
      map.put("funcCode", funcCode);
      map.put("icon", icon);
      YHORM orm = new YHORM();
      orm.saveSingle(dbConn, "sysFunction", map);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"????????????????????????");
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ??????????????????????????????  cc 20100317
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
   
  public String updateSysMenu(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    ArrayList<YHUserPriv> userPrivList = null;
    String menuIdOld = null;
    String menuId = null;
    String menuName = null;
    String image = null;
    String menuIdStr = "";
    int num = 0;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);   
      dbConn = requestDbConn.getSysDbConn();
      YHPerson person = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
      int loginUserSeqId = person.getSeqId();
      String loginUserRole = person.getUserPriv();
      
      YHSysMenu menu = (YHSysMenu)YHFOM.build(request.getParameterMap());
      menuIdOld = request.getParameter("menuIdOld");
      menuId = menu.getMenuId();
      if(menuId == null || "".equals(menuId)) {
        return "/core/inc/rtjson.jsp";
      }
      menuName = menu.getMenuName();
      if(menuName == null || "".equals(menuName)) {
        return "/core/inc/rtjson.jsp";
      }
      image = menu.getImage();
      if(image == null || "".equals(image)) {
        return "/core/inc/rtjson.jsp";
      }
      
      if(menuIdOld.equals(menuId)) {
        menuLogic.updateMenu(dbConn, menuId, menuName, image, menuIdOld);
        request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
        request.setAttribute(YHActionKeys.RET_MSRG, "???????????????????????????");  
        return "/core/inc/rtjson.jsp";
      }else {
        String funcMenuId = null;
        num = menuLogic.selectMenu(dbConn, menuId);
        if(num >= 1) {
          request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
          request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????????????????, ???????????????");
          return "/core/inc/rtjson.jsp";
        }
        YHORM orm = new YHORM();
        functionList = menuLogic.getSysFunctionMenuId(dbConn, menuIdOld);
        for(int i = 0; i < functionList.size(); i++){
          YHSysFunction sytFuns = functionList.get(i);
          int seqId = 0;
          if(sytFuns.getMenuId().length() <= 6){
            seqId = sytFuns.getSeqId();
            menuIdStr = sytFuns.getMenuId();
            String subFunc = menuIdStr.substring(2, menuIdStr.length());
            String menuIdsss = menuId + subFunc;
            Map m =new HashMap();
            m.put("seqId", seqId);
            m.put("menuId", menuIdsss);
            orm.updateSingle(dbConn, "sysFunction", m);
          }
        }
        menuLogic.updateMenu(dbConn, menuId, menuName, image, menuIdOld);
        upUserPriv(menuIdOld, menuId, dbConn);
//        String menuIdNew = "";
//        String funcIdStr = "";
//        for(int z = 0; z < userPrivList.size(); z++){
//          String strs = "";
//          YHUserPriv userPrivStr = userPrivList.get(z);
//          String privStrs = userPrivStr.getFuncIdStr();
//          int seqId = userPrivStr.getSeqId();
//          String privStr[] = privStrs.split(",");
//          for(int x = 0; x < privStr.length; x++){
//            funcIdStr = privStr[x];
//            if(funcIdStr.startsWith(menuIdOld)){
//              if(funcIdStr.length() == 2){
//                funcIdStr = menuId;
//              }else{
//                funcIdStr.substring(2, funcIdStr.length());
//                funcIdStr = menuId + funcIdStr.substring(2, funcIdStr.length());
//              }
//            }
//            strs += funcIdStr+",";
//          }
//          Map m =new HashMap();
//          m.put("seqId", seqId);
//          m.put("funcIdStr", strs);
//          orm.updateSingle(dbConn, "userPriv", m);
//        }
        
//        menuLogic.insertMenu(dbConn, menuId, menuName, image);
//        functionList = menuLogic.listFunction(dbConn, menuIdOld);
//        for(int i = 0; i < functionList.size(); i++) {
//          YHSysFunction function  = functionList.get(i);
//          funcMenuId = function.getMenuId();
//          menuLogic.updateFunction(dbConn, menuId, menuIdOld, funcMenuId);
//        }
//        menuLogic.deleteMenu(dbConn, menuIdOld);
        request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
        request.setAttribute(YHActionKeys.RET_MSRG,"???????????????????????????");
      }
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";    
  }
  
  /**
   * ?????????????????????????????????USER_PRIV?????????menuId ?????????8111,21,2110,211010,2112,3110,310101
   *   ???????????????21??????71??????8111,71???2110???211010???2112???3110???311010
   * @param menuIdOld  ???menuId
   * @param menuId     ?????????menuId
   * @param dbConn
   */
  
  public void upUserPriv(String menuIdOld, String menuId, Connection dbConn) {
    String menuIdNew = "";
    String funcIdStr = "";
    YHORM orm = new YHORM();
    ArrayList<YHUserPriv> userPrivList = null;
    try {
      userPrivList = menuLogic.getUserPrivList(dbConn);
      for (int z = 0; z < userPrivList.size(); z++) {
        String strs = "";
        YHUserPriv userPrivStr = userPrivList.get(z);
        String privStrs = userPrivStr.getFuncIdStr();
        int seqId = userPrivStr.getSeqId();
        String privStr[] = privStrs.split(",");
        for (int x = 0; x < privStr.length; x++) {
          funcIdStr = privStr[x];
          if (funcIdStr.startsWith(menuIdOld)) {
            if (funcIdStr.length() == 2) {
              funcIdStr = menuId;
            } else {
              funcIdStr.substring(2, funcIdStr.length());
              funcIdStr = menuId + funcIdStr.substring(2, funcIdStr.length());
            }
          }
          strs += funcIdStr + ",";
        }
        Map m = new HashMap();
        m.put("seqId", seqId);
        m.put("funcIdStr", strs);
        orm.updateSingle(dbConn, "userPriv", m);
      }
    } catch (Exception e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }
  }
  
  /**
   * ???????????????????????????????????????4????????????????????????????????????4???????????????????????? 
   * ?????????USER_PRIV??? FUNC_ID_STR?????????4????????????????????????7110???7112???711010???711210??? ???
   *       ??????4??????????????????6???????????????6????????????2?????????????????????
   *       ???10?????????15????????????7115???7112???711510???711210
   * @param menuIdStr  ?????????menuId SYS_FUNCTION???
   * @param dbConn
   * @param menuId     SYS_MENU?????????menuId
   * @param menuSort   ??????menuId??????????????????????????????
   */
  
  public void upUserPriv4(String menuIdStr, Connection dbConn, String menuId,
      String menuSort, String menuId4) {
    String menuIdNew = "";
    String funcIdStr = "";
    YHORM orm = new YHORM();
    ArrayList<YHUserPriv> userPrivList = null;
    try {
      userPrivList = menuLogic.getUserPrivList(dbConn);
      for (int z = 0; z < userPrivList.size(); z++) {
        String strs = "";
        YHUserPriv userPrivStr = userPrivList.get(z);
        String privStrs = userPrivStr.getFuncIdStr();
        int seqId = userPrivStr.getSeqId();
        String privStr[] = privStrs.split(",");
        for (int x = 0; x < privStr.length; x++) {
          funcIdStr = privStr[x];
          if (funcIdStr.startsWith(menuIdStr)) {
            if (funcIdStr.length() == 4) {
              funcIdStr = menuId4 + menuSort; //menuIdStr.substring(2, menuIdStr.length());
            } else if (funcIdStr.length() == 6) {
              funcIdStr = menuId4 + funcIdStr.substring(2, funcIdStr.length());
            }
          }
          strs += funcIdStr + ",";
        }
        Map m = new HashMap();
        m.put("seqId", seqId);
        m.put("funcIdStr", strs);
        orm.updateSingle(dbConn, "userPriv", m);
      }
    } catch (Exception e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }
  }
  
  public void updateChangeUserPriv4(String menuIdStr, Connection dbConn, String menuId,
      String menuSort, String menuId4) {
    String menuIdNew = "";
    String funcIdStr = "";
    YHORM orm = new YHORM();
    ArrayList<YHUserPriv> userPrivList = null;
    try {
      userPrivList = menuLogic.getUserPrivList(dbConn);
      for (int z = 0; z < userPrivList.size(); z++) {
        String strs = "";
        YHUserPriv userPrivStr = userPrivList.get(z);
        String privStrs = userPrivStr.getFuncIdStr();
        int seqId = userPrivStr.getSeqId();
        String privStr[] = privStrs.split(",");
        for (int x = 0; x < privStr.length; x++) {
          funcIdStr = privStr[x];
          if (funcIdStr.startsWith(menuIdStr)) {
            if (funcIdStr.length() == 4) {
              funcIdStr = menuId4 + menuSort; //menuIdStr.substring(2, menuIdStr.length());
            } else if (funcIdStr.length() == 6) {
              funcIdStr = menuId4 + menuSort + funcIdStr.substring(4, funcIdStr.length());
            }
          }
          strs += funcIdStr + ",";
        }
        Map m = new HashMap();
        m.put("seqId", seqId);
        m.put("funcIdStr", strs);
        orm.updateSingle(dbConn, "userPriv", m);
      }
    } catch (Exception e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }
  }
  
  /**
   * ?????????menuId???6?????? ???????????????????????????menuId
   * @param menuIdStr
   * @param dbConn
   * @param menuId
   * @param menuSort
   * @param menuId4
   */
  
  public void upUserPriv46(String menuIdStr, Connection dbConn, String menuId,
      String menuSort, String menuId4) {
    String menuIdNew = "";
    String funcIdStr = "";
    YHORM orm = new YHORM();
    ArrayList<YHUserPriv> userPrivList = null;
    try {
      userPrivList = menuLogic.getUserPrivList(dbConn);
      for (int z = 0; z < userPrivList.size(); z++) {
        String strs = "";
        YHUserPriv userPrivStr = userPrivList.get(z);
        String privStrs = userPrivStr.getFuncIdStr();
        int seqId = userPrivStr.getSeqId();
        String privStr[] = privStrs.split(",");
        for (int x = 0; x < privStr.length; x++) {
          funcIdStr = privStr[x];
          if (funcIdStr.startsWith(menuIdStr)) {
            if (funcIdStr.length() == 6) {
              funcIdStr = menuId4 + funcIdStr.substring(4, funcIdStr.length());
            }
          }
          strs += funcIdStr + ",";
        }
        Map m = new HashMap();
        m.put("seqId", seqId);
        m.put("funcIdStr", strs);
        orm.updateSingle(dbConn, "userPriv", m);
      }
    } catch (Exception e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }
  }
  
  /**
   * ???????????????????????????????????????6????????????????????????????????????6???????????????????????? 
   * ??????;711010???711210, ???711010 ???10?????????11????????????711011???711210???
   * @param menuIdStr   ?????????menuId SYS_FUNCTION???
   * @param dbConn
   * @param menuId      SYS_MENU?????????menuId
   * @param menuSort    ??????menuId??????????????????????????????
   */
  
  public void upUserPriv6(String menuIdStr, Connection dbConn, String menuId,
      String menuSort, String menuId4) {
    //System.out.println(menuSort+"UIYTY");
    String menuIdNew = "";
    String funcIdStr = "";
    YHORM orm = new YHORM();
    ArrayList<YHUserPriv> userPrivList = null;
    try {
      userPrivList = menuLogic.getUserPrivList(dbConn);
      for (int z = 0; z < userPrivList.size(); z++) {
        String strs = "";
        YHUserPriv userPrivStr = userPrivList.get(z);
        String privStrs = userPrivStr.getFuncIdStr();
        int seqId = userPrivStr.getSeqId();
        String privStr[] = privStrs.split(",");
        for (int x = 0; x < privStr.length; x++) {
          funcIdStr = privStr[x];
          if (funcIdStr.startsWith(menuIdStr)) {
            funcIdStr.substring(0, funcIdStr.length() - 2);
            if(menuId4.length() == 2){
              funcIdStr = menuId4 + menuIdStr.substring(2, menuIdStr.length());
            }else if(menuId4.length() == 4 && menuIdStr.length() != 4){
              //funcIdStr = menuId4 + menuIdStr.substring(4, menuIdStr.length());
              funcIdStr = menuId4 + menuSort;
            }else if(menuId4.length() == 4 && menuIdStr.length() == 4){
              funcIdStr = menuId4 + menuIdStr.substring(2, menuIdStr.length());
            }
          }
          strs += funcIdStr + ",";
        }
        Map m = new HashMap();
        m.put("seqId", seqId);
        m.put("funcIdStr", strs);
        orm.updateSingle(dbConn, "userPriv", m);
      }
    } catch (Exception e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }
  }
  
  /**
   * ????????????:??????  cc 20100317
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  
  public String updateSysFunction(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    Map map = null;
    String menuSortOld = request.getParameter("menuSortOld");
    String menuLast = request.getParameter("menuLast");          //?????????????????????
    String menuIdStr = request.getParameter("menuIdStr");       //??????????????? ??????menuId
    int seqId = Integer.parseInt(request.getParameter("seqId"));
    String menuIdFlagStr = request.getParameter("menuId"); //??????menuId???????????????        
    String menuIdFlag = menuIdFlagStr.substring(0,2);     //????????? ??????????????????3??????????????????2?????????  menuIdFlag????????????????????????menuId(?????????2???)
    String menuIdOld = request.getParameter("menuIdOld"); //??????????????????menuId
    String menuSortMid = request.getParameter("menuSort");
    String menuId4 = request.getParameter("menuId");    //????????????menuId
    String menuIdOverAll = request.getParameter("menuIdOverAll");   //??????????????????menuId
    ArrayList<YHUserPriv> userPrivList = null;
    String menuId = null;
    String menuSort = null;
    String menuAdd = null;
    String funcName = null;
    String funcCode = null;
    String sum = null;
    String last = null;
    String lastTwo = null;
    String menuIdSum = null;
    String iconStr = "";
    int num = 0;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHORM orm = new YHORM();
      YHSysFunction function = (YHSysFunction) YHFOM.build(request.getParameterMap());
      menuId = function.getMenuId();
      menuSort = function.getMenuSort(); // new
      if (menuSort == null || "".equals(menuSort)) {
        return "/core/inc/rtjson.jsp";
      }
      if (menuSort.length() != 2) {
        return "/core/inc/rtjson.jsp";
      }
      funcName = function.getFuncName();
      if (funcName == null || "".equals(funcName)) {
        return "/core/inc/rtjson.jsp";
      }
      menuAdd = function.getMenuAdd();
      if (menuAdd == null) {
        menuAdd = "";
      }
      if(YHUtility.isNullorEmpty(function.getIcon())){
        iconStr = "edit.gif";
      }else{
        iconStr = function.getIcon();
      }
      if(YHUtility.isNullorEmpty(function.getFuncCode())){
        funcCode = "org";
      }else{
        funcCode = function.getFuncCode();
      }
      String menuIdOverStr = menuIdOverAll.substring(0,4);
      if(menuIdOverAll.length() == 4){
        menuIdOverStr = menuIdOverAll.substring(0,2);
      }
      if(menuIdOverStr.equals(menuId4)){
        if (menuSortOld.equals(String.valueOf(menuSort)) && menuLast.equals(menuIdFlagStr)) {
          map = new HashMap();
          map.put("seqId", "" + function.getSeqId());
          //map.put("menuId", "" + menuIdOld + menuSortOld + "");//function.getMenuSort() +
          map.put("funcName", function.getFuncName());
          map.put("funcCode", funcCode);
          map.put("icon", iconStr);
          orm.updateSingle(dbConn, "sysFunction", map);
          request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
          request.setAttribute(YHActionKeys.RET_MSRG, "????????????????????????");
          return "/core/inc/rtjson.jsp";
        } else {
          num = menuLogic.selectFunctionNum(dbConn, menuId, menuAdd, menuSort);
           if (num >= 1) {
            request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
            request.setAttribute(YHActionKeys.RET_MSRG, "????????????????????????, ???????????????");
            return "/core/inc/rtjson.jsp";
          }
          menuId = menuIdFlag;                                            //?????????menuId????????????
          if (menuId4.length() == 2) {                                   //??????????????????menuId???2???
            functionList = menuLogic.getSysFunctionMenuId1(dbConn, menuIdStr);
            for (int i = 0; i < functionList.size(); i++) {
              YHSysFunction sytFuns = functionList.get(i);
              int seqIds = sytFuns.getSeqId();
              String menuIdStrs = sytFuns.getMenuId();                   //???menuId???
              if(menuIdStrs.length() == 4){
                last = menuSortMid; //menuIdStrs.substring(2, menuIdStrs.length());
                sum = menuId + last;
              }else if(menuIdStrs.length() == 6){
                last = menuIdStrs.substring(4, menuIdStrs.length());
                sum = menuId4 + menuSortMid + last;
              }
              Map m = new HashMap();
              m.put("seqId", seqIds);
              m.put("menuId", sum);
              orm.updateSingle(dbConn, "sysFunction", m);
            }
            if(menuIdStr.length() == 4){                                  //?????????????????????menuId???4???
              updateChangeUserPriv4(menuIdStr, dbConn, menuId, menuSort, menuId4);  //???????????????
            }else if(menuIdStr.length() == 6){                            //?????????????????????menuId???6??????4???6?????????????????????????????????????????????????????????????????????2???????????????4?????????
              upUserPriv46(menuIdStr, dbConn, menuId, menuSort, menuId4);
            }
          } else if (menuId4.length() == 4) {                             //??????????????????menuId???4???            if(menuIdStr.length() == 4){
              lastTwo = menuIdStr.substring(2, menuIdStr.length());
              menuIdSum = menuId4 + lastTwo;
            }else if(menuIdStr.length() == 6){
              //lastTwo = menuIdStr.substring(4, menuIdStr.length());
              lastTwo = menuSort;
              menuIdSum = menuId4 + lastTwo;
            }
            map = new HashMap();
            map.put("seqId", "" + function.getSeqId());
            map.put("menuId", menuIdSum);
            map.put("funcName", function.getFuncName());
            map.put("funcCode", funcCode);
            map.put("icon", iconStr);
            orm.updateSingle(dbConn, "sysFunction", map);
            upUserPriv6(menuIdStr, dbConn, menuId, menuSort, menuId4);
          }
        }

      } else {
        if (menuIdStr.length() != 6) {
          if (menuId.length() != 2) {
            if (menuLogic.checkLevel(dbConn, menuIdStr)) {
              request
                  .setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
              request.setAttribute(YHActionKeys.RET_MSRG,
                  "??????????????????????????????????????????2?????????????????????????????????");
              return "/core/inc/rtjson.jsp";
            }
          }
        }
        if (menuSortOld.equals(String.valueOf(menuSort)) && menuLast.equals(menuIdFlagStr)) {
          map = new HashMap();
          map.put("seqId", "" + function.getSeqId());
          //map.put("menuId", "" + menuIdOld + menuSortOld + "");//function.getMenuSort() +
          map.put("funcName", function.getFuncName());
          map.put("funcCode", funcCode);
          map.put("icon", iconStr);
          orm.updateSingle(dbConn, "sysFunction", map);
          request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
          request.setAttribute(YHActionKeys.RET_MSRG, "????????????????????????");
          return "/core/inc/rtjson.jsp";
        } else {
          num = menuLogic.selectFunctionNum(dbConn, menuId, menuAdd, menuSort);
           if (num >= 1) {
            request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
            request.setAttribute(YHActionKeys.RET_MSRG, "????????????????????????, ???????????????");
            return "/core/inc/rtjson.jsp";
          }
          menuId = menuIdFlag;                                            //?????????menuId????????????
          if (menuId4.length() == 2) {                                   //??????????????????menuId???2???            functionList = menuLogic.getSysFunctionMenuId1(dbConn, menuIdStr);
            for (int i = 0; i < functionList.size(); i++) {
              YHSysFunction sytFuns = functionList.get(i);
              int seqIds = sytFuns.getSeqId();
              String menuIdStrs = sytFuns.getMenuId();                   //???menuId???
              if(menuIdStr.length() == 4){
                last = menuIdStrs.substring(2, menuIdStrs.length());
                sum = menuId + last;
              }else if(menuIdStr.length() == 6){
                last = menuIdStrs.substring(4, menuIdStrs.length());
                sum = menuId4 + last;
              }
              Map m = new HashMap();
              m.put("seqId", seqIds);
              m.put("menuId", sum);
              orm.updateSingle(dbConn, "sysFunction", m);
            }
            if(menuIdStr.length() == 4){                                  //?????????????????????menuId???4???              upUserPriv4(menuIdStr, dbConn, menuId, menuSort, menuId4);  //???????????????            }else if(menuIdStr.length() == 6){                            //?????????????????????menuId???6??????4???6?????????????????????????????????????????????????????????????????????2???????????????4?????????              upUserPriv46(menuIdStr, dbConn, menuId, menuSort, menuId4);
            }
          } else if (menuId4.length() == 4) {                             //??????????????????menuId???4???            if(menuIdStr.length() == 4){
              lastTwo = menuIdStr.substring(2, menuIdStr.length());
              menuIdSum = menuId4 + lastTwo;
            }else if(menuIdStr.length() == 6){
              lastTwo = menuIdStr.substring(4, menuIdStr.length());
              menuIdSum = menuId4 + lastTwo;
            }
            map = new HashMap();
            map.put("seqId", "" + function.getSeqId());
            map.put("menuId", menuIdSum);
            map.put("funcName", function.getFuncName());
            map.put("funcCode", funcCode);
            map.put("icon", iconStr);
            orm.updateSingle(dbConn, "sysFunction", map);
            upUserPriv6(menuIdStr, dbConn, menuId, menuSort, menuId4);
          }
        }
      }
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "????????????????????????");
    } catch (Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String deleteSysMenu(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    request.setCharacterEncoding("utf-8");
    String seqId = request.getParameter("seqId");
    String menuId = request.getParameter("menuId");
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);   
      dbConn = requestDbConn.getSysDbConn();
      menuLogic.deleteSysMenu(dbConn, seqId, menuId);
      deleteUserPriv(menuId, dbConn);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"???????????????????????????");
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String deleteSysFunction(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    request.setCharacterEncoding("utf-8");
    String menuId = request.getParameter("menuId");
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);   
      dbConn = requestDbConn.getSysDbConn();
      menuLogic.deleteSysFunc(dbConn, menuId);
      deleteUserPriv(menuId, dbConn);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"????????????????????????");
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ???????????????????????????menuId???
   * @param menuId   ??????(SYS_MENU???SYS_FUNCTION)?????????menuId??????
   * @param dbConn
   */
  
  public void deleteUserPriv(String menuId, Connection dbConn) {
    String menuIdNew = "";
    String funcIdStr = "";
    YHORM orm = new YHORM();
    ArrayList<YHUserPriv> userPrivList = null;
    try {
      userPrivList = menuLogic.getUserPrivList(dbConn);
      for (int z = 0; z < userPrivList.size(); z++) {
        String strs = "";
        YHUserPriv userPrivStr = userPrivList.get(z);
        String privStrs = userPrivStr.getFuncIdStr();
        int seqId = userPrivStr.getSeqId();
        String privStr[] = privStrs.split(",");
        for (int x = 0; x < privStr.length; x++) {
          funcIdStr = privStr[x];
          if (funcIdStr.startsWith(menuId)) {
           continue;
          }
          strs += funcIdStr + ",";
        }
        Map m = new HashMap();
        m.put("seqId", seqId);
        m.put("funcIdStr", strs);
        orm.updateSingle(dbConn, "userPriv", m);
      }
    } catch (Exception e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }
  }
  
  public String getNoTree(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    HashMap map = null;
    String num = request.getParameter("num");
    String length = request.getParameter("length");
    if(num==null||num.equals("0")){
      num = "";
    }
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHORM orm = new YHORM();
      StringBuffer sb = new StringBuffer("[");
      if(Integer.parseInt(length) == 2) {
        ArrayList<YHSysMenu> menuList = null;
        
        //????????????????????? 1 = 1 order by ....
        menuList = (ArrayList<YHSysMenu>)orm.loadListSingle(dbConn, YHSysMenu.class, new String[]{" 1 = 1 order by MENU_ID"});
        for(int i = 0; i < menuList.size(); i++) {
          YHSysMenu menu = menuList.get(i);
          sb.append("{");
          sb.append("nodeId:\"" + menu.getMenuId() + "\"");
          sb.append(",name:\"" + menu.getMenuName() + "\"");
          sb.append(",isHaveChild:" + 1 + "");
          sb.append(",imgAddress:\"" + request.getContextPath() + "/core/styles/imgs/menuIcon/" + menu.getImage() + "\"");
          sb.append("},");
        }       
        sb.deleteCharAt(sb.length() - 1);       
      } else {
        List funcList = new ArrayList();
        funcList.add("sysFunction");
        String[] filters = new String[]{"MENU_ID like '" + num + "%'"," length(MENU_ID) = " + length + "  order by MENU_ID"};
        map = (HashMap)orm.loadDataSingle(dbConn, funcList, filters);
        List<Map> list = (List<Map>) map.get("OA_SYS_FUNC");
        String contextPath = request.getContextPath();
        for(Map m : list) {
          String funcAddress = null;
          String imageAddress = null;
          String fun = (String) m.get("funcCode");
          imageAddress = contextPath + "/core/funcs/display/img/org.gif";
          if (fun.startsWith("/")) {
            funcAddress = contextPath + fun;
          }else {
            funcAddress = contextPath + "/core/funcs/" + fun + "/";
          }
          sb.append("{");
          sb.append("nodeId:\"" + m.get("menuId") + "\"");
          sb.append(",name:\"" + m.get("funcName") + "\"");
          sb.append(",isHaveChild:" + 0);
          sb.append(",imgAddress:\"" + imageAddress + "\"");
          sb.append("},");
        } 
      }
      sb.append("]");
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "?????????????????????");
      request.setAttribute(YHActionKeys.RET_DATA, sb.toString());
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ?????????????????????????????????
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  
  public String getMenuPara(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHSysMenuLogic orgLogic = new YHSysMenuLogic();
      YHSecurity org = null;
      String data = null;
      org = orgLogic.getMenuPara(dbConn);
      if (org == null) {
        org = new YHSecurity();
      }
      data = YHFOM.toJson(org).toString();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"??????????????????");
      request.setAttribute(YHActionKeys.RET_DATA, data);
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ?????????????????????????????????????????????value??????SYS_PARA???
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  
  public String getMenuExpandSingle(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn)request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson person = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
      int seqId = person.getSeqId();
      List<Map> list = new ArrayList();
      YHORM orm = new YHORM();
      HashMap map = null;
      StringBuffer sb = new StringBuffer("[");
      String[] filters = new String[]{"PARA_NAME = 'MENU_EXPAND_SINGLE'"};
      List funcList = new ArrayList();
      funcList.add("sysPara");
      map = (HashMap)orm.loadDataSingle(dbConn, funcList, filters);
      list.addAll((List<Map>) map.get("SYS_PARA"));
      for(Map ms : list){
        sb.append("{");
        sb.append("seqId:\"" + ms.get("seqId") + "\"");
        sb.append(",paraValue:\"" + (ms.get("paraValue") == null ? "" : ms.get("paraValue")) + "\"");
        sb.append("},");
      }
      sb.deleteCharAt(sb.length() - 1); 
      if (list.size() == 0) {
        sb = new StringBuffer("[");
      }
      sb.append("]");
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG,"??????????????????");
      request.setAttribute(YHActionKeys.RET_DATA, sb.toString());
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ????????????????????????????????????Windows??????????????????????????????  MENU_DISPLAY??????SYS_PARA?????????
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  
  public String getMenuDisplay(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson person = (YHPerson) request.getSession().getAttribute(YHConst.LOGIN_USER);
      int seqId = person.getSeqId();
      List<Map> list = new ArrayList();
      YHORM orm = new YHORM();
      HashMap map = null;
      StringBuffer sb = new StringBuffer("[");
      String[] filters = new String[] { "PARA_NAME = 'MENU_DISPLAY'" };
      List funcList = new ArrayList();
      funcList.add("sysPara");
      map = (HashMap) orm.loadDataSingle(dbConn, funcList, filters);
      list.addAll((List<Map>) map.get("SYS_PARA"));
      for (Map ms : list) {
        sb.append("{");
        sb.append("seqId:\"" + ms.get("seqId") + "\"");
        sb.append(",paraValue:\"" + (ms.get("paraValue") == null ? "" : ms.get("paraValue")) + "\"");
        sb.append("},");
      }
      sb.deleteCharAt(sb.length() - 1);
      if (list.size() == 0) {
        sb = new StringBuffer("[");
      }
      sb.append("]");
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????");
      request.setAttribute(YHActionKeys.RET_DATA, sb.toString());
    } catch (Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ???????????????????????????????????????
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  
  public String updateTopMenuNum(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try {
      String topMenuNum = request.getParameter("topMenuNum");
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      menuLogic.updateTopMenuNum(dbConn, topMenuNum);
    } catch (Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????");
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ??????????????????????????????????????????
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  
  public String updateMenuNavigation(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String sum = "";
      String sumSingle = "";
      String menuShorcut = request.getParameter("menuShorcut");
      String menuWinexe = request.getParameter("menuWinexe");
      String menuUrl = request.getParameter("menuUrl");
      String menuExpandSingle = request.getParameter("menuExpandSingle");
      if (menuShorcut.equals("true")) {
        sum += "SHORTCUT,";
      }
      if (menuWinexe.equals("true")) {
        sum += "WINEXE,";
      }
      if (menuUrl.equals("true")) {
        sum += "URL,";
      }
      if (menuExpandSingle.equals("true")) {
        sumSingle = "1";
      } else {
        sumSingle = "0";
      }
      menuLogic.updateMenuNavigation(dbConn, sum);
      menuLogic.updateMenuSingle(dbConn, sumSingle);
    } catch (Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????");
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
}
