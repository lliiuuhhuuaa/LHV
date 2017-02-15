package cn.hua.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cn.hua.bean.MySource;
import cn.hua.bean.SaveFile;
import cn.hua.dao.MySourceDao;
@Component
public class MySourceDaoImpl implements MySourceDao{
	@Autowired
	private SessionFactory sessionFactory;
	@Override
	public void add(MySource t) {
		sessionFactory.getCurrentSession().save(t);
	}

	@Override
	public void update(MySource t) {
		sessionFactory.getCurrentSession().update(t);
		
	}

	@Override
	public void delete(MySource t) {
		sessionFactory.getCurrentSession().delete(t);
		
	}

	@Override
	public MySource find(Object id) {
		return sessionFactory.getCurrentSession().get(MySource.class, id.toString());
	}

	@Override
	public List<MySource> findAll() {
		return null;
	}

	@Override
	public List<Object> findSeries(String keyword,int size) {
		return sessionFactory.getCurrentSession().createNativeQuery("select id,seriesname,decription from mysource where seriesname != id and seriesname like :keyword group by seriesname").setParameter("keyword", "%"+keyword+"%").setFirstResult(0).setMaxResults(size).getResultList();
	}
	@Override
	public List<Object> findSeriesAndName(String keyword,int size) {
		return sessionFactory.getCurrentSession().createNativeQuery("select id,name,seriesname from mysource where seriesname like :keyword or name like :keyword group by seriesname").setParameter("keyword", "%"+keyword+"%").setFirstResult(0).setMaxResults(size).getResultList();
	}
	public int[] saveScanList(List<MySource> list){
		int[] num=new int[list.size()];
		Session session = sessionFactory.getCurrentSession();
		int i=0;
		for(MySource source : list){
			try{
				session.save(source);
				num[i++]=1;
			}catch(Exception e){
				num[i++]=0;
			}
		}
		session.flush();
		return num;
		/*sessionFactory.getCurrentSession().doWork(new Work(){
			@Override
			public void execute(Connection conn) throws SQLException {
				PreparedStatement ps = conn.prepareStatement("insert into mysource(id,name,uploadtime,sourcepath,seriesname,ispass) values(?,?,?,?,?,0)");
				for(MySource source : list){
					ps.setString(1, UUID.randomUUID().toString());
					ps.setString(2,source.getName());
					ps.setObject(3,new Date());
					ps.setString(4, source.getSourcepath());
					ps.setString(5, source.getSeriesname());
					ps.addBatch();
				}
				num = ps.executeBatch();
				ps.close();
			}
			
		});
		return num;*/
	}

	@Override
	public boolean pathIsExist(String path) {
		String result = sessionFactory.getCurrentSession().createNativeQuery("select count(*) from savefile where path=:path").setParameter("path", path).getSingleResult().toString();
		if(result!=null&&result.equals("0")) return false;
		else return true;
	}

	@Override
	public List<MySource> findSourceByOffline() {
		return sessionFactory.getCurrentSession().createQuery("from MySource where ispass=0 and source!=null and log!=null",MySource.class).getResultList();
	}
	@Override
	public List<MySource> findSourceByOnline() {
		return sessionFactory.getCurrentSession().createQuery("from MySource where ispass=1",MySource.class).getResultList();
	}
	@Override
	public int updateMany(List<String> passed,int ispass) {
		return sessionFactory.getCurrentSession().createNativeQuery("update mysource set ispass=:ispass where id in(:id)").setParameter("ispass", ispass).setParameterList("id", passed).executeUpdate();
	}
	@Override
	public int findSourceByPath(String path) {
		Object obj = sessionFactory.getCurrentSession().createNativeQuery("select count(*) from savefile where path=:path").setParameter("path", path).getSingleResult();
		return Integer.parseInt(obj.toString());
	}
	public SaveFile verifyMd5(String md5){
		List<SaveFile> list = sessionFactory.getCurrentSession().createQuery("from SaveFile where md5=:md",SaveFile.class).setParameter("md", md5).getResultList();
		if(list!=null&&list.size()>0)return list.get(0);
		else return null;
	}
	public int deleteRubbishFile(){
		return sessionFactory.getCurrentSession().createNativeQuery("delete from savefile where id not in(select img_id from mysource) or id not in(select source_id from mysource)").executeUpdate();
	}

	@Override
	public List<MySource> findSourceBySeries(String seriesname, String id,String ...option) {
		String opt="";
		if(option!=null&&option.length>0)opt="select new MySource("+option[0]+") ";
		Query<MySource>  query = sessionFactory.getCurrentSession().createQuery(opt+"from MySource where seriesname!=id and seriesname=:name"+(id!=null?" and id not in(:ids)":"")+" order by name",MySource.class).setParameter("name", seriesname);
		if(id!=null)query.setParameter("ids", id);
		return query.getResultList();
	}
	public List<Object> findCategoryBySourceId(String id){
		return sessionFactory.getCurrentSession().createNativeQuery("select category_id from mysource_category where mysource_id=:id").setParameter("id", id).getResultList();
	}
	
	public List<MySource> list(String sql,int page,int size){
		return  sessionFactory.getCurrentSession().createQuery(sql,MySource.class).setFirstResult(page).setMaxResults(size).getResultList();
	}

	@Override
	public int count(String sql) {
		Object obj = sessionFactory.getCurrentSession().createNativeQuery(sql).getSingleResult();
		return Integer.parseInt(obj.toString());
	}
}
