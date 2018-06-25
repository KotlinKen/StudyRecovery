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
	font-size: 15px;
	position: absolute;
	right: 10px;
}
span.guide.ok {color: green;}
span.guide.error{color: red;}
span#pwd {
	font-size: 15px;
	position: relative;
	left: 70%;
	top : -50px;
	color: red;
}
span#pwdok {
	font-size: 15px;
	position: relative;
	left: 70%;
	top : -50px;
	color: green;
}
span#pwd2 {
	font-size: 15px;
	position: relative;
	left: 70%;
	top : -50px;
	color: red;
}
span#pwd2ok {
	font-size: 15px;
	position: relative;
	left: 70%;
	top : -50px;
	color: green;
}
div{width: 600px; min-height: 25px;margin: auto; background: rgb(255, 255, 255);}
div#indivik{margin: auto;}
div#inindivik1{ background: rgb(230, 230, 230)}
div#inindivik2{margin: auto; text-align: center; background: rgb(230, 230, 230)}
div#inindivik3{width: 450px; margin: auto; text-align: center; }
div#headerdivik{margin: auto; text-align: center;}
div#id-password-div-ik{position: relative; top: 0px; left: 0%; width: 100%; height: 100%}
div#choos-ik{border-radius: 5px;}
div#name-phone-email-gender-div-ik{border-radius: 10px;}
div.blank-ik{background: rgb(230, 230, 230); height: 5px;}
#buttona{position: relative; left: 20px;}
#buttonb{position: relative; left: 71%;}
body {background: rgb(230, 230, 230)}
#indivik{border-radius: 5px; border: solid 3px rgb(200, 200, 200); }
#headaik{color: black;}
input[type=text] {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: none;
    border-bottom: 1px solid #cccccc;
}
input[type=password] {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: none;
    border-bottom: 1px solid #cccccc;
}
input[type=date] {
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: none;
    border-bottom: 1px solid #cccccc;
}
#email{ width: 30%;}#userId_{width: 60%}#emailaddr{width: 50%}#submit{width: 100%; position: relative; top: 10px;}#inputCode{width: 40%;}
.jender {
    position: relative;
    z-index: 10;
    display: block;
    float: left;
    width: 49.8%;
    height: 31px;
    border-right: solid 1px #dcdcdc;
}
.jender input {
    position: absolute;
    z-index: 9;
    top: 0;
    left: 0;
    width: 100%;
    height: 31px;
}
.jender label {
    line-height: 32px;
    position: absolute;
    z-index: 10;
    top: 0;
    left: 0;
    display: block;
    width: 100%;
    height: 31px;
    cursor: pointer;
    text-align: center;
    color: #8e8e8e;
    background: #fff;
}
.jender input:checked+label {
    z-index: 100;
    margin: -1px;
    color: black;
    border: solid 1px #cccccc;
    box-shadow:2px 2px #b3b3b3;
}
textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    resize: vertical;
}
.category {
   position: relative;
    z-index: 10;
    display: inline-block;
    float: left;
    width: 20%;
    height: 31px;
    border-right: solid 1px #dcdcdc;
}
.category input {
    position: fixed;
    display:inline;
    top: 0;
    left: 0;
    width: 0%;
    height: 0%;
}
.category label {
    line-height: 32px;
    position: relative;
    z-index: 10;
    top: 0;
    left: 20px;
    display: block;
    width: 100%;
    height: 31px;
    cursor: pointer;
    text-align: center;
    color: #8e8e8e;
    background: #fff;
    text-align: center;
}
.category input:checked+label {
    z-index: 100;	
    color: #08a600;
    border: solid 1px #08a600;
}
#div-img-ik{width: 280px;height: 320px; border: solid 1px #8e8e8e; margin-left: 5px;}
.call_img{width: 100%;height: 100%; position: relative;}
</style>
</head>
<body>
	<script>
		$(function() {
			/* 패스워드 */
			$("#password_").blur(function() {
				var p1 = $("#password_");
				var p2 = $(this).val();
				if(p1.val().trim().length ==0){
					 document.getElementById("pwd").innerHTML = "패스워드를 입력하세요";
					p1.focus();
					return;
				}
					
				if (p1.val().trim().length < 8) {
					document.getElementById("pwd").innerHTML = "사용불가";
					password.focus();
					return;
				}
				if (p1.val().indexOf(" ") >= 0) {
					document.getElementById("pwd").innerHTML = "사용불가";
					password.focus();
					return;
				}
				if (p1.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) >= 0) {
					document.getElementById("pwd").innerHTML = "사용불가";
					password.focus();
					return;
				}
			
				if (p1.val().search(/[!@#$%^&*()?_+~]/g) == -1) {
					document.getElementById("pwd").innerHTML = "사용불가";
					password.focus();
					return;
				} 
			  
				if (p1.val().search(/[0-9]/g) == -1) {
					document.getElementById("pwd").innerHTML = "사용불가";
					password.focus();
					return;
				}
				document.getElementById("pwd").innerHTML = "";
				document.getElementById("pwdok").innerHTML = "사용가능";
			});
			$("#password2").blur(function() {
				var p1 = $("#password_").val();
				var p2 = $(this).val();
				
				if(p1.trim().length==0){
					document.getElementById("pwd2").innerHTML = "패스워드를 입력하세요.";
					$("#pwdDuplicateCheck").val(0);
					$("#password_").focus();
					return;
				}
				
				if (p1 != p2) {
					document.getElementById("pwd2").innerHTML = "패스워드가 다릅니다.";
					$("#pwdDuplicateCheck").val(0);
					$("#password_").focus();
				} else {
					document.getElementById("pwd2").innerHTML = "패스워드가 동일합니다.";
					$("#pwdDuplicateCheck").val(1);
				}
			});
			/* 아이디 */
			$("#userId_").on("keyup", function() {
				var userId = $(this).val().trim();
				if (userId.length > 11)
					alert("아이디가 너무 김니다.")
			});
			/* 파일 업로드 */
			$("#upFile").change(
			function() {
				var ext = $("input:file").val().split(".")
						.pop().toLowerCase();
				if (ext.length > 0) {
					if ($.inArray(ext, [ "gif", "png", "jpg",
							"jpeg" ]) == -1) {
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
						$("#div-img-ik").html(html);
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
		function fn_checkID() {
			var userId = $("#userId_").val().trim();
			if (userId.length < 4) {
				alert("아이디는 4글자 이상 입니다.");
				userId.focus();
				return;
			}
			if (userId.length > 11) {
				alert("아이디는 10글자 이하 입니다.");
				userId.focus();
				return;
			}
			if (userId.indexOf(" ") >= 0) {
				alert("아이디는 공백을 사용할 수 없습니다");
				userId.focus();
				return;
			}
			if (userId.search(/[!@#$%^&*()?_~]/g) >= 0) {
				alert("아이디는 특수문자를 사용할 수 없습니다");
				userId.focus();
				return;
			}
			if (userId.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) >= 0) {
				alert("아이디는 한글을 사용할 수 없습니다");
				userId.focus();
				return;
			}
			$.ajax({
				url : "checkIdDuplicate.do",
				data : {
					userId : userId
				},
				dataType : "json",
				success : function(data) {
					console.log(data);
					if (data.isUsable == true) {
						$(".guide.ok").show();
						$(".guide.error").hide();
						$("#idDuplicateCheck").val(1);
					} else {
						$(".guide.error").show();
						$(".guide.ok").hide();
						$("#idDuplicateCheck").val(0);
					}
				},
				error : function(jqxhr, textStatus, errorThrown) {
					console.log("ajax실패", jqxhr, textStatus, errorThrown);
				}
			});
		}
		function validate() {
			/* id */
			var userId = $("#userId_");
			if (userId.val().trim().length < 4) {
				alert("아이디는 최소4자이이상이어야합니다");
				userId.focus();
				return false;
			}
			if (userId.val().trim().length > 11) {
				alert("아이디는 최소11자이이하이어야합니다");
				userId.focus();
				return false;
			}
			if (userId.val().indexOf(" ") >= 0) {
				alert("아이디는 공백을 사용할 수 없습니다");
				userId.focus();
				return false;
			}
			if (userId.val().search(/[!@#$%^&*()?_~]/g) >= 0) {
				alert("아이디는 특수문자를 사용할 수 없습니다");
				userId.focus();
				return false;
			}
			if (userId.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) >= 0) {
				alert("아이디는 한글을 사용할 수 없습니다");
				userId.focus();
				return false;
			}
			var idcheck = $("#idDuplicateCheck").val();
			if (idcheck == 0) {
				alert("아이디가 확인 하세요.");
				userId.focus();
				return false;
			}
			/* password */
			var password = $("#password_");
			var pwdcheck = $("#pwdDuplicateCheck").val();
			if (password.val() == userId.val()) {
				alert("아이디와 패스워드가 동일합니다.");
				password.focus();
				return false;
			}
			if (password.val().trim().length < 8) {
				alert("패스워든는 8글자보다 작습니다");
				password.focus();
				return false;
			}
			if (password.val().indexOf(" ") >= 0) {
				alert("패스워드는 공백을 사용할 수 없습니다");
				password.focus();
				return false;
			}
			if (password.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) >= 0) {
				alert("패스워드는 한글을 사용할 수 없습니다");
				password.focus();
				return false;
			}
		
			if (password.val().search(/[!@#$%^&*()?_+~]/g) == -1) {
				alert(password.val()+"패스워드는 특수문자를 사용해야 합니다.");
				password.focus();
				return false;
			} 
		  
			if (password.val().search(/[0-9]/g) == -1) {
				alert("패스워드는 숫자를 사용해야 합니다.");
				password.focus();
				return false;
			}
			if (pwdcheck == 0) {
				alert("비밀번호가 일치하지 않습니다");
				password.focus();
				return false;
			}
			var name = $("#name");
			if (name.val().trim().length < 2) {
				alert("이름을 2글자 이상 입력해 주세요.");
				name.focus();
				return false;
			}
			if (name.val().trim().indexOf(" ") >= 0) {
				alert("이름을에 공백을  사용할 수 없습니다.");
				name.focus();
				return false;
			}
			if (name.val().search(/[!@#$%^&*()?_~]/g) != -1) {
				alert("이름에 특수 문자를 입력할 수 없습니다.");
				name.focus();
				return false;
			}
			if (name.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ]/g) != -1) {
				alert("이름에 온전한 한글을 입력해 주세요.");
				name.focus();
				return false;
			}
			if (name.val().search(/[a-z|A-Z]/g) != -1) {
				alert("이름에 영어를 입력할 수 없습니다..");
				name.focus();
				return false;
			}
			if (name.val().search(/[0-9]/g) != -1) {
				alert("이름에 숫자를 입력할 수 없습니다.");
				name.focus();
				return false;
			}
			var phone = $("#phone");
			if (phone.val().search(/[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|!@#$%^&*()?_~]/g) != -1) {
				alert("전화번호는 숫자만 가능합니다.");
				phone.focus();
				return false;
			}
			if (phone.val().trim().length < 9) {
				alert("전화번호를 다시 입력해 주세요.");
				phone.focus();
				return false;
			}
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
	</script>

	<script>
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
			data.append("em", em);
			alert("인증번호 전송");
			$.ajax({
				url : "certification.do",
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
			console.log("em : " + em);
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
					var html="<option>무엇을 가르켜 주시겠어요(필수)?</option>";
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
<div id="inindivik1"></div> 
<div id="inindivik2"><a id="headaik" href="${pageContext.request.contextPath}"><br /><h1>STUDY GROUPT</h1><br /></a></div>
	<div id="enroll-container">
		<form action="instructorEnrollEnd.do"
			method="post" name='mainForm' id='mainForm'
			onsubmit="return validate();" enctype="multipart/form-data">
			<div id="id-password-div-ik">	
				<br />
				<div id="userId-container">
					<input type="text" name="mid" id="userId_" placeholder="아이디(필수)" required autocomplete="off" />
					<button type="button" onclick="fn_checkID();" class="btn btn-outline-secondary">아이디 확인</button>
					<br />
					<div id="check-id">
					<span class="guide ok">중복된 아이디가 없습니다.</span> 
					<span class="guide error">중복된 아이디가 있습니다.</span> 
					</div>
					<input type="hidden" id="idDuplicateCheck" value="0" />
				</div>
				<div>
					<input type="password" name="pwd" id="password_" placeholder="비밀번호(필수)" required autocomplete="off"  /> <br /> 
					<span id="pwd"></span>  
					<span id="pwdok"></span>  
					<input type="password" id="password2" placeholder="비밀번호 확인(필수)"  required autocomplete="off"  /> <br /> 
					<span id="pwd2"></span> 
					<span id="pwd2ok"></span> 
					<input type="hidden" id="pwdDuplicateCheck" value="0" />
				</div>
				<br />
			</div>
			<input type="text" name="mname" id="name" placeholder="이름" required  autocomplete="off"  /><br /> 
			<input type="text" name="phone" id="phone" maxlength="11" placeholder="전화번호" required required autocomplete="off"  /> <br /> 
			<input type="text" name="email" id="email" placeholder="이메일" required  autocomplete="off"  /> @ 
			<input type="text" name="email" id="emailaddr" placeholder="직접입력" required  autocomplete="off"  />
			<input type="button" value="인증번호" onclick="fn_certification();" class="btn btn-outline-secondary"/> 
			<input type="hidden" id="checkcertification" value="0" /> 
			<input type="text" id="inputCode" placeholder="인증번호를 입력하세요" required autocomplete="off"/>
			<input type="button" value="확인" onclick="checkJoinCode();"  class="btn btn-outline-secondary"/> 
			<input type="hidden" id="checkPoint" value="0" /> <br />
			<input type="date" name="birth" required/><br />
			<span class="jender">
			<input type="radio" name="gender" value="M" id="male" checked /> <label for="male">남</label> 
			</span>
			<span class="jender">
			<input type="radio" name="gender" value="F"id="fmale" /> <label for="fmale">여</label> <br /> 
			</span><br /><hr /><br />
			프로필사진(필수) : <input type="file" name="upFile" id="upFile" class="btn btn-outline-secondary"/> 
			<input type='hidden' name='mprofile' id="mprofile" value='no'>
			<div id="div-img-ik"></div>
			<br />
			포트폴리오(필수) : <input type="file" name="psFile" required class="btn btn-outline-secondary"/> <br />
			자기소개서(필수) : <input type="file" name="psFile" required class="btn btn-outline-secondary"/> 
			<div class="form-check-inline form-check">
				<select name="kno" id="kind" class="custom-select my-1 mr-sm-2" required> <!-- ajax로 kind가져오기 -->
				</select>&nbsp;&nbsp;&nbsp;
				<select name="sno" id="subject" class="custom-select my-1 mr-sm-2" required> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
				</select>
			</div>

			<br />  <br />
			<textarea rows="10" cols="50" name="cover"placeholder="강사님 당신을 소개 하세요 모두가 알 수 있도록...(필수)" ></textarea>

			<br />
			<%-- <button type="button" onclick="location.href='${pageContext.request.contextPath}'">취소</button> --%>
			<input type="submit" id="submit" value="가입하기" class="btn btn-outline-secondary"/>
		</form>
		<br />
		<br />

	</div>
</body>
</html>