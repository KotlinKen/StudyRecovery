<jsp:include page="/WEB-INF/views/common/admin_header.jsp"><jsp:param value="DashBoard" name="pageTitle" /></jsp:include>



          <canvas class="my-4 w-100" id="myChart" width="900" height="380"></canvas>
          <canvas class="my-4 w-100" id="myChart2" width="900" height="380"></canvas>

          <h2>Section title</h2>
          <div class="table-responsive">
            <table class="table table-striped table-sm">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Header</th>
                  <th>Header</th>
                  <th>Header</th>
                  <th>Header</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>1,001</td>
                  <td>Lorem</td>
                  <td>ipsum</td>
                  <td>dolor</td>
                  <td>sit</td>
                </tr>
                <tr>
                  <td>1,002</td>
                  <td>amet</td>
                  <td>consectetur</td>
                  <td>adipiscing</td>
                  <td>elit</td>
                </tr>
                <tr>
                  <td>1,003</td>
                  <td>Integer</td>
                  <td>nec</td>
                  <td>odio</td>
                  <td>Praesent</td>
                </tr>
                <tr>
                  <td>1,003</td>
                  <td>libero</td>
                  <td>Sed</td>
                  <td>cursus</td>
                  <td>ante</td>
                </tr>
                <tr>
                  <td>1,004</td>
                  <td>dapibus</td>
                  <td>diam</td>
                  <td>Sed</td>
                  <td>nisi</td>
                </tr>
                <tr>
                  <td>1,005</td>
                  <td>Nulla</td>
                  <td>quis</td>
                  <td>sem</td>
                  <td>at</td>
                </tr>
                <tr>
                  <td>1,006</td>
                  <td>nibh</td>
                  <td>elementum</td>
                  <td>imperdiet</td>
                  <td>Duis</td>
                </tr>
                <tr>
                  <td>1,007</td>
                  <td>sagittis</td>
                  <td>ipsum</td>
                  <td>Praesent</td>
                  <td>mauris</td>
                </tr>
                <tr>
                  <td>1,008</td>
                  <td>Fusce</td>
                  <td>nec</td>
                  <td>tellus</td>
                  <td>sed</td>
                </tr>
                <tr>
                  <td>1,009</td>
                  <td>augue</td>
                  <td>semper</td>
                  <td>porta</td>
                  <td>Mauris</td>
                </tr>
                <tr>
                  <td>1,010</td>
                  <td>massa</td>
                  <td>Vestibulum</td>
                  <td>lacinia</td>
                  <td>arcu</td>
                </tr>
                <tr>
                  <td>1,011</td>
                  <td>eget</td>
                  <td>nulla</td>
                  <td>Class</td>
                  <td>aptent</td>
                </tr>
                <tr>
                  <td>1,012</td>
                  <td>taciti</td>
                  <td>sociosqu</td>
                  <td>ad</td>
                  <td>litora</td>
                </tr>
                <tr>
                  <td>1,013</td>
                  <td>torquent</td>
                  <td>per</td>
                  <td>conubia</td>
                  <td>nostra</td>
                </tr>
                <tr>
                  <td>1,014</td>
                  <td>per</td>
                  <td>inceptos</td>
                  <td>himenaeos</td>
                  <td>Curabitur</td>
                </tr>
                <tr>
                  <td>1,015</td>
                  <td>sodales</td>
                  <td>ligula</td>
                  <td>in</td>
                  <td>libero</td>
                </tr>
              </tbody>
            </table>
          </div>
	  <!-- Graphs -->
	  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
	  <script>
	    var ctx = document.getElementById("myChart");
	    var ctx2 = document.getElementById("myChart2");
	    

	    

	    
	    var myChart = new Chart(ctx2, {
	      type: 'line',
	      data: {
	        labels: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
	        datasets: [{
	          data: [110200, 21345, 39002, 24003, 23489, 103000, 90000],
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
	          display: false,
	        }
	      }
	    });
	    
	    
	    
	    
	    
	    
	    
	    
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