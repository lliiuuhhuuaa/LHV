package cn.hua.utils;

import java.io.IOException;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import cn.hua.socket.MyHandler;

public class Message {
	private WebSocketSession session;
	public Message() {
	}
	public Message(WebSocketSession session){
		this.session = session;
	}
	public void send(String mes){
		try {
			session.sendMessage(new TextMessage(mes));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public void send(String chatId,String message){
		try {
			if(chatId!=null){
				session = MyHandler.getSessionById(chatId);
				if(session!=null)
					session.sendMessage(new TextMessage(message));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
