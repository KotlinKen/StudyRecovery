
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
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"
	integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm"
	crossorigin="anonymous"></script>
<script src="${rootPath}/resources/js/member/enroll.js"></script>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/enroll.css" /><base>
<style type="text/css">
body { background: #efefef;}
</style>
</head>
<body>
	
<div id="inindivik1"></div> 
		<form action="instructorEnrollEnd.do"
			method="post" name='mainForm' id='mainForm'
			onsubmit="return validate();" enctype="multipart/form-data">
	<div id="enroll-container">
<div id="inindivik2"><a class="navbar-brand rm-custom-brand" href="${rootPath}"><jsp:include page="/WEB-INF/views/common/logo_blue.jsp"></jsp:include></a></div>
			<div id="id-password-div-ik">
				<br />
				<!-- 아이디 -->
				<div id="userId-container">
					<input type="text" name="mid" id="userId_" placeholder="아이디(필수)" maxlength="15" required autocomplete="off" />
					<button type="button" onclick="fn_checkID();" class="btn btn-primary">아이디 확인</button>
					<br />
					<div id="check-id">
					<span class="guide ok"></span> 
					<span class="guide error"></span> 
					</div>
					<input type="hidden" id="idDuplicateCheck" value="0" />
				</div>
				<!-- 패스워드 -->
				<div>
					<input type="password" name="pwd" id="password_" placeholder="비밀번호(필수)"  maxlength="15" required autocomplete="off"  /> <br /> 
					<span id="pwd"></span>  
					<span id="pwdok"></span>  
					<br />
					<input type="password" id="password2" placeholder="비밀번호 확인(필수)"  maxlength="15"  required autocomplete="off"  /> <br /> 
					<span id="pwd2"></span> 
					<span id="pwd2ok"></span> 
					<input type="hidden" id="pwdDuplicateCheck" value="0" />
				</div>
				<br />
				
			</div>
			<div id="name-phone-email-gender-div-ik">
			
			<!-- 이름 -->
			<input type="text" name="mname" id="name" placeholder="이름(필수)"  maxlength="7" required  autocomplete="off"  /><br />
			<span id="nameerr" class="name"></span> 
			<span id="nameok" class="name"></span> <br /> 
			
			<!-- 전화번호 -->
			<input type="text" name="phone" id="phone" maxlength="11" placeholder="전화번호(필수)" required required autocomplete="off"  /> <br /> 
			<span id="phoneerr" class="phone"></span> <br />
			
			<!-- 이메일 -->
			<input type="text" name="email" id="email" placeholder="이메일(필수)" required  maxlength="15"  autocomplete="off"  /> @ 
			<input type="text" name="email" id="emailaddr" placeholder="직접입력" required  maxlength="20"  autocomplete="off"  />
			<input type="button" value="인증번호" onclick="fn_certification();" class="btn btn-primary"/> 
			<input type="hidden" id="checkcertification" value="0" /> <br /><br />
			<input type="text" id="inputCode" placeholder="인증번호를 입력하세요" required autocomplete="off"/>
			<input type="button" value="확인" onclick="checkJoinCode();" class="btn btn-primary" />  <br />
			<span id="countDown"></span>
			<input type="hidden" id="checkPoint" value="0" /> <br />
			
			<!-- 생년월일 -->
			<label for="birth" class="textP">생년월일(필수)</label><input type="date" name="birth" id="birth" required/><br />
				<br />
			<span class="jender">
			<input type="radio" name="gender" value="M" id="male" checked /> <label for="male">남</label> 
			</span>
			<span class="jender">
			<input type="radio" name="gender" value="F"id="fmale" /> <label for="fmale">여</label> <br /> 
			</span><br /><br />
			</div>
			<br />

			<!-- 사진 올리기 -->
			<label for="upFile" class="textP">프로필사진(필수)</label><input type="file" name="upFile" id="upFile" accept="image/*" /> 
				<button type="button" class="btn btn-primary" id="btn_noFile">취소</button> 
			<input type='hidden' name='mprofile' id="mprofile" value='noprofile.jpg' />
			<div id="div-img-ik"></div>
			<br />
			<br />
			
			<!-- 파일 올리기 -->
			<label for="port" class="textP">포트폴리오(필수)</label><input type="file" name="psFile" id="port" required  accept=".txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls"/><br />
			<span  class="card-body text-secondary">.txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls 형식 파일만 가능 합니다.</span><br /><br />
			<label for="self" class="textP">자기소개서(필수)</label><input type="file" name="psFile" id="self" required accept=".txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls" /> <br />
			<span  class="card-body text-secondary">.txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls 형식 파일만 가능 합니다.</span><br /><br />
			
			<!-- 카테고리 설정 -->
			<div class="form-check-inline form-check">
				<label for="kind">카테고리</label>
				<select name="kno" id="kind" class="custom-select"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
					<option value="-1">과목을 선택하세요.</option>
					
					<c:if test="${!empty kindList }">
					<c:forEach var="kind" items="${kindList }" varStatus="vs">
						<option value="${kind.KNO }">${kind.KINDNAME }</option>
					</c:forEach>
					</c:if>
				</select>
				
			</div>

			<br />  <br />
			<textarea rows="10" cols="50"  name="cover"placeholder="자기소개...(필수)" maxlength="1000" style="width:98%" ></textarea>

			<br />
			<%-- <button type="button" onclick="location.href='${pageContext.request.contextPath}'">취소</button> --%>
			<input type="submit" id="submit" value="가입하기" class="btn btn-primary" style="width:98%"/>
			<br /><br />
	</div>
		</form>
		<br />
		<br />

</body>
</html>