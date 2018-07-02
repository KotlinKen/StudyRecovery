<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="MEMBER" name="pageTitle" /></jsp:include>
<div class="studyList">
<style>
.container{width: 60%;position: relative;left: 5%;}
</style>
<!-- 장익순 작업 머리 버튼 설정 시작  -->
 <jsp:include page="/WEB-INF/views/member/admin_member_button.jsp"/>
<!-- 장익순 버튼 설정 끝 -->
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />
<!-- 개인 정보  -->
	<div  class="container" >
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>아이디</th>
					<td>${m.mid }</td>
				</tr>
				<tr>
					<th>이름</th>
					<td>${m.mname }</td>
				</tr>
			</thead>
			<tbody> 
			</tbody>
		</table>
	</div>
<!-- 개인정보 끝 -->
<!-- 점수 그래프 시작 -->
<script src="${rootPath}/resources/code/highcharts.js"></script>
<script src="${rootPath}/resources/code/modules/exporting.js"></script>

<div id="container"  class="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

<script type="text/javascript">

	Highcharts.chart('container', {
	    chart: {
	        type: 'column'
	    },
	    title: {
	        text: '평가 점수/지식점수'
	    },
	    xAxis: {
	        categories: ['점수'] 
	    },
	    credits: {
	        enabled: false
	    },
	    series: [{
	        name: '평가점수',
	        data: [${m.point}]
	    }, {
	        name: '지식점수',
	        data: [${m.NPoint}]
	    }]
	});
</script>
<!-- 점수 그래프 끝 -->
<!-- 스터디 내역 시작 -->

<table class="container" >
	<thead>
		<th>
			스터디 번호			
		</th>
		<th>
			좋아요/싫어요		
		</th>
		<th>
			평가 내용
		</th>
		<th>
			과목
		</th>
		<th>
			타입
		</th>
	</thead>
	<tbody>
	<c:forEach var="v" items="${reviewList }">
		<tr>
			<td>
			${v.SNO }
			</td>
			<td>
			<c:if test="${v.POINT <0}">
			<span style="color: red;">싫어요</span> 
			</c:if>
			<c:if test="${v.POINT >0}">
			<span style="color: blue">좋아요</span>
			</c:if>
			</td>
			<td>
			${v.CONTENT }
			</td>
			<td>
			${v.SUBJECTNAME }
			</td>
			<td>
			${v.TYPE }
			</td>
		</tr>
	</c:forEach>
	</tbody>
</table>
<!-- 스터디 내역 끝 -->

