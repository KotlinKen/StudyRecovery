<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="" name="pageTitle"/></jsp:include>
<div class="container">
<div class="tabs">
	<span class="showPopup"><a href="${rootPath }/board/boardList">전체보기</a></span><span class="seperate">|</span>
	<span class="showPopup"><a href="${rootPath }/board/boardList?type=공지">공지사항</a></span><span class="seperate">|</span><span class="showBanner"><a href="${rootPath }/board/boardList?type=일반" >일반</a></span>
	<span class="seperate">|</span><span class="showBanner"><a href="${rootPath }/board/boardList?type=one" >1:1</a></span>
</div>

<form action="${rootPath }/adv/adverstingListPaging" >
	<div class="form-row">
		<div class="form-group col-md-3">
			<input type="text" name="searchKeyword" class="form-control" value="${param.searchKeyword }" autocomplete="off"/>
		</div>
		<div class="form-group col-md-1">
			<button type="submit" class="form-control btn btn-primary btn-lg active">검색</button>
		</div>
	</div>
</form>

<div class="panel">
	<div class="leftSection">
	<div style="padding:5px 10px;">
	총 <span style="font-weight:bold;"> ${count } </span>건의 광고가 있습니다.
	</div>
	</div>
	<div class="rightSection">
	<button type="button" class="rm_btn rm_btn_colorGreen" onclick="location.href='adverstingWrite'">REGIST ADVERSTING</button>
	</div>
</div>




<table class="rm_table">
<thead>
	<tr>
		<th width="5%">번호</th>
		<th width="15%">제목</th>
		<th width="25%">내용</th>
		<th width="5%">작성자</th>
		<th width="6%">등록일</th>
	</tr>
</thead>
<tbody>
	
	<c:forEach var="list" items="${list}" varStatus="status">
		<tr onclick="fn_boardView('${list.BNO }')">
			<td class="first_col">${list.BNO}</td>
			<td class="boardTitle">${list.TITLE}</td>
			<td class="boartContent"><c:out value='${fn:substring(  ((list.CONTENT.replaceAll("\\\<.*?\\\>","")).replace("&nbsp;","")),0, 10)}' /></td>
			
			
			<td class="boartContent">${list.MNAME}</td>
			<td>${list.REG }</td>
		</tr>

	</c:forEach>
	${fn:length(list) == 0 ? "<tr><td colspan='6'>등록된 게시글이 없습니다.</td></tr>" : "" }
	
</tbody>
</table>



<%
	int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("count")));
	int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
	int cPage =1;
	try{
		cPage = Integer.parseInt(String.valueOf(request.getParameter("cPage")));
	}catch(NumberFormatException e){
		
	}
	
%>

<%= com.pure.study.common.util.Utils.getPageBar(totalContents, cPage, numPerPage, "adverstingListPaging.do") %>
</div>
<script>
	function fn_boardView(bno){
		location.href="${rootPath}/board/boardView?bno="+bno;
	}
</script>
<jsp:include page ="/WEB-INF/views/common/footer.jsp" />