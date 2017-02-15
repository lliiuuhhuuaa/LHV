package cn.hua.bean;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
@Entity
@Table(name="watchedandcollect")
public class WatchedAndCollect implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private String userid;
	private MySource source;
	private String type;
	private String seriesname;
	private Date time;
	
	public WatchedAndCollect() {
	}
	public WatchedAndCollect(String userid,MySource source, String type,String seriesname,Date time) {
		this.userid = userid;
		this.source = source;
		this.type = type;
		this.seriesname = seriesname;
		this.time = time;
	}
	@Id
	@GeneratedValue
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	@ManyToOne
	public MySource getSource() {
		return source;
	}
	public void setSource(MySource source) {
		this.source = source;
	}
	@Column(length=10)
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getTime() {
		return time;
	}
	public void setTime(Date time) {
		this.time = time;
	}
	@Column(length=40)
	public String getSeriesname() {
		return seriesname;
	}
	public void setSeriesname(String seriesname) {
		this.seriesname = seriesname;
	}
	@Column(length=40)
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	
}
