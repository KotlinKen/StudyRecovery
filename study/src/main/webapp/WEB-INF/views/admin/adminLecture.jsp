<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="LECTURE" name="pageTitle" /></jsp:include>

<div class="lectureList">
	<div class="table-responsive">
		<!-- 삭제 버튼. -->
		<button type='button' id="deleteLecturesBtn">강의 삭제</button>
	
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
	    <li class="page-item">
	    	<a class="page-link" href="#">Next</a>
	    </li>
	  </ul>
	</nav>
</div>

<script>
$(function(){
	loadLecture(1, 5, 'lecture');
});// $(function(){});

$("#deleteLecturesBtn").click(function(){
	var lectures = [];
	
	$("input[name=lecture]:checked").each(function(index){
		lectures[index] = Number($(this).val());	
	})
	
	console.log(lectures);
	
	$.ajax({
		url : "${rootPath}/lecture/deleteLectures",
		data : { lectures : lectures },
		success : function(data){
			loadLecture(1,5,'lecture');
		}
	});
});

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
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadLecture('+pageNo+','+5+',\'lecture\')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadLecture('+pageNo+','+5+','+',\'lecture\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var lecture = null;
	    	for(index in data.list){
	    		lecture = data.list[index];
	    		
	    		var upfile = (data.list[index].UPFILE);
	    		
    			rmHtml += "<tr>"
    				rmHtml += "<td>"+lecture.SNO+"</td>";
	    			rmHtml += "<td>" +lecture.TITLE.substring(0,10) +"</td>";
	    			rmHtml += "<td>" +(lecture.CONTENT.replace(/(<([^>]+)>)/ig,"")).substring(0,10)+"</td>";
	    			rmHtml += "<td>" +lecture.DNAME+"</td>";
	    			rmHtml += "<td>" +lecture.SDATE+"</td>";
	    			rmHtml += "<td>" +lecture.EDATE+"</td>";
	    			rmHtml += "<td>" +lecture.STATUS+"</td>";
	    			rmHtml += "<td>" +lecture.REGDATE+"</td>";
	    			rmHtml += "<td><input type='checkbox' name='lecture' value="+lecture.SNO+"></td>"; 
    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}// 강의 리스트 로드
</script>
${test }

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />