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
</style>
<script>
$(function() {
	//storeBasket에서 가져온 정보를 이곳에 뿌리쟈
	var $basketList = ${cBasketList};
	
	var $productList = $basketList.productList;
	
	console.log($productList);
	var $table =$("table");
	 
	 var $AllTotal = 0;
	
	 $.each($productList,function(idx,product){
		 console.log("fire:" + $productList);
			var $tr = $("<tr></tr>").attr("class", "list").appendTo($table);
			var $imgTd = $("<td></td>").appendTo($tr);//이미지
			var $infoTd = $("<td></td>").appendTo($tr);//상품정보
			var $qntTd = $("<td></td>").appendTo($tr);//수량
			var $prTd = $("<td></td>").appendTo($tr);//가격
			
			var $imgDiv = $("<div></div>").appendTo($imgTd).css("flaot","right");//정렬이 옆으로..? 다시 확인하기
			
			$("<img style=\"width:150px; height:150px;\"></img>").attr("src", "/jnjimg/goods/"+product.goodsImg).appendTo($imgDiv);
			var $spanNum =$("<span></span><br>").text('상품번호').appendTo($infoTd).css("text-align","center");
			var $spanName =$("<span></span><br>").text('상품명').appendTo($infoTd).css("text-align","center");
			var $spanOption =$("<span></span>").text('옵션').appendTo($infoTd).css("text-align","center");
			
			var $span1 = $("<span></span>").text(product.goodsNo).appendTo($spanNum);
			var $span2 = $("<span></span>").text(product.goodsName).appendTo($spanName);
			var $span3 = $("<span></span>").text(product.optionContent).appendTo($spanOption);
			

		 	var $spanQnt =$("<span></span><br>").text(product.qnt).appendTo($qntTd);
		 	$("<span></span>").text('개').appendTo($spanQnt);
		 	
		 	var $qnt = parseInt(product.qnt);
		 	
		 	console.log($qnt);
		 	
		 	var $price = parseInt(product.goodsPrice);
		 	
		 	console.log($price);
		 	
		 	var $oneTotal = $qnt*$price;
		 	
		 	var $spanPrice =$("<span></span><br>").text(numberWithCommas($oneTotal)).attr("id","oneTotal").appendTo($prTd);
		 	$("<span></span>").text('원').appendTo($spanPrice);
		 	
		 	$AllTotal += $oneTotal;
		
	})
	
		 	console.log($AllTotal);
		 	
		 	var $AllTotalTr = $("<tr></tr>").appendTo($table);
		 	var $td5 = $("<td colspan='3'></td>").appendTo($AllTotalTr);
		 	var $td6 = $("<td colspan='1'></td>").appendTo($AllTotalTr);
		 	var $spanTopTop =$("<span></span><br>").text('총 합계').appendTo($td6).css("text-align","center");
		 	var $spanSubSub = $("<br><span></span>").text(numberWithCommas($AllTotal)+" ").appendTo($spanTopTop);
		 	var $spanSubSub2 = $("<span></span>").text('원').appendTo($spanTopTop);
	//여기 수정해
   var orderbtn = $(".orderbtn");
   $("#order").on("click", function() {
	   var $basketList = ${cBasketList};
	   var $productList = $basketList.productList;
	   var idx =0;
	  	$("input").each(function(idx){
			if($(this).val()=="") {
				alert($(this).attr("placeholder")+"을(를) 입력하시오");
				return false;
			} 
		}) 
      if($("#checkbox1").prop("checked") && $("#checkbox2").prop("checked")) {
    	  console.log($productList);
    	  $("tr[class=list]").each(function(idx){
    		  console.log($productList[idx].goodsNo);
          	  console.log($productList[idx].optionNo);
    		  $("<input type='hidden' name='goodsNo' value='"+$productList[idx].goodsNo+"'>").appendTo(orderbtn);
            $("<input type='hidden' name='optionNo' value='"+$productList[idx].optionNo+"'>").appendTo(orderbtn);
            $("<input type='hidden' name='orderQnt' value='"+$productList[idx].qnt+"'>").appendTo(orderbtn);
            $("<input type='hidden' name='money' value='"+$productList[idx].qnt*$productList[idx].goodsPrice+"'>").appendTo(orderbtn);
              if(parseInt($("#payWay option:selected").val())==2) {
               $("<input type='hidden' name='orderRecordState' value='1'>").appendTo(orderbtn);
            } else if(parseInt($("#payWay option:selected").val())==1) {
               $("<input type='hidden' name='orderRecordState' value='2'>").appendTo(orderbtn);
            }
   			idx++
         })
    	  
         console.log($("#payWay option:selected").val());
         
         if(parseInt($("#payWay option:selected").val())==2) {
            $("<input type='hidden' name='orderState' value='1'>").appendTo(orderbtn);
         } else if(parseInt($("#payWay option:selected").val())==1) {
            $("<input type='hidden' name='orderState' value='2'>").appendTo(orderbtn);
         }   
         $("<input type='hidden' name='payWay' value='"+$("#payWay option:selected").val()+"'>").appendTo(orderbtn);            
         $("<input type='hidden' name='payMoney' value='"+$AllTotal+"'>").appendTo(orderbtn);            
         $("<input type='hidden' name='orderTel' value='"+$("#tel1 option:selected").val()+$("#tel2").val()+"'>").appendTo(orderbtn);
         $("<input type='hidden' name='recipientAddr' value='("+$("#addr1").val()+")"+$("#addr2").val()+", "+$("#addr3").val()+"'>").appendTo(orderbtn);
         $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo(orderbtn);
         $("#order").attr("type", "submit");
      } else {
         alert("동의 체크하시오");
      }   
    
      
   })
   	
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
	
	$("#zipcode").on("click", function() {
		  sample6_execDaumPostcode();
	})
	
	 //숫자 콤마넣기
	function numberWithCommas(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
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
		<table class="table storeBasketPayTable">
			<colgroup width="30%" />
			<colgroup width="30%" />
			<colgroup width="30%" />
			<colgroup width="10%" />
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
		<form class="form-horizontal" method="post" action="/jnj/menu/store/order" enctype="multipart/form-data">
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