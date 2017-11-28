package yh.core.funcs.picture.act;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;

import javax.imageio.ImageIO;

import org.apache.sanselan.Sanselan;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class YHImageUtil {

	private int width;

	private int height;

	private int scaleWidth;

	double support = (double) 3.0;

	double PI = (double) 3.14159265358978;

	double[] contrib;

	double[] normContrib;

	double[] tmpContrib;

	int startContrib, stopContrib;

	int nDots;

	int nHalfDots;

	/**
	 * Start: Use Lanczos filter to replace the original algorithm for image
	 * scaling. Lanczos improves quality of the scaled image modify by :blade
	 */

	public static void main(String[] args) {
		YHImageUtil is = new YHImageUtil();
		try {
			is.saveImageAsJpg("D:/gggg.JPG", "D:\\tt\\gggg.JPG", 80, 60);
			// System.out.println("success");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 生成宽为80，高为60的的缩略图
	 * 
	 * @param fromFileStr
	 * @param saveToFileStr
	 * @return
	 * @throws Exception
	 */
	public boolean saveImageAsImage(String fromFileStr, String saveToFileStr) throws Exception {
		String imgTypeStr = "JPEG";
		if (fromFileStr.lastIndexOf(".") != -1) {
			imgTypeStr = fromFileStr.substring(fromFileStr.lastIndexOf(".") + 1, fromFileStr.length());
		}

		boolean flag = false;
		BufferedImage srcImage = null;
		File saveFile = new File(saveToFileStr);
		File fromFile = new File(fromFileStr);
		try {
			srcImage = ImageIO.read(fromFile);
		} catch (Exception ex) {
			srcImage = Sanselan.getBufferedImage(fromFile);
		}

		int width = srcImage.getWidth(null); // 得到源图宽
		int height = srcImage.getHeight(null);
		
		if ((imgTypeStr.equalsIgnoreCase("JPEG") || imgTypeStr.equalsIgnoreCase("JPG")) && width > 100 && height > 100) {
		  saveCachFile(srcImage, saveToFileStr);
		  System.gc();
	    System.gc();
		  return flag;
		}
		
		int newWideth = 0;// 重新设定它的宽
		int newHeight = 0;// 重新设定高
		if (width >= 80 && width > height) {
			newWideth = 80;// 重新设定它的宽
			newHeight = 80 * height / width;// 重新设定高,用比例计算图片的高(重设高/实高=重设宽/实宽)
		} else if (height >= 60 && width < height) {
			newHeight = 80;// 重新设定它的宽
			newWideth = 80 * width / height;// 重新设定高,用比例计算图片的高(重设高/实高=重设宽/实宽)
		} else {
			newWideth = width;
			newHeight = height;
		}
		newWideth = (newWideth <= 0 ? 1 : newWideth);
		newHeight = (newHeight <= 0 ? 1 : newHeight);
		srcImage = imageZoomOut(srcImage, newWideth, newHeight);
		flag = ImageIO.write(srcImage, imgTypeStr, saveFile);
		System.gc();
		System.gc();

		return flag;
	}

	/**
	 * 按比例生成缩略图
	 * 
	 * @param fromFileStr
	 *          原图片地址
	 * @param saveToFileStr
	 *          生成缩略图地址
	 * @param formatWideth
	 *          生成图片宽度
	 * @param formatHeight
	 *          formatHeight高度
	 */
	public boolean saveImageAsJpg(String fromFileStr, String saveToFileStr, int formatWideth, int formatHeight) throws Exception {

		String imgTypeStr = "JPEG";
		if (fromFileStr.lastIndexOf(".") != -1) {
			imgTypeStr = fromFileStr.substring(fromFileStr.lastIndexOf(".") + 1, fromFileStr.length());
		}

		boolean flag = false;
		BufferedImage srcImage;
		File saveFile = new File(saveToFileStr);
		File fromFile = new File(fromFileStr);
		srcImage = javax.imageio.ImageIO.read(fromFile); // construct image
		srcImage = javax.imageio.ImageIO.read(fromFile); // construct image
		try {
			srcImage = ImageIO.read(fromFile);

		} catch (Exception ex) {
			srcImage = Sanselan.getBufferedImage(fromFile);
		}
		int imageWideth = srcImage.getWidth(null); // 原宽
		int imageHeight = srcImage.getHeight(null); // 原高
		int changeToWideth = 0;
		int changeToHeight = 0;
		if (imageWideth > 0 && imageHeight > 0) {
			// flag=true;
			if (imageWideth / imageHeight >= formatWideth / formatHeight) {
				if (imageWideth > formatWideth) {
					changeToWideth = formatWideth;
					changeToHeight = (imageHeight * formatWideth) / imageWideth;
				} else {
					changeToWideth = imageWideth;
					changeToHeight = imageHeight;
				}
			} else {
				if (imageHeight > formatHeight) {
					changeToHeight = formatHeight;
					changeToWideth = (imageWideth * formatHeight) / imageHeight;
				} else {
					changeToWideth = imageWideth;
					changeToHeight = imageHeight;
				}
			}
		}

		srcImage = imageZoomOut(srcImage, changeToWideth, changeToHeight);
		// ImageIO.write(srcImage, "JPEG", saveFile);
		flag = ImageIO.write(srcImage, imgTypeStr, saveFile);
		System.gc();
		System.gc();

		return flag;
	}

	/**
	 * 按用户输入的长和宽生成缩略图
	 * 
	 * @param fromFileStr
	 *          原图片地址
	 * @param saveToFileStr
	 *          生成缩略图地址
	 * @param formatWideth
	 *          生成图片宽度
	 * @param formatHeight
	 *          formatHeight高度
	 */
	public void saveImageAsUser(String fromFileStr, String saveToFileStr, int formatWideth, int formatHeight) throws Exception {

		String imgTypeStr = "JPEG";
		if (fromFileStr.lastIndexOf(".") != -1) {
			imgTypeStr = fromFileStr.substring(fromFileStr.lastIndexOf(".") + 1, fromFileStr.length());
		}

		// boolean flag = false;
		BufferedImage srcImage;
		File saveFile = new File(saveToFileStr);
		File fromFile = new File(fromFileStr);
		try {
			srcImage = ImageIO.read(fromFile);
		} catch (Exception ex) {
			srcImage = Sanselan.getBufferedImage(fromFile);
		}

		int changeToWideth = 0;
		int changeToHeight = 0;

		int imageWideth = srcImage.getWidth(null); // 原宽
		int imageHeight = srcImage.getHeight(null); // 原高

		if (formatWideth >= imageWideth) {
			changeToWideth = imageWideth;
		} else if (formatWideth >= 0) {
			changeToWideth = formatWideth;
		}

		if (formatHeight >= imageHeight) {
			changeToHeight = imageHeight;
		} else if (formatHeight >= 0) {
			changeToHeight = formatHeight;
		}

		srcImage = imageZoomOut(srcImage, changeToWideth, changeToHeight);
		ImageIO.write(srcImage, imgTypeStr, saveFile);
		System.gc();
		System.gc();
	}

	public BufferedImage imageZoomOut(BufferedImage srcBufferImage, int w, int h) {
		width = srcBufferImage.getWidth();
		height = srcBufferImage.getHeight();
		scaleWidth = w;

		if (DetermineResultSize(w, h) == 1) {
			return srcBufferImage;
		}
		CalContrib();
		BufferedImage pbOut = HorizontalFiltering(srcBufferImage, w);
		BufferedImage pbFinalOut = VerticalFiltering(pbOut, h);
		return pbFinalOut;
	}

	/**
	 * 决定图像尺寸
	 */
	private int DetermineResultSize(int w, int h) {
		double scaleH, scaleV;
		scaleH = (double) w / (double) width;
		scaleV = (double) h / (double) height;
		// 需要判断一下scaleH，scaleV，不做放大操作
		if (scaleH >= 1.0 && scaleV >= 1.0) {
			return 1;
		}
		return 0;

	} // end of DetermineResultSize()

	private double Lanczos(int i, int inWidth, int outWidth, double Support) {
		double x;

		x = (double) i * (double) outWidth / (double) inWidth;

		return Math.sin(x * PI) / (x * PI) * Math.sin(x * PI / Support) / (x * PI / Support);
	}

	private void CalContrib() {
		nHalfDots = (int) ((double) width * support / (double) scaleWidth);
		nDots = nHalfDots * 2 + 1;
		try {
			contrib = new double[nDots];
			normContrib = new double[nDots];
			tmpContrib = new double[nDots];
		} catch (Exception e) {
			// System.out.println("init   contrib,normContrib,tmpContrib" + e);
		}

		int center = nHalfDots;
		contrib[center] = 1.0;

		double weight = 0.0;
		int i = 0;
		for (i = 1; i <= center; i++) {
			contrib[center + i] = Lanczos(i, width, scaleWidth, support);
			weight += contrib[center + i];
		}

		for (i = center - 1; i >= 0; i--) {
			contrib[i] = contrib[center * 2 - i];
		}

		weight = weight * 2 + 1.0;

		for (i = 0; i <= center; i++) {
			normContrib[i] = contrib[i] / weight;
		}

		for (i = center + 1; i < nDots; i++) {
			normContrib[i] = normContrib[center * 2 - i];
		}
	} // end of CalContrib()

	// 处理边缘
	private void CalTempContrib(int start, int stop) {
		double weight = 0;

		int i = 0;
		for (i = start; i <= stop; i++) {
			weight += contrib[i];
		}

		for (i = start; i <= stop; i++) {
			tmpContrib[i] = contrib[i] / weight;
		}
	} // end of CalTempContrib()

	private int GetRedValue(int rgbValue) {
		int temp = rgbValue & 0x00ff0000;
		return temp >> 16;
	}

	private int GetGreenValue(int rgbValue) {
		int temp = rgbValue & 0x0000ff00;
		return temp >> 8;
	}

	private int GetBlueValue(int rgbValue) {
		return rgbValue & 0x000000ff;
	}

	private int ComRGB(int redValue, int greenValue, int blueValue) {

		return (redValue << 16) + (greenValue << 8) + blueValue;
	}

	// 行水平滤波
	private int HorizontalFilter(BufferedImage bufImg, int startX, int stopX, int start, int stop, int y, double[] pContrib) {
		double valueRed = 0.0;
		double valueGreen = 0.0;
		double valueBlue = 0.0;
		int valueRGB = 0;
		int i, j;

		for (i = startX, j = start; i <= stopX; i++, j++) {
			valueRGB = bufImg.getRGB(i, y);

			valueRed += GetRedValue(valueRGB) * pContrib[j];
			valueGreen += GetGreenValue(valueRGB) * pContrib[j];
			valueBlue += GetBlueValue(valueRGB) * pContrib[j];
		}

		valueRGB = ComRGB(Clip((int) valueRed), Clip((int) valueGreen), Clip((int) valueBlue));
		return valueRGB;

	} // end of HorizontalFilter()

	// 图片水平滤波
	private BufferedImage HorizontalFiltering(BufferedImage bufImage, int iOutW) {
		int dwInW = bufImage.getWidth();
		int dwInH = bufImage.getHeight();
		int value = 0;
		BufferedImage pbOut = new BufferedImage(iOutW, dwInH, BufferedImage.TYPE_INT_RGB);

		for (int x = 0; x < iOutW; x++) {

			int startX;
			int start;
			int X = (int) (((double) x) * ((double) dwInW) / ((double) iOutW) + 0.5);
			int y = 0;

			startX = X - nHalfDots;
			if (startX < 0) {
				startX = 0;
				start = nHalfDots - X;
			} else {
				start = 0;
			}

			int stop;
			int stopX = X + nHalfDots;
			if (stopX > (dwInW - 1)) {
				stopX = dwInW - 1;
				stop = nHalfDots + (dwInW - 1 - X);
			} else {
				stop = nHalfDots * 2;
			}

			if (start > 0 || stop < nDots - 1) {
				CalTempContrib(start, stop);
				for (y = 0; y < dwInH; y++) {
					value = HorizontalFilter(bufImage, startX, stopX, start, stop, y, tmpContrib);
					pbOut.setRGB(x, y, value);
				}
			} else {
				for (y = 0; y < dwInH; y++) {
					value = HorizontalFilter(bufImage, startX, stopX, start, stop, y, normContrib);
					pbOut.setRGB(x, y, value);
				}
			}
		}

		return pbOut;
	} // end of HorizontalFiltering()

	private int VerticalFilter(BufferedImage pbInImage, int startY, int stopY, int start, int stop, int x, double[] pContrib) {
		double valueRed = 0.0;
		double valueGreen = 0.0;
		double valueBlue = 0.0;
		int valueRGB = 0;
		int i, j;

		for (i = startY, j = start; i <= stopY; i++, j++) {
			valueRGB = pbInImage.getRGB(x, i);
			valueRed += GetRedValue(valueRGB) * pContrib[j];
			valueGreen += GetGreenValue(valueRGB) * pContrib[j];
			valueBlue += GetBlueValue(valueRGB) * pContrib[j];
		}

		valueRGB = ComRGB(Clip((int) valueRed), Clip((int) valueGreen), Clip((int) valueBlue));
		return valueRGB;
	} // end of VerticalFilter()

	private BufferedImage VerticalFiltering(BufferedImage pbImage, int iOutH) {
		int iW = pbImage.getWidth();
		int iH = pbImage.getHeight();
		int value = 0;
		BufferedImage pbOut = new BufferedImage(iW, iOutH, BufferedImage.TYPE_INT_RGB);

		for (int y = 0; y < iOutH; y++) {

			int startY;
			int start;
			int Y = (int) (((double) y) * ((double) iH) / ((double) iOutH) + 0.5);

			startY = Y - nHalfDots;
			if (startY < 0) {
				startY = 0;
				start = nHalfDots - Y;
			} else {
				start = 0;
			}

			int stop;
			int stopY = Y + nHalfDots;
			if (stopY > (int) (iH - 1)) {
				stopY = iH - 1;
				stop = nHalfDots + (iH - 1 - Y);
			} else {
				stop = nHalfDots * 2;
			}

			if (start > 0 || stop < nDots - 1) {
				CalTempContrib(start, stop);
				for (int x = 0; x < iW; x++) {
					value = VerticalFilter(pbImage, startY, stopY, start, stop, x, tmpContrib);
					pbOut.setRGB(x, y, value);
				}
			} else {
				for (int x = 0; x < iW; x++) {
					value = VerticalFilter(pbImage, startY, stopY, start, stop, x, normContrib);
					pbOut.setRGB(x, y, value);
				}
			}
		}
		return pbOut;
	} // end of VerticalFiltering()

	int Clip(int x) {
		if (x < 0)
			return 0;
		if (x > 255)
			return 255;
		return x;
	}
	
	/** 
	* 生成缩略图 
	* @param filePath 原文件路径 
	* @param cachFile 生成缩略图路径 
	* @throws Exception 
	*/ 
  private void saveCachFile(BufferedImage src, String cachFile) throws Exception {
    FileOutputStream out = null;
    try {
      int width = src.getWidth(null); // 得到源图宽
      int height = src.getHeight(null);
      int newWidth = 0;// 重新设定它的宽
      int newHeight = 0;// 重新设定高
      if (width > height) {
        newWidth = 80;// 重新设定它的宽
        newHeight = 80 * height / width;// 重新设定高,用比例计算图片的高(重设高/实高=重设宽/实宽)
      } else {
        newHeight = 80;// 重新设定它的宽
        newWidth = 80 * width / height;// 重新设定高,用比例计算图片的高(重设高/实高=重设宽/实宽)
      }
      BufferedImage descImg = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
      descImg.getGraphics().drawImage(src.getScaledInstance(newWidth, newHeight, Image.SCALE_AREA_AVERAGING), 0, 0, newWidth, newHeight, null); // 绘制缩小后的图
      out = new FileOutputStream(cachFile);// 输出到文件流
      JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
      encoder.encode(descImg); // 近JPEG编码
    } catch (Exception e) {
      throw e;
    }finally {
      try {
        if (out != null) {
          out.close();
        }
      }catch(Exception ex) {        
      }
    }
  }
}