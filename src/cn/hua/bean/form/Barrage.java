package cn.hua.bean.form;

import java.io.Serializable;

public class Barrage implements Serializable,Comparable<Barrage>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String text;
	private String color;
	private String position;
	private String size;
	private String time;
	private String send_time;
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getSize() {
		return size;
	}
	public void setSize(String size) {
		this.size = size;
	}
	public String getSend_time() {
		return send_time;
	}
	public void setSend_time(String send_time) {
		this.send_time = send_time;
	}
	@Override
	public int compareTo(Barrage o) {
		if(Integer.parseInt(this.time)<Integer.parseInt(o.getTime()))return -1;
		else return 1;
	}
}
