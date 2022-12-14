package yh.core.funcs.filefolder.logic;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
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
import java.util.Set;

import org.apache.log4j.Logger;

import yh.core.funcs.email.logic.YHInnerEMailUtilLogic;
import yh.core.funcs.filefolder.data.YHFileContent;
import yh.core.funcs.mobilesms.logic.YHMobileSms2Logic;
import yh.core.funcs.office.ntko.logic.YHNtkoLogic;
import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.portal.util.YHPortalProducer;
import yh.core.funcs.portal.util.rules.YHImgRule;
import yh.core.funcs.portal.util.rules.YHLinkRule;
import yh.core.funcs.sms.data.YHSmsBack;
import yh.core.funcs.sms.logic.YHSmsUtil;
import yh.core.funcs.system.filefolder.data.YHFileSort;
import yh.core.funcs.system.filefolder.logic.YHFileSortLogic;
import yh.core.funcs.system.syslog.logic.YHSysLogLogic;
import yh.core.global.YHConst;
import yh.core.global.YHLogConst;
import yh.core.global.YHSysPropKeys;
import yh.core.global.YHSysProps;
import yh.core.util.YHUtility;
import yh.core.util.db.YHDBUtility;
import yh.core.util.db.YHORM;
import yh.core.util.file.YHFileUploadForm;
import yh.core.util.file.YHFileUtility;

public class YHFileContentLogic {
	private static Logger log = Logger.getLogger(YHFileContentLogic.class);
	public static String COPYPATH = File.separator + "core" + File.separator + "funcs" + File.separator + "filefolder" + File.separator + "fileUtil";

	public List<YHFileContent> getFileContentsInfo(Connection dbConn, Map map) throws Exception {
		YHORM orm = new YHORM();
		return orm.loadListSingle(dbConn, YHFileContent.class, map);

	}

	public List<YHFileContent> getFileContentsByFilters(Connection dbConn, String[] filters) throws Exception {
		YHORM orm = new YHORM();
		return orm.loadListSingle(dbConn, YHFileContent.class, filters);

	}

	public void saveSingleObj(Connection dbConn, YHFileContent fileContent) throws Exception {
		YHORM orm = new YHORM();
		orm.saveSingle(dbConn, fileContent);
	}

	public String createFile(String fileType, String fileName, String webrootPath) throws Exception {
		SimpleDateFormat format = new SimpleDateFormat("yyMM");
		String currDate = format.format(new Date());
		String separator = File.separator;
		String filePath = YHSysProps.getAttachPath() + separator + "file_folder" + separator + currDate + separator;

		YHInnerEMailUtilLogic emut = new YHInnerEMailUtilLogic();
		String rand = emut.getRandom();
		String newFileName = rand + "_" + fileName + "." + fileType;
		String tmp = filePath + newFileName;

		String type = fileType.trim();
		if ("xls".equals(type)) {
			String srcFile = webrootPath + this.COPYPATH + File.separator + "copy.xls";
			YHFileUtility.copyFile(srcFile, tmp);
		} else if ("ppt".equals(type)) {
			String srcFile = webrootPath + this.COPYPATH + File.separator + "copy.ppt";
			YHFileUtility.copyFile(srcFile, tmp);
		} else if ("doc".equals(type)) {
			String srcFile = webrootPath + this.COPYPATH + File.separator + "copy.doc";
			YHFileUtility.copyFile(srcFile, tmp);
		} else {
			File file = new File(filePath);
			if (!file.exists()) {
				file.mkdirs();
			}
			String createPath = file.getPath().replace("\\", "/");
			File createFile = new File(createPath + "/" + newFileName);
			createFile.createNewFile();
		}

		return rand;

	}

	/**
	 * ??????????????????
	 */
	public String uploadFileLogic(Connection dbConn, YHFileContent content, YHFileUploadForm fileForm,YHPerson loginUser,String seqId,String remoteAddr,String filePath) throws Exception {
		YHORM orm = new YHORM();
		// ????????????????????????
		int loginUserSeqId = loginUser.getSeqId();
		int loginUserDeptId = loginUser.getDeptId();
		String loginUserRoleId = loginUser.getUserPriv();

		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyMM");
		String currDate = format.format(date);
		int sortId = 0;
		if (seqId != null) {
			sortId = Integer.parseInt(seqId);
		}
		String smsPerson = fileForm.getParameter("smsPerson");
		if (smsPerson == null) {
			smsPerson = "";
		}
		String mobileSmsPerson = fileForm.getParameter("mobileSmsPerson");
		if (mobileSmsPerson == null) {
			mobileSmsPerson = "";
		}
		String folderPath = fileForm.getParameter("folderPath");
		if (folderPath == null) {
			folderPath = "";
		}
		String subjectStr = "";
		try {
			Iterator<String> keysIte = fileForm.iterateFileFields();
			while (keysIte.hasNext()) {
				String fieldName = keysIte.next();
				String fileName = fileForm.getFileName(fieldName);
				if (YHUtility.isNullorEmpty(fileName)) {
					continue;
				}
				String nameTitle = "";
				String newSubject = "";
				if (fileName.lastIndexOf(".") != -1) {
					nameTitle = fileName.substring(0, fileName.lastIndexOf("."));
				}
				boolean haveFile = this.isExistFile(dbConn, sortId, nameTitle);
				if (haveFile) {
					StringBuffer buffer = new StringBuffer();
					this.copyExistFile(dbConn, buffer, sortId, nameTitle);
					newSubject = buffer.toString().trim();
				}else {
					newSubject = nameTitle;
				}
				
				YHInnerEMailUtilLogic emut = new YHInnerEMailUtilLogic();
				content.setSortId(sortId);
				content.setSendTime(YHUtility.parseTimeStamp());
				content.setAttachmentName(fileName.trim() + "*");
//				String[] fName = fileName.split("\\.");
				content.setSubject(newSubject);
				subjectStr = newSubject; // J01786??????

				String rand = emut.getRandom();
				fileName = rand + "_" + fileName;
				fileForm.saveFile(fieldName, filePath + File.separator + fileName);
				
				content.setAttachmentId(currDate + "_" + String.valueOf(rand) + ",");
				content.setCreater(String.valueOf(loginUserSeqId));
			}
			orm.saveSingle(dbConn, content);
			YHFileContent maxContent = this.getMaxSeqId(dbConn);
			int contentId = maxContent.getSeqId();
			// ????????????
			String remark = "????????????,??????:" + subjectStr;
			YHSysLogLogic.addSysLog(dbConn, YHLogConst.FILE_FOLDER, remark, loginUserSeqId, remoteAddr);

			// ????????????
			// YHSmsUtil sms=new YHSmsUtil();
			YHSmsBack sms = new YHSmsBack();
			String loginName = this.getPersonNamesByIds(dbConn, String.valueOf(loginUserSeqId));
			String smsContent = loginName + " ??????????????????" + folderPath + " ??????????????????:" + subjectStr;
			String remindUrl = "/core/funcs/filefolder/read.jsp?sortId=" + sortId + "&contentId=" + contentId + "&newFileFlag=1&openFlag=1";
			if ("allPrivPerson".equals(smsPerson)) {
				YHFileSortLogic logic = new YHFileSortLogic();
				YHFileSort fileSort = logic.getFileSortInfoById(dbConn, String.valueOf(sortId));
				String deptIdStr = logic.getDeptIds(dbConn, fileSort, "USER_ID");
				String roleIdStr = logic.getRoleIds(dbConn, fileSort, "USER_ID");
				String personIdStr = logic.selectManagerIds(dbConn, fileSort, "USER_ID");

				if (!"".equals(personIdStr)) {
					personIdStr += ",";
				}
				// ?????????????????????????????????				// String deptPrivIdStrs = logic.getPrivDeptIdStr(dbConn,
				// loginUserDeptId, deptIdStr);
				// String rolePrivIdStrs = logic.getPrivRoleIdStr(dbConn,
				// Integer.parseInt(loginUserRoleId), roleIdStr);
				// // ????????????????????????????????????????????????id???				// String deptPersonIdStr = logic.getDeptPersonIdStr(loginUserDeptId,
				// deptPrivIdStrs, dbConn);
				// String rolePersonIdStr =
				// logic.getRolePersonIdStr(Integer.parseInt(loginUserRoleId),
				// rolePrivIdStrs, dbConn);

				String deptPersonIdStr = "";
				String rolePersonIdStr = "";
				if (!YHUtility.isNullorEmpty(deptIdStr)) {
					deptPersonIdStr = logic.getDeptPersonIds(deptIdStr, dbConn);
				}
				if (!YHUtility.isNullorEmpty(roleIdStr)) {
					rolePersonIdStr = logic.getRolePersonIds(roleIdStr, dbConn);
				}

				String allPersonIdStr = personIdStr + deptPersonIdStr + rolePersonIdStr;
				String allpersonStr = "";
				ArrayList al = new ArrayList();
				String[] arr = allPersonIdStr.split(",");
				for (int i = 0; i < arr.length; i++) {
					if (al.contains(arr[i]) == false) {
						al.add(arr[i]);
						allpersonStr += arr[i] + ",";
					}
				}
				if (allpersonStr != null && !"".equals(allpersonStr)) {
					sms.setFromId(loginUserSeqId);
					sms.setToId(allpersonStr.trim());
					sms.setContent(smsContent);
					sms.setSendDate(YHUtility.parseTimeStamp());
					sms.setSmsType(YHLogConst.FILE_FOLDER);
					sms.setRemindUrl(remindUrl);
					YHSmsUtil.smsBack(dbConn, sms);
				}

			} else if (!"".equals(smsPerson)) {
				sms.setFromId(loginUserSeqId);
				sms.setToId(smsPerson);
				sms.setContent(smsContent);
				sms.setSendDate(YHUtility.parseTimeStamp());
				sms.setSmsType(YHLogConst.FILE_FOLDER);
				sms.setRemindUrl(remindUrl);
				YHSmsUtil.smsBack(dbConn, sms);
			}
			// ??????????????????
			String mobileSmsContent = loginName + " ?????????????????? " + folderPath + " ??????????????????:" + subjectStr;
			YHMobileSms2Logic mobileSms = new YHMobileSms2Logic();
			if ("allPrivPerson".equals(mobileSmsPerson.trim())) {
				YHFileSortLogic logic = new YHFileSortLogic();
				YHFileSort fileSort = logic.getFileSortInfoById(dbConn, String.valueOf(sortId));
				String deptIdStr = logic.getDeptIds(dbConn, fileSort, "USER_ID");
				String roleIdStr = logic.getRoleIds(dbConn, fileSort, "USER_ID");
				String personIdStr = logic.selectManagerIds(dbConn, fileSort, "USER_ID");
				if (!"".equals(personIdStr)) {
					personIdStr += ",";
				}
				// ?????????????????????????????????				String deptPrivIdStrs = logic.getPrivDeptIdStr(dbConn, loginUserDeptId, deptIdStr);
				String rolePrivIdStrs = logic.getPrivRoleIdStr(dbConn, Integer.parseInt(loginUserRoleId), roleIdStr);
				// ????????????????????????????????????????????????id???				String deptPersonIdStr = logic.getDeptPersonIdStr(loginUserDeptId, deptPrivIdStrs, dbConn);
				String rolePersonIdStr = logic.getRolePersonIdStr(Integer.parseInt(loginUserRoleId), rolePrivIdStrs, dbConn);
				String allPersonIdStr = personIdStr + deptPersonIdStr + rolePersonIdStr;
				String allpersonStr = "";
				ArrayList al = new ArrayList();
				String[] arr = allPersonIdStr.split(",");
				for (int i = 0; i < arr.length; i++) {
					if (al.contains(arr[i]) == false) {
						al.add(arr[i]);
						allpersonStr += arr[i] + ",";
					}
				}
				if (allpersonStr != null && !"".equals(allpersonStr)) {
					mobileSms.remindByMobileSms(dbConn, allpersonStr, loginUserSeqId, mobileSmsContent, null);
				}
			} else if (!"".equals(mobileSmsPerson.trim())) {
				mobileSms.remindByMobileSms(dbConn, mobileSmsPerson, loginUserSeqId, mobileSmsContent, null);
			}
		} catch (Exception e) {
			throw e;
		}
		return null;
	}

	public YHFileContent getFileContentInfoById(Connection dbConn, int contentId) throws Exception {
		YHORM orm = new YHORM();
		return (YHFileContent) orm.loadObjSingle(dbConn, YHFileContent.class, contentId);
	}

	public void updateSingleObj(Connection dbConn, YHFileContent fileContent) throws Exception {
		YHORM orm = new YHORM();
		orm.updateSingle(dbConn, fileContent);
	}

	public void updataFileInfoByObj(Connection dbConn, YHFileContent content) throws Exception {
		YHORM orm = new YHORM();
		orm.updateSingle(dbConn, content);
	}

	/**
	 * ????????????????????????
	 * 
	 * @param dbConn
	 * @param map
	 * @param loginUser
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> queryFileContentInfoById(Connection dbConn, Map map, YHPerson loginUser, int currNo, int pageSize)
			throws Exception {
		String filePath = YHSysProps.getAttachPath() + File.separator + "file_folder";
		List list = new ArrayList();
		Statement stmt = null;
		ResultSet rs = null;
		if (currNo == 0) {
			currNo = 1;
		} else {
			currNo = currNo + 1;
		}

		String seqIdStr = (String) map.get("seqId");
		String subject = (String) map.get("subject");
		String contentNo = (String) map.get("contentNo");

		String key1 = (String) map.get("key1");
		String key2 = (String) map.get("key2");
		String key3 = (String) map.get("key3");

		String attachmentDesc = (String) map.get("attachmentDesc");
		String attachmentName = (String) map.get("attachmentName");
		String attachmentData = (String) map.get("attachmentData");
		String sendTimeMin = (String) map.get("sendTimeMin");
		String sendTimeMax = (String) map.get("sendTimeMax");

		YHORM orm = new YHORM();

		int loginUserSeqId = loginUser.getSeqId();
		String loginUserSeqIdStr = String.valueOf(loginUserSeqId);

		int seqId = 0;
		if (!YHUtility.isNullorEmpty(seqIdStr)) {
			seqId = Integer.parseInt(seqIdStr);
		}

		if (YHUtility.isNullorEmpty(subject)) {
			subject = "";
		}
		if (YHUtility.isNullorEmpty(contentNo)) {
			contentNo = "";
		}
		if (YHUtility.isNullorEmpty(key1)) {
			key1 = "";
		}
		if (YHUtility.isNullorEmpty(key2)) {
			key2 = "";
		}
		if (YHUtility.isNullorEmpty(key3)) {
			key3 = "";
		}
		if (YHUtility.isNullorEmpty(attachmentDesc)) {
			attachmentDesc = "";
		}
		if (YHUtility.isNullorEmpty(attachmentName)) {
			attachmentName = "";
		}
		if (YHUtility.isNullorEmpty(attachmentData)) {
			attachmentData = "";
		}
		if (YHUtility.isNullorEmpty(sendTimeMin)) {
			sendTimeMin = "";
		}
		if (YHUtility.isNullorEmpty(sendTimeMax)) {
			sendTimeMax = "";
		}

		YHFileSort fileSort = new YHFileSort();
		YHFileSortLogic sysLogic = new YHFileSortLogic();

		boolean accessPriv = false;
		int managePriv = 0;
		int downPriv = 0;
		int newPriv = 0;

		if (seqId != 0) {
			fileSort = (YHFileSort) orm.loadObjSingle(dbConn, YHFileSort.class, seqId);
			if (fileSort != null) {
				String sortUserIds = fileSort.getUserId() == null ? "" : fileSort.getUserId();
				// ????????????(??????owner??????)
				accessPriv = sysLogic.getAccessPriv(dbConn, loginUser, fileSort);
				if (loginUserSeqIdStr.equals(sortUserIds.trim()) || accessPriv) {
					accessPriv = true;
				}
				boolean manageUserPriv = sysLogic.getManageAccessPriv(dbConn, loginUser, fileSort);
				boolean downUserPriv = sysLogic.getDownAccessPriv(dbConn, loginUser, fileSort);
				boolean newUserPriv = sysLogic.getNewUserAccessPriv(dbConn, loginUser, fileSort);
				if (loginUserSeqIdStr.equals(sortUserIds.trim()) || manageUserPriv) {
					managePriv = 1;
				}
				if (loginUserSeqIdStr.equals(sortUserIds.trim()) || downUserPriv) {
					downPriv = 1;
				}
				if (loginUserSeqIdStr.equals(sortUserIds.trim()) || newUserPriv) {
					newPriv = 1;
				}
			}
		} else {
			accessPriv = true;
			managePriv = 1;
			downPriv = 1;
			newPriv = 1;
		}
		if (!accessPriv) {
			return list;
		}
		String where_str = "";
		if (!YHUtility.isNullorEmpty(subject.trim())) {
			where_str += " and SUBJECT like '%" + YHDBUtility.escapeLike(subject) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(contentNo.trim())) {
			where_str += " and CONTENT_NO like '%" + YHDBUtility.escapeLike(contentNo) + "%'" + YHDBUtility.escapeLike();
		}

		if (!YHUtility.isNullorEmpty(attachmentDesc.trim())) {
			where_str += " and ATTACHMENT_DESC like '%" + YHDBUtility.escapeLike(attachmentDesc) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(key1.trim())) {
			where_str += " and CONTENT like '%" + YHDBUtility.escapeLike(key1) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(key2.trim())) {
			where_str += " and CONTENT like '%" + YHDBUtility.escapeLike(key2) + "%'" + YHDBUtility.escapeLike();
		}

		if (!YHUtility.isNullorEmpty(key3.trim())) {
			where_str += " and CONTENT like '%" + YHDBUtility.escapeLike(key3) + "%'" + YHDBUtility.escapeLike();
		}

		if (!YHUtility.isNullorEmpty(attachmentName.trim())) {
			where_str += " and ATTACHMENT_NAME like '%" + YHDBUtility.escapeLike(attachmentName) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(sendTimeMin.trim())) {
			String temp = YHDBUtility.getDateFilter("SEND_TIME", sendTimeMin.trim(), ">=");
			where_str += " and " + temp;
		}
		if (!YHUtility.isNullorEmpty(sendTimeMax.trim())) {
			String temp = YHDBUtility.getDateFilter("SEND_TIME", sendTimeMax.trim(), "<="); // to_char(SEND_TIME,
			where_str += " and " + temp;
		}

		String query = "";
		if (seqId != 0) {
			query = "SELECT * from oa_file_content where SORT_ID=" + seqId + where_str;
		} else {
			query = "SELECT * from oa_file_content where SORT_ID=" + seqId + " and USER_ID='" + loginUserSeqId + "'" + where_str;
		}
		query += " order by CONTENT_NO,SEND_TIME desc ";

		try {
			stmt = dbConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = stmt.executeQuery(query);
			rs.last();
			int maxRow = rs.getRow();
			rs.beforeFirst();
			int count = 0;
			rs.absolute((currNo - 1) * pageSize + 1);
			if (maxRow > 0) {
				do {
					String dbAttachmentIds = YHUtility.encodeSpecial(rs.getString("ATTACHMENT_ID"));
					String dbAttachmentNames = YHUtility.encodeSpecial(rs.getString("ATTACHMENT_NAME"));
					if (!"".equals(attachmentData.trim()) && "".equals(dbAttachmentNames.trim())) {
						continue;
					}

					// ????????????????????????
					if (!YHUtility.isNullorEmpty(attachmentData) && !YHUtility.isNullorEmpty(dbAttachmentNames)) {
						String[] attIdArray = dbAttachmentIds.trim().split(",");
						String[] attNameArray = dbAttachmentNames.trim().split("\\*");
						int contentValue = -1;
						for (int i = 0; i < attIdArray.length; i++) {
							String attId = this.getAttaId(attIdArray[i]);
							String attFolder = this.getFilePathFolder(attIdArray[i]);
							String newAttName = attId + "_" + attNameArray[i];
							String oldAttName = attId + "." + attNameArray[i];

							String newFilePath = filePath + "/" + attFolder + "/" + newAttName;
							String oldFilePath = filePath + "/" + attFolder + "/" + oldAttName;
							File newFile = new File(newFilePath);
							File oldFile = new File(oldFilePath);

							String fileType = "";
							String attName = attNameArray[i];
							if (attName.trim().lastIndexOf(".") != -1) {
								fileType = attName.substring(attName.trim().lastIndexOf(".")); // .doc
							}

							StringBuffer buffer = new StringBuffer();
							if (newFile.exists()) {
								long totalSpace = newFile.length();
								if (".htm".equals(fileType.trim()) || ".html".equals(fileType.trim())) {
									if (totalSpace < 500 * 1024 * 1024) {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									} else {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									}
								} else if (".txt".equals(fileType.trim())) {
									if (totalSpace < 500 * 1024 * 1024) {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									} else {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									}
								}
								if (contentValue >= 0) {
									break;
								}
							} else if (oldFile.exists()) {
								long totalSpace = oldFile.length();
								if (".htm".equals(fileType.trim()) || ".html".equals(fileType.trim())) {
									if (totalSpace < 500 * 1024 * 1024) {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									} else {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									}
								} else if (".txt".equals(fileType.trim())) {
									if (totalSpace < 500 * 1024 * 1024) {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									} else {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "GBK");
										contentValue = buffer.indexOf(attachmentData.trim());
										if (contentValue == -1) {
											buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "UTF-8");
											contentValue = buffer.indexOf(attachmentData.trim());
										}
									}
								}
								if (contentValue >= 0) {
									break;
								}
							} else {
								break;
							}
						}
						if (contentValue == -1) {
							continue;
						}
					}
					Map<String, String> map2 = new HashMap<String, String>();
					map2.put("contentId", rs.getString("SEQ_ID"));
					map2.put("sortId", rs.getString("SORT_ID"));
					map2.put("subject", rs.getString("SUBJECT"));
					map2.put("sendTime", YHUtility.getDateTimeStr(rs.getTimestamp("SEND_TIME"))); 

					map2.put("attachmentId", rs.getString("ATTACHMENT_ID"));
					map2.put("attachmentName", rs.getString("ATTACHMENT_NAME"));
					map2.put("attachmentDesc", rs.getString("ATTACHMENT_DESC"));
					map2.put("maxRow", String.valueOf(maxRow));
					list.add(map2);
				} while (rs.next() && ++count < pageSize);
			}

		} catch (SQLException e) {
			throw e;
		} finally {
			YHDBUtility.close(stmt, rs, log);
		}

		return list;

	}

	/**
	 * ????????????
	 * 
	 * @param dbConn
	 * @param map
	 * @param loginUser
	 * @return
	 * @throws Exception
	 */
	public List<Map<Object, Object>> getGlobalFileContentsByList(Connection dbConn, Map map, YHPerson loginUser) throws Exception {
		String filePath = YHSysProps.getAttachPath() + File.separator + "file_folder";
		YHFileSortLogic fileSortLogic = new YHFileSortLogic();
		List list = new ArrayList();

		Statement stmt = null;
		ResultSet rs = null;

		String subject = (String) map.get("subject");
		String contentNo = (String) map.get("contentNo");

		String key1 = (String) map.get("key1");
		String key2 = (String) map.get("key2");
		String key3 = (String) map.get("key3");

		String attachmentDesc = (String) map.get("attachmentDesc");
		String attachmentName = (String) map.get("attachmentName");
		String attachmentData = (String) map.get("attachmentData");
		String sendTimeMin = (String) map.get("sendTimeMin");
		String sendTimeMax = (String) map.get("sendTimeMax");

		if (YHUtility.isNullorEmpty(subject)) {
			subject = "";
		}
		if (YHUtility.isNullorEmpty(contentNo)) {
			contentNo = "";
		}
		if (YHUtility.isNullorEmpty(key1)) {
			key1 = "";
		}
		if (YHUtility.isNullorEmpty(key2)) {
			key2 = "";
		}
		if (YHUtility.isNullorEmpty(key3)) {
			key3 = "";
		}
		if (YHUtility.isNullorEmpty(attachmentDesc)) {
			attachmentDesc = "";
		}
		if (YHUtility.isNullorEmpty(attachmentName)) {
			attachmentName = "";
		}
		if (YHUtility.isNullorEmpty(attachmentData)) {
			attachmentData = "";
		}
		if (YHUtility.isNullorEmpty(sendTimeMin)) {
			sendTimeMin = "";
		}

		if (YHUtility.isNullorEmpty(sendTimeMax)) {
			sendTimeMax = "";
		}

		// ????????????
		String where_str = "";
		if (!YHUtility.isNullorEmpty(subject.trim())) {
			where_str += " and SUBJECT like '%" + YHDBUtility.escapeLike(subject) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(contentNo.trim())) {
			where_str += " and CONTENT_NO like '%" + YHDBUtility.escapeLike(contentNo) + "%'" + YHDBUtility.escapeLike();
		}

		if (!YHUtility.isNullorEmpty(attachmentDesc.trim())) {
			where_str += " and ATTACHMENT_DESC like '%" + YHDBUtility.escapeLike(attachmentDesc) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(key1.trim())) {
			where_str += " and CONTENT like '%" + YHDBUtility.escapeLike(key1) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(key2.trim())) {
			where_str += " and CONTENT like '%" + YHDBUtility.escapeLike(key2) + "%'" + YHDBUtility.escapeLike();
		}

		if (!YHUtility.isNullorEmpty(key3.trim())) {
			where_str += " and CONTENT like '%" + YHDBUtility.escapeLike(key3) + "%'" + YHDBUtility.escapeLike();
		}

		if (!YHUtility.isNullorEmpty(attachmentName.trim())) {
			where_str += " and ATTACHMENT_NAME like '%" + YHDBUtility.escapeLike(attachmentName) + "%'" + YHDBUtility.escapeLike();
		}
		if (!YHUtility.isNullorEmpty(sendTimeMin.trim())) {
			String temp = YHDBUtility.getDateFilter("SEND_TIME", sendTimeMin.trim(), ">=");
			where_str += " and " + temp;
		}
		if (!YHUtility.isNullorEmpty(sendTimeMax.trim())) {
			String temp = YHDBUtility.getDateFilter("SEND_TIME", sendTimeMax.trim(), "<="); // to_char(SEND_TIME,
			where_str += " and " + temp;
		}
		String query = "SELECT * from oa_file_content where 1=1 " + where_str;
		query += " order by CONTENT_NO,SEND_TIME desc ";

		try {
			stmt = dbConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = stmt.executeQuery(query);
			rs.last();
			int maxRow = rs.getRow();
			rs.beforeFirst();
			int count = 0;
			while (rs.next()) {
				String dbAttachmentIds = YHUtility.null2Empty(rs.getString("ATTACHMENT_ID"));
				String dbAttachmentNames = YHUtility.null2Empty(YHUtility.encodeSpecial(rs.getString("ATTACHMENT_NAME")));

				// ????????????????????????
				if (!"".equals(attachmentData.trim()) && "".equals(dbAttachmentNames.trim())) {
					continue;
				}
				if (!YHUtility.isNullorEmpty(attachmentData) && !YHUtility.isNullorEmpty(dbAttachmentNames)) {
					String[] attIdArray = dbAttachmentIds.trim().split(",");
					String[] attNameArray = dbAttachmentNames.trim().split("\\*");
					int contentValue = -1;
					for (int i = 0; i < attIdArray.length; i++) {
						String attId = this.getAttaId(attIdArray[i]);
						String attFolder = this.getFilePathFolder(attIdArray[i]);
						String newAttName = attId + "_" + attNameArray[i];
						String oldAttName = attId + "." + attNameArray[i];

						String newFilePath = filePath + "/" + attFolder + "/" + newAttName;
						String oldFilePath = filePath + "/" + attFolder + "/" + oldAttName;
						File newFile = new File(newFilePath);
						File oldFile = new File(oldFilePath);
						String fileType = "";
						String attName = attNameArray[i];
						if (attName.trim().lastIndexOf(".") != -1) {
							fileType = attName.substring(attName.trim().lastIndexOf(".")); // .doc
						}
						StringBuffer buffer = new StringBuffer();
						if (newFile.exists()) {
							long totalSpace = newFile.length();
							if (".htm".equals(fileType.trim()) || ".html".equals(fileType.trim())) {
								if (totalSpace < 500 * 1024 * 1024) {
									buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								} else {
									buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								}
							} else if (".txt".equals(fileType.trim())) {
								if (totalSpace < 500 * 1024 * 1024) {
									buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								} else {
									buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(newFile.getAbsolutePath(), 0, 500, "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								}
							}
							if (contentValue >= 0) {
								break;
							}
						} else if (oldFile.exists()) {
							long totalSpace = oldFile.length();
							if (".htm".equals(fileType.trim()) || ".html".equals(fileType.trim())) {
								if (totalSpace < 500 * 1024 * 1024) {
									buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								} else {
									buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								}

							} else if (".txt".equals(fileType.trim())) {
								if (totalSpace < 500 * 1024 * 1024) {
									buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								} else {
									buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "GBK");
									contentValue = buffer.indexOf(attachmentData.trim());
									if (contentValue == -1) {
										buffer = YHFileUtility.loadLine2Buff(oldFile.getAbsolutePath(), 0, 500, "UTF-8");
										contentValue = buffer.indexOf(attachmentData.trim());
									}
								}
							}
							if (contentValue >= 0) {
								break;
							}
						} else {
							break;
						}
					}
					if (contentValue == -1) {
						continue;
					}
				}
				int managePriv = 0;
				int downPriv = 0;
				int newPriv = 0;
				int fileSortCur = 1; // ?????????????????????????????????				int dbSortId = rs.getInt("SORT_ID");
				String dbUserId = YHUtility.null2Empty(rs.getString("USER_ID"));

				int loginUserSeqId = loginUser.getSeqId();
				String loginUserSeqIdStr = String.valueOf(loginUserSeqId);

				if (dbSortId != 0) {
					YHFileSort fileSort = fileSortLogic.getFolderInfoById(dbConn, dbSortId);
					if (fileSort != null) {
						String sortUserIds = fileSort.getUserId() == null ? "" : fileSort.getUserId();
						boolean userIdPriv = fileSortLogic.getUserIdAccessPriv(dbConn, loginUser, fileSort);
						if (!loginUserSeqIdStr.equals(sortUserIds.trim()) && !userIdPriv) {
							continue;
						}
						boolean manageUserPriv = fileSortLogic.getManageAccessPriv(dbConn, loginUser, fileSort);
						boolean downUserPriv = fileSortLogic.getDownAccessPriv(dbConn, loginUser, fileSort);
						boolean newUserPriv = fileSortLogic.getNewUserAccessPriv(dbConn, loginUser, fileSort);
						if (loginUserSeqIdStr.equals(sortUserIds.trim()) || manageUserPriv) {
							managePriv = 1;
						}
						if (loginUserSeqIdStr.equals(sortUserIds.trim()) || downUserPriv) {
							downPriv = 1;
						}
						if (loginUserSeqIdStr.equals(sortUserIds.trim()) || newUserPriv) {
							newPriv = 1;
						}
						if (loginUserSeqIdStr.equals(sortUserIds.trim())) {
							fileSortCur = 2; // ????????????????????????
						} else {
							fileSortCur = 1; // ????????????????????????
						}

					}
				} else {
					if (!loginUserSeqIdStr.equals(dbUserId.trim())) {
						continue;
					}
					managePriv = 1;
					downPriv = 1;
					newPriv = 1;
					fileSortCur = 2;
				}

				StringBuffer buffer1 = new StringBuffer();
				fileSortLogic.getSortNamePath(dbConn, dbSortId, buffer1);
				String sortName = buffer1.toString();
				String sortNames[] = sortName.split(",");
				StringBuffer sb = new StringBuffer();
				for (int i = sortNames.length - 1; i >= 0; i--) {
					sb.append(sortNames[i]);
				}
				sb.deleteCharAt(sb.length() - 1);

				String treePath = "/" + sb.toString();

				if ("".equals(treePath) && dbSortId == 0) {
					treePath = "/";
				}

				Map<Object, Object> map2 = new HashMap<Object, Object>();
				map2.put("dbContentId", rs.getInt("SEQ_ID"));
				map2.put("dbSortId", rs.getInt("SORT_ID"));
				map2.put("dbSubject", rs.getString("SUBJECT"));
				map2.put("dbSendTime", YHUtility.getDateTimeStr(rs.getTimestamp("SEND_TIME")));

				map2.put("dbAttachmentId", rs.getString("ATTACHMENT_ID"));
				map2.put("dbAttachmentName", rs.getString("ATTACHMENT_NAME"));
				map2.put("dbAttachmentDesc", rs.getString("ATTACHMENT_DESC"));
				// map2.put("dbUserId", rs.getString("USER_ID"));

				map2.put("treePath", treePath);
				map2.put("managePriv", managePriv);
				map2.put("downPriv", downPriv);
				map2.put("newPriv", newPriv);
				map2.put("fileSortCur", fileSortCur);
				list.add(map2);
			}
		} catch (Exception e) {
			throw e;
		} finally {
			YHDBUtility.close(stmt, rs, log);
		}
		return list;
	}

	/**
	 * ??????seqId???????????????
	 * 
	 * 
	 * @param dbConn
	 * @param seqIdStrs
	 * @param filePath
	 * @throws NumberFormatException
	 * @throws Exception
	 */
	public void delFile(Connection dbConn, String seqIdStrs, String filePath, int loginUserSeqId, String ipStr, String recycle, String recyclePath)
			throws NumberFormatException, Exception {
		YHORM orm = new YHORM();

		String[] seqIdStr = seqIdStrs.split(",");
		if (!"".equals(seqIdStrs) && seqIdStrs.split(",").length > 0) {
			// ??????????????????????????????id???
			for (String seqId : seqIdStr) {
				YHFileContent fileContent = this.getFileContentInfoById(dbConn, Integer.parseInt(seqId));
				String attachmentId = YHUtility.null2Empty(fileContent.getAttachmentId());
				String attachmentName = YHUtility.null2Empty(fileContent.getAttachmentName());
				String[] attIdArray = {};
				String[] attNameArray = {};
				if (!"".equals(attachmentId) && attachmentId != null && attachmentName != null) {
					attIdArray = attachmentId.trim().split(",");
					attNameArray = attachmentName.trim().split("\\*");
				}
				for (int i = 0; i < attIdArray.length; i++) {
					Map<String, String> map = this.getFileName(attIdArray[i], attNameArray[i]);
					if (map.size() != 0) {
						Set<String> set = map.keySet();
						// ??????Set??????
						for (String keySet : set) {
							String key = keySet;
							String keyValue = map.get(keySet);
							String attaIdStr = this.getAttaId(keySet);
							String fileNameValue = attaIdStr + "_" + keyValue;
							String fileFolder = this.getFilePathFolder(key);
							String oldFileNameValue = attaIdStr + "." + keyValue;
							File file = new File(filePath + File.separator + fileFolder + File.separator + fileNameValue);
							File oldFile = new File(filePath + File.separator + fileFolder + File.separator + oldFileNameValue);

							if (file.exists()) {
								if ("1".equals(recycle.trim())) {
									YHFileUtility.xcopyFile(file.getAbsolutePath(), recyclePath + File.separator + fileNameValue);
								} else {
									YHFileUtility.deleteAll(file.getAbsoluteFile());
								}
							} else if (oldFile.exists()) {
								if ("1".equals(recycle.trim())) {
									YHFileUtility.xcopyFile(oldFile.getAbsolutePath(), recyclePath + File.separator + fileNameValue);
								} else {
									YHFileUtility.deleteAll(oldFile.getAbsoluteFile());
								}
							}
						}
					}
				}
				// ?????????????????????				YHFileContent delContent = new YHFileContent();
				delContent.setSeqId(fileContent.getSeqId());
				orm.deleteSingle(dbConn, delContent);

				// ??????????????????
				String remark = "????????????,??????:" + fileContent.getSubject();
				YHSysLogLogic.addSysLog(dbConn, YHLogConst.FILE_FOLDER, remark, loginUserSeqId, ipStr);

			}
		}
	}

	/**
	 * ????????????????????????
	 * 
	 * @param dbConn
	 * @param attId
	 * @param attName
	 * @param contentId
	 * @throws Exception
	 */
	public boolean delFloatFile(Connection dbConn, String attId, String attName, int contentId) throws Exception {
		boolean updateFlag = false;
		YHFileContent fileContent = this.getFileContentInfoById(dbConn, contentId);
		String[] attIdArray = {};
		String[] attNameArray = {};
		String attachmentId = YHUtility.null2Empty(fileContent.getAttachmentId());
		String attachmentName = YHUtility.null2Empty(fileContent.getAttachmentName());
		if (!"".equals(attachmentId.trim()) && attachmentId != null && attachmentName != null) {
			attIdArray = attachmentId.trim().split(",");
			attNameArray = attachmentName.trim().split("\\*");
		}
		String attaId = "";
		String attaName = "";
		for (int i = 0; i < attIdArray.length; i++) {
			if (attId.equals(attIdArray[i])) {
				continue;
			}
			attaId += attIdArray[i] + ",";
			attaName += attNameArray[i] + "*";
		}

		fileContent.setAttachmentId(attaId.trim());
		fileContent.setAttachmentName(attaName.trim());
		this.updataFileInfoByObj(dbConn, fileContent);
		updateFlag = true;
		return updateFlag;

	}

	/**
	 * ??????????????????
	 * 
	 * @param dbConn
	 * @param seqIdStrs
	 * @throws Exception
	 * @throws NumberFormatException
	 */
	public void copyFile(Connection dbConn, String seqIdStrs, String sortId, String filePath) throws NumberFormatException, Exception {
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyMM");
		String currDate = format.format(date);
		YHInnerEMailUtilLogic emut = new YHInnerEMailUtilLogic();

		YHORM orm = new YHORM();
		String randFlag = "";
		String newAttName = "";
		String[] seqIdStr = seqIdStrs.split(",");
		if (!"".equals(seqIdStrs) && seqIdStrs.split(",").length > 0) {
			// ?????????????????????id???			for (String seqId : seqIdStr) {
				boolean isHave = false;
				YHFileContent fileContent = this.getFileContentInfoById(dbConn, Integer.parseInt(seqId));
				if (fileContent != null) {
					String subject = YHUtility.null2Empty(fileContent.getSubject());
					boolean haveFile = this.isExistFile(dbConn, Integer.parseInt(sortId), subject);
					if (haveFile) {
						StringBuffer buffer = new StringBuffer();
						this.copyExistFile(dbConn, buffer, Integer.parseInt(sortId), subject);
						String newSubject = buffer.toString().trim();
						fileContent.setSubject(newSubject);
					}

					String attachmentId = YHUtility.null2Empty(fileContent.getAttachmentId());
					String attachmentName = YHUtility.null2Empty(fileContent.getAttachmentName());
					String[] attIdArray = {};
					String[] attNameArray = {};
					if (attachmentId != null && attachmentName != null) {
						attIdArray = attachmentId.split(",");
						attNameArray = attachmentName.split("\\*");
					}
					for (int i = 0; i < attIdArray.length; i++) {
						Map<String, String> map = this.getFileName(attIdArray[i], attNameArray[i]);
						// ??????Set??????
						if (map.size() != 0) {
							Set<String> set = map.keySet();
							for (String keySet : set) {
								String rand = emut.getRandom();
								String key = keySet;
								String keyValue = map.get(keySet);
								String attaIdStr = this.getAttaId(keySet);
								String newAttaName = rand + "_" + keyValue;
								String fileNameValue = attaIdStr + "_" + keyValue;
								String fileFolder = this.getFilePathFolder(key);

								File file = new File(filePath + File.separator + fileFolder + File.separator + fileNameValue);
								if (file != null && file.exists()) {
									YHFileUtility.copyFile(filePath + File.separator + fileFolder + File.separator + fileNameValue, filePath + File.separator
											+ currDate + File.separator + newAttaName);
									randFlag += currDate + "_" + rand + ",";
									newAttName += keyValue + "*";
									isHave = true;
									break;
								}
							}
						}
					}
					if (isHave) {
						// ??????????????????
						// fileContent.setUserId(String.valueOf(loginUserSeqId));
						// fileContent.setCreater(String.valueOf(loginUserSeqId));
						fileContent.setSortId(Integer.parseInt(sortId));
						fileContent.setSendTime(YHUtility.parseTimeStamp());
						fileContent.setAttachmentId(randFlag);
						fileContent.setAttachmentName(newAttName.trim());
						orm.saveSingle(dbConn, fileContent);
					} else {
						fileContent.setSortId(Integer.parseInt(sortId));
						fileContent.setSendTime(YHUtility.parseTimeStamp());
						orm.saveSingle(dbConn, fileContent);
					}

				}
			}
		}
	}

	/**
	 * ???????????????Id
	 * 
	 * @param keyId
	 * @return
	 */
	public String getAttaId(String keyId) {
		String attaId = "";
		if (keyId != null && !"".equals(keyId)) {
			if (keyId.indexOf('_') != -1) {
				String[] ids = keyId.split("_");
				if (ids.length > 0) {
					attaId = ids[1];
				}

			} else {
				attaId = keyId;
			}
		}
		return attaId;
	}

	/**
	 * ???????????????Id ????????????
	 * 
	 * 
	 * @param keyId
	 * @return
	 */
	public String getOldAttaId(String keyId) {
		String attaId = "";
		if (keyId != null && !"".equals(keyId)) {
			if (keyId.indexOf('_') != -1) {
				String[] ids = keyId.split("_");
				if (ids.length > 0) {
					attaId = ids[1];
				}
			} else {
				attaId = keyId;
			}
		}
		return attaId;
	}

	/**
	 * ????????????id???????????????name?????????
	 * 
	 * 
	 * @param dbConn
	 * @param ids
	 * @return
	 * @throws Exception
	 */
	public String getPersonNamesByIds(Connection conn, String ids) throws Exception {
		String names = "";
		if (ids != null && !"".equals(ids.trim())) {
			if (ids.endsWith(",")) {
				ids = ids.substring(0, ids.length() - 1);
			}
			String query = "select USER_NAME from PERSON where SEQ_ID in (" + ids + ")";
			Statement stm = null;
			ResultSet rs = null;
			try {
				stm = conn.createStatement();
				rs = stm.executeQuery(query);
				while (rs.next()) {
					names += rs.getString("USER_NAME") + ",";
				}
			} catch (Exception ex) {
				throw ex;
			} finally {
				YHDBUtility.close(stm, rs, null);
			}
		}
		if (names.endsWith(",")) {
			names = names.substring(0, names.length() - 1);
		}
		return names;
	}

	/**
	 * ??????????????????????????????
	 * 
	 * @param key
	 * @return
	 */
	public String getFilePathFolder(String key) {
		String folder = "";

		if (key != null && !"".equals(key)) {

			if (key.indexOf('_') != -1) {
				String[] str = key.split("_");
				for (int i = 0; i < str.length; i++) {
					folder = str[0];
				}
			} else {
				folder = "all";
			}

		}
		return folder;
	}

	/**
	 * ????????????Id????????????
	 * 
	 * @param attachmentId
	 * @param attachmentName
	 * @return
	 */
	public Map<String, String> getFileName(String attachmentId, String attachmentName) {
		Map<String, String> map = new HashMap<String, String>();
		if (attachmentId == null || attachmentName == null) {
			return map;
		}
		if (!"".equals(attachmentId.trim()) && !"".equals(attachmentName.trim())) {

			String attachmentIds[] = attachmentId.split(",");
			String attachmentNames[] = attachmentName.split("\\*");
			if (attachmentIds.length != 0 && attachmentNames.length != 0) {
				for (int i = 0; i < attachmentIds.length; i++) {
					map.put(attachmentIds[i], attachmentNames[i]);
				}

			}
		}
		return map;
	}

	/**
	 * ????????????Id????????????
	 * 
	 * @param attachmentId
	 * @param attachmentName
	 * @return
	 */
	public String getAttachName(String attachmentId, String attachmentName) {
		String fileName = "";
		if (attachmentId == null || attachmentName == null) {
			return fileName;
		}
		if (!"".equals(attachmentId.trim()) && !"".equals(attachmentName.trim())) {

			String attachmentIds[] = attachmentId.split(",");
			String attachmentNames[] = attachmentName.split("\\*");
			if (attachmentIds.length != 0 && attachmentNames.length != 0) {

				for (int i = 0; i < attachmentIds.length; i++) {
					fileName = attachmentIds[i] + attachmentNames[i];
				}

			}
		}
		return fileName;
	}

	/**
	 * ?????????????????????????????? ????????????
	 * 
	 * 
	 * @param key
	 * @return
	 */
	public String getAttFolderName(String key) {
		String folder = "";
		if (key != null && !"".equals(key)) {

			if (key.indexOf('_') != -1) {
				String[] str = key.split("_");
				for (int i = 0; i < str.length; i++) {
					folder = str[0];
				}
			} else {
				folder = "all";
			}
		}
		return folder;
	}

	/**
	 * ??????????????????
	 * 
	 * @param dbConn
	 * @param seqIdStrs
	 * @param sortId
	 * @param filePath
	 * @throws NumberFormatException
	 * @throws Exception
	 */
	public void cutFile(Connection dbConn, String seqIdStrs, String sortId, String filePath) throws NumberFormatException, Exception {
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyMM");
		String currDate = format.format(date);
		YHInnerEMailUtilLogic emut = new YHInnerEMailUtilLogic();

		String randFlag = "";
		String newAttName = "";
		boolean isHave = false;

		YHORM orm = new YHORM();
		String[] seqIdStr = seqIdStrs.split(",");
		if (!YHUtility.isNullorEmpty(seqIdStrs) && seqIdStrs.split(",").length > 0) {
			// ?????????????????????Id???			for (String seqId : seqIdStr) {
				YHFileContent fileContent = this.getFileContentInfoById(dbConn, Integer.parseInt(seqId));
				if (fileContent != null) {
					String subject = YHUtility.null2Empty(fileContent.getSubject());
					boolean haveFile = this.isExistFile(dbConn, Integer.parseInt(sortId), subject);
					if (haveFile) {
						StringBuffer buffer = new StringBuffer();
						this.copyExistFile(dbConn, buffer, Integer.parseInt(sortId), subject);
						String newSubject = buffer.toString().trim();
						fileContent.setSubject(newSubject);
					}
					String attachmentId = YHUtility.null2Empty(fileContent.getAttachmentId());
					String attachmentName = YHUtility.null2Empty(fileContent.getAttachmentName());
					YHFileContent delContent = new YHFileContent();
					String[] attIdArray = {};
					String[] attNameArray = {};
					if (!YHUtility.isNullorEmpty(attachmentId) && !YHUtility.isNullorEmpty(attachmentName)) {
						attIdArray = attachmentId.split(",");
						attNameArray = attachmentName.split("\\*");
					}
					for (int i = 0; i < attIdArray.length; i++) {
						Map<String, String> map = this.getFileName(attIdArray[i], attNameArray[i]);
						if (map.size() != 0) {
							Set<String> set = map.keySet();
							// ??????Set??????
							for (String keySet : set) {
								String rand = emut.getRandom();
								String key = keySet;
								String keyValue = map.get(keySet);
								String attaIdStr = this.getAttaId(keySet);
								String fileNameValue = attaIdStr + "_" + keyValue;
								String newAttaName = rand + "_" + keyValue;
								String fileFolder = this.getFilePathFolder(key);

								File file = new File(filePath + File.separator + fileFolder + File.separator + fileNameValue);
								if (file != null && file.exists()) {
									YHFileUtility.xcopyFile(filePath + File.separator + fileFolder + File.separator + fileNameValue, filePath + File.separator
											+ currDate + File.separator + newAttaName);
									randFlag += currDate + "_" + rand + ",";
									newAttName += keyValue + "*";
									isHave = true;
									break;
								}
							}
						}
					}
					if (isHave) {
						delContent.setSeqId(fileContent.getSeqId());
						// ???????????????
						orm.deleteSingle(dbConn, delContent);
						// ???????????????
						fileContent.setSortId(Integer.parseInt(sortId));
						fileContent.setSendTime(YHUtility.parseTimeStamp());
						fileContent.setAttachmentId(randFlag.trim());
						fileContent.setAttachmentName(newAttName.trim());
						orm.saveSingle(dbConn, fileContent);
					} else {
						delContent.setSeqId(fileContent.getSeqId());
						orm.deleteSingle(dbConn, delContent);
						fileContent.setSortId(Integer.parseInt(sortId));
						fileContent.setSendTime(YHUtility.parseTimeStamp());
						orm.saveSingle(dbConn, fileContent);
					}

				}

			}
		}
	}

	/**
	 * ??????????????????????????????
	 * 
	 * @param dbConn
	 * @param seqId
	 * @param attachId
	 * @param attachName
	 * @throws Exception
	 */
	public boolean transferFolder(Connection dbConn, int seqId, String attachId, String attachName, String subject, String filePath, String folderPath)
			throws Exception {
		boolean flag = false;
		YHORM orm = new YHORM();
		String fileFolder = filePath + File.separator + this.getAttFolderName(attachId);
		String fileName = this.getOldAttaId(attachId) + "_" + attachName;
		String oldFileName = this.getOldAttaId(attachId) + "." + attachName;

		YHFileContent fileContent = new YHFileContent(); // this.getFileContentInfoById(dbConn,
		// seqId);
//		YHFileContent fileContent1 = this.getFileContentInfoById(dbConn, seqId);
		try {
			Date date = new Date();
			SimpleDateFormat format = new SimpleDateFormat("yyMM");
			String currDate = format.format(date);
			YHInnerEMailUtilLogic emut = new YHInnerEMailUtilLogic();

			String rand = emut.getRandom();
			String newAttaName = rand + "_" + attachName;

			File file = new File(fileFolder + "/" + fileName);
			File oldFile = new File(fileFolder + "/" + oldFileName);
			String subjectStr = "????????????";
			String newSubject = "";
			if (!YHUtility.isNullorEmpty(subject)) {
				subjectStr = subject;
			}
			boolean haveFile = this.isExistFile(dbConn, seqId, subjectStr);
			if (haveFile) {
				StringBuffer buffer = new StringBuffer();
				this.copyExistFile(dbConn, buffer, seqId, subjectStr);
				newSubject = buffer.toString().trim();
			}
			
			if (file.exists()) {
				YHFileUtility.copyFile(file.getAbsolutePath(), folderPath + File.separator + currDate + File.separator + newAttaName);
				fileContent.setSortId(seqId);
				fileContent.setSubject(newSubject);
				fileContent.setSendTime(YHUtility.parseTimeStamp());
				fileContent.setAttachmentId(currDate + "_" + rand + ",");
				fileContent.setAttachmentName(attachName + "*");
				orm.saveSingle(dbConn, fileContent);
				flag = true;

			} else if (oldFile.exists()) {
				YHFileUtility.copyFile(oldFile.getAbsolutePath(), folderPath + File.separator + currDate + File.separator + newAttaName);
				fileContent.setSortId(seqId);
				fileContent.setSubject(newSubject);
				fileContent.setSendTime(YHUtility.parseTimeStamp());
				fileContent.setAttachmentId(currDate + "_" + rand + ",");
				fileContent.setAttachmentName(attachName + "*");
				orm.saveSingle(dbConn, fileContent);
				flag = true;
			}
			return flag;
		} catch (Exception e) {
			throw e;
		}
	}

	/**
	 * ???????????????SeqId???
	 * 
	 * 
	 * @param dbConn
	 * @return
	 */
	public YHFileContent getMaxSeqId(Connection dbConn) {
		// String sql="select MAX(SEQ_ID) from file_sort";
		String sql = "select SEQ_ID from oa_file_content where SEQ_ID=(select MAX(SEQ_ID) from oa_file_content ) ";
		YHFileContent content = null;
		int seqId = 0;
		// String sortName = "";
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = dbConn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				content = new YHFileContent();
				seqId = rs.getInt("SEQ_ID");
				content.setSeqId(seqId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			YHDBUtility.close(ps, rs, log);
		}
		return content;
	}

	/**
	 * ?????????????????????
	 * 
	 * 
	 * @param userSeqId
	 * @param ids
	 * @param dbConn
	 * @return
	 * @throws Exception
	 * @throws Exception
	 */
	public boolean isHaveReaderId(int userSeqId, String ids) throws Exception, Exception {
		boolean flag = false;
		if (ids != null && !"".equals(ids.trim())) {
			String[] aId = ids.split(",");
			for (String tmp : aId) {
				if (!"".equals(tmp.trim())) {
					if (Integer.parseInt(tmp) == userSeqId) {
						flag = true;
					}
				}
			}
		}
		return flag;
	}

	public void updateReader(Connection dbConn, String contentId, int loginUserSeqId) throws NumberFormatException, Exception {
		String[] seqIdStr = contentId.split(",");
		if (!"".equals(contentId) && contentId.split(",").length > 0) {
			for (String seqId : seqIdStr) {
				YHFileContent content = this.getFileContentInfoById(dbConn, Integer.parseInt(seqId));
				String readStr = YHUtility.null2Empty(content.getReaders());
				if (readStr != null && !"".equals(readStr.trim()) && readStr.lastIndexOf(',') == -1) {
					readStr += ",";
				}
				boolean isRead = this.isHaveReaderId(loginUserSeqId, readStr);
				if (!isRead) {
					String readers = readStr.trim() + String.valueOf(loginUserSeqId) + ",";
					content.setReaders(readers.trim());
					this.updateSingleObj(dbConn, content);
				}
			}
		}
	}

	/**
	 * ??????????????????????????????
	 * 
	 * @param dbConn
	 * @param subjectName
	 * @return
	 * @throws Exception
	 */
	public String checkSubjectName(Connection dbConn, int seqId, int subContentId, String subjectName) throws Exception {
		String data = "";
		boolean isHave = false;
		int isHaveFlag = 0;

		Map map = new HashMap();
		map.put("SORT_ID", seqId);
		try {
			List<YHFileContent> contentList = this.getFileContentsInfo(dbConn, map);
			if (subContentId != 0) {
				if (contentList != null && contentList.size() > 0) {
					for (YHFileContent content : contentList) {
						String subject = YHUtility.null2Empty(content.getSubject());
						int contentId = content.getSeqId();
						if (subContentId != contentId) {
							if (subjectName.trim().equals(subject.trim())) {
								isHave = true;
								break;
							}
						}
					}
				}
			} else {
				if (contentList != null && contentList.size() > 0) {
					for (YHFileContent content : contentList) {
						String subject = YHUtility.null2Empty(content.getSubject());
						if (subjectName.trim().equals(subject.trim())) {
							isHave = true;
							break;
						}
					}
				}
			}

			if (isHave) {
				isHaveFlag = 1;
			}
			data = "{isHaveFlag:\"" + isHaveFlag + "\" }";

		} catch (Exception e) {
			throw e;
		}
		return data;
	}

	/**
	 * ??????????????????????????????
	 * 
	 * @param dbConn
	 * @param subjectName
	 * @return
	 * @throws Exception
	 */
	public String checkEditSubjectName(Connection dbConn, int seqId, int subContentId, String subjectName) throws Exception {
		String data = "";
		boolean isHave = false;
		int isHaveFlag = 0;

		Map map = new HashMap();
		map.put("SORT_ID", seqId);
		try {
			List<YHFileContent> contentList = this.getFileContentsInfo(dbConn, map);
			if (contentList != null && contentList.size() > 0) {
				for (YHFileContent content : contentList) {
					String subject = YHUtility.null2Empty(content.getSubject());
					int contentId = content.getSeqId();
					if (subContentId != contentId) {
						if (subjectName.trim().equals(subject.trim())) {
							isHave = true;
							break;
						}
					}
				}
			}
			if (isHave) {
				isHaveFlag = 1;
			}
			data = "{isHaveFlag:\"" + isHaveFlag + "\" }";

		} catch (Exception e) {
			throw e;
		}
		return data;
	}

	/**
	 * ???????????????????????????????????????
	 * 
	 * 
	 * @param attIdStr
	 * @param attNameStr
	 * @return
	 * @throws Exception
	 */
	public String isHaveFileInDisk(String attIdStr, String attNameStr) throws Exception {

		int isHaveFile = 0;
		String filePath = "";
		String oldFilePath = "";
		try {
			if (!"".equals(attIdStr.trim()) && !"".equals(attNameStr.trim())) {
				String currDate = this.getFilePathFolder(attIdStr);
				String fileId = this.getAttaId(attIdStr);
				String fileName = fileId + "_" + attNameStr;
				String oldFileName = fileId + "." + attNameStr;

				filePath = YHSysProps.getAttachPath() + File.separator + "file_folder" + File.separator + currDate + File.separator + fileName; // YHSysProps.getAttachPath()??????
				oldFilePath = YHSysProps.getAttachPath() + File.separator + "file_folder" + File.separator + currDate + File.separator + oldFileName; // YHSysProps.getAttachPath()??????
			}
			File file = new File(filePath);
			File oldFile = new File(oldFilePath);
			if (file.exists()) {
				isHaveFile = 1;
			} else if (oldFile.exists()) {
				isHaveFile = 1;
			}
			String data = "{isHaveFile:\"" + isHaveFile + "\"}";
			return data;
		} catch (Exception e) {
			throw e;
		}
	}

	/**
	 * ?????????????????????????????????
	 * 
	 * @param dbConn
	 * @return
	 * @throws Exception
	 */
	public List<Map<Object, Object>> selectNewContent(Connection dbConn) throws Exception {
		List<Map<Object, Object>> list = new ArrayList<Map<Object, Object>>();
		Statement stmt = null;
		ResultSet rs = null;
		// String sql =
		// "select a.SEQ_ID,a.SUBJECT,a.SEND_TIME,a.READERS,b.SEQ_ID as SORT_ID,b.SORT_NAME,b.USER_ID,b.OWNER  from FILE_CONTENT a,FILE_SORT b where a.SORT_ID=b.SEQ_ID and b.SORT_TYPE!='4' and rownum between (1) and (150) order by a.SEND_TIME desc";
		// String sql =
		// "select * from ( select aa.*,rownum row_num from ( select a.SEQ_ID,a.SUBJECT,a.SEND_TIME,a.READERS,b.SEQ_ID as SORT_ID,b.SORT_NAME,b.USER_ID,b.OWNER, b.sort_type  from FILE_CONTENT a,FILE_SORT b where a.SORT_ID = b.SEQ_ID and (b.SORT_TYPE != '4' or b.SORT_TYPE is  NULL) order by a.SEND_TIME desc )aa )bb  where bb.row_num between 1 and 10";
		String query ="";
	    String dbms = YHSysProps.getString(YHSysPropKeys.DBCONN_DBMS);
	    if(dbms.equals(YHConst.DBMS_MYSQL)){
	    	query = "select a.SEQ_ID,a.SUBJECT,a.SEND_TIME,a.READERS,b.SEQ_ID as SORT_ID,b.SORT_NAME,b.USER_ID,b.OWNER, b.sort_type  from oa_file_content a,oa_file_sort b where a.SORT_ID = b.SEQ_ID and (b.SORT_TYPE != '4' or b.SORT_TYPE is  NULL) order by a.SEND_TIME desc limit 10";
	    }else if(dbms.equals(YHConst.DBMS_ORACLE)){
	    	query = "select * from (select a.SEQ_ID,a.SUBJECT,a.SEND_TIME,a.READERS,b.SEQ_ID as SORT_ID,b.SORT_NAME,b.USER_ID,b.OWNER, b.sort_type  from oa_file_content a,oa_file_sort b where a.SORT_ID = b.SEQ_ID and (b.SORT_TYPE != '4' or b.SORT_TYPE is  NULL) order by a.SEND_TIME desc ) where rownum<=10";
	    }
		

		try {
			stmt = dbConn.createStatement();
			rs = stmt.executeQuery(query);
			int count = 0;
			while (rs.next() && count++ < 10) {
				Map<Object, Object> map = new HashMap<Object, Object>();
				YHFileContent content = new YHFileContent();
				content.setSeqId(rs.getInt("SEQ_ID"));
				content.setSubject(rs.getString("SUBJECT"));
				content.setSendTime(rs.getTimestamp("SEND_TIME"));

				map.put("contentId", rs.getInt("SEQ_ID"));
				map.put("subject", rs.getString("SUBJECT"));
				map.put("sendTime", rs.getObject("SEND_TIME"));
				map.put("sortId", rs.getInt("SORT_ID"));
				map.put("sortName", rs.getString("SORT_NAME"));
				map.put("userId", rs.getString("USER_ID"));
				map.put("owner", rs.getString("OWNER"));
				map.put("readers", rs.getString("READERS"));
				list.add(map);
			}

		} catch (Exception e) {
			throw e;
		} finally {
			YHDBUtility.close(stmt, rs, log);
		}
		return list;
	}

	/**
	 * ??????userId???owner???????????????
	 * 
	 * 
	 * @param dbConn
	 * @param sortId
	 * @return
	 * @throws Exception
	 */
	public boolean getVisiPriv(Connection dbConn, YHFileSort fileSort, YHPerson user) throws Exception {
		boolean flag = false;

		int loginUserSeqId = user.getSeqId();
		int loginUserDeptId = user.getDeptId();
		String loginUserRoleId = user.getUserPriv();

		int visiPrivFlag = 0;
		int ownerPrivFlag = 0;

		YHFileSortLogic logic = new YHFileSortLogic();
		String[] actions = new String[] { "USER_ID", "OWNER" };

		try {
			for (int i = 0; i < actions.length; i++) {
				if ("USER_ID".equals(actions[i])) {
					String userPrivs = logic.selectManagerIds(dbConn, fileSort, "USER_ID");
					String rolePrivs = logic.getRoleIds(dbConn, fileSort, "USER_ID");
					String deptPrivs = logic.getDeptIds(dbConn, fileSort, "USER_ID");
					boolean userFlag = logic.getUserIdStr(loginUserSeqId, userPrivs, dbConn);
					boolean deptFlag = logic.getDeptIdStr(loginUserDeptId, deptPrivs, dbConn);
					boolean roleFlag = logic.getRoleIdStr(loginUserRoleId, rolePrivs, dbConn);
					if (userFlag || deptFlag || roleFlag) {
						visiPrivFlag = 1;
					}
				}

				if ("OWNER".equals(actions[i])) {
					String userPrivs = logic.selectManagerIds(dbConn, fileSort, "OWNER");
					String rolePrivs = logic.getRoleIds(dbConn, fileSort, "OWNER");
					String deptPrivs = logic.getDeptIds(dbConn, fileSort, "OWNER");
					boolean userFlag = logic.getUserIdStr(loginUserSeqId, userPrivs, dbConn);
					boolean deptFlag = logic.getDeptIdStr(loginUserDeptId, deptPrivs, dbConn);
					boolean roleFlag = logic.getRoleIdStr(loginUserRoleId, rolePrivs, dbConn);
					if (userFlag || deptFlag || roleFlag) {
						ownerPrivFlag = 1;
					}
				}
			}
			if (visiPrivFlag == 1 || ownerPrivFlag == 1) {
				flag = true;
			}
		} catch (Exception e) {
			throw e;
		}
		return flag;
	}

	/**
	 * ??????????????????
	 * 
	 * @param dbConn
	 * @param fileSort
	 * @return
	 * @throws Exception
	 */
	public boolean getDownPriv(Connection dbConn, YHFileSort fileSort, YHPerson user) throws Exception {
		boolean flag = false;
		int loginUserSeqId = user.getSeqId();
		int loginUserDeptId = user.getDeptId();
		String loginUserRoleId = user.getUserPriv();
		int downPrivFlag = 0;
		int managePrivFlag = 0;
		YHFileSortLogic logic = new YHFileSortLogic();
		String[] actions = new String[] { "DOWN_USER", "MANAGE_USER" };
		try {
			for (int i = 0; i < actions.length; i++) {
				if ("DOWN_USER".equals(actions[i])) {
					String userPrivs = logic.selectManagerIds(dbConn, fileSort, "DOWN_USER");
					String rolePrivs = logic.getRoleIds(dbConn, fileSort, "DOWN_USER");
					String deptPrivs = logic.getDeptIds(dbConn, fileSort, "DOWN_USER");
					boolean userFlag = logic.getUserIdStr(loginUserSeqId, userPrivs, dbConn);
					boolean deptFlag = logic.getDeptIdStr(loginUserDeptId, deptPrivs, dbConn);
					boolean roleFlag = logic.getRoleIdStr(loginUserRoleId, rolePrivs, dbConn);
					if (userFlag || deptFlag || roleFlag) {
						downPrivFlag = 1;
					}
				}
				if ("MANAGE_USER".equals(actions[i])) {
					String userPrivs = logic.selectManagerIds(dbConn, fileSort, "MANAGE_USER");
					String rolePrivs = logic.getRoleIds(dbConn, fileSort, "MANAGE_USER");
					String deptPrivs = logic.getDeptIds(dbConn, fileSort, "MANAGE_USER");

					boolean userFlag = logic.getUserIdStr(loginUserSeqId, userPrivs, dbConn);
					boolean deptFlag = logic.getDeptIdStr(loginUserDeptId, deptPrivs, dbConn);
					boolean roleFlag = logic.getRoleIdStr(loginUserRoleId, rolePrivs, dbConn);
					if (userFlag || deptFlag || roleFlag) {
						managePrivFlag = 1;
					}
				}
			}

			if (downPrivFlag == 1 || managePrivFlag == 1) {
				flag = true;
			}

		} catch (Exception e) {
			throw e;
		}

		return flag;
	}

	/**
	 * ???????????????????????????
	 * 
	 * 
	 * @param readIdStr
	 * @param loginUser
	 * @return
	 * @throws Exception
	 */
	public boolean isReaders(String readStr, YHPerson loginUser) throws Exception {
		boolean returnFlag = false;
		int loginUserSeqId = loginUser.getSeqId();

		try {
			if (readStr != null && !"".equals(readStr.trim()) && readStr.lastIndexOf(',') == -1) {
				readStr += ",";
			}
			returnFlag = this.isHaveReaderId(loginUserSeqId, readStr);

		} catch (Exception e) {
			throw e;
		}

		return returnFlag;
	}

	/**
	 * ???????????????id???name
	 * 
	 * @param dbConn
	 * @param contentStrs
	 * @return
	 * @throws Exception
	 */
	public String getDownFileInfo(Connection dbConn, String contentStrs) throws Exception {
		String data = "";
		String attIdArry = "";
		String attNamedArry = "";
		int counter = 0;
		StringBuffer buffer = new StringBuffer();
		try {
			String[] seqIdStr = contentStrs.split(",");
			if (!"".equals(contentStrs) && contentStrs.split(",").length > 0) {
				for (String seqId : seqIdStr) {
					YHFileContent fileContent = this.getFileContentInfoById(dbConn, Integer.parseInt(seqId));
					String attachmentId = fileContent.getAttachmentId();
					String attachmentName = fileContent.getAttachmentName();

					if (!"".equals(attachmentId.trim()) && !"".equals(attachmentName.trim())) {
						attIdArry += attachmentId;
						attNamedArry += attachmentName;
					}
				}
			}

			String[] counterArry = attIdArry.split(",");
			if (counterArry != null && counterArry.length != 0) {
				for (int i = 0; i < counterArry.length; i++) {
					counter++;
					if (counter >= 3) {
						break;
					}
				}
			}

			data = "{attIdArry:\"" + attIdArry + "\",attNamedArry:\"" + attNamedArry + "\",counter:" + counter + "}";

		} catch (Exception e) {
			throw e;
		}

		return data;
	}

	/**
	 * ???????????????
	 * 
	 * 
	 * @return
	 * @throws Exception
	 */
	public boolean reNameOndisk(String oldNameStr, String attachId, String renameStr, String folderPath) throws Exception {
		boolean returnFlag = false;

		String fileFolder = this.getFilePathFolder(attachId); // 1006
		String filePath = folderPath + "/" + fileFolder;

		String attIdStr = this.getAttaId(attachId); // f40b24778d538764c902bbd547aa7802

		String oldName = attIdStr + "_" + oldNameStr; // f40b24778d538764c902bbd547aa7802_??????????????????????????????.docx
		String newName = attIdStr + "_" + renameStr; // f40b24778d538764c902bbd547aa7802_??????cc.docx

		String oldName2 = attIdStr + "." + oldNameStr;
		String newName2 = attIdStr + "." + renameStr;

		try {
			if (filePath != null && !"".equals(filePath.trim())) {

				File oldFile = new File(filePath + "/" + oldName);
				File newFile = new File(filePath + "/" + newName);

				File oldFile2 = new File(filePath + "/" + oldName2);
				File newFile2 = new File(filePath + "/" + newName2);

				if (!newFile.exists()) {
					if (oldFile.renameTo(newFile)) {
						returnFlag = true;
					}
				} else if (!newFile2.exists()) {
					if (oldFile2.renameTo(newFile2)) {
						returnFlag = true;
					}
				}

			}

		} catch (Exception e) {
			throw e;
		}

		return returnFlag;
	}

	public String updateAttachName(Connection dbConn, int contentId, String attachName, String attachId, String renameStr, String folderPath)
			throws Exception {
		YHORM orm = new YHORM();
		try {
			YHFileContent content = this.getFileContentInfoById(dbConn, contentId);
			String attIdDb = "";
			String attNameDb = "";
			if (content != null) {
				attIdDb = content.getAttachmentId();
				attNameDb = content.getAttachmentName();
			}

			String[] attIdArry = attIdDb.split(",");
			String[] attNameArry = attNameDb.split("\\*");

			String updateAttId = "";
			String updateAttName = "";

			if (attIdArry != null && attIdArry.length > 0) {
				for (int i = 0; i < attIdArry.length; i++) {
					String attIdTemp = attIdArry[i];
					if (attIdTemp.equals(attachId.trim())) {
						continue;
					}
					updateAttId += attIdTemp + ",";
					updateAttName += attNameArry[i] + "*";
				}
			}

			updateAttId = updateAttId + attachId + ",";
			updateAttName = updateAttName + renameStr + "*";

			content.setAttachmentId(updateAttId.trim());
			content.setAttachmentName(updateAttName.trim());
			orm.updateSingle(dbConn, content);

		} catch (Exception e) {
			throw e;
		}

		return "";

	}

	/**
	 * 
	 * @param attachmentName
	 * @param attachmentId
	 * @param module
	 * @return
	 * @throws Exception
	 */
	public HashMap toZipInfoMapFile(Connection dbConn, int sortId, String seqIds, String module, YHPerson loginUser)
			throws Exception {
		HashMap result = new HashMap();

		YHORM orm = new YHORM();
		if (seqIds == null || "".equals(seqIds.trim())) {
			return result;
		}
		if (seqIds.trim().endsWith(",")) {
			seqIds = seqIds.trim().substring(0, seqIds.trim().length() - 1);
		}
		String[] filters = { "SEQ_ID IN(" + seqIds + ")" };
		ArrayList<YHFileContent> fileContents = (ArrayList<YHFileContent>) orm.loadListSingle(dbConn, YHFileContent.class, filters);
		HashMap<String, Integer> subjectNames = new HashMap<String, Integer>();
		YHNtkoLogic ntkoLogic = new YHNtkoLogic();
		for (int j = 0; j < fileContents.size(); j++) {
			YHFileContent fileContent = fileContents.get(j);
			String[] attachmentArray = YHUtility.isNullorEmpty(fileContent.getAttachmentName()) ? new String[0] : fileContent.getAttachmentName().split("\\*");
			String[] attachmentIdArray = YHUtility.isNullorEmpty(fileContent.getAttachmentId()) ? new String[0] : fileContent.getAttachmentId().split(",");
			String subject = fileContent.getSubject();
			if (subjectNames.keySet().contains(subject.trim())) {
				int count = subjectNames.get(subject.trim());
				subject = subject + "_" + count;
				subjectNames.put(subject.trim(), count + 1);
			} else {
				subjectNames.put(subject.trim(), 1);
			}
			HashMap<String, Integer> filesName = new HashMap<String, Integer>();

			YHFileSort fileSort = new YHFileSort();
			boolean downPriv = true;
			if (sortId != 0) {
				fileSort = (YHFileSort) orm.loadObjSingle(dbConn, YHFileSort.class, sortId);
				// ????????????
				downPriv = this.getDownPriv(dbConn, fileSort, loginUser);
			}

			for (int i = 0; i < attachmentIdArray.length; i++) {
				if ("".equals(attachmentIdArray[i].trim()) || "".equals(attachmentArray[i].trim())) {
					continue;
				}

				String fileType = YHFileUtility.getFileExtName(attachmentArray[i].trim());
				// ???????????????office??????
				boolean isOffice = this.isOfficeFile("." + fileType);
				if (isOffice && !downPriv) {
					continue;
				}

				String attachName = attachmentArray[i].trim();
				String temp = ntkoLogic.getAttachBytes(attachName, attachmentIdArray[i].trim(), module);
				String fileName = "";
				if (temp != null) {
					String preName = attachName.substring(0, attachName.lastIndexOf("."));
					if (filesName.keySet().contains(attachName.trim())) {
						int count = filesName.get(attachName.trim());
						String extName = attachName.substring(attachName.lastIndexOf("."), attachName.length());
						fileName = preName + "_" + count + extName;
						filesName.put(attachName.trim(), count + 1);
					} else {
						filesName.put(attachName.trim(), 1);
						fileName = attachName;
					}
					result.put(subject + "/" + "??????" + "/" + fileName, temp); // ????????????
				}
				result.put(subject + "/" + "??????" + "/", null); // ???????????????????????????????????????
			}

			result.put(subject + "/", null); // ???????????????????????????
			String createName = this.getPersonNamesByIds(dbConn, String.valueOf(fileContent.getCreater()));

			String html = "<html><head><title>" + subject + "</title><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head>";
			html += "<style>body{font-size:12px;} table{border:1px #000 solid;border-collapse:collapse;} table td{border:1px #000 solid;}</style>";
			html += "<body><table width='70%' align='center'><tr><td align='center' colspan='2'><b><span class='big'>" + subject
					+ "&nbsp;</span></b></td></tr>";
			html += "<tr><td height='250' valign='top' colspan='2'>" + YHUtility.null2Empty(fileContent.getContent()) + "&nbsp;</td></tr>";
			html += "<tr class=small><td width='100'>????????????</td><td width='400'>" + createName + "&nbsp;</td></tr></table></body></html>";
			/* FileInputStream htmlIn = new FileInputStream( html.getBytes()); */
			InputStream in = new ByteArrayInputStream(html.getBytes("UTF-8"));
			result.put(subject + "/" + subject + ".html", in); // ?????????hmtl??????
		}

		return result;
	}

	/**
	 * ???????????????office??????
	 * 
	 * @param fileName
	 * @return
	 * @throws Exception
	 */
	public boolean isOfficeFile(String fileType) throws Exception {
		boolean flag = false;
		try {
			if (fileType != null && !"".equals(fileType.trim())) {
				if (".doc".equals(fileType) || ".xls".equals(fileType) || ".ppt".equals(fileType) || ".pps".equals(fileType) || ".docx".equals(fileType)
						|| ".xlsx".equals(fileType) || ".pptx".equals(fileType) || ".ppsx".equals(fileType) || "wps".equals(fileType) || ".et".equals(fileType)
						|| ".ett".equals(fileType)) {
					flag = true;
				}
			}
		} catch (Exception e) {
			throw e;
		}
		return flag;
	}

	/**
	 * ???????????????????????????????????????????????????
	 * 
	 * 
	 * @param dbConn
	 * @param seqId
	 * @param startCount
	 * @param endCount
	 * @return
	 * @throws Exception
	 */

	public YHPortalProducer getFileFolderInfoToDeskTop(Connection dbConn, int seqId, int startCount, int endCount) throws Exception {
		List<Object> list = new ArrayList<Object>();
		YHPortalProducer rule = new YHPortalProducer();
		YHORM orm = new YHORM();
		int k = 0;
		try {// //?????????????????????????????????seqId????????????????????????
			String[] condition = { " SORT_PARENT=" + seqId + " AND (SORT_TYPE !='4' or SORT_TYPE is null) order by SORT_NO,SORT_NAME" };
			List<YHFileSort> sortList = orm.loadListSingle(dbConn, YHFileSort.class, condition);
			if (sortList != null || sortList.size() > 0) {
				for (int i = startCount; i < startCount + endCount && k <= endCount && i < sortList.size(); i++) {
					YHFileSort fileSort = sortList.get(i);
					Map<String, String> map = new HashMap<String, String>();
					String sosrtName = YHUtility.null2Empty(fileSort.getSortName());
					map.put("fileName", sosrtName);
					map.put("isDir", "isDir");
					map.put("filePath", "'" + fileSort.getSeqId() + "'");
					list.add(map); // list ?????????????????????
				}
			}
			String[] filters = { "SORT_ID=" + seqId };// ?????????????????????????????????seqId?????????????????????
			List<YHFileContent> fileContents = orm.loadListSingle(dbConn, YHFileContent.class, filters);
			if (fileContents != null || fileContents.size() > 0) {
				for (int i = startCount; i < startCount + endCount && k <= endCount && i < fileContents.size(); i++) {
					YHFileContent fileContent = fileContents.get(i);
					String attachmentId = YHUtility.null2Empty(fileContent.getAttachmentId());
					String attachmentName = YHUtility.null2Empty(fileContent.getAttachmentName());
					String attaIdArry[] = attachmentId.split(",");
					String attaNameArry[] = attachmentName.split("\\*");
					if (!YHUtility.isNullorEmpty(attachmentId) && attaIdArry.length > 0) {
						for (int j = 0; j < attaIdArry.length; j++) {
							String fileName = attaNameArry[j];
							Map<String, String> map = new HashMap<String, String>();
							String fileType = "";
							if (fileName.lastIndexOf('.') != -1) {
								fileType = fileName.substring(fileName.lastIndexOf('.') + 1, fileName.length());
							}
							map.put("fileName", fileName);
							map.put("fileType", fileType);
							map.put("isDir", "isFile");
							map.put("filePath", "'" + fileContent.getSortId() + "'");
							list.add(map);// ??????list ?????????????????????
						}
					}
				}
			}
			rule.setData(list);
			YHLinkRule lr = new YHLinkRule("fileName", "filePath");
			YHImgRule imag = new YHImgRule("fileName", "filePath");
			rule.addRule(lr);
			rule.addRule(imag);
			// rule.toJson();
		} catch (Exception e) {
			throw e;
		}
		// System.out.println(list.toString());
		return rule;
	}

	/**
	 * ???????????????????????????
	 * 
	 * @param dbConn
	 * @param sortId
	 * @param subject
	 * @return
	 * @throws Exception
	 */
	public boolean isExistFile(Connection dbConn, int sortId, String subject) throws Exception {
		boolean flag = false;
		int counter = 0;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sql = "select count(SEQ_ID) from oa_file_content where SORT_ID = ? and SUBJECT=?";
		try {
			stmt = dbConn.prepareStatement(sql);
			stmt.setInt(1, sortId);
			stmt.setString(2, subject);
			rs = stmt.executeQuery();
			if (rs.next()) {
				counter = rs.getInt(1);
			}
			if (counter > 0) {
				flag = true;
			}
		} catch (Exception e) {
			throw e;
		} finally {
			YHDBUtility.close(stmt, rs, log);
		}
		return flag;
	}

	/**
	 * ??????????????????????????????????????????
	 * 
	 * @param dbConn
	 * @param buffer
	 * @param sortId
	 * @param subject
	 * @throws Exception
	 */
	public void copyExistFile(Connection dbConn, StringBuffer buffer, int sortId, String subject) throws Exception {
		try {
			String temp = subject + " - ??????";
			String subjectSuffix = temp;
			int repeat = 1;
			while (this.isExistFile(dbConn, sortId, subjectSuffix)) {
			  repeat++;
			  subjectSuffix = temp + "(" + repeat + ")";
			}
			buffer.append(subjectSuffix);
		} catch (Exception e) {
			throw e;
		}
	}

}
