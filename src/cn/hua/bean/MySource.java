package cn.hua.bean;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.validator.constraints.NotEmpty;
@Entity
@Table(name="mysource")
public class MySource implements Serializable{

	/**
	 * 资源
	 */
	private static final long serialVersionUID = 1L;
	@NotEmpty
	private String id;
	@NotEmpty
	private String name;
	private String decription;
	private Set<Category> category =new HashSet<Category>();
	private SaveFile img;
	private SaveFile source;
	private String seriesname;//用户排序一系列
	private int ispass;
	private SourceLog log;
	private String kind;
	public MySource() {
		// TODO Auto-generated constructor stub
	}
	public MySource(String name, SaveFile source,String seriesname) {
		this.name = name;
		this.source = source;
		this.seriesname = seriesname;
	}
	public MySource(String id, String name, String decription, Set<Category> category, SaveFile img, String seriesname,
			SourceLog log) {
		this.id = id;
		this.name = name;
		this.decription = decription;
		this.category = category;
		this.img = img;
		this.seriesname = seriesname;
		this.log = log;
	}
	public MySource(String id, String name, SaveFile img, String seriesname,
			SourceLog log) {
		this.id = id;
		this.name = name;
		this.img = img;
		this.seriesname = seriesname;
		this.log = log;
	}
	public MySource(String id, String name) {
		this.id = id;
		this.name = name;
	}
	@Id
	@GeneratedValue(generator="uuid")
	@GenericGenerator(name="uuid",strategy="uuid2")
	@Column(length=40)
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Column(length=200)
	public String getDecription() {
		return decription;
	}
	public void setDecription(String decription) {
		this.decription = decription;
	}
	@Column(length=40)
	public String getSeriesname() {
		return seriesname;
	}
	public void setSeriesname(String seriesname) {
		if(seriesname!=null&&seriesname.length()>40){
			seriesname = seriesname.substring(0,39);
		}
		this.seriesname = seriesname;
	}
	@Column(length=1)
	public int getIspass() {
		return ispass;
	}
	public void setIspass(int ispass) {
		this.ispass = ispass;
	}
	@ManyToMany(fetch=FetchType.EAGER)
	public Set<Category> getCategory() {
		return category;
	}
	public void setCategory(Set<Category> category) {
		this.category = category;
	}
	@OneToOne(cascade=CascadeType.ALL)
	public SourceLog getLog() {
		return log;
	}
	public void setLog(SourceLog log) {
		this.log = log;
	}
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	@ManyToOne(cascade={CascadeType.ALL})
	public SaveFile getImg() {
		return img;
	}
	public void setImg(SaveFile img) {
		this.img = img;
	}
	@ManyToOne(cascade={CascadeType.ALL})
	public SaveFile getSource() {
		return source;
	}
	public void setSource(SaveFile source) {
		this.source = source;
	}
	
}
