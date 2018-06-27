<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% response.setContentType("text/html"); %>
<style>
	table, tr, th, td{
		border: 2px solid black;
	}
	button[name=evaluationView]{
		display: none;
	}
</style>
	
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="내 스터디 목록" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp" />
	<br />
	<input type="hidden" id="hiddenUserId" value="${memberLoggedIn.mid }" />
	<input type="hidden" id="hiddenMno" value="${memberLoggedIn.mno }" />
	<a href="${rootPath }/member/searchMyPageKwd.do?leader=y" ${leader eq 'y' ? "style='color:red'" :'' }>팀장</a>|
	<a href="${rootPath }/member/searchMyPageKwd.do?leader=n" ${leader eq 'n' ? "style='color:red'" :'' }>팀원</a>
	<br />
	<input type="radio" name="type" id="study" ${(type eq 'study') or (type == null)?'checked':'' }/>
	<label for="study">study</label>
	<input type="radio" name="type" id="lecture"  ${type eq 'lecture'?'checked':'' } />
	<label for="lecture">lecture</label>
	<br />
	<select id="searchKwd">
		<option value="title" ${searchKwd eq 'title'?'selected':'' }>강의/스터디명</option>
		<option value="captain" ${searchKwd eq 'captain'?'selected':'' }>팀장/강사명</option>
		<option value="subject" ${searchKwd eq 'subject'?'selected':'' }>과목</option>
		<option value="place" ${searchKwd eq 'place'?'selected':'' }>스터디 장소</option>
		<option value="diff" ${searchKwd eq 'diff'?'selected':'' }>난이도</option>
		<option value="term" ${searchKwd eq 'term'?'selected':'' }>스터디 시작일</option>
		<option value="freq" ${searchKwd eq 'freq'?'selected':'' }>주기</option>
	</select>
	<form action="searchMyPageKwd.do" 
		  method="post" id="formSearch" >
		<c:if test="${kwd != null and searchKwd != null and searchKwd != 'term' and searchKwd != 'freq' }">
			<input type='text' name='kwd' value="${kwd }" />
			<input type='hidden' name='searchKwd' value='${searchKwd }' />
		</c:if>
		<c:if test="${kwd == null }">
			<input type='text' name='kwd' placeholder='강의/스터디명'  />
			<input type='hidden' name='searchKwd' value='title' />
		</c:if>
		<c:if test="${kwd != null and searchKwd == 'term' }">
			<select name='kwd' id='dateKwdYear'>
				<c:forEach var='y' begin='2016' end='2022'>
				<option value="${y }" ${fn:contains(kwd, y)?'selected':'' }>${y }년</option>
				</c:forEach>
			</select>
			<select name='kwd' id='dateKwdMonth'>
				<option value="">월</option>
				<c:forEach var='m' begin='1' end='12' varStatus='cnt'>
				<option value="${m>10?'':'0' }${m}" ${cnt.index eq fn:split(kwd,',')[1] ?'selected':'' }>${m }월</option>
				</c:forEach>				
			</select>
			<input type='hidden' name='searchKwd' value='term' />
		</c:if>
		<%
			String[] arr = {"월","화","수","목","금","토","일"};
			request.setAttribute("arr", arr);
		%>
		<c:if test="${kwd != null and searchKwd == 'freq' }">
			<c:forEach var='f' items="${arr}" varStatus='vs'>
				<input type='checkbox' name='kwd' id='freqKwd${vs.index }' value='${f }' ${fn:contains(kwd,f) ?'checked':'' } />
				<label for='freqKwd${vs.index }'>${f }</label>
			</c:forEach>
			<input type='hidden' name='searchKwd' value='freq' />
			<input type='hidden' name='kwd' value='none' />
		</c:if>
		
		
		<input type="hidden" name="type" value="${type }" />
		<input type="hidden" name="myPage" value="${myPage}" />
		<input type="hidden" name="leader" value="${leader}" />
		<button type='submit' id='btn-search'>검색</button>
	</form>
	<c:if test="${leader eq 'n' }"> <!-- 나중에 처리해줘야함 -->
		<p>총 ${count }의 스터디 팀원 건이 있습니다.</p> <!--  스터디 가져올 경우 기간 마감된 것도 표시해줌. -->
	</c:if>
	<c:if test="${leader eq 'y'}">
		<p>총 ${leaderCount }의 스터디 팀장 건이 있습니다.</p> <!--  스터디 가져올 경우 기간 마감된 것도 표시해줌. -->
	</c:if>
	<table>
		<c:if test="${count != 0 or leaderCount != 0 }">
			<tr>
				<th>번호</th>
				<th>강의/스터디명</th>
				<th>팀장/강사명</th>
				<th>분류</th>
				<th>과목</th>
				<th>스터디 장소</th>
				<th>난이도</th>
				<th>수업일정(주기)</th>
				<th>스터디 기간 및 시간</th> <!-- 18/5/6 ~ 18/6/6(시간) -->
				<th>보기</th>
				<th>평가</th>
			</tr>
		</c:if>
		<c:if test="${count == 0 and leaderCount == 0 }">
			<p>검색 결과가 없습니다.</p>
		</c:if>
		<c:if test="${myPageList != null and leader eq 'n' }">
			<c:forEach var="ms" items="${myPageList}" varStatus="vs" >
				<tr>
					<td>${vs.index+1 }</td>
					<td>${ms.title }</td>
					<td>${ms.captain}</td>
					<td>${ms.type }</td>
					<td>${ms.subject }</td>
					<td>${ms.place}</td>
					<td>${ms.diff}</td>
					<td>${ms.freq}</td>
					<td>${ms.sdate} ~ ${ms.edate}(${ms.time })</td>
					<td>
						<button type=button id="btn-detail" value="${ms.sno }">자세히</button>
					</td>
					<td>
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<c:set var="sysdate"><fmt:formatDate value="${now}" pattern="yyyy/MM/dd" /></c:set> 
					<c:if test="${fn:contains(ms.status,'종료') }">
						<button type=button id="${ms.sno }" value="1" name="evaluation" class="btn btn-outline-success" data-toggle="modal" data-target="#reviewModal">평가</button>
						<button type=button id="evalView${ms.sno }" value="1" name="evaluationView" class="btn btn-outline-success" data-toggle="modal" data-target="#viewModal">평가 보기</button>
					</c:if>
					
					<c:if test="${fn:contains(ms.status,'진행') }">
						<button type=button class="btn btn-outline-success disabled">스터디 진행 중</button>
					</c:if>
					
					</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${leaderList != null and leader eq 'y'}">
			<c:forEach var="ms" items="${leaderList}" varStatus="vs" >
				<tr>
					<td>${vs.index+1 }</td>
					<td>${ms.title }</td>
					<td>${ms.captain}</td>
					<td>${ms.type }</td>
					<td>${ms.subject }</td>
					<td>${ms.place}</td>
					<td>${ms.diff}</td>
					<td>${ms.freq}</td>
					<td>${ms.sdate} ~ ${ms.edate}(${ms.time })</td>
					<td>
						<button type=button id="btn-detail" value="${ms.sno }">자세히</button>
					</td>
					<td>
					<c:if test="${fn:contains(ms.status,'종료') }">
						<button type=button id="${ms.sno }" value="1" name="evaluation" class="btn btn-outline-success" data-toggle="modal" data-target="#reviewModal">평가</button>
						<button type=button id="evalView${ms.sno }" value="1" name="evaluationView" class="btn btn-outline-success" data-toggle="modal" data-target="#viewModal">평가 보기</button>
					</c:if>
					
					<c:if test="${fn:contains(ms.status,'진행') }">
						<button type=button class="btn btn-outline-success disabled" >${ms.status }</button>
					</c:if>
					
					<c:if test="${fn:contains(ms.status,'모집 중') or fn:contains(ms.status,'마감 임박') or fn:contains(ms.status,'모집 마감') }">
						<button type=button id="applyList${ms.sno }" value="1" name="applyListView" class="btn btn-outline-success" data-toggle="modal" data-target="#viewModal" >신청 현황</button>
					</c:if>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		
	</table>
	<br />
	<!-- 페이지바 -->
	<%
		request.setCharacterEncoding("utf-8");
	 	response.setContentType("text/html;charset=UTF-8");
		int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("count")));
		int totalLeaderContents = Integer.parseInt(String.valueOf(request.getAttribute("leaderCount")));
		int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
		String searchKwd = String.valueOf(request.getAttribute("searchKwd"));
		String kwd = String.valueOf(request.getAttribute("kwd"));
		String type = String.valueOf(request.getAttribute("type"));
		String leader = String.valueOf(request.getAttribute("leader"));
		String myPage = String.valueOf(request.getAttribute("myPage"));
		int cPage = 1;
		try{
			cPage = Integer.parseInt(request.getParameter("cPage"));
		}catch(NumberFormatException e){
			
		}
	%>
	<c:if test="${leader=='y' }">
		<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalLeaderContents, cPage, numPerPage,"searchMyPageKwd.do?searchKwd="+searchKwd+"&kwd="+kwd+"&type="+type+"&leader="+leader, myPage) %>
	</c:if>
	<c:if test="${leader=='n' }">
		<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalContents, cPage, numPerPage,"searchMyPageKwd.do?searchKwd="+searchKwd+"&kwd="+kwd+"&type="+type+"&leader="+leader, myPage) %>
	</c:if>
	
	<!-- 스터디 리뷰 시작 -->
	<div class="modal fade" id="reviewModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
		<div class="modal-dialog modal-lg" role="document" >
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">스터디 리뷰</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					</div>
					<form action="${rootPath }/member/reviewEnroll.do" method="post" onsubmit="return giveReview();">
						<div class="modal-body" id="form-reviewEnroll">
							<!-- 
								간략한 스터디 정보(스터디 제목, 팀장이름), 작성자 아이디, 평가할 회원(select?), 좋아요/싫어요, 내용 
							 -->
						</div>
						<div class="modal-footer">
							<button type="submit" class="btn btn-outline-success">등록</button>
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						</div>
				</form>
			</div>
		</div>
	</div>
	<!-- 스터디 리뷰 끝 -->
	<!-- 스터디 리뷰 보기 시작 -->
	<div class="modal fade" id="viewModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
		<div class="modal-dialog modal-lg" role="document" >
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modalLabel">스터디 내 평가</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					</div>
						<div class="modal-body" id="div-reviewView">
							<!-- 
								간략한 스터디 정보(스터디 제목, 팀장이름), 작성자 아이디, 평가할 회원(select?), 좋아요/싫어요, 내용 
							 -->
						</div>
						<div class="modal-body" id="div-crew">
						</div>
			</div>
		</div>
	</div>
	<!-- 스터디 리뷰 보기 끝 -->
	<!-- 스터디 신청 현황 보기 시작 -->
	<!-- <div class="modal fade" id="applyViewModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
		<div class="modal-dialog modal-lg" role="document" >
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="applyModalLabel">스터디 신청 현황</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					</div>
						<div class="modal-body" id="div-applyView">
							
								간략한 스터디 정보(스터디 제목, 팀장이름), 작성자 아이디, 평가할 회원(select?), 좋아요/싫어요, 내용 
							
						</div>
						<div class="modal-footer">
							<button type="submit" class="btn btn-outline-success">등록</button>
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						</div>
			</div>
		</div>
	</div> -->
	<!-- 스터디 신청 현황 보기 끝 -->
	
	<script>
		$(function(){
			/* 키워드로 검색 하기 */
			$("select#searchKwd").on("change",function(){
				var html = "";
				$("form#formSearch").empty();
				if($(this).val()=='title'){ //스터디 명
					html="<input type='text' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
					html+="<input type='hidden' name='searchKwd' value='title' />";
					
					console.log('title');
				} 
				if($(this).val()=='captain'){ //팀장 명
					html="<input type='text' name='kwd' id='captainKwd' placeholder='강사/팀장명' />";
					html+="<input type='hidden' name='searchKwd' value='captain' />";
					
					console.log('captain');
				} 
				if($(this).val()=='subject'){ //과목명
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='과목명' />";
					html+="<input type='hidden' name='searchKwd' value='subject' />";
					
					console.log('subject');
				} 
				if($(this).val()=='place'){ //장소명
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='장소' />";
					html+="<input type='hidden' name='searchKwd' value='place' />";
					
					console.log('place');
				} 
				if($(this).val()=='diff'){ //난이도
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='난이도' />";
					html+="<input type='hidden' name='searchKwd' value='diff' />";
					
					console.log('diff');
				} 
				if($(this).val()=='term'){ //기간
					html="<select name='kwd' id='dateKwdYear'>";
					html+="<option value='2016'>2016년</option>";
					html+="<option value='2017'>2017년</option>";
					html+="<option value='2018'>2018년</option>";
					html+="<option value='2019'>2019년</option>";
					html+="<option value='2020'>2020년</option>";
					html+="<option value='2021'>2021년</option>";
					html+="<option value='2022'>2022년</option>";
					html+="</select>";
					html+="<select name='kwd' id='dateKwdMonth'>";
					html+="<option value=''>월</option>";
					html+="<option value='01'>1월</option>";
					html+="<option value='02'>2월</option>";
					html+="<option value='03'>3월</option>";
					html+="<option value='04'>4월</option>";
					html+="<option value='05'>5월</option>";
					html+="<option value='06'>6월</option>";
					html+="<option value='07'>7월</option>";
					html+="<option value='08'>8월</option>";
					html+="<option value='09'>9월</option>";
					html+="<option value='10'>10월</option>";
					html+="<option value='11'>11월</option>";
					html+="<option value='12'>12월</option>";
					html+="</select>";
					html+="<input type='hidden' name='searchKwd' value='term' />";
					console.log('term');
				} 
				if($(this).val()=='freq'){ //스터디 주기
					html = "<input type='checkbox' name='kwd' id='freqKwd1' value='월' />";
					html += "<label for='freqKwd1'>월</label>";
					html += "<input type='checkbox' name='kwd' id='freqKwd2' value='화' />";
					html += "<label for='freqKwd2'>화</label>";
					html += "<input type='checkbox' name='kwd' id='freqKwd3' value='수' />";
					html += "<label for='freqKwd3'>수</label>";
					html += "<input type='checkbox' name='kwd' id='freqKwd4' value='목' />";
					html += "<label for='freqKwd4'>목</label>";
					html += "<input type='checkbox' name='kwd' id='freqKwd5' value='금' />";
					html += "<label for='freqKwd5'>금</label>";
					html += "<input type='checkbox' name='kwd' id='freqKwd6' value='토' />";
					html += "<label for='freqKwd6'>토</label>";
					html += "<input type='checkbox' name='kwd' id='freqKwd7' value='일' />";
					html += "<label for='freqKwd7'>일</label>";
					html+="<input type='hidden' name='searchKwd' value='freq' />";
					html+="<input type='hidden' name='kwd' value='none' />";
					console.log('freq');
				}
				html+="<input type='hidden' name='type' value='${type}' />";
				html+="<input type='hidden' name='leader' value='${leader}' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				html+="<button type='submit' id='btn-search'>검색</button>";
				$("form#formSearch").html(html);
				
			});
			
			//스터디이지 강의인지 구분하기
			$("[type=radio]#study").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				html+="<input type='hidden' name='type' value='study' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				html+="<input type='hidden' name='leader' value='${leader}' />";
				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
			$("[type=radio]#lecture").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				html+="<input type='hidden' name='type' value='lecture' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				html+="<input type='hidden' name='leader' value='${leader}' />";
				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
			
			//스터디 자세히 보기
			$("#btn-detail").click(function(){
				console.log($(this).val());
				location.href="${rootPath}/study/studyView.do?sno="+$(this).val();
			});
			
			//평가 버튼 클릭시, 평가할 폼이 나옴.
			$("button[name=evaluation]").on("click",function(){
				var studyNo = this.id;
				var leader = '<%=leader%>';
				if(this.value=="1"){
					$.ajax({
						url: "reviewEnrollView.do",
						data: {studyNo: studyNo, leader: leader},
						dataType: "json",
						contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
						success: function(data){
							var html = "<table><tr><th>스터디명</th><th>팀장이름</th><th>작성자</th><th>평가할 팀원</th><th>평가</th><th>내용</th><th>보기</th></tr>";
							var userId = $("input#hiddenUserId").val();
							var mno = $("input#hiddenMno").val();
							for(var i in data.list){
								var index = data.list[i];
								console.log(data);
								if(userId!=index.tmid){ //자기 자신을 평가 할 수 없음
									html += "<tr>";
									html += "<td>"+index.title;
									html += "<input type='hidden' name='sno' value='"+studyNo+"'>"+"</td>"; //스터디 번호
									html += "<td>"+index.smid+"("+index.smname+")"+"</td>"; //팀장 id, name
									html += "<td>작성자";
									html += "<input type='hidden' name='mno' value='"+mno+"'>"+"</td>";//작성자 id
									html += "<td>"+index.tmid+"("+index.tmname+")"; //평가할 id, name
									html += "<input type='hidden' name='tmno' value='"+index.tmno+"'>"+"</td>";
									html += "<td>";
									html += "<button type='button' class='like' id='likeq"+index.tmno+"' value='1000'>좋아요</button>";
									html += "<button type='button' class='dislike' id='dislikeq"+index.tmno+"' value='-1000'>싫어요</button>";
									html += "<input type='hidden' name='point' id='pointq"+index.tmno+"' value='0'>";
									html += "</td>";
									html += "<td><input type='text' name='content' size='50' placeholder='평가 내용을 적어 주세요' required/></td>";
									html += "<td>보기 </td>";
									html += "</tr>";
								}  else if(userId!=index.tmid && <%="n"==leader%>){ //자기 자신이 아니면서 팀원인 경우
									html += "<tr>";
									html += "<td>"+index.title;
									html += "<input type='hidden' name='sno' value='"+studyNo+"'>"+"</td>"; //스터디 번호
									html += "<td>"+index.smid+"("+index.smname+")"+"</td>"; //팀장 id, name
									html += "<td>작성자";
									html += "<input type='hidden' name='mno' value='"+mno+"'>"+"</td>";//작성자 id
									html += "<td>"+index.tmid+"("+index.tmname+")"; //평가할 id, name
									html += "<input type='hidden' name='tmno' value='"+index.tmno+"'>"+"</td>";
									html += "<td>";
									html += "<button type='button' class='like' id='likeq"+index.tmno+"' value='1000'>좋아요</button>";
									html += "<button type='button' class='dislike' id='dislikeq"+index.tmno+"' value='-1000'>싫어요</button>";
									html += "<input type='hidden' name='point' id='pointq"+index.tmno+"' value='0'>";
									html += "</td>";
									html += "<td><input type='text' name='content' size='50' placeholder='평가 내용을 적어 주세요' required/></td>";
									html += "<td>보기</td>";
									html += "</tr>";
								}
							}
							html +="</table>";
							
							html += "<input type='hidden' name='searchKwd' value='<%=searchKwd%>' /> ";
							html += "<input type='hidden' name='kwd' value='<%=kwd%>' /> ";
							html += "<input type='hidden' name='type' value='<%=type%>' /> ";
							html += "<input type='hidden' name='leader' value='<%=leader%>' /> ";
							html += "<input type='hidden' name='cPage' value='<%=cPage%>' /> ";
							
							if(data.length<2){
								$("div#form-reviewEnroll").html("평가할 팀원이 없습니다.");																
							}
							
							$("div#form-reviewEnroll").html(html);								
							
							$(".like").on("click",function(){
								console.log($(this).val());
								var tmno = this.id.split("q")[1].toString();
								$("#dislikeq"+tmno).attr("style","color: black");
								$(this).attr("style","color: red");
								$("#pointq"+tmno).val($(this).val());
							});
							$(".dislike").on("click",function(){
								console.log($(this).val());
								var tmno = this.id.split("q")[1].toString();
								$("#likeq"+tmno).attr("style","color: black");
								$(this).attr("style","color: red");
								$("#pointq"+tmno).val($(this).val());
							});
						
							 
						},
						error: function(){
							console.log("ajax실패");
						}
						
					});
					
				}
			});
			
		});
	function giveReview(){
		var point = document.getElementsByName("point");
		var cnt = 0;
		console.log(point);
		for(var i=0; i<point.length; i++){
			if(point[i].value=='1000' || point[i].value=='-1000'){
				cnt++;
			}
		}
		if(cnt==point.length){
			return ture;
		}else{
			alert("모든 평가 버튼을 눌러주세요");
		}
		
		return false;
	}
	var array = new Array("");
	
	$(document).ready(function() { 
		var once = 0;
		if(once==0){
			var eval = document.getElementsByName("evaluation");
			var arr="";
			for(var i=0; i<eval.length; i++){
				arr += eval[i].id;
				if(i<eval.length-1){
					arr += ",";
					
				}
			}
			console.log(arr);
			$.ajax({
				url: "reviewFinish.do",
				data: {studyNo: arr},
				dataType: "json",
				success: function(data){
					console.log(data);
					var cnt=0;
					
					//로그인 한 회원은 평가를 했지만, 자신의 평가 값이 없을 경우, 평가 완료
					for(var index in data.studyNoList){
						$("#"+data.studyNoList[index]).attr("disabled","true");
						$("#"+data.studyNoList[index]).html("평가 완료");
						$("#"+data.studyNoList[index]).val("0");  //로그인 한 회원이 평가를 했는지 알려준다.
					}
					
					//로그인 한 회원이 평가를 하고, 자신의 평가 값이 있을 경우, 평가 보기
					for(var index in data.reviewList[0]){
						for(var i in data.reviewList[0][index]){
								//자신의 평가 값이 있고, 로그인 한 회원이 평가를 했다면 0, 안했다면 1
								if(i.length>0 && $("#"+index).val()=='0'){ 
									$("#"+index).remove();
									$(".btn.btn-outline-success.disabled").remove();
									$("#evalView"+index).attr("style","display: inline");
								}
							
							var map = {};
							map.point=data.reviewList[0][index][i].point.toString();
							map.content = data.reviewList[0][index][i].content;
							map.sno = index;
							array[cnt] = map;
							cnt++;
						}
					}
				},
				error: function(){
					console.log("ajax 처리 실패");
				}
				
			});
			once=1;
		}
		
	});
	
	$(function(){
		//평가 보기 버튼 클릭시, 해당 스터디의 스터디의 평가 리스트를 볼 수 있다.
		$("[name=evaluationView]").on("click",function(){
			for(var i=0; i<array.length; i++){
				if(this.id=="evalView"+array[i].sno){
					console.log(array[i]);
					var html ="<table>";
					html += "<tr>";
					html += "<td>";
					if(array[i].point == "1000"){
						html += "좋아요";
					}
					if(array[i].point=="-1000"){
						html += "싫어요";						
					}
					html += "</td>";
					html += "<td>";
					html += array[i].content;
					html += "</td>";
					html += "</tr>";									
					html += "</table>";
					$("#div-reviewView").html(html);
					$("h5#modalLabel").html("스터디 내 평가");
				}
			}
		});
		
		
		//신청 현황 보기 버튼
		$("button[name=applyListView]").on("click",function(){
			$("div.modal-body#div-crew").html("");
			console.log(this.id);
			var studyNo = this.id.split("t")[1];
			applyLog(studyNo);
						
		});
		
	});
	
	function applyLog(studyNo){
		$.ajax({
			url: "applyListView.do",
			data: {studyNo: studyNo},
			dataType: "json",
			success: function(data){
				console.log(data);
				var html ="<table>";
				html += "<tr>";
				html += "<td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>자기 소개</td><td>보기</td>";
				html += "</tr>";
				for(var i in data.applyList){
					console.log(data.applyList[i]);
					html += "<tr id='amno"+data.applyList[i].mno+"'>";
					html += "<td>";
					html += "<img src='${rootPath}/resources/upload/member/"+data.applyList[i].mprofile+"' alt='회원 "+data.applyList[i].mid+"의 프로필 사진' style='width:100px;'/>";
					html += "</td>";
					html += "<td>";
					html += data.applyList[i].grade;
					html += "</td>";
					html += "<td>";
					if(data.applyList[i].gender == 'M'){
						html += "남자";
					}else{
						html += "여자";
					}
					html += "</td>";
					html += "<td>";
					html += data.applyList[i].mname+"("+data.applyList[i].mid+")";
					html += "</td>";
					html += "<td>";
					html += data.applyList[i].cover;
					html += "</td>";
					html += "<td>";
					html += "<button type=button class='apply' name='agree' id='agreeq"+data.applyList[i].mno+"'>수락</button>";
					html += "</td>";
					html += "</tr>";	
					
					$("h5#modalLabel").html("스터디 신청 현황("+data.applyList[0].title+")");
				}
				html += "</table>";
				
				var removehtml = "<br />";
				removehtml += "<h5>스터디 신청을 수락 완료 회원</h5>";
				removehtml += "<hr>";
				removehtml += "<table>"; 
				removehtml += "<tr><td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>자기 소개</td><td>보기</td></tr>";
				for(var i in data.crewList){
					console.log(data.crewList[i]);
					removehtml += "<tr id='cmno"+data.crewList[i].mno+"'>";
					removehtml += "<td>";
					removehtml += "<img src='${rootPath}/resources/upload/member/"+data.crewList[i].mprofile+"' alt='회원 "+data.crewList[i].mid+"의 프로필 사진' style='width:100px;'/>";
					removehtml += "</td>";
					removehtml += "<td>";
					removehtml += data.crewList[i].grade;
					removehtml += "</td>";
					removehtml += "<td>";
					if(data.crewList[i].gender == 'M'){
						removehtml += "남자";
					}else{
						removehtml += "여자";
					}
					removehtml += "</td>";
					removehtml += "<td>";
					removehtml += data.crewList[i].mname+"("+data.crewList[i].mid+")";
					removehtml += "</td>";
					removehtml += "<td>";
					removehtml += data.crewList[i].cover;
					removehtml += "</td>";
					removehtml += "<td>";
					removehtml += "<button type=button class='cancel' name='' id='??"+data.crewList[i].mno+"'>팀원 취소</button>";
					removehtml += "</td>";
					removehtml += "</tr>";	
				}
				
				//스터디 신청 수락된 회원 => 수락 버튼을 누르면 밑으로 
				removehtml += "</table>";
				
				
				if(data.applyList.length==0){
					$("h5#modalLabel").html("스터디 신청 현황("+data.studyName+")");
					$("#div-reviewView").html("신청한 회원이 없습니다.");
					if(data.crewList.length!=0){
						$("#div-crew").html(removehtml);
					}else{
						$("#div-crew").html("팀원이 없습니다.");
					}
				} else{
					$("#div-reviewView").html(html);
					$("#div-crew").html(removehtml);
				}
				
				$("button[name=agree]").on("click",function(){
					$(this).attr("style","color: red;");
					$("#disagreeq"+this.id.split("q")[1]).attr("style","color: black;");
					console.log(this.id.split("q")[1]);
					var mno = this.id.split("q")[1];
					var sno = data.studyNo;
					$("#div-reviewView").html(html);
					$("tr#amno"+mno).remove();
					//var name = "들어 왔당!";
					//var name = data.studyName;
					// 신청 수락 클릭시, 신청이 수락된다.
					// 신청 수락을 하면  apply테이블에서 crew테이블에 들어가야한다. => 회원번호, 스터디 번호
					// 신청 현황에는 신청한 사람과 팀원으로 선택한 사람이 들어가 있어야한다.
					// 신청 기간 안에는 팀원을 다시 거절 할 수 있다?
					// 거절했던 회원을 다시 신청 목록에 넣을 수 있다?
					// 신청이 수락되면 이메일을 발송해준다?
					
					applyButton(sno, mno);
				});
				$("button[name=disagree]").on("click",function(){
					$(this).attr("style","color: red;");
					$("#agreeq"+this.id.split("q")[1]).attr("style","color: black;");
					console.log(this.id.split("q")[1]);
				});
				
				
			},
			error: function(){
				console.log("ajax 처리 실패");
			}
		});
	}
	
	function applyButton(sno, mno){
			$("div#div-reviewView").html("");
			$.ajax({
				url: "applyButton.do",
				data: {sno: sno, mno: mno},
				dataType: "json",
				success: function(data){
					var html = "";
					console.log(data);
					html += "<h5>스터디 신청을 수락 완료 회원</h5>";
					html += "<hr>";
					html += "<table>"; 
					html += "<tr><td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>자기 소개</td><td>보기</td></tr>";
					for(var i in data.crewList){
						console.log(data.crewList[i]);
						html += "<tr class='mno"+data.crewList[i].mno+"'>";
						html += "<td>";
						html += "<img src='${rootPath}/resources/upload/member/"+data.crewList[i].mprofile+"' alt='회원 "+data.crewList[i].mid+"의 프로필 사진' style='width:100px;'/>";
						html += "</td>";
						html += "<td>";
						html += data.crewList[i].grade;
						html += "</td>";
						html += "<td>";
						if(data.crewList[i].gender == 'M'){
							html += "남자";
						}else{
							html += "여자";
						}
						html += "</td>";
						html += "<td>";
						html += data.crewList[i].mname+"("+data.crewList[i].mid+")";
						html += "</td>";
						html += "<td>";
						html += data.crewList[i].cover;
						html += "</td>";
						html += "<td>";
						html += "<button type=button class='cancel' name='' id='cancel"+data.crewList[i].mno+"'>팀원 취소</button>";
						html += "</td>";
						html += "</tr>";	
					}
					
					//스터디 신청 수락된 회원 => 수락 버튼을 누르면 밑으로 
					html += "</table><br />";
					
					$("div.modal-body#div-crew").html(html);
					applyLog(sno);
					
				},
				error: function(){
					console.log("ajax 처리 실패");
				}
			});
			
	}
	
	</script>
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	

	
	





