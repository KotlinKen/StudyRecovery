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
<div class="container">
<label for="content">comment</label>
      <form name="replyInsertForm">
<div class="input-group">
<input type="hidden" name="bNo" value="${reply.bNo}"/>
<input type="text" class="form-control" id="content" name="content" placeholder="내용을 입력하세요.">
<input type="button" class="insertBtn" name="replyInsertBtn" value="등록" onclick="location.href='${pageContext.request.contextPath}/board/replyInsert.do?'">


</div>
</form>
</div>  
       <input type="button" class="updateBtn" value="글수정" onclick="location.href='${pageContext.request.contextPath}/board/boardUpdate.do?no='+${board.bNo}">
       <input type="button" class="delBtn" value="글삭제" onclick="location.href='${pageContext.request.contextPath}/board/boardDelete.do?no='+${board.bNo}">
</div>
 <script>
function fileDownload(oName, rName){
	//한글파일명, 특수문자가 포함있을 경우 대비
	oName = encodeURIComponent(oName);
	location.href="${pageContext.request.contextPath}/board/boardDownload.do?oName="+oName+"&rName="+rName;
}
 var bNo = '${reply.bNo}'; //게시글 번호
 
$('[name=replyInsertBtn]').click(function(){ //댓글 등록 버튼 클릭시 
    var insertData = $('[name=replyInsertForm]').serialize(); //commentInsertForm의 내용을 가져옴
    replyInsert(insertData); //Insert 함수호출(아래)
});

//댓글 등록
function replyInsert(insertData){
    $.ajax({
        url : "replyInsert.do",
        type : 'post',
        data : insertData,
        success : function(data){
            if(data == 1) {
                replyList(); //댓글 작성 후 댓글 목록 reload
                $('[name=reply]').val('');
            }
        }
    });
}

//댓글 목록 
function commentList(){
    $.ajax({
        url : '/reply/list',
        type : 'get',
        data : {'bNo':bNo},
        success : function(data){
            var a =''; 
            $.each(data, function(key, value){ 
                a += '<div class="replyArea" style="border-bottom:1px solid darkgray; margin-bottom: 15px;">';
                a += '<div class="replyInfo'+value.rNo+'">'+'댓글번호 : '+value.rNo+' / 작성자 : '+value.mNo;
                a += '<a onclick="replyUpdate('+value.rNo+',\''+value.content+'\');"> 수정 </a>';
                a += '<a onclick="replyDelete('+value.rNo+');"> 삭제 </a> </div>';
                a += '<div class="replyContent'+value.rNo+'"> <p> 내용 : '+value.content +'</p>';
                a += '</div></div>';
            });
            
            $(".replyList").html(a);
        }
    });
}




</script> 