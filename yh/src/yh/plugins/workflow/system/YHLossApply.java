package yh.plugins.workflow.system;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;



import yh.core.funcs.workflow.util.YHIWFHookPlugin;

public class YHLossApply implements YHIWFHookPlugin {

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * yh.core.funcs.workflow.util.YHIWFHookPlugin#execute(java.sql.Connection,
	 * int, java.util.Map, java.util.Map, boolean)
	 */
	@Override
	public String execute(Connection dbConn, int runId, Map arrayHandler,
			Map formData, boolean agree) throws Exception {

		dbConn.setAutoCommit(false);
		String lossId = (String) arrayHandler.get("KEY");// 仓库发货单id
		Statement st = dbConn.createStatement();
		// 1.将仓库发货单的状态为“客户验收不通过，有退货”
		try {
			updatePP(dbConn, lossId);
			dbConn.commit();
		} catch (Exception e) {
			dbConn.rollback();
			throw e;
		}
		return null;
	}
	public void updatePP(Connection dbConn,String lossId)throws Exception{
//		List<Map<String,Object>> ppList = getLP(dbConn, lossId);
//		Statement st  = dbConn.createStatement();
//		try{
//			if(ppList != null ){
//				for(int i=0;i<ppList.size();i++){
//					
//					String pro_id = (String) ppList.get(i).get("proId");//这是产品的id
//					String number = (String) ppList.get(i).get("num");//这是盘点数量
//				
//					if(number != null){
//						String sql2 = "update erp_db_log set status='"+StaticData.OVER+"' where pod_id='"+lossId+"'";
//						st.executeUpdate(sql2);
//						
//						List<Map<String,Object>> dbLogList=this.getDb(dbConn, lossId,pro_id);
//						for(int k=0;k<dbLogList.size();k++){
//							String whId = (String) dbLogList.get(k).get("whId");
//							int num = Integer.parseInt( dbLogList.get(k).get("number").toString());
//							String flag = (String) dbLogList.get(i).get("flag");//这是盘点类型
//							int  dbNum=getDbById(dbConn, pro_id, whId);
//							if("报损".equals(flag)){
//							num=dbNum-num;
//							}else{
//								
//							num=dbNum+num;
//							}
//							String sql5= "update erp_db set num="+num+" where pro_id='"+pro_id+"' and wh_id='"+whId+"'";
//							st.executeUpdate(sql5);
//						}
//					}
//					else{
//					}
//				}
//			}
//			
//			//修改该退货单的状态为已完成
//			String sql = "update erp_loss set status = '"+StaticData.OVER+"' where id='"+lossId+"'";
//			st.executeUpdate(sql);
//		}
//		catch (Exception e) {
//			throw e;
//		}
	}
	
	private int getDbById(Connection dbConn,String proId,String whId)throws Exception{
		Statement st  = null;
		ResultSet rs = null;
		try{
			st = dbConn.createStatement();
			String sql = "SELECT num FROM erp_db WHERE pro_id='"+proId+"' and wh_id='"+whId+"'";
			rs = st.executeQuery(sql);
			while(rs.next()){
				return rs.getInt("num");
			}
		}
		catch (Exception e) {
			throw e;
		}
		return 0;
	}
	/**
	 * 根据仓库盘点单查询对应的报损或者报溢数量
	 * @param dbConn
	 * @param pod_id
	 * @return
	 * @throws Exception
	 */
	private List<Map<String,Object>> getLP(Connection dbConn,String lossId)throws Exception{
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		Statement st  = null;
		ResultSet rs = null;
		try{
			st = dbConn.createStatement();
			String sql = "SELECT pro_id,num FROM erp_loss loss LEFT JOIN erp_loss_pro lp ON lp.loss_id=loss.id where loss.id='"+lossId+"'";
			rs = st.executeQuery(sql);
			while(rs.next()){
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("proId", rs.getString("pro_id"));
				map.put("num", rs.getString("num"));
				list.add(map);
			}
			if(list.size() > 0){
				return list;
			}
		}
		catch (Exception e) {
			throw e;
		}
		return null;
	}

	
	private List<Map<String,Object>> getDb(Connection dbConn,String lossId,String pro_id)throws Exception{
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		Statement st  = null;
		ResultSet rs = null;
		try{
			st = dbConn.createStatement();
			String sql = "SELECT  flag, wh_id,pro_id,number FROM erp_db_log WHERE pod_id= '"+lossId+"'";
			rs = st.executeQuery(sql);
			while(rs.next()){
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("whId", rs.getString("wh_id"));
				map.put("proId", rs.getString("pro_id"));
				map.put("number", rs.getString("number"));
				map.put("flag", rs.getString("flag"));
				list.add(map);
			}
			if(list.size() > 0){
				return list;
			}
		}
		catch (Exception e) {
			throw e;
		}
		return null;
	}

}
