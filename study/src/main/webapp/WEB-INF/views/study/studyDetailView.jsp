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
	
	$scrollTop = $(this).scrollTop();
	$wingSection = $(".wingSection"); 
	
	console.log($scrollTop);
	if($("#studyDetails").height() > $(".wingSection").height()+$scrollTop){
	if($scrollTop > 100){
		$wingSection.stop().animate({top: $scrollTop - 145}, 500);  
	}else if($scrollTop <= 100 ){
		$wingSection.stop().animate({top: 0}, 500);
	}
	console.log($(".container").height());
	
	
	}
	
	
})
	
	
	
});


</script>

<style>
#studyDetails .container{position:relative;  margin-top: 10px;  }
.content{background:#fff; width:75%;}
.wingSection{position:absolute; right:0px; top:10px; width:25%; padding:10px; background:#fff; }
.wingSection > div{margin:20px 0px; line-height:1.8rem}
.customBtn{width:100%; background:none; padding:15px 0px; border:none; margin-bottom:10px; cursor:pointer; }
.baseColor{background:#0056e9; color:#fff;  border:1px solid #0056e9;}
.baseColor:hover{background:#fff; color:#0056e9; border:1px solid #0056e9;}
.baseColorRefelct{background:#fff; color:#0056e9; border:1px solid #0056e9;} 
.baseColorRefelct:hover{background:#0056e9; color:#fff;} 
.levelBox{position:relative;height:100px; }
.levelBox .levelWrap{padding:20px; background:#0056e9; position:absolute;top:-2.4rem; left:2.5rem;text-align:center;}
.levelBox .levelWrap span{}
.levelBox .levelWrap .naming{color:#fff}
.levelBox .levelWrap .levels{color:#fff; font-size:1.6rem;}
.informBox{text-align:center; padding:0px 0px 40px 0px;}
.informBox .title{padding:0px 70px 0px 70px; line-height:140%;}
.contentBox{position:relative; overflow:hidden; padding-top:40px; border-top:1px solid #efefef;}
.contentBox > div{float:left; padding-left:20px; box-sizing: border-box;;}
.contentBoxTitle{width:25%; font-weight:bold;}
.contentBoxprofile{padding-top:30px;}
.contentBoxprofile img{width:80px; height:80px; border-radius:100px;  }
.contentBoxContent{width:75%; padding:0px 30px;}
.rm_touchTable{}
.rm_touchTable td, .rm_touchTable th{padding:5px; }
</style>

<div id="studyDetails">
	<div class="container">
		<div class="content">
	
			<div class="sliderSection">
				<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
					<div class="carousel-inner">
						<c:forEach var="img" items="${imgs }" varStatus="vs">
							<div class="carousel-item ${vs.first ? 'active':'' }">
								<img class="d-block w-100 rm_cover_img" src="${rootPath }/resources/upload/study/${img }" alt="slide">
							</div>
						</c:forEach>
					</div>

					<a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev"> <span class="carousel-control-prev-icon" aria-hidden="true"></span> <span class="sr-only">Previous</span>
					</a> <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next"> <span class="carousel-control-next-icon" aria-hidden="true"></span> <span class="sr-only">Next</span>
					</a>

				</div>
			</div>
			<div class="levelBox">
				<div class="levelWrap">
					<span class="naming">LEVEL</span> <br /> <span class="levels"> ${study.DNAME }</span>
				</div>
			</div>		
			<div class="informBox">
				<div>${study.LNAME } ${study.TNAME }</div>	
				<div><h1 class="title">${study.TITLE }</h1></div>
			</div>
			<div class="contentBox">
				<div class="contentBoxTitle">스터디 소개</div>
				<div class="contentBoxContent">${study.CONTENT }</div>
			</div>
			
			<div class="contentBox">
				<div class="contentBoxTitle">상세 정보</div>
				<div class="contentBoxContent">
					<table style="width:100%;" class="rm_touchTable">
						<tr><th style="width:15%">지역 :</th><td style="width:45%">${study.LNAME } ${study.TNAME }</td><th style="width:15%">인원 :</th><td>${study.RECRUIT }명</td></tr>
						<tr><th>일정 :</th><td>${study.SDATE } ~ ${study.EDATE }</td><th>주기 :</th><td>${study.FREQ } </td></tr>
						<tr><th>시간 :</th><td>${study.TIME }</td><th>협의비 :</th><td>${study.PRICE }원 </td></tr>
					</table>
				</div>
			</div>
			<div class="contentBox">
				<div class="contentBoxTitle"> 
					<div>리더소개</div>
					<div class="contentBoxprofile"><img src="${rootPath }/resources/upload/member/${study.MPROFILE}" alt="" class="profile" /></div>
					<div class="pointBox">
						<div>${study.POINT } <span>${memberAvg.AVGPOINT }</span> </div>
						<div>${study.NPOINT } <span>${memberAvg.AVGNPOINT }</span></div>
						<div>${study.EXP } <span>${memberAvg.AVGEXP }</span></div>
					</div>
				</div>
				
				
				<div class="contentBoxContent">${study.CONTENT }</div>
			</div>
			
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
		<div class="wingSection"> 
			<div style="font-weight:bold;">
				원어민 영어발음, Joanne의 쉽고 재밌는 영어회화의 시작!
			</div>
			<div>
				12주 
			</div>
			<div>
				<span>참가비</span><span>24000원</span> 
			</div>
			<div>
				<button class="customBtn baseColor">참여 신청하기</button>
				<button class="customBtn baseColorRefelct">찜하기</button>
			</div> 
			<div>
				<div>리얼 후기</div>
			</div>
			<div>
				<div>신청인원</div>
			</div>
			
		
		</div>
	
	
	

	</div>
</div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>	
