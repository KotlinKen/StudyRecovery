<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="${rootPath }/resources/js/jquery-3.3.1.js"></script>
<script src="${rootPath}/resources/js/member/find.js"></script>
<script src="${rootPath}/resources/js/member/enroll.js"></script>
<!-- 테이블 css -->
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />

<style>
	.find{
		padding-top: 5%;
		padding-bottom: 5%;
		padding-left: 40%;
	}
	span{
		position: relative;
		top: 0;
		left: 30%;
		z-index: 1000;
	}
	.id-pwd{
		width: 40%;
		height: 40%;
		background: #ebebee;
		position: relative;
		top: 0;
		left: 0;
		z-index: 100;
		border-radius: 5px;
	}
	input[type=text] {
	    width: 100%;
	    padding: 12px 20px;
	    margin: 8px 0;
	    box-sizing: border-box;
	    border: none;
	    border-bottom: 1px solid #cccccc;
	}
	input[type=email] {
	    width: 100%;
	    padding: 12px 20px;
	    margin: 8px 0;
	    box-sizing: border-box;
	    border: none;
	    border-bottom: 1px solid #cccccc;
	}
</style>
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="${findType } 찾기" name="pageTitle"/>
	</jsp:include>
	<%
		String findType = String.valueOf(request.getAttribute("findType"));
		System.out.println("아이디?"+findType);
	%>
	<div class="page">
		<c:if test="${mid==null and findType eq '아이디' }">
			<!-- <span id="idServiceLogo"></span> -->
			<form class="find" action="${pageContext.request.contextPath }/member/memberFindIdPwd.do" onsubmit="return validate();">
				<table  class="id-pwd">
					<tr  class="id-pwd">
						<td  class="id-pwd">
						<input type="text" name="mname" id="mname" placeholder="회원 이름" maxlength="7" autocomplete="off"/>	
						<br /> 
						<span id="nameerr" class="name"></span> 
						<span id="nameok" class="name"></span>					
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="email" name="email" id="email" maxlength="30" required placeholder="이메일"/>						
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="hidden" name="findType" value="아이디" />
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="submit" class="btncss" id="submit" value="찾기" />							
						</td>
					</tr>
				</table>
			</form>
		</c:if>
		<c:if test="${mid!=null }">
			당신의 아이디는 ${mid }** 입니다.
		</c:if>
		<c:if test="${pwd==null and findType eq '비밀번호' }">
			<span id="pwdServiceLogo" class=".link_findpw"></span>
			<form class="find" action="${pageContext.request.contextPath }/member/mailSending.do" method="post" onsubmit="return confirm();">
				<table  class="id-pwd">
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="text" name="mid" id="mid" placeholder="아이디" />
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="email" name="email" id="email" placeholder="이메일" />
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="submit" id="pwdSearch" value="찾기" />
						</td>
					</tr>
				</table>
			</form>
		</c:if>
	</div>
	<script>
	function confirm(){
			alert("잠시만 기다려주세요.");
			return true;
	} 
	</script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	