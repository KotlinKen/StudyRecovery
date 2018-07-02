<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="BOARD" name="pageTitle" /></jsp:include>

<div class="listup"></div>

<script>
$(function(){
	timer = setInterval(function(){
		loadRestMember();
	}, 1000);
	
});

function loadRestMember(){
	$.ajax({
		url:"${rootPath}/rest/AllSessions",
		dataType:"json",
		success:function(data){
			var html ="";
			for(index in data.list){
				var bil = data.list[index];
				html += bil.ip + " &nbsp;";
				if(bil.log == "login"){
					html += data.list[index].member.mid + " &nbsp;";
				}
				html += bil.time + " &nbsp;";
				html += bil.log + " &nbsp;";
				html +="<br>";
			}
			$(".listup").html(html);

		},error:function(){
			
		}
	});
}
 
</script>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />