<%@page import="java.util.Map"%>
<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="게시판" name="pageTitle"/></jsp:include>
<style>

.card-header{border-bottom:none;}
.btn-link{text-decoration:none;}
.btn-link:hover{text-decoration:none;}
.card-body{padding:2.4rem}
.tabs .actived{color:#0056e9;}

</style>
<div class="container">
	<div class="tabs">
		<span class="">
			<a href="${rootPath }/board/boardList?type=일반" class="${param.type eq '일반' ? 'actived' : '' }">전체보기</a>
		</span>
		<span class="seperate">|</span>
		<span class="">
			<a href="${rootPath }/board/boardList?type=공지" class="${param.type eq '공지' ? 'actived' : '' }">공지사항</a>
		</span>
		<span class="seperate">|</span>
		<span class="">
			<a href="${rootPath }/board/boardList?type=one" class="${param.type eq 'one' ? 'actived' : '' }">1:1</a>
		</span>
		<span class="seperate">|</span>
		<span class="">
			<a href="${rootPath }/board/boardList?type=faq" class="${param.type eq 'faq' ? 'actived' : '' }">FAQ</a>
		</span>
		
		<span class="seperate">|</span>
		<span class="">
			<a href="${rootPath }/board/boardList?type=event" class="${param.type eq 'event' ? 'actived' : '' }">이벤트</a>
		</span>
	</div>
	<c:if test="${param.type ne 'faq' }"> 
	<form action="${rootPath }/board/boardList" method="get">
	<input type="hidden" name="cPage" value="1" />
		<div class="form-row">
			<div class="form-group col-md-1" style="max-width:90px;">
				<select name="searchType" id="searchType">
					<option value="title" ${param.searchType eq "title" || param.searchType eq null ? "selected" : "" } >제목</option>
					<c:if test="${mber.mid eq 'manager' }"> 
					<option value="mname" ${param.searchType eq "mname" ? "selected" : "" } >작성자</option>
					</c:if>
					<option value="content" ${param.searchType eq "content" ? "selected" : "" } >내용</option>
				</select>
			</div>
			<div class="form-group col-md-3">
				<input type="hidden" name="type" value="${param.type}" /> <input type="text" name="searchKeyword" class="form-control" id="searchKeyword" value="${param.searchKeyword }" autocomplete="off" />
			</div>
			<div class="form-group col-md-1">

				<button type="submit" class="form-control btn btn-primary btn-lg" onclick="return searchVaildation()">검색</button>
			</div>
		</div>
	</form>

	<div class="panel">
	<div class="leftSection">
		<div style="padding: 5px 10px;">
			총 <span style="font-weight: bold;"> ${count } </span>건의 게시물이 있습니다.
		</div>
	</div>
	<c:if test="${mber != null && param.type ne 'event' && param.type ne '공지' || mber.mid eq 'manager'}">
	<div class="rightSection">
		<c:if test="${mber.mid ne 'manager'}">
		<button type="button" class="btn btn_reg" onclick="location.href='boardWrite?type=one'">
			1:1 문의하기
		</button>
		</c:if>
		<button type="button" class="btn btn_reg" onclick="location.href='boardWrite?type=${param.type}'">
			게시글 등록
		</button>
	</div>
	</c:if>
</div>

<table class="table rm_table">
<thead>
	<tr>
		<th width="5%">번호</th>
		<th width="20%">제목</th>
		<th width="25%">내용</th>
		<th width="7%">채택</th>
		<th width="10%">작성자</th>
		<th width="6%">등록일</th> 
	</tr>
</thead>
<tbody>

	<c:forEach var="list" items="${list}" varStatus="status">
		<tr onclick="fn_boardView('${list.BNO }')">
			<td class="first_col">${list.BNO}</td>
			<td class="boardTitle">
				
				${pastDate <= (list.REG) ? "<span class='circle circleBlue'></span>" : "" } ${fn:substring(list.TITLE, 0, 18)}
			</td>
			<td class="boartContent">
				${fn:substring(list.CONTENT.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", ""), 0, 20) eq "" ? "내용이 없습니다." : fn:substring(list.CONTENT.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", ""), 0, 20) }
				<c:if test="${list.CNT > 0}"><span class="replyCounter"> ${list.CNT }</span> </c:if>
			</td>
			<td class="boardFork text-center">
				 ${(list.FORK != null && list.FORK != 0) ? "<span class='circle circlePink'></span><span> 채택완료 </span>" : "" }
			</td>
			<%-- <td class="boartContent"><c:out value='${fn:substring(  ((list.CONTENT.replaceAll("\\\<.*?\\\>","")).replace("&nbsp;","")),0, 10) eq "" ? "내용이 없습니다." : fn:substring(  ((list.CONTENT.replaceAll("\\\<.*?\\\>","")).replace("&nbsp;","")),0, 10)}' /></td> --%>
			<td class="text-center">
			${mber.mno eq list.MNO ? "<span class='circle circleRed'></span>" : ""} 	${fn:substring(list.MNAME,0,3)} 
			</td>
			<td class="text-center">${list.REG }</td>
		</tr>
	</c:forEach>
	${fn:length(list) eq 0 ? "<tr><td colspan='6'>등록된 게시글이 없습니다.</td></tr>" : "" }
	
</tbody>
</table>
</c:if>

<c:if test="${param.type eq 'faq' }"> 
<div style="margin-top:20px;">
	<h1>자주 묻는 질문</h1>
</div>

<div class="accordion" id="accordionExample" style="margin:30px 0px 60px 0px;">

<c:forEach var="list" items="${list}" varStatus="status">

  <div class="card">
    <div class="card-header" id="headingOne">
      <h5 class="mb-0">
        <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseOne${status.count}" aria-expanded="true" aria-controls="collapseOne">
          ${list.TITLE}
        </button>
      </h5>
    </div>

    <div id="collapseOne${status.count}" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
      <div class="card-body">
        ${list.CONTENT}
      </div>
    </div>
  </div>
</c:forEach>
 
</div>

</c:if>

<%

/* List<Student> list = (List<Student>) request.getParameter("list"); */
	int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("count")));
	int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
	Map<String, String> paramMap = (Map<String, String>) request.getAttribute("queryMap");
	
	paramMap.put("cPage", "1");
	
	int cPage =1;
	String type = String.valueOf(request.getParameter("type"));
	String searchType = String.valueOf(request.getParameter("searchType"));
	String searchKeyword = String.valueOf(request.getParameter("searchKeyword"));
	
	if (type.equals("null")){
		type = "일반";
	}
	try{
		cPage = Integer.parseInt(String.valueOf(request.getParameter("cPage")));
	}catch(NumberFormatException e){
		
	}
	
	
%>
<c:if test="${param.type ne 'faq' }"> 
<%= com.pure.study.common.util.Utils.getPageBar(totalContents, cPage, numPerPage, "boardList", type, paramMap) %>
</c:if>
</div>
<script>
	function fn_boardView(bno){
		location.href="${rootPath}/board/boardView?bno="+bno+"&type=${param.type}";
	}
	
	function searchVaildation(){
		console.log("test");
		$searchKeyword = $("#searchKeyword").val().trim();
		$searchType = $("#searchType").val().trim();
		
		if($searchKeyword == ""){
			alert("검색어를 입력해주세요");
			return false;
		}
		if($searchType == ""){
			alert("이런건 곤란해요 검색어 타입을 설정해주세요");
			return false;
		}
		return true;
		
	}
</script>
<jsp:include page ="/WEB-INF/views/common/footer.jsp" />