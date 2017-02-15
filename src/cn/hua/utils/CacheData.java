package cn.hua.utils;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CacheData{
	//缓存规则：行号：资源id：资源名称
	public static void addWatchedCookie(HttpServletResponse response,Map<String,String> map) {
		StringBuffer data = new StringBuffer();
		for(Entry<String, String> entry : map.entrySet()){
			data.append(entry.getKey()+":"+entry.getValue()+",");
		}
		data.deleteCharAt(data.length()-1);
		Cookie cookie=null;
		try {
			cookie = new Cookie("lhv_watched",URLEncoder.encode(data.toString(),"UTF-8"));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		cookie.setMaxAge(60*60*24*15);	//保存15天
		cookie.setPath("/LHV");
		response.addCookie(cookie);
	}
	public static Map<String,String> getWatchedCookie(HttpServletRequest request){
		Cookie[] cookies = request.getCookies();
		if(cookies!=null)
		for(Cookie cookie : cookies){
			if("lhv_watched".equals(cookie.getName())){
				String value=null;
				try {
					value = URLDecoder.decode(cookie.getValue(),"UTF-8");
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if(value!=null){
					Map<String,String> map = new LinkedHashMap<String,String>();
					String[] val = value.split(","); 
					for(String temp : val){
						String[] key_val = temp.split(":");
						if(key_val.length==2){
							map.put(key_val[0], key_val[1]);
						}
					}
					return map;
				}
			}
		}
		return null;
	}
	public static void removeCookie(HttpServletResponse httpServletResponse, String key){
		Cookie cookie = new Cookie(key,null);
		cookie.setMaxAge(0);
		cookie.setPath("/skjs");
		System.out.println("remove");
		httpServletResponse.addCookie(cookie);
	}
}
