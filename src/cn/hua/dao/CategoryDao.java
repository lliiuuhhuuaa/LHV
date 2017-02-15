package cn.hua.dao;

import java.util.List;

import cn.hua.bean.Category;

public interface CategoryDao {
	boolean isReName(String name,Category parent);
	List<Category> findAllCategory();
	List<Category> findAllCategoryByLi();
	Category getCategoryByName(String name);
}
