package cn.hua.utils;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

public class FileOperation extends Thread{
	private String path;
	private static Properties properties=new Properties();
	static{
		try {
			properties.load(FileRW.class.getClassLoader().getResourceAsStream("path.properties"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public FileOperation(String path){
		//path = path.replaceAll("\\\\", "/");
		this.path= path;
	}
	
	@Override
	public void run(){
		if(path!=null&&(path.startsWith(properties.getProperty("litimg"))||path.startsWith(properties.getProperty("source"))||path.startsWith(properties.getProperty("cvpath"))||path.startsWith(properties.getProperty("avatar_system")))){
			deleteFile(path,"noCheck");
			path = path.substring(0,Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\")));
			deleteFile(path,"check");
			path = path.substring(0,Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\")));
			deleteFile(path,"check");
			path = path.substring(0,Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\")));
			deleteFile(path,"check");
		}
	}
	public void deleteFile(String path,String type){
		File file = new File(path);
		if(file.exists()){
			if(file.isDirectory()){
				if(type.equals("check")){
					if(file.listFiles().length>0){
						return;
					}
				}else if(file.listFiles().length>0){
					for(File f : file.listFiles()){
						f.delete();
					}
				}
			}
			file.delete();
		}
	}
}
