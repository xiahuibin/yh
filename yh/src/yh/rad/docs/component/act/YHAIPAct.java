package yh.rad.docs.component.act;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import yh.core.exps.YHInvalidParamException;
import yh.core.global.YHActionKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.core.util.file.YHFileUploadForm;
import yh.core.util.file.YHFileUtility;

public class YHAIPAct {
  private String uploadPath = "rad\\docs\\component\\aip\\tmp\\";
  /**
   * 上传AIP文件
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String uploadAip(HttpServletRequest request, HttpServletResponse response) throws Exception {
    try {
      String ctxPath = (String)request.getAttribute(YHActionKeys.ACT_CTX_PATH);
      String tName = request.getParameter("T_NAME");
      String content = request.getParameter("CONTENT");
      
      if (YHUtility.isNullorEmpty(tName)) {
        throw new YHInvalidParamException("没有传递模板名称");
      }
      if (YHUtility.isNullorEmpty(content)) {
        throw new YHInvalidParamException("没有传递模板内容");
      }
      String filePath = ctxPath + uploadPath + "\\" + tName + ".aip";
      YHFileUtility.storeString2File(filePath, content);
      
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "AIP 文件保存成功");
    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "AIP 文件保存失败");
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * 加载AIP文件
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String loadAip(HttpServletRequest request, HttpServletResponse response) throws Exception {
    try {
      String ctxPath = (String)request.getAttribute(YHActionKeys.ACT_CTX_PATH);
      String tName = request.getParameter("T_NAME");
      String filePath = ctxPath + uploadPath + "\\" + tName + ".aip";
      
      String content = YHFileUtility.loadLine2Buff(filePath).toString();      
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "AIP 文件保存成功");
      request.setAttribute(YHActionKeys.RET_DATA, "\"" + content + "\"");
    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "AIP 文件保存失败");
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String testCode(HttpServletRequest request, HttpServletResponse response) throws Exception {
    try {
//      request.setCharacterEncoding("UTF-8");
      String tName = request.getParameter("test1");
//      tName = new String(tName.getBytes("ISO8859-1"), "UTF-8");
      System.out.println(tName);
      
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "AIP 文件保存成功");
    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "AIP 文件保存失败");
    }
    return "/core/inc/rtjson.jsp";
  }
}
