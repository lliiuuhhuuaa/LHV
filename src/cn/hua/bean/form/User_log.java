package cn.hua.bean.form;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class User_log implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private Date lastSignDate;
	private int signCount;
	private long experience;
	private Date lastLoginTime;
	private long[] myLevel;
	private boolean sign=false;
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
	public Date getLastLoginTime() {
		return lastLoginTime;
	}
	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}
	public long[] getMyLevel(){
		if(this.myLevel==null){
			myLevel = new long[3];
			myLevel[0] = 0;
			myLevel[1] = 0;
			myLevel[2] = 100;
		}
		return myLevel;
	}
	public boolean isSign() {
		return sign;
	}
}
