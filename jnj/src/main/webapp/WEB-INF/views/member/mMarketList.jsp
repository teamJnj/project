<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<style>
	.mMarketList h3 {
		color: #7F5926;
	}
	.mMarketList thead:first-of-type {
		background-color: #FFB24C;
	}
	.mMarketList .table,.mMarketList th {
		text-align: center;
	}
	.mMarketList .table {
		margin-top: 30px;
	}
</style>
<script>
//단위 , 찍기
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

$(function() {
	// 상단 메뉴바
	$.ajax({
		url:"/jnj/username",
		type:"get",
		data:$("form").serialize(),
		success:function(principal){
			$("#minfo").attr("href", "/jnj/member/info?memberId="+principal);
			$("#msponsor").attr("href", "/jnj/member/sponsor/record?memberId="+principal);
			$("#madopt").attr("href", "/jnj/member/adopt/record?memberId="+principal);
			$("#mvolunteer").attr("href", "/jnj/member/volunteer/record?memberId="+principal);
			$("#mmarket").attr("href", "/jnj/member/market/record?memberId="+principal);
			$("#mstore").attr("href", "/jnj/member/store/record?orderId="+principal);
			$("#mqna").attr("href", "/jnj/common/qna/record?writeId="+principal);
			$("#mresign").attr("href", "/jnj/member/resign?memberId="+principal);
		}
	});
	
	var map = ${map};
	var $mMarketList = map.mMarketList;
	var $pagination = map.pagination;
	var memberId = ${memberId};
	console.log($mMarketList);
	
	var tbody = $(".marketlist tbody");
	var tr = $("<tr></tr>").appendTo(tbody);
	
	$.each($mMarketList, function(idx, mMarket) {
		var tr = $("<tr></tr>").appendTo(tbody);
		var title = $("<td></td>").appendTo(tr);
		$("<a></a>").attr("href", "/jnj/member/market/view?marketNo="+mMarket.MARKETNO).text(mMarket.MARKETTITLE).appendTo(title);
		$("<td></td>").text(mMarket.MARKETDATE).appendTo(tr);
		if(mMarket.APPLYPEAPLE==0) 
			$("<td></td>").text(0+"/"+40).appendTo(tr);
		else
			$("<td></td>").text(mMarket.APPLYPEAPLE+"/"+40).appendTo(tr);
		$("<td></td>").text(mMarket.BOOTHNUM+"개").appendTo(tr);
		$("<td></td>").text(numberWithCommas(mMarket.PAYMONEY)+"원").appendTo(tr);
		if(mMarket.MARKETAPPLYSTATE==0)
			$("<td></td>").text("취소").appendTo(tr);
		else if(mMarket.MARKETAPPLYSTATE==1)
			$("<td></td>").text("신청완료").appendTo(tr);
		else if(mMarket.MARKETAPPLYSTATE==2)
			$("<td></td>").text("완료").appendTo(tr);
		else if(mMarket.MARKETAPPLYSTATE==3)
			$("<td></td>").text("인원미달").appendTo(tr);
		
	})
	
	var ul = $("#pagination");
	var li;
 	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr("href", "/jnj/member/market/record?memberId="+memberId+"&pageNo="+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr("href", "/jnj/member/market/record?memberId="+memberId+"&pageNo="+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a").attr("href", "/jnj/member/market/record?memberId="+memberId+"&pageNo="+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr("href", "/jnj/member/market/record?memberId="+memberId+"&pageNo="+ $pagination.next));
	} 	
})
</script>
</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="minfo">개인정보수정</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="msponsor">후원내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="madopt">입양내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mvolunteer">봉사내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mmarket">프리마켓내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mstore">구매내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mqna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mresign">회원탈퇴</a></h4>
	<hr>
	<div class="container mMarketList">
		<h3>프리마켓내역</h3>
		<hr/>
		<table class="table marketlist">
			<colgroup width="30%"/>
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			<colgroup width="10%"/>
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			<thead>
				<tr>
					<th>제목</th>
					<th>개최 날짜</th>
					<th>신청인원</th>
					<th>부스개수</th>
					<th>참가비</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<br>
		<br>
		<div class="container2">
			<ul class="pager" id="pagination">
				<!-- <li><a href="#">이전으로</a></li>
						<li><a href="#">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
				<li><a href="#">다음으로</a></li> -->
			</ul>
		</div>
		<br><br><br>
	</div>
</body>
</html>