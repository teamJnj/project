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
		var $member = ${member};

		$("#memberInfoName").text("[ " + $member.memberName + "님 ] 상세 정보");

		$("#menu_mInfo").on("click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_info?memberId=" + $member.memberId;
		});

		$("#menu_mSponsor").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_sponsor?memberId=" + $member.memberId;
		});
		
		$("#menu_mAdopt").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_adopt?memberId=" + $member.memberId;
		});
		
		$("#menu_mVolunteer").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_volunteer?hostId=" + $member.memberId;
		});
		
		$("#menu_mMarket").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_market?memberId=" + $member.memberId;
		});
		
		$("#menu_mFind").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_find?memberId=" + $member.memberId;
		});
		
		$("#menu_mQna").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_qna?qnaDivision=1&memberId=" + $member.memberId;
		});
		
		$("#menu_mOrder").on( "click", function(e) {
			e.preventDefault();
			location.href = "/jnj/admin/member_orders?&memberId=" + $member.memberId;
		});
		
	});
</script>
</head>

<body>

	<ol class="breadcrumb">
		<li class="breadcrumb-item">
			<a id="menu_mInfo" href="#">개인정보</a>
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
			<a id="menu_mMarket" href="#">프리마켓내역</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mOrder" href="#">구매내역</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mFind" href="#">게시글/댓글내역</a>
		</li>
		<li class="breadcrumb-item">
			<a id="menu_mQna" href="#">1:1문의</a>
		</li>
	</ol>

</body>

</html>