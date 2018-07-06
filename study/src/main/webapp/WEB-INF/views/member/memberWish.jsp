<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link type="text/css" rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
	ul#ul-page > li:nth-child(4){
		background: #ffffff;
	}
	td{
		max-width: 180;
		word-break:break-all;
		text-overflow:ellipsis; 
		overflow:hidden;
		white-space:nowrap;
	}
	select#town{
		display:none;
	}
	select#subject{
		display:none;
	}
</style>
<div class="page">
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="내 찜 목록" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp" />
	<br />
	<input type="radio" name="type" id="study" ${(type eq 'study') or (type == null)?'checked':'' }/>
	<label for="study">study</label>
	<input type="radio" name="type" id="lecture"  ${type eq 'lecture'?'checked':'' } />
	<label for="lecture">lecture</label>
	<br />
	<input type="radio" name="applyDate" id="present" value="present" ${(applyDate eq 'present') or (applyDate == null)?'checked':'' }/>
	<label for="present">
	<c:if test="${type eq 'lecture' }">
		현재 신청 중인 강의
	</c:if>
	<c:if test="${type eq 'study' }">
		현재 신청 중인 스터디
	</c:if>
	</label>
	<input type="radio" name="applyDate" id="last" value="last"  ${applyDate eq 'last'?'checked':'' } />
	<label for="last">
	<c:if test="${type eq 'lecture' }">
		신청이 지난 강의
	</c:if>
	<c:if test="${type eq 'study' }">
		신청이 지난 스터디
	</c:if>
	</label>
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
	
	<select id="searchKwd">
		<option value="title" ${searchKwd eq 'title'?'selected':'' }>강의/스터디명</option>
		<option value="captain" ${searchKwd eq 'captain'?'selected':'' }>팀장/강사명</option>
		<%-- <option value="subject" ${searchKwd eq 'subject'?'selected':'' }>과목</option>
		<option value="place" ${searchKwd eq 'place'?'selected':'' }>스터디 장소</option>
		<option value="diff" ${searchKwd eq 'diff'?'selected':'' }>난이도</option> --%>
		<option value="term" ${searchKwd eq 'term'?'selected':'' }>신청 마감일</option>
		<option value="freq" ${searchKwd eq 'freq'?'selected':'' }>주기</option>
	</select>
	<form action="searchMyPageKwd.do" id="formSearch" autocomplete="off" style="display: inline">
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
		<c:if test="${applyDate != null }">
			<input type="hidden" name="applyDate" value="${applyDate }" />
		</c:if>
		<input type='hidden' name='myPage' value='${myPage}' />
		
		<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>
	</form>
	<p>총 ${count }의 스터디 신청 건이 있습니다.</p> <!-- 스터디 가져올 경우 기간 마감된 것도 표시해줌. -->
	<table>
		<c:if test="${count != 0}">
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
				<th>상태</th>
				<th>신청인원</th>
				<th>신청마감</th>
				<th>찜한 날짜</th>
				<th>보기</th>
			</tr>
		</c:if>
		<c:if test="${count == 0 }">
			<p>검색 결과가 없습니다.</p>
		</c:if>
		<c:forEach var="w" items="${myPageList}" varStatus="vs" >
			<tr>
				<td>${(numPerPage*cPage)-(numPerPage-1)+vs.index }</td>
				<td>${w.title }</td>
				<td>${w.captain}</td>
				<td>${w.type }</td>
				<td>${w.subject }</td>
				<td>${w.place}</td>
				<td>${w.diff}</td>
				<td>${w.freq}</td>
				<td>${w.sdate} ~ ${w.edate}(${w.time })</td>
				<td>${w.status}</td>
				<td>${w.applycnt} / ${w.recruit}</td>
				<td>${w.ldate}</td>
				<td>${w.wdate}</td>
				<td>
					<button type=button class="btn btn-outline-success btncss btn-detail" value="${w.type },${w.sno }">자세히</button>
				</td>
			</tr>
		</c:forEach>
	</table>
	<br />
	<!-- 페이지바 -->
	<%
		int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("count")));
		int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
		String searchKwd = String.valueOf(request.getAttribute("searchKwd"));
		String kwd = String.valueOf(request.getAttribute("kwd"));
		String type = String.valueOf(request.getAttribute("type"));
		String applyDate = String.valueOf(request.getAttribute("applyDate"));
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
	<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalContents, cPage, numPerPage,"searchMyPageKwd.do?searchKwd="+searchKwd+"&kwd="+kwd+"&type="+type+"&applyDate="+applyDate, myPage) %>
	<script>
		var exec = 0;
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
				/* if($(this).val()=='subject'){
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
				}  */
				if($(this).val()=='term'){
					//html="<input type='date' name='kwd' id='dateKwd' />";
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
				if(<%="present".equals(applyDate)%>){
					html+="<input type='hidden' name='applyDate' value='present' />";					
				} 
				if(<%="last".equals(applyDate)%>){
					html+="<input type='hidden' name='applyDate' value='last' />";					
				}
				html+="<input type='hidden' name='myPage' value='${myPage}' />";

				html+="<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>";
				html+="<input type='hidden' name='type' value='${type}' />";
				$("form#formSearch").html(html);
				
			});
			
			$("[type=radio]#study").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				html+="<input type='hidden' name='type' value='study' />";
				if(<%="present".equals(applyDate)%>){
					html+="<input type='hidden' name='applyDate' value='present' />";					
				} 
				if(<%="last".equals(applyDate)%>){
					html+="<input type='hidden' name='applyDate' value='last' />";					
				}
				html+="<input type='hidden' name='myPage' value='${myPage}' />";

				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
			
			$("[type=radio]#lecture").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				html+="<input type='hidden' name='type' value='lecture' />";
				if(<%="present".equals(applyDate)%>){
					html+="<input type='hidden' name='applyDate' value='present' />";					
				} 
				if(<%="last".equals(applyDate)%>){
					html+="<input type='hidden' name='applyDate' value='last' />";					
				}
				html+="<input type='hidden' name='myPage' value='${myPage}' />";

				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
			
			$("[type=radio]#present").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				if(<%="lecture".equals(type)%>){
					html+="<input type='hidden' name='type' value='lecture' />";					
				} 
				if(<%="study".equals(type)%>){
					html+="<input type='hidden' name='type' value='study' />";					
				}
				html+="<input type='hidden' name='myPage' value='${myPage}' />";

				$("#formSearch").html(html);
				$("#formSearch").submit(); 
				
			});
			
			$("[type=radio]#last").on("click",function(){
				var html="<input type='hidden' name='kwd' id='titleKwd' placeholder='강의/스터디명' />";
				html+="<input type='hidden' name='searchKwd' value='title' />";
				if(<%="lecture".equals(type)%>){
					html+="<input type='hidden' name='type' value='lecture' />";					
				} 
				if(<%="study".equals(type)%>){
					html+="<input type='hidden' name='type' value='study' />";					
				}
				html+="<input type='hidden' name='applyDate' value='last' />";	
				html+="<input type='hidden' name='myPage' value='${myPage}' />";

				$("#formSearch").html(html);
				$("#formSearch").submit();
			});
		
			
		});
		$(function(){
			$(".btn-detail").click(function(){
				var type = $(this).val().split(",")[0];
				var sno = $(this).val().split(",")[1];
				if(type=='study'){
					location.href="${rootPath}/study/studyView.do?sno="+sno;					
				}
				if(type=='lecture'){
					location.href="${rootPath}/lecture/lectureView.do?sno="+sno;										
				}
			});
		})
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
	
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
	

</div>