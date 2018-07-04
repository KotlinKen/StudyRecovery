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
		
		// 결제 도전!
		var IMP = window.IMP;
		IMP.init("imp25308825"); // 아임포트에 등록된 내 아이디.		
		var msg = "";
		
		var sno = ${lecture.SNO};
		var mno = ${memberLoggedIn.getMno()};	
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
	        	
	        	if(confirm("결제 하시겠습니까?")){
		         	if( data == "" ){
		         		 IMP.request_pay({
		     			    pg : 'inicis', // version 1.1.0부터 지원.
		     			    pay_method : 'card',
		     			    merchant_uid : 'merchant_' + new Date().getTime(),
		     			    name : '스터디 강의 신청',
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
		     			    }
		   			        alert(msg); 
		     			});
		         	}
		         }
	        	// 없는 경우.
	         	else{
	         		alert("결제를 취소하셨습니다.");
	         	}
	         }
	      }).done(); 		  
	   }
	}
	
	//찜하기 버튼 클릭 이벤트
	function lectureWish(){
		var sno = ${lecture.SNO};
		var mno = ${memberLoggedIn.getMno()};
		
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
	
	function lectureWishCancel(){
		var sno = ${lecture.SNO};
		var mno = ${memberLoggedIn.getMno()};
		
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
		var mno = ${memberLoggedIn.getMno()};
		
		if(confirm("신청을 취소하시겠습니까?")){
			$.ajax({
				url : "lectureCancel.do",
				data : {
					sno : sno,
					mno : mno
				},
				success : function(){
					location.href="${rootPath}/lecture/lectureView.do?sno=" +sno + "&mno=" + mno;
				}
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
	});
	
	// 삭제버튼
	function deleteLecture(){
		if( confirm("강의를 삭제하시겠습니까?")){			
			location.href="${pageContext.request.contextPath}/lecture/deleteLecture.do?sno=" + ${lecture.SNO};
		}
	}
</script>

<div id="lecture-detail">
   <c:if test="${memberLoggedIn.getMno() eq lecture.MNO  }">
      <!-- <button type="button" id="updateLecture" class="btn btn-primary" data-toggle="modal" data-target="#updateModal">수정   </button> -->
      <button type="button" onclick="deleteLecture();">강의 삭제</button>
      <br />
   </c:if>

   <span>LEVEL : ${lecture.DNAME }</span> <span>${lecture.LNAME }-${lecture.TNAME }</span>
   <span>${lecture.TITLE }</span> <br />
   <span>스터디 소개 : ${lecture.CONTENT }</span> 

   <div id="detail">
      <span>지역 : ${lecture.LNAME } ${lecture.TNAME }</span> 
      <span>인원 : ${lecture.RECRUIT }명</span>      
      <br /> 
      
      <span>${lecture.FREQ }</span> <span>${lecture.TIME }</span>      
      <br />
      
      <span>신청기간 : ${lecture.LDATE }까지</span> 
      <span>수업 기간 : ${lecture.SDATE }~${lecture.EDATE }</span> 
      <span>협의비 : ${lecture.PRICE }</span>
      
      <hr />

      <label for="">리더 소개</label> <span>${lecture.COVER }</span>
   </div>

   <!-- 팀장에 대한 후기 -->
   <div id="review">
   
   </div>
   
   <!-- 수정 모달 -->
   <div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
         <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header">
               <h5 class="modal-title" id="exampleModalLabel">강의 수정</h5>
               <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
               </button>
            </div>
            <form action="${pageContext.request.contextPath }/lecture/updateLectureEnd.do" method="post">
               <!-- 모달 바뤼 -->
               <div class="modal-body" >
               
               </div>
               
               <!-- 모달 풋터 -->
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary">Save changes</button>
               </div>
            </form>         
         </div>         
      </div>
   </div>   
</div>

<!-- 오른쪽 fix창 -->
<div id="side-info">
   <span>${lecture.SUBNAME } : ${lecture.KNAME }</span> 
   <span>${lecture.TITLE }</span><br />
   <span>${lecture.SDATE }~${study.EDATE }</span>
   <br />

   <c:if test="${memberLoggedIn.getMno() ne null && memberLoggedIn.getMno() ne lecture.MNO  }">
      <!-- 참여, 찜 -->
      <c:if test="${insert eq 0}">
      
      	<c:if test="${lecture.STATUS == '마감 임박' || lecture.STATUS == '모집 중'}">
	         <button type="button" onclick="lectureApply();" >참여 신청하기</button>
	         
	         <!-- 찜 -->
	         <c:if test="${wish eq 0}">
	            <button type="button" onclick="lectureWish();">찜하기</button>
	         </c:if>
	         <c:if test="${wish ne 0}">
	            <button type="button" onclick="lectureWishCancel();">찜 취소</button>
	         </c:if>
      	</c:if>      	
      	<c:if test="${lecture.STATUS == '모집 마감' || lecture.STATUS == '진행 중' || lecture.STATUS == '강의 종료'}">
	         <button type="button" onclick="lectureApply();" disabled>참여 신청하기</button>
	         
	         <!-- 찜 -->
	         <c:if test="${wish eq 0}">
	            <button type="button" onclick="lectureWish();" disabled>찜하기</button>
	         </c:if>
	         <c:if test="${wish ne 0}">
	            <button type="button" onclick="lectureWishCancel();" disabled>찜 취소</button>
	         </c:if>
      	</c:if>         
      </c:if>
      
      <!-- 신청 취소 -->
      <c:if test="${insert ne 0}">
		<c:if test="${lecture.STATUS == '마감 임박' || lecture.STATUS == '모집 중'}">
			<button type="button" onclick="lectureCancel();">신청 취소</button>
		</c:if>
		<c:if test="${lecture.STATUS == '모집 마감' || lecture.STATUS == '진행 중' || lecture.STATUS == '강의 종료'}">
			<button type="button" onclick="lectureCancel();" disabled>신청 취소</button>
		</c:if>      	
      </c:if>
   </c:if>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />