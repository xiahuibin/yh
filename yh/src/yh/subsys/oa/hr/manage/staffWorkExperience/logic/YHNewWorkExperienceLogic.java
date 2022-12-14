package yh.subsys.oa.hr.manage.staffWorkExperience.logic;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import yh.core.funcs.email.logic.YHInnerEMailUtilLogic;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.sms.data.YHSmsBack;
import yh.core.funcs.sms.logic.YHSmsUtil;
import yh.core.funcs.system.selattach.util.YHSelAttachUtil;
import yh.core.global.YHSysProps;
import yh.core.util.YHUtility;
import yh.core.util.db.YHDBUtility;
import yh.core.util.db.YHORM;
import yh.core.util.file.YHFileUploadForm;
import yh.subsys.oa.book.data.YHPage;
import yh.subsys.oa.hr.manage.hrIdtransName.hrPublicIdTransName;
import yh.subsys.oa.hr.manage.logic.YHHrStaffIncentiveLogic;
import yh.subsys.oa.hr.manage.relatives.data.YHHrStaffRelatives;
import yh.subsys.oa.hr.manage.staffWorkExperience.data.YHHrStaffWorkExperience;
import yh.subsys.oa.hr.manage.staff_license.act.YHNewLicenseInfoAct;
import yh.subsys.oa.hr.manage.staff_license.data.YHHrStaffLicense;

public class YHNewWorkExperienceLogic {
	public static int newLicenseInfo(Connection conn, YHPerson person,
			YHHrStaffLicense license) throws Exception {
		PreparedStatement ps = null;
		ResultSet rs = null;
		int ok = 0;
		String sql = "insert into oa_pm_employee_certificate(CREATE_USER_ID,CREATE_DEPT_ID,STAFF_NAME,LICENSE_TYPE,LICENSE_NO,LICENSE_NAME,NOTIFIED_BODY,GET_LICENSE_DATE"
				+ ",EFFECTIVE_DATE,EXPIRATION_PERIOD,EXPIRE_DATE,STATUS,ATTACHMENT_ID,ATTACHMENT_NAME,REMARK,ADD_TIME) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, license.getCreateUserId());
			ps.setInt(2, license.getCreateDeptId());
			ps.setString(3, license.getStaffName());
			ps.setString(4, license.getLicenseType());
			ps.setString(5, license.getLicenseNo());
			ps.setString(6, license.getLicenseName());
			ps.setString(7, license.getNotifiedBody());
			ps.setDate(8, new java.sql.Date(
					license.getGetLicenseDate() == null ? 0 : license
							.getGetLicenseDate().getTime()));
			ps.setDate(9, new java.sql.Date(
					license.getEffectiveDate() == null ? 0 : license
							.getEffectiveDate().getTime()));
			ps.setString(10, license.getExpirationPeriod());
			ps.setDate(11, new java.sql.Date(
					license.getExpireDate() == null ? 0 : license
							.getExpireDate().getTime()));
			ps.setString(12, license.getStatus());
			ps.setString(13, license.getAttachmentId());
			ps.setString(14, license.getAttachmentName());
			ps.setString(15, license.getRemark());
			ps.setString(16, license.getAddTime());
			ok = ps.executeUpdate();

		} catch (Exception ex) {
			throw ex;
		} finally {
			YHDBUtility.close(ps, rs, null);
		}

		return ok;
	}
  /**
   * ?????????????????? ??????????????????????????????
   * @param dbConn
   * @param fileForm
   * @param person
   * @throws Exception
   */
	/**
	 * @param dbConn
	 * @param fileForm
	 * @param person
	 * @throws Exception
	 */
	public void setNewWordInfoValueLogic(Connection dbConn,
			YHFileUploadForm fileForm, YHPerson person) throws Exception {
		YHORM orm = new YHORM();
		String userName = fileForm.getParameter("userName");
		String userId = fileForm.getParameter("userId");
		String postOfJob = fileForm.getParameter("POST_OF_JOB");//????????????
		String workBranch = fileForm.getParameter("WORK_BRANCH");//????????????
		String witness = fileForm.getParameter("WITNESS");//?????????
		String startDate = fileForm.getParameter("START_DATE");//????????????
		String endDate = fileForm.getParameter("END_DATE");//????????????
		String mobile = fileForm.getParameter("MOBILE");//????????????
		String workUnit = fileForm.getParameter("WORK_UNIT");//????????????
		String workContent = fileForm.getParameter("WORK_CONTENT");//????????????
		String reasonForLeaving = fileForm.getParameter("REASON_FOR_LEAVING");// ????????????
		String remark = fileForm.getParameter("REMARK");//??????
		String keyPerformance = fileForm.getParameter("incentiveDescription");//????????????
		try {
			Map<Object, Object> map = this.fileUploadLogic(fileForm,
					YHNewLicenseInfoAct.attachmentFolder);
			boolean attachFlag = (Boolean) map.get("attachFlag");
			String attachmentIds = (String) map.get("attachmentIds");
			String attachmentNames = (String) map.get("attachmentNames");
            
			YHHrStaffWorkExperience work = new YHHrStaffWorkExperience();
			work.setStaffName(userId);
			work.setPostOfJob(postOfJob);
			work.setWorkBranch(workBranch);
			work.setWitness(witness);
			if (!YHUtility.isNullorEmpty(startDate)) {
				work.setStartDate(YHUtility.parseDate("yyyy-MM-dd",
						startDate));
			}
			if (!YHUtility.isNullorEmpty(endDate)) {
				work.setEndDate(YHUtility.parseDate("yyyy-MM-dd",
						endDate));
			}
			work.setMobile(mobile);
			work.setWorkUnit(workUnit);
			work.setWorkContent(workContent);
			work.setReasonForLeaving(reasonForLeaving);
			work.setRemark(remark);
			
			if (attachFlag) {
				work.setAttachmentId(attachmentIds);
				work.setAttachmentName(attachmentNames);
			}
			work.setKeyPerformance(keyPerformance);//????????????
			Date currentTime = new Date();    
		    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");    
		    String dateString = formatter.format(currentTime); 
		    work.setAddTime(dateString);
			work.setCreateUserId(String.valueOf(person.getSeqId()));
			work.setCreateDeptId(person.getDeptId());
			orm.saveSingle(dbConn, work);
		} catch (Exception e) {
			throw e;
		}
         
	}
	/**
	 * ?????????????????? ??????????????????????????????
	 * @param dbConn
	 * @param fileForm
	 * @param person
	 * @throws Exception
	 */
	public void setUpWorkInfoValueLogic(Connection dbConn,
			YHFileUploadForm fileForm, YHPerson person) throws Exception {
		YHORM orm = new YHORM();
		String seqId = fileForm.getParameter("seqid");
		String userName = fileForm.getParameter("userName");
		String userId = fileForm.getParameter("userId");
		String postOfJob = fileForm.getParameter("POST_OF_JOB");//????????????
		String workBranch = fileForm.getParameter("WORK_BRANCH");//????????????
		String witness = fileForm.getParameter("WITNESS");//?????????
		String startDate = fileForm.getParameter("START_DATE");//????????????
		String endDate = fileForm.getParameter("END_DATE");//????????????
		String mobile = fileForm.getParameter("MOBILE");//????????????
		String workUnit = fileForm.getParameter("WORK_UNIT");//????????????
		String workContent = fileForm.getParameter("WORK_CONTENT");//????????????
		String reasonForLeaving = fileForm.getParameter("REASON_FOR_LEAVING");// ????????????
		String remark = fileForm.getParameter("REMARK");//??????
		String keyPerformance = fileForm.getParameter("incentiveDescription");//????????????
		try {
			Map<Object, Object> map = this.fileUploadLogic(fileForm,
					YHNewLicenseInfoAct.attachmentFolder);
			boolean attachFlag = (Boolean) map.get("attachFlag");
			String attachmentIds = (String) map.get("attachmentIds");
			String attachmentNames = (String) map.get("attachmentNames");
            
			YHHrStaffWorkExperience work = new YHHrStaffWorkExperience();
			work.setSeqId(Integer.valueOf(seqId));
			work.setStaffName(userId);
			work.setPostOfJob(postOfJob);
			work.setWorkBranch(workBranch);
			work.setWitness(witness);
			if (!YHUtility.isNullorEmpty(startDate)) {
				work.setStartDate(YHUtility.parseDate("yyyy-MM-dd",
						startDate));
			}
			if (!YHUtility.isNullorEmpty(endDate)) {
				work.setEndDate(YHUtility.parseDate("yyyy-MM-dd",
						endDate));
			}
			work.setMobile(mobile);
			work.setWorkUnit(workUnit);
			work.setWorkContent(workContent);
			work.setReasonForLeaving(reasonForLeaving);
			work.setRemark(remark);
			
			if (attachFlag) {
				work.setAttachmentId(attachmentIds);
				work.setAttachmentName(attachmentNames);
			}
			work.setKeyPerformance(keyPerformance);//????????????
			Date currentTime = new Date();    
		    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");    
		    String dateString = formatter.format(currentTime); 
		    work.setAddTime(dateString);
			work.setCreateUserId(String.valueOf(person.getSeqId()));
			work.setCreateDeptId(person.getDeptId());
			//orm.save(dbConn, work);
		    orm.updateSingle(dbConn, work);

		} catch (Exception e) {
			throw e;
		}

	}
	/**
	 * ?????????????????????????????????id???????????????--wyw
	 * 
	 * @param fileForm
	 * @return
	 * @throws Exception
	 */
	public Map<Object, Object> fileUploadLogic(YHFileUploadForm fileForm,
			String attachmentFolder) throws Exception {
		Map<Object, Object> result = new HashMap<Object, Object>();
		try {
			// ?????????????????????????????????????????????
			YHSelAttachUtil sel = new YHSelAttachUtil(fileForm,
					attachmentFolder);
			String attIdStr = sel.getAttachIdToString(",");
			String attNameStr = sel.getAttachNameToString("*");
			boolean fromFolderFlag = false;
			String forlderAttchId = "";
			String forlderAttchName = "";
			if (!"".equals(attIdStr) && !"".equals(attNameStr)) {
				forlderAttchId = attIdStr + ",";
				forlderAttchName = attNameStr + "*";
				fromFolderFlag = true;
			}
			Iterator<String> iKeys = fileForm.iterateFileFields();
			boolean uploadFlag = false;
			String uploadAttchId = "";
			String uploadAttchName = "";
			Date date = new Date();
			SimpleDateFormat format = new SimpleDateFormat("yyMM");
			String currDate = format.format(date);
			String separator = File.separator;
			String filePath = YHSysProps.getAttachPath() + separator
					+ attachmentFolder + separator + currDate;

			while (iKeys.hasNext()) {
				String fieldName = iKeys.next();
				String fileName = fileForm.getFileName(fieldName);
				if (YHUtility.isNullorEmpty(fileName)) {
					continue;
				}
				YHInnerEMailUtilLogic emul = new YHInnerEMailUtilLogic();
				String rand = emul.getRandom();
				uploadAttchId += currDate + "_" + rand + ",";
				uploadAttchName += fileName + "*";
				uploadFlag = true;

				fileName = rand + "_" + fileName;
				fileForm.saveFile(fieldName, filePath + File.separator + fileName);
			}
			boolean attachFlag = false;
			String attachmentIds = "";
			String attachmentNames = "";
			if (fromFolderFlag && uploadFlag) {
				attachmentIds = forlderAttchId + uploadAttchId;
				attachmentNames = forlderAttchName + uploadAttchName;
				attachFlag = true;
			} else if (fromFolderFlag) {
				attachmentIds = forlderAttchId;
				attachmentNames = forlderAttchName;
				attachFlag = true;
			} else if (uploadFlag) {
				attachmentIds = uploadAttchId;
				attachmentNames = uploadAttchName;
				attachFlag = true;
			}
			result.put("attachFlag", attachFlag);
			result.put("attachmentIds", attachmentIds);
			result.put("attachmentNames", attachmentNames);
		} catch (Exception e) {
			throw e;
		}
		return result;
	}

	/*
	 * ?????????????????????
	 */
	public int count(Connection dbConn, YHPerson user) throws Exception {
    YHHrStaffIncentiveLogic logic = new YHHrStaffIncentiveLogic();
    String deptIdStr = logic.getHrManagerPriv(dbConn, user);
	  
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = " select COUNT(*) from oa_pm_employee_experience"
               + " where CREATE_USER_ID = "+ user.getSeqId()
               + " or CREATE_DEPT_ID in "+ deptIdStr;
		try {
			ps = dbConn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			YHDBUtility.close(ps, rs, null);
		}
		return 0;

	}

	/**
	 * ??????????????????????????????
	 * 
	 * @param dbConn
	 * @param user
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<YHHrStaffWorkExperience> findWorkExperienceInfo(Connection dbConn, YHPerson user,	YHPage page) throws Exception {
    YHHrStaffIncentiveLogic logic = new YHHrStaffIncentiveLogic();
    String deptIdStr = logic.getHrManagerPriv(dbConn, user);
	  
		PreparedStatement ps = null;
		ResultSet rs = null;
		String workSql = " select SEQ_ID,STAFF_NAME,WORK_UNIT,MOBILE,POST_OF_JOB,WITNESS " 
		               + " from oa_pm_employee_experience "
		               + " where CREATE_USER_ID = "+ user.getSeqId()
		               + " or CREATE_DEPT_ID in "+ deptIdStr
		               + " order by SEQ_ID desc";
		List<YHHrStaffWorkExperience> work = new ArrayList<YHHrStaffWorkExperience>();
		try {
			ps = dbConn.prepareStatement(workSql,	ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ps.setMaxRows(page.getCurrentPageIndex() * page.getPageSize());// ????????????????????????????????????
			rs = ps.executeQuery();
			rs.first();// ???????????????????????????????????????
			rs.relative((page.getCurrentPageIndex() - 1) * page.getPageSize() - 1);// ????????????????????????????????????
			while (rs.next()) {
				YHHrStaffWorkExperience workEx = new YHHrStaffWorkExperience();
				workEx.setSeqId(rs.getInt("SEQ_ID"));
				workEx.setStaffName(hrPublicIdTransName.getUserName(dbConn, Integer.valueOf(rs.getString("STAFF_NAME"))));
				workEx.setWorkUnit(rs.getString("WORK_UNIT"));
				workEx.setMobile(rs.getString("MOBILE"));
				workEx.setPostOfJob(rs.getString("POST_OF_JOB"));
				workEx.setWitness(rs.getString("WITNESS"));
				work.add(workEx);
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			YHDBUtility.close(ps, rs, null);
		}
		return work;
	}

	/**
	 * ?????????????????????????????????
	 * 
	 * @param dbConn
	 * @param user
	 * @param ContractSeqId
	 * @return
	 * @throws Exception
	 */

	public List<YHHrStaffWorkExperience> workXxInfo(Connection dbConn, YHPerson user,
			int workSeqId) throws Exception {
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		 List<YHHrStaffWorkExperience> work = new ArrayList<YHHrStaffWorkExperience>();
		    YHORM orm =new YHORM();
		try {
			YHHrStaffWorkExperience sle= (YHHrStaffWorkExperience) orm.loadObjSingle(dbConn, YHHrStaffWorkExperience.class, workSeqId);
			work.add(sle);
			
		} catch (SQLException e) {
			throw e;
		} finally {
			YHDBUtility.close(ps, rs, null);
		}
		return work;
	}

	/**
	 * ?????????????????????????????????
	 * 
	 * @param conn
	 * @param person
	 * @param noHiddenId
	 * @return
	 * @throws Exception
	 */
	public static int delWorkExInfo(Connection conn, YHPerson person,
			int noHiddenId) throws Exception {
		PreparedStatement ps = null;
		ResultSet rs = null;
		int ok = 0;
		String deleteSql = "delete from oa_pm_employee_experience where seq_id ="
				+ noHiddenId;

		try {
			ps = conn.prepareStatement(deleteSql);
			ok = ps.executeUpdate();
		} catch (Exception ex) {
			throw ex;
		} finally {
			YHDBUtility.close(ps, rs, null);
		}

		return ok;
	}

	/**
	 * ?????????????????????????????????
	 * 
	 * @param dbConn
	 * @param loginperson
	 * @param deleteStr
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	public int deleteWorkExInfo(Connection dbConn, String deleteStr)
			throws IOException, Exception {
		String deletenewsCommentSql = "";
		String deletenewsSql = "";
		Statement stmt = null;
		ResultSet rs = null;

		if (!YHUtility.isNullorEmpty(deleteStr)) {
			String[] deleteStrs = deleteStr.split(",");
			deleteStr = "";
			for (int i = 0; i < deleteStrs.length; i++) {
				deleteStr += deleteStrs[i] + ",";
			}
			deleteStr = deleteStr.substring(0, deleteStr.length() - 1);
		}
		int success = 0;
		try {
			stmt = dbConn.createStatement();
			deletenewsCommentSql = "delete  from oa_pm_employee_experience  where seq_id in  ("
					+ deleteStr + ")";
			success = stmt.executeUpdate(deletenewsCommentSql);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			YHDBUtility.close(stmt, rs, null);
		}
		return success;
	}

	/**
	 * ????????????????????????????????????????????????
	 * ???????????????????????????
	 * @param dbConn
	 * @param user
	 * @param page
	 * @param contract
	 * @param makeContract1
	 * @param makeContract2
	 * @param trailOverTime1
	 * @param trailOverTime2
	 * @param contractEndTime1
	 * @param contractEndTime2
	 * @return
	 * @throws Exception
	 */
	public int workCount(Connection dbConn, YHPerson user, YHHrStaffWorkExperience work) throws Exception {
    YHHrStaffIncentiveLogic logic = new YHHrStaffIncentiveLogic();
    String deptIdStr = logic.getHrManagerPriv(dbConn, user);
	  
		PreparedStatement ps = null;
		ResultSet rs = null;
		String conditionStr = "";
		List<YHHrStaffWorkExperience> workEx = new ArrayList<YHHrStaffWorkExperience>();
		try {
			if (!YHUtility.isNullorEmpty(work.getStaffName())) {
				conditionStr = " and STAFF_NAME ='"
						+ YHDBUtility.escapeLike(work.getStaffName()) + "'";
			}

			if (!YHUtility.isNullorEmpty(work.getPostOfJob())) {
				conditionStr += " and POST_OF_JOB ='"
						+ YHDBUtility.escapeLike(work.getPostOfJob())
						+ "'";
			}
			if (!YHUtility.isNullorEmpty(work.getWorkUnit())) {
				conditionStr += " and WORK_UNIT ='"
						+ YHDBUtility.escapeLike(work.getWorkUnit()) + "'";
			}
			if (!YHUtility.isNullorEmpty(work.getMobile())) {
				conditionStr += " and MOBILE ='"
						+ YHDBUtility.escapeLike(work.getMobile())
						+ "'";
			}
			if (!YHUtility.isNullorEmpty(work.getWorkContent())) {
				conditionStr += " and WORK_CONTENT ='"
						+ YHDBUtility.escapeLike(work.getWorkContent()) + "'";
			}
			if (!YHUtility.isNullorEmpty(work.getKeyPerformance())) {
				conditionStr += " and KEY_PERFORMANCE ='"
						+ YHDBUtility.escapeLike(work.getKeyPerformance()) + "'";
			}
			String sql = " select COUNT(*) from oa_pm_employee_experience "
					       + " where (CREATE_USER_ID = "+ user.getSeqId()
                 + " or CREATE_DEPT_ID in "+ deptIdStr + ")" 
					       + conditionStr;
			
			ps = dbConn.prepareStatement(sql);
      rs = ps.executeQuery();      
      if(rs.next()){
        return rs.getInt(1);
      }
		} catch (SQLException e) {
			throw e;
		} finally {
			YHDBUtility.close(ps, rs, null);
		}
		return 0;

	}
	  /**
     * ????????????????????????????????????????????????
     * @param dbConn
     * @param user
     * @param page
     * @param contract
     * @param makeContract1
     * @param makeContract2
     * @param trailOverTime1
     * @param trailOverTime2
     * @param contractEndTime1
     * @param contractEndTime2
     * @return
     * @throws Exception
     */
    public List<YHHrStaffWorkExperience> queryWorkExInfo(Connection dbConn,YHPerson user, YHPage page,YHHrStaffWorkExperience work) throws Exception{
      YHHrStaffIncentiveLogic logic = new YHHrStaffIncentiveLogic();
      String deptIdStr = logic.getHrManagerPriv(dbConn, user);
      
      PreparedStatement ps = null;
      ResultSet rs = null;
      String conditionStr = "";
      List<YHHrStaffWorkExperience> works = new ArrayList<YHHrStaffWorkExperience>();
      try{//sql += " and ACTIVE_CONTENT like '%" +  YHUtility.encodeLike(activeContent) + "%' " + YHDBUtility.escapeLike();
        	
      	if (!YHUtility.isNullorEmpty(work.getStaffName())) {
      	  conditionStr = " and STAFF_NAME like '%" + YHDBUtility.escapeLike(work.getStaffName()) + "%' " + YHDBUtility.escapeLike();
      	}
  			if (!YHUtility.isNullorEmpty(work.getWorkUnit())) {
  				conditionStr += " and WORK_UNIT like '%" + YHDBUtility.escapeLike(work.getWorkUnit())+ "%' " + YHDBUtility.escapeLike();
  			}
  			if (!YHUtility.isNullorEmpty(work.getMobile())) {
  				conditionStr += " and MOBILE like '%" + YHDBUtility.escapeLike(work.getMobile()) + "%' " + YHDBUtility.escapeLike();
  			}
  			if (!YHUtility.isNullorEmpty(work.getPostOfJob())) {
  				conditionStr += " and POST_OF_JOB like '%" + YHDBUtility.escapeLike(work.getPostOfJob()) + "%' " + YHDBUtility.escapeLike();
  			}
  			if (!YHUtility.isNullorEmpty(work.getWitness())) {
  				conditionStr += " and WITNESS like '%" + YHDBUtility.escapeLike(work.getWitness()) + "%' " + YHDBUtility.escapeLike();
  			}
			
			
  			String workSql = " select SEQ_ID,STAFF_NAME,WORK_UNIT,MOBILE,POST_OF_JOB,WITNESS from oa_pm_employee_experience "
                       + " where (CREATE_USER_ID = "+ user.getSeqId()
                       + " or CREATE_DEPT_ID in "+ deptIdStr + ")" 
                       + conditionStr;
  		  ps = dbConn.prepareStatement(workSql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
        ps.setMaxRows(page.getCurrentPageIndex() * page.getPageSize());//????????????????????????????????????  
        rs = ps.executeQuery();
        rs.first();//???????????????????????????????????????
        rs.relative((page.getCurrentPageIndex()-1) * page.getPageSize() -1);//????????????????????????????????????       
        while(rs.next()){
          YHHrStaffWorkExperience workEx = new YHHrStaffWorkExperience();
    	    workEx.setSeqId(rs.getInt("SEQ_ID"));
    			workEx.setStaffName(hrPublicIdTransName.getUserName(dbConn, Integer.valueOf(rs.getString("STAFF_NAME"))));
    			workEx.setWorkUnit(rs.getString("WORK_UNIT"));
    			workEx.setMobile(rs.getString("MOBILE"));
    			workEx.setPostOfJob(rs.getString("POST_OF_JOB"));
    			workEx.setWitness(rs.getString("WITNESS"));
    			works.add(workEx);
        }
      } catch (SQLException e){
        throw e;
      }finally{
        YHDBUtility.close(ps, rs, null);
      }    
       return works;
   }
	
	
	/**
	 * ??????????????????
	 * @param user
	 * @param dbConn
	 * @param content
	 * @param url
	 * @param toId
	 * @param date
	 * @throws Exception
	 */
	 public static void sendSms(YHPerson user, Connection dbConn,String content, 
		      String url, String toId, Date date) throws Exception{
		    YHSmsBack smsBack = new YHSmsBack();    
		    smsBack.setContent(content);
		    smsBack.setFromId(user.getSeqId());
		    smsBack.setRemindUrl(url);
		    smsBack.setSmsType("0");
		    smsBack.setToId(toId);    
		    if(date != null){
		      smsBack.setSendDate(date);
		    }
		    YHSmsUtil.smsBack(dbConn, smsBack);
		  }
	 //id ?????????name
	 public String getUserName(Connection dbConn, int seqId) throws Exception{ 
		 String sql = "select USER_NAME from person dr where dr.SEQ_ID=" + seqId; 
		 PreparedStatement ps = null; 
		 ResultSet rs = null; 
		 try{ 
				 ps = dbConn.prepareStatement(sql); 
				 rs = ps.executeQuery(); 
			 if(rs.next()){ 
			   return rs.getString("USER_NAME"); 
			 } 
		 } catch (Exception e){ 
		     throw e; 
		 }finally{ 
		     YHDBUtility.close(ps, null, null); 
		 } 
		     return null; 
	 }
	 
	  /**
	   * ??????????????????
	   * 
	   * @param dbConn
	   * @param seqIdStr
	   * @param attachId
	   * @return
	   * @throws Exception
	   */
	  public boolean updateFloadFile(Connection dbConn, String seqIdStr, String attachId) throws Exception {
	    boolean returnFlag = false;
	    YHORM orm = new YHORM();
	    int seqId = 0;
	    if (!YHUtility.isNullorEmpty(seqIdStr)) {
	      seqId = Integer.parseInt(seqIdStr);
	    }
	    try {
	      YHHrStaffWorkExperience staffWorkExperience = (YHHrStaffWorkExperience) orm.loadObjSingle(dbConn, YHHrStaffWorkExperience.class, seqId);
	      String dbAttachId = "";
	      String dbAttachName = "";
	      if (staffWorkExperience != null) {
	        dbAttachId = YHUtility.null2Empty(staffWorkExperience.getAttachmentId());
	        dbAttachName = YHUtility.null2Empty(staffWorkExperience.getAttachmentName());
	        String[] dbAttachIdArrays = dbAttachId.split(",");
	        String[] dbAttachNameArrays = dbAttachName.split("\\*");
	        String attachmentId = "";
	        String attachmentName = "";
	        if (!YHUtility.isNullorEmpty(attachId) && dbAttachIdArrays.length > 0) {
	          for (int i = 0; i < dbAttachIdArrays.length; i++) {
	            if (attachId.equals(dbAttachIdArrays[i])) {
	              continue;
	            }
	            attachmentId += dbAttachIdArrays[i] + ",";
	            attachmentName += dbAttachNameArrays[i] + "*";
	          }
	          staffWorkExperience.setAttachmentId(attachmentId.trim());
	          staffWorkExperience.setAttachmentName(attachmentName.trim());
	          orm.updateSingle(dbConn, staffWorkExperience);
	          returnFlag = true;
	        }
	      }
	    } catch (Exception e) {
	      throw e;
	    }
	    return returnFlag;
	  }

}
