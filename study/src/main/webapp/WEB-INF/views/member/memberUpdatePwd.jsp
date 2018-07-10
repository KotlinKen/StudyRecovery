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
	width:33.3%;
	min-width:400px;
	position:relative;
	margin:0 auto;
	}

	.id-pwd{
		background: #ebebee;
		position: relative;
		z-index: 100;
		border-radius: 5px;
		padding:10px;
	}
	input[type=password].pwd {
	    width: 100%;
	    padding: 12px 20px;
	    box-sizing: border-box;
	    border: none;
	    border-bottom: 1px solid #cccccc;
	}
	div#page-all{
		background: #ffffff;
	}
	.spanidpass{
		text-align:center;
		display:block;
		margin:0 auto;
		font-size: 25px;
		min-width: 160px;
		margin-top:20px;
		margin-bottom:20px;
		width:33.3%;
		position: relative;
	}
	
	.find table.rm_touchTable{
		padding:30px;
	}
</style>
<div id="page-all" >
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="비밀번호 변경" name="pageTitle"/>
	</jsp:include>
	<div class="container">
	<c:if test="${memberLoggedIn==null }">
		<span id="idServiceLogo" class="spanidpass"><b>비밀번호 변경</b></span>
		<form class="find" action="${pageContext.request.contextPath }/member/memberUpdatePwd.do" method="post" onsubmit="return pwdDuplicateCheck();">
			<table class="id-pwd rm_touchTable">
				<tr class="id-pwd">
					<td class="id-pwd">
						<input type="password" class="pwd" name="pwd" id="password_" maxlength="15" placeholder="비밀번호" required autocomplete="off"  />
						<span id="pwd"></span>  
						<span id="pwdok"></span>  
					</td>
				</tr>
				<tr class="id-pwd">
					<td class="id-pwd">
						<input type="password" class="pwd" id="password2"  placeholder="비밀번호 확인" required autocomplete="off"  />
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
</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</div>