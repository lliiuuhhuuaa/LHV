package cn.hua.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.hua.annotation.Jurisdiction;
import cn.hua.bean.Category;
import cn.hua.bean.MySource;
import cn.hua.bean.SaveFile;
import cn.hua.bean.SourceLog;
import cn.hua.bean.form.MissionBean;
import cn.hua.service.dao.ServiceDao;
import cn.hua.socket.MyHandler;
import cn.hua.utils.Conversion;
import cn.hua.utils.ConvertSource;
import cn.hua.utils.FileOperation;
import cn.hua.utils.FileRW;
import cn.hua.utils.Message;

@Controller
public class UtilsMission {
	@Autowired
	private ServiceDao service;
	//线程锁常量
	public final static String ONLINELOCK="online";
	public final static String OFFLINELOCK="offline";
	public final static String CLEARLOCK="clearRubbish";
	public final static String CONVERLOCK="videoConver";
	//保存当前任务
	private static Map<String,MissionBean> missions = new HashMap<String,MissionBean>();
	public static Map<String,MissionBean> getMissions() {
		return missions;
	}
	public static void removeMission(String id){
		missions.remove(id);
	}
	//获取当前已存在任务
	@Jurisdiction({"BackgroundLogin","UtilsUsed"})
	@RequestMapping(value="utils/mission",method=RequestMethod.GET)
	public String mission(Map<String,Object> map){
		map.put("mission", missions.values());
		return "manageUtils";
	}
	//添加任务
	@ResponseBody
	@RequestMapping(value="utils/mission",method=RequestMethod.POST)
	@Jurisdiction({"BackgroundLogin","UtilsUsed"})
	public String mission(@Valid MissionBean mi){
		if(mi!=null){
			if(mi.getCode()!=null&&mi.getCode()==1){
				//判断任务集体中是否已存在当前类型任务
				if(!missions.containsKey(mi.getType())){
					//获取当前用户通信Session
					if(MyHandler.getSessionById(mi.getId())!=null){
						mi.setTime(System.currentTimeMillis());
						missions.put(mi.getType(),mi);
						//启动任务分配线程分配执行任务
						new Mission(service,mi).start();
						return Conversion.stringToJson("message,true");
					}else
						return Conversion.stringToJson("message,false,cause,通信服务器未连接");
				}else{
					MissionBean mib = missions.get(mi.getType());
					//判断当前已存在任务是否处理暂停状态
					if(mib.getState()==2){
						/*mib.setState(1);//设置状态
						this.notifyAll();*/
						mib.setId(mi.getId());
						new Mission(service,mib).start();
						return Conversion.stringToJson("message,true");
					}else{
						return Conversion.stringToJson("message,false,cause,任务在服务器上未完成");
					}
				}
				//如果
			}else if(mi.getCode()!=null&&mi.getCode()==0){
				if(missions.get(mi.getType())!=null)
					missions.get(mi.getType()).setState(mi.getCode());
				return Conversion.stringToJson("message,true");
			}else if(mi.getCode()!=null&&mi.getCode()==2){
				if(missions.get(mi.getType())!=null)
					missions.get(mi.getType()).setState(mi.getCode());
				return Conversion.stringToJson("message,true");
			}
		}
		return Conversion.stringToJson("message,false,cause,未知错误");
	}
}
//任务分配线程
class Mission extends Thread{
	private MissionBean mi;
	private ServiceDao service;
	public Mission(ServiceDao service,MissionBean mi){
		this.service = service;
		this.mi = mi;
	}
	@Override
	public void run() {
		//根据类型分配线程执行任务
			if("autoOnline".equals(mi.getType())){
				synchronized (UtilsMission.ONLINELOCK) {
					if(mi.getState()==2){	//当状态为2，则唤醒暂停的任务
						mi.setState(1);
						UtilsMission.ONLINELOCK.notifyAll();
						return;
					}
				}
				new AutoOnline(service).start();	//开启线程执行任务
			}else if("autoOffline".equals(mi.getType())){
				synchronized (UtilsMission.OFFLINELOCK) {
					if(mi.getState()==2){
						mi.setState(1);
						UtilsMission.OFFLINELOCK.notifyAll();
						return;
					}
				}
				new AutoOffline(service).start();
			}else if("clearRubbish".equals(mi.getType())){
				synchronized (UtilsMission.CLEARLOCK) {
					if(mi.getState()==2){
						mi.setState(1);
						UtilsMission.CLEARLOCK.notifyAll();
						return;
					}
				}
				new ClearRubbish(service).start();
			}else if("videoConver".equals(mi.getType())){
				synchronized (UtilsMission.CONVERLOCK) {
					if(mi.getState()==2){
						mi.setState(1);
						UtilsMission.CONVERLOCK.notifyAll();
						return;
					}
				}
				new VideoConver(service).start();
			}
	}
	
}
/**
 * 自动上线线程处理
 * @author 甜橙六画
 *
 */
class AutoOnline extends Thread{
	private ServiceDao service;
	public AutoOnline(ServiceDao service) {
		this.service = service;
	}
	@Override
	public void run() {
		MissionBean missionBean = UtilsMission.getMissions().get("autoOnline");
		Message message = new Message();
		try{
			synchronized (UtilsMission.ONLINELOCK) {
				System.out.println("liuhua:自动上线正在执行");
				List<MySource> passed = new ArrayList<MySource>();
				List<MySource> list = service.findSourceByOffline();
				List<Category> categoryRoot = service.getAllCategory();
				for(int i=0;list!=null&&i<list.size();i++){
					MySource source = list.get(i);
					boolean catePass = false;//分类检验，至少包含一个主类
					for(Category cate : categoryRoot){
						for(Category temp : source.getCategory()){
							if(cate.getId().equals(temp.getId())){
								catePass=true;break;
							}
						}
						if(catePass)break;
					}
					if(!catePass)continue;
					//检查视频需不需要转换格式
					if(ConvertSource.checkIsConver(source.getSource()))continue;
					File video = new File(source.getSource().getPath());
					if(video.exists()){
						if(source.getImg()==null||source.getImg()!=null&&!(new File(source.getImg().getPath()).exists())){
							String imgpath = FileRW.getSavePath("pic", null);
							if(FileRW.take(video.getAbsolutePath(), imgpath)){
								SaveFile saveFile = new SaveFile();
								saveFile.setPath(imgpath);
								source.setImg(saveFile);
							}
						}
						if(source.getSeriesname()==null)source.setSeriesname(source.getId());
						if(source.getLog().getGrade()==null){
							SourceLog log = source.getLog();
							log.setGrade("0,0,0,0,0");
							source.setLog(log);
						}
						source.setIspass(1);
						passed.add(source);
					}
					if(missionBean!=null){
						if(missionBean.getState()==2){
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,2"));
							UtilsMission.ONLINELOCK.wait();
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,1"));
						}else if(missionBean.getState()==0){
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,0"));
							return;
						}
					}
				}
				int num=0;
				if(passed.size()>0){
					//对符合规范的进行更新
					num = service.updateMany(passed);
				}
				message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,10,handler,"+num));
				UtilsMission.removeMission(missionBean.getType());
			}
		}
		catch(Exception e){
			message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,8"));
			UtilsMission.removeMission(missionBean.getType());
		}
	}
}
/**
 * 自动下线处理线程
 * @author 甜橙六画
 *
 */
class AutoOffline extends Thread{
	private ServiceDao service;
	public AutoOffline(ServiceDao service) {
		this.service = service;
	}
	@Override
	public void run() {
		MissionBean missionBean = UtilsMission.getMissions().get("autoOffline");
		Message message = new Message();
		try{
			synchronized (UtilsMission.OFFLINELOCK) {
				System.out.println("liuhua:自动下线正在执行");
				List<String> offline = new ArrayList<String>();
				List<MySource> list = service.findSourceByOnline();
				for(int i=0;i<list.size();i++){
					MySource source = list.get(i);
					File video = new File(source.getSource()!=null?source.getSource().getPath():null);
					File img = new File(source.getImg()!=null?source.getImg().getPath():null);
					if(!(video.exists())||!(img.exists())){
						offline.add(source.getId());
					}else{
						//检查视频需不需要转换格式
						if(ConvertSource.checkIsConver(source.getSource()))offline.add(source.getId());
					}
					if(missionBean!=null){
						if(missionBean.getState()==2){
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,2"));
							UtilsMission.OFFLINELOCK.wait();
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,1"));
						}else if(missionBean.getState()==0){
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,0"));
							return;
						}
					}
				}
				int num=0;
				if(offline.size()>0){
					num = service.updateManySource(offline,0);
				}
				message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,10,handler,"+num));
				UtilsMission.removeMission("autoOffline");
			}
		}catch(Exception e){
			message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,8"));
			UtilsMission.removeMission(missionBean.getType());
		}
	}
}
/**
 * 清理垃圾文件处理线程
 * @author 甜橙六画
 *
 */
class ClearRubbish extends Thread{
	private static Properties properties=new Properties();
	static{
		try {
			properties.load(FileRW.class.getClassLoader().getResourceAsStream("path.properties"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	private ServiceDao service;
	private int dirOrFile=0;
	MissionBean missionBean = UtilsMission.getMissions().get("clearRubbish");
	Message message = new Message();
	public ClearRubbish(ServiceDao service) {
		this.service = service;
	}
	@Override
	public void run() {
		try{
			synchronized(UtilsMission.CLEARLOCK){
				System.out.println("liuhua:自动清理正在执行");
				service.deleteRubbishFile();
				traverse(new File(properties.get("litimg").toString()));
				if(missionBean!=null){
					if(missionBean.getState()==2){
						message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,2"));
						UtilsMission.CLEARLOCK.wait();
						message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,2"));
					}else if(missionBean.getState()==0){
						message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,0"));
						UtilsMission.removeMission(missionBean.getType());
						return;
					}
				}
				traverse(new File(properties.get("source").toString()));
				message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,10,handler,"+dirOrFile));
				UtilsMission.removeMission(missionBean.getType());
			}
		}catch(Exception e){
			message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,8"));
			UtilsMission.removeMission(missionBean.getType());
		}
		
	}
	//递归遍历目录下所有文件或目录
	private void traverse(File file){
		if(file.exists()){
			if(file.isDirectory()){
				File[] childs = file.listFiles();
				if(childs.length>0){
					for(File temp : childs)traverse(temp);
				}else{
					file.delete();
					dirOrFile++;
				}
			}else{
				String absPath = file.getAbsolutePath().replaceAll("/", "\\\\");
				if(!service.findSourceByPath(absPath)){
					new FileOperation(file.getAbsolutePath()).start();
					dirOrFile++;
				}
			}
		}
	}
}
/**
 * 视频格式线程处理
 * @author 甜橙六画
 *
 */
class VideoConver extends Thread{
	private ServiceDao service;
	public VideoConver(ServiceDao service) {
		this.service = service;
	}
	@Override
	public void run() {
		MissionBean missionBean = UtilsMission.getMissions().get("videoConver");
		Message message = new Message();
		try{
			synchronized (UtilsMission.CONVERLOCK) {
				System.out.println("liuhua:视频格式转换正在执行");
				List<MySource> list = service.findSourceByOffline();
				int num=0;
				for(int i=0;list!=null&&i<list.size();i++){
					MySource source = list.get(i);
					if(!ConvertSource.convert(source.getSource()))continue;
					service.update(source);num++;
					if(missionBean!=null){
						if(missionBean.getState()==2){
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,2"));
							UtilsMission.CONVERLOCK.wait();
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,1"));
						}else if(missionBean.getState()==0){
							message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,0"));
							return;
						}
					}
				}
				message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,10,handler,"+num));
				UtilsMission.removeMission(missionBean.getType());
			}
		}
		catch(Exception e){
			message.send(missionBean.getId(),Conversion.stringToJson("type,"+missionBean.getType()+",state,8"));
			UtilsMission.removeMission(missionBean.getType());
		}
	}
}