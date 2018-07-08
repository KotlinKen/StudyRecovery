package com.pure.study.message.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.WebSocketSession;

import com.pure.study.common.websocket.EchoHandler;
import com.pure.study.member.model.vo.Member;
import com.pure.study.message.model.service.MessageService;

@Controller
public class MessageController {
	
	@Autowired
	MessageService messageService;
	

	
	
	@RequestMapping(value="/message/messageList", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView messageList(@RequestParam Map<String, String> queryMap, HttpServletRequest request){
		ModelAndView mav = new ModelAndView("jsonView");
		
		int cPage = 1;
		int numPerPage = 10;
		
		
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		if(m != null) {
			queryMap.put("mno", String.valueOf(m.getMno()));
		}
		
		
		
		
		List<Map<String, String>> listAll = messageService.messageList();
		System.out.println("+==========================================================+");
		List<Map<String, String>> listQuery = messageService.messageList(queryMap);
		List<Map<String, String>> listQueryPage = messageService.messageList(cPage, numPerPage, queryMap);
		
		
		mav.addObject("listAll", listAll);
		mav.addObject("listQuery", listQuery);
		mav.setViewName("message/messageList");
		return mav; 
	}
	
	@RequestMapping(value="/message/messageWrite", method=RequestMethod.GET)
	public ModelAndView messageWrite(@RequestParam Map<String, String> queryMap, HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		if(m != null) {
			queryMap.put("mno", String.valueOf(m.getMno()));
		}
		return mav; 
	}
	@RequestMapping(value="/message/messageWriteEnd", method=RequestMethod.POST)
	public ModelAndView messageWriteEnd(@RequestParam(value="receivermno", required = true, defaultValue="") int receivermno,
			@RequestParam Map<String, String> queryMap, HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		if(m != null) {
			queryMap.put("sendermno", String.valueOf(m.getMno()));
		}else {
			//널이면 접근 불가하게
		}
		
		if(queryMap.get("sno") == null) {
			queryMap.put("sno", null);
		}
		
		int result = messageService.messageWrite(queryMap);
		
		
		
		
		
		if(result > 0 ) {
			

			
			mav.addObject("msg", "쪽지를 발송하였습니다.");
			mav.addObject("loc", "/message/messageWrite");
			mav.setViewName("common/msg");
			return mav;
		}else {
			mav.addObject("msg", "발송에 실패 하였습니다.");
			mav.addObject("loc", "message/messageWrite");
			mav.setViewName("common/msg");
		}
		
		mav.addObject("result", result);
		mav.setViewName("message/messageWrite");
		return mav; 
	}
	
	
}
