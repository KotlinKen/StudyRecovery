<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
	div.modal-body{
		text-align: center;
	}
	input[type=text]{
		text-align: center;
	}
</style>
<script>
$(document).ready(function(){
	var localNo = ${lecture.LNO};
	var tno = ${lecture.TNO};
	
	var kindNo = ${lecture.KNO};
	var subno = ${lecture.SUBNO};
	
	$.ajax({
		url: "selectTown.do",
		data: {localNo : localNo},
		dataType: "json",
		success : function(data){	
			
			var html="<option value=''>세부 지역을 선택하세요</option>";
			
			for(var index in data){
				if( tno == parseInt( data[index].TNO ) )
					html += "<option value='"+data[index].TNO +"' selected>" + data[index].TOWNNAME + "</option>";						
				else
					html += "<option value='"+data[index].TNO +"'>" + data[index].TOWNNAME + "</option>";
			}
			
			$(".modal-body #town").html(html);	
		}
	});
	
	$.ajax({
		url: "selectSubject.do",
		data: {kindNo : kindNo},
		dataType: "json",
		success : function(data){	
			
			var html="<option value=''>세부 과목을 선택하세요</option>";
			
			for(var index in data){
				if( subno == parseInt( data[index].SUBNO ) )
					html += "<option value='"+data[index].SUBNO +"' selected>" + data[index].SUBJECTNAME + "</option>";						
				else
					html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option>";
			}
			
			$(".modal-body #sub").html(html);	
		}
	});
});

$(function(){	
	// TOWN선택
	$(".modal-body #local").on("change", function(){
		var localNo = $("option:selected", this).val();
		
		if(localNo == ""){
			$(".modal-body #town").hide();
			return;
		}
		
		$(".modal-body #town").show();
		
		$.ajax({
			url: "selectTown.do",
			data: {localNo : localNo},
			dataType: "json",
			success : function(data){
				var html="<option value=''>세부 지역을 선택하세요</option>";
				
				for(var index in data){
					html += "<option value='"+data[index].TNO +"'>" + data[index].TOWNNAME + "</option></br>";
				}				
				$(".modal-body #town").html(html);
			}			
		});
	});
	
	// 세부 과목 선택
	$(".modal-body #kind").on("change", function(){
		var kindNo = $("option:selected", this).val();
		
		if(kindNo == ""){
			$(".modal-body #sub").hide();
			return;
		}
		
		$(".modal-body #sub").show();
		
		$.ajax({
			url: "selectSubject.do",
			data: {kindNo : kindNo},
			dataType: "json",
			success : function(data){
				var html="<option>세부 과목을 선택하세요</option>";
				
				for(var index in data){
					html += "<option value='"+data[index].SUBNO +"'>" + data[index].SUBJECTNAME + "</option></br>";
				}
				
				$(".modal-body #sub").html(html);
			}			
		});
	});
});
</script>

<input type="hidden" name="sno" id="sno" />

<label for="title">제목 : </label>
<input type="text" name="title" id="title"  value="${lecture.TITLE }"/>
<br />

<!-- 지역 -->
<label for="local">지역 : </label>
<select name="local" id="local">
	<option value="">지역</option>
	<c:if test="${!empty locList}">
		<c:forEach var="loc" items="${locList }" varStatus="vs">
			<c:if test="${lecture.LNO eq loc.LNO }">
				<option value="${lecture.LNO }" selected>${loc.LOCAL }</option>							
			</c:if>
			<c:if test="${lecture.LNO ne loc.LNO }">
				<option value="${loc.LNO }">${loc.LOCAL }</option>	
			</c:if>
		</c:forEach>		
	</c:if>
</select>

<!-- 시,군,구 -->
<select name="tno" id="town">

</select>

<br />

<!-- 카테고리 -->
<label for="kind">카테고리 : </label>
<select name="kind" id="kind"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
	<option value="">과목을 선택하세요.</option>
	
	<c:if test="${!empty kindList }">
		<c:forEach var="kind" items="${kindList }" varStatus="vs">
			<c:if test="${lecture.KNO eq kind.KNO }">
				<option value="${kind.KNO }" selected>${kind.KINDNAME }</option>						
			</c:if>
			<c:if test="${lecture.KNO ne kind.KNO }">
				<option value="${kind.KNO }">${kind.KINDNAME }</option>	
			</c:if>		
		</c:forEach>
	</c:if>
</select>

<!-- 상세 과목 -->
<select name="subno" id="sub">

</select>
<!-- 카테고리 end -->

