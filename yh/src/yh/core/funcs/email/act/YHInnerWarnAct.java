package yh.core.funcs.email.act;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadException;
import org.apache.log4j.Logger;

import yh.core.data.YHRequestDbConn;
import yh.core.funcs.email.data.YHEmailCont;
import yh.core.funcs.email.logic.YHInnerEMailUtilLogic;
import yh.core.funcs.email.logic.YHInnerWarnLogic;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.system.censorcheck.logic.YHCensorCheckLogic;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.core.util.file.YHFileUploadForm;

public class YHInnerWarnAct{
  /**
   * log                                               
   */
  private YHInnerEMailUtilLogic emul = new YHInnerEMailUtilLogic();
  private  Logger log = Logger.getLogger(YHInnerWarnAct.class);
  
 
  /**
   * 保存邮件（写邮件，或发送邮件）
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
//  public String sendMail(HttpServletRequest request,
//      HttpServletResponse response) throws Exception{
//    request.setCharacterEncoding("utf-8");
//    response.setCharacterEncoding("utf-8");
//    Connection conn = null;
//    String url = "";
//    String msg = "";
//    int data = 0;
//    try{
//      YHFileUploadForm fileForm = new YHFileUploadForm();
//      fileForm.parseUploadRequest(request);
//      YHPerson person = (YHPerson)request.getSession().getAttribute("LOGIN_USER");
//      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
//        .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
//      conn = requestDbConn.getSysDbConn();
//      YHInnerWarnLogic dbWarn = new YHInnerWarnLogic();
//      data = dbWarn.sendMailLogic(conn, fileForm,person.getSeqId(),YHEmailCont.UPLOAD_HOME,person.getUserName(),request.getContextPath());
//      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
//      request.setAttribute(YHActionKeys.RET_MSRG, "邮件发送成功！");
//    } catch (FileUploadException e) {
//      msg = "邮件发送失败，请重发!";
//      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
//      request.setAttribute(YHActionKeys.RET_MSRG, msg);
//      log.debug(msg, e);
//    } catch(Exception e){
//      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
//      request.setAttribute(YHActionKeys.RET_MSRG,  e.getMessage());
//      msg = e.getMessage();
//      log.debug(msg, e);
//    }
//      request.setAttribute(YHActionKeys.RET_METHOD, YHActionKeys.RET_METHOD_REDIRECT);
//      url = "/core/funcs/email/new/sendOk.jsp?sendFlag=1&msg=" + YHUtility.encodeURL(msg);
//    return url;
//  }
//  
  
  
}