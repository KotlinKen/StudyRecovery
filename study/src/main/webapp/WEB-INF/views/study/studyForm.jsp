<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 <jsp:include page="/WEB-INF/views/common/header.jsp">
 	<jsp:param value="" name="pageTitle"/>
</jsp:include>	 

<style>
div.forCopy{
	display:none;
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
 			  
 		  	  var file=$("<img>").attr("src",
 		  			  "${pageContext.request.contextPath }/resources/upload/study/"+data.url);
 			  $(el).summernote('insertNode',file[0]);
 		  },error:function(data){
 			  console.log("error:"+data);
 		  }
 	 });
 	  
   }
  
  

</script>

<script>
function validate(){

	// 유효성 검사 - 지역,도시
	var local = $("#local").val();
	var town = $("#town").val();
	console.log("local="+local+";;");
	if( local=="선택하세요" || town=="세부 지역을 선택하세요"){
		alert("지역을 선택해주세요");
		return false;	
	}
	
	// 유효성 검사 - 카테고리, 세부종목
	var kind = $("#kind").val();
	var sub = $("#subject").val();
	console.log(kind);
	if( kind=="선택하세요" || sub=="세부 과목을 선택하세요"){
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
	
	
		/*               시작 시간 마감 시간 유효성 검사             */
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
			return false;
		}
		/*               시작 시간 마감 시간 유효성 검사             */
	
	
	// time만들기.
	var startTime = $("#starttime option:checked").val();
	var endTime = $("#endtime option:checked").val();	
	
	$("#time").val(startTime + "~" + endTime);	
	
	
   var file = $("div.fileWrapper div.custom-file input:file");
   var fileVal = file.val();
   var cnt = 0;

   file.each(function(){
      if( fileVal != "" ) 
         cnt++;
   });
   
     console.log(cnt);
   if( cnt == 0 ){
      alert("사진을 최소 1개이상 등록해주세요.");
      return false;   
   }
   
// summernote required마냥 만들어주기.
   var sumVal = $("#summernote").val();
   
   if( sumVal.trim().length == 0 ){
      alert("내용을 입력해주세요");
      return false;
   }
	return true;
}

$(document).ready(function(){
	
	
	$(".day").attr("disabled", true);
	$("#subject").hide();
	$("#town").hide();
	
	var date = new Date();
	var year = date.getFullYear();
	var month = new String(date.getMonth()+1);
	var day = new String(date.getDate());
	
	if(month.length == 1 )
		month = "0" + month;
	if( day.length == 1 )
		day = "0" + day;
	
	var today = year + "-" + month + "-" + day;
	
	$("#ldate").attr("min", today);
	$("#sdate").attr("min", today);
	$("#edate").attr("min", today);
});

$(function(){
	
	//첨부파일 선택하면 파일 이름이 input창에 나타나게한다.
	//첨부파일이름 표시
	$("form[name=studyFrm]").on("change","[name=upFile]",function(){
		var fileName= $(this).prop("files")[0].name;
		
		$(this).next(".custom-file-label").html(fileName);
	});

	
	//local 지역 리스트를 가져와 select 만듦. 
	 $.ajax({
		url:"selectLocal.do",
		dataType:"json",
		success:function(data){
			var html="<option>선택하세요</option>";
			for(var index in data){
				html +="<option value='"+data[index].LNO+"'>"+data[index].LOCAL+"</option><br/>";
			}
			$("select#local").html(html); 
			
			
		}
	}); 
	
	//local 선택하면 town 리스트 가져와 select 만듦. 
	//on(change) event, ajax event
	 $("select#local").on("change",function(){
		 var lno=$("select#local option:selected").val();

		if(lno == ""){
			$("#town").hide();
			return;
		}
		
		$("#town").show();
		 
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
				html +="<option value='"+data[index].KNO+"'>"+data[index].KINDNAME+"</option><br/>";
			}
			$("select#kind").html(html);
			
		},error:function(){
			
		}
	}); 	
	
	//kind를 선택하면 해당하는 과목들을들을 가져와 리스트를 생성한다.
	 $("select#kind").on("change",function(){
		 
		var kno= $("option:selected", this).val();
			
		if(kno == "선택하세요"){
			$("#subject").hide();
			return;
		}
		$("#subject").show();
		 
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
			console.log(data);
			var html="";
			for(var index in data){
				html +="<option value='"+data[index].DNO+"'>"+data[index].DIFFICULTNAME+"</option><br/>";
			}
			$("select#diff").html(html);
			
		},error:function(){
			
		}
	}); 	
	
	//첨부파일 + 버튼 클릭시 첨부파일창이 밑에 더 생긴다.
	$("form[name=studyFrm]").on("click","button.addFile",function(){
		console.log("adddd");
		if($("div.fileWrapper").length<10){
			$("div.fileWrapper:last").after($("div.forCopy").clone().removeClass("forCopy").addClass("fileWrapper"));
		}
			
	});
	
	//첨부파일 - 버튼 클릭시  해당 첨부파일 영역이 사라진다.
	$("form[name=studyFrm]").on("click","button.removeFile",function(){
		console.log($("div.fileWrapper:eq(0)"));
		if( $(this).parent("div.fileWrapper")[0]!==$("div.fileWrapper:eq(0)")[0]){ //맨첫번째 첨부파일은 삭제이벤트 발생안함.
			$(this).parent("div.fileWrapper").remove();
		}
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
	
	$("div.fileWrapper div.custom-file input:file").on('change',function(){
	      var ext = $(this).val().split(".").pop().toLowerCase();
	      console.log("ext="+ext);
	       if (ext.length > 0) {
	          if ($.inArray(ext, [ "gif", "png", "jpg",
	                "jpeg" ]) == -1) {
	             alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
	             return false;
	          }
	       }
	       
	       
	 });
	
});

</script>
<div class="container">
<div id="study-container">
	<form action="studyFormEnd.do" name="studyFrm" method="post" onsubmit="return validate();" enctype="multipart/form-data">
		
		<label for="local">지역 : </label>
		<select name="lno" id="local">
		</select>
		<select name="tno" id="town">
		</select>	
		<input type="text" name="title" id="title" placeholder="제목" maxlength="100" class="form-control" required /><br />
		<textarea id="summernote" name="content" cols="30" rows="10" placeholder="내용을 입력해주세요"></textarea>
		<label for="depart">카테고리</label>
		<select name="kno" id="kind"> <!-- ajax로 kind가져오기 -->
		</select>&nbsp;&nbsp;&nbsp;
		<select name="subno" id="subject"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
		</select>
		<label for="diff">난이도  </label>
		<select name="dno" id="diff">
			<option value="1">입문</option>
		</select><br />
		<label for="ldate">신청마감  </label><input type="date" name="ldate" id="ldate" />
		<label for="schedule">스터디 일정 : </label><input type="date" name="sdate" id="sdate" class="changeDate"/>~<input type="date" name="edate" id="edate" class="changeDate" /><br />
		<label for="freq">스터디빈도  </label>
		<label>일 </label><input type="checkbox" name="freq" class="day" value="일"/>
		<label>월 </label><input type="checkbox" name="freq" class="day" value="월"/>
		<label>화 </label><input type="checkbox" name="freq" class="day" value="화"/>
		<label>수 </label><input type="checkbox" name="freq" class="day" value="수"/>
		<label>목 </label><input type="checkbox" name="freq" class="day" value="목"/>
		<label>금 </label><input type="checkbox" name="freq" class="day" value="금"/>
		<label>토 </label><input type="checkbox" name="freq" class="day" value="토"/> 
		
		<label for="starttime">스터디 시간</label>
		<select name="starttime" id="starttime" class="time">
			<c:forEach var="i" begin="6" end="23">
			<option value="${i }:00">${i }:00</option>
			
			</c:forEach>
		</select>
		
		<select name="endtime" id="endtime" class="time">
			<c:forEach var="j" begin="7" end="24">
			<c:if test="${j < 24}">
				<option value="${j }:00">${j }:00</option>	
			</c:if>
			 <c:if test="${j == 24 }">
				<option value="${j }:00" selected>${j }:00</option>		 
			 </c:if>
		</c:forEach>
		</select>
		<br />
		
		<input type="hidden" name="time" id="time"/>
		<label for="price">일회 사용회비 : </label>
		<input type="number" name="price" id="price" class="form-control" placeholder="협의 - 스터디 카페 대여비 - 6000" min="0" step="1000" max="100000" value="0" required />
		<br />
		
		<label for="recruit">모집 인원 : </label>
		<select name="recruit" id="recruit">
			<c:forEach var="i" begin="2" end="10">
				<option value="${i }">${i }명</option>
			</c:forEach>
		</select>
		<br />
		
		<label for="etc">기타 : </label><textarea name="etc" id="etc" cols="30" rows="10" class="form-control" maxlength="1000"></textarea><br /> 
		
		<!-- 첨부파일 영역 -->
		<div class="input-group mb-3 fileWrapper" style="padding:0px">
			  <div class="input-group-prepend" style="padding:0px">
			    <span class="input-group-text">첨부파일</span>
			  </div>
			  <div class="custom-file">
			    <input type="file" class="custom-file-input" name="upFile" accept="image/*" required >
			    <label class="custom-file-label">파일을 선택하세요</label>
			  </div>
			  <button type="button" class="addFile">+</button>
			  <button type="button" class="removeFile">-</button>
		</div>
		
	
		<input type="reset" value="취소하기" />
		<input type="submit" value="등록하기" />
		
			<!-- 테스트용 -->
		<div id="output"></div>
	</form>
	
	<div class="input-group mb-3 forCopy" style="padding:0px">
		  <div class="input-group-prepend" style="padding:0px">
		    <span class="input-group-text">첨부파일</span>
		  </div>
		  
		  <div class="custom-file">
		    <input type="file" class="custom-file-input" name="upFile" accept="image/*" required>
		    <label class="custom-file-label" >파일을 선택하세요</label>
		  </div>
		  
		  <button type="button" class="addFile">+</button>
		  <button type="button" class="removeFile">-</button>
	</div>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
