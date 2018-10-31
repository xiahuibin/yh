/**
 * 
 */
package yh.oa.tools;

import yh.core.util.YHGuid;
import yh.core.util.auth.YHAuthenticator;

/**
 * @author ljs
 *
 */
public class Test {

	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		String str=YHGuid.getRawGuid();
		System.out.println(str);
		System.out.println(System.getProperty("java.library.path"));
		System.out.println(YHAuthenticator.ciphEncryptStr("123456"));
	}

}
