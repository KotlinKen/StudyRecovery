<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>



	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="메인" name="pageTitle"/>
	</jsp:include>
	sectiontest 
	<a href="${pageContext.request.contextPath }/study/studyList.do">스터디</a>
	
	${serverTime}	
	
	
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

