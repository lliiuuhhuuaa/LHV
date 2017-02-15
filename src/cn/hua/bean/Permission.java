package cn.hua.bean;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="permission")
public class Permission implements Comparable<Permission>,Serializable{
	/**
	 * 权限
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private String name;
	private String decription;
	public Permission(){}
	@Id
	@GeneratedValue
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDecription() {
		return decription;
	}
	public void setDecription(String decription) {
		this.decription = decription;
	}
	@Override
	public int compareTo(Permission o) {
		if(this.id>o.id)
			return 1;
		else
			return -1;
	}
	
}
