<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>스터디그룹트 관리자 로그인</title>

	<script src="${rootPath}/resources/js/jquery-3.3.1.js"></script>
	<script src="${rootPath}/resources/js/jquery-ui.min.js"></script>
	<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/floating-labels.css" />
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
	<link rel="icon" type="image/x-icon" class="js-site-favicon" href="${rootPath}/resources/images/favicon.ico" />
	<link rel="stylesheet" href="${rootPath}/resources/css/bootstrap/bootstrap.css" />
	<link rel="stylesheet" href="${rootPath}/resources/css/common/init.css" />
	<link rel="stylesheet" href="${rootPath}/resources/css/common/common.css" />
	<link href="https://fonts.googleapis.com/css?family=Tajawal" rel="stylesheet">
	
  </head>



  <body>
    <form class="form-signin" action="${ rootPath }/member/memberLogin" method="post" >
      <div class="text-center mb-4">
        <img class="mb-4" src="${rootPath}/resources/images/logoIcon.svg" alt="" width="72" height="72">
        <h1 class="h3 mb-3 font-weight-normal">Floating labels</h1>
        <p>Managerment Study Grooupts WebSite <a href="https://caniuse.com/#feat=css-placeholder-shown">Works in latest Chrome, Safari, and Firefox.</a></p>
      </div>

      <div class="form-label-group">
        <input type="text" id="userId" class="form-control" placeholder="userId" name="userId" value="${cookie.remember.value }" required autofocus>
        <label for="userId">userId</label>
      </div>

      <div class="form-label-group">
        <input type="password" id="inputPassword" class="form-control" placeholder="Password" name="pwd" required>
        <label for="inputPassword">Password</label>
      </div>
		<input type="hidden" name="admin" value="1" />
      <div class="checkbox mb-3">
        <label>
          <input type="checkbox" name="remember" value="remember-me" ${cookie.remember.value != null ? "checked" : ""}> Remember me
        </label>
      </div>
      <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
      <p class="mt-5 mb-3 text-muted text-center">&copy; 2017-2018</p>
    </form>
  </body>
</html>
