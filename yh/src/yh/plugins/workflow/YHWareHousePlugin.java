package yh.plugins.workflow;

import java.sql.Connection;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import yh.core.data.YHRequestDbConn;
import yh.core.funcs.workflow.util.YHFlowRunUtility;
import yh.core.funcs.workflow.util.YHIWFPlugin;
import yh.core.global.YHBeanKeys;

public class YHWareHousePlugin implements YHIWFPlugin{

	@Override
	public String after(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return null;
	}

	@Override
	public String before(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
//		try {
//		      YHRequestDbConn requestDbConn = (YHRequestDbConn) request
//		          .getAttribute(YHBeanKeys.REQUEST_DB_CONN_MGR);
//		      Connection conn = requestDbConn.getSysDbConn();
//		      String flowIdStr = request.getParameter("flowId");
//		      String runIdStr = request.getParameter("runId");
//		    
//		      int runId = Integer.parseInt(runIdStr);
//		      int flowId = Integer.parseInt(flowIdStr);
//		     
//		      YHFlowRunUtility wf = new YHFlowRunUtility();
//		    
//		      String pod_id =  wf.getData(conn, flowId, runId, "发货单ID");
//		      
//		      //修改状态为审核中，此时发货单不能修改
//		      String sql = "update erp_order_product_out_detail set pod_status = '"+StaticData.AUDITING+"' where id='"+pod_id+"'";
//		      Statement st  = conn.createStatement();
//		      st.executeUpdate(sql);
//		} catch(Exception ex) {
//		      throw ex;
//		    }
		    
		return null;
	}

}
