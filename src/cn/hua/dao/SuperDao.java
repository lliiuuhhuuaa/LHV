package cn.hua.dao;

import java.util.List;

public interface SuperDao<T> {
	void add(T t);
	void update(T t);
	void delete(T t);
	T find(Object id);
	List<T> findAll();
}
