package cn.hua.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

import cn.hua.annotation.Jurisdiction;
import cn.hua.annotation.LoginSign;
import cn.hua.bean.Permission;
import cn.hua.bean.SaveFile;
import cn.hua.bean.User;
import cn.hua.bean.UserLog;
import cn.hua.bean.WatchedAndCollect;
import cn.hua.bean.form.DataRequest;
import cn.hua.bean.form.DataResponse;
import cn.hua.bean.form.User_list;
import cn.hua.service.dao.ServiceDao;
import cn.hua.utils.CacheData;
import cn.hua.utils.Conversion;
/*@SessionAttributes(types={User.class})*/
@Controller
public class UserController {
	@Autowired
	private ServiceDao service;
	/**
	 * 登陆视图
	 * @return
	 */
	@Jurisdiction("BackgroundLogin")
	@RequestMapping(value="/admin",method=RequestMethod.GET)
	public String adminUI(HttpSession session){
		User user = (User)session.getAttribute("user");
		List<Permission> permissions = user.getRole().getPermissions();
		StringBuffer sb = new StringBuffer();
		for(Permission p : permissions){
			sb.append(p.getName()+",");
		}
		session.setAttribute("permissions", sb.toString());
		return "admin";
	}
	/**
	 * 登陆视图
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String v_loginUI(HttpSession session){
		User user = (User) session.getAttribute("user");
		if(user==null)return "redirect:index";
		return "login";
	}
	/**
	 * 注册视图
	 * @return
	 */
	@RequestMapping(value="/register",method=RequestMethod.GET)
	public String registerUI(HttpSession session){
		session.removeAttribute("user");
		return "register";
	}
	/**
	 * 用户管理视图
	 * @return
	 */
	@RequestMapping(value="/userManage",method=RequestMethod.GET)
	public String userManageUI(HttpSession session){
		return "userManage";
	}
	/**
	 * 注销登陆
	 * @return
	 */
	@RequestMapping(value="/logout",method=RequestMethod.GET)
	public String logout(Map<String,Object> request,HttpSession session){
		request.remove("user");
		session.removeAttribute("user");
		return "login";
	}
	/**
	 * 登陆处理
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.POST)
	public String login(@RequestParam(required=true) String account,@RequestParam(required=true) String password,Map<String,Object> request,HttpSession session){
		if("".equals(account)||"".equals(password)){
			request.put("error", "账号或密码不能为空");
			return "login";
		}
		User user = service.verify(account,password);
		if(user==null){
			request.put("error", "账号或密码错误");
			return "login";
		}
		session.setAttribute("user", user);
		return "redirect:index";
	}
	/**
	 * 登陆ajax处理
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="json/login",method=RequestMethod.POST)
	public String login2(@RequestParam(required=true) String account,@RequestParam(required=true) String password,HttpSession session){
		if("".equals(account)||"".equals(password)){
			return Conversion.stringToJson("message,false,cause,账号或密码不能为空");
		}
		User user = service.verify(account,password);
		if(user==null){
			return Conversion.stringToJson("message,false,cause,账号或密码错误");
		}
		session.setAttribute("user", user);
		return Conversion.stringToJson("message,true");
	}
	/**
	 * 管理登陆视图
	 * @return
	 */
	@Jurisdiction("BackgroundLogin")
	@RequestMapping(value="/login/admin",method=RequestMethod.POST)
	public String login_admin(@RequestParam(required=true) String account,@RequestParam(required=true) String password,Map<String,Object> request,HttpSession session){
		if("".equals(account)||"".equals(password)){
			request.put("admin", "admin");
			request.put("error", "账号或密码不能为空");
			return "login";
		}
		User user = service.verify(account,password);
		if(user==null){
			request.put("error", "账号或密码错误");
			request.put("admin", "admin");
			return "login";
		}
		session.setAttribute("user", user);
		return "redirect:/admin";
	}
	/**
	 * 注册成功视图
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping(value="/registerSuccess",method=RequestMethod.GET)
	public String registerSuccess(Map<String,Object> request){
		request.put("categorys", service.findAllCategoryByLi());
		request.put("avatar", service.findAvatar());
		return "registerSuccess";
	}
	/**
	 * 修改资源视图
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping(value="/updateUser",method=RequestMethod.GET)
	public String updateUser(Map<String,Object> request,HttpSession session){
		User user = (User)session.getAttribute("user");
		request.put("categorys", service.findAllCategoryByLi());
		request.put("avatar", service.findAvatar());
		request.put("updateUser", true);
		if(user.getQuestion()!=null){
			String[] quest = user.getQuestion().split(",");
			if(quest.length==2)
			request.put("question", quest);
		}
		return "registerSuccess";
	}
	/**
	 * 注册视图
	 * @return
	 */
	@RequestMapping(value="/register",method=RequestMethod.POST)
	public String register(@Valid User user,BindingResult result,Map<String,Object> request,HttpSession session){
		if(result.hasErrors()){
			return "register";
		}
		try{
			UserLog log = new UserLog();
			log.setLastLoginTime(new Date());
			user.setLog(log);
			service.addUser(spaceHandler(user));
			session.setAttribute("user", user);
		}catch(Exception e){
			e.printStackTrace();
			if(e.getMessage().contains("ConstraintViolationException")){
				request.put("error", "用户名已经被使用");
			}
			return "register";
		}
		return "redirect:/registerSuccess";
	}
	/**
	 * 更新用户
	 * @param user
	 * @param result
	 * @param request
	 * @param session
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping(value="/request/updateUser",method=RequestMethod.POST)
	public String updateUser(@Valid User user,BindingResult result,Map<String,Object> request,HttpSession session){
		User login_user = (User)session.getAttribute("user");
		if(result.hasErrors()){
			return "registerSuccess";
		}
		SaveFile dFile = null;
		if(user.getAvatar()!=null&&user.getAvatar().getId()!=null&&!user.getAvatar().getId().equals("")&&!user.getAvatar().getId().equals(login_user.getAvatar()!=null?login_user.getAvatar().getId():"")){
			dFile = login_user.getAvatar();
			user.setAvatar(service.findById(SaveFile.class, user.getAvatar().getId()));
		}else{
			user.setAvatar(login_user.getAvatar());
		}
		spaceHandler(user);//空数据处理
		BeanUtils.copyProperties(user, login_user);
		service.updateUser(login_user);
		if(dFile!=null)service.deleteFileThread(dFile, false);
		return "redirect:/index";
	}
	/**
	 * 检查用户是否已存在 
	 * @param type
	 * @param value
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="json/checkIsExist",method=RequestMethod.POST)
	public String checkIsExist(@RequestParam(required=true) String type,@RequestParam(required=true) String value){
		if(type.equals("")||type.equals(""))return Conversion.stringToJson("message,false");
		if(service.checkUserByType(type, value))
			return Conversion.stringToJson("message,true");
		else
			return Conversion.stringToJson("message,false");
	}
	//获取资源分页列表
	@Jurisdiction({"BackgroundLogin","SelectUser"})
	@RequestMapping(value="json/list/user")  
    @ResponseBody  
	public DataResponse<User_list> list(@Valid DataRequest dataRequest,BindingResult result){
		return service.userlist(dataRequest);
	}
	/**
	 * 删除用户
	 * @param id
	 * @return
	 */
	@Jurisdiction({"BackgroundLogin","DeleteUser"})
	@RequestMapping(value="json/deleteUser",method=RequestMethod.POST)
	@ResponseBody
	public String deleteUser(@RequestParam String id){
		if(id==null||id!=null&&id.trim().equals(""))return Conversion.stringToJson("message,false");
		try{
			return service.deleteManyUser(id);
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
			User user = service.findUserById(id);
			map.put("user",user);
		}
	}
	//空串问题，暂时就这样解决吧
	public User spaceHandler(User user){
		user.setEmail(user.getEmail()!=null&&user.getEmail().trim().equals("")?null:user.getEmail());
		user.setPhoneNo(user.getPhoneNo()!=null&&user.getPhoneNo().trim().equals("")?null:user.getPhoneNo());
		user.setUsername(user.getUsername()!=null&&user.getUsername().trim().equals("")?null:user.getUsername());
		user.setNickname(user.getNickname()!=null&&user.getNickname().trim().equals("")?null:user.getNickname());
		user.setName(user.getName()!=null&&user.getName().trim().equals("")?null:user.getName());
		user.setQuestion(user.getQuestion()!=null&&user.getQuestion().trim().equals("")?null:user.getQuestion());
		return user;
	}
	/**
	 * 签到
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping("json/sign")
	@ResponseBody
	public String sign(HttpSession session){
		try{
			User user = (User)session.getAttribute("user");
			user = service.findUserById(user.getId());
			if(user==null)return "login";
			UserLog log = user.getLog();
			if(!log.isSign()){
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				if(log.getLastSignDate()==null){
					log.setSignCount(1);
				}else{
					if(sdf.format(log.getLastSignDate()).equals(sdf.format(System.currentTimeMillis()-86400000)))
						log.setSignCount(log.getSignCount()+1);
					else log.setSignCount(1);
				}
				log.setLastSignDate(new Date());
				log.setExperience(log.getExperience()+(log.getSignCount()*5>25?25:log.getSignCount()*5));
				service.updateManyByFields(UserLog.class, new String[]{log.getId()}, new String[]{"experience","signCount","lastSignDate"}, new Object[]{log.getExperience(),log.getSignCount()==0?1:log.getSignCount(),log.getLastSignDate()});
				user.setLog(log);
				session.setAttribute("user", user);
				return Conversion.stringToJson("message,true");
			}else{
				return Conversion.stringToJson("message,false,cause,已经签过了");
			}
		}catch(Exception e){
			e.printStackTrace();
			return Conversion.stringToJson("message,false,cause,未知错误");
		}
		
	}
	/**
	 * 更新签到后信息
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping("json/getSign")
	@ResponseBody
	public User getSign(HttpSession session){
		return (User)session.getAttribute("user");
	}
	/**
	 * 更新签到后信息
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping("json/watchExp")
	@ResponseBody
	public String watchExp(HttpSession session){
		User user = (User)session.getAttribute("user");
		UserLog log = user.getLog();
		if(log.getWatchExpCount()<5){
			if(log.getLastWatchExpTime()!=null){
				Long lastTime = log.getLastWatchExpTime().getTime()+10*60*1000;
				if(lastTime>System.currentTimeMillis()){
					return Conversion.stringToJson("count,"+log.getWatchExpCount());
				}
			}
			try{
				log.setLastWatchExpTime(new Date());
				log.setWatchExpCount(log.getWatchExpCount()+1);
				log.setExperience(log.getExperience()+5);
				service.update(log);
				user.setLog(log);
				session.setAttribute("user", user);
				return Conversion.stringToJson("count,"+log.getWatchExpCount());
			}catch(Exception e){
				e.printStackTrace();
			}
			return Conversion.stringToJson("count,"+(log.getWatchExpCount()-1));
		}else{
			return Conversion.stringToJson("count,5");
		}
	}
	/**
	 * 获取用户看过视频记录和收藏的视频
	 * @param session
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping("json/watched_collect/collect")
	@ResponseBody
	public List<WatchedAndCollect> watched_collect(HttpSession session){
		User user = (User)session.getAttribute("user");
		return service.watched_collect(user.getId(),"collect");
	}
	/**
	 * 保存收藏
	 * @param id
	 * @param session
	 * @return
	 */
	@LoginSign("login")
	@RequestMapping("json/saveCollect/{id}")
	@ResponseBody
	public String collect(@PathVariable String id,HttpSession session){
		User user = (User) session.getAttribute("user");
		return service.collectOrWatched(id,user,"collect");
	}
	/**
	 * 保存看过，登陆保存至数据库，没登陆保存至cookie
	 * @param id
	 * @param session
	 * @return
	 */
	@RequestMapping("json/saveWatched/{id}")
	@ResponseBody
	public String watched(@PathVariable String id,@RequestParam String name,HttpServletRequest request,HttpServletResponse response,HttpSession session){
		User user = (User) session.getAttribute("user");
		if(user!=null){
			return service.collectOrWatched(id,user,"watched");
		}else{
			Map<String,String> watch_map = CacheData.getWatchedCookie(request);
			if(watch_map==null)watch_map=new HashMap<String,String>();
			if(watch_map.size()>5){
				String key = null;
				for(Entry<String,String> entry : watch_map.entrySet()){
					key = entry.getKey();break;
				}
				watch_map.remove(key);
			}
			watch_map.put(id, name);
			CacheData.addWatchedCookie(response, watch_map);
			return Conversion.stringToJson("result,true");
		}
	}
	/**
	 * 获取看过，cookie
	 * @param id
	 * @param session
	 * @return
	 */
	@RequestMapping("json/watched_collect/watched")
	@ResponseBody
	public Map<String,String> getWatched(HttpServletRequest request,HttpSession session){
		User user = (User) session.getAttribute("user");
		Map<String,String> watched = null;
		if(user!=null){
			List<WatchedAndCollect> list = service.watched_collect(user.getId(),"watched");
			if(list==null||list!=null&&list.size()<1)watched = CacheData.getWatchedCookie(request);
			else
			for(WatchedAndCollect wc : list){
				if(watched==null)watched = new LinkedHashMap<String,String>();
				watched.put(wc.getSource().getId(), wc.getSource().getId().equals(wc.getSource().getSeriesname())?
						wc.getSource().getName():(wc.getSeriesname()+wc.getSource().getName()));
			}
		}else{
			watched = CacheData.getWatchedCookie(request);
		}
		if(watched!=null)
		watched.put("length", watched.size()+"");
		return watched;
	}
}
