package cn.hua.aop;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import cn.hua.annotation.Jurisdiction;
import cn.hua.annotation.LoginSign;
import cn.hua.bean.Permission;
import cn.hua.bean.User;
import cn.hua.bean.UserLog;
import cn.hua.service.dao.ServiceDao;
import cn.hua.utils.Conversion;

public class Logging {
	@Autowired
	private ServiceDao service;
	public Object jurisdiction(ProceedingJoinPoint point){
		try {
			String methodName = point.getSignature().getName();
			Jurisdiction jurisdiction = ((MethodSignature)point.getSignature()).getMethod().getAnnotation(Jurisdiction.class);
			HttpSession session = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest().getSession();
			User user = (User) session.getAttribute("user");
			if(jurisdiction==null){
				LoginSign loginSign = ((MethodSignature)point.getSignature()).getMethod().getAnnotation(LoginSign.class);
				if(loginSign!=null&&user==null){
					return resultHandler("login");
				}
				return point.proceed();
			}
			if("login_admin".equals(methodName))return point.proceed();//对后台登陆进行特殊的处理
			if(user==null||user!=null&&user.getRole()==null){
				((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest().setAttribute("admin", "/admin");
				return "/login";
			}
			List<Permission> permissions = user.getRole().getPermissions();
			for(String value : jurisdiction.value()){
				boolean isContain=false;
				for(Permission temp : permissions){
					if(temp.getName().equals(value)){
						isContain=true;break;
					}
				}
				if(isContain)continue;
				else{
					return resultHandler(value);
				}
			}
			return point.proceed();
		} catch (Throwable e) {  
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	//登陆处理
	public Object loginHandle(ProceedingJoinPoint point) throws Throwable{	//当登陆时单独进行处理
		Object obj = point.proceed();
		if(obj!=null&&obj.toString().startsWith("redirect:")){
			Jurisdiction jurisdiction = ((MethodSignature)point.getSignature()).getMethod().getAnnotation(Jurisdiction.class);
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			HttpSession session = request.getSession();
			User user = (User) session.getAttribute("user");
			String methodName = point.getSignature().getName();
			if("login_admin".equals(methodName)){
				if(user==null||user!=null&&user.getRole()==null){
					request.setAttribute("error", "权限不足,无法登陆");
					session.removeAttribute("user");return "/login";
				}else{
					for(String value : jurisdiction.value()){
						boolean isContain=false;
						for(Permission temp : user.getRole().getPermissions()){
							if(temp.getName().equals(value)){
								isContain=true;break;
							}
						}
						if(isContain)continue;
						else{
							request.setAttribute("error", "权限不足,无法登陆");
							session.removeAttribute("user");return "/login";
						}
					}
				}
			}
			UserLog log = user.getLog();
			if(log==null){
				log = new UserLog();
				log.setLastLoginTime(new Date());
				user.setLog(log);
				service.update(user);
			}else{
				log.setLastLoginTime(new Date());
				service.update(log);
			}
			return obj.toString();
		}else
		return obj;
	}
	/**
	 * 根据权限做不同跳转
	 * @param value
	 * @return
	 */
	private Object resultHandler(String value){
		if("BackgroundLogin".equals(value)){
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			request.setAttribute("admin", "/admin");
			return "redirect:/login";
		}else if(value.startsWith("Select"))
			return "redirect:/home";
		else if("login".equals(value))
			return "redirect:/login";
		else 
			return Conversion.stringToJson("message,false,cause,权限不足");
	}
}
