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
						html += "<img class ='call_img'   src='${rootPath }/resources/upload/member/"+date.renamedFileName+"'>";
						$("#div-img-ik").html(html);
						$("#div-img-ik").css({"display":"inline-block"});
						$("#mprofile").val(date.renamedFileName);
						$("#btn_noFile").show();
					
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
				console.log("불")
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
			var cc =  $("#countDown").text();
			console.log(cc);
			if(cc!=""){
				if(cc<11){
					alert("이미 보넸습니다.10초 후 다시 확인 하세요");
					
					return;
				}
			}
			
			var data = new FormData();
			var em = email + "@" + emailaddr;
			data.append("em", em);
			alert("인증번호 전송중 ...");
			$.ajax({
				url : "certification.do",
				data : data,
				contentType : false,
				processData : false,
				type : "POST",
				dataType : "json",
				success : function(date) {
					var cnt = 10;
					if(date.check==true){
					$("#checkcertification").val(1);
					stop();
					reset();
					start();
					}else{
					alert("인증번호 전송실패  이미 가입하셨나요?");
					stop();
					reset();
					start();
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
						var html="<select name=\"sno\" id=\"sub\" class=\"custom-select\"><option value='-1'>세부 과목을 선택하세요</option>";
						
						for(var index in data){
							html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option></br>";
						}
						html+="</select>"
						$("#kind").after(html);
					}			
				});
			});	
		});
		$(document).ready(function(){
		   var date = new Date();
		   var year = date.getFullYear();
		   var month = new String(date.getMonth()+1);
		   var day = new String(date.getDate());
		   
		   if(month.length == 1 )
		      month = "0" + month;
		   if( day.length == 1 )
		      day = "0" + day;
		   
		   var today = year + "-" + month + "-" + day;
		   
		   $("#birth").attr("max", today);
		   
		 
		  
		});
		$(function () {
			
			$("#btn_upFile").click(function(e){
				e.preventDefault(); 
				$("input:file").click(); 
				
			});
			
			$("#btn_noFile").click(function(e){
				$("#div-img-ik").hide();
				$("#mprofile").val("noprofile.jpg");
				
				$("#btn_noFile").hide();
			});
			
		});
		
		
		
		
		var timer,
		 i = 0,
		 divide = 1;


		function start(){
		 // setInterval()은 지정된 시간후 특정 자바스크립트 코드가 포함된 문자열을 반복하여 호출하는 메소드
		 // 지정된 시간 increment() 함수를 의미

		 timer = self.setInterval('increment()', (1000 / divide));
		}

		function increment(){
		 // ( i / divide )??
		 i++;
		 document.getElementById('countDown').innerHTML = (i / divide);
		}

		function stop(){
		 // clearInterval : setInterval을 멈출 때 사용
		 // timer = null을 준 이유는?
		 clearInterval(timer);
		 timer = null;
		}

		function reset(){
		 stop();
		 i = 0
		 document.getElementById('countDown').innerHTML = (i / divide);
		}
		
		
		$("#birth").on("change",function() {
			console.log("?");
			//$("#birthspan").css({"display":"none"})
		});
		 
		