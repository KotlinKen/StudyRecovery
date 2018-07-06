<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="BOARD" name="pageTitle" /></jsp:include>


<div class="fluid-container">
  <div class="row text-left" style="margin-bottom:10px;">
    <div class="col">
    </div>
    <div class="col-8">
    </div>
    <div class="col text-right">
      <button type="button" class="btn btn-primary" onclick="javascript:location.href='${rootPath}/admin/boardWrite'">게시물작성</button>
    </div>
  </div>
</div>
<div class="studyList">
	<div class="table-responsive">
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th width="5%">번호</th>
					<th width="15%">제목</th>
					<th width="35%">내용</th>
					<th width="5%">타입</th>
					<th width="10%">채택</th>
					<th width="10%">작성자</th>
					<th width="10%">등록일</th>
					<th width="5%">수정</th>
					<th width="5%">보기</th>
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
	loadInstructor(1, 10, "all");
});

function loadInstructor(cPage, pageBarSize, type){
	$.ajax({
		url:"${rootPath}/rest/board/"+type+"/"+cPage+"/"+pageBarSize,
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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+(pageNo-1)+','+pageBarSize+',\'all\')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadInstructor('+pageNo+','+pageBarSize+',\'all\')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+pageNo+','+pageBarSize+',\'all\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var board = null;
	    	for(index in data.list){
	    		board = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr>"
	    				rmHtml += "<td>"+board.BNO+"</td>";
		    			rmHtml += "<td class='text-left'>" +board.TITLE +"</td>";
		    			rmHtml += "<td class='text-left'>" +(board.CONTENT.replace(/(<([^>]+)>)/ig,"")).replace("&nbsp;","").substring(0,45)+"</td>";
		    			rmHtml += "<td>" +board.TYPE+"</td>";
		    			rmHtml += "<td>" +board.FORK+"</td>";
		    			rmHtml += "<td>" +board.MNAME+"</td>";
		    			rmHtml += "<td>" +board.REG+"</td>";
		    			rmHtml += "<td><button class='btn btn-primary' onclick='fn_boardModify("+board.BNO+")'>수정</button></td>";
		    			rmHtml += "<td><button class='btn btn-primary' onclick='fn_boardView("+board.BNO+")'>보기</button></td>";
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}
function fn_boardView(bno){
	location.href="${rootPath}/admin/boardView?bno="+bno;
}
function fn_boardModify(bno){
	location.href="${rootPath}/admin/boardModify?bno="+bno;
}	
</script>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />