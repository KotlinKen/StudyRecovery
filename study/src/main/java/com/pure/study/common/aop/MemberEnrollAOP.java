package com.pure.study.common.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.builder.ToStringBuilder;
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
   public void beforMemberEnroll(JoinPoint joinPoint ) throws Throwable{
      logger.info("Controller메소드가 시작했습니다.");
      
      Object[] obj = joinPoint.getArgs();
      logger.info("Controller메소드가 시작했습니다. : "+joinPoint);
      logger.info("Controller메소드가 시작했습니다.getArgs : "+joinPoint.getArgs());
      logger.info("Controller메소드가 시작했습니다.obj : "+obj);
      try {
		
    	  logger.info("Controller메소드가 시작했습니다.obj : "+obj[0]);
	} catch (Exception e) {
		// TODO: handle exception
	}
      logger.info("Controller메소드가 시작했습니다.getKind : "+joinPoint.getKind());
      logger.info("Controller메소드가 시작했습니다.hashCode : "+joinPoint.hashCode());
      logger.info("Controller메소드가 시작했습니다.toLongString : "+joinPoint.toLongString());
      logger.info("Controller메소드가 시작했습니다.toString : "+joinPoint.toString());
      logger.info("Controller메소드가 시작했습니다.getStaticPart : "+joinPoint.getStaticPart());
      logger.info("Controller메소드가 시작했습니다.getThis : "+joinPoint.getThis());
      logger.info("Controller메소드가 시작했습니다.getTarget : "+joinPoint.getTarget());
      logger.info("Controller메소드가 시작했습니다.getSourceLocation : "+joinPoint.getSourceLocation());
      logger.info("Controller메소드가 시작했습니다.getClass : "+joinPoint.getClass());
      logger.info("Controller메소드가 시작했습니다.getSignature : "+joinPoint.getSignature());
      
      Object params[] = joinPoint.getArgs();
      for(Object param : params) {
         
              logger.info("찍힐까? : "+param);
          
      }
      
     // EnrollInterceptora lciaop = new EnrollInterceptora();
//      logger.info("Controller메소드가 시작했습니다.lciaop : "+lciaop);
//      
//      if(lciaop) {
//    	  
//      }

      
   }
}