<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>     
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주인과 집사</title>
<meta name="viewport" content="width=device-width", initial-scale="1">


<script src="/jnj/resources/boot/js/bootstrap.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


<link rel="stylesheet" href="/jnj/resources/boot/css/index.css">
<link rel="stylesheet" href="/jnj/resources/boot/css/bootstrap.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">



<script>
	/* var $resign = ${resign};
	if($resign==false)
		alert("회원 탈퇴에 실패했습니다. 비밀번호를 확인해 주세요"); */
</script>


</head>
<body>

	<header id="header">
	
		<sec:authorize access="isAnonymous()">
				<jsp:include page="include/header.jsp" />
		</sec:authorize>
		
		<sec:authorize access="hasRole('ROLE_MEMBER')">
			<jsp:include page="include/userHeader.jsp" />
		</sec:authorize>
		
		<sec:authorize access="hasRole('ROLE_CENTER')">
			<jsp:include page="include/centerHeader.jsp" />
		</sec:authorize>
		
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<jsp:include page="include/userHeader.jsp" />
		</sec:authorize>
	
	
	
	</header>
	
	<nav id="nav">
		<sec:authorize access="isAnonymous()">
			<jsp:include page="include/anonymous.jsp" />
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_MEMBER')">
			<jsp:include page="include/user.jsp" />
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_CENTER')">
			<jsp:include page="include/user.jsp" />
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<jsp:include page="include/user.jsp" />
		</sec:authorize>
	</nav>
	
	<section>
		<jsp:include page="${viewName}" />
	</section>
	
	<footer id="footer">
		<jsp:include page="include/footer.jsp" />
	</footer>
	
	<%-- <div id="guestbook">
		<jsp:include page="mouseM.jsp"></jsp:include>
	</div> --%>
</body>
</html>