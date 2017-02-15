package cn.hua.dao;

import java.util.List;

public interface GlobalDao {
	<T> List<T> list(Class<T> cls,String criteria,int start,int size);
	<T> int count(Class<T> cls,String str);
	<T> int deleteManyByIds(Class<T> cls,Object[] ids);
	<T> List<T> findManyByIds(Class<T> cls, Object[] ids);
	<T> void add(T t);
	<T> void update(T t);
	<T> void delete(T t);
	<T> T find(Class<T> cls,Object id);
	<T> Integer updateManyByFields(Class<T> cls,String criteria,String[] ids,Object[] value);
	<T> List<T> list(Class<T> cls, String criteria, int start, int size,String ... option);
	<T> T get(Class<T> cls,String sql,String ... params);
	<T> int updateMany(List<T> passed);
	<T> Object findIdByField(String sql,String ... param);
}
