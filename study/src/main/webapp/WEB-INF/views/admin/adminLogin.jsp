<style>
* {
	box-sizing: border-box;
}

.inputer {
	padding: 13px;
	margin-bottom: 20px;
	width: 100%;
	outline: none;
	font-size: 28px;
	vertical-align: middle;
	box-shadow: none;
	-webkit-box-shadow: none;
	-webkit-appearance: none;
	border:1px solid #ececec;
}


.inputer:focus {
	box-shadow: none;
	-webkit-box-shadow: none;
	outline:none;
	border-color:#ff1969;
}

.wrap {
	width: 980px;
	margin: 0 auto;
	text-align: center;
}

.login_form {
	width: 440px;
	border: 1px solid #ececec;
	padding: 30px 60px 30px 60px;
	margin-top: 100px;
	display: inline-block;
	border-top: 3px solid #ff1969
}

.login_form h2 {
	font-weight: normal
}

button {
	background: #ff1969;
	border: none;
	font-size: 26px;
	padding: 20px 10px;
	color: #fff;
	width: 100%;
}

#saveIdWrap{
padding:10 0 20 0px;
}


input[type="checkbox"]{
display:none;}
input[type="checkbox"] + label span {
    display:inline-block;
    width:19px;
    height:19px;
    margin:-2px 5px 0 0;
    vertical-align:middle;
    background:url(https://s3-us-west-2.amazonaws.com/s.cdpn.io/210284/check_radio_sheet.png) left top no-repeat;
    cursor:pointer;
}

input[type="checkbox"]:checked + label span {
    background:url(https://s3-us-west-2.amazonaws.com/s.cdpn.io/210284/check_radio_sheet.png) -19px top no-repeat;
}

</style>

<div>
	<div class="wrap">
		<div class="login_form">
			<form action="/cinema/managerLoginEnd" method="POST">
				<h2>관리자 로그인</h2>
				<input type="text" name="id" class="inputer" value = ' ' /> <input type="password" name="pw" class="inputer"/>
				<div id="saveIdWrap">
				<p>
				<input type="checkbox" id="saveId" name="saveId"  />
			    <label for="saveId"><span></span>아이디저장</label>
				</div>
				<button type="submit">접속</button>
				<a href="${rootPath}" >돌아가기</a>
			</form>
		</div>

	</div>
</div>