package yh.core.funcs.workflow.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import yh.core.funcs.dept.logic.YHDeptLogic;
import yh.core.funcs.email.logic.YHEmailUtil;
import yh.core.funcs.mobilesms.logic.YHMobileSms2Logic;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.person.data.YHUserPriv;
import yh.core.funcs.person.logic.YHPersonLogic;
import yh.core.funcs.person.logic.YHUserPrivLogic;
import yh.core.funcs.sms.data.YHSmsBack;
import yh.core.funcs.sms.logic.YHSmsUtil;
import yh.core.funcs.workflow.data.YHFlowFormItem;
import yh.core.funcs.workflow.data.YHFlowFormType;
import yh.core.funcs.workflow.data.YHFlowProcess;
import yh.core.funcs.workflow.data.YHFlowRun;
import yh.core.funcs.workflow.data.YHFlowRunData;
import yh.core.funcs.workflow.data.YHFlowRunPrcs;
import yh.core.funcs.workflow.data.YHFlowSort;
import yh.core.funcs.workflow.data.YHFlowType;
import yh.core.funcs.workflow.praser.YHPraseData2Form;
import yh.core.funcs.workflow.praser.YHPraseData2PrintForm;
import yh.core.funcs.workflow.util.YHFlowFormUtility;
import yh.core.funcs.workflow.util.YHFlowHookUtility;
import yh.core.funcs.workflow.util.YHFlowRunUtility;
import yh.core.funcs.workflow.util.YHPrcsRoleUtility;
import yh.core.funcs.workflow.util.YHTurnConditionUtility;
import yh.core.funcs.workflow.util.YHWorkFlowUtility;
import yh.core.funcs.workflow.util.sort.YHFlowProcessComparator;
import yh.core.util.YHUtility;
import yh.core.util.db.YHDBUtility;
import yh.core.util.db.YHORM;
import yh.user.api.core.db.YHDbconnWrap;
import yh.user.taiji.system.YHSystemLogLogic;

public class YHFlowRunLogic {
  /**
   * 
   * @param flowType 一个流程   * @param loginUser 用户
   * @return
   * @throws Exception 文号
   */
  public String getRunName(YHFlowType flowType , YHPerson loginUser , Connection conn , boolean isUpdateAutoNum) throws Exception{
    conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
    YHDeptLogic deptLogic = new YHDeptLogic();
    YHUserPrivLogic userPrivLogic = new YHUserPrivLogic();
    YHFlowSortLogic fsLogic = new YHFlowSortLogic();
    
    YHFlowSort flowSort = fsLogic.getFlowSortById(flowType.getFlowSort() , conn);
    YHDeptLogic dept = new YHDeptLogic();
    int deptId = loginUser.getDeptId();
    String deptName = dept.getNameById(deptId, conn);
    StringBuffer sb = new StringBuffer();
    deptLogic.getDeptNameLong(conn, deptId, sb);
    String longName = sb.toString();
    if (longName.endsWith("/")) {
      longName = longName.substring(0, longName.length() - 1);
    }
    YHUserPriv role = userPrivLogic.getRoleById(Integer.parseInt(loginUser.getUserPriv()) , conn);
    String runName = "";
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date = new Date();
    String dateStr = df.format(date);
    
    if(flowType.getAutoName() == null || "".equals(flowType.getAutoName())){
      runName = flowType.getFlowName() + "(" + dateStr + ")";
    }else{
      String[] aDate = dateStr.split(" ");

      String curYear = aDate[0].split("-")[0];
      String curMon =  aDate[0].split("-")[1];
      String curDay =  aDate[0].split("-")[2];
      String curHour = aDate[1].split(":")[0];
      String curMinite = aDate[1].split(":")[1];
      String curSecond = aDate[1].split(":")[2];
      
      String autoNum = String.valueOf(flowType.getAutoNum() + 1);
      runName = flowType.getAutoName();
      if (isUpdateAutoNum) {
      //更新字流程文号计数器
        if (runName.indexOf("{N}") != -1) {
          String query ="update oa_fl_type set AUTO_NUM="+ autoNum +" where SEQ_ID=" + flowType.getSeqId();
          YHWorkFlowUtility.updateTableBySql(query, conn);
        }
      }
      int autoLen = flowType.getAutoLen();
      int length = autoLen - autoNum.length();
      for(int i = 0 ;i < length ;i++ ){
        autoNum = "0" + autoNum;
      }
      runName = runName.replaceAll("\\{Y\\}", curYear);
      runName = runName.replaceAll("\\{M\\}", curMon);
      runName = runName.replaceAll("\\{D\\}", curDay);
      runName = runName.replaceAll("\\{H\\}", curHour);
      runName = runName.replaceAll("\\{I\\}", curMinite);
      runName = runName.replaceAll("\\{S\\}", curSecond);
      runName = runName.replaceAll("\\{F\\}", flowType.getFlowName());
      runName = runName.replaceAll("\\{FS\\}", flowSort.getSortName());
      runName = runName.replaceAll("\\{U\\}", loginUser.getUserName());
      runName = runName.replaceAll("\\{SD\\}", deptName);
      runName = runName.replaceAll("\\{R\\}", role.getPrivName());
      runName = runName.replaceAll("\\{LD\\}", longName);
      runName = runName.replaceAll("\\{N\\}", autoNum);
    }
    
    return runName;
  }
  /**
   * 为YHFlowRunAct/getNewMsg方法组装数据
   * @param flowType
   * @param loginUser
   * @param list
   * @return 字符串 形如"{formId:23,flowName:'ddd',runName:'请假申请(2010-01-20 14:45:45)',prcsList:[{prcsNo:'1',prcsName:'请假申请',prcsTo:'2,'},{prcsNo:'1',prcsName:'请假申请',prcsTo:'2,'}]}"
   * @throws 
   */
  public String getNewMsg(YHFlowType flowType , YHPerson loginUser ,List<YHFlowProcess> list , Connection conn) throws Exception{
    StringBuffer sb = new StringBuffer("{");
    //取得文号
    String runName = this.getRunName(flowType, loginUser , conn , false);
    sb.append("formId:"+ flowType.getFormSeqId() 
        +",flowName:\""+YHUtility.encodeSpecial(flowType.getFlowName()) 
        +"\",runName:'" + runName + "',flowType:"+ flowType.getFlowType());
    if (flowType.getFlowDesc() != null) {
      sb.append(",introduction:\"" + YHUtility.encodeSpecial(flowType.getFlowDesc()) + "\"");
    }
    sb.append(",autoEdit:" + flowType.getAutoEdit());
    sb.append(",prcsList:[");
    //循环
    Collections.sort(list,new YHFlowProcessComparator());
    for(int i = 0 ;i < list.size() ;i ++){
      YHFlowProcess tmp = list.get(i);
      sb.append("{");
      sb.append("prcsNo:\"" + tmp.getPrcsId() + "\",");
      sb.append("prcsName:\"" + YHUtility.encodeSpecial(tmp.getPrcsName()) + "\",");
      
      String prcsTo = tmp.getPrcsTo();
      if (prcsTo == null || "".equals(prcsTo)) {
        if(i + 1 == list.size()){
          prcsTo = "0";
        }else{
          YHFlowProcess t2 = list.get(i + 1);
          prcsTo = t2.getPrcsId() + "";
        }
      }
      sb.append("prcsTo:'" + prcsTo + "'");
      sb.append("},");
    }
    if(list.size() > 0){
      sb.deleteCharAt(sb.length() - 1);
    }
    sb.append("]");
    sb.append("}");
    return sb.toString();
  }
  /**
   * 取得最近的工作列表
   * @return {title:'分类:ddd,类型:jjj',flowId:8,flowName:'ddd',runId:1,fileNo:'文件1',beginTime:'2003-1-12'},{title:'ddd',flowId:8,flowName:'ddd',runId:1,fileNo:'文件1',beginTime:'2003-1-12'}
   * @throws Exception
   */
  public String getRecentlyFlowRun(YHPerson user , Connection conn , String sortId) throws Exception{
    //---- 逐一查询最近的工作 ----
    long date1 = System.currentTimeMillis();
    String query = "SELECT FLOW_ID,RUN_ID,RUN_NAME,BEGIN_TIME from oa_fl_run where " 
      + " BEGIN_USER="+ user.getSeqId() 
      + " and DEL_FLAG=0 order by RUN_ID desc";
    YHPrcsRoleUtility tru = new YHPrcsRoleUtility();
    List<Map> flowRunList = new ArrayList();
    Statement stm = null;
    ResultSet rs = null;
    String flowIdStr = "";
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      while(rs.next()){
        int flowId = rs.getInt("FLOW_ID");
        //没在里面
        if (!YHWorkFlowUtility.findId(flowIdStr, String.valueOf(flowId))) {
          int runId = rs.getInt("RUN_ID");
          String runName = rs.getString("RUN_NAME");
          Timestamp beginTime = rs.getTimestamp("BEGIN_TIME");
          Map flowRunMap = new HashMap();
          flowRunMap.put("RUN_ID", runId);
          flowRunMap.put("RUN_NAME", runName);
          flowRunMap.put("BEGIN_TIME", beginTime);
          flowRunMap.put("FLOW_ID", flowId);
          flowRunList.add(flowRunMap);
          flowIdStr += flowId + ",";
        }
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    
    StringBuffer sb = new StringBuffer();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    YHORM orm = new YHORM();
    int count = 0 ;
    for(Map map : flowRunList){
      //验证是否有权限      if (count > 20) {
        break;
      }
      int flowId = (Integer)map.get("FLOW_ID");
      YHFlowProcess flowFirstProcess = null;
      YHFlowType ftTmp = (YHFlowType) orm.loadObjSingle(conn, YHFlowType.class, flowId);
      if (ftTmp == null) {
        continue;
      }
      boolean flag = false;
      if ("1".equals(ftTmp.getFlowType())) {
        YHFlowProcessLogic logic = new YHFlowProcessLogic();
        flowFirstProcess = logic.getFlowProcessById(ftTmp.getSeqId(), "1" , conn);
        flag = flowFirstProcess != null 
          && tru.prcsRole(ftTmp, flowFirstProcess, 0, user ,conn) ;
        map.put("flowTypeT" , "固定");
      } else {
        flag = tru.prcsRole(ftTmp, flowFirstProcess, 0, user , conn);
        map.put("flowTypeT" , "自由");
      }
      
      int sId = ftTmp.getFlowSort();
      if (flag && (YHUtility.isNullorEmpty(sortId) || YHWorkFlowUtility.findId(sortId, String.valueOf(sId)))) {
        String querySortName = "SELECT SORT_NAME from oa_fl_sort WHERE SEQ_ID=" + sId;
        String sortName = "";
        Statement stm2 = null;
        ResultSet rs2 = null;
        try {
          stm2 = conn.createStatement();
          rs2 = stm2.executeQuery(querySortName);
          if (rs2.next()){
            sortName = rs2.getString("SORT_NAME");
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm2, rs2, null); 
        }
        sb.append("{");
        sb.append("title:'分类:" + sortName
          + ",类型:" + map.get("flowTypeT") + "'");
        sb.append(",flowType:"  + ftTmp.getFlowType());
        sb.append(",flowId:" + ftTmp.getSeqId());
        String runName =(String)map.get("RUN_NAME") ;
        runName = YHWorkFlowUtility.getRunName(runName);
        sb.append(",flowName:'" + ftTmp.getFlowName()  + "'");
        sb.append(",runId:" + map.get("RUN_ID"));
        sb.append(",fileNo:'" + runName + "'");
        sb.append(",beginTime:'" + sdf.format((Date)map.get("BEGIN_TIME")) +  "'") ;
        sb.append("},");
        count ++ ;
      }
    }
    if (count > 0) {
      sb.deleteCharAt(sb.length() - 1);
    }
    long date2= System.currentTimeMillis();
    long date3 = date2 - date1;
  
    return sb.toString();
  }
  /**
   * 根据runID取得工作
   * @param runId
   * @return
   * @throws Exception
   */
  public YHFlowRun getFlowRunByRunId(int runId , Connection conn) throws Exception {
    // TODO Auto-generated method stub
    HashMap map = new HashMap();
    map.put("RUN_ID", runId);
    YHORM orm = new YHORM();
    YHFlowRun flowRun = (YHFlowRun) orm.loadObjSingle(conn, YHFlowRun.class, map);
    return flowRun;
  }
  /**
   * 根据给定的flowRun flowType 取得打印表单数据
   * @param flowRun
   * @param flowType
   * @return
   * @throws Exception 
   */
  public Map getPrintForm(YHPerson user ,YHFlowRun flowRun , YHFlowType flowType , boolean isWord , Connection conn, String imgPath) throws Exception{
    Map result = new HashMap();
    YHFlowFormUtility ffu = new YHFlowFormUtility();
    Map map = new HashMap();
    YHFormVersionLogic logic5  = new YHFormVersionLogic();
    int formId = logic5.getFormSeqId(conn, flowRun.getFormVersion(), flowType.getFormSeqId());
    
    map.put("FORM_ID", formId);
    YHORM orm = new YHORM();
    List<YHFlowFormItem> itemList = orm.loadListSingle(conn, YHFlowFormItem.class, map);
    String form = "";
    String script = "";
    String css = "";
    if (itemList.size() > 0) {
      map = new HashMap();
      map.put("RUN_ID", flowRun.getRunId());
      List<YHFlowRunData> frdList = orm.loadListSingle(conn, YHFlowRunData.class, map);
      YHFlowFormType ff = (YHFlowFormType) orm.loadObjSingle(conn, YHFlowFormType.class, formId);
      String modelShort = this.analysisAutoFlag(flowRun, flowType, ff, conn , imgPath);
      //取得转换后的form表单
      if (ff.getScript() != null) {
        script = ff.getScript();
      }
      if (ff.getCss() != null) {
        css = ff.getCss();
      }
      YHPraseData2PrintForm pdf = new YHPraseData2PrintForm();
      form =  pdf.parsePrintForm(user, modelShort , flowRun.getRunId(), flowType.getSeqId(), frdList, itemList , conn , isWord);
    } else {
      form = YHWorkFlowUtility.Message("表单内容为空！", 0);
    }
    //替换所有的单引号,不然会使json解析出错
    String form2 = form;
    form = form.replaceAll("\r\n", "");
    form = form.replaceAll("\n", "");
    form = form.replaceAll("\'", "\\\\'");
    script = script.replaceAll("\'", "\\\\'");
    script = script.replaceAll("[\n-\r]", "");
    css = css.replaceAll("\'", "\\\\'");
    css = css.replaceAll("[\n-\r]", "");
    result.put("form2", form2);
    result.put("form", form);
    result.put("script", script);
    result.put("css", css);
    return result;
  }
  /**
   * 
   * @param flowId
   * @param runId
   * @param prcsId
   * @param flowPrcs
   * @return
   * @throws Exception 
   */
  public String getHandlerMsg(YHPerson user , int runId, int prcsId, String flowPrcs , String ip , Connection conn  , String imgPath , String isWriteLog) throws Exception {
    // TODO Auto-generated method stub
    YHFlowTypeLogic flowTypeLogic =  new YHFlowTypeLogic();
    YHFlowRun flowRun = this.getFlowRunByRunId(runId , conn);
    Date date = new Date();
    YHFlowType flowType = flowTypeLogic.getFlowTypeById(flowRun.getFlowId() , conn);
    boolean  attachPrivWrite =  false;
    boolean  filePrivWrite = true;
    YHFlowProcess flowProcess = null;
    String attachPriv = "";
    Map runPrcsQuery = new HashMap();
    runPrcsQuery.put("RUN_ID", runId);
    runPrcsQuery.put("PRCS_ID", prcsId);
    runPrcsQuery.put("USER_ID", user.getSeqId());
    YHORM orm = new YHORM();
    String dispAip = "";
    YHFlowRunPrcs runProcess = (YHFlowRunPrcs) orm.loadObjSingle(conn, YHFlowRunPrcs.class, runPrcsQuery);
    if ("1".equals(flowType.getFlowType())) {
      YHFlowProcessLogic flowPrcsLogic = new  YHFlowProcessLogic();
      //查出相关步骤
      flowProcess = flowPrcsLogic.getFlowProcessById(flowRun.getFlowId(), flowPrcs , conn);
      String item = flowProcess.getPrcsItem();
      dispAip = flowProcess.getDispAip() + "";
      //附件是否可写
      if (runProcess != null && "1".equals(runProcess.getOpFlag())) {
        attachPrivWrite = YHWorkFlowUtility.findId(item, "[A@]");
        attachPriv = flowProcess.getAttachPriv();
        if (attachPriv == null) {
          attachPriv = "";
        }
        //文号是否可写
        filePrivWrite = YHWorkFlowUtility.findId(item, "[B@]");
      }
    } else {
      attachPriv = "1,2,3,4,5";
      attachPrivWrite = true;
    }
    Map aipMap = new HashMap();
    if(!YHUtility.isNullorEmpty(flowRun.getAipFiles())) {
      String aipFiles = flowRun.getAipFiles();
      String[] array = aipFiles.split("\n");
      for (String ss : array) {
        String[] s1 = ss.split(":");
        aipMap.put(s1[0], s1[1]);
      }
    }
    //查出第一步骤
    //查出运行中的步骤
    YHFormVersionLogic logic5  = new YHFormVersionLogic();
    int formId = logic5.getFormSeqId(conn, flowRun.getFormVersion(), flowType.getFormSeqId());
    
    //查出表单
    YHFlowFormType fft = (YHFlowFormType) orm.loadObjSingle(conn, YHFlowFormType.class, formId);
    
    
    //查询表单字段信息
    Map formItemQuery = new HashMap();
    
    
    formItemQuery.put("FORM_ID", formId);
    List<YHFlowFormItem> list = orm.loadListSingle(conn, YHFlowFormItem.class , formItemQuery);
    Map runDataQuery = new HashMap();
    runDataQuery.put("RUN_ID", runId);
    List<YHFlowRunData> frdList = orm.loadListSingle(conn, YHFlowRunData.class , runDataQuery);
    
    if(runProcess != null 
        && "1".equals(runProcess.getPrcsFlag())){
      runProcess.setPrcsFlag("2");
      runProcess.setPrcsTime(date);
      orm.updateSingle(conn, runProcess);
      if( "1".equals(runProcess.getTopFlag())
          && "1".equals(runProcess.getOpFlag())){
        String query = "update oa_fl_run_prcs set OP_FLAG=0 WHERE "
          + " USER_ID<>'" + user.getSeqId() +"'  "
          + " AND RUN_ID='" + flowRun.getRunId() + "'  "
          + " AND PRCS_ID='" + runProcess.getPrcsId() + "'  "
          + " AND FLOW_PRCS='"+ runProcess.getFlowPrcs() +"'";
        Statement stm = null;
        try {
          stm = conn.createStatement();;
          stm.executeUpdate(query);
        } catch (Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm, null, null);
        }
      }
      if(runProcess.getPrcsId()  == 1){
        flowRun.setBeginUser(user.getSeqId());
        flowRun.setBeginTime(date);
        orm.updateSingle(conn, flowRun);
        //父流程先不做
      }
    }
    //修改上一步骤状态为已经办理完毕
    int oldPrcsId = prcsId - 1;
    String query = "update oa_fl_run_prcs set PRCS_FLAG='4' WHERE "
          + " RUN_ID='"+runId+"'  "
          + " AND PRCS_ID='"+oldPrcsId+"'";
    if(!"0".equals(runProcess.getParent()) 
        && !YHUtility.isNullorEmpty(runProcess.getParent())) {
      String[] parent = runProcess.getParent().split(",");
      String ps = "";
      for (String s : parent) {
        if (!YHUtility.isNullorEmpty(s))
          ps += s + ",";
      }
      ps = YHWorkFlowUtility.getOutOfTail(ps);
      query +=" AND FLOW_PRCS IN ("+ ps +")";
    }
      
       
    Statement stm = null;
    try {
      stm = conn.createStatement();
      stm.executeUpdate(query);
    } catch (Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, null, null);
    }
    String flowTypeStr = flowType.getFlowType();
    boolean hasEnd = false;
    if ("2".equals(flowTypeStr) && "1".equals(runProcess.getOpFlag())) {
       query = "SELECT * from oa_fl_run_prcs where RUN_ID="+runId+" and PRCS_ID>'"+prcsId+"' and PRCS_FLAG='5'";
       Statement stm1 = null;
       ResultSet rs1 = null;
       try {
         stm1 = conn.createStatement();
         rs1 = stm1.executeQuery(query);
         if (!rs1.next()) {
           hasEnd = true;
         }
       } catch(Exception ex) {
         throw ex;
       } finally {
         YHDBUtility.close(stm1, rs1, null); 
       }
    } else if ("2".equals(flowTypeStr) && "2".equals(runProcess.getTopFlag())) {
      query = "select 1 FROM oa_fl_run_prcs WHERE RUN_ID='"+runId+"' AND PRCS_ID='"+prcsId+"' AND FLOW_PRCS='"+flowPrcs+"' AND USER_ID<>'"+user.getSeqId()+"' AND PRCS_FLAG IN('1','2')";
      Statement stm1 = null;
      ResultSet rs1 = null;
      try {
        stm1 = conn.createStatement();
        rs1 = stm1.executeQuery(query);
        if (!rs1.next()) {
          hasEnd = true;
        }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm1, rs1, null); 
      }
    }
    //设置宏标记    String formMsg = "";
    if (list.size() > 0) {
      String modelShort = this.analysisAutoFlag(flowRun, flowType, fft, conn , imgPath);
      YHPraseData2Form pdf = new YHPraseData2Form();
      formMsg  = pdf.parseForm(user
          , modelShort
          , flowProcess
          , runProcess
          , flowType
          , frdList
          , list
          , ip
          , conn);
      formMsg = formMsg.replaceAll("\'", "\\\\'");
      formMsg = formMsg.replaceAll("\n", "");
      formMsg = formMsg.replaceAll("\\\n", "");
    }
    String js = (fft == null || fft.getScript() == null) ? "" : fft.getScript();
    String css = ( fft == null || fft.getCss() == null) ? "" : fft.getCss();
    js = js.replaceAll("\'", "\\\\'");
    js = js.replaceAll("[\n-\r]", "");
    css = css.replaceAll("\'", "\\\\'");
    css = css.replaceAll("[\n-\r]", "");
    
    StringBuffer sb = new StringBuffer();
    String feedback = "0";
    if(flowProcess!= null && flowProcess.getFeedback() != null){
      feedback = flowProcess.getFeedback();
    }
    String allowBack = "0";//不允许回退
    if(flowProcess != null && flowProcess.getAllowBack() != null){
      allowBack = flowProcess.getAllowBack();
    }
    if ("1".equals(allowBack)) {
      String query2 = "SELECT 1 FROM oa_fl_run_prcs WHERE " 
        + " RUN_ID='"+runId+"' AND PRCS_ID='"+prcsId+"' AND OP_FLAG='1' AND FLOW_PRCS<>'"+flowPrcs+"' AND PARENT='"+ runProcess.getParent()+"'";
      Statement stm1 = null;
      ResultSet rs1 = null;
      try {
        stm1 = conn.createStatement();
        rs1 = stm1.executeQuery(query2);
        if (rs1.next()) {
          allowBack = "0";
        }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm1, rs1, null); 
      }
    }
    
    String focusUser =  flowRun.getFocusUser();
    YHPersonLogic logic = new YHPersonLogic();
    String focusUserName = logic.getNameBySeqIdStr(focusUser, conn);
    sb.append("{formMsg:'" + formMsg + "'");
    sb.append(",js:'" + js + "'");
    sb.append(",css:'" + css + "'");
    String runName = flowRun.getRunName();
    runName = YHWorkFlowUtility.getRunName(runName);
    
    sb.append(",runName:'" + runName + "'");
    sb.append(",flowRunPrcs:{");
    sb.append("opFlag:'" + runProcess.getOpFlag() + "'");
    sb.append(",attachPrivWrite:" + attachPrivWrite);
    sb.append(",filePrivWrite:" + filePrivWrite);
    sb.append(",feedbackFlag:" + feedback);
    sb.append(",allowBack:" + allowBack);
    sb.append(", flowType:" + flowType.getFlowType());
    sb.append(", flowDoc:" + flowType.getFlowDoc());
    sb.append(", focusUserName:'" + focusUserName + "'");
    sb.append(",attachPriv:'" + attachPriv + "'");
    sb.append(",hasEnd:" + hasEnd);
    if (dispAip == null || "0".equals(dispAip)) {
      dispAip = "";
    }
    sb.append(",dispAip:'" + dispAip + "'");
    sb.append(",dispFile:'" + YHUtility.null2Empty((String)aipMap.get(dispAip)) + "'");
    sb.append("}");
    sb.append("}");
    if ("1".equals(isWriteLog)) {
      YHFlowRunLogLogic log = new YHFlowRunLogLogic();
      int iFlowPrcs = 0;
      if (YHUtility.isInteger(flowPrcs)) {
        iFlowPrcs = Integer.parseInt(flowPrcs);
      }
      log.runLog(runId, prcsId, iFlowPrcs, user.getSeqId(), 8, "访问了工作流：" + runName + "的办理界面！", ip, conn);
    }
    return sb.toString();
  }
  /**
   * 查询是否重名
   * @param runName
   * @param flowId
   * @return
   * @throws Exception 
   */
  public boolean isExist(String runName , int flowId , Connection conn) throws Exception{
    //查询是否为重名的
    YHORM orm = new YHORM();
    Map map = new HashMap();
    map.put("RUN_NAME", runName);
    map.put("FLOW_ID", flowId);//
    YHFlowRun flowRun = (YHFlowRun) orm.loadObjSingle(conn, YHFlowRun.class, map);
    if(flowRun != null){ 
      return true;
    }
    return false;
  }
  /**
   * 根据runName新建工作
   * @param user
   * @param flowType
   * @param runName
   * @throws Exception
   */
  public int createNewWork(YHPerson user ,YHFlowType flowType , String runName , Connection conn ) throws Exception{
      //查出最的runId
      conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
      int runId = 0;
     // if (max == 0 ) {
        String query = "select MAX(RUN_ID) max FROM oa_fl_run";
        Statement stm = null;
        ResultSet rs = null;
        try {
          stm = conn.createStatement();
          rs = stm.executeQuery(query);
          if(rs.next()){
            //根据最大的构建 新的runId
            runId = rs.getInt("max") + 1;
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm, rs, null); 
        }
      //对工作名称进行处理      runName = runName.replaceAll("\n", "");
      runName = runName.replaceAll("\r", "");
      //runName = runName.replaceAll("\"", "&#34;");
     // runName = runName.replaceAll("'", "&rsquo;");
      runName = runName.replaceAll("\\{RUN\\}", String.valueOf(runId));
      YHORM orm = new YHORM();
      YHFormVersionLogic l = new YHFormVersionLogic();
      //新建 一个工作实例 
       query = "insert into oa_fl_run (RUN_ID "
        + " ,RUN_NAME "
        + " ,FLOW_ID "
        + " ,BEGIN_USER "
        + " ,BEGIN_TIME " 
        + ", FORM_VERSION " 
        + ") values ("
        + runId 
        +",?,"
        + flowType.getSeqId() 
        +","+ user.getSeqId() 
        +",?"
        + " , " + l.getMaxVersion(conn, flowType.getFormSeqId())
        +")";
      Timestamp time =  new  Timestamp(new Date().getTime());
      PreparedStatement stm2 = null;
      try {
        stm2 = conn.prepareStatement(query);
        stm2.setString(1, runName);
        stm2.setTimestamp(2, time);
        stm2.executeUpdate();
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm2, null, null); 
      }
      
      //新建工作的第一个步骤
      query = "insert into oa_fl_run_prcs (RUN_ID  "
        + " , PRCS_ID  "
        + " ,USER_ID  "
        + " ,PRCS_FLAG  "
        + " ,FLOW_PRCS  "
        + " ,CREATE_TIME) VALUES (" + runId + " , 1, " +user.getSeqId() + ",'1','1',?)";
      
      PreparedStatement stm3 = null;
      try {
        stm3 = conn.prepareStatement(query);
        stm3.setTimestamp(1, time);
        stm3.executeUpdate();
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm3, null, null); 
      }
      //查询flowType,一个相关流程

      YHFlowFormUtility ffu = new YHFlowFormUtility();
      //存入缓存
     // ffu.cacheForm(flowType.getFormSeqId() , conn);
      //更新记数器
      if(flowType.getAutoName() != null && flowType.getAutoName().indexOf("{N}") != -1){
        flowType.setAutoNum(flowType.getAutoNum() + 1);
        orm.updateSingle(conn, flowType);
      }
      //查询相关表单
      YHFlowFormType fft = (YHFlowFormType) orm.loadObjSingle(conn, YHFlowFormType.class, flowType.getFormSeqId());
      //查询表单字段信息
      
      Map formItemQuery = new HashMap();
      formItemQuery.put("FORM_ID", flowType.getFormSeqId());
      List<YHFlowFormItem> list = orm.loadListSingle(conn, YHFlowFormItem.class , formItemQuery);
      //实例 化一个YHFlowRunData列表并且添加到数据库
      String fieldName = "";
      String fieldVal = "";
      Map valueMap  = new HashMap();
      int count = 2 ;
      YHFlowRunLogic logic = new YHFlowRunLogic();
      for(YHFlowFormItem tmp : list){
        String clazz = tmp.getClazz();
        if("DATE".equals(clazz) || "USER".equals(clazz)){
          continue;
        }
        String itemData = logic.getItemData(tmp);
        if (!YHWorkFlowUtility.isSave2DataTable()){
          YHFlowRunData runData = new YHFlowRunData();
          runData.setItemData(itemData);
          runData.setItemId(tmp.getItemId());
          runData.setRunId(runId);
          orm.saveSingle(conn, runData);
        } else {
          count++;
          fieldName += ",DATA_" + tmp.getItemId() ;
          fieldVal += ",?";
          valueMap.put(count, itemData);
        }
      }
      if (YHWorkFlowUtility.isSave2DataTable()){
        String tableName = YHWorkflowSave2DataTableLogic.FORM_DATA_TABLE_PRE + flowType.getSeqId() + "_" + flowType.getFormSeqId() ;
        String del = "DELETE FROM " + tableName + " WHERE RUN_ID = " + runId;
        YHWorkFlowUtility.updateTableBySql(del, conn);
        PreparedStatement stm4 = null;
        String query1 = "insert into " + tableName + " (RUN_ID , RUN_NAME , BEGIN_USER, BEGIN_TIME " + fieldName + ") "
          + "VALUES ("  + runId + ", ? ," + user.getSeqId() + ", ? " + fieldVal + ")";
        try {
          stm4 = conn.prepareStatement(query1);
          stm4.setString(1, runName);
          stm4.setTimestamp(2, time);
          Set<Integer> keys = valueMap.keySet();
          for (int b : keys) {
            String itemData = (String)valueMap.get(b);
            stm4.setString(b, itemData);
          }
          stm4.executeUpdate();
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm4, null, null); 
        }
      }
      return runId;    
  }
  public String getItemData(YHFlowFormItem tmp) {
    String clazz = tmp.getClazz();
    String tag = tmp.getTag();
    String content = tmp.getContent();
    String value = tmp.getValue();
    String itemData = "";
    if("INPUT".equals(tag) && content.indexOf("checkbox") != -1){
      Pattern pattern = Pattern.compile("\\s+[Cc][Hh][Ee][Cc][Kk][Ee][Dd]");  
      Matcher matcher = pattern.matcher(content); 
      if (matcher.find()) {
        itemData = "on";
      } else {
        itemData = "";
      }
    }else if(!"SELECT".equals(tag) && !"LIST_VIEW".equals(clazz)){
      itemData = tmp.getValue() == null ? "" : tmp.getValue();
      itemData = itemData.replaceAll("\"", "");
      if("{宏控件}".equals(itemData)){
        itemData = "";
      }
      if ("MODULE".equals(clazz)) {
        itemData = "";
      }
    } else if ("INPUT".equals(tag)) {
      itemData = value;
    } else {
      itemData = "";
    }
    return itemData;
  }
  /**
   * 保存表单
   * @param user
   * @param flowId
   * @param runId
   * @param prcsId
   * @param flowPrcs
   * @param map
   * @return
   * @throws Exception 
   */
  public String saveFormData(YHPerson user , int flowId 
      , int runId , int prcsId , int flowPrcs  ,HttpServletRequest request , String hiddenStr , String readOnlyStr , Connection conn) throws Exception{
    YHORM orm = new YHORM();
    Map queryRunPrcs = new HashMap();
    queryRunPrcs.put("RUN_ID", runId);
    queryRunPrcs.put("PRCS_ID", prcsId);
    queryRunPrcs.put("FLOW_PRCS", flowPrcs);
    queryRunPrcs.put("USER_ID", user.getSeqId());
    YHFlowRunPrcs flowRunPrcs = (YHFlowRunPrcs) orm.loadObjSingle(conn, YHFlowRunPrcs.class, queryRunPrcs);
    YHFlowType flowType = (YHFlowType) orm.loadObjSingle(conn, YHFlowType.class, flowId);
    //说明是主办
    YHFormVersionLogic lo = new YHFormVersionLogic();
    int versionNo = lo.getVersionNo(conn, runId);
    int formId = flowType.getFormSeqId();
    int formSeqId = lo.getFormSeqId(conn, versionNo, formId);
        if("1".equals(flowRunPrcs.getOpFlag())){
      Map queryItem = new HashMap();
      Map dataMap = new HashMap();
      queryItem.put("FORM_ID",  formSeqId);
      List<YHFlowFormItem> list = orm.loadListSingle(conn, YHFlowFormItem.class, queryItem);
      String dataField = "";
      int count = 0;
      for(YHFlowFormItem tmp : list){
        int itemId = tmp.getItemId();
        //保密字段、只读字段不保存
        if(YHWorkFlowUtility.findId(hiddenStr, String.valueOf(itemId))
            || YHWorkFlowUtility.findId(readOnlyStr, String.valueOf(itemId))){
          continue;
        }
        String clazz = tmp.getClazz();
        if("DATE".equals(clazz) || "USER".equals(clazz)){
          continue;
        }
        String aItem = request.getParameter("DATA_" + itemId);
        String itemData =  "";
        if (!YHUtility.isNullorEmpty(aItem)) {
          itemData =  aItem;
        }
        if (!YHWorkFlowUtility.isSave2DataTable()){
          Map queryMap = new HashMap();
          queryMap.put("RUN_ID", runId);
          queryMap.put("ITEM_ID", itemId);
          YHFlowRunData flowRunData = (YHFlowRunData) orm.loadObjSingle(conn, YHFlowRunData.class, queryMap);
          if(flowRunData != null){
            flowRunData.setItemData((itemData == null ? "" : itemData));
            orm.updateSingle(conn, flowRunData);
          }else{
            flowRunData =  new YHFlowRunData();
            flowRunData.setItemId(itemId);
            flowRunData.setRunId(runId);
            flowRunData.setItemData((itemData == null ? "" : itemData));
            orm.saveSingle(conn, flowRunData);
          }
        }  else {
          String t = "DATA_" + itemId;
          dataField += t + "=?,";
          count++;
          dataMap.put(count, itemData);
        }
      }
      
      if (YHWorkFlowUtility.isSave2DataTable()){
        dataField = YHWorkFlowUtility.getOutOfTail(dataField);
        if (!YHUtility.isNullorEmpty(dataField)) {
          String tableName = YHWorkflowSave2DataTableLogic.FORM_DATA_TABLE_PRE+ flowId  + "_" + formSeqId;
          String update = "update " + tableName + " set "
             + dataField 
             + " where RUN_ID=" + runId;
          PreparedStatement stm4 = null;
          try {
            stm4 = conn.prepareStatement(update);
            Set<Integer> keys = dataMap.keySet();
            for (int b : keys) {
              String itemData = (String)dataMap.get(b);
              stm4.setString(b, itemData);
            }
            stm4.executeUpdate();
          } catch(Exception ex) {
            throw ex;
          } finally {
            YHDBUtility.close(stm4, null, null); 
          }
        }
      }
    }
    return null;
  }
  /**
   * 取得转交页面的相关数据


   * @param loginUser
   * @param runId
   * @param prcsId
   * @param flowPrcsStr
   * @return
   * @throws Exception
   */
  public String getTurnData(YHPerson loginUser, int runId, int prcsId, String flowPrcsStr , Connection conn , boolean isManage) throws Exception{
    YHORM orm = new YHORM();
    Map queryMap = new HashMap();
    queryMap.put("RUN_ID", runId);
    YHFlowRun flowRun = (YHFlowRun) orm.loadObjSingle(conn, YHFlowRun.class, queryMap);
    Map queryPrcs = new HashMap();
    queryPrcs.put("RUN_ID", runId);
    queryPrcs.put("PRCS_ID", prcsId);
    queryPrcs.put("FLOW_PRCS", Integer.parseInt(flowPrcsStr));
    List<YHFlowRunPrcs> flowRunPrcList = orm.loadListSingle(conn, YHFlowRunPrcs.class, queryPrcs);
    String parentStr = "";
    for (YHFlowRunPrcs p : flowRunPrcList) {
      if (!YHUtility.isNullorEmpty(p.getParent())) {
        parentStr += p.getParent() + ",";
      }
    }
    //注意这儿
    YHFlowProcessLogic flowProcessLogic  = new YHFlowProcessLogic();
    YHFlowProcess flowProcess = flowProcessLogic.getFlowProcessById(flowRun.getFlowId(), flowPrcsStr , conn);
    YHFlowType flowType = (YHFlowType) orm.loadObjSingle(conn, YHFlowType.class , flowRun.getFlowId());
    //------------------------------------------- 转出条件检查 ----------------------------------
    YHTurnConditionUtility turnUtility = new YHTurnConditionUtility();
    Map formData = turnUtility.getForm(flowType.getFormSeqId(), runId , flowRun.getFlowId() , conn);
    if (!isManage) {
      String notPass = turnUtility.checkCondition(loginUser, formData, flowProcess, false, runId , prcsId , Integer.parseInt(flowPrcsStr) , conn);
      if (!"setOk".equals(notPass)) {
//        notPass = notPass.replaceAll("[\n-\r]", "");
//        notPass = notPass.replaceAll("\'", "\\\\'");
        String s = "{notOutPass:\""+YHUtility.encodeSpecial(notPass)+"\"}";
        return s;
      }
    }
    StringBuffer sb = new StringBuffer();
    sb.append("{flowName:'" + flowType.getFlowName() + "'");
    String syncDeal = flowProcess.getSyncDeal();
    if (YHUtility.isNullorEmpty(syncDeal)) {
      syncDeal = "0";
    }
    String gatherNode = flowProcess.getGatherNode();
    if (YHUtility.isNullorEmpty(gatherNode)) {
      gatherNode = "0";
    }
    
    sb.append(",prcsName:'" + flowProcess.getPrcsName() + "',remindFlag:" + flowProcess.getRemindFlag());
    sb.append(",syncDeal:'" + syncDeal + "'");
    String runName = flowRun.getRunName();
    runName = YHWorkFlowUtility.getRunName(runName);
    sb.append(",flowRun:{runName:'" + runName +"'");
    boolean isAllowTurn = false;//默认为不允许
    if (flowProcess.getTurnPriv() != null
        && "1".equals(flowProcess.getTurnPriv())) {
      isAllowTurn = true;
    }
    sb.append(",isAllowTurn:" + isAllowTurn);//是否允许强制转交
    //取得所有经办人的办理信息
    if ("1".equals(gatherNode)) {
//      String query1 = "select PRCS_FLAG , PRCS_ID , FLOW_PRCS FROM FLOW_RUN_PRCS " 
//        + " WHERE  " 
//        + " RUN_ID = " + runId 
//        + " AND PRCS_ID = " +(prcsId - 1) ;
//      Statement stm3 = null;
//      ResultSet rs3 = null;
//      try {
//        stm3 = conn.createStatement();
//        rs3 = stm3.executeQuery(query1);
//        while(rs3.next()){
//          String ss = rs3.getString("FLOW_PRCS");
//          if (!YHWorkFlowUtility.findId(parentStr, ss)) {
//            sb.append("},gatherNode:'1'}");
//            return sb.toString();
//          }
//        }
//      } catch(Exception ex) {
//        throw ex;
//      } finally {
//        YHDBUtility.close(stm3, rs3, null); 
//      }
//    }
      int iflowPrc = Integer.parseInt(flowPrcsStr);
      String query1 = "select "
        + " PRCS_ID  "
        + "  from  "
        + "  oa_fl_process  "
        + " where  "
        + " FLOW_SEQ_ID='"+flowRun.getFlowId()+"' "
        + "  and  (" + YHDBUtility.findInSet(flowPrcsStr, "PRCS_TO") + " or (PRCS_ID = "+ (iflowPrc - 1) +" AND PRCS_TO=''))";
        Statement stm3 = null;
        ResultSet rs3 = null;
        try {
          stm3 = conn.createStatement();
          //System.out.println(query1);
          rs3 = stm3.executeQuery(query1);
          while (rs3.next()){
            int prcsId1 = rs3.getInt("PRCS_ID");
            String  query2 = "select PRCS_FLAG from oa_fl_run_prcs WHERE RUN_ID='"+runId+"' AND FLOW_PRCS='"+prcsId1+"' and OP_FLAG='1'";
            Statement stm4 = null;
            ResultSet rs4 = null;
            String prcsFlag1 = "1";
            boolean cannotTurn = false;
            try {
              stm4 = conn.createStatement();
              rs4 = stm4.executeQuery(query2);
              if(rs4.next()){
                prcsFlag1 = rs4.getString("PRCS_FLAG");
                if (YHUtility.isInteger(prcsFlag1) && Integer.parseInt(prcsFlag1) <= 2) {
                  cannotTurn = true;
                }
              } else {
                cannotTurn = false;
              }
            } catch(Exception ex) {
              throw ex;
            } finally {
              YHDBUtility.close(stm4, rs4, null); 
            }
            if (!YHWorkFlowUtility.findId(parentStr, prcsId1 + "") && cannotTurn) {
              sb.append("},gatherNode:'1'}");
              return sb.toString();
            }
          }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm3, rs3, null); 
      }
    }
    String str = this.getHandlerState(flowRunPrcList, loginUser, Integer.parseInt(flowPrcsStr) , conn , isManage);
    if ( str == null ) {
      return null;
    }else{
      sb.append ( str ) ;
    }
    sb.append ( "}" ) ;
    //取得下一步的信息
    List<YHFlowProcess> nextPrcs = flowProcessLogic.getNextProcess ( flowProcess , conn );
    sb.append( ",nextPrcs:[" );
    for ( YHFlowProcess tmp : nextPrcs ) {
      
      sb.append("{");
      sb.append ( "seqId:" + tmp.getSeqId() );
      sb.append ( ",prcsId:'" + tmp.getPrcsId() + "'" );
      sb.append( ",childFlow:'" + tmp.getChildFlow() + "'" );
      int parentFlowId = 0;
      String prcsBack = "";
      String backUserOp = "";
      String backUser = "";
      sb.append( ",parentRun:'" + flowRun.getParentRun() + "'" );
      if (tmp.getPrcsId() == 0 && flowRun.getParentRun() != 0) {
        YHFlowRunUtility u = new YHFlowRunUtility();
        parentFlowId = u.getFlowId(conn, flowRun.getParentRun());
        String query3 = "select FLOW_PRCS FROM oa_fl_run_prcs WHERE RUN_ID='"+flowRun.getParentRun()+"' AND CHILD_RUN='"+runId+"'";
        Statement stm = null;
        ResultSet rs = null;
        int flowPrcs = 0;
        try {
          stm = conn.createStatement();
          rs = stm.executeQuery(query3);
          if(rs.next()){
            flowPrcs = rs.getInt("FLOW_PRCS");
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm, rs, null); 
        }
        sb.append( ",parentFlowPrcs:'" + flowPrcs + "'" );
        sb.append( ",parentFlowId:'" + parentFlowId + "'" );
        sb.append( ",prcsName:'结束子流程 '" );
        String query5 = "select PRCS_TO,AUTO_USER_OP,AUTO_USER FROM oa_fl_process WHERE FLOW_SEQ_ID='"+ parentFlowId +"' AND PRCS_ID='"+ flowPrcs +"'";
        Statement stm6 = null;
        ResultSet rs6 = null;
        try {
          stm6 = conn.createStatement();
          rs6 = stm6.executeQuery(query5);
          if(rs6.next()){
            prcsBack = rs6.getString("PRCS_TO");
            backUserOp = rs6.getString("AUTO_USER_OP");
            backUser = rs6.getString("AUTO_USER");
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm6, rs6, null); 
        }
        if (YHUtility.isNullorEmpty(prcsBack)) {
          prcsBack = "";
        }
        sb.append( ",prcsBack:'"+prcsBack+"'" );
      } else {
        if (tmp.getChildFlow() != 0) {
          sb.append ( ",prcsName:'" + tmp.getPrcsName() + "(子流程)'" );
        } else {
          sb.append ( ",prcsName:'" + tmp.getPrcsName() + "'" );
        }
      }
      
      
      String topFlag = (tmp.getTopDefault() == null ? "0" : tmp.getTopDefault());
      String userFilter = (tmp.getUserFilter() == null ? "0" : tmp.getUserFilter());
      //检查转入条件      String notInPass = turnUtility.checkCondition(loginUser, formData, tmp, true, runId , prcsId , Integer.parseInt(flowPrcsStr) , conn);
      boolean userLock = false;
      if("0".equals(tmp.getUserLock())){
        userLock = true;
      }
      if (!"setOk".equals(notInPass)) {
        sb.append(",notInPass:\""+YHUtility.encodeSpecial(notInPass)+"\"");
      }
      //取得下一步中的默认人员        if (tmp.getPrcsId() == 0 && flowRun.getParentRun() != 0) {
          sb.append ( "," + turnUtility.userSelect2(conn, loginUser, prcsBack, parentFlowId, backUserOp, backUser));
        } else {
          sb.append ( "," + turnUtility.userSelect ( loginUser, tmp, flowRun , conn));
        }
      
      sb.append ( ",userFilter:'" + userFilter + "'");//过滤信息
      sb.append ( ",userLock:" + userLock);//是否允许修改默认转交方式
      sb.append ( ",topFlag:'" + topFlag  + "'");//转交方式
      sb.append("},"); 
    }
    if(nextPrcs.size() > 0){
      sb.deleteCharAt ( sb.length() - 1 );
    }
    sb.append ( "]" ) ;
    YHConfigLogic logic = new YHConfigLogic();
    String paraValue = logic.getSysPar("SMS_REMIND", conn);
    String[] remindArray = paraValue.split("\\|");
    String smsRemind = "";
    String sms2remind = "";
    if (remindArray.length == 1) {
      smsRemind = remindArray[0];
    } else if (remindArray.length  >= 2) {
      smsRemind = remindArray[0];
      sms2remind = remindArray[1];
    }
    sb.append(",smsRemind:'"  + smsRemind + "', sms2Remind:'" + sms2remind + "'");
    String query = "select TYPE_PRIV,SMS2_REMIND_PRIV from oa_msg2_priv";
    String typePriv = "";
    String sms2RemindPriv = "";
    Statement stm = null;
    ResultSet rs = null;
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      if(rs.next()){
        typePriv = rs.getString("TYPE_PRIV");
        sms2RemindPriv = rs.getString("SMS2_REMIND_PRIV");
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    //检查该模块是否允许手机提醒
    boolean sms2PrivNext = false ;
    boolean sms2PrivStart = false ;
    boolean sms2PrivAll = false ;
    if (YHWorkFlowUtility.findId(typePriv, "7") 
        && YHWorkFlowUtility.findId(sms2RemindPriv , String.valueOf(loginUser.getSeqId()))) {
      sms2PrivNext = true;
    }
    if (YHWorkFlowUtility.findId(typePriv, "40") 
        && YHWorkFlowUtility.findId(sms2RemindPriv , String.valueOf(loginUser.getSeqId()))) {
      sms2PrivStart = true;
    }
    if (YHWorkFlowUtility.findId(typePriv, "41") 
        && YHWorkFlowUtility.findId(sms2RemindPriv , String.valueOf(loginUser.getSeqId()))) {
      sms2PrivAll  = true;
    }
    sb.append (",sms2PrivNext:" + sms2PrivNext + ", sms2PrivStart:" + sms2PrivStart + ", sms2PrivAll:" + sms2PrivAll + "}") ;
    return sb.toString();
  }
  /**
   * 取得办理情况的字符串
   * @return
   * @throws Exception 
   */
  public String getHandlerState(List<YHFlowRunPrcs> flowRunPrcList  , YHPerson user , int flowPrcs ,Connection conn , boolean isManage) throws Exception{
    String userNameStr = "";
    //?
    String parentStr = "";
    String notAllFinish = "";
    int turnForbidden = 0;
    String flowPrcsUp = "";
    YHPersonLogic personLogic = new YHPersonLogic();
    for(YHFlowRunPrcs tmp : flowRunPrcList){
      if(tmp.getFlowPrcs() == flowPrcs){
        int userId = tmp.getUserId();
        String parent = tmp.getParent();
        String prcsFlag = tmp.getPrcsFlag();
        parentStr += parent + ",";
        YHPerson person =  personLogic.getPersonById(userId , conn);
        if(person != null){
          if(prcsFlag.equals("1")){
            userNameStr += "<font color=red title=未接收办理>" + person.getUserName() + "(未接收)</font>,";
          }else if(prcsFlag.equals("2")){
            userNameStr += "<font color=red title=正在办理>" + person.getUserName() + "(办理中)</font>,";
          }else if(prcsFlag.equals("4")){
            userNameStr += "<font color=green title=已办理完毕>" + person.getUserName() + "(已办结)</font>,";
          }else{
            userNameStr += person.getUserName() + ",";
          }
        }
        if(!prcsFlag.equals("4") 
            && userId != user.getSeqId()){
          if(person != null){
            notAllFinish += person.getUserName() + ",";
          }
        }
        if((prcsFlag.equals("3") 
            || prcsFlag.equals("4"))
            && userId == user.getSeqId()
            && !isManage){
          turnForbidden = 1;
        }else{
          turnForbidden = 0 ;
        }
      }else{
        flowPrcsUp += tmp.getFlowPrcs();
      }
    }
    if(!"".equals(notAllFinish)){
      notAllFinish = notAllFinish.substring(0, notAllFinish.length() - 1);
    }
    userNameStr =  userNameStr.substring(0 , userNameStr.length() - 1) ;
    if(turnForbidden == 1){
      return null;
    }else{
      return ",userNameStr:'" + userNameStr + "',notAllFinish:'" + notAllFinish + "'";
    }
  }
  /**
   * 转交下一步

   * @param loginUser -登陆用户
   * @param runId -实际流程ID
   * @param flowId -流程
   * @param prcsId -实际步骤
   * @param flowPrcs -步骤
   * @param prcsChoose -选择的流程步骤

   * @param prcsUser -经办人

   * @param prcsOpUser -主办人

   * @param topFlag -办理方式
   * @param ip -用户ip
   * @param remindFlag -提醒方式
   * @param remindContent -提醒内容
   * @param conn  
   * @throws Exception
   */
  public void turnNext(YHPerson loginUser
      , int runId
      , int flowId
      , int prcsId
      , int flowPrcs
      , String prcsChoose
      , Map opUserMap
      , String ip
      , Connection conn) throws Exception{
    
    this.turnNext( runId, flowId, prcsId, flowPrcs, prcsChoose, opUserMap, conn );
    //工作流日志    String[] ss = prcsChoose.split(",");
    for (int i = 0 ;i < ss.length ;i++) {
      String s = ss[i];
      if (!"".equals(s) && YHUtility.isInteger(s)) {
        String prcsUser = (String)opUserMap.get("prcsUser_" + s);
        YHPersonLogic personLogic = new YHPersonLogic();
        String userNameStr = "";
        userNameStr  = personLogic.getNameBySeqIdStr(prcsUser , conn);
        String content = "转交至步骤"+(prcsId + 1)+",办理人:" + userNameStr;
        YHFlowRunLogLogic logLogic = new YHFlowRunLogLogic();
        logLogic.runLog(runId,prcsId ,flowPrcs,loginUser.getSeqId(),1,content,ip ,conn);
      }
    }
    
  }
  /**
   * 回退到prcsOld这步
   * @param loginUser
   * @param runId
   * @param flowId
   * @param prcsId
   * @param flowPrcs
   * @param prcsChoose
   * @param ip
   * @param skin 
   * @throws Exception
   */
  public void backTo(YHPerson loginUser
      , int runId
      , int flowId
      , int prcsId
      , int flowPrcs
      , String prcsPre
      , String ip 
      , String contextPath
      , String sortId
      , String skin, Connection conn) throws Exception{
    YHORM orm = new YHORM();
    Map map = new HashMap();
    map.put("RUN_ID", runId);
    map.put("PRCS_ID", Integer.parseInt(prcsPre));//回退的实际步骤    List<YHFlowRunPrcs> runPrcs =  orm.loadListSingle(conn, YHFlowRunPrcs.class , map);
    if (runPrcs.size() > 0 ){
      String prcsUser = "";//经办人      String prcsOpUser = "";//主办人      String topFlag = "0";//主办方式,
      YHFlowRunPrcs flowPrcsTmp = runPrcs.get(0);//主要是取出flowPrcs和topFlag
      topFlag = flowPrcsTmp.getTopFlag();
      String flowPrcsTo = String.valueOf(flowPrcsTmp.getFlowPrcs());
      for(YHFlowRunPrcs tmp : runPrcs){
        //1说明是主办        if ("1".equals(tmp.getOpFlag())) {
          prcsOpUser = String.valueOf(tmp.getUserId()) ;
        }
        prcsUser += tmp.getUserId() + ",";
      }
      Map opUserMap = new HashMap();
      opUserMap.put("prcsOpUser_" + flowPrcsTo , prcsOpUser);
      opUserMap.put("prcsUser_" + flowPrcsTo, prcsUser);
      opUserMap.put("topFlag_" + flowPrcsTo, topFlag);
      this.turnNext( runId, flowId, prcsId, flowPrcs, flowPrcsTo,  opUserMap , conn);
      //工作流日志      String userNameStr = "";
      YHPersonLogic personLogic = new YHPersonLogic();
      String content = "回退至步骤" + prcsPre ;
      YHFlowRunLogLogic logLogic = new YHFlowRunLogLogic();
      logLogic.runLog(runId,prcsId ,flowPrcs,loginUser.getSeqId(),1,content,ip ,conn);
      String prcsUser2 = (String)opUserMap.get("prcsUser_" + flowPrcsTo);
      YHSmsBack sb = new YHSmsBack();
      sb.setSmsType("7");
      String remindContent = "工作流回退提醒：流水号"+runId+"的工作回退给您处理！";
      sb.setContent(remindContent);
      sb.setFromId(loginUser.getSeqId());
      sb.setToId(prcsUser2);
      sb.setRemindUrl("/core/funcs/workflow/flowrun/list/inputform/index.jsp?skin="+skin+"&sortId="+ sortId +"&runId=" + runId + "&flowId=" + flowId + "&prcsId=" + (prcsId + 1)+ "&flowPrcs=" + prcsPre);
      YHSmsUtil.smsBack(conn, sb);
    }
  }
  /**
   * 转交下一步,通用接口
   * @param runId
   * @param flowId
   * @param prcsId
   * @param flowPrcs
   * @param prcsChoose
   * @param prcsUser 所有经办人
   * @param prcsOpUser 所有主办人
   * @param topFlag 经办方式0-指定主办人,1-无主办人会签 ,2-先接收为主办
   * @return
   * @throws Exception
   */
  public void turnNext(int runId
      , int flowId
      , int prcsId
      , int flowPrcs
      , String prcsChoose
      , Map opUserMap
      , Connection conn) throws Exception{
    String[] aPrcsChoose = prcsChoose.split(",");
    Timestamp time =  new  Timestamp(new Date().getTime());
    int prcsIdNew = prcsId + 1;
    for(String tmp : aPrcsChoose){
      if ("".equals(tmp)) {
        continue;
      }
      String prcsUser = (String)opUserMap.get("prcsUser_" + tmp);
      String prcsOpUser =  (String)opUserMap.get("prcsOpUser_" + tmp);
      String topFlag = (String)opUserMap.get("topFlag_" + tmp);
      //强制合并节点与子流程
      String query1 = "select "
                + "  GATHER_NODE,"
               +"   CHILD_FLOW, "
               + " ALLOW_BACK, "
               + " RELATION "
              + "  from "
                 + " oa_fl_process "
                + "where " 
                 + " FLOW_SEQ_ID='"+flowId+"' and " 
                  + " PRCS_ID='"+tmp+"'";
      Statement stm9 = null;
      ResultSet rs9 = null;
      String childFlow = "";
      String allowBack = "";
      String relation = "";
      try {
        stm9 = conn.createStatement();
        rs9 = stm9.executeQuery(query1);
        if(rs9.next()){
          childFlow = rs9.getString("CHILD_FLOW");//子流程ID（如果是普通步骤，则这个字段为0）
          allowBack =  rs9.getString("ALLOW_BACK");
          relation =  rs9.getString("RELATION");
        }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm9, rs9, null); 
      }
      Map otherMap = new HashMap();
      String prcsOpUserOld = prcsOpUser;
      int freeOther = this.getFreeOther(flowId, conn);
      YHTurnConditionUtility tu = new YHTurnConditionUtility();
      if (freeOther == 2) {
         //委托主办人        prcsOpUser = tu.turnOther(prcsOpUser, flowId, runId, prcsId, tmp, "", otherMap, conn);
        opUserMap.put("prcsUser_" + tmp, prcsOpUser);
         //委托经办人        prcsUser = tu.turnOther(prcsUser, flowId, runId, prcsId, tmp, prcsOpUserOld, otherMap, conn);
        opUserMap.put("prcsOpUser_" + tmp, prcsUser);
      }
      if("0".equals(childFlow)){
      //如果检测到曾经按先到先得转交或者无主办人会签，则此次转交也按先到先得规则 ？？？091016
        String queryTopFlag = "SELECT TOP_FLAG from oa_fl_run_prcs where  "
          + " RUN_ID='"+ runId +"'  "
          + " and PRCS_ID='"+ prcsIdNew +"'  "
          + " and FLOW_PRCS='"+ tmp +"'  "
          + " and TOP_FLAG IN ('1','2')";
        Statement stm = null;
        ResultSet rs = null;
        try {
          stm = conn.createStatement();
          rs = stm.executeQuery(queryTopFlag);
          if(rs.next()){
            topFlag = rs.getString("TOP_FLAG");
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm, rs, null); 
        }
        //如果检测到有主办人正在办理中，则此次转交设定的主办人作废，主办人依据现存的 ？？？091016
        String queryIsHasHander = "SELECT 1 from oa_fl_run_prcs where  "
          + " RUN_ID='"+ runId +"'  "
          + " and PRCS_ID='"+ prcsIdNew +"'  "
          + " and FLOW_PRCS='"+ tmp +"'  "
          + " and OP_FLAG='1'  "
          + " and TOP_FLAG='0'  "
          + " and PRCS_FLAG in('1','2')";
        int tFlag = 0 ;
        Statement stm2 = null;
        ResultSet rs2 = null;
        try {
          stm2 = conn.createStatement();
          rs2 = stm2.executeQuery(queryIsHasHander);
          if(rs2.next()){
            tFlag = 1;
            prcsOpUser = "";
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm2, rs2, null); 
        }
        
        String[] aPrcsUser = prcsUser.split(",");
        for(String userTmp : aPrcsUser){
          if(!userTmp.equals("")){
             //如果是主办人（$PRCS_OP_USER），主办人标识置成1；如果是谁先接收谁主办，则所有经办人的主办标识全置成1. 091016
            String opFlag = "0";
            if(userTmp.equals(prcsOpUser) || topFlag.equals("1")){
              opFlag = "1";
            }
            //无主办人会签，则主办人标识全置成0
            if(topFlag.equals("2")){
              opFlag = "0";
            }
            //-- 如果检测到同名用户正在办理，则不再转发给他，但如果曾经办理过，则会再次转发给他 --什么时候会出现这种情况？？？091016
            //$query = "SELECT 1 from FLOW_RUN_PRCS where RUN_ID='$RUN_ID' and PRCS_ID='$PRCS_ID_NEW' and FLOW_PRCS='$FLOW_PRCS_NEXT' and USER_ID='$TOK' and PRCS_FLAG in('1','2')";
            String query = "SELECT 1 from oa_fl_run_prcs where " 
              + " RUN_ID='"+runId+"'  " 
              + " and PRCS_ID='"+prcsIdNew+"'  " 
              + " and FLOW_PRCS='"+tmp+"'  " 
              + " and USER_ID="+userTmp
              + " and PRCS_FLAG in('1','2')";
            Statement stm3 = null;
            ResultSet rs3 = null;
            PreparedStatement  stm4 = null;
            try {
              stm3 = conn.createStatement();
              rs3 = stm3.executeQuery(query);
              String queryTmp = "";
              if(!rs3.next()){
                String otherUser = (String) otherMap.get(userTmp);
                if (otherUser == null || "".equals(otherUser)) {
                  otherUser = "0";
                }
                String query2 = "SELECT 1 from oa_fl_run_prcs where " 
                  + " RUN_ID='"+runId+"'  " 
                  + " and FLOW_PRCS='"+tmp+"'  " 
                  + " and USER_ID="+userTmp
                  + " and PRCS_FLAG in('1','2')";
                
                queryTmp = "insert into oa_fl_run_prcs(RUN_ID,PRCS_ID,USER_ID,PRCS_FLAG,FLOW_PRCS,OP_FLAG,TOP_FLAG,PARENT,CREATE_TIME,OTHER_USER) "
                  +"values ("
                  + runId 
                  +","+prcsIdNew
                  +","+userTmp
                  +",'1',"
                  + tmp +",'"
                  +opFlag+"','"
                  +topFlag
                  +"','"+flowPrcs+"',?,"+ otherUser +")";//parent去掉了


                stm4 = conn.prepareStatement(queryTmp);
                stm4.setTimestamp(1, time);
                stm4.executeUpdate();
              }else{
                //和parent相关
                String queryFlowRunPrcs = "select PARENT from oa_fl_run_prcs where  "
                + "  RUN_ID='"+runId+"' and  "
                + "   PRCS_ID='"+ prcsIdNew +"' and  "
                + "   FLOW_PRCS='"+ tmp +"' and  "
                + "   USER_ID='"+userTmp+"' and  "
                + "   PRCS_FLAG in ('1','2')";
                Statement stm5 = null;
                ResultSet rs5 = null;
                String parent = "";
                try {
                  stm5 = conn.createStatement();
                  rs5 = stm5.executeQuery(queryFlowRunPrcs);
                  if(rs5.next()){
                    parent = YHUtility.null2Empty(rs5.getString("PARENT"));
                  }
                } catch(Exception ex) {
                  throw ex;
                } finally {
                  YHDBUtility.close(stm5, rs5, null); 
                }
                if ("".equals(parent) || parent.endsWith(",")) {
                  parent +=  flowPrcs;
                } else {
                  parent += "," + flowPrcs ;
                }
                String updateFlowRunPrcs = "update "
                + "  oa_fl_run_prcs "
                + "  set  "
                + "   PARENT='" + parent + "'"
                + "   where  "
                + "  RUN_ID='"+runId+"' and  "
                + "   PRCS_ID='"+ prcsIdNew +"' and  "
                + "   FLOW_PRCS='"+ tmp +"' and  "
                + "   USER_ID='"+userTmp+"' and  "
                + "   PRCS_FLAG in ('1','2')";
                YHWorkFlowUtility.updateTableBySql(updateFlowRunPrcs, conn);
              }
            } catch(Exception ex) {
              throw ex;
            } finally {
              YHDBUtility.close(stm4, null, null);
              YHDBUtility.close(stm3, rs3, null); 
            }
          }
          //主办人依照原来，则不能收回。   “主办人依照原来”
          String query = "";
          if(tFlag == 1){
            query = "update oa_fl_run_prcs set DELIVER_TIME=?,PRCS_FLAG='4' WHERE RUN_ID="+runId+" and PRCS_ID="+prcsId+" and FLOW_PRCS='"+flowPrcs+"' and PRCS_FLAG in ('1','2')";
          }else{
            query = "update oa_fl_run_prcs set DELIVER_TIME=?,PRCS_FLAG='3' WHERE RUN_ID="+runId+" and PRCS_ID="+prcsId+" and FLOW_PRCS='"+flowPrcs+"' and PRCS_FLAG in ('1','2')";
          }
          PreparedStatement stm5 = null;
          try {
            stm5 = conn.prepareStatement(query);
            stm5.setTimestamp(1, time);
            stm5.executeUpdate();
          } catch(Exception ex) {
            throw ex;
          } finally {
            YHDBUtility.close(stm5, null, null); 
          }
        }
      } else {
        //新建子流程，返回子流实例ID为$RUN_ID_NEW
        YHFlowRunUtility fru = new YHFlowRunUtility();
        int runIdNew = fru.createNewWork(conn, Integer.parseInt(childFlow), prcsOpUserOld, prcsUser, runId, allowBack, relation , flowId);
        String queryTopFlag = "SELECT FLOW_TYPE from oa_fl_type where  "
          + " SEQ_ID ='"+ childFlow +"'";
        Statement stm = null;
        ResultSet rs = null;
        String flowType  = "1";
        try {
          stm = conn.createStatement();
          rs = stm.executeQuery(queryTopFlag);
          if(rs.next()){
            flowType = rs.getString("FLOW_TYPE");
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm, rs, null); 
        }
        String flowPrcsNext = tmp;
        if ("2".equals(flowType)) {
          flowPrcsNext = "0";
        }
        /**
         * 插入“衔接节点”的步骤主办人记录
         * 说明：1、注意：仅插入“主办人”的一条记录
         *       2、这个主办人其实是子流程的发起人？（turn_next.php界面上指定好的）
         */
        String insertFlowRunPrcs ="insert into oa_fl_run_prcs (RUN_ID,PRCS_ID,USER_ID,PRCS_FLAG,FLOW_PRCS,OP_FLAG,TOP_FLAG,PARENT,CHILD_RUN,CREATE_TIME) " 
          + " values ("+runId+","+prcsIdNew+",'"+prcsOpUser+"','1',"+flowPrcsNext+",1,0,'"+flowPrcs+"','"+runIdNew+"',?)";
        PreparedStatement stm2 = null;
        try {
          stm2 = conn.prepareStatement(insertFlowRunPrcs);
          stm2.setTimestamp(1, time);
          stm2.executeUpdate();
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm2, null, null); 
        }
        //直接更新状态为办结
        String updateState = "update "
                  + "  oa_fl_run_prcs  "
                  + "set  "
                  + " DELIVER_TIME=?, "
                  + " PRCS_FLAG='4' "
                  + " where  "
                  + " RUN_ID = " + runId + " and  "
                  + "  PRCS_ID = " + prcsId + " and  "
                  + " FLOW_PRCS = '" + flowPrcs + "' and "
                  + " PRCS_FLAG in ('1','2')";
        PreparedStatement stm3 = null;
        try {
          stm3 = conn.prepareStatement(updateState);
          stm3.setTimestamp(1, time);
          stm3.executeUpdate();
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm3, null, null); 
        }
        opUserMap.put("nextFlow_" + tmp, childFlow);
        opUserMap.put("nextRun_" + tmp, runIdNew);
      }
    }
  }
  public String turnEnd(YHPerson loginUser, int runId, int flowId, int prcsId, int flowPrcs, String prcsUser, String prcsOpUser, String topFlag , String ip  , Connection conn , String prcsBack) throws Exception{
    Timestamp time =  new  Timestamp(new Date().getTime());
    YHFlowHookUtility hookUtility = new YHFlowHookUtility();
    hookUtility.runHookPlugin(conn, runId);
  //取出流程实例的几个字段：$PARENT_RUN、$FOCUS_USER、$RUN_NAME
    String query1 = "select "
      + "  RUN_NAME,"
      + "  FOCUS_USER,"
      + "   PARENT_RUN "
      + "  from "
      + "    oa_fl_run "
      + "  where "
      + "    RUN_ID='"+runId+"'";
    Statement stm2 = null;
    ResultSet rs2 = null;
    int parentRun = 0;
    String focusUser = "";
    String runName = "";
    try {
      stm2 = conn.createStatement();
      rs2 = stm2.executeQuery(query1);
      if(rs2.next()){
        parentRun = rs2.getInt("PARENT_RUN");
        focusUser = rs2.getString("FOCUS_USER");
        runName = rs2.getString("RUN_NAME");
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm2, rs2, null); 
    }
    //更新当前步骤的办理标记为4（已办结），所有的经办人一块更新 091015
    
    String updateFlag = "update oa_fl_run_prcs set  "
      + " PRCS_FLAG='4'"
      + " WHERE "
      + " RUN_ID='"+runId+"'  "
      + " and PRCS_ID='"+prcsId+"'  "
      + " and FLOW_PRCS='"+ flowPrcs +"'";
    Statement stm = null;
    try {
      stm = conn.createStatement();
      stm.executeUpdate(updateFlag);
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, null, null); 
    }
    //更新当前主办人的转交时间为当前系统时间，仅更新当前步骤中当前主办人的记录（一条）091015
    String updateTime = "update oa_fl_run_prcs set  "
      + " DELIVER_TIME=?  "
      + " WHERE  "
      + " RUN_ID='" + runId + "'"
      + " and PRCS_ID='" + prcsId + "'"
      + " and FLOW_PRCS='"+ flowPrcs +"'"
      + " and USER_ID=" + loginUser.getSeqId();
   
    PreparedStatement stm4 = null;
    try {
      stm4 = conn.prepareStatement(updateTime);
      stm4.setTimestamp(1, time);
      stm4.executeUpdate();
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm4, null, null); 
    }
    /**
     * 091015
     * 判断当前步骤是否为当前流程中唯一一个状态为“执行中”的步骤（即当前步骤状态改为4之后，系统中再无当前流程的“执行中”步骤）
     * 若是则更新当前流程的结束时间为当前系统时间 
     */
    String query = "select 1 FROM oa_fl_run_prcs WHERE  "
      + " RUN_ID='"+runId+"'  "
      + " AND PRCS_FLAG IN (1,2)  "
      + " AND ((TOP_FLAG IN (0,1) AND OP_FLAG=1) OR TOP_FLAG=2)";
    Statement stm3 = null;
    ResultSet rs3 = null;
    PreparedStatement stm5 = null;
    try {
      stm3 = conn.createStatement();
      rs3 = stm3.executeQuery(query);
      if(!rs3.next()){
        String updateFlowRun = "update oa_fl_run set  "
          + " END_TIME=? "
          + " WHERE RUN_ID='"+runId+"'";
        stm5 = conn.prepareStatement(updateFlowRun);
        stm5.setTimestamp(1, time);
        stm5.executeUpdate();
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm5, null, null);
      YHDBUtility.close(stm3, rs3, null); 
    }
    //工作流日志  //子流程结束返回父流程
    if(parentRun !=0){
      /**
       * 取出FLOW_RUN_PRCS表中的“子流程衔接节点”
       * $PARENT_RUN：父流程的RUN_ID，见上面
       * $RUN_ID：流程实例ID
       */
      int parentPrcsId = 0;
      int parentFlowPrcs = 0;
       query = "select "
        + "  PRCS_ID,"
        + "  FLOW_PRCS "
        + "  from "
        + "     oa_fl_run_prcs "
        + "   where "
        + "     RUN_ID='"+ parentRun +"' and "
        + "     CHILD_RUN='"+runId+"'";
       Statement stm9 = null;
       ResultSet rs9 = null;
       try {
         stm9 = conn.createStatement();
         rs9 = stm9.executeQuery(query);
         if(rs9.next()){
           parentPrcsId = rs9.getInt("PRCS_ID");//子流程衔接节点的PRCS_ID（顺序号）
           parentFlowPrcs =  rs9.getInt("FLOW_PRCS");//子流程衔接节点的FLOW_PRCS（步骤定义编号）
         }
       } catch(Exception ex) {
         throw ex;
       } finally {
         YHDBUtility.close(stm9, rs9, null); 
       }
      /**
       * 更新父流程节点（衔接节点）为已办结（PRCS_FLAG='4'）
       * 说明：衔接节点的状态好像只能是1和4，因为不可能对衔接节点进行“接收”、“转交”操作，
       *       “我的工作”列表上就已经滤掉了，用CHILD_RUN=0的条件
       */
        query = "update "
        + "     oa_fl_run_prcs "
        + "    set "
        + "     DELIVER_TIME=?,"
        + "      PRCS_FLAG='4' "
                    + "     where "
                    + "      RUN_ID="+parentRun+" and "
                    + "     PRCS_ID="+parentPrcsId+" and "
                    + "     FLOW_PRCS='"+parentFlowPrcs+"' and "
                    + "      PRCS_FLAG in (1,2)";
        PreparedStatement stm10 = null;
        try {
          stm10 = conn.prepareStatement(query);
          stm10.setTimestamp(1, time);
          stm10.executeUpdate();
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm10, null, null); 
        }

      /**
       * 如果子流程对应的步骤设置了返回步骤，则返回父流程节点
       * 说明：1、返回的步骤是一个并发合并节点，该怎样处理？（答：创建新的并发合并节点记录，出现分叉）
       *       2、直接插入返回步骤节点记录，好像没有考虑多个节点指向一个节点（比如：并发合并）的情况
       *       3、这样直接插入，遇到多点合一的流程设计势必会出现“分叉”现象
       *       4、由此想到一个问题：说明书上的那个复杂的例子是否真的能运行起来？
       *       5、并发合并节点在转交或者结束时，要检查哪些步骤的prcs_to指向自己，prcs_to字段如果不设置，检查又会不完整
       * $PRCS_BACK：对应FLOW_PROCESS表的PRCS_TO字段
       */
      if (!"".equals(prcsBack) && !"0".equals(prcsBack)) {
        /**
         * 父流程返回步骤的顺序号
         * 说明：1、向父流程插入顺序号为$PARENT_PRCS_ID_NEW的主办/经办人记录时，可能父流程中已经插入了比$PARENT_PRCS_ID_NEW更大的步骤经办人记录
         *       2、如果有则实际的流程图上会出现分叉现象，还是会引起混乱？（不会太混乱，多少会有一点乱）
         *          这里插入的主办人和之前的主办人有无冲突？各个经办人的状态之间有无矛盾？（待测试）
         *       3、PARENT字段赋值为$PARENT_FLOW_RPCS，衔接步骤的定义编号，不是只有衔接节点的PARENT字段才有值么？
         *          怎么父流程返回步骤的也有值？（好像没用，待确认）
         */
        int parentPrcsIdNew = parentPrcsId + 1;
        query = "insert into oa_fl_run_prcs(RUN_ID,PRCS_ID,USER_ID,PRCS_FLAG,FLOW_PRCS,OP_FLAG,TOP_FLAG,PARENT) " 
          + "values ("+ parentRun +","+parentPrcsIdNew+",'"+ prcsOpUser +"','1',"+prcsBack+",1,0,'"+parentFlowPrcs+"')";
        YHWorkFlowUtility.updateTableBySql(query, conn);
        String[] backUserArray = prcsUser.split(",");
        for (String ss : backUserArray) {
          if ("".equals(ss) || ss.equals(prcsOpUser)) {
            continue;
          }
          query = "insert into oa_fl_run_prcs(RUN_ID,PRCS_ID,USER_ID,PRCS_FLAG,FLOW_PRCS,OP_FLAG,TOP_FLAG,PARENT) " 
            + " values ("+ parentRun +","+parentPrcsIdNew+",'"+ss+"','1',"+prcsBack+",0,0,'"+parentFlowPrcs+"')";
          YHWorkFlowUtility.updateTableBySql(query, conn);
        }
//        remindNext(conn  
//            , parentRun , int flowId , parentPrcsIdNew , Integer.parseInt(prcsBack)
//            , String content , String contextPath , String prcsUser , int userId , String sortId, String skin);
      }
      /**
       * 父流程的衔接节点不设置返回步骤，则检查父流程若所有节点是否均已办结，如果是则更新流程结束时间字段；如果还有尚未办结的节点，则空操作哦
       * 说明：1、衔接节点在上面已经更新为4，故读这段程序时，可以看作是“除衔接节点外的各个步骤节点都已经是4”
       *       2、如果这个“衔接节点”没办理完成，整个流程是否可以结束？（好像只有在并发分叉的情况下可以）
       *       3、一个猜想（待验证）：流程里有多个节点可以“结束流程”，每一个节点结束后都更新FLOW_RUN的END_TIME字段？？？（答：当然要这样。）
       */
      else {
        query  = "select 1 from oa_fl_run_prcs where RUN_ID='"
          + parentRun +"' and PRCS_FLAG!='4'";
        Statement stm7 = null;
        ResultSet rs7 = null;
        PreparedStatement stm8 = null;
        try {
          stm7 = conn.createStatement();
          rs7 = stm7.executeQuery(query);
          if (!rs7.next()) {
            query = "update oa_fl_run set END_TIME=? where RUN_ID='"+ parentRun +"'";
            stm8 = conn.prepareStatement(query);
            stm8.setTimestamp(1, time);
            stm8.executeUpdate();
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm7, rs7, null); 
          YHDBUtility.close(stm8, null, null); 
        }
      }
    }
    if (!YHUtility.isNullorEmpty(focusUser)) {
      YHSmsBack sb = new YHSmsBack();
      sb.setSmsType("7");
      sb.setContent("您所关注的工作已经结束:" + runName);
      sb.setFromId(loginUser.getSeqId());
      sb.setToId(focusUser);
      sb.setRemindUrl("/core/funcs/workflow/flowrun/list/print/index.jsp?runId="+runId+"&flowId="+ flowId + "&openFlag=1&width=800&height=600");
      YHSmsUtil.smsBack(conn, sb);
    }
    YHFlowRunLogLogic logLogic = new YHFlowRunLogLogic();
    logLogic.runLog(runId,prcsId ,flowPrcs,loginUser.getSeqId(),1,"结束流程",ip , conn);
    return null;
  }
  /**
   * 办理完毕处理函数
   * @param loginUser
   * @param runId
   * @param flowId
   * @param prcsId
   * @param flowPrcs
   * @param skin 
   * @return
   * @throws Exception
   */
  public String handlerFinish(YHPerson loginUser, int runId, int flowId, int prcsId, int flowPrcs , String ip ,String sortId, String skin, Connection conn , String contextPath) throws Exception{
    StringBuffer sb = new StringBuffer();
    String result = "";
    //----------- 自由流程主办人结束流程 或监控人结束流程 ----------- 暂不考虑
    YHORM orm = new YHORM();
    Map queryPrcs = new HashMap();
    queryPrcs.put("RUN_ID", runId);
    queryPrcs.put("PRCS_ID", prcsId);
    queryPrcs.put("FLOW_PRCS", flowPrcs);
    queryPrcs.put("USER_ID", loginUser.getSeqId());

    YHFlowRunPrcs flowRunPrcs = (YHFlowRunPrcs) orm.loadObjSingle(conn, YHFlowRunPrcs.class, queryPrcs);
    //无主办人会签，先检查是否最后一个经办人
    if("2".equals(flowRunPrcs.getTopFlag())){
      String query = "select 1 FROM oa_fl_run_prcs WHERE "
        +" RUN_ID='"+ runId +"' "
        +" AND PRCS_ID='"+ prcsId +"' "
        +" AND FLOW_PRCS='"+ flowPrcs + "' "
        +" AND USER_ID<>" + loginUser.getSeqId()
        +" AND PRCS_FLAG IN(1,2)";
      Statement stm = null;
      ResultSet rs = null;
      try {
        stm = conn.createStatement();
        rs = stm.executeQuery(query);
        if(!rs.next()){//说明自己是最后一个

          sb.append("{");
          if(flowPrcs == 0){
            //如果是最后一步

            sb.append("turnPage:'0'");
          }else{
            //如果不是最后一步

            sb.append("turnPage:'1'");
          }
          //转到转交页面
          sb.append("}");
          return sb.toString();
        }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm, rs, null); 
      }
    }
    //--- 写办理完毕状态 ---
    String updateQuery = "";
    Timestamp time =  new  Timestamp(new Date().getTime());
    if(flowPrcs == 0){//自由流程
      updateQuery = "update oa_fl_run_prcs set "
        +"PRCS_FLAG='4'"
        +",DELIVER_TIME=?"
        +" WHERE "
        +" RUN_ID='" + runId + "' "
        +" and PRCS_ID='" + prcsId+ "' "
        +" and USER_ID=" +loginUser.getSeqId();
      result = "'0'";
    }else{//固定流程
      updateQuery = "update oa_fl_run_prcs set "
        +" PRCS_FLAG='4'"
        +" ,DELIVER_TIME=? "
        +" WHERE "
        +" RUN_ID='" + runId  + "' "
        +" and PRCS_ID='" + prcsId + "' "
        +" and FLOW_PRCS='"+flowPrcs+"' "
        +" and USER_ID=" + loginUser.getSeqId();
      result = "'1'";
    }
    
    PreparedStatement stm3 = null;
    try {
      stm3 = conn.prepareStatement(updateQuery);
      stm3.setTimestamp(1, time);
      stm3.executeUpdate();
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm3, null, null); 
    }
    //经办人办理完毕后，如检查到所有经办人会签全部结束后，短信提醒主办人

    boolean flag = false;
    String query2 = "SELECT 1 from oa_fl_run_prcs WHERE " 
      + "  RUN_ID='"+runId+"' " 
      + "  AND PRCS_ID="+prcsId+"  " 
      + "  AND OP_FLAG='0' AND PRCS_FLAG<>'4'";
    Statement stm6 = null;
    ResultSet rs6 = null;
    try {
      stm6 =  conn.createStatement();
      rs6 = stm6.executeQuery(query2);
      if(!rs6.next()){
        flag = true;
      }
    } catch (Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm6, rs6, null);
    }
    if (flag) {
      String query = "SELECT RUN_NAME " 
      + " ,FLOW_ID  " 
      + " from oa_fl_run WHERE  " 
      + " RUN_ID=" + runId;
      
      String runName = "";
      int flowId1 = 0 ;
      Statement stm7 = null;
      ResultSet rs7 = null;
      try {
        stm7 =  conn.createStatement();
        rs7 = stm7.executeQuery(query);
        if(rs7.next()){
          runName = rs7.getString("RUN_NAME");
          flowId1 = rs7.getInt("FLOW_ID");
        }
      } catch (Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm7, rs7, null);
      }
      
      query = "SELECT " 
      + "  USER_ID  " 
      + "  from oa_fl_run_prcs WHERE  " 
      + " RUN_ID=" + runId 
      + " AND PRCS_ID=" + prcsId 
      + " AND OP_FLAG='1' AND PRCS_FLAG<>'4'";
      
      int userId = 0 ;
      Statement stm8 = null;
      ResultSet rs8 = null;
      try {
        stm8 =  conn.createStatement();
        rs8 = stm8.executeQuery(query);
        if(rs8.next()){
          userId = rs8.getInt("USER_ID");
        }
      } catch (Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm8, rs8, null);
      }
      if (userId != 0 ) {
        String remindUrl = "";
        String smsContent = "工作流已会签完毕：" + runName + "\n您作为主办人，可以转交下一步骤";
        YHSmsBack sb1 = new YHSmsBack();
        sb1.setSmsType("7");
        sb1.setContent(smsContent);
        sb1.setFromId(loginUser.getSeqId());
        sb1.setToId(String.valueOf(userId));
        sb1.setRemindUrl("/core/funcs/workflow/flowrun/list/inputform/index.jsp?skin="+ skin +"&sortId="+ sortId +"&runId=" + runId + "&flowId=" + flowId1 + "&prcsId=" + prcsId + "&flowPrcs=" + flowPrcs);
        YHSmsUtil.smsBack(conn, sb1);
      }
    }
    //--- 流程日志 ---
//    if($OP!="MANAGE")
//       $CONTENT="结束流程";
//    else
//       $CONTENT=$LOGIN_USER_NAME."强制结束流程";
    //YHFlowRunLogLogic logLogic = new YHFlowRunLogLogic(this.conn);
    //logLogic.runLog(runId,prcsId ,flowPrcs,loginUser.getUserId(),1,"结束流程",ip);
    return result;
  }
  public void cancelRun( int flowId, int runId, int prcsId, int flowPrcs , Connection conn) throws Exception{
    YHORM orm = new YHORM();
    String query =  "SELECT 1 "
        + "FROM oa_fl_run_prcs  WHERE "
        + "RUN_ID='"+runId+"' AND PRCS_ID>1";
    Statement stm = null;
    ResultSet rs = null;
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      boolean flag = rs.next();
      if(flag){
        return ;
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    
    YHFlowRun flowRun = this.getFlowRunByRunId(runId , conn);
    if(flowRun != null && flowRun.getParentRun() != 0){
      return ;
    }
    YHFlowTypeLogic flowTypeLogic = new YHFlowTypeLogic();
    YHFlowType flowType = flowTypeLogic.getFlowTypeById(flowId , conn);
    //处理自动文号
    if(flowType.getAutoName() != null && flowType.getAutoName().indexOf("{N}") != -1){
    //没有大于此流水号的工作，则处理自动文号表达式
      String query1 = "select 1 from oa_fl_run WHERE "
        + " RUN_ID>'"+ runId +"'  "
        + "AND FLOW_ID='"+ flowId +"'";
      Statement stm2 = null;
      ResultSet rs2 = null;
      try {
        stm2 = conn.createStatement();
        rs2 = stm2.executeQuery(query1);
        if(!rs2.next()){
          flowType.setAutoNum(flowType.getAutoNum() - 1);
          orm.updateSingle(conn, flowType);
          //conn.commit();
        }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm2, rs2, null); 
      }
    }
    //---删除附件 --
    //---删除会签附件 --
    Statement stm3 = null;
    Statement stm4 = null ;
    Statement stm5 = null;
    Statement stm6 = null ;
    try {
      String deleteFeedback ="delete from oa_fl_run_feedback where  "
        + "RUN_ID=" + runId;
      stm3 = conn.createStatement();
      stm3.executeUpdate(deleteFeedback);
      String deleteRunData = "delete from oa_fl_run_data where  "
        + "RUN_ID=" + runId;
      if (YHWorkFlowUtility.isSave2DataTable()) {
        int versionNo = flowRun.getFormVersion();
        int formId = flowType.getFormSeqId();
        YHFormVersionLogic lo =new YHFormVersionLogic();
        int formSeqId = lo.getFormSeqId(conn, versionNo, formId);
        String tableName = YHWorkflowSave2DataTableLogic.FORM_DATA_TABLE_PRE + flowId  + "_" + formSeqId;
        deleteRunData = "delete from " + tableName +" where "
          + "RUN_ID=" + runId;
      } 
      stm4 = conn.createStatement();
      stm4.executeUpdate(deleteRunData);
      
      String deleteFlowRunPrcs = "delete from oa_fl_run_prcs where  "
        + "RUN_ID=" + runId;
      stm5 = conn.createStatement();
      stm5.executeUpdate(deleteFlowRunPrcs);
      String deleteFlowRun="delete from oa_fl_run where "
        + " RUN_ID=" + runId;
      stm6 = conn.createStatement();
      stm6.executeUpdate(deleteFlowRun);
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm3, null, null);
      YHDBUtility.close(stm4, null, null);
      YHDBUtility.close(stm5, null, null);
      YHDBUtility.close(stm6, null, null);
    }
  }
  public String getPreRunPrcs(int runId , int prcsId , int flowId , Connection conn) throws Exception {
    // TODO Auto-generated method stub
    StringBuffer sb = new StringBuffer();
    List<YHFlowRunPrcs> list = new ArrayList();
    String query = "select "
      + "COUNT(distinct PRCS_ID)"
      + ",PRCS_ID"
      + ",FLOW_PRCS "
      + ",count(distinct PRCS_ID) "
      + " from oa_fl_run_prcs where "
      + " RUN_ID=" + runId 
      + " and PRCS_ID!=" + prcsId 
      + " GROUP BY prcs_id , flow_prcs";
    Statement stm1 = null;
    ResultSet rs1 = null;
    String prcsIdStr = "";
    try {
      stm1 = conn.createStatement();
      rs1 = stm1.executeQuery(query);
      while(rs1.next()){
        int flowPrcs = rs1.getInt("FLOW_PRCS");
        if (!YHWorkFlowUtility.findId(prcsIdStr, String.valueOf(flowPrcs))) {
          YHFlowRunPrcs rp = new YHFlowRunPrcs();
          rp.setPrcsId(rs1.getInt("PRCS_ID"));
          rp.setFlowPrcs(flowPrcs);
          prcsIdStr += flowPrcs + ",";
          list.add(rp);
        }
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm1, rs1, null); 
    }
    for (YHFlowRunPrcs runPrcs : list) {
      if(runPrcs.getPrcsId() !=  prcsId){
        sb.append("{");
        sb.append("id:" + runPrcs.getPrcsId());
        String prcsName = "";
        query = "select "
          + " PRCS_NAME "
          + " from oa_fl_process where "
          + " FLOW_SEQ_ID =" + flowId 
          + " and PRCS_ID =" + runPrcs.getFlowPrcs() ;
        Statement stm2 = null;
        ResultSet rs2 = null;
        try {
          stm2 = conn.createStatement();
          rs2 = stm2.executeQuery(query);
          if(rs2.next()){
            prcsName = rs2.getString("PRCS_NAME");
          }
        } catch(Exception ex) {
          throw ex;
        } finally {
          YHDBUtility.close(stm2, rs2, null); 
        }
        sb.append(",prcsName:'" + prcsName + "',flowPrcsId:" + runPrcs.getFlowPrcs());
        sb.append("},");
      }
    }
    if (list.size() > 0) {
      sb.deleteCharAt(sb.length() - 1);
    }
    return sb.toString();
  }
  /**
   * 提醒所有经办人和流程发起人
   * @param conn
   * @param remindFlag
   * @param content
   * @param contextPath
   * @param runId
   * @throws Exception 
   */
  public void remindAllAndSend(Connection conn , int remindFlag , String content , String contextPath , int runId , int userId , int flowId) throws Exception{
    Map map2 = new HashMap();
    map2.put("RUN_ID", runId);
    YHORM orm = new YHORM();
    YHFlowRun flowRun = (YHFlowRun) orm.loadObjSingle(conn, YHFlowRun.class  , map2);
    String id = String.valueOf(flowRun.getBeginUser());
    boolean has = false;
    if ((remindFlag&0x20)>0 ) {
      YHSmsBack sb = new YHSmsBack();
      sb.setSmsType("40");
      sb.setContent(content);
      sb.setFromId(userId);
      sb.setToId(id);
      sb.setRemindUrl("/core/funcs/workflow/flowrun/list/print/index.jsp?runId="+runId+"&flowId="+ flowId + "&openFlag=1&width=800&height=600");
      YHSmsUtil.smsBack(conn, sb);
      has = true;
    }
    //短信提醒所有经办人
    String ids = "";
    String query = "SELECT USER_ID from oa_fl_run_prcs where RUN_ID=" + runId;
    Statement stm = null;
    ResultSet rs = null;
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      while (rs.next()) {
        int userId1 = rs.getInt("USER_ID");
        if (!YHWorkFlowUtility.findId(ids, String.valueOf(userId)) 
            && userId1 != userId) {
          //没有，或者userId
          if (!has || userId1 != flowRun.getBeginUser()) {
            ids += userId1 + ",";
          } 
        }
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    if ((remindFlag&4 ) >0 ) {
      if (!"".equals(ids)){
        YHSmsBack sb = new YHSmsBack();
        sb.setSmsType("41");
        sb.setContent(content);
        sb.setFromId(userId);
        sb.setToId(ids);
        sb.setRemindUrl("/core/funcs/workflow/flowrun/list/print/index.jsp?runId="+runId+"&flowId="+ flowId + "&openFlag=1&width=800&height=600");
        YHSmsUtil.smsBack(conn, sb);
      }
    //短信提醒发起人    } 
    //手机提醒发起人

    if ((remindFlag&0x10)>0) {
      YHMobileSms2Logic ms2l = new YHMobileSms2Logic(); 
      ms2l.remindByMobileSms(conn, String.valueOf(id),userId, content, null);
    }
    //手机提醒所有人
    if ((remindFlag&2)>0) {
      YHMobileSms2Logic ms2l = new YHMobileSms2Logic(); 
      ms2l.remindByMobileSms(conn, ids ,userId, content, null);
    }
  //短信提醒下一步经办人 短信(remindFlag&0x100)>0 邮件(remindFlag&0x40)>0
  //短信提醒发起人 短信(remindFlag&0x20)>0 邮件 (remindFlag&8)>0
 //短信提醒所有经办人 短信(remindFlag&4)>0 邮件 (remindFlag&1)>0
  }
  /**
   * 提醒下一步经办人
   * @param conn
   * @param content
   * @param contextPath
   * @param runId
   * @param userId
   * @param skin 
   * @throws Exception 
   */
  public void remindNext(Connection conn  
      , int runId , int flowId , int prcsId , int flowPrcs
      , String content , String contextPath , String prcsUser , int userId , String sortId, String skin) throws Exception {
    YHSmsBack sb = new YHSmsBack();
    sb.setSmsType("7");
    sb.setContent(content);
    sb.setFromId(userId);
    sb.setToId(prcsUser);
    sb.setRemindUrl("/core/funcs/workflow/flowrun/list/inputform/index.jsp?skin="+skin+"&sortId="+sortId +"&runId=" + runId + "&flowId=" + flowId + "&prcsId=" + prcsId + "&flowPrcs=" + flowPrcs);
    YHSmsUtil.smsBack(conn, sb);
  }
  /**
   * 邮件提醒下一步经办人
   * @param conn
   * @param content
   * @param contextPath
   * @param runId
   * @param userId
   * @throws Exception 
   */
  public void remindNextEmail(Connection conn  , String content , String contextPath , String prcsUser , int userId) throws Exception {
    //YHEmailUtil.emailNotifier(conn, userId, prcsUser, "工作流转交下一步提醒", content, new Date(), important)
  }
  /**
   * 工作流是否删除

   * @param runId
   * @param conn
   * @return
   * @throws Exception
   */
  public boolean hasDelete(int runId , Connection conn) throws Exception{
    String query  = "SELECT DEL_FLAG from oa_fl_run WHERE RUN_ID=" + runId;
    Statement stm = null;
    ResultSet rs = null;
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      if (rs.next()) {
        String delFlag = rs.getString("DEL_FLAG");
        if ("1".equals(delFlag)) {
          return true;
        }
        return false;
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    return false;
  }
  /**
   * 解析宏标记

   * @param flowRun
   * @param ft
   * @param form
   * @param conn
   * @return
   * @throws Exception
   */
  public String analysisAutoFlag (YHFlowRun flowRun , YHFlowType ft , YHFlowFormType form , Connection conn , String imgPath) throws Exception {
    String modelShort = "";
    if (form != null) {
      modelShort = form.getPrintModelShort();
    }
    modelShort = this.analysisAutoFlag(flowRun, ft, form, conn, imgPath, modelShort);
    return modelShort;
  }
  /**
   * 解析宏标记


   * @param flowRun
   * @param ft
   * @param form
   * @param conn
   * @return
   * @throws Exception
   */
  public String analysisAutoFlag (YHFlowRun flowRun , YHFlowType ft , YHFlowFormType form , Connection conn , String imgPath , String modelShort) throws Exception {
    Map map = new HashMap();
    Date beginTime = flowRun.getBeginTime();
    String date = new SimpleDateFormat("yyyy-MM-dd").format(beginTime);
    String time = new SimpleDateFormat("HH:mm:ss").format(beginTime);
    modelShort = modelShort.replaceAll("#\\[表单\\]", "<b>"+form.getFormName()+"</b>");
    String runName = flowRun.getRunName();
    runName = YHWorkFlowUtility.getRunName(runName);
    runName = runName.replace("$", "\\$");
    modelShort = modelShort.replaceAll("#\\[文号\\]", runName);
    modelShort = modelShort.replaceAll("#\\[时间\\]", "日期：" + date);
    modelShort = modelShort.replaceAll("#\\[流水号\\]", flowRun.getRunId() + "");
    modelShort = modelShort.replaceAll("#\\[文号计数器\\]", ft.getAutoNum() + "");
    //---------附件链接宏标记------------------
    YHWorkFlowUtility ut = new YHWorkFlowUtility();
    String flowDoc = ft.getFlowDoc();
    if (!"0".equals(flowDoc) 
        && modelShort.indexOf("#[附件") != -1) {
      modelShort = ut.getAttach(modelShort, flowRun, conn , imgPath);
    }
    if ( modelShort.indexOf("#[会签意见") != -1) {
      modelShort = ut.getSignInfo(modelShort, flowRun, conn);
    }
    return modelShort;
  }
  public void updateRunName(String runName , int runId  ,Connection conn) throws Exception {
    YHORM orm = new YHORM();
    Map map = new HashMap();
    map.put("RUN_ID", runId);
    YHFlowRun flowRun = (YHFlowRun) orm.loadObjSingle(conn, YHFlowRun.class, map);
    flowRun.setRunName(runName);
    orm.updateSingle(conn, flowRun);
  }
  public int getFreeOther(int flowId , Connection conn) throws Exception { 
    int freeOther = 2;
    String query = "select FREE_OTHER from oa_fl_type where SEQ_ID=" + flowId;
    Statement stm = null;
    ResultSet rs = null;
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      if (rs.next()) {
        freeOther = rs.getInt("FREE_OTHER");
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    return freeOther ;
  }
  public void remaindEmail(int flowId  , int prcsId , int runId ,  Connection conn , YHPerson user , String imgPath , String contextPath) throws Exception {
    String query = "SELECT MAIL_TO from oa_fl_process where FLOW_SEQ_ID="+flowId+" and PRCS_ID=" + prcsId;
    Statement stm = null;
    ResultSet rs = null;
    String mailTo = "";
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      if (rs.next()) {
        mailTo = rs.getString("MAIL_TO");
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    if (mailTo != null && !"".equals(mailTo)) {
      Map map = new HashMap();
      map.put("RUN_ID", runId);
      YHFlowRunLogic frl = new YHFlowRunLogic();
      YHFlowRun flowRun = frl.getFlowRunByRunId(runId , conn);
      YHFlowTypeLogic ftl = new YHFlowTypeLogic();
      YHFlowType ft = ftl.getFlowTypeById(flowId, conn);
      String  form = "";
      if (flowRun != null) {
        Map result = frl.getPrintForm(user, flowRun, ft ,true, conn , imgPath ) ;
        form = (String)result.get("form2");
        //form = form.replaceAll("\\\\\"", "\"");
      }
      //处理附件
      YHEmailUtil.emailNotifier(conn, user.getSeqId(), mailTo, flowRun.getRunName(), form, new java.util.Date(), "1" , contextPath , true);
    }
  }
  public boolean canHandlerWrok(int runId , int prcsId , int flowPrcs , int userId , Connection conn) throws Exception {
    boolean flag = false;
    String query  = "SELECT 1 from oa_fl_run_prcs WHERE RUN_ID="+runId+" AND PRCS_ID="+ prcsId +" AND FLOW_PRCS="+ flowPrcs +" and USER_ID="+ userId +" and PRCS_FLAG in(1,2)";
    Statement stm = null;
    ResultSet rs = null;
    try {
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      if (rs.next()) {
        flag = true;
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    return flag;
  }
  public void manageTurnNext(Connection conn ,int runId , int prcsId , int flowPrcs) throws Exception{
    String query  = "SELECT  "
               + " PARENT "
               + " from  "
               + "oa_fl_run_prcs  "
               + " WHERE  "
               + " RUN_ID='"+runId+"' AND  "
               + " PRCS_ID='"+prcsId+"' AND  "
               + " FLOW_PRCS='"+flowPrcs+"'";
    Statement stm = null;
    ResultSet rs = null;
    String parent = "";
    try {//当前步骤如果是子流程的“衔接节点”则PARENT不为空，或者并发流程中记录哪些步骤已转交过来也用PARENT字段
      stm = conn.createStatement();
      rs = stm.executeQuery(query);
      if (rs.next()) {
        parent = rs.getString("PARENT");
      }
    } catch(Exception ex) {
      throw ex;
    } finally {
      YHDBUtility.close(stm, rs, null); 
    }
    int prcsIdPre = prcsId - 1 ;//得到上一步骤的步骤流水号PRCS_ID_PRE
    String query1 = "update   "
      + "   oa_fl_run_prcs   "
      + "  set   "
      + "  PRCS_FLAG='4'   "
      + "    WHERE   "
      + "   RUN_ID='"+runId+"' AND   "
      + "   PRCS_ID='"+prcsIdPre+"'";
    if (!"0".equals(parent) && !YHUtility.isNullorEmpty(parent)) {
      query1 += " and  FLOW_PRCS in ("+parent+") ";//对并发的处理，子流程好像不用加上这一个条件就可以处理好
    }
    YHWorkFlowUtility.updateTableBySql(query1, conn);
  }
  public static void main(String[] args) throws Exception {
    Set set = new HashSet();
    String sss= "3569,3570,3571,3572,3573,3574,3575,3576,3577,3578,3579,3580,3581,3582,3583,3584,3585,3586,3587,3588,3589,3590,3591,3592,3592,3593,3594,3595,3596,3597,3598,3599,3600,3601,3602,3603,3604,3605,3606,3607,3608,3609,3610,3611,3612,3613,3614,3615,3616,3617,3618,3619,3620,3621,3622,3623,3624,3625,3626,3627,3628,3629,3630,3631,3632,3633,3634,3635,3636,3637,3638,3639,3640,3641,3642,3643,3644,3645,3646,3647,3648,3649,3650,3651,3652,3653,3654,3655,3656,3657,3658,3659,3660,3661,3662,3663,3664,3665,3666,3667,3668,3669,3670,3671,3672,3673,3674,3675,3676,3677,3678,3679,3680,3681,3682,3683,3684,3685,3686,3687,3688,3689,3690,3691,3692,3693,3694,3695,3696,3697,3698,3699,3700,3701,3702,3703,3704,3705,3705,3706,3707,3708,3709,3710,3711,3712,3713,3714,3715,3716,3717,3718,3719,3720,3721,3722,3723,3724,3725,3726,3727,3728,3729,3730,3731,3732,3733,3734,3735,3736,3737,3738,3739,3740,3741,3742,3743,3744,3745,3746,3747,3748,3749,3750,3751,3752,3753,3754,3755,3756,3757,3758,3759,3760,3761,3762,3763,3764,3765,3766,3767,3768,3769,3770,3771,3772,3773,3774,3775,3776,3777,3778,3779,3780,3781,3782,3783,3784,3785,3786,3787,3788,3789,3790,3791,3792,3793,3794,3795,3796,3797,3798,3799,3800,3801,3802,3803,3804,3805,3806,3807,3808,3809,3810,3811,3812,3813,3814,3815,3816,3817,3818,3819,3820,3821,3822,3823,3824,3825,3826,3827,3828,3829,3830,3831,3832,3833,3834,3835,3836,3837,3838,3839,3840,3841,3842,3843,3844,3845,3846,3847,3848,3849,3850,3851,3851,3852,3853,3854,3855,3856,3857,3858,3859,3860,3861,3862,3863,3864,3865,3866,3866,3867,3868,3869,3870,3871,3872,3873,3874,3875,3876,3877,3878,3879,3880,3881,3882,3883,3884,3885,3886,3887,3888,3889,3889,3890,3891,3892,3893,3894,3895,3896,3897,3898,3899,3900,3901,3902,3903,3904,3905,3906,3907,3908,3909,3910,3911,3912,3913,3914,3915,3916,3917,3918,3919,3920,3921,3921,3922,3923,3924,3925,3926,3927,3928,3929,3930,3931,3932,3933,3934,3935,3936,3937,3938,3939,3940,3941,3942,3943,3944,3945,3946,3947,3948,3949,3950,3951,3952,3953,3954,3955,3956,3957,3958,3959,3960,3961,3962,3963,3964,3965,3966,3967,3968,3969,3970,3971,3972,3973,3974,3975,3976,3977,3978,3979,3980,3981,3982,3983,3984,3985,3986,3987,3988,3989,3990,3991,3992,3993,3994,3995,3996,3997,3998,3999,4000,4001,4002,4003,4004,4005,4006,4007,4008,4009,4010,4011,4012,4013,4014,4015,4016,4017,4018,4019,4020,4021,4022,4023,4024,4025,4026,4027,4028,4029,4030,4031,4032,4033,4034,4035,4036,4037,4038,4039,4040,4041,4042,4043,4044,4045,4046,4047,4048,4049,4050,4051,4052,4053,4054,4055,4056,4057,4058,4059,4060,4061,4062,4063,4064,4065,4066,4067,4068,4069,4070,4071,4072,4073,4074,4075,4076,4077,4078,4079,4080,4081,4082,4083,4084,4085,4086,4087,4088,4089,4090,4091,4092,4093,4094,4095,4096,4097,4098,4099,4100,4101,4102,4103,4104,4105,4106,4107,4108,4109,4110,4111,4112,4113,4114,4115,4116,4117,4118,4119,4120,4121,4122,4123,4124,4125,4126,4127,4128,4129,4130,4131,4132,4132,4133,4134,4135,4136,4137,4138,4139,4140,4141,4142,4143,4144,4145,4146,4147,4148,4149,4150,4151,4152,4153,4154,4155,4156,4157,4158,4159,4160,4161,4162,4163,4164,4165,4166,4167,4168,4169,4170,4171,4172,4173,4174,4175,4176,4177,4178,4179,4180,4181,4182,4183,4184,4185,4186,4187,4188,4189,4190,4191,4192,4193,4194,4195,4196,4197,4198,4199,4200,4201,4202,4203,4204,4205,4206,4207,4208,4209,4210,4211,4212,4213,4214,4215,4216,4217,4218,4219,4220,4221,4222,4223,4224,4225,4226,4227,4228,4229,4230,4231,4232,4233,4234,4235,4236,4237,4238,4239,4240,4241,4242,4243,4244,4245,4246,4247,4248,4249,4250,4251,4252,4253,4254,4255,4256,4257,4258,4259,4260,4261,4262,4263,4264,4265,4266,4267,4268,4269,4270,4271,4272,4273,4274,4275,4276,4277,4278,4279,4280,4281,4282,4283,4284,4285,4286,4287,4288,4288,4289,4290,4291,4292,4293,4294,4295,4296,4297,4298,4299,4300,4301,4302,4303,4304,4305,4306,4307,4308,4309,4310,4311,4312,4313,4314,4315,4316,4317,4318,4319,4320,4321,4322,4323,4324";
    String[] ss = sss.split(",");
    int count = 0 ;
    for  (String s : ss) {
      if (!"".equals(s)) {
        if (set.contains(s)) {
          System.out.println(s);
        }
        set.add(s);
        count++;
      }
    }
    System.out.println(set.size() + ":" + count);
  
    
  }
  
}
