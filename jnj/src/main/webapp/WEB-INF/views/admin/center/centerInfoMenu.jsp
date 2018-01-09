 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>Admin Base Page</title>
<script>
	$(function() {
		var $center = ${center};

		$("#centerInfoName").text("[ " + $center.centerName + "님 ] 상세 정보");

		$("#menu_mInfo").on("click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/center_info?centerId=" + $center.centerId;
		});
		
		$("#menu_mQna").on("click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/center_qna?qnaDivision=2&centerId=" + $center.centerId;
		});
		
		$("#menu_mVolunteer").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/center_volunteer?hostId=" + $center.centerId;
		});
		
		$("#menu_mPet").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/center_pet?centerId=" + $center.centerId;
		});
		
		$("#menu_mAdopt").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/center_adopt?centerId=" + $center.centerId;
		});
		
		$("#menu_mSponsor").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/center_sponsor?centerId=" + $center.centerId;
		});
		
	});
</script>
</head>

<body>

	<ol class="breadcrumb">
		<li class="breadcrumb-item">
			<a id="menu_mInfo" href="#">센터정보</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mPet" href="#">등록동물</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mSponsor" href="#">후원내역</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mAdopt" href="#">입양내역</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mVolunteer" href="#">봉사내역</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mQna" href="#">1:1문의</a>
		</li>
	</ol>

</body>

</html>