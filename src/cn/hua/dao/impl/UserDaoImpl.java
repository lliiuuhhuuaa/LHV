package cn.hua.dao.impl;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cn.hua.bean.User;
import cn.hua.dao.UserDao;
@Component
public class UserDaoImpl implements UserDao {
	@Autowired
	private SessionFactory sessionFactory;
	@Override
	public int checkUserByType(String type, String value) {
		String obj = sessionFactory.getCurrentSession().createNativeQuery("select count(*) from lhvuser where "+type+"=:value").setParameter("value", value).getSingleResult().toString();
		return Integer.parseInt(obj);
	}
	@Override
	public User verify(String account, String password) {
		List<User> list = sessionFactory.getCurrentSession().createQuery("from User where (username=:account or phoneNo=:account or email=:account) and password=:password",User.class).setParameter("account", account).setParameter("password", password).getResultList();
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}
	@Override
	public List<User> getManager(String criteria, int start, int size) {
		return sessionFactory.getCurrentSession().createQuery("from User"+criteria,User.class).setFirstResult(start).setMaxResults(size).getResultList();
	}
	
}
