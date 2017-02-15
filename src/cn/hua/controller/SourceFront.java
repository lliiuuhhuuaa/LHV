package cn.hua.controller;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

import cn.hua.bean.Category;
import cn.hua.bean.MySource;
import cn.hua.bean.SaveFile;
import cn.hua.bean.SourceLog;
import cn.hua.bean.SpecialSource;
import cn.hua.bean.User;
import cn.hua.bean.form.Barrage;
import cn.hua.bean.form.Comment;
import cn.hua.bean.form.DataRequest;
import cn.hua.bean.form.DataResponse;
import cn.hua.bean.form.Source_front;
import cn.hua.service.dao.ServiceDao;
import cn.hua.utils.ByteRangeViewRender;
import cn.hua.utils.Conversion;
import cn.hua.utils.FileRW;

@Controller
public class SourceFront {
	@Autowired
	private ServiceDao service;
	@RequestMapping("/")
	public String defult(){
		return "redirect:index";
	}
	/**
	 * 主页请求
	 * @param reload
	 * @param request
	 * @return
	 */
	@RequestMapping("index")
	public String index(@RequestParam(required=false,defaultValue="0") int reload,HttpServletRequest request){
		ServletContext servletContext = request.getSession().getServletContext();
		Object obj = servletContext.getAttribute("save_time");
		boolean isRequest=true;//用于判断最后保存时间后是否重新请求数据
		if(obj!=null&&reload==0){
			if(Long.parseLong(obj.toString())+3600000>System.currentTimeMillis()){
				isRequest=false;
			}
		}
		//展示资源
		if(servletContext.getAttribute("specialSource")==null||isRequest){
			DataRequest dataRequest = new DataRequest();
			dataRequest.setPage(1);dataRequest.setRows(10);
			DataResponse<SpecialSource>  dataResponse = service.list(dataRequest, SpecialSource.class);
			if(dataResponse!=null)
			servletContext.setAttribute("specialSource",dataResponse.getRows());
			//存入当前时间
			servletContext.setAttribute("save_time",System.currentTimeMillis());
		}
		//分类
		if(servletContext.getAttribute("category")==null||isRequest)
			servletContext.setAttribute("category", service.getAllCategory());
		//最新推荐
		if(servletContext.getAttribute("source_new")==null||isRequest)
			servletContext.setAttribute("source_new", service.getFrontSource("new", 9,"id,name,decription,category,img,seriesname,log"));
		//电影推荐
		if(servletContext.getAttribute("source_movie")==null||isRequest)
			servletContext.setAttribute("source_movie", service.getFrontSource("电影", 9,"id,name,decription,category,img,seriesname,log"));
		//电视剧推荐
		if(servletContext.getAttribute("source_teleplay")==null||isRequest)
			servletContext.setAttribute("source_teleplay", service.getFrontSource("电视剧", 9,"id,name,decription,category,img,seriesname,log"));
		//动漫推荐
		if(servletContext.getAttribute("source_cartoon")==null||isRequest)
			servletContext.setAttribute("source_cartoon", service.getFrontSource("动漫", 9,"id,name,decription,category,img,seriesname,log"));
		return "index";
	}
	@RequestMapping(value="json/front_source/{type}")
	@ResponseBody
	public List<Source_front> getFrontSource(@PathVariable String type){
		if("new".equals(type)){
			return service.getFrontSource("new", 9);
		}else if("movie".equals(type)||"teleplay".equals(type)||"cartoon".equals(type)){
			return service.getFrontSource("other", 9);
		}else return null;
	}
	/**
	 * 图片下载，
	 * @param session
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/source/img/{size}/{id}")
	public void imgVisit(@PathVariable String size,@PathVariable String id,HttpServletResponse response){
		SaveFile saveFile = service.findById(SaveFile.class, id);
		if(saveFile!=null){
			File file = new File(saveFile.getPath());
			if(!file.exists())return;
			InputStream input=null;ImageInputStream iis=null;
			try {
				input = new FileInputStream(file);
				OutputStream output = response.getOutputStream();
				if (id != null) {
						//对这类图片进行缩小处理
						Image srcImg  = ImageIO.read(input);//取源图
						int width=srcImg.getWidth(null),height=srcImg.getHeight(null);
						if("max".equals(size)){
							width  =  460; //假设要缩小到200点像素
							height =  358;//srcImg.getHeight(null)*446/srcImg.getWidth(null);//按比例，将高度缩减
						}else if("avatar".equals(size)){
							width=40;height=40;
						}
				        Image image =srcImg.getScaledInstance(width, height, Image.SCALE_SMOOTH);//缩小
				        BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
				        Graphics2D g2 = bufferedImage.createGraphics();
				        g2.drawImage(image, 0, 0, width, height, Color.WHITE, null);
				        g2.dispose();
				        JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(output);
				        encoder.encode(bufferedImage);
						/*String suffix = FileRW.getSuffix(file.getName());
						Iterator<ImageReader> iterator = ImageIO.getImageReadersByFormatName("jpg");
						ImageReader imageReader = iterator.next();
						iis = ImageIO.createImageInputStream(input);
						imageReader.setInput(iis,true);
						ImageReadParam param = imageReader.getDefaultReadParam();
						Rectangle rect = new Rectangle(0,0,460,358);
						param.setSourceRegion(rect);
						BufferedImage bufferedImage = imageReader.read(0,param);
						ImageIO.write(bufferedImage, "jpg", output);*/
				}
				
				
				
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				if(input!=null)
					try {
						input.close();
						if(iis!=null)iis.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
		}
	}
	/**
	 * 资源信息请求
	 * @param id
	 * @param request
	 * @return
	 */
	@RequestMapping("/get_source/{id}")
	public String paly(@PathVariable String id,HttpServletRequest request,HttpSession session){
		MySource source = service.findById(MySource.class, id);
		if(source!=null&&!source.getId().equals(source.getSeriesname())){
			List<MySource> list = service.findSourceBySeries(source.getSeriesname(),null,"id,name");
			request.setAttribute("sources", list);
		}else{
			List<MySource> list = new ArrayList<MySource>();
			list.add(source);
			request.setAttribute("sources", list);
		}
		request.setAttribute("current_source", source);
		//推荐请求
		User user = (User) session.getAttribute("user");
		String[] hobbys = null;
		String[] hobbys_1 = null;
		String[] hobbys_2 = null;
		if(user!=null&&user.getHobby()!=null){
			String hobby = user.getHobby();
			if(hobby!=null)hobbys_1 = hobby.split(",");
		}else{
			String hobby = null;
			for(Category c :source.getCategory()){
				if(hobby==null)hobby=c.getId()+",";
				else hobby+=c.getId()+",";
			}
			hobby = hobby.substring(0, hobby.length()-1);
			hobbys_2  = hobby.split(",");
		}
		if(hobbys_1!=null&&hobbys_2!=null){
			hobbys = new String[hobbys_1.length+hobbys_2.length];
			System.arraycopy(hobbys_2, 0, hobbys, 0, hobbys_2.length);
			System.arraycopy(hobbys_1, 0, hobbys, hobbys_2.length, hobbys_1.length);
		}
		List<Source_front> sfs = service.findHobbySourceById(hobbys!=null?hobbys:hobbys_1!=null?hobbys_1:hobbys_2);
		request.setAttribute("hobbys",sfs);
		return "play";
	}
	/**
	 * 根据资源ID请求流
	 * @param id
	 * @param request
	 * @return
	 */
	@RequestMapping("/play/{id}")
	public void paly(@PathVariable String id,HttpServletResponse response,HttpServletRequest request){
		SaveFile source = service.findById(SaveFile.class, id);
		if(source!=null){
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("file", new File(source.getCvpath()!=null?source.getCvpath():source.getPath()));  
			map.put("contentType", "video/mp4");
			ByteRangeViewRender render = new ByteRangeViewRender();
			try {
				render.render(map, request, response);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	/**
	 * 获取弹幕文件(顺便更新资源播放次数)
	 * @return
	 */
	@RequestMapping("json/getBarrage/{id}")
	@ResponseBody
	public List<Barrage> getBarrage(@PathVariable String id){
		try{
			MySource source = service.findById(MySource.class, id);
			if(source!=null){
				SourceLog log = source.getLog();
				if(log!=null){//更新播放次数
					log.setTotal_play(log.getTotal_play()+1);
				}
				service.update(log);
			}
		}catch(Exception e){e.printStackTrace();}
		return FileRW.readBarrage(id);
	}
	/**
	 * 保存弹幕文件
	 * @param barrage
	 */
	@RequestMapping("json/saveBarrage/{id}")
	@ResponseBody
	public String saveBarrage(@Valid Barrage barrage,@PathVariable String id){
		barrage.setSend_time(System.currentTimeMillis()+"");
		barrage.setText(Conversion.filter(barrage.getText()));
		boolean result = FileRW.saveBarrage(id, barrage);
		return Conversion.stringToJson("message,"+result);
	}
	/**
	 * 对资源进行评分 
	 * @param barrage
	 */
	@RequestMapping(value="json/score/{id}",method=RequestMethod.POST)
	@ResponseBody
	public String saveScore(@PathVariable String id,@RequestParam(required=true) Integer index){
		try{
			MySource source = service.findById(MySource.class, id);
			if(source!=null){
				SourceLog log = source.getLog();
				String[] scores = log.getGrade().split(",");
				StringBuffer newScores = new StringBuffer();
				for(int i=0;i<scores.length;i++){
					if(i==index){
						scores[i] = Integer.parseInt(scores[i])+1+"";
					}
					if(i==scores.length-1)newScores.append(scores[i]);
					else newScores.append(scores[i]+",");
				}
				if(!source.getId().equals(source.getSeriesname())){
					List<MySource> list = service.findSourceBySeries(source.getSeriesname(),null);
					List<SourceLog> passed = new ArrayList<SourceLog>();
					for(MySource ms : list){
						SourceLog temp_log = ms.getLog();
						temp_log.setGrade(newScores.toString());
						passed.add(temp_log);
					}
					service.updateMany(passed);
				}else{
					log.setGrade(newScores.toString());
					service.update(log);
				}
				return Conversion.stringToJson("result,true");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return Conversion.stringToJson("result,false");
	}
	/**
	 * 保存评论
	 * @param id
	 * @param text
	 * @param session
	 * @return
	 */
	@RequestMapping(value="json/saveComment/{id}",method=RequestMethod.POST)
	@ResponseBody
	public String saveComment(@PathVariable String id,@RequestParam String text,HttpSession session){
		User user = (User)session.getAttribute("user");
		Comment comment = new Comment(Conversion.filter(text),0,user!=null?user.getId():"",System.currentTimeMillis()+"");
		boolean result = FileRW.saveComment(id, comment);
		return Conversion.stringToJson("result,"+result+",time,"+comment.getTime());
	}
	/**
	 * 保存评论
	 * @param id
	 * @param text
	 * @param session
	 * @return
	 */
	@RequestMapping(value="json/praise//{id}",method=RequestMethod.POST)
	@ResponseBody
	public String saveComment(@PathVariable String id,@RequestParam String time){
		boolean result = FileRW.praiseComment(id, time);
		return Conversion.stringToJson("result,"+result);
	}
	/**
	 * 读取评论
	 * @param id
	 * @param text
	 * @param session
	 * @return
	 */
	@RequestMapping(value="json/getComment/{id}",method=RequestMethod.POST)
	@ResponseBody
	public List<Comment> getComment(@PathVariable String id){
		List<Comment> list = FileRW.readComment(id);
		if(list!=null&&list.size()>0)
		for(Comment com : list){
			if(com.getUser_id()!=null){
				Object[] obj = service.findForFieldById(User.class, com.getUser_id(), "nickname","username","avatar_id");
				if(obj==null)com.setUser_id(null);
				else{
					com.setName((obj[0]!=null?obj[0]:obj[1]).toString());
					com.setImg_id(obj[2].toString());
				}
			}
		}
		return list;
	}
	/**
	 * 检查是否有满足下载条件
	 * @param session
	 * @return
	 */
	@RequestMapping(value="json/checkDownload",method=RequestMethod.POST)
	@ResponseBody
	public String checkDownload(HttpSession session){
		User user = (User)session.getAttribute("user");
		if(user==null){
			return Conversion.stringToJson("result,false,cause,您还未登陆");
		}else if(user.getLog().getMyLevel()[0]<1){
			return Conversion.stringToJson("result,false,cause,您等级还未达到1级");
		}else{
			return Conversion.stringToJson("result,true");
		}
	}
	/**
	 * 下载资源
	 * @param id
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 */
	@RequestMapping("download/{id}")
	public ModelAndView download(@PathVariable String id,HttpServletRequest request,HttpServletResponse response,HttpSession session){
		User user = (User)session.getAttribute("user");
		if(user==null||user!=null&&user.getLog().getMyLevel()[0]<1){
			return null;
		}
		MySource source = service.findById(MySource.class, id);
		if(source!=null&&source.getSource()!=null){
			ModelAndView mv = new ModelAndView(new ByteRangeViewRender());
			mv.addObject("file",new File(source.getSource().getCvpath()!=null?source.getSource().getCvpath():source.getSource().getPath()));
			mv.addObject("contentType","download/file");
			mv.addObject("name", source.getId().equals(source.getSeriesname())?source.getName():source.getSeriesname()+"　"+source.getName()+source.getSource().getPath().substring(source.getSource().getPath().indexOf(".")));
			return mv;
		}
		return null;
	}
	@RequestMapping("list")
	public String list(@Valid DataRequest dataRequest,Map<String,Object> request,HttpSession session){
		ServletContext servletContext = session.getServletContext();
		//分类
		if(servletContext.getAttribute("category")==null)
			servletContext.setAttribute("category", service.getAllCategory());
		if(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>1){
			Category cate = service.findCategoryById(dataRequest.getSearchString()[0]);
			if(cate==null)dataRequest.getSearchString()[0]="";
		}else if(dataRequest.getSearchString()!=null&&dataRequest.getSearchString().length>2){
			Category cate = service.findCategoryById(dataRequest.getSearchString()[1]);
			if(cate==null)dataRequest.getSearchString()[1]="";
		}
		request.put("dataResponse", service.source_list(dataRequest));
		return "list";
	}
}
