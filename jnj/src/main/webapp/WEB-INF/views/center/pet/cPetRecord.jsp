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
	var $sort = $map.sort;
	var $list = $map.list;
	var $pagination = $map.pagination;
	var $table = $("table");
	
	$("#sort1").attr('href', '/jnj/center/pet/record?sort=1');
	$("#sort2").attr('href', '/jnj/center/pet/record?sort=2');
	$("#sort3").attr('href', '/jnj/center/pet/record?sort=3');
	
	$table.empty();
	$table.append('<colgroup width="10%"/><colgroup width="15%"/><colgroup width="20%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="15%"/><colgroup width="10%"/><thead><tr><th>동물번호</th><th>사진</th><th>이름</th><th>분류</th><th>성별</th><th>상태</th><th>안락사예정일</th><th></th></tr></thead>');
	$.each($list, function(i, $pet) {
		var $tbody = $("<tbody></tbody>").appendTo($table);
		
		var $tr = $("<tr></tr>").appendTo($tbody);
		$("<td style='height:110px; line-height:110px;'></td>").text($pet.petNo).appendTo($tr);
		
		$("<td><img src=\"/jnjimg/pet/"+ $pet.petImg +"\" width=\"152px\" height=\"114px\"></td>").appendTo($tr);
		
		$("<td style='height:110px; line-height:110px;'></td>").text($pet.petName).appendTo($tr);
		
		var petSort = "강아지";
		if($pet.petSort==2) petSort="고양이";
		else if($pet.petSort==3) petSort="기타";
		$("<td style='height:110px; line-height:110px;'></td>").text(petSort).appendTo($tr);
		
		var gender = "남자";
		if($pet.gender==2) gender="여자";
		$("<td style='height:110px; line-height:110px;'></td>").text(gender).appendTo($tr);
		
		var petState = "대기";
		var mercyDate = $pet.mercyDate;
		if($pet.petState==2) petState="접수";
		else if($pet.petState==3) petState="진행";
		else if($pet.petState==4) {
			petState="입양";
			mercyDate="-";
		}
		else if($pet.petState==5) petState="안락사";
		$("<td style='height:110px; line-height:110px;'></td>").text(petState).appendTo($tr);
		$("<td style='height:110px; line-height:110px;'></td>").text(mercyDate).appendTo($tr);
		$("<td style='height:110px; line-height:110px;'><a href=\"/jnj/center/pet/view?petNo="+$pet.petNo+"\">상세보기</a></td>").appendTo($tr);
		//var $link = $("<a>").attr("href", "/zboard1/board/read_board?bno=" + $board.bno);
		//$title.wrapInner($link);
	});
	$("#write").on("click", function() {
		location.href = "/jnj/center/pet/insert";
	})
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('<').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/pet/record?pageno='+ $pagination.prev + '&sort=' + $sort))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/pet/record?pageno='+ i + '&sort=' + $sort).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/pet/record?pageno='+ i + '&sort=' + $sort))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('>').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/pet/record?pageno='+ $pagination.next + '&sort=' + $sort));
	}
	/*
	$("#arrayName").on("click", function() {
		$.ajax({
			url : "",
			type:"post",
			data:"bno=" + $("#arrayName") + "&_csrf=" + "${_csrf.token}",
			success:function(reportCnt) {
				$("#reportCnt").text(reportCnt);
			}
		});
	});*/
});
</script>
<title>PetList by MyCenter</title>
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
	
	td {
		vertical-align: middle;
	}
</style>
</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet/" style="color: navy; font-weight: 700; font-size: 20px;">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign">회원탈퇴</a></h4>
	<hr>
	<div class="container petListInCenter">
		<h3 style="display: inline-block;">센터 유기동물 리스트</h3>
		<div class="form-group" style="float: right; margin-top: 32px; margin-right: 80px;">
			<button id="write" type="submit" class="btn btn-default">동물 등록</button>
		</div>
		<div style="text-align: right; float:right; margin-top: 50px; margin-right: -50px;"><a href="#" id="sort1">등록일순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="sort2">이름순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="sort3">안락사예정일순</a></div>
		<table class="table" cellspacing="0" cellpadding="0">
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