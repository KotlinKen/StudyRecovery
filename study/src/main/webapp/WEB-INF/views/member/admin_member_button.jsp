<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
	li.btn-page{
		border-top: 1px solid #e1e1e1;
		border-bottom: 1px solid transparent;
		border-left: 1px solid #e1e1e1;
		border-right: 1px solid #e1e1e1;
		padding: 7px;
		border-radius: 10%;
		margin: 0;
		display: inline;
		background: #f9f9f9;
	}
	li.btn-page a{
		color: #666;
	}
</style>
	
	
	
	
<div class="ulpage">
	<ul id="ul-page">
		<li class='btn-page'>
		<a href="${rootPath }/admin/adminMember">회원</a>
		</li>
		<li class='btn-page'>
		<a href="${rootPath }/member/memberPointList.do">회원 포인트 관리</a>
		</li>
		<li class='btn-page'>
			<a href="${rootPath }/member/agreementAdmin.do">약관 동의 관리</a>
		</li>
	</ul>
</div>
	
