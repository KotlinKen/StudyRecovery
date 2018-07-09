<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${param.pageTitle}</title>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/style.css" />
<style>
#instructor{display: none;}
#seccessdiv{ top: 50px; text-align: center;}
.button{color: white; border: 1px solid white; padding: 10px; border-radius: 3px;}
.button:hover{border: 2px solid white; position: relative; top:-5px;}
h2{position: relative; color: white;}
h1{ color: white;}
span{color: white;}
img{width: 50%;}
</style>
</head>
<body><br /><br />	
<img src="${rootPath}/resources/images/ttbmp.png" alt="공부" /><br />
	<h1>진심으로 축하 드립니다.</h1>
<span>
저희<a id="headaik" href="${pageContext.request.contextPath}" style="color: white;">STUDY GROUPT</a>
에서는 보다 나은 서비스를 위해 최선을 다하겠습니다. 감사합니다.
</span>
<br /><br />
	
	<c:if test="${'ok' eq check} ">
		<h1 id="ccc">?????????</h1>
	</c:if>
	
<div id="seccessdiv">
	${ check}  
	<br />
	<div id="instructor">
		<form action="${pageContext.request.contextPath }/member/memberLoginInstruct.do" method="post">
		<div class="modal-body">
			<input type="text" class="form-control" name="userId" id="userId_" placeholder="아이디" required /> <br /> 
			<input type="password" class="form-control" name="pwd" id="password_" placeholder="비밀번호" required /> 
			<a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=아이디">아이디/</a> 
			<a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=비밀번호">비밀번호 찾기</a>
			</div>
			<div class="modal-footer">
				<button type="submit" class="btn btn-outline-success">로그인</button>
			</div>
		</form>
	</div>
	<br /><br />
	<a  href="${rootPath }/study/studyList.do" style="color: white;" class="button">스터디 둘러보기</a> &nbsp;&nbsp;
	<a  href="${rootPath }/lecture/lectureList.do" style="color: white;" class="button">강의 둘러보기</a> &nbsp;&nbsp;
	<a id="headaik" href="${pageContext.request.contextPath}" style="color: white;" class="button">홈으로</a>
	<br /><br /><br /><br />
	
</div>
<script>
function fn_instruct() {
	$("#instructor").css({"display":"block"});
}
</script>
</body>
</html>
