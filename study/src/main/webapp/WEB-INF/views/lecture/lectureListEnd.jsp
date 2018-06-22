<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
	$(document).ready(function(){
		$(".lectureDiv").click(function(){
			var sno = $(this).children("#sno").val();
			location.href="${pageContext.request.contextPath}/lecture/lectureView.do?sno=" + sno;
		});
	});	
	
	$(document).ready(function(){
		$("#town").hide();
		$("#sub").hide();
		
		// TOWN선택
		$("#local").on("change", function(){
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
		
		// 페이징 처리
		$(".movePageBtn").click(function(){
			var cPage = $(this).val();
			
			location.href="${pageContext.request.contextPath}/lecture/lectureList.do?cPage=" + cPage;
		});
	});
</script>
<style>
	#lectureList-container{
		height: 1100px;
	}
	#beforeBtn{
		position: absolute;
		width: 80px;
		height: 80px;
		top: 735px;
		left: 427px;		
	}
	#afterBtn{
		position: absolute;
		width: 80px;
		height: 80px;
		top: 735px;
		right: 427px;
	}
</style>
	<button type="button" onclick="location.href='${pageContext.request.contextPath}/lecture/insertLecture.do'">강의	작성</button>
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
		
		<select name="tno" id="town">
		
		</select> 
		
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
		
		<!-- ajax로 kind가져오기 -->
		<select name="subno" id="sub"> 
		
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
			<c:if test="${!empty lectureList }">
				<c:forEach var="lecture" items="${lectureList }">
					<div class="lectureDiv" style="border: 1px solid gray; text-align: center;">
						<span>제목 : ${lecture.TITLE }</span>
						<br />
						<span>지역 : ${lecture.LOCAL} ${lecture.TNAME}</span>
						<br />
						<span>과목 : ${lecture.KNAME} - ${lecture.SUBNAME}</span>
						<br />
						<span>난이도 : ${lecture.DNAME }</span>
						<br />
						<span>비용 : ${lecture.PRICE}원</span>
						<br />
						<span>${lecture.STATUS }</span>
						<br />
						<span>
							일정 :
							<fmt:parseDate value="${lecture.SDATE}" type="date" var="sdate" pattern="yyyy-MM-dd" />
							<fmt:formatDate value="${sdate }" pattern="yyyy/MM/dd"/> 
							~ 
							<fmt:parseDate value="${lecture.EDATE}" type="date" var="edate" pattern="yyyy-MM-dd" />
							<fmt:formatDate value="${edate }" pattern="yyyy/MM/dd"/>
							&nbsp;&nbsp;&nbsp;
							시간 : ${lecture.TIME }							
						</span>
						<br />
						<span>
							등록일 : <fmt:parseDate value="${lecture.REGDATE }" type="date" var="regDate" pattern="yyyy-MM-dd" />
							<fmt:formatDate value="${regDate }" pattern="yyyy/MM/dd"/>	
						</span>
						<input type="hidden" id="sno" value="${lecture.SNO }"/>
					</div>
				</c:forEach>	
			</c:if>	
		</div>
	</div>
	<input type="hidden" name="cPage" id="cPage" value="${cPage }"/>
	
	<c:if test="${cPage != 1 }">
		<button type="button" class="movePageBtn" id="beforeBtn" name="beforeBtn" value="${cPage-1}">&lt;</button>
	</c:if>
	<c:if test="${cPage <= totalPage}">
		<button type="button" class="movePageBtn" id="afterBtn" name="afterPage" value="${cPage+1}">&gt;</button>	
	</c:if>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>