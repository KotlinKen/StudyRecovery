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
	<div class="errorCode">1234</div>
	<div class="errorName">이름</div>
	<div class="errorContent">내용</div>
	<div class="">
		<a href="${rootPath }">
			시작페이지로 돌아가기
		</a></div>
</div>