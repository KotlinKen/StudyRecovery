<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<html>
<head>
	<title>에러페이지</title>
	<style>
		div#error-container{text-align: center;}
	</style>
</head>
<body>
<%-- 	<div id="error-container">
		<h1>에러!</h1>
		<h2 style="color: red;"><%=exception.getMessage() %></h2>

	</div> --%>
	
		<div id="wrapper">
		<div id="page-wrapper">
			<div align="center">
				<c:out value='${msg }'/>
			</div>
		</div>
	</div>
			<a href="${pageContext.request.contextPath }">
			시작페이지로 돌아가기
		</a>
<c:out value="${requestScope['javax.servlet.error.status_code']}"/>
<c:out value="${requestScope['javax.servlet.error.exception_type']}"/>
<c:out value="${requestScope['javax.servlet.error.message']}"/>
<c:out value="${requestScope['javax.servlet.error.request_uri']}"/>
<c:out value="${requestScope['javax.servlet.error.exception']}"/>
<c:out value="${requestScope['javax.servlet.error.servlet_name']}"/>
</body>
</html>