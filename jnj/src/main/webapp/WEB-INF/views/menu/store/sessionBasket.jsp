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
$(function(){
	/* ajax로 cBasketList 호출해 */
	var $basketList;
	$.ajax({
		url : "/jnj/menu/store/miniBasket",
		type : "get",
		success : function(basketList){
			
			$basketList = JSON.parse(basketList);
			console.log("나와줘라..");
			console.log($basketList);
			start();	
		}
		
	})
	
	function start(){
	console.log("나오니?");
	console.log($basketList);
	var $productList = $basketList.productList;
	console.log("왜 안나오니?");
	console.log($productList);
	
	var size=0;
	$.each($productList,function(idx,product){
		size=idx;
	})

	var $table =$("#table");
	
	var $tr = $("<tr></tr>").appendTo($table);
	var $tr2 =$("<tr></tr>").appendTo($table);
	var $imgTd = $("<td></td>").appendTo($tr);//이미지
	var $infoTd = $("<td></td>").attr("class","goodsName").appendTo($tr2);//상품정보
	
	var $imgDiv = $("<div></div>").appendTo($imgTd).css("flaot","right");
	
	$("<img style=\"width:100px; height:100px;\"></img>").attr("src","/jnjimg/goods/"+$productList[size].goodsImg).appendTo($imgDiv);
	
	var $span2 = $("<span></span><br>").text($productList[size].goodsName).attr("class","goodsName").appendTo($infoTd).css("text-align","center");
	var $span3 = $("<span></span>").text($productList[size].optionContent).attr("class","goodsName").appendTo($infoTd).css("text-align","center");
	var $goodsNoLink=$("<a></a>").attr("href","/jnj/menu/store/view?goodsNo="+$productList[size].goodsNo);
	$imgDiv.wrapInner($goodsNoLink);
	
	/* 두개만 나타나게할거임! */
	
	var $tr = $("<tr></tr>").appendTo($table);
	var $tr2 =$("<tr></tr>").appendTo($table);
	var $imgTd = $("<td></td>").appendTo($tr);//이미지
	var $infoTd = $("<td></td>").attr("class","goodsName").appendTo($tr2);//상품정보
	
	var $imgDiv = $("<div></div>").appendTo($imgTd).css("flaot","right");
	
	$("<img style=\"width:100px; height:100px;\"></img>").attr("src","/jnjimg/goods/"+$productList[size-1].goodsImg).appendTo($imgDiv);
	
	var $span2 = $("<span></span><br>").text($productList[size-1].goodsName).attr("class","goodsName").appendTo($infoTd).css("text-align","center");
	var $span3 = $("<span></span>").text($productList[size-1].optionContent).attr("class","goodsName").appendTo($infoTd).css("text-align","center");
	var $goodsNoLink=$("<a></a>").attr("href","/jnj/menu/store/view?goodsNo="+$productList[size-1].goodsNo);
	$imgDiv.wrapInner($goodsNoLink);
	
	
	/* 
	$.each($productList,function(idx,product){
			var $tr = $("<tr></tr>").appendTo($table);
			var $tr2 =$("<tr></tr>").appendTo($table);
			var $imgTd = $("<td></td>").appendTo($tr);//이미지
			var $infoTd = $("<td></td>").attr("class","goodsName").appendTo($tr2);//상품정보
			
			var $imgDiv = $("<div></div>").appendTo($imgTd).css("flaot","right");
			
			$("<img style=\"width:100px; height:100px;\"></img>").attr("src","/jnjimg/goods/"+product.goodsImg).appendTo($imgDiv);
			
			var $span2 = $("<span></span>").text(product.goodsName).attr("class","goodsName").appendTo($infoTd).css("text-align","center");
			var $goodsNoLink=$("<a></a>").attr("href","/jnj/menu/store/view?goodsNo="+product.goodsNo);
			$imgDiv.wrapInner($goodsNoLink);
			
	}) */
	
	}
	$("#basketGoGo").on("click",function(){
	      location.href = "/jnj/menu/store/basketGo"; 
	      
	   })
	$("#mainImg").on("click",function(){
      location.reload(); 
      
   		})
	
	
	
})
</script>
<style>
.sessionBasket{
border: 1px solid #FFB24C;
width: 200px;
height: 420px;
position:relative;
background-color: #FFB24C;
border-radius: 50px;
}
#mainImg{
width: 150px;
height: 100px;
}

#img{
width: 150px;
height: 110px;
margin: 10px;

}
#basketGoGo{
position:absolute;
margin-left: 23px;
bottom:10px;
background-color: #FFB24C;

}
#table{
position: absolute;
margin-left: 30px;
}
.goodsName{
text-align: center;
}

</style>
</head>
<body>
<!-- 여기 따라다는 애 만들어애ㅑ해 -->
	
	<div class="container-fluid sessionBasket">
		<div id="mainImg">
			<img id="img" src="/jnjimg/goods/mini.jpg">
		</div>
		<table id="table">
			</table>
		<button id="basketGoGo">장바구니 더보기</button>
	</div>
</body>
</html>