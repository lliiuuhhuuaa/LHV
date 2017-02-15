package cn.hua.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.hua.annotation.Jurisdiction;
import cn.hua.bean.Category;
import cn.hua.service.dao.ServiceDao;
import cn.hua.utils.Conversion;
@Controller
public class CategoryController {
	@Autowired
	private ServiceDao service;
	@Jurisdiction("BackgroundLogin")
	@RequestMapping(value="/allCategory")
	public String view(Map<String,Object> request){
		request.put("categorys",  service.getAllCategory());
		return "category";
	}
	@Jurisdiction({"BackgroundLogin","AddCategory"})
	@RequestMapping(value="/category/{pid}",method=RequestMethod.POST,produces="text/html;charset=UTF-8")
	@ResponseBody
	public String add(@PathVariable String pid,@RequestParam("name") String name){
		if(name==null){
			return Conversion.stringToJson("message,false,cause,无法获取分类名称");
		}
		Category parent = service.findCategoryById(pid);
		if(!"0".equals(pid)&&parent==null){
			return Conversion.stringToJson("message,false,cause,父级不存在");
		}
		if(service.categoryIsReName(name,parent)){
			return Conversion.stringToJson("message,false,cause,分类名称已存在");
		}
		Category category = new Category(new Long(System.currentTimeMillis()).toString(),name,parent);
		try{
			service.addCategory(category);
			return Conversion.stringToJson("message,true,id,"+category.getId());
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,数据库正忙...");
	}
	@Jurisdiction({"BackgroundLogin","DeleteCategory"})
	@RequestMapping(value="/category/{id}",method=RequestMethod.DELETE,produces="text/html;charset=UTF-8")
	@ResponseBody
	public String delete(@PathVariable String id){
		if(id==null||id!=null&&"".equals(id.trim())){
			return Conversion.stringToJson("message,false,cause,无法获取分类信息");
		}
		try{
			Category category = service.findCategoryById(id);
			if(category==null){
				return Conversion.stringToJson("message,false,cause,没有当前分类信息");
			}
			service.deleteCategory(category);
			return Conversion.stringToJson("message,true");
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,数据库正忙...");
	}
	@Jurisdiction({"BackgroundLogin","UpdateCategory"})
	@RequestMapping(value="/category/{id}",method=RequestMethod.PUT,produces="text/html;charset=UTF-8")
	@ResponseBody
	public String update(@PathVariable String id,@RequestParam String name){
		if(id==null||id!=null&&id.trim().equals("")){
			return Conversion.stringToJson("message,false,cause,无法获取分类信息");
		}
		Category category = service.findCategoryById(id);
		if(category==null){
			return Conversion.stringToJson("message,false,cause,没有当前分类信息");
		}
		category.setName(name);
		try{
			service.updateCategory(category);
			return Conversion.stringToJson("message,true");
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("message,false,cause,数据库正忙...");
	}
	/**
	 * 获取分类的json格式数据
	 * @return
	 */
	@RequestMapping(value="json/category",method=RequestMethod.POST)
	@ResponseBody
	public List<Category> categoryJson(HttpSession session){
		ServletContext servletContext = session.getServletContext();
		//分类
		List<Category> categorys = (List<Category>) servletContext.getAttribute("category");
		if(categorys==null)
			categorys = service.getAllCategory();
		return categorys;
	}
}
