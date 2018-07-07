package com.pure.study.common.websocket;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pure.study.member.model.vo.Member;
import com.pure.study.message.model.vo.Message;

public class EchoHandler extends TextWebSocketHandler {
	 private static Logger logger = LoggerFactory.getLogger(EchoHandler.class);
	 

	 
	 
	    //방법일 일대일챗팅 map사용
		private Map<String, WebSocketSession> sessions = new HashMap<String, WebSocketSession>();
	    private ObjectMapper mapper = new ObjectMapper();
	    
	    
	    /**
	     * 클라이언트 연결 이후에 실행되는 메소드
	     */
	    @Override
	    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
	    	  Map<String,Object> map = session.getAttributes();
	    	  Member member = (Member) map.get("memberLoggedIn");
	    	  System.out.println("로그인 한 아이디 : " + member.getMid());
	        //Map사용시
	    	sessions.put(member.getMid(), session);
	        
	        logger.info("{} 연결됨", session.getId());
	        
	        
	        Message message = new Message("init", member.getMid(), null, "안녕~");
	        
	        Iterator<String> sessionIds = sessions.keySet().iterator();
	        String sessionId="";
	        
	    
	        
	        while(sessionIds.hasNext()){
	            sessionId = sessionIds.next();
	            System.out.println("담겨있는 값" + ":" + sessionId );
 
	        }
	        
	        
	        
	      
	        
	        
	        handleTextMessage(session, new TextMessage(mapper.writeValueAsString(message)));
	    }
	    /**
	     * 클라이언트가 웹소켓서버로 메시지를 전송했을 때 실행되는 메소드
	     */
	    @Override
	    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    	  
	    	logger.error("handdle 호출" + session.getId());
	    	 
	   
	        //배열이면 많이 쓸수 있고, 쓰지않으면 최대 2개임여
	        logger.info("{}와 부터 {}받음",new String[] {session.getId(), message.getPayload()});
	        
	    	  message.getPayload();

	/*        for(WebSocketSession sess : sessionList){
	            sess.sendMessage(new TextMessage("echo: " +  message.getPayload()));
	        }*/
	    	  
	        Iterator<String> sessionIds = sessions.keySet().iterator();
	        String sessionId="";
	        while(sessionIds.hasNext()){
	            sessionId = sessionIds.next();
	            //sessions.get(sessionId).sendMessage(new TextMessage(sessionId+" echo " + message.getPayload()));
	            sessions.get(sessionId).sendMessage(message);
	            logger.error("sessionids 호출" + sessionId);
	        }
	        
	    }
	    /**
	     * 클라이언트가 연결을 끊었을 때 실행되는 메소드
	     */
	    @Override
	    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	        //map
	    	Iterator<String> tarKeyIter = sessions.keySet().iterator();
	    	while (tarKeyIter.hasNext()) {
	    	    String key = tarKeyIter.next();
	    	    if(sessions.get(key) == session) {
	    	        sessions.remove(key);
	    	        break;
	    	    }
	    	}
	        //logger.info("{} 연결 끊김", session.getId());
	    }
	    
		public Map<String, WebSocketSession> getSessions() {
			return sessions;
		}
		public void setSessions(Map<String, WebSocketSession> sessions) {
			this.sessions = sessions;
		}

	    

	
	

}
