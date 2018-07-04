<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${param.pageTitle }</title>
<!-- 부트스트랩관련 라이브러리 -->
<script src="${rootPath}/resources/js/jquery-3.3.1.js"></script>
<script src="${rootPath}/resources/js/common.js"></script>
<script src="${rootPath}/resources/js/jquery-ui.min.js"></script>
<link rel="shortcut icon" href="">
<link rel="icon" type="image/x-icon" class="js-site-favicon" href="https://assets-cdn.github.com/favicon.ico">
<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/bootstrap.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/common/init.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/common/common.css" />
<link href="https://fonts.googleapis.com/css?family=Tajawal" rel="stylesheet">
<script src="${rootPath}/resources/js/bootstrap.min.js"></script>

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${rootPath}/resources/css/style.css" />
<script>
function imgError(img){ 
	img.src="${rootPath}/resources/upload/adversting/20180617_161710579_2.jpg";
}
$(function(){
	var type = "TOP";
	$.ajax({
		url : "${rootPath}/adv/call",
		data : {type : type},
		dataType : "json",
		success : function(data){
			console.log(data);
			if(data.adv != null){
				$(".mainTop").append("<a href='"+data.adv.URL+"' ><img src='${rootPath}/resources/upload/adversting/" + data.adv.ADVIMG + "' onerror='imgError(this)'/></a>");
				$(".topBanner").css({"display": "block", "background-color" : data.adv.BACKCOLOR});
			}else{
			}
		}
	});
});	
	
$(function(){
	var popCookie = "${cookie.popupValue.value}";

	if(popCookie != "Y"){
	var type = "POPUP";
		$.ajax({
			url : "${rootPath}/adv/call",
			data : {type : type},
			dataType : "json",
			success : function(data){
				console.log(data);
				
				if(data.adv == null){
					console.log('등록된 팝업이 없습니다.');
				}else{
					$(".adverstingPopup").draggable();
					$(".adverstingPopup").css("display", "block").append("<img src='${rootPath}/resources/upload/adversting/" + data.adv.ADVIMG+ "' />");
				}
			}
		});
		
		$(".adverstingPopup .adverstingPopupCloseBtn").on("click", function(){
			$(this).parent().css("display", "none");
			$.ajax({
				url : "${rootPath}/adv/popupClose",
				success: function(data){
					console.log("test");
					
				}
			})
		});
	}
	});	
	
$(function(){
	var type = "WINGRIGHT";
		$.ajax({
			url : "${rootPath}/adv/call",
			data : {type : type},
			dataType : "json",
			success : function(data){
				console.log(data);
				
				if(data.adv == null){
					console.log('등록된 윙 광고가  없습니다.');
				}else{
					$(".adverstingWing").css({"display": "block" , "background-image" : "url('${rootPath}/resources/upload/adversting/"+data.adv.ADVIMG+"')"});
					
				}
			}
		});
	});	
		
	
	
</script>
</head>

<body>
	<div class="banner topBanner">
		<div class="container">
			<div class="mainTop"></div>
		</div>
	</div>
	<div class="adverstingPopup">
		<div class="adverstingPopupCloseBtn closebtn"></div>
	</div>

	<div class="container adverstingWingWrap">
		<div class="adverstingWing"></div>
	</div>


	<header>
		<div class="container">
			<nav class="navbar navbar-expand-lg navbar-light bg-light">
				<a class="navbar-brand" href="${rootPath}"> STUDY GROUPT </a>
				<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav mr-auto">
						<li class="nav-item active"><a class="nav-link" href="${rootPath }/adv/adverstingWrite">광고작성</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/adv/adverstingListPaging">광고리스트</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/study/studyList.do">스터디</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/study/studyForm.do">스터디 작성</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/lecture/lectureList.do">강의</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/lecture/insertLecture.do">강의 작성</a></li>
						<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> Dropdown </a>
							<div class="dropdown-menu" aria-labelledby="navbarDropdown">
								<a class="dropdown-item" href="${rootPath }/admin/adminLogin">어드민</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" href="${rootPath }/admin/adminLogin">어드민</a>
							</div></li>
					</ul>

					<c:if test="${memberLoggedIn == null }">
						<button type="button" class="btn btn-outline-success" data-toggle="modal" data-target="#loginModal">로그인</button> &nbsp; &nbsp;
				<!-- 회원가입 버튼 시작 -->
						<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/member/memberAgreement.do'">회원가입</button>
						<!-- 회원가입 버튼 끝 -->
					</c:if>
					<c:if test="${memberLoggedIn != null }">
						<p>
							<a href="${pageContext.request.contextPath }/member/memberView.do">${memberLoggedIn.mname }</a>님
						</p>
						<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/member/memberLogout.do'">로그아웃</button>

					</c:if>
	</header>
	<section>
		<!-- 로그인 Modal 시작 -->
		<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">로그인</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<form action="${pageContext.request.contextPath }/member/memberLogin.do" method="post">
						<div class="modal-body">
							<input type="text" class="form-control" name="userId" id="userId" placeholder="아이디" required /> <br /> 
							<input type="password" class="form-control" name="pwd" id="password" placeholder="비밀번호" required /> 
							<input type="checkbox" id="idSaveCheck" />
							<label for="idSaveCheck">아이디 저장</label> <br />
							<a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=아이디">아이디/</a> 
							<a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=비밀번호">비밀번호 찾기</a>
						</div>
						<div class="modal-footer">
							<button type="submit" class="btn btn-outline-success">로그인</button>
							<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<script>
		$(document).ready(function(){
			 
		    // 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
		    var key = getCookie("key");
		    $("#userId").val(key); 
		     
		    if($("#userId").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
		        $("#idSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
		    }
		     
		    $("#idSaveCheck").change(function(){ // 체크박스에 변화가 있다면,
		        if($("#idSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
		        	deleteCookie("key");
		            setCookie("key", $("#userId").val(), 7); // 7일 동안 쿠키 보관
		        }else{ // ID 저장하기 체크 해제 시,
		            deleteCookie("key");
		        }
		    });
		     
		    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
		    $("#userId").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
		        if($("#idSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
		        	deleteCookie("key");
		            setCookie("key", $("#userId").val(), 7); // 7일 동안 쿠키 보관
		        }
		    });
		});
		 
		function setCookie(cookieName, value, exdays){
		    var exdate = new Date();
		    exdate.setDate(exdate.getDate() + exdays);
		    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString())+ ';path=/';
		    document.cookie = cookieName + "=" + cookieValue;
		}
		 
		function deleteCookie(cookieName){
		    var expireDate = new Date();
		    expireDate.setDate(expireDate.getDate() - 1);
		    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + ';path=/';
		}
		 
		function getCookie(cookieName) {
		    cookieName = cookieName + '=';
		    var cookieData = document.cookie + ';path=/';
		    var start = cookieData.indexOf(cookieName);
		    var cookieValue = '';
		    if(start != -1){
		        start += cookieName.length;
		        var end = cookieData.indexOf(';', start);
		        if(end == -1)end = cookieData.length;
		        cookieValue = cookieData.substring(start, end);
		    }
		    return unescape(cookieValue);
		}
 
		</script>
		</header>