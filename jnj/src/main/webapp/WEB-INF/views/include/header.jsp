<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<script>
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
			<li><a href="/jnj/login">로그인</a></li>
			<li><a href="/jnj/join">회원가입</a></li>
		</ul>
	</div>
</div>
	
</header>
	
</body>
</html>