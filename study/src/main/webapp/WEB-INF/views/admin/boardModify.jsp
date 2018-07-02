<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="게시물 수정" name="pageTitle" /></jsp:include>
<c:set var = "images" value = "${fn:split(board.UPFILE, ',')}" />




<form action="${rootPath}/admin/boardModifyEnd"  method="post" enctype="multipart/form-data">
	<input type="hidden" name="bno" value="${board.BNO}"/>
	<select name="type" id="boardType" required="required">
		<option value="일반">일반</option>
		<option value="공지">공지</option>
		<option value="faq">FAQ</option>
		<option value="event">이벤트</option>
	</select>
	<input type="hidden" name="oldFileList" class="oldFileList" value="">
	<div class="form-row">
		<div class="form-group col-md-12">
			<label for="inputEmail4">제목</label> <input type="text" class="form-control" id="title" name="title" id="title" value="${board.TITLE}" placeholder="광고 제목을 입력해주세요" required="required" autocomplete="off">
		</div>
	</div>

	<div class="form-row">
		<div class="form-group col-md-12">
			<label for="content">광고 내용을 간략히 적어주세요.</label>
			<textarea class="form-control summernote" name="content" id="summernote" rows="2" class="" required="required">${board.CONTENT}</textarea>
		</div>
	</div>

	<div class="input_fields_wrap">
		<button class="add_field_button">Add More Fields</button>
		<label for="img${g.count}">메인이미지</label> <input type="hidden" />
		<c:forEach var="image" items="${images}" varStatus="g">
		<div class="form-row">
			<div class="form-group col-md-6">
				<div class="upfile_name">
					<input type="file" class="form-control" id="img${g.count}" name="upFile">
					<div class="upfile_cover oldFileName">${image}</div>
					<button type="button" class="upfile_button">파일업로드</button> 
				</div>
			</div>
			<div class="form-group col-md-2"> <a href="#" class="remove_field">Remove</a>  </div>
		</div>
		</c:forEach> 
	</div>
  <button type="submit" class="btn btn-primary" onclick="return boardValidation()">수정</button>
  <button type="button" class="btn btn-cancle" onclick="javascript:location.href='${rootPath}/board/boardView?bno=${board.BNO}'">취소</button>
</form>
</div>
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


function boardValidation(){
	$oldFileList = $(".oldFileList"); // 서버로 넘길때 사용할 FileListName;
	
	$oldFileName = $(".oldFileName"); //
	$oldFiles = $oldFileName.toArray();
	
	$oldFileName  = "";
	
	for(i in $oldFiles ){
		if(i > 0){
			$oldFileName += ",";
		}
		
		$oldFileName += $oldFiles[i].innerText;
	}
	console.log($oldFileName);
	$oldFileList.val($oldFileName);
	$title = $("#title").val().trim();
	$textAreaVal = $("#summernote").val().replace(/(<([^>]+)>)/ig,"");
	
	if($title == ""){
		alert("제목을 입력해 주세요");
		 $("#title").focus();
		return false; 
	}
	
	if($textAreaVal == ""){
		alert("내용을 입력해 주세요");
		$("#summernote").focus();
		return false;
	}


	return true;
	
}



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
$(".input_fields_wrap").on("click", ".upfile_button", function(){
	console.log(this);
	$(this).siblings("[name=upFile]").click();
	
});

$(".input_fields_wrap").on("change", ".upfile_name",  function(){
	
	console.log($(this).find(".upfile_cover"));
	var _URL = window.URL || window.webkitURl;
	
	if($(this).find("input")[0].files[0] != null){
		console.log($(this).find("input")[0].files[0].name);

		var file = $(this).find("input")[0].files[0];
		var img = new Image();
		img.src=_URL.createObjectURL(file);
 
		var name = $(this).find("input")[0].files[0].name.substring(1, 45);
		$(this).find(".upfile_cover").text(name.length >= 43 ? name+"..." : name);
		$(this).find(".upfile_cover").removeClass("oldFileName");
	}
	

});


$("#status").click(function(){
	$status = $("#status");
	if($status.attr("checked") == "checked"){
		$status.removeAttr("checked");
	}else{
		$status.attr("checked", "");
	}
});


$(document).ready(function(){
    var max_fields      = 10; //maximum input boxes allowed
    var wrapper         = $(".input_fields_wrap"); //Fields wrapper
    var add_button      = $(".add_field_button"); //Add button ID
    
    var x = 1; //initlal text box count
    $(add_button).click(function(e){ //on add input button click
        e.preventDefault();
        if(x < max_fields){ //max input box allowed
            x++; //text box increment
            $(wrapper).append('<div class="form-row"><div class="form-group col-md-6"><div class="upfile_name"><input type="file" class="form-control"  name="upFile"/> <div class="upfile_cover"></div>    <button type="button" class="upfile_button">파일업로드</button> </div></div><div class="form-group col-md-2"> <a href="#" class="remove_field">Remove</a>  </div></div>'); //add input box
        }
    });
    
    $(wrapper).on("click",".remove_field", function(e){ //user click on remove text
        e.preventDefault(); $(this).parent().prev().remove();   $(this).parent("div").remove();x--;
    })
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
		  url:"${rootPath}/board/uploadImage",
		  cache:false,
		  enctype:'multipart/form-data',
		  success:function(data){ 
		  	  console.log("data : "+data.imageUrl);
		  	  var file=$("<img>").attr("src", "${rootPath }/resources/upload/board/"+data.imageUrl);
			  $(el).summernote('insertNode', file[0]);
		  },error:function(data){
			  console.log("error:"+data);
		  }
	 });
}
</script>




<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />
