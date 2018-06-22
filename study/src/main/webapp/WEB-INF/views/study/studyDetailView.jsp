<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 <jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 
	<c:set var="imgs" value="${fn:split(study.UPFILE,',')}"/>
<style>
	.rm_cover_img{object-fit:cover; height:350px;}
</style>

<script>
var mno = "${memberLoggedIn.getMno()}";

function studyApply(sno){
	
	if(mno == ""){
		if(confirm("회원 가입후 이용하세요")){
			console.log("회원가입을 하시게요~");
		}
	}else{
		if(confirm("신청하시겠습니까")) {
			$.ajax({
				url:"applyStudy.do",
				data:{sno:sno},
				success:function(data){
					if(data!=0){
						alert("신청되었습니다.");
					}else{
						alert("이미 신청한 스터디입니다.");
					}
					//신청 완료 후 button에 스타일 주어서 이미 신청했음을 표시하게 한다.
				},error:function(){
					
				}
			});
		}
	}

}

//찜하기 버튼 클릭 이벤트
function studyWish(sno){
	var mno = "${memberLoggedIn.getMno()}";
	if(mno == ""){
		
		
	}
	if(mno != null || mno != ''){ 	//세션에서 멤버의 mno 받아옴 로그인 안한상태에 대해서도 분기 처리.
	//찜하기를 이미 선택했다면 다시 누르면 찜하기에서 삭제됨.
		$.ajax({
			url:"wishStudy.do",
			data:{sno:sno},
			success:function(data){
				console.log("찜했다");
				//신청 완료 후 button에 스타일 주어서 이미 신청했음을 표시하게 한다.
			},error:function(){
				
			}
		});
	}else{
		if(conrim("회원 가입후 이용하세요")){
			console.log("회원가입을 하시게요~");
		}
		
	}

}
$(function(){
	
	$("button.editStudy").click(function(){
		location.href="studyUpdate.do?sno="+${study.SNO};
		
	});
	
	$("button.removeStudy").click(function(){
		if(confirm("정말 삭제하시겠습니까?")){
			location.href="deleteStudy.do?sno="+${study.SNO};

		}
	});
		
	
	
	
});


$(function(){
$(window).scroll(function(){
	console.log($(this).scrollTop());
	
	$scrollTop = $(this).scrollTop();
	$wingSection = $(".wingSection"); 
	if($scrollTop > 200){
		console.log("test");
		$wingSection.removeClass("col-md-4");		
		$wingSection.addClass("fixed");
		
	}else{
		console.log("none");
		$wingSection.removeClass("fixed");		
		$wingSection.addClass("col-md-4");
	}
	
})
	
	
	
});


</script>

<style>
section#content {
	padding: 0px;
}

#studyDetails {
	
}

#studyDetails .contentSection {
	padding: 0px;
}
#studyDetails .contentSection .sliderSection {
position: relative; 
}



#studyDetails .wingSection {
	padding-left: 15px;
	position: relative;
	top: 0px;
	right: 0px;
}

#studyDetails .wingSection .wingWrap {
	background: #ececec;
	padding: 10px;
}

#studyDetails .fixed {
	position: fixed;
	bacgkround: red;
	left: 60%;
	top: 0%;
}

.levelBox {
	position: absolute;
	background: #EF6C00;
	width: 100px;
	height: 100px;
	z-index: 10;
	bottom: -50px;
	left: 35px;
	text-align:center;
}
.naming{display:inline-block ;font-weight:bold; font-size:1.6rem; color:#FEE538; padding-top:15px; }
.levels{color:#fff; font-size:1.4rem;}
.studyViewContent{margin-top:80px;  word-break : keep-all; text-align:center;}
.titleSection{padding:10px 50px 20px 50px; font-weight:bold;  }
.localSection{color:#999;}
.studyInfoSection{text-align: left;}

</style>

<div id="studyDetails">
	<div class="container">
		<div class="row">
			<div class="contentSection col-md-8">
				<div class="sliderSection">
					<div class="levelBox">
						<span class="naming">LEVEL</span> <br />
						<span class="levels"> ${study.DNAME }</span>		
					</div>
					
					<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
						<div class="carousel-inner">
							<c:forEach var="img" items="${imgs }" varStatus="vs">
								<div class="carousel-item ${vs.first? 'active':'' }">
									<img class="d-block w-100 rm_cover_img" src="${pageContext.request.contextPath }/resources/upload/study/${img }" alt="Second slide">
								</div>
							</c:forEach>
						</div>

						<a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev"> <span class="carousel-control-prev-icon" aria-hidden="true"></span> <span class="sr-only">Previous</span>
						</a> <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next"> <span class="carousel-control-next-icon" aria-hidden="true"></span> <span class="sr-only">Next</span>
						</a>

					</div>
				</div>
				
				
				
				
				<div class="studyViewContent">
					<div class="localSection">${study.LNAME } ${study.TNAME }</div>
					<div class="titleSection"><h2>${study.TITLE }</h2></div>
					<div class="studyInfoSection row">
						<div class="float-left col-md-4">스터디 소개</div>
						<div class="float-right col-md-8">${study.CONTENT }</div>
					</div>
					<div>3</div>
					<div>4</div>
				
				
				</div>
				
				
				
				
				<div>3</div>
				<div>4</div>
			
			
			</div>
			<div class="wingSection col-md-2">
				<div class="wingWrap"> 
					<div>1</div>
					<div>2</div>
					<div>3</div>
					<div>4</div>
				</div>
			</div>
		</div>
	</div>
</div>








<div id="study-detail">
	<c:set var="imgs" value="${fn:split(study.UPFILE,',')}"/>
	
<button type="button" class="editStudy">스터디 수정</button> <!-- 팀장일때만 나타날 것임. -->
<button type="button" class="removeStudy">스터디 삭제</button><!-- 팀장일때만 나타날 것임. -->


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
<label for="">리더 소개</label>
		<c:if test="${study.MPROFILE!=null }">
			<img src="${pageContext.request.contextPath}/resources/upload/member/${study.MPROFILE}" alt="" />
		</c:if>
		<c:if test="${study.MPROFILE==null }">
			<img src="${pageContext.request.contextPath}/resources/upload/member/basicprofile.png" alt="" />
		</c:if>

		<span>${study.COVER }</span>

</div>


<div id="review"><!-- 팀장에 대한 후기 -->


</div>


</div>
<div id="side-info">
	<!-- 오른쪽 fix창 -->
	<span>${study.KNAME } : ${study.SUBNAME }</span> <span>${study.TITLE }</span><br /> <span>${study.SDATE }~${study.EDATE }</span>
	<button type="button" onclick="studyApply('${study.SNO}');">
		<span>참여신청하기</span>
	</button>
	<button type="button" onclick="studyWish('${study.SNO}');">
		<span>찜하기</span>
	</button>


</div>


</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>	
