package com.pure.study.common.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.pure.study.member.model.vo.Member;

public class BoardCheckInterceptor extends HandlerInterceptorAdapter {
	//org.slf4j.Logger타입의 logger를 생성함
	//LoggerFactory.getLogger메소드의 파라미터로 현재클래스객체를 전달함.
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		if(memberLoggedIn == null) {
			logger.info(" 보드 ALERT : 멤버만 게시글 작성 가능");
			request.setAttribute("msg", "회원 가입후 이용 가능합니다.");
			request.setAttribute("loc", "/");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
			return false;	
		}
		
		return super.preHandle(request, response, handler);
	}	
}
