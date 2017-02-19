package cn.hua.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.persistence.Table;
import javax.servlet.http.HttpSession;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import cn.hua.bean.Category;
import cn.hua.bean.MySource;
import cn.hua.bean.Permission;
import cn.hua.bean.Role;
import cn.hua.bean.SaveFile;
import cn.hua.bean.SpecialSource;
import cn.hua.bean.User;
import cn.hua.bean.WatchedAndCollect;
import cn.hua.bean.form.DataRequest;
import cn.hua.bean.form.DataResponse;
import cn.hua.bean.form.SourceResponse;
import cn.hua.bean.form.Source_front;
import cn.hua.bean.form.User_list;
import cn.hua.dao.CategoryDao;
import cn.hua.dao.GlobalDao;
import cn.hua.dao.MySourceDao;
import cn.hua.dao.PermissionDao;
import cn.hua.dao.RoleDao;
import cn.hua.dao.UserDao;
import cn.hua.service.dao.ServiceDao;
import cn.hua.utils.Conversion;
import cn.hua.utils.Encryption;
import cn.hua.utils.FileOperation;
import cn.hua.utils.FileRW;
@Transactional
@Component
public class ServiceImpl implements ServiceDao{
	@Autowired
	private CategoryDao categoryDao;
	@Autowired
	private MySourceDao mySourceDao;
	@Autowired
	private GlobalDao globalDao;
	@Autowired
	private UserDao userDao;
	@Autowired
	private RoleDao roleDao;
	@Autowired
	private PermissionDao permissionDao;
	@Override
	public void addCategory(Category category) {
		globalDao.add(category);
	}
	@Override
	public void deleteCategory(Category category) {
		globalDao.delete(category);
	}
	@Override
	public void updateCategory(Category category) {
		globalDao.update(category);
	}
	@Override
	public Category findCategoryById(String id) {
		return globalDao.find(Category.class,id);
	}
	@Override
	public List<Category> getAllCategory() {
		return categoryDao.findAllCategory();
	}
	@Override
	public boolean categoryIsReName(String name,Category parent) {
		return categoryDao.isReName(name,parent);
	}
	@Override
	public void addSource(MySource source) {
		mySourceDao.add(source);
	}
	@Override
	public void deleteSource(MySource source) {
		mySourceDao.delete(source);
	}
	@Override
	public void updateSource(MySource source){
		mySourceDao.update(source);
	}
	@Override
	public String updateSourceFile(String type,String id,MultipartFile file) {
		MySource source = findSourceById(id);
		if(source==null){
			return Conversion.stringToJson("message,false,cause,找不到对应的资源信息");
		}
		//获取文件md5
		String md5 = null;
		try {
			md5 = FileRW.fileMD5(file.getInputStream());
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if(md5==null){
			return Conversion.stringToJson("message,false,cause,解析文件出错");
		}
		SaveFile saveFile = mySourceDao.verifyMd5(md5);
		SaveFile srcFile = null;
		if(saveFile!=null){
			if("pic".equals(type)){
				srcFile = source.getImg();
				source.setImg(saveFile);
			}else{
				srcFile = source.getSource();
				source.setSource(saveFile);
			}
			try{
				mySourceDao.update(source);
				deleteFileThread(srcFile,true,source.getId());
				return Conversion.stringToJson("message,true");
			}catch(Exception e){
				return Conversion.stringToJson("message,false,cause,保存文件失败,请重试");
			}
		}else{
			String path = null;
			path = FileRW.getSavePath(type, file);
			if("pic".equals(type)){
				if(!FileRW.checkImgSuffix(file.getOriginalFilename())){
					if(path!=null&&!path.equals(""))
						new FileOperation(path).start();
					return Conversion.stringToJson("message,false,cause,缩略图格式不支持");
				}
				srcFile = source.getImg();
				saveFile = new SaveFile(path);
				saveFile.setMd5(md5);
				source.setImg(saveFile);
			}else{
				if(!FileRW.checkSourceSuffix(file.getOriginalFilename())){
					if(path!=null&&!path.equals(""))
						new FileOperation(path).start();
					return Conversion.stringToJson("message,false,cause,资源格式不支持");
				}
				srcFile = source.getSource();
				saveFile = new SaveFile(path);
				saveFile.setMd5(md5);
				source.setSource(saveFile);
			}
			try{
				mySourceDao.update(source);
				FileRW.saveSource(file, path);
				//更新成功之后删除以前文件;
				deleteFileThread(srcFile,true,source.getId());
				return Conversion.stringToJson("message,true");
			}catch(Exception e){
				e.printStackTrace();
				if(path!=null&&!path.equals(""))
					new FileOperation(path).start();
			}
		}
		return Conversion.stringToJson("message,false,cause,保存文件失败,请重试");
	}
	@Override
	public MySource findSourceById(String id) {
		return mySourceDao.find(id);
	}
	/**
	 * 通过关键字查询系列
	 */
	@Override
	public List<Map<String,Object>> findSeries(String keyword) {
		List<Map<String,Object>> listMap = new ArrayList<Map<String,Object>>();
		List<Object> list = mySourceDao.findSeries(keyword,7);
		for(int i=0;i<list.size()&&i<7;i++){
			Map<String,Object> map = new HashMap<String,Object>();
			Object[] arr = (Object[]) list.get(i);
			map.put("id", arr[0]);
			map.put("seriesname", arr[1]);
			map.put("decription", arr[2]);
			List<Object> catelist = mySourceDao.findCategoryBySourceId(arr[0].toString());
			StringBuffer sb = new StringBuffer();
			for(int j=0;catelist!=null&&j<catelist.size();j++){
				sb.append(catelist.get(j).toString()+(j==catelist.size()-1?"":","));
			}
			map.put("category", sb.toString());
			listMap.add(map);
		}
		return listMap;
	}
	/**
	 * 通过关键字查询系列和资源名称
	 */
	@Override
	public List<Map<String,Object>> findSeriesAndName(String keyword) {
		List<Map<String,Object>> listMap = new ArrayList<Map<String,Object>>();
		List<Object> list = mySourceDao.findSeriesAndName(keyword,7);
		for(int i=0;i<list.size()&&i<7;i++){
			Map<String,Object> map = new HashMap<String,Object>();
			Object[] arr = (Object[]) list.get(i);
			map.put("id", arr[0]);
			map.put("name", arr[1]);
			map.put("seriesname", arr[2]);
			listMap.add(map);
		}
		return listMap;
	}
	/**
	 * 自动扫描资源
	 */
	@Override
	public int[] saveScanList(List<MySource> list) {
		return mySourceDao.saveScanList(list);
	}
	/**
	 * 路径是否存在
	 */
	@Override
	public boolean pathIsExist(String path) {
		return mySourceDao.pathIsExist(path);
	}
	/**
	 * 删除多行记录
	 */
	@Override
	public <T> int deleteManyByIds(Class<T> cls, String ids) {
		String[] arr = null;
		if(ids!=null){
			arr = ids.split(",");
		}
		return globalDao.deleteManyByIds(cls, arr);
	}
	//删除多个资源
	@Override
	public String deleteManySource(String ids) {
		List<MySource> list = findManyByIds(MySource.class, ids);
		String[] arr=null;
		if(ids!=null)arr = ids.split(",");
		if(list==null||list!=null&&list.size()<1)return Conversion.stringToJson("message,false");
		int num = globalDao.deleteManyByIds(MySource.class, arr);
		for(int i=0;i<list.size()&&list.size()==num;i++){
			MySource source = list.get(i);
			if(source.getImg()!=null&&source.getImg().getPath()!=null)
				deleteFileThread(source.getImg(),true);
			if(source.getSource()!=null&&source.getSource().getPath()!=null)
				deleteFileThread(source.getSource(),true);
		}
		return Conversion.stringToJson("message,true,num,"+num);
	}
	//删除多个头像
	@Override
	public String deleteManyImg(String ids) {
		List<SaveFile> list = findManyByIds(SaveFile.class, ids);
		String[] arr=null;
		if(ids!=null)arr = ids.split(",");
		if(list==null||list!=null&&list.size()<1)return Conversion.stringToJson("message,false");
		int num = globalDao.deleteManyByIds(SaveFile.class, arr);
		for(int i=0;i<list.size()&&list.size()==num;i++){
			deleteFileThread(list.get(i),true);
		}
		return Conversion.stringToJson("message,true,num,"+num);
	}
	/**
	 * 获取资源数据列表
	 */
	@Override
	public <T> DataResponse<T> list(DataRequest request, Class<T> cls,String ... option) {
		DataResponse<T> response = new DataResponse<T>();  
        int count;//总记录数  
        int size = request.getRows() <= 0 ? 20 : request.getRows();//每页显示数量  
        int totalPages;//总页数  
        int page = request.getPage() <= 0 ? 1 : request.getPage();//当前显示页码  
        List<T> list;
        String criteria = initSearchCondition(request);
        count = globalDao.count(cls,criteria);  
        totalPages = count / size;  
        if (count % size != 0) {  
            totalPages++;  
        }  
        int currPage = Math.min(totalPages, page);  
        int start = currPage * size - size;  
        start = start < 0 ? 0 : start;  
        if(option!=null&&option.length>0)
        	list = globalDao.list(cls, criteria+sortCriteria(request.getSidx(), request.getSord()), start, size,option[0]);
        else
        	list = globalDao.list(cls, criteria+sortCriteria(request.getSidx(), request.getSord()), start, size);
        response.setRecords(count);  
        response.setTotal(totalPages);  
        response.setPage(currPage);  
        response.setRows(list);  
        return response;  
	}
	//获取搜索条件
	private String initSearchCondition(DataRequest request) {
		StringBuffer sb = new StringBuffer(" where(");
		if(request.isSearch()){
			//如果搜索的字段不一致则不搜索
			if(request.getSearchField()==null||request.getSearchOper()==null||request.getSearchString()==null)return "";
			if(request.getSearchField().length!=request.getSearchOper().length&&request.getSearchField().length!=request.getSearchString().length)return "";
			//循环进行条件语句拼接
			for(int i=0;i<request.getSearchField().length;i++){
				String searchString = request.getSearchString()[i];
				String searchOper = request.getSearchOper()[i];
				String searchField = request.getSearchField()[i];
				//这里目前只兼容like搜索的或条件
				if(i!=0&&i<request.getSearchField().length)sb.append(" or ");
				sb.append(searchField);
				//这里加入管理员条件
				if("eq".equals(searchOper)){
					sb.append(" = '" +searchString+"'");
				}else if("ne".equals(searchOper)){
					sb.append(" != '" +searchString+"'");
				}else if("lt".equals(searchOper)){
					sb.append(" < '" +searchString+"'");
				}else if("le".equals(searchOper)){
					sb.append(" <= '" +searchString+"'");
				}else if("gt".equals(searchOper)){
					sb.append(" > '" +searchString+"'");
				}else if("ge".equals(searchOper)){
					sb.append(" >= '" +searchString+"'");
				}else if("nu".equals(searchOper)||"nc".equals(searchOper)||"ni".equals(searchString)){
					sb.append(" not like '%" +searchString+"%'");
				}else if("nn".equals(searchOper)||"cn".equals(searchOper)||"in".equals(searchOper)){
					sb.append(" like '%" +searchString+"%'");
				}else if("bw".equals(searchOper)){
					sb.append(" like '" +searchString+"%'");
				}else if("bn".equals(searchOper)){
					sb.append("not like '" +searchString+"%'");
				}else if("ew".equals(searchOper)){
					sb.append("like '%" +searchString+"'");
				}else if("en".equals(searchOper)){
					sb.append("not like '%" +searchString+"'");
				}
			}
			sb.append(")");
			return sb.toString();
		}
		return "";
	}
	//获取排序条件
	private String sortCriteria(String sidx,String sord){
		if(sidx!=null&&!sidx.trim().equals("")){
			return " order by "+sidx+" "+sord;
		}
		return "";
	}
	@Override
	public <T> List<T> findManyByIds(Class<T> cls, String ids) {
		String[] arr = null;
		if(ids!=null){
			arr = ids.split(",");
		}
		return globalDao.findManyByIds(cls, arr);
	}
	@Override
	public List<MySource> findSourceByOffline() {
		return mySourceDao.findSourceByOffline();
	}
	@Override
	public List<MySource> findSourceByOnline() {
		return mySourceDao.findSourceByOnline();
	}
	@Override
	public int updateManySource(List<String> passed,int ispass) {
		return mySourceDao.updateMany(passed,ispass);
	}
	@Override
	public <T> int updateMany(List<T> passed) {
		return globalDao.updateMany(passed);
	}
	@Override
	public boolean findSourceByPath(String path) {
		int num = mySourceDao.findSourceByPath(path);
		if(num>0)return true;
		else return false;
	}
	@Override
	public void addUser(User user) {
		user.setPassword(Encryption.encryption(user.getPassword()));
		globalDao.add(user);
		
	}
	@Override
	public void deleteUser(User user) {
		globalDao.delete(user);
		
	}
	@Override
	public void updateUser(User user) {
		globalDao.update(user);
	}
	@Override
	public User findUserById(String id) {
		return globalDao.find(User.class, id);
	}
	@Override
	public List<Category> findAllCategoryByLi() {
		return categoryDao.findAllCategoryByLi();
	}
	@Override
	public boolean checkUserByType(String type, String value) {
		if(userDao.checkUserByType(type, value)>0)
			return true;
		else
			return false;
	}
	@Override
	public User verify(String account, String password) {
		return userDao.verify(account,Encryption.encryption(password));
	}
	@Override
	public String deleteManyUser(String ids) {
		List<User> list = findManyByIds(User.class, ids);
		String[] arr=null;
		if(ids!=null)arr = ids.split(",");
		if(list==null||list!=null&&list.size()<1)return Conversion.stringToJson("message,false");
		int num = globalDao.deleteManyByIds(User.class, arr);
		return Conversion.stringToJson("message,true,num,"+num);
	}
	/**
	 * 权限
	 */

	@Override
	public Map<Integer, String> getPermissions(Role role) {
		role =  roleDao.getPermissions(role);
		Map<Integer,String> map = new HashMap<Integer,String>();
		if(role!=null){
			Iterator<Permission> iterator = role.getPermissions().iterator();
			while(iterator.hasNext()){
				Permission p = iterator.next();
				map.put(p.getId(), p.getName());
			}
		}
		return map;
	}
	@Override
	public List<Role> getAllRoles() {
		return roleDao.getAllRoles();
	}
	@Override
	public void deleteRole(Role role) {
		globalDao.delete(role);
		
	}
	@Override
	public Role findRoleByName(String name) {
		return roleDao.findByName(name);
	}
	@Override
	public List<Permission> getPermissions() {
		return permissionDao.getPermissions();
	}
	@Override
	public Role findRoleById(String id) {
		return globalDao.find(Role.class, id);
	}
	@Override
	public void addRole(Role role) {
		globalDao.add(role);
	}
	@Override
	public Permission findPermissionByName(String name) {
		return permissionDao.findByName(name);
	}
	@Override
	public Permission findPermissionById(int id) {
		return permissionDao.findById(id);
	}
	@Override
	public void updateRole(Role role) {
		globalDao.update(role);
	}
	@Override
	public String deleteManyRole(String ids) {
		String[] arr=null;
		if(ids!=null)arr = ids.split(",");
		int num = globalDao.deleteManyByIds(Role.class, arr);
		return Conversion.stringToJson("message,true,num,"+num);
	}
	@Override
	public DataResponse<User_list> getSpecialUser(DataRequest request,boolean isManager) {
		DataResponse<User_list> response = new DataResponse<User_list>();  
        int count;//总记录数  
        int size = request.getRows() <= 0 ? 20 : request.getRows();//每页显示数量  
        int totalPages;//总页数  
        int page = request.getPage() <= 0 ? 1 : request.getPage();//当前显示页码  
        List<User> list;
        String criteria = initSearchCondition(request);
        String countCriteria = criteria.equals("")?" where role_id"+(isManager?" is not ":" is ")+"null":criteria+" and role_id"+(isManager?" is not ":" is ")+"null";
        criteria = criteria.equals("")?" where role"+(isManager?"!=":"=")+"null":criteria+" and role"+(isManager?"!=":"=")+"null";
        count = globalDao.count(User.class,countCriteria);  
        totalPages = count / size;  
        if (count % size != 0) {  
            totalPages++;  
        }  
        int currPage = Math.min(totalPages, page);  
        int start = currPage * size - size;  
        start = start < 0 ? 0 : start;  
        
        list = globalDao.list(User.class, criteria+sortCriteria(request.getSidx(), request.getSord()), start, size); 
        List<User_list> user_list = new ArrayList<User_list>();
        for(User u : list){
        	User_list ul = new User_list();
        	BeanUtils.copyProperties(u, ul);
        	if(u.getLog()!=null){
        		ul.setLastLoginTime(u.getLog().getLastLoginTime());
        		ul.setVipLevel(((Long)u.getLog().getMyLevel()[0]).intValue());
        	}
        	user_list.add(ul);
        }
        response.setRecords(count);  
        response.setTotal(totalPages);  
        response.setPage(currPage);  
        response.setRows(user_list);  
        return response;  
	}
	@Override
	public <T> Integer updateManyByFields(Class<T> cls,String[] ids,String[] name, Object[] value) {
		StringBuffer criteria = new StringBuffer();
		for(int i=0;i<name.length;i++){
			criteria.append(name[i]+"=?"+(i!=name.length-1?",":""));
		}
		return globalDao.updateManyByFields(cls, criteria.toString(), ids,value);
	}
	@Override
	public <T> void update(T obj) {
		globalDao.update(obj);
	}
	/**
	 * 获取用户列表后进行对象转存
	 */
	public DataResponse<User_list> userlist(DataRequest dataRequest){
		 DataResponse<User> du = list(dataRequest, User.class);
		 DataResponse<User_list> dul = new DataResponse<User_list>();
		 dul.setPage(du.getPage());
		 dul.setRecords(du.getRecords());
		 dul.setTotal(du.getTotal());
		 dul.setUserdata(du.getUserdata());
		 List<User_list> user_list = new ArrayList<User_list>();
		 for(User u : du.getRows()){
			 User_list ul = new User_list();
			 BeanUtils.copyProperties(u, ul);
			 if(u.getLog()!=null){
	        		ul.setLastLoginTime(u.getLog().getLastLoginTime());
	        		ul.setVipLevel(((Long)u.getLog().getMyLevel()[0]).intValue());
	        	}
	        	user_list.add(ul);
		 }
		 dul.setRows(user_list);
		 return dul;
	}
	/**
	 *观看记录与收藏记录
	 */
	public List<WatchedAndCollect> watched_collect(String id,String type){
		return globalDao.list(WatchedAndCollect.class, "where userid='"+id+"' and type='"+type+"' order by time desc", 0, 5);
	}
	/**
	 * 主页推荐查询
	 */
	public List<Source_front> getFrontSource(String type,int size,String ... option){
		String sql="";
		if(option!=null&&option.length>0)sql = "select new MySource("+option[0]+") ";
		if("new".equals(type)){
			sql="from MySource where ispass=1 group by seriesname order by log.uploadtime desc,log.total_play desc";
		}else{
			Category cate = categoryDao.getCategoryByName(type);
			if(cate==null)sql="from MySource where ispass=1 order by log.uploadtime desc,log.total_play desc";
			else
			sql="from MySource where ispass=1 and kind like '%"+cate.getId()+"%' group by seriesname order by log.total_play desc";
			//sql="from MySource where ispass=1 and kind like '%"+cate.getId()+",%' and((seriesname!=null  group by seriesname) or seriesname==null) order by log.total_play desc";
		}
		List<MySource> list = mySourceDao.list(sql, 1,size);
		if(list==null||list!=null&&list.size()<1)return null;
		List<Source_front> sfList = new ArrayList<Source_front>();
        for(MySource ms : list){
        	Source_front sf = new Source_front();
        	BeanUtils.copyProperties(ms, sf);
        	sfList.add(sf);
        }
        return sfList; 
	}
	/**
	 * 查询文件是否被占用
	 * @param idi 
	 * @return true  占用
	 * @return false  不占用
	 */
	public boolean selectFileIsUse(String id,String type, String ... sourceId){
		int i=0;
		if("avatar".equals(type)){
			i = globalDao.count(User.class, " where avatar_id='"+id+"'");
		}else
			i = globalDao.count(MySource.class, " where (img_id='"+id+"' or source_id='"+id+"')"+(sourceId.length>0?" and id!='"+sourceId[0]+"'":""));
		if(i>0)return true;
		else return false;
	}
	/**
	 * 删除文件线程分配
	 * @param saveFile
	 * @param isSelect	是否需要向数据库查询文件被占用
	 * @param id
	 */
	public void deleteFileThread(SaveFile saveFile,boolean isSelect,String ... id){
		if(saveFile!=null&&saveFile.getId()!=null){
			if(saveFile.getIsSystem()==1){//判断为系统头像
				if(!selectFileIsUse(saveFile.getId(),"avatar")){
					new FileOperation(saveFile.getPath()).start();
				}
			}else{
				if(isSelect&&selectFileIsUse(saveFile.getId(),"source",id)){
					return;
				}else{
					deleteManyByIds(SaveFile.class, saveFile.getId());
					new FileOperation(saveFile.getPath()).start();
					new FileOperation(saveFile.getCvpath()).start();
				}
			}
		}
	}
	public void deleteRubbishFile(){
		int i = 0;
		try{
			i = mySourceDao.deleteRubbishFile();
			System.out.println("liuhua:rubbish record deleted,handler record "+i);
		}catch(Exception e){
			System.out.println("liuhua:rubbish record delete error");
		}
	}
	public <T> T findById(Class<T> clazz,String id){
		return globalDao.find(clazz, id);
	}
	@Override
	public List<MySource> findSourceBySeries(String seriesname, String id,String ... option) {
		return mySourceDao.findSourceBySeries(seriesname,id,option);
	}
	public <T> void add(T t){
		globalDao.add(t);
	}
	@Override
	public SaveFile verifyMd5(String md5) {
		return mySourceDao.verifyMd5(md5);
	}
	@Override
	public String updateSpecialSourceFile(String id, MultipartFile file) {
		SpecialSource source = findById(SpecialSource.class, id);
		if(source==null){
			return Conversion.stringToJson("message,false,cause,找不到对应的资源信息");
		}
		//获取文件md5
		String md5 = null;
		try {
			md5 = FileRW.fileMD5(file.getInputStream());
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if(md5==null){
			return Conversion.stringToJson("message,false,cause,解析文件出错");
		}
		SaveFile saveFile = verifyMd5(md5);
		SaveFile srcFile = null;
		if(saveFile!=null){
				srcFile = source.getImg();
				source.setImg(saveFile);
			try{
				update(source);
				deleteFileThread(srcFile,true,source.getId());
				return Conversion.stringToJson("message,true");
			}catch(Exception e){
				return Conversion.stringToJson("message,false,cause,保存文件失败,请重试");
			}
		}else{
			String path = null;
			path = FileRW.getSavePath("pic", file);
			if(!FileRW.checkImgSuffix(file.getOriginalFilename())){
				if(path!=null&&!path.equals(""))
					new FileOperation(path).start();
				return Conversion.stringToJson("message,false,cause,图像格式不支持");
			}
			srcFile = source.getImg();
			saveFile = new SaveFile(path);
			saveFile.setMd5(md5);
			source.setImg(saveFile);
			try{
				update(source);
				FileRW.saveSource(file, path);
				//更新成功之后删除以前文件;
				deleteFileThread(srcFile,true,source.getId());
				return Conversion.stringToJson("message,true");
			}catch(Exception e){
				e.printStackTrace();
				if(path!=null&&!path.equals(""))
					new FileOperation(path).start();
			}
		}
		return Conversion.stringToJson("message,false,cause,保存文件失败,请重试");
	}
	@Override
	public <T> int count(Class<T> cls, String crit) {
		return globalDao.count(cls, crit);
	}
	@Override
	public String deleteManySource2(String ids) {
		List<SpecialSource> list = findManyByIds(SpecialSource.class, ids);
		String[] arr=null;
		if(ids!=null)arr = ids.split(",");
		if(list==null||list!=null&&list.size()<1)return Conversion.stringToJson("message,false");
		int num = globalDao.deleteManyByIds(SpecialSource.class, arr);
		for(int i=0;i<list.size()&&list.size()==num;i++){
			SpecialSource source = list.get(i);
			if(source.getImg()!=null&&source.getImg().getPath()!=null)
				deleteFileThread(source.getImg(),true);
		}
		return Conversion.stringToJson("message,true,num,"+num);
	}
	@Override
	public String collectOrWatched(String id,User user,String type) {
		try{
			user = globalDao.find(User.class,user.getId());
			MySource source = globalDao.find(MySource.class,id);
			if(source==null){
				return Conversion.stringToJson("result,false,cause,资源信息不存在");
			}
			WatchedAndCollect wc = null;
			if(!source.getId().equals(source.getSeriesname())&&"collect".equals(type))
				wc = globalDao.get(WatchedAndCollect.class, "from WatchedAndCollect where userid=? and seriesname=? and type=?",user.getId(),source.getSeriesname(),type);
			else
				wc = globalDao.get(WatchedAndCollect.class, "from WatchedAndCollect where userid=? and source_id=? and type=?",user.getId(),source.getSource().getId(),type);
			if(wc==null){
				List<WatchedAndCollect> list = globalDao.list(WatchedAndCollect.class, "where userid='"+user.getId()+"' and type='"+type+"'", 0, 11);
				if(list.size()>=10){
					WatchedAndCollect temp = list.get(list.size()-1);
					globalDao.delete(temp);
					//globalDao.deleteManyByIds(WatchedAndCollect.class, new Integer[]{temp.getId()});
				}
				wc = new WatchedAndCollect(user.getId(), source, type, source.getId().equals(source.getSeriesname())?source.getId():source.getSeriesname(), new Date());
				add(wc);
			}else{
				if(!source.getId().equals(wc.getSource().getId())){
					wc.setSource(source);
					wc.setTime(new Date());
					update(wc);
				}
			}
			return Conversion.stringToJson("result,true");
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("result,false,cause,未知原因");
	}
	@Override
	public List<Source_front> findHobbySourceById(String[] cates) {
		StringBuffer sb = new StringBuffer();
		for(int i=0;cates!=null&&i<cates.length;i++){
			if(i==cates.length-1) sb.append(" kind like '%"+cates[i]+"%'");
			else sb.append(" kind like '%"+cates[i]+"%' or ");
		}
		List<MySource> list = globalDao.list(MySource.class, "where ispass=1 and ("+sb.toString()+")", 0, 4);
		List<Source_front> sf_list = new ArrayList<Source_front>(); 
		for(MySource my : list){
			Source_front sf = new Source_front();
			BeanUtils.copyProperties(my, sf);
			sf_list.add(sf);
		}
		return sf_list;
	}
	@Override
	public String[] findAvatar() {
		DataRequest request = new DataRequest();
		request.setPage(1);request.setRows(20);
		request.setSearch(true);request.setSearchField("isSystem");request.setSearchOper("eq");request.setSearchString("1");
		List<SaveFile> list = list(request, SaveFile.class).getRows();
		String[] arr = new String[list.size()];
		for(int i=0;list!=null&&i<list.size();i++){
			arr[i] = list.get(i).getId();
		}
		return arr;
	}
	public <T> Object[] findForFieldById(Class<T> cls,String id,String ... field){
		Table table = cls.getAnnotation(Table.class);
		String fields="";
		for(int i=0;field!=null&&i<field.length;i++){
			if(i==field.length-1)fields+=field[i];
			else fields+=field[i]+",";
		}
		String sql = "select "+(fields.equals("")?"*":fields)+" from "+ table.name()+" where id=?";
		return (Object[]) globalDao.findIdByField(sql, id);
	}
	public SourceResponse source_list(DataRequest dataRequest){
		SourceResponse dataResponse = new SourceResponse();
		int count;//总记录数  
        int size = dataRequest.getRows() <= 0 ? 20 : dataRequest.getRows();//每页显示数量  
        int totalPages;//总页数  
        int page = dataRequest.getPage() <= 0 ? 1 : dataRequest.getPage();//当前显示页码  
        String keyword = dataRequest.getSpecialSearch();
        String key_string="";
        if(keyword!=null){
        	key_string = " and (name like '%"+keyword+"%' or seriesname like '%"+keyword+"%') ";
        	
        }
        String sql="from MySource where ispass=1 and "
				+ " kind like '%"+(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>0?dataRequest.getSearchString()[0]:"")+"%' and kind like '%"+(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>1?dataRequest.getSearchString()[1]:"")+"%' "+key_string
						+ " group by seriesname order by "+(dataRequest.getSidx()!=null?dataRequest.getSidx():"log.uploadtime")+" desc";
		String countsql="select c.c+b.c from (select count(*) c from (select count(*) from mysource where id!=seriesname and ispass=1 and  kind like '%"+(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>0?dataRequest.getSearchString()[0]:"")+"%' and kind like '%"+(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>1?dataRequest.getSearchString()[1]:"")+"%'"+key_string
						+ " GROUP BY seriesname) a) b,(select count(*) c from mysource where id=seriesname and ispass=1 and  kind like '%"+(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>0?dataRequest.getSearchString()[0]:"")+"%' and kind like '%"+(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>1?dataRequest.getSearchString()[1]:"")+"%'"+key_string
						+ ") c";
		count = mySourceDao.count(countsql);
		totalPages = count / size;  
	        if (count % size != 0) {  
	            totalPages++;  
	        }  
        int currPage = Math.min(totalPages, page);  
        int start = currPage * size - size;  
        start = start < 0 ? 0 : start;  
        dataResponse.setPage(currPage);
        dataResponse.setRecords(count);
		dataResponse.setTotal(totalPages);
		dataResponse.setParent_cate(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>0&&!dataRequest.getSearchString()[0].equals("")?dataRequest.getSearchString()[0]:null);
		dataResponse.setCate(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>1&&!dataRequest.getSearchString()[1].equals("")?dataRequest.getSearchString()[1]:null);
		dataResponse.setSidx(dataRequest.getSidx()!=null?dataRequest.getSidx():"log.uploadtime");
		dataResponse.setSpecialSearch(dataRequest.getSpecialSearch()!=null?dataRequest.getSpecialSearch():"");
		if(count<1){
			return dataResponse;
		}
		dataResponse.setRows(mySourceDao.list(sql, start, size));
		return dataResponse;
	}
}

