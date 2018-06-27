<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

	<a href="${rootPath }/member/memberView.do">개인정보</a>|
	<a href="${rootPath }/member/searchMyPageKwd.do?myPage=study">내 스터디</a>|
	<a href="${rootPath }/member/searchMyPageKwd.do?myPage=apply">스터디 신청 목록</a>|
	<a href="${rootPath }/member/searchMyPageKwd.do?myPage=wish">스터디 관심 목록</a>
	|<a href="#" onclick="javascript:document.myForm.submit();">강사신청</a>
	<a href="${rootPath }/member/searchMyPageEvaluation.do">평가 관리</a>
	
	<form name="myForm" action="${rootPath }/member/instructorApply.do" method="post" >
	<input type="hidden" name="mid" value="${memberLoggedIn.mid }" />
	<input type="hidden" name="mno" value="${memberLoggedIn.mno }" />
	</form>
	