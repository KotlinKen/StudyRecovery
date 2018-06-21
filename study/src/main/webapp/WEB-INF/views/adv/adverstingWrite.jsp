<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<jsp:include page ="/WEB-INF/views/common/header.jsp">
	<jsp:param value="광고등록" name="pageTitle"/>
</jsp:include>


<form action="${rootPath}/adv/adverstingWriteEnd"  method="post" enctype="multipart/form-data">
	<div class="form-row">
		<div class="form-group col-md-2">
			<label for="position">배너위치</label> <select id="position" name="position" class="form-control">
				<option value="TOP" selected>TOP</option>
				<option value="BANNER">베너</option>
				<option value="POPUP">팝업</option>
				<option value="WINGRIGHT">오른쪽 윙</option> 
				<option>윙 3</option>
			</select>
		</div>
	</div>
	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="inputEmail4">제목</label> <input type="text" class="form-control" id="title" name="title" placeholder="광고 제목을 입력해주세요" autocomplete="off">
		</div>
	</div>

	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="content">광고 내용을 간략히 적어주세요.</label>
			<textarea class="form-control" name="content" id="content" rows="3"></textarea>
		</div>
	</div>


	<div class="form-row">
		<div class="form-group col-md-12">
			<div class="custom-control custom-checkbox">
				<input type="checkbox" class="custom-control-input" name="status" id="status" checked> <label class="custom-control-label" for="status">STATUS 사용여부</label>
			</div>
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
	      <input type="text" class="form-control" id="url" name="url" placeholder="링크를 작성해주세요." autocomplete="off">
	    </div>
	</div>
  
	<div class="form-row backColorRow">
	   <div class="form-group col-md-6">
	      <label for="backColor">백보드 컬러</label> 
	      <input type="text" class="form-control" id="backColor" name="backColor" placeholder="보드컬러를 작성해주세요" autocomplete="off" >
	    </div>
	</div>
  <button type="submit" class="btn btn-primary">등록</button>
</form>

<script>
$(function(){
	var startDate = new Date();
	var endDate = new Date();
	endDate.setMonth(endDate.getMonth()+1);
	// 시작날짜 오늘 부터로 초기값 설정
	$("[name=startAd]").val( startDate.toISOString().substring(0, 10));
	// 종료 시간 기본 한달로 초기값 설정
	$("[name=endAd]").val(endDate.toISOString().substring(0, 10));
});


//이미지 섬네일보기 
$("[name=img]").change(function(){
	var img = $(".thumnail");
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
			img.html("<img src='"+reader.result+"' width='100%' />");
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
	
	
	

</script>


<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
