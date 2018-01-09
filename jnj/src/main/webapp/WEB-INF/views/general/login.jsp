<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script>
	$(function() {
		$('#gmLoginFormLink').click(function(e) {
			$("#gmLoginForm").delay(100).fadeIn(100);
			$("#emLoginForm").fadeOut(100);
			$('#emLoginFormLink').removeClass('active');
			$(this).addClass('active');
			e.preventDefault();
		});
		$('#emLoginFormLink').click(function(e) {
			$("#emLoginForm").delay(100).fadeIn(100);
			$("#gmLoginForm").fadeOut(100);
			$('#gmLoginFormLink').removeClass('active');
			$(this).addClass('active');
			e.preventDefault();
		});
		$("#gmLoginBtn").on("click", function() {
			// $("#gmLoginForm").submit();
			// 사용자 아이디 꺼내서 member 테이블에 접근해서 아이디가 존재하는지 조회
			$.ajax({
				
				url : "/jnj/check_id",
				type: "post",
				data:{
					"memberId" : $("#gid").val(),
					"type" : 1,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				success: function(memberId) {
					console.log(memberId);
					if(memberId==true) {
						 $("#gmLoginForm").submit();
					} else {
						alert("아이디와 비밀번호가 틀렸습니다.");
						$("#gid").val('');
						$("#gpwd").val('');
					}
				}
			});
			
		});
		$("#emLoginBtn").on("click", function() {
			// $("#emLoginForm").submit();
			// 사용자 아이디 꺼내서 center 테이블에 접근해서 아이디가 존재하는지 조회
			$.ajax({
				url : "/jnj/check_id",
				type: "post",
				data:{
					"centerId" : $("#eid").val(),
					"type" : 2,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				
				success: function(centerId) {
					console.log(centerId);
					if(centerId==true) {
						 $("#emLoginForm").submit();
					} else {
						alert("아이디와 비밀번호가 틀렸습니다.");
						$("#eid").val('');
						$("#epwd").val('');
					}
				}
			});
		});
	});
	function showId2Popup() {
		window.open("/jnj/find_id?type=2", "a",
				"width=500, height=500, left=100, top=50", "type=2");
	}
	function showPwd2Popup() {
		window.open("/jnj/find_pwd?type=2", "a",
				"width=500, height=500, left=100, top=50", "type=2");
	}

	function showId1Popup() {
		window.open("/jnj/find_id?type=1", "a",
				"width=500, height=500, left=100, top=50", "type=1");
	}
	function showPwd1Popup() {
		window.open("/jnj/find_pwd?type=1", "a",
				"width=500, height=500, left=100, top=50", "type=1");
	}
</script>

<title>로그인</title>
<style>
body {
	padding-top: 150px;
}

.panel-login {
	border-color: #ccc;
	-webkit-box-shadow: 0px 2px 3px 0px rgba(0, 0, 0, 0.2);
	-moz-box-shadow: 0px 2px 3px 0px rgba(0, 0, 0, 0.2);
	box-shadow: 0px 2px 3px 0px rgba(0, 0, 0, 0.2);
}

.panel-login>.panel-heading {
	background-color: #fff;
	border-color: #fff;
	text-align: center;
}

.panel-login>.panel-heading a {
	text-decoration: none;
	color: #FFB24C;
	font-weight: bold;
	font-size: 15px;
	-webkit-transition: all 0.1s linear;
	-moz-transition: all 0.1s linear;
	transition: all 0.1s linear;
}

.panel-login>.panel-heading a.active {
	color: #7F5926;
	font-size: 18px;
}

.panel-login>.panel-heading hr {
	margin-top: 10px;
	margin-bottom: 0px;
	clear: both;
	border: 0;
	height: 1px;
}

.panel-login input[type="text"], .panel-login input[type="email"],
	.panel-login input[type="password"] {
	height: 45px;
	border: 1px solid #ddd;
	font-size: 16px;
	-webkit-transition: all 0.1s linear;
	-moz-transition: all 0.1s linear;
	transition: all 0.1s linear;
}

.panel-login input:hover, .panel-login input:focus {
	outline: none;
	-webkit-box-shadow: none;
	-moz-box-shadow: none;
	box-shadow: none;
	border-color: #ccc;
}

.btn-login {
	background-color: #FFB24C;
	outline: none;
	color: #7F5926;
	font-size: 14px;
	height: auto;
	font-weight: normal;
	padding: 14px 0;
	text-transform: uppercase;
	border-color: #FFB24C;
}

.btn-login:hover, .btn-login:focus {
	color: #fff;
	background-color: #FF9100;
	border-color: #FF9100;
}

.findIdPw {
	text-decoration: underline;
	color: #888;
}

.findIdPw:hover, .findIdPw:focus {
	text-decoration: underline;
	color: #666;
}

.btn-emlogin {
	background-color: #1CB94E;
	outline: none;
	color: #fff;
	font-size: 14px;
	height: auto;
	font-weight: normal;
	padding: 14px 0;
	text-transform: uppercase;
	border-color: #1CB94A;
}

.btn-emlogin:hover, .btn-emlogin:focus {
	color: #fff;
	background-color: #1CA347;
	border-color: #1CA347;
}

a:link, a:visited {
	text-decoration: none;
}

#preA a:visited {
	color: white;
}
body {
padding: 0;
}
</style>

</head>
<body>
<br><br><br><br><br><br><br><br>
	<div class="container">
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<div class="panel panel-login">
					<div class="panel-heading">
						<div class="row">
							<div class="col-xs-6">
								<a href="#" class="active" id="gmLoginFormLink">일반회원</a>
							</div>
							<div class="col-xs-6">
								<a href="#" id="emLoginFormLink">센터회원</a>
							</div>
						</div>
						<hr />
					</div>

					<div class="panel-body">
						<div class="row">
							<div class="col-lg-12">


								<form id="gmLoginForm" action="/jnj/login" method="post"
									role="form" style="display: block;">
									<div class="form-group">
										<input type="text" name="loginid" id="gid"
											class="form-control" placeholder="Username" value="">
									</div>
									<div class="form-group">
										<input type="password" name="loginpwd" id="gpwd"
											class="form-control" placeholder="Password">
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-3">
												<input type="hidden" name="${_csrf.parameterName}"
													value="${_csrf.token}">
												<button type="button" id="gmLoginBtn" class="form-control">로그인</button>
											</div>
											<div class="col-sm-3">
												<input type="button" class="btn btn-info" value="아이디 찾기"
													onclick="showId1Popup();" />
											</div>
											<div class="col-sm-3">
												<input type="button" class="btn btn-info" value="비밀번호 찾기"
													onclick="showPwd1Popup();" />
											</div>
										</div>
									</div>
								</form>

								<form id="emLoginForm" action="/jnj/login" method="post"
									role="form" style="display: none;">
									<div class="form-group">
										<input type="text" name="loginid" id="eid"
											class="form-control" placeholder="Username" value="">
									</div>
									<div class="form-group">
										<input type="password" name="loginpwd" id="epwd"
											class="form-control" placeholder="Password"> <input
											type="hidden" name="${_csrf.parameterName}"
											value="${_csrf.token}">
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-3">
												<button type="button" id="emLoginBtn" class="form-control">로그인</button>
											</div>
											<div class="col-sm-3">
												<input type="button" class="btn btn-info" value="아이디 찾기"
													onclick="showId2Popup();" />
											</div>
											<div class="col-sm-3">
												<input type="button" class="btn btn-info" value="비밀번호 찾기"
													onclick="showPwd2Popup();" />
											</div>
										</div>
									</div>
								</form>

							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<br><br><br><br><br><br><br><br>
</body>
</html>