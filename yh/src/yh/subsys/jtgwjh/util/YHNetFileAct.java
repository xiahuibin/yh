package yh.subsys.jtgwjh.util;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.DocumentException;

import sun.misc.BASE64Decoder;
import yh.core.data.YHDbRecord;
import yh.core.data.YHRequestDbConn;
import yh.core.esb.client.data.YHExtDept;
import yh.core.esb.client.logic.YHDeptTreeLogic;
import yh.core.funcs.calendar.logic.YHAffairLogic;
import yh.core.funcs.calendar.logic.YHCalExpImpLogic;
import yh.core.funcs.calendar.logic.YHCalendarLogic;
import yh.core.funcs.calendar.logic.YHTaskLogic;
import yh.core.funcs.diary.logic.YHDiaryUtil;
import yh.core.funcs.jexcel.util.YHCSVUtil;
import yh.core.funcs.jexcel.util.YHJExcelUtil;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.person.logic.YHPersonLogic;
import yh.core.funcs.system.logic.YHSystemLogic;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.global.YHSysProps;
import yh.core.util.YHGuid;
import yh.core.util.YHReflectUtility;
import yh.core.util.YHUtility;
import yh.core.util.auth.YHAuthenticator;
import yh.core.util.db.YHDBUtility;
import yh.core.util.db.YHORM;
import yh.core.util.file.YHFileUploadForm;
import yh.core.util.file.YHFileUtility;
import yh.core.util.file.YHZipFileTool;
import yh.core.util.net.http.YHHttpFileUtility;
import yh.subsys.jtgwjh.docReceive.data.YHJhDocrecvInfo;
import yh.subsys.jtgwjh.docReceive.logic.YHJhDocrecvInfoLogic;
import yh.subsys.jtgwjh.docReceive.logic.YHUnZipRarFile;
import yh.subsys.jtgwjh.task.logic.YHJhTaskLogLogic;

public class YHNetFileAct {

  
  public String downloadFile2(String host,int port,String url,String zipName, Map map) throws Exception {
    String attach =  YHSysProps.getAttachPath()    + File.separator  + "NETFILE" + File.separator;
    YHHttpFileUtility util = new YHHttpFileUtility();
    attach = attach + File.separator;
    File outFile = new File(attach);
    //File outPath = outFile.getParentFile();
    if (!outFile.exists()) {
      outFile.mkdirs();
    }
    String fileName = "" ;
    //??????????????????
    String rand = YHDiaryUtil.getRondom();
    fileName = rand + "_" + zipName;
    while (YHDiaryUtil.getExist(attach, fileName)) {
      rand = YHDiaryUtil.getRondom();
      fileName = rand + "_" + zipName;
    }
    
    //????????????
    util.downloadFile(host, 80,url, attach + fileName,new HashMap<String, String>());
    
    //????????????
    Map<String ,String> dataMap = YHUnZipRarFile.unNetZipFileXml(attach + fileName);
    return  null;
  }
  /**
   * ???????????????????????????
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String downloadFile(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String zipName = request.getParameter("fileName") == null ? "test.zip" : request.getParameter("fileName");
    String JHDocHost = YHSysProps.getString("JHDocHost") == null ? "localhost" :  YHSysProps.getString("JHDocHost") ;//
    String JHDocPort = YHSysProps.getString("JHDocPort") == null ? "80" :  YHSysProps.getString("JHDocPort");
    String JHDocSendUrl = request.getParameter("url") ==null ? "" :   request.getParameter("url")  ;
    String seqId = "0";
    String runId = "";
    try {
      YHHttpFileUtility util = new YHHttpFileUtility();
       String attach =  YHSysProps.getAttachPath()    + File.separator  + "NETFILE" + File.separator;
      
      File outFile = new File(attach);
      //File outPath = outFile.getParentFile();
      if (!outFile.exists()) {
        outFile.mkdirs();
      }
      String fileName = "" ;
      //??????????????????
      String rand = YHDiaryUtil.getRondom();
      fileName = rand + "_" + zipName;
      while (YHDiaryUtil.getExist(attach, fileName)) {
        rand = YHDiaryUtil.getRondom();
        fileName = rand + "_" + zipName;
      }
      
      //????????????
      util.downloadFile(JHDocHost, Integer.parseInt(JHDocPort),JHDocSendUrl, attach + fileName,new HashMap<String, String>());
 
      //????????????
     Map<String ,String> dataMap = YHUnZipRarFile.unNetZipFileXml(attach + fileName);  
    //  Map<String ,String> dataMap = YHUnZipRarFile.unNetZipFileXml("D:\\project\\yhcoreGW\\attach\\NETFILE\\8aa5469da31ec9d6cac9331b84b9638a_abc.zip");

      if(dataMap != null){
        seqId = dataMap.get("seqId");
        runId = dataMap.get("runId") == null ? "" : dataMap.get("runId");
      }
      
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
    }catch(Exception ex) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, ex.getMessage());
      throw ex;
    }
    return  "/subsys/jtgwjh/sendDoc/modify.jsp?seqId=" + seqId +"&runId=" + runId ;
  }
  
  /**
   * ???????????????????????????
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String uploadFile(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
     String seqId = request.getParameter("seqId");
     String JHDocHost = YHSysProps.getString("JHDocHost") == null ? "localhost" :  YHSysProps.getString("JHDocHost") ;//
     String JHDocPort = YHSysProps.getString("JHDocPort") == null ? "80" :  YHSysProps.getString("JHDocPort");
     String JHDocUploadUrl = YHSysProps.getString("JHDocUploadUrl") ==null ? "" :  YHSysProps.getString("JHDocUploadUrl")  ;
     String  returnStr = "";
     try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson user = (YHPerson) request.getSession().getAttribute(YHConst.LOGIN_USER);
      String attach =  YHSysProps.getAttachPath()    + File.separator  + "docReceive" + File.separator;
      String netAttach =  YHSysProps.getAttachPath()    + File.separator  + "NETFILE" + File.separator;
      YHHttpFileUtility util = new YHHttpFileUtility();
      if(YHUtility.isInteger(seqId)){
        //??????
        YHJhDocrecvInfo recv =  YHJhDocrecvInfoLogic.getById(dbConn, seqId);
        if(recv != null){
          //??????XML
          String xml = "<root>" + toXML(recv) + "</root>";
          xml = "<?xml version='1.0' encoding='UTF-8'?>"  + xml;
          //????????????
          String taskName = YHGuid.getRawGuid();
          String path = netAttach + taskName ;
          String FileName = "JHNET_DATA" + YHGuid.getRawGuid() + ".xml";
          while (YHDocUtil.getExist(path, FileName)) {
            FileName = "JHNET_DATA" + YHGuid.getRawGuid() + ".xml";
          }
          String fileName  =path + File.separator + FileName;
          YHFileUtility.storeString2File(fileName, xml);
          if(!YHUtility.isNullorEmpty(recv.getAttachmentId()) && !YHUtility.isNullorEmpty(recv.getAttachmentName())){
            String[] attachIdArr = recv.getAttachmentId().split(",");
            String[] attachNameArr = recv.getAttachmentName().split("\\*");
            for (int i = 0; i < attachNameArr.length; i++) {
              if(!YHUtility.isNullorEmpty(attachIdArr[i]) && attachIdArr[i].split("_").length ==2){
                String date =  attachIdArr[i].split("_")[0];
                String fileId = attachIdArr[i].split("_")[1];
                YHFileUtility.copyFile(attach + date+  File.separator + fileId  + "_"+attachNameArr[i] , path +  File.separator+ fileId  + "_" + attachNameArr[i]);
              }
            }
          }
          
          //??????
          //??????zip?????????
          YHZipFileTool.doZip(path, path + ".zip");
          System.out.println(path + ".zip");
          String status = util.uploadFile(JHDocHost, Integer.parseInt(JHDocPort), JHDocUploadUrl,  path + ".zip", new HashMap());
          System.out.println("????????????????????????"+ status);
          returnStr = status;
        }
      }
      request.setAttribute(YHActionKeys.RET_DATA, "{returnURL:\"" + YHUtility.encodeSpecial(returnStr)+ "\"}");
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "???????????????");
    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, e.getMessage());
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
  public String getUser(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    Connection dbConn = null;
     String userName = request.getParameter("userName");
        try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson person = null;
      String  realName = "";
      String  pwd = "";
      YHSystemLogic logic = new YHSystemLogic();
      if(!YHUtility.isNullorEmpty(userName)){
        //??????
        realName = getFromBASE64(userName);
        // realName = ciphDecryptStr(userName);
        person = logic.queryPerson(dbConn, realName);
      }
      if(person != null){
        if(!YHUtility.isNullorEmpty(person.getPassword())){
          //pwd =  ciphDecryptStr(person.getPassword());
        }
      }
      request.setAttribute(YHActionKeys.RET_DATA, "{userName:\"" + YHUtility.encodeSpecial(realName) + "\",pwd:\"" + YHUtility.encodeSpecial(pwd)  + "\"}");
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "???????????????");
    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, e.getMessage());
    }
    return "/core/inc/rtjson.jsp";
  }
  
  /**
   * ?????????XMl???????????????

   * @param obj
   * @return
   * @throws Exception
   */
  public static StringBuffer toXML( YHJhDocrecvInfo obj) throws Exception {
    if (obj == null) {
      return new StringBuffer("");
    }
    StringBuffer rtBuf = new StringBuffer("");
    Class cls = obj.getClass();
    Field[] fieldArray = cls.getDeclaredFields();
    int length = fieldArray.length;
    for (int i = 0; i < length; i++) {
      Field field = fieldArray[i];
      Class fieldType = field.getType(); 
      String fieldName = field.getName();
      rtBuf.append("<"+fieldName+">");
     // rtBuf.append("");
      Object value = null;
        if (int.class.equals(fieldType)
            || Integer.class.equals(fieldType)
            || double.class.equals(fieldType)
            || Double.class.equals(fieldType)) {
          value = YHReflectUtility.getValue(obj, fieldName);
        }else if (Date.class.equals(fieldType)) {
          if((Date)YHReflectUtility.getValue(obj, fieldName)!=null){
            value = YHUtility.getDateTimeStr((Date)YHReflectUtility.getValue(obj, fieldName)) ;
          }
        }else {
          Object valueObj = YHReflectUtility.getValue(obj, fieldName);
          if (valueObj == null) {
            value = "";
          }else {
            String tmpStr = YHUtility.null2Empty(valueObj.toString());

            value =  tmpStr ;
          }
        }
        if(value == null){
          value = "";
        }
        String tempValue = value.toString();
        if(fieldName.equals("urgentType")){//????????????
          tempValue = "??????";
          if(value.equals("1")){
            tempValue = "??????";
          }else if(value.equals("2")){
            tempValue = "??????";
          }
        }
        if(fieldName.equals("securityLevel")){//??????
          tempValue = "??????";
          if(value.equals("1")){
            tempValue = "??????";
          }else if(value.equals("2")){
            tempValue = "??????";
          }else if(value.equals("3")){
            tempValue = "??????";
          }
        }
      rtBuf.append(tempValue);
      rtBuf.append("</"+fieldName+">");
    }
    return rtBuf;
  }
  
  
  /**
   * ??????
   * @param str
   * @return
   * @throws Exception
   */
  public static String ciphEncryptStr(String str) throws Exception{
    String pw = YHAuthenticator.ciphEncryptStr(str);
    return pw;
  }
  /**
   * ??????
   * @param encryptPass
   * @return
   */
  public static String ciphDecryptStr(String encryptPass){
    String temp = "";
   try {
     temp = YHAuthenticator.ciphDecryptStr( encryptPass) ;
  } catch (Exception e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
    return temp;
  }
  public static void main(String[] args) throws Exception {
    //String s = ciphEncryptStr("");
    //System.out.println( s);//
   
  //  System.out.println( ciphDecryptStr("$1$3qKMwh5R$WgVqyn13H8h4Ht1v/ld.K1"));
    System.out.println(getFromBASE64("emhhbmdzYW4="));
    System.out.println(getBASE64("zhangsan"));
  }
  
  public static String getFromBASE64(String s) {
    if (s == null)
      return null;
    BASE64Decoder decoder = new BASE64Decoder();
    try {
      byte[] b = decoder.decodeBuffer(s);
      return new String(b, "GB2312");
    } catch (Exception e) {
      return null;
    }
  }

  public static String getBASE64(String s) {
    if (s == null)
      return null;
    try {
      return (new sun.misc.BASE64Encoder()).encode(s.getBytes("UTF-8"));
    } catch (UnsupportedEncodingException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return "";
  }

  
  /**
   * ????????????XML
   * 
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String importData(HttpServletRequest request, HttpServletResponse response)
      throws Exception {
    Connection dbConn = null;
    InputStream is = null;
    InputStream is2 = null;
    OutputStream ops = null;
    String error = "???????????????";
    String type = "1";
    String isExNotUser = "";//????????????????????????
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHPerson user = (YHPerson) request.getSession().getAttribute(
          YHConst.LOGIN_USER);
      int userSeqId = user.getSeqId();
      String userPriv = user.getUserPriv();
      YHFileUploadForm fileForm = new YHFileUploadForm();
      fileForm.parseUploadRequest(request);
      is = fileForm.getInputStream("xmlFile");
      //System.out.println(is2.toString()+","+is.toString());
      YHCalExpImpLogic el = new YHCalExpImpLogic();
      YHPersonLogic pl = new YHPersonLogic();
      ArrayList<YHDbRecord> drl = YHCSVUtil.CVSReader(is);
     // ArrayList<YHDbRecord> drl = YHJExcelUtil.readExc(is,true); 
      
      addOutDept(dbConn, drl );
    } catch (DocumentException e) {
      type = "2";
    } catch (Exception ex) {
      ex.printStackTrace();
      // System.out.println(ex.getMessage());
      // throw ex;
    }
    String path = request.getContextPath();
    response.sendRedirect(path + "/subsys/jtgwjh/setting/import.jsp?type=" + type + "&isExNotUser=" + isExNotUser);
    return "";
  }

public void addOutDept(Connection dbConn,ArrayList<YHDbRecord> list)throws Exception {
  String esbClient = "client";
  int startNum = 7;
  for (int i = 0; i < list.size(); i++) {
    
    YHDbRecord rd = list.get(i);
    startNum = startNum + 1;
    String unitOrder = rd.getValueByName("????????????") == null ? "" : (String)rd.getValueByName("????????????");
    String unitCode = rd.getValueByName("????????????") == null ? "" : (String)rd.getValueByName("????????????");
    String unitFullName = rd.getValueByName("????????????") == null ? "" : (String)rd.getValueByName("????????????");
    String deptName = rd.getValueByName("????????????") == null ? "" : (String)rd.getValueByName("????????????");
    String parentUnit = rd.getValueByName("????????????") == null ? "" : (String)rd.getValueByName("????????????");
    String userType = rd.getValueByName("????????????") == null ? "" : (String)rd.getValueByName("????????????");

    YHExtDept dept = new YHExtDept();
    dept.setDeptName(deptName);
    if(YHUtility.isNumber(unitOrder)){
      unitOrder = Integer.parseInt(unitOrder.substring(0, unitOrder.indexOf("."))) + "";
    }
    dept.setDeptNo(unitOrder);
    String deptTelLine = "0";
    String deptGroup = "0";
    if(userType.equals("??????")){
      deptTelLine = "1";
    }
    if(parentUnit.equals("???????????????")){
      deptGroup = "1";
    }else if(parentUnit.equals("????????????????????????")){
      deptGroup = "2";
    }else if(parentUnit.equals("????????????????????????")){
      deptGroup = "4";
    }else if(parentUnit.equals("?????????????????????")){
      deptGroup = "3";
    }else if(parentUnit.equals("??????????????????")){
      deptGroup = "5";
    }
    String seqIdStr = YHGuid.getRawGuid();
   // dept.setDeptId(seqIdStr);
    dept.setDeptDesc("");
    dept.setDeptStatue("1");
    dept.setDeptFullName(unitFullName);
    String deptIdInt = "0";
    if(YHUtility.isNumber(unitCode)){
      unitCode = Integer.parseInt(unitCode.substring(0, unitCode.indexOf("."))) + "";
      
      deptIdInt = unitCode;
      for (int j = unitCode.length(); j < 4; j++) {
        unitCode = "0" + unitCode;
      }
    }
    dept.setDeptCode(unitCode);
    dept.setDeptId(deptIdInt);
    dept.setDeptPasscard("");
    dept.setDeptGroup(deptGroup);
    dept.setDeptTelLine(deptTelLine);
    dept.setEsbUser(esbClient + unitOrder);
    YHDeptTreeLogic.addDept(dbConn, dept);
   }
  }


  /**
   * 
   * ?????????????????????????????????
   * 
   * @param dbConn
   * @param item
   * @return
   * @throws Exception
   */
  public void deleteAllDept(Connection dbConn) throws Exception {
    Statement stmt = null;
    ResultSet rs = null;
  
    String sql = "delete from  oa_dept_ext " ;
    try {
      stmt = dbConn.createStatement();
      stmt.executeUpdate(sql);
    } catch (Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stmt, rs, null);
    }
  }

}
