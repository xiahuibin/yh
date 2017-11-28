package yh.core.funcs.email.util;

import java.io.File;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class sendMail {
  private MimeMessage mimeMsg; //MIME邮件对象

  private Session session; //邮件会话对象
  private Properties props; //系统属性
  private boolean needAuth = false; //smtp是否需要认证

  private String username = ""; //smtp认证用户名和密码
  private String password = "";

  private Multipart mp; //Multipart对象,邮件内容,标题,附件等内容均添加到其中后再生成MimeMessage对象



  /**
  * 
  */
 /* public sendMail() {
  setSmtpHost(getConfig.mailHost);//如果没有指定邮件服务器,就从getConfig类中获取
  createMimeMessage();
  }*/

  public sendMail(String smtp){
  setSmtpHost(smtp);
  createMimeMessage();
  }



  /**
  * @param hostName String
  */
  public void setSmtpHost(String hostName) {
//  System.out.println("设置系统属性：mail.smtp.host = "+hostName);
  if(props == null)props = System.getProperties(); //获得系统属性对象

  props.put("mail.smtp.host",hostName); //设置SMTP主机
  }


  /**
  * @return boolean
  */
  public boolean createMimeMessage()
  {
  try{
//  System.out.println("准备获取邮件会话对象！");
  session = Session.getDefaultInstance(props,null); //获得邮件会话对象
  }
  catch(Exception e){
//  System.err.println("获取邮件会话对象时发生错误！"+e);
  return false;
  }

//  System.out.println("准备创建MIME邮件对象！");
  try{
  mimeMsg = new MimeMessage(session); //创建MIME邮件对象
  mp = new MimeMultipart();

  return true;
  }
  catch(Exception e){
  System.err.println("创建MIME邮件对象失败！"+e);
  return false;
  }
  }



  /**
  * @param need boolean
  */
  public void setNeedAuth(boolean need) {
//  System.out.println("设置smtp身份认证：mail.smtp.auth = "+need);
  if(props == null)props = System.getProperties();

  if(need){
  props.put("mail.smtp.auth","true");
  }else{
  props.put("mail.smtp.auth","false");
  }
  }



  /**
  * @param name String
  * @param pass String
  */
  public void setNamePass(String name,String pass) {
  username = name;
  password = pass;
  }


  /**
  * @param mailSubject String
  * @return boolean
  */
  public boolean setSubject(String mailSubject) {
//  System.out.println("设置邮件主题！");
  try{
  mimeMsg.setSubject(mailSubject);
  return true;
  }
  catch(Exception e) {
  System.err.println("设置邮件主题发生错误！");
  return false;
  }
  }



  /**
  * @param mailBody String
  */
  public boolean setBody(String mailBody) {
  try{
  BodyPart bp = new MimeBodyPart();
  bp.setContent("<meta http-equiv=Content-Type content=text/html; charset=gb2312>"+mailBody,"text/html;charset=GB2312");
  mp.addBodyPart(bp);

  return true;
  }
  catch(Exception e){
  System.err.println("设置邮件正文时发生错误！"+e);
  return false;
  }
  }


  /**
  * @param name String
  * @param pass String
  */
  public boolean addFileAffix(String filename) {

//  System.out.println("增加邮件附件："+filename);

  try{
  BodyPart bp = new MimeBodyPart();
  FileDataSource fileds = new FileDataSource(filename);
  bp.setDataHandler(new DataHandler(fileds));
  sun.misc.BASE64Encoder enc = new sun.misc.BASE64Encoder();
  bp.setFileName("=?UTF-8?B?"+enc.encode(fileds.getName().getBytes("UTF-8"))+"?=");

  mp.addBodyPart(bp);

  return true;
  }
  catch(Exception e){
  System.err.println("增加邮件附件："+filename+"发生错误！"+e);
  return false;
  }
  }



  /**
  * @param name String
  * @param pass String
  */
  public boolean setFrom(String from) {
//  System.out.println("设置发信人！");
  try{
  mimeMsg.setFrom(new InternetAddress(from)); //设置发信人
  return true;
  }
  catch(Exception e)
  { return false; }
  }


  /**
  * @param name String
  * @param pass String
  */
  public boolean setTo(String to){
  if(to == null)return false;

  try{
  mimeMsg.setRecipients(Message.RecipientType.TO,InternetAddress.parse(to));
  return true;
  }
  catch(Exception e)
  { return false; }

  }

  /**
  * @param name String
  * @param pass String
  */
  public boolean setCopyTo(String copyto)
  {
  if(copyto == null)return false;
  try{
  mimeMsg.setRecipients(Message.RecipientType.CC,(Address[])InternetAddress.parse(copyto));
  return true;
  }
  catch(Exception e)
  { return false; }
  }


  /**
  * @param name String
  * @param pass String
  */
  public boolean sendout()
  {
  try{
  mimeMsg.setContent(mp);
  mimeMsg.saveChanges();
//  System.out.println("正在发送邮件....");

  Session mailSession = Session.getInstance(props,null);
  Transport transport = mailSession.getTransport("smtp");
  transport.connect((String)props.get("mail.smtp.host"),username,password);
  transport.sendMessage(mimeMsg,mimeMsg.getRecipients(Message.RecipientType.TO));
  // transport.send(mimeMsg);

//  System.out.println("发送邮件成功！");
  transport.close();

  return true;
  }
  catch(Exception e)
  {
  System.err.println("邮件发送失败！"+e);
  return false;
  }
  }


  /**
  * Just do it as this
  */
  public static void main(String[] args) {

  String mailbody = "<meta http-equiv=Content-Type content=text/html; charset=gb2312>"+
  "<div align=center><a href=http://www.csdn.net> csdn </a></div>";

  sendMail themail = new sendMail("smtp.163.com");
  themail.setNeedAuth(true);
  themail.setNamePass("chenyimdj@163.com", "chyi1986");
  if(themail.setSubject("标题") == false) return;
  if(themail.setBody(mailbody) == false) return;
  if(themail.setTo("chenyimdj@163.com,chenyimdj@126.com") == false) return;
  if(themail.setFrom("chenyimdj@163.com") == false) return;
  if(themail.addFileAffix("E:" + File.separator + "新建文本文档.txt") == false) return;
  //themail.setNamePass("user","password");

  if(themail.sendout() == false) return; 
  }

}
