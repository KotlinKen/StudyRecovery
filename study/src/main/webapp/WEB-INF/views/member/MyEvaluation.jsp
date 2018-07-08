<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.*, java.math.*" %>
<script type="text/javascript" src="${rootPath}"></script>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
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
	select#subject{
		display:none;
	}
	div.background{
		background: #ffffff;
	}
	h5.npoint{
		text-align: center;
		margin-top: 50px;
	}
</style>
<div class="background">
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp"/>
<div class="page">
	<br />
	<form action="${rootPath }/member/searchMyPageEvaluation.do" id="form-eval">
		<input type="radio" name="myPage" id="exp" value="exp" ${myPage eq 'exp'?'checked':'' }/>
		<label for="exp">경험치</label>
		<input type="radio" name="myPage" id="point" value="point" ${myPage eq 'point'?'checked':'' }/>
		<label for="point">평가 점수</label>
		<input type="radio" name="myPage" id="npoint" value="npoint" ${myPage eq 'npoint'?'checked':'' }/>
		<label for="npoint">지식 점수</label>
	</form>
	<div id="div-eval">
		<c:if test="${myPage eq 'exp' }">
			<h5> ${m.mname }님의 등급은 <strong>${list.expname }</strong> 입니다.</h5>
			 
			 <div id="myProgress">
			  <div id="myBar">
			    <div id="label">${list.exp }/${list.tblExp }</div>
			  </div>
			</div>
		</c:if>
		<c:if test="${myPage eq 'point' }">
				<div class="slidecontainer">
				  <input type="range" min="${gradeMin.POINT }" max="${gradeMax.POINT }" value="${list.point }" class="slider" id="myRange" disabled>
				</div>
				<c:forEach var="g" items="${gradeList }" varStatus="vs">
				<span style="position:absolute; left: ${((28*(vs.index))/2)*0.77+24}%;">
				${g.STATUS } 
				</span>
				</c:forEach>
				<br />
				<br />
				<br />
				
				<!-- 필터 -->
				<!-- 과목, 강의명, 팀장명, 좋아요 검색 -->
				<label for="subject">카테고리 :</label>
				<select name="kno" id="kind">
				<option value="0">전체</option>
				<c:forEach var="k" items="${kindList }">
					<option value="${k.KNO }" ${kno eq k.KNO?'selected':'' }>${k.KINDNAME }</option>
				</c:forEach>
				</select>&nbsp;
				<select name="subno" id="subject">
				</select>
				<form action="searchMyPageEvaluation.do" id="formSearch" autocomplete="off" style="display: inline">
					<select name="point">
						<option value="0">좋아요/싫어요</option>
						<option value="1000" ${point eq '1000'?'selected':'' }>좋아요</option>
						<option value="-1000" ${point eq '-1000'?'selected':'' }>싫어요</option>
					</select>
					<br />
					<select name="searchKwd">
						<option value="title" ${searchKwd eq 'title'?'selected':'' }>강의/스터디명</option>
						<option value="captain" ${searchKwd eq 'captain'?'selected':'' }>팀장/강사명</option>
					</select>
					<input type="text" name="kwd" value="${kwd eq ''?'':kwd }"/>
					<input type="hidden" name="myPage" value="point" />
					<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>
				</form> 
				
				<!-- 평가 리스트 -->
				<p>총 ${count }건의 평가가 있습니다.</p>
				<table>
					<tr>
						<th>번호</th>
						<th>강의/스터디명</th>
						<th>팀장/강사명</th>
						<th>분류</th>
						<th>과목</th>
						<th>스터디 기간 및 시간</th> 
						<th>평가 결과</th>
						<th>평가 내용</th>
						<th>보기</th>
					</tr>
					<c:forEach var="ms" items="${evalList}" varStatus="vs" >
						<tr>
							<td>${(numPerPage*cPage)-(numPerPage-1)+vs.index }</td>
							<td>${ms.title }</td>
							<td>${ms.captain}</td>
							<td>${ms.type }</td>
							<td>${ms.subjectname }</td>
							<td>${ms.sdate} ~ ${ms.edate}(${ms.time })</td>
							<td>
								<c:if test="${ms.point eq '1000' }">
									좋아요
								</c:if>
								<c:if test="${ms.point eq '-1000' }">
									싫어요
								</c:if>
							</td>
							<td>${ms.content }</td>
							<td>
								<button type=button class="btn btn-outline-success btncss btn-detail " value="${ms.sno }">자세히</button>
							</td>					
						</tr>
					</c:forEach>
				</table>
				<%
					int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("count")));
					int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
					String myPage = String.valueOf(request.getAttribute("myPage"));
					String searchKwd = String.valueOf(request.getAttribute("searchKwd"));
					String kwd = String.valueOf(request.getAttribute("kwd"));
					/* 
					String type = String.valueOf(request.getAttribute("type"));
					String applyDate = String.valueOf(request.getAttribute("applyDate"));
					String lno = String.valueOf(request.getAttribute("lno"));
					String tno = String.valueOf(request.getAttribute("tno"));
					String dno = String.valueOf(request.getAttribute("dno")); */
					
					int cPage = 1;
					try{
						cPage = Integer.parseInt(request.getParameter("cPage"));
					}catch(NumberFormatException e){
						
					}
				%>
				<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalContents, cPage, numPerPage,"searchMyPageEvaluation.do?", myPage) %>
	
		</c:if>
		<c:if test="${myPage eq 'npoint' }">
			<h5 class="npoint">당신의 지식 점수는 <strong style="font-size: 30px;">${list.NPOINT }</strong>입니다.</h5>
			
			<!-- 
				게시판 내가쓴 글..
					번호, 타입(1:1), 제목, 내용, 댓글 수, 등록일, 채택 여부, 자세히 버튼	
				게시판 채택된 글..
					번호, 타입(1:1), 게시판 제목, 게시판 내용, 채택 여부, 자세히 버튼
			 -->
			<%-- 
			<table>
				<tr>
					<td>번호</td>
					<td>타입</td>
					<td>제목</td>
					<td>내용</td>
					<td>댓글 수</td>
					<td>등록일</td>
					<td>채택 여부</td>
					<td>보기</td>
				</tr>
				<c:forEach var="ms" items="${pointList}" varStatus="vs" >
						<tr>
							<td>${(numPerPage*cPage)-(numPerPage-1)+vs.index }</td>
							<td>${ms.title }</td>
							<td>${ms.captain}</td>
							<td>${ms.type }</td>
							<td>${ms.subjectname }</td>
							<td>${ms.sdate} ~ ${ms.edate}(${ms.time })</td>
							<td>
								<c:if test="${ms.point eq '1000' }">
									좋아요
								</c:if>
								<c:if test="${ms.point eq '-1000' }">
									싫어요
								</c:if>
							</td>
							<td>${ms.content }</td>
							<td>
								<button type=button class="btn btn-outline-success btncss btn-detail " value="${ms.type },${ms.sno }">자세히</button>
							</td>					
						</tr>
					</c:forEach>
			</table>
			 --%>
		</c:if>
	</div>
	<br />
	<br />
	<br />
	<br />
	<br />
	<%
		Map<String, Object> map = (Map<String, Object>)request.getAttribute("list");
		double a =0;
		if(map.containsKey("tblExp")){
			int tblExp = ((BigDecimal)map.get("tblExp")).intValue();
			int exp = ((BigDecimal)map.get("exp")).intValue();
			int b = (tblExp-1000);
			a = (((double)exp-b)/(tblExp-b))*100;
			System.out.println(exp);
			System.out.println(tblExp);
		}		
		
	%>
	<script>
		$(document).ready(function() { 
			$("#myBar").attr("style", "width:"+<%=a%>+"%");
		});
		$(function(){
			$("input[name=myPage]").on("click", function(){
				$("#form-eval").submit();
			});
		});
		
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
			var kno = ($("#kind").val()!=null?$("#kind").val():"0");
			var subno = ($("#subject").val()!=null?$("#subject").val():"0");
			
			hideSearch("kno",kno);
			if(kno==0){
				hideSearch("subno",'0');			
			}else{
				hideSearch("subno",subno);			
			}
			
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
		<%
			String kno = String.valueOf(request.getAttribute("kno"));
			String subno = String.valueOf(request.getAttribute("subno"));
		%>
		
		//이전 검색 select박스 유지하기
		$(document).ready(function(){
			var kno = '<%=kno%>';
			var subno = '<%=subno%>';
			if(kno!=0){
				kindLoad(kno,subno);
			}
		});
		
		//스터디 자세히 보기
		$(".btn-detail ").click(function(){
			var sno = $(this).val();
			
			location.href="${rootPath}/study/studyView.do?sno="+sno;
		});
	</script>
	
	

	
	
	</div>	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</div>	