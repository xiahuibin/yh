package yh.core.funcs.workflow.praser;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import yh.core.funcs.person.data.YHPerson;
import yh.core.funcs.workflow.data.YHFlowFormItem;
import yh.core.funcs.workflow.data.YHFlowRunData;
import yh.core.funcs.workflow.util.YHWorkFlowUtility;
import yh.core.util.YHUtility;
import yh.core.util.db.YHDBUtility;

public class YHPraseData2PrintForm {
  
  public String parsePrintForm(YHPerson user,String modelShort, 
    int  runId, int flowId, List<YHFlowRunData> frdList,
    List<YHFlowFormItem> itemList ,Connection conn , boolean isWord) throws Exception {
    if (YHWorkFlowUtility.isSave2DataTable()){
      YHPraseData2FormUtility util = new YHPraseData2FormUtility();
      frdList = util.tableData2FlowRunData(conn ,  flowId,  runId  , itemList );
    }  
    //-----------判断字段对于当前用户是否为隐藏----------------
      String hidden = "";
      String query = "select HIDDEN_ITEM from oa_fl_process,oa_fl_run_prcs as FLOW_RUN_PRCS " 
        + "where oa_fl_process.FLOW_SEQ_ID="+ flowId
        + " and FLOW_RUN_PRCS.RUN_ID="+ runId
        + " and FLOW_RUN_PRCS.USER_ID="+ user.getSeqId() 
        + " and oa_fl_process.PRCS_ID=FLOW_RUN_PRCS.FLOW_PRCS";
      Statement stm = null;
      ResultSet rs = null;
      try {
        stm = conn.createStatement();
        rs = stm.executeQuery(query);
        while(rs.next()){
          String tmp = rs.getString("HIDDEN_ITEM");
          if(tmp != null && !"".equals(tmp)){
            hidden += tmp;
          }
        }
      } catch(Exception ex) {
        throw ex;
      } finally {
        YHDBUtility.close(stm, rs, null); 
      }
      if (itemList.size() < 0 ) {
        String content = YHWorkFlowUtility.Message("表单内容为空", 2);
        return content;
      }
      
      String signObject = "";
      String signCheckStr = "";
      boolean isHaveSign = false;
      for (YHFlowFormItem item : itemList) {
        String realValue = "";
        int itemId = item.getItemId();
        YHFlowRunData flowRunData = this.getFlowRunData(frdList, itemId);
        if(flowRunData != null 
            && flowRunData.getItemData() != null){
          realValue = flowRunData.getItemData();
          String type = item.getType();
          if ("hidden".equals(type)) {
            flowRunData.setItemData("");
            continue;
          }
          realValue = YHWorkFlowUtility.getOutSpecialChar(realValue);
        }
        String tag = item.getTag();
        String title = item.getTitle();
        String content = item.getContent();
        String clazz = item.getClazz();
        String tag1 = tag.toLowerCase();
        if (content != null)
          content = content.replace("<" + tag1, "<" + tag);
        item.setContent(content);
        //判断是否是保密字段
        if (YHWorkFlowUtility.findId(hidden, title)) {
          // 替换为空
          realValue = "";
        }
        
        if("DATE".equals(clazz) || "USER".equals(clazz)){
          realValue = "";
          modelShort = modelShort.replaceAll("\\{" + item.getName() + "\\}", realValue);
          continue;
        } else if ("RADIO".equals(clazz)
            && "IMG".equals(tag)) {
          String radioField = YHUtility.null2Empty(item.getRadioField());
          String radioCheck = YHUtility.null2Empty(item.getRadioCheck());
          String[] radioArray = radioField.split("`");
          String name = item.getName();
          String disabled = "";
          if (!YHUtility.isNullorEmpty(realValue)) {
            radioCheck = realValue;
          }
          disabled =  "disabled";
          realValue = "";
          for (String s : radioArray) {
            String checked = "";
            if (s.equals(radioCheck)) {
              checked = "checked";
            }
            realValue += "<input type=\"radio\" name=\""+name+"\" value=\""+s+"\" "+checked+" "+disabled+"><label>"+ s +"</label>&nbsp;";
          }
        } else if("SELECT".equals(tag) && !"AUTO".equals(clazz)){
          String child = item.getChild();
          if(child != null && !"".equals(child)){
            for (YHFlowFormItem tmp : itemList) {
              int itemId2 = tmp.getItemId();
              String title2 = tmp.getTitle();
              String clazz2 = tmp.getClazz();
              String tag2 = tmp.getTag();

              if ("DATE".equals(clazz2) || "USER".equals(clazz2)) {
                continue;
              }
              if (YHWorkFlowUtility.findId(child , title2) 
                  && "SELECT".equals(tag2)) {
                YHFlowRunData rd = this.getFlowRunData(frdList, itemId2);
                String childValue = rd.getItemData();
                if (rd != null && childValue != null && !"".equals(childValue)) {
                  childValue = childValue.replaceAll("\"", "&quot;");
                  childValue = childValue.replaceAll("<", "&lt;");
                  childValue = childValue.replaceAll(">", "&gt;");
                  int index = childValue.indexOf("|");
                  if (index != -1) {
                    childValue = childValue.substring(0 , index);
                    rd.setItemData(childValue);
                  }
                }
                break;
              }
            }
          }
        }else if("AUTO".equals(clazz) && "SELECT".equals(tag) && !"".equals(realValue)){
        }else if("LIST_VIEW".equals(clazz)){
          int sumFlag = 0 ;
          String lvTitle = item.getLvTitle();
          String lvAlign = item.getLvAlign();
          if ( lvAlign == null ) {
            lvAlign = "";
          }
          if ( lvTitle == null ) {
            lvTitle = "";
          }
          String lvSize = item.getLvSize();
          if ( lvSize == null ) {
            lvSize = "";
          }
          String lvSum = item.getLvSum();
          if ( lvSum == null ) {
            lvSum = "";
          }
          
          String[] lvSumArray = lvSum.split("`");
          if (lvSum.indexOf("1") != -1) {
            sumFlag = 1;
          }
          String[] myArraySize = lvSize.split("`");
          String lvValue = realValue;
          realValue = "<TABLE class='LIST_VIEW' style='border-collapse:collapse' border=1 cellspacing=0 cellpadding=2><TR style='font-weight:bold;font-size:14px;' class='LIST_VIEW_HEADER'>";
          String[] myArray = lvTitle.split("`");
          
          int arrayCountTitle = myArray.length;
          String[] alignArray = lvAlign.split("`");
          for (int t = 0 ;t < arrayCountTitle ; t++) {
            String tmp = myArray[t];
            String align = "";
            if (alignArray.length > t) {
              align = alignArray[t];
            }
            if ("".equals(align) || align == null) {
              align = "left";
            }
            realValue += "<TD nowrap align='"+ align +"'>" + tmp + "</TD>";
          }
          realValue += "</TR>";
          lvValue = lvValue.replace("&#13;", "");
          myArray = lvValue.split("&#10;");
          int arrayCount = myArray.length;
          Float[] sumData = new Float[arrayCountTitle];
          
          for (String tmp : myArray) {
            String[] myArray1 = tmp.split("`");
            
            if (!"".equals(tmp) && myArray1.length > 0) {
              realValue += "<tr>";
              for (int j = 0 ;j < arrayCountTitle; j++) {
                if (  j < myArray1.length 
                    && "1".equals(lvSumArray[j]) 
                    && myArray1[j] != null
                    && YHUtility.isNumber(myArray1[j])) {
                  if (sumData[j] == null) {
                    sumData[j] = new Float(0) ;
                  }
                  sumData[j] += Float.parseFloat(myArray1[j]);
                }
                String tdData = "";
                if (j < myArray1.length && !"".equals(myArray1[j]) ) {
                  tdData = myArray1[j];
                } else {
                  tdData = "&nbsp;";
                }
                int l = Integer.parseInt(myArraySize[j]);
                String align = "";
                if (alignArray.length > j) {
                  align = alignArray[j];
                }
                if ("".equals(align) || align == null) {
                  align = "left";
                }
                
                
                realValue += "<td width=" + (l * 9) +" align='"+ align +"'>"+ tdData +"</td>";
              }
              realValue += "</tr>";
            }
          }
          if (sumFlag == 1 && arrayCount > 0 ) {
            realValue += "<tr style='font-weight:bold;'>";
            for (int j= 0 ; j < arrayCountTitle ; j++) {
              String sumValue = "";
              if ("".equals(sumData[j]) || sumData[j] == null) {
                sumValue = "&nbsp;";
              } else {
                sumValue = "合计：" + sumData[j];
              }
              int l = Integer.parseInt(myArraySize[j]);
              realValue += "<td align=right width="+ (l * 9) +">" + sumValue +"</td>";
            }
            realValue += "<td>";
          }
          realValue +="</TABLE>";
        }else if("SIGN".equals(clazz)){
          if (isWord) {
            realValue = "";
          } else {
            String signId = "DATA_" + itemId;
            String itemCheck = "";
            String signCheck = "";
            if (item.getDatafld() != null) {
              signCheck =  item.getDatafld();
            }
            if (!signCheck.endsWith(",")) {
              signCheck += ",";
            }
            for (YHFlowFormItem item2 : itemList) {
              String title2 = item2.getTitle();
              String clazz2 = item2.getClazz();
              int itemId2 = item2.getItemId();

              if ("DATE".equals(clazz2) || "USER".equals(clazz2)) {
                continue;
              }
              if (YHWorkFlowUtility.findId(signCheck, title2)) {
                itemCheck += "DATA_" + itemId2 + ",";
              }
            }
            signCheckStr += "\"" + signId + "\":\"" + itemCheck + "\",";
            signObject += signId + ",";
            String tmp = "<div id=SIGN_POS_"+ signId + ">&nbsp;</div>";
            realValue = tmp + "<input type=hidden id=DATA_"+ itemId + " name=DATA_"+ itemId + " value='"+ realValue +"' title='"+ title +"'>\n";
            isHaveSign = true;
          }
        }else if ("MODULE".equals(clazz)) {
          if (!YHWorkFlowUtility.findId(hidden, title)) {
            String module = item.getValue();
            String divId = "module-" + module  + "-DATA_"+ itemId;
            String moduleSeqId = realValue;
            realValue = "<div id=\""+ divId +"\">"+ content +"</div>";
            realValue += "<script>";
            realValue += "printModuleContent(\""+ module +"\" , \""+ divId +"\" ,  \""+ moduleSeqId +"\")";
            realValue += "</script>";
          }
        }else{
          if("AUTO".equals(clazz) && "{宏控件}".equals(realValue)){
            realValue = "";
          }
          realValue = realValue.replaceAll("<", "&lt;");
          realValue = realValue.replaceAll(">", "&gt;");
          realValue = realValue.replaceAll("  ", "&nbsp;&nbsp;");
          realValue = realValue.replaceAll("\r\n", "<br>");
          realValue = realValue.replaceAll("  ", "&nbsp;&nbsp;");
          if ("INPUT".equals(tag) && 
              ( content.indexOf("type=checkbox") == -1  
              || content.indexOf("type=\"checkbox\"")== -1
              || content.indexOf("type=\\\"checkbox\\\"") == -1 )) {
            String hidden2 = item.getHidden();
            if("1".equals(hidden2)) {
              realValue = "";
            }
          }
        }
        if (flowRunData != null) {
          flowRunData.setItemData(realValue);
        }
      }
      for (YHFlowFormItem item : itemList) {
        int itemId = item.getItemId();
        YHFlowRunData flowRunData = this.getFlowRunData(frdList, itemId);
        String name = item.getName();
        String clazz = item.getClazz();
        String title = item.getTitle();
        if("DATE".equals(clazz) || "USER".equals(clazz)){
          continue;
        }
        String realValue = "" ;
        if (flowRunData != null ) {
          realValue = flowRunData.getItemData();
        }
        if (!isWord 
            && !"DATE".equals(clazz) 
            && !"USER".equals(clazz) 
            && !"RADIO".equals(clazz) 
            && !"SIGN".equals(clazz) 
            && !"MODULE".equals(clazz)) {
          String tag = item.getTag();
          String content = item.getContent();
          if("INPUT".equals(tag) && (content.indexOf("type=checkbox") != -1
              || content.indexOf("type=\"checkbox\"") != -1
              || content.indexOf("type=\\\"checkbox\\\"") != -1 )){
            if("on".equals(realValue)){
              realValue = "<input type=checkbox checked onclick='this.checked=1;'>";
              realValue += "<input type=hidden name=DATA_"+itemId+" id=DATA_"+itemId+" value=\"on\" title=\""+title+"\">";
            }else{
              realValue = "<input type=checkbox onclick='this.checked=0;'>";
              realValue += "<input type=hidden name=DATA_"+itemId+" id=DATA_"+itemId+" title=\""+title+"\">";
            }
          } else  {
            if ("TEXTAREA".equals(tag)) {
              realValue = YHUtility.null2Empty(realValue);
              realValue = realValue.replace("&#10;", "<br/>");
            }
            realValue += "<input type=hidden name=DATA_"+itemId+" id=DATA_"+itemId+" value=\""+realValue+"\" title=\""+title+"\">";
          }
        }
        modelShort = modelShort.replaceAll("\\{" + name + "\\}", realValue);
      }
      //处理签章控件
      String sign  = "";
      if (isHaveSign) {
        sign += "<script>";
        if (signObject.endsWith(",")) {
          signObject = signObject.substring(0, signObject.length() -1 );
        }
        sign += "sign_str = \"" + signObject + "\";";
        if (signCheckStr.endsWith(",")) {
          signCheckStr = signCheckStr.substring(0, signCheckStr.length() -1 );
        }
        sign += "sign_check = {" + signCheckStr + "};";
        sign += "isHaveSign = true;LoadSignData();";
        sign += "</script>";
      }
      modelShort =  sign + modelShort;
      return modelShort;
  }
  public YHFlowRunData getFlowRunData(List<YHFlowRunData> frdList, int itemId) {
    YHFlowRunData flowRunData = null;
    for (YHFlowRunData tmp : frdList) {
      if (tmp.getItemId() == itemId) {
        flowRunData = tmp;
      }
    }
    return flowRunData;
  }
}
