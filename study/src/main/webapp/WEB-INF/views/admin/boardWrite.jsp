<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="BOARD" name="pageTitle" /></jsp:include>
${memberLoggedIn }
	<form action="${rootPath}/board/boardWriteEnd"  method="post" enctype="multipart/form-data">
		<input type="hidden" name="mno" value="${memberLoggedIn.mno}"/>
		<input type="hidden" name="type" value="one"/>
		<div class="form-row">
			<div class="form-group col-md-6">
				<label for="inputEmail4">제목</label> <input type="text" class="form-control" id="title" name="title" id="title" placeholder="광고 제목을 입력해주세요" autocomplete="off">
			</div>
		</div>
	
		<div class="form-row">
			<div class="form-group col-md-6">
				<label for="content">광고 내용을 간략히 적어주세요.</label>
				<textarea class="form-control summernote" name="content" id="summernote" rows="2" class=""></textarea>
			</div>
		</div>
	
	
	
		<div class="input_fields_wrap">
			<button class="add_field_button">Add More Fields</button>
			<div class="form-row">
				<div class="form-group col-md-6">
					<label for="img1">메인이미지</label> <input type="hidden" />
					<div class="upfile_name">
						<input type="file" class="form-control" id="img1" name="upFile">
						<div class="upfile_cover">${adversting.ADVIMG }</div>
						<button type="button" class="upfile_button">파일업로드</button>
					</div>
				</div>
			</div>
		</div>
	
		<div class="form-row">
		   <div class="form-group col-md-6">
		      <label for="url">링크를 작성해주세요.</label> 
		      <input type="text" class="form-control" id="url" name="url" placeholder="링크를 작성해주세요." autocomplete="off">
		    </div>
		</div>
	  <button type="submit" class="btn btn-primary">등록</button>
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

$(".input_fields_wrap").on("change",".upfile_name",  function(){
	
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

	$(document).ready(function() {
	      $('#title').keyup(function(e){
	    	  console.log("test");
	          var content = $(this).val();
	          $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
	          $('#txtcounter').html(content.length + '/300');
	      });
	      $('#title').keyup();
	});
	
	
	$(document).ready(function() {
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
	
	
	
</script>


<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />