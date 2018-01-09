<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>     
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<title>Admin Base Page</title>
	
	<link href="/jnj/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="/jnj/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="/jnj/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
	<link href="/jnj/resources/css/sb-admin.css" rel="stylesheet">
	  
    <script src="/jnj/resources/vendor/jquery/jquery.min.js"></script>
    <script src="/jnj/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script src="/jnj/resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    
    <script src="/jnj/resources/vendor/chart.js/Chart.min.js"></script>
    <script src="/jnj/resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="/jnj/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    
    <script src="/jnj/resources/js/sb-admin.min.js"></script>

    <script src="/jnj/resources/js/sb-admin-datatables.min.js"></script>
    <script src="/jnj/resources/js/sb-admin-charts.min.js"></script>

</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	
	<!-- 왼쪽 메뉴 바입니다. -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
		<a class="navbar-brand" href="/jnj/">주인과 집사</a>
		<button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
	    	<span class="navbar-toggler-icon"></span>
	    </button>
	    
	    <div class="collapse navbar-collapse" id="navbarResponsive">
	    	<ul class="navbar-nav navbar-sidenav" id="exampleAccordion">
	    		
	    		
	    		<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Main">
	          		<a class="nav-link" href="/jnj/admin/main">
		            	<i class="fa fa-fw fa-area-chart"></i>
		            	<span class="nav-link-text">관리자 메인</span>
	          		</a>
	        	</li>
	        	
	        	
	        	
	        	<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Total">
	          		<a class="nav-link" href="/jnj/admin/notice">
		            	<i class="fa fa-fw fa-table"></i>
		            	<span class="nav-link-text">공지사항</span>
	          		</a>
	        	</li>
	        	
	        	
	        	
		        <li class="nav-item" data-toggle="tooltip" data-placement="right" title="" data-original-title="Components">
		          <a class="nav-link nav-link-collapse collapsed" data-toggle="collapse" href="#collapseComponents" data-parent="#exampleAccordion" aria-expanded="false">
		            <i class="fa fa-fw fa-wrench"></i>
		            <span class="nav-link-text">회원 별 관리</span>
		          </a>
		          <ul class="sidenav-second-level collapse" id="collapseComponents" style="">
		            <li>
		              <a href="/jnj/admin/member">일반회원</a>
		            </li>
		            <li>
		              <a href="/jnj/admin/center">센터회원</a>
		            </li>
		          </ul>
		        </li>
		        
	        	
	        	
	        	<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Total">
	          		<a class="nav-link" href="/jnj/admin/market">
		            	<i class="fa fa-fw fa-table"></i>
		            	<span class="nav-link-text">프리마켓</span>
	          		</a>
	        	</li>
	        	
	        	
	        	
		        <li class="nav-item" data-toggle="tooltip" data-placement="right" title="" data-original-title="Example Pages">
		          <a class="nav-link nav-link-collapse collapsed" data-toggle="collapse" href="#collapseExamplePages" data-parent="#exampleAccordion" aria-expanded="false">
		            <i class="fa fa-fw fa-table"></i>
		            <span class="nav-link-text">스토어</span>
		          </a>
		          <ul class="sidenav-second-level collapse" id="collapseExamplePages" style="">
		            <li>
		              <a href="/jnj/admin/goods">상품관리</a>
		            </li>
		            <li>
		              <a href="/jnj/admin/orders">판매관리</a>
		            </li>
		          </ul>
		        </li>
	        	
	        	
	        	
	        	<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Total">
	          		<a class="nav-link" href="/jnj/admin/qna">
		            	<i class="fa fa-fw fa-dashboard"></i>
		            	<span class="nav-link-text">1:1문의</span>
	          		</a>
	        	</li>
	        	
	        	
	        	
	        	<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Total">
	          		<a class="nav-link" href="/jnj/admin/sales">
		            	<i class="fa fa-fw fa-dashboard"></i>
		            	<span class="nav-link-text">매출내역-후원</span>
	          		</a>
	        	</li>
	        	
	        	
	        	
	        	<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Total">
	          		<a class="nav-link" href="/jnj/admin/sales_store">
		            	<i class="fa fa-fw fa-dashboard"></i>
		            	<span class="nav-link-text">매출내역-스토어</span>
	          		</a>
	        	</li>
	        	
	    	</ul>
	    </div>
	</nav>
	
	<section>
		<jsp:include page="${adminViewName}"/>
	</section>

</body>
</html>