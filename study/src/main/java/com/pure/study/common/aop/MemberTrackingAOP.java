package com.pure.study.common.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.member.model.vo.Member;

@Component
@Aspect
public class MemberTrackingAOP {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@AfterReturning(pointcut="execution(* com.pure.study.admin.controller.AdminController.*(..))", returning = "obj")
	public void beforMemberEnroll(JoinPoint joinPoint, Object obj) throws Exception {
		Object[] object = joinPoint.getArgs();
	
		
		
		
		
		logger.info(obj+"ttt");
	}
	
	
	
}
