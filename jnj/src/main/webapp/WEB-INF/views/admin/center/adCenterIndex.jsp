<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<title>Admin Base Page</title>
	
	<link href="/jnj/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	
	<link href="/jnj/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="/jnj/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
	<link href="/jnj/resources/css/sb-admin.css" rel="stylesheet" >
	  
    <script src="/jnj/resources/vendor/jquery/jquery.min.js"></script>
    <script src="/jnj/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script src="/jnj/resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    
    <script src="/jnj/resources/vendor/chart.js/Chart.min.js"></script>
    <script src="/jnj/resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="/jnj/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    
    <script src="/jnj/resources/js/sb-admin.min.js"></script>
    
    <script src="/jnj/resources/js/sb-admin-datatables.min.js"></script>
    <script src="/jnj/resources/js/sb-admin-charts.min.js"></script>

	<script>
		$(function(){
			var $center = ${center};
			$("#centerInfoName").text( "[ "+$center.centerName+"님 ] 상세 정보" );
		});
	</script>
	<style>
		#centerInfoName{
			font-weight: bold;
			font-size: larger;
			margin-left: 25px;
		}
	</style>
</head>
<body>

	<header id="header">
		<br>
		<p id="centerInfoName"></p>
	</header>
	
	<hr>
	
	<nav id="nav">
		<jsp:include page="centerInfoMenu.jsp" />
	</nav>
	
	<hr>
	
	<section>
		<jsp:include page="${centerInfoIndex}" />
	</section>

</body>
</html>