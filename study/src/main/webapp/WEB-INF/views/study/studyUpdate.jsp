<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.Map" %>
 <jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 
<style>
div.forCopy{
	display:none;
}
div.btn-form{
	text-align:center;
}
div.btn-form input[type=submit]{
	background:#0056e9;
	color:white;
}
div.btn-form input[type=reset]{
	background:black;
	color:white;
	opacity: 0.6;
}
button.btn-upfile{
	background:black;
	color:white;
	opacity: 0.6;
}
select#local, select#kind, select#subject, select#town, select#diff, select#endtime, select#starttime, select#recruit{
	width:150px;
}
select#town, select#kind, select#diff{
	width:200px;
}
select#town{
	width:240px;
}

</style>
<script>
//에디터 속성값 주고 열기
$(document).ready(function() {
    $('#summernote').summernote({
      focus: true,
      height: 500, // 페이지가 열릴때 포커스를 지정함
      callbacks:{
    	  onImageUpload:function(files){
	   	  	  console.log("onImageUpload");
	   		  uploadImage(files[0],this);
      	}
      },
      lang:'ko-KR'
    });
    
 });
 
//사진 업로드 함수
function uploadImage(file,el){
    console.log("파일 업로드 함수 호출");
	  var data=new FormData();
	  data.append('file',file);
	  $.ajax({
		  data:data,
		  type:"POST",
		  processData:false,
		  contentType:false,
		  dataType:'json',
		  url:"uploadImage.do",
		  cache:false,
		  enctype:'multipart/form-data',
		  success:function(data){ 
			  
		  	  console.log("dddd : "+data.url);
		  	  var file=$("<img>").attr("src",
		  			  "${pageContext.request.contextPath }/resources/upload/study/"+data.url);
			  $(el).summernote('insertNode',file[0]);
		  },error:function(data){
			  console.log("error:"+data);
		  }
	 });
	  
  }
$(function(){
	//local 지역 리스트를 가져와 select 만듦. 
	 $.ajax({
		url:"selectLocal.do",
		dataType:"json",
		success:function(data){
			
			var html="<option>선택하세요</option>";
			for(var index in data){
				console.log(data[index]);
				html +="<option value='"+data[index].LNO+"'";
				if(${study.LNO}==data[index].LNO) html+="selected";
				html += ">"+data[index].LOCAL+"</option><br/>";
			}
			$("select#local").html(html);
			
			
		},error:function(){
			
		}
	}); 
	
	
	$.ajax({
		url:"selectTown.do",
		data:{lno:${study.LNO}},
		dataType:"json",
		success:function(data){
			
			var html="";
			for(var index in data){
				html +="<option value='"+data[index].TNO+"'";
				if(${study.TNO}==data[index].TNO) html+="selected";
				html += ">"+data[index].TOWNNAME+"</option><br/>";
			}
			$("select#town").html(html);
			
		},error:function(){
			
		}
	});
	
	 $("select#local").on("change",function(){
		 var lno=$("select#local option:selected").val();
		 console.log(lno);
		$.ajax({
			url:"selectTown.do",
			dataType:"json",
			data:{lno:lno},
			success:function(data){
				
				var html="";
				for(var index in data){
					html +="<option value='"+data[index].TNO+"'>"+data[index].TOWNNAME+"</option><br/>";
				}
				$("select#town").html(html);
				
			},error:function(){
				
			}
		});
	});
	 
	 
	 
	
	 
	//kind 리스트를 가져와 select 만듦. 프로그래밍, 회화, 운동 등등..
	 $.ajax({
		url:"selectKind.do",
		dataType:"json",
		success:function(data){
			var html="<option>선택하세요</option>";
			for(var index in data){
				html +="<option value='"+data[index].KNO+"'";
				if(${study.KNO}==data[index].KNO) html+="selected";
				html+=">"+data[index].KINDNAME+"</option><br/>";
			}
			$("select#kind").html(html);
			
		},error:function(){
			
		}
	}); 
	
	
	$.ajax({
			url:"selectSubject.do",
			data:{kno:${study.KNO}},
			dataType:"json",
			success:function(data){

				var html="";
				for(var index in data){
					html +="<option value='"+data[index].SUBNO+"'";
					if(${study.SUBNO}==data[index].SUBNO) html+="selected";
					html += ">"+data[index].SUBJECTNAME+"</option><br/>";
				}
				$("select#subject").html(html);
				
			},error:function(){
				
			}
		});
	

	
	//kind를 선택하면 해당하는 subject과목들을들을 가져와 리스트를 생성한다.
	 $("select#kind").on("change",function(){
		$.ajax({
			url:"selectSubject.do",
			dataType:"json",
			data:{kno:$("select#kind option:selected").val()},
			success:function(data){
				var html="";
				for(var index in data){
					html +="<option value='"+data[index].SUBNO+"'>"+data[index].SUBJECTNAME+"</option><br/>";
				}
				$("select#subject").html(html);
				
			},error:function(){
				
			}
		});
	});
	
	
	//diff(난이도) 리스트를 가져와 select 만듦.
	 $.ajax({
		url:"selectLv.do",
		dataType:"json",
		success:function(data){
			var html="";
			for(var index in data){
				html +="<option value='"+data[index].DNO+"'";
				if(${study.DNO}==data[index].DNO) html+="selected";
				html+=">"+data[index].DIFFICULTNAME+"</option><br/>";
			}
			$("select#dno").html(html);
			
		},error:function(){
			
		}
	}); 
	
	//첨부파일 + 버튼 클릭시 첨부파일창이 밑에 더 생긴다.
		$("form[name=studyFrm]").on("click","button.addFile",function(){
			
			if($("div.fileWrapper").length<10){
				$("div#upfile-container").append($("div.forCopy").clone().removeClass("forCopy").addClass("fileWrapper"));
			}
				
		});
		
		//첨부파일 - 버튼 클릭시  해당 첨부파일 영역이 사라진다.
		$("form[name=studyFrm]").on("click","button.removeFile",function(){
				$(this).parent("div.fileWrapper").remove();
		});
	 
		//첨부파일 선택하면 파일 이름이 input창에 나타나게한다.
		//첨부파일이름 표시
		$("form[name=studyFrm]").on("change","[name=upFile]",function(){
			
			var fileName= $(this).prop("files")[0].name;
			
			$(this).next(".custom-file-label").html(fileName);
			$(this).next("input[name=isNew]").val("true");
			
		});
		

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
			var difference = (end_date - start_date) /1000/24/60/60;			
			
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
		
		$(".time").on("change", function(){
			// 시작 시간
			var startTime = $("#starttime");
			var startTimeVal = startTime.val();
			var startTimeArray = startTimeVal.split(":");
			var start = Number(startTimeArray[0]);		
			
			// 마감 시간
			var endTime = $("#endtime");
			var endTimeVal = $("#endtime").val();
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

//유효성 검사
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
	var sub = $("#subject").val();
	
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
   var starttime = $("select#starttime option:checked").val();
   var endtime = $("select#endtime option:checked").val();   
   
   $("input#time").val(starttime + "~" + endtime);
	   
	   
	   //기존의 파일 이름 연결해서 보내기 
	   var oldFiles="";
	   $("input[name=isNew]").each(function(index){
		   
		   if($(this).val()=="false"){
			   if(index!=0) oldFiles+=",";
			   oldFiles+=$(this).next("label").text();
			   
		   }
	   });
	   console.log("oldFiles ="+oldFiles );
	   $("input#originFile").val(oldFiles);
	   
	   
	   
	return true;
}

/* $(document).ready(function(){
	$(".day").attr("disabled", true);
}); */


</script>
<form action="studyUpdateEnd.do" name="studyFrm" method="post" onsubmit="return validate();" enctype="multipart/form-data">
	
		<label for="local">지역 : </label>
		<select id="local" class="custom-select">
		</select>
		<select name="tno" id="town" class="custom-select">
		</select>	
		<input type="text" name="title" id="title" placeholder="제목" class="form-control" value="${study.TITLE }" required /><br />
		<%-- <label for="content">스터디 내용 : </label><textarea name="content" id="content" cols="30" rows="10" placeholder="내용을 입력해주세요" class="form-control">${study.CONTENT }</textarea><br /> --%>
		<textarea id="summernote" name="content" id="content" cols="30" rows="10" >${study.CONTENT }</textarea>
		<label for="depart">카테고리</label>
		<select id="kind"> <!-- ajax로 kind가져오기 -->
		</select>&nbsp;&nbsp;&nbsp;
		<select name="subno" id="subject" class="custom-select"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
		</select>
		<label for="diff">난이도 : </label>
		<select name="dno" id="diff" class="custom-select">
			<option value="1">입문</option>
		</select><br />
		<label for="ldate">신청마감 : </label><input type="date" name="ldate" id="ldate" value="${study.LDATE }"/>
		<label for="schedule">스터디 일정 : </label><input type="date" name="sdate" class="changeDate" id="sdate" value="${study.SDATE }"/>~<input type="date" name="edate" class="changeDate" id="edate" value="${study.EDATE }"/><br />
		<label for="freq">스터디빈도 : </label>
		<label>일 </label><input type="checkbox" name="freq" class="day"value="일" ${fn:contains(study.FREQ, "일")? "checked":""}/>
		<label>월 </label><input type="checkbox" name="freq" class="day" value="월" ${fn:contains(study.FREQ, "월")? "checked":""}/>
		<label>화 </label><input type="checkbox" name="freq" class="day" value="화" ${fn:contains(study.FREQ, "화")? "checked":""}/>
		<label>수 </label><input type="checkbox" name="freq" class="day" value="수" ${fn:contains(study.FREQ, "수")? "checked":""}/>
		<label>목 </label><input type="checkbox" name="freq" class="day" value="목" ${fn:contains(study.FREQ, "목")? "checked":""}/>
		<label>금 </label><input type="checkbox" name="freq" class="day" value="금" ${fn:contains(study.FREQ, "금")? "checked":""}/>
		<label>토 </label><input type="checkbox" name="freq" class="day" value="토" ${fn:contains(study.FREQ, "토")? "checked":""}/> 
		
		<label for="starttime">스터디 시간</label>
		
		<!-- 시간을 시작시간, 끝나는 시간으로 나누어서 비교하기 위해서 spilt함 -->
		<c:set var="times" value="${fn:split(study.TIME,'~')}"/>
		
		<select id="starttime" class="time custom-select">
			<c:forEach var="i" begin="6" end="23">
			<option value="${i }:00" ${fn:contains(fn:split(study.TIME,'~')[0],i)? "selected":""} >${i }:00</option>
			
			</c:forEach>
		</select>
		<select id="endtime" class="time custom-select">
			<c:forEach var="j" begin="7" end="24">
			<option value="${j }:00"${fn:contains(times[1],j)? "selected":""}>${j }:00</option>
			
			</c:forEach>
		</select><br />
		<input type="hidden" name="time" id="time"/>
		<label for="price">일회 사용회비 : </label><input type="text" name="price" id="price" class="form-control" placeholder="협의 - 스터디 카페 대여비 - 6000원" value="${study.PRICE }"/>
		<br />
		<label for="recruit">모집 인원 : </label>
		<select name="recruit" id="recruit" class="custom-select">
			<c:forEach var="i" begin="2" end="10">
			<option value="${i }" ${study.RECRUIT==i? "selected":"" } >${i }명</option>
			</c:forEach>
		</select><br />
		<label for="etc">기타 : </label><textarea name="etc" id="etc" cols="30" rows="10" class="form-control" >${study.ETC }</textarea><br /> 
		
		<!-- 기존의 업로드 파일 값들을 보낸다. -->
		<input type="hidden" name="originFile" id="originFile" />
		<button type="button" class="addFile btn-upfile btn">파일 추가</button>
		
		
		<!-- 첨부파일 영역들 여기 다 있다. -->
		<div id="upfile-container">
			<c:set var="imgFiles" value="${fn:split(study.UPFILE,',')}"/>
			<c:forEach var="img" items="${imgFiles }">
			<div class="input-group mb-3 fileWrapper" style="padding:0px">
				  <div class="input-group-prepend" style="padding:0px">
				    <span class="input-group-text">첨부파일</span>
				  </div>
				  <div class="custom-file">
				    <input type="file" class="custom-file-input" name="upFile">
				     <!-- 새로 첨부한 파일인지의 여부 -->
				    <input type="hidden" name="isNew" value="false" />
				    <label class="custom-file-label">${img }</label>
				  </div>
				 
				  <button type="button" class="removeFile btn-upfile btn">-</button>
			</div>
			</c:forEach>
		</div>
		
		<div class="btn-form">
			<input type="reset" value="취소하기" class="btn"/>
			<input type="submit" value="수정하기" class="btn" />
		</div>
		<input type="hidden" name="sno" value="${study.SNO }" />
	</form>
	<div class="input-group mb-3 forCopy" style="padding:0px">
			  <div class="input-group-prepend" style="padding:0px">
			    <span class="input-group-text">첨부파일</span>
			  </div>
			  <div class="custom-file">
			    <input type="file" class="custom-file-input" name="upFile">
			    <label class="custom-file-label">파일을 선택하세요</label>
			     <!-- 새로 첨부한 파일인지의 여부 -->
			 	 <input type="hidden" name="isNew" value="true" />
			  </div>
			  
			  <button type="button" class="removeFile btn-upfile btn">-</button>
	</div>