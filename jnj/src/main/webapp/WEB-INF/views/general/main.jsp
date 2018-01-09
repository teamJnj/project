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

.panel-primary>.panel-heading {
	color: #fff;
	background-color: #FFB24C;
	border-color: #FF9100;
}
#jumbotron{
width:1140px;
height:301px;
background-image: url("/jnjimg/main/main.jpg");
}


</style>
<title>메인화면</title>
</head>
<body>
	<div class="container">
		<div id="jumbotron">
		<!-- <img src="/jnjimg/main/main.jpg" id="mainImg"> -->
			<br>
			<br>
			<br>
			<h1 class="text-center">우리 주인과집사를 소개합니다.</h1>
			<p class="text-center">안락사 당하기 직전 도움이 필요한 동물의 후원 및 입양을 소개합니다.</p>
			<p class="text-center">
				<a class="btn btn-primary btn-lg" href="/jnj/menu/board_notice/record" role="button">자세히
					알아보러 가기</a>
			</p>
		</div>
		<div class="row">
			<div class="col-md-4">
				<h4>안락사의 위기에 처한 유기동물 후원하기</h4>
				<p>후원합시다</p>
				<p>
					<a href="/jnj/menu/sponsor/record?petSort=0" class="btn btn-default" data-target="#modal" data-toggle="modal">
					후원 정보확인</a>
				</p>
			</div>
			<div class="col-md-4">
				<h4>유기견 &amp; 유기묘 입양하기</h4>
				<p>안락사 예정 또는 주인을 찾지못한 유기동물 입양합시다</p>
				<p>
					<a href="/jnj/menu/adopt/record?petSort=0&petState=0&firstAddr=전체" class="btn btn-default">입양 정보확인</a>
				</p>
			</div>
			<div class="col-md-4">
				<h4>다양한 봉사활동</h4>
				<p>센터위주가 아닌 회원이 중심이 되는 활동도 가능합니다.</p>
				<p>
					<a href="/jnj/menu/volunteer/record" class="btn btn-default">봉사 정보확인</a>
				</p>
			</div>
		</div>



		<hr>



		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">
					<span class="glyphicon glyphicon-pencil"></span> &nbsp;&nbsp;전체보기
				</h3>
			</div>
			<div class="panel-body">
				<div class="media">
					<div class="media-left">
						<a href="/jnj/menu/market/record"><img src="/jnjimg/main/1.jpg" style="width: 150px;" class="media-object"
							alt="프리마켓 이미지"></a>
					</div>
					<div class="media-body">
						<h4 class="media-heading">
							<a href="/jnj/menu/market/record">프리마켓</a>&nbsp;<span class="label label-warning">확인하기</span>
						</h4>
						<span style="font:15pt '굴림체'">매월 개최되는 프리마켓!<br>
						지금 바로 신청 정보 확인하러 가기!</span>
					</div>
				</div>
				<hr>
				<div class="media">
					<div class="media-left">
						<a href="/jnj/menu/store/record"><img src="/jnjimg/main/2.jpg" style="width: 150px;" class="media-object"
							 alt="스토어 이미지"></a>
					</div>
					<div class="media-body">
						<h4 class="media-heading">
							<a href="/jnj/menu/store/record">스토어</a>&nbsp;<span class="label label-warning">Hot</span>
						</h4>
						<span style="font:15pt '굴림체'">새로운 굿즈 확인<br>
						유기동물을 후원하는 또 다른 방법 바로 확인!</span>
					</div>
				</div>
				<hr>
				<div class="media">
					<div class="media-left">
						<a href="/jnj/menu/board_find/list"><img src="/jnjimg/main/3.jpg" style="width: 150px;" class="media-object"
							alt="찾아요 이미지"></a>
					</div>
					<div class="media-body">
						<h4 class="media-heading">
							<a href="/jnj/menu/board_find/list">찾아요</a>&nbsp;<span class="label label-warning">NEW정보</span>
						</h4>
						<span style="font:15pt '굴림체'">잃어버린 동물 신고<br>
						소중한 반려 동물을 잃어버렸다면 지금 바로 신고하자!</span>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%-- <div id="guestbook">
		<jsp:include page="../mouseM.jsp"></jsp:include>
	</div>  --%>

</body>
</html>