package cn.hua.utils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
/**
 * 自定义json返回的日期格式
 * @author 甜橙六画
 *
 */
public class CustomDateSerializer extends JsonSerializer<Date> {
	 @Override
	 public void serialize(Date value, JsonGenerator jgen,SerializerProvider provider)
	   throws IOException,JsonProcessingException {
	  SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	  String formattedDate = formatter.format(value);
	  jgen.writeString(formattedDate);
	 }
	}
