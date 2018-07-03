<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="INSTRUCTOR" name="pageTitle" /></jsp:include>
<div class="studyList">
	<div class="table-responsive" id="table1">
	<h3>강사 신청 리스트</h3>
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>아이디</th>
					<th>이름</th>
					<th>연락처</th>
					<th>포인트</th>
					<th>지식포인트</th>
					<th>신청날짜</th>
					<th>승인날짜</th>
					<th>승인취소날짜</th>
					<th>승인 상태</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<br />
	<br />
	<div class="table-responsive" id="table2">
	<h3>강사 리스트</h3>
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>아이디</th>
					<th>이름</th>
					<th>연락처</th>
					<th>포인트</th>
					<th>지식포인트</th>
					<th>신청날짜</th>
					<th>승인날짜</th>
					<th>승인취소날짜</th>
					<th>승인 상태</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>


<script>
$(function(){
	loadInstructor( "instructor");
});

function loadInstructor(){
	$.ajax({
		url:"${rootPath}/member/member/loadInstructor.do",
		dataType:"json",
		success:function(data){
		
			console.log(data);
			var rmHtml1 = "";
			var rmHtml2 = "";
			var member = null;
	    	for(index in data.list){
	    		member = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    		if(member.STATE.trim() =='X'){
	    			rmHtml1 += "<tr>"
    				rmHtml1 += "<td>"+member.MNO+"</td>";
	    			rmHtml1 += "<td><a href=\"${rootPath }/member/memberSelectONEView.do?mid="+member.MID+"\">" +member.MID +"</a></td>";
	    			rmHtml1 += "<td>" +member.MNAME+"</td>";
	    			rmHtml1 += "<td>" +member.PHONE+"</td>";
	    			rmHtml1 += "<td>" +member.POINT+"</td>";
	    			rmHtml1 += "<td>" +member.NPOINT+"</td>";
	    			var d = new Date(member.APPLICATIONDATE)
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
	    			
	    		    rmHtml1 += "<td>" +formattedDate+"</td>";
	    		   
	    			if(member.OKDATE !=null){
		    			
		    			var d = new Date(member.OKDATE)
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
	    				rmHtml1 += "<td>" +formattedDate+"</td>";
	    			}else{
    					rmHtml1 += "<td>--</td>";
	    			}
	    			
	    			if(member.OUTDATE !=null){
		    			var d = new Date(member.OUTDATE)
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
	    				rmHtml1 += "<td>" +formattedDate+"</td>";
	    			}else{
    					rmHtml1 += "<td>--</td>";
	    			}
	    			rmHtml1 += "<td>" +member.STATE+"</td>";
	    			rmHtml1 += "</tr>";
	    			
	    		}else{
	    			rmHtml2 += "<tr>"
	    				rmHtml2 += "<td>"+member.MNO+"</td>";
		    			rmHtml2 += "<td><a href=\"${rootPath }/member/memberSelectONEView.do?mid="+member.MID+"\">" +member.MID +"</a></td>";
		    			rmHtml2 += "<td>" +member.MNAME+"</td>";
		    			rmHtml2 += "<td>" +member.PHONE+"</td>";
		    			rmHtml2 += "<td>" +member.POINT+"</td>";
		    			rmHtml2 += "<td>" +member.NPOINT+"</td>";
		    			var d = new Date(member.APPLICATIONDATE)
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
		    			
		    		    rmHtml2 += "<td>" +formattedDate+"</td>";
		    		   
		    			if(member.OKDATE !=null){
			    			
			    			var d = new Date(member.OKDATE)
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
		    				rmHtml2 += "<td>" +formattedDate+"</td>";
		    			}else{
	    					rmHtml2 += "<td>--</td>";
		    			}
		    			
		    			if(member.OUTDATE !=null){
			    			var d = new Date(member.OUTDATE)
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
		    				rmHtml2 += "<td>" +formattedDate+"</td>";
		    			}else{
	    					rmHtml2 += "<td>--</td>";
		    			}
		    			rmHtml2 += "<td>" +member.STATE+"</td>";
		    			rmHtml2 += "</tr></a>";
		    			
	    		}
	    	}
			$("#table1 tbody").html(rmHtml1);
			$("#table2 tbody").html(rmHtml2);

		},error:function(){
			
		}
	});
}

</script>

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />

