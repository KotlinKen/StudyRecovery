<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="STUDY" name="pageTitle" /></jsp:include>
<style>
div.infoinfo{
	display:none;
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
/* input#btn-search{
	position:relative;
	left:90%;
	top:0px;
} */
select#local, select#kind, select#subject, select#town, select#diff{
	width:100px;
}
input#leadername, input#title{
	width:200px;
	display:inline-block;
	padding:0.4rem 0.75rem;
}
div.btn-wrap{
	text-align:right;
	margin-bottom:5px;
}
button#btn-delete{
	background:lightblue;
	color:black;
	border-radius: 10px;
	padding:8px;
}
</style>
<script>
$(function(){
	$("#subject").hide();
	$("#town").hide();
	
	$("button#btn-search").click(function(){
		SearchStudy(1,5);
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
	
	//local 지역 리스트를 가져와 select 만듦. 
	 $.ajax({
		url:"${pageContext.request.contextPath}/study/selectLocal.do",
		dataType:"json",
		success:function(data){
			console.log("ddddd");
			var html="<option value='0'>선택하세요</option>";
			for(var index in data){
				html +="<option value='"+data[index].LNO+"'>"+data[index].LOCAL+"</option><br/>";
			}
			$("select#local").html(html); 
		}
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
					url:"${pageContext.request.contextPath}/study/selectTown.do",
					data:{lno:$(this).val()},
					dataType:"json",
					success:function(data){
						html += "<option value='0'>전체</option>";
						for(var index in data){
							html +="<option value='"+data[index].TNO+"'>"+data[index].TOWNNAME+"</option><br/>";
						}
						$("select#town").html(html);
					}
				});
		});
		
		 $.ajax({
				url:"${pageContext.request.contextPath}/study/selectKind.do",
				dataType:"json",
				success:function(data){
					var html="<option value='0'>선택하세요</option>";
					for(var index in data){
						html +="<option value='"+data[index].KNO+"'>"+data[index].KINDNAME+"</option><br/>";
					}
					$("select#kind").html(html);
					
				},error:function(){
					
				}
			}); 	
	
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
					url:"${pageContext.request.contextPath}/study/selectSubject.do",
					data:{kno:$(this).val()},
					dataType:"json",
					success:function(data){
						html += "<option value='0'>전체</option>";
						for(var index in data){
							html +="<option value='"+data[index].SUBNO+"'>"+data[index].SUBJECTNAME+"</option><br/>";
						}
						$("select#subject").html(html);
					}
				});
			
		});
		
		
	
	
	loadStudy(1, 5, 'study');
	
	$("div.alert").addClass("infoinfo");
	
	//스터디 목록에서 체크하고 삭제버튼 누른 이벤트 
	$("button#btn-delete").click(function(){
		var study_arr=[];
		
		$("input[name=isDelete]:checked").each(function(index){
			study_arr[index]=Number($(this).val());
		});
		console.log(study_arr);
		console.log(study_arr);
		 $.ajax({
			url:"${rootPath}/study/deleteStudysAdmin",
			data:{study_arr:study_arr},
			success:function(result){
				$("div.alert").removeClass("infoinfo");
				setTimeout(function(){
					$(".alert").remove();
				},3000);
				
				loadStudy(1, 5, 'study');
				
			}
		}); 
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
		

});



function loadStudy(cPage, pageBarSize, type){
	$.ajax({
		url:"${rootPath}/rest/"+type+"/all/"+cPage+"/"+pageBarSize,
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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadStudy('+(pageNo-1)+','+5+',\'study\')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadStudy('+pageNo+','+5+',\'study\')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadStudy('+pageNo+','+5+',\'study\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var study = null;
	    	for(index in data.list){
	    		study = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    		rmHtml += "<tr onclick=location.href='${rootPath}/study/studyView.do?sno="+study.SNO+"'>";
	    				rmHtml += "<td>"+study.SNO+"</td>";
		    			rmHtml += "<td>" +study.TITLE.substring(0,10) +"</td>";
	    				rmHtml += "<td>"+study.MNAME+"</td>";
	    				rmHtml += "<td>"+study.LNAME+"|"+study.TNAME+"</td>";
	    				rmHtml += "<td>"+study.KNAME+"|"+study.SUBNAME+"</td>";
	    				rmHtml += "<td>"+study.STATUS+"</td>";
	    				rmHtml += "<td>"+study.SDATE+"</td>";
	    				rmHtml += "<td>"+study.EDATE+"</td>";
	    				rmHtml += "<td>"+study.APPLYCNT+"</td>";
	    				rmHtml += "<td>"+study.RECRUIT+"</td>";
	    				rmHtml += "<td>"+study.FREQ+"<br>"+study.TIME+"</td>";
		    			/* rmHtml += "<td>" +(study.CONTENT.replace(/(<([^>]+)>)/ig,"")).substring(0,10)+"</td>"; */
		    			rmHtml += "<td>" +study.REGDATE+"</td>";
		    			rmHtml += "<td><input type='checkbox' name='isDelete' value="+study.SNO+"></td>"; 
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}// 스터디 리스트 로드
function SearchStudy(cPage, pageBarSize){
	var filter = {lno:$("select#local option:selected").val(),tno:$("select#town").val(),
			subno:$("select#subject").val(),kno:$("select#kind option:selected").val(),
			leadername:$("input#leadername").val(),title:$("input#title").val(),
			year:$("select#year").val(),month:$("select#month").val(),status:$("select#status").val()};
	
	console.log(filter);
	//제이슨 오브젝트로 만듦 
	$.ajax({   
		url:"${pageContext.request.contextPath}/study/AdminStudySearch/"+cPage+"/"+pageBarSize,
		dataType:"json",
		data: filter,
		success:function(data){
			
			console.log("검색함..");
			console.log(data);
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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:SearchStudy('+(pageNo-1)+','+5+')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:SearchStudy('+pageNo+','+5+')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:SearchStudy('+pageNo+','+5+')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var study = null;
	    	for(index in data.list){
	    		study = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr onclick=location.href='${rootPath}/study/studyView.do?sno="+study.SNO+"'>";
	    			rmHtml += "<td>"+study.SNO+"</td>";
	    			rmHtml += "<td>" +study.TITLE.substring(0,10) +"</td>";
    				rmHtml += "<td>"+study.MNAME+"</td>";
    				rmHtml += "<td>"+study.LNAME+"|"+study.TNAME+"</td>";
    				rmHtml += "<td>"+study.KNAME+"|"+study.SUBNAME+"</td>";
    				rmHtml += "<td>"+study.STATUS+"</td>";
    				rmHtml += "<td>"+study.SDATE+"</td>";
    				rmHtml += "<td>"+study.EDATE+"</td>";
    				rmHtml += "<td>"+study.APPLYCNT+"</td>";
    				rmHtml += "<td>"+study.RECRUIT+"</td>";
    				rmHtml += "<td>"+study.FREQ+"<br>"+study.TIME+"</td>";
	    			/* rmHtml += "<td>" +(study.CONTENT.replace(/(<([^>]+)>)/ig,"")).substring(0,10)+"</td>"; */
	    			rmHtml += "<td>" +study.REGDATE+"</td>";
	    			rmHtml += "<td><input type='checkbox' name='isDelete' value="+study.SNO+"></td>"; 
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
	
}
</script>
<div class="studyList">
	<div class="study-search">
		<table>
				<tr>
					<th>지역</th>
					<th>과목</th>
					<th>스터디명</th>
					<th>팀장명</th>
					<th>스터디 시작일</th>
					<th>스터디 상태</th>
					<th>검색</th>
				</tr>
				<tr>
					<td>
						<select name="lno" id="local" class="custom-select">
						</select>
					</td>
					<td>
						<select name="kno" id="kind" class="custom-select">
						</select>
					</td>
					<td>
						<input type="text" name="title" id="title" placeholder="스터디명을 입력하세요" class="form-control" maxlength="10" />
					</td>
					<td>
						<input type="text" name="leadername" id="leadername" placeholder="팀장명을 입력하세요" class="form-control" maxlength="10"/>
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
						<input type="button" id="btn-search" value="필터 검색" class="btn btn-dark"/>
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
		<div class="btn-wrap">
			<button type='button' id="btn-delete">스터디 삭제</button>
		</div>
		
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>제목</th>
					<th>팀장</th>
					<th>지역</th>
					<th>과목</th>
					<th>상태</th>
					<th>시작</th>
					<th>종료</th>
					<th>신청인원</th>
					<th>모집인원</th>
					<th>시간</th>
					<th>등록일</th>
					<th>선택</th>
				</tr>
			</thead>
			<tbody>
			
			</tbody>
		</table>
	</div>
	<nav aria-label="Page navigation example">
	  <ul class="pagination">
	    <li class="page-item"><a class="page-link" href="#">Next</a></li>
	  </ul>
	</nav>
	<div class="alert" role="alert">
	  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	  <strong>Success!</strong> 스터디 삭제 성공
	</div>
</div>
<a class="btn btn-primary btn-lg" style="font-size: 12px;color: white;" href="${rootPath}/adminSub/loadListView.do">지역 관리</a>
<a class="btn btn-primary btn-lg" style="font-size: 12px;color: white;" href="${rootPath}/adminSub/kindListView.do">카테고리 관리</a>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />