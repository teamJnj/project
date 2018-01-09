<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<style>
.apply {
	width : 810px;
	height : 550px;
}

.apply h3 {
	color: #7F5926;
}

#apply {
	width: 150px;
	margin-left: 200px;
	margin-right: 10px;
}

#cancel {
	width: 150px;
}

</style>
<script>
$(function(){
	var marketNo = "${marketNo}";
	var applyPeople = "${applyPeople}";
	var boothPrice = "${boothPrice}";
	console.log(marketNo);
	console.log(applyPeople);
	console.log(boothPrice);
	
	if(applyPeople==19){
		alert("부스신청할 갯수는 1개입니다");
		$("#two").hide();
	}
	$("#two").on("click", function() {
		$("#text").text("부스 가격 : "+boothPrice*2+" 원");
	}) 
	$("#one").on("click", function() {
		$("#text").text("부스 가격 : "+boothPrice+" 원");
	}) 
	$("#pay").on("click", function() {
		$("#text2").text("우리 1002-135-303488");
		
		var ddiv = $("#ddd");
		ddiv.empty();
		var div = $("<div class='form-group'></div>").appendTo(ddiv);
		$("<label class='control-label col-sm-2' for='title'>입금자</label>" ).appendTo(div);
		var div2 = $("<div class='col-sm-8'></div>").appendTo(div);
		$("<input type='text' class='form-control' id='depositor' name='depositor' placeholder='입금자'>").appendTo(div2);
		$("<label class='error' for='depositor' generated='true' style='display:none; color: red;'>error message</label>").appendTo(div2);
	}) 
	
	$("#card").on("click", function(){
		var ddiv = $("#ddd");
		ddiv.empty();
		$("<input type='hidden' name='depositor' value='card'>").appendTo(ddiv);
	})
	
	
	
	
	$("#cancel").on("click", function() {
		location.href = "/jnj/menu/market/view?marketNo="+marketNo;
	})
	
	
	$("#form").validate({
		
		// 검증 규칙 지정
		rules : {
			tel2 : {
				required : true,
				digits : true,
				minlength : 7,
				maxlength : 8
			},
			boothNum : {
				required : true
			},
			payWay : {
				required : true
			},
			depositor : {
				required : true,
				minlength : 1,
				maxlength : 20
			}
		},
		messages : {
			tel2 : {
				required :"전화번호를 입력해주세요",
				digits : "전화번호는 숫자만 입력 가능합니다",
				minlength : "최소 {0}숫자이상이어야 합니다",
				maxlength : "최대 {0}숫자이하이어야 합니다"
			},
			boothNum : {
				required :"부스 개수를 선택해주세요."
			},
			payWay : {
				required :"결제방법를 선택해주세요."
			},
			depositor : {
				required :"입금자를 입력해주세요.",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			}
		}
	});
	
	
})
</script>
</head>
<body>
	<div class="container apply">
		<h3>-프리마켓 신청</h3>
		<hr />
		<form id="form" action="/jnj/menu/market/apply" class="form-horizontal" method="post" >
			<input type="hidden" class="form-control" id="marketNo" name="marketNo" placeholder="marketNo" value="${marketNo}">
			<input type="hidden" class="form-control" id="memberId" name="memberId" placeholder="memberId" value="${memberId}">
			<div class="form-group">
				<label class="control-label col-sm-2" for="title">전화번호</label>
					<div class="col-sm-2">
						<select id="tel1" name="tel1" class="form-control">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="017">017</option>
						</select>
						<label class="error" for="tel1" generated="true" style="display:none; color: red;">error message</label>
					</div>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="tel2" name="tel2" placeholder="전화번호">
					<label class="error" for="tel2" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			
			<div class="form-group">
			<label class="control-label col-sm-2" for="title">부스 개수</label>
			<div class="col-sm-4">
					<input type="radio" name="boothNum" id="one" value="1">1개 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="boothNum" id="two" value="2">2개  
					<label class="error" for="boothNum" generated="true" style="display:none; color: red;">error message</label>
				</div>	
				<span id="text"class="control-label col-sm-4" for="title"></span>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="title">결제방법</label>
				<div class="col-sm-4">
					<input type="radio" name="payWay" id="card" value="1">카드결제 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="payWay" id="pay" value="2">무통장입금 
					<label class="error" for="payWay" generated="true" style="display:none; color: red;">error message</label> 
				</div>
				<span id="text2"class="control-label col-sm-4" for="title"></span>
			</div>
			<div id="ddd"></div>
			
			
			<br> <br> <br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<button type="submit" id="apply"  class="btn btn-default">신청</button>
			<button type="button" id="cancel" class="btn btn-default">취소</button>
		</form>
	</div>
</body>
</html>