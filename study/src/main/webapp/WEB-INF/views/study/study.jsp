<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 
<link href="https://fonts.googleapis.com/css?family=Gaegu|Song+Myung" rel="stylesheet">
<script>
$(function(){
	$("p#noMore").addClass("noMore");
	
	$("#subject").hide();
	$("#town").hide();
	
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
	
	/* 처음에 조건없이 리스트를 가져오는 ajax */
	$.ajax({
		url:"selectStudyList.do",
		dataType:"json",
		success:function(data){
			$("input#total").val(data.total);
			$("input#numPerPage").val(data.numPerPage);
			$("input#cPageNo").val(data.cPage);
			var html="";
			for(index in data.list){
				var study = data.list[index];
				var upfile = study.UPFILE.split(",");
        	    html+="<li class='col-md-4'>";
        	    html+="<div class='pixel'>";
        	    html+="<a href='studyView.do?sno="+study.SNO+"'>";
        	    html+= "<div class='photoSection'>";
        	    html+= "<div style='background-image:url(${rootPath}/resources/upload/study/"+upfile[0]+")'></div>";
        	    html+= "</div>";
        	    html+= "<div class='inforSection'>";
        	    html+= "<h4>"+study.TITLE.substring(0, 18)+"</h4>";
        	   /*  html+= "<h4>"+study.TITLE+"</h4>"; */
        	    html += "<div class='profile'><img src='${rootPath}/resources/upload/member/"+study.MPROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
        	    html += 	"<div class='profileName'>"+study.MID+"</div>";
        	    html += 	"<div class='profileInfors'>";
        	    html += 	"<div class='nPoint'>N :"+study.NPOINT+"</div>";
        	    html += 	"<div class='point'>P : "+study.POINT+"</div>";
        	    html += 	"<div class='exp'>E : "+study.EXP+"</div>";
        	    html += 	"</div>";
        	    html += "</div>";
        	    html += "<div class='metaSection'>";
        	    html += 	"<p>"+study.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
        	    html += "</div>";
        	    html += "<div class='localSection'>";
        	    html += 	"<div class='study'>"+study.SUBNAME+"</div>";
        	    html += 	"<div class='local'>"+study.LNAME+"|"+study.TNAME+"</div>";
        	    html += 	"<div class='level'>"+study.DNAME+"</div>";
        	    if(study.STATUS =='스터디 종료'){
        	    	html +=    "<div class='time' style='background:#000; color:#fff;'>"+study.STATUS+"</div>";
        	    }else if(study.STATUS=='마감 임박'){
        	    	html +=    "<div class='time' style='background:red; color:#fff;'>"+study.STATUS+"</div>";
        	    }else{
        	    	html +=    "<div class='time'>"+study.STATUS+"</div>";
        	    	
        	    }
        	    html += "</div>";
        	    html += "<div class='subMeta'>";
        	    html += "<div class='applycnt'>"+study.APPLYCNT+"</div>";
        	    html += "<div class='ldate'>"+study.LDATE+"</div>";
        	    html += "<div class='term'>"+study.SDATE+" ~ "+study.EDATE +"</div>";
        	    html += "</div>";
        	    html += "</a>";
		        html += "</div>";
		        html += "</li>";

        	}
			
			$("ul.list").html(html);
			$("input#cPageNo").val(data.cPage);
			$("span#totalcount").html(data.total);
        	
		},error:function(){
			
		}
	});
	/* 처음에 조건없이 리스트를 가져오는 ajax */
	
	
	//카테고리를 선택하면 그에 맞는 과목들을 가져온다.
	$("select#kind").on("change",function(){
		
		var kno= $("option:selected", this).val();
		
		if(kno == "0"){
			$("#subject").hide();
			return;
		}
		$("#subject").show();
		
		
		var html="";
			$.ajax({
				url:"selectSubject.do",
				data:{kno:$(this).val()},
				dataType:"json",
				success:function(data){
					for(var index in data){
						html +="<option value='"+data[index].SUBNO+"'>"+data[index].SUBJECTNAME+"</option><br/>";
					}
					$("select#subject").html(html);
				}
			});
		
	});
	
	//지역을 선택하면 그에 맞는 도시들을 가져온다.
	$("select#local").on("change",function(){
		
		var lno=$("select#local option:selected").val();
		if(lno == "0"){
			$("#town").hide();
			return;
		}
		$("#town").show();
		
		var html="";
			$.ajax({
				url:"selectTown.do",
				data:{lno:$(this).val()},
				dataType:"json",
				success:function(data){
					for(var index in data){
						html +="<option value='"+data[index].TNO+"'>"+data[index].TOWNNAME+"</option><br/>";
					}
					$("select#town").html(html);
				}
			});
	});
	

	//필터 조건 정하고 검색 버튼을 누른 이벤트
	$("input#filterSearch").on("click",function(){
		
		if($("input[name=case]").val()=='none'){
			console.log("caser값은요"+$("input[name=case]").val());
		    $("input[name=case]").val('search');
		}
		console.log("caser값은요"+$("input[name=case]").val());
		var filter={lno:$("select#local option:selected").val(),tno:$("select#town option:selected").val(),
				subno:$("select#subject option:selected").val(),kno:$("select#kind option:selected").val(),
				dno:$("select#diff option:selected").val(),leadername:$("input#leadername").val(),
				searchCase:$("input[name=case]").val(),	status:$("select#status").val()};

		$.ajax({
			url:"searchStudy.do",
			data:filter,
			dataType:"json",
			success:function(data){
				console.log(data);
				var html="";
			 	if(data.list.length>0){
			 		
		        	for(index in data.list){
		        		var study = data.list[index];
						var upfile = study.UPFILE.split(",");
		        	    html+="<li class='col-md-4'>";
		        	    html+="<div class='pixel'>";
		        	    html+="<a href='studyView.do?sno="+study.SNO+"'>";
		        	    html+= "<div class='photoSection'>";
		        	    html+= "<div style='background-image:url(${rootPath}/resources/upload/study/"+upfile[0]+")'></div>";
		        	    html+= "</div>";
		        	    html+= "<div class='inforSection'>";
		        	    html+= "<h4>"+study.TITLE.substring(0, 18)+"</h4>";
		        	   /*  html+= "<h4>"+study.TITLE+"</h4>"; */
		        	    html += "<div class='profile'><img src='${rootPath}/resources/upload/member/"+study.MPROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
		        	    html += 	"<div class='profileName'>"+study.MID+"</div>";
		        	    html += 	"<div class='profileInfors'>";
		        	    html += 	"<div class='nPoint'>N :"+study.NPOINT+"</div>";
		        	    html += 	"<div class='point'>P : "+study.POINT+"</div>";
		        	    html += 	"<div class='exp'>E : "+study.EXP+"</div>";
		        	    html += 	"</div>";
		        	    html += "</div>";
		        	    html += "<div class='metaSection'>";
		        	    html += 	"<p>"+study.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
		        	    html += "</div>";
		        	    html += "<div class='localSection'>";
		        	    html += 	"<div class='study'>"+study.SUBNAME+"</div>";
		        	    html += 	"<div class='local'>"+study.LNAME+"|"+study.TNAME+"</div>";
		        	    html += 	"<div class='level'>"+study.DNAME+"</div>";
		        	    if(study.STATUS =='스터디 종료'){
		        	    	html +=    "<div class='time' style='background:#000; color:#fff;'>"+study.STATUS+"</div>";
		        	    }else if(study.STATUS=='마감 임박'){
		        	    	html +=    "<div class='time' style='background:red; color:#fff;'>"+study.STATUS+"</div>";
		        	    }else{
		        	    	html +=    "<div class='time'>"+study.STATUS+"</div>";
		        	    	
		        	    }
		        	    html += "</div>";
		        	    html += "<div class='subMeta'>";
		        	    html += "<div class='applycnt'>"+study.APPLYCNT+"</div>";
		        	    html += "<div class='ldate'>"+study.LDATE+"</div>";
		        	    html += "<div class='term'>"+study.SDATE+" ~ "+study.EDATE +"</div>";
		        	    html += "</div>";
		        	    html += "</a>";
				        html += "</div>";
				        html += "</li>";
		        	} 
		        	
			 	}else{
			 		html+="<span>해당 스터디가 없습니다.<span>";
			 	}
				
	        	$("ul.list").html(html); 
	        	
	        	//새로 cPage 1로 설정
	        	$("input#cPageNo").val(data.cPage);
	        	$("input#total").val(data.total);
			}
		});
	});
	
	$("button#sort-deadline").click(function(){
		if($("button#sort-pop").hasClass("clicked")) {
			$("button#sort-pop").removeClass("clicked");
			console.log("pop눌러잇엄");
		}
		if($("input[name=case]").val()=="deadline"){
			$("input[name=case]").val("none");
			$(this).removeClass("clicked");
		}else{
			$("input[name=case]").val("deadline");
			$(this).addClass("clicked");
		}
		
		
	});
	
	
	//인기순 정렬(신청자순)
	$("button#sort-pop").click(function(){
		if($("button#sort-deadline").hasClass("clicked")) $("button#sort-deadline").removeClass("clicked");
		
		if($("input[name=case]").val()=="pop"){
			$("input[name=case]").val("none");
			$(this).removeClass("clicked");
		}else{
			$("input[name=case]").val("pop");
			$(this).addClass("clicked");
		}
		
	});
	
	
	
	
	//무한 스크롤.
	//내려갈 때 계속 해당하는 스터디 리스트가 나옴
	var scrollTime=500;
	var timer = null;
	
	$(window).on('scroll',function(){
		var maxHeight = $(document).height();
	    var currentScroll = $(window).scrollTop() + $(window).height();
		if(maxHeight <= currentScroll+100){
			clearTimeout(timer);
			timer = setTimeout(listAddbyPaging,scrollTime);
		}
		
	});
	
	function listAddbyPaging(){
		
	    var urlPath="";
		var cPage=Number($("input#cPageNo").val());
		var total =Number($("input#total").val());
		var numPerPage= Number($("input#numPerPage").val());
		var listCase=$("input[name=case]").val();
		var dataForList={cPage:cPage};//페이징 처리에 보낼 data 값.
		
		
		//아무 조건없이 페이징 하느냐, 있이 하느냐, 마감임박순으로 하느냐, 인기스터디 순으로 하느냐에 따라 url분기. 보낼 data값 설정.
	    if(listCase=="none"){
	    	urlPath="studyListAdd.do";
	    	
	    }else{
	    	urlPath="searchStudyAdd.do";
	    	dataForList={lno:$("select#local option:selected").val(),tno:$("select#town option:selected").val(),
					subno:$("select#subject option:selected").val(),kno:$("select#kind option:selected").val(),
					dno:$("select#diff option:selected").val(),leadername:$("input#leadername").val(),cPage:cPage,
					searchCase:$("input[name=case]").val(),	status:$("select#status").val()};
						
			console.log(dataForList);			
	    }
		
		console.log("cPage="+cPage);
		var isPage=Math.floor(total/numPerPage)+1;
		console.log("isPage="+isPage);
		
		 //최대 가져올 수 있는 cPage 검사. 
		 if (cPage<=isPage) {
		      $.ajax({
		        url:urlPath,
		        dataType:"json",
		        data:dataForList,
		        success:function(data){
		        	console.log(data);
		        	var html="";
		        	for(index in data.list){
		        		var study = data.list[index];
						var upfile = study.UPFILE.split(",");
		        	    html+="<li class='col-md-4'>";
		        	    html+="<div class='pixel'>";
		        	    html+="<a href='study/study/studyView.do?sno="+study.SNO+"'>";
		        	    html+= "<div class='photoSection'>";
		        	    html+= "<div style='background-image:url(${rootPath}/resources/upload/study/"+upfile[0]+")'></div>";
		        	    html+= "</div>";
		        	    html+= "<div class='inforSection'>";
		        	    html+= "<h4>"+study.TITLE.substring(0, 18)+"</h4>";
		        	   /*  html+= "<h4>"+study.TITLE+"</h4>"; */
		        	    html += "<div class='profile'><img src='${rootPath}/resources/upload/member/"+study.MPROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
		        	    html += 	"<div class='profileName'>"+study.MID+"</div>";
		        	    html += 	"<div class='profileInfors'>";
		        	    html += 	"<div class='nPoint'>N :"+study.NPOINT+"</div>";
		        	    html += 	"<div class='point'>P : "+study.POINT+"</div>";
		        	    html += 	"<div class='exp'>E : "+study.EXP+"</div>";
		        	    html += 	"</div>";
		        	    html += "</div>";
		        	    html += "<div class='metaSection'>";
		        	    html += 	"<p>"+study.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
		        	    html += "</div>";
		        	    html += "<div class='localSection'>";
		        	    html += 	"<div class='study'>"+study.SUBNAME+"</div>";
		        	    html += 	"<div class='local'>"+study.LNAME+"</div>";
		        	    html += 	"<div class='level'>"+study.DNAME+"</div>";
		        	    if(study.STATUS =='스터디 종료'){
		        	    	html +=    "<div class='time' style='background:#000; color:#fff;'>"+study.STATUS+"</div>";
		        	    }else{
		        	    	html +=    "<div class='time'>"+study.STATUS+"</div>";
		        	    }
		        	    html += "</div>";
		        	    html += "<div class='subMeta'>";
		        	    html += "<div class='applycnt'>"+study.APPLYCNT+"</div>";
		        	    html += "<div class='ldate'>"+study.LDATE+"</div>";
		        	    html += "<div class='term'>"+study.SDATE+" ~ "+study.EDATE +"</div>";
		        	    html += "</div>";
		        	    html += "</a>";
				        html += "</div>";
				        html += "</li>";

		        	}
		        	$("input#cPageNo").val(data.cPage);
		        	$("ul.list").append(html);
		        },error:function(){
		        	
		        }
		      });//ajax 끝
		  }else{
			  if(!$("p#noMore").prop("noMore")){
				  $("p#noMore").addClass("noMore");  
			  }
			  
		  }//if문 끝
		
	}
	//검색 필터 조건 초기화 하기
	$("a#reFilter").click(function(){
		$("#town").hide();
		$("#subject").hide();
		$("button.sortBy").removeClass("clicked");
		
		
		$("#local option:eq(0)").prop("selected", true);
		$("#kind option:eq(0)").prop("selected", true);
		$("#diff option:eq(0)").prop("selected", true);
		
		$('#leadername').val("");
		
		$("input[name=case]").val("none");
		
		console.log("검색 조건 초기화");
		
		
		
	});
});


</script>
<style>
select#local, select#kind, select#subject, select#town, select#diff{
	width:100px;
}
input#leadername{
	width:200px;
	display:inline-block;
	padding:0.4rem 0.75rem;
}
button.sortBy{
	background:white;
	border:1px solid lightgray;
}
button.sortBy:hover{
	background:black;
	color:white;
}
div#studylist-container button#enroll{
	position:relative;
	left:90%;
	top:0px;
}
button.clicked{
	background:black;
	color:white;
}
input#filterSearch{
	
}
div#study-search{
	
}
div.wrap{
	display:inline-block;
}
table{
	margin:0 auto;
	
}
table th{
	text-align:center;
}
a#reFilter{
	color:black;
	text-shadow: 5px 5px 5px white;
}
</style>
<style>
p.noMore{
	display:none;
}

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
span#totalcount{
	font-family: 'Song Myung', serif;
}
h3#totalcountt{
	font-family: 'Song Myung', serif;
}
</style>

<div id="studylist-container" class="section-content container rm_study_list">
		<div class="btn-container">
			<button id="enroll" onclick="location.href='${pageContext.request.contextPath}/study/studyForm.do'" class="btn btn-primary">스터디 작성</button>
		</div>
		
		<div id="study-search">
			<table>
				<tr>
					<th>지역</th>
					<th>과목</th>
					<th>난이도</th>
					<th>팀장명</th>
					<th>정렬</th>
					<th>검색<th>
				</tr>
				<tr>
					<td>
						<select name="lno" id="local" class="custom-select">
							<option value="0">전체</option>
							<c:forEach var="local" items="${localList }">
								<option value="${local.LNO }">${local.LOCAL }</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<select name="kno" id="kind" class="custom-select">
							<option value="0">전체</option>
							<c:forEach var="k" items="${kindList }">
								<option value="${k.KNO }">${k.KINDNAME }</option>
							</c:forEach>
						</select>
					
					</td>
					<td>
						<select name="dno" id="diff" class="custom-select">
							<option value="0">전체</option>
							<c:forEach var="diff" items="${diffList }">
								<option value="${diff.DNO }">${diff.DIFFICULTNAME }</option>
							</c:forEach>
						</select>
					</td>
					<td>
					    <input type="text" name="leadername" id="leadername" placeholder="팀장명을 적어주세요" maxlength="10" class="form-control" />
					</td>	
					<td>
						<button type="button" id="sort-deadline" class="btn sortBy">마감임박순</button>
						<button type="button" id="sort-pop" class="btn sortBy">인기스터디순</button>
					</td>	
					<td>
						<input type="button" id="filterSearch" value="필터 검색" class="btn btn-dark"/>
					</td>		
				</tr>
				<tr>
					<td>
						<select name="tno" id="town" class="custom-select">
							<option value="0">전체</option>
						</select>
					</td>
					<td>
						<select name="subno" id="subject" class="custom-select">
							<option value="0">전체</option>
						</select>
					</td>
					<td>
					<br /><br />                   
					</td>
					<td>
					<br /><br />          
					</td>
					<td>
						<br />
					</td>
					<td>
						<a href="#" id="reFilter">검색 조건 초기화</a>
					</td>
					
				
				</tr>
			</table>
			
		</div>
		<hr />
		 <h3 id="totalcountt"><span id="totalcount"></span>개의 스터디</h3>
		
		<div id="study-list" class="content">
			<ul class="list">
			
			</ul>
		</div>
		
		<p id="noMore">더이상 스터디가 존재하지 않습니다.</p>
		
		<input type="hidden" id="cPageNo" value="1" />
		<input type="hidden" id="total" value="0" />
		<input type="hidden" id="numPerPage" />
		<input type="hidden" name="case" value="none" /> <!-- 조건없이 리스트를 가져오나, 조건있이 리스트를 가져오나 여부.-->
	
	
	

</div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
