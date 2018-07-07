<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 <jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 
<style>
.notLeader{
	display:none;
}

div.sideInfo{

}
div#carouselExampleControls{
	width:500px;
	height:600px;
}
div.carousel-item img{
	width:500px;
	height:600px;
}
div.member-photo img{
	widht:60px;
	height:70px;
}
div.review-detail a{
	color:coral;
}
</style>

<script>
//참여신청 버튼 클릭 이벤트
function studyApply(sno){
	//세션에서 멤버의 mno 받아옴 로그인 안한상태에 대해서도 분기 처리.
	//이미 신청을 했으면 return;하게 만들어야 함. 
	//임시로 confirm. 계획은 부트스트랩 모달창에 주요 정보 나열 후 확인버튼누르면 아작스 실행.
	var mno=${memberLoggedIn!=null? memberLoggedIn.getMno():"0"};
	if(${memberLoggedIn!=null}){
	
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
					}
					//신청 완료 후 button에 스타일 주어서 이미 신청했음을 표시하게 한다.
				},error:function(){
					
				}
			});
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
	if(${memberLoggedIn!=null}){//로그인을 한 상황..
		
		if($("input#isWish").val()==0){//사용자는 전에 찜하지 않았음.
			$.ajax({
				url:"wishStudy.do",
				data:{sno:sno,mno:mno},
				success:function(data){
					console.log("찜했다");
					$("button#btn-wish").val("찜취소");
					if(confirm("찜했습니다. 찜 장바구니로 가시겠습니까?")){
						
						location.href="${pageContext.request.contextPath}/member/searchMyPageKwd.do?myPage=wish";
					}
					$("input#isWish").val("1");//찜했음을 저장
				},error:function(){
					
				}
			});
		}else{
			if(confirm("이미 찜했습니다. 취소하겠습니까?")){
				$.ajax({
					url:"deletewishStudy.do",
					data:{sno:sno,mno:mno},
					success:function(data){
						$("img.wish").attr("src","${pageContext.request.contextPath }/resources/upload/study/wish.png");
						$("input#isWish").val("0");//찜취소한거 저장
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
		
	
	
	
});


</script>
<style>
div.studyView-container{
	width:1200px;
	margin:0 auto;
	position:relative;

}
div.study-info{
	width:800px;
	border:1px solid black;
	position:relative;
}
div.level-mark{
	position:absolute;
	top:350px;
	border:1px solid black;
	left:50px;
	height:90px;
	width:100px;
}
span.area{
	border:1px solid black;
	margin:0 auto;
	position: relative;
	left:330px;
}
div.study-images{
	border:1px solid black;
	height:400px;
	
}
div.title-wrap{
	margin:0 auto;
	text-align:center;
}
h2.section-label{
	float:left;
	clear:right;
	height:100px;
}
div.study-detail{
	float:right;
	border:1px solid black;
}
div.study-description{
	float:right;
	border:1px solid black;
}

</style>
<div class="studyView-container">
<div id="study-detail">
	<c:set var="imgs" value="${fn:split(study.UPFILE,',')}"/>
	<c:if test="${memberLoggedIn!=null }">
		<c:if test="${memberLoggedIn.getMno()==study.MNO }">
			<c:if test="${study.STATUS=='모집 중'||study.STATUS=='마감 임박'||study.STATUS=='진행 중'}">
				<button type="button" class="removeStudy">스터디 삭제</button><!-- 팀장일때만 나타날 것임. -->
			</c:if>
		</c:if>
	</c:if>
<c:if test="${memberLoggedIn!=null&&memberLoggedIn.getMno()==study.MNO}">
	<c:if test="${study.STATUS ne '모집 마감'&&study.STATUS ne '스터디 종료'&&study.STATUS ne '진행 중' }">
		<button type="button" class="editStudy">스터디 수정</button> <!-- 팀장일때만 나타날 것임. -->
	</c:if>
</c:if>	

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
	<div class="level">난이도값</div>
</div>
<span class="area">지역/도시 값</span><br /><br />
<div class="title-wrap">
	<h1 class="title">제목값</h1>
</div>
</div>
</header>
<div class="center-content">
<section class="study-infomation">
		<h2 class="section-label">스터디 소개</h2>
	<div class="study-description">
		영어로 이야기를 하려고 할 때, 또는 외국인 앞에서 말문을 열어야 할 때..
등에서 식은땀이 나고 어디서부터 어떤 이야기를 꺼내야 할 지 막막하신 분들이 계신가요?

회화를 시작해야 하는데, 배울건 너무나도 많고 어디에서부터 시작해서 무엇을 어떻게 배워야 할지 막막하셨죠? 제 스터디에서는 가장 기초가 되지만 자칫 밋밋해질 수 있는 자기소개를 어떻게 톡톡 튀고 매력있게 할 수 있을지부터 시작해서, 모든 대화의 기초가 되는 표현을 바탕으로 문장을 어떻게 만들어 가야 할지를 차근차근 배워 볼 거에요.


[진행방식]

1. Say hello!
서로 인사 나누고, 이번 한주에 대해 얘기하며 친해져요.

2. Vocabularies
처음엔 단어부터 입에 붙도록 연습해야 해요. 주마다 유용한 단어들 같이 읽어보면서 외워봐요.

3. Activities
특정 문장 구조 혹은 단어들로 재밌게 할 수 있는 활동들 가져올거에요. 이때는 틀리더라도 괜찮으니 마구마구 입 밖으로 영어를 뱉어봐요!

4. Grammar
Activity로 익힌 문장구조를 문법 설명으로 연결해드릴 거에요. 먼저 입에 익은 다음에 설명을 들으시면 이해가 더 잘 되실 거에요 :)

5. Free talk
한주간 뭐할 건지, 요즘 고민은 없는 지 자유롭게 이야기 하는 시간입니다. 오늘 배운 문장구조를 써먹을 수 있는 주제로 이야기 나누면 연습이 많이 되실거에요. 제가 듣다가 설명해 드릴 부분은 찾아서 설명해드릴게요!

6. Q&A
Any questions! 무엇이든 물어보세요.


[스터디 목표]

- I am driving / I drive 구별
- I do / I did 구별
- 영어로 질문 만들기
- I will / I am gonna + ~
- I like/love/prefer + ~
- I can/should/must/could/might/would + ~
- Interesting + Interested
- I’d like to + ~ / Would you like to + -

위의 기본 문장구조에 익숙해져 영어로 간단한 의사 표현을 할 수 있게 되는것을 목표로 삼아요! :-)		
	</div>
	<div class="study-detail">
		
	</div>
</section>
<section class="leader-information">
	<header class="front-leader">
	<h1>리더소개</h1>
	<img src="" alt="" class="leader-profile-image" />
	</header>
</section>
<div class="center-leader">
<span>리더 소개 내용 자기소개 줄ㅈ</span>
</div>
</div>


<aside id="action-widget">
<div class="order-action">
	<h1 class='title'>타이틀이여</h1>
	<label for="">회비</label><span class="price">가격</span>
	<span class="term">기간</span>
	<span class="time">주기 시간</span>
	<!-- 참여신청하기, 찜하기 버튼ㄴ -->
</div>
</aside>
</div>



<span>LEVEL : ${study.DNAME }</span>
<span>${study.LNAME }-${study.TNAME }</span>
<span>${study.TITLE }</span>
<span>스터디 소개 : ${study.CONTENT }</span>
<div id="detail">
<span>지역 : ${study.LNAME }-${study.TNAME }</span>
<span>인원 : ${study.RECRUIT }명</span><br />
<span>
	${study.FREQ }
</span>
<span>${study.TIME }</span><br />
<span>신청기간 : ${study.LDATE }까지</span>
<span>수업 기간 : ${study.SDATE }~${study.EDATE }</span>
<span>협의비 : ${study.PRICE }</span>
<hr />
<label for="">리더 소개</label><br />
<c:if test="${study.MPROFILE!=null }">
<img src="${pageContext.request.contextPath}/resources/upload/member/${study.MPROFILE}" alt="" />
</c:if>
<c:if test="${study.MPROFILE==null }">
<img src="${pageContext.request.contextPath}/resources/upload/member/basicprofile.png" alt="" />
</c:if>

<span>${study.COVER }</span>

</div>


<div id="review-container"><!-- 팀장에 대한 후기 -->
<h5>리더에 대한 후기</h5>
<c:if test="${reviewList!=null }">
	<ul class="reviews">
		<c:forEach var="r" items="${reviewList }">
			<li class="review-one">
				<div class="member-photo">
					<img src="${pageContext.request.contextPath }/resources/upload/member/${r.MPROFILE!=null? r.MPROFILE:'basicprofile.png'}" alt="" />
				</div>
				<div class="review-detail">
					<span>${r.MNAME }</span>&nbsp;|&nbsp;<span>${r.POINT }점</span>
					<p>${r.CONTENT }</p>
					<a href="studyView.do?sno=${r.SNO }">${r.TITLE }</a><br />
					<span><fmt:formatDate value="${r.REGDATE }" pattern="yyyy-MM-dd"/></span>
				
					
				</div>
			</li>
		</c:forEach>
	</ul>

</c:if>
<c:if test="${reviewList==null }">
아직 평가가 없습니다.
</c:if>

</div>


</div>
<div id="side-info"> <!-- 오른쪽 fix창 -->
<span>${study.KNAME } : ${study.SUBNAME }</span>
<span>${study.TITLE }</span><br />
<span>${study.SDATE }~${study.EDATE }</span>
<c:if test="${memberLoggedIn==null||memberLoggedIn.getMno()!=study.MNO}">
	<c:if test="${study.STATUS=='모집 중'||study.STATUS=='마감 임박' }">
		<button type="button" id="btn-apply" onclick="studyApply('${study.SNO}');"><span>참여신청하기</span></button>
		<button type="button" id="btn-wish"  onclick="studyWish('${study.SNO}');"><span>찜하기</span></button>
	</c:if>
	
</c:if>	



</div>


</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>	
