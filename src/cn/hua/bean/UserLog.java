package cn.hua.bean;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
@Entity
@Table(name="userlog")
/**
 * 用户日志记录表
 * @author 刘华
 *
 */
public class UserLog implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private Date lastSignDate;
	private int signCount;
	private long experience;
	private Date lastLoginTime;
	private int watchExpCount;
	private Date lastWatchExpTime;
	
	private long[] myLevel;
	private boolean sign=false;
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
	public Date getLastSignDate() {
		return lastSignDate;
	}
	public void setLastSignDate(Date lastSignDate) {
		this.lastSignDate = lastSignDate;
		if(lastSignDate!=null){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if(sdf.format(lastSignDate).equals(sdf.format(new Date()))){
				sign=true;
			}
		}
	}
	public int getSignCount() {
		if(lastSignDate!=null){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if(!sdf.format(lastSignDate).equals(sdf.format(new Date()))&&!sdf.format(lastSignDate).equals(sdf.format(System.currentTimeMillis()-86400000))){
				this.signCount=0;
			}
		}
		return signCount;
	}
	public void setSignCount(int signCount) {
		this.signCount = signCount;
	}
	public long getExperience() {
		return experience;
	}
	public void setExperience(Long experience) {
		this.experience = experience;
		if(myLevel==null) myLevel = new long[3];
		if(experience==null||experience==0){
			myLevel[0] = 0;
			myLevel[1] = 0;
			myLevel[2] = 100;
			return;
		}
		int exp = 100,level=0;
		while(exp<this.experience){
			exp *=2;level++;
		}
		myLevel[0] = level;
		myLevel[1] = this.experience;
		myLevel[2] = exp;
	}
	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}
	
	public Date getLastLoginTime() {
		return lastLoginTime;
	}
	public int getWatchExpCount() {
		if(lastWatchExpTime!=null){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if(sdf.format(lastWatchExpTime).equals(sdf.format(new Date()))){
				return watchExpCount;
			}else{
				this.watchExpCount=0;
				return 0;
			}
		}
		this.watchExpCount=0;
		return 0;
	}
	public void setWatchExpCount(int watchExpCount) {
		this.watchExpCount = watchExpCount;
	}
	public Date getLastWatchExpTime() {
		return lastWatchExpTime;
	}
	public void setLastWatchExpTime(Date lastWatchExpTime) {
		this.lastWatchExpTime = lastWatchExpTime;
	}
	@Transient
	public long[] getMyLevel(){
		if(this.myLevel==null){
			myLevel = new long[3];
			myLevel[0] = 0;
			myLevel[1] = 0;
			myLevel[2] = 100;
		}
		return myLevel;
	}
	@Transient
	public boolean isSign() {
		return sign;
	}
}
