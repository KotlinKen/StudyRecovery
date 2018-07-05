<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script>
/* history.pushState(null, null, location.href);
var dd =document.getElementById("dd");
window.onpopstate = function(event) {
    alert("여기서 뒤로 갈 수 없습니다.");
}; */
</script>

	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="회원 가입 성공" name="pageTitle"/>
	</jsp:include>
	
	
	<jsp:include page="/WEB-INF/views/member/memberSeccessMessage.jsp"/>
	
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

