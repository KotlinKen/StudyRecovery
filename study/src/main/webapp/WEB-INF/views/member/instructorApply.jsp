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

div {
	width: 600px;
	min-height: 25px;
	margin: auto;
	background: rgb(255, 255, 255);
}

div#indivik {
	margin: auto;
}

div#inindivik1 {
	background: rgb(230, 230, 230)
}

div#inindivik2 {
	margin: auto;
	text-align: center;
	background: rgb(230, 230, 230)
}

div#inindivik3 {
	width: 450px;
	margin: auto;
	text-align: center;
}

div#headerdivik {
	margin: auto;
	text-align: center;
}

div#id-password-div-ik {
	position: relative;
	top: 0px;
	left: 0%;
	width: 100%;
	height: 100%
}

div#choos-ik {
	border-radius: 5px;
}

div#name-phone-email-gender-div-ik {
	border-radius: 10px;
}

div.blank-ik {
	background: rgb(230, 230, 230);
	height: 5px;
}

#buttona {
	position: relative;
	left: 20px;
}

#buttonb {
	position: relative;
	left: 71%;
}

body {
	background: rgb(230, 230, 230)
}

#indivik {
	border-radius: 5px;
	border: solid 3px rgb(200, 200, 200);
}

#headaik {
	color: black;
}

#submit {
	width: 100%;
	position: relative;
	top: 10px;
}

#inputCode {
	width: 40%;
}

#sub{display: none}
</style>
</head>
<body>
	<script>
		$(function() {
			/* 파일 업로드 */
			$("#upFile").change(function() {
				var ext = $("input:file").val().split(".").pop().toLowerCase();
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
					if ($.inArray(ext, [ "txt", "hwp", "docx","pptx" ,"ppt","xlsx","xlsx"]) == -1) {
						alert("txt,hwp,docx,pptx,ppt,xlsx,xlsx 파일만 업로드 할수 있습니다.");
						$("#port").val("");
						return false;
					}
				}
			});
			$("#self").change(function() {
				var ext = $("#self").val().split(".").pop().toLowerCase();
				if (ext.length > 0) { 
					if ($.inArray(ext, [ "txt", "hwp", "docx","pptx" ,"ppt","xlsx","xlsx"]) == -1) {
						alert("txt,hwp,docx,pptx,ppt,xlsx,xlsx 파일만 업로드 할수 있습니다.");
						$("#self").val("");
						return false;
					}
				}
			});
		});

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
		function validate() {
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
	</script>
	<div id="inindivik1"></div>
	<div id="inindivik2">
		<a id="headaik" href="${pageContext.request.contextPath}"><br />
		<h1>STUDY GROUPT</h1>
			<br /></a>
	</div>
	<div id="enroll-container">
		<br />
		<form action="instructorApplyEnd.do" method="post" name='mainForm'
			id='mainForm' onsubmit="return validate();"
			enctype="multipart/form-data">

			<input type="hidden" name="mno" id="mno" value="${mno} " /> 
			<input type="hidden" name="mid" id="mid" value="${mid} " /> 
			
			<br /> 
			<!-- 파일 올리기 -->
			포트폴리오(필수) : <input type="file" name="psFile" id="port" required  accept=".txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls"/> <br /><br />
			자기소개서(필수) : <input type="file" name="psFile" id="self" required accept=".txt, .hwp, .docx , .pptx ,.ppt , xlsx ,.xls" /> <br />
			<br />
			<!-- 카테고리 설정 -->
			<div class="form-check-inline form-check">
				<label for="kind">카테고리 : </label>
				<select name="kno" id="kind" required> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
					<option value="-1" >과목을 선택하세요.</option>
					
					<c:if test="${!empty kindList }">
					<c:forEach var="kind" items="${kindList }" varStatus="vs">
						<option value="${kind.KNO }">${kind.KINDNAME }</option>
					</c:forEach>
					</c:if>
				</select>
				<select name="sno" id="sub" required> <!-- ajax로 kind가져오기 -->
					<option value="-1" >과목을 선택하세요.</option>
				</select>
				<br />
			</div> 
			<input type="submit" id="submit" value="강사 신청" class="btn btn-outline-secondary" />

		</form>
		<br /> <br />

	</div>
</body>
</html>