package com.pure.study.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.pure.study.member.model.vo.Member;

public class AdminCheckInterceptor extends HandlerInterceptorAdapter {
	//org.slf4j.Logger타입의 logger를 생성함
	//LoggerFactory.getLogger메소드의 파라미터로 현재클래스객체를 전달함.
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		if("/study/admin/adminLogin".equals(request.getRequestURI())) {

			if(memberLoggedIn != null ){
				String admin = memberLoggedIn.getMid();
				if(!(admin.equals("manager"))) {
					logger.info("비정상적 접근 : 관리자만 접근 가능합니다.");
					logger.info("비정상적 접근 : 관리자만 접근 가능합니다.");
					request.setAttribute("msg", "비정상적 접근 : 관리자만 접근 가능합니다.");
					request.setAttribute("loc", "/");
					request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
					return false;
				}else {
					logger.info(admin+"님 환영합니다.");
					request.setAttribute("msg", "이미 로그인 되었습니다.");
					request.setAttribute("loc", "/admin/adminMain");
					request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
				}

			}
		}else {
			if(memberLoggedIn==null){
				logger.info("비로그인 상태에서 ["+request.getRequestURI()+"] 접근!");
				request.setAttribute("msg", "관리자 로그인후 이용해주세요.");
				request.setAttribute("loc", "/");
				request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
				return false;
			}else {
				String admin = memberLoggedIn.getMid();
				if(!(admin.equals("manager"))) {
					logger.info("비정상적 접근 : 관리자만 접근 가능합니다.");
					request.setAttribute("msg", "비정상적 접근 : 관리자만 접근 가능합니다.");
					request.setAttribute("loc", "/");
					request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
					return false;
				}else {
					logger.info(admin+"님 환영합니다.");
				}
				
			}
		}
		return super.preHandle(request, response, handler);
	}	
}
