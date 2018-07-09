<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% response.setContentType("text/html"); %>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
	ul#ul-page > li:nth-child(2){
		background: #ffffff;
	}
	td{
		max-width: 200;
		word-break:break-all;
		text-overflow:ellipsis; 
		overflow:hidden;
		white-space:nowrap;
		padding:15px 5px;
		border-bottom:1px solid #efefef;
	}
	select#town{
		display:none;
	}
	select#subject{
		display:none;
	}
	div.background{
		background: #ffffff;
	}
	button.cancel, .apply, .like, .dislike{
		width: auto;
		height: auto;
		font-size: 15px;
		border-radius: 10px;
		padding-left: 5px;
		padding-right: 5px;
		padding-top: 5px;
		padding-bottom: 5px;
		background: #ffffff;
		border-style: solid ;
		color: #666;
	}
	.leader{
		padding: 15px;
		border-radius: 0.1rem;
	}
	.leader:hover{
		padding: 15px;
		border-radius: 0.1rem;
		background: #0056e9;
		color:#fff;		
	}
	button.apply:hover, .cancel:hover{
		background: #0056e9;
		color: #ffffff;
	}
</style>

<div class="background">
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="내 스터디 목록" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp" />
	<br />
<div class="container page">
	<h3>내 스터디/강의</h3>
	<br />
	<input type="hidden" id="hiddenUserId" value="${memberLoggedIn.mid }" />
	<input type="hidden" id="hiddenMno" value="${memberLoggedIn.mno }" />
	
	<!-- 팀장/팀원 구분 -->
	<a class="leader" href="${rootPath }/member/searchMyPageKwd.do?leader=y&type=${type}" ${leader eq 'y' ? "style='background:#007bff; color: white;'" :'' }>팀장</a>
	<a class="leader" href="${rootPath }/member/searchMyPageKwd.do?leader=n&type=${type}" ${leader eq 'n' ? "style='background:#007bff; color: white;'" :'' }>팀원</a>
	<br />
	<br />
	
	<!-- 스터디/강의 구분 -->
	<input type="radio" name="type" id="study" ${(type eq 'study') or (type == null)?'checked':'' }/>
	<label for="study">study</label>
	<input type="radio" name="type" id="lecture"  ${type eq 'lecture'?'checked':'' } />
	<label for="lecture">lecture</label>
	<br />

	<!-- 검색 필터 지역, 카테고리, 난이도 디비에서 값 뽑기 -->
	<label for="local">지역:</label>
	<select name="lno" id="local" >
	<option value="0">전체</option>
	<c:forEach var="local" items="${localList }">
		<option value="${local.LNO }" ${lno eq local.LNO?'selected':'' }>${local.LOCAL }</option>
	</c:forEach>
	</select>&nbsp;
	<select name="tno" id="town">
	</select>
	<label for="subject">카테고리 :</label>
	<select name="kno" id="kind">
	<option value="0">전체</option>
	<c:forEach var="k" items="${kindList }">
		<option value="${k.KNO }" ${kno eq k.KNO?'selected':'' }>${k.KINDNAME }</option>
	</c:forEach>
	</select>&nbsp;
	<select name="subno" id="subject">
	</select>
	<label for="diff">난이도 : </label>
	<select name="dno" id="diff">
	<option value="0">전체</option>
	<c:forEach var="diff" items="${diffList }">
		<option value="${diff.DNO }" ${dno eq diff.DNO?'selected':'' }>${diff.DIFFICULTNAME }</option>
	</c:forEach>
	</select>
	<br />
	
	<!-- 검색 키워드 -->
	<select id="searchKwd">
		<option value="title" ${searchKwd eq 'title'?'selected':'' }>강의/스터디명</option>
		<option value="captain" ${searchKwd eq 'captain'?'selected':'' }>팀장/강사명</option>
		<%-- 
		<option value="subject" ${searchKwd eq 'subject'?'selected':'' }>과목</option>
		<option value="place" ${searchKwd eq 'place'?'selected':'' }>스터디 장소</option>
		<option value="diff" ${searchKwd eq 'diff'?'selected':'' }>난이도</option>
		 --%>
		<option value="term" ${searchKwd eq 'term'?'selected':'' }>스터디 시작일</option>
		<option value="freq" ${searchKwd eq 'freq'?'selected':'' }>주기</option>
	</select>
	
	<!-- 검색할 폼 제출 -->
	<form action="searchMyPageKwd.do" id="formSearch" autocomplete="off" style="display: inline">
		<!-- 초기 설정 -->
		<c:if test="${kwd == null }">
			<input type='text' name='kwd' placeholder='강의/스터디명'  />
			<input type='hidden' name='searchKwd' value='title' />
		</c:if>
		
		<!-- input:text가 아닌 검색 항목 처리 -->
		<c:if test="${kwd != null and searchKwd != null and searchKwd != 'term' and searchKwd != 'freq' }">
			<input type='text' name='kwd' value="${kwd }" />
			<input type='hidden' name='searchKwd' value='${searchKwd }' />
		</c:if>
		
		<!-- 기간 처리 -->
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
		<!-- 주기 처리 -->
		<c:if test="${kwd != null and searchKwd == 'freq' }">
			<c:forEach var='f' items="${arr}" varStatus='vs'>
				<input type='checkbox' name='kwd' id='freqKwd${vs.index }' value='${f }' ${fn:contains(kwd,f) ?'checked':'' } />
				<label for='freqKwd${vs.index }'>${f }</label>
			</c:forEach>
			<input type='hidden' name='searchKwd' value='freq' />
			<input type='hidden' name='kwd' value='none' />
		</c:if>
		
		<input type="hidden" name="myPage" value="${myPage}" />
		<input type="hidden" name="leader" value="${leader}" />
		<input type="hidden" name="type" value="${type }" />
		<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>
	</form>
	<!-- 팀장/팀원 스터디의 건수 표시 -->
	<c:if test="${leader eq 'n' }"> 
		<p>총 ${count }의 스터디 팀원 건이 있습니다.</p> 
	</c:if>
	<c:if test="${leader eq 'y'}">
		<p>총 ${leaderCount }의 스터디 팀장 건이 있습니다.</p> 
	</c:if>
	
	
	<!-- 스터디/강의 목록 -->
	<table>
		<!-- 팀장/팀원으로서의 스터디 목록이 존재하면 컬럼명을 쓴다. -->
		<c:if test="${count != 0 or leaderCount != 0 }">
			<tr>
				<th class="text-center">번호</th>
				<th class="text-center">강의/스터디명</th>
				<th class="text-center">팀장/강사명</th>
				<th class="text-center">과목</th>
				<th class="text-center">장소</th>
				<th class="text-center">난이도</th>
				<th class="text-center">수업 주기</th>
				<th class="text-center">마감일</th>
				<th class="text-center">기간 및 시간</th> <!-- 18/5/6 ~ 18/6/6(시간) -->
				<th class="text-center">보기</th>
				<th class="text-center">평가</th>
			</tr>
		</c:if>
		<!--  -->
		<c:if test="${(count == 0 and leader eq 'n') or (leaderCount == 0 and leader eq 'y')}">
			<p>검색 결과가 없습니다.</p>
		</c:if>
		
		<!-- 팀원일 때, 스터디 목록 -->
		<c:if test="${myPageList != null and leader eq 'n' }">
			<c:forEach var="ms" items="${myPageList}" varStatus="vs" >
				<tr>
					<td>${(numPerPage*cPage)-(numPerPage-1)+vs.index }</td>
					<td>${ms.title }</td>
					<td>${ms.mname }</td>
					<td>${ms.subject }</td>
					<td>${ms.place}</td>
					<td>${ms.diff}</td>
					<td>${ms.freq}</td>
					<td>${ms.ldate}</td>
					<td>${ms.sdate} ~ ${ms.edate}(${ms.time })</td>
					<td>
						<button type=button class="btn btn-outline-success btncss btn-detail " value="${ms.type },${ms.sno }">자세히</button>
					</td>
					<td>
					<!-- 오늘의 날짜를 알려주는 코드(신청 버튼, 평가, 평가 완료, 평가보기 버튼 구분) -->
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<c:set var="sysdate"><fmt:formatDate value="${now}" pattern="yyyy/MM/dd" /></c:set>
					
					<!-- 신청 중 -->
					<c:if test="${sysdate lt ms.ldate or sysdate eq ms.ldate }">
						<button type=button id="applyList${ms.sno }" value="1" name="applyListView" class="btn btn-outline-success btncss" disabled >모집 중</button>						
					</c:if>
					
					<!-- 신청 마감 -->
					<c:if test="${((sysdate gt ms.ldate) or (sysdate eq ms.ldate)) and ((sysdate lt ms.sdate)) }">
						<button type=button id="applyList${ms.sno }" value="1" name="applyListView" class="btn btn-outline-success btncss" disabled >심사 중</button>						
					</c:if>
		
					<!-- 스터디 진행 중 => 팀원 목록 분기 하기? -->
					<c:if test="${((sysdate gt ms.sdate) or (sysdate eq ms.sdate) )and ((sysdate lt ms.edate) or (sysdate eq ms.edate)) and !(ms.sdate eq ms.ldate) }">
						<button type=button id="crewList${ms.sno }" value="1" name="crewListView" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#crewListModal" >진행 중(팀원 목록)</button>						
					</c:if>
					
					<!-- 스터디 종료 => 평가 보기에서 내가 한 평가, 남이 한 평가 같이 보기 -->
					<c:if test="${sysdate gt ms.edate  }">
						<button type=button id="${ms.sno }" value="1" name="evaluation" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#reviewModal">평가</button>
						<button type=button id="evalView${ms.sno }" value="1" name="evaluationView" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#viewModal">평가 보기</button>					
					</c:if>
					
					</td>
				</tr>
			</c:forEach>
		</c:if>

		<!-- 팀장일때 스터디 목록 -->
		<c:if test="${leaderList != null and leader eq 'y'}">
			<c:forEach var="ms" items="${leaderList}" varStatus="vs" >
					
				<tr>
					<td>${(numPerPage*cPage)-(numPerPage-1)+vs.index }</td>
					<td>${ms.title }</td>
					<td>${ms.mname }</td>
					<td>${ms.subject }</td>
					<td>${ms.place}</td>
					<td>${ms.diff}</td>
					<td>${ms.freq}</td>
					<td>${ms.ldate}</td>
					<td>${ms.sdate} ~ <br> ${ms.edate} <br> ${ms.time }</td>
					<td>
						<button type=button class="btn btn-outline-success btncss btn-detail " value="${ms.type },${ms.sno }">자세히</button>
					</td>
					<td>
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<c:set var="sysdate"><fmt:formatDate value="${now}" pattern="yyyy/MM/dd" /></c:set>
					
					<!-- 신청 중 & 신청 마감 & 스터디 진행 전 => 팀원 취소 하기 기능-->
					<c:if test="${(sysdate lt ms.sdate) or (sysdate eq ms.sdate)  }">
						<button type=button id="applyList${ms.sno }" value="1" name="applyListView" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#viewModal" style="margin-bottom:10px;" >신청 현황</button> <br />
					</c:if>
					
					<!-- 스터디 진행 중 => 팀원 목록 분기하기(신청현황에서) -->
					<c:if test="${((sysdate gt ms.sdate) or (sysdate eq ms.sdate)) and ((sysdate lt ms.edate) or (sysdate eq ms.edate)) }">
						<button type=button id="crewList${ms.sno }" value="1" name="crewListView" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#crewListModal" >팀원 목록</button>						
					</c:if>
					
					<!-- 스터디 종료 -->
					<c:if test="${sysdate gt ms.edate  }">
						<button type=button id="${ms.sno }" value="1" name="evaluation" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#reviewModal">평가</button>
						<button type=button id="evalView${ms.sno }" value="1" name="evaluationView" class="btn btn-outline-success btncss" data-toggle="modal" data-target="#viewModal">평가 보기</button>					
						<!-- 내가 한 평가도 보여주기 -->
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
		String lno = String.valueOf(request.getAttribute("lno"));
		String tno = String.valueOf(request.getAttribute("tno"));
		String kno = String.valueOf(request.getAttribute("kno"));
		String subno = String.valueOf(request.getAttribute("subno"));
		String dno = String.valueOf(request.getAttribute("dno"));
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
							<button type="submit" class="btn btn-outline-success btncss">등록</button>
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
	<!-- 스터디 팀원 목록 보기 시작 -->
	<div class="modal fade" id="crewListModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
		<div class="modal-dialog modal-lg" role="document" >
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">스터디 팀원 목록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" id="div-crewList" >
				
				</div>
			</div>
		</div>
	</div>
	<!-- 스터디 팀원 목록 보기 끝 -->
	
	<script>
		$(function(){
			/* 키워드로 검색 하기 */
			$("select#searchKwd").on("change",function(){
				var html = "";
				$("form#formSearch").empty();
				if($(this).val()=='title'){ //스터디 명
					html="<input type='text' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
					html+="<input type='hidden' name='searchKwd' value='title' />";
					
					//console.log('title');
				} 
				if($(this).val()=='captain'){ //팀장 명
					html="<input type='text' name='kwd' id='captainKwd' placeholder='강사/팀장명' />";
					html+="<input type='hidden' name='searchKwd' value='captain' />";
					
					//console.log('captain');
				} 
				/* 
				if($(this).val()=='subject'){ //과목명
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='과목명' />";
					html+="<input type='hidden' name='searchKwd' value='subject' />";
					
					//console.log('subject');
				} 
				if($(this).val()=='place'){ //장소명
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='장소' />";
					html+="<input type='hidden' name='searchKwd' value='place' />";
					
					//console.log('place');
				} 
				if($(this).val()=='diff'){ //난이도
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='난이도' />";
					html+="<input type='hidden' name='searchKwd' value='diff' />";
					
					//console.log('diff');
				} 
				 */
				 
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
					//console.log('term');
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
					//console.log('freq');
				}
				html+="<input type='hidden' name='type' value='${type}' />";
				html+="<input type='hidden' name='leader' value='${leader}' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				html+="<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>";
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
			$(".btn-detail ").click(function(){
				var type = $(this).val().split(",")[0];
				var sno = $(this).val().split(",")[1];
				if(type=='study'){
					location.href="${rootPath}/study/studyView.do?sno="+sno;					
				}
				if(type=='lecture'){
					location.href="${rootPath}/lecture/lectureView.do?sno="+sno;										
				}
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
						//contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
						success: function(data){
							var html = "<table><tr><th>스터디명</th><th>팀장이름</th><th>작성자</th><th>평가할 팀원</th><th>평가</th><th>내용</th></tr>";
							var userId = $("input#hiddenUserId").val();
							var mno = $("input#hiddenMno").val();
							for(var i in data.list){
								var index = data.list[i];
								//console.log(data);
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
									html += "<button type='button' class='like' id='likeq"+index.tmno+"' value='1000'>좋아요</button>&nbsp;";
									html += "<button type='button' class='dislike' id='dislikeq"+index.tmno+"' value='-1000'>싫어요</button>";
									html += "<input type='hidden' name='point' id='pointq"+index.tmno+"' value='0'>";
									html += "</td>";
									html += "<td><input type='text' name='content' size='50' placeholder='평가 내용을 적어 주세요' autocomplete='off' required/></td>";
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
									html += "<button type='button' class='like' id='likeq"+index.tmno+"' value='1000'>좋아요</button>&nbsp;";
									html += "<button type='button' class='dislike' id='dislikeq"+index.tmno+"' value='-1000'>싫어요</button>";
									html += "<input type='hidden' name='point' id='pointq"+index.tmno+"' value='0'>";
									html += "</td>";
									html += "<td><input type='text' name='content' size='50' placeholder='평가 내용을 적어 주세요' autocomplete='off' required/></td>";
									html += "</tr>";
								}
							}
							html +="</table>";
							
							html += "<input type='hidden' name='leader' value='<%=leader%>' /> ";
							html += "<input type='hidden' name='type' value='<%=type%>' /> ";
							html += "<input type='hidden' name='searchKwd' value='<%=searchKwd%>' /> ";
							html += "<input type='hidden' name='kwd' value='<%=kwd%>' /> ";
							html += "<input type='hidden' name='cPage' value='<%=cPage%>' /> ";
							
							if(data.list.length<1){
								$("div#form-reviewEnroll").html("평가할 팀원이 없습니다.");																
							}else{
								$("div#form-reviewEnroll").html(html);																
							}
							
							
							$(".like").on("click",function(){
								//console.log($(this).val());
								var tmno = this.id.split("q")[1].toString();
								$("#dislikeq"+tmno).attr("style","background-color: #ffffff");
								$(this).attr("style","background: #0056e9");
								$("#pointq"+tmno).val($(this).val());
							});
							$(".dislike").on("click",function(){
								//console.log($(this).val());
								var tmno = this.id.split("q")[1].toString();
								$("#likeq"+tmno).attr("style","background-color: #ffffff");
								$(this).attr("style","background: #0056e9");
								$("#pointq"+tmno).val($(this).val());
							});
						
							 
						},
						error: function(){
							//console.log("ajax실패");
						}
						
					});
					
				}
			});
			
		});
	function giveReview(){
		var point = document.getElementsByName("point");
		var cnt = 0;
		//console.log(point);
		for(var i=0; i<point.length; i++){
			if(point[i].value=='1000' || point[i].value=='-1000'){
				cnt++;
			}
		}
		if(cnt==point.length && point.length!=0){
			return ture;
		}else if(point.length ==0){
			
		}
		else{
			alert("모든 평가 버튼을 눌러주세요");
		}
		
		return false;
	}
	var array = new Array("");
	var giveReviewArray = new Array("");
	
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
			//console.log(arr);
			$.ajax({
				url: "reviewFinish.do",
				data: {studyNo: arr},
				dataType: "json",
				success: function(data){
					//console.log(data);
					var cnt=0;
					var cntt=0;
					
					//로그인 한 회원은 평가를 했지만, 자신의 평가 값이 없을 경우
					for(var index in data.studyNoList){
						$("#"+data.studyNoList[index]).remove();
						$("#"+data.studyNoList[index]).val("0");  //로그인 한 회원이 평가를 했는지 알려준다. 
						$("#evalView"+data.studyNoList[index]).attr("style","display: inline");
					} 
					
					for(var index in data.giveReviewList[0]){
						for(var i in data.giveReviewList[0][index]){
								//$(".btn.btn-outline-success.disabled").remove();
								var map = {};
								map.point=data.giveReviewList[0][index][i].point.toString();
								map.content = data.giveReviewList[0][index][i].content;
								map.mname = data.giveReviewList[0][index][i].mname;
								map.sno = index;
								giveReviewArray[cntt] = map;
								//console.log(map);
								cntt++;
							}
					}
					 
					//로그인 한 회원이 평가를 하고, 자신의 평가 값이 있을 경우, 평가 보기
					for(var index in data.reviewList[0]){
						for(var i in data.reviewList[0][index]){
							//자신의 평가 값이 있고, 로그인 한 회원이 평가를 했다면 0, 안했다면 1
							if(i.length>0){ 
								//$(".btn.btn-outline-success.disabled").remove();
								var map = {};
								map.point=data.reviewList[0][index][i].point.toString();
								map.content = data.reviewList[0][index][i].content;
								map.mname = data.reviewList[0][index][i].mname;
								map.sno = index;
								array[cnt] = map;
							}
							cnt++;
						}
					}
					

				},
				error: function(){
					//console.log("ajax 처리 실패");
				}
				
			});
			once=1;
		}
		
	});
	
	$(function(){
		//평가 보기 버튼 클릭시, 해당 스터디의 스터디의 평가 리스트를 볼 수 있다.
		$("[name=evaluationView]").on("click",function(){
			var ahtml ="내가 받은 평가<br /><hr/>";
			ahtml+="<table><tr><th>평가 등급</th><th>평가 내용</th></tr>";
			var bhtml ="내가 준 평가<br /><hr/>";
			bhtml+="<table><tr><th>평가 등급</th><th>평가한 회원</th><th>평가 내용</th></tr>";
			//console.log(array);
			//console.log(giveReviewArray);
			for(var i=0; i<array.length; i++){
				if(this.id=="evalView"+array[i].sno){
					//console.log(array[i]);
					
					ahtml += "<tr>";
					ahtml += "<td>";
					if(array[i].point == "1000"){
						ahtml += "좋아요";
					}
					if(array[i].point=="-1000"){
						ahtml += "싫어요";						
					}
					ahtml += "</td>";
					ahtml += "<td>";
					ahtml += array[i].content;
					ahtml += "</td>";
					ahtml += "</tr>";									
					
				}
			}
			ahtml += "</table>";
			for(var i=0; i<giveReviewArray.length; i++){
				if(this.id=="evalView"+giveReviewArray[i].sno){
					////console.log(giveReviewArray[i]);
					
					bhtml += "<tr>";
					bhtml += "<td>";
					if(giveReviewArray[i].point == "1000"){
						bhtml += "좋아요";
					}
					if(giveReviewArray[i].point=="-1000"){
						bhtml += "싫어요";						
					}
					bhtml += "</td>";
					bhtml += "<td>";
					bhtml += giveReviewArray[i].mname;
					bhtml += "</td>";
					bhtml += "<td>";
					bhtml += giveReviewArray[i].content;
					bhtml += "</td>";
					bhtml += "</tr>";									
					
				}
			}
			bhtml += "</table>";
			if(array.length<1){
				ahtml="내가 받은 평가<br /><hr/>";	
				ahtml+="받은 평가가 없습니다.";
				ahtml+="<br/><br/><br/>";
			
			}
			$("#div-crew").html("");
			$("#div-reviewView").html(ahtml+"<br/>"+bhtml);
			$("h5#modalLabel").html("스터디 내 평가");
		});
		
		
		//신청 현황 보기 버튼
		$("button[name=applyListView]").on("click",function(){
			$("div.modal-body#div-crew").html("");
			////console.log(this.id);
			var studyNo = this.id.split("t")[1];
			applyLog(studyNo, "apply");
						
		});
		
		//팀원 목록 보기 버튼
		$( "button[name=crewListView]").on("click",function(){
			$("div.modal-body#div-crewList").html("");
			////console.log(this.id);
			var studyNo = this.id.split("t")[1];
			applyLog(studyNo, "crew");
		});
	});
	 
	function applyLog(studyNo, crew){
		$.ajax({
			url: "applyListView.do",
			data: {studyNo: studyNo},
			dataType: "json",
			success: function(data){
				////console.log(data);
				var recruit = data.recruit;
				var html ="<table>";
				html += "<tr>";
				html += "<td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>자기 소개</td><td>보기</td>";
				html += "</tr>";
				for(var i in data.applyList){
					//console.log(data.applyList[i]);
					html += "<tr id='amno"+data.applyList[i].mno+"'>";
					html += "<td>";
					html += "<img src='${rootPath}/resources/upload/member/"+data.applyList[i].mprofile+"' alt='회원 "+data.applyList[i].mid+"의 프로필 사진'  onerror=src='/study/resources/upload/member/noprofile.jpg'  style='width:100px;'/>";
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
					if(data.applyList[i].cover != null){
						html += data.applyList[i].cover;						
					}else{
						html += "X";	
					}
					html += "</td>";
					html += "<td>";
					html += "<button type=button class='apply' name='agree' id='agreeq"+data.applyList[i].mno+"'>수락</button>";
					html += "</td>";
					html += "</tr>";	
					$("h5#modalLabel").html("스터디 신청 현황("+data.applyList[0].title+")<br/>모집인원 : "+data.crewCnt+"/"+recruit);
				}
				html += "</table>";
				
				var removehtml = "";
				<%if(("lecture").equals(type)){%>
					removehtml += "<h6>강의를 듣는 회원</h6>";
				<%} else{%>
					removehtml += "<h5>스터디 신청을 수락 완료한 회원</h5>";
				<%}%>
				removehtml += "<hr>";
				removehtml += "<table>"; 
				removehtml += "<tr><td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>자기 소개</td><td>보기</td></tr>";
				for(var i in data.crewList){
					//console.log(data.crewList[i]);
					removehtml += "<tr id='cmno"+data.crewList[i].mno+"'>";
					removehtml += "<td>";
					removehtml += "<img src='${rootPath}/resources/upload/member/"+data.crewList[i].mprofile+"' alt='회원 "+data.crewList[i].mid+"의 프로필 사진'  onerror=src='/study/resources/upload/member/noprofile.jpg' style='width:100px;'/>";
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
					if(data.crewList[i].cover != null){
						removehtml += data.crewList[i].cover;						
					}else{
						removehtml += "X";	
					}
					removehtml += "</td>";
					removehtml += "<td>";
					removehtml += "<button type=button class='cancel'  value='"+data.crewList[i].type+","+data.crewList[i].mno+","+data.crewList[i].sno+"'>팀원 취소</button>";
					removehtml += "</td>";
					removehtml += "</tr>";	
				}
				
				//스터디 신청 수락된 회원 => 수락 버튼을 누르면 밑으로 
				removehtml += "</table>";
				
				
				//스터디 팀원 목록
				var crewhtml = "";
				crewhtml += "<table>"; 
				crewhtml += "<tr><td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>전화번호</td><td>자기 소개</td></tr>";
				for(var i in data.crewList){
					//console.log(data.crewList[i]);
					crewhtml += "<tr id='cmno"+data.crewList[i].mno+"'>";
					crewhtml += "<td>";
					crewhtml += "<img src='${rootPath}/resources/upload/member/"+data.crewList[i].mprofile+"' alt='회원 "+data.crewList[i].mid+"의 프로필 사진'  onerror=src='/study/resources/upload/member/noprofile.jpg' style='width:100px;'/>";
					crewhtml += "</td>";
					crewhtml += "<td>";
					crewhtml += data.crewList[i].grade;
					crewhtml += "</td>";
					crewhtml += "<td>";
					if(data.crewList[i].gender == 'M'){
						crewhtml += "남자";
					}else{
						crewhtml += "여자";
					}
					crewhtml += "</td>";
					crewhtml += "<td>";
					crewhtml += data.crewList[i].mname+"("+data.crewList[i].mid+")";
					crewhtml += "</td>";
					crewhtml += "<td>";
					crewhtml += data.crewList[i].phone;
					crewhtml += "</td>";
					crewhtml += "<td>";
					if(data.crewList[i].cover != null){
						crewhtml += data.crewList[i].cover;						
					}else{
						crewhtml += "X";	
					}
					crewhtml += "</td>";
					crewhtml += "</tr>";	
				}
				
				//스터디 신청 수락된 회원 => 수락 버튼을 누르면 밑으로 
				crewhtml += "</table>";
				
				
				if(data.applyList.length==0){
					<%if(("lecture").equals(type)){%>
						$("h5#modalLabel").html(data.studyName);
					<%} else{%>
						
						$("h5#modalLabel").html("스터디 신청 현황("+data.studyName+") <br/>모집인원 : "+data.crewCnt+"/"+recruit);
					<%}%>
					
					<%if(("lecture").equals(type)){%>
						//여기가 강의 신청 현황의 값이 없을 경우
						$("#div-reviewView").html("신청한 회원이 없습니다.");						
					<%} else{%>
						$("#div-reviewView").html("신청한 회원이 없습니다.");
					<%}%>
					
					if(data.crewList.length>0){
						$("#div-crew").html(removehtml);
					}else{
						<%if(("lecture").equals(type)){%>
							$("#div-crew").html("<br/><h6>강의를 듣는 회원</h6><hr/><br/> 팀원이 없습니다.");
						<%} else{%>
							$("#div-crew").html("<br/><h5>스터디 신청을 수락 완료한 회원</h5><hr/><br/> 팀원이 없습니다.");
						<%}%>
					}
				} else{
					$("#div-reviewView").html(html);
					if(data.crewList.length>0){
						$("#div-crew").html(removehtml);
					}else{
						<%if(("lecture").equals(type)){%>
							$("#div-crew").html("<br/><h6>강의를 듣는 회원</h6><hr/><br/> 팀원이 없습니다.");
						<%} else{%>
							$("#div-crew").html("<br/><h5>스터디 신청을 수락 완료한 회원</h5><hr/><br/> 팀원이 없습니다.");
						<%}%>
					}
				} 
				if(crew=="crew"){
					if(data.crewList.length>0){
						$("#div-crewList").html(crewhtml);												
					}else{
						<%if(("lecture").equals(type)){%>
							$("#div-crewList").html("해당 강의의 팀원이 없습니다.");
						<%} else{%>
							$("#div-crewList").html("해당 스터디의 팀원이 없습니다.");
						<%}%>
					}
				}
				
				$("button[name=agree]").on("click",function(){
					console.log(recruit);
					//모집 인원이 회원으로 수락한 인원보다 크면 수락해준다.
					if(data.crewCnt<recruit){
						$(this).attr("style","color: red;");
						$("#disagreeq"+this.id.split("q")[1]).attr("style","color: black;");
						//console.log(this.id.split("q")[1]);
						var mno = this.id.split("q")[1];
						var sno = data.studyNo;
						$("#div-reviewView").html(html);
						$("tr#amno"+mno).remove();
						
						applyButton(sno, mno, "agree");
					}
					//모집 인원이 회원으로 수락한 인원보다 같거나 작으면 알림을 준다.
					else{
						alert("모집 인원이 꽉 찼습니다. ("+recruit+" 명)");
					}
				});
				$(".cancel").on("click", function(){
					var type = $(this).val().split(",")[0];
					var mno = $(this).val().split(",")[1];
					var sno = $(this).val().split(",")[2];
					if(type=='lecture'){
						alert("강의는 팀원을 취소할 수 없습니다. 관리자에게 문의하세요.");
					}else{						
						applyButton(sno, mno, "cancel");					
					}
				});
				
			},
			error: function(){
				//console.log("ajax 처리 실패");
			}
		});
	}
	
	function applyButton(sno, mno, confirm){
			$("div#div-reviewView").html("");
			$.ajax({
				url: "applyButton.do",
				data: {sno: sno, mno: mno, confirm: confirm},
				dataType: "json",
				success: function(data){
					var html = "";
					if(data.msg!=null){
						alert(data.msg);
					}
					//console.log(data);
					<%if(("lecture").equals(type)){%>
						html += "<h6>강의를 듣는 회원</h6>";
					<%} else{%>
						html += "<h5>스터디 신청을 수락 완료한 회원</h5>";
					<%}%>
					
					html += "<hr>";
					html += "<table>"; 
					html += "<tr><td>프로필사진</td><td>평가 등급</td><td>성별</td><td>회원이름(ID)</td><td>자기 소개</td><td>보기</td></tr>";
					for(var i in data.crewList){
						//console.log(data.crewList[i]);
						html += "<tr class='mno"+data.crewList[i].mno+"'>";
						html += "<td>";
						html += "<img src='${rootPath}/resources/upload/member/"+data.crewList[i].mprofile+"' alt='회원 "+data.crewList[i].mid+"의 프로필 사진'  onerror=src='/study/resources/upload/member/noprofile.jpg' style='width:100px;'/>";
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
						if(data.crewList[i].cover != null){
							html += data.crewList[i].cover;						
						}else{
							html += "X";	
						}
						html += "</td>";
						html += "<td>";
						html += "<button type=button class='cancel' value='"+data.crewList[i].type+","+data.crewList[i].mno+","+data.crewList[i].sno+"'>팀원 취소</button>";
						html += "</td>";
						html += "</tr>";	
					}
					
					//스터디 신청 수락된 회원 => 수락 버튼을 누르면 밑으로 
					html += "</table><br />";
					
					$("div.modal-body#div-crew").html(html);
					applyLog(sno);
					
				},
				error: function(){
					//console.log("ajax 처리 실패");
				}
			});
			
	}
	
	//지역을 선택하면 그에 맞는 도시들을 가져온다.
	$("select#local").on("change",function(){
		
		var lno=$("select#local option:selected").val();
		var lnoVal = $(this).val();
		if(lno == "0"){
			$("#town").hide();
			return;
		}
		
		townLoad(lnoVal,0);
			
	});
	function townLoad(lnoVal, tno){
		$.ajax({
			url:"../study/selectTown.do",
			data:{lno:lnoVal},
			dataType:"json",
			success:function(data){
				var html="";
				console.log(data);
				for(var index in data){
					if(tno==data[index].TNO){
						html +="<option value='"+data[index].TNO+"' selected>"+data[index].TOWNNAME+"</option><br/>";						
					}else{
						html +="<option value='"+data[index].TNO+"'>"+data[index].TOWNNAME+"</option><br/>";												
					}
				}
				$("#town").show();
				$("select#town").html(html);
			}
		});
	}

	//카테고리를 선택하면 그에 맞는 과목들을 가져온다.
	$("select#kind").on("change",function(){
		
		var kno= $("option:selected", this).val();
		var knoVal = $(this).val();
		if(kno == "0"){
			$("#subject").hide();
			return;
		}		
		
		kindLoad(knoVal);
			
		
	});
	
	function kindLoad(knoVal, subno){
		$.ajax({
			url:"../study/selectSubject.do",
			data:{kno:knoVal},
			dataType:"json",
			success:function(data){
				var html="";
				for(var index in data){
					if(subno==data[index].SUBNO){
						html +="<option value='"+data[index].SUBNO+"' selected>"+data[index].SUBJECTNAME+"</option><br/>";						
					}else{
						html +="<option value='"+data[index].SUBNO+"'>"+data[index].SUBJECTNAME+"</option><br/>";												
					}
				}
				$("#subject").show();
				$("select#subject").html(html);
			}
		});
	}
	
	//검색 제출 폼에 지역, 과목, 난이도 input:hidden 넣고 제출하기
	$("#formSearch").click(function(){
		var lno = ($("#local").val()!=null?$("#local").val():"0");
		var tno = ($("#town").val()!=null?$("#town").val():"0");
		var kno = ($("#kind").val()!=null?$("#kind").val():"0");
		var subno = ($("#subject").val()!=null?$("#subject").val():"0");
		var dno = ($("#diff").val()!=null?$("#diff").val():"0");
		
		hideSearch("lno",lno);
		if(lno==0){
			hideSearch("tno",'0');			
		}else{
			hideSearch("tno",tno);						
		}
		
		hideSearch("kno",kno);
		if(kno==0){
			hideSearch("subno",'0');			
		}else{
			hideSearch("subno",subno);			
		}
		
		hideSearch("dno",dno);
		
		
		return true;
	}); 
	
	//검색 폼 안에 넣을 input:hidden
	function hideSearch(n,v){
		var hide = document.createElement("input");
		hide.type="hidden";
		hide.name=n;
		hide.value=v;
		$("#formSearch").append(hide);
	}
	
	//이전 검색 select박스 유지하기
	$(document).ready(function(){
		var lno = '<%=lno%>';
		var tno = '<%=tno%>';
		var kno = '<%=kno%>';
		var subno = '<%=subno%>';
		if(lno!=0){
			townLoad(lno,tno);
		}
		if(kno!=0){
			kindLoad(kno,subno);
		}
	});
	</script>
		
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	
</div>









