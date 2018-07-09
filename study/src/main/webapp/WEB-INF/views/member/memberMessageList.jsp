<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import = 'com.pure.study.member.model.vo.Member, java.util.List, java.util.Map' %>
<jsp:include page="/WEB-INF/views/common/header.jsp"><jsp:param value="내 정보 보기" name="pageTitle"/></jsp:include>
<style>
.memberlist > div{padding:10px; cursor:pointer; }
.memberlist > div:hover{background:#0056e9; color:#fff;}
#returnMember{margin-bottom:10px;}

</style>

<div class="container">
<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp"/>




	<div class="panel">
		<div class="leftSection">
			<div style="padding: 5px 10px;">
				총 <span style="font-weight: bold;"> ${count } </span>건의 쪽지가 있습니다.
			</div>
		</div>
			<div class="rightSection">
				<button type="button" id="btn-login" class="btn btn_reg" data-toggle="modal" data-target="#messageWriteModal" style="cursor:pointer">쪽지 작성</button>
			</div>
	</div>

	
<table class="table rm_table">
	<tr>
		<th>번호</th>	
		<th>내용</th>	
		<th>보낸이</th>	
		<th>받는이</th>	
		<th>발송날짜</th>
		<th>수신날짜</th>
	</tr>	
	<c:forEach var="message" items="${listQueryPage }">
	<tr onclick="messageView(${message.MESSAGENO}, ${message.SENDERMNO}, '${message.SNAME }')" data-toggle="modal"  data-target="#messageViewModal" >
		<td>${message.MESSAGENO }</td>	
		<td>${message.CONTENT }</td>	
		<td>${message.SNAME }</td>	
		<td>${message.RNAME }</td>	
		<td>${message.REGDATE }</td>	
		<td>${message.CHECKDATE }</td>	
	</tr>
	</c:forEach>
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
<%= com.pure.study.common.util.Utils.getPageBarRm(totalContents, cPage, numPerPage, "memberMessageList") %>
 



</div>


		<!-- 글쓰기  Modal 시작 -->
		      <div class="modal fade rm_custom_modal rm_custom_modal2 " id="messageWriteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel2" aria-hidden="true">
		         <div class="modal-dialog" role="document">
		            <div class="modal-content">
		               <div class="modal-header text-center">
		                  <h3 class="modal-title" id="exampleModalLabel">쪽지작성</h3>
	                  		<div class="modal-description">글을 작성하실때에는 상호 존중을 기본으로 서로 예의와 매너를 지켜가면서 작성 해주세요</div>
		                  <div class="adverstingPopupCloseBtn closebtn close" data-dismiss="modal"></div>
		               </div>
		               <form action="${rootPath }/message/messageWriteEnd" method="post">
						<div class="modal-body">
                           <input type="text" class="form-control" id="searchMember" placeholder="받는이" required />
                           
                           <div class="memberlist" style="max-height:150px; overflow-y:scroll; margin:10px 0px;" autocomplete="off" >
                           
                           </div>
                           
                           <input type="hidden" class="form-control" name="receivermno" id="receivermno" required />
						   <input type="text"  autofocus  class="form-control focus" name="content" id="writeContent" required placeholder="내용" autocomplete="off"  maxlength="20" />
						   
						</div>
						<div class="modal-footer">
							<div class="container">
								<div class="row">
									<div class="col-md-6" style="padding-left:0px;">
										<button type="submit" class="btn btn-outline-success btn-lg btn-block">전송</button>
									</div>
									<div class="col-md-6" style="padding-right:0px;">
										<button type="button" class="btn btn-secondary btn-lg btn-block" data-dismiss="modal">취소</button>
									</div>
								</div>
								<div class="row text-center">
									<div class="modal-description">We'll never post to Twitter, Facebook or Google on your behalf or without permission.</div>
								</div>
							</div>
						</div>
					</form>
		            </div>
		         </div>
		      </div>
		      <!-- 글쓰기 Modal 끝 -->

		<!-- 글보기 Modal 시작 -->
		      <div class="modal fade rm_custom_modal rm_custom_modal2 " id="messageViewModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		         <div class="modal-dialog" role="document">
		            <div class="modal-content">
		               <div class="modal-header text-center">
		                  <h3 class="modal-title" id="exampleModalLabel">쪽지보기</h3>
	                  		<div class="modal-description">글을 작성하실때에는 상호 존중을 기본으로 서로 예의와 매너를 지켜가면서 작성 해주세요</div>
		                  <div class="adverstingPopupCloseBtn closebtn close" data-dismiss="modal"></div>
		               </div>
						<div class="modal-body">
						   <input type="text"  autofocus  class="form-control focus" name="messageContent" id="messageContent" readonly="readonly"/>
						</div>
						<div class="modal-footer">
							<div class="container">
								<div class="row">
									<div class="col-md-6" style="padding-left:0px;">
										<button type="button" class="btn btn-outline-success btn-lg btn-block showReturnModal" data-toggle="modal" data-target="#messageReturnModal">답장</button>
									</div>
									<div class="col-md-6" style="padding-right:0px;">
										<button type="button" class="btn btn-secondary btn-lg btn-block cancelBtn" data-dismiss="modal">취소</button>
									</div>
								</div>
								<div class="row text-center">
									<div class="modal-description">We'll never post to Twitter, Facebook or Google on your behalf or without permission.</div>
								</div>
							</div>
						</div>
		            </div>
		         </div>
		      </div>
		      <!-- 로그인 Modal 끝 -->

















		<!-- 답장  Modal 시작 -->
		      <div class="modal fade rm_custom_modal rm_custom_modal2 " id="messageReturnModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel2" aria-hidden="true">
		         <div class="modal-dialog" role="document">
		            <div class="modal-content">
		               <div class="modal-header text-center">
		                  <h3 class="modal-title" id="exampleModalLabel">답장하기</h3>
	                  		<div class="modal-description">글을 작성하실때에는 상호 존중을 기본으로 서로 예의와 매너를 지켜가면서 작성 해주세요</div>
		                  <div class="adverstingPopupCloseBtn closebtn close" data-dismiss="modal"></div>
		               </div>
		               <form action="${rootPath }/message/messageWriteEnd" method="post">
						<div class="modal-body">
                           <input type="text" class="form-control" id="returnMember" placeholder="받는이" required readonly="readonly" />
                           <input type="hidden" class="form-control" name="receivermno" id="returnmno" required />
						   <input type="text"  autofocus  class="form-control focus" name="content" id="returnWriteContent" required placeholder="내용" autocomplete="off"  maxlength="20" />
						   
						</div>
						<div class="modal-footer">
							<div class="container">
								<div class="row">
									<div class="col-md-6" style="padding-left:0px;">
										<button type="submit" class="btn btn-outline-success btn-lg btn-block">전송</button>
									</div>
									<div class="col-md-6" style="padding-right:0px;">
										<button type="button" class="btn btn-secondary btn-lg btn-block" data-dismiss="modal">취소</button>
									</div>
								</div>
								<div class="row text-center">
									<div class="modal-description">We'll never post to Twitter, Facebook or Google on your behalf or without permission.</div>
								</div>
							</div>
						</div>
					</form>
		            </div>
		         </div>
		      </div>
		      <!-- 답장 Modal 끝 -->

















<script>

function setMember(receiverMno, receiverName){
	console.log(receiverMno);
	console.log(receiverName);
	$("#receivermno").val(receiverMno);
	$("#searchMember").val(receiverName);
	$(".memberlist").empty();
}


$("#searchMember").keyup(function(){
	console.log($("#searchMember").val());
	$memberList = $(".memberlist");	
	$.ajax({
		url : "${rootPath}/member/memberSearch",
		data : {searchType : "mname", mname : $("#searchMember").val()},
		dataType : "json",
		success : function(data){
			console.log(data.resultListMap);
			var html = "";
			for(index in data.resultListMap){
				html += "<div onclick='setMember("+data.resultListMap[index].MNO+", \""+data.resultListMap[index].MNAME+"\")'>"+data.resultListMap[index].MNAME+" <span style='color:#999; display:inline-block; padding-left:10px;'>"+ data.resultListMap[index].MID+ "</span></div>";
			}
			
			$memberList.html(html);
			
		}
	});
	
});

function messageView(messageNo, senderMno, senderMname){
	console.log(senderMno, senderMname);
	$("#returnMember").val(senderMname);
	$("#returnmno").val(senderMno);

	$.ajax({
		url : "${rootPath}/member/memberMessageView",
		data : {messageNo : messageNo},
		dataType : "json",
		success : function(data){
			console.log(data);
			$("#messageContent").val(data.resultMap.CONTENT);
		}
		
	});
}
	
	
	$(".showReturnModal").on("click", function(){
		$(".cancelBtn").click()
	});
	
	

</script>







<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
