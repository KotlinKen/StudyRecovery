<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import = 'com.pure.study.member.model.vo.Member, java.util.List, java.util.Map' %>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
	<style>
		input{
			display:none;
		}
		textarea{
			display:none;
		}
		td{
			text-align: left;
		}
		th{
			width: 150px;
		}
		[type=submit]{
			display: none;
		}
		label{
			display: none;
		}
	</style>

	<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="MEMBER" name="pageTitle" /></jsp:include>
	<div class="studyList">
	<!-- 장익순 작업 머리 버튼 설정 시작  -->
	 <jsp:include page="/WEB-INF/views/member/admin_member_button.jsp"/>
	<!-- 장익순 버튼 설정 끝 -->
	${member.mid }
	<form id="update-form" action="${pageContext.request.contextPath }/member/updateUser.do" method="post" enctype="multipart/form-data" onsubmit="return submitCheck();" >
         <table>
         	<tr>
         		<th>회원 아이디</th>
         		<td>
	                <input type="hidden" name="mno" id="mno" value="${member.mno }" />
	                <input type="text" name="mid" id="mid" value="${member.mid }" readonly/>
	                 <span>${member.mid }</span>                
         		</td>
         	</tr>
         	<tr>
         		<th>회원 이름</th>
         		<td>
         			<input type="text" name="mname" id="mname" size="30px" maxlength="7" value="${member.mname }" autocomplete="off" />
         			 <span>${member.mname }</span> 
         		</td>
         	</tr>
         	<tr>
         		<th>비밀번호 변경</th>
         		<td>
         			어떻게 할까~?
         		</td>
         	</tr>
         	<tr>
         		<th>연락처</th>
         		<td>
         			<input type="text" name="phone" id="phone" maxlength="11" value="${fn:trim(member.phone) }" autocomplete="off" />
         			 <span>${member.phone }</span> 
         		</td>
         	</tr>
         	<tr>
         		<th>사진</th>
         		<td>
         			<c:if test="${!(member.mprofile eq 'no')}">
                  <div id="imgChange" style="width:100px;">
                     <img id="photo" src="${pageContext.request.contextPath }/resources/upload/member/${member.mprofile}" alt="${member.mprofile}" onerror="this.src=''" style="width:100px;" /> 
                  </div>
                  </c:if>
                  <c:if test="${member.mprofile eq 'no'}">
                     <p>프로필 사진이 없습니다.</p>
                  </c:if>
                  <br />
                  <input type="file" name="upFile" />
                  <input type="hidden" name="preMprofile" value="${member.mprofile }" />
         		</td>
         	</tr>
         	<tr>
         		<th>이메일 변경</th>
         		<td>
         			어떻게 할까~?
         			 <span>${member.email }</span> 
                  <input type="email" name="email" id="email" value="${member.email }" readonly /> 
         		</td>
         	</tr>
         	<tr>
         		<th>생년월일</th>
         		<td>
         			 <span>${member.birth }</span> 
         			<input type="date" name="birth" id="birth" value="${member.birth }" readonly />
         		</td>
         	</tr>
         	<tr>
         		<th>성별</th>
         		<td>
         			${member.gender=='M'?'남자':'여자' }
         		</td>
         	</tr>
         	<tr>
         		<th> 관심사</th>
         		<td>
                  <span>
                  <c:forEach var="f" items="${member.favor }">
                  	${f }
                  </c:forEach>
                  </span>
                  
          			
         		</td>
         	</tr>
         	<tr>
         		<th>자기 소개</th>
         		<td>
         			<p id="length"></p>
         			 <span>${member.cover }</span> 
                  <%-- <textarea class="form-control" name="cover" cols="30" rows="10" placeholder="자기소개 및 특이 사항" style="resize: none;" >${member.cover }</textarea> --%>
                  
         		</td>
         	</tr>
         </table>
         <div class="btn-center1">
	       <!--   <button type="submit" class='btncss' id="submit">수정</button>                  
	         <span><button type="button" class='btncss' id="updateForm">수정</button></span> -->
         </div>
         </form>
	<script>
		$("#updateForm").click(function(){
			$("input").attr("style","display: block");
			$("span").attr("style","display: none");
		});
	</script>
	<%-- 
	<form id="update-form" action="${pageContext.request.contextPath }/member/updateUser.do" method="post" enctype="multipart/form-data" onsubmit="return submitCheck();" >
         <table>
         	<tr>
         		<th>회원 아이디</th>
         		<td>
	                <input type="hidden" name="mno" id="mno" value="${member.mno }" />
	                <input type="text" name="mid" id="mid" value="${member.mid }" readonly/>               
         		</td>
         	</tr>
         	<tr>
         		<th>회원 이름</th>
         		<td>
         			<input type="text" name="mname" id="mname" size="30px" maxlength="7" value="${member.mname }" autocomplete="off" />
         			
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
         			<input type="text" name="phone" id="phone" maxlength="11" value="${fn:trim(member.phone) }" autocomplete="off" />
         		</td>
         	</tr>
         	<tr>
         		<th>사진</th>
         		<td>
         			<c:if test="${!(member.mprofile eq 'no')}">
                  <div id="imgChange" style="width:100px;">
                     <img id="photo" src="${pageContext.request.contextPath }/resources/upload/member/${member.mprofile}" alt="${member.mprofile}" onerror="this.src=''" style="width:100px;" /> 
                  </div>
                  </c:if>
                  <c:if test="${member.mprofile eq 'no'}">
                     <p>프로필 사진이 없습니다.</p>
                  </c:if>
                  <br />
                  <input type="file" name="upFile" />
                  <input type="hidden" name="preMprofile" value="${member.mprofile }" />
         		</td>
         	</tr>
         	<tr>
         		<th>이메일 변경</th>
         		<td>
         			<button type="button"
                        class="btn btn-outline-success"
                         data-toggle="modal" 
                         data-target="#emailUpdate">이메일 변경</button>
                  <input type="email" name="email" id="email" value="${member.email }" readonly /> 
         		</td>
         	</tr>
         	<tr>
         		<th>생년월일</th>
         		<td>
         			<input type="date" name="birth" id="birth" value="${member.birth }" readonly />
         		</td>
         	</tr>
         	<tr>
         		<th>성별</th>
         		<td>
         			${member.gender=='M'?'남자':'여자' }
         		</td>
         	</tr>
         	<tr>
         		<th> 관심사</th>
         		<td>
         			<%
                  	Member m = (Member)request.getAttribute("member");
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
                  <textarea class="form-control" name="cover" cols="30" rows="10" placeholder="자기소개 및 특이 사항" style="resize: none;" >${member.cover }</textarea>
                  
         		</td>
         	</tr>
         </table>
         <div class="btn-center1">
	         <button type="submit" class='btncss' id="submit">수정</button>                  
         </div>
         </form>
	 --%>
	
	
	
	
	
	
	
	
	</div>
	<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />
	