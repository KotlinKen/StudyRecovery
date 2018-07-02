<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="MEMBER" name="pageTitle" /></jsp:include>
<div class="studyList">
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
.container{width: 60%;position: relative;left: 5%;}
#myProgress {
  position: relative;
  width: 80%;
  height: 30px;
  background-color: #ddd;
}

#myBar {
  position: absolute;
  height: 100%;
  background-color: #0056E9;
}

#label {
  text-align: center;
  line-height: 30px;
  color: white;
  
}
ul#ul-page > li:nth-child(6){
	background: #ffffff;
}
table{text-align: center;}
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
					<th>회원 번호</th>
					<td>${m.mno }</td>
				</tr>
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

<!-- 경험치 시작 -->
<div id="div-eval"  class="container">
	<c:if test="${eval eq 'exp' }">
		<h5> ${m.mname }님의 등급은 <strong>${list.expname }급</strong> 입니다.</h5>
		 
		 <div id="myProgress">
		  <div id="myBar">
		    <div id="label">${list.exp }/${list.tblExp }</div>
		  </div>
		</div>
	</c:if>
</div>
<!-- 경험치 끝 -->
<br />
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
		<tr>
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
		</tr>
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

<table class="container" >
	<thead>
		<tr>
			<th>
				게시판 번호			
			</th>
			<th>
				댓글 내용		
			</th>
			<th>
				채택여부
			</th>
			<th>
				작성일
			</th>
		</tr>
	</thead>
	<tbody>
<c:forEach var="v" items="${replyList }">
	<tr>
		<td>
			${v.BNO }
		</td>
		<td>
			${v.RNO }
		</td>
		<td>
		<c:if test="${v.FORK == v.RNO}">
			O		
		</c:if>
		<c:if test="${v.FORK != v.RNO}">
			X		
		</c:if>
		</td>
		<td>
		${v.REGDATE }
		</td>
	</tr>
</c:forEach>
</tbody>
</table>


	
<c:if test="${instruct != null}">
<table class="container" >
	<thead>
		<tr>
			<th>
				강사 신청 번호	
			</th>
			<th>
				${instruct.INO }
			</th>
			</tr>
			<tr>
				<th>
					포트폴리오	
				</th>
				<th>
					${instruct.PORTPOLIO }
				</th>
			</tr>
			<tr>
				<th>
					자기소계서
				</th>
				<th>
					${instruct.SELFINTRODUCTION }
				</th>
			</tr>
			<tr>
				<th>
					승인여부
				</th>
				<th>
					${instruct.STATE }
				</th>
			</tr>
			<tr>
				<th>
					신청일
				</th>
				<th>
					${instruct.APPLICATIONDATE }
				</th>
			</tr>
			<tr>
				<th colspan="2">
				<c:if test="${instruct.STATE  eq 'O'}">
				???
				</c:if>
				<c:if test="${instruct.STATE  eq 'X'}">
				????
				</c:if>
					<button type="button" onclick="fn_submit();"  class="btn btn-info" > 승인</button>
				</th>
			</tr>
	</thead>
</table>
</c:if>
	

<script>
	function fn_submit() {
		location.href="${pageContext.request.contextPath}/member/applyInstructAgree.do?ino="+${instruct.INO }
	}
</script>
