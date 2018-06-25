<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
	$(document).ready(function(){
		$(".lectureDiv").click(function(){
			var sno = $(this).children("#sno").val();
			location.href="${pageContext.request.contextPath}/lecture/lectureView.do?sno=" + sno;
		});
	});	
	
	$(document).ready(function(){
		$("#town").hide();
		$("#sub").hide();
		
		// TOWN선택
		$("#local").on("change", function(){
			var localNo = $("option:selected", this).val();
			
			if(localNo == ""){
				$("#town").hide();
				return;
			}
			
			$("#town").show();
			
			$.ajax({
				url: "selectTown.do",
				data: {localNo : localNo},
				dataType: "json",
				success : function(data){
					var html="<option value=''>세부 지역을 선택하세요</option>";
					
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
			
			if(kindNo == ""){
				$("#sub").hide();
				return;
			}
			
			$("#sub").show();
			
			$.ajax({
				url: "selectSubject.do",
				data: {kindNo : kindNo},
				dataType: "json",
				success : function(data){
					var html="<option value=''>세부 과목을 선택하세요</option>";
					
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
				$("input#cPageNo").val(data.cPage);
			},error:function(){
				
			}
		});
		/* 처음에 조건없이 리스트를 가져오는 ajax */
				
		
		// 검색
		$("#searchLectureBtn").click(function(){
			
			$("input[name=case]").val("search"); //검색인 경우 case 설정
			
			var filter={lno:$("#local").val(),tno:$("#town").val(),
					subno:$("#sub").val(),kno:$("#kind").val(),
					dno:$("#diff").val(),leadername:$("input#leadername").val()};
			
			
			$.ajax({
				url: "searchLecture.do",
				data: filter,
				dataType: "json",
				success: function( data ){
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
					$("input#total").val(data.total);
					$("input#cPageNo").val(data.cPage);

				}
			});
		});
		
		//마감임박순 버튼 클릭 이벤트 첫 페이징 가져옴.
		$("button#sortDeadlineBtn").click(function(){
			$("input#case").val("deadline");
			
			$.ajax({
				url:"selectByDeadline.do",
				dataType:"json",
				success:function(data){
					
					var html="";
					for(var index in data.list){
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
					$("input#cPageNo").val(data.cPage);
					$("input#total").val(data.total);
				}
			});
		});
		
		
		////인기(신청자)순 버튼 클릭 이벤트 첫 페이징 가져옴.
		$("button#sortPopularBtn").click(function(){
			$("input#case").val("pop");
			
			$.ajax({
				url:"selectByApply.do",
				dataType:"json",
				success:function(data){
					
					var html="";
					for(var index in data.list){
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
					$("input#cPageNo").val(data.cPage);
					$("input#total").val(data.total);
				}
			});
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
		    	urlPath="lectureListAdd.do";
		    	
		    }else if(listCase=="search"){
		    	urlPath="lectureSearchAdd.do";
		    	dataForList={lno:$("#local").val(),tno:$("#town").val(),
						subno:$("#sub").val(),kno:$("#kind").val(),
						dno:$("#diff").val(),leadername:$("input#leadername").val(),cPage:cPage};
		    	
		    }else if(listCase=="deadline"){
				urlPath="lectureDeadlinAdd.do";	    	
		    }else{
		    	urlPath="lectureApplyAdd.do";
		    	
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
			        	$("input#cPageNo").val(data.cPage);
			        	$("div#lecture-container").append(html); 
			        },error:function(){
			        	
			        }
			      });//ajax 끝
			  }//if문 끝
			
		}
		
		
		
	});
</script>
<style>
	#lectureList-container{
		height: 1100px;
	}
	#beforeBtn{
		position: absolute;
		width: 80px;
		height: 80px;
		top: 735px;
		left: 427px;		
	}
	#afterBtn{
		position: absolute;
		width: 80px;
		height: 80px;
		top: 735px;
		right: 427px;
	}
	#beforeSearchBtn{
		position: absolute;
		width: 80px;
		height: 80px;
		top: 735px;
		left: 427px;		
	}
	#afterSearchBtn{
		position: absolute;
		width: 80px;
		height: 80px;
		top: 735px;
		right: 427px;
	}
</style>
	<button type="button" onclick="location.href='${pageContext.request.contextPath}/lecture/insertLecture.do'">강의	작성</button>
	<div id="lectureList-container">	
		<!-- 지역 -->
		<label for="local">지역 : </label>
		<select name="local" id="local">
			<option value="" selected>지역</option>
			<c:if test="${!empty locList}">
				<c:forEach var="loc" items="${locList }" varStatus="vs">
					<option value="${loc.LNO }">${loc.LOCAL }</option>
				</c:forEach>		
			</c:if>
		</select>
		&nbsp; 
		
		<select name="tno" id="town">
		
		</select> 
		
		<!-- 카테고리 -->
		<label for="kind">카테고리</label>
		<select name="kind" id="kind"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
			<option value="">과목을 선택하세요.</option>
			
			<c:if test="${!empty kindList }">
			<c:forEach var="kind" items="${kindList }" varStatus="vs">
				<option value="${kind.KNO }">${kind.KINDNAME }</option>
			</c:forEach>
			</c:if>
		</select>

		<!-- ajax로 subject가져오기 -->
		<select name="subno" id="sub"> 
		
		</select>
		<!-- 카테고리 end -->
		&nbsp; 		
		
		<label for="diff">난이도 : </label>
		<select name="dno" id="diff">
			<option value="">난이도를 선택하세요</option>
			
			<c:if test="${!empty diffList }">
				<c:forEach var="diff" items="${diffList }" varStatus="vs">
					<option value="${diff.DNO }">${diff.DIFFICULTNAME }</option>
				</c:forEach>
			</c:if>
		</select>
		
		<input type="text" name="leadername" id="leadername" placeholder="팀장명을 적어주세요" /> 
		<button type="button" id="searchLectureBtn">검색</button>
	
		<button type="button" id="sortDeadlineBtn">마감임박순</button>
		<button type="button" id="sortPopularBtn">인기스터디순</button>	
		
		<!-- 페이징시 필요한 값 저장 -->	
		<input type="hidden" id="cPageNo" value="1" />
		<input type="hidden" id="total" value="0" />
		<input type="hidden" id="numPerPage" />
		<input type="hidden" name="case" value="none" /> <!-- 조건없이 리스트를 가져오나, 조건있이 리스트를 가져오나 여부.-->
		<hr />
		
		<div id="lecture-container">
			
		</div>
	</div>
	</section>
	
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>