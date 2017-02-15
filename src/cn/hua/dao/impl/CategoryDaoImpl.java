package cn.hua.dao.impl;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.stereotype.Component;

import cn.hua.bean.Category;
import cn.hua.dao.CategoryDao;
@Component
public class CategoryDaoImpl implements CategoryDao {
	@Autowired
	private SessionFactory session;
	/*@Override
	public void add(Category t) {
		hibernateTemplate.save(t);
	}

	@Override
	public void update(Category t) {
		hibernateTemplate.update(t);
	}

	@Override
	public void delete(Category category) {
		hibernateTemplate.delete(category);
	}

	@Override
	public Category find(Object id) {
		return hibernateTemplate.get(Category.class,id.toString());
	}*/
	@Override
	public boolean isReName(String name,Category parent) {
		String result = session.getCurrentSession().createNativeQuery("select count(*) from category where parent_id=:id and name=:name").setParameter("id",parent!=null?parent.getId():"").setParameter("name", name).getSingleResult().toString();
		if(Integer.parseInt(result)>0)return true;else return false;
	}

	@Override
	public List<Category> findAllCategory() {
		return session.getCurrentSession().createNativeQuery("select * from category where parent_id is null", Category.class).getResultList();
	}
	public List<Category> findAllCategoryByLi(){
		return session.getCurrentSession().createNativeQuery("select * from category", Category.class).getResultList();
	}
	public Category getCategoryByName(String name){
		List<Category> list = session.getCurrentSession().createQuery("from Category where name=:name",Category.class).setParameter("name", name).getResultList();
		if(list!=null&&list.size()>0)return list.get(0);
		return null;
	}
}
