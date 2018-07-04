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
					<th>이메일</th>
					<th>관심사</th>
					<th>가입일</th>
					<th>탈퇴일</th>
					<th>수정/강퇴</th>
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
	    			rmHtml += "<tr>"
	    				rmHtml += "<td>" +member.MNO+"</td>"; /* 번호  */
		    			rmHtml += "<td>" +member.MID +"</td>";/* 아이디  */
		    			rmHtml += "<td>" +member.MNAME+"</td>";/* 이름  */
		    			rmHtml += "<td>" +member.PHONE+"</td>";/* 연락처  */
		    			rmHtml += "<td>" +member.GENDER+"</td>";/* 성별  */
		    			rmHtml += "<td>" +member.EMAIL+"</td>";/* 이메일  */
		    			rmHtml += "<td>" +member.FAVOR+"</td>";/* 관심사  */
		    			/* rmHtml += "<td>" +member.REGDATE+"</td>";/* 가입일  */ 
		    			var d = new Date(member.REGDATE)
		    			m = d.getMonth() + 1;
		    		    if (m < 10)
		    		        m = '0' + m
		    		    if (d.getDate() < 10)
		    		        day = '0' + d.getDate()
		    		    else
		    		        day = d.getDate();
		    		    var formattedDate = m + "/" + day + "/" + d.getFullYear();
		    		    var hours = (d.getHours() < 10) ? "0" + d.getHours() : d.getHours();
		    		    var minutes = (d.getMinutes() < 10) ? "0" + d.getMinutes() : d.getMinutes();
		    		    formattedDate = formattedDate;
		    			
		    		    rmHtml += "<td>" +formattedDate+"</td>";
		    		   
		    			
		    		    /* rmHtml += "<td>" +member.QDATE+"</td>"; 탈퇴일 */
						if(member.QDATE !=null){
			    			var d = new Date(member.QDATE)
			    			m = d.getMonth() + 1;
			    		    if (m < 10)
			    		        m = '0' + m
			    		    if (d.getDate() < 10)
			    		        day = '0' + d.getDate()
			    		    else
			    		        day = d.getDate();
			    		    var formattedDate = m + "/" + day + "/" + d.getFullYear();
			    		    var hours = (d.getHours() < 10) ? "0" + d.getHours() : d.getHours();
			    		    var minutes = (d.getMinutes() < 10) ? "0" + d.getMinutes() : d.getMinutes();
			    		    formattedDate = formattedDate;
		    				rmHtml += "<td>" +formattedDate+"</td>";
		    			}else{
		    				console.log("?");
	    					rmHtml += "<td>--</td>";
		    			}
		    			
		    			rmHtml += "<td><button type=\"button\" class=\"btn btn-outline-primary btn-block\"onclick=\"fn_Modify('"+member.MID+"');\">수정/강퇴</button>";/* 수정/강퇴버튼 */
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
	
}

</script>
<<script type="text/javascript">
function fn_Modify(e) {
	location.href ="${rootPath }/member/memberSelectONEView.do?mid="+e+"&&size="+10;
}
</script>

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />

