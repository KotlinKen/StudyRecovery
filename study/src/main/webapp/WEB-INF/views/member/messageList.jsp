<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>


<%@page import = 'com.pure.study.member.model.vo.Member, java.util.List, java.util.Map' %>
<jsp:include page="/WEB-INF/views/common/header.jsp"><jsp:param value="내 정보 보기" name="pageTitle"/></jsp:include>


<div class="container">
<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp"/>




${listAll }








</div>










<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
