package cn.hua.dao;

import java.util.List;

import cn.hua.bean.User;


public interface UserDao{
	int checkUserByType(String type,String value);
	User verify(String account, String encryption);
	List<User> getManager(String criteria,int start,int size);
}
