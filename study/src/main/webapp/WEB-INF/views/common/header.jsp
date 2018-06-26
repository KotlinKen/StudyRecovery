<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${param.pageTitle }</title>
<!-- 부트스트랩관련 라이브러리 -->

<link rel="shortcut icon" href="">
<link rel="icon" type="image/x-icon" class="js-site-favicon" href="${rootPath}/resources/images/favicon.ico" />
<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/bootstrap.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/common/init.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/common/common.css" />
<link href="https://fonts.googleapis.com/css?family=Tajawal" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.css" rel="stylesheet">


<script src="${rootPath}/resources/js/jquery-3.3.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="${rootPath}/resources/js/jquery-ui.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
<script src="${rootPath}/resources/js/common.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.js"></script>

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${rootPath}/resources/css/style.css" />
<script>
function imgError(img){ 
	img.src="${rootPath}/resources/upload/adversting/20180617_161710579_2.jpg";
}
$(function(){
	
console.log("${cookie.popupValue.value}");
	var type = "TOP";
	$.ajax({
		url : "${rootPath}/adv/call",
		data : {type : type},
		dataType : "json",
		success : function(data){
			var html ="";
			var image ="${rootPath}/resources/upload/adversting/"+data.adv.ADVIMG;
			var url = data.adv.URL;
			console.log(url);
			


			if(data.adv != null){
				if(url != undefined){
					html +="<a href='"+url+"' >"
					html +="<div class='mainTop' style='background-image : url("+image+")'>"			
					html +="</div>"			
					html +="</a>"			
				/* $(".mainTop").css({"display": "block" , "background-image" : "url('${rootPath}/resources/upload/adversting/"+data.adv.ADVIMG+"' onerror='imgError(this)')"}); */
				/* $(".mainTop").append("<a href='"+data.adv.URL+"' ><img src='${rootPath}/resources/upload/adversting/" + data.adv.ADVIMG + "' onerror='imgError(this)'/></a>"); */
				}else{
					html +="<div class='mainTop' style='background-image : url("+image+")'>"			
					html +="</div>"			
				}
				$(".topBanner .container").html(html);
				$(".topBanner").css({"display": "block", "background-color" : data.adv.BACKCOLOR});

			}else{
				console.log("TOP베너가 등록되지 않았습니다.");
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
				<a class="navbar-brand rm-custom-brand" href="${rootPath}"><jsp:include page="/WEB-INF/views/common/logo_blue.jsp"></jsp:include></a>
				<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav mr-auto">
						<li class="nav-item ${pageTitle}"><a class="nav-link" href="${rootPath }/study/studyList.do">스터디</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/lecture/lectureList.do">강의</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/board/boardList">게시판</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/board/boardWrite">게시글작성</a></li>
						<c:if test="${memberLoggedIn.mid ne 'manager' }">
						<li class="nav-item"><a class="nav-link" href="${rootPath }/admin/adminLogin">관리자 로그인</a></li>
						</c:if>
						<c:if test="${memberLoggedIn.mid eq 'manager' }">
						<li class="nav-item"><a class="nav-link" href="${rootPath }/admin/adminMain">관리자 메인</a></li>
						</c:if>
					</ul>
					<ul class="navbar-nav float-right">
						<c:if test="${memberLoggedIn == null }">
						<li class="nav-item"><a id="btn-login" class="nav-link" data-toggle="modal" data-target="#loginModal">로그인</a></li>
						<li class="nav-item"><a class="nav-link" onclick="location.href='${pageContext.request.contextPath}/member/memberAgreement.do'">회원가입</a></li>
						</c:if>
						<c:if test="${memberLoggedIn != null }">
						<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/member/memberView.do">${memberLoggedIn.mname }님</a></li>
						<li class="nav-item"><a class="nav-link" onclick="location.href='${pageContext.request.contextPath}/member/memberLogout.do'">로그아웃</a></li>
						</c:if>
					</ul>
				</div>
			</nav>
		</div>
	</header>
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
										<input type="text" class="form-control" name="userId" id="userId" placeholder="아이디" required /> <br /> <input type="password" class="form-control" name="pwd" id="password" placeholder="비밀번호" required /> <a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=아이디">아이디/</a> <a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=비밀번호">비밀번호 찾기</a>
									</div>
									<div class="modal-footer">
										<button type="submit" class="btn btn-outline-success">로그인</button>
										<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
									</div>
								</form>
							</div>
						</div>
					</div>
					<!-- 로그인 Modal 끝 -->

