<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="${rootPath }/resources/js/jquery-3.3.1.js"></script>
<script src="${rootPath}/resources/js/member/enroll.js"></script>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />

<style>
	.find{
		padding-top: 5%;
		padding-bottom: 5%;
		padding-left: 33%;
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
	input[type=password] {
	    width: 100%;
	    padding: 12px 20px;
	    margin: 8px 0;
	    box-sizing: border-box;
	    border: none;
	    border-bottom: 1px solid #cccccc;
	}
</style>
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="비밀번호 변경" name="pageTitle"/>
	</jsp:include>
	<c:if test="${memberLoggedIn==null }">
		<form class="find" action="${pageContext.request.contextPath }/member/memberUpdatePwd.do" method="post" onsubmit="return pwdDuplicateCheck();">
			<table class="id-pwd">
				<tr class="id-pwd">
					<td class="id-pwd">
						<input type="password" name="pwd" id="password_" maxlength="15" placeholder="비밀번호" required autocomplete="off"  />
						<span id="pwd"></span>  
						<span id="pwdok"></span>  
					</td>
				</tr>
				<tr class="id-pwd">
					<td class="id-pwd">
						<input type="password" id="password2"  placeholder="비밀번호 확인" required autocomplete="off"  />
						<span id="pwd2"></span> 
						<span id="pwd2ok"></span> 
					</td>
				</tr>
				<tr class="id-pwd">
					<td class="id-pwd">
						<input type="hidden" name="key" value="${key }" />
						<input type="hidden" name="mid" value="${mid }" />
						<input type="hidden" id="pwd-ok" value="1" />
						<button type="submit" class="btncss" id="submit">변경</button>
					</td>
				</tr>
			</table>
			
		</form>
	</c:if>

	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	