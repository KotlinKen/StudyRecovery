<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="BOARD" name="pageTitle" /></jsp:include>



<form action="${rootPath}/admin/adverstingUpdate"  name="adverstingUpdate"  method="post" enctype="multipart/form-data">
	<div class="form-row">
		<div class="form-group col-md-2">
			<label for="position">배너위치</label> <select id="position" name="position" class="form-control">
				<option value="TOP">TOP</option>
				<option value="BANNER" ${("베너" eq adversting.POSITION) ? "selected" : ""}>베너</option>
				<option value="POPUP" ${("POPUP" eq adversting.POSITION) ? "selected" : ""}>팝업</option>
				<option value="WINGRIGHT" ${("WINGRIGHT" eq adversting.POSITION) ? "selected" : ""}>윙 2</option>
				<option ${("윙 3" eq adversting.POSITION) ? "selected" : ""}>윙 3</option>
			</select>
		</div>
	</div>
	<div class="form-row">
		<div class="form-group col-md-12">
			<div class="custom-control custom-checkbox">
				<input type="checkbox" class="custom-control-input" name="status" id="status" ${(adversting.STATUS == 'Y' ? 'checked' : '' )}> <label class="custom-control-label" for="status">STATUS 사용여부</label>
			</div>
		</div>
	</div>
	<div class="form-row">
		<input type="hidden" name="ano" value="${adversting.ANO }" />
		<div class="form-group col-md-6">
			<label for="inputEmail4">제목</label> <input type="text" class="form-control" id="title" name="title" placeholder="광고 제목을 입력해주세요" autocomplete="off" value="${adversting.TITLE}">
		</div>


	</div>
	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="content">광고 내용을 간략히 적어주세요.</label>
			<textarea class="form-control" name="content" id="summernote" rows="3" >${adversting.CONTENT}</textarea>
			${adversting.CONTENT}
		</div>
	</div>




	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="img1">메인이미지</label> <input type="hidden" name="advImg" value="${adversting.ADVIMG }" />
			<div class="upfile_name">
				<input type="file" class="form-control" id="img1" name="img">
				<div class="upfile_cover">${adversting.ADVIMG }</div>
				<button type="button" class="upfile_button">파일업로드</button>
			</div>
		</div>
	</div>
	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="img1">섬네일</label>
			<div class="form-control thumnail">
				<img src="${rootPath}/resources/upload/adversting/${adversting.ADVIMG}" alt="" class="col-md-12 customCols" />
			</div>
			<div class="imgSize">권장 사이즈 1110 x 80</div>
		</div>
	</div>




	<div class="form-row">
		 <div class="form-group col-md-6">
		  <label for="startAd">시작일</label> 
		  <input type="date" class="form-control" name="startAd" id="startAd" />
		</div>
	</div>
	<div class="form-row">
		 <div class="form-group col-md-6">
		  <label for="endAd">종료일</label> 
		  <input type="date" class="form-control" name="endAd" id="endAd" />
		</div>
	</div>
	<div class="form-row">
	   <div class="form-group col-md-6">
	      <label for="url">링크를 작성해주세요.</label> 
	      <input type="text" class="form-control" id="url" name="url" placeholder="링크를 작성해주세요." autocomplete="off" value="${adversting.URL}">
	    </div>
	</div>

   	<div class="form-row backColorRow">
	   <div class="form-group col-md-6">
	      <label for="backColor">백보드 컬러</label> 
	      <input type="text" class="form-control" id="backColor" name="backColor" placeholder="백보드 컬러를 작성해주세요" autocomplete="off" value="${adversting.BACKCOLOR }">
	    </div>
	</div>
  


  <button type="submit" class="btn btn-primary">수정</button>
  <button type="button" class="btn btn-primary" onclick="fn_delete()">삭제</button>
</form>

<script>

function fn_delete(){
	$("[name=adverstingReWrite]").attr("action", "${rootPath}/adv/adverstingDelete");
	$("[name=adverstingReWrite]").submit();
}



$(function(){
	console.log("${adversting.STARTAD}");
	var startDate = "${adversting.STARTDATE}";
	var endDate = "${adversting.ENDDATE}";
	$("[name=startAd]").val(startDate);
	$("[name=endAd]").val(endDate);
	$('.status_checker').prop('indeterminate', true);

});


//이미지 섬네일보기 
$("[name=img]").change(function(){
	var img = $(".thumnail").find("img");
	$file  = $(this)[0].files[0];
	if($file != null){
		var reader = new FileReader();
		reader.readAsDataURL($file);
		//확장자 확인후 진행 여부
		var chk = $(this).val().split(".").pop().toLowerCase();
		if($.inArray(chk, ['gif','png','jpg','jpeg']) == -1){
			alert("이미지만 등록할 수 있습니다.");
			$(this).val("");
			return; 
		}
		reader.onload = function(){
			img.attr("src", reader.result);
		}
	}
});




//첨부파일 클릭
$(".upfile_button").on("click", function(){
	$("#img1").click();
	
});

$(".upfile_name").on("change", function(){
	
	var _URL = window.URL || window.webkitURl;
	
	if($(this).find("input")[0].files[0] != null){
		console.log($(this).find("input")[0].files[0].name);

		
		var file = $(this).find("input")[0].files[0];
		var img = new Image();
		img.src=_URL.createObjectURL(file);
		img.onload = function(){
			console.log(this.width + " ----" + this.height);	
			
			$(".imgSize").text("* 추가한 이미지 사이즈 " + this.width+"px * "+this.height+"px");
		}		
		

		
		var name = $(this).find("input")[0].files[0].name.substring(1, 45);
		$(this).find(".upfile_cover").text(name.length >= 43 ? name+"..." : name);
		
	}
});


//체크박스 컨트
	
	$("#status").click(function(){
		$status = $("#status");
		console.log($status.attr("checked"));
		if($status.attr("checked") == "checked"){
			$status.removeAttr("checked");
		}else{
			$status.attr("checked", "");
		}
		
	});

	$(document).ready(function() {
	    $('#summernote').summernote({
	      focus: true,
	      height: 500// 페이지가 열릴때 포커스를 지정함
	    });
	  });
</script>




<div class="studyList">
	<div class="table-responsive">
		<table class="table table-striped table-sm">
			<thead>
				<tr>
					<th>No</th>
					<th>제목</th>
					<th>내용</th>
					<th>이미지</th>
					<th>링크</th>
					<th>위치</th>
					<th>상태</th>
					<th>컬러</th>
					<th>시작일</th>
					<th>종료일</th>
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
</div>


<script>
$(function(){
	loadData("all", 1, 5);
});

function loadData(type, cPage, pageBarSize){
	$.ajax({
		url:"${rootPath}/rest/adversting/"+type+"/"+cPage+"/"+pageBarSize,
		dataType:"json",
		success:function(data){
			console.log(data);
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
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor(\'all\,'+(pageNo-1)+','+5+')">Previous</a></li>';
			}
			while(!(pageNo > pageEnd || pageNo > totalPage)){
				console.log("test");
				pageNation += '<li class="page-item"><a class="page-link '+ ( pageNo == cPage ? "currentPage" : "" )+'" href="javascript:loadInstructor(\'all\,'+pageNo+','+5+')">'+pageNo+'</a></li>';
				pageNo++;
			}
			//다음 버튼
			
			if(pageNo > totalPage){
				pageNation += '<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>';
			}else{
				pageNation += '<li class="page-item"><a class="page-link" href="javascript:loadInstructor(\'all\','+pageNo+','+5+')">Next</a></li>';
			}
			
			//페이지 버튼 생성
			$pagination.html(pageNation);
			
			console.log(data);
			var rmHtml = "";
			var adversting = null;
	    	for(index in data.list){
	    		adversting = data.list[index];
	    		var upfile = (data.list[index].UPFILE);
	    			rmHtml += "<tr onclick=fn_adverstingView("+adversting.ANO+")>"
	    				rmHtml += "<td>"+adversting.ANO+"</td>";
		    			rmHtml += "<td>" +adversting.TITLE +"</td>";
		    			rmHtml += "<td>" +(adversting.CONTENT.replace(/(<([^>]+)>)/ig,"")).substring(0,10)+"</td>";
		    			rmHtml += "<td>" +adversting.ADVIMG+"</td>";
		    			rmHtml += "<td>" +adversting.URL+"</td>";
		    			rmHtml += "<td>" +adversting.POSITION+"</td>";
		    			rmHtml += "<td>" +adversting.STATUS+"</td>";
		    			rmHtml += "<td>" +adversting.BACKCOLOR+"</td>";
		    			rmHtml += "<td>" +adversting.STARTDATE+"</td>";
		    			rmHtml += "<td>" +adversting.ENDDATE+"</td>";
	    			rmHtml += "</tr>";
	    	}
			$(".table-responsive tbody").html(rmHtml);

		},error:function(){
			
		}
	});
}

</script>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />