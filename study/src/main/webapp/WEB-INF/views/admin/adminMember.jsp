<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="MEMBER" name="pageTitle" /></jsp:include>
<div class="studyList">
<!-- 장익순 작업 머리 버튼 설정 시작  -->
 <jsp:include page="/WEB-INF/views/member/admin_member_button.jsp"/>
<!-- 장익순 버튼 설정 끝 -->
	<div class="table-responsive">
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>아이디</th>
					<th>이름</th>
					<th>연락처</th>
					<th>성별</th>
					<th>포인트</th>
					<th>지식포인트</th>
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

<%
	String rootPath = request.getContextPath();
%>
<script>
$(function(){
	loadInstructor(1, 5, "member");
});

function loadInstructor(cPage, pageBarSize, type){
	$.ajax({
		url:"${rootPath}/rest/member/"+type+"/"+cPage+"/"+pageBarSize,
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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+(pageNo-1)+','+5+',\'member\')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadInstructor('+pageNo+','+5+',\'member\')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+pageNo+','+5+',\'member\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var member = null;
	    	for(index in data.list){
	    		member = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr class='linkmno' id='"+member.MNO+"'>"
	    				rmHtml += "<td>"+ member.MNO+"</td>";
		    			rmHtml += "<td>" +member.MID +"</td>";
		    			rmHtml += "<td>" +member.MNAME+"</td>";
		    			rmHtml += "<td>" +member.PHONE+"</td>";
		    			rmHtml += "<td>" +member.GENDER+"</td>";
		    			rmHtml += "<td>" +member.POINT+"</td>";
		    			rmHtml += "<td>" +member.NPOINT+"</td>";
		    			rmHtml += "<td>" +member.REGDATES+"</td>";
	    			rmHtml += "</tr>";
	    	}
	    	
			$(".table-responsive tbody").html(rmHtml);
			
			$(".linkmno").on("click",function(){
				location.href = "<%=rootPath%>/member/adminMemberView.do?mno="+this.id;
			});

		},error:function(){
			
		}
	});
}

</script>

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />

