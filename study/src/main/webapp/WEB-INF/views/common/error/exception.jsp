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
	font-size:24px;
}
.errorCode{}
</style>
<div class="errorWrap">
	<div class="errorCode"><c:out value="${requestScope['javax.servlet.error.status_code']}"/></div>
	<div class="errorName"><c:out value="${requestScope['javax.servlet.error.exception_type']}"/></div>
	<div class="errorContent"><c:out value="${requestScope['javax.servlet.error.message']}"/></div>
	<div class="">
		<a href="${rootPath }">
			시작페이지로 돌아가기
		</a></div>
</div>