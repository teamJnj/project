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
	var $list = $map.list;
	var $sort = $map.sort;
	var $pagination = $map.pagination;
	var $table = $("table");
	var $cState = ${requestScope.cState};
	
	if($cState==0||$cState==2||$cState==3) {
		$(".normalState").attr("href", "#");
	}
	
	$("#sort1").attr('href', '/jnj/center/adopt/record?sort=1');
	$("#sort2").attr('href', '/jnj/center/adopt/record?sort=2');
	$("#sort3").attr('href', '/jnj/center/adopt/record?sort=3');
	$("#sort4").attr('href', '/jnj/center/adopt/record?sort=4');
	$("#sort5").attr('href', '/jnj/center/adopt/record?sort=5');
	
	$table.empty();
	$table.append('<colgroup width="7%"/><colgroup width="15%"/><colgroup width="10%"/><colgroup width="7%"/><colgroup width="10%"/><colgroup width="14%"/><colgroup width="7%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="10%"/><thead><tr><th>동물번호</th><th>사진</th><th>이름</th><th>분류</th><th>안락사 예정일</th><th>입양 신청정보</th><th>상태</th><th>입양날짜</th><th>취소날짜</th><th></th></tr></thead>');
	$.each($list, function(i, $pet) {
		var $tbody = $("<tbody></tbody>").appendTo($table);
		
		var $tr = $("<tr></tr>").appendTo($tbody);
		$("<td style='height:114px; line-height:114px;'></td>").text($pet.petNo).appendTo($tr);
		
		$("<td><img src=\"/jnjimg/pet/"+ $pet.petImg +"\" width=\"152px\" height=\"114px\"></td>").appendTo($tr);
		
		$("<td style='height:114px; line-height:114px;'></td>").text($pet.petName).appendTo($tr);
		
		var petSort = "강아지";
		if($pet.petSort==2) petSort="고양이";
		else if($pet.petSort==3) petSort="기타";
		$("<td style='height:114px; line-height:114px;'></td>").text(petSort).appendTo($tr);
		
		var petState = "대기";
		var mercyDate = $pet.mercyDate;
		if($pet.cancle==1) petState="취소"
		else if($pet.petState==2) petState="접수";
		else if($pet.petState==3) petState="진행";
		else if($pet.petState==4) {
			petState="입양";
			mercyDate="-";
		}
		
		$("<td style='height:114px; line-height:114px;'></td>").text(mercyDate).appendTo($tr);
		
		var $td = $("<td style='line-height:36px;'></td>").appendTo($tr);
		$("<span>"+$pet.memberName+"("+$pet.memberId+")</span><br><span>"+$pet.adoptTel+"</span><br><span>["+$pet.adoptApplyDate+"]</span>").appendTo($td);
		
		$("<td style='height:114px; line-height:114px;'></td>").text(petState).appendTo($tr);
		var adoptDate = $pet.adoptDate;
		if(adoptDate==null) adoptDate="-";
		$("<td style='height:114px; line-height:114px;'></td>").text(adoptDate).appendTo($tr);
		var cancleDate = $pet.cancleDate;
		if(cancleDate==null) cancleDate="-";
		$("<td style='height:114px; line-height:114px;'></td>").text(cancleDate).appendTo($tr);
		$("<td style='height:114px; line-height:114px;'><a href='/jnj/center/adopt/view?petNo="+$pet.petNo+"&memberId="+$pet.memberId+"&adoptNo="+$pet.adoptNo+"'>상세보기</a></td>").appendTo($tr);
		//var $link = $("<a>").attr("href", "/zboard1/board/read_board?bno=" + $board.bno);
		//$title.wrapInner($link);
	});
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('<').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/adopt/record?pageno='+ $pagination.prev + '&sort=' + $sort))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/adopt/record?pageno='+ i + '&sort=' + $sort).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/center/adopt/record?pageno='+ i + '&sort=' + $sort))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('>').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/center/adopt/record?pageno='+ $pagination.next + '&sort=' + $sort));
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
	.td {
		line-height: 50px;
		height: 50px;
	}
</style>
</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info" class="normalState">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" class="normalState">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt" style="color: navy; font-weight: 700; font-size: 20px;">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer" class="normalState">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna/record">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign" class="normalState">회원탈퇴</a></h4>
	<hr>
	<div class="container petListInCenter">
		<h3>센터 입양 리스트</h3>
		<div style="text-align: right; float:right; margin-bottom: 10px;">
		<a href="#" id="sort1">최신순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" id="sort2">입양일순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" id="sort3">상태순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" id="sort4">이름순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" id="sort5">동물번호순</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
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