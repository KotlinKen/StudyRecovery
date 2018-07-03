
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
	left: 10px;
}
span.guide.ok {color: green;}
span.guide.error{color: red;}
span#nameok {color: green;}
span#nameerr{color: red;}
span.name{ position: relative;top:0px;left:2%;}
span.phone{ position: relative;top:0px;left:2%;}
span#phoneerr{color: red;}
span#pwd {font-size: 15px;position: absolute;right:2%;top:135px;color:red;}
span#pwdok {font-size:15px;position:absolute;right:2%;top:135px;color:green;}
span#pwd2 {font-size: 15px;position: absolute;right:2%;top:200px;color:red;}
span#pwd2ok {font-size:15px;position:absolute;right:2%;top:200px;color:green;}
div{width: 600px; min-height: 25px;margin: auto; }
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
#email{ width: 30%;}
#userId_{width: 60%}
#emailaddr{width: 50%}
#submit{width: 100%; position: relative; top: 10px;}
#inputCode{width: 40%;}
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
    text-align: center;
}
.category input:checked+label {
    z-index: 100;	
    color: #08a600;
    border: solid 1px #08a600;
}
#sub{display: none}
#div-img-ik{display:none;}
#div-img-ik{width: 280px;min-height: 0px; border: solid 1px #8e8e8e; margin-left: 5px;}
.call_img{width: 100%; position: relative;}
</style>
</head>
<body>
	<script>
		$(function() {
			/* 패스워드 */
			$("#password_").on("keyup",function() {
				var p1 = $("#password_").val();
				if(p1.length>15){
					document.getElementById("pwd").innerHTML = "패스워드가 길어요";
					document.getElementById("pwdok").innerHTML = "";
					$("#password_").val(p1.substr(0,15));
					$("#pwdDuplicateCheck").val(0);
					return;
				}
			});
			$("#password_").blur(function() {
				var p1 = $("#password_");
				var p2 = $(this).val();
				if(p1.val().trim().length ==0){
					 document.getElementById("pwd").innerHTML = "패스워드를 입력하세요";
					 document.getElementById("pwdok").innerHTML = "";
					return;
				}
				if (p1.val() == $("#userId_").val()) {
					document.getElementById("pwd").innerHTML = "아이디와 비번이 동일합니다.";
					document.getElementById("pwdok").innerHTML = "";
					return false;
				}
				if (p1.val().trim().length < 8) {
					document.getElementById("pwd").innerHTML = "비밀 번호는 8글자 이상 입니다.";
					document.getElementById("pwdok").innerHTML = "";
					return;
				}
				if (p1.val().indexOf(" ") >= 0) {
					document.getElementById("pwd").innerHTML = "공백은 사용 할 수 없습니다.";
					document.getElementById("pwdok").innerHTML = "";
					return;
				}
				if (p1.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) > 0) {
					document.getElementById("pwd").innerHTML = "한글은 사용할 수 없습니다.";
					document.getElementById("pwdok").innerHTML = "";
					return;
				}
				if (p1.val().search(/[-＃＆　!@#$%^&*()?_+~]/g) == -1) {
					document.getElementById("pwd").innerHTML = "특수문자 1개 이상 입니다.";
					document.getElementById("pwdok").innerHTML = "";
					return;
				} 
				if (p1.val().search(/[0-9]/g) == -1) {
					document.getElementById("pwd").innerHTML = "숫자 1개 이상 입니다.";
					document.getElementById("pwdok").innerHTML = "";
					return;
				}
				document.getElementById("pwd").innerHTML = "";
				document.getElementById("pwdok").innerHTML = "사용가능";
			});
			/* 패스워드 확인  */
			$("#password2").on("keyup",function() {
				var p1 = $("#password_").val();
				var p2 = $(this).val();
				if(p2.length>15){
					document.getElementById("pwd2").innerHTML = "패스워드가 길어요";
					document.getElementById("pwd2ok").innerHTML = "";
					$("#password2").val(p2.substr(0,15));
					$("#pwdDuplicateCheck").val(0);
					return;
				}
				if(p2.trim().length>15){
					document.getElementById("pwd2").innerHTML = "패스워드가 길어요";
					document.getElementById("pwd2ok").innerHTML = "";
					$("#password2").val(p2.substr(0,15));
					$("#pwdDuplicateCheck").val(0);
					return;
				}
				if (p1 != p2) {
					document.getElementById("pwd2").innerHTML = "패스워드가 다릅니다.";
					document.getElementById("pwd2ok").innerHTML = "";
					$("#pwdDuplicateCheck").val(0);
				} else {
					document.getElementById("pwd2").innerHTML = "";
					document.getElementById("pwd2ok").innerHTML = "패스워드가 동일합니다.";
					$("#pwdDuplicateCheck").val(1);
				}
			});
			$("#password2").blur(function() {
				var p1 = $("#password_").val();
				var p2 = $(this).val();
				if(p1.trim().length==0){
					document.getElementById("pwd2").innerHTML = "패스워드를 입력하세요.";
					document.getElementById("pwd2ok").innerHTML = "";
					$("#pwdDuplicateCheck").val(0);
					return;
				}
				if (p1 != p2) {
					document.getElementById("pwd2").innerHTML = "패스워드가 다릅니다.";
					document.getElementById("pwd2ok").innerHTML = "";
					$("#pwdDuplicateCheck").val(0);
				} else {
					document.getElementById("pwd2").innerHTML = "";
					document.getElementById("pwd2ok").innerHTML = "패스워드가 동일합니다.";
					$("#pwdDuplicateCheck").val(1);
				}
			});
			/* 아이디 */
			$("#userId_").on("keyup", function() {
				var userId = $("#userId_");
				if (userId.val().trim().length > 10){
					var d = userId.val().substr(0,10);
					console.log(d);
					userId.val(d);
					alert("글자 수는 11 미만 입니다.")
					userId.focus();
					return;			
				}
			});  
			/* 파일 업로드 */
			$("#upFile").change(function() {
				var ext = $("input:file").val().split(".").pop().toLowerCase();
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
						$("#div-img-ik").css({"display":"inline-block"});
						$("#mprofile").val(date.renamedFileName)
					
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
			$("#port").change(function() {
				var ext = $("#port").val().split(".").pop().toLowerCase();
				if (ext.length > 0) { 
					if ($.inArray(ext, [ "txt", "hwp", "docx","pptx" ,"ppt","xls","xlsx"]) == -1) {
						alert("txt,hwp,docx,pptx,ppt,xlsx,xlsx 파일만 업로드 할수 있습니다.");
						$("#port").val("");
						return false;
					}
				}
			});
			$("#self").change(function() {
				var ext = $("#self").val().split(".").pop().toLowerCase();
				if (ext.length > 0) { 
					if ($.inArray(ext, [ "txt", "hwp", "docx","pptx" ,"ppt","xls","xlsx"]) == -1) {
						alert("txt,hwp,docx,pptx,ppt,xlsx,xlsx 파일만 업로드 할수 있습니다.");
						$("#self").val("");
						return false;
					}
				}
			});
			/* 이름 검사 */
			$("#name").blur(function() {
				var name = $("#name");
				if(name.val().trim().length ==0){
					 document.getElementById("nameerr").innerHTML = "이름를 입력하세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val("");
					return;
				}
				if (name.val().trim().length > 7) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val("");
					return;
				}
				if (name.val().indexOf(" ") >= 0) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val("");
					return;
				}
				if (name.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ]/g) != -1 ) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val("");
					return;
				}
				if (name.val().search(/[-＃＆　!@#$%^&*()?_+~]/g)  != -1) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val("");
					return;
				} 
				if (name.val().search(/[0-9]/g)  != -1) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val("");
					return;
				}
				if (name.val().search(/[a-z|A-Z]/g) != -1) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#name").val(""); 
					return;
				}
				document.getElementById("nameerr").innerHTML = "";
				document.getElementById("nameok").innerHTML = "ok";
			});
			$("#name").click(function() {
				document.getElementById("nameerr").innerHTML = "";
			});
			/* 전화번호 */
			$("#phone").on("keyup",function(){
				var phone = $("#phone").val();
				console.log(phone);
				if(phone.indexOf(" ")>0){
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "공백은 사용 할 수 없습니다";
					return;
				}
				if(phone.search(/[a-z|A-Z]/g) != -1){
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "숫자 만 사용 할 수 없습니다";
					return;
				}
				if(phone.search(/[-＃＆　!@#$%^&*()?_+~]/g) != -1){
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "숫자 만 사용 할 수 없습니다";
					return;
				}
				if(phone.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) != -1){
					console.log(phone.length-1)
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "숫자 만 사용 할 수 없습니다";
					return;
				}
				document.getElementById("phoneerr").innerHTML = "";
				
			});
		 $("#phone").blur(function(){
				var phone = $("#phone").val();
				if(phone.trim()==0){
					document.getElementById("phoneerr").innerHTML = "전화번호를 입력 하세요";
					$("#phone").val("");
					return;
				}
				if(phone.trim()<8){
					document.getElementById("phoneerr").innerHTML = "전화번호를 입력 하세요";
					$("#phone").val("");
					return;
				}
				if(phone.indexOf(" ")>0){
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "공백은 사용 할 수 없습니다";
					return;
				}
				if(phone.search(/[a-z|A-Z]/g) != -1){
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "숫자 만 사용 할 수 없습니다";
					return;
				}
				if(phone.search(/[-＃＆　!@#$%^&*()?_+~]/g) != -1){
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "숫자 만 사용 할 수 없습니다";
					return;
				}
				if(phone.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) != -1){
					console.log(phone.length-1)
					$("#phone").val(phone.substr(0,phone.length-1));
					document.getElementById("phoneerr").innerHTML = "숫자 만 사용 할 수 없습니다";
					return;
				}
				document.getElementById("phoneerr").innerHTML = "";
			}); 
		 
		 $("#userId_").click(function(){
				$(".guide.error").hide();
				$(".guide.ok").hide();
				$("#idDuplicateCheck").val(0);
			});
			$("#userId_").blur(function(){
				fn_checkID();
			});
			$("#password_").click(function(){
				 document.getElementById("pwd").innerHTML = "";
				 document.getElementById("pwdok").innerHTML = "";
			});
			$("#password2").click(function(){
				 document.getElementById("pwd2").innerHTML = "";
				 document.getElementById("pwd2ok").innerHTML = "";
			});
			$("#phone").click(function(){
				 document.getElementById("phoneerr").innerHTML = "";
			});
		});
		/* 아이디 확인  */
		function fn_checkID() {
			var userId = $("#userId_");
			console.log(userId.val().trim().length);
			if (userId.val().trim().length < 4) {
				$(".guide.error").html("아이디는 4글자 이상 입니다.");
				$(".guide.error").show();
				$(".guide.ok").hide();
				return;
			}
			if (userId.val().trim().length > 11) { 
				$(".guide.error").html("아이디는 10글자 이하 입니다.");
				$(".guide.error").show();
				$(".guide.ok").hide();
				return;
			}
			if (userId.val().indexOf(" ") >= 0) {
				userId.val(userId.val().trim());
				$(".guide.error").html("아이디는 공백을 사용할 수 없습니다");
				$(".guide.error").show();
				$(".guide.ok").hide();
				return;
			}
			if (userId.val().search(/[-＃＆　!@#$%^&*()?_~]/g) >= 0) {
				$(".guide.error").html("아이디는 특수문자를 사용할 수 없습니다");
				$(".guide.error").show();
				$(".guide.ok").hide();
				return;
			}
			if (userId.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) >= 0) {
				$(".guide.error").html("아이디는 한글을 사용할 수 없습니다");
				$(".guide.error").show();
				$(".guide.ok").hide();
				return;
			}
			if(userId.val().search(/[a-z|A-Z]/g)==-1){
				$(".guide.error").html("숫자만 입력하면 안됩니다.");
				$(".guide.error").show();
				$(".guide.ok").hide();
				return;
			}
			
			$.ajax({
				url : "checkIdDuplicate.do",
				data : {userId : userId.val()},
				dataType : "json",
				success : function(data) {
					console.log(data);
					if (data.isUsable == true) {
						$(".guide.ok").html("사용가능");
						$(".guide.ok").show();
						$(".guide.error").hide();
						$("#idDuplicateCheck").val(1);
					} else {
						$(".guide.error").html("아이디가 중복 됩니다.");
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
			if (userId.val().search(/[-＃＆　!@#$%^&*()?_~]/g) >= 0) {
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
				alert("아이디를 확인 하세요.");
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
		
			if (password.val().search(/[-＃＆　!@#$%^&*()?_+~]/g) == -1) {
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
			/* name */
			var name = $("#name");
			if (name.val().trim().length < 2) {
				alert("이름을 2글자 이상 입력해 주세요.");
				name.focus();
				return false;
			}
			if (name.val().trim().length > 7) {
				alert("이름을 2글자 이상 입력해 주세요.");
				name.focus();
				return false;
			}
			if (name.val().indexOf(" ") >= 0) {
				alert("이름을에 공백을  사용할 수 없습니다.");
				name.focus();
				return false;
			}
			if (name.val().search(/[-＃＆　!@#$%^&*()?_~]/g) != -1) {
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
			/* phone */
			var phone = $("#phone");
			if (phone.val().search(/[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|-＃＆　!@#$%^&*()?_~]/g) != -1) {
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
			
			var kind = $("#kind");
			if(kind.val() == -1){
				kind.focus();
				return false;
			}
			var sno = $("#sub");
			if(sno.val()==-1){
				sno.focus();
				return false;
			}
			var port = $("#port");
			if(port.val()== ""){
				port.focus();
				return false;
			}
			var self = $("#self");
			if(self.val()== ""){
				self.focus();
				return false;
			}
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
			 $("#kind").on("change", function(){
				var kindNo = $("option:selected", this).val();
				console.log()
				if(kindNo == ""){
					$("#sub").hide();
					return;
				}
				$("#sub").show();
				$.ajax({
					url: "selectSubject.do",
					data: {kindNo : kindNo},
					dataType: "json",
					success : function(data){
						var html="<option value='-1'>세부 과목을 선택하세요</option>";
						
						for(var index in data){
							html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option></br>";
						}
						
						$("#sub").html(html);
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
				<!-- 아이디 -->
				<div id="userId-container">
					<input type="text" name="mid" id="userId_" placeholder="아이디(필수)" maxlength="15" required autocomplete="off" />
					<button type="button" onclick="fn_checkID();" class="btn btn-outline-secondary">아이디 확인</button>
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
					<input type="password" id="password2" placeholder="비밀번호 확인(필수)"  maxlength="15"  required autocomplete="off"  /> <br /> 
					<span id="pwd2"></span> 
					<span id="pwd2ok"></span> 
					<input type="hidden" id="pwdDuplicateCheck" value="0" />
				</div>
				<br />
				
			</div>
			<div id="name-phone-email-gender-div-ik">
			
			<!-- 이름 -->
			<input type="text" name="mname" id="name" placeholder="이름(필수)"  maxlength="7" required  autocomplete="off"  />
			<span id="nameerr" class="name"></span> 
			<span id="nameok" class="name"></span> <br /> 
			
			<!-- 전화번호 -->
			<input type="text" name="phone" id="phone" maxlength="11" placeholder="전화번호(필수)" required required autocomplete="off"  /> <br /> 
			<span id="phoneerr" class="phone"></span> <br />
			
			<!-- 이메일 -->
			<input type="text" name="email" id="email" placeholder="이메일(필수)" required  maxlength="15"  autocomplete="off"  /> @ 
			<input type="text" name="email" id="emailaddr" placeholder="직접입력" required  maxlength="20"  autocomplete="off"  />
			<input type="button" value="인증번호" onclick="fn_certification();" class="btn btn-outline-secondary"/> 
			<input type="hidden" id="checkcertification" value="0" /> 
			<input type="text" id="inputCode" placeholder="인증번호를 입력하세요" required autocomplete="off"/>
			<input type="button" value="확인" onclick="checkJoinCode();" class="btn btn-outline-secondary" /> 
			<input type="hidden" id="checkPoint" value="0" /> <br />
			
			<!-- 생년월일 -->
			<input type="date" name="birth" required/><br />
			<span class="jender">
			<input type="radio" name="gender" value="M" id="male" checked /> <label for="male">남</label> 
			</span>
			<span class="jender">
			<input type="radio" name="gender" value="F"id="fmale" /> <label for="fmale">여</label> <br /> 
			</span><br /><br />
			</div>
			<div class="blank-ik"></div>
			<br /><br />

			<!-- 사진 올리기 -->
			프로필사진(필수) : <input type="file" name="upFile" id="upFile" accept="image/*" /> 
			<input type='hidden' name='mprofile' id="mprofile" value='no' />
			<div id="div-img-ik"></div>
			<br />
			<br />
			
			<!-- 파일 올리기 -->
			포트폴리오(필수) : <input type="file" name="psFile" id="port" required  accept=".txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls"/> <br /><br />
			자기소개서(필수) : <input type="file" name="psFile" id="self" required accept=".txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls" /> <br />
			
			<!-- 카테고리 설정 -->
			<div class="form-check-inline form-check">
				<label for="kind">카테고리</label>
				<select name="kno" id="kind"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
					<option value="-1">과목을 선택하세요.</option>
					
					<c:if test="${!empty kindList }">
					<c:forEach var="kind" items="${kindList }" varStatus="vs">
						<option value="${kind.KNO }">${kind.KINDNAME }</option>
					</c:forEach>
					</c:if>
				</select>
				<select name="sno" id="sub"> <!-- ajax로 kind가져오기 -->
				
				</select>
			</div>

			<br />  <br />
			<textarea rows="10" cols="50" name="cover"placeholder="강사님 당신을 소개 하세요 모두가 알 수 있도록...(필수)" maxlength="1000" ></textarea>

			<br />
			<%-- <button type="button" onclick="location.href='${pageContext.request.contextPath}'">취소</button> --%>
			<input type="submit" id="submit" value="가입하기" class="btn btn-outline-secondary"/>
		</form>
		<br />
		<br />

	</div>
</body>
</html>