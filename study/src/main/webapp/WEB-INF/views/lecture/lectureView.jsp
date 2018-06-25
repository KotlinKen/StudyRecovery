<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="https://service.iamport.kr/js/iamport.payment-1.1.5.js" type="text/javascript"></script>
<script>	
	//참여신청 버튼 클릭 이벤트
	function lectureApply(){
		// 결제 도전!
		var IMP = window.IMP;
		IMP.init("imp25308825"); // 아임포트에 등록된 내 아이디.		
		var msg = "";
		
		var sno = ${lecture.SNO};
		var mno = ${memberLoggedIn.getMno()};		
		
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
	         	if( data == 0 ){
	         		 IMP.request_pay({
	     			    pg : 'inicis', // version 1.1.0부터 지원.
	     			    pay_method : 'card',
	     			    merchant_uid : 'merchant_' + new Date().getTime(),
	     			    name : '스터디 강의 신청',
	     			    amount : ${lecture.PRICE},
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
	     			        		
	     			        	}
	     			        });
   			        		msg = '결제가 완료되었습니다.';	     	     			        
	     			    } else {
	     			        msg = '결제에 실패하였습니다.';
	     			        msg += '에러내용 : ' + rsp.error_msg;
	     			    }
	   			        alert(msg); 
	     			});
	         	}
	        	// 없는 경우.
	         	else{
	         		alert("이미 신청하신 강의입니다.");
	         	}
	         }
	      }); 		  
	   }
	}
	
	//찜하기 버튼 클릭 이벤트
	function lectureWish(){
		var sno = ${lecture.SNO};
		
	   //세션에서 멤버의 mno 받아옴 로그인 안한상태에 대해서도 분기 처리.
	   //찜하기를 이미 선택했다면 다시 누르면 찜하기에서 삭제됨.
	   $.ajax({
	      url:"wishLecture.do",
	      data:{
	    	  sno : sno,
	    	  mno : 2
	      },
	      success:function(data){
	         console.log("찜했다");
	         //신청 완료 후 button에 스타일 주어서 이미 신청했음을 표시하게 한다.
	      }
	   });
	}
	
	$(function(){   
	   $("button.editLecture").click(function(){
	      location.href="lectureUpdate.do?sno="+${lecture.SNO};	      
	   });   
	   
	   $("#updateLectureBtn").click(function(){
		   location.href = "lectureUpdate.do?sno=" + ${lecture.SNO};
	   });
	});
	// 삭제버튼
	function deleteLecture(){
		location.href="${pageContext.request.contextPath}/lecture/deleteLecture.do?sno=" + ${lecture.SNO};
	}
</script>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div id="study-detail">
	<c:if test="${memberLoggedIn.getMno() eq lecture.MNO  }">
		<button type="button" id="updateLectureBtn">강의 수정</button>
		<button type="button" onclick="deleteLecture();">강의 삭제</button>
	</c:if>

	<span>LEVEL : ${lecture.DNAME }</span> <span>${lecture.LNAME }-${lecture.TNAME }</span>
	<span>${lecture.TITLE }</span> <span>스터디 소개 : ${lecture.CONTENT }</span>

	<div id="detail">
		<span>지역 : ${lecture.LNAME } ${lecture.TNAME }</span> 
		<span>인원 : ${lecture.RECRUIT }명</span>
		
		<br /> 
		
		<span>${lecture.FREQ }</span> <span>${lecture.TIME }</span>
		
		<br />
		
		<span>신청기간 : ${lecture.LDATE }까지</span> 
		<span>수업 기간 : ${lecture.SDATE }~${lecture.EDATE }</span> 
		<span>협의비 : 	${lecture.PRICE }</span>

		<hr />

		<label for="">리더 소개</label> <span>${lecture.COVER }</span>
	</div>

	<!-- 팀장에 대한 후기 -->
	<div id="review"></div>
</div>

<!-- 오른쪽 fix창 -->
<div id="side-info">
	<span>${lecture.SUBNAME } : ${lecture.KNAME }</span> 
	<span>${lecture.TITLE }</span><br />
	<span>${lecture.SDATE }~${study.EDATE }</span>

	<c:if test="${memberLoggedIn.getMno() ne lecture.MNO  }">
		<button type="button" onclick="lectureApply();">참여 신청하기</button>
		<button type="button" onclick="lectureWish();">찜하기</button>
	</c:if>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />