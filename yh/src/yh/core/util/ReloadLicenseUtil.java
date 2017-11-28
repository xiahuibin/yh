package yh.core.util;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ReloadLicenseUtil {
//	public static String LICENSE_FILE_PATH1 = ""; //系统级别的变量
	public static boolean sysUseLinsenceServletFlag = false; //系统级别的变量
	public static boolean sysLinsencePageErrorFlag = false; //系统级别的变量
	public static String appCompany="";
	public  static int  userCounts = 0; 
	 public static String lincenseUserCompany="";
//	 public static int lincenseUserNum=0;  
	 public static long lincenseEndTime=0;
	 public static boolean hasReg = false;
//	 public static boolean isCompanyAdapt(){
//		  if("木星软件".equalsIgnoreCase(ReloadLicenseUtil.lincenseUserCompany))
//			  return true;
//		  if("木星软件工作室".equalsIgnoreCase(ReloadLicenseUtil.lincenseUserCompany))
//			  return true;
//     if(ReloadLicenseUtil.lincenseUserCompany.equalsIgnoreCase(ReloadLicenseUtil.appCompany))
//  	   return true;
//     return false;
//	  }
//	 public static boolean isUserNumAdapt(){
//		  if(lincenseUserNum<ReloadLicenseUtil.userCounts)
//			  return false;
//		  return true;
//	  }
//	 
//	 public static boolean isDateAdapt(){
//		  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		  long nowSysTime;
//		try {
//			nowSysTime = sdf.parse(new Date().toLocaleString()).getTime();
//			if(lincenseEndTime>nowSysTime)
//			{
//				  return true;
//			}
//			  return false;
//		} catch (ParseException e) {
//			e.printStackTrace();
//		}
//		return false;
//	  }
//	 
//	  public static String leaveDate(){
//		   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		   
//		   try {
//			 long nowDate=sdf.parse(new Date().toLocaleString()).getTime();
//			 long leaveTime=ReloadLicenseUtil.lincenseEndTime-nowDate;
//			 long leaveDate=leaveTime/(1000*60*60*24);
//			 return String.valueOf(leaveDate);
//		} catch (ParseException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		return "0";
//	  }
}
