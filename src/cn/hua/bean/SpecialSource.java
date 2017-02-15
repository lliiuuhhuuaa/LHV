package cn.hua.bean;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
@Entity
@Table(name="specialsource")
public class SpecialSource {
	private String id;
	private MySource source;
	private String oneDecript;
	private SaveFile img;
	private String theme;
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
	@OneToOne
	public MySource getSource() {
		return source;
	}
	public void setSource(MySource source) {
		this.source = source;
	}
	@Column(length=30)
	public String getOneDecript() {
		return oneDecript;
	}
	public void setOneDecript(String oneDecript) {
		this.oneDecript = oneDecript;
	}
	@ManyToOne(cascade=CascadeType.ALL)
	public SaveFile getImg() {
		return img;
	}
	public void setImg(SaveFile img) {
		this.img = img;
	}
	@Column(length=10)
	public String getTheme() {
		return theme;
	}
	public void setTheme(String theme) {
		this.theme = theme;
	}
	
}
