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
	var $sponsorRecord = $map.sponsorRecord;
	
	var $cState = ${requestScope.cState};
	if($cState==0||$cState==2||$cState==3) {
		$(".normalState").attr("href", "#");
	}
	
	var $table = $("table");
	$table.empty();
	$table.append('<colgroup width="33%"/><colgroup width="34%"/><colgroup width="33%"/><thead><tr><th>후원 연월</th><th>총 후원 금액</th><th></th></tr></thead>');
	$.each($sponsorRecord, function(i, $sponsorRecord) {
		var $tbody = $("<tbody></tbody>").appendTo($table);
		
		var $tr = $("<tr></tr>").appendTo($tbody);
		$("<td></td>").text($sponsorRecord.month+"月").appendTo($tr);
		$("<td></td>").text(numberWithCommas($sponsorRecord.totalSponsorMoney)+"원").appendTo($tr);
		$("<td><a href='/jnj/center/sponsor/record/detail?month="+$sponsorRecord.month+"'>상세보기</a></td>").appendTo($tr);
	});
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('<').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/sponsor/record?pageno='+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/sponsor/record?pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/sponsor/record?pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('>').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/sponsor/record?pageno='+ $pagination.next));
	}
	
	function numberWithCommas(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
	<a href="/jnj/center/info" class="normalState">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" class="normalState">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor" style="color: navy; font-weight: 700; font-size: 20px;">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer" class="normalState">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna/record">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign" class="normalState">회원탈퇴</a></h4>
	<hr>
	<div class="container petListInCenter">
		<h3>센터 월별 후원 리스트</h3>
		<table class="table">
			<colgroup width="10%"/>
			<colgroup width="10%"/>
			<colgroup width="20%"/>
			<colgroup width="15%"/>
			<colgroup width="10%"/>
			<colgroup width="15%"/>
			<colgroup width="20%"/>
			<thead>
				<tr>
					<th>동물번호</th><th>사진</th><th>이름</th><th>분류</th><th>성별</th><th>상태</th><th>안락사예정일</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td></td>
				</tr>
			</tbody>
		</table>
		<div id="pagination" class="container2">
			<ul class="pager">
				<!-- <li><a href="#">이전으로</a></li>
						<li><a href="#">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
				<li><a href="#">다음으로</a></li> -->
			</ul>
		</div>
		<br><br><br><br><br><br>
	</div>
</body>
</html>