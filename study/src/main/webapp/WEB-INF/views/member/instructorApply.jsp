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
<style>
div#userId-container span.guide {
	display: none;
	font-size: 12px;
	position: absolute;
	top: 12px;
	right: 10px;
}
span.pwd {
	display: none;
	font-size: 12px;
	position: absolute;
	top: 12px;
	right: 10px;
}
div#userId-container span.ok {
	color: green;
}
div#userId-container span.error {
	color: red;
}
</style>
</head>
<body>
	<script>
	$(function () {
		
			/* 파일 업로드 */
		$("#upFile").change( function() {
			var ext = $("input:file").val().split(".")
					.pop().toLowerCase();
			if (ext.length > 0) {
				if ($.inArray(ext, [ "gif", "png", "jpg","jpeg" ]) == -1) {
					alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
					return false;
				}
			}
			console.log(ext);
			var data = new FormData();
			var upFile = document.getElementById("upFile").files[0];
			data.append("upFile", upFile);
			$.ajax({
				url : "memberImgUpload.do",
				data : data,
				contentType : false,
				processData : false,
				type : "POST",
				dataType : "json",
				success : function(date) {
					var html = "";
					html += "<img class ='call_img'   src='${pageContext.request.contextPath }/resources/upload/member/"+date.renamedFileName+"'>";
					$("#div-img-ik").before(html);
					$("#mprofile").val(
							date.renamedFileName)
					$(".fa").on(
							"click",
							function() {
								$(this).parent()
										.remove();
							});
				},
				error : function(jqxhr, textStatus,
						errorThrown) {
					console.log(jqxhr);
					console.log(textStatus);
					console.log(errorThrown);
				},
				cache : false,
				processData : false
			});
			});
		});
		
		function validate() {
			
			/* 이메일  */
			var email = $("#email").val();
			var emailaddr = $("#emailaddr");
			if (emailaddr.val().search(/[.]/g) == -1) {
				alert("이메일 형식이 바르지 않습니다.");
				emailaddr.focus();
				return false;
			}
			var checkPoint = $("#checkPoint").val();
			if (checkPoint == 0) {
				alert("이메일 인증을 바랍니다");
				emailaddr.focus();
				return false;
			}
			/* 생년월일  */
			var year = $("#year");
			var month = $("#month");
			var day = $("#day");
			if (year.val().trim().length != 4) {
				alert("생년월일을 다시 입력하세요.");
				year.focus();
				return false;
			}
			if (month.val().trim().length == 0) {
				alert("생년월일을 다시 입력하세요.");
				year.focus();
				return false;
			}
			if (day.val().trim().length == 0) {
				alert("생년월일을 다시 입력하세요.");
				year.focus();
				return false;
			}
			return true;
		}
		/* 이메일 인증 번호 전송 */
		function fn_certification() {
			var email = $("#email").val();
			var emailaddr = $("#emailaddr").val();
			if (email.trim().length == 0) {
				alert("이메일을 입력하세요.");
				email.focus();
			}
			if (emailaddr.trim().length == 0) {
				alert("이메일을 입력하세요.");
				emailaddr.focus();
			}
			if (emailaddr.search(/[.]/g) == -1) {
				alert("이메일 형식이 바르지 않습니다.");
				emailaddr.focus();
			}
			if(emailaddr.search(/[@]/g) >0){
				alert("이메일 형식이 바르지 않습니다.");
				emailaddr.focus();
			}
			var data = new FormData();
			var em = email + "@" + emailaddr;
			var mno = $("#mno").val();
			console.log(mno);
			data.append("em", em);
			data.append("mno", mno);
			alert("인증번호 전송");
			$.ajax({
				url : "instructorCertification.do",
				data : data,
				contentType : false,
				processData : false,
				type : "POST",
				dataType : "json",
				success : function(date) {
					if(date.check==true){
					$("#checkcertification").val(1);
					}else{
					alert("인증번호 전송실패");
					}
				},
				error : function(jqxhr, textStatus, errorThrown) {
					alert("인증번호 전송실패");
					console.log(jqxhr);
					console.log(textStatus);
					console.log(errorThrown);
				},
				cache : false,
				processData : false
			});
		}
		
		/* 이메일 인증번호 확인 */
		function checkJoinCode() {
			var email = $("#email").val();
			var emailaddr = $("#emailaddr").val();
			var inputCode = $("#inputCode").val();
			var checkcertification = $("#checkcertification").val();
			if (email.trim().length == 0) {
				alert("이메일을 입력하세요.");
				email.focus();
			}
			if (emailaddr.trim().length == 0) {
				alert("이메일을 입력하세요.");
				emailaddr.focus();
			}
			if(checkcertification ==0){
				alert("이메일을 인증을 먼저 하세요.");
				emailaddr.focus();
			}
			var data = new FormData();
			var em = email + "@" + emailaddr;

			data.append("em", em);
			data.append("inputCode", inputCode)
			$.ajax({
				url : "checkJoinCode.do",
				data : data,
				contentType : false,
				processData : false,
				type : "POST",
				dataType : "json",
				success : function(date) {
					console.log(data.result);
					if (date.result == true) {
						$("#checkPoint").val(1);
						alert("이메일 인증을 성공했습니다.")
					} else {
						$("#checkPoint").val(0);
						alert("이메일 인증을 실패했습니다.")
					}
				},
				error : function(jqxhr, textStatus, errorThrown) {
					alert("이메일 인증을 실패했습니다.")
					console.log(jqxhr);
					console.log(textStatus);
					console.log(errorThrown);
				},
				cache : false,
				processData : false
			});
		}
		
		$(function(){
			//kind 리스트를 가져와 select 만듦. 프로그래밍, 회화, 운동 등등..
			 $.ajax({
				url:"selectKind.do",
				dataType:"json",
				success:function(data){
					var html="<option>선택하세요</option>";
					for(var index in data){
						html +="<option value='"+data[index].KNO+"'>"+data[index].KINDNAME+"</option><br/>";
					}
					$("select#kind").html(html);
					
				},error:function(){
					
				}
			}); 	
			
			//subject를 선택하면 해당하는 과목들을들을 가져와 리스트를 생성한다.
			 $("select#kind").on("change",function(){
				$.ajax({
					url:"selectSubject.do",
					dataType:"json",
					data:{kno:$("select#kind option:selected").val()},
					success:function(data){
						var html="";
						for(var index in data){
							html +="<option value='"+data[index].SUBNO+"'>"+data[index].SUBJECTNAME+"</option><br/>";
						}
						$("select#subject").html(html);
						
					},error:function(){
						
					}
				});
			});
		});
	</script>

	<div id="enroll-container">
		<form action="instructorApplyEnd.do" method="post" name='mainForm' id='mainForm'
			onsubmit="return validate();" enctype="multipart/form-data">
		
		<input type="text" name="mno" id="mno" value="42" />  
		<input type="text" name="mid" id="mno" value="jjsk109" />  
			프로필사진 : <input type="file" name="upFile" id="upFile" /> 
			<input type='hidden' name='mprofile' id="mprofile" value='no'>
			<div id="div-img-ik"></div>
			<br />
			포트폴리오 : <input type="file" name="psFile" required/> <br />
			자기소개서 : <input type="file" name="psFile" required/> 
			<div class="form-check-inline form-check">
				관심분야 : &nbsp;
				<select name="kno" id="kind" required> <!-- ajax로 kind가져오기 -->
				</select>&nbsp;&nbsp;&nbsp;
				<select name="sno" id="subject" required> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
				</select>
			</div>

			<br /> 자기소개 <br />
			<textarea rows="10" cols="50" name="cover"></textarea>
			 
			<input type="text" name="email" id="email" placeholder="이메일" required  autocomplete="off"  /> @ 
			<input type="text" name="email" id="emailaddr" placeholder="직접입력" required  autocomplete="off"  />
			<input type="button" value="인증번호" onclick="fn_certification();" /> 
			<input type="hidden" id="checkcertification" value="0" /> 
			<input type="text" id="inputCode" placeholder="인증번호를 입력하세요" required autocomplete="off"/>
			
			<input type="button" value="확인" onclick="checkJoinCode();" /> 
			<br />
			<button type="button" onclick="location.href='${pageContext.request.contextPath}'">취소</button>
			<input type="submit" value="가입" />
		</form>

	</div>
</body>
</html>