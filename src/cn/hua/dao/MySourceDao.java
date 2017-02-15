package cn.hua.dao;

import java.util.List;

import cn.hua.bean.MySource;
import cn.hua.bean.SaveFile;

public interface MySourceDao extends SuperDao<MySource>{
	List<Object> findSeries(String keyword, int size);
	int[] saveScanList(List<MySource> list);
	boolean pathIsExist(String path);
	List<MySource> findSourceByOffline();
	int updateMany(List<String> passed, int ispass);
	List<MySource> findSourceByOnline();
	int findSourceByPath(String path);
	int count(String sql);
	List<MySource> list(String sql,int page,int size);
	SaveFile verifyMd5(String md5);
	int deleteRubbishFile();
	/**
	 * 根据系列名查资源
	 * @param seriesname 系列名
	 * @param id	排除在外的id
	 * @param option	要查询的列
	 * @return
	 */
	List<MySource> findSourceBySeries(String seriesname, String id,String ...option);
	List<Object> findCategoryBySourceId(String id);
	List<Object> findSeriesAndName(String keyword, int size);
}
