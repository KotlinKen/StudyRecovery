<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<script src="https://service.iamport.kr/js/iamport.payment-1.1.5.js" type="text/javascript"></script>
<script>
	//참여신청 버튼 클릭 이벤트
	function lectureApply(){
		
		if(${memberLoggedIn==null}) $("a#btn-login").trigger('click');
		else{
			// 결제 도전!
			var IMP = window.IMP;
			IMP.init("imp25308825"); // 아임포트에 등록된 내 아이디.		
			var msg = "";
			
			var sno = ${lecture.SNO};
			var mno = ${memberLoggedIn != null ? memberLoggedIn.getMno():"0"};	
			var price = 100;
			
		   //세션에서 멤버의 mno 받아옴 로그인 안한상태에 대해서도 분기 처리.
		   //이미 신청을 했으면 return;하게 만들어야 함. 
		   //임시로 confirm. 계획은 부트스트랩 모달창에 주요 정보 나열 후 확인버튼누르면 아작스 실행.	   
		   if(confirm("신청하시겠습니까")) {
			    $.ajax({
		         url:"findLecture.do",
		         data:{
		        	    sno : sno,
		        	 	mno : mno
		         },
		         success:function(data){
		        	//강의를 등록할 수 있는 경우. 
		        	if( data == ""){	        		
				       	if(confirm("결제 하시겠습니까?")){
			         		 IMP.request_pay({
			     			    pg : 'inicis', // version 1.1.0부터 지원.
			     			    pay_method : 'card',
			     			    merchant_uid : 'merchant_' + new Date().getTime(),
			     			    name : '강의 신청',
			     			    amount : 100,
			     			    m_redirect_url : 'https://www.yourdomain.com/payments/complete'
			     			}, function(rsp) {
			     			    if ( rsp.success ) {	    			    	
			     			        $.ajax({
			     			        	url : "applyLecture.do",
			     			        	data: {
			     			        		sno : sno,
			     			        		mno : mno
			     			        	},
			     			        	success:function(data){
			     			        		var pno = rsp.imp_uid.replace("imp_", "");
			     			        		
			     			        		location.href = "successPay.do?mno=" + mno + 
			     			        									 "&sno=" + sno + 
			     			        									 "&pno=" + pno + 
			     			        									 "&price=" + price;
			     			        	}
			     			        });
		   			        		msg = '결제가 완료되었습니다.';	     	     			        
			     			    } else {
			     			    	var pno = rsp.imp_uid.replace("imp_", "");
			     			    	
			     			    	location.href = "failedPay.do?mno=" + mno + 
																 "&sno=" + sno + 
																 "&pno=" + pno + 
																 "&price=" + price;
			     			    	
			     			        msg = '결제에 실패하였습니다.';
			     			        msg += '에러내용 : ' + rsp.error_msg;
			     			        alert(msg);
			     			    }
			     			});
			         	}
		        	}
		        	// 없는 경우.
		         	else{
		         		if( data != "결제를 취소하셨습니다")
		         			msg = data;
		         		else
		         			msg = "결제를 취소하셨습니다.";
		         	}
		         }
		      }).done(function(){
		    	  if( msg != "" )
		    	  	alert(msg);
	         });		  
		   }
			
		}
		
	}
	
	//찜하기 버튼 클릭 이벤트
	function lectureWish(){
		var sno = ${lecture.SNO};
		var mno = ${memberLoggedIn != null ? memberLoggedIn.getMno():"0"};
		if(${memberLoggedIn==null}) $("a#btn-login").trigger('click');
		else{
			var wishBtn = $("#lectureWishBtn").val();
			
			$.ajax({
				url : "lectureWish.do",
				data : {
					sno : sno,
					mno : mno
				},
				success : function(){
					if(confirm("찜하시겠습니까?"))
						location.href="${rootPath}/lecture/lectureView.do?sno=" +sno + "&mno=" + mno;
				}
			});
		}
		
	}
	
	function lectureWishCancel(){
		var sno = ${lecture.SNO};
		var mno =  ${memberLoggedIn != null ? memberLoggedIn.getMno():"0"};
		
		$.ajax({
			url : "lectureWishCancel.do",
			data : {
				sno : sno,
				mno : mno
			},
			success : function(){
				if(confirm("찜 취소하시겠습니까?")){
					location.href="${rootPath}/lecture/lectureView.do?sno=" +sno + "&mno=" + mno;
				}
			}
		});
	}
	
	function lectureCancel(){		
		var sno = ${lecture.SNO};
		var mno =  ${memberLoggedIn != null ? memberLoggedIn.getMno():"0"};
		
		if(confirm("신청을 취소하시겠습니까?")){
			$.ajax({
				url : "selectPay.do",
				data : {
					mno : mno,
					sno : sno
				},
				success : function(data){
					console.log(pno);
					var pno = data;
					var price = ${lecture.PRICE};
					
					$.ajax({
						url : "lectureCancel.do",
						data : {
							sno : sno,
							mno : mno,
							pno : pno,
							price : price
						},
						success: function( data ){
						}
					});						
				}
			}).done(function(){
				alert("취소되었습니다");
				location.href="${rootPath}/lecture/lectureView.do?sno=" +sno + "&mno=" + mno;
			});
		}
	}
	
	$(function(){   
		$("#updateLecture").click(function(){
			var sno = ${lecture.SNO};
			
			$.ajax({			 
				url : "updateLecture.do",
				data : {sno : sno},
				dataType : "html",
				success: function( data ){
				 	$(".modal-body").html(data);
				}
			});    
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
		
		
		
	});
	
	// 삭제버튼
	function deleteLecture(){
		if( confirm("강의를 삭제하시겠습니까?")){			
			location.href="${pageContext.request.contextPath}/lecture/deleteLecture.do?sno=" + ${lecture.SNO};
		}
	}
</script>
<!-- css 씌우기 -->
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
	background:white;
	overflow: hidden;
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
button.btn-apply{
	background:#ef6c00;
	color:white;
}
ul.reviews{
	overflow:hidden;
}
li.review-one{
	overflow:hidden;
}
</style>
<c:set var="imgs" value="${fn:split(lecture.UPFILE,',')}"/>
<div class="leader-btn-wrap">
	
		<c:if test="${memberLoggedIn!=null }">
			<c:if test="${memberLoggedIn.getMno() eq lecture.MNO  }">
				<c:if test="${lecture.STATUS=='모집 중'||lecture.STATUS=='마감 임박'}">
					<button type="button" class="removeStudy btn" onclick="deleteLecture();">강의 삭제</button>
				</c:if>
		      
		      <br />
		   </c:if>
		</c:if>

</div>
<div class="studyView-container">
	

<div id="study-detail">
	<div class="study-wrap">
	

<%-- <input type="hidden" id="isWish" value="${isWish }" /> --%>
<div class="study-info">
<header class="front-info">
<div class="study-images">
	<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
	  <div class="carousel-inner">
		   <c:forEach var="img" items="${imgs }" varStatus="vs"> 
				<div class="carousel-item ${vs.first? 'active':'' }">
			     	<img class="d-block w-100" src="${pageContext.request.contextPath }/resources/upload/lecture/${img }" alt="Second slide">
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
	<div class="level">${lecture.DNAME }</div>
</div>
<p class="area">${lecture.LOCAL } | ${lecture.TNAME }</p>
<div class="title-wrap">
	<h1 class="title">${lecture.TITLE }</h1>
</div>
</div>
</header>
<div class="center-content">
<section class="study-infomation">
	<div class="introduce-wrap">
		<h2 class="section-label">스터디 소개</h2>
		<div class="study-description section-content">
			${lecture.CONTENT }
		</div>
	</div>
	<hr />
	<div class="study-detail">
		<h3 class='section-label'>상세 정보</h3>
		<div class="section-content">
			<dl id="deatil-list">
				<dt>지역 :</dt>
				<dd>${lecture.LOCAL } | ${lecture.TNAME }</dd>
				<dt class="right-column">인원 : </dt>
				<dd class="right-column">${lecture.RECRUIT }명</dd>
				<dt>일정:</dt>
				<dd>${lecture.SDATE }~${lecture.EDATE }</dd>
				<dt class="right-column">주기</dt>
				<dd class="right-column">${lecture.FREQ }  </dd>
				<dt>시간</dt>
				<dd>${lecture.TIME }</dd>
				<dt class="right-column">강의료</dt>
				<dd class="right-column">${lecture.PRICE }원</dd>
			</dl>
		
		</div>
	</div>
</section>

<section class="leader-information">
	<hr />
	<div class="leader-wrap">
		<header class="front-leader section-label" style="margin-bottom: 20px;">
			
		<h3 class="leader-label">강사 소개</h3>
		<img src="${pageContext.request.contextPath }/resources/upload/member/${lecture.PROFILE}" alt="" class="leader-profile-image" />
		</header>
	
		<div class="center-leader section-content">
			<span>${lecture.COVER }</span>
		</div>
	</div>
	
</section>

</div>


</div>
<br />

<div id="review-container"><!-- 팀장에 대한 후기 -->
<h5 style="font-weight:bold; margin-left:20px; margin-bottom:10px;">강사에 대한 후기</h5>
<c:if test="${reviewList!=null }">
	<ul class="reviews">
		<c:forEach var="r" items="${reviewList }">
			<li class="review-one">
				<div class="member-photo section-label">
					<img src="${pageContext.request.contextPath }/resources/upload/member/${r.MPROFILE!=null? r.MPROFILE:'basicprofile.png'}" alt="" />
				</div>
				<div class="review-detail section-content">
					<span>${r.MNAME }</span>&nbsp;|&nbsp;<span>${r.POINT }점</span>
					<pre>${r.CONTENT }</pre>
					<a href="lectureView.do?sno=${r.SNO }">${r.TITLE }</a>
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
		<h1 class='title'>${lecture.TITLE }</h1>
		<label for="">신청 기간 : </label> <span class="side-info">~${lecture.LDATE }</span><br />
		<label for="">스터디일정 : </label> <span class="side-info">${lecture.SDATE }~${lecture.EDATE }</span><br />
		<label for="">강의료 : </label> <span class="price side-info">${lecture.PRICE }원</span><br />
		<label for="">신청 현황 : </label>&nbsp;&nbsp;<span>${lecture.CNT }</span>/<span>${lecture.RECRUIT }명</span>
		  <c:if test="${memberLoggedIn== null || memberLoggedIn.getMno() ne lecture.MNO  }">
	      <!-- 참여, 찜 -->
	      <c:if test="${insert eq 0}">
	      
	      	<c:if test="${lecture.STATUS == '마감 임박' || lecture.STATUS == '모집 중'}">
		         <button type="button" class="btn btn-apply" onclick="lectureApply();" >참여 신청하기</button>
		         
		         <!-- 찜 -->
		         <c:if test="${wish eq 0}">
		            <button type="button" class="btn btn-wish" onclick="lectureWish();">찜하기</button>
		         </c:if>
		         <c:if test="${wish ne 0}">
		            <button type="button" class="btn btn-wish" onclick="lectureWishCancel();">찜 취소</button>
		         </c:if>
	      	</c:if>      	
	      	<c:if test="${lecture.STATUS == '모집 마감' || lecture.STATUS == '진행 중' || lecture.STATUS == '강의 종료'}">
		         <button type="button" class="btn btn-apply" onclick="lectureApply();" disabled>참여 신청하기</button>
		         
		         <!-- 찜 -->
		         <c:if test="${wish eq 0}">
		            <button type="button" class="btn btn-wish" onclick="lectureWish();" disabled>찜하기</button>
		         </c:if>
		         <c:if test="${wish ne 0}">
		            <button type="button" class="btn btn-wish" onclick="lectureWishCancel();" disabled>찜 취소</button>
		         </c:if>
	      	</c:if>         
	      </c:if>
	      
	      <!-- 신청 취소 -->
	      <c:if test="${insert ne 0}">
			<c:if test="${lecture.STATUS == '마감 임박' || lecture.STATUS == '모집 중'}">
				<button type="button" class="btn btn-apply" onclick="lectureCancel();">신청 취소</button>
			</c:if>
			<c:if test="${lecture.STATUS == '모집 마감' || lecture.STATUS == '진행 중' || lecture.STATUS == '강의 종료'}">
				<button type="button" class="btn btn-apply" onclick="lectureCancel();" disabled>신청 취소</button>
			</c:if>      	
	      </c:if>
	   </c:if>
	</div>
	</aside>
	</div>

</div><!-- 전체 -->

<div class="no"></div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />