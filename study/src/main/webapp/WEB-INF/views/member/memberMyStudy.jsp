<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
	table, tr, th, td{
		border: 2px solid black;
	}
</style>
	
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="내 스터디 목록" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp" />
	<br />
	<input type="hidden" id="hiddenUserId" value="${memberLoggedIn.mid }" />
	
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
						<button type=button>자세히</button>
					</td>
					<td>
						<button type=button id="${ms.sno }" value="1" name="evaluation" class="btn btn-outline-success" data-toggle="modal" data-target="#reviewModal">평가</button>
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
						<button type=button>자세히</button>
					</td>
					<td>
						<button type=button id="${ms.sno }" value="1" name="evaluation" class="btn btn-outline-success" data-toggle="modal" data-target="#reviewModal">평가</button>
						<button type=button>신청 현황</button>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		
	</table>
	<br />
	<!-- 페이지바 -->
	<%
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
		<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalLeaderContents, cPage, numPerPage,"searchMyPageKwd.do?searchKwd="+searchKwd+"&kwd="+kwd+"&type="+type+"leader"+leader, myPage) %>
	</c:if>
	<c:if test="${leader=='n' }">
		<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalContents, cPage, numPerPage,"searchMyPageKwd.do?searchKwd="+searchKwd+"&kwd="+kwd+"&type="+type+"leader"+leader, myPage) %>
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
					<form action="${rootPath }/member/reviewEnroll.do" method="post">
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
	
	<script>
		$(function(){
			$("select#searchKwd").on("change",function(){
				var html = "";
				$("form#formSearch").empty();
				if($(this).val()=='title'){
					html="<input type='text' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
					html+="<input type='hidden' name='searchKwd' value='title' />";
					
					console.log('title');
				} 
				if($(this).val()=='captain'){
					html="<input type='text' name='kwd' id='captainKwd' placeholder='강사/팀장명' />";
					html+="<input type='hidden' name='searchKwd' value='captain' />";
					
					console.log('captain');
				} 
				if($(this).val()=='subject'){
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='과목명' />";
					html+="<input type='hidden' name='searchKwd' value='subject' />";
					
					console.log('subject');
				} 
				if($(this).val()=='place'){
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='장소' />";
					html+="<input type='hidden' name='searchKwd' value='place' />";
					
					console.log('place');
				} 
				if($(this).val()=='diff'){
					html="<input type='text' name='kwd' id='subjectKwd' placeholder='난이도' />";
					html+="<input type='hidden' name='searchKwd' value='diff' />";
					
					console.log('diff');
				} 
				if($(this).val()=='term'){
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
				if($(this).val()=='freq'){
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
				html+="<button type='submit' id='btn-search'>검색</button>";
				html+="<input type='hidden' name='type' value='${type}' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				$("form#formSearch").html(html);
				
			});
			
			$("[type=radio]#study").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				html+="<input type='hidden' name='type' value='study' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
			$("[type=radio]#lecture").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				html+="<input type='hidden' name='type' value='lecture' />";
				html+="<input type='hidden' name='myPage' value='${myPage}' />";
				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
			
			$("button[name=evaluation]").on("click",function(){
				var studyNo = this.id;
				var leader = '<%=leader%>';
				console.log(studyNo);
				if($(this).val()=="1"){
					$.ajax({
						url: "reviewEnrollView.do",
						data: {studyNo: studyNo, leader: leader},
						dataType: "json",
						success: function(data){
							console.log(data);
							var html = "<table><tr><th>스터디명</th><th>팀장이름</th><th>작성자</th><th>평가할 팀원</th><th>평가</th><th>내용</th><th>보기</th></tr>";
							var userId = $("input#hiddenUserId").val();
							for(var i in data){
								var index = data[i];
								console.log(index.mid);
								console.log(data);
								if(userId!=index.mid){
									html += "<tr>";
									html += "<input type='hidden' name='tmno' value='"+index.mno+"'>";
									html += "<td>"+index.title;
									html += "<input type='hidden' name='sno' value='"+studyNo+"'>"+"</td>";
									html += "<td>"+index.smid+"("+index.smname+")"+"</td>";
									html += "<td>작성자";
									html += "<input type='hidden' name='mno' value='"+userId+"'>"+"</td>";
									html += "<td>"+index.mid+"("+index.mname+")"+"</td>";
									html += "<td>";
									html += "<button class='like' id='like,"+tmno+"' value='1000'>좋아요</button>";
									html += "<button class='dislike' id='dislike,"+tmno+"' value='-1000'>싫어요</button>";
									html += "<input type='hidden' name='point' id='point"+tmno+"' value='0'>";
									html += "</td>";
									html += "<td><input type='text' name='content' size='50' placeholder='평가 내용을 적어 주세요' required/></td>";
									html += "<td>보기</td>";
									html += "</tr>";
								} 
								if(userId!=index.mid && <%="n"==leader%>){
									html += "<tr>";
									html += "<input type='hidden' name='tmno' value='"+index.mno+"'>";
									html += "<td>"+index.title;
									html += "<input type='hidden' name='sno' value='"+studyNo+"'>"+"</td>";
									html += "<td>"+index.smid+"("+index.smname+")"+"</td>";
									html += "<td>작성자";
									html += "<input type='hidden' name='mno' value='"+userId+"'>"+"</td>";
									html += "<td>"+index.mid+"("+index.mname+")"+"</td>";
									html += "<td>";
									html += "<button class='like' id='like,"+tmno+"' value='1000'>좋아요</button>";
									html += "<button class='dislike' id='dislike,"+tmno+"' value='-1000'>싫어요</button>";
									html += "<input type='hidden' name='point' id='point"+tmno+"' value='0'>";
									html += "</td>";
									html += "<td><input type='text' name='content' size='50' placeholder='평가 내용을 적어 주세요' required/></td>";
									html += "<td>보기</td>";
									html += "</tr>";
								}
								
							}
							html +="</table>";
							if(data.length<2){
								$("div#form-reviewEnroll").html("평가할 팀원이 없습니다.");																
							} else{
								$("div#form-reviewEnroll").html(html);								
							}
							 
						},
						error: function(){
							console.log("ajax실패");
						}
						
					});
					
				}
			});
			
			$("button.like").on("click",function(){
				console.log($(this).val());
			});
			$("button.dislike").on("click",function(){
				console.log($(this).val());
				
			});
		});
	
	</script>
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	
