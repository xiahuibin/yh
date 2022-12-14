package yh.subsys.inforesouce.docmgr.act;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import yh.core.data.YHRequestDbConn;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.system.selattach.util.YHSelAttachUtil;
import yh.core.funcs.doc.data.YHDocFlowFormItem;
import yh.core.funcs.doc.data.YHDocFlowRunData;
import yh.core.funcs.doc.data.YHDocFlowType;
import yh.core.funcs.doc.logic.YHFlowProcessLogic;
import yh.core.funcs.doc.logic.YHFlowRunLogic;
import yh.core.funcs.doc.logic.YHFlowTypeLogic;
import yh.core.funcs.doc.util.YHFlowRunUtility;
import yh.core.funcs.doc.util.YHWorkFlowUtility;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.core.util.db.YHDBUtility;
import yh.core.util.db.YHORM;
import yh.core.util.file.YHFileUtility;
import yh.subsys.inforesouce.docmgr.data.YHDocFlowRun;
import yh.subsys.inforesouce.docmgr.logic.YHDoc2Logic;
import yh.subsys.inforesouce.docmgr.logic.YHDocLogic;
import yh.subsys.oa.rollmanage.data.YHRmsFile;
import yh.subsys.oa.rollmanage.logic.YHRmsFileLogic;

public class YHDoc2Act {
  private static Logger log = Logger
    .getLogger("yh.subsys.inforesouce.docmgr.act.YHDocAct");
  public String saveDoc(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
      
      String runId = request.getParameter("runId");
      String prcsId = request.getParameter("prcsId");
      String flowPrcs = request.getParameter("flowPrcs");
      String docContent = request.getParameter("docContent");
      
      YHDoc2Logic logic = new YHDoc2Logic();
      logic.saveDoc(dbConn, loginUser.getSeqId(), runId, docContent, prcsId, flowPrcs);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "????????????");
    } catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String getDocHistory(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson loginUser = (YHPerson)request.getSession().getAttribute(YHConst.LOGIN_USER);
      
      String runId = request.getParameter("runId");
      
      YHDoc2Logic logic = new YHDoc2Logic();
      String str = logic.getDocHistory(dbConn, runId, loginUser.getSeqId());
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "????????????");
      request.setAttribute(YHActionKeys.RET_DATA, str);
    } catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String delDocHistory(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String seqId = request.getParameter("seqId");
      YHDoc2Logic logic = new YHDoc2Logic();
      logic.delDocHistory(dbConn, seqId);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "????????????");
    } catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String createDoc(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      String realPath = request.getRealPath("/");
      int runId = Integer.parseInt(request.getParameter("runId"));
      String docName = request.getParameter("docName");
      YHDoc2Logic logic = new YHDoc2Logic();
      String docStyle = "???-?????????.doc";
      if (docName.indexOf("??????") != -1) {
        docStyle = "???-?????????????????????????????????.doc";
      } else if (docName.indexOf("???") != -1) {
        docStyle = "???-?????????.doc";
      }else if (docName.indexOf("????????????") != -1) {
        docStyle = "???-??????????????????.doc";
      }else if (docName.indexOf("??????") != -1) {
        docStyle = "???-????????????.doc";
      }else if (docName.indexOf("??????") != -1) {
        docStyle = "???-????????????.doc";
      }else if (docName.indexOf("??????") != -1) {
        docStyle = "???-????????????.doc";
      }else if (docName.indexOf("??????") != -1) {
        docStyle = "???-????????????.doc";
      }
      String docId = logic.createAttachment(runId, docName, dbConn , realPath , docStyle);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "???????????? ");
      request.setAttribute(YHActionKeys.RET_DATA, docId);
    } catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String getContent(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      int runId = Integer.parseInt(request.getParameter("runId"));
      YHDocLogic logic = new YHDocLogic();
      YHDoc2Logic logic2 = new YHDoc2Logic();
      String style = logic.getStyle(runId ,dbConn );
      String content = logic2.getContent(dbConn , runId);
      String str = "{style:"+ style +",content:\""+content+"\"}";
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, " ");
      request.setAttribute(YHActionKeys.RET_DATA, str);
    } catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  public String getDoc(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
    try{
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      
      int runId = Integer.parseInt(request.getParameter("runId"));
      int flowId = Integer.parseInt(request.getParameter("flowId"));
      int flowPrcs = Integer.parseInt(request.getParameter("flowPrcs"));
      
      YHDoc2Logic logic = new YHDoc2Logic();
      String doc = logic.getDoc(runId, flowPrcs , flowId, dbConn);
      
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, " ");
      request.setAttribute(YHActionKeys.RET_DATA, doc);
    } catch (Exception ex){
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return "/core/inc/rtjson.jsp";
  }
  
}
