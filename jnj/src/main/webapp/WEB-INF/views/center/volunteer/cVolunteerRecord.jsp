<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script>
$(function() {
	var $map = ${map};
	var $pagination = $map.pagination;
	var $volunteerRecord = $map.volunteerRecord;
	var $sort = $map.sort;
	var $table = $("table");
	
	$("#sort1").attr('href', '/jnj/center/volunteer/record?sort=1');
	$("#sort2").attr('href', '/jnj/center/volunteer/record?sort=2');
	$("#sort3").attr('href', '/jnj/center/volunteer/record?sort=3');
	
	$table.empty();
	$table.append('<colgroup width="25%"/><colgroup width="10%"/><colgroup width="15%"/><colgroup width="15%"/><colgroup width="15%"/><colgroup width="15%"/><thead><tr><th>봉사 제목</th><th>나이제한</th><th>신청인원</th><th>신청 마감 날짜</th><th>봉사 (예정)날짜</th><th>상태</th></tr></thead>');
	$.each($volunteerRecord, function(i, $volunteerRecord) {
		var $tbody = $("<tbody></tbody>").appendTo($table);
		var $tr = $("<tr></tr>").appendTo($tbody);
		$("<td><a href='/jnj/menu/volunteer/view?volunteerNo="+$volunteerRecord.volunteerNo+"'>"+$volunteerRecord.volunteerTitle+"</a></td>").appendTo($tr);
		var ageLimit = "-";
		if($volunteerRecord.ageLimit>0) ageLimit = $volunteerRecord.ageLimit + "세 이상"
		$("<td></td>").text(ageLimit).appendTo($tr);
		var maxPeople = "제한없음";
		if($volunteerRecord.maxPeople>0) maxPeople=$volunteerRecord.maxPeople +"명";
		var people = $volunteerRecord.applyPeople + "명 / " + maxPeople;
		$("<td><a href='/jnj/center/volunteer/record/apply?volunteerNo="+$volunteerRecord.volunteerNo+"'>"+people+"</a></td>").appendTo($tr);
		$("<td></td>").text($volunteerRecord.applyEndDate).appendTo($tr);
		$("<td></td>").text($volunteerRecord.volunteerDate).appendTo($tr);
		var volunteerState = "모집중";
		if($volunteerRecord.detailState==2) volunteerState = "모집완료";
		else if($volunteerRecord.detailState==3) volunteerState = "봉사완료";
		else if($volunteerRecord.detailState==4) volunteerState = "인원미달";
		
		if($volunteerRecord.volunteerState==0) volunteerState="블락";
		else if($volunteerRecord.volunteerState==2) volunteerState="취소";
		$("<td></td>").text(volunteerState).appendTo($tr);
	});
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('<').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record?pageno='+ $pagination.prev + '&sort=' + $sort))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record?pageno='+ i + '&sort=' + $sort).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record?pageno='+ i + '&sort=' + $sort))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('>').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record?pageno='+ $pagination.next + '&sort=' + $sort));
	}
});
</script>
<title>SponsorRecord by MyCenter</title>
<style>
	.petListInCenter button {
		margin-left: 92.5%;
		background-color: #FFB24C;
		color: #7F5926;
	}
	.petListInCenter button:hover {
		background-color: #7F5926;
		color: #FFB24C;
	}
	.petListInCenter h3 {
		color: #7F5926;
	}
	.petListInCenter thead {
		background-color: #FFB24C;
		text-align: center;
	}
	.petListInCenter thead th {
		text-align: center;
	}
	.petListInCenter tbody td {
		text-align: center;
	}
	.petListInCenter .table {
		text-align: center;
		margin-top: 30px;
		align-content: center;
		vertical-align: middle;
	}
	.pager {
		margin-left: 46%;
	}
	
	#pagination  ul {
		maring: 0;
		padding: 0;
	}
	#pagination li {
		list-style: none;
		float: left;
		width: 35px;
		text-align : center;
		height : 35px;
		line-height: 35px;
		font-size : 0.75em;
		border: 1px solid #ddd;
	}
	#pagination a {
		text-decoration:  none;
		display : block;
		color : #7F5926;
	}
	#pagination a:link, #pagination a:visited {
		color : #7F5926;
	}
	#pagination {
		margin-left: 46%;
		margin-top: 20px;
	}
</style>
</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer" style="color: navy; font-weight: 700; font-size: 20px;">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign">회원탈퇴</a></h4>
	<hr>
	<div class="container petListInCenter">
		<h3>센터 봉사 내역</h3>
		<div style="text-align: right; float:right; margin-bottom: 10px;">
		<a href="#" id="sort1">최신순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" id="sort2">봉사날짜순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" id="sort3">상태순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		<table class="table">
		</table>
		<div id="pagination" class="container2">
			<ul class="pager">
			</ul>
		</div>
		<br><br><br><br><br><br>
	</div>
</body>
</html>