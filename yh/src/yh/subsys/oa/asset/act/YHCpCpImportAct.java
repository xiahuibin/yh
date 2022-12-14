package yh.subsys.oa.asset.act;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import yh.core.data.YHDbRecord;
import yh.core.data.YHRequestDbConn;
import yh.core.funcs.jexcel.util.YHCSVUtil;
import yh.core.funcs.jexcel.util.YHJExcelUtil;
import yh.core.global.YHActionKeys;
import yh.core.global.YHBeanKeys;
import yh.core.global.YHConst;
import yh.core.util.YHUtility;
import yh.core.util.file.YHFileUploadForm;
import yh.subsys.oa.asset.data.YHCpAssetType;
import yh.subsys.oa.asset.data.YHCpCptlInfo;
import yh.subsys.oa.asset.data.YHCpCptlRecord;
import yh.subsys.oa.asset.data.YHCpcptl;
import yh.subsys.oa.asset.logic.YHCpAssetTypeLogic;
import yh.subsys.oa.asset.logic.YHCpCptlRecordLogic;
public class YHCpCpImportAct {

  public String importAsset (HttpServletRequest request,HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    PreparedStatement stmt = null;
    InputStream is = null;
    int num = 0;
    int numOne = 0;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
      .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHFileUploadForm fileForm = new YHFileUploadForm();
      fileForm.parseUploadRequest(request);
      is = fileForm.getInputStream();
      ArrayList<YHDbRecord> drl = YHCSVUtil.CVSReader(is, YHConst.CSV_FILE_CODE);
      SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
      SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");
      String newDate = sf.format(new Date());
      numOne = drl.size();
      for (int i = 0; i < drl.size(); i++) {
        YHDbRecord rd = new YHDbRecord();
        rd = drl.get(i);
        String cptlNo = (String)rd.getValueByName("????????????");
        String cptlName = (String)rd.getValueByName("????????????");
        String cptlVal = (String)rd.getValueByName("?????????");
        String cptlSpec = (String)rd.getValueByName("????????????");
        String listDate = (String)rd.getValueByName("????????????");
        String safekeeping = (String)rd.getValueByName("????????????");
        String remark = (String)rd.getValueByName("??????");
        if (YHUtility.isNullorEmpty(listDate)) {
          listDate = sd.format(new Date());
        }
        else{
          listDate = listDate.replaceAll("/", "-");
        }
        YHCpAssetType type = YHCpAssetTypeLogic.cptlSpec(dbConn,cptlSpec);
        if (type == null) {
          YHCpAssetType typeName = new YHCpAssetType();
          typeName.setTypeName(cptlSpec);
          typeName.setTypeNo(0);
          YHCpAssetTypeLogic.addType(dbConn,typeName);
          int seqId = YHCpAssetTypeLogic.getMaxSeqId(dbConn);
          cptlSpec = String.valueOf(seqId);
        }else {
          cptlSpec = String.valueOf(type.getSeqId());
        }
        String nameVlue = "'" + cptlNo + "','" + cptlName + "'," + cptlVal + ",'" + cptlSpec + "'";
        String sql = "insert into oa_asset_info "
          + "(CPTL_NO,CPTL_NAME,CPTL_VAL,CPTL_SPEC,LIST_DATE,CREATE_DATE,safekeeping,remark) values (" + nameVlue + ",?,?,'"+ safekeeping +"','"+ remark +"')";
        stmt = dbConn.prepareStatement(sql);
        stmt.setDate(1,java.sql.Date.valueOf(listDate));
        stmt.setDate(2,java.sql.Date.valueOf(newDate));
        stmt.executeUpdate();//??????SQL
        num ++;
      }
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "?????????????????????");
    } catch (Exception e) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????");
      throw e;
    }
    return "/subsys/oa/asset/manage/mgs.jsp?num=" + num + "&numOne=" + numOne;
  }
//??????????????????
  public String importProduct (HttpServletRequest request,HttpServletResponse response) throws Exception{
//	    Connection dbConn = null;
//	    PreparedStatement stmt = null;
//	    InputStream is = null;
//	    int num = 0;
//	    int numOne = 0;
//	    try {
//	      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
//	      .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
//	      dbConn = requestDbConn.getSysDbConn();
//	      YHFileUploadForm fileForm = new YHFileUploadForm();
//	      fileForm.parseUploadRequest(request);
//	      is = fileForm.getInputStream();
//	      ArrayList<YHDbRecord> drl = YHCSVUtil.CVSReader(is, YHConst.CSV_FILE_CODE);
//	      numOne = drl.size();
//	      for (int i = 0; i < drl.size(); i++) {
//	        YHDbRecord rd = new YHDbRecord();
//	        rd = drl.get(i);
//	        String proCode = (String)rd.getValueByName("????????????");
//	        String proName = (String)rd.getValueByName("????????????");
//	        String proType = (String)rd.getValueByName("????????????");
//	        String price = (String)rd.getValueByName("????????????");
//	        String unitName = (String)rd.getValueByName("????????????");
//	        String type = (String)rd.getValueByName("??????");
//	        String style = (String)rd.getValueByName("????????????");
//	        String remark = (String)rd.getValueByName("??????");
//	        String param="'"+proCode+"','"+proName+"','"+proType+"',"+price+",'"+unitName+"','"+type+"','"+style+"','"+remark+"'";
//	        HypyUtil hu=new HypyUtil();
//	        String shortName=hu.cn2py(proName);
//	        String proId=UUID.randomUUID().toString();
//	        String sql="insert into  erp_product(id,pro_code,pro_name,pro_type,pro_price,unit_id,ps_id,pt_id,remark,shortName) values('"+proId+"',"+param+",'"+shortName+"')";
//	        stmt = dbConn.prepareStatement(sql);
//	        stmt.executeUpdate();//??????SQL
//	        num ++;
//	      }
//	      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
//	      request.setAttribute(YHActionKeys.RET_MSRG, "?????????????????????");
//	    } catch (Exception e) {
//	      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
//	      request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????");
//	      throw e;
//	    }
//	    return "/subsys/oa/asset/manage/mgs.jsp?num=" + num + "&numOne=" + numOne;
	  return null;
	  }
  /**
   * ??????CSV??????
   * 
   * @param request
   * @param response
   * @return
   * @throws Exception
   */
  public String downCSVTemplet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    response.setCharacterEncoding(YHConst.CSV_FILE_CODE);
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request.getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();

      String fileName = URLEncoder.encode("??????????????????.csv", "UTF-8");
      fileName = fileName.replaceAll("\\+", "%20");
      response.setHeader("Cache-control", "private");
      response.setContentType("application/vnd.ms-excel");
      response.setHeader("Accept-Ranges", "bytes");
      response.setHeader("Cache-Control","maxage=3600");
      response.setHeader("Pragma","public");
      response.setHeader("Content-disposition", "attachment; filename=\"" + fileName + "\"");
      ArrayList<YHDbRecord> dbL = new ArrayList<YHDbRecord>();
      YHDbRecord record = new YHDbRecord();
      record.addField("????????????", "");
      record.addField("????????????", "");
      record.addField("?????????", "");
      record.addField("????????????", "");
      record.addField("????????????", "");
      record.addField("????????????", "");
      record.addField("??????", "");
      dbL.add(record);
      YHCSVUtil.CVSWrite(response.getWriter(), dbL);
    } catch (Exception ex) {
      ex.printStackTrace();
      throw ex;
    }
    return null;
  }


  public String outAsset (HttpServletRequest request,HttpServletResponse response) throws Exception{
    Connection dbConn = null;
    try {
      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
      .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
      dbConn = requestDbConn.getSysDbConn();
      YHCpCptlInfo cptlInfo = new YHCpCptlInfo();
      YHCpCptlRecord cptlRecord = new YHCpCptlRecord();
      YHCpCptlRecordLogic recordLogic = new YHCpCptlRecordLogic();

      String cpreFlag = request.getParameter("CPRE_FLAG");
      String cptlName = request.getParameter("CPTL_NAME");
      String cptlSpec = request.getParameter("CPTL_SPEC");
      String deptId2 = request.getParameter("DEPT_ID");
      String typeId = request.getParameter("TYPE_ID");
      String useFor = request.getParameter("USE_FOR"); 
      String useState = request.getParameter("USE_STATE");
      String useUser = request.getParameter("USE_USER");

      int deptId = 0;
      if (!YHUtility.isNullorEmpty(deptId2)) {
        deptId = Integer.parseInt(deptId2);
        cptlRecord.setDeptId(deptId);
      }
      cptlRecord.setCpreFlag(cpreFlag);
      cptlInfo.setCptlName(cptlName);
      cptlInfo.setCptlSpec(cptlSpec);
      cptlInfo.setTypeId(typeId);
      cptlInfo.setUseFor(useFor);
      cptlInfo.setUseState(useState);
      cptlInfo.setUseUser(useUser);

      List<YHCpcptl> list = recordLogic.importOut(dbConn,cptlInfo,cptlRecord);

      OutputStream ops = null;
      String fileName = URLEncoder.encode("???????????????????????????.xls","UTF-8");
      fileName = fileName.replaceAll("\\+", "%20");
      response.setHeader("Cache-control","private");
      response.setContentType("application/vnd.ms-excel");
      response.setHeader("Accept-Ranges","bytes");
      response.setHeader("Cache-Control","maxage=3600");
      response.setHeader("Pragma","public");
      response.setHeader("Content-disposition","attachment; filename=\"" + fileName + "\"");
      ops = response.getOutputStream();
      YHCpCptlRecordLogic expl = new YHCpCptlRecordLogic();
      ArrayList<YHDbRecord > dbL = expl.getDbRecord(list);
      YHJExcelUtil.writeExc(ops, dbL);
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_OK);
      request.setAttribute(YHActionKeys.RET_MSRG, "?????????????????????");
    } catch (Exception e) {
      request.setAttribute(YHActionKeys.RET_STATE, YHConst.RETURN_ERROR);
      request.setAttribute(YHActionKeys.RET_MSRG, "??????????????????");
      throw e;
    }
    return null;
  }
}

