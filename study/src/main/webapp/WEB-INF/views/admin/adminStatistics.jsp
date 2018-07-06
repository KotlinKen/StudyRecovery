<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="STATISTICS" name="pageTitle" /></jsp:include>
<style>
.statistics .row{margin-bottom:80px;}
.statis_title{font-size:1.6rem; margin-bottom:30px; }
</style>
<div class="container-fluid statistics" >
  <div class="row">
    <div class="col-sm">
      <div class="statis_title">일자별 댓글수</div>
      <canvas id="myChart" width="400" height="150"></canvas>
    </div>
    <div class="col-sm">
    </div>
  </div>
  <div class="row">
    <div class="col-sm">
      <div class="statis_title">스터디/강의 일자별 등록수</div>    
      <canvas id="myChart2" width="400" height="150"></canvas>
    </div>
    <div class="col-sm">
    </div>
  </div>
  <div class="row">
    <div class="col-sm">
      <div class="statis_title">남/녀 일자별 가입수</div>    
      <canvas id="memberCount" width="400" height="150"></canvas>
    </div>
    <div class="col-sm">
      
    </div>
  </div>
</div>

	  <!-- Graphs -->
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
	  <script>
	    var ctx = document.getElementById("myChart");
	    var ctx2 = document.getElementById("myChart2");
	    var memberCount = document.getElementById("memberCount");
	    
	    
	    
	    
	    $.ajax({
			url:"${rootPath}/rest/admin/statistics",
			dataType:"json",
			data:{table : "study", start : "20180601", end : "20180730"},
			success:function(data){
				var dateList = [];
				var countList = [];
				for(index in data.list){
					var dt = data.list[index];
					var dts = dt.RDATE;
					var ct = dt.CNT;
					
					if(dts !='전체'){
						dateList.push(dts);
						countList.push(ct);
					}
				}
	
	    
	    
	    var myChart = new Chart(ctx2, {
	      type: 'line',
	      data: {
	        labels: dateList,
	        datasets: [{
        	label : 'STUDY',
	          data: countList,
	          lineTension: 0,
	          backgroundColor: 'transparent',
	          borderColor: '#007bff',
	          borderWidth: 2,
	          pointBackgroundColor: '#007bff'
	        }]
	      },
	      options: {
	        scales: {
	          yAxes: [{
	            ticks: {
	              beginAtZero: true
	            }
	          }]
	        },
	        legend: {
	          display: true,
	        }
	      }
	    });
			} //석세스
	    });
	    
	    
	    
	    
	    
	    
	    
$(function(){	  
	
	
	
	
    $.ajax({
		url:"${rootPath}/rest/admin/statistics",
		dataType:"json",
		data:{table : "member", start : "20180601", end : "20180730", gender : "M"},
		success:function(data){
			console.log(data);
			var memberListMale = [];
			var memberListMaleCount = [];
			for(index in data.list){
				var dt = data.list[index];
				var dts = dt.RDATE;
				var ct = dt.CNT;
				
				if(dts !='전체'){
					memberListMale.push(dts);
					memberListMaleCount.push(ct);
				}
			}	
			
		    $.ajax({
				url:"${rootPath}/rest/admin/statistics",
				dataType:"json",
				data:{table : "member", start : "20180601", end : "20180730", gender : "F"},
				success:function(data){
					console.log(data+"member");
					console.log(data);
					var memberListFemale = [];
					var memberListFemaleCount = [];
					for(index in data.list){
						var dt = data.list[index];
						var dts = dt.RDATE;
						var ct = dt.CNT;
						if(dts !='전체'){
							memberListFemale.push(dts);
							memberListFemaleCount.push(ct);
							
						}
					}	
	
			
			
		    var myChart2 = new Chart(memberCount, {
			      type: 'line',
			      data: {
			        labels: memberListFemale,
			        datasets: [{
			          label : 'Male',
			          data: memberListMaleCount,
			          lineTension: 0,
			          backgroundColor: 'transparent',
			          borderColor: '#007bff',
			          borderWidth: 2,
			          pointBackgroundColor: '#007bff'
			        },{
			          label : 'Female',
			          data: memberListFemaleCount,
			          lineTension: 0,
			          backgroundColor: 'transparent',
			          borderColor: '#ff149d',
			          borderWidth: 2,
			          pointBackgroundColor: '#ff149d'
			        }]
			      },
			      options: {
			        scales: {
			          yAxes: [{
			            ticks: {
			              beginAtZero: true
			            }
			          }]
			        },
			        legend: {
			          display: true,
			        }
			      }
			    });
			
			
			
			
				}
		    });// member Female
			
			
		}// member Male
    });
    


		
		
		
		

	
	    
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
			            	label : 'reply count',
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

