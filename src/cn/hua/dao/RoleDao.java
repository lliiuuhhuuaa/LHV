package cn.hua.dao;

import java.util.List;

import cn.hua.bean.Role;

public interface RoleDao{
	Role getPermissions(Role role);
	public List<Role> getAllRoles();
	public Role findByName(String name);
}
