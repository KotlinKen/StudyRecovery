<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="게시물 등록" name="pageTitle" /></jsp:include>
${memberLoggedIn }
<c:set var = "images" value = "${fn:split(board.UPFILE, ',')}" />




<input type="hidden" name="type" value="일반"/>
<div class="form-row">
	<div class="form-group col-md-6">
		 <div> 제목 :  ${board.TITLE }</div>
	</div>
</div>

<div class="form-row">
	<div class="form-group col-md-6">
		내용:
		<textarea class="form-control" name="content" rows="2" readonly>${board.CONTENT}</textarea>

	</div>
</div>
<div class="form-row">
	<nav aria-label="Page navigation example">
	  <ul class="pagination">
	    <li class="page-item"><a class="page-link" href="#">Next</a></li>
	  </ul>
	</nav>
</div>

<button type="button" class="btn btn-primary" onclick="javascript:location.href='${rootPath}'/admin/boardList">목록</button>
  


<script>


$(function(){
loadData(11, 1, 1, 5);
});

function loadData(bno, type, cPage, pageBarSize){
	$.ajax({
		url:"${rootPath}/board/replyList?bno="+bno+"&cPage="+cPage,
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
			var rmHtml = "";
			var adversting = null;
			$(".table-responsive tbody").html(rmHtml);
		},error:function(){
			
		}
	});
}

</script>

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />
