<%@page import="javax.print.attribute.standard.DateTimeAtCompleted"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
div.forCopy{
	display:none;
}
</style>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<script>
function validate(){
	// 유효성 검사 - 지역,도시
	var local = $("#local").val();
	var town = $("#town").val();
	
	if( local=="" || town=="세부 지역을 선택하세요"){
		alert("지역을 선택해주세요");
		return false;	
	}
	
	// 유효성 검사 - 카테고리, 세부종목
	var kind = $("#kind").val();
	var sub = $("#sub").val();
	
	if( kind=="" || sub=="세부 과목을 선택하세요"){
		alert("강의 과목을 선택해주세요");
		return false;
	}
	
	// 유효성 검사 - 난이도
	var diff = $("#diff").val();
	
	if(diff==""){
		alert("난이도를 선택해주세요");
		return false;
	}	
	
	// 유효성 검사 - 일정, 빈도
	if( $(".day:checked").length == 0 ){
		alert("요일을 선택하세요");
		return false;	
	}
	
	// time만들기.
	var startTime = $("#startTime option:checked").val();
	var endTime = $("#endTime option:checked").val();	
	
	$("#time").val(startTime + "~" + endTime);	
	
	return true;
}

$(document).ready(function(){
	$(".day").attr("disabled", true);
});

$(function(){	
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
				var html="<option>세부 지역을 선택하세요</option>";
				
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
				var html="<option>세부 과목을 선택하세요</option>";
				
				for(var index in data){
					html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option></br>";
				}
				
				$("#sub").html(html);
			}			
		});
	});
	
	//첨부파일 선택하면 파일 이름이 input창에 나타나게한다.
   //첨부파일이름 표시
   $("form[name=lectureFrm]").on("change","[name=upFile]",function(){
      var fileName= $(this).prop("files")[0].name;
      
      $(this).next(".custom-file-label").html(fileName);
   });
	
	//첨부파일 + 버튼 클릭시 첨부파일창이 밑에 더 생긴다.
	$("form[name=lectureFrm]").on("click","button.addFile",function(){
		console.log("adddd");
		if($("div.fileWrapper").length<10){
			$("div.fileWrapper:last").after($("div.forCopy").clone().removeClass("forCopy").addClass("fileWrapper"));
		}			
	});
	
	//첨부파일 - 버튼 클릭시  해당 첨부파일 영역이 사라진다.
	$("form[name=lectureFrm]").on("click","button.removeFile",function(){
		console.log($("div.fileWrapper:eq(0)"));
		if( $(this).parent("div.fileWrapper")[0]!==$("div.fileWrapper:eq(0)")[0]){ //맨첫번째 첨부파일은 삭제이벤트 발생안함.
			$(this).parent("div.fileWrapper").remove();
		}
	});	
	
	// 날짜를 조정해보자... 유효성 검사 포함.
	// 유효성 검사 - 마감일
	$("#ldate").on("change", function(){		
		var ldate = $(this);
		var ldateVal = ldate.val();
		var lArray = ldateVal.split("-");
		var deadline = new Date(lArray[0], lArray[1], lArray[2]).getTime();
		
		var date = new Date();
		var year = date.getFullYear();
		var month = new String(date.getMonth()+1);
		var day = new String(date.getDate());
		
		if(month.length == 1 )
			month = "0" + month;
		if( day.length == 1 )
			day = "0" + day;
		
		var today = new Date(year, month, day);
		
		if( (deadline-today.getTime()) < 0 ){
			alert("과거가 마감일이 될 수 없습니다.");
			ldate.val("");
		}
		
		var sdate = $("#sdate");		
		var edate = $("#edate");
		sdate.val("");
		edate.val("");
		
		$("input[class=day]").prop("checked", false);
		$("input[class=day]").attr("disabled", true);
		
		sdate.attr("min", $(this).val());
		edate.attr("min", $(this).val());		
	});
	
	// 유효성 검사 - 강의기간
	$("input[class=changeDate]").on("change", function(){
		$("input[class=day]").prop("checked", false);
		$("input[class=day]").attr("disabled", true);
		
		// 시작하는 날
		var sdate = $("#sdate");
		var sdateVal = sdate.val();
		var sday = new Date(sdateVal).getDay();
		var startArray = sdateVal.split("-");
		var start_date = new Date(startArray[0], startArray[1], startArray[2]).getTime();
		
		// 끝나는 날
		var edate = $("#edate");
		var edateVal = edate.val();
		var endArray = edateVal.split("-");
		var end_date = new Date(endArray[0], endArray[1], endArray[2]).getTime();	
		
		// 신청 마감일
		var ldateVal = $("#ldate").val();
		
		if( ldateVal == "" ){
			alert("마감일 먼저 설정해주세요.");
			sdate.val("");
			edate.val("");
		}			
		
		// 날짜 차이
		var difference = (end_date - start_date)/1000/24/60/60;			
		
		// 알고리즘
		if( sdateVal != "" && edateVal != "" ){
			if( difference >= 0 && difference < 7 ){			
				$("input[class=day]").attr("disabled", true);
			 	for( var i = 0; i < difference+1; i++ ){
			 		if( sday + i < 7)			
			 			$("input[class=day]").eq(sday+i).attr("disabled", false);		 		
			 		else
			 			$("input[class=day]").eq(sday+i-7).attr("disabled", false);	
			 	}
			}
			else if( difference > 7 )
				$(".day").attr("disabled", false);
			// 강의 끝나는 날이 시작하는 날보다 빠를 경우 초기화.
			else if( difference < 0 ){
				alert("강의가 끝나는 날이 시작하는 날보다 빠를 수 없습니다.");
				sdate.val("");
				edate.val("");
			}
			else
				$(".day").attr("disabled", false);	
		}
		else{
			$(".day").attr("disabled", true);	
		}		
	});
	
	// 유효성 검사 - 시간
	$(".time").on("change", function(){
		// 시작 시간
		var startTime = $("#startTime");
		var startTimeVal = startTime.val();
		var startTimeArray = startTimeVal.split(":");
		var start = Number(startTimeArray[0]);		
		
		// 마감 시간
		var endTime = $("#endTime");
		var endTimeVal = $("#endTime").val();
		var endTimeArray = endTimeVal.split(":");
		var end = Number(endTimeArray[0]);	
		
		// 시작시간이 마감시간보다 클 경우.
		if( start > end ){
			alert("시작하는 시간이 끝나는 시간보다 클 수 없습니다.");
			startTime.val("6:00");
			endTime.val("7:00");
		}
	});
});
</script>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div id="lecture-container">
	<form action="lectureFormEnd.do" id="lectureFrm" name="lectureFrm" method="post" enctype="multipart/form-data" onsubmit="return validate();">
	<input type="hidden" name="mno" value="${memberLoggedIn.getMno()}"/>
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
	
	<!-- 시,군,구 -->
	<select name="tno" id="town">
	
	</select>	
	<!-- 지역 end -->	
	
	<label for="title">스터디 제목 : </label><input type="text" name="title" id="title" placeholder="제목" class="form-control" required /><br />
	<label for="content">스터디 내용 : </label><textarea name="content" id="content" cols="30" rows="10" placeholder="내용을 입력해주세요" class="form-control" required></textarea><br />

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
	<select name="subno" id="sub"> <!-- ajax로 kind가져오기 -->
	
	</select>
	<!-- 카테고리 end -->
	&nbsp;&nbsp;&nbsp;
	
	<label for="diff">난이도 : </label>
	<select name="dno" id="diff">
		<option value="">난이도를 선택하세요</option>
		
		<c:if test="${!empty diffList }">
		<c:forEach var="diff" items="${diffList }" varStatus="vs">
			<option value="${diff.DNO }">${diff.DIFFICULTNAME }</option>
		</c:forEach>
		</c:if>
	</select>
	<br />
	
	<label for="ldate">신청마감 : </label><input type="date" name="ldate" id="ldate" />
	<label for="schedule">스터디 일정 : </label><input type="date" name="sdate" id="sdate" class="changeDate"/>~<input type="date" name="edate" id="edate" class="changeDate"/><br />

	<label for="freq">스터디빈도 : </label>
    <label>일 </label><input type="checkbox" class="day" name="freqs" value="일" /> 
    <label>월 </label><input type="checkbox" class="day" name="freqs" value="월" />
    <label>화 </label><input type="checkbox" class="day" name="freqs" value="화" />
    <label>수 </label><input type="checkbox" class="day" name="freqs" value="수" />
    <label>목 </label><input type="checkbox" class="day" name="freqs" value="목" />
    <label>금 </label><input type="checkbox" class="day" name="freqs" value="금" />
    <label>토 </label><input type="checkbox" class="day" name="freqs" value="토" />
	    
	<label for="starttime">스터디 시간</label>
	<select name="startTime" id="startTime" class="time">
		<c:forEach var="i" begin="6" end="23">
			<option value="${i }:00">${i }:00</option>		
		</c:forEach>
	</select>
	<select name="endTime" id="endTime" class="time">
		<c:forEach var="j" begin="7" end="24">
			<option value="${j }:00">${j }:00</option>		
		</c:forEach>
	</select>
	
	<input type="hidden" name="time" id="time" />
	<br />
	
	<label for="price">일회 사용회비 : </label><input type="text" name="price" id="price" class="form-control" min="0" step="1000" placeholder="협의 - 스터디 카페 대여비 - 6000원" />
	<br />
	
	<label for="recruit">모집 인원 : </label>
	<select name="recruit" id="recruit">
		<c:forEach var="i" begin="2" end="10">
			<option value="${i }">${i }명</option>
		</c:forEach>
	</select>
	<br /> 
	
	<label for="etc">기타 : </label>
	<textarea name="etc" id="etc" cols="30" rows="10" class="form-control"></textarea>
	<br /> 
	
	<div class="input-group mb-3 fileWrapper" style="padding:0px">
		  <div class="input-group-prepend" style="padding:0px">
		    <span class="input-group-text">첨부파일</span>
		  </div>
		  <div class="custom-file">
		    <input type="file" class="custom-file-input" name="upFile">
		    <label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
		  </div>
		  <button type="button" class="addFile">+</button>
		  <button type="button" class="removeFile">-</button>
	</div>
	
	<div class="input-group mb-3 forCopy" style="padding:0px">
		  <div class="input-group-prepend" style="padding:0px">
		    <span class="input-group-text">첨부파일</span>
		  </div>
		  <div class="custom-file">
		    <input type="file" class="custom-file-input" name="upFile">
		    <label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
		  </div>
		  <button type="button" class="addFile">+</button>
		  <button type="button" class="removeFile">-</button>
	</div>
	
	<input type="reset" value="취소하기" />
	<input type="submit" value="등록"/>
	</form>	
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>