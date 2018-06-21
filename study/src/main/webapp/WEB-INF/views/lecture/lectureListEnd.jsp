<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
	$(document).ready(function(){
		$(".lectureTr").click(function(){
			var sno = $(this).attr("sno");			
			location.href="${pageContext.request.contextPath}/lecture/lectureView.do?sno=" + sno;
		});
	});	
	
	$(document).ready(function(){
		$("#town").hide();
		$("#sub").hide();
		
		// TOWN선택
		$("#local").on("change", 	function(){
			var localNo = $("option:selected", this).val();
			
			if(localNo == ""){
				$("#town").hide();
				return;
			}
			$("#town").show();
			$.ajax({
				url: "selectTown.do",
				data: {localNo : localNo},
				dataType: "json",
				success : function(data){
					var html="<option>세부 지역을 선택하세요</option>";
					
					for(var index in data){
						html += "<option value='"+data[index].TNO +"'>" + data[index].TOWNNAME + "</option></br>";
					}				
					$("#town").html(html);
				}			
			});
		});
		
		// 세부 과목 선택
		$("#kind").on("change", function(){
			var kindNo = $("option:selected", this).val();
			
			if(kindNo == ""){
				$("#sub").hide();
				return;
			}
			$("#sub").show();
			$.ajax({
				url: "selectSubject.do",
				data: {kindNo : kindNo},
				dataType: "json",
				success : function(data){
					var html="<option>세부 과목을 선택하세요</option>";
					
					for(var index in data){
						html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option></br>";
					}
					
					$("#sub").html(html);
				}			
			});
		});		
	});
</script>
<body>
	<button type="button" onclick="location.href='${pageContext.request.contextPath}/lecture/insertLecture.do'">강의
	작성</button>
	<div id="lectureList-container">	
		<!-- 지역 -->
		<label for="local">지역 : </label>
		<select name="local" id="local">
			<option value="" selected>지역</option>
			<c:if test="${!empty locList}">
				<c:forEach var="loc" items="${locList }" varStatus="vs">
					<option value="${loc.LNO }">${loc.LOCAL }</option>
				</c:forEach>		
			</c:if>
		</select>
		&nbsp; 
		
		<select name="tno" id="town"></select> 
		
		<!-- 카테고리 -->
		<label for="kind">카테고리</label>
		<select name="kind" id="kind"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
			<option value="">과목을 선택하세요.</option>
			
			<c:if test="${!empty kindList }">
			<c:forEach var="kind" items="${kindList }" varStatus="vs">
				<option value="${kind.KNO }">${kind.KINDNAME }</option>
			</c:forEach>
			</c:if>
		</select>
		<select name="subno" id="sub"> <!-- ajax로 kind가져오기 -->
		
		</select>
		<!-- 카테고리 end -->
		&nbsp; 		
		
		<label for="diff">난이도 : </label>
		<select name="dno" id="diff">
			<option value="">난이도를 선택하세요</option>
			
			<c:if test="${!empty diffList }">
			<c:forEach var="diff" items="${diffList }" varStatus="vs">
				<option value="${diff.DNO }">${diff.DIFFICULTNAME }</option>
			</c:forEach>
			</c:if>
		</select>
		
		<input type="text" name="leadername" id="leadername" placeholder="팀장명을 적어주세요" /> 
		<input type="submit" value="필터 검색" />

	
		<button type="button" id="sort-deadline">마감임박순</button>
		<button type="button" id="sort-deadline">인기스터디순</button>
	
		<hr />
		
		<div id="lecture-container">
	
		</div>
	</div>

	<input type="hidden" name="case" value="0" />
	<!-- 조건없이 리스트를 가져오나, 조건있이 리스트를 가져오나 여부. 임시방편. -->
	<input type="hidden" name="cPageNo" value="2" />
	<!-- cPage 번호 저장. -->
	
	<c:if test="${!empty lectureList }">
		<table>
			<tr>
				<th></th>
				<th>지역</th>
				<th>분야</th>
				<th>과목</th>
				<th>난이도</th>
				<th>비용</th>
				<th>상태</th>
				<th>모집일</th>
				<th>운영일</th>
				<th>운영시간</th>
				<th>작성자</th>
				<th>등록일</th>
			</tr>
			
			<c:forEach var="lecture" items="${lectureList}" varStatus="vs">
				<tr class="lectureTr" sno="${lecture.SNO}">
					<td>${vs.index+1}</td>
					<td>${lecture.LOCAL} ${lecture.TNAME}</td>
					<td>${lecture.SUBNAME}</td>
					<td>${lecture.KNAME}</td>
					<td>${lecture.DNAME }</td>
					<td>${lecture.PRICE}원</td>
					<td>${lecture.STATUS }</td>
					<td>
						<fmt:parseDate value="${lecture.LDATE }" type="date" var="ldate" pattern="yyyy-MM-dd" />
						<fmt:formatDate value="${ldate }" pattern="yyyy/MM/dd"/>
					</td>
					<td>
						<fmt:parseDate value="${lecture.SDATE}" type="date" var="sdate" pattern="yyyy-MM-dd" />
						<fmt:formatDate value="${sdate }" pattern="yyyy/MM/dd"/> 
						~ 
						<fmt:parseDate value="${lecture.EDATE}" type="date" var="edate" pattern="yyyy-MM-dd" />
						<fmt:formatDate value="${edate }" pattern="yyyy/MM/dd"/>
					</td>
					<td>${lecture.TIME }</td>
					<td>${lecture.MNAME }</td>
					<td>
						<fmt:parseDate value="${lecture.REGDATE }" type="date" var="regDate" pattern="yyyy-MM-dd" />
						<fmt:formatDate value="${regDate }" pattern="yyyy/MM/dd"/>						
					</td>
				</tr>	
			</c:forEach>
		</table>
	</c:if>
</body>
</html>