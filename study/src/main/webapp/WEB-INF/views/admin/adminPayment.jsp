<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp">
<jsp:param value="PAYMENT" name="pageTitle" />
</jsp:include>
   
<div class="payList">
	<div class="table-responsive">
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>제목</th>
					<th>강사명</th>
					<th>등록일</th>
					<th>시작 일자</th>
					<th>강의 요일</th>
					<th>시간</th>
					<th>강의 비용</th>
					<th>신청 인원</th>
					<th>모집 인원</th>
					<th>지역</th>
					<th>과목</th>
					<th>상태</th>
					<th>결제 상태</th>
					<th></th>
				</tr>
			</thead>			
			<tbody>
				<c:forEach var="pay" items="${list }">
					<tr>
						<td>imp_${pay.PNO }</td>
						<td>${pay.TITLE }</td>
						<td>${pay.MNAME}</td>
						<td>
							<fmt:formatDate value="${pay.REGDATE }" pattern="yyyy-MM-dd"/>							
						</td>
						<td>
							<fmt:formatDate value="${pay.SDATE }" pattern="yyyy-MM-dd"/>							
						</td>
						<td>${pay.FREQ }</td>
						<td>${pay.TIME }</td>
						<td>${pay.PRICE }원</td>
						<td>${pay.CNT }</td>
						<td>${pay.RECRUIT }</td>
						<td>${pay.LOCAL }/${pay.TOWNNAME }</td>
						<td>${pay.KNAME }/${pay.SUBNAME }</td>
						<td>${pay.STATUS }</td>
						<td>${pay.PSTATUS }</td>
						<td>ㅋ</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>   	
   
<jsp:include page="/WEB-INF/views/common/admin_footer.jsp"/>   