<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="MEMBER" name="pageTitle" /></jsp:include>

<div class="studyList">
<!-- 장익순 작업 머리 버튼 설정 시작  -->
 <jsp:include page="/WEB-INF/views/member/admin_member_button.jsp"/>
<!-- 장익순 버튼 설정 끝 -->

	<div class="table-responsive">
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>선택 <input type="checkbox" id="checkAll"/></th>
					<th>아이디</th>
					<th>이름</th>
					<th>경험치 <button type="button" id="expPlus">+</button><button type="button" id="expMinus">-</button> </th>
					<th>점수 <button type="button" id="pointPlus">+</button><button type="button" id="pointMinus">-</button></th>
					<th>지식점수 <button type="button" id="npointPlus">+</button><button type="button" id="npointMinus">-</button></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<nav aria-label="Page navigation example">
		<ul class="pagination">
			<li class="page-item"><a class="page-link" href="#">Next</a></li>
		</ul>
	</nav>
	

<script>
$(function(){
	loadInstructor(1, 5, "member");
});

function loadInstructor(cPage, pageBarSize, type){
	$.ajax({
		url:"${rootPath}/rest/member/"+type+"/"+cPage+"/"+pageBarSize,
		dataType:"json",
		success:function(data){
			
			var numPerPage = data.numPerPage;
			var cPage = data.cPage;
			var total = data.total;
			var totalPage = Math.ceil(parseFloat(total)/numPerPage);
			var pageNo = (Math.floor((cPage - 1)/parseFloat(pageBarSize))) * pageBarSize +1;
			var pageEnd = pageNo + pageBarSize - 1;
			var pageNation ="";
			
			$pagination = $(".pagination");
			
			if(pageNo == 1 ){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+(pageNo-1)+','+5+',\'member\')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadInstructor('+pageNo+','+5+',\'member\')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor('+pageNo+','+5+',\'member\')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var member = null;
	    	for(index in data.list){
	    		member = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr>"
	    				rmHtml += "<td><input type=\"checkbox\" class = \"check\" /> <input type=\"hidden\" value=\" "+member.MNO+ " \" /></td>";
		    			rmHtml += "<td><a href=\"${rootPath }/member/memberSelectONEView.do?mid="+member.MID+"\">" +member.MID +"</a></td>";
		    			rmHtml += "<td>" +member.MNAME+"</td>";
		    			rmHtml += "<td class=\"td1\" id=\"tdexp"+member.MNO+"\"> <input type=\"number\" value=\""+member.EXP+ "\" id=\"exp"+member.MNO+"\" class=\"number num1\" max=\"1000\" min=\"0\"  /> <br/><button type=\"button\" id=\"insertIButton\" class=\"btn btn-outline-success \" onclick=\"fn_expInsert('"+member.MNO+"');\">변경</button> <button type=\"button\" id=\"insertIButton\" class=\"btn btn-outline-success \" onclick=\"fn_expCancel('"+member.MNO+"','"+member.EXP+"');\">되돌리기</button></td>";
		    			rmHtml += "<td class=\"td2\" id=\"tdpoint"+member.MNO+"\"> <input type=\"number\" value=\""+member.POINT+ "\" id=\"point"+member.MNO+"\" class=\"number num2\" max=\"100000\" min=\"-100000\"  /> <br/> <button type=\"button\" id=\"insertIButton\" class=\"btn btn-outline-success \" onclick=\"fn_pointInsert('"+member.MNO+"');\">변경</button> <button type=\"button\" id=\"insertIButton\" class=\"btn btn-outline-success \" onclick=\"fn_pointCancel('"+member.MNO+"','"+member.POINT+"');\">되돌리기</button></td>";
		    			rmHtml += "<td class=\"td3\" id=\"tdnpoint"+member.MNO+"\"> <input type=\"number\" value=\""+member.NPOINT+ "\" id=\"npoint"+member.MNO+"\" class=\"number num3\" max=\"100000\" min=\"0\"  />  <br/> <button type=\"button\" id=\"insertIButton\" class=\"btn btn-outline-success \" onclick=\"fn_npointInsert('"+member.MNO+"');\">변경</button> <button type=\"button\" id=\"insertIButton\" class=\"btn btn-outline-success \" onclick=\"fn_npointCancel('"+member.MNO+"','"+member.NPOINT+"');\">되돌리기</button>";
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);
			document.getElementById("checkAll").checked = false;
		},error:function(){
			
		}
	});
}
/* 경험치 */
function fn_expInsert(mno) {
	var exp = $("#exp"+mno).val(); 
	exp = Math.floor(exp);
	if(exp<0){
		exp = 0;
		$("#exp"+mno).val(0); 
	}
	if(exp>1000){
		exp = 1000;
		$("#exp"+mno).val(1000); 
	}
	var data = new FormData();
	data.append("mno", mno);
	data.append("exp", exp);
	console.log(exp)
	$.ajax({
		url:"changOneEXP.do",
		data : data,
		contentType : false,
		processData : false,
		type : "POST",
		dataType : "json",
		success : function(date) {
			$("#exp"+mno).val(exp);
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
}
function fn_expCancel(mno,exp) { 
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
			$("#exp"+mno).val(exp);
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
}
/* 포인트 */
function fn_pointInsert(mno) {
	var point = $("#point"+mno).val();
	point = Math.floor(point);
	if(point<-100000){
		point = -100000;
		$("#point"+mno).val(-100000); 
	}
	if(point > 100000){
		point = 100000;
		$("#point"+mno).val(100000);
	}
	var data = new FormData();
	data.append("mno", mno);
	data.append("point", point);
	$.ajax({
		url:"changOnePOINT.do",
		data : data,
		contentType : false,
		processData : false,
		type : "POST",
		dataType : "json",
		success : function(date) {
			$("#point"+mno).val(point);
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
}
function fn_pointCancel(mno,point) {
	var data = new FormData();
	data.append("mno", mno);
	data.append("point", point);
	$.ajax({
		url:"changOnePOINT.do",
		data : data,
		contentType : false,
		processData : false,
		type : "POST",
		dataType : "json",
		success : function(date) {
			$("#point"+mno).val(point);
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
}
/* 지식포인트 */
function fn_npointInsert(mno) {
	var npoint = $("#npoint"+mno).val();
	npoint = Math.floor(npoint);
	if(npoint <-100000){
		npoint = -100000;
		$("#npoint"+mno).val(-100000);
	}
	if(npoint > 100000){
		npoint = 100000;
		$("#npoint"+mno).val(100000);
	}
	var data = new FormData();
	data.append("mno", mno);
	data.append("npoint", npoint);
	$.ajax({
		url:"changOneNPOINT.do",
		data : data,
		contentType : false,
		processData : false,
		type : "POST",
		dataType : "json",
		success : function(date) {
			$("#npoint").val(npoint);
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
}
function fn_npointCancel(mno,npoint) {
	var data = new FormData();
	data.append("mno", mno);
	data.append("npoint", npoint);
	$.ajax({
		url:"changOneNPOINT.do",
		data : data,
		contentType : false,
		processData : false,
		type : "POST",
		dataType : "json",
		success : function(date) {
			$("#npoint"+mno).val(npoint);
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
}
	
$(function(){	
	$("#checkAll").on("click",function () {
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
	$("#expPlus").on("click",function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				var id = ("#exp"+c).replace(" ","");
				var exp = $(id).val(); 
				exp = Math.floor(exp);
				console.log("#exp"+c);
				console.log(exp);
				if(exp+10 <1000){
					console.log("");
					mno.push(c);
					console.log(c);
				}
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
					console.log(mno[i]);
					console.log(date.list[i].EXP);
					var mn = mno[i];
					console.log(mn);
					var id = ("#exp"+mno[i]).replace(" ","");
					console.log(id);
					console.log($(id).val());
					$(id).val(date.list[i].EXP);
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
				var id = ("#exp"+c).replace(" ","");
				var exp = $(id).val();
				exp = Math.floor(exp);
				console.log("#exp"+c);
				console.log(exp);
				if(exp-10>0){
					console.log("");
					mno.push(c);
					console.log(c);
				}
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
					console.log(mno[i]);
					console.log(date.list[i].EXP);
					var mn = mno[i];
					console.log(mn);
					var id = ("#exp"+mno[i]).replace(" ","");
					console.log(id);
					console.log($(id).val());
					$(id).val(date.list[i].EXP);
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
				var id = ("#point"+c).replace(" ","");
				var point = $(id).val(); 
				point = Math.floor(point);
				console.log("#point"+c);
				console.log(point);
				if(point+1000 <100000){
					console.log("");
					mno.push(c);
					console.log(c);
				}
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
					console.log(mno[i]);
					console.log(date.list[i].POINT);
					var mn = mno[i];
					console.log(mn);
					var id = ("#point"+mno[i]).replace(" ","");
					console.log(id);
					console.log($(id).val());
					$(id).val(date.list[i].POINT);
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
	$("#pointMinus").on("click",function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
				$("#div2").fadeOut("slow");
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				var id = ("#point"+c).replace(" ","");
				var point = $(id).val(); 
				point = Math.floor(point);
				console.log("#point"+c);
				console.log(point);
				if(point-1000>-100000){
					console.log("");
					mno.push(c);
					console.log(c);
				}
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
				console.log("");
				for(var i = 0; i<mno.length;i++ ){
					console.log(mno[i]);
					console.log(date.list[i].POINT);
					var mn = mno[i];
					console.log(mn);
					var id = ("#point"+mno[i]).replace(" ","");
					console.log(id);
					console.log($(id).val());
					$(id).val(date.list[i].POINT);
				} 
			},
			error : function(jqxhr, textStatus,errorThrown) {
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
				var id = ("#npoint"+c).replace(" ","");
				var npoint = $(id).val(); 
				npoint = Math.floor(npoint);
				console.log("#point"+c);
				console.log(npoint);
				if(npoint+1000<100000){
					console.log("");
					mno.push(c);
					console.log(c);
				}
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
					console.log(mno[i]);
					console.log(date.list[i].NPOINT);
					var mn = mno[i];
					console.log(mn);
					var id = ("#npoint"+mno[i]).replace(" ","");
					console.log(id);
					console.log($(id).val());
					$(id).val(date.list[i].NPOINT);
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
	$("#npointMinus").on("click",function () {
		var check = [];
		var mno = [];
		var check = $(".check");
		for(var i = 0; i<check.length;i++ ){
			if(check[i].checked == true){
				var c = $(check[i]).siblings().val();
				var id = ("#npoint"+c).replace(" ","");
				var npoint = $(id).val(); 
				npoint = Math.floor(npoint);
				console.log("#point"+c);
				console.log(npoint);
				if(npoint-1000>-100000){
					console.log("");
					mno.push(c);
					console.log(c);
				}
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
					console.log(mno[i]);
					console.log(date.list[i].NPOINT);
					var mn = mno[i];
					console.log(mn);
					var id = ("#npoint"+mno[i]).replace(" ","");
					console.log(id);
					console.log($(id).val());
					$(id).val(date.list[i].NPOINT);
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
});
</script>


<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />






<%-- <c:forEach var="v" items="${list }" varStatus="vs"> 
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
</c:forEach> --%>

<%-- history.pushState(null, null, location.href);
	window.onpopstate = function(event) {
	backspace('02');
	};
	function backspace(e) {
		var urlname = "memberlist";
		var data = new FormData();
		data.append("urlname", urlname);
		$.ajax({
	    	url:"adminInnerCheck.do",
	    	type:"POST",
	    	data : data,
	    	contentType : false,
			processData : false,
	    	dataType : "json",
	    	success : function (data) {
	    		if(e=='02'){
	    			history.back(2);
	    		}else{
	    		location.href="${pageContext.request.contextPath}"
	    			
	    		}
			},error : function (jqxhr,textStatus,textStatus) {
				console.log(jqxhr);
				console.log(textStatus);
				console.log(textStatus);
			}
	    });
	} 
	
	
		/* $(".number.num1").blur(function() {
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
		
	});*/--%>
