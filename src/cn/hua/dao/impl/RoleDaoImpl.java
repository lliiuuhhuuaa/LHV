package cn.hua.dao.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.stereotype.Component;

import cn.hua.bean.Role;
import cn.hua.dao.RoleDao;
@Component
public class RoleDaoImpl implements RoleDao{
	private HibernateTemplate hibernateTemplate;
	@Resource
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}
	@Override
	public Role getPermissions(Role role) {
		return hibernateTemplate.get(Role.class, role.getId());
	}
	@Override
	public Role findByName(String name) {
		List<Role> list = hibernateTemplate.getSessionFactory().getCurrentSession().createQuery("from Role where name=:name",Role.class).setParameter("name", name).getResultList();
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else
		return null;
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<Role> getAllRoles() {
		return (List<Role>) hibernateTemplate.find("from Role");
	}

}
