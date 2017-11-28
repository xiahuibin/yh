package yh.core.util;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.FileSystem; 
import org.hyperic.sigar.FileSystemUsage; 
import org.hyperic.sigar.CpuInfo;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.NetFlags;
import org.hyperic.sigar.NetInterfaceConfig;
import org.hyperic.sigar.NetInterfaceStat;
import org.hyperic.sigar.OperatingSystem;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.SigarException;
import org.hyperic.sigar.SigarNotImplementedException;
import org.hyperic.sigar.Swap;



public class GetServerInfo {

	//获取cpu的数量
	public static int getCpuCount(){  
		        Sigar sigar = new Sigar();  
		            try {
						return sigar.getCpuInfoList().length;
					} catch (SigarException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}  
		           sigar.close();
				return 0;  
		    }  
		 
		   // b)CPU的总量（单位：HZ）以及cpu的相关信息
		   public void getCpuTotal() {  
	        Sigar sigar = new Sigar();  
		        CpuInfo[] infos;  
		       try {  
		           infos = sigar.getCpuInfoList();  
		            for (int i = 0; i < infos.length; i++) {// �����ǵ���CPU���Ƕ�CPU������  
		               CpuInfo info = infos[i];  
		               System.out.println("mhz=" + info.getMhz());// CPU的总量MHz  
		               System.out.println("vendor=" + info.getVendor());// 获取cpu的卖主  如：Intel
		               System.out.println("model=" + info.getModel());// ���CPU������获取cpu 的类别，如celeron
		                System.out.println("cache size=" + info.getCacheSize());// ����洢����  
		            }  
		        } catch (SigarException e) {  
		           e.printStackTrace();  
		       }  
		   }  
		 
		    // c)CPU的用户使用量，系统使用剩余量，总的剩余量，总的使用占用量等（单位：100%）��  
		    public void testCpuPerc() {  
		       Sigar sigar = new Sigar();  
		       // ��ʽһ����Ҫ�����һ��CPU�����  
		        CpuPerc cpu;  
		       try {  
		            cpu = sigar.getCpuPerc();  
		           printCpuPerc(cpu);  
		        } catch (SigarException e) {  
		            e.printStackTrace();  
		        }  
		        // ��ʽ���������ǵ���CPU���Ƕ�CPU������  
		        CpuPerc cpuList[] = null;  
		        try {  
		            cpuList = sigar.getCpuPercList();  
		        } catch (SigarException e) {  
		           e.printStackTrace();  
		           return;  
		       }  
	        for (int i = 0; i < cpuList.length; i++) {  
		           printCpuPerc(cpuList[i]);  
		        }  
		    }  
		  
		    private void printCpuPerc(CpuPerc cpu) {  
		        System.out.println("User :" + CpuPerc.format(cpu.getUser()));// 用户使用率�û�ʹ����  
		        System.out.println("Sys :" + CpuPerc.format(cpu.getSys()));// ϵͳ系统使用率
		        System.out.println("Wait :" + CpuPerc.format(cpu.getWait()));// 当前等待率��ǰ�ȴ���  
		        System.out.println("Nice :" + CpuPerc.format(cpu.getNice()));//  
		        System.out.println("Idle :" + CpuPerc.format(cpu.getIdle()));// 当前空闲率��ǰ������  
		        System.out.println("Total :" + CpuPerc.format(cpu.getCombined()));// 总的使用率�ܵ�ʹ����  
		    }  
		  
		    // 2.内存资源信息
		   public void getPhysicalMemory() {  
		        // a)�����wuli物理内存信息ڴ� 
		       Sigar sigar = new Sigar();  
		        Mem mem;  
		        try {  
		            mem = sigar.getMem();  
		            // �内存总量ڴ���  
		            System.out.println("Total = " + mem.getTotal() / 1024L + "K av");  
		           // ��ǰ�当前内存使用量ڴ�ʹ��  
		            System.out.println("Used = " + mem.getUsed() / 1024L + "K used");  
		           // ��ǰ�当前页面剩余量ڴ�ʣ��  
		            System.out.println("Free = " + mem.getFree() / 1024L + "K free");  
		            // b)ϵͳҳ���ļ���������Ϣ  系统页面文件交换区信息
		            Swap swap = sigar.getSwap();  
		            // 交换区总量��������  
		            System.out.println("Total = " + swap.getTotal() / 1024L + "K av");  
		            // 当前交换区使用量��ǰ������ʹ��  
		           System.out.println("Used = " + swap.getUsed() / 1024L + "K used");  
		            // 当前交换区剩余量��ǰ������ʣ��  
		            System.out.println("Free = " + swap.getFree() / 1024L + "K free");  
		        } catch (SigarException e) {  
		            e.printStackTrace();  
		        }  
		    }  
	  
	   // 3.����ϵͳ��Ϣ  操作系统信息
		    // a)取到当前操作系统的名称ȡ����ǰ����ϵͳ����ƣ�  
		    public String getPlatformName() {  
		       String hostname = "";  
		       try {  
		           hostname = InetAddress.getLocalHost().getHostName();  
		        } catch (Exception exc) {  
		           Sigar sigar = new Sigar();  
		            try {  
		               hostname = sigar.getNetInfo().getHostName();  
		           } catch (SigarException e) {  
		               hostname = "localhost.unknown";  
		           } finally {  
		                sigar.close();  
		           }  
		        }  
		        return hostname;  
		    }  
		  
		    // b)ȡ��ǰ����ϵͳ����Ϣ  取当前系统的信息
		    public void testGetOSInfo() {  
		        OperatingSystem OS = OperatingSystem.getInstance();  
		        // ����ϵͳ�系统描述
		        System.out.println("OS.getArch() = " + OS.getArch());  
		        System.out.println("OS.getCpuEndian() = " + OS.getCpuEndian());//  
		        System.out.println("OS.getDataModel() = " + OS.getDataModel());//  
		        // 操作系统类型ϵͳ����  
		        System.out.println("OS.getDescription() = " + OS.getDescription());  
		        System.out.println("OS.getMachine() = " + OS.getMachine());//  
		        // 操作系统的卖主����ϵͳ����  
		        System.out.println("OS.getName() = " + OS.getName());  
		        System.out.println("OS.getPatchLevel() = " + OS.getPatchLevel());//  
		       // 卖主名称����ϵͳ������  
		        System.out.println("OS.getVendor() = " + OS.getVendor());  
		        // 操作系统名称�������  
		       System.out.println("OS.getVendorCodeName() = " + OS.getVendorCodeName());  
		       // 操作系统卖主类型����ϵͳ���  
		       System.out.println("OS.getVendorName() = " + OS.getVendorName());  
		       // 操作系统卖主类型����ϵͳ��������  
		        System.out.println("OS.getVendorVersion() = " + OS.getVendorVersion());  
		        // ����ϵͳ�İ操作系统的版本号��  
		       System.out.println("OS.getVersion() = " + OS.getVersion());  
		   }  
		 
		   // c)ȡ��ǰϵͳ��̱��е��û���获取当前进程表中当前用户信息
	       public void testWho() {  
		        try {  
		            Sigar sigar = new Sigar();  
		            org.hyperic.sigar.Who[] who = sigar.getWhoList();  
		            if (who != null && who.length > 0) {  
		               for (int i = 0; i < who.length; i++) {  
		                   System.out.println("\n~~~~~~~~~" + String.valueOf(i) + "~~~~~~~~~");  
		                   org.hyperic.sigar.Who _who = who[i];  
		                   System.out.println("getDevice() = " + _who.getDevice());  
		                    System.out.println("getHost() = " + _who.getHost());  
		                   System.out.println("getTime() = " + _who.getTime());  
		                   // ��ǰϵͳ��̱��е��û���  
		                   System.out.println("getUser() = " + _who.getUser());  
		                }  
		            }  
		        } catch (SigarException e) {  
		            e.printStackTrace();  
		        }  
		    }  
		  
		    // 4.��Դ��Ϣ����Ҫ��Ӳ�̣�  
		    // a)ȡӲ�����еķ�������ϸ��Ϣ��ͨ��sigar.getFileSystemList()4���FileSystem�б����Ȼ�������б���  
		    public void testFileSystemInfo() throws Exception {  
		        Sigar sigar = new Sigar();  
		        FileSystem fslist[] = sigar.getFileSystemList();  
		       // String dir = System.getProperty("user.home");// ��ǰ�û��ļ���·��  
		        for (int i = 0; i < fslist.length; i++) {  
		            System.out.println("\n~~~~~~~~~~" + i + "~~~~~~~~~~");  
		           FileSystem fs = fslist[i];  
		           // ������̷����  
		           System.out.println("fs.getDevName() = " + fs.getDevName());  
		            // ������̷����  
		            System.out.println("fs.getDirName() = " + fs.getDirName());  
		            System.out.println("fs.getFlags() = " + fs.getFlags());//  
		           // �ļ�ϵͳ���ͣ����� FAT32��NTFS  
		           System.out.println("fs.getSysTypeName() = " + fs.getSysTypeName());  
		            // �ļ�ϵͳ��������籾��Ӳ�̡����������ļ�ϵͳ��  
		            System.out.println("fs.getTypeName() = " + fs.getTypeName());  
		            // �ļ�ϵͳ����  
		           System.out.println("fs.getType() = " + fs.getType());  
		           FileSystemUsage usage = null;  
		            try {  
		               usage = sigar.getFileSystemUsage(fs.getDirName());  
		            } catch (SigarException e) {  
		               if (fs.getType() == 2)  
		                    throw e;  
		                continue;  
		            }  
		           switch (fs.getType()) {  
		           case 0: // TYPE_UNKNOWN ��δ֪  
		               break;  
		           case 1: // TYPE_NONE  
		                break;  
		            case 2: // TYPE_LOCAL_DISK : ����Ӳ��  
		                // �ļ�ϵͳ�ܴ�С  
		                System.out.println(" Total = " + usage.getTotal() + "KB");  
		                // �ļ�ϵͳʣ���С  
		                System.out.println(" Free = " + usage.getFree() + "KB");  
		              // �ļ�ϵͳ���ô�С  
		               System.out.println(" Avail = " + usage.getAvail() + "KB");  
		               // �ļ�ϵͳ�Ѿ�ʹ��  
		                System.out.println(" Used = " + usage.getUsed() + "KB");  
	                double usePercent = usage.getUsePercent() * 100D;  
	               // �ļ�ϵͳ��Դ��������  
		                System.out.println(" Usage = " + usePercent + "%");  
		              break;  
		           case 3:// TYPE_NETWORK ������  
		                break;  
		           case 4:// TYPE_RAM_DISK ���t�  
		               break;  
		            case 5:// TYPE_CDROM ������  
		                break;  
		            case 6:// TYPE_SWAP ��ҳ�潻��  
		                break;  
		           }  
		           System.out.println(" DiskReads = " + usage.getDiskReads());  
		            System.out.println(" DiskWrites = " + usage.getDiskWrites());  
		        }  
		        return;  
		    }  
		  
		   // 5.������Ϣ  
		   // a)��ǰ�������ʽ����  
	    public String getFQDN() {  
		       Sigar sigar = null;  
		        try {  
		            return InetAddress.getLocalHost().getCanonicalHostName();  
		        } catch (UnknownHostException e) {  
		           try {  
		               sigar = new Sigar();  
		               return sigar.getFQDN();  
		            } catch (SigarException ex) {  
		               return null;  
		           } finally {  
		               sigar.close();  
		            }  
		        }  
		    }  
		  
		    // b)ȡ����ǰ�����IP��ַ 取到当前机器的IP地址
		    public String getDefaultIpAddress() {  
		        String address = null;  
		        try {  
		            address = InetAddress.getLocalHost().getHostAddress();  
		            // ͷ���  
		            // ������ͨ��Sigar���߰��еķ���4��ȡ  
		            if (!NetFlags.LOOPBACK_ADDRESS.equals(address)) {  
		                return address;  
		           }  
		       } catch (UnknownHostException e) {  
		           // hostname not in DNS or /etc/hosts  
		        }  
		        Sigar sigar = new Sigar();  
		        try {  
		            address = sigar.getNetInterfaceConfig().getAddress();  
		        } catch (SigarException e) {  
		            address = NetFlags.LOOPBACK_ADDRESS;  
		        } finally {  
		            sigar.close();  
		        }  
		        return address;  
		    }  
		  
		    // c)ȡ����ǰ�����MAC��ַ  取到当前机器的mac地址
		    public List getMAC() {  
		        Sigar sigar = null;  
		        List macList=new ArrayList();
		       try {  
		            sigar = new Sigar();  
		            String[] ifaces = sigar.getNetInterfaceList();  
		            String hwaddr = null;  
		           for (int i = 0; i < ifaces.length; i++) {  
		                NetInterfaceConfig cfg = sigar.getNetInterfaceConfig(ifaces[i]);  
		               if (NetFlags.LOOPBACK_ADDRESS.equals(cfg.getAddress()) || (cfg.getFlags() & NetFlags.IFF_LOOPBACK) != 0  
		                        || NetFlags.NULL_HWADDR.equals(cfg.getHwaddr())) {  
		                   continue;  
		               }  
	                /* 
		                * �����ڶ������(��������Ĭ��ֻȡ��һ�����MAC��ַ�����Ҫ�������е�����(����ĺ�����ģ�������޸ķ����ķ�������Ϊ�����Collection 
		                 * ��ͨ����forѭ����ȡ���Ķ��MAC��ַ�� 
		                 */  
		                macList.add(cfg.getHwaddr().replace(":", "-"));  
		                  
	            }  
		            return macList;  
		            
	        } catch (Exception e) {  
		            return null;  
		       } finally {  
		            if (sigar != null)  
		                sigar.close();  
		        }  
		    }  
		  
		    // d)��ȡ����������Ϣ  
		    public void testNetIfList() throws Exception {  
		        Sigar sigar = new Sigar();  
		        String ifNames[] = sigar.getNetInterfaceList();  
		        for (int i = 0; i < ifNames.length; i++) {  
		            String name = ifNames[i];  
		            NetInterfaceConfig ifconfig = sigar.getNetInterfaceConfig(name);  
		            print("\nname = " + name);// �����豸��  
		            print("Address = " + ifconfig.getAddress());// IP��ַ  
		            print("Netmask = " + ifconfig.getNetmask());// ��������  
		           if ((ifconfig.getFlags() & 1L) <= 0L) {  
		                print("!IFF_UP...skipping getNetInterfaceStat");  
		               continue;  
		            }  
		            try {  
		                NetInterfaceStat ifstat = sigar.getNetInterfaceStat(name);  
		                print("RxPackets = " + ifstat.getRxPackets());// ���յ��ܰ����  
		                print("TxPackets = " + ifstat.getTxPackets());// ���͵��ܰ����  
		                print("RxBytes = " + ifstat.getRxBytes());// ���յ������ֽ���  
		                print("TxBytes = " + ifstat.getTxBytes());// ���͵����ֽ���  
		               print("RxErrors = " + ifstat.getRxErrors());// ���յ��Ĵ������  
		              print("TxErrors = " + ifstat.getTxErrors());// ������ݰ�ʱ�Ĵ�����  
		                print("RxDropped = " + ifstat.getRxDropped());// ����ʱ����İ���  
		                print("TxDropped = " + ifstat.getTxDropped());// ����ʱ����İ���  
		            } catch (SigarNotImplementedException e) {  
		            } catch (SigarException e) {  
		                print(e.getMessage());  
		            }  
		        }  
		    }  
		  
		    void print(String msg) {  
		        System.out.println(msg);  
		    }  
		  
		    // e)һЩ�������Ϣ  
		    public void getEthernetInfo() {  
		        Sigar sigar = null;  
		        try {  
		            sigar = new Sigar();  
		            String[] ifaces = sigar.getNetInterfaceList();  
		            for (int i = 0; i < ifaces.length; i++) {  
		                NetInterfaceConfig cfg = sigar.getNetInterfaceConfig(ifaces[i]);  
		                if (NetFlags.LOOPBACK_ADDRESS.equals(cfg.getAddress()) || (cfg.getFlags() & NetFlags.IFF_LOOPBACK) != 0  
		                        || NetFlags.NULL_HWADDR.equals(cfg.getHwaddr())) {  
		                    continue;  
		                }  
		                System.out.println("cfg.getAddress() = " + cfg.getAddress());// IP��ַ  
		                System.out.println("cfg.getBroadcast() = " + cfg.getBroadcast());// ��ع㲥��ַ  
		                System.out.println("cfg.getHwaddr() = " + cfg.getHwaddr());// ��MAC��ַ  
		                System.out.println("cfg.getNetmask() = " + cfg.getNetmask());// ��������  
		                System.out.println("cfg.getDescription() = " + cfg.getDescription());// ��������Ϣ  
		                System.out.println("cfg.getType() = " + cfg.getType());//  
		                System.out.println("cfg.getDestination() = " + cfg.getDestination());  
		                System.out.println("cfg.getFlags() = " + cfg.getFlags());//  
		                System.out.println("cfg.getMetric() = " + cfg.getMetric());  
		                System.out.println("cfg.getMtu() = " + cfg.getMtu());  
		                System.out.println("cfg.getName() = " + cfg.getName());  
		                System.out.println();  
		           }  
		        } catch (Exception e) {  
		            System.out.println("Error while creating GUID" + e);  
		        } finally {  
		            if (sigar != null)  
		                sigar.close();  
		        }  
	       }  
		  
		    public String cpu(){
		          Sigar sigar = new Sigar();
		          String cpuinfo="";
		          CpuInfo[] infos;
		          try {
		               infos = sigar.getCpuInfoList();
		               cpuinfo+=infos[0].getModel();
		               int cpunum=infos.length/2;
		               if(cpunum>0){
		                  cpuinfo+=" ,"+cpunum+"CPU";
		               }else{
		                   cpuinfo+=" ,1CPU";
		               }
		          } catch (SigarException e) {
		           e.printStackTrace();
		          }
		               cpuinfo+=","+Runtime.getRuntime().availableProcessors()+"CORE";
		        return cpuinfo;
		    }
		    
		    public static void main(String[] arg) {  
		        try {  
		            GetServerInfo testsS = new GetServerInfo(); 
		            //testsS.getCpuTotal();  
		            System.out.println(testsS.getCpuCount());
		            /*testsS.testGetOSInfo();  
		            testsS.testWho();  
		            testsS.testFileSystemInfo();  
		            testsS.testNetIfList();  
		            testsS.getEthernetInfo();  */
		        } catch (Exception e) {  
		           // TODO Auto-generated catch block  
		            e.printStackTrace();  
		       }  
		    }


}
