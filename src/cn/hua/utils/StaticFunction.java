package cn.hua.utils;

import java.io.IOException;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import cn.hua.bean.Permission;
import cn.hua.bean.User;
/**
 * 自定义标签，用于页面验证有无权限显示菜单
 * @author 刘华
 *
 */
public class StaticFunction extends SimpleTagSupport {
	private String var;
	public void setVar(String var) {
		this.var = var;
	}
	@Override
	public void doTag() throws JspException, IOException {
		HttpSession session = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest().getSession();
		User user = (User) session.getAttribute("user");
		if(user==null||user!=null&&user.getRole()==null||var==null)return;
		String[] value = var.split(",");
		for(String per : value){
			boolean pass = false;
			for(Permission p : user.getRole().getPermissions()){
				if(per.equals(p.getName())){
					pass = true;
					break;
				}
			}
			if(pass)continue;else return;
		}
		getJspBody().invoke(null);
	}
	
}
