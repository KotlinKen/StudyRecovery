<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 <jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 
<script>
//참여신청 버튼 클릭 이벤트
function studyApply(sno){
	//세션에서 멤버의 mno 받아옴 로그인 안한상태에 대해서도 분기 처리.
	//이미 신청을 했으면 return;하게 만들어야 함. 
	//임시로 confirm. 계획은 부트스트랩 모달창에 주요 정보 나열 후 확인버튼누르면 아작스 실행.
	var mno=${memberLoggedIn!=null? memberLoggedIn.getMno():"0"};
	if(${memberLoggedIn!=null}){
		if(${isApply eq 0}){
			if(confirm("신청하시겠습니까")) {
				$.ajax({
					url:"applyStudy.do",
					data:{sno:sno,mno:mno},
					success:function(data){
						if(data==-1){
							alert("신청인원 최대 인원 100명을 넘었습니다.");
						}
						else if(data==0){
							alert("이미 신청한 스터디입니다.");
						}else{
							alert("신청되었습니다.");
							window.location.reload(true);
						}
						//신청 완료 후 button에 스타일 주어서 이미 신청했음을 표시하게 한다.
					},error:function(){
						
					}
				});
			}
		}else{
			if(confirm("신청취소하겠습니까")) {
				$.ajax({
					url:"applyStudyDelete.do",
					data:{sno:sno,mno:mno},
					success:function(data){
						if(data>0){
							alert("신청취소되었습니다.");
							window.location.reload(true);
						}else{
							
						}
				
					},error:function(){
						
					}
				});
			}
			
		}
	
		
	}else{
		//alert("로그인 후 이용하세요");
		$("a#btn-login").trigger('click');
	}
	
}

//찜하기 버튼 클릭 이벤트
function studyWish(sno){
	//세션에서 멤버의 mno 받아옴 로그인 안한상태에 대해서도 분기 처리.
	//찜하기를 이미 선택했다면 다시 누르면 찜하기에서 삭제됨.
	var mno=${memberLoggedIn!=null? memberLoggedIn.getMno():"0"};
	console.log("######");
	console.log(sno);
	console.log(mno);
	if(${memberLoggedIn!=null}){//로그인을 한 상황..
		
		if(${isWish eq 0}){//사용자는 전에 찜하지 않았음.
			$.ajax({
				url:"wishStudy.do",
				data:{sno:sno,mno:mno},
				success:function(data){
					console.log("찜했다");
					$("button#btn-wish").val("찜취소");
					if(confirm("찜했하시겠습니까?")){
						alert("찜되었습니다.");
						window.location.reload(true);
						//location.href="${pageContext.request.contextPath}/member/searchMyPageKwd.do?myPage=wish";
					}
					
				},error:function(){
					
				}
			});
		}else{
			if(confirm("이미 찜했습니다. 취소하겠습니까?")){
				$.ajax({
					url:"deletewishStudy.do",
					dataType:"json",
					data:{sno:sno,mno:mno},
					success:function(data){
						alert("정상적으로 취소 되었습니다.");
						$("img.wish").attr("src","${pageContext.request.contextPath }/resources/upload/study/wish.png");
						$("input#isWish").val("0");//찜취소한거 저장
						window.location.reload(true);
					},error:function(){
						
					}
				});
			}
		}
	}else{//로그인창 띄움.
		$("a#btn-login").trigger('click');
	}
	
}
$(function(){
	
	if($("input#isWish").val()==1) $("button#btn-wish").val("찜취소");
	
	$("button.editStudy").click(function(){
		$.ajax({
			url:"preStudyUpdate.do",
			data:{sno:${study.SNO}},
			type:"post",
			success:function(data){
				if(data==0) location.href="studyUpdate.do?sno="+${study.SNO};
				else alert("이미 신청한 회원이 있어 수정할 수 없습니다.");
			}
		});

	});
	
	$("button.removeStudy").click(function(){
		if(confirm("정말 삭제하시겠습니까?")){
			location.href="deleteStudy.do?sno="+${study.SNO};

		}
	});
	
	
	$(window).on('scroll',function(){
		var maxHeight = $(document).height();
		console.log("document height"+maxHeight);
	    var currentScroll = $(window).scrollTop() + $(window).height();
	    console.log("currentScroll"+currentScroll);
		if(1108 <= currentScroll){
			console.log("으엥");
			$("aside#action-widget").addClass("fixed");
		}else{
			$("aside#action-widget").removeClass("fixed");
		}
		
	});
	
	
	if(Number($("span.score-point").text())>Number($("span.score-point").next().text())){
		console.log($("span.score-point").text());
		$("span.score-point").css("color","green");
	}else if(Number($("span.score-point").text())<Number($("span.score-point").next().text())){
		$("span.score-point").css("color","red");
		
		
	}else{
		$("span.score-point").css("color","orange");
	}
	
	console.log(Number($("span.score-point").text()));
	console.log(Number($("span.score-point").next().text()));
	
	if(Number($("span.score-npoint").text())>Number($("span.score-npoint").next().text())){
		$("span.score-npoint").css("color","green");
	}else if(Number($("span.score-npoint").text())<Number($("span.score-npoint").next().text())){
		$("span.score-npoint").css("color","red");
	}else{
		$("span.score-npoint").css("color","orange");
	}
	
	
	if(Number($("span.score-exp").text())>Number($("span.score-exp").next().text())){
		$("span.score-exp").css("color","green");
	}else if(Number($("span.score-exp").text())<Number($("span.score-exp").next().text())){
		$("span.score-exp").css("color","red");
	}else{
		$("span.score-exp").css("color","orange");
	}
	
});
	
</script>
<style>
.notLeader{
	display:none;
}

div.sideInfo{

}
div#carouselExampleControls{
	width:700px;
	height:400px;
}
div.carousel-item img{
	width:700px;
	height:400px;
}
div.member-photo img{
	width:60px;
	height:70px;
	border-radius: 50px;
	
}
div.review-detail a{
	color:coral;
}
div.studyView-container{
	width:1000px;
	margin:0 auto;
	position:relative;
	background:white;
	margin-top:50px;

}
div.study-info{
	width:700px;/* 
	border:1px solid black; */
	position:relative;
	background:white;
	margin-bottom:20px;
}
div.level-mark{
	position:absolute;
	top:350px;
	left:50px;
	height:90px;
	width:100px;
	background:#ef6c00;
	text-align:center;
}
div.label{
	font-size: 20px;
	color:#ffeb3b;
}
div.level{
	font-size:30px;
	color:white;
}
p.area{
	margin:0 auto;
	position: relative;
	left:330px;
	color:#0056e9;
	font-weight:bold;
	font-size:18px;
	margin-top:5px;
	top:10px;
}
div.study-images{
	/* border:1px solid black; */
	height:400px;
	
}
div.title-wrap{
	text-align:center;
	background:white;
	margin-bottom: 33px;
    margin-top: 33px;
	
}
h1.title{
	color:#3c3c3c;
	font-size:28px;
}
.section-label{
	float:left;
	clear:right;
	height:100px;
	color:#333;
	font-size:20px;
	font-weight:bold;
	margin-left:30px;
	background:white;
	margin-top:20px;
}
h3.leader-label{
	color:#333;
	font-size:15px;
	background:white;
	font-size:20px;
	font-weight:bold;
	
}
div.study-detail{
	overflow:hidden;
	/* border:1px solid black; */
	background:white;
}
div.study-description{
	/* border:1px solid black; */
	width:600px;
	background:white;
}
section.leader-information{
	position:relative;
	width: 700px;
	height: 400px;
	background:white;
	overflow: hidden;
	width: 700px;
    height: 400px;
	
}
div.introduce-wrap{
	overflow: hidden;
	background:white;
}
div.section-content{
	float:right;
	width:500px;
	background:white;
	
}
dl#deatil-list dt, dl#deatil-list dd{
	display:inline-block;
}
dl#deatil-list dt{
	width:70px;
}
dl#deatil-list dd{
	width:162px;
}
aside#action-widget{
	width:280px;
	float:right;
	background:white;
	box-shadow: 8px 8px 8px lightgray;
	
}
div.study-wrap{
	float:left;
	clear:right;
	background:white;
}
div.no{
	clear:both;
	background:white;
	
} 
div#review-container{
	clear:both;
	background:white;
}
li.review-one{
	clear:left;
	background:white;
}
img.leader-profile-image{
	width:80px;
	height:80px;
	border-radius: 50px;
}
div.order-action{
	background:white;
	padding:10px;
}
div.order-action button{
	width:100%;
	padding:15px;
	font-size:18px;
}
.fixed{
	position:fixed;
	top:0;
	left:50%;
	margin-left:13.8pc;
}
div.center-leader{
	margin-top:20px;
}
.side-info{
	font-size: 15px;
	font-weight: bold;
}
.price{
	font-size:20px;
	color:#ef6c00;
	font-weight:bold;
}
div.leader-btn-wrap{
	width:1000px;
	margin:0 auto;
	text-align:right;
	position:relative;
}
div.leader-btn-wrap button{
	position:relative;
	top:30px;
	right:10px;
	
}
button.removeStudy{
	background:red;
	color:white;
}
button.editStudy{
	background:black;
	color:white;
}
button#btn-apply{
	background:#ef6c00;
	color:white;
}
ul.reviews{
	overflow:hidden;
}
li.review-one{
	overflow:hidden;
}
.slider {
    -webkit-appearance: none;
    width: 80%;
    height: 15px;
    border-radius: 5px;
    background: #d3d3d3;
}
.slider::-webkit-slider-thumb {
   -webkit-appearance: none;
   appearance: none;
   width: 0px;
   height: 0px;
   border-top: 20px solid none;
   border-bottom: 20px solid #0056e9;
   border-right: 20px solid transparent;
   border-left: 20px solid transparent;
   background: transparent;
   cursor: pointer;
   transform: translateY(11px);
}
p.rContent{
	margin-top:10px;
}


</style>
<c:set var="imgs" value="${fn:split(study.UPFILE,',')}"/>
<div class="leader-btn-wrap">
		<c:if test="${memberLoggedIn!=null }">
		<c:if test="${memberLoggedIn.getMno()==study.MNO }">
			<c:if test="${study.STATUS=='모집 중'||study.STATUS=='마감 임박'||study.STATUS=='진행 중'}">
				<button type="button" class="removeStudy btn">스터디 삭제</button><!-- 팀장일때만 나타날 것임. -->
			</c:if>
		</c:if>
	</c:if>
<c:if test="${memberLoggedIn!=null&&memberLoggedIn.getMno()==study.MNO}">
	<c:if test="${study.STATUS ne '모집 마감'&&study.STATUS ne '스터디 종료'&&study.STATUS ne '진행 중' }">
		<button type="button" class="editStudy btn">스터디 수정</button> <!-- 팀장일때만 나타날 것임. -->
	</c:if>
</c:if>	
</div>
<div class="studyView-container">
<div id="study-detail">
	<div class="study-wrap">
	

<input type="hidden" id="isWish" value="${isWish }" />
<div class="study-info">
<header class="front-info">
<div class="study-images">
	<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
	  <div class="carousel-inner">
		   <c:forEach var="img" items="${imgs }" varStatus="vs"> 
				<div class="carousel-item ${vs.first? 'active':'' }">
			     	<img class="d-block w-100" src="${pageContext.request.contextPath }/resources/upload/study/${img }" alt="Second slide">
			     </div> 
	  		</c:forEach> 
	  </div>
	  
	  <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
	    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	    <span class="sr-only">Previous</span>
	  </a>
	  <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
	    <span class="carousel-control-next-icon" aria-hidden="true"></span>
	    <span class="sr-only">Next</span>
	  </a>
	  
	</div>
</div>

<div class="front-text">
<div class="level-mark">
	<div class="label">LEVEL</div>
	<div class="level">${study.DNAME }</div>
</div>
<p class="area">${study.LNAME } | ${study.TNAME }</p>
<div class="title-wrap">
	<h1 class="title">${study.TITLE }</h1>
</div>
</div>
</header>
<div class="center-content">
<section class="study-infomation">
	<div class="introduce-wrap">
		<h2 class="section-label">스터디 소개</h2>
		<div class="study-description section-content">
			${study.CONTENT }
		</div>
	</div>
	<hr />
	<div class="study-detail">
		<h3 class='section-label'>상세 정보</h3>
		<div class="section-content">
			<dl id="deatil-list">
				<dt>지역 :</dt>
				<dd>${study.LNAME } | ${study.TNAME }</dd>
				<dt class="right-column">인원 : </dt>
				<dd class="right-column">${study.RECRUIT }명</dd>
				<dt>일정:</dt>
				<dd>${study.SDATE }~${study.EDATE }</dd>
				<dt class="right-column">주기</dt>
				<dd class="right-column">${study.FREQ }  </dd>
				<dt>시간</dt>
				<dd>${study.TIME }</dd>
				<dt class="right-column">협의비</dt>
				<dd class="right-column">${study.PRICE }원</dd>
			</dl>
		
		</div>
	</div>
</section>

<section class="leader-information">
	<hr />
	<div class="leader-wrap">
		<header class="front-leader section-label" style="margin-bottom: 20px;">
		
		<c:if test="${ratio <= 10}">
			<h3 class="leader-label">리더소개(상위  ${ratio }% 회원)</h3>
		</c:if> 
		<c:if test="${ratio > 10}">
			<h3 class="leader-label">리더소개</h3>
		</c:if> 
		<img src="${pageContext.request.contextPath }/resources/upload/member/${study.MPROFILE}" alt="" class="leader-profile-image" />
		<div class="pointrange" id="pointrange">
<<<<<<< HEAD
			<label for="">포인트 </label>
			<p class="score">${study.POINT }/${memberAvg.AVGPOINT }</p>
			<label for="">지식포인트 </label>
			<p class="score">${study.NPOINT }/${memberAvg.AVGNPOINT }</p>
			<label for="">경험치 </label>
			<p class="score">${study.EXP }/${memberAvg.AVGEXP }</p>
=======
			<label for="" style="font-size:13px;">점수 / 평균점수</label><br />
			<label for="">포인트 </label><br />
			<span class="score-point">${study.POINT }</span>/<span>${memberAvg.AVGPOINT }</span><br />
			<label for="">지식포인트 </label><br />
			<span class="score-npoint">${study.NPOINT }</span>/<span>${memberAvg.AVGNPOINT }</span><br />
			<label for="">경험치 </label><br />
			<span class="score-exp">${study.EXP }</span>/<span>${memberAvg.AVGEXP }</span><br />
>>>>>>> branch 'HeoKyeong' of https://github.com/KotlinKen/StudyRecovery.git
		</div>
		</header>
	
		<div class="center-leader section-content">
			<span>${study.COVER }</span>
		</div>
	</div>
	
</section>

</div>


</div>
<br />

<div id="review-container"><!-- 팀장에 대한 후기 -->
<h5 style="font-weight:bold; margin-left:20px; margin-bottom:10px;">리더에 대한 후기</h5>
<c:if test="${reviewList!=null }">
	<ul class="reviews">
		<c:forEach var="r" items="${reviewList }">
			<li class="review-one">
				<div class="member-photo section-label">
					<img src="${pageContext.request.contextPath }/resources/upload/member/${r.MPROFILE!=null? r.MPROFILE:'basicprofile.png'}" alt="" />
					
				</div>
				<div class="review-detail section-content">
					<span>${r.MNAME }</span>&nbsp;|&nbsp;
					<c:if test="${r.POINT eq '1000' }">
						<span style="color:blue;">${r.POINT }</span>점
					</c:if>
					<c:if test="${r.POINT ne '1000' }">
						<span style="color:red;">${r.POINT }</span>점
					</c:if>
					
					<p class="rContent">${r.CONTENT }</p>
					<a href="studyView.do?sno=${r.SNO }">${r.TITLE }</a>
					<p><fmt:formatDate value="${r.REGDATE }" pattern="yyyy-MM-dd"/></p>
				
					
				</div>
				
			</li>
			<hr />
			
		</c:forEach>
	</ul>

</c:if>
<c:if test="${reviewList==null }">
아직 평가가 없습니다.
</c:if>

</div>

</div>
<!-- 옆에 따라디는 정보 창, 참여 신청 찜하기  -->
<aside id="action-widget">
<div class="order-action">
	<h1 class='title'>${study.TITLE }</h1>
	<label for="">신청 기간 : </label> <span class="side-info">~${study.LDATE }</span><br />
	<label for="">스터디일정 : </label> <span class="side-info">${study.SDATE }~${study.EDATE }</span><br />
	<label for="">회비 : </label> <span class="price side-info">${study.PRICE }원</span><br />
	<label for="">모집인원 : </label>&nbsp;&nbsp;<span>${study.RECRUIT }명</span><br />
	<label for="">신청인원 : </label>&nbsp;&nbsp;<span>${study.APPLYCNT+study.CREWCNT }명</span>
	 <c:if test="${memberLoggedIn==null }">
	 	<button type="button" id="btn-apply" class="btn" onclick="studyApply('${study.SNO}');"><span>참여 신청하기</span></button><br /><br />
	 	<button type="button" id="btn-wish" class="btn" onclick="studyWish('${study.SNO}');"><span>찜하기</span></button><br /><br />
	 </c:if>

	<c:if test="${memberLoggedIn!=null&&memberLoggedIn.getMno()!=study.MNO}">
		<c:if test="${study.STATUS=='모집 중'||study.STATUS=='마감 임박' }">
			<c:if test="${isApply eq 0}">
				<button type="button" id="btn-apply" class="btn" onclick="studyApply('${study.SNO}');"><span>참여 신청하기</span></button><br /><br />
			</c:if>
			<c:if test="${isApply ne 0 }">
				<button type="button" id="btn-apply" class="btn" onclick="studyApply('${study.SNO}');"><span>참여 취소하기</span></button><br /><br />
			</c:if>
			<c:if test="${isWish eq 0 }"> 
				<button type="button" id="btn-wish" class="btn" onclick="studyWish('${study.SNO}');"><span>찜하기</span></button><br /><br />
			</c:if>
			<c:if test="${isWish ne 0 }"> 
				<button type="button" id="btn-wish" class="btn" onclick="studyWish('${study.SNO}');"><span>찜취소</span></button><br /><br />
			</c:if>
		
		</c:if>
</c:if>	
</div>
</aside>
	</div>

</div><!-- 전체 -->

<div class="no"></div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>	
