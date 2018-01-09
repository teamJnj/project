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
	var $applyRecord = $map.applyRecord;
	var $vno = $map.vno;
	
	var $table = $("table");
	$table.empty();
	$table.append('<colgroup width="20%"/><colgroup width="20%"/><colgroup width="20%"/><colgroup width="20%"/><colgroup width="20%"/><thead><tr><th>아이디</th><th>신청자</th><th>생년월일</th><th>전화번호</th><th></th></tr></thead>');
	$.each($applyRecord, function(i, $applyRecord) {
		var $tbody = $("<tbody></tbody>").appendTo($table);
		var $tr = $("<tr></tr>").appendTo($tbody);
		$("<td></td>").text($applyRecord.memberId).appendTo($tr);
		$("<td></td>").text($applyRecord.memberName).appendTo($tr);
		$("<td></td>").text($applyRecord.birthDate).appendTo($tr);
		$("<td></td>").text($applyRecord.applyTel).appendTo($tr);
		var $td = $("<td></td>").appendTo($tr);
		//var $form = $("<form id='frm"+i+"' action='/jnj/center/volunteer/cancle' method='post'></form>").appendTo($td);
		$("<input type='submit'>").val("거절").attr("class","cancle").attr("data-volunteerNo",$applyRecord.volunteerNo).attr("data-idx",i).attr("data-memberId",$applyRecord.memberId).appendTo($td);
	});
	
	$(".cancle").on("click", function() {
		if (confirm("정말 거절하시겠습니까??") == true){    //확인
			var $form = $("<form action='/jnj/center/volunteer/cancle' method='post'></form>").appendTo("#di");
			$("<input type='hidden' name='volunteerNo'>").val($(this).attr("data-volunteerNo")).appendTo($form);
			$("<input type='hidden' name='memberId'>").val($(this).attr("data-memberId")).appendTo($form);
			$("<input type='hidden' name='_csrf' value='${_csrf.token}'>").appendTo($form);
			//var formData = new FormData();
			//formData.append("volunteerNo", $(this).attr("data-volunteerNo"));
			//formData.append("memberId", $(this).attr("data-memberId"));
			//formData.append("_csrf", "${_csrf.token}");
			$form.submit();
		}
	});
	
	$("#h3").text("봉사번호 "+ $vno +" - 봉사 신청 내역");
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('<').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record/apply?pageno='+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record/apply?pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record/apply?pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('>').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/volunteer/record/apply?pageno='+ $pagination.next));
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
	#goListBtn{
	   float: right;
	   margin-right: 50px;
	   width: 100px;
	   height: 40px;
	   text-align: 40px;
	   background-color: #FFB24C;
	   color: #fff;
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
	<div>
	   <a href="/jnj/center/volunteer" class="btn btn-block" id="goListBtn">목록</a>
	</div>
	<div id="di" class="container petListInCenter">
		<h3 id="h3"></h3>
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