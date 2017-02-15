package cn.hua.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.hua.bean.Permission;
import cn.hua.bean.Role;
import cn.hua.bean.User;
import cn.hua.bean.form.DataRequest;
import cn.hua.bean.form.DataResponse;
import cn.hua.bean.form.User_list;
import cn.hua.service.dao.ServiceDao;
import cn.hua.utils.Conversion;

@Controller
public class Jurisdiction {
	@Autowired
	private ServiceDao service;
	/**
	 * 返回角色查看视图
	 * @return
	 */
	@RequestMapping(value="/role",method=RequestMethod.GET)
	@cn.hua.annotation.Jurisdiction("BackgroundLogin")
	public String roleUi(HttpSession session,Map<String,Object> request){
		User user = (User) session.getAttribute("user");
		request.put("permissions", user.getRole()!=null?user.getRole().getPermissions():null);
		return "role";
	}
	/**
	 * 返回管理员查看视图
	 * @return
	 */
	@RequestMapping(value="/manager",method=RequestMethod.GET)
	@cn.hua.annotation.Jurisdiction("BackgroundLogin")
	public String manager(Map<String,Object> request){
		DataRequest dr = new DataRequest();
		dr.setPage(1);
		dr.setRows(100);
		request.put("roles", service.list(dr, Role.class).getRows());
		return "manager";
	}
	//获取权限分页列表
	@RequestMapping(value="/json/list/permission")  
    @ResponseBody  
    @cn.hua.annotation.Jurisdiction("BackgroundLogin")
	public DataResponse<Permission> permission(@Valid DataRequest dataRequest,BindingResult result){
		return service.list(dataRequest, Permission.class);
	}
	//获取角色分页列表
	@RequestMapping(value="/json/list/role")  
	@ResponseBody  
	@cn.hua.annotation.Jurisdiction("BackgroundLogin")
	public DataResponse<Role> role(@Valid DataRequest dataRequest,BindingResult result){
		return service.list(dataRequest, Role.class);
	}
	//获取管理员分页列表
	@RequestMapping(value="/json/list/manager")  
	@ResponseBody  
	@cn.hua.annotation.Jurisdiction("BackgroundLogin")
	public DataResponse<User_list> manager(@Valid DataRequest dataRequest,BindingResult result){
		return service.getSpecialUser(dataRequest,true);
	}
	//获取管理员分页列表
	@RequestMapping(value="/json/list/getNoRoleUsers")  
	@ResponseBody
	@cn.hua.annotation.Jurisdiction("BackgroundLogin")
	public DataResponse<User_list> getNoRoleUsers(@Valid DataRequest dataRequest,BindingResult result){
		return service.getSpecialUser(dataRequest,false);
	}
	/**
	 * 添加角色
	 * @param role
	 * @param result
	 * @param session
	 * @param permissions
	 * @return
	 */
	@RequestMapping(value="/json/addRole")
	@ResponseBody
	@cn.hua.annotation.Jurisdiction({"BackgroundLogin","AddRole","UpdateRole"})
	public String addRole(@Valid Role role,BindingResult result,HttpSession session,@RequestParam Integer[] permissions){
		if("1".equals(role.getId()))return Conversion.stringToJson("message,false,cause,无权修改超级管理员");
		User user = (User) session.getAttribute("user");
		//根据当前角色与选择权限进行赋值
		List<Permission> ps = user.getRole().getPermissions();
		for(int i=0;i<permissions.length;i++){
			for(int j=0;j<ps.size();j++){
				if(ps.get(j).getId()==permissions[i]){
					role.getPermissions().add(ps.get(j));
					break;
				}
			}
		}
		try{
			role.setLevel(role.getLevel()<0?0:role.getLevel()+user.getRole().getLevel()+1);
			role.setParentLevel(user.getRole().getLevel());
			if(role.getId()!=null)
				service.updateRole(role);
			else
				service.addRole(role);
			return Conversion.stringToJson("message,true");
		}catch(Exception e){
			if(e.getMessage().contains("ConstraintViolationException")){
				 return Conversion.stringToJson("message,false,cause,角色名已经被使用");
			}
			return Conversion.stringToJson("message,false,cause,未知原因");
		}
	}
	/**
	 * 更新角色
	 * @param member
	 * @param roleId
	 * @param session
	 * @return
	 */
	@RequestMapping(value="/json/updateRoleForUser")
	@ResponseBody
	@cn.hua.annotation.Jurisdiction({"BackgroundLogin","GiveRole"})
	public String updateRoleForUser(@RequestParam String member,@RequestParam String roleId,HttpSession session){
		try{
			User user = (User) session.getAttribute("user");
			Role role = service.findRoleById(roleId);
			if(role==null)return Conversion.stringToJson("message,false,cause,没有选择的角色");
			if(role.getLevel()<=user.getRole().getLevel()){
				return Conversion.stringToJson("message,false,cause,权限不足");
			}
			String[] members = member.split(",");
			if(members.length<1)return Conversion.stringToJson("message,false,cause,没有可操作的用户");
			List<User> list = service.findManyByIds(User.class,member);
			String ids[] = new String[list.size()];int i=0;
			for(User temp : list){
				if(temp.getRole()!=null&&temp.getRole().getLevel()<=user.getRole().getLevel()){
					return Conversion.stringToJson("message,false,cause,不能操作控制级别比您高的用户");
				}
				ids[i++] = temp.getId();
			}
			int result = service.updateManyByFields(User.class, ids, new String[]{"role_id"}, new String[]{roleId});
			return Conversion.stringToJson("message,true,result,"+result);
		}catch(Exception e){
			return Conversion.stringToJson("message,false,cause,发生错误");
		}
	}
	/**
	 * 验证角色名是否存在
	 * @param name
	 * @return
	 */
	@RequestMapping(value="/json/verifyRoleName")
	@ResponseBody
	public String verifyRoleName(@RequestParam String name){
		Role role = service.findRoleByName(name);
		if(role==null){
			return Conversion.stringToJson("message,false");
		}else{
			return Conversion.stringToJson("message,true");
		}
		
	}
	/**
	 * 删除角色
	 * @param id
	 * @return
	 */
	@cn.hua.annotation.Jurisdiction({"BackgroundLogin","DeleteRole"})
	@RequestMapping(value="json/deleteRole",method=RequestMethod.POST)
	@ResponseBody
	public String deleteRole(@RequestParam String id,HttpSession session){
		User user = (User) session.getAttribute("user");
		if(id==null||id!=null&&id.trim().equals(""))return Conversion.stringToJson("message,false");
		try{
			int level = user.getRole().getLevel();
			List<Role> list = service.findManyByIds(Role.class, id);
			for(Role role : list){
				if(role.getLevel()<=level){
					return Conversion.stringToJson("message,false,cause,权限不足");
				}
			}
			return service.deleteManyRole(id);
		}catch(Exception e){
			if(e.getCause().toString().contains("ConstraintViolationException")){
				 return Conversion.stringToJson("message,false,cause,角色正在使用");
			}
		}
		return Conversion.stringToJson("message,false,cause,未知原因");
	}
	/**
	 * 撤消用户角色
	 * @param id
	 * @return
	 */
	@cn.hua.annotation.Jurisdiction({"BackgroundLogin","CancelRole"})
	@RequestMapping(value="json/cancelRoleForUser",method=RequestMethod.POST)
	@ResponseBody
	public String cancelRoleForUser(@RequestParam String id,HttpSession session){
		User user = (User) session.getAttribute("user");
		if(id==null||id!=null&&id.trim().equals(""))return Conversion.stringToJson("message,false,cause,没有要删除的管理员");
		try{
			int level = user.getRole().getLevel();
			List<User> list = service.findManyByIds(User.class, id);
			String[] ids = new String[list.size()];int i=0;
			for(User temp : list){
				if(temp.getRole()!=null&&temp.getRole().getLevel()<=level){
					return Conversion.stringToJson("message,false,cause,权限不足");
				}
				ids[i++]=temp.getId();
			}
			Integer result = service.updateManyByFields(User.class, ids, new String[]{"role_id"}, new String[]{null});
			 return Conversion.stringToJson("message,true,result,"+result);
		}catch(Exception e){
			e.printStackTrace();
			return Conversion.stringToJson("message,false,cause,未知原因");
		}
		
	}
}
