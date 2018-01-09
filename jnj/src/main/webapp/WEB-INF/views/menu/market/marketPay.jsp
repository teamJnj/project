<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<script>
$(function() {
	//var marketNo = "${marketNo}";
	var $map = ${requestScope.map};
	var $marketApply = $map.marketApply;
	var $market = $map.market;
	var $name = ${requestScope.name};
	console.log($marketApply);
	console.log($market.boothPrice);
	if($marketApply.payWay==1){
		$marketApply.payWay="카드결제";
	}else{
		$marketApply.payWay="무통장입금";
		$("#text2").text("우리 1002-135-303488");
		$("#text1").text("입금자명");
		$("#depositor").text($marketApply.depositor);
	}
	$("#marketNo").text($marketApply.marketNo);
	$("#applyTel").text($marketApply.applyTel);
	$("#boothNum").text($marketApply.boothNum+"개");
	$("#payWay").text($marketApply.payWay);
	$("#boothPrice").text($marketApply.boothNum*$market.boothPrice+"원");
	$("#end").on("click",function(){
		location.href = "/jnj/menu/market/view?marketNo="+$market.marketNo;
	})
	
})

	
	    
</script>
<style>
.pay {
	width : 810px;
	height : 550px;
}

.pay h3 {
	color: #7F5926;
	text-align: center;
}
.pay h4 {
	color: #7F5926;
}

#end {
	width: 150px;
	margin-left: 300px;
	margin-right: 10px;
}

</style>
</head>

<body>
<div class="container pay">
		<h3>-프리마켓 신청이 완료 되었습니다</h3>
		<h3>감사합니다</h3>
		<hr />
		<form action="/jnj/menu/market/pay" class="form-horizontal" method="get" >
			<input type="hidden" class="form-control" id="marketNo" name="marketNo" placeholder="marketNo" value="${marketNo}">
			<input type="hidden" class="form-control" id="memberId" name="memberId" placeholder="memberId" value="${memberId}">
			<div class="form-group">
				<label class="control-label col-sm-3" for="title"></label>
				<label class="control-label col-sm-2" for="title">전화번호</label>
				<span id="applyTel" name="applyTel" class="control-label col-sm-2" for="title"></span>
				<div class="col-sm-6">
				</div>
			</div>
			
			
			<div class="form-group">
				<label class="control-label col-sm-3" for="title"></label>
				<label class="control-label col-sm-2" for="title">부스 개수</label>
				<span id="boothNum"class="control-label col-sm-2" for="title"></span> 
				<span id="text"class="control-label col-sm-4" for="title"></span>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-3 for="title"></label>
				<label class="control-label col-sm-2" for="title">총 가격</label>
				<span id="boothPrice"class="control-label col-sm-2" for="title"></span> 
				<span id="text"class="control-label col-sm-4" for="title"></span>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-3" for="title"></label>
				<label class="control-label col-sm-2" for="title">결제수단</label>
				<span id="payWay"class="control-label col-sm-2" for="title"></span> 
				<span id="text2"class="control-label col-sm-4" for="title"></span>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-3" for="title"></label>
				<label id="text1"class="control-label col-sm-2" for="title"></label>
				<span id="depositor"class="control-label col-sm-2" for="title"></span> 
			</div>
			
			
			<br> <br> <br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<button type="button" id="end"  class="btn btn-default">확인</button>
			<br> <br> <br>
		</form>
	</div>

</body>
</html>