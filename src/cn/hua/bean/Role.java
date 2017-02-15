package cn.hua.bean;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

import java.io.Serializable;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name="role")
public class Role implements Serializable {
	/**
	 * 角色：拥有那些权限 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private String name;
	private int level;
	private int parentLevel;
	private List<Permission> permissions = new LinkedList<Permission>();
	@Id
	@GeneratedValue(generator="uuid")
	@GenericGenerator(name="uuid",strategy="uuid2")
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public int getParentLevel() {
		return parentLevel;
	}
	public void setParentLevel(int parentLevel) {
		this.parentLevel = parentLevel;
	}
	@Column(length=20,unique=true)
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Column(name="roleLevel")
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	@ManyToMany(fetch=FetchType.EAGER,cascade=CascadeType.ALL)
	public List<Permission> getPermissions() {
		Collections.sort(permissions);
		return permissions;
	}
	public void setPermissions(List<Permission> permissions) {
		this.permissions = permissions;
	}
	public Role(){}
	public Role(int level, int parentLevel, String name) {
		this.level = level;
		this.parentLevel = parentLevel;
		this.name = name;
	}
	public Role(String id) {
		this.id = id;
	}
	public Role(String id, String name) {
		super();
		this.id = id;
		this.name = name;
	}
	
}