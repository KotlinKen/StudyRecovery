package com.pure.study.common.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MemberEnrollAOP {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@After("execution(* com.kh.spring.member.controller.MemberController.memberEnroll(..))")
	public void beforMemberEnroll(JoinPoint joinPoint) throws Exception {
		Object[] object = joinPoint.getArgs();
	
		Object arg = object[0];
		
		String id = (String)arg;
		
		logger.info("  : "+ id );
		
		
	}
}
