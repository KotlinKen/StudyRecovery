<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<c:if test="${!empty lectureList }">
	<c:forEach var="lecture" items="${lectureList }">
		<div class="lectureDiv" style="border: 1px solid gray; text-align: center;">
			<span>제목 : ${lecture.TITLE }</span>
			<br />
			<span>지역 : ${lecture.LOCAL} ${lecture.TNAME}</span>
			<br />
			<span>과목 : ${lecture.KNAME} - ${lecture.SUBNAME}</span>
			<br />
			<span>난이도 : ${lecture.DNAME }</span>
			<br />
			<span>비용 : ${lecture.PRICE}원</span>
			<br />
			<span>${lecture.STATUS }</span>
			<br />
			<span>
				일정 :
				<fmt:parseDate value="${lecture.SDATE}" type="date" var="sdate" pattern="yyyy-MM-dd" />
				<fmt:formatDate value="${sdate }" pattern="yyyy/MM/dd"/> 
				~ 
				<fmt:parseDate value="${lecture.EDATE}" type="date" var="edate" pattern="yyyy-MM-dd" />
				<fmt:formatDate value="${edate }" pattern="yyyy/MM/dd"/>
				&nbsp;&nbsp;&nbsp;
				시간 : ${lecture.TIME }							
			</span>
			<br />
			<span>
				작성자 : ${lecture.MNAME } &nbsp;&nbsp;&nbsp;
				등록일 : <fmt:parseDate value="${lecture.REGDATE }" type="date" var="regDate" pattern="yyyy-MM-dd" />
				<fmt:formatDate value="${regDate }" pattern="yyyy/MM/dd"/>	
			</span>
			<input type="hidden" id="sno" value="${lecture.SNO }"/>
		</div>
	</c:forEach>
		
	<input type="hidden" name="cPage" id="cPage" value="${cPage }"/>
	
	<c:if test="${cPage != 1 }">
		<button type="button" class="moveSearchPageBtn" id="beforeSearchBtn" name="beforeBtn" value="${cPage-1}">&lt;</button>
	</c:if>
	<c:if test="${cPage <= totalPage}">
		<button type="button" class="moveSearchPageBtn" id="afterSearchBtn" name="afterPage" value="${cPage+1}">&gt;</button>	
	</c:if>
</c:if>
<c:if test="${empty lectureList }">
	<div class="lectureDiv" style="border: 1px solid gray; text-align: center;">
		강의가 없어 시발롬아.
	</div>
</c:if>	
