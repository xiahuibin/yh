package yh.core.funcs.doc.act;

import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import yh.core.data.YHRequestDbConn;
import yh.core.funcs.doc.data.YHDocFlowFormReglex;
import yh.core.funcs.doc.data.YHDocFlowFormType;
import yh.core.funcs.doc.logic.YHFlowFormLogic;
import yh.core.funcs.doc.praser.YHFormPraser;
import yh.core.funcs.doc.util.YHWorkFlowUtility;
import yh.core.funcs.person.data.YHPerson;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.core.util.db.YHORM;
import yh.core.util.file.YHFileUploadForm;
import yh.core.util.form.YHFOM;

public class YHFlowFormAct {
  private static Logger log = Logger
    .getLogger("yh.core.funcs.doc.act.YHFlowFormAct");
  public String insertFlowForm(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String formName = request.getParameter("formName");
      String deptId = request.getParameter("deptId");
      
      YHDocFlowFormType form = new YHDocFlowFormType();
      form.setDeptId(Integer.parseInt(deptId));
      form.setFormName(formName);
      YHORM orm = new YHORM();
      orm.saveSingle(dbConn, form);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "成功添加数据");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String doUploadImage(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    try{
      String module = request.getParameter("module");
      YHFileUploadForm fileForm = new YHFileUploadForm();
      fileForm.parseUploadRequest(request);
      YHWorkFlowUtility util = new YHWorkFlowUtility();
      String fileName = fileForm.getFileName();
      String[] tmp =  util.getNewAttachPath(fileName, module);
      String filePath = tmp[1];
      fileForm.saveFile(filePath);
      String contextPath = request.getContextPath();
      String requestPath = contextPath + "/yh/core/funcs/office/ntko/act/YHNtkoAct/upload.act?attachmentName="+YHUtility.encodeURL(fileName)+"&attachmentId="+tmp[0]+"&module="+module+"&directView=1";
      response.setCharacterEncoding("UTF-8");
      response.setContentType("text/html");
      response.setHeader("Cache-Control", "no-cache");  
      PrintWriter out = response.getWriter();
      out.print("<body onload=\"window.parent.OnUploadCompleted(0, '" + requestPath + "', '" + fileName + "', 'success' )\"/>");
      out.flush();
      out.close();
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return null;
  }
  public String getFlowForm(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      int seqId = Integer.parseInt(request.getParameter("seqId"));
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String data = null;
      YHORM orm = new YHORM();
      YHDocFlowFormType obj = (YHDocFlowFormType) orm.loadObjSingle(dbConn, YHDocFlowFormType.class, seqId);
      YHFlowFormLogic logic = new YHFlowFormLogic();
      data = "{seqId:"+ obj.getSeqId() +",formName:'"+obj.getFormName()+"',deptId:"+ obj.getDeptId() +"}";
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "成功取出数据");
      request.setAttribute(YHActionKeys.RET_DATA, "{formData:" +data + ",noDelete:" + logic.isExistFlowRun(seqId, dbConn)+"}");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String getFormView(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      int seqId = Integer.parseInt(request.getParameter("seqId"));
    //  String printModel = request.getParameter("printModel");
    //  String[] str = null;
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String data = null;
      YHFlowFormLogic ffl = new YHFlowFormLogic();
      Map map = ffl.selectFlowForm(dbConn, seqId, "PRINT_MODEL");
      data = toJs(map).toString();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "成功取出数据");
      request.setAttribute(YHActionKeys.RET_DATA, data);
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public StringBuffer toJs(Map map) throws Exception {
    StringBuffer rtBuf = new StringBuffer("{");
    Iterator it = map.entrySet().iterator();
    while (it.hasNext()){
      Map.Entry entry = (Map.Entry) it.next();
      Object key = entry.getKey();
      Object value = entry.getValue();
      rtBuf.append("'");
      rtBuf.append(key);
      rtBuf.append("'");
      rtBuf.append(":");
      rtBuf.append("\"");
      rtBuf.append(value);
      rtBuf.append("\"");
      //System.out.println(key+":"+value+"ffffffff");
    }
    rtBuf.append("}");
    //System.out.println(rtBuf+"eeeeeeeee");
    return rtBuf;
  }
  
  public String updateForm(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      String seqStr = request.getParameter("seqId");
      String printModel = request.getParameter("printModel");
      String printModelNew = "";
      //System.out.println(seqStr);
      int seqId = Integer.parseInt(seqStr.trim());
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHFlowFormLogic ffl = new YHFlowFormLogic();
      printModel = printModel.replaceAll("\"", "\\\\\"");
      printModel = printModel.replaceAll("\r\n", "");
      HashMap hm = (HashMap) YHFormPraser.praserHTML2Dom(printModel);
      Map<String, Map> m1 = YHFormPraser.praserHTML2Arr(hm);
      printModelNew = YHFormPraser.toShortString(m1, printModel, YHDocFlowFormReglex.CONTENT);
      ffl.updateFlowForm(dbConn, seqId, new String[]{"PRINT_MODEL","PRINT_MODEL_SHORT"},  new String[]{printModel,printModelNew});
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "保存成功！");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String updateFlowForm(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      String seqStr = request.getParameter("seqId");
      int seqId = Integer.parseInt(seqStr.trim());
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHDocFlowFormType form = (YHDocFlowFormType) YHFOM.build(request.getParameterMap());
      form.setSeqId(seqId);
      YHORM orm = new YHORM();
      orm.updateSingle(dbConn, form);
      
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "成功更改数据库的数据");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }

  public String deleteForm(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      String seqId = request.getParameter("seqId");
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHFlowFormLogic logic = new YHFlowFormLogic();
      logic.deleteForm(Integer.parseInt(seqId), dbConn);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "成功删除数据库的数据");
    }catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
  public String updateDesign(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try{
      int seqId = Integer.parseInt(request.getParameter("seqId"));
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHDocFlowFormType form = (YHDocFlowFormType) YHFOM.build(request.getParameterMap());
      form.setSeqId(seqId);
      YHORM orm = new YHORM();
      orm.updateSingle(dbConn, form);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "成功更改数据库的数据");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  /**
   * 表单分类管理
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String listBySort(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    String data = "";
    int sortId = 0 ;
    try{
      sortId = Integer.parseInt(request.getParameter("sortId"));
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHFlowFormLogic ffl = new YHFlowFormLogic();
      YHPerson u = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
      StringBuffer sb = ffl.flowFormType2Json(dbConn, sortId , u );
      data = "{flowList:" + sb.toString() + "}";
      request.setAttribute(YHActionKeys.RET_DATA, data );
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "取出数据！");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    //System.out.println(data);
    return "/core/inc/rtjson.jsp";
  }
  public String search(HttpServletRequest request,
      HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    String data = "";
    try{
      String search = request.getParameter("searchKey");
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHFlowFormLogic ffl = new YHFlowFormLogic();
      YHPerson u = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
      StringBuffer sb = ffl.search(dbConn, search , u);
      data = "{flowList:" + sb.toString() + "}";
      request.setAttribute(YHActionKeys.RET_DATA, data );
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "取出数据！");
    }catch(Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    //System.out.println(data);
    return "/core/inc/rtjson.jsp";
  }
}
