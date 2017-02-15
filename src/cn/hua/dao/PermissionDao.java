package cn.hua.dao;

import cn.hua.bean.Permission;
import cn.hua.bean.User;

import java.util.List;

public interface PermissionDao{
	public List<Permission> getPermissions();
	public Permission findByName(String name);
	public Permission findById(int name);
	/*List<Permission> myPermission(User user);*/
}
