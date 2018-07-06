package com.pure.study.common.aop;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.member.model.vo.Member;

@Component
@Aspect
public class BoardAOP {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Around("execution(* com..BoardController.*Write(..))"+"execution(* com..BoardController.*WriteEnd(..))")
	public ModelAndView beforeBoardAccess(ProceedingJoinPoint joinPoint) throws Throwable{
		logger.info("************************************보드 포인트컷**************************************");
		Object[] objs = joinPoint.getArgs();
		HttpSession session = null;
		Map<String, String> queryMap = null;
		ModelAndView mav = new ModelAndView();
		
		for(Object o : objs) {
			logger.info(o+"");
			if(o instanceof HttpServletRequest) {
				session = ((HttpServletRequest) o).getSession();
			}
			if(o instanceof Map) {
				queryMap = (Map<String, String>) o;
			}
			
		}
		logger.info("맵"+queryMap);
		Member m = (Member) session.getAttribute("memberLoggedIn");
		
		String type = queryMap.get("type");
		if(type != null) {
			if(m != null && (type.equals("공지") || type.equals("event"))) {
				if(m.getMid().equals("manager")) {
					mav = (ModelAndView) joinPoint.proceed();
				}else {
					mav.addObject("msg", "관리자외 접근 불가 입니다.");
					mav.addObject("loc", "/");
					mav.setViewName("common/msg");
				}
				
			}else { //널 그리고 공지사항아 아니거나 이벤트가 아니거나

				
			}
		}
		return mav;
	}
}
