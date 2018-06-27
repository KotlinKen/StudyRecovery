<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<jsp:include page ="/WEB-INF/views/common/header.jsp">
	<jsp:param value="광고등록" name="pageTitle"/>
</jsp:include>
<div class="container">
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


	<form action="${rootPath }/board/replyWrite" method="post" class="form-inline">
		<input type="hidden" name="bno" value="${board.BNO}" /> <input type="hidden" name="mno" value="${memberLoggedIn.mno}" />
		<div class="form-group md-4">
			<span class="comment_profile" style="background-image:url('${rootPath }/resources/upload/member/${memberLoggedIn.mprofile }')"></span>
		</div>
		<div class="form-group md-8">
			<label for="comment">코멘트</label>
			<textarea class="form-control" id="comment" rows="3" name="content"></textarea>
		</div>
		<button type="submit">전송</button>
	</form>


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
<button type="button" class="btn btn-primary" onclick="javascript:location.href='${rootPath}'/board/boardList">목록</button>
  


<script>


$(function(){
loadData(${board.BNO }, 1, 1, 5);
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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadData(${board.BNO}, 1, '+(pageNo-1)+','+5+')">다음</a></li>';
			}
  			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadData(${board.BNO}, 1 ,'+pageNo+','+5+')">'+pageNo+'</a></li>';
				pageNo++;
			} 
			
			
			//다음 버튼
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">다음</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadData(${board.BNO}, 1,'+pageNo+','+5+')">다음</a></li>';
			}
			//페이지 버튼 생성
			$pagination.html(pageNation);
			var rmHtml = "";
			var reply = null;
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var reply = null;
	    	for(index in data.list){
	    		reply = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr onclick=fn_replyView(this,"+reply.RNO+")>"
		    			rmHtml += "<td>" +reply.CONTENT +"</td>";
		    			rmHtml += "<td>" +reply.CONTENT +"</td>";
		    			rmHtml += "<td>" +reply.MID+"</td>";
		    			if('${memberLoggedIn.mno}'== reply.MNO){ 
		    				rmHtml += "<td><button>수정</button><button>삭제</button></td>";
		    			}
		    			if('${memberLoggedIn.mno}'== '${board.MNO}' && '${memberLoggedIn.mno}' != reply.MNO && '${board.FORK}' != "1"){ 
		    				rmHtml += "<td><button onclick='fn_fork("+reply.MNO+", "+${board.BNO}+")'>채택</button></td>";
		    			}
		    			rmHtml += "<td>" +reply.MPROFILE+"</td>";
		    			rmHtml += "<td>" +reply.REGDATE+"</td>";
	    			rmHtml += "</tr>";
	    			//대댓글용
/* 	    			rmHtml += "<tr>";
		    			rmHtml += "<td> ";
		    			rmHtml += "</td>";
		    			rmHtml += "<td colspan='3'>";
	    				rmHtml += "<form action='${rootPath}/admin/replyWrite' method='post'>";
		    			rmHtml += "<input type='hidden' name='parentno' value='"+reply.RNO+"'/>";
		    			rmHtml += "<input type='hidden' name='bno' value='"+reply.BNO+"'/>";
		    			rmHtml += "<input type='hidden' name='mno' value='${memberLoggedIn.mno}'/>";
		    			rmHtml += "<input type='hidden' name='lev' value='"+(reply.LEV+1)+"'/>";
		    			rmHtml += "<input type='text' name='title'/>";
		    			rmHtml += "<textarea name='content'></textarea>";
		    			rmHtml += "<button type='submit'>전송</button>";
		    			rmHtml += "</form>";
		    			rmHtml += "</td>";
		    			rmHtml += "<td>";
		    			rmHtml += "</td>";
	    			rmHtml += "</tr>"; */
	    	}
			$(".table-responsive tbody").html(rmHtml);
			
			
		},error:function(){
			
		}
	});
}



function fn_fork(mno, bno){
	location.href='${rootPath}/board/boardReplyFork?mno='+mno+'&bno='+bno;
}
	
</script>



<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
