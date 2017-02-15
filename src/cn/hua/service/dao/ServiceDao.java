package cn.hua.service.dao;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

import cn.hua.bean.Category;
import cn.hua.bean.MySource;
import cn.hua.bean.Permission;
import cn.hua.bean.Role;
import cn.hua.bean.SaveFile;
import cn.hua.bean.User;
import cn.hua.bean.WatchedAndCollect;
import cn.hua.bean.form.DataRequest;
import cn.hua.bean.form.DataResponse;
import cn.hua.bean.form.Source_front;
import cn.hua.bean.form.User_list;

public interface ServiceDao{
	void addCategory(Category category);
	void deleteCategory(Category category);
	void updateCategory(Category category);
	Category findCategoryById(String id);
	List<Category> getAllCategory();
	boolean categoryIsReName(String name,Category parent);
	void addSource(MySource source);
	void deleteSource(MySource source);
	void updateSource(MySource source);
	String updateSourceFile(String type,String id,MultipartFile file);
	MySource findSourceById(String id);
	List<Map<String, Object>> findSeries(String keyword);
	int[] saveScanList(List<MySource> sources);
	boolean pathIsExist(String path);
	<T> DataResponse<T> list(DataRequest request, Class<T> cls,String ... option);
	<T> int deleteManyByIds(Class<T> cls,String ids);
	<T> List<T> findManyByIds(Class<T> cls,String ids);
	String deleteManySource(String ids);
	String deleteManyImg(String ids);
	List<MySource> findSourceByOffline();
	int updateManySource(List<String> passed, int ispass);
	<T> int updateMany(List<T> passed);
	List<MySource> findSourceByOnline();
	boolean findSourceByPath(String string);
	void addUser(User user);
	void deleteUser(User user);
	void updateUser(User user);
	User findUserById(String id);
	List<Category> findAllCategoryByLi();
	boolean checkUserByType(String type, String value);
	User verify(String account, String password);
	String deleteManyUser(String id);
	Map<Integer, String> getPermissions(Role role);
	List<Role> getAllRoles();
	void deleteRole(Role r);
	Role findRoleByName(String name);
	Role findRoleById(String id);
	List<Permission> getPermissions();
	void addRole(Role role);
	Permission findPermissionByName(String name);
	Permission findPermissionById(int id);
	void updateRole(Role role);
	String deleteManyRole(String id);
	DataResponse<User_list> getSpecialUser(DataRequest request,boolean isManager);
	<T> Integer updateManyByFields(Class<T> class1,String[] ids,String[] name,Object[] value);
	<T> void update(T obj);
	DataResponse<User_list> userlist(DataRequest dataRequest);
	List<WatchedAndCollect> watched_collect(String id,String type);
	List<Source_front> getFrontSource(String type,int size,String ... option);
	/**
	 * 查询文件是否被占用
	 * @return true  占用
	 * @return false  不占用
	 */
	boolean selectFileIsUse(String id,String type,String ... sourceId);
	/**
	 * 清除没有外键关联的文件记录
	 */
	void deleteRubbishFile();
	/**
	 * 根据ID返回指定类型数据
	 * @param clazz
	 * @param id
	 * @return
	 */
	<T> T findById(Class<T> clazz,String id);
	/**
	 * 查询一个序列的资源
	 * @param seriesname 序列名
	 * @param id	排除的id
	 * @param option	查询的列
	 * @return
	 */
	List<MySource> findSourceBySeries(String seriesname, String id,String ... option);
	/**
	 * 查询系列名称和资源名称
	 * @param keyword
	 * @return
	 */
	List<Map<String, Object>> findSeriesAndName(String keyword);
	/**
	 * 全局添加
	 * @param t
	 */
	<T> void add(T t);
	/**
	 * 鸡保存文件的md5
	 * @param md5
	 * @return
	 */
	public SaveFile verifyMd5(String md5);
	/**
	 * 更新主面展示资源
	 * @param id
	 * @param file
	 * @return
	 */
	String updateSpecialSourceFile(String id, MultipartFile file);
	/**
	 * 数量查询
	 * @param cls
	 * @param crit
	 * @return
	 */
	<T> int count(Class<T> cls, String crit);
	/**
	 * 删除展示资源
	 * @param ids
	 * @return
	 */
	String deleteManySource2(String ids);
	/**
	 * 收藏资源
	 * @param id
	 * @param session
	 * @return
	 */
	String collectOrWatched(String id,User user,String type);
	/**
	 * 根据条件查ID，多对多的情况
	 */
	List<Source_front> findHobbySourceById(String[] cate);
	/**
	 * 查询出系统头像
	 * @return
	 */
	String[]  findAvatar();
	/**
	 * 删除文件前查询是否被战用
	 * @param saveFile
	 * @param isSelect 是否查询
	 * @param id
	 */
	void deleteFileThread(SaveFile saveFile,boolean isSelect,String ... id);
	/**
	 * 普通查询多字段
	 * @param cls
	 * @param id
	 * @param field
	 * @return
	 */
	<T> Object[] findForFieldById(Class<T> cls,String id,String ... field);
	/**
	 * 专为列表页面设计的查询
	 * @param dataRequest
	 * @return
	 */
	DataResponse<MySource> source_list(DataRequest dataRequest);
}
