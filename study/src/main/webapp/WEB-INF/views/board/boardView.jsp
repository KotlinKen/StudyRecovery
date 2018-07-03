<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<jsp:include page ="/WEB-INF/views/common/header.jsp">
	<jsp:param value="${board.TITLE }" name="pageTitle"/>
</jsp:include>
<div class="container">
<c:set var = "images" value = "${fn:split(board.UPFILE, ',')}" />
<br />




<input type="hidden" name="type" value="일반"/>
<div class="form-row">
	<div class="form-group col-md-6">
		 <div> 작성자 :  ${board.MNAME }</div>
	</div>
	<div class="form-group col-md-6">
		 <div> 작성일 :  ${board.REGDATE }</div>
	</div>
</div>
<div class="form-row">
	<div class="form-group col-md-6">
		 <div> 제목 :  ${board.TITLE }</div>
	</div>
</div>

<div class="form-row">
	<div class="form-group col-md-12">
		<div class="form-control" style="padding:30px; min-height:500px;">${board.CONTENT}</div> 
	</div>
</div>

<div class="panel buttonPanel">
	<div class="leftSection">
	

	</div>
	<div class="rightSection">
	<c:if test="${mber.mno eq board.MNO }">
	<button type="button" class="btn btn_reg" onclick="javascript:location.href='${rootPath}/board/boardModify?bno=${board.BNO}'">수정</button> 
	</c:if>
	<button type="button" class="btn btn_reg" onclick="javascript:location.href='${rootPath}/board/boardList'">목록</button> 
	</div>
</div>



	<c:if test="${memberLoggedIn != null }">
	<form action="${rootPath }/board/replyWrite" method="post">
		<div class="form-row">
			<input type="hidden" name="mno" value="${mber.mno }"/>
			<input type="hidden" name="bno" value="${board.BNO}"/>
			
			<div class="form-group col-md-1 text-center">
				<c:if test="${memberLoggedIn.mprofile != null }">
				<div class="comment_profile backCover text-center" style="background-image:url('${rootPath }/resources/upload/member/${memberLoggedIn.mprofile }')"></div>
				</c:if>
				
					
				
				<div class="text-center">${mber.mid }</div>
			</div>
			<div class="form-group col-md-10">
				<textarea class="form-control commentArea" id="comment" rows="3" style="width:100%;" name="content"></textarea>
				<div class="commentCounter text-right"><span>0</span>/200</div>
			</div>
			<div class="form-group col-md-1">
				<button type="submit" class="btn rm_custom_btn" onclick="return fn_commentCheck()">전송</button>
			</div>
		</div>
	</form>
	</c:if>



	<c:if test="${memberLoggedIn == null }">
	<div class="form-row">
		<div class="form-group col-md-1 profile-col">
			<span class="comment_profile backCover" style="background-image:url('${rootPath }/resources/images/noprofile.jpg')"></span>
		</div>
		<div class="form-group col-md-10">
			<textarea class="form-control commentArea needLogin" id="comment" rows="3" style="width:100%" name="content" readonly> 로그인후 작성하실수 있습니다.</textarea>
			
		
		</div>
		<div class="form-group col-md-1">
			<button type="button" class="btn rm_custom_btn" onclick="return commentLoginfirst()">전송</button>
		</div>
	</div>
	</c:if>
	
	
	<form action="${rootPath }/board/replyDelete" method="post" id="replyHandler">
		<input type="hidden" name="bno" value="${board.BNO}"/>
		<input type="hidden" name="rno" id="rno" />
		<input type="hidden" name="mno" value="${mber.mno }"/>
	</form>
	
	<form action="${rootPath }/board/replyModify" method="post" id="replyModifyHandler">
		<input type="hidden" name="bno" value="${board.BNO}"/>
		<input type="hidden" name="rno"  />
		<input type="hidden" name="mno" value="${mber.mno }"/>
		<textarea hidden="hidden" name="content" id="textAreaforReplyHandler" cols="1" rows="1"></textarea>
	</form>

	<div class="replyList">

	</div>

<style>
.commentArea{border:1px solid #ededed; width:100%; resize:none; overflow:hidden;}
.needLogin{padding-top:40px; padding-left:30px; padding-bottom:0px;}
.commentArea:focus{border:1px solid #ededed;}
.rm_custom_btn{ width:100%; height:100px; border-radius:0.15rem; }
</style>
<script type="text/javascript">

function fn_commentCheck(){
	$comment = $("#comment");
	
	if($comment.val().trim() == ""){
		alert("코멘트를 입력해 주세요.");
		$comment.focus();
		return false;
	}
	
}

function commentLoginfirst(){
	if(confirm("코멘트를 남기려면 우선 로그인해주세요")){
		$("#btn-login").click();	
	}else{
		
	}
}

$(document).ready(function() {
    $('.commentArea').on('keydown', function() {
    	var count = $(this).val().length;
    	var maxCount = 199;
    	$(this).parent().find(".commentCounter span").text(count);
    	
        if(count > maxCount) {
            $(this).val($(this).val().substring(0, 199));
        }
    });
});

</script>




<div class="studyList">
	<nav aria-label="Page navigation example">
	  <ul class="pagination">
	    <li class="page-item"><a class="page-link" href="#">Next</a></li>
	  </ul>
	</nav>
</div>



	




</div>


<script>


$(function(){
	loadData( ${board.BNO }, 1, 1, 5);
});

function loadData(bno, type, cPage, pageBarSize){
	$.ajax({
		url:"${rootPath}/board/replyList?bno="+bno+"&cPage="+cPage,
		dataType:"json",
		success:function(data){
			console.log(data);
			var numPerPage = data.numPerPage;
			var cPage = data.cPage;
			var total = data.total;
			var totalPage = Math.ceil(parseFloat(total)/numPerPage);
			var pageNo = (Math.floor((cPage - 1)/parseFloat(pageBarSize))) * pageBarSize +1;
			var pageEnd = pageNo + pageBarSize - 1;
			var pageNation ="";
			
			$pagination = $(".pagination");
			
			if(pageNo == 1 ){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">이전</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadData(${board.BNO}, 1, '+(pageNo-1)+','+5+')">다음</a></li>';
			}
  			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadData(${board.BNO}, 1 ,'+pageNo+','+5+')">'+pageNo+'</a></li>';
				pageNo++;
			} 
			
			
			//다음 버튼
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">다음</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadData(${board.BNO}, 1,'+pageNo+','+5+')">다음</a></li>';
			}
			//페이지 버튼 생성
			$pagination.html(pageNation);
			var rmHtml = "";
			var reply = null;
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var reply = null;
			
	    	for(index in data.list){
	    		reply = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    		var profile = reply.MPROFILE;
	    		
	    			rmHtml += "<div class='reply'>"
		    			rmHtml += "<div class='replyInfo text-center'>";
							if(profile == "no" || profile == null || profile == ""){
		    					rmHtml += "<div class='felxerJustify'><div class='replyPic backCover text-center' style='background-image:url(${rootPath }/resources/images/noprofile.jpg)' ></div></div>";
							}else{
			    				rmHtml += "<div class='felxerJustify'><div class='replyPic backCover text-center' style='background-image:url(${rootPath }/resources/upload/member/"+profile+")' ></div></div>";
							}
			    			rmHtml += "<div class='replyMid'>" +reply.MID+"</div>";
		    			rmHtml += "</div>";

		    			rmHtml += "<div class='replyContent'><div class='oldContent'>" +reply.CONTENT +"</div></div>";
		    			rmHtml += "<div class='replyRegdate'>" +reply.REGS+"</div>";
		    			
		    			
		    			
		    			rmHtml += "<div class='replyCommand'>";
		    			
		    			
		    			if('${mber.mno}'== reply.MNO){ 
		    				rmHtml += "<div><a class='replyModify' onclick='replyModify(this, "+reply.MNO+", "+reply.RNO+");'>수정</a><a class='replyDelete' onclick='replyDelete("+reply.MNO+", "+reply.RNO+")'>삭제</a></div>";
		    			}
		    			if('${mber.mno}'== '${board.MNO}' && '${mber.mno}' != reply.MNO && '${board.FORK}' == 0){ 
		    				rmHtml += "<div><a onclick='fn_fork("+reply.MNO+", "+${board.BNO}+", "+reply.RNO+")'>채택</a></div>";
		    			}else{
		    				if('${board.FORK}' == reply.RNO){
		    					rmHtml += "<div style='color:red'>채택글</div>";
		    				}
		    			}
		    			
		    			
		    			rmHtml += "</div>";
		    			
	    			rmHtml += "</div>";
	    	}
			$(".replyList").html(rmHtml);
			
			
		},error:function(){
			
		}
	});
}

function replyDelete(mno, rno){
	if("${mber.mno}" != mno){
		alert("본인의 글만 삭제 가능합니다.");
		return false;
	}
	console.log(rno);
	$rh = $("#replyHandler");
	
	$rno = $rh.find("[name=rno]");
	console.log($rno);
	
	$rno.val(rno);
	
	$rh.submit();
}

function replyModify(t, mno, rno){
	$parent =$(t).parent().parent().parent();
	$sel = $(t).parent().parent().parent().find(".replyContent");
	$date = $(t).parent().parent().parent().find(".replyRegdate");
	$command = $(t).parent().parent().parent().find(".replyCommand");
	
	console.log(t);
	$old = $(t).parent().parent().parent().find(".oldContent");
	$old.hide();
	$date.hide();
	$command.hide();
	$sel.append("<textarea class='newContent commentArea'>"+$old.text()+"</textarea>");
	$parent.append("<div class='newContentBtn'><button onclick='replyModifyEnd("+mno+","+ rno+")'>수정</button><button onclick='replyModifyCancel(this)'>취소</button></div>");
}

function replyModifyCancel(t){

	
	
	$parent = $(t).parent().parent();
	console.log($parent);
	
	
	
	$content = $parent.find(".newContent").remove();
	$btn = $parent.find(".newContentBtn").remove();
	$old = $parent.find(".oldContent").show();
	$date = $parent.find(".replyRegdate").show();
	$command = $parent.find(".replyCommand").show();
	
}
function replyModifyEnd(mno, rno){
	if("${mber.mno}" != mno){
		alert("본인의 글만 수정 가능합니다.");
		return false;
	}
	$rh = $("#replyModifyHandler");
	$rno = $rh.find("[name=rno]");
	console.log($rno);
	$rno.val(rno);
	
	$rh.find("#textAreaforReplyHandler").val($(".newContent").val());
	$rh.submit();
}


function fn_fork(mno, bno, rno){
	console.log(mno);
	console.log(bno);
	console.log(rno);
	if(confirm("채택 하시겠습니까?")){
		$.ajax({
	        url : "${rootPath}/board/boardReplyFork",
	        type : "POST",
	        data : {"mno" : mno, "bno" : bno, "rno" : rno },
	        dataType : "json",
	        success : function(res) {
	        	console.log(res);
	        	if(res.queryMapString.result > 0){
	        		alert("글이 채택되었습니다.");
        			location.href = "${rootPath}/board/boardView?bno="+bno;
	        		console.log(res);
	        	}else{
	        		console.log(res);
	        	}
	        },
	        error : function(data) {
	            alert("opps.....");
	            console.log(data);
	        }
	     });
	}
}
	
</script>

<style>
	.reply{ display:flex;  margin-bottom:20px; padding-top:10px; padding-bottom:20px; border-bottom:1px solid #dedede;}
	.replyInfo{width:10%}
	.felxerJustify{justify-content: center; display:flex;}
	.replyPic{width:60px; height:60px; border-radius:30px; }
	.replyMid{}
	.replyContent{flex-grow:10;   border: 1px solid #ededed;}
	.oldContent{padding:10px;}
	.newContent{width:100%; height:100%; padding:10px;}
	.newContentBtn{align-self:center; flex-basis:90px; margin-left:10px; border:none; }
	.newContentBtn button{ font-size:1rem; border:none; background:none; margin-left:10px; cursor:pointer; }
	.replyRegdate{ align-self:center; flex-basis: 100px; color:#999; margin-left:20px;}
	.replyModify{margin-right:10px; }
	.replyCommand{flex-basis: 100px; align-self:center;}
	.replyCommand a{cursor:pointer;}
	
</style>


<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
