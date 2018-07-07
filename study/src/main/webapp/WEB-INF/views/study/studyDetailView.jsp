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
	
	if($("#studyDetails").height() > $(".wingSection").height()+$scrollTop){
	if($scrollTop > 60){
		$wingSection.stop().animate({top: $scrollTop - 145});  
	}else{
		$wingSection.stop().animate({top: $scrollTop});
	}
	console.log($(".container").height());
	
	
	}
	
	
})
	
	
	
});


</script>

<style>
#studyDetails .container{position:relative; height:900px; margin-top: 10px;  }
.content{background:red; width:75%;}
.wingSection{position:absolute; right:0px; top:10px; width:25%; padding:10px; background:#fff; }
.wingSection > div{margin:20px 0px; line-height:1.8rem}
.customBtn{width:100%; background:none; padding:15px 0px; border:none; margin-bottom:10px; cursor:pointer; }
.baseColor{background:#0056e9; color:#fff;  border:1px solid #0056e9;}
.baseColor:hover{background:#fff; color:#0056e9; border:1px solid #0056e9;}
.baseColorRefelct{background:#fff; color:#0056e9; border:1px solid #0056e9;} 
.baseColorRefelct:hover{background:#0056e9; color:#fff;} 
</style>

<div id="studyDetails">
	<div class="container">
		<div class="content">
			<div class="sliderSection">
				<div class="levelBox">
					<span class="naming">LEVEL</span> <br /> <span class="levels"> ${study.DNAME }</span>
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
