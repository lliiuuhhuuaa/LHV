package cn.hua.bean;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.validator.constraints.Length;
@Entity
@Table(name="lhvuser")
public class User implements Serializable{
	/**
	 * 用户基本信息表
	 */
	private static final long serialVersionUID = 1L;
	private String email;
	private String id;
	private String nickname;
	@Length(min=6,max=40)
	private String password;
	@Length(min=5,max=15)
	private String username;
	@Length(max=11)
	private String phoneNo;
	private String question;
	private String name;
	private String presentation;
	private String hobby;
	private SaveFile avatar;
	private Role role;
	private UserLog log;
	@ManyToOne
	public Role getRole() {
		return role;
	}
	public void setRole(Role role) {
		this.role = role;
	}
	@Column(length=40,unique=true)
	public String getEmail() {
		return email;
	}
	@Id
	@GeneratedValue(generator="uuid")
	@GenericGenerator(name="uuid",strategy="uuid2")
	@Column(length=40)
	public String getId() {
		return id;
	}
	@Column(length=40,unique=true)
	public String getNickname() {
		return nickname;
	}
	public String getPassword() {
		return password;
	}
	@Column(length=40,unique=true)
	public String getUsername() {
		return username;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	@Column(length=40,unique=true)
	public String getPhoneNo() {
		return phoneNo;
	}
	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}
	public String getQuestion() {
		return question;
	}
	public void setQuestion(String question) {
		this.question = question;
	}
	@Column(length=40)
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPresentation() {
		return presentation;
	}
	public void setPresentation(String presentation) {
		this.presentation = presentation;
	}
	public String getHobby() {
		return hobby;
	}
	public void setHobby(String hobby) {
		this.hobby = hobby;
	}
	@OneToOne(cascade=CascadeType.ALL)
	public UserLog getLog() {
		return log;
	}
	public void setLog(UserLog log) {
		this.log = log;
	}
	@ManyToOne(cascade=CascadeType.ALL)
	public SaveFile getAvatar() {
		return avatar;
	}
	public void setAvatar(SaveFile avatar) {
		this.avatar = avatar;
	}
	
}
