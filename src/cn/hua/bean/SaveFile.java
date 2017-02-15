package cn.hua.bean;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="savefile")
public class SaveFile {
	private String id;
	private int isSystem;
	private String path;
	private String cvpath;
	private String md5;
	public SaveFile(){}
	public SaveFile(String path){
		this.path = path;
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
	@Column(length=1)
	public int getIsSystem() {
		return isSystem;
	}
	public void setIsSystem(int isSystem) {
		this.isSystem = isSystem;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		if(path!=null)
			path = path.replaceAll("/", "\\\\");
			this.path = path;
		this.path = path;
	}
	@Column(length=40)
	public String getMd5() {
		return md5;
	}
	public void setMd5(String md5) {
		this.md5 = md5;
	}
	public String getCvpath() {
		return cvpath;
	}
	public void setCvpath(String cvpath) {
		this.cvpath = cvpath;
	}
	
}
