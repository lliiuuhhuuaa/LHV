package cn.hua.utils;
/**
 * 功能：将任意格式的视频转化为flv格式，有利于在线视频播放
 * 前置条件：E盘下放有 ffmpeg.exe、ffplay.exep、threadGC2.dll（ffmpeg来自 
ffmpeg.rev12665.7z）
 *                 E盘下还需 mencoder.exe、drv43260.dll
 *  ps:   ffmpeg 能解析的格式：asx，asf，mpg，wmv，3gp，mp4，mov，avi，flv等
 *         mencoder 解析剩下的格式：wmv9，rm，rmvb  
 *  author：刘坤林
 *  time：2010.12.9
 */
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Properties;

import cn.hua.bean.SaveFile;

public class ConvertSource {
	private static Properties path=new Properties();
	private static Properties ffmpeg=new Properties();
	static{
		try {
			path.load(FileRW.class.getClassLoader().getResourceAsStream("path.properties"));
			ffmpeg.load(FileRW.class.getClassLoader().getResourceAsStream("ffmpeg.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(path.isEmpty()){
				throw new RuntimeException("路径配置文件不存在！path.propeties");
			}
			if(ffmpeg.isEmpty()){
				throw new RuntimeException("ffmpeg配置文件不存在！ffmpeg.properties");
			}
		}
	}
	/**
	 * 检查是否需要转换格式
	 * @return
	 */
	public static boolean checkIsConver(SaveFile saveFile){
		if(saveFile==null)return false;
		if(saveFile.getCvpath()!=null){
			if(new File(saveFile.getCvpath()).exists())
			return false;
		}
		if(!new File(saveFile.getPath()).exists()){
			return false;
		}
		//如果文件后缀为指定格式，强制转换为false,则不进行转换
		if(saveFile.getPath().toLowerCase().endsWith(ffmpeg.getProperty("cvformat").toLowerCase())&&"false".equalsIgnoreCase(ffmpeg.getProperty("isNeedCv"))){
			return false;
		}
		return true;
	}
	/**
	 * 功能函数
	 * 
	 * @param saveFile
	 *            待处理视频，需带路径
	 * @return
	 */
	public static boolean convert(SaveFile saveFile) {
		if(saveFile==null)return false;
		if(saveFile.getCvpath()!=null){
			if(new File(saveFile.getCvpath()).exists())
			return true;
		}
		if (!checkfile(saveFile.getPath())) {
			System.out.println(saveFile + " is not file");
			return false;
		}
		//如果文件后缀为指定格式，强制转换为false,则不进行转换
		if(saveFile.getPath().toLowerCase().endsWith(ffmpeg.getProperty("cvformat").toLowerCase())&&"false".equalsIgnoreCase(ffmpeg.getProperty("isNeedCv"))){
			return true;
		}
		String outputPath = getDir(saveFile.getId());
		if(new File(outputPath).exists()){
			saveFile.setCvpath(outputPath);
			return true;
		}else if (process(saveFile.getPath(), outputPath)) {
			System.out.println("ok");
			saveFile.setCvpath(outputPath);
			return true;
		}
		return false;
	}
	//获取保存的文件夹
	public static String getDir(String uuid) {
		int hashcode = uuid.hashCode();
		int dir1 = hashcode & 0xf;
		int dir2 = (hashcode >> 4) & 0xf;
		String finalPath;
		finalPath = path.getProperty("cvpath") + File.separatorChar + dir1 + File.separatorChar + dir2;
		File file = new File(finalPath);
		if (!file.exists()) {
			file.mkdirs();
		}
		return finalPath+File.separatorChar+uuid+ffmpeg.getProperty("cvformat");
	}
	// 检查文件是否存在
	private static boolean checkfile(String path) {
		File file = new File(path);
		if (!file.isFile()) {
			return false;
		}
		return true;
	}

	/**
	 * 转换过程 ：先检查文件类型，在决定调用 processFlv还是processAVI
	 * 
	 * @param inputFile
	 * @param outputFile
	 * @param response 
	 * @return
	 */
	private static boolean process(String inputFile, String outputFile) {
		int type = checkContentType(inputFile);
		boolean status = false;
		if (type == 0) {
			status = processFLV(inputFile, outputFile);// 直接将文件转为flv文件
		} else if (type == 1) {
			String avifilepath = processAVI(type, inputFile);
			if (avifilepath == null)
				return false;// avi文件没有得到
			status = processFLV(avifilepath, outputFile);// 将avi转为flv
		}
		return status;
	}

	/**
	 * 检查视频类型
	 * 
	 * @param inputFile
	 * @return ffmpeg 能解析返回0，不能解析返回1
	 */
	private static int checkContentType(String inputFile) {
		String type = inputFile.substring(inputFile.lastIndexOf(".") + 1, inputFile.length()).toLowerCase();
		// ffmpeg能解析的格式：（asx，asf，mpg，wmv，3gp，mp4，mov，avi，flv等）
		if (type.equals("avi")) {
			return 0;
		} else if (type.equals("mpg")) {
			return 0;
		} else if (type.equals("wmv")) {
			return 0;
		} else if (type.equals("3gp")) {
			return 0;
		} else if (type.equals("mov")) {
			return 0;
		} else if (type.equals("mp4")) {
			return 0;
		} else if (type.equals("asf")) {
			return 0;
		} else if (type.equals("asx")) {
			return 0;
		} else if (type.equals("flv")) {
			return 0;
		}
		// 对ffmpeg无法解析的文件格式(wmv9，rm，rmvb等),
		// 可以先用别的工具（mencoder）转换为avi(ffmpeg能解析的)格式.
		else if (type.equals("wmv9")) {
			return 1;
		} else if (type.equals("rm")) {
			return 1;
		} else if (type.equals("rmvb")) {
			return 1;
		} else if(type.equals("mkv")){
			return 1;
		}
		return 9;
	}

	/**
	 * ffmepg: 能解析的格式：（asx，asf，mpg，wmv，3gp，mp4，mov，avi，flv等）
	 * 
	 * @param inputFile
	 * @param outputFile
	 * @param response 
	 * @return
	 */
	private static boolean processFLV(String inputFile, String outputFile) {
		if (!checkfile(inputFile)) {
			System.out.println(inputFile + " is not file");
			return false;
		}
		List<String> commend = new java.util.ArrayList<String>();
		// 低精度
		commend.add(ffmpeg.getProperty("path"));
		commend.add("-i");
		commend.add(inputFile);
		commend.add("-vcodec");
		commend.add("libx264");
		commend.add("-b");
		commend.add("1024000");
		commend.add("-y");
		commend.add(outputFile);
		StringBuffer test = new StringBuffer();
		for (int i = 0; i < commend.size(); i++)
			test.append(commend.get(i) + " ");
		System.out.println(test);
		try {
			ProcessBuilder builder = new ProcessBuilder();
			builder.redirectErrorStream(true);
			builder.command(commend);
			Process process = builder.start();
			int len=0,time=0;byte[] buf = new byte[20480];
			InputStream input = process.getInputStream();
			System.out.print("正在转换视频格式.");
			while((len=input.read(buf))!=-1){
				System.out.print(".");time++;
			}
			return time<50?false:true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Mencoder: 对ffmpeg无法解析的文件格式(wmv9，rm，rmvb等),
	 * 可以先用别的工具（mencoder）转换为avi(ffmpeg能解析的)格式.
	 * 
	 * @param type
	 * @param inputFile
	 * @return
	 */
	private static String processAVI(int type, String inputFile) {
		File file = new File(path.getProperty("temppath")+File.separatorChar+"temp.avi");
		if (file.exists())
			file.delete();
		List<String> commend = new java.util.ArrayList<String>();
		commend.add(ffmpeg.getProperty("mencoderpath"));
		commend.add(inputFile);
		commend.add("-oac");
		commend.add("mp3lame");
		commend.add("-lameopts");
		commend.add("preset=64");
		commend.add("-ovc");
		commend.add("xvid");
		commend.add("-xvidencopts");
		commend.add("bitrate=2048");
		commend.add("-of");
		commend.add("avi");
		commend.add("-o");
		commend.add(path.getProperty("temppath")+File.separatorChar+"temp.avi");
		StringBuffer test = new StringBuffer();
		for (int i = 0; i < commend.size(); i++)
			test.append(commend.get(i) + " ");
		System.out.println(test);
		try {
			ProcessBuilder builder = new ProcessBuilder();
			builder.command(commend);
			Process p = builder.start();
			/**
			 * 清空Mencoder进程 的输出流和错误流 因为有些本机平台仅针对标准输入和输出流提供有限的缓冲区大小，
			 * 如果读写子进程的输出流或输入流迅速出现失败，则可能导致子进程阻塞，甚至产生死锁。
			 */
			final InputStream is1 = p.getInputStream();
			final InputStream is2 = p.getErrorStream();
			new Thread() {
				public void run() {
					BufferedReader br = new BufferedReader(new InputStreamReader(is1));
					try {
						String lineB = null;
						while ((lineB = br.readLine()) != null) {
							if (lineB != null)
								System.out.println(lineB);
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}.start();
			new Thread() {
				public void run() {
					BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
					try {
						String lineC = null;
						while ((lineC = br2.readLine()) != null) {
							if (lineC != null)
								System.out.println(lineC);
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}.start();

			// 等Mencoder进程转换结束，再调用ffmepg进程
			p.waitFor();
			return path.getProperty("temppath")+File.separatorChar+"temp.avi";
		} catch (Exception e) {
			System.err.println(e);
			return null;
		}
	}
}