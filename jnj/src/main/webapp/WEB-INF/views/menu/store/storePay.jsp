<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<style>
.storePay {
	margin-top: 100px;
}

.storePay h3 {
	color: #7F5926;
}

#order {
	margin-left: 380px;
	background-color: #FFB24C;
	color: #7F5926;
}

.storePay #zipcode {
	background-color: #7F5926;
	color: #FFB24C;
}

.storePay button:hover {
	background-color: #7F5926;
	color: #FFB24C;
}

.storePay thead {
	text-align: center;
	background-color: #FFB24C;
}
.payview img {
	height: 150px;
	width: 150px;
}
</style>
<script>
//단위 , 찍기
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

$(function() {
	var map = ${map};
	console.log(map);

	var tbody = $(".payview tbody");
	
	$.each(map, function(idx, pay) {
		var tr = $("<tr></tr>").attr("class", "list").appendTo(tbody);
		var img = $("<td></td>").appendTo(tr);
		var imga = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo="+pay.goods.GOODSNO).appendTo(img);
		$("<img>").attr("src", "/jnjimg/goods/"+pay.goodsImg).attr("alt", pay.goods.GOODSNO).appendTo(imga);
		var goods = $("<td></td>").appendTo(tr);
		$("<span></span>").text("상품번호 ").appendTo(goods);
		$("<span></span>").text(pay.goods.GOODSNO).appendTo(goods);
		$("<br>").appendTo(goods);
		$("<span></span>").text("상품명 ").appendTo(goods);
		$("<span></span>").text(pay.goods.GOODSNAME).appendTo(goods);
		$("<br>").appendTo(goods);
		$("<span></span>").text("옵션 ").appendTo(goods);
		$("<span></span>").text(pay.goodsOption.OPTIONCONTENT).appendTo(goods);
		$("<td></td>").text(pay.orderQnt+"개").appendTo(tr);
		$("<td></td>").text(numberWithCommas(pay.orderQnt*pay.goods.GOODSPRICE)+"원").appendTo(tr);
	})
	var total = $("<tr></tr>").attr("id", "totalprice").appendTo(tbody);
	$("<td></td>").attr("colspan", 3).appendTo(total);
	
	var payMoney = 0;
	var money = 0;
	var qnt = 0;
	var price = 0;
	$("tr[class=list]").each(function(i){
		qnt = map[i].orderQnt
		price = map[i].goods.GOODSPRICE;
		payMoney = payMoney+(qnt*price);
	})
	var totaltd = $("<td></td>").attr("colspan", 2).appendTo(total);
	$("<span></span>").text("총 합계 ").appendTo(totaltd);
	$("<span></span>").text(numberWithCommas(payMoney) + "원").appendTo(totaltd);
	
	$("#payWay").change(function() {
		var $payWay = $("#payWay option:selected").attr("value");
		if($payWay==2) {
			$("<label class='control-label col-sm-4' for='title'>입금자명</label>").appendTo("#deposit");
			var depo = $("<div class='col-sm-5'></div>").appendTo("#deposit");
			$("<input type='text' class='form-control' id='depositor' name='depositor' placeholder='입금자명'>").appendTo(depo);
		} else if($payWay==1) {
			$("#deposit").empty();
		}
	})
	
	/* 
	<label class='control-label col-sm-4' for='title'>입금자명</label>
	<div class='col-sm-5'>
		<input type='text' class='form-control' id='depositor' name='depositor' placeholder='입금자명'>
	</div> */

	
	var orderbtn = $(".orderbtn");
	var check = false;
	$("#order").on("click", function() {
		
		$("input").each(function(idx){
			console.log(check)
			if($(this).val()=="") {
				alert($(this).attr("placeholder")+"을(를) 입력하시오");
				console.log(check)
				check = true;
				console.log(check)
				return false;
			} 
		})
		if(check) { 
			check = false;
			return false;
		}
		
		else {
		
			if($("#checkbox1").prop("checked") && $("#checkbox2").prop("checked")) {
				$("tr[class=list]").each(function(idx){
					$("<input type='hidden' name='goodsNo' value='"+map[idx].goods.GOODSNO+"'>").appendTo(orderbtn);
					$("<input type='hidden' name='optionNo' value='"+map[idx].goodsOption.OPTIONNO+"'>").appendTo(orderbtn);
					$("<input type='hidden' name='orderQnt' value='"+map[idx].orderQnt+"'>").appendTo(orderbtn);
					$("<input type='hidden' name='money' value='"+map[idx].orderQnt*map[idx].goods.GOODSPRICE+"'>").appendTo(orderbtn);
					if(parseInt($("#payWay option:selected").val())==2) {
						$("<input type='hidden' name='orderRecordState' value='1'>").appendTo(orderbtn);
					} else if(parseInt($("#payWay option:selected").val())==1) {
						$("<input type='hidden' name='orderRecordState' value='2'>").appendTo(orderbtn);
					}	
				})
				
				if(parseInt($("#payWay option:selected").val())==2) {
					$("<input type='hidden' name='orderState' value='1'>").appendTo(orderbtn);
				} else if(parseInt($("#payWay option:selected").val())==1) {
					$("<input type='hidden' name='orderState' value='2'>").appendTo(orderbtn);
				}	
				$("<input type='hidden' name='payWay' value='"+$("#payWay option:selected").val()+"'>").appendTo(orderbtn);				
				$("<input type='hidden' name='payMoney' value='"+payMoney+"'>").appendTo(orderbtn);				
				$("<input type='hidden' name='orderTel' value='"+$("#tel1 option:selected").val()+$("#tel2").val()+"'>").appendTo(orderbtn);
				$("<input type='hidden' name='recipientAddr' value='("+$("#addr1").val()+")"+$("#addr2").val()+", "+$("#addr3").val()+"'>").appendTo(orderbtn);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo(orderbtn);
				$("#order").attr("type", "submit");
				
			} else {
				alert("동의 체크하시오");
			}	
		}
		check = false;
	})
	
	
	$("#zipcode").on("click", function() {
		  sample6_execDaumPostcode();
	})
})


// 주소 api
function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('addr1').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('addr2').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('addr3').focus();
            }
        }).open();
    }
    
  
</script>
</head>
<body>
	<div class="container storePay">
		<h3>주문하기</h3>
		<hr />
		<br>
		<table class="table payview">
			<colgroup width="30%" />
			<colgroup width="30%" />
			<colgroup width="20%" />
			<colgroup width="20%" />
			<thead>
				<tr>
					<th></th>
					<th>상품정보</th>
					<th>수량</th>
					<th>주문금액</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<br> <br>
		<hr />
		<h2>배송정보</h2>
		<form class="form-horizontal" method="post" action="/jnj/menu/store/order" id="form">
			<div class="form-group ">
				<label class="control-label col-sm-4" for="text">수취인</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="recipient" name="recipient" placeholder="수취인">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">연락처</label>
				<div class="form-group">
					<div class="col-md-2">
						<select id="tel1" class="form-control">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="017">017</option>
						</select>
					</div>
					<div class="col-sm-3 row">
						<input type="text" class="form-control" id="tel2" placeholder="전화번호">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">우편번호</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="addr1" placeholder="주소">
				</div>
				<button type="button" id="zipcode">우편번호</button>
				<br>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="title"></label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="addr2" placeholder="주소">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="title"></label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="addr3" placeholder="나머지주소">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">배송메모</label>
				<div class="form-group">
					<div class="col-sm-5">
						<input type="text" class="form-control" id="memo" name="memo" placeholder="배송메모">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">결제방법</label>
				<div class="form-group">
					<div class="col-md-5">
						<select id="payWay" name="payWay" class="form-control">
							<option value="1">신용카드</option>
							<option value="2">무통장입금</option>
						</select>
					</div>
				</div>
			</div>
			<div class="form-group" id="deposit">
				
			</div>
			<div class="form-group">
				<div class="checkbox">
					<label class="control-label col-sm-4" for="text"></label>
					<label>
						<input type="checkbox" id="checkbox1">쇼핑몰 구매 약관 동의
					</label>
						<br> 
					<label class="control-label col-sm-4" for="text">
					</label> 
					<label>
						<input type="checkbox" id="checkbox2">
						위 상품의 구매조건 확인 및 결제진행 동의
					</label>
				</div>
			</div>
			<br> <br> <br>
			<div class="form-group orderbtn">
				<div class="col-sm-offset-2 col-sm-10">
					<button id="order" type="button" class="btn btn-default">결제하기</button>
				</div>
				
			</div>
			<br><br>
		</form>
	</div>
</body>
</html>