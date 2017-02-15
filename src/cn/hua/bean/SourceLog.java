package cn.hua.bean;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import cn.hua.utils.CustomDateSerializer;
import cn.hua.utils.LHUtils;
@Entity
@Table(name="sourcelog")
public class SourceLog implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private long total_play;
	private String grade;
	@JsonSerialize(using = CustomDateSerializer.class)
	private Date uploadtime;
	private String uploaduserid;
	private float score;
	@Id
	@GeneratedValue(generator="uuid")
	@GenericGenerator(name="uuid",strategy="uuid2")
	@Column(length=40)
	public String getId() {
		return id;
	}
	public SourceLog() {
	}
	public SourceLog(Date uploadtime, String uploaduserid) {
		this.uploadtime = uploadtime;
		this.uploaduserid = uploaduserid;
	}
	public void setId(String id) {
		this.id = id;
	}
	public long getTotal_play() {
		return total_play;
	}
	public void setTotal_play(long total_play) {
		this.total_play = total_play;
	}
	@Column(length=10)
	public String getGrade() {
		if(grade==null)return "0,0,0,0,0";
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public Date getUploadtime() {
		return uploadtime;
	}
	public void setUploadtime(Date uploadtime) {
		this.uploadtime = uploadtime;
	}
	@Column(length=40)
	public String getUploaduser() {
		return uploaduserid;
	}
	public void setUploaduser(String uploaduserid) {
		this.uploaduserid = uploaduserid;
	}
	public void setScore(float score) {
		this.score = score;
	}
	public float getScore() {
		this.score = LHUtils.calcScore(this.grade);
		return score;
	}
}
