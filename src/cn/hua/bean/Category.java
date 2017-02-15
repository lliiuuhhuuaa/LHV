package cn.hua.bean;

import java.io.Serializable;
import java.util.Set;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="category")
public class Category implements Serializable,Comparable<Category>{
	/**
	 * 分类表
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private String name;
	@JsonIgnore
	private Category parent;
	private Set<Category> childs = new TreeSet<Category>();
	public Category() {
		// TODO Auto-generated constructor stub
	}
	
	public Category(String id) {
		this.id = id;
	}

	public Category(String id, String name,Category parent) {
		this.id = id;
		this.name = name;
		this.parent = parent;
	}

	@Id
	@Column(length=20)
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	@Column(length=40)
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@ManyToOne
	public Category getParent() {
		return parent;
	}
	public void setParent(Category parent) {
		this.parent = parent;
	}
	@OneToMany(mappedBy="parent",fetch=FetchType.EAGER,cascade=CascadeType.REMOVE)
	public Set<Category> getChilds() {
		/*if(childs!=null){
			List<Category> list = new ArrayList<Category>(childs);
			Collections.sort(list);
			childs = new TreeSet<Category>(list);
		}*/
		return childs;
	}
	public void setChilds(Set<Category> childs) {
		this.childs = childs;
	}
	@Override
	public int compareTo(Category o) {
		return this.name.compareToIgnoreCase(o.getName());
	}
	
}
