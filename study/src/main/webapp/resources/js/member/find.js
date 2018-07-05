/* 이름 검사 */
			$("#mname").blur(function() {
				var name = $("#mname");
				if(name.val().trim().length ==0){
					 document.getElementById("nameerr").innerHTML = "이름를 입력하세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val("");
					return;
				}
				if (name.val().trim().length > 7) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val("");
					return;
				}
				if (name.val().indexOf(" ") >= 0) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val("");
					return;
				}
				if (name.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ]/g) != -1 ) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val("");
					return;
				}
				if (name.val().search(/[-＃＆　!@#$%^&*()?_+~]/g)  != -1) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val("");
					return;
				} 
				if (name.val().search(/[0-9]/g)  != -1) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val("");
					return;
				}
				if (name.val().search(/[a-z|A-Z]/g) != -1) {
					 document.getElementById("nameerr").innerHTML = "이름은 한글로 2글자 이상 입니다. 외국인도 한글로 적어 주세요";
					 document.getElementById("nameok").innerHTML = "";
					 $("#mname").val(""); 
					return;
				}
				document.getElementById("nameerr").innerHTML = "";
				document.getElementById("nameok").innerHTML = "ok";
			});
			$("#mname").click(function() {
				document.getElementById("nameerr").innerHTML = "";
			});
			
			function validate(){
				/* name */
				var name = $("#mname");
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
				
			}