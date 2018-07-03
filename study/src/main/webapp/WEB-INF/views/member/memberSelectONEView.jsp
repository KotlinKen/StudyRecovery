
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param
		value="MEMBER" name="pageTitle" /></jsp:include>
<div class="studyList">
	<%@ page import="java.util.*, java.math.*"%>
	<link type="text/css" rel="stylesheet"
		href="${rootPath}/resources/css/member/member.css" />
	<style>
.container {
	width: 60%;
	position: relative;
	left: 5%;
}

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

ul#ul-page>li:nth-child(6) {
	background: #ffffff;
}

table {
	text-align: center;
}

.pmDiv {
	text-align: center;
	display: none;
	width: 100%
}

.pmDiv button {
	width: 49.6%;
	display: inline-block;
}
</style>
	<!-- 장익순 작업 머리 버튼 설정 시작  -->
	<jsp:include page="/WEB-INF/views/member/admin_member_button.jsp" />
	<!-- 장익순 버튼 설정 끝 -->
	<jsp:include page="/WEB-INF/views/common/admin_footer.jsp" />
	<!-- 개인 정보  -->
	<div class="container">
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
	<div id="div-eval" class="container">
		<c:if test="${eval eq 'exp' }">
			<h5>
				<strong>${list.expname }</strong> 입니다.
			</h5>
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

	<div id="container" class="container"
		style="min-width: 310px; height: 400px; margin: 0 auto">
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
	</div>

	<!-- 점수 그래프 끝 -->

	<div class="container">
		<button type="button" class="btn btn-outline-primary btn-block"
			onclick="fn_show_pmDiv(0);">평가점수 변경</button>
		<div class="pmDiv">
			<button class="btn btn-outline-primary"
				onclick="fn_point(0,'${m.mno }');">평가 점수 더하기</button>
			<button class="btn btn-outline-primary"
				onclick="fn_point(1,'${m.mno }');">평가 점수 빼기</button>
		</div>
		<button type="button" class="btn btn-outline-primary btn-block"
			onclick="fn_show_pmDiv(1);">지식점수 변경</button>
		<div class="pmDiv">
			<button class="btn btn-outline-primary"
				onclick="fn_point(2,'${m.mno }');">지식 점수 더하기</button>
			<button class="btn btn-outline-primary"
				onclick="fn_point(3,'${m.mno }');">지식 점수 빼기</button>
		</div>
	</div>

	<!-- 스터디 내역 시작 -->

	<table class="container">
		<thead>
			<tr>
				<th>스터디 번호</th>
				<th>좋아요/싫어요</th>
				<th>평가 내용</th>
				<th>과목</th>
				<th>타입</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="v" items="${reviewList }">
				<tr>
					<td>${v.SNO }</td>
					<td><c:if test="${v.POINT <0}">
							<span style="color: red;">싫어요</span>
						</c:if> <c:if test="${v.POINT >0}">
							<span style="color: blue">좋아요</span>
						</c:if></td>
					<td>${v.CONTENT }</td>
					<td>${v.SUBJECTNAME }</td>
					<td>${v.TYPE }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<!-- 스터디 내역 끝 -->

	<table class="container">
		<thead>
			<tr>
				<th>게시판 번호</th>
				<th>댓글 내용</th>
				<th>채택여부</th>
				<th>작성일</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="v" items="${replyList }">
				<tr>
					<td>${v.BNO }</td>
					<td>${v.RNO }</td>
					<td><c:if test="${v.FORK == v.RNO}">
			O		
		</c:if> <c:if test="${v.FORK != v.RNO}">
			X		
		</c:if></td>
					<td>${v.REGDATE }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>



	<c:if test="${instruct != null}">
		<table class="container">
			<thead>
				<tr>
					<th>강사 신청 번호</th>
					<th>${instruct.INO }</th>
				</tr>
				<tr>
					<th>포트폴리오</th>
					<th>

						<button type="button" class="btn btn-outline-primary btn-block"
							onclick="fileDownload('${instruct.PORTPOLIO }');">${instruct.PORTPOLIO }
						</button>
					</th>
				</tr>
				<tr>
					<th>자기소계서</th>
					<th>

						<button type="button" class="btn btn-outline-primary btn-block"
							onclick="fileDownload('${instruct.SELFINTRODUCTION }');">${instruct.SELFINTRODUCTION }
						</button>
					</th>
				</tr>
				<tr>
					<th>승인여부</th>
					<th>${instruct.STATE }</th>
				</tr>
				<tr>
					<th>신청일</th>
					<th>${instruct.APPLICATIONDATE }</th>
				</tr>
				<tr>
					<th>승인 취소일</th>
					<th>${instruct.OUTDATE }</th>
				</tr>
				<tr>
					<th colspan="2"><c:choose>
							<c:when test="${instruct.STATE eq 'X  '}">
								<button type="button" onclick="fn_submit(01);"
									class="btn btn-outline-primary">승인</button>
							</c:when>
							<c:otherwise>
								<button type="button" onclick="fn_submit(02);"
									class="btn btn-outline-primary">승인취소</button>
							</c:otherwise>

						</c:choose></th>
				</tr>
			</thead>
		</table>
		<script>
	function fn_submit(e) {
		if(e==01){
			location.href="${pageContext.request.contextPath}/member/applyInstructAgree.do?ino="+${instruct.INO };
		}
		else{
			location.href="${pageContext.request.contextPath}/member/applyInstructCancel.do?ino="+${instruct.INO };
		}
		
	}
	function fileDownload(oName) {
		oName=encodeURIComponent(oName);
		console.log(oName);
		location.href="${pageContext.request.contextPath}/member/boardDownload.do?oName="+oName;
		
		
	}
	
</script>

	</c:if>
	<div class="container">
		<button type="button" onclick="fn_goback();"
			class="btn btn-outline-primary">돌아가기</button>
	</div>
	<br /> <br /> <br /> <br /> <br /> <br />
	<%
		Map<String, Object> map = (Map<String, Object>) request.getAttribute("list");
		double a = 0;
		if (map.containsKey("tblExp")) {
			int tblExp = ((BigDecimal) map.get("tblExp")).intValue();
			int exp = ((BigDecimal) map.get("exp")).intValue();
			a = ((double) exp / tblExp) * 100;
		}
	%>
	<script>
	$(document).ready(function() { 
		$("#myBar").attr("style", "width:"+<%=a%>+"%");
	});
	$(function(){
		$("input[name=eval]").on("click", function(){
			$("#form-eval").submit();
		});
	});
</script>

	<script>
	function fn_goback() {
		history.back();
	}
	function fn_show_pmDiv(e) {
		console.log(e);
		console.log($(".pmDiv:eq("+e+")"))
		if($(".pmDiv:eq("+e+")").css("display") == "none"){
		$(".pmDiv:eq("+e+")").slideDown(1000);
		}else{
			$(".pmDiv:eq("+e+")").hide("slow");
		}
	}
	
	function fn_point(e,mno) {
		console.log(e);
		console.log(mno);
		var url = "";
		if(e == 0){
			url="changPOINTPLUS.do";
		} 
		if(e == 1){
			url="changPOINTMINUS.do";
		}
		if(e == 2){
			url="changNPOINTPLUS.do";
		}
		if(e == 3){
			url="changNPOINTMINUS.do";
		}
		console.log(url)
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:url,
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				console.log(date.list[0]);
				location.reload();
			},
			error : function(jqxhr, textStatus, errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	}
</script>