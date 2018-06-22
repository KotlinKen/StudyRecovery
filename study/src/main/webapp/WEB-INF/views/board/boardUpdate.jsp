<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
div#board-container{width:400px; margin:0 auto; text-align:center;}
div#board-container input,div#board-container button{margin-bottom:15px;}
/* 부트스트랩 : 파일라벨명 정렬*/
div#board-container label.custom-file-label{text-align:left;}
</style>
<script src="${pageContext.request.contextPath }/resources/jquery-3.3.1.js"></script>

<div id="board-container">
   <form action="boardUpdateEnd.do" name="boardUpdateFrm" method="post" onsubmit="location.href='${pageContext.request.contextPath}/board/boardView.do?no='+${board.bNo}" enctype="multipart/form-data">
<input type="text" class="form-control" placeholder="글번호" name="bNo" id= "bNo" value="${board.bNo }" required>
 <input type="text" class="form-control" placeholder="제목" name="title" id="title" value="${board.title }" required>
   <input type="text" class="form-control" name="mNo" value="${board.mNo}" readonly required> 

   <c:forEach items="${imgFiles }" var="img" varStatus="vs">
       <button type="button" 
               class="btn btn-outline-success btn-block"
               onclick="fileDownload('${a.originalFileName}','${a.renamedFileName }');">
           첨부파일${vs.count} - ${a.originalFileName }
           
       </button>
       
   </c:forEach>
<textarea class="form-control" name="content" placeholder="내용" required>${board.content }</textarea> 
<button type="submit">확인</button>
</form>
</div>