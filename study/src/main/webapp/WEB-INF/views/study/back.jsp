<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="" name="pageTitle"/></jsp:include>






		<div class="row">
			<div class="contentSection col-md-8">
				<div class="sliderSection">
					<div class="levelBox">
						<span class="naming">LEVEL</span> <br />
						<span class="levels"> ${study.DNAME }</span>		
					</div>
					
					<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
						<div class="carousel-inner">
							<c:forEach var="img" items="${imgs }" varStatus="vs">
								<div class="carousel-item ${vs.first? 'active':'' }">
									<img class="d-block w-100 rm_cover_img" src="${pageContext.request.contextPath }/resources/upload/study/${img }" alt="Second slide">
								</div>
							</c:forEach>
						</div>

						<a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev"> <span class="carousel-control-prev-icon" aria-hidden="true"></span> <span class="sr-only">Previous</span>
						</a> <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next"> <span class="carousel-control-next-icon" aria-hidden="true"></span> <span class="sr-only">Next</span>
						</a>

					</div>
				</div>
				
				
				
				
				<div class="studyViewContent">
					<div class="localSection">${study.LNAME } ${study.TNAME }</div>
					<div class="titleSection"><h2>${study.TITLE }</h2></div>
					<div class="studyInfoSection row">
						<div class="col-md-4">스터디 소개</div>
						<div class="col-md-8">${study.CONTENT }</div>
			
					</div>
					<div>3</div>
					<div>4</div>
				</div>

				
				<div>3</div>
				<div>4</div>
			
			
			</div>
			
			<!-- 컨텐트 섹션 끝  -->
			
			
			<div class="wingSection col-md-4">
				<div class="wingWrap"> 
					<div>1</div>
					<div>2</div>
					<div>3</div>
					<div>4</div>
				</div>
			</div>
			
			
		</div>








<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
