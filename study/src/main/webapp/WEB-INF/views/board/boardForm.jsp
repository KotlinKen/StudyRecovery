<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--    <jsp:param value="" name="pageTitle"/>--%>
<script src="${pageContext.request.contextPath }/resources/jquery-3.3.1.js"></script>
 <script>
function validate(){
	console.log($("input[name=title]").val());
	console.log($("input[name=mNo]").val());
	console.log($("textarea[name=content]").val());

   
   return true;
}
$(function(){
   $("[name=upFile]").on("change",function(){
      //var fileName= $(this).val();
      var fileName= $(this).prop("files")[0].name;
      
      $(this).next(".custom-file-label").html(fileName);
   });
   
});

</script>
<style>
/*부트스트랩 라벨명정렬*/
div#board-container label.custom-file-label{text-align:left;}
div#board-container{
   width:400px;
   margin:0 auto;
   text-align:center;
   
}
div#board-container input{margin-bottom:15px;}
</style>

<div id="board-container">
   <form action="boardFormEnd.do" name="boardFrm" method="GET" onsubmit="return validate();" enctype="multipart/form-data">
      <input type="text" name="title" id="title" placeholder="제목" class="form-control" required/>
      <input type="number" name="mNo" id="mNo" value="14"<%-- "${memberLoggedIn.getMno() }" --%> class="form-control" readonly required/>
      <div class="input-group mb-3" style="padding:0px">
        <div class="input-group-prepend" style="padding:0px">
          <span class="input-group-text">첨부파일</span>
        </div>
        <div class="custom-file">
          <input type="file" class="custom-file-input" id="upFile1" name="upFile">
          <label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
        </div>
      </div>
      
       <div class="input-group mb-3" style="padding:0px">
        <div class="input-group-prepend" style="padding:0px">
          <span class="input-group-text">첨부파일2</span>
        </div>
        <div class="custom-file">
          <input type="file" class="custom-file-input" id="upFile2" name="upFile">
          <label class="custom-file-label" for="upFile1">파일을 선택하세요</label>
        </div>
      </div>
      <textarea name="content" id="content" cols="30" rows="10" class="form-control" placeholder="내용" required></textarea><br />
      <input type="submit" class="btn btn-outline-success" value="저장"/>
   </form>

</div>
