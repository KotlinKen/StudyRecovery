<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="MEMBER" name="pageTitle" /></jsp:include>
<div class="studyList">
<!-- 장익순 작업 머리 버튼 설정 시작  -->
 <jsp:include page="/WEB-INF/views/member/admin_member_button.jsp"/>
<!-- 장익순 버튼 설정 끝 -->

<div id="indivik">
		<form action="${pageContext.request.contextPath}/member/agreementAdminEnd.do" method="post" name='mainForm' id='mainForm'>
		<span>서비스 이용약관 동의</span><br />
		<div>
			<c:forEach var ="v" items="${service }">
				<input type="hidden" value="${v.SNO }" name="sno" />  
				<textarea rows="" cols="" id="scontent${v.SNO }" name="scontent">
					${v.SCONTENT } 
				</textarea>
				<button type="button" class="btn btn-outline-success" onclick="fn_serviceChange('${v.SNO }');" >수정</button>
				<button type="button" class="btn btn-outline-success" onclick="fn_serviceDelete('${v.SNO }');" >삭제</button>
				<p id="p-s-ik${v.SNO }"></p>
				<br />
			</c:forEach>
			<button type="button" id="insertSButton" class="btn btn-outline-success" onclick="fn_serviceInsert('01');"><b>+</b></button>
		</div>
		<hr />
		<span>개인정보 수집 및 이요 동의</span> <br />
		<div>
			<c:forEach var ="v" items="${information }">
					<input type="hidden" value="${v.INO }" name="sno" />  
				<textarea rows="3" cols="100" id="icontent${v.INO }">
					${v.ICONTENT } 
				</textarea> 
				<button type="button" class="btn btn-outline-success" onclick="fn_informationChange('${v.INO }');" >수정</button>
				<button type="button" class="btn btn-outline-success" onclick="fn_informationDelete('${v.INO }');" >삭제</button>
				<p id="p-i-ik${v.INO }"></p>
				<br />
			</c:forEach>
			<button type="button" id="insertIButton" class="btn btn-outline-success" onclick="fn_informationInsert();"><b>+</b></button>
		</div>
		<button type="button" id="buttona" class="btn btn-outline-success" onclick="location.href='${rootPath}/admin/adminMember'">돌아가기</button>
		<br /><br />
		</form>
	
</div>
<br /><br />
<script>
	/* history.pushState(null, null, location.href);
	window.onpopstate = function(event) {
	backspace('02');
	};
	function backspace(e) {
		var urlname = "agreementadmin";
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
	} */
	function fn_serviceChange(e) {
		console.log(e);
		var sno = e;
		var scontent =  $("#scontent"+e).val();
		console.log(scontent);
		var data = new FormData();
		data.append("sno", sno);
		data.append("scontent", scontent);
		$.ajax({
			url : "serviceOneAdminEnd.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				var html = "수정되었습니다.";
				$("#p-s-ik"+e).html(html);
			
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
	
	function fn_informationChange(e) {
		console.log(e);
		var ino = e;
		var icontent =  $("#icontent"+e).val();
		console.log(icontent);
		var data = new FormData();
		data.append("ino", ino);
		data.append("icontent", icontent);
		$.ajax({
			url : "informationOneAdminEnd.do",
			data : data,
			contentType : false,
			processData : false,
			type : "POST",
			dataType : "json",
			success : function(date) {
				console.log(date.chack);
				var html = "수정되었습니다.";
				$("#p-i-ik"+e).html(html);
			
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
	
	function fn_serviceDelete(e) {
		var sno = e;
		var data = new FormData();
		data.append("sno", sno);
		$.ajax({
			url : "serviceOneDeleteEnd.do",
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
		
	}
	function fn_informationDelete(e) {
		var ino = e;
		var data = new FormData();
		data.append("ino", ino);
		$.ajax({
			url : "informationOneDeleteEnd.do",
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
		
	}
	var cnt = 0;
	function fn_serviceInsert() {
		console.log(cnt);
		var html = "<textarea name='scontent' id='insertS"+cnt+"' ></textarea>"
		html += "<button type='button' class='btn btn-outline-success' onclick=\"fn_serviceInsertEnd('"+cnt+"');\" >추가하기</button><br/><br/>"
		$("#insertSButton").before(html);
		cnt++;
	}
	function fn_serviceInsertEnd(e) {
		var scontent = $("#insertS"+e).val();
		var data = new FormData();
		data.append("scontent", scontent);
		$.ajax({
			url : "serviceInsertEnd.do",
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
	}
	function fn_informationInsert() {
		console.log(cnt);
		var html = "<textarea name='icontent' id='insertI"+cnt+"' ></textarea>"
		html += "<button type='button' class='btn btn-outline-success' onclick=\"fn_informationInsertEnd('"+cnt+"');\" >추가하기</button><br/><br/>"
		$("#insertIButton").before(html);
		cnt++;
	}
	function fn_informationInsertEnd(e) {
		var icontent = $("#insertI"+e).val();
		var data = new FormData();
		data.append("icontent", icontent);
		$.ajax({
			url : "informationInsertEnd.do",
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
	}


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
		    				rmHtml += "<td>"+ member.MNO+"</td>";
			    			rmHtml += "<td>" +member.MID +"</td>";
			    			rmHtml += "<td>" +member.MNAME+"</td>";
			    			rmHtml += "<td>" +member.PHONE+"</td>";
			    			rmHtml += "<td>" +member.GENDER+"</td>";
			    			rmHtml += "<td>" +member.POINT+"</td>";
			    			rmHtml += "<td>" +member.NPOINT+"</td>";
			    			rmHtml += "<td>" +member.REGDATES+"</td>";
		    			rmHtml += "</tr>";
		    	}
				$(".table-responsive tbody").html(rmHtml);

			},error:function(){
				
			}
		});
	}

	</script>

	<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />

