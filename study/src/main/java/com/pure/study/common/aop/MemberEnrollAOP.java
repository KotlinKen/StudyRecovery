package com.pure.study.common.aop;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
public class MemberEnrollAOP {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	
	@After("execution(* com.pure.study..*Controller.*(..))")
	public void beforMemberEnroll(JoinPoint joinPoint , HttpServletRequest request) throws Exception {
		Object[] object = joinPoint.getArgs();
	
		Object arg = object[0];
		
		String id = (String)arg;
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		System.out.println();
		logger.info("[Info]Controll memberEnroll  : " );
		logger.info("[Info]Controll memberEnroll  : "+ id );
		
		
	}
}
