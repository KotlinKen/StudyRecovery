<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<link type="text/css" rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
	ul#ul-page > li:nth-child(8){
		background: #ffffff;
	}
	select#town{
		display:none;
	}
	select#subject{
		display:none;
	}
	.btn-cancel{
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
	button.btn-cancel:hover{
		background: #0056e9;
		color: #ffffff;
	}

</style>
<div class="background">
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="결제 관리" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp" />
	<br />
	<br />
<div class="container page">
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
	
	<br />
	<select id="searchKwd">
		<option value="title" ${searchKwd eq 'title'?'selected':'' }>강의/스터디명</option>
		<option value="term" ${searchKwd eq 'term'?'selected':'' }>결제일</option>
	</select>
	
	<form action="paymentList.do" id="formSearch" autocomplete="off" style="display: inline">
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
		<input type='hidden' name='myPage' value='${myPage}' />
		<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>
	</form>
	<br />
	<br />
	<!-- 페이지바 -->
	<%
		int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("count")));
		int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
		String searchKwd = String.valueOf(request.getAttribute("searchKwd"));
		String kwd = String.valueOf(request.getAttribute("kwd"));
		String payDate = String.valueOf(request.getAttribute("payDate"));
		String myPage = String.valueOf("1");
		String lno = String.valueOf(request.getAttribute("lno"));
		String tno = String.valueOf(request.getAttribute("tno"));
		String kno = String.valueOf(request.getAttribute("kno"));
		String subno = String.valueOf(request.getAttribute("subno"));
		
		int cPage = 1;
		try{
			cPage = Integer.parseInt(request.getParameter("cPage"));
		}catch(NumberFormatException e){
			
		}
	%>

			<!-- 리스트 -->
			<table class="rm_touchTable">
				<thead>
					<tr>
						<th class="text-center">No</th>
						<th class="text-center">제목</th>
						<th class="text-center">등록일</th>
						<th class="text-center">시작 일자</th>
						<th class="text-center">강의 요일</th>
						<th class="text-center">시간</th>
						<th class="text-center">강의 비용</th>
						<th class="text-center">지역</th>
						<th class="text-center">과목</th>
						<th class="text-center">상태</th>
						<th class="text-center">결제 상태</th>
						<th class="text-center">비고</th>
					</tr>
				</thead>			
				<tbody>
					<c:forEach var="p" items="${list }" varStatus="vs">
						<tr>
							<td>${(numPerPage*cPage)-(numPerPage-1)+vs.index }</td>
							<td>${p.TITLE }</td>
							<td>${p.REGDATE }</td>
							<td>${p.SDATE }</td>
							<td>${p.FREQ }</td>
							<td>${p.TIME }</td>
							<td>${p.PRICE }</td>
							<td>${p.LOCAL }/${p.TOWNNAME }</td>
							<td>${p.KNAME }/${p.SUBNAME }</td>
							<td>${p.STATUS }</td>
							<td>${p.PSTATUS }</td>
							<td>
							<c:if test="${p.PSTATUS == '결제실패'}">
							<span style="color:red;">${p.PSTATUS}</span>
							</c:if>
							<c:if test="${!(p.PSTATUS == '결제실패')}">
							<span> ${p.PSTATUS } </span>
							</c:if>
							<c:if test="${p.PSTATUS == '결제완료' && ( p.STATUS == '모집 마감' || p.STATUS == '마감 임박' || p.STATUS == '모집 중')}">
							<button type="button" class="btn-cancel" onclick='lectureAdminCancel(${p.SNO},${p.MNO},${p.PNO},${p.PRICE})'>결제 취소</button>
							</c:if>
							<c:if test="${p.PSTATUS == '결제실패' }">
							<span style="color:red;">${p.PSTATUS }</span>
							</c:if>
							<c:if test="${p.PSTATUS == '결제취소' }">
							<span style="color:mediumseagreen;">취소완료</span>
							</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
	</div>  
	
	<%=com.pure.study.common.util.MyPageUtil.getPageBar(totalContents, cPage, numPerPage,"paymentList.do?searchKwd="+searchKwd+"&kwd="+kwd, myPage) %>
	<script>
	function lectureAdminCancel(sno, mno, pno, price){
		if(confirm("결제를 취소하시겠습니까?")){
			$.ajax({
				url : "${rootPath}/lecture/lectureAdminCancel.do",
				data : {
					sno : sno,
					mno : mno,
					pno : pno,
					price : price
				},
				success : function(data){
					location.href="${rootPath}/member/paymentList.do";
				}
			}).done(function(){
				alert("취소 완료");
			});		
		}
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
	$("select#searchKwd").on("change",function(){
		console.log("???");
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
		html+="<button type='submit' id='btn-search'><span class='icon'><i class='fa fa-search'></i></span></button>";
		html+="<input type='hidden' name='type' value='${type}' />";
		
		$("form#formSearch").html(html);
	});
	
	</script> 
	
	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</div>	