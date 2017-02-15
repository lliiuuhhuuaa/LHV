package cn.hua.socket;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import cn.hua.utils.Conversion;
/**
 * 定义消息处理器
 * @author 甜橙六画
 *
 */
public class MyHandler extends TextWebSocketHandler {
	private final static Map<String,WebSocketSession> missionUser = new HashMap<String,WebSocketSession>();
	public MyHandler() {
		System.out.println("初始化聊天服务器.......");
	}
	@Override
	public void afterConnectionClosed(WebSocketSession session,
			CloseStatus status) throws Exception {
		missionUser.remove(session.getId());
		System.out.println("用户"+session.getId()+"断开连接");
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session)
			throws Exception {
		missionUser.put(session.getId(), session);
		session.sendMessage(new TextMessage(Conversion.stringToJson("state,100,id,"+session.getId())));
		System.out.println("新用户连接到websocket,当前用户个数："+missionUser.size());
	}
	@Override
	protected void handleTextMessage(WebSocketSession session,
			TextMessage message) throws Exception {
		/*String mes = message.getPayload();
		System.out.println(mes);
		ObjectMapper mapper = new ObjectMapper();
		Map<String,String> map = mapper.readValue(mes, Map.class);
		if(map==null)return;
		try {
			if("form".equals(map.get("type"))){
				session.sendMessage(new TextMessage(
						Conversion.stringToJson("id,"+map.get("id")+",type,form,state,uploading,content,正在上传,mission,50,log,正在解析资源信息")));
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		};*/
	}
	public static WebSocketSession getSessionById(String id){
		return missionUser.get(id);
	}
}
