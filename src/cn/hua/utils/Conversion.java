package cn.hua.utils;

public class Conversion{
	/*public T  beanToBean(T target,K source){
		BeanUtils.copyProperties(source, target);
		return target;
	}*/
	/**
	 * 普通字符串转json字符串，注意：传入字符串需键值对应
	 * @param 接收一个字符串，例："abc,true,abc,ead"
	 * @return {"abc":true,"abc":"ead"}
	 */
	public static String stringToJson(String str){
		String[] newArray = str.split(",");
		StringBuffer json = new StringBuffer("{");
		for(int i=0;i<newArray.length;i++){
			if(i%2==0){
				json.append("'"+newArray[i]+"':");
			}else{
				if(newArray[i].equals("true")||newArray[i].equals("false")||newArray[i].equals("null")){
					json.append(newArray[i]+",");
				}else{
					json.append("'"+newArray[i]+"',");
				}
			}
		}
		System.out.println("StringToJson:"+json.deleteCharAt(json.length()-1).append("}").toString());
		return json.deleteCharAt(json.length()-1).append("}").toString();
	}
	public static String stringToJsonGroupTwo(String str){
		//{,1,pp,},{
		String[] newArray = str.split(",");
		StringBuffer json = new StringBuffer("[{");
		for(int i=0;i<newArray.length;i++){
			if(i%4==0&&i>0){
				json.append("},{");
			}
			if(i%2==0){
				json.append("'"+newArray[i]+"':");
			}else{
				if(newArray[i].equals("true")||newArray[i].equals("false")){
					json.append(newArray[i]+",");
				}else{
					json.append("'"+newArray[i]+"',");
				}
			}
		}
		//System.out.println("StringToJson:"+json.deleteCharAt(json.length()-1).append("}]").toString());
		return json.deleteCharAt(json.length()-1).append("}]").toString();
	}
	public static String filter(String message){
		if(message == null){
			return null;
		}
		char content[] = new char[message.length()];
		message.getChars(0, message.length(), content, 0);
		StringBuffer result = new StringBuffer(content.length);
		for(int i=0;i<content.length;i++){
			switch(content[i]){
			case '<':
				result.append("&lt;");
				break;
			case '>':
				result.append("&gt;");
				break;
			case '&':
				result.append("&amp;");
				break;
			case '"':
				result.append("&quot;");
				break;
			default:
				result.append(content[i]);
			}
		}
		return result.toString();
	}
}
