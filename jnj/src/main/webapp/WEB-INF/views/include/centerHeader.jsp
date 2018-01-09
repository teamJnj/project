<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">

</script>
<style type="text/css">

.navbar-default {
	background-color: #ff9100;
}

.navbar-nav {
	font-size: 1.3em;
}

.navbar-default .navbar-nav>.open>a, .navbar-default .navbar-nav>.open>a:hover,
	.navbar-default .navbar-nav>.open>a:focus {
	color: #555;
	background-color: #FFB24C;
}

.navbar-collapse li {
	width: 240px;
	text-align: center;
}

.dropdown-menu>li>a:hover, .dropdown-menu>li>a:focus {
	font-size: 1.3em;
}

.navbar-brand {
	float: left;
	height: 50px;
	padding: 15px 15px;
	font-size: 1.5em;
	line-height: 20px;
}

.btn-primary {
  color: #fff;
  background-color: #ff9100;
  border-color: #2e6da4;
}

.panel-primary > .panel-heading {
  color: #fff;
  background-color: #FFB24C;
  border-color: #ff9100;
}

#userName {
float: left;
	height: 50px;
	padding: 15px 15px;
	font-size: 0.9em;
	line-height: 20px;
}
#main{
width: 82px;
height: 70px;
margin-top: 12px;
}
#jnj{
float: right;
margin-top: 25px;
font-size: 30px;
color: #DF7401;
border-color: black;
font-weight: bolder;

}
#navbar-header{
float: left;
}
#ul{
margin-top: 45px;
}
</style>
<script type="text/javascript">
$(function () {
	
	$.ajax({
		url:"/jnj/username",
		type:"get",
		data:$("form").serialize(),
		success:function(principal){
			console.log(principal);
			$("#userName").text(principal+"님 환영합니다.");
			$("#mypage").attr("href", "/jnj/center");
		}
	});
	
	$("#logoutBtn").on("click", function(e){
		console.log("로그아웃 클릭");
		e.preventDefault();
		
		var $form = $("#frm");
		$form.empty();
		$form.attr("action", "/jnj/logout");
		$form.attr("method", "post");
		var $input = $("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
		$form.submit();
	})
	
});

$(function(){
	$("#main").on("click", function(e){
		e.preventDefault();
		location.href = "/jnj/";
	});
	
	$("#main2").on("click", function(e){
		e.preventDefault();
		location.href = "/jnj/";
	});
})
</script>
<title>Insert title here</title>
</head>
<body>
	
<header class="header">
	
	
<div class="container-fluid">


	<div class="navbar-header" id="navbar-header">
		<img src="/jnjimg/main/12345.jpg" id="main">
		<img src="/jnjimg/main/jnj.png" id="main2" style="height: 70px; margin-top: 11px;">
	</div>
	
	
	<div>
		<ul class="nav navbar-nav navbar-right" id="ul">
			<li><span id="userName"></span></li>
			<li><a href="/jnj/general/message/receive/record" id="M">쪽지</a></li>
			<li><a href=# id="mypage">마이페이지</a></li>
			<li><a href="#" id="logoutBtn">로그아웃</a></li>
		</ul>
	</div>
	
	<form id="frm">
	</form>
</div>
	
</header>
	
</body>
</html>