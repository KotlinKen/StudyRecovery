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
		
		<c:if test="${!empty kindList }">
		<c:forEach var="kind" items="${kindList }" varStatus="vs">
			<option value="${kind.KNO }">${kind.KINDNAME }</option>
		</c:forEach>
		
		<c:forEach var="kind" items="${kindList }" varStatus="vs">
			<input type="hidden" value="${kind.KNAMEENAME }" id="ename${kind.KNO }"/>
			<input type="hidden" value="${kind.KINDNAME }" id="kname${kind.KNO }"/>
		</c:forEach>
		</c:if>
	</select>
	<button type="button" id="insertKindBt" onclick="fn_insertKideEnd();">추가</button>
<!-- </div> -->
<div id="sub" class="table-responsive"></div>

<script>

$(function(){
	//kind 리스트를 가져와 select 만듦. 프로그래밍, 회화, 운동 등등..
	 $("#kind").on("change", function(){
		var kindNo = $("option:selected", this).val();
		console.log("?")
		if(kindNo == ""){
			$("#sub").hide();
			return;
		}
		var ename = $("#ename"+kindNo).val();
		var kname = $("#kname"+kindNo).val();
		console.log(ename);
		$("#sub").show();
		$.ajax({
			url: "selectSubject.do",
			data: {kindNo : kindNo},
			dataType: "json",
			success : function(data){
				var html = "";
				html +="<table class=\"table table-striped table-sm\">";
				html +="<thead>";
				html +="<tr>";
				html += "<th>카테고리(한글)</th>";
				html +=	"<th>카테고리(영어)</th>";
				html +=	"<th>과목이름(한글)</th>";
				html += "<th>과목이름(영어)</th>";
				html += "<th>추가/삭제</th>";
				html += "</tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var index in data){
				html +="<tr>";
					html += "<td>"+kname+"</td>"
					html += "<td>"+ename+"</td>"
					html += "<td><input type='text' id='sk"+data[index].SUBNO+"' value='"+data[index].SUBJECTNAME+"' name='subjectname' />"
					html += "<td><input type='text' id='se"+data[index].SUBNO+"' value='"+data[index].SNAMEENAME+"' name='snameename' /></td>"
					html += "<td><button type='button' onclick='fn_changSub("+data[index].SUBNO+");'>변경</button>"
					html += "<button type='button' onclick='fn_deleteSub("+data[index].SUBNO+");'>삭제</button></td>"
				html +="</tr>"
				}
				html += "</tbody>";
				html += "</table>";
				console.log("??")
				html += "<form action=\"instructorSubEnd.do\"  method=\"post\" onsubmit=\"return validateSub();\"> ";
				html += "<input type='hidden'  value='"+kindNo+"' name='subno' />"
				html += "<button type='submit' id='subIn'>submit</button>"
				html += "<button type='button' id='subC' onclick='fn_cancelSub();'>cancel</button>"
				html +="</form>"
				html +="<button type='button' onclick='fn_insertSub();' >추가</button>"
				html +="<button type='button' onclick='fn_deleteKindEnd("+kindNo+");' >분류 삭제</button>"
				$("#sub").html(html);
			}			
		});
	});	
});
function fn_insertSub() {
	var html ="";
	html +="<label class='labelkclass'>과목이름(한글)</label><input type='text' class='subjectkclass' name='subjectname' />";
	html +="<label class='labeleclass'>과목이름(영어)</label><input type='text' class='subjecteclass' name='snameename' /><br />";
	
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
	var subjecteclass = document.getElementsByClassName("subjecteclass");
	console.log(subjecteclass);
	if(subjecteclass == "undefined"){
		return false;
	}
	for(var i =0; i<subjectkclass.length; i++){
		console.log(i);
		if(!englishCheck(subjecteclass[i].value)){
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
	location.href="${rootPath}/adminSub/deleteSubEnd.do?subno="+e;
}
function fn_changSub(e) {
	console.log(e)
	var subjectname = $("#sk"+e).val();
	console.log(subjectname);
	if(!koreanCheck(subjectname)){
		return false;
		console.log("불"+i);
	}
	
	var snameename = $("#se"+e).val();
	console.log(snameename);
	if(!englishCheck(snameename)){
		return false;
		console.log("불"+i);
	}
	location.href="${rootPath}/adminSub/updateSubEnd.do?subno="+e+"&&subjectname="+subjectname+"&&snameename="+snameename;
}
function fn_insertKideEnd() {
	var html ="<form action=\"instructorKindEnd.do\"  method=\"post\" onsubmit=\"return validateKind();\">";
	html +="<label class='labelKkclass'>분류이름(한글)</label><input type='text' class='kindkclass' name='kindname' />";
	html +="<label class='labelKeclass'>분류이름(영어)</label><input type='text' class='kindeclass' name='knameename' /><br />";
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
	

	if(!englishCheck(kindeclass[0].value)){
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
	location.href="${rootPath}/adminSub/deleteKindEnd.do?kno="+e;
		
	}
	
}
</script>

<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />

