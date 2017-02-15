package cn.hua.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import cn.hua.annotation.Jurisdiction;
import cn.hua.annotation.LoginSign;
import cn.hua.bean.Category;
import cn.hua.bean.MySource;
import cn.hua.bean.SaveFile;
import cn.hua.bean.SourceLog;
import cn.hua.bean.SpecialSource;
import cn.hua.bean.User;
import cn.hua.bean.form.DataRequest;
import cn.hua.bean.form.DataResponse;
import cn.hua.service.dao.ServiceDao;
import cn.hua.socket.MyHandler;
import cn.hua.utils.Conversion;
import cn.hua.utils.FileOperation;
import cn.hua.utils.FileRW;
import cn.hua.utils.Message;

@Controller
public class MySourceController {
	@Autowired
	private ServiceDao service;
	@RequestMapping(value="/uploadSource",method=RequestMethod.GET)
	public String updateSource(Map<String,Object> request){
		request.put("categorys", service.getAllCategory());
		return "uploadSource";
	}
	@Jurisdiction({"BackgroundLogin","LocalScan"})
	@RequestMapping(value="/uploadSource2",method=RequestMethod.GET)
	public String updateSource2(){
		return "uploadSource2";
	}
	@Jurisdiction({"BackgroundLogin"})
	@RequestMapping(value="/sourceManage",method=RequestMethod.GET)
	public String sourceManage(){
		return "sourceManage";
	}
	@Jurisdiction({"BackgroundLogin"})
	@RequestMapping(value="/specialSourceManage",method=RequestMethod.GET)
	public String sourceManage2(){
		return "specialSourceManage";
	}
	/**
	 * 表单上传
	 * @param source
	 * @param result
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","AddSource"})
	@RequestMapping(value="json/updateSource/form",method=RequestMethod.POST)
	@ResponseBody
	public String uploadForm(@Valid MySource source,BindingResult result,HttpSession session){
		if(result.hasErrors()){
			return Conversion.stringToJson("message,false,cause,表单服务器验证失败");
		}
		try{
			User user = (User)session.getAttribute("user");
			String cateIds=null;
			for(Category ctemp : source.getCategory()){
				if(cateIds==null)cateIds="";
				cateIds += ctemp.getId()+",";
			}
			if(source.getId()==null||source.getId()!=null&&source.getId().equals("")||source.getId()!=null&&source.getId().length()<=20){
				source.setLog(new SourceLog(new Date(),user.getId()));
				service.addSource(source);}
			else{
				MySource mySource = service.findSourceById(source.getId());
				BeanUtils.copyProperties(source, mySource,"img","source","log");
				source=mySource;
				source.setKind(cateIds);
				if(source.getSeriesname()==null)source.setSeriesname(source.getId());
				service.updateSource(source);
			}
			if(source.getSeriesname()!=null){
				List<MySource> my = service.findSourceBySeries(source.getSeriesname(),source.getId());
				if(my.size()>0){
					for(MySource ms : my){
						Set<Category> msCate = new HashSet<Category>();
						ms.setKind(cateIds);
						ms.setIspass(0);
						msCate.addAll(source.getCategory());
						ms.setCategory(msCate);
						ms.setDecription(source.getDecription());
						
					}
					service.updateMany(my);
				}
			}
			return Conversion.stringToJson("message,true,id,"+source.getId());
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,保存信息失败，请重试");
	}
	/**
	 * 表单上传
	 * @param source
	 * @param result
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping(value="json/user/addSource/form",method=RequestMethod.POST)
	@ResponseBody
	public String userAddForm(@Valid MySource source,BindingResult result,HttpSession session){
		if(result.hasErrors()){
			return Conversion.stringToJson("message,false,cause,表单服务器验证失败");
		}
		try{
			User user = (User)session.getAttribute("user");
			String cateIds=null;
			for(Category ctemp : source.getCategory()){
				if(cateIds==null)cateIds="";
				cateIds += ctemp.getId()+",";
			}
			if(source.getId()==null||source.getId()!=null&&source.getId().equals("")||source.getId()!=null&&source.getId().length()<=20){
				source.setLog(new SourceLog(new Date(),user.getId()));
				service.addSource(source);
			}
			return Conversion.stringToJson("message,true,id,"+source.getId());
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,保存信息失败，请重试");
	}
	/**
	 * 主页展示表单上传
	 * @param source
	 * @param result
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","AddSource","UpdateSource"})
	@RequestMapping(value="json/updateSpecialSource/form",method=RequestMethod.POST)
	@ResponseBody
	public String uploadForm2(@Valid SpecialSource source,BindingResult result,HttpSession session){
		if(result.hasErrors()){
			return Conversion.stringToJson("message,false,cause,表单服务器验证失败");
		}
		try{
			if(source.getId()==null||source.getId()!=null&&source.getId().equals("")||source.getId()!=null&&source.getId().length()<=20){
				int num = service.count(SpecialSource.class, "");
				if(num>=10)return Conversion.stringToJson("message,false,cause,展示资源最多只能保存10条");
				service.add(source);}
			else{
				SpecialSource temp_source = service.findById(SpecialSource.class,source.getId());
				BeanUtils.copyProperties(source, temp_source,"img");
				service.update(temp_source);
			}
			return Conversion.stringToJson("message,true,id,"+source.getId());
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,保存信息失败，请重试");
	}
	/**
	 * 本地文件扫描
	 * @param source
	 * @param result
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","LocalScan","AddSource"})
	@RequestMapping(value="json/scanFile/{socketID}",method=RequestMethod.POST)
	@ResponseBody
	public String scan(@PathVariable String socketID,@RequestParam String path,@RequestParam Integer level,@RequestParam Integer autoSeries,HttpSession httpSession){
		try {
			WebSocketSession session = MyHandler.getSessionById(socketID);
			if(session==null)return Conversion.stringToJson("message,false,cause,上传服务器未连接");
			Message message = new Message(session);
			if(path==null)return Conversion.stringToJson("message,false,cause,路径不存在");
			List<MySource> sources = new ArrayList<MySource>();
			File file = new File(path);
			session.sendMessage(new TextMessage(Conversion.stringToJson("log,开始扫描路径："+file.getAbsolutePath())));
			FileRW.autoScan(file,level,sources,autoSeries,message,service);
			if(sources.size()<1){
				message.send(Conversion.stringToJson("log,扫描结束，没有扫描到文件"));
				return Conversion.stringToJson("message,false,cause,目录下没有文件或路径错误");
			}
			message.send(Conversion.stringToJson("log,扫描结束，扫描到文件："+sources.size()+"个"));
			message.send(Conversion.stringToJson("log,开始保存数据"));
			//设置文件日志
			User user = (User)httpSession.getAttribute("user");
			for(MySource ms : sources){
				SourceLog log = new SourceLog(new Date(),user.getId());
				ms.setLog(log);
			}
			int[] num = service.saveScanList(sources);
			int sum=0;
			for(int i=0;i<num.length;i++){
				String sp = sources.get(i).getSource().getPath();
				if(num[i]==1){
					sum++;
					message.send(Conversion.stringToJson("log,保存文件：["+sp.substring(sp.lastIndexOf("\\")+1)+"]成功"));
				}else{
					message.send(Conversion.stringToJson("log,保存文件：["+sp.substring(sp.lastIndexOf("\\")+1)+"]失败"));
				}
			}
			return Conversion.stringToJson("message,true,log,保存结果：["+sum+"个文件成功，"+(num.length-sum)+"个文件失败]");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,数据处理异常");
	}
	/**
	 * 缩略图与文件上传
	 * @param type
	 * @param id
	 * @param file
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","UpdateSource"})
	@RequestMapping(value="json/updateSource/{type}/{id}",method=RequestMethod.POST)
	@ResponseBody
	public String uploadPic(@PathVariable String type,@PathVariable String id,@RequestParam("file") MultipartFile file){
		if(type==null||id==null||file==null){
			return Conversion.stringToJson("message,false,cause,找不到对应的资源信息");
		}
		return service.updateSourceFile(type, id, file);
	}
	/**
	 * 缩略图与文件上传
	 * @param type
	 * @param id
	 * @param file
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping(value="json/user/updateSource/{type}/{id}",method=RequestMethod.POST)
	@ResponseBody
	public String userUploadPic(@PathVariable String type,@PathVariable String id,@RequestParam("file") MultipartFile file){
		if(type==null||id==null||file==null){
			return Conversion.stringToJson("message,false,cause,找不到对应的资源信息");
		}
		MySource source = service.findById(MySource.class, id);
		if(source==null){
			return Conversion.stringToJson("message,false,cause,找不到对应的资源信息");
		}
		if(source.getIspass()==1){
			return Conversion.stringToJson("message,false,cause,您只有更新资源的权限");
		}
		if(type.equals("pic")){
			if(source.getImg()!=null){
				return Conversion.stringToJson("message,false,cause,您只有更新资源的权限");
			}
		}
		if(type.equals("source")){
			if(source.getSource()!=null){
				return Conversion.stringToJson("message,false,cause,您只有更新资源的权限");
			}
		}
		return service.updateSourceFile(type, id, file);
	}
	/**
	 * 大图上传
	 * @param type
	 * @param id
	 * @param file
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","UpdateSource"})
	@RequestMapping(value="json/updateSpecialSource/{id}",method=RequestMethod.POST)
	@ResponseBody
	public String uploadPic(@PathVariable String id,@RequestParam("file") MultipartFile file){
		if(id==null||file==null){
			return Conversion.stringToJson("message,false,cause,找不到对应的资源信息");
		}
		return service.updateSpecialSourceFile(id, file);
	}
	/**
	 * 通过关键字搜索已有系列名
	 * @param keyword
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="json/findSeries",method=RequestMethod.POST)
	public List<Map<String,Object>> getAllSeries(@RequestParam String keyword){
		return service.findSeries(keyword);
	}
	/**
	 * 通过关键字搜索系列名和资源名称
	 * @param keyword
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="json/findSeriesAndName",method=RequestMethod.POST)
	public List<Map<String,Object>> getAllSeriesAndName(@RequestParam String keyword){
		return service.findSeriesAndName(keyword);
	}
	//获取资源分页列表
	@Jurisdiction({"BackgroundLogin"})
	@RequestMapping(value="json/list/source")  
    @ResponseBody  
	public DataResponse<MySource> list(@Valid DataRequest dataRequest,BindingResult result){
		return service.list(dataRequest, MySource.class);
	}
	//获取资源分页列表
	@Jurisdiction({"BackgroundLogin"})
	@RequestMapping(value="json/list/specialSource")  
	@ResponseBody  
	public DataResponse<SpecialSource> list2(@Valid DataRequest dataRequest,BindingResult result){
		return service.list(dataRequest, SpecialSource.class);
	}
	/**
	 * 删除资源
	 * @param id
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","DeleteSource"})
	@RequestMapping(value="json/deleteSource",method=RequestMethod.POST)
	@ResponseBody
	public String deleteSource(@RequestParam String id){
		if(id==null||id!=null&&id.trim().equals(""))return Conversion.stringToJson("message,false,cause,未获取到要删除数据");
		try{
			return service.deleteManySource(id);
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,未知原因");
	}
	/**
	 * 删除资源
	 * @param id
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","DeleteSource"})
	@RequestMapping(value="json/deleteSpecialSource",method=RequestMethod.POST)
	@ResponseBody
	public String deleteSource2(@RequestParam String id){
		if(id==null||id!=null&&id.trim().equals(""))return Conversion.stringToJson("message,false,cause,未获取到要删除数据");
		try{
			return service.deleteManySource2(id);
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,未知原因");
	}
	//获取资源分页列表
	@RequestMapping(value="json/list/headPortrait")  
	@ResponseBody  
	public DataResponse<SaveFile> headPort(@Valid DataRequest dataRequest,BindingResult result){
		dataRequest.setSearch(true);
		dataRequest.setSearchField("isSystem");
		dataRequest.setSearchOper("eq");
		dataRequest.setSearchString("1");
		return service.list(dataRequest, SaveFile.class);
	}
	//上传头像
	@RequestMapping(value="json/admin/uploadImg",method=RequestMethod.POST)  
	@ResponseBody  
	public String uploadheadPort(@RequestParam("img") MultipartFile img){
		String path = FileRW.getDir(FileRW.getPath("avatar_system"),null)+File.separator+UUID.randomUUID().toString()+".png";
		if(FileRW.saveSource(img, path)){
			SaveFile sf = new SaveFile(path);
			sf.setIsSystem(1);
			try{
				service.add(sf);
			}catch(Exception e){
				new FileOperation(path);
			}
		}
		return Conversion.stringToJson("result,true");
	}
	//用户上传头像
	@LoginSign("login")
	@RequestMapping(value="json/uploadImg",method=RequestMethod.POST)  
	@ResponseBody
	public String user_uploadheadPort(@RequestParam("img") MultipartFile img,HttpSession session){
		User user = (User)session.getAttribute("user");
		String path = FileRW.getDir(FileRW.getPath("avatar_user"),null)+File.separator+UUID.randomUUID().toString()+".png";
		if(FileRW.saveSource(img, path)){
			SaveFile sf = new SaveFile(path);
			sf.setIsSystem(0);
			try{
				SaveFile stemp = user.getAvatar();
				user.setAvatar(sf);
				service.update(user);
				if(stemp!=null&&stemp.getIsSystem()!=1) service.deleteFileThread(stemp, false);
				return Conversion.stringToJson("result,true,id,"+user.getAvatar().getId());
			}catch(Exception e){
				new FileOperation(path);
			}
		}
		return Conversion.stringToJson("result,false,cause,不知道为什么");
	}
	/**
	 * 删除头像
	 * @param img
	 * @return
	 */
	@RequestMapping(value="json/admin/deleteAvatar",method=RequestMethod.POST)  
	@ResponseBody  
	@Jurisdiction({"BackgroundLogin","DeleteSource"})
	public String deleteAvatar(@RequestParam String id){
		if(id==null||id!=null&&id.trim().equals(""))return Conversion.stringToJson("message,false,cause,未获取到要删除数据");
		try{
			return service.deleteManyImg(id);
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,未知原因");
	}
	/**
	 * 更新数据之前根据ID查询
	 * @param binder
	 */
	@ModelAttribute
	public void updateBefor(@RequestParam(value="id",required=false) String id,Map<String,Object> map){
		if(id!=null){
			MySource ms = service.findSourceById(id);
			map.put("user",ms);
		}
	}
	/**
	 * 初始化页面数据绑定,可以设置禁止字段，设置转换器等
	 * @param binder
	 */
	/*@InitBinder
	public void initBander(WebDataBinder binder){
		binder.setDisallowedFields("uploadtime","category","source");
	}*/
}
