package cn.hua.bean.form;

import java.io.Serializable;
import java.util.Set;

import cn.hua.bean.Category;
import cn.hua.bean.SaveFile;
import cn.hua.bean.SourceLog;

public class Source_front implements Serializable{

	/**
	 * 资源
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private String name;
	private String decription;
	private Set<Category> category;
	private SaveFile img;
	private String seriesname;//用户排序一系列
	private SourceLog log;
	public Source_front() {
		// TODO Auto-generated constructor stub
	}
	public Source_front(String name,String seriesname) {
		this.name = name;
		this.seriesname = seriesname;
	}
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
	public String getDecription() {
		return decription;
	}
	public void setDecription(String decription) {
		this.decription = decription;
	}
	public String getSeriesname() {
		return seriesname;
	}
	public void setSeriesname(String seriesname) {
		if(seriesname!=null&&seriesname.length()>40){
			seriesname = seriesname.substring(0,39);
		}
		this.seriesname = seriesname;
	}
	public Set<Category> getCategory() {
		return category;
	}
	public void setCategory(Set<Category> category) {
		this.category = category;
	}
	public SourceLog getLog() {
		return log;
	}
	public void setLog(SourceLog log) {
		this.log = log;
	}
	public SaveFile getImg() {
		return img;
	}
	public void setImg(SaveFile img) {
		this.img = img;
	}
}
