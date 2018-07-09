<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="CATEGORY" name="pageTitle" /></jsp:include>
<style>

#kinddiv{display: block; position: absolute; top:0px; width: 500px;}
#sub{display: none;display: block; position:  absolute; top: 100px; left: 100px; width: 700px; }
.chngeSub{position: relative; top: -15px; right: 0px; width: 35%;}
</style>
<div class="form-check-inline form-check" id="divdd">
<!-- <div id="kinddiv"> -->
	<select name="kno" id="kind" class="custom-select"> <!-- kind선택시 ajax로 그에 맞는 과목 가져오기 -->
		<option value="-1">과목을 선택하세요.</option>
		
		<c:if test="${!empty list }">
		<c:forEach var="v" items="${list }" varStatus="vs">
			<option value="${v.LNO }">${v.LOCAL }</option>
		</c:forEach>
		<c:forEach var="v" items="${list }" varStatus="vs">
			<input type="hidden" value="${v.LOCAL }" id="load${v.LNO }">

		</c:forEach>
		
		</c:if>
	</select>
	<button type="button" id="insertKindBt" onclick="fn_insertKideEnd();">추가</button>
<!-- </div> -->
<div id="sub" class="table-responsive"></div>

<script>

$(function(){

	 $("#kind").on("change", function(){
		var lno = $("option:selected", this).val();
		console.log("?")
		if(lno == ""){
			$("#sub").hide();
			return;
		}
		var lname = $("#load"+lno).val();
		
		console.log(lname); 
		$("#sub").show();
		$.ajax({
			url: "selectTown.do",
			data: {lno : lno},
			dataType: "json",
			success : function(data){
				var html = "";
				html +="<table class=\"table table-striped table-sm\">";
				html +="<thead>";
				html +="<tr>";
				html += "<th>도/특별시/광역시</th>";
				html +=	"<th>시/구</th>";
				html += "<th>추가/삭제</th>";
				html += "</tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var index in data){
				html +="<tr>";
					html += "<td>"+lname+"</td>" 
					html += "<td><input type='text' id='sk"+data[index].TNO+"' value='"+data[index].TOWNNAME+"' name='subjectname' />"
					html += "<td><button type='button' onclick='fn_changSub("+data[index].TNO+");'>변경</button>"
					html += "<button type='button' onclick='fn_deleteSub("+data[index].TNO+");'>삭제</button></td>"
				html +="</tr>"
				}
				html += "</tbody>";
				html += "</table>";
				console.log("??")
				html += "<form action=\"instructorTownEnd.do\"  method=\"post\" onsubmit=\"return validateSub();\"> ";
				html += "<input type='hidden'  value='"+lno+"' name='lno' />"
				html += "<button type='submit' id='subIn'>submit</button>"
				html += "<button type='button' id='subC' onclick='fn_cancelSub();'>cancel</button>"
				html +="</form>"
				html +="<button type='button' onclick='fn_insertSub();' >추가</button>"
				html +="<button type='button' onclick='fn_deleteKindEnd("+lno+");' >분류 삭제</button>"
				$("#sub").html(html);
			}			
		});
	});	
});
function fn_insertSub() {
	var html ="";
	html +="<label class='labelkclass'>지역(시/구)</label><input type='text' class='subjectkclass' name='townname' />";
	$("#subIn").before(html);
}
function fn_cancelSub() {
	console.log("지우기");
	$(".labelkclass").last().remove();
	$(".labeleclass").last().remove();
	$(".subjectkclass").last().remove();
	$(".subjecteclass").last().remove();
	
}
function validateSub() {
	var subjectkclass = document.getElementsByClassName("subjectkclass");
	console.log(subjectkclass);
	if(subjectkclass == "undefined"){
		return false;
	}
	for(var i =0; i<subjectkclass.length; i++){
		console.log(i)
		if(!koreanCheck(subjectkclass[i].value)){
			return false;
			console.log("불"+i);
		}
	}
	
	console.log("합");
	return true;
}

function koreanCheck(name) {
	console.log(name);

	if (name.trim() == 0) {
		return false;
	}
	if (name.indexOf(" ") >= 0) {
		return false;
	}
	if (name.search(/[ㄱ-ㅎ|ㅏ-ㅣ]/g) != -1 ) {
		return false;
	}
	if (name.search(/[a-z|A-Z]/g) != -1) {
		return false;
	}
	
	return true;
}
function englishCheck(name) {
	console.log(name);
	
	if (name.trim() == 0) {
		return false;
	}
	if (name.indexOf(" ") >= 0) {
		return false;
	}
	if(name.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g) != -1){
		return false;
	}
	
	return true;
}
function fn_deleteSub(e) {
	location.href="${rootPath}/adminSub/deleteTownEnd.do?tno="+e;
}
function fn_changSub(e) {
	console.log(e)
	var townname = $("#sk"+e).val();
	console.log(townname);
	if(!koreanCheck(townname)){
		return false;
		console.log("불"+i);
	}
	
	location.href="${rootPath}/adminSub/updateTownEnd.do?tno="+e+"&&townname="+townname;
}
function fn_insertKideEnd() {
	var html ="<form action=\"instructorLocalEnd.do\"  method=\"post\" onsubmit=\"return validateKind();\">";
	html +="<label class='labelKkclass'>도/특별시/광역시</label><input type='text' class='kindkclass' name='local' /><br/>";
	html += "<button class='pbtnclass' type='submit'>추가</button>"
	html += "<button class='mbtnclass' type='button' onclick='fn_cancelKindEnd();'>취소</button></form>"
	$("#insertKindBt").before(html);
}
function validateKind() {
	var kindkclass = document.getElementsByClassName("kindkclass");
	console.log(kindkclass);

	if(!koreanCheck(kindkclass[0].value)){
		return false;
		console.log("불"+i);
	}

	console.log("합");
	return true;
}
function fn_cancelKindEnd() {
	$(".kindkclass").remove();
	$(".kindeclass").remove();
	$(".labelKkclass").remove();
	$(".labelKeclass").remove();
	$(".pbtnclass").remove();
	$(".mbtnclass").remove();
}
function fn_deleteKindEnd(e) {
	if(confirm("분류를 지우시겠습니까?")){
	location.href="${rootPath}/adminSub/deleteLocalEnd.do?lno="+e;
		
	}
	
}
</script>

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />

