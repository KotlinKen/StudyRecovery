//테이블 hover용
$(function() {
	$(".rm_table tr").on("mouseover", function() {
		$(".rm_table tr").not(this).css({
			"background-color" : "#fff"
		})
		$(this).css({
			"background-color" : "#f6f8fa"
		});
		
	});
	
	
	
	// adversting 
	if($(this).val() == "POPUP"){
		$(".backColorRow").hide();
	}else{
		$(".backColorRow").show();
	}
	
	
	$("#position").change(function(){
		if($(this).val() == "POPUP"){
			$(".backColorRow").hide();
		}else{
			$(".backColorRow").show();
		}
	});
	
	
	$("#startAd, #endAd").on("change", function(){
		$startAd = $("#startAd");
		$endAd = $("#endAd");
		$startAdTemp = $startAd.val();
		if($startAd.val() != null && $startAd.val() != "" ){
			if($(this)[0] == $startAd[0]){
				$endAd.attr("min", $startAd.val());
				
				if($startAd.val() > $endAd.val()){
					$(this).val($endAd.val());
					return alert("종료일 선택 에러 : 종료일보다 클수 없습니다.");
				}
			}else{
				console.log($(this));
				console.log($startAd);
				if($startAd.val() > $endAd.val()){
					$(this).val($startAd.val());
					return alert("종료일 선택 에러 : 시작일보다 작을수 없습니다.");
				}

			}			
		}else{
			
		}
	
	
	});
	
	
	
	$(window).scroll(function(){
		var curpos = $(window).scrollTop();
		if(curpos < 50 ){
			$(".adverstingWing").stop().animate({"top" : 0});
		}
		if(curpos > 100){
			$(".adverstingWing").stop().animate({"top" : curpos-120});
		}
	});
	
});


//천단위
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


