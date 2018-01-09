<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<script>
//단위 , 찍기
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

$(function() {
	var map = ${map};
	var orders = map.orderViewOrders;
	var delivery = map.orderViewDelivery;
	var pay = map.orderViewPay;
	var memberId = ${memberId};
	
	var table1 = $(".success1 tbody");
	var tr1 = $("<tr></tr>").appendTo(table1);
	$("<th></th>").text("주문번호").appendTo(tr1);
	$("<td></td>").text(pay[0].ORDERNO).appendTo(tr1);
	var tr2 = $("<tr></tr>").appendTo(table1);
	$("<th></th>").text("배송지정보").appendTo(tr2);
	var deli = $("<td></td>").appendTo(tr2);
	$("<span></span>").text(delivery[0].RECIPIENT).appendTo(deli);
	$("<br>").appendTo(deli);
	$("<span></span>").text(delivery[0].ORDERTEL).appendTo(deli);
	$("<br>").appendTo(deli);
	$("<span></span>").text(delivery[0].RECIPIENTADDR).appendTo(deli);
	var tr3 = $("<tr></tr>").appendTo(table1);
	$("<th></th>").text("결제정보").appendTo(tr3);
	var money = $("<td></td>").appendTo(tr3);
	if(pay[0].DEPOSITOR==null) {
		$("<span></span>").text("신용카드").appendTo(money);
		$("<br>").appendTo(money);
		$("<span></span>").text(numberWithCommas(pay[0].PAYMONEY)+"원").appendTo(money);
	} else {
		$("<span></span>").text(pay[0].DEPOSITOR).appendTo(money);
		$("<br>").appendTo(money);
		$("<span></span>").text(numberWithCommas(pay[0].PAYMONEY)+"원").appendTo(money);
		$("<br>").appendTo(money);
		$("<span></span>").text("412-195684-5124847").appendTo(money);
	}
	
	var table2 = $(".success2 tbody");
	
	$.each(orders, function(idx, orderView) {
		var goodstr = $("<tr></tr>").appendTo(table2);
		var goodsNotd = $("<td></td>").appendTo(goodstr);
		$("<span></span>").text(pay[0].ORDERDATE).appendTo(goodsNotd);
		$("<br>").appendTo(goodsNotd);
		$("<span></span>").text("("+orderView.orderViewOrders.GOODSNO+")").appendTo(goodsNotd);
		var imgtd = $("<td></td>").appendTo(goodstr);
		var imga = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo="+orderView.orderViewOrders.GOODSNO).appendTo(imgtd);
		$("<img>").attr("src", "/jnjimg/goods/"+orderView.orderViewImg.GOODSIMG).attr("alt", "사진안나옴").css("height", "100px").appendTo(imga);
		var goodsNametd = $("<td></td>").appendTo(goodstr);
		var goodsNamea = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo="+orderView.orderViewOrders.GOODSNO).appendTo(goodsNametd);
		$("<span></span>").text(orderView.orderViewOrders.GOODSNAME).appendTo(goodsNamea);
		$("<br>").appendTo(goodsNamea);
		$("<span></span>").text(orderView.orderViewOption.OPTIONCONTENT).appendTo(goodsNamea);
		$("<td></td>").text(orderView.orderViewOrders.ORDERQNT+"개").appendTo(goodstr);
		$("<td></td>").text(numberWithCommas(orderView.orderViewOrders.MONEY)+"원").appendTo(goodstr);	
	})
	var totoaltr = $("<tr></tr>").appendTo(table2);
	$("<th></th>").attr("colspan", 3).appendTo(totoaltr);
	var totoaltd = $("<th></th>").attr("id", "totalprice").attr("colspan", 2).appendTo(totoaltr);
	$("<span></span>").text("총 합계 : ").appendTo(totoaltd);
	$("<span></span>").text(numberWithCommas(pay[0].PAYMONEY)+"원").appendTo(totoaltd);

	$("#store").on("click", function() {
		location.href = "/jnj/menu/store/record";
	})
	$("#myorder").on("click", function() {
		location.href = "/jnj/member/store/record?memberId="+memberId;
	})
})
</script>
<style>
#success {
	margin: 100px;
}
</style>
</head>
<body>
<div id="success">
	<h1>주문이 완료되었습니다.</h1>
	<br>
	<table class="table success1">
		<colgroup width="20%" />
		<colgroup width="80%" />
		<tbody>
		</tbody>
	</table>
	<br><br>
	<table class="table success2">
		<colgroup width="15%" />
		<colgroup width="20%" />
		<colgroup width="45%" />
		<colgroup width="10%" />
		<colgroup width="10%" />
		<thead>
			<tr>
				<th><span>주문날짜</span><br> <span>(상품번호)</span></th>
				<th>이미지</th>
				<th>상품정보</th>
				<th>수량</th>
				<th>총 금액</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<button type="button" id="store" class="btn btn-default">쇼핑계속하기</button>
	<button type="button" id="myorder" class="btn btn-default">주문내역확인</button>
</div>
</body>
</html>