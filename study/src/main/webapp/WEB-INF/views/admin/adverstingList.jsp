<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="BOARD" name="pageTitle" /></jsp:include>
<div class="studyList">
	<div class="table-responsive">
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>제목</th>
					<th>내용</th>
					<th>이미지</th>
					<th>링크</th>
					<th>위치</th>
					<th>상태</th>
					<th>컬러</th>
					<th>시작일</th>
					<th>종료일</th>
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

<div class="fluid-container">
  <div class="row text-left">
    <div class="col">
      <button type="button" class="btn btn-primary">Primary</button>
    </div>
    <div class="col-8">
    </div>
    <div class="col text-right">
      <button type="button" class="btn btn-primary" onclick="javascript:location.href='${rootPath}/admin/adverstingWrite'">광고작성</button>
    </div>
  </div>
</div>

<script>
$(function(){
	loadData("all", 1, 5);
});

function loadData(type, cPage, pageBarSize){
	$.ajax({
		url:"${rootPath}/rest/adversting/"+type+"/"+cPage+"/"+pageBarSize,
		dataType:"json",
		success:function(data){
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
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">이전</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor(\'all\,'+(pageNo-1)+','+5+')">다음</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadInstructor(\'all\,'+pageNo+','+5+')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">다음</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor(\'all\','+pageNo+','+5+')">다음</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var adversting = null;
	    	for(index in data.list){
	    		adversting = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr onclick=fn_adverstingView("+adversting.ANO+")>"
	    				rmHtml += "<td>"+adversting.ANO+"</td>";
		    			rmHtml += "<td>" +adversting.TITLE +"</td>";
		    			rmHtml += "<td>" +(adversting.CONTENT.replace(/(<([^>]+)>)/ig,"")).substring(0,10)+"</td>";
		    			rmHtml += "<td>" +adversting.ADVIMG+"</td>";
		    			rmHtml += "<td>" +adversting.URL+"</td>";
		    			rmHtml += "<td>" +adversting.POSITION+"</td>";
		    			rmHtml += "<td>" +adversting.STATUS+"</td>";
		    			rmHtml += "<td>" +adversting.BACKCOLOR+"</td>";
		    			rmHtml += "<td>" +adversting.STARTDATE+"</td>";
		    			rmHtml += "<td>" +adversting.ENDDATE+"</td>";
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}


function fn_adverstingView(ano){
	location.href="${rootPath}/admin/adverstingView?ano="+ano;

}
</script>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />