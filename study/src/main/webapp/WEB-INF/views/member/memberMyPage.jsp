<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

	<a href="${pageContext.request.contextPath }/member/memberView.do">개인정보</a>|
	<a href="${pageContext.request.contextPath }/member/searchMyPageKwd.do?">내 스터디</a>|
	<a href="${pageContext.request.contextPath }/member/searchMyApplyKwd.do">스터디 신청 목록</a>|
	<a href="${pageContext.request.contextPath }/member/searchMyWishKwd.do">스터디 관심 목록</a>
	