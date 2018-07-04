<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script src="${rootPath}/resources/js/jquery-3.3.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="${rootPath}/resources/js/jquery-ui.min.js"></script>
<script src="${rootPath}/resources/js/bootstrap.min.js"></script>
<script src="${rootPath}/resources/js/common.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.js"></script>
<link rel="icon" type="image/x-icon" class="js-site-favicon" href="${rootPath}/resources/images/favicon.ico" />
<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/bootstrap.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/common/init.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/dashboard.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/adminCustomRm.css" />
<link rel="stylesheet" href="${rootPath}/resources/css/common/common.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote-bs4.css" rel="stylesheet">

<link href="https://fonts.googleapis.com/css?family=Tajawal" rel="stylesheet">

<body>
	<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
		<a class="navbar-brand col-sm-3 col-md-2 mr-0" href="${rootPath }/admin/adminMain">
			<jsp:include page="/WEB-INF/views/common/logo.jsp"></jsp:include>
		</a> 

		<ul class="navbar-nav px-1">
			<!-- 없을때 처리 필요 -->
			<li class="nav-item text-nowrap"><span class="profile" style='background-image:url(${rootPath}/resources/upload/member/${memberLoggedIn.mprofile })'></span></li>
			<li class="nav-item text-nowrap"><a class="nav-link sign" href="${rootPath }/member/memberLogout.do">Sign out</a></li>
		</ul>
	</nav>
	<div class="container-fluid">
		<div class="row">
			<nav class="col-md-2 d-none d-md-block bg-light sidebar">
				<div class="sidebar-sticky">
					<ul class="nav flex-column">
						<li class="nav-item"><a class="nav-link ${fn:contains(where, 'admin/adminMain') ? 'active' : ''}" href="${rootPath }/admin/adminMain"> <span data-feather="home"></span> Dashboard <span class="sr-only">(current)</span>
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'Study') ? 'active' : ''}" href="${rootPath }/admin/adminStudy"> <span data-feather="file"></span> 스터디
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'ecture') ? 'active' : ''}" href="${rootPath }/admin/adminLecture"> <span data-feather="file"></span> 강의
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'ember') ? 'active' : ''}" href="${rootPath }/admin/adminMember"> <span data-feather="users"></span> 회원
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'structor') ? 'active' : ''}" href="${rootPath }/admin/adminInstructor"> <span data-feather="users"></span> 강사
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'board') ? 'active' : ''}" href="${rootPath }/admin/boardList"> <span data-feather="layers"></span> 게시판
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'adversting') ? 'active' : ''}" href="${rootPath }/admin/adverstingList"> <span data-feather="layers"></span> 광고관리
						</a></li> 
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'statistics') ? 'active' : ''}" href="${rootPath }/admin/adminStatistics"> <span data-feather="layers"></span> 통계
						</a></li>
						<li class="nav-item"><a class="nav-link  ${fn:contains(where, 'payment') ? 'active' : ''}" href="${rootPath }/admin/adminPayment.do"> <span data-feather="layers"></span> 결제
						</a></li>
					</ul>

					<h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
						<span>Saved reports</span> <a class="d-flex align-items-center text-muted" href="#"> <span data-feather="plus-circle"></span>
						</a>
					</h6>
					<ul class="nav flex-column mb-2">
						<li class="nav-item"><a class="nav-link" href="#"> <span data-feather="file-text"></span> Current month
						</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath }/admin/restSessions"> <span data-feather="file-text"></span> 현재 접속자
						</a></li>
						<li class="nav-item"><a class="nav-link" href="${rootPath}/"> <span data-feather="file-text"></span> 홈으로
						</a></li>
					</ul>
				</div>
			</nav>
			<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
			<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
				<h1 class="h2">${param.pageTitle}</h1>
				<div class="btn-toolbar mb-2 mb-md-0"  style="display:none;">
					<div class="btn-group mr-2">
						<button class="btn btn-sm btn-outline-secondary" >글쓰기</button>
						<button class="btn btn-sm btn-outline-secondary">Export</button>
					</div>
					<button class="btn btn-sm btn-outline-secondary dropdown-toggle">
						<span data-feather="calendar"></span> This week
					</button>
				</div>
			</div>