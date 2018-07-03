<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import = 'com.pure.study.member.model.vo.Member, java.util.List, java.util.Map' %>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
   span.check-no{
      color: red;
      display: none;
   }
   
   span.check-yes{
      color: green;
      display: none;
   }
   ul#ul-page > li:first-child{
		background: #ffffff;
	}
	td{
		text-align: left;
	}
	p#length{
		text-align: right;
		font-size: 20px;
	}
	
	div.btn-center1{
		text-align: center;
		position: relative;
		top: 0;
		left: 680px;
		display: inline;
	}
	div.btn-center2{
		text-align: center;
		position: relative;
		top: -43px;
		left: 760px;
		display: inline;
	}
	.btncss{
		width: auto;
		height: auto;
		font-size: 17px;
		border-radius: 15px;
		padding-left: 15px;
		padding-right: 15px;
		padding-top: 7px;
		padding-bottom: 7px;
		background: #ffffff;
		border-style: solid;
	}
	.btncss:hover{
		background: #0056e9;
		color: white;
	}
	#submit:hover{
		background: #0056e9;
		color: white;
	}
	
</style>
<div class="page">
   <jsp:include page="/WEB-INF/views/common/header.jsp"> 
      <jsp:param value="내 정보 보기" name="pageTitle"/>
   </jsp:include>
         <jsp:include page="/WEB-INF/views/member/memberMyPage.jsp"/>
         <br />
         
         <form id="update-form" action="${pageContext.request.contextPath }/member/updateUser.do" method="post" enctype="multipart/form-data" onsubmit="return submitCheck();" >
            <c:if test="${memberLoggedIn != null }">
         <table>
         	<tr>
         		<th>회원 아이디</th>
         		<td>
	                <input type="hidden" name="mno" id="mno" value="${memberLoggedIn.mno }" />
	                <input type="text" name="mid" id="mid" value="${memberLoggedIn.mid }" readonly/>               
         		</td>
         	</tr>
         	<tr>
         		<th>회원 이름</th>
         		<td>
         			<input type="text" name="mname" id="mname" size="30px" maxlength="7" value="${memberLoggedIn.mname }" autocomplete="off" />
         			
         		</td>
         	</tr>
         	<tr>
         		<th>비밀번호 변경</th>
         		<td>
         			<button type="button" class="btn btn-outline-success" data-toggle="modal" 
                      data-target="#pwdUpdate">비밀번호 변경</button>
         		</td>
         	</tr>
         	<tr>
         		<th>연락처</th>
         		<td>
         			<input type="text" name="phone" id="phone" maxlength="11" value="${fn:trim(memberLoggedIn.phone) }" autocomplete="off" />
         		</td>
         	</tr>
         	<tr>
         		<th>사진</th>
         		<td>
         			<c:if test="${!(memberLoggedIn.mprofile eq 'no')}">
                  <div id="imgChange" style="width:100px;">
                     <img id="photo" src="${pageContext.request.contextPath }/resources/upload/member/${memberLoggedIn.mprofile}" alt="${memberLoggedIn.mprofile}" onerror="this.src=''" style="width:100px;" /> 
                  </div>
                  </c:if>
                  <c:if test="${memberLoggedIn.mprofile eq 'no'}">
                     <p>프로필 사진이 없습니다.</p>
                  </c:if>
                  <br />
                  <input type="file" name="upFile" />
                  <input type="hidden" name="preMprofile" value="${memberLoggedIn.mprofile }" />
         		</td>
         	</tr>
         	<tr>
         		<th>이메일 변경</th>
         		<td>
         			<button type="button"
                        class="btn btn-outline-success"
                         data-toggle="modal" 
                         data-target="#emailUpdate">이메일 변경</button>
                  <input type="email" name="email" id="email" value="${memberLoggedIn.email }" readonly /> 
         		</td>
         	</tr>
         	<tr>
         		<th>생년월일</th>
         		<td>
         			<input type="date" name="birth" id="birth" value="${memberLoggedIn.birth }" readonly />
         		</td>
         	</tr>
         	<tr>
         		<th>성별</th>
         		<td>
         			${memberLoggedIn.gender=='M'?'남자':'여자' }
         		</td>
         	</tr>
         	<tr>
         		<th> 관심사</th>
         		<td>
         			<%
                  	Member m = (Member)request.getAttribute("memberLoggedIn");
                  	System.out.println("mfavor=="+m);
                  	String[] mfavor = m.getFavor();
                  	List<Map<String, String>> list = (List<Map<String, String>>)request.getAttribute("favor");
                  	System.out.println("mfavor=="+list);
                  	int cnt=0;
                  %>
          			<% for(Map a : list) {%>
          				<input type="checkbox" name="favor" id="favor<%=cnt %>" value="<%=a.get("KINDNAME")%>" 
          				<%for(String b : mfavor) {%>
          					<%=a.get("KINDNAME").equals(b)?"checked":"" %>
          				<% }%>/>
             				
            			<label for="favor<%=cnt %>"><%=a.get("KINDNAME")%></label>   
          			<% cnt++; }%>
         		</td>
         	</tr>
         	<tr>
         		<th>자기 소개</th>
         		<td>
         			<p id="length"></p>
                  <textarea class="form-control" name="cover" cols="30" rows="10" placeholder="자기소개 및 특이 사항" style="resize: none;">${memberLoggedIn.cover }</textarea>
                  
         		</td>
         	</tr>
         </table>
         </c:if>
         <div class="btn-center1">
	         <button type="submit" class='btncss' id="submit">수정</button>                  
         </div>
         </form>
         <form id="drop-form" action="${pageContext.request.contextPath }/member/memberDrop.do" onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
            <input type="hidden" name="mid" value="${memberLoggedIn.mid }" />
         	<div class="btn-center2">
            	<button type="submit" class='btncss' id="drop">탈퇴하기</button>
            </div>
         </form>
         <!-- 비밀번호 팝업창 시작 -->
      <div class="modal fade" id="pwdUpdate" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">비밀번호 변경</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="${pageContext.request.contextPath }/member/newPwd.do" method="post" onsubmit="return pwdDuplicateCheck();">
            <div class="modal-body">
               <input type="password" class="form-control" name="oldPwd" id="oldPwd" placeholder="기존 비밀번호" required/>
               <br />
               <input type="password" class="form-control" name="newPwd" id="newPwd" placeholder="새 비밀번호(영대소문자, 숫자, 특수문자를 꼭 포함해주세요)" required/>
               <br />
               <input type="password" class="form-control" name="newPwd_" id="newPwdCheck" placeholder="새 비밀번호 확인" required/>
               <span class="check-no" >불일치</span>
            <span class="check-yes" >일치</span>
            <input type="hidden" id="pwd-ok" value="1" />
            </div>
            <div class="modal-footer">
              <button type="submit" class="btn btn-outline-success" >변경</button>
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
            </form>
          </div>
        </div>
      </div>
      <!-- 비밀번호 변경 팝업창 끝 -->
      <!-- 이메일 팝업창 시작 -->
      <div class="modal fade" id="emailUpdate" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">이메일 변경</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <form action="${pageContext.request.contextPath }/member/newEmail.do" method="post" onsubmit="return emailDuplicateCheck();">
            <div class="modal-body">
               <input type="email" class="form-control" name="email" id="newEmail" placeholder="이메일 변경" required/>
               <button type="button" class="btn btn-outline-success" id="emailUpdate">인증번호 발송</button>
               <br />
               <input type="hidden" id="send" value="duplication" />
               <input type="text" id="key" placeholder="인증키 입력" />
               <input type="hidden" id="keyCheck" value="check" />
               <button type="button" class="btn btn-outline-success" id="emailUpdateCheck">인증번호 확인</button>
               <span class="check-no" >불일치</span>
            <span class="check-yes" >일치</span>
            <input type="hidden" id="email-ok" value="1" />
            </div>
            <div class="modal-footer">
              <button type="submit" class="btn btn-outline-success">변경</button>
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
            </form>
          </div>
        </div>
      </div>
      <!-- 이메일 변경 팝업창 끝 -->
         
         <script>
/*             $(function(){
            	var len = 2000;
            	$("#length").html($("textarea[name=cover]").val().length+"/"+len);
               $("#newPwdCheck").on("keyup",function(){
                  var p1 = $("#newPwd").val();
                  var p2 = $(this).val();
                  //console.log(p1);
                  //console.log(p2);
                  if(p1==p2){
                     //console.log("일치");
                     $(".check-no").hide();
                     $(".check-yes").show();
                     $("#pwd-ok").val(0);
                  }else{
                     //console.log("불일치");
                     $(".check-yes").hide();
                     $(".check-no").show();
                     $("#pwd-ok").val(1);
                     
                  }
               });
                             
               //이메일 변경
               $("[type=button]#emailUpdate").click(function(){
                  var newEmail = $("#newEmail").val().trim();
                  
                  if($("#newEmail").val().trim()==""){
                	  alert("새로 변경할 이메일을 입력해주세요.");
                  }
                  if($("input#send").val()=="duplication"){	//이메일이 중복되는지 체크하기
                	  emailDuplication(newEmail);
                  }
                  if($("input#send").val()=="keySend"){ //조건문 바꿔야함.
                     //console.log("확인"+$("#send").val());
                     emailSendKey(newEmail);
                  }
               });
               
               $("#emailUpdateCheck").click(function(){
                  var key = $("#keyCheck").val();
                  var inputKey = $("#key").val();
                  
                  if(key==inputKey){
                     //console.log("이메일 인증키 일치!");
                     $(".check-no").hide();
                     $(".check-yes").show();
                     $("#email-ok").val(0);
                  }else{
                     //console.log("이메일 인증키 불일치!");      
                     $(".check-yes").hide();
                     $(".check-no").show();
                     $("#email-ok").val(1);
                  }
                  
               });
               //텍스트 길이 제한
               $("textarea[name=cover]").keyup(function(){
            	  var textLength = $(this).val().length;
            	  if(len<=2000){
              		  $(this).val($(this).val().substr(0,len));
              		  $("p#length").html(textLength+"/"+len);
              		  if(textLength==2000){
    	            	alert("최대 길이는 "+len+"자 입니다.");            		
              		  }
                	}
               });
               $("input#mid").click(function(){
             	  alert("회원 아이디는 변경할 수 없습니다.");
               });
               $("input#birth").click(function(){
             	  alert("생년월일은 변경할 수 없습니다. 관리자에게 문의해주세요. 1111-2222");
               });
             //이름 크기 제한
               $("input[name=mname]").on("keyup",function(){
            	  var textLength = $(this).val().trim().length;
            	  if(textLength>7){
            		
            		  alert("7자리 이하로 입력해주세요.");
             		  $(this).val($(this).val().substr(0,7));
            		  
             		} else if(textLength<=7){        			
             		}
               });
             //연락처 크기 제한
               $("input[name=phone]").keyup(function(){
            	   var text = $(this).val().trim();
            	  var textLength = text.length;
            	  var reg = /^(?=.*[0-9]).{0,11}$/;
            	  if(!reg.test(text) && textLength!=0){
            		  alert("연락처는 11자리, 숫자만 입력해주세요.");
            		  console.log(textLength);
            		  if(textLength==12){
            			  
            		  }else{
            		  	$(this).val("");            			  
            		  }
            	  } 
            	  if(textLength>11){
             		  $(this).val($(this).val().substr(0,11));      		
             		}
               });
               
               
            });
            
            //업로드 할 이미지 보여주기
            var upload = document.getElementsByName('upFile')[0];
            upload.onchange = function (e) {
            	  e.preventDefault();
            }


$("input[name=mname]").on("keyup", function() {
	var textLength = $(this).val().trim().length;
	if (textLength > 7) {
		$("p#pmname").attr("style", "display:inline;");
		alert("글자수가 제한되었습니다.");
		$(this).val($(this).val().trim().substring(0, 7));

	} else if (textLength <= 7) {
		$("p#pmname").attr("style", "display:none;");
	}
});
 */
	$(function() {
		var len = 2000;
		$("#length").html($("textarea[name=cover]").val().length + "/" + len);
		$("#newPwdCheck").on("keyup", function() {
			var p1 = $("#newPwd").val();
			var p2 = $(this).val();
			//console.log(p1);
			//console.log(p2);
			if (p1 == p2) {
				//console.log("일치");
				$(".check-no").hide();
				$(".check-yes").show();
				$("#pwd-ok").val(0);
			} else {
				//console.log("불일치");
				$(".check-yes").hide();
				$(".check-no").show();
				$("#pwd-ok").val(1);

			}
		});

		//이메일 변경
		$("[type=button]#emailUpdate").click(function() {
			var newEmail = $("#newEmail").val().trim();
			
			if ($("#newEmail").val().trim() == "") {
				alert("새로 변경할 이메일을 입력해주세요.");
			}
			if ($("input#send").val() == "duplication") { //이메일이 중복되는지 체크하기
				emailDuplication(newEmail);
			}
			if ($("input#send").val() == "keySend") { //조건문 바꿔야함.
				//console.log("확인"+$("#send").val());
				emailSendKey(newEmail);
			}
		});

		$("#emailUpdateCheck").click(function() {
			var key = $("#keyCheck").val();
			var inputKey = $("#key").val();

			if (key == inputKey) {
				//console.log("이메일 인증키 일치!");
				$(".check-no").hide();
				$(".check-yes").show();
				$("#email-ok").val(0);
			} else {
				//console.log("이메일 인증키 불일치!");      
				$(".check-yes").hide();
				$(".check-no").show();
				$("#email-ok").val(1);
			}

		});
		//텍스트 길이 제한
		$("textarea[name=cover]").keyup(function() {
			var textLength = $(this).val().length;
			if (len <= 2000) {
				$(this).val($(this).val().substr(0, len));
				$("p#length").html(textLength + "/" + len);
				if (textLength == 2000) {
					alert("최대 길이는 " + len + "자 입니다.");
				}
			}
		});
		$("input#mid").click(function() {
			alert("회원 아이디는 변경할 수 없습니다.");
		});
		$("input#birth").click(function() {
			alert("생년월일은 변경할 수 없습니다. 관리자에게 문의해주세요. 1111-2222");
		});
		//이름 크기 제한

		//연락처 크기 제한
		$("input[name=phone]").keyup(function() {
			var text = $(this).val().trim();
			var textLength = text.length;
			var reg = /^(?=.*[0-9]).{0,11}$/;
			if (!reg.test(text) && textLength != 0) {
				alert("연락처는 11자리, 숫자만 입력해주세요.");
				console.log(textLength);
				if (textLength == 12) {

				} else {
					$(this).val("");
				}
			}
			if (textLength > 11) {
				$(this).val($(this).val().substr(0, 11));
			}
		});

	});

	//업로드 할 이미지 보여주기
	var upload = document.getElementsByName('upFile')[0];
	upload.onchange = function(e) {
		e.preventDefault();

		var file = upload.files[0], reader = new FileReader();
		reader.onload = function(event) {
			var img = new Image();
			img.src = event.target.result;
			img.width = 200;
			$("#imgChange").html(img);
		}
		reader.readAsDataURL(file);

		return false;
	}
	function pwdDuplicateCheck() {
		var newPwd = $("#newPwd").val().trim();
		var reg = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
		var isValid = true;

		var po = $("#pwd-ok").val();
		if (po == "1") {
			//console.log("ok");
			alert("비밀번호가 불일치합니다.");
			isValid = false;
		}
		if (newPwd.length<8 || newPwd.length>16) {
			alert("암호를 8자이상 16자 이하로 설정해주세요.");
			return false;
		}
		if (!reg.test(newPwd)) {
			alert("영대소문자, 숫자, 특수문자로 비밀번호를 입력해주세요.");
			return false;
		}

		return isValid;
	}

	function emailDuplicateCheck() {
		var po = $("#email-ok").val();
		if (po == "1") {
			//console.log("ok");
			alert("인증키가 불일치 합니다.");
			return false;
		}

		return true;
	}

	function submitCheck() {
		if ($("input[type=file]").val() != "") {
			var ext = $('input[type=file]').val().split('.').pop()
					.toLowerCase();
			if ($.inArray(ext, [ 'gif', 'png', 'jpg', 'jpeg' ]) == -1) {
				alert('gif,png,jpg,jpeg 파일만 업로드 할수 있습니다.');
				return false;
			}
		}
		if($("input[name=mname]").val().trim().length > 7 ){
			$("input[name=mname]").substring(0, 7);
		}
		
		

		if ($("input[name=mname]").val().length < 2
				|| $("input[name=mname]").val().trim().length > 7) {
			alert("한글 2자이상 7자 이하로 적어주세요.");
			return false;
		}
		return true;
	}
	function emailSendKey(newEmail) {
		alert("이메일로 인증번호를 발송하였습니다.");
		$.ajax({
			url : "newEmailKey.do",
			data : {
				newEmail : newEmail
			},
			dataType : "json",
			success : function(data) {
				if (data.isUsable == true) {
					$("#keyCheck").val(data.tempPwd);
				} else {

				}

			},
			error : function(jqxhr, textStatus, errorThrown) {
				console.log("ajax실패", jqxhr, textStatus, errorThrown);
			}

		});
	}
	function emailDuplication(newEmail) {
		if (newEmail != "") {
			$.ajax({
				url : "emailDuplication.do",
				data : {
					newEmail : newEmail
				},
				dataType : "json",
				success : function(data) {
					
					if (data.isDulpl == false) {//이메일이 중복일 경우
						$("input#send").val("duplication");
						alert("이메일이 중복됩니다.");
					} else {
						emailSendKey(newEmail);//중복되지 않으면
					}

				},
				error : function(jqxhr, textStatus, errorThrown) {
					console.log("ajax실패", jqxhr, textStatus, errorThrown);
				}

			});

		}
	}

            
</script>
   
   <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</div> 
