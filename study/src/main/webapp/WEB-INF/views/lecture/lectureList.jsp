<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link href="https://fonts.googleapis.com/css?family=Gaegu|Song+Myung" rel="stylesheet">
<style>
p.noMore{
	display:none;
}
span#totalcount{
	font-family: 'Song Myung', serif;
}
h3#totalcountt{
	font-family: 'Song Myung', serif;
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
button.sortBy{
	background:white;
	border:1px solid lightgray;
}
button.sortBy:hover{
	background:black;
	color:white;
}
button.clicked{
	background:black;
	color:white;
}
input#leadername{
	width:200px;
	display:inline-block;
	padding:0.4rem 0.75rem;
}
select#local, select#kind, select#sub, select#town, select#diff{
	width:100px;
}
div#enroll button#insertLectureBtn{
	position:relative;
	left:90%;
	top:0px;
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
</style>
<script>
   $(document).ready(function(){
	   $("#insertLectureBtn").click(function(){
			var mno = ${memberLoggedIn != null ? memberLoggedIn.getMno():"0"};
			
			location.href = "${pageContext.request.contextPath}/lecture/insertLecture.do?mno=" + mno;
		});
	   
       $("#town").hide(); 
       $("#sub").hide(); 
       
       $("p#noMore").addClass("noMore");
      
       //강의 클릭시 강의 상세보기 이동 이벤트
       $("div#lecture-container").on("click","div.lectureOne",function(){
	       var sno = $(this).children("input").val();
	       var mno=${memberLoggedIn != null ? memberLoggedIn.getMno():"0"};
	       
	       location.href="${pageContext.request.contextPath}/lecture/lectureView.do?sno=" + sno +"&mno=" + mno;
	    });       
       
      // TOWN선택
      $("#local").on("change", function(){
         var localNo = $("option:selected", this).val();
         
          if(localNo == "0"){
            $("#town").hide();
            return;
         } 
         
         $("#town").show();
         
         $.ajax({
            url: "selectTown.do",
            data: {localNo : localNo},
            dataType: "json",
            success : function(data){
               var html="";
               
               html += "<option value='0'>전체</option>";
               
               for(var index in data){
                  html += "<option value='"+data[index].TNO +"'>" + data[index].TOWNNAME + "</option></br>";
               }            
               $("#town").html(html);
            }         
         });
      });
      
      // 세부 과목 선택
      $("#kind").on("change", function(){
         var kindNo = $("option:selected", this).val();
         
          if(kindNo == "0"){
            $("#sub").hide();
            return;
         } 
         
         $("#sub").show();
         
         $.ajax({
            url: "selectSubject.do",
            data: {kindNo : kindNo},
            dataType: "json",
            success : function(data){
               var html="";
               html += "<option value='0'>전체</option>";
               
               for(var index in data){
                  html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option></br>";
               }
               
               $("#sub").html(html);
            }         
         });
      });
      
      /* 처음에 조건없이 리스트를 가져오는 ajax */
		$.ajax({
			url:"selectLectureList.do",
			dataType:"json",
			success:function(data){
				$("input#total").val(data.total);
				$("input#numPerPage").val(data.numPerPage);
				$("input#cPageNo").val(data.cPage);
				
				
				var html="";
				for(index in data.list){
					var lecture = data.list[index];
					var upfile = lecture.UPFILE.split(",");
	        	    html+="<li class='col-md-4'>";
	        	    html+="<div class='pixel'>";
	        	    html+="<a href='lectureView.do?sno="+lecture.SNO+"'>";
	        	    html+= "<div class='photoSection'>";
	        	    html+= "<div style='background-image:url(${rootPath}/resources/upload/lecture/"+upfile[0]+")'></div>";
	        	    html+= "</div>";
	        	    html+= "<div class='inforSection'>";
	        	    html+= "<h4>"+lecture.TITLE.substring(0, 18)+"</h4>";
	        	   /*  html+= "<h4>"+lecture.TITLE+"</h4>"; */
	        	    html += "<div class='profile'><img src='${rootPath}/resources/upload/member/"+lecture.PROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
	        	    html += 	"<div class='profileName'>"+lecture.MID+"</div>";
	        	    html += 	"<div class='profileInfors'>";
	        	    html += 	"<div class='nPoint'>N :"+lecture.NPOINT+"</div>";
	        	    html += 	"<div class='point'>P : "+lecture.POINT+"</div>";
	        	    html += 	"<div class='exp'>E : "+lecture.EXP+"</div>";
	        	    html += 	"</div>";
	        	    html += "</div>";
	        	    html += "<div class='metaSection'>";
	        	    html += 	"<p>"+lecture.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
	        	    html += "</div>";
	        	    html += "<div class='localSection'>";
	        	    html += 	"<div class='study'>"+lecture.SUBNAME+"</div>";
	        	    html += 	"<div class='local'>"+lecture.LOCAL+"|"+lecture.TNAME+"</div>";
	        	    html += 	"<div class='level'>"+lecture.DNAME+"</div>";
	        	    if(lecture.STATUS =='강의 종료'){
	        	    	html +=    "<div class='time' style='background:#000; color:#fff;'>"+lecture.STATUS+"</div>";
	        	    }else if(lecture.STATUS=='마감 임박'){
	        	    	html +=    "<div class='time' style='background:red; color:#fff;'>"+lecture.STATUS+"</div>";
	        	    }else{
	        	    	html +=    "<div class='time'>"+lecture.STATUS+"</div>";
	        	    	
	        	    }
	        	    html += "</div>";
	        	    html += "<div class='subMeta'>";
	        	    html += "<div class='applycnt'>"+lecture.CNT+"</div>";
	        	    html += "<div class='ldate'>"+lecture.LDATE+"</div>";
	        	    html += "<div class='term'>"+lecture.SDATE+" ~ "+lecture.EDATE +"</div>";
	        	    html += "</div>";
	        	    html += "</a>";
			        html += "</div>";
			        html += "</li>";

	        	}
				
				$("ul.list").html(html);
				$("input#cPageNo").val(data.cPage);
				$("span#totalcount").html(data.total);
				
				
				
				/* 
				
				
				
				var html="";
	        	for(index in data.list){
	        	    html+="<div class='lectureOne'>";
	        		html+="<span class='studyinfo'>신청기간 : ~"+data.list[index].LDATE+"</span><br/>";
	        		html+="<span class='studyinfo'>"+data.list[index].LOCAL+"-"+data.list[index].TNAME+data.list[index].DNAME+"</span><br/>";
	        		html+="<span class='studyinfo'>"+data.list[index].KNAME+ data.list[index].SUBNAME+"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].TITLE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].SDATE+"~"+data.list[index].EDATE+"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].PROFILE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].UPFILE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].STATUS +"</span><br/><hr>";
	        		html+="<input type='hidden' value='"+data.list[index].SNO+"'/>";
	        		html+="</div>";
	        	}
				$("div#lecture-container").html(html); 
				$("input#cPageNo").val(data.cPage); */
			},error:function(){
				
			}
		});
		/* 처음에 조건없이 리스트를 가져오는 ajax */				
		
		// 검색
		$("#searchLectureBtn").click(function(){
			
			if($("input[name=case]").val()=='none'){
				console.log("caser값은요"+$("input[name=case]").val());
			    $("input[name=case]").val('search');
			}
			
			var filter={
						lno:$("#local").val(),
						tno:$("#town").val(),
						subno:$("#sub").val(),
						kno:$("#kind").val(),
						dno:$("#diff").val(),
						leadername:$("input#leadername").val(),
						searchCase:$("input[name=case]").val()
			};			
			
			$.ajax({
				url: "searchLecture.do",
				data: filter,
				dataType: "json",
				success: function( data ){
					var html="";
					if(data.list.length>0){
						for(index in data.list){
							var lecture = data.list[index];
							var upfile = lecture.UPFILE.split(",");
			        	    html+="<li class='col-md-4'>";
			        	    html+="<div class='pixel'>";
			        	    html+="<a href='lectureView.do?sno="+lecture.SNO+"'>";
			        	    html+= "<div class='photoSection'>";
			        	    html+= "<div style='background-image:url(${rootPath}/resources/upload/lecture/"+upfile[0]+")'></div>";
			        	    html+= "</div>";
			        	    html+= "<div class='inforSection'>";
			        	    html+= "<h4>"+lecture.TITLE.substring(0, 18)+"</h4>";
			        	   /*  html+= "<h4>"+lecture.TITLE+"</h4>"; */
			        	    html += "<div class='profile'><img src='${rootPath}/resources/upload/member/"+lecture.PROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
			        	    html += 	"<div class='profileName'>"+lecture.MID+"</div>";
			        	    html += 	"<div class='profileInfors'>";
			        	    html += 	"<div class='nPoint'>N :"+lecture.NPOINT+"</div>";
			        	    html += 	"<div class='point'>P : "+lecture.POINT+"</div>";
			        	    html += 	"<div class='exp'>E : "+lecture.EXP+"</div>";
			        	    html += 	"</div>";
			        	    html += "</div>";
			        	    html += "<div class='metaSection'>";
			        	    html += 	"<p>"+lecture.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
			        	    html += "</div>";
			        	    html += "<div class='localSection'>";
			        	    html += 	"<div class='study'>"+lecture.SUBNAME+"</div>";
			        	    html += 	"<div class='local'>"+lecture.LOCAL+"|"+lecture.TNAME+"</div>";
			        	    html += 	"<div class='level'>"+lecture.DNAME+"</div>";
			        	    if(lecture.STATUS =='강의 종료'){
			        	    	html +=    "<div class='time' style='background:#000; color:#fff;'>"+lecture.STATUS+"</div>";
			        	    }else if(lecture.STATUS=='마감 임박'){
			        	    	html +=    "<div class='time' style='background:red; color:#fff;'>"+lecture.STATUS+"</div>";
			        	    }else{
			        	    	html +=    "<div class='time'>"+lecture.STATUS+"</div>";
			        	    	
			        	    }
			        	    html += "</div>";
			        	    html += "<div class='subMeta'>";
			        	    html += "<div class='applycnt'>"+lecture.CNT+"</div>";
			        	    html += "<div class='ldate'>"+lecture.LDATE+"</div>";
			        	    html += "<div class='term'>"+lecture.SDATE+" ~ "+lecture.EDATE +"</div>";
			        	    html += "</div>";
			        	    html += "</a>";
					        html += "</div>";
					        html += "</li>";
			        	}
					}else{
						html+="<span>해당 강의가 없습니다.<span>";
					}
					$("ul.list").html(html); 
					$("input#total").val(data.total);
					$("input#cPageNo").val(data.cPage);
					$("span#totalcount").html(data.total);
			 }
			});
		});
		
		//마감임박순 버튼 클릭 이벤트 첫 페이징 가져옴.
		$("button#sortDeadlineBtn").click(function(){
			if($("button#sortPopularBtn").hasClass("clicked")) {
				$("button#sortPopularBtn").removeClass("clicked");
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
		
		////인기(신청자)순 버튼 클릭 이벤트 첫 페이징 가져옴.
		$("button#sortPopularBtn").click(function(){
			if($("button#sortDeadlineBtn").hasClass("clicked")) $("button#sortDeadlineBtn").removeClass("clicked");
			
			if($("input[name=case]").val()=="pop"){
				$("input[name=case]").val("none");
				$(this).removeClass("clicked");
			}else{
				$("input[name=case]").val("pop");
				$(this).addClass("clicked");
			}
			
			
		});		
		
		//무한 스크롤.
		//내려갈 때 계속 해당하는 강의 리스트가 나옴
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
			
			//아무 조건없이 페이징 하느냐, 있이 하느냐, 마감임박순으로 하느냐, 인기강의 순으로 하느냐에 따라 url분기. 보낼 data값 설정.
		    if(listCase=="none"){
		    	urlPath="lectureListAdd.do";		    	
		    } else {
		    	urlPath="lectureSearchAdd.do";
		    	dataForList={
		    				lno:$("#local").val(),
		    				tno:$("#town").val(),
		    				subno:$("#sub").val(),
		    				kno:$("#kind").val(),
		    				dno:$("#diff").val(),
		    				leadername:$("input#leadername").val(),
		    				searchCase:$("input[name=case]").val(),
		    				cPage:cPage
		    	}
		    }
		  
			var isPage=Math.floor(total/numPerPage)+1;
			
			 //최대 가져올 수 있는 cPage 검사. 
			 if (cPage<=isPage) {
			      $.ajax({
			        url:urlPath,
			        dataType:"json",
			        data:dataForList,
			        success:function(data){
			        	var html="";
			        	
			        	for(index in data.list){
			        		var lecture = data.list[index];
							var upfile = lecture.UPFILE.split(",");
			        	    html+="<li class='col-md-4'>";
			        	    html+="<div class='pixel'>";
			        	    html+="<a href='lectureView.do?sno="+lecture.SNO+"'>";
			        	    html+= "<div class='photoSection'>";
			        	    html+= "<div style='background-image:url(${rootPath}/resources/upload/lecture/"+upfile[0]+")'></div>";
			        	    html+= "</div>";
			        	    html+= "<div class='inforSection'>";
			        	    html+= "<h4>"+lecture.TITLE.substring(0, 18)+"</h4>";
			        	   /*  html+= "<h4>"+lecture.TITLE+"</h4>"; */
			        	    html += "<div class='profile'><img src='${rootPath}/resources/upload/member/"+lecture.PROFILE+"' onerror='this.src=\"${rootPath}/resources/images/noprofile.jpg\"' /></div>";
			        	    html += 	"<div class='profileName'>"+lecture.MID+"</div>";
			        	    html += 	"<div class='profileInfors'>";
			        	    html += 	"<div class='nPoint'>N :"+lecture.NPOINT+"</div>";
			        	    html += 	"<div class='point'>P : "+lecture.POINT+"</div>";
			        	    html += 	"<div class='exp'>E : "+lecture.EXP+"</div>";
			        	    html += 	"</div>";
			        	    html += "</div>";
			        	    html += "<div class='metaSection'>";
			        	    html += 	"<p>"+lecture.CONTENT.replace(/(<([^>]+)>)/ig,"").replace("&nbsp;","").substring(0, 18)+"</p>";
			        	    html += "</div>";
			        	    html += "<div class='localSection'>";
			        	    html += 	"<div class='study'>"+lecture.SUBNAME+"</div>";
			        	    html += 	"<div class='local'>"+lecture.LOCAL+"|"+lecture.TNAME+"</div>";
			        	    html += 	"<div class='level'>"+lecture.DNAME+"</div>";
			        	    if(lecture.STATUS =='강의 종료'){
			        	    	html +=    "<div class='time' style='background:#000; color:#fff;'>"+lecture.STATUS+"</div>";
			        	    }else if(lecture.STATUS=='마감 임박'){
			        	    	html +=    "<div class='time' style='background:red; color:#fff;'>"+lecture.STATUS+"</div>";
			        	    }else{
			        	    	html +=    "<div class='time'>"+lecture.STATUS+"</div>";
			        	    	
			        	    }
			        	    html += "</div>";
			        	    html += "<div class='subMeta'>";
			        	    html += "<div class='applycnt'>"+lecture.CNT+"</div>";
			        	    html += "<div class='ldate'>"+lecture.LDATE+"</div>";
			        	    html += "<div class='term'>"+lecture.SDATE+" ~ "+lecture.EDATE +"</div>";
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
			$("#sub").hide();
			$("#town").html("<option value='0'></option>");
			$("#subject").html("<option value='0'></option>");
			$("button.sortBy").removeClass("clicked");
			
			
			$("#local option:eq(0)").prop("selected", true);
			$("#kind option:eq(0)").prop("selected", true);
			$("#diff option:eq(0)").prop("selected", true);
			
			$('#leadername').val("");
			
			$("input[name=case]").val("none");
			
			console.log("검색 조건 초기화");		
		});		
		

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
   });
</script>
<div class="container section-content container rm_study_list">
	<div class="btn-container" id="enroll">
   		<button type="button" id="insertLectureBtn" class="btn btn-primary">강의 작성</button>	
	</div>
   <div class="lecture-search">
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
						 <select name="local" id="local" class="custom-select">
					         <option value="0" selected>전체</option>
					         <c:if test="${!empty locList}">
					            <c:forEach var="loc" items="${locList }" varStatus="vs">
					               <option value="${loc.LNO }">${loc.LOCAL }</option>
					            </c:forEach>      
					         </c:if>
				      </select>
					</td>
					<td>
						<select name="kind" id="kind" class="custom-select"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
					         <option value="0">전체</option>
					         
					         <c:if test="${!empty kindList }">
					         <c:forEach var="kind" items="${kindList }" varStatus="vs">
					            <option value="${kind.KNO }">${kind.KINDNAME }</option>
					         </c:forEach>
					         </c:if>
				      </select>
					
					</td>
					<td>
						<select name="dno" id="diff" class="custom-select">
					         <option value="0">전체</option>
					         
					         <c:if test="${!empty diffList }">
					            <c:forEach var="diff" items="${diffList }" varStatus="vs">
					               <option value="${diff.DNO }">${diff.DIFFICULTNAME }</option>
					            </c:forEach>
					         </c:if>
					     </select>
					</td>
					<td>
					     <input type="text" name="leadername" id="leadername" placeholder="팀장명을 적어주세요" class="form-control"/> 
					</td>	
					<td>
						<button type="button" id="sortDeadlineBtn" class="btn sortBy">마감임박순</button>
      					<button type="button" id="sortPopularBtn"  class="btn sortBy">인기강사순</button>
					
					</td>	
					<td>
						 <button type="button" id="searchLectureBtn" class="btn btn-dark">필터 검색</button>
					</td>		
				</tr>
				<tr>
					<td>
						<select name="tno" id="town" class="custom-select">
							<option value='0'>전체</option>
				     	 </select> 
					</td>
					<td>
						<select name="subno" id="sub" class="custom-select"> 
				      		<option value='0'>전체</option>
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
   <h3 id="totalcountt"><span id="totalcount"></span>개의 강의</h3>    
      <div id="lecture-container" class="content">
         <ul class="list">
				
		 </ul>
      </div>
      
      <p id="noMore">더이상 강의가 존재하지 않습니다.</p>
      
       <!-- 페이징시 필요한 값 저장 -->	
	 <input type="hidden" id="cPageNo" value="1" />
	 <input type="hidden" id="total" value="0" />
	 <input type="hidden" id="numPerPage" />
	 <input type="hidden" name="case" value="none" /> <!-- 조건없이 리스트를 가져오나, 조건있이 리스트를 가져오나 여부.-->
   </div>

</section>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>