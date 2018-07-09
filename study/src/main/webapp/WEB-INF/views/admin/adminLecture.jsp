<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="LECTURE" name="pageTitle" /></jsp:include>
<style>
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
select#local, select#kind, select#sub, select#town, select#diff{
	width:100px;
}
input#leadername, input#title{
	width:200px;
	display:inline-block;
	padding:0.4rem 0.75rem;
}
</style>
<div class="lectureList">
	<div class="lecture-search">
		<table>
				<tr>
					<th>지역</th>
					<th>과목</th>
					<th>강의명</th>
					<th>강사명</th>
					<th>강의 시작일</th>
					<th>강의 상태</th>
					<th>검색</th>
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
						<select name="kind" id="kind" class="custom-select">
							 <option value="0">전체</option>
				         
					         <c:if test="${!empty kindList }">
						         <c:forEach var="kind" items="${kindList }" varStatus="vs">
						            <option value="${kind.KNO }">${kind.KINDNAME }</option>
						         </c:forEach>
					         </c:if>
						</select>
					</td>
					<td>
						<input type="text" name="title" id="title" placeholder="강의명을 입력하세요" class="form-control" maxlength="10" />
					</td>
					<td>
						<input type="text" name="leadername" id="leadername" placeholder="강사명을 입력하세요" class="form-control" maxlength="10"/>
					</td>	
					<td>
						<select name="year" id="year" class="custom-select">
							<option value="">년도를 선택하세요</option>
							<c:forEach var="i" begin="2018" end="2022">
								<option value="${i }">${i }년</option>
							</c:forEach>
						</select>
					</td>	
					<td>
						<select name="status" id="status" class="custom-select">
							<option value="전체">전체</option>
							<option value="모집 중">모집중</option>
							<option value="마감 임박">마감 임박</option>
							<option value="모집 마감">모집 마감</option>
							<option value="진행 중">진행 중</option>
							<option value="스터디 종료">스터디 종료</option>
						</select>
					</td>	
					<td>
						<button type="button" id="searchBtn" class="btn btn-dark">필터 검색</button>	
					</td>	
				</tr>
				<tr>
					<td>
						<select name="tno" id="town" class="custom-select">
							<option value="0">전체</option>
						</select>
					</td>
					<td>
						<select name="subno" id="sub" class="custom-select">
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
						<select name="month" id="month" class="custom-select">
							<option value="0">월을 선택하세요</option>
							<c:forEach var="i" begin="1" end="12">
								<option value="${i>10?'':'0' }${i}">${i }월</option>
							</c:forEach>
						</select>
					</td>
					<td>
						
					</td>
					<td>
						<a href="#" id="reFilter">검색 조건 초기화</a>
					</td>
				</tr>
			</table>
	</div>
	<div class="table-responsive">
	
		<!-- 삭제 버튼. -->
		<!-- <button type='button' id="deleteLecturesBtn">강의 삭제</button> -->
	
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>NO</th>
					<th>제목</th>
					<th>지역</th>
					<th>과목</th>
					<th>인원</th>
					<th>강사</th>
					<th>진행일</th>
					<th>진행 시간</th>
					<th>가격</th>
					<th>현황</th>
					<th>등록일</th>
					<th></th>
				</tr>
			</thead>			
			<tbody>
			
			</tbody>
		</table>
	</div>
	<nav aria-label="Page navigation example">
	  <ul class="pagination">
	    <li class="page-item">
	    	<a class="page-link" href="#">Next</a>
	    </li>
	  </ul>
	</nav>
</div>

<script>
$(function(){
	loadLecture(1, 5, 'lecture');
	
	$("#town").hide(); 
	$("#sub").hide(); 
	$("select#month").hide();
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
			url: "${pageContext.request.contextPath}/lecture/selectTown.do",
			data: {localNo : localNo},
			dataType: "json",
			success : function(data){
				var html="";
           
				html += "<option value='0'>전체</option>";
				
				for(var index in data){
					html += "<option value='"+data[index].TNO +"'>" + data[index].TOWNNAME + "</option>";
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
			url: "${pageContext.request.contextPath}/lecture/selectSubject.do",
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
	
	$("#searchBtn").click(function(){
		searchAdminLecture(1, 5);
	});
	
	$("select#month").hide();
	$("select#year").on('change',function(){
		console.log($(this).val());
		if($(this).val()!=''){
			$("select#month").show();
		}else{
			$("select#month").hide();
		}
		
	});
	
	
	//검색 필터 조건 초기화 하기
	$("a#reFilter").click(function(){
		$("#town").hide();
		$("#subject").hide();
		$("#month").hide();
		$("#town").html("<option value='0'></option>");
		$("#subject").html("<option value='0'></option>");
		
		
		
		$("#local option:eq(0)").prop("selected", true);
		$("#kind option:eq(0)").prop("selected", true);
		$("#status option:eq(0)").prop("selected", true);
		
		$('#leadername').val("");
		$('#title').val("");
		
		
		
		console.log("검색 조건 초기화");
		
		
		
	});
});// $(function(){});

$("#deleteLecturesBtn").click(function(){
	var lectures = [];
	
	$("input[name=lecture]:checked").each(function(index){
		lectures[index] = Number($(this).val());	
	})
	
	$.ajax({
		url : "${rootPath}/lecture/deleteLectures",
		data : { lectures : lectures },
		success : function(data){
			loadLecture(1,5,'lecture');
		}
	});
});

// 강의 불러오는 함수.
function loadLecture(cPage, pageBarSize, type){
	$.ajax({
		url:"${rootPath}/"+type+"/all/"+cPage+"/"+pageBarSize,
		dataType:"json",
		success:function(data){
			
			var numPerPage = data.numPerPage;
			var cPage = data.cPage;
			var total = data.total;
			var totalPage = Math.ceil(parseFloat(total)/numPerPage);
			var pageNo = (Math.floor((cPage - 1)/parseFloat(pageBarSize))) * pageBarSize +1;
			var pageEnd = pageNo + pageBarSize - 1;
			var pageNation ="";
			
			$pagination = $(".pagination");
			
			if(pageNo == 1 ){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadLecture('+(pageNo-1)+','+5+',\'lecture\')">Previous</a></li>';
			}
			
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadLecture('+pageNo+','+5+',\'lecture\')">'+pageNo+'</a></li>';
				pageNo++;
			}
			
			//다음 버튼			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadLecture('+pageNo+','+5+',\'lecture\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);

			var rmHtml = "";
			var lecture = null;
	    	for(index in data.list){
	    		lecture = data.list[index];
	    		
	    		var upfile = (data.list[index].UPFILE);
	    		
	    		rmHtml += "<tr onclick=location.href='${rootPath}/lecture/lectureView.do?sno="+lecture.SNO+"'>"
    				rmHtml += "<td>"+lecture.SNO+"</td>";
	    			rmHtml += "<td>" +lecture.TITLE+"</td>";
	    			rmHtml += "<td>" +lecture.LOCAL + "/" + lecture.TNAME+"</td>";
	    			rmHtml += "<td>" +lecture.KNAME + "/" + lecture.SUBNAME +"</td>";
	    			rmHtml += "<td>" +lecture.CNT +"/" + lecture.RECRUIT+"</td>";
	    			rmHtml += "<td>" +lecture.MNAME+"</td>";
	    			rmHtml += "<td>" +lecture.SDATE +"~" + lecture.EDATE+"</td>";
	    			rmHtml += "<td>" +lecture.FREQ +"<br>" + lecture.TIME +"</td>";
	    			rmHtml += "<td>" +lecture.PRICE+"</td>";
	    			rmHtml += "<td>" +lecture.STATUS+"</td>";
	    			rmHtml += "<td>" +lecture.REGDATE+"</td>";
	    			
					if( lecture.CNT == 0 && (lecture.STATUS == "모집 중" || lecture.STATUS == "마감 임박"))
						rmHtml += "<td><input type='checkbox' name='lecture' id='deleteLecturesBtn'/></td>";
					else
						rmHtml += "<td></td>";
    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}// 강의 리스트 로드

function searchAdminLecture(cPage, pageBarSize){
	$.ajax({
		url : "${rootPath}/lecture/searchAdminLecture/"+cPage+"/"+pageBarSize,
		dataType : "json",
		data : {
			lno	: $("#local option:selected").val(),
			tno : $("#town option:selected").val(),
			subno : $("#sub option:selected").val(),
			kno : $("#kind option:selected").val(),
			leader : $("#leader").val(),
			title : $("#title").val(),
			year : $("#year").val(),
			month : $("#month").val(),
			status : $("#status").val()
		},
		success : function(data){
			var numPerPage = data.numPerPage;
			var cPage = data.cPage;
			var total = data.total;
			var totalPage = Math.ceil(parseFloat(total)/numPerPage);
			var pageNo = (Math.floor((cPage - 1)/parseFloat(pageBarSize))) * pageBarSize +1;
			var pageEnd = pageNo + pageBarSize - 1;
			var pageNation ="";

			$pagination = $(".pagination");
			
			if(pageNo == 1 ){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:searchAdminLecture('+(pageNo-1)+','+5+')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:searchAdminLecture('+(pageNo)+','+5+')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:searchAdminLecture('+(pageNo)+','+5+')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);

			var rmHtml = "";
			var lecture = null;
			
	    	for(index in data.list){
	    		lecture = data.list[index];
	    		
    			rmHtml += "<tr onclick=location.href='${rootPath}/lecture/lectureView.do?sno="+lecture.SNO+"'>"
    				rmHtml += "<td>"+lecture.SNO+"</td>";
	    			rmHtml += "<td>" +lecture.TITLE+"</td>";
	    			rmHtml += "<td>" +lecture.LOCAL + "/" + lecture.TOWNNAME+"</td>";
	    			rmHtml += "<td>" +lecture.KNAME + "/" + lecture.SUBNAME +"</td>";
	    			rmHtml += "<td>" +lecture.CNT +"/" + lecture.RECRUIT+"</td>";
	    			rmHtml += "<td>" +lecture.MNAME+"</td>";
	    			rmHtml += "<td>" +lecture.SDATE +"~" + lecture.EDATE+"</td>";
	    			rmHtml += "<td>" +lecture.FREQ +"<br>" + lecture.TIME +"</td>";
	    			rmHtml += "<td>" +lecture.PRICE+"</td>";
	    			rmHtml += "<td>" +lecture.STATUS+"</td>";
	    			rmHtml += "<td>" +lecture.REGDATE+"</td>";
	    			
	    			if( lecture.CNT == 0 && (lecture.STATUS == "모집 중" || lecture.STATUS == "마감 임박"))
						rmHtml += "<td><input type='checkbox' name='lecture' id='deleteLecturesBtn'/></td>";
					else
						rmHtml += "<td></td>";
    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);
		}
	});
}
</script>
${test }

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />