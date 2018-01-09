<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<script>
// 단위 , 찍기
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function removeCommas(num) {
    return num.toString().replace(",", "");
}


// 화면 내에서 이동
function fnMove(seq){
    var offset = $(".storeview" + seq).offset();
    $('html, body').animate({scrollTop : offset.top}, 400);
} 
 
$(function(){
	var map = ${sView};		
	var goods = map.goods;	// 상품 정보(이름, 번호, 가격, 수량, )	
	var goodsImg = map.goodsImg;
	var goodsOption = map.goodsOption;
	var comment = ${sComment};
	var memberId = ${memberId};
	var mstate = ${mstate};
	
	 
	
	
	
	/*----------------------------------------------------------------------------------*/
	
	
						
	
	// 수현
	
	
	// div
	var storeview = $(".storeview");
	var storeview1 = $(".storeview1");
	var storeview2 = $(".storeview2");
	var storeview3 = $(".storeview3");
	
	// 상품 사진 및 상단의 상품 정보
	// table
	var tbody1 = $(".viewtable tbody");
	
	
	var tr11 = $("<tr></tr>").appendTo(tbody1);
	var td111 = $("<td></td>").attr("id", "row").attr("rowspan",2).attr("colspan",3).appendTo(tr11);
	// 상품번호
	var goodsNo = $("<h5></h5>").appendTo(td111);
	$("<span></span>").text("상품번호 ").appendTo(goodsNo);
	$("<span></span>").attr("id", "goodsNo").text(goods.goodsNo).appendTo(goodsNo);
	// 상품이미지
	var imgDiv = $("<div></div>").attr("id", "imgdiv").appendTo(goodsNo);
	$("<img>").css("width", "400px").css("height", "350px").attr("alt","sss").attr("src", "/jnjimg/goods/"+goodsImg[0]).appendTo(imgDiv);
	// 상품명
	var th111 = $("<th></th>").attr("colspan", "4").appendTo(tr11);
	$("<h3></h3>").text(goods.goodsName).appendTo(th111);
	
	var tr12 = $("<tr></tr>").attr("id", "options").css("height", "362px").appendTo(tbody1);
	var th121 = $("<th></th>").attr("class", "titlestore").appendTo(tr12);
	$("<br>").appendTo(th121);
	$("<span></span>").text("판매가").appendTo(th121);
	$("<br><br>").appendTo(th121);
	$("<span></span>").text("옵션").appendTo(th121);
	// 상품가격
	var goodsPrice = $("<td></td>").attr("colspan", "3").appendTo(tr12);
	$("<br>").appendTo(goodsPrice);
	$("<span></span>").text(numberWithCommas(goods.goodsPrice)+"원").appendTo(goodsPrice);
	$("<br><br>").appendTo(goodsPrice);
	
	var total =  $("<tr></tr>").attr("id", "total").appendTo(tbody1);	
	$("<td></td>").attr("colspan", 5).appendTo(total);
	var totaltd = $("<td></td>").attr("colspan", 2).appendTo(total);
	$("<span></span>").text("총 수량 ").appendTo(totaltd);
	$("<span></span>").attr("id", "orderQnt").text(0).appendTo(totaltd);
	$("<span></span>").text("개 ").appendTo(totaltd);
	$("<span></span>").text("총 상품금액 ").appendTo(totaltd);
	$("<span></span>").attr("id", "payMoney").text(0).appendTo(totaltd);
	$("<span></span>").text("원 ").appendTo(totaltd);
	

	
	// 옵션
	var opselect = $("<select></select>").attr("id", "option").attr("name", "option").attr("class", "form-control").appendTo(goodsPrice)
	$("<option></option>").text("옵션").appendTo(opselect);
	$.each(goodsOption, function(idx, $goodsOption) {
		$("<option></option>").val(idx).text($goodsOption.OPTIONCONTENT).appendTo(opselect);
	})
		
		
	// 옵션 선택 -> 추가
	var basketoption = $("#option").val();
	var row = 0;
		
	var totalmoney = 0;		
	var totalqnt = 0;
		
	var index = 0;
	$("#option").change(function() {
			
		var $option = $("#option option:selected").attr("value");
		var $optionCon = $("#option option:selected").text();
			
		// 선택한 option이 null이 아니라면
		if($option!=null) {
			var check = false;
			$("tr[class=add]").each(function(idx){
				if( $optionCon == $(this).children().children().eq(3).text() ){
					$(this).children().children().eq(3);
						
					// 수량 증가
					var num = $(this).children("td").eq(0).attr("id");
					var q = parseInt($("#opQ"+num ).val())+1;
					
					$("#opQ"+num ).val(q);
					
					// 바뀐 금액
					$(this).children().eq(3).children("span[class=money]").text(numberWithCommas(q*goods.goodsPrice))
					
					$("#option option:eq(0)").prop("selected", true);
					calctotal();
					check = true;
					return;
				}				
			});
			// 옵션이 중복될 경우 추가하면 안 되서
			if( check ) return;
			var tr13 = $("<tr data-no='"+goodsOption[$option].OPTIONNO+"'></tr>").attr("class", "add"); 
			$("#total").before(tr13);
						
			// 추가한 상품 이름
			var td131 = $("<th></th>").attr("class", "titlestore").appendTo(tr13);
			$("<span></span>").text(goods.goodsName).appendTo(td131);
			$("<br>").appendTo(td131);
			$("<span></span>").text("- ").appendTo(td131);
			$("<span></span>").attr("class", "op").text(goodsOption[$option].OPTIONCONTENT).appendTo(td131);
						
			// 상품 수량
			var goodsQnt = $("<td id='"+index+"'></td>").appendTo(tr13);
			var quantity = $("<span></span>").attr("class", "quantity").appendTo(goodsQnt);
			$("<input id='opQ"+index+"'>").attr("type", "text").attr("class", "qnt").attr("name", "orderQnt").attr("class", "form-control").attr("value", 1).attr("readonly", "readonly").appendTo(quantity);
			$("<div></div>").attr("id", "updown")
			$("<a></a>").attr("class", "up").text("▲").appendTo(quantity);
			$("<a></a>").attr("class", "down").text("▼").appendTo(quantity);
					
			$("<td></td>").text(".").appendTo(tr13);
				
			// 상품 옵션별 금액
			var money = $("<td></td class='total'>").appendTo(tr13);
			
			$("<span></span>").attr("class", "money").css("display", "inline-block").css("width", "100x").text(numberWithCommas(goods.goodsPrice)).appendTo(money);
			$("<span></span>").text("원 ").appendTo(money);
			$("<a></a>").attr("class", "remove").text("X").appendTo(money);
	
			// 상품 이미지 있는 td rowspan++
			row++;
			$("#row").attr("rowspan", 2+row);
				
			index++;
				
			$("#option option:eq(0)").prop("selected", true);
		}
		calctotal();
	})
	
		
	// 수량 증가 
	$(document).on("click",".up", function () {	
		var sp1 = $(this).parent("span");
		var spc1 = sp1.children("input").val();
		if(spc1<goods.stockQnt) {			
			var qntadd1 = parseInt(spc1)+1;
			sp1.children("input").val(qntadd1);
			
			// 수량*상품금액 
			var trtr = $(this).parents("tr");
			var totalM = qntadd1*goods.goodsPrice
			trtr.find("span[class=money]").text(numberWithCommas(totalM))
			
			calctotal();
		}	
	})
		
	// 수량 감소
	$(document).on("click", ".down", function () {
		var sp2 = $(this).parent("span");
		var spc2 = sp2.children("input").val();
		if(spc2>1) {			
			var qntsub = parseInt(spc2)-1;
			sp2.children("input").val(qntsub);
			
			// 수량*상품금액 
			var trtr1 = $(this).parents("tr");
			trtr1.find("span[class=money]").text(numberWithCommas(qntsub*goods.goodsPrice))
		
			calctotal();
		}	
	})
				
	function calctotal() {
		var allqnt = 0;
		var allmoney = 0;
		$("input[id^=opQ]").each(function() {
			var opQadd= parseInt($(this).val());
			allqnt= opQadd+allqnt;
		})
		$("#orderQnt").text(allqnt);
		$("span[class=money]").each(function() {
			var moneyadd= parseInt(removeCommas($(this).text()));
			console.log(moneyadd)
			allmoney= moneyadd+allmoney;
		})
		$("#payMoney").text(numberWithCommas(allmoney));
	}
	
	
	
	
	$("<hr/>").appendTo(storeview1);
	var btnDiv = $("<div></div>").attr("id", "total1").appendTo(storeview1);
	$("<button></button>").text("구매하기").attr("id", "pay").attr("type", "button").attr("class", "btn btn-default").appendTo(btnDiv);
	$("<button></button>").text("장바구니").attr("id", "basket").attr("type", "button").attr("class", "btn btn-default").appendTo(btnDiv);
	$("<br><br>").appendTo(btnDiv);
	
	if(goods.goodsState==0) {
		$("#pay").attr("disabled", "disabled");
		$("#basket").attr("disabled", "disabled");
	}
	
	if(parseInt(mstate)==0) {
		$("#pay").attr("disabled", "disabled");
		$("#basket").attr("disabled", "disabled");
	}
	
	
	/*--storeview1 끝--*/
	
	$("#pay").on("click", function() {
		if($("tr[class=add]").length==0) {
			alert("상품 옵션을 선택하세요");
		} else {
			var form = $("<form></form>").attr("action", "/jnj/menu/store/pay").attr("method", "post");
			
			$("tr[class=add]").each(function(idx){
				$("<input type='hidden' name='goodsNo' value='"+goods.goodsNo+"'>").appendTo("#total1");
				$("<input type='hidden' name='optionNo' value='"+parseInt($(this).attr("data-no"))+"'>").appendTo("#total1");
				$("<input type='hidden' name='orderQnt' value='"+parseInt($("#opQ"+idx).val())+"'>").appendTo("#total1");
				
			})
			$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo("#total1");
			$("#total1").wrap(form);
			$("#pay").attr("type", "submit");
		}
	})
	
	
	$("<hr/>").appendTo(storeview);
	
	/*--storeview2 --*/
	
	var goodsContent = $("<div></div>").appendTo(storeview2);
	$("<br>").appendTo(goodsContent);
	for(var i=1; i<goodsImg.length; i++) {
		$("<img>").css("width", "500px").attr("alt", goods.goodsNo).attr("src", "/jnjimg/goods/"+goodsImg[i]).appendTo(goodsContent);
		$("<br><br>").appendTo(goodsContent);
	}
	
	$("<br>").appendTo(goodsContent);
	$("<p></p>").text(goods.goodsContent).appendTo(goodsContent);

	/*--storeview2 끝--*/
	
	/*--storeview3 --*/
	
	var goodsComment = $("<div></div>").appendTo(storeview3);
	var commtable = $("<table></table>").attr("class", "table viewtable").appendTo(goodsComment);
	$("<colgroup width='10%'/>").appendTo(commtable);
	$("<colgroup width='15%'/>").appendTo(commtable);
	$("<colgroup width='45%'/>").appendTo(commtable);
	$("<colgroup width='15%'/>").appendTo(commtable); 
	$("<colgroup width='15%'/>").appendTo(commtable); 
	var commthead = $("<thead></thead>").appendTo(commtable);
	$("<tr><th>만족도</th><th>옵션</th><th>내용</th><th>작성자</th><th>날짜</th></tr>").appendTo(commthead);
	
	if(comment.length==0) {
		console.log("없으면 들어와")
		var empty = $("<tbody></tbody>").appendTo(commtable);
		var em = $("<tr></tr>").appendTo(empty);
		$("<td></td>").attr("colspan", 5).text("상품후기가 없습니다.").appendTo(em);
	} else {
		console.log(comment)
		console.log("있음 들어와")
		$.each(comment, function(idx, comm) {
			var commtbody = $("<tbody></tbody>").appendTo(commtable);
			var commtr1 = $("<tr></tr>").appendTo(commtbody);
			var star="";
			for(var i=0; i<5; i++){
				if( i < comm.SATISFY )	star += "★";
				else					star += "☆";
			}
			$("<td></td>").text(star).attr("data-sati", comm.SATISFY).appendTo(commtr1);
			$("<td></td>").text(comm.OPTIONCONTENT).attr("data-opno", comm.OPTIONNO).appendTo(commtr1);
			$("<td></td>").text(comm.REVIEWCONTENT).attr("data-comm", comm.REVIEWCONTENT).appendTo(commtr1);
			$("<td></td>").text(comm.WRITEID).appendTo(commtr1);
			$("<td></td>").text(comm.WRITEDATE).appendTo(commtr1);
				
		})
	
	}
	
	$(document).on("click", ".remove", function() {
		var subQnt = $(this).parents().eq(1).children().eq(1).children().children().eq(0).val();
		var subMoney = $(this).parents().eq(1).children().eq(3).children().eq(0).text();
		var recentQnt = $("#orderQnt").text();
		var recentMoney = $("#payMoney").text();
		var rowsub = $("#row").attr("rowspan")-1;
		console.log(rowsub)
		console.log($(this).parents().eq(1))
		$(this).parents().eq(1).remove();
		$("#row").attr("rowspan", rowsub);
		$("#orderQnt").text(parseInt(recentQnt)-parseInt(subQnt));
		$("#payMoney").text(parseInt(recentMoney)-parseInt(subMoney));
		row=0;
	})

	
	
	
	/* ------------------------------------------------------------------------ */
	/* 혜미혜미혜미혜마혜마몧미ㅖ */
	//장바구니 버튼을 누르면 정보를 들고 컨트롤러로 이동할거얌
	$(".storeview1").on("click","#basket",function(){
		if($("tr[class=add]").length==0) {
			alert("상품 옵션을 선택하세요");
		} else { 
			var $form = $("<form></form>").appendTo("body");
			$form.empty();
		 	var idx=0;
			$("tr[class=add]").each(function(idx){
				console.log($(this).children().eq(0).children().eq(3).text());
				console.log($(this).children().eq(1).children().eq(0).children().eq(0).val());
				console.log($(this));
				console.log(goods.goodsNo);
				console.log(goodsImg)
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsNo").val(goods.goodsNo).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsName").val(goods.goodsName).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsPrice").val(goods.goodsPrice).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].goodsImg").val(goodsImg[0]).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionNo").val($(this).attr("data-no")).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].optionContent").val($(this).children().eq(0).children().eq(3).text()).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","ProductList"+"["+idx+"].qnt").val($(this).children().eq(1).children().eq(0).children().eq(0).val()).appendTo($form);
			}) 
			
			
			$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($form);
			
			console.log($form.serialize());
			
			//장바구니 B누르면 장바구니로 이동할거냐고 알림창 뜨는거얌!
			$.ajax({
				url : "/jnj/menu/store/baskettt",
				type: "post",
				data : $form.serialize(),
				success : function(){
					var result=confirm("장바구니에 담겼습니다. 장바구니로 이동할까요?");
					if(result){
						console.log("끝!");
						location.href="/jnj/menu/store/basketGo";
					}else if(result==false){
						location.reload();
					}
				}
			})
		}
	})
	//옆에 따라오는 작은 장바구니! session값이 null이면 안보이게 해줘야함
	var $basketList = ${cBasketList};
	var $productList = $basketList.productList;
	var size=null;
	$.each($productList,function(idx,product){
		size=idx;
	})
	console.log("미니장바구니 사이즈 : ");
	console.log(size);
	if(size<=-1 || size==null){
		$("#miniBasket").hide();
	}else if(size>=0){
		$(document).scroll(function(){
			var con = $("#miniBasket");
			var position = $(window).scrollTop();
			if(position > 50){ con.fadeIn(500); }
			else if(position < 50){ con.fadeOut(500); }
		});
	}

})
</script>
<style>

tbody td .quantity {
	display: inline-block;
	position: relative;
	vertical-align: middle;
}

tbody td .quantity .up {
	color: gray;
	text-decoration: none;
	position: absolute;
	left: 80%;
	top: 0;
}

tbody td .quantity .down {
	color: gray;
	text-decoration: none;
	position: absolute;
	left: 80%;
	top: 15px;
}

.quantity:hover {
	color: black;
	text-decoration: none;
}

.form-control[readonly] {
	background-color: white;
}

.storeview1 .titlestore, .storeview3, .storeview3 th {
	text-align: center;
}

.storeview button, .storeview .btn {
	margin-right: 10px;
	background-color: #FFB24C;
	color: #7F5926;
	border-color: #ccc;
}

.storeview button:hover, .storeview .btn:hover {
	background-color: #7F5926;
	color: #FFB24C;
}

.storeview1 #option, .storeview1 #qnt, .storeview1 #qnt2 {
	width: 110px;
}

.storeview3 #satisfaction, .storeview3 #buyoption {
	width: 120px;
}

.storeview3 #content {
	width: 70%;
}

.storeview1 #amount1, .storeview1 #amount2 {
	margin-left: 60%;
}

.storeview1 img {
	margin: 5px 10px 10px 0;
}

.storeview3 .btn-group {
	width: 100%;
}

.storeview3 .btn-group .btn {
	margin: 0;
}

.storeview3 th {
	background-color: #7F5926;
	color: #FFB24C;
}

.storeview #total1 {
	margin-left: 75%;
}

.storeview #total1 h4, .storeview3 .form-control {
	display: inline;
}

.storeview #pay {
	margin-left: 27%;
}

.storeview .goods {
	text-align: center;
	padding: 10px 0;
}

.storeview3 .goods {
	margin: 50px 0;
}

.goods h4 {
	font-weight: bold;
}
/* 혜미 장바구니 */
#miniBasket{
position: fixed;
width: 200px;
height: 420px;
left: 20px;
top:200px;
display: none;
}
</style>
</head>
<body>
	<div class="container storeview">
		<div class="storeview1">
			<table class="table viewtable">
				<colgroup width='40%' />
				<colgroup width='3%' />
				<colgroup width='2%' />
				<colgroup width='15%' />
				<colgroup width='10%' />
				<colgroup width='27%' />
				<colgroup width='8%' />
				<tbody>
				</tbody>
			</table>
		</div>
		<hr />
		<div class="storeview2">
			<div class="btn-group btn-group-justified">
				<a onclick="fnMove('2')" class="btn">상품설명</a> <a
					onclick="fnMove('3')" class="btn">상품후기</a> <a onclick="fnMove('4')"
					class="btn">교환/반품/배송</a>
			</div>
		</div>
		<div class="storeview3">
			<div class="btn-group btn-group-justified">
				<a onclick="fnMove('2')" class="btn">상품설명</a> <a
					onclick="fnMove('3')" class="btn">상품후기</a> <a onclick="fnMove('4')"
					class="btn">교환/반품/배송</a>
			</div>
			<br>
		</div>
		<div class="storeview4">
			<div class="btn-group btn-group-justified">
				<a onclick="fnMove('2')" class="btn">상품설명</a> <a
					onclick="fnMove('3')" class="btn">상품후기</a> <a onclick="fnMove('4')"
					class="btn">교환/환불/배송</a>
			</div>
			<div class="goods">
				<h4>* 입금확인에 대해서 *</h4>
				<p>01. 무통장 입금을 이용하실 때, 주문자면과 입금자명이 다를 경우, 주문금액과 실제 금액이 다를 경우,</p>
				<p>결제할 금액 이상을 입금한 경우 입금확인이 지연됩니다.</p>
				<p>02. 입금확인 지연이 되는 경우, 전화상담 또는 1:1문의로 연락주시면 빠르게 처리해드리겠습니다.</p>
				<p>03. 고객의 사정으로 결제하셔야 할 금액 이상을 입금하신 경우는 계좌이체 수수료를 제외한 금액이 환불됩니다.</p>
				<br>
				<h4>* 배송에 대해서 *</h4>
				<p>01. 배송업체는 JJ주인집사택배(1588-1234)를 이용하고 있습니다.</p>
				<p>02. 결제(입금완료)완료 후 4일 이내에 상품을 수령하실 수 있습니다. (단, 공휴일 주말 제외)</p>
				<p>(배송지연시 미리 안내를 드리지 못합니다. 양해부탁드립니다.)</p>
				<p>03. 배송비는 무료입니다.</p>
				<p>04. 도서산간 지역은 특성상 배송기간이 더 소요될 수 있습니다.</p>
				<br>
				<h4>* 취소/교환/환불에 대해서 *</h4>
				<p>취소의 경우 입금이 안된 경우만 가능합니다.</p>
				<p>교환/환불은 반드시 쇼핑몰 지정 택배사를 이용해주세요. (타택배사 이용시 비용은 고객님이 부탐하셔야됩니다.)</p>
				<p>교환/환불 전 반드시 교환/환불 신청 후 물품을 보내주세요.</p>
				<p>사전 접수없이 보내실 경우 반품 및 교환이 불가능합니다.</p>
				<p>환불 및 교환에 대한 자세한 사항은 아래의 내용을 참고해주세요.</p>
				<br>
				<h4>* 교환/환불이 불가능한 경우에 대해서 *</h4>
				<p>01. 제품을 받으신 후 10일 이내에 교환, 환불신청을 하지 않았을 경우</p>
				<p>02. 고객님의 부주의로 인한 상품의 변형, 훼손 또는 파손된 경우</p>
				<p>03. 제품이 오염되었을 경우 (립스틱, 화장품, 음식물, 기타 오염물질로 인해)</p>
				<p>04. 제품을 찾용 및 사용하거나 수선, 수리, 세탁하였을 경우</p>
				<p>05. 환불 불가로 표기된 상품을 구매한 경우</p>
				<p>06. 환불 의사를 표하지 않고 환불한 경우</p>
			</div>
		</div>
	</div>
	
	
	<div id="miniBasket">
		<jsp:include page="sessionBasket.jsp"></jsp:include>
	</div>
</body>
</html>