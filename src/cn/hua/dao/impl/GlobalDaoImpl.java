package cn.hua.dao.impl;

import java.util.List;

import javax.persistence.Table;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cn.hua.bean.WatchedAndCollect;
import cn.hua.dao.GlobalDao;
@Component
public class GlobalDaoImpl implements GlobalDao{
	@Autowired
	private SessionFactory sessionFactory;
	@Override
	public <T> int count(Class<T> cls, String str) {
		Table table = cls.getAnnotation(Table.class);
		Object obj = sessionFactory.getCurrentSession().createNativeQuery("select count(*) from "+table.name()+" "+str).getSingleResult();
		return Integer.parseInt(obj.toString());
	}
	@Override
	public <T> List<T> list(Class<T> cls, String criteria, int start, int size) {
		return sessionFactory.getCurrentSession().createQuery("from "+cls.getName()+" "+criteria,cls).setFirstResult(start).setMaxResults(size).getResultList();
	}

	@Override
	public <T> int deleteManyByIds(Class<T> cls,Object[] ids) {
		sessionFactory.getCurrentSession().createQuery("delete from "+WatchedAndCollect.class.getName()+" where source_id in(:id)").setParameterList("id", ids).executeUpdate();
		return sessionFactory.getCurrentSession().createQuery("delete from "+cls.getName()+" where id in(:id)").setParameterList("id", ids).executeUpdate();
	}
	@Override
	public <T> List<T> findManyByIds(Class<T> cls, Object[] ids) {
		return sessionFactory.getCurrentSession().createQuery("from "+cls.getName()+" where id in(:id)",cls).setParameterList("id", ids).getResultList();
	}
	@Override
	public <T> void add(T t) {
		sessionFactory.getCurrentSession().save(t);
	}
	@Override
	public <T> void update(T t) {
		sessionFactory.getCurrentSession().update(t);
		
	}
	@Override
	public <T> void delete(T t) {
		sessionFactory.getCurrentSession().delete(t);
		
	}
	@Override
	public <T> T find(Class<T> cls,Object id) {
		return sessionFactory.getCurrentSession().get(cls,id+"");
	}
	@Override
	public <T> Integer updateManyByFields(Class<T> cls,String criteria,String[] ids,Object[] value) {
		Table table = cls.getAnnotation(Table.class);
		NativeQuery nq = sessionFactory.getCurrentSession().createNativeQuery("update "+table.name()+" set "+criteria+" where id in(:id)");
		for(int i=0;i<value.length;i++){
			nq.setParameter(++i, value[--i]);
		}
		return nq.setParameterList("id", ids).executeUpdate();
	}
	@Override
	public <T> List<T> list(Class<T> cls, String criteria, int start, int size,String ... option) {
		String opt="";
		if(option!=null&&option.length>0){
			opt = "select new "+cls.getName()+"("+option[0]+") ";
		}
		Session session = sessionFactory.getCurrentSession();
		return session.createQuery(opt+" from "+cls.getName()+criteria,cls).setFirstResult(start).setMaxResults(size).getResultList();
	}
	@Override
	public <T> T get(Class<T> cls,String sql,String ... params){
		Query<T> query = sessionFactory.getCurrentSession().createQuery(sql,cls);
		for(int i=0;params!=null&&i<params.length;i++){
			query.setParameter(i, params[i]);
		}
		List<T> list =  query.getResultList();
		if(list!=null&&list.size()>0)return list.get(0);
		return null;
	}
	/**
	 * 批量更新
	 */
	@Override
	public <T> int updateMany(List<T> passed) {
		/*return sessionFactory.getCurrentSession().createNativeQuery("update mysource set ispass=:ispass where id in(:id)").setParameter("ispass", ispass).setParameterList("id", passed).executeUpdate();*/
		Session session = sessionFactory.getCurrentSession();
		int i=0;
		for(T t : passed){
			try{
				session.update(t);
				i++;
			}catch(Exception e){
			}
		}
		session.flush();
		return i;
	}
	/**
	 * 批量普通查找
	 */
	@Override
	public <T> Object findIdByField(String sql,String ... param) {
		NativeQuery<?> query = sessionFactory.getCurrentSession().createNativeQuery(sql);
		for(int i=0;param!=null&&i<param.length;i++) query.setParameter(i+1, param[i]);
		try{
			return  query.getSingleResult();
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
}
