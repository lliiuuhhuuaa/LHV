package cn.hua.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.springframework.web.multipart.MultipartFile;

import cn.hua.bean.MySource;
import cn.hua.bean.SaveFile;
import cn.hua.bean.form.Barrage;
import cn.hua.bean.form.Comment;
import cn.hua.service.dao.ServiceDao;

public class FileRW {
		private static Properties properties=new Properties();
		private static Properties ffmpeg=new Properties();
		private static StringBuffer sb = new StringBuffer();
		private static String LOCK = "lock";
		static{
			try {
				//配置文件读取
				properties.load(FileRW.class.getClassLoader().getResourceAsStream("path.properties"));
				ffmpeg.load(FileRW.class.getClassLoader().getResourceAsStream("ffmpeg.properties"));
				BufferedReader br = new BufferedReader(new InputStreamReader(FileRW.class.getClassLoader().getResourceAsStream("series_exception.txt")));
				String str = null;
				while((str = br.readLine())!=null){
					sb.append(str);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}finally{
				if(properties.isEmpty()){
					throw new RuntimeException("路径配置文件不存在！path.propeties");
				}
				if(ffmpeg.isEmpty()){
					throw new RuntimeException("ffmpeg配置文件不存在！ffmpeg.properties");
				}
			}
		}
		/**
		 * 获取上传文件路径
		 * @param type
		 * @param file
		 * @return
		 */
		public static String getSavePath(String type,MultipartFile file) {
			type = "pic".equals(type)?"litimg":"source";
			return getDir(properties.getProperty(type), UUID.randomUUID().toString()) + File.separatorChar +(file==null?UUID.randomUUID().toString()+".jpg":getNameAndSuffix(file.getOriginalFilename()));

		}
		//检查后缀
		public static boolean checkImgSuffix(String name){
			if(name==null||name!=null&&name.trim().equals("")){
				return false;
			}
			String[] fileSuffix = new String[] { ".jpg", ".gif", ".png",".jpge"};
			for (String fileSuffixName : fileSuffix) {
				if (name.toLowerCase().endsWith(fileSuffixName)) {
					return true;
				}
			}
			return false;
		}
		//检查后缀
		public static boolean checkSourceSuffix(String name){
			if(name==null||name!=null&&name.trim().equals("")){
				return false;
			}
			String[] fileSuffix = new String[] { ".mp4", ".mkv", ".rmvb",".avi",".rm","mov",".wmv","flv"};
			for (String fileSuffixName : fileSuffix) {
				if (name.toLowerCase().endsWith(fileSuffixName)) {
					return true;
				}
			}
			return false;
		}
	/*// 上传
		public static String saveImg(MultipartFile file,String path){
			try {
				InputStream inputStream = file.getInputStream();
				FileOutputStream outputStream = new FileOutputStream(path);
				byte[] buf = new byte[1024];
				int length = 0;
				while ((length = inputStream.read(buf)) != -1) {
					outputStream.write(buf, 0, length);
				}
				inputStream.close();
				outputStream.close();
				return path;
			} catch (Exception e) {
				new FileOperation(path).start(); // 启用线程删除文件
				e.printStackTrace();
			}
			return null;
		}*/
		//上传文件
		public static boolean saveSource(MultipartFile file,String path){
			InputStream inputStream=null;
			FileOutputStream outputStream=null;
			try {
				inputStream = file.getInputStream();
				outputStream = new FileOutputStream(path);
				byte[] buf = new byte[10240000];
				int length = 0;
				while ((length = inputStream.read(buf)) != -1) {
					outputStream.write(buf, 0, length);
				}
				outputStream.flush();
				outputStream.close();
				inputStream.close();
				return true;
			} catch (Exception e) {
				new FileOperation(path).start(); // 启用线程删除文件
				throw new RuntimeException(e);
			}finally{
					try {
						if(outputStream!=null) outputStream.close();
						if(inputStream!=null) inputStream.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
		}
		//上传头像
		public static boolean saveSource(byte[] img,String path){
			FileOutputStream output=null;
			try {
				output = new FileOutputStream(path);
				output.write(img);
				output.flush();
				return true;
			} catch (Exception e) {
				new FileOperation(path).start(); // 启用线程删除文件
				throw new RuntimeException(e);
			}finally{
				try {
					if(output!=null)
					output.close();
				} catch (IOException e) {
					output=null;
				}
			}
		}
		/**
		 * 自动扫描文件
		 * @param file
		 * @param level
		 * @param sources
		 * @param autoSeries
		 * @param message
		 * @param service
		 */
		public static void autoScan(File file,Integer level, List<MySource> sources, Integer autoSeries, Message message, ServiceDao service,String ... series){
			if(file.exists()){
				if(file.isDirectory()){
					String seriesname = file.getName();
					if(level>0){
						String[] list = file.list();
						if(list==null)return;
						level--;
						for(String temp : list){
							autoScan(new File(file.getAbsoluteFile(),temp),level,sources,autoSeries,message,service,seriesname);
						}
					}
				}else{
					if(checkSourceSuffix(file.getName())){
						if(!service.pathIsExist(file.getAbsolutePath())){
							sources.add(new MySource(file.getName().substring(0,file.getName().lastIndexOf(".")),new SaveFile(file.getAbsolutePath()),checkSeriesName(series,autoSeries)));
							message.send(Conversion.stringToJson("log,扫描到文件："+file.getName()));
						}else{
							message.send(Conversion.stringToJson("log,已存在，跳过文件："+file.getName()));
						}
					}
				}
			}
		}
		//获取保存的文件夹
		public static String getDir(String path, String uuid) {
			Long currentTime = System.currentTimeMillis();
			int hashcode = currentTime.hashCode();
			int dir1 = hashcode & 0xf;
			int dir2 = (hashcode >> 4) & 0xf;
			String finalPath;
			if (uuid != null)
				finalPath = path + File.separatorChar + dir1 + File.separatorChar + dir2 + File.separatorChar
						+ UUID.randomUUID();
			else
				finalPath = path + File.separatorChar + dir1 + File.separatorChar + dir2;
			File file = new File(finalPath);
			if (!file.exists()) {
				file.mkdirs();
			}
			return finalPath;
		}
		//获取保存文件基路径
		public static String getPath(String type){
			return properties.getProperty(type);
		}
		//获取文件后缀
		public static String getSuffix(String name){
			if(name==null||name!=null&&name.lastIndexOf(".")==-1)return "";
			return name.substring(name.lastIndexOf("."));
		}
		//获取文件后缀
		public static String getNameAndSuffix(String name){
			return System.currentTimeMillis()+"-_-"+name;
		}
		//检查是否符合系列名规范
		public static String checkSeriesName(String[] name, Integer autoSeries){
			if(autoSeries==0||name==null||name!=null&&name.length<1)return null;
			if(name[0].length()>20)return null;
			if(sb.indexOf("-"+name[0]+"-")!=-1){
				return null;
			}else{
				return name[0];
			}
		}
		/**
		 * 获取文件的md5码
		 * @param input
		 * @return
		 */
		public static String fileMD5(InputStream input){
		      // 缓冲区大小（这个可以抽出一个参数）
		      int bufferSize = 1024*10000;
		      DigestInputStream digestInputStream = null;
		      try {
		         // 拿到一个MD5转换器（同样，这里可以换成SHA1）
		         MessageDigest messageDigest =MessageDigest.getInstance("MD5");
		         // 使用DigestInputStream
		         digestInputStream = new DigestInputStream(input,messageDigest);
		         // read的过程中进行MD5处理，直到读完文件
		         byte[] buffer =new byte[bufferSize];
		         while (digestInputStream.read(buffer) > 0);
		         // 获取最终的MessageDigest
		         messageDigest= digestInputStream.getMessageDigest();
		         // 拿到结果，也是字节数组，包含16个元素
		         byte[] resultByteArray = messageDigest.digest();
		         // 同样，把字节数组转换成字符串
		         return byteArrayToHex(resultByteArray);
		      } catch (Exception e) {
		         return null;
		      }finally {
		         try {
		            digestInputStream.close();
		         } catch (Exception e) {
		         }
		      }
		   }
		//下面这个函数用于将字节数组换成成16进制的字符串

		   public static String byteArrayToHex(byte[] b) {
		        String hs = "";   
		        String stmp = "";   
		        for (int n = 0; n < b.length; n++) {   
		            stmp = (Integer.toHexString(b[n] & 0XFF));   
		            if (stmp.length() == 1) {   
		                hs = hs + "0" + stmp;   
		            } else {   
		                hs = hs + stmp;   
		            }   
		            if (n < b.length - 1) {   
		                hs = hs + "";   
		            }   
		        }   
		        // return hs.toUpperCase();   
		        return hs;

		      // 首先初始化一个字符数组，用来存放每个16进制字符

		      /*char[] hexDigits = {'0','1','2','3','4','5','6','7','8','9', 'A','B','C','D','E','F' };

		 

		      // new一个字符数组，这个就是用来组成结果字符串的（解释一下：一个byte是八位二进制，也就是2位十六进制字符（2的8次方等于16的2次方））

		      char[] resultCharArray =new char[byteArray.length * 2];

		      // 遍历字节数组，通过位运算（位运算效率高），转换成字符放到字符数组中去

		      int index = 0;

		      for (byte b : byteArray) {

		         resultCharArray[index++] = hexDigits[b>>> 4 & 0xf];

		         resultCharArray[index++] = hexDigits[b& 0xf];

		      }

		      // 字符数组组合成字符串返回

		      return new String(resultCharArray);*/

		}
		   /**
		    * 视频截图
		    * @param videoLocation
		    * @param imageLocation
		    * @return
		    */
		 public static boolean take(String videoLocation, String imageLocation){
			 // 低精度
			 List<String> commend = new ArrayList<String>();
			 commend.add(ffmpeg.getProperty("path"));//视频提取工具的位置
			 commend.add("-i");	//视频路径
			 commend.add(videoLocation);
			 commend.add("-y");
			 commend.add("-f");
			 commend.add("image2");
			 commend.add("-ss");	//截取时间点
			 commend.add(ffmpeg.getProperty("time","100"));
			 commend.add("-t");		//要截取的时间长度
			 commend.add("0.001");
			 commend.add("-s");	//截取图片的宽高
			 commend.add(ffmpeg.getProperty("width","460")+"*"+ffmpeg.getProperty("heigth","358"));
			 commend.add(imageLocation);	//图片保存路径
			 synchronized(FileRW.LOCK){
				 try {
					 ProcessBuilder builder = new ProcessBuilder();
					 builder.command(commend);
					 builder.redirectErrorStream(true);  
					 Process process = builder.start();
					 InputStream in =process.getInputStream();  
		             byte[] re = new byte[1024];  
		             System.out.print("正在进行截图，请稍候");  
		             while (in.read(re) != -1) {System.out.print(".");}  
		             System.out.println("");  
		             in.close();  
		             System.out.println("视频截图完成...");  
					return true;
				 } catch (Exception e) {
					 e.printStackTrace();
					 return false;
				 }
			 }
	 } 
	//获取保存的文件夹
		public static String getUUID_dir(String basePath,String uuid,String suffix) {
			int hashcode = uuid.hashCode();
			int dir1 = hashcode & 0xf;
			int dir2 = (hashcode >> 4) & 0xf;
			String finalPath;
			finalPath = basePath + File.separatorChar + dir1 + File.separatorChar + dir2;
			File file = new File(finalPath);
			if (!file.exists()) {
				file.mkdirs();
			}
			return finalPath+File.separatorChar+uuid+"."+suffix;
		}
		/**
		 * 保存弹幕文件
		 * @param id
		 * @param barrage
		 * @return
		 */
	public static boolean saveBarrage(String id,Barrage barrage){
		File file = new File(getUUID_dir(properties.getProperty("barrage"), id,"xml"));
		SAXReader reader = new SAXReader();
		reader.setEncoding("UTF-8");
    	Document doc = null;
    	Element root=null;
    	try {
			if(!file.exists()){
	    		doc = DocumentHelper.createDocument();
	    		root = doc.addElement("lhv");
	    	}
	    	if(doc==null)doc = reader.read(file);
	    	if(root==null)root = doc.getRootElement();
	    	
			Element mes = root.addElement("bar").addAttribute("color", barrage.getColor())
					.addAttribute("position", barrage.getPosition()).addAttribute("size", barrage.getSize())
					.addAttribute("time", barrage.getTime()).addAttribute("send_time", barrage.getSend_time());
				mes.setText(barrage.getText());
			return saveXml(doc,file);
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return false;
	}
	/**
	 * 读取弹幕文件
	 * @param id
	 * @return
	 */
	public static List<Barrage> readBarrage(String id){
		File file = new File(getUUID_dir(properties.getProperty("barrage"), id,"xml"));
		List<Barrage> barrages=null;
		if(!file.exists()){
			return null;
		}
    	SAXReader reader = new SAXReader();
    	reader.setEncoding("UTF-8");
    	Document doc;
		try {
			doc = reader.read(file);
			if(doc==null)return null;
			List<Element> list = doc.getRootElement().elements("bar");
			for(Element e: list){
				if(barrages==null)barrages=new ArrayList<Barrage>();
				Barrage barrage = new Barrage();
				barrage.setColor(e.attributeValue("color"));
				barrage.setPosition(e.attributeValue("position"));
				barrage.setSize(e.attributeValue("size"));
				barrage.setTime(e.attributeValue("time"));
				barrage.setSend_time(e.attributeValue("send_time"));
				barrage.setText(e.getText());
				barrages.add(barrage);
			}
			if(barrages!=null)
			java.util.Collections.sort(barrages);
			return barrages;
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	//保存文件
    public static boolean saveXml(Document doc,File file){
		 OutputFormat outputFormat = new OutputFormat("\t", true);
		 outputFormat.setEncoding("UTF-8");
	     outputFormat.setLineSeparator("\r\n");//这是为了换行操作  
		try {
			XMLWriter output = new XMLWriter(new FileOutputStream(file),outputFormat);  
			output.write(doc);
			output.close();
			return true;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
    }
    /**
     * 保存评论
     * @param id
     * @param comment
     * @return
     */
	public static boolean saveComment(String id, Comment comment) {
		File file = new File(getUUID_dir(properties.getProperty("comment"),id,"xml"));
		SAXReader reader = new SAXReader();
		reader.setEncoding("UTF-8");
    	Document doc = null;
    	Element root=null;
    	try {
			if(!file.exists()){
	    		doc = DocumentHelper.createDocument();
	    		root = doc.addElement("lhv");
	    	}
	    	if(doc==null)doc = reader.read(file);
	    	if(root==null)root = doc.getRootElement();
	    	
			Element mes = root.addElement("com").addAttribute("user_id", "".equals(comment.getUser_id())?null:comment.getUser_id())
					.addAttribute("time",comment.getTime()).addAttribute("support", comment.getSupport()+"");
				mes.setText(comment.getText());
			return saveXml(doc,file);
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return false;
	}
	/**
	 * 读取评论文件
	 * @param id
	 * @return
	 */
	public static List<Comment> readComment(String id){
		File file = new File(getUUID_dir(properties.getProperty("comment"), id,"xml"));
		List<Comment> comments=null;
		if(!file.exists()){
			return null;
		}
    	SAXReader reader = new SAXReader();
    	reader.setEncoding("UTF-8");
    	Document doc;
		try {
			doc = reader.read(file);
			if(doc==null)return null;
			List<Element> list = doc.getRootElement().elements("com");
			for(Element e: list){
				if(comments==null)comments=new ArrayList<Comment>();
				Comment comment = new Comment();
				comment.setSupport(Long.parseLong(e.attributeValue("support")));
				comment.setTime(e.attributeValue("time"));
				comment.setUser_id(e.attributeValue("user_id"));
				comment.setText(e.getText());
				comments.add(comment);
			}
			java.util.Collections.sort(comments);
			return comments;
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	public static boolean praiseComment(String id, String time) {
		File file = new File(getUUID_dir(properties.getProperty("comment"), id,"xml"));
		if(!file.exists()){
			return false;
		}
    	SAXReader reader = new SAXReader();
    	Document doc;
		try {
			doc = reader.read(file);
			if(doc==null)return false;
			Element e = (Element) doc.selectSingleNode("/lhv/com[@time='"+time+"']");
			e.setParent(null);
			doc.getRootElement().remove(e);
			String support = Long.parseLong(e.attributeValue("support"))+1+"";
			e.remove(e.attribute("support"));
			e.addAttribute("support", support);
			doc.getRootElement().add(e);
			return saveXml(doc, file);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
}
