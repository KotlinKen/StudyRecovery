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
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
<script src="${rootPath}/resources/js/common.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.js"></script>

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${rootPath}/resources/css/style.css" />
<script>
function imgError(img){ 
	img.src="${rootPath}/resources/upload/adversting/20180617_161710579_2.jpg";
}
$(function(){
	$(".topBanner").slideUp(100);
	var type = "TOP";
	$.ajax({
		url : "${rootPath}/adv/call",
		data : {type : type},
		dataType : "json",
		success : function(data){
			var html ="";
			var image ="${rootPath}/resources/upload/adversting/"+data.adv.ADVIMG;
			var url = data.adv.URL;
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
				$(".topBanner").css({ "background-color" : data.adv.BACKCOLOR}).slideDown(100);
				
				$(".topBanner").on("click", function(){
					$(this).slideUp();
				})

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


	<header>
		<div class="container">
			<nav class="navbar navbar-expand-lg navbar-light bg-light">
				<a class="navbar-brand rm-custom-brand" href="${rootPath}"><jsp:include page="/WEB-INF/views/common/logo_blue.jsp"></jsp:include></a>
				<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav mr-auto">
						<li class="nav-item ${pageTitle}"><a class='nav-link ${fn:contains(where, "study/study") ? "actived" : ""}' href="${rootPath }/study/studyList.do">스터디</a></li>
						<li class="nav-item"><a class='nav-link ${fn:contains(where, "lecture/lecture") ? "actived" : ""}' href="${rootPath }/lecture/lectureList.do?mno=${memberLoggedIn != null ? memberLoggedIn.getMno():'0'}">강의</a></li>
						<li class="nav-item"><a class='nav-link ${fn:contains(where, "board/board") ? "actived" : ""}' href="${rootPath }/board/boardList">게시판</a></li>
					</ul>
					<ul class="navbar-nav float-right">
						<c:if test="${memberLoggedIn == null }">
							<li class="nav-item"><a id="btn-login" class="nav-link" data-toggle="modal" data-target="#loginModal" style="cursor:pointer">로그인</a></li>
							<li class="nav-item"><a class="nav-link" onclick="location.href='${pageContext.request.contextPath}/member/memberAgreement.do'" style="cursor:pointer">회원가입</a></li>
							<li class="nav-item"><a class="nav-link" href="${rootPath }/admin/adminLogin">관리자 로그인</a></li>
						</c:if>
						<c:if test="${memberLoggedIn != null }">
							<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/member/memberView.do" style="cursor:pointer">${memberLoggedIn.mname }님</a></li>
							<li class="nav-item"><a class="nav-link" onclick="location.href='${pageContext.request.contextPath}/member/memberLogout.do'" style="cursor:pointer">로그아웃</a></li>
							<c:if test="${memberLoggedIn.mid eq 'manager' }">
								<li class="nav-item"><a class="nav-link" href="${rootPath }/admin/adminMain">관리자 메인</a></li>
							</c:if>
						</c:if>
					</ul>


				</div>
			</nav>
		</div>
		<!-- 로그인 Modal 시작 -->
		      <div class="modal fade rm_custom_modal" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		         <div class="modal-dialog" role="document">
		            <div class="modal-content">
		               <div class="modal-header text-center">
		                  <h3 class="modal-title" id="exampleModalLabel">로그인</h3>
	                  		<div class="modal-description">Welcome Study Grooupt, what you want get all Tings <br /> Please save me </div>
		                  <div class="adverstingPopupCloseBtn closebtn close" data-dismiss="modal"></div>
		               </div>
		               <form action="${pageContext.request.contextPath }/member/memberLogin.do" method="post">
		                  <div class="modal-body">
		                     <input type="text"   autofocus  class="form-control focus" name="userId" id="userId" placeholder="아이디" required autocomplete="off"/>
		                     <input type="password" class="form-control" name="pwd" id="password" placeholder="비밀번호" required />


							<div class="container">
								<div class="row">
									<div class="custom-control custom-checkbox my-1 mr-sm-2">
										<input type="checkbox" class="custom-control-input" id="idSaveCheck"> <label class="custom-control-label" for="idSaveCheck">아이디 저장</label>
									</div>

								</div>
								<div class="row findIdPw">
									<a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=아이디">아이디</a> 
									<span> | </span> 
									<a href="${pageContext.request.contextPath }/member/memberFindPage.do?findType=비밀번호">비밀번호 찾기</a>
									<span> | </span> 
									<a href="${pageContext.request.contextPath}/member/memberAgreement.do" class="joinUs">회원가입</a>
								</div>

							</div>

							
		                     
		                  </div>
						<div class="modal-footer">
							<div class="container">
								<div class="row">
									<button type="submit" class="btn btn-outline-success btn-lg btn-block">로그인</button>
								</div>
								<div class="row">
									<button type="button" class="btn btn-secondary btn-lg btn-block" data-dismiss="modal">취소</button>
								</div>
								<div class="row text-center">
									<div class="modal-description">We'll never post to Twitter, Facebook or Google on your behalf or without permission.</div>
								</div>
							</div>
							
							
							
						</div>
					</form>
		            </div>
		         </div>
		      </div>
		      <!-- 로그인 Modal 끝 -->
	</header>
	
	
	<div class="container adverstingWingWrap">
		<div class="adverstingWing"></div>
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
            setCookie("key", $("#userId").val(), 7); // 7일 동안 쿠키 보관
        }else{ // ID 저장하기 체크 해제 시,
            deleteCookie("key");
        }
    });
     
    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("#userId").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
        if($("#idSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
            setCookie("key", $("#userId").val(), 7); // 7일 동안 쿠키 보관
        }
    });
});
 
function setCookie(cookieName, value, exdays){
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
    document.cookie = cookieName + "=" + cookieValue;
}
 
function deleteCookie(cookieName){
    var expireDate = new Date();
    expireDate.setDate(expireDate.getDate() - 1);
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}
 
function getCookie(cookieName) {
    cookieName = cookieName + '=';
    var cookieData = document.cookie;
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

