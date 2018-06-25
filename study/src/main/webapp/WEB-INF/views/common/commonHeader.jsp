
<div class="banner topBanner">
	<div class="container"></div>
</div>
<div class="adverstingPopup">
	<div class="adverstingPopupCloseBtn closebtn"></div>
</div>

<div class="container adverstingWingWrap">
	<div class="adverstingWing"></div>
</div>
	<header>
		<div class="container">
			<nav class="navbar navbar-expand-lg navbar-light bg-light">
				<a class="navbar-brand" href="${rootPath}"><jsp:include page="/WEB-INF/views/common/logo_blue.jsp"></jsp:include></a>
				<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav mr-auto">
						<li class="nav-item"><a class="nav-link" href="${rootPath }/study/studyList.do">스터디</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/lecture/lectureList.do">강의</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/board/boardList">게시판</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/board/boardWrite">게시글작성</a></li>
						<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> Dropdown </a>
							<div class="dropdown-menu" aria-labelledby="navbarDropdown">
							<c:if test="${memberLoggedIn.mid ne 'manager' }">
								<a class="dropdown-item" href="${rootPath }/admin/adminLogin">어드민</a>
								<div class="dropdown-divider"></div>
							</c:if>
							<c:if test="${memberLoggedIn.mid eq 'manager' }">
								<a class="dropdown-item" href="${rootPath }/admin/adminMain">어드민</a>
							</c:if>
							</div></li>
					</ul>

					<c:if test="${memberLoggedIn == null }">
						<button type="button" class="btn btn-outline-success" data-toggle="modal" data-target="#loginModal">로그인</button> &nbsp; &nbsp;
				<!-- 회원가입 버튼 시작 -->
						<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/member/memberAgreement.do'">회원가입</button>
						<!-- 회원가입 버튼 끝 -->
					</c:if>
					<c:if test="${memberLoggedIn != null }">
						<p>
							<a href="${pageContext.request.contextPath }/member/memberView.do">${memberLoggedIn.mname }</a>님
						</p>
						<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/member/memberLogout.do'">로그아웃</button>

					</c:if>
	</header>