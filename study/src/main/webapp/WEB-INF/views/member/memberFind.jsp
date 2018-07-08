<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="${rootPath }/resources/js/jquery-3.3.1.js"></script>
<script src="${rootPath}/resources/js/member/enroll.js"></script>
<%-- <script src="${rootPath}/resources/js/member/find.js"></script> --%>
<!-- 테이블 css -->
<%-- <link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" /> --%>

<style>
	.find{
		padding: 15px;
	}
	span.name{
		position: relative;
		top: 0;
		left: 0;
		z-index: 1000;
	}
	span#nameok{
		color: green;
	}
	span#nameerr{
		color: red;		
	}
	table.id-pwd{
		width: 100%;
		/*height: 20%; */
		/* position: relative;
		top: 25px; */
		
		left: -80px;
		z-index: 100; 
		
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
	    border-bottom: 1.5px solid #0000ff;
	    background: #f8f9fb;
	}
	input[type=text] {
	    width: 100%;
	    padding: 12px 20px;
	    margin: 8px 0;
	    box-sizing: border-box;
	    border: none;
	    border-bottom: 1.5px solid #0000ff;
	    background: #f8f9fb;
	}
	#findid{
		width: 300px; 
		margin-left:-60px;
		margin-right:7.5%;
		margin-bottom:1%;
		margin-top:5%;
	}
	#findpwd{
		width: 300px; 
		margin-left:-60px;
		margin-right:7.5%;
		margin-bottom:1%;
		margin-top:5%;
	}
	div.page{
		width: 500px;
		height: 500px;
		/* position: relative;
		left:35%; */
		margin:auto;
		top:0;
		background: #f8f9fb;
		
	}
	#idServiceLogo{
	font-size: 25px;
	width: 100px;
	}
	.blank-div{
	height: 50px;
	width: 100%;
	padding: 20px;
	text-align: center;
	}
	.buttontd{text-align: center;}
</style>
<div class="page-all">
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="${findType } 찾기" name="pageTitle"/>
	</jsp:include>
	<%
		String findType = String.valueOf(request.getAttribute("findType"));
		System.out.println("아이디?"+findType);
	%>
	<div class="blank-div">	</div>
	<div class="page">
		<c:if test="${mid==null and findType eq '아이디' }">
			<form class="find" action="${pageContext.request.contextPath }/member/memberFindIdPwd.do" onsubmit="return validate();">
			<span id="idServiceLogo"><b>아이디 찾기</b></span>
			<div class="blank-div">	</div>
				<%-- <img src="${rootPath }/resources/upload/member/findid.PNG" alt="아이디 찾기" id="findid"/> --%>
				<table  class="id-pwd">
					<tr  class="id-pwd">
						<td  class="id-pwd">
						<input type="text" name="mname" id="name" placeholder="회원 이름" maxlength="7" autocomplete="off"/>	
						<br /> 
					
						<span id="nameerr" class="name"></span> 
						<span id="nameok" class="name"></span>	<br />
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="email" name="email" id="email" maxlength="30" required placeholder="이메일" autocomplete="off"/>						
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="hidden" name="findType" value="아이디" />
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd buttontd" ><br />
							<input type="submit" class="btn btn-primary" id="submit" value="찾기" />							
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
			<form class="find" action="${rootPath }/member/mailSending.do" method="post" onsubmit="return confirm();">
				<img src="${rootPath }/resources/upload/member/findpwd.PNG" alt="비밀번호 찾기" id="findpwd"/>
				<table  class="id-pwd">
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="text" name="mid" id="mid" placeholder="아이디" autocomplete="off" maxlength="15"/>
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd">
							<input type="email" name="email" id="email" placeholder="이메일" autocomplete="off" maxlength="35"/>
						</td>
					</tr>
					<tr  class="id-pwd">
						<td  class="id-pwd buttontd" >
							<input type="submit" class='btncss' id="submit" value="찾기" />
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
</div>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	