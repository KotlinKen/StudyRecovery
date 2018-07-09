<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>

<style>
.errorWrap {
	width: 900px;
	padding: 30px;
	display: block;
	position: relative;
	margin: 0 auto;
	text-align: center;
	font-size:1rem;
}
.errorWrap > div {padding:10px; }
.errorCode{font-size:1.2rem;}
</style>
<div class="errorWrap">
	<div><img src="${rootPath }/resources/images/errorlogo.png" alt="" /> </div>
	<div class="errorCode"><c:out value="${requestScope['javax.servlet.error.status_code']}"/> ERROR</div>
	<%-- <div class="errorName"><c:out value="${requestScope['javax.servlet.error.exception_type']}"/></div> --%>
	<div class="errorName">에러가 발생했습니다. 관리자에게 문의 해주세요</div>
<%-- 	<div class="errorContent"><c:out value="${requestScope['javax.servlet.error.message']}"/></div> --%>
	<div class="errorContent"></div>
	
	<div class="">
		<a href="${rootPath }">
			시작페이지로 돌아가기
		</a></div>
</div>