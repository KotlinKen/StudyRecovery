<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="DashBoard" name="pageTitle" /></jsp:include>



          <canvas class="my-4 w-100" id="myChart" width="900" height="380"></canvas>
          <canvas class="my-4 w-100" id="myChart2" width="900" height="380"></canvas>


	  <!-- Graphs -->
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
	  <script>
	    var ctx = document.getElementById("myChart");
	    
 
	    
	    
	    
	    
	    
	    
	    
$(function(){	    
	    
	    $.ajax({
			url:"${rootPath}/rest/admin/replyDateStatisticsList",
			dataType:"json",
			success:function(data){
				console.log(data);
				
				
		var dataList = [];
		var ctList = [];
		for(index in data.list){
			
			var dt = data.list[index];
			var dts = dt.RDATE;
			var ct = dt.CNT;
			if(dts !='전체'){
			dataList.push(dts);
			ctList.push(ct);
			}
		}				

		
		console.log(dataList);
		console.log(ctList);
				
		
			    var myChart = new Chart(ctx, {
			        type: 'line',
			        data: {
			            datasets: [{
			                data: ctList
			            }],
			            labels: dataList,
			        },
			        options: {
			            scales: {
			                xAxes: [{
			                    ticks: {
			                        min: 'January'
			                    }
			                }]
			            }
			        }
			    });
				
				
				
			},error:function(){
				console.log("tes");				
				
			}
		});
	    
});
	    
	    
	    
	    
	    
	  </script>
<jsp:include page ="/WEB-INF/views/common/admin_footer.jsp" />