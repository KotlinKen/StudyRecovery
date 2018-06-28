<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 
<style>
p.noMore{
	display:none;
}

</style>
<script>
$(function(){
	$("p#noMore").addClass("noMore");
	
	$("#subject").hide();
	$("#town").hide();
	
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
        	    html+="<div class='studyone'>";
        		html+="<span class='studyinfo'>신청기간 : ~"+data.list[index].LDATE+"</span><br/>";
        		html+="<span class='studyinfo'>"+data.list[index].LNAME+"-"+data.list[index].TNAME+data.list[index].DNAME+"</span><br/>";
        		html+="<span class='studyinfo'>"+data.list[index].KNAME+ data.list[index].SUBNAME+"</span><br/>";
        		html+="<span class='studyinfo'>"+ data.list[index].TITLE +"</span><br/>";
        		html+="<span class='studyinfo'>"+ data.list[index].SDATE+"~"+data.list[index].EDATE+"</span><br/>";
        		html+="<span class='studyinfo'>"+ data.list[index].MPROFILE +"</span><br/>";
        		if(data.list[index].UPFILE==undefined) html+="<span class='studyinfo'>"+ "사진없음" +"</span><br/>";
        		else html+="<span class='studyinfo'>"+ data.list[index].UPFILE +"</span><br/>";
        		html+="<span class='studyinfo'>"+ data.list[index].STATUS +"</span><br/><hr>";
        		html+="<input type='hidden' value='"+data.list[index].SNO+"'/>";
        		html+="</div>";
        	}
			$("div#study-list").html(html); 
			$("input#cPageNo").val(data.cPage);
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
	
	
	//스터디 클릭시 스터디 상세보기 페이지로 이동하는 이벤트
	$("div#study-list").on("click","div.studyone",function(){
		location.href="${pageContext.request.contextPath}/study/studyView.do?sno="+$(this).children("input").val();
	});
	
	
	//필터 조건 정하고 검색 버튼을 누른 이벤트
	$("input#filterSearch").on("click",function(){
		var filter={lno:$("select#local option:selected").val(),tno:$("select#town option:selected").val(),
				subno:$("select#subject option:selected").val(),kno:$("select#kind option:selected").val(),
				dno:$("select#diff option:selected").val(),leadername:$("input#leadername").val()};
		
		$("input[name=case]").val("search"); //검색인 경우 case 설정
		
		$.ajax({
			url:"searchStudy.do",
			data:filter,
			dataType:"json",
			success:function(data){
				console.log(data);
				var html="";
			 	if(data.list.length>0){
			 		
		        	for(index in data.list){
		        		html+="<div class='studyone'>";
		        		html+="<span class='studyinfo'>신청기간 : ~"+data.list[index].LDATE+"</span><br/>";
		        		html+="<span class='studyinfo'>"+data.list[index].LNAME+"-"+data.list[index].TNAME+data.list[index].DNAME+"</span><br/>";
		        		html+="<span class='studyinfo'>"+data.list[index].SUBNAME+ data.list[index].KNAME+"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].TITLE +"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].SDATE+"~"+data.list[index].EDATE+"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].MPROFILE +"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].UPFILE +"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].STATUS +"</span><br/><hr>";
		        		html+="<input type='hidden' value='"+data.list[index].SNO+"'/>";
		        		html+="</div>"; 
		        	} 
			 	}else{
			 		html+="<span>해당 스터디가 없습니다.<span>";
			 	}
				
	        	$("div#study-list").html(html); 
	        	
	        	//새로 cPage 1로 설정
	        	$("input#cPageNo").val(data.cPage);
	        	$("input#total").val(data.total);
	        	
			}
		});
	});
	
	$("button#sort-deadline").click(function(){
		$("input#case").val("deadline");
		
		$.ajax({
			url:"selectByDeadline.do",
			dataType:"json",
			success:function(data){
				
				var html="";
				for(var index in data.list){
					var s = data.list[index];
					html+="<div class='studyone'>";
	        		html+="<span class='studyinfo'>신청기간 : ~"+data.list[index].LDATE+"</span><br/>";
	        		html+="<span class='studyinfo'>"+data.list[index].LNAME+"-"+data.list[index].TNAME+data.list[index].DNAME+"</span><br/>";
	        		html+="<span class='studyinfo'>"+data.list[index].SUBNAME+ data.list[index].KNAME+"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].TITLE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].SDATE+"~"+data.list[index].EDATE+"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].MPROFILE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].UPFILE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].STATUS +"</span><br/><hr>";
	        		html+="<input type='hidden' value='"+data.list[index].SNO+"'/>";
	        		html+="</div>"; 
					
				}
				$("div#study-list").html(html); 
				$("input#cPageNo").val(data.cPage);
				$("input#total").val(data.total);
			}
		});
	});
	
	
	//인기순 정렬(신청자순)
	$("button#sort-pop").click(function(){
		$("input#case").val("pop");
		
		$.ajax({
			url:"selectByApply.do",
			dataType:"json",
			success:function(data){
				
				var html="";
				for(var index in data.list){
					var s = data.list[index];
					html+="<div class='studyone'>";
	        		html+="<span class='studyinfo'>신청기간 : ~"+data.list[index].LDATE+"</span><br/>";
	        		html+="<span class='studyinfo'>"+data.list[index].LNAME+"-"+data.list[index].TNAME+data.list[index].DNAME+"</span><br/>";
	        		html+="<span class='studyinfo'>"+data.list[index].SUBNAME+ data.list[index].KNAME+"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].TITLE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].SDATE+"~"+data.list[index].EDATE+"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].MPROFILE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].UPFILE +"</span><br/>";
	        		html+="<span class='studyinfo'>"+ data.list[index].STATUS +"</span><br/><hr>";
	        		html+="<input type='hidden' value='"+data.list[index].SNO+"'/>";
	        		html+="</div>"; 
					
				}
				$("div#study-list").html(html); 
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
	    	urlPath="studyListAdd.do";
	    	
	    }else if(listCase=="search"){
	    	urlPath="searchStudyAdd.do";
	    	dataForList={lno:$("select#local option:selected").val(),tno:$("select#town option:selected").val(),
						subno:$("select#subject option:selected").val(),kno:$("select#kind option:selected").val(),
						dno:$("select#diff option:selected").val(),leadername:$("input#leadername").val(),cPage:cPage};
	    	
	    }else if(listCase=="deadline"){
			urlPath="studyDeadlinAdd.do";	    	
	    }else{
	    	urlPath="studyApplyAdd.do";
	    	
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
		        		html+="<div class='studyone'>";
		        		html+="<span class='studyinfo'>신청기간 : ~"+data.list[index].LDATE+"</span><br/>";
		        		html+="<span class='studyinfo'>"+data.list[index].LNAME+"-"+data.list[index].TNAME+data.list[index].DNAME+"</span><br/>";
		        		html+="<span class='studyinfo'>"+data.list[index].SUBNAME+ data.list[index].KNAME+"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].TITLE +"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].SDATE+"~"+data.list[index].EDATE+"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].PROFILE +"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].UPFILE +"</span><br/>";
		        		html+="<span class='studyinfo'>"+ data.list[index].STATUS +"</span><br/><hr>";
		        		html+="<input type='hidden' value='"+data.list[index].SNO+"'/>";
		        		html+="</div>";
		        	}
		        	$("input#cPageNo").val(data.cPage);
		        	$("div#study-list").append(html);
		        },error:function(){
		        	
		        }
		      });//ajax 끝
		  }else{
			  if(!$("p#noMore").prop("noMore")){
				  $("p#noMore").addClass("noMore");  
			  }
			  
		  }//if문 끝
		
	}
});


</script>
<div id="studylist-container">
		<button onclick="location.href='${pageContext.request.contextPath}/study/studyForm.do'">스터디 작성</button>
		<div id="study-search">
			<label for="local">지역:</label>
			<select name="lno" id="local">
			<option value="0">전체</option>
			<c:forEach var="local" items="${localList }">
				<option value="${local.LNO }">${local.LOCAL }</option>
			</c:forEach>
			</select>&nbsp;
			<select name="tno" id="town">
			</select>
			<label for="subject">카테고리 :</label>
			<select name="kno" id="kind">
			<option value="0">전체</option>
			<c:forEach var="k" items="${kindList }">
				<option value="${k.KNO }">${k.KINDNAME }</option>
			</c:forEach>
			</select>&nbsp;
			<select name="subno" id="subject">
			</select>
			
			<label for="diff">난이도 : </label>
			<select name="dno" id="diff">
			<option value="0">전체</option>
			<c:forEach var="diff" items="${diffList }">
				<option value="${diff.DNO }">${diff.DIFFICULTNAME }</option>
			</c:forEach>
			</select>
			<input type="text" name="leadername" id="leadername" placeholder="팀장명을 적어주세요" maxlength="50" />
			<input type="button" id="filterSearch" value="필터 검색" />
			
		</div>
			
	
		<button type="button" id="sort-deadline">마감임박순</button>
		<button type="button" id="sort-pop">인기스터디순</button>
		
		<hr />
		<div id="study-list">
		
		</div>
		
		<p id="noMore">더이상 스터디가 존재하지 않습니다.</p>
		
		<input type="hidden" id="cPageNo" value="1" />
		<input type="hidden" id="total" value="0" />
		<input type="hidden" id="numPerPage" />
		<input type="hidden" name="case" value="none" /> <!-- 조건없이 리스트를 가져오나, 조건있이 리스트를 가져오나 여부.-->
	
	
	

</div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
