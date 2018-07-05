package com.pure.study.common.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

@Aspect
@Component
public class MemberEnrollAOP {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Before("execution(* com.pure.study.member.controller.MemberController.memberAgreement(..))")
	public void beforMemberEnroll(JoinPoint joinPoint , HttpServletRequest request , ProceedingJoinPoint pjoin) throws Throwable{
		logger.info("Controller메소드가 시작했습니다.");
		
		Object[] obj = joinPoint.getArgs();
		logger.info("Controller메소드가 시작했습니다. : "+request);
		

		
	}
}
