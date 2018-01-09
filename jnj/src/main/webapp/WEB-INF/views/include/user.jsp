<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
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
  border-color: #FFB24C;
}

.panel-primary > .panel-heading {
  color: #fff;
  background-color: #FFB24C;
  border-color: #ff9100;
}
#dogs{
width: 30x;
height: 30px;
margin: 0;
margin-top: 11px;

}

#aa1, #aa2, #aa3, #aa4, #aa5{
	color: white;
	font-weight: bold;
}

#a1:hover, #a2:hover, #a3:hover, #a4:hover, #a5:hover {
	color: gray;
}

</style>
</head>
<body>
	
	<nav class="navbar navbar-default">


	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		<ul class="nav navbar-nav">
			<li><a id="aa1" href="/jnj/menu/sponsor/record?petSort=0">후원</a></li>
			<li><a id="aa2" href="/jnj/menu/adopt/record?petSort=0&petState=0&firstAddr=전체">입양</a></li>
			<li class="dropdown">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
				aria-haspopup="true" aria-expanded="false" style="color: white; font-weight: bold;">모집<span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="/jnj/menu/volunteer/record">봉사</a></li>
					<li><a href="/jnj/menu/market/record">프리마켓</a></li>
				</ul>
			</li>
			<li><a id="aa4" href="/jnj/menu/store/record">스토어</a></li>
			<li class="dropdown">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
				aria-haspopup="true" aria-expanded="false" style="color: white; font-weight: bold;">게시판<span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="/jnj/menu/board_find/list">찾아요</a></li>
					<li><a href="/jnj/menu/board_found/list">찾았어요</a></li>
				</ul>
			</li>
			
		</ul>
		<img src="/jnjimg/main/dogs.gif" id="dogs">
	</div>
	
	
</nav>
	
</body>
</html>