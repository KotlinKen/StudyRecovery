<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="STUDY" name="pageTitle" /></jsp:include>

<div class="studyList">
	<div class="table-responsive">
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
</div>







<script>
$(function(){
	loadStudy(1, 5, 'study');



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
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}// 스터디 리스트 로드
</script>
${test }


<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />