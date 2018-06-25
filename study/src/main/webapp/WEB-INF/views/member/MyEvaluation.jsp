<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp"/>
	<br />
	평가 관리
	<input type="radio" name="exp" id="exp" ${eval eq 'exp'?'checked':'' }/>
	<label for="exp">경험치</label>
	<input type="radio" name="point" id="point" ${eval eq 'point'?'checked':'' }/>
	<label for="point">평가 점수</label>
	<input type="radio" name="npoint" id="npoint" ${eval eq 'npoint'?'checked':'' }/>
	<label for="npoint">지식 점수</label>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	