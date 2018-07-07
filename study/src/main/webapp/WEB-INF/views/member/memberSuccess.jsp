<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
#mes{margin: auto;
	margin :auto;
	width:73%;
	padding: 15px;
	text-align:center;
	background: #0fc7d3
	}
</style>
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
	
	<div id="mes">
	<jsp:include page="/WEB-INF/views/member/memberSeccessMessage.jsp"/>
	</div>
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

