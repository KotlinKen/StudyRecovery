<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="STUDY" name="pageTitle" /></jsp:include>
<style>
div.infoinfo{
	display:none;
}
</style>
<div class="studyList">
	<div class="table-responsive">
		<button type='button' id="btn-delete">스터디 삭제</button>
		<select id="searchKwd">
			<option value="title" >강의/스터디명</option>
			<option value="captain">팀장/강사명</option>
			<option value="subject">과목</option>
			<option value="place">스터디 장소</option>
			<option value="diff" >난이도</option>
			<option value="term" >스터디 시작일</option>
			<option value="freq" >주기</option>
		</select>
		<input type="text" name="title" id="title" placeholder="강의/스터디명을 입력하세요" />
		<input type="text" name="leadername" id="leadername" placeholder="팀장/강사명을 입력하세요" />
		<select name="kno" id="category">
		
		</select>
		<select name="subno" id="subject">
		
		</select>
		<select name="lno" id="local">
		
		</select>
		<select name="tno" id="town">
		
		</select>
		<select name="dno" id="diff">
		
		</select>
		
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>제목</th>
					<th>내용</th>
					<th>레벨</th>
					<th>시작</th>
					<th>종료</th>
					<th>상태</th>
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







<script>
$(function(){
	
	
	//local 지역 리스트를 가져와 select 만듦. 
	 $.ajax({
		url:"/study/selectLocal.do",
		dataType:"json",
		success:function(data){
			var html="<option>선택하세요</option>";
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
	
	
	
	
	
	$("select#searchKwd").change(function(){
		
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
		
	



});// $(function(){});



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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadStudy('+pageNo+','+5+','+',\'study\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var study = null;
	    	for(index in data.list){
	    		study = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr>"
	    				rmHtml += "<td>"+study.SNO+"</td>";
		    			rmHtml += "<td>" +study.TITLE.substring(0,10) +"</td>";
		    			rmHtml += "<td>" +(study.CONTENT.replace(/(<([^>]+)>)/ig,"")).substring(0,10)+"</td>";
		    			rmHtml += "<td>" +study.DNAME+"</td>";
		    			rmHtml += "<td>" +study.SDATE+"</td>";
		    			rmHtml += "<td>" +study.EDATE+"</td>";
		    			rmHtml += "<td>" +study.STATUS+"</td>";
		    			rmHtml += "<td>" +study.REGDATE+"</td>";
		    			rmHtml += "<td><input type='checkbox' name='isDelete' value="+study.SNO+"></td>"; 
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}// 스터디 리스트 로드
</script>



<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />