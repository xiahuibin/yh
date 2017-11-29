package yh.oa.tools;

import java.util.HashMap;
import java.util.Map;

public class StaticData {
public static final String SOFTTITLE="协同办公系统";
public static final String SOFTTITLE_SHORT="协同办公系统";
public static final String SOFTCOMPANY="信息科技有限公司";
public static final String SOFTCOMPANY_SHORTNAME="协同办公系统";
public static final String SOFTKEYWORD="ERP,JCRM,JOA,JCM,进销存";

public static  String VERSIONDESC="协同办公系统";
public static Map versionMap=new HashMap();
//public static final String SOFTVERSION="A6-CERP*";
static{
	
	versionMap.put("JOA-P*", "JOA智能管理企业版");
}
public static Map signaturerMap=new HashMap();
static{
	
	signaturerMap.put("JOA-P*", "aqpInuM5eIE92yBWUUHQKnxLv1r5GgPKmoOY5Uv/MECvXBtZcAXQelGnDA1uycySGwhv9oqoRGRW4P61NtrBdJPVNNj5YFfP+8HNRy5kxYt6lWNO5OZTrHc7rPX2vQ+aWfvJFfR4ahUSFKhNyYUU5DO8Ca/kodfENWQ+tEVoYkA=");
}
/*office 控件控制的关键字，引入插件账户后进行更改*/
//public static final String MakerCaption="南京一恒软件工程有限公司";
//public static final String MakerKey="57C56F3DB420B8FCD06B56515D8BCCACCC2CF4F6";
//
//public static final String ProductCaption="乌鲁木齐市商业银行";
//public static final String ProductKey= "7CB626C174A599E7770C8E07C8756BEC377656B9";
//public static final String Classid="clsid:01DFB4B4-0E07-4e3f-8B7A-98FD6BFF153F";//"clsid:C9BC4DFF-4248-4a3c-8A49-63A7D317F404";
//public static final String Codebase="OfficeControl.cab#version=5,0,2,1";


/*测试使用版本*/
public static final String MakerCaption="";
public static final String MakerKey="";

public static final String ProductCaption="";
public static final String ProductKey= "";
public static final String Classid="clsid:A39F1330-3322-4a1d-9BF0-0BA2BB90E970";//"clsid:C9BC4DFF-4248-4a3c-8A49-63A7D317F404";
public static final String Codebase="OfficeControl.cab#version=5,0,0,6";


/*相关的页面下载链接，可以在官方网站下载文件或者在本地网站下载，具体项目进行更改*/
public static final String YIHENG="Q5";
public static final String YH_WEB_SITE="http://www.zmmx.com";
public static final String YH_DOWN_SITE1="http://down.zmmx.com/";

public static final String YH_MACHINECODE_SITE ="http://oa.zmmx.com/";
public static final String YH_HERO_SITE="http://oa.zmmx.com/hero/";
public static final String YH_OA_SITE="www.zmmx.com";

//文件管理
public static final String ROLLFILE="2240";
//通告
public static final String NOTIFY="0506";


}
