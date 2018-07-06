<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="BOARD" name="pageTitle" /></jsp:include>


<style>
.btn-lg {
	border-radius: 0.2rem;
	font-size: 0.8rem;
	padding: 0.6rem 1rem;
	border: none;
}

#searchType {
	font-size: 0.8rem;
	-webkit-appearance: none;
	padding: 0.6rem 1rem;
	
}
.searchKeyword {
	padding: 0.6rem 1rem;
	font-size: 0.8rem;
}
</style>

<script>
	function searchVaildation(){
		$searchBox = $(".searchBox");
		$searchType = $searchBox.find("#searchType");
		$searchKeyword = $searchBox.find("#searchKeyword");
		
		$searchTypeVal = $searchType.val();
		$searchKeywordVal = $searchKeyword.val();
		
		
	}
</script>



<div class="fluid-container searchBox">
	<div class="row text-left" style="margin-bottom: 10px;">
		<div class="col-8">
			<input type="hidden" name="cPage" value="1" />
			<div class="form-row">
				<div class="form-group col-md-1" style="max-width: 90px;">
					<select name="searchType" id="searchType" class="searchType">
						<option value="title" ${param.searchType eq "title" || param.searchType eq null ? "selected" : "" }>제목</option>
						<c:if test="${mber.mid eq 'manager' }">
							<option value="mname" ${param.searchType eq "mname" ? "selected" : "" }>작성자</option>
						</c:if>
						<option value="content" ${param.searchType eq "content" ? "selected" : "" }>내용</option>
						
						<option value="type" ${param.searchType eq "type" ? "selected" : "" }>타입</option>
					</select>
				</div>
				

		<div class="form-group col-md-3">
						<input type="hidden" name="type" value="${param.type}" /> <input type="text" name="searchKeyword" class="form-control searchKeyword" id="searchKeyword" value="${param.searchKeyword }" autocomplete="off" />
					</div>
				
				<div class="form-group col-md-1">
					<button type="button" class="form-control btn btn-primary btn-lg" onclick="searchVaildation()">검색</button>
				</div>
			</div>
		</div>
		<div class="col-2"></div>
		<div class="col text-right">
			<button type="button" class="btn btn-primary btn-lg" onclick="javascript:location.href='${rootPath}/admin/boardWrite'">게시물작성</button>
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
	loadData(1, 10);
});

function loadData(cPage, viewCount){
	obj = {cPage : cPage, viewCount : viewCount}
	$.ajax({
		url : "${rootPath}/rest/board/list",
		data : obj,
		dataType: "json",
		success : function(data){
			var viewCount = data.viewCount;
			var cPage = data.cPage;
			var total = data.total;
			var pageBarSize = 5;
			var totalPage = Math.ceil(parseFloat(total)/viewCount);
			var pageNo = (Math.floor((cPage - 1)/parseFloat(pageBarSize))) * pageBarSize +1;
			var pageEnd = pageNo + pageBarSize - 1;
			var pageNation ="";
			$pagination = $(".pagination");
			if(pageNo == 1 ){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>';
			}else{
/* 				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+(pageNo-1)+','+pageBarSize+',\'all\')">Previous</a></li>'; */
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadData('+(pageNo-1)+','+pageBarSize+',\'all\')">Previous</a></li>';
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
	    	
	    	
	    	$pagination.html(pageNation);
			$(".table-responsive tbody").html(rmHtml);
			
			
			
		} // success
	});
}






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









