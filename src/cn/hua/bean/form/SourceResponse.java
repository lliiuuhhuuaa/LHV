package cn.hua.bean.form;

import java.io.Serializable;

import cn.hua.bean.MySource;

public class SourceResponse extends DataResponse<MySource> implements Serializable{  
	 /**
	  * 
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String parent_cate;
     private String cate;
     private String sidx;
     private String specialSearch;
	public String getParent_cate() {
		return parent_cate;
	}
	public void setParent_cate(String parent_cate) {
		this.parent_cate = parent_cate;
	}
	public String getCate() {
		return cate;
	}
	public void setCate(String cate) {
		this.cate = cate;
	}
	public String getSidx() {
		return sidx;
	}
	public void setSidx(String sidx) {
		this.sidx = sidx;
	}
	public String getSpecialSearch() {
		return specialSearch;
	}
	public void setSpecialSearch(String specialSearch) {
		this.specialSearch = specialSearch;
	}
} 