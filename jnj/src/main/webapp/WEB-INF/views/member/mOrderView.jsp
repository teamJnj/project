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
	.mOrderView h2, .mOrderView h3 {
		color: #7F5926;
	}
	.mOrderView th, .mOrderView #totalprice {
		background-color: #FFB24C;
	}
	.mOrderView .table,.mOrderView th {
		text-align: center;
	}
	.mOrderView .table {
		margin-top: 30px;
	}
	.mOrderView #totalprice span {
		font-size: 1.1em;
	}
	.mOrderView #totalprice span:first-of-type {
		margin-right: 25%;
	}
	.mOrderView button {
		margin-right: 10px;
		background-color: #FFB24C;
		color: #7F5926;
	}
	.mOrderView button:hover {
		background-color: #7F5926;
		color: #FFB24C;
	}
	.mOrderView #list {
		margin-left: 45%;
	}
</style>
<script>
//단위 , 찍기
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

$(function() {
	var map = ${map};
	var orderViewOrders = map.orderViewOrders;
	var orderViewDelivery = map.orderViewDelivery;
	var orderViewPay = map.orderViewPay;
	
	// 주문 정보
	var orderview1 = $(".orderview1 tbody");
	var orderNotr = $("<tr></tr>").appendTo(orderview1);
	$("<th></th>").text("주문번호").appendTo(orderNotr);
	$("<td></td>").text(orderViewPay[0].ORDERNO).appendTo(orderNotr);
	var orderDatetr = $("<tr></tr>").appendTo(orderview1);
	$("<th></th>").text("주문날짜").appendTo(orderDatetr);
	$("<td></td>").text(orderViewPay[0].ORDERDATE).appendTo(orderDatetr);
	var depositortr = $("<tr></tr>").appendTo(orderview1);
	$("<th></th>").text("주문자").appendTo(depositortr);
	$("<td></td>").text(orderViewPay[0].ORDERID).appendTo(depositortr);
	var orderStatetr = $("<tr></tr>").appendTo(orderview1);
	$("<th></th>").text("주문처리상태").appendTo(orderStatetr);
	
	var allstate = orderViewPay[0].ORDERSTATE;
	
	if (allstate == 0) {
		$("<td></td>").text("주문취소").appendTo(orderStatetr);
	} else if (allstate == 1) {
		$("<td></td>").text("주문완료").appendTo(orderStatetr);
	} else if (allstate == 2) {
		$("<td></td>").text("입금완료").appendTo(orderStatetr);
	} else if (allstate == 3) {
		$("<td></td>").text("배송준비중").appendTo(orderStatetr);
	} else if (allstate == 4) {
		$("<td></td>").text("배송중").appendTo(orderStatetr);
	} else if (allstate == 5) {
		$("<td></td>").text("배송완료").appendTo(orderStatetr);
	} else if (allstate == 6) {
		$("<td></td>").text("교환/환불접수").appendTo(orderStatetr);
	} else if (allstate == 7) {
		$("<td></td>").text("교환/환불중").appendTo(orderStatetr);
	} else if (allstate == 8) {
		$("<td></td>").text("교환/환불완료").appendTo(orderStatetr);
	} else if (allstate == 9) {
		$("<td></td>").text("구매확정").appendTo(orderStatetr);
	}

	// 결제 정보
	var orderview2 = $(".orderview2 tbody");
	var payMoneytr = $("<tr></tr>").appendTo(orderview2);
	$("<th></th>").text("총 주문금액").appendTo(payMoneytr);
	$("<td></td>").text(numberWithCommas(orderViewPay[0].PAYMONEY) + "원").appendTo(payMoneytr);
	var payMoneytr2 = $("<tr></tr>").appendTo(orderview2);
	$("<th></th>").text("총 결제금액").appendTo(payMoneytr2);
	$("<td></td>").text(numberWithCommas(orderViewPay[0].PAYMONEY) + "원").appendTo(payMoneytr2);
	var paywaytr = $("<tr></tr>").appendTo(orderview2);
	$("<th></th>").text("결제수단").appendTo(paywaytr);
	var paywaytd = $("<td></td>").appendTo(paywaytr);
	if (orderViewPay[0].PAYWAY == 1) {
		$("<span></span>").text("신용카드").appendTo(paywaytd);
	} else if (orderViewPay[0].PAYWAY == 2) {
		$("<span></span>").text("무통장입금").appendTo(paywaytd);
	}

	$("<br>").appendTo(paywaytd);
	if(orderViewPay[0].DEPOSITOR==null) {
		
	} else {
		$("<span></span>").text("입금자 : ").appendTo(paywaytd);
		$("<span></span>").text(orderViewPay[0].DEPOSITOR).appendTo(paywaytd);
		$("<br>").appendTo(paywaytd);
		$("<span></span>").text(" 계좌번호 : ").appendTo(paywaytd);
		$("<span></span>").text("신한은행 ").appendTo(paywaytd);
		$("<span></span>").text("412-195684-5124847").appendTo(paywaytd);
	}
	

	// 주문 상품 정보
	var orderview3 = $(".orderview3 tbody");

	$.each(orderViewOrders, function(idx, orderView) {
		var goodstr = $("<tr></tr>").appendTo(orderview3);
		var goodsNotd = $("<td></td>").attr("rowspan", 2).appendTo(goodstr);
		$("<span></span>").text(orderViewPay[0].ORDERDATE).appendTo(goodsNotd);
		$("<br>").appendTo(goodsNotd);
		$("<span></span>").text("(" + orderView.orderViewOrders.GOODSNO	+ ")").appendTo(goodsNotd);
		var imgtd = $("<td></td>").attr("rowspan", 2).appendTo(goodstr);
		var imga = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo=" + orderView.orderViewOrders.GOODSNO).appendTo(imgtd);
		$("<img>").attr("src", "/jnjimg/goods/" + orderView.orderViewImg.GOODSIMG).attr("alt", "사진안나옴").css("height", "100px").appendTo(imga);
		var goodsNametd = $("<td></td>").attr("rowspan", 2).appendTo(goodstr);
		var goodsNamea = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo=" + orderView.orderViewOrders.GOODSNO).appendTo(goodsNametd);
		$("<span></span>").text(orderView.orderViewOrders.GOODSNAME).appendTo(goodsNamea);
		$("<br>").appendTo(goodsNamea);
		$("<span></span>").text(orderView.orderViewOption.OPTIONCONTENT).appendTo(goodsNamea);
		$("<td></td>").attr("rowspan", 2).text(orderView.orderViewOrders.ORDERQNT + "개").appendTo(goodstr);
		$("<td></td>").attr("rowspan", 2).text(numberWithCommas(orderView.orderViewOrders.MONEY) + "원").appendTo(goodstr);
		var statetd = $("<td></td>").appendTo(goodstr);
		var state = orderView.orderViewOrders.ORDERRECORDSTATE;
		if(state==0) {
			statetd.text("주문취소").appendTo(statetd);
		} else if(state==1) {
			statetd.text("주문완료").appendTo(statetd);
		} else if(state==2) {
			statetd.text("입금완료").appendTo(statetd);
		} else if(state==3) {
			statetd.text("배송준비중").appendTo(statetd);
		} else if(state==4) {
			statetd.text("배송중").appendTo(statetd);
		} else if(state==5) {
			statetd.text("배송완료").appendTo(statetd);
		} else if(state==6) {
			statetd.text("교환/환불접수").appendTo(statetd);
		} else if(state==7) {
			statetd.text("교환/환불중").appendTo(statetd);
		} else if(state==8) {
			statetd.text("교환/환불완료").appendTo(statetd);
		} else if(state==9) {
			statetd.text("구매확정").appendTo(statetd);
		}			
		var goodstr2 = $("<tr></tr>").appendTo(orderview3);
		var reviewbtn = $("<td></td>").attr("data-no", orderView.orderViewOrders.GOODSNO + "/" + orderView.orderViewOption.OPTIONNO).appendTo(goodstr2);
		var reviewdiv = $("<div class='form-group'></div>").appendTo(reviewbtn);
		if (state == 5)
			$("<button class='review' type='button' class='btn btn-default'>구매확정</button>").appendTo(reviewdiv);
		else {
			$("<button class='review' type='button' class='btn btn-default'></button>").appendTo(reviewdiv);
			$(reviewdiv).empty();
		}
	})
	var totoaltr = $("<tr></tr>").appendTo(orderview3);
	$("<th></th>").attr("colspan", 4).appendTo(totoaltr);
	var totoaltd = $("<th></th>").attr("id", "totalprice").attr("colspan", 2).appendTo(totoaltr);
	$("<span></span>").text("총 합계 : ").appendTo(totoaltd);
	$("<span></span>").text(numberWithCommas(orderViewPay[0].PAYMONEY) + "원").appendTo(totoaltd);

	// 배송지 정보
	var orderview4 = $(".orderview4 tbody");
	var recipienttr = $("<tr></tr>").appendTo(orderview4);
	$("<th></th>").text("수령인").appendTo(recipienttr);
	$("<td></td>").text(orderViewDelivery[0].RECIPIENT).appendTo(recipienttr);
	var addrtr = $("<tr></tr>").appendTo(orderview4);
	$("<th></th>").text("주소").appendTo(addrtr);
	$("<td></td>").text(orderViewDelivery[0].RECIPIENTADDR).appendTo(addrtr);
	var teltr = $("<tr></tr>").appendTo(orderview4);
	$("<th></th>").text("전화번호").appendTo(teltr);
	$("<td></td>").text(orderViewDelivery[0].ORDERTEL).appendTo(teltr);
	var memotr = $("<tr></tr>").appendTo(orderview4);
	$("<th></th>").text("배송 메모").appendTo(memotr);
	$("<td></td>").text(orderViewDelivery[0].MEMO).appendTo(memotr);
	var btndiv = $("#btncancle");
	$("<button id='list' type='button' class='btn btn-default'>목록으로</button>").appendTo(btndiv);
	if (orderViewPay[0].ORDERSTATE == 1)
		$("<button id='cancle' type='button' class='btn btn-default'>주문취소</button>").appendTo(btndiv);
	else if (orderViewPay[0].ORDERSTATE == 0) {
		$("#btncancle").empty();
		$("<button id='list' type='button' class='btn btn-default'>목록으로</button>").appendTo(btndiv);
	} else
		$("<button id='rechange' type='button' class='btn btn-default'>교환/환불신청</button>").appendTo(btndiv);

	// 배송조회
	/* $(".delivery").on("click", function() {
			
		var $review = window.open("", "배송조회", "width=810, height=600");
			
			
		var $div = $(this).parent("div");
		var $no = $(this).parents().eq(1).attr("data-no");
		var $goodsNo = $no.split('/')[0];
		var $optionNo = $no.split('/')[1];
		var $form = $("<form></form>").attr("target", "배송조회").attr("action", "/jnj/menu/store/comment/1").attr("method", "post");
			
		$("<input type='hidden' name='goodsNo' value='"+$goodsNo+"'>").appendTo($div);
		$("<input type='hidden' name='optionNo' value='"+$optionNo+"'>").appendTo($div);
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($div);
			
			
		$div.wrap($form);
		$(this).attr("type", "submit");
	}) */

	// 후기 작성 페이지 띄우기
	$(".review").on("click", function() {
		var $review = window.open("", "리뷰작성", "width=810, height=600");

		var $div = $(this).parent("div");
		var $no = $(this).parents().eq(1).attr("data-no");
		var $goodsNo = $no.split('/')[0];
		var $optionNo = $no.split('/')[1];
		var $form = $("<form></form>").attr("target", "리뷰작성").attr("action", "/jnj/member/store/comment/1").attr("method", "post");

		$("<input type='hidden' name='orderNo' value='"+orderViewPay[0].ORDERNO+"'>").appendTo($div);
		$("<input type='hidden' name='goodsNo' value='"+$goodsNo+"'>").appendTo($div);
		$("<input type='hidden' name='optionNo' value='"+$optionNo+"'>").appendTo($div);
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($div);

		$div.wrap($form);
		$(this).attr("type", "submit");
	})

	// 교환 버튼
	$(document).on("click", "#rechange", function() {
		var cnt = 0;
		for (var i = 0; i < orderViewOrders.length; i++) {
			if(orderViewOrders[i].orderViewOrders.ORDERRECORDSTATE == 7) {
				cnt++;
			}
		}

		if(cnt == orderViewOrders.length) {
			alert("이미 교환/환불중입니다")
		} else {
			location.href = "/jnj/member/store/rechange_apply?orderNo=" + orderViewPay[0].ORDERNO;
		}
	})

	// 취소 버튼
	$(document).on("click", "#cancle", function() {
		var cancleform = $("<form></form>").attr("action", "/jnj/member/store/cancle").attr("method", "post");
		$("<input type='hidden' name='orderNo' value='"+orderViewPay[0].ORDERNO+"'>").appendTo(cancleform);
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(cancleform);
		$("#btncancle").wrap(cancleform);
		$(this).attr("type", "submit");
	})

	// 목록으로
	$(document).on("click", "#list", function() {
		location.href = "/jnj/member/store/record?orderId=" + ${writeId};
	})

})
</script>
</head>
<body>
	<div class="container mOrderView">
		<h3>주문 상세 내역</h3>
		<hr/>
		<h2>주문정보</h2>
		<table class="table orderview1">
			<colgroup width="40%"/>
			<colgroup width="60%"/>
			<tbody>	
			</tbody>
		</table>
		<br>
		<h2>결제정보</h2>
		<table class="table orderview2">
			<colgroup width="40%"/>
			<colgroup width="60%"/>
			<tbody>
			</tbody>
		</table>
		<br>
		<h2>주문 상품 정보</h2>
		<table class="table orderview3">
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			<colgroup width="40%"/>
			<colgroup width="10%"/>
			<colgroup width="10%"/>
			<colgroup width="10%"/>
			<thead>
				<tr>
					<th><span>주문날짜</span><br><span>(상품번호)</span></th>
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
		<h2>배송지 정보</h2>
		<table class="table orderview4">
			<colgroup width="40%"/>
			<colgroup width="60%"/>
			<tbody>
			</tbody>
		</table>
		<br><br><br>
		<div class="form-group" id="btncancle">
			
		</div>
		<br><br>
	</div>
</body>
</html>