<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
 $(function(){
	 //storeView에서 가져온 정보를 이제 이곳에 뿌려야행
	var $basketList = ${cBasketList};
	console.log($basketList);
	var $productList = $basketList.productList;
	
	console.log($productList);
	var $table =$("table");
	 
	 var $AllTotal = 0;
	
	 $.each($productList,function(idx,product){
		 console.log("fire:" + $productList);
			var $tr = $("<tr></tr>").appendTo($table);
			var $imgTd = $("<td></td>").appendTo($tr);//체크박스랑 이미지
			var $infoTd = $("<td></td>").appendTo($tr);//상품정보
			var $qntTd = $("<td></td>").appendTo($tr);//수량
			var $prTd = $("<td></td>").appendTo($tr);//가격
			
			var $checkDiv = $("<div></div>").appendTo($imgTd).css("float","left");
			var $imgDiv = $("<div></div>").appendTo($imgTd).css("flaot","right");//정렬이 옆으로..? 다시 확인하기
			
			$("<input type='checkbox' name='check' data-idx='"+idx+"'></input>").appendTo($checkDiv).css("text-align","center");
			$("<img style=\"width:150px; height:150px;\"></img>").attr("src","/jnjimg/goods/"+product.goodsImg).appendTo($imgDiv);
			
			var $spanNum =$("<span></span><br>").text('상품번호').appendTo($infoTd).css("text-align","center");
			var $spanName =$("<span></span><br>").text('상품명').appendTo($infoTd).css("text-align","center");
			var $spanOption =$("<span></span>").text('옵션').appendTo($infoTd).css("text-align","center");
			
			var $span1 = $("<span></span>").text(" - "+product.goodsNo).appendTo($spanNum);
			var $span2 = $("<span></span>").text(" - "+product.goodsName).appendTo($spanName);
			var $span3 = $("<span></span>").text(" - "+product.optionContent).appendTo($spanOption);
			
			var $goodsNoLink=$("<a></a>").attr("href","/jnj/menu/store/view?goodsNo="+product.goodsNo);
			$imgDiv.wrapInner($goodsNoLink);

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
		 	var $spanTopTop =$("<span></span><br>").text('총 합계').appendTo($td6);
		 	var $spanSubSub = $("<br><span></span>").text(numberWithCommas($AllTotal)+" ").appendTo($spanTopTop);
		 	var $spanSubSub2 = $("<span></span>").text('원').appendTo($spanTopTop);
	
	
	// 물건을 삭제할거얌!
	//삭제하기 버튼을 누르면 정보를 들고 컨트롤러로 이동한당ㅎㅅㅎ
	$("#storeBasketButtonDelete").on("click",function(e){
		e.preventDefault();
		
		var $form = $("<form></form>").appendTo("body");
		$form.empty();
		
		
		var idx = 0;

		$("input[name='check']:checked").each(function(idx){
			console.log("idx:"+$(this).attr("data-idx"));
			var Sb= $productList[$(this).attr("data-idx")];
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsNo").val(Sb.goodsNo).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsName").val(Sb.goodsName).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsPrice").val(Sb.goodsPrice).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsImg").val(Sb.goodsImg).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionNo").val(Sb.optionNo).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionContent").val(Sb.optionContent).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].qnt").val(Sb.qnt).appendTo($form);
			
		}) 
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($form);
		
		console.log($form.serialize());
		if(confirm("장바구니에서 삭제할까요?")==true) {
			console.log($form.serialize());
			$.ajax({
				url : "/jnj/menu/store/delete",
				type: "post",
				data : $form.serialize(),
				success : function(){
					window.location.reload();
				}
			}) 
		}
	})
	
	
/* 	//선택결제할거얌
	$("#storeBasketButtonSelectPay").on("click",function(e){
		e.preventDefault();
		var $form = $("<form></form>").attr("action", "/jnj/menu/store/payGoGo").attr("method", "post").appendTo("body");
		$form.empty();
		
		var idx = 0;

		$("input[name='check']:checked").each(function(idx){
			console.log("idx:"+$(this).attr("data-idx"));
			var Sb= $productList[$(this).attr("data-idx")];
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsNo").val(Sb.goodsNo).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsName").val(Sb.goodsName).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsPrice").val(Sb.goodsPrice).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsImg").val(Sb.goodsImg).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionNo").val(Sb.optionNo).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionContent").val(Sb.optionContent).appendTo($form);
			$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].qnt").val(Sb.qnt).appendTo($form);
			
		}) 
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($form);
		
		console.log($form.serialize());
	}) */
	//전체결제 히히
   $("#storeBasketButtonAllPay").on("click",function(e){
      e.preventDefault();
      var $form = $("<form></form>").appendTo("body");
      $form.empty();
      
      
      var idx = 0;

      $("input[name='check']:checkbox").attr("checked",true).each(function(idx){
         console.log("idx:"+$(this).attr("data-idx"));
         var Sb= $productList[$(this).attr("data-idx")];
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsNo").val(Sb.goodsNo).appendTo($form);
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsName").val(Sb.goodsName).appendTo($form);
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsPrice").val(Sb.goodsPrice).appendTo($form);
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsImg").val(Sb.goodsImg).appendTo($form);
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionNo").val(Sb.optionNo).appendTo($form);
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionContent").val(Sb.optionContent).appendTo($form);
         $("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].qnt").val(Sb.qnt).appendTo($form);
         
      }) 
      $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($form);
      
      console.log($form.serialize());
      location.href = "/jnj/menu/store/payGoGo"; 
      
   })
	
   //숫자 콤마넣기
	function numberWithCommas(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
	 
 })
 
 </script>
<style>
.storeBasket {
	margin-top: 100px;
}

.storeBasket h3 {
	color: #7F5926;
}

.storeBasket button {
	
	background-color: #FFB24C;
	color: #7F5926;
}

.storeBasket button:hover {
	background-color: #7F5926;
	color: #FFB24C;
}
 
.storeBasket #table thead {
text-align: center;
background-color: #FFB24C;
}
#BasketButton{
margin-left: 950px;
}
#backList {
	font-size: 1.3em;
	float: right;
	margin: 0px 50px 0px 0px;
}

</style>
</head>
<body>
	<div class="container storeBasket">
		<h3>장바구니</h3>
		<a id="backList" href="/jnj/menu/store/record">목록으로</a>
	<br>
		<hr />
      <br>
     <table class="table" id="table" >
         <colgroup width="30%"/>
         <colgroup width="30%"/>
         <colgroup width="30%"/>
         <colgroup width="10%"/>
         <thead>
            <tr>
				<th></th>
               <th>상품정보</th>
               <th>수량</th>
               <th>주문금액</th>
            </tr>
         </thead>
         <tbody>
            <tr>
  <td>   	
  <!-- <form>
    <div class="checkbox">
      	<label><input type="checkbox" value=""></label>
 		<div id="goodsViewGoGo">id걸고 on.click
 			<img src="1.jpg" height="100px">
 		</div>
    </div>
  </form>
  </td>
 
               <td>
               		상품번호<span></span><br>
               		상품명<span></span><br>
               		옵션<span></span>
               	</td>
               <td>1개</td>
               <td>15,000원</td>
            </tr>
            <tr id="totalprice">
               <td colspan="3"></td>
               <td colspan="1"><span>총 합계</span><br><span>30,000원</span></td>
            </tr>
         </tbody> -->
      </table>
      <hr />
      		<!-- <div id="AllTotalDiv">총합계
		      <span>총합계</span><span id="AllTotal"></span><span>원</span>
	        </div> -->
      <br><br>
				<div class="col-sm-offset-2 col-sm-10" id="BasketButton">
					<button id="storeBasketButtonDelete" type="button" class="btn btn-default">삭제하기</button>
					<!-- <button id="storeBasketButtonSelectPay" type="button" class="btn btn-default">선택결제</button> -->
					<button id="storeBasketButtonAllPay" type="button" class="btn btn-default">결제하기</button>
				</div>
			</div>
			<br>
			<br>
			<br>
</body>
</html>