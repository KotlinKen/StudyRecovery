<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="${findType } 찾기" name="pageTitle"/>
	</jsp:include>
		<c:if test="${mid==null and findType eq '아이디' }">
			아이디 찾기
			<form action="${pageContext.request.contextPath }/member/memberFindIdPwd.do">
				<input type="text" name="mname" id="mname" placeholder="회원 이름"/>
				<input type="email" name="email" id="email" placeholder="이메일"/>
				<input type="hidden" name="findType" value="아이디" />
				<input type="submit" value="찾기" />
			</form>
		</c:if>
		<c:if test="${mid!=null }">
			당신의 아이디는 ${mid }** 입니다.
		</c:if>
		<c:if test="${pwd==null and findType eq '비밀번호' }">
			비밀번호 찾기
			<form action="${pageContext.request.contextPath }/member/mailSending.do" method="post" onsubmit="return confirm();">
				<input type="text" name="mid" id="mid" placeholder="아이디" />
				<input type="email" name="email" id="email" placeholder="이메일" />
				<input type="hidden" name="findType" value="비밀번호" />
				<input type="submit" id="pwdSearch" value="찾기" />
			</form>
			
		</c:if>
		<script>
		function confirm(){
				alert("잠시만 기다려주세요.");
				return true;
		} 
		</script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	