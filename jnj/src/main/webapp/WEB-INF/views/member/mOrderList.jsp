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
	.mOrderList h3 {
		color: #7F5926;
	}
	.mOrderList thead:first-of-type {
		background-color: #FFB24C;
	}
	.mOrderList .table,.mOrderList th {
		text-align: center;
	}
	.mOrderList .table {
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
			console.log(principal);
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
	var mOrderList = map.mOrderList;
	var $pagination = map.pagination;
	var memberId = ${memberId};
	
	var tbody = $(".mOrdertable tbody");
	
	$.each(mOrderList, function(idx, mOrder) {
		var tr = $("<tr></tr>").appendTo(tbody);
		var date = $("<td></td>").appendTo(tr);
		$("<span></span>").text(mOrder.orderListOrders.ORDERDATE).appendTo(date);
		$("<br>").appendTo(date);
		$("<span></span>").text("("+mOrder.orderListOrders.ORDERNO+")").appendTo(date);
		var img = $("<td></td>").appendTo(tr);
		var view1 = $("<a></a>").attr("href", "/jnj/member/store/view?orderNo="+mOrder.orderListOrders.ORDERNO).appendTo(img);
		console.log(mOrder.orderListImg.GOODSIMG+idx)
		$("<img>").attr("src", "/jnjimg/goods/"+mOrder.orderListImg.GOODSIMG).attr("alt", "이미지 찾자").attr("width", "100px").appendTo(view1);
		var goods = $("<td></td>").appendTo(tr);
		var view2 = $("<a></a>").attr("href", "/jnj/member/store/view?orderNo="+mOrder.orderListOrders.ORDERNO).appendTo(goods);
		$("<span></span>").text(mOrder.orderListGoodsName.GOODSNAME).appendTo(view2);
		$("<br>").appendTo(view2);
		$("<span></span>").text(mOrder.orderListGoodsOption.OPTIONCONTENT).appendTo(view2);
		var orderqnt = $("<td></td>").text(mOrder.orderListQnt+"개").appendTo(tr);
		
		$("<td></td>").text(numberWithCommas(mOrder.orderListOrders.PAYMONEY)+"원").appendTo(tr);
		var state = mOrder.orderListOrders.ORDERSTATE;
		if(state==0) {
			$("<td></td>").text("주문취소").appendTo(tr);
		} else if(state==1) {
			$("<td></td>").text("주문완료").appendTo(tr);
		} else if(state==2) {
			$("<td></td>").text("입금완료").appendTo(tr);
		} else if(state==3) {
			$("<td></td>").text("배송준비중").appendTo(tr);
		} else if(state==4) {
			$("<td></td>").text("배송중").appendTo(tr);
		} else if(state==5) {
			$("<td></td>").text("배송완료").appendTo(tr);
		} else if(state==6) {
			$("<td></td>").text("교환/환불접수").appendTo(tr);
		} else if(state==7) {
			$("<td></td>").text("교환/환불중").appendTo(tr);
		} else if(state==8) {
			$("<td></td>").text("교환/환불완료").appendTo(tr);
		} else if(state==9) {
			$("<td></td>").text("구매확정").appendTo(tr);
		}
	})

	
	var ul = $("#pagination");
	var li;
 	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr("href", "/jnj/member/store/record?memberId="+memberId+"&pageNo="+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr("href", "/jnj/member/store/record?memberId="+memberId+"&pageNo="+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a").attr("href", "/jnj/member/store/record?memberId="+memberId+"&pageNo="+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr("href", "/jnj/member/store/record?memberId="+memberId+"&pageNo="+ $pagination.next));
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
	<div class="container mOrderList">
		<h3>구매내역</h3>
		<hr/>
		<table class="table mOrdertable">
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			<colgroup width="40%"/>
			<colgroup width="10%"/>
			<colgroup width="10%"/>
			<colgroup width="10%"/>
			<thead>
				<tr>
					<th><span>주문날짜</span><br><span>(주문번호)</span></th>
					<th>이미지</th>
					<th>상품정보</th>
					<th>수량</th>
					<th>총 금액</th>
					<th>주문처리상태</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<br>
		<br>
		<div class="container2">
			<ul class="pager" id="pagination">
			</ul>
		</div>
		<br><br><br>
	</div>
</body>
</html>