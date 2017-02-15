package cn.hua.bean.form;

import java.io.Serializable;

public class Comment implements Serializable,Comparable<Comment>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String text;
	private long support;
	private String user_id;
	private String time;
	private String name;
	private String img_id;
	public Comment() {
	}
	public Comment(String text, long support, String user_id, String time) {
		this.text = text;
		this.support = support;
		this.user_id = user_id;
		this.time = time;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public long getSupport() {
		return support;
	}
	public void setSupport(long support) {
		this.support = support;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getImg_id() {
		return img_id;
	}
	public void setImg_id(String img_id) {
		this.img_id = img_id;
	}
	@Override
	public int compareTo(Comment o) {
		if(Long.parseLong(this.time)<Long.parseLong(o.getTime()))return -1;
		else return 1;
	}
}
