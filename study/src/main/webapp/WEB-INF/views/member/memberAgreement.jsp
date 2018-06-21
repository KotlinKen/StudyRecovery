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
p{width: 300px; height: 300px; overflow: scroll;}
</style>
</head>
<body>
<form action="${pageContext.request.contextPath}/member/memberEnroll.do" method="post" onsubmit="return validate();">
<input type="hidden" name="check" id="check" value="21" />
<spen>서비스 이용약관 동의 (필수)<input type="checkbox" id="agree1" value="0" name="agree1" /></spen>
<p>
	<c:forEach var ="v" items="${service }">
		${v.SCONTENT } <br />
	</c:forEach>
</p>

<spen>개인정보 수집 및 이용 동의 (필수)<input type="checkbox" id="agree2" value="0" name="agree2" /></spen>
<p>
	<c:forEach var ="v" items="${information }">
		${v.ICONTENT } <br />
	</c:forEach>
</p>


 <button type="button" onclick="location.href='${pageContext.request.contextPath}'">취소</button>
 <button type="submit" onclick="fn_agreement();">다음</button>
 </form>
 <script>
	$("#agree1").click(function() {
		var chk1=document.getElementById("agree1");
		if(!chk1.checked){
			$("#agree1").val(0);
		}else{
			$("#agree1").val(1);
		}
	}); 
	$("#agree2").click(function() {
		var chk2=document.getElementById("agree2");
		if(!chk2.checked){
			$("#agree2").val(0);
		}else{
			$("#agree2").val(1);
		}
	}); 
 	function validate() {
 	      //체크박스 체크여부 확인 [하나]
        var chk1=document.getElementById("agree1");
        var chk2=document.getElementById("agree2");
       
        if(!chk1.checked){
            alert('동의해야 진행할 수  있습니다.');
            return false;
        }
     
        if(!chk2.checked) {
            alert('동의해야 진행할 수  있습니다.');
            return false;
        }
    
        var che1 = $("#agree1").val(); 
        var che2 = $("#agree2").val(); 
      
        return true;
	}
 </script>
</body>
</html>