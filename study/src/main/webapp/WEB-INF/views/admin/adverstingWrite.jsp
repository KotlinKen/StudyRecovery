<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="광고작성" name="pageTitle" /></jsp:include>

<form action="${rootPath}/admin/adverstingWriteEnd"  method="post" enctype="multipart/form-data" onsubmit="return validate();">
	<div class="form-row">
		<div class="form-group col-md-2">
			<label for="position">배너위치</label>
			<select id="position" name="position" required class="form-control">
				<option value="TOP" rm-data="test" selected >TOP</option>
				<option value="BANNER">베너</option>
				<option value="POPUP">팝업</option>
				<option value="WINGRIGHT">오른쪽 윙</option> 
			</select>
		</div>
	</div>
	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="inputEmail4">제목</label> <input type="text" class="form-control" id="title" name="title" id="title" placeholder="광고 제목을 입력해주세요" required="required" autocomplete="off">
		</div>
	</div>

	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="content">광고 내용을 간략히 적어주세요.</label>
			<textarea class="form-control" name="content" id="summernote" rows="3" class=""></textarea>
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
			<label for="img1">이미지 <span class="sizeAlert"></span></label> 
			<input type="hidden" name="advImg" value="${adversting.ADVIMG }" />
			<div class="upfile_name">
				<input type="file" class="form-control" id="img1" name="img">
				<div class="upfile_cover">${adversting.ADVIMG }</div>
				<button type="button" class="upfile_button">파일업로드</button>
				<div class="imgSize"></div>
			</div>
		</div>
	</div>
	<div class="form-row">
		<div class="form-group col-md-6">
			<label for="img1">섬네일</label>
			<div class="form-control thumnail" style="display:none;">
			</div>
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
	  <div class="row text-left">
   	   <div class="form-group col-md-3">
	      <button type="button" class="btn btn-primary" onclick="javascript:location.href='${rootPath}/admin/adverstingWrite'">목록</button>
	    </div>
   	   <div class="form-group col-md-3 text-right">
	      <button type="submit" class="btn btn-primary">등록</button>
	    </div>
	  </div>
</form>


<script>
$("#position").on("change", function(){
	var values = $(this).val();
	var text = "";
	switch(values){
		case "TOP" : text = "1110 x 80"; break;
		case "BANNER" : text = "350 x 500"; break;
		case "POPUP" : text = "350 x 500"; break;
		case "WINGRIGHT" : text = "100 x 100"; break;
	}
	$(".sizeAlert").text(text);
});

function validate(){
	console.log("test");
	$title = $("#title").val();
	$img =$("#img1")[0].files[0];
	$sdate = $("#startAd").val();
	$edate = $("#startAd").val();
	
	if($title == "" || $title == null){
		alert("제목 입력해주세요.");
		return false;		
	}
	if($sdate == "" || $sdate == null){
		alert("시작일자를 확인해주세요.");
		return false;		
	}
	if($edate == "" || $edate == null){
		alert("종료일자를 확인해주세요.");
		return false;		
	}
	
	
	
	console.log($title);
	console.log($img);
	console.log($img);
	console.log($date);
	
	
	
	return false;
}

$(function(){
	var startDate = new Date();
	var startDateISO = startDate.toISOString().substring(0, 10);
	var endDate = new Date();
	endDate.setMonth(endDate.getMonth()+1);
	endDateISO = endDate.toISOString().substring(0, 10);
	// 시작날짜 오늘 부터로 초기값 설정
	$("[name=startAd]").val(startDateISO);
	$("[name=startAd]").attr("min", startDateISO);
	// 종료 시간 기본 한달로 초기값 설정
	$("[name=endAd]").val(endDateISO);
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
	
	

//summernote settings
$(document).ready(function() {
    $('#summernote').summernote({
      focus: true,
      height: 500, // 페이지가 열릴때 포커스를 지정함
      callbacks:{
    	  onImageUpload:function(files){
	   	  	  console.log("onImageUpload");
	   		  uploadImage(files[0],this);
      	}
      },
      lang:'ko-KR'
    });
    
  });

	$(document).ready(function() {
	      $('#title').keyup(function(e){
	    	  console.log("test");
	          var content = $(this).val();
	          $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
	          $('#txtcounter').html(content.length + '/300');
	      });
	      $('#title').keyup();
	});
	//summernote upFile
	function uploadImage(file,el){
	    console.log("파일 업로드 함수 호출");
		  var data=new FormData();
		  data.append('file',file);
		  $.ajax({
			  data:data,
			  type:"POST",
			  processData:false,
			  contentType:false,
			  dataType:'json',
			  url:"${rootPath}/admin/uploadImage",
			  cache:false,
			  enctype:'multipart/form-data',
			  success:function(data){ 
			  	  console.log("data : "+data.imageUrl);
			  	  var file=$("<img>").attr("src", "${rootPath }/resources/upload/admin/"+data.imageUrl);
				  $(el).summernote('insertNode', file[0]);
			  },error:function(data){
				  console.log("error:"+data);
			  }
		 });
	}
	
</script>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />