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
	.mChangeReturn h3, .mChangeReturn h4 {
		color: #7F5926;
	}
	.mReChangeTable th {
		background-color: #FFB24C;
	}
	.mReChangeTable,.mReChangeTable th {
		text-align: center;
	}
	.mChangeReturn #bank {
		display: inline;
		width: 130px;
	}
	.mChangeReturn #account {
		display: inline;
		width: 50%;
	}
	.mChangeReturn button {
		margin-left: 48%;
		margin-right: 10px;
		background-color: #FFB24C;
		color: #7F5926;
	}
	.mChangeReturn button:hover {
		background-color: #7F5926;
		color: #FFB24C;
	}
	.mChangeReturn .tab-content {
		padding: 70px;
	}
	.mChangeReturn textarea {
		height: 300px;
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
	
	
	// 주문번호, 굿즈번호, 옵션번호
	
	//주문 상품 정보
	var table = $(".mReChangeTable tbody");
	
	$.each(orderViewOrders, function(idx, orderView) {
		var goodstr = $("<tr></tr>").appendTo(table);
		var checktd = $("<td></td>").appendTo(goodstr);
		var checkdiv = $("<div></div>").attr("class", "checkbox").appendTo(checktd);
		var checklabel = $("<label></label>").appendTo(checkdiv);
		var stateO = orderView.orderViewOrders.ORDERRECORDSTATE;
		if(stateO==6 || stateO==7 || stateO==9)
			$("<input>").attr("type", "checkbox").attr("disabled", true).attr("value", orderView.orderViewOrders.GOODSNO).appendTo(checklabel);
		else
			$("<input>").attr("type", "checkbox").attr("value", orderView.orderViewOrders.GOODSNO).appendTo(checklabel);
		
		
		var goodsNotd = $("<td></td>").appendTo(goodstr);
		$("<span></span>").text(orderViewPay[0].ORDERDATE).appendTo(goodsNotd);
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
		$("<input>").attr("type", "hidden").attr("name", "optionNo").attr("value", orderView.orderViewOrders.OPTIONNO).appendTo(goodsNametd);
		$("<td></td>").text(orderView.orderViewOrders.ORDERQNT+"개").appendTo(goodstr);
		$("<td></td>").text(numberWithCommas(orderView.orderViewOrders.MONEY)+"원").appendTo(goodstr);
		var statetd = $("<td></td>").appendTo(goodstr);
		var state = orderView.orderViewOrders.ORDERRECORDSTATE;
		if(state==0) {
			statetd.text("주문취소");
		} else if(state==1) {
			statetd.text("주문완료");
		} else if(state==2) {
			statetd.text("입금완료");
		} else if(state==3) {
			statetd.text("배송준비중");
		} else if(state==4) {
			statetd.text("배송중");
		} else if(state==5) {
			statetd.text("배송완료");
		} else if(state==6) {
			statetd.text("교환/환불접수");
		} else if(state==7) {
			statetd.text("교환/환불중");
		} else if(state==8) {
			statetd.text("교환/환불완료");
		} else if(state==9) {
			statetd.text("구매확정");
		}	 
	})
	
	var totoaltr = $("<tr></tr>").appendTo(table);
	$("<th></th>").attr("colspan", 5).appendTo(totoaltr);
	var totoaltd = $("<th></th>").attr("id", "totalprice").attr("colspan", 2).appendTo(totoaltr);
	$("<span></span>").text("총 합계 : ").appendTo(totoaltd);
	$("<span></span>").text(numberWithCommas(orderViewPay[0].PAYMONEY)+"원").appendTo(totoaltd);
	
	


	
	
	// 교환
	$("#change").on("click", function() {
		if($("input:checkbox:checked").length==0) {
			alert("교환할 상품을 선택하세요");
			if($("#changecause").val()=="") {
				alert("교환 사유를 입력하세요");
				return false;
			}
		} else {
			if($("#changecause").val()=="") {
				alert("교환 사유를 입력하세요");
				return false;
			}	
		}
		
		var form = $("<form></form>").attr("action", "/jnj/member/store/change").attr("method", "post");
		var menu1 = $("#menu1");
		$("<input>").attr("type", "hidden").attr("name", "orderNo").attr("value", orderViewPay[0].ORDERNO ).appendTo(menu1);
		$("<input>").attr("type", "hidden").attr("name", "refundDivision").attr("value", 2).appendTo(menu1);
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo(menu1);
		$("input:checkbox:checked").each(function (index) {  
			var optionNoval = $(this).parents("tr").children().eq(3).children().eq(1).val()
			$("<input>").attr("type", "hidden").attr("name", "goodsNo").attr("value", $(this).val()).appendTo(menu1);
			$("<input>").attr("type", "hidden").attr("name", "optionNo").attr("value", optionNoval).appendTo(menu1);
	    });
		alert("신청이 완료되었습니다");
		$("#menu1").wrap(form);
		$("#change").attr("type", "submit");
	})
	
	
	// 환불
	$("#refund").on("click", function() {
		if($("input:checkbox:checked").length==0) {
			alert("환불할 상품을 선택하세요");
			return false;
		}
		if($("#refundcause").val()=="") {
			alert("환불 사유를 입력하세요");
			return false;
		}	
		if($("select option:selected").val()=="none") {
			alert("은행을 선택하세요");
			return false;
		}
		if($("#account").val()=="") {
			alert("환불 계좌를 입력하세요");
			return false;
		}
		if($("#holder").val()=="") {
			alert("예금주를 입력하세요");
			return false;
		}
		
		
		
		var form = $("<form></form>").attr("action", "/jnj/member/store/refund").attr("method", "post");
		var menu2 = $("#menu2");
		$("<input>").attr("type", "hidden").attr("name", "orderNo").attr("value", orderViewPay[0].ORDERNO ).appendTo(menu2);
		$("<input>").attr("type", "hidden").attr("name", "refundDivision").attr("value", 1).appendTo(menu2);
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo(menu2);
		$("input:checkbox:checked").each(function (index) {  
			var optionNoval = $(this).parents("tr").children().eq(3).children().eq(1).val();
			$("<input>").attr("type", "hidden").attr("name", "goodsNo").attr("value", $(this).val()).appendTo(menu2);
			$("<input>").attr("type", "hidden").attr("name", "optionNo").attr("value", optionNoval).appendTo(menu2);
	    });
		alert("신청이 완료되었습니다");
		$("#menu2").wrap(form);
		$("#refund").attr("type", "submit");
	})
})
</script>
</head>
<body>
	<div class="container mChangeReturn">
		<h3>교환/환불 신청</h3>
		<hr/>
		<table class="table mReChangeTable">
			<colgroup width="5%"/>
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			<colgroup width="40%"/>
			<colgroup width="5%"/>
			<colgroup width="10%"/>
			<colgroup width="10%"/>
			<thead>
				<tr>
					<th></th>
					<th><span>주문날짜</span><br><span>(주문번호)</span></th>					
					<th>이미지</th>
					<th>상품정보</th>
					<th>수량</th>
					<th>상품구매금액</th>
					<th>주문처리상태</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<br>
		<div class="rechangeform">
			<ul class="nav nav-tabs">
			    <li class="active"><a data-toggle="tab" href="#menu1">교환</a></li>
			    <li><a data-toggle="tab" href="#menu2">환불</a></li>
			</ul>
			<div class="tab-content">
			    <div id="menu1" class="tab-pane fade in active">
			    	<div class="form-group">
  						<label for="pwd"><h4>교환 사유</h4></label>
  						<textarea class="form-control" id="changecause" name="refundReason" placeholder="내용을 입력하세요"></textarea>
						<br><br><br>
						<div class="form-group">
							<button id="change" type="button" class="btn btn-default">신청</button>
						</div>
					</div>
			    </div>
			    <div id="menu2" class="tab-pane fade">
					<div class="form-group">
  						<label for="refundcause"><h4>환불 사유</h4></label>
  						<textarea class="form-control" id="refundcause" name="refundReason" placeholder="내용을 입력하세요"></textarea>
					</div>
					<div class="form-group">
						<label for="refundaccout"><h4>환불 계좌</h4></label><br>
						<select id="bank" name="refundAccountBank" class="form-control">
							<option value="none">은행 선택</option>
							<option value="국민은행">국민은행</option>
							<option value="우리은행">우리은행</option>
							<option value="신한은행">신한은행</option>
							<option value="우체국">우체국</option>
						</select>
						<input type="text" class="form-control" id="account" name="refundAccountNo" placeholder="계좌번호">
						<div class="form-group">
  							<label for="refundcause"><h4>예금주</h4></label>
  							<input type="text" class="form-control" id="holder" name="refundAccountHolder" placeholder="예금주">
						</div>
						<br><br><br>
						<div class="form-group">
							<button id="refund" class="btn btn-default">신청</button>
						</div>
					</div>	
			    </div>
			</div>
		</div>
		<br><br><br>
	</div>
</body>
</html>