<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<style>
	span#check-no{
		color: red;
		display: none;
	}
	span#check-yes{
		color: green;
		display: none;
	}
	
</style>
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="비밀번호 변경" name="pageTitle"/>
	</jsp:include>
	<c:if test="${memberLoggedIn==null }">
		<form action="${pageContext.request.contextPath }/member/memberUpdatePwd.do" method="post" onsubmit="return pwdDuplicateCheck();">
			<input type="password" name="pwd" id="pwd" placeholder="비밀번호" />
			<br />
			<input type="password" id="pwd-check" placeholder="비밀번호 확인" />
			<span id="check-no" >비밀번호가 불일치</span>
			<span id="check-yes" >비밀번호가 일치</span>
			<input type="hidden" name="key" value="${key }" />
			<input type="hidden" name="mid" value="${mid }" />
			<input type="hidden" id="pwd-ok" value="1" />
			<br />
			<button type="submit">변경</button>
		</form>
	</c:if>
	<script>
	$(function(){
		$("#pwd-check").on("keyup",function(){
			var p1 = $("#pwd").val();
			var p2 = $(this).val();
			console.log(p1);
			console.log(p2);
			if(p1==p2){
				//console.log("일치");
				$("#check-no").hide();
				$("#check-yes").show();
				$("#pwd-ok").val(0);
			}else{
				//console.log("불일치");
				$("#check-yes").hide();
				$("#check-no").show();
				$("#pwd-ok").val(1);
				
			}
		});
	});
	function pwdDuplicateCheck(){
		var newPwd = $("#pwd").val().trim();
		var reg = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
		var isValid = true;
		
		var po = $("#pwd-ok").val();
		if(po=="1"){
			console.log("ok");
			alert("비밀번호가 불일치합니다.");
			return false;
		}
		if (newPwd.length<8 || newPwd.length>16) {
			alert("암호를 8자이상 16자 이하로 설정해주세요.");
			return false;
		}
		if (!reg.test(newPwd)) {
			alert("영대소문자, 숫자, 특수문자로 비밀번호를 입력해주세요.");
			return false;
		}
		
		return true;
	}
	</script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	