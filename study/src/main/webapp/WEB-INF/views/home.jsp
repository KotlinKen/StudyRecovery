<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="스터디 그룹트" name="pageTitle"/></jsp:include>
<%@ page import="java.sql.*, java.util.*"%>
<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
  <ol class="carousel-indicators">
    <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
    <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img class="d-block w-100" src="${rootPath }/resources/images/grooupt01.jpg" alt="First slide">
        <div class="carousel-caption d-none d-md-block">
	    <h2 class="text-left">지금! 스터디 그룹트와</h2>
	    <h2 class="text-left" style="font-weight:normal">함께하세요</h2>
	    <p class="text-left"  style="font-weight:normal">지금 스터디를 등록하고 새로운 사람들과 함께하세요!</p>
  	</div>
    </div>
    <div class="carousel-item">
      <img class="d-block w-100" src="${rootPath }/resources/images/grooupt02.jpg" alt="Second slide">
        <div class="carousel-caption d-none d-md-block">
	    <h2 class="text-left">혼자 공부하는데 </h2>
	    <h2 class="text-left"  style="font-weight:normal">어려움이 있나요?</h2>
	    <p class="text-left"  style="font-weight:normal">스터디 그룹트는 그룹스터디 매칭 부터,<br> 실력되는 강사분들에게 직접 배울수 있습니다.</p>
  </div>
    </div>
 
  </div>
  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>


<section class="studylist-section">

<div class="container">

</div>
<div id="container" class="section-content container rm_study_list studies pixler">
	<div class="content">
		<div class="clearfix titlebar">
			<div class="float-left titlebox">
				<h3>GROUP STUDY</h3>
			</div>
			<a href="${rootPath }/study/studyList.do" class="btn float-right btn_all">전체보기</a>
		</div>

			<ul class="nav studiesCategory">
				<li class="nav-item"><a class="nav-link">전체 보기</a></li>
				<li class="nav-item"><a class="nav-link">마감 임박</a></li>
				<li class="nav-item"><a class="nav-link">모집 중</a></li>
				<li class="nav-item"><a class="nav-link">진행 중</a></li>
				<li class="nav-item"><a class="nav-link">스터디 종료</a></li>
			</ul>

			<ul class="list">
			</ul>
	</div>
</div>
</section>
<div class="container">
	<hr>
</div>
<section class="lecturelist-section">
	<div class="container">

	</div>
	<div id="container" class="section-content container rm_study_list lectures pixler">
		<div class="content">
			<div class="clearfix titlebar">
				<div class="float-left titlebox">
					<h3>LECTURE</h3>
				</div>
				<a href="${rootPath }/lecture/lectureList.do" class="btn float-right btn_all">전체보기</a>
			</div>
			<ul class="nav lectureCategory">
				<li class="nav-item"><a class="nav-link">전체 보기</a></li>
				<li class="nav-item"><a class="nav-link">마감 임박</a></li>
				<li class="nav-item"><a class="nav-link">모집 중</a></li>
				<li class="nav-item"><a class="nav-link">진행 중</a></li>
				<li class="nav-item"><a class="nav-link">강의 종료</a></li>
			</ul>
			<ul class="list">
			</ul>
		</div>
	</div>
</section>


<section class="advantage-section">
	<div class="section-content container">
		<div class="content">
			<div class="main_section_title">
				<span class="highlight">스터디 그룹트,</span><br> 어떤 점이 좋나요?
			</div>
			<ul class="section-list">
				<li class="advantage col-4 type-1">
				<div class=" "></div>
					<div class="title">나도 알려주고, 배우고!</div>
					<div class="description">
						배우기만 하는 시대는 끝!
						<br>
						알려줄수도 있고 공부도 할 수 있는!
					</div></li>
				<li class="advantage col-4  type-2"><div class=""></div>
					<div class="title">상호평가로 그룹 선택이 쉬워져요!</div>
					<div class="description">
						선호하는 성향을 알수 있는 가장 기본!
						<br>
						꼭 맞는 사람들끼리 시작해요 :)
					</div></li>
				<li class="advantage col-4  type-3"><div class="advantage-icon"></div>
					<div class="title">다양한 지역 및 시간대</div>
					<div class="description">
						평일 낮부터 밤, 그리고 주말까지!
						<br>
						내게 딱 맞는 시간대를 찾아보세요 :D
					</div></li>
			</ul>
		</div>
	</div>
</section>



<section class="statistics-section">
	<div class="section-content container">
		<div class="content">
			<div class="main_section_title">
				<span class="highlight">스터디 그룹트와</span><br>함께 하고 있습니다.
			</div>
			<ul class="section-list">
				<li class="statistics col-4 type-1"><div class="studyCounter" style="display:block; font-size:3.4rem"></div>
					<div class="title">스터디 개설수</div>
					<div class="description">
						입문부터 고급까지 7개의
						<br>
						세부 레벨로 진행되는 스터디에요!
					</div></li>
				<li class="statistics col-4 type-2"><div class="lectureCounter" style="display:block; font-size:3.4rem"></div>
					<div class="title">스터디 그룹트 강의 개설수</div>
					<div class="description">
						도란도란 정예 멤버로
						<br>
						꼭 맞는 사람들끼리 시작해요 :)
					</div></li>
				<li class="statistics col-4 type-3"><div class="memberCounter" style="display:block; font-size:3.4rem"></div>
					<div class="title">누적 스터디 멤버</div>
					<div class="description">
						평일 낮부터 밤, 그리고 주말까지!
						<br>
						내게 딱 맞는 시간대를 찾아보세요 :D
					</div></li>
			</ul>
		</div>
	</div>
</section>




<section class="instructorjoin-section backCover" style="padding: 50px 0px; background:url('${rootPath}/resources/images/co_study2.jpg'); background-size: cover; object-position: center; background-position: center center; background-repeat: no-repeat;">
	<div class="section-content container">
		<div class="content" style="color:#fff;">
			<div class="main_section_title">
				<span class="highlight" style="font-size:3rem;">그룹트 강사 </span><br>어렵지 않아요!
			</div>
			<ul class="section-list">
				<li class="instructorjoin col-4 type-1"><div class="advantage-icon"></div>
					<div class="title">내가 편한 지역, 편한 시간에</div>
					<div class="description"> 
						<a href="${rootPath }/member/memberAgreement.do" style="display:block; font-size:1.1rem; color:#fff; background:#0056e9; border-radius:30px; margin-top:30px; padding:10px 20px; ">신청하러 가기</a>
					</div></li>
			</ul>
		</div>
	</div>
</section>




<script>
$(function(){

	categoryList('study', "", 6, "SREGDATE", 'desc');
	categoryList('lecture', "", 6, "SREGDATE", 'desc');
	$('.carousel').carousel();
	
	$.ajax({
		url:"${rootPath}/rest/counter",
		dataType:"json",
		success:function(data){
        	$(".studyCounter").html(numberWithCommas(data.study+35102));
        	$(".lectureCounter").html(numberWithCommas(data.lecture+1320));
        	$(".memberCounter").html(numberWithCommas(data.member+3912912));
		},error:function(){
			
		}
	});
	

	

})

$(".lectureCategory li a").click(function(){
	if($(this).text() == "전체 보기"){status = "";}else{status=$(this).text();}
	
	$(this).addClass("active");
	$(".lectureCategory li a").not($(this)).removeClass("active");
	categoryList('lecture', status, 6, "SDATE", 'desc');
});
$(".studiesCategory li a").click(function(){
	if($(this).text() == "전체 보기"){status = "";}else{status=$(this).text();}
	$(this).addClass("active");
	$(".studiesCategory li a").not($(this)).removeClass("active");
	categoryList('study', status, 6, "SDATE", 'desc');
});


function categoryList(type, status, rownum, order, desc){

	$.ajax({
		url:"${rootPath}/rest/home/restTypeLister",
		dataType:"json",
		data : {type : type, status : status , rownum : rownum , order : order, desc: desc },
		success:function(data){
			var rmHtml = "";
        		console.log(data);
        	for(index in data.list){
        		var upfiles = data.list[index].UPFILE;
        		if(upfiles != null){
        			var upfile = upfiles.split(",");
        		
        		var study = data.list[index]; 
        		
        		rmHtml += "<li class='col-md-4'>";
        		rmHtml += "<div class='pixel'>";
        		
        		
        		if(type == "study"){       		
	       			rmHtml += "<a href='${rootPath}/study/studyView.do?sno="+study.SNO+"'>";
	   				rmHtml += "<div class='photoSection'>";
   					rmHtml += 	"<div style='background-image:url(${rootPath}/resources/upload/study/"+upfile[0]+"), url(${rootPath}/resources/images/nones.gif)'></div>";
   				}else{
	       			rmHtml += "<a href='${rootPath}/lecture/lectureView.do?sno="+study.SNO+"&mno=" + ${memberLoggedIn != null ? memberLoggedIn.getMno():"0"} +"'>";
	  				rmHtml += "<div class='photoSection'>";	
	   				rmHtml += 	"<div style='background-image:url(${rootPath}/resources/upload/lecture/"+upfile[0]+"), url(${rootPath}/resources/images/nones.gif)'></div>";
   				}
        		
   				rmHtml += "</div>";
				rmHtml += "<div class='inforSection'>";
  				rmHtml += 	"<h4>"+data.list[index].TITLE.substring(0, 18)+"</h4>";
/*   				rmHtml += 	"<div class='profile'><img src='${rootPath}/resources/upload/study/20180625_215620103_62.gif' /></div>"; */
  				rmHtml += 	"<div class='profile'><img src='${rootPath}/resources/upload/member/"+study.MPROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
  				rmHtml += 	"<div class='profileName'>"+study.MID+"</div>";
  				rmHtml += 	"<div class='profileInfors'>";
  				rmHtml += 	"<div class='nPoint'>N :"+study.NPOINT+"</div>";
  				rmHtml += 	"<div class='point'>P : "+study.POINT+"</div>";
  				rmHtml += 	"<div class='exp'>E : "+study.EXP+"</div>";
  				rmHtml += 	"</div>";
  				
   				rmHtml += "</div>";
				rmHtml += "<div class='metaSection'>";
  				rmHtml += 	"<p>"+study.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
  				/* rmHtml += 	"<p>"+ "내용이 없네 정말.."+"</p>"; */
   				rmHtml += "</div>";
				rmHtml += "<div class='localSection'>";
  				rmHtml += 	"<div class='study'>"+study.SUBJECTNAME+"</div>";
  				rmHtml += 	"<div class='local'>"+study.LOCAL+"</div>";
  				rmHtml += 	"<div class='level'>"+study.DIFFICULTNAME+"</div>";


  				
  				if(study.STATUS =='강의 종료'){
  					rmHtml += 	"<div class='time' style='background:#000; color:#fff;'>"+study.STATUS+"</div>";
  				}else{
  					rmHtml += 	"<div class='time'>"+study.STATUS+"</div>";
  				}
   				rmHtml += "</div>";
   				rmHtml += "<div class='subMeta'>";
   				rmHtml += "<div class='applycnt'>"+study.APPLYCNT+"</div>";
  				rmHtml += "<div class='ldate'>"+formatDate(new Date(study.LDATE))+"</div>";
  				rmHtml += "<div class='term'>"+formatDate(new Date(study.SDATE))+" ~ "+formatDate(new Date(study.EDATE)) +"</div>";
   				rmHtml += "</div>";
   				rmHtml += "</a>"
        		rmHtml += "</div>"
        		rmHtml += "</li>"
        		}
        	}
        	if(type =='lecture'){
				$(".lectures .list").html(rmHtml);
        	}else{
				$(".studies .list").html(rmHtml);
        	}
        	
		},error:function(){
			
		}
	});
	
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}


$(".rm_study_list").on("mouseenter mouseleave", ".profile", function(e){
	$pf = $(this);
	console.log($pf.siblings("div.profileInfors"));
	
	
	console.log(e.type);
	
	if(e.type=="mouseenter"){
		$pf.siblings("div.profileInfors").css({"display":"block"}).stop().animate({ "opacity" : "0.9"}, 100);
	}else{
		$pf.siblings("div.profileInfors").stop().animate({ "opacity" : "0"}, 100,"linear", function(){console.log($(this).css({"display": "none"}))});
	}
	
});

</script>
<style>
.pixler .inforSection::before{
	position: absolute;
    top: -81px;
    left: 56%;
    content: "";
    display: block;
    width: 125px;
    height: 107px;
    background-position: center center;
    background-repeat: no-repeat;
    background-size: 156px auto;
    background-image: url(${rootPath}/resources/images/before.svg);
    clip: rect(-13px, 199px, 60px, 0px);
    z-index: 0;
}

@media (min-width: 1025px) {

.pixler .inforSection::before{
    top: -81px;
    left: 64%;
}
  
}
.carousel-caption{
	position: absolute;
    left: 20%;
    top: 25%;
    z-index: 10;
    padding-top: 20px;
    padding-bottom: 20px;
    color: #fff;
    text-align: center;
	

}
.carousel-caption *{
font-family: 'Noto Sans KR', sans-serif;
}
.carousel-caption{
	padding-left:40px;
}
</style>
<jsp:include page ="/WEB-INF/views/common/footer.jsp" />