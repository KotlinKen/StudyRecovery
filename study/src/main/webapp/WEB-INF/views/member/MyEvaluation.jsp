<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.*, java.math.*" %>
<script type="text/javascript" src="${rootPath}"></script>
<link type="text/css"  rel="stylesheet" href="${rootPath}/resources/css/member/member.css" />
<style>
#myProgress {
  position: relative;
  width: 80%;
  height: 30px;
  background-color: #ddd;
}

#myBar {
  position: absolute;
  height: 100%;
  background-color: #0056E9;
}

#label {
  text-align: center;
  line-height: 30px;
  color: white;
  
}
	ul#ul-page > li:nth-child(6){
		background: #ffffff;
	}
</style>
<div class="page">
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param value="" name="pageTitle"/>
	</jsp:include>
	<jsp:include page="/WEB-INF/views/member/memberMyPage.jsp"/>
	<br />
	평가 관리
	<form action="${rootPath }/member/searchMyPageEvaluation.do" id="form-eval">
		<input type="radio" name="eval" id="exp" value="exp" ${eval eq 'exp'?'checked':'' }/>
		<label for="exp">경험치</label>
		<input type="radio" name="eval" id="point" value="point" ${eval eq 'point'?'checked':'' }/>
		<label for="point">평가 점수</label>
		<input type="radio" name="eval" id="npoint" value="npoint" ${eval eq 'npoint'?'checked':'' }/>
		<label for="npoint">지식 점수</label>
	</form>
	<div id="div-eval">
		<c:if test="${eval eq 'exp' }">
			<h5> ${m.mname }님의 등급은 <strong>${list.expname }</strong> 입니다.</h5>
			 
			 <div id="myProgress">
			  <div id="myBar">
			    <div id="label">${list.exp }/${list.tblExp }</div>
			  </div>
			</div>
		</c:if>
		<c:if test="${eval eq 'point' }">
				<div class="slidecontainer">
				  <input type="range" min="${gradeMin.POINT }" max="${gradeMax.POINT }" value="${list.point[0] }" class="slider" id="myRange" disabled>
				</div>
				<c:forEach var="g" items="${gradeList }" varStatus="vs">
				<span style="position:absolute; left: ${((50*(vs.index))/2)*0.77+5}%;">
				${g.STATUS } 
				</span>
				</c:forEach>
		</c:if>
	</div>
	<br />
	<br />
	<br />
	<br />
	<br />
	<%
		Map<String, Object> map = (Map<String, Object>)request.getAttribute("list");
		double a =0;
		if(map!=null){
			if(map.containsKey("tblExp")){
				int tblExp = ((BigDecimal)map.get("tblExp")).intValue();
				int exp = ((BigDecimal)map.get("exp")).intValue();
				a = ((double)exp/tblExp)*100;
			}			
		}
		
	%>
	<script>
		$(document).ready(function() { 
			$("#myBar").attr("style", "width:"+<%=a%>+"%");
		});
		$(function(){
			$("input[name=eval]").on("click", function(){
				$("#form-eval").submit();
			});
		});
	</script>
	
	

	
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</div>	