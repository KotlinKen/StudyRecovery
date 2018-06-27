<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${param.pageTitle}</title>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.3.1.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/style.css" />
<style>
.number{display: none;}
</style>
</head>
<body>
<table>
  <tr>
    <th>선택 <input type="checkbox" id="checkAll"/></th>
    <th>아이디</th>
    <th>이름</th>
    <th>경험치 <button type="button" id="expPlus">+</button><button type="button" id="expMinus">-</button> </th>
    <th>점수 <button type="button" id="pointPlus">+</button><button type="button" id="pointMinus">-</button></th>
    <th>지식점수 <button type="button" id="npointPlus">+</button><button type="button" id="npointMinus">-</button></th>
    <th>강사신청여부</th>
  </tr>
<c:forEach var="v" items="${list }" varStatus="vs"> 
  <tr>
	
	<td><input type="checkbox" class = "check" /> <input type="hidden" value="${v.MNO }" /></td>
    <td><a href="">${v.MID }</a></td>
    <td>${v.MNAME }</td>
    <td class="td1" id="td${v.MNO}">${v.EXP } <input type="number" value="${v.EXP }"class="number num1"  /> <input type="hidden" value="${v.MNO }" /> </td>
    <td class="td2" id="point${v.MNO}">${v.POINT }  <input type="number" value="${v.POINT }"class="number num2"/><input type="hidden" value="${v.MNO }" /></td>
    <td class="td3" id="npoint${v.MNO }">${v.NPOINT } <input type="number" value="${v.NPOINT }"class="number num3"/><input type="hidden" value="${v.MNO }" /></td>
    <c:if test="${v.APPROVAL == null }">
    	<td>학생 </td>
    </c:if>
    <c:if test="${v.APPROVAL != null }">
    	<td>${v.APPROVAL eq 'O'?'강사':'강사신청중' } </td>
    </c:if>
  </tr>
</c:forEach>
</table>

<script>
	$("td").click(function () {
		$(".number").css({"display":"none"});
		$(this).find("input").css({"display":"inline-block"});
		$(this).find("input").focus();
	});
	$(".number.num1").blur(function() {
		var exp = $(this).val();
		var mno =  $(this).siblings().val();
	
		var data = new FormData();
		data.append("mno", mno);
		data.append("exp", exp);
		$.ajax({
			url:"changOneEXP.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				location.reload();			
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
		
	});
	$(".number.num2").blur(function() {
		var point = $(this).val();
		var mno =  $(this).siblings().val();
	
		var data = new FormData();
		data.append("point", point);
		data.append("mno", mno);
		$.ajax({
			url:"changOnePOINT.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				location.reload();			
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
		
	});
	$(".number.num3").blur(function() {
		var npoint = $(this).val();
		var mno =  $(this).siblings().val();

		var data = new FormData();
		data.append("npoint", npoint);
		data.append("mno", mno);
		$.ajax({
			url:"changOneNPOINT.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				location.reload();			
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
		
	});
	
	$("#checkAll").click(function () {
		var checkAll = $("#checkAll").prop("checked");

		if(checkAll ==true){
			var check = document.getElementsByClassName("check");
			for(var i = 0; i<check.length;i++ ){

				if(check[i].checked == false){
					check[i].checked = true;
				}
			} 
		}else{
			var check = document.getElementsByClassName("check");
			for(var i = 0; i<check.length;i++ ){

				if(check[i].checked == true){
					check[i].checked = false;
				}
			} 
		}
		
	});
	/* 경험치 */
	$("#expPlus").click(function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				mno.push(c);
			}
		} 
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:"changEXPPLUS.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				for(var i = 0; i<mno.length;i++ ){
					var html = date.list[i].EXP+" <input type=\"number\" value=\"";
					html += date.list[i].EXP+"\"class=\"number num1\"  /> <input type=\"hidden\" value=\"" ;
					html += date.list[i].EXP+"\" />"
					$("#td"+mno[i]).html(html);
				} 
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	});
	$("#expMinus").click(function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				mno.push(c);
			}
		} 
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:"changEXPMINUS.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				for(var i = 0; i<mno.length;i++ ){
					var html = date.list[i].EXP+" <input type=\"number\" value=\"";
					html += date.list[i].EXP+"\"class=\"number num1\"  /> <input type=\"hidden\" value=\"" ;
					html += date.list[i].EXP+"\" />"
					$("#td"+mno[i]).html(html);
				} 
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	});
	/* 성실포인트  */
	$("#pointPlus").click(function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				mno.push(c);
			}
		} 
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:"changPOINTPLUS.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				for(var i = 0; i<mno.length;i++ ){
					var html = date.list[i].POINT+" <input type=\"number\" value=\"";
					html += date.list[i].POINT+"\"class=\"number num1\"  /> <input type=\"hidden\" value=\"" ;
					html += date.list[i].POINT+"\" />"
					$("#point"+mno[i]).html(html);
				} 
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	});
	$("#npointMinus").click(function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				mno.push(c);
			}
		} 
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:"changPOINTMINUS.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				for(var i = 0; i<mno.length;i++ ){
					var html = date.list[i].POINT+" <input type=\"number\" value=\"";
					html += date.list[i].POINT+"\"class=\"number num1\"  /> <input type=\"hidden\" value=\"" ;
					html += date.list[i].POINT+"\" />"
					$("#npoint"+mno[i]).html(html);
				} 
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	});
	/* 지식포인트 */
	$("#npointPlus").click(function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				mno.push(c);
			}
		} 
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:"changNPOINTPLUS.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				for(var i = 0; i<mno.length;i++ ){
					var html = date.list[i].NPOINT+" <input type=\"number\" value=\"";
					html += date.list[i].NPOINT+"\"class=\"number num1\"  /> <input type=\"hidden\" value=\"" ;
					html += date.list[i].NPOINT+"\" />"
					$("#npoint"+mno[i]).html(html);
				} 
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	});
	$("#pointMinus").click(function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				mno.push(c);
			}
		} 
		var data = new FormData();
		data.append("mno", mno);
		$.ajax({
			url:"changNPOINTMINUS.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				for(var i = 0; i<mno.length;i++ ){
					var html = date.list[i].NPOINT+" <input type=\"number\" value=\"";
					html += date.list[i].NPOINT+"\"class=\"number num1\"  /> <input type=\"hidden\" value=\"" ;
					html += date.list[i].NPOINT+"\" />"
					$("#npoint"+mno[i]).html(html);
				} 
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			},
			cache : false,
			processData : false
		});
	});
</script>

</body>
</html>
