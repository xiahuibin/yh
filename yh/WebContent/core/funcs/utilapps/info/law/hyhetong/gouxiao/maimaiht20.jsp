<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/core/inc/header.jsp" %>
<!DOCTYPE  html  PUBLIC  "-//W3C//DTD  HTML  4.01  Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>法律法规查询</TITLE>
<meta  http-equiv="Content-Type"  content="text/html;  charset=UTF-8">
<link  rel="stylesheet"  href  ="<%=cssPath%>/style.css">
<style type="text/css">
<!--a            { text-decoration: none; font-size: 9pt; color: black; font-family: 宋体 }

.text        { font-size: 9pt; font-family: 宋体 }

.text1       { color: #0000A0; font-size: 11pt; font-family: 宋体 }

.text2       { color: #008080; font-size: 9pt; font-family: 宋体 }

.text3       { color: #0F8A91; font-size: 11pt; font-family: 宋体 }

.l100        { line-height: 14pt; font-size: 9pt }

td           { font-family: 宋体; font-size: 9pt; line-height: 13pt }

input        { font-size: 9pt; font-family: 宋体 }

p            { font-size: 9pt; font-family: 宋体 }

--></style>



</HEAD>

<BODY class="bodycolor" topmargin="0">

<BR>

<table width="500" border="0" cellspacing="1" cellpadding="3" align="center" class="TableBlock">

  <tr> 

    <td height="27" class="TableHeader">

      <div align="center">农作物种子预约生产合同</font></div>

    </td>

  </tr>

  <tr>

    <td height="54" valign="top" class="TableData">

      <p align="center"></p>

      <p align="center"></p>

      <p align="center"> </p>

      <p> 　　<BR> 

　　预约方：　　　　　　　　　　　　　　　　　　　合同编号：<BR> 

　　签订地点：<BR> 

　　承约方：　　　　　　　　　　　　　　　　　　　签订时间：　年　月　日<BR> 

　　根据《中华人民共和国经济合同法》、《中华人民共和国种子管理条例》及有关规定，为明确双方<BR> 

　　的权利义务，经双方协商一致，签订本合同。<BR> 

　　一、预约生产的农作物种子品种、质量、数量、金额：<BR> 

　　┌───┬──┬───┬──┬─────────────┬──┬───┐<BR> 

　　│农作物│品种│计量　│数量│　　质量(％)　　　　　　　│单价│总金额│<BR> 

　　│种类　│名称│单位　│　　├──┬──┬───┬───┤(元)│(元)　│<BR> 

　　│　　　│　　│　　　│　　│纯度│净度│发芽率│水份　│　　│　　　│<BR> 

　　├───┼──┼───┼──┼──┼──┼───┼───┼──┼───┤<BR> 

　　│　　　│　　│　　　│　　│　　│　　│　　　│　　　│　　│　　　│<BR> 

　　├───┼──┼───┼──┼──┼──┼───┼───┼──┼───┤<BR> 

　　│　　　│　　│　　　│　　│　　│　　│　　　│　　　│　　│　　　│<BR> 

　　├───┴──┴───┴──┴──┴──┴───┴───┴──┴───┤<BR> 

　　│　合计人民币金额(大写): 万　仟　佰　拾　元　角　分　　　　　　　　　│<BR> 

　　└──────────────────────────────────┘<BR> 

　　二、预约方繁育材料：<BR> 

　　┌──┬────────────┬──┬──┬──┬───┬──┬──┐<BR> 

　　│材料│　　　质量(％)　　　　　│计量│数量│提供│亩用量│单价│总金│<BR> 

　　│品名├──┬──┬───┬──┤单位│　　│日期│　　　│(元)│额　│<BR> 

　　│　　│纯度│净度│发芽率│水份│　　│　　│　　│　　　│　　│(元)│<BR> 

　　├──┼──┼──┼───┼──┼──┼──┼──┼───┼──┼──┤<BR> 

　　│　　│　　│　　│　　　│　　│　　│　　│　　│　　　│　　│　　│<BR> 

　　├──┼──┼──┼───┼──┼──┼──┼──┼───┼──┼──┤<BR> 

　　│　　│　　│　　│　　　│　　│　　│　　│　　│　　　│　　│　　│<BR> 

　　├──┴──┴──┴───┴──┴──┴──┴──┴───┴──┴──┤<BR> 

　　│　合计人民币金额(大写): 万　仟　佰　拾　元　角　分　　　　　　　　　│<BR> 

　　└──────────────────────────────────┘<BR> 

　　三、农作物种子预约生产的环境及技术要求：<BR> 

　　四、预约方提供技术服务的种类、方式及保密要求；<BR> 

　　五、农作物种子质量检验及检疫严格按国家颁布的有关规定办理，检验执行ＧＢ／Ｔ３５４３．１<BR> 

　　～３５４３．７－１９９５《农作物种子检验规程》。<BR> 

　　１．承约方必须持有《种子生产许可证》，交售种子时还须提供该批种子的有效田间检验结果单、<BR> 

　　产地检疫合格证和《农作物种子质量合格证》。<BR> 

　　２．预约方收货后复检，发芽率、净度、水分三项指标在收货后两个发芽周期内复检完毕，纯度在<BR> 

　　收货后该作物第一个生产周期内复检完毕，发现问题及时通知对方，逾期视为种子合格。<BR> 

　　３．双方对经销的每批种子必须同时取样分别封存，以备种子复检和鉴定，样品保存至该批种子用<BR> 

　　于生产收获以后。<BR> 

　　４．申请种子委托检验和鉴定，费用由　　　　　　　（单位）负担。<BR> 

　　六、超幅度损耗及计算方法：<BR> 

　　七、包装要求及包装费用负担：<BR> 

　　八、交（提）货时间、地点、发运方式、运费负担：<BR> 

　　九、定金的数额及交付时间：<BR> 

　　十、结算方式和期限：<BR> 

　　十一、双方一般责任：<BR> 

　　预约方：所供繁育材料必须达到合同约定的国家有关技术质量标准；提供详细的生产资料和技术指<BR> 

　　导；按合同约定时间交付定金；保证按时足额收购承约方生产的符合本合同约定标准的种子。<BR> 

　　承约方：按合同约定的种子品种、数量、质量安排生产；遵循合同规定的种子生产技术规程和种苗<BR> 

　　产地检疫规程，并接受种子管理机构的监督检查；保证种子质量达到合同约定条款规定；并按合同约定<BR> 

　　的数量、时间、地点交付预约方。<BR> 

　　十二、凡因不可抗力因素造成种子数量或质量达不到本合同约定条款的，承约方及时通知预约方进<BR> 

　　行实地考查，提供具有法律效力的有关资料，双方协商变更合同，签订补充协议。协商不成，按经济合<BR> 

　　同法及种子管理法规的有关规定处理。<BR> 

　　十三、违约责任：<BR> 

　　十四、种子质量发生纠纷，由　　　　（机构或单位）进行技术质量仲裁；本合同在履行中发生纠<BR> 

　　纷，由当事人协商解决，协商不成，可由仲裁委员会仲裁或向人民法院起诉。<BR> 

　　十五、双方协商的其它条款：<BR> 

　　十六、本合同未尽事项，一律按《中华人民共和国经济合同法》、《中华人民共和国种子管理条<BR> 

　　例》及国家有关规定，经合同双方协商一致，做出补充规定附后。如需提供担保，另立《合同担保<BR> 

　　书》，作为本合同附件。<BR> 

　　本合同一式　份，合同双方各持　份；合同副本　份，送　　　（单位）备案。<BR> 

　　┌─────────┬────────┬───────┬───────┐<BR> 

　　│预约方(章):　　　 │承约方(章):　　 │审核意见:　　 │鉴定意见:　　 │<BR> 

　　│单位地址:　　　　 │单位地址:　　　 │　　　　　　　│　　　　　　　│<BR> 

　　│法定代表人:　　　 │法定代表人:　　 │　　　　　　　│　　　　　　　│<BR> 

　　│委托代理人:　　　 │委托代理人:　　 │　　　　　　　│　　经办人:　 │<BR> 

　　│电话:　　　　　　 │电话:　　　　　 │　经办人:　　 │　　　　　　　│<BR> 

　　│电挂:　　　　　　 │电挂:　　　　　 │　　　　　　　│　鉴定机关(章)│<BR> 

　　│开户银行:　　　　 │开户银行:　　　 │　审核机关(章)│　　年　月　日│<BR> 

　　│帐号:　　　　　　 │帐号:　　　　　 │　　年　月　日│　　　　　　　│<BR> 

　　│邮政编码:　　　　 │邮政编码:　　　 │　　　　　　　│　　　　　　　│<BR> 

　　└─────────┴────────┴───────┴───────┘<BR> 

　　有效期限：　　　　年　　月　　日至　　　　年　　月　　日<BR> 

　　<BR> 

　　<BR> 

　　　　 </p>

    </td>

  </tr>

</table>

<br><center>
<input type="button" class="BigButton" value="回上一层" onclick="history.go(-1)">
<input type="button" class="BigButton" value="回主目录" onclick="location='../../index.jsp';">
</center><br>

</html>
