<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 결제모듈 라이브러리 추가 -->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<style>
#payMoneyContainer{
	text-align: center;
	margin-top: 40px;
}

#payMoney{
	border: 1px solid #fff;
	margin-left: 17%;
	font-size: 30px;
}

#sponsorFinalPay{
	border: 1px solid #fff;
}

#FinalPayMoney{
	border: 1px solid #fff;
	margin-left: 33%;
	font-size: 30px;
}

#payWayContainer{
	float: center;
	text-align: center;
	font-size: 15px;
}

#payWayBtn{
	float: center;
	width: 150px;
	margin-left: 40%;
	margin-top: 40px;
	background-color: #FFB24C;
}

#sponsorReply{
	float: center;
	margin-left: 23%;
	margin-top: 30px;
}

#totalDiv{
	margin-top:150px;
}
</style>


<script>
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
};


$(function(){
	var $spInfo = ${spInfo};
	
	$("#payMoney").val("결제 금액: "+numberWithCommas($spInfo.payMoney)+"원");
	var myPayMoney = numberWithCommas($spInfo.payMoney);
	
		$("#payWayBtn").on("click", function() {
			
			console.log("결제 버튼을 클릭. 결제 금액: " + myPayMoney );
			var payStateCheck = false;	// 결제에 성공했는지 실패 했는지 판단하는 변수
			var paySelectWay = "";		// 사용자가 선택한 결제 방법
			
			var $payWayCheck = $(':input[name=payWayCheck]:radio:checked').val();
			var $depositor = $('#depositor').val();
			
			if($payWayCheck==3){
				$("#payWayBtn").attr("disabled","disabled");
				$spInfo.payWay=1;
				paySelectWay = "phone";
				$("<input></input>").attr("type","hidden").attr("name","payMoney").val($spInfo.payMoney).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","petNo").val($spInfo.petNo).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","payWay").val($spInfo.payWay).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($spInfo.sponsorNo).appendTo("#payCheckForm");
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#payCheckForm");
			}
			else if($payWayCheck==1){
				$("#payWayBtn").attr("disabled","disabled");
				$spInfo.payWay=1;
				
				$("<input></input>").attr("type","hidden").attr("name","payMoney").val($spInfo.payMoney).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","petNo").val($spInfo.petNo).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","payWay").val($spInfo.payWay).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($spInfo.sponsorNo).appendTo("#payCheckForm");
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#payCheckForm");
			} else if($payWayCheck==2){
				$("#payWayBtn").attr("disabled","disabled");
				$spInfo.payWay=2;
				$("<input></input>").attr("type","hidden").attr("name","payMoney").val($spInfo.payMoney).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","petNo").val($spInfo.petNo).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","payWay").val($spInfo.payWay).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($spInfo.sponsorNo).appendTo("#payCheckForm");
				$("<input></input>").attr("type","hidden").attr("name","depositor").val($spInfo.depositor).appendTo("#payCheckForm");
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#payCheckForm");
			} else{
				alert("결제 방법을 선택하세요");
				// 결제 방법 선택을 안했을때는 
				// 뒤에 있는 코드가 실행되면 안되니까 return 해줍시다 꼭ㅋㅋ
				return;	
			}
			
			if( $payWayCheck== 3){
				// 결제 모듈 연동
				var IMP = window.IMP;
				   IMP.init('imp39302297');  	// 식별 코드
		
				   IMP.request_pay({
					    pg : 'danal',				// 다날 결제 연결
					    pay_method : paySelectWay,	// 선택한 결제 방식은?
					    merchant_uid : 'merchant_' + new Date().getTime(),
					    name : '후원하기 결제',
					    amount : myPayMoney,
					    buyer_email : '',
					    buyer_name : '박주리',
					    buyer_tel : '010-6865-9692',
					    buyer_addr : '인천광역시 연수구 옥련동',
					    buyer_postcode : '123-456',
					    m_redirect_url : 'http://localhost:8082/jnj/menu/sponsor/pay1'
					}, function(rsp) {
					    if ( rsp.success ) {
					    	console.log( rsp.paid_amount + "결제가 완료되었습니다.");
					    	payStateCheck = true;
					    	var msg = rsp.paid_amount + "결제가 완료되었습니다.";
					        /*
						       	고유ID : rsp.imp_uid
						        상점 거래ID : rsp.merchant_uid
						        결제 금액 : rsp.paid_amount
						        카드 승인번호 : rsp.apply_num 
						    */
					    } else {
					    	payStateCheck = false;
					        var msg = '결제에 실패하였습니다.';
					        msg += '에러내용 : ' + rsp.error_msg;
					    }
					    
					    // 결제가 성공 했을 때만 다음으로 넘어간다 
					    if( payStateCheck == true ){
					    	
					    	alert(msg);	// 결제 금액 얼마 성공 메시지 띄우고
					    	
					    	// DB에 처리하러 갑시다.
					    	$.ajax({
								url:"/jnj/menu/sponsor/pay2",
								type:"post",
								data:$("#payCheckForm").serialize(),
								success: function($spInfo){
									$(".container").empty();
									
									 var $container=$("body").append("<div class='container'></div>");
									 $("<p id='sponsorFinalPay' style='color:#FF9100; font-size:40px; font-weight: bold; text-align: center;'></p>").text("후원에 성공하였습니다.").appendTo($container);
									 var $finalPay=$("<p></p>").appendTo($container);
									 $("<input type='text' id='FinalPayMoney' readonly='readonly'></input>").val("후원 금액: "+$spInfo.payMoney+"원").appendTo($finalPay);
									 
									 var $form=$("<form id='finalPayForm'></form>").appendTo($container);
									 
									 $("<textarea rows='4' cols='60' name='sponsorReply' id='sponsorReply' placeholder='후원합니다.' maxlength='30'></textarea>").appendTo($form);
									 
									 $("<a class='btn btn-block' id='insertSponsorPayBtn' style='background-color:#FFB24C; width: 100px; margin-top:15px; margin-left:45%; color:#fff'></a>").text("등록하기").appendTo($form);
									 $("<input></input>").attr("type","hidden").attr("name","petNo").val($spInfo.petNo).appendTo("#finalPayForm");
									 $("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($spInfo.sponsorNo).appendTo("#finalPayForm");
									 $("<input></input>").attr("type","hidden").attr("name","memberSponsorNo").val($spInfo.memberSponsorNo).appendTo("#finalPayForm");
									 $("<input></input>").attr("type","hidden").attr("name","payMoney").val($spInfo.payMoney).appendTo("#finalPayForm");
									 $("<input></input>").attr("type","hidden").attr("name","goalMoney").val($spInfo.goalMoney).appendTo("#finalPayForm");
									 $("<input></input>").attr("type","hidden").attr("name","sponsorMoney").val($spInfo.sponsorMoney).appendTo("#finalPayForm");
									 $("<input></input>").attr("type","hidden").attr("name","payWay").val($spInfo.payWay).appendTo("#finalPayForm");
									 $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#finalPayForm");
									 
									 $("#finalPayForm").on("click","#insertSponsorPayBtn",function(e){
										 
										 var $sponsorReply = $("#sponsorReply").val();
										 
										if($sponsorReply=="")
											$("#sponsorReply").val("후원합니다.");
										else
											$("#sponsorReply").val($sponsorReply);
										 
										$.ajax({
												url:"/jnj/menu/sponsor/pay_result",
												type:"post",
												data:$("#finalPayForm").serialize(),
												success: function(){
													self.close();
													opener.location.reload();
												}
									 	});
									});
								}
							});
					    }
					    else{
					    	// 버튼은 다시 활성화 시켜줍시닼ㅋㅋ
					    	$("#payWayBtn").prop("disabled", false);
					    	alert(msg);
					    }
				});
			}
			else{
				// DB에 처리하러 갑시다.
		    	$.ajax({
					url:"/jnj/menu/sponsor/pay2",
					type:"post",
					data:$("#payCheckForm").serialize(),
					success: function($spInfo){
						$(".container").empty();
						
						 var $container=$("body").append("<div class='container'></div>");
						 $("<p id='sponsorFinalPay' style='color:#FF9100; font-size:40px; font-weight: bold; text-align: center;'></p>").text("후원에 성공하였습니다.").appendTo($container);
						 var $finalPay=$("<p></p>").appendTo($container);
						 $("<input type='text' id='FinalPayMoney' readonly='readonly'></input>").val("후원 금액: "+$spInfo.payMoney+"원").appendTo($finalPay);
						 
						 var $form=$("<form id='finalPayForm'></form>").appendTo($container);
						 
						 $("<textarea rows='4' cols='60' name='sponsorReply' id='sponsorReply' placeholder='후원합니다.' maxlength='30'></textarea>").appendTo($form);
						 
						 $("<a class='btn btn-block' id='insertSponsorPayBtn' style='background-color:#FFB24C; width: 100px; margin-top:15px; margin-left:45%; color:#fff'></a>").text("등록하기").appendTo($form);
						 $("<input></input>").attr("type","hidden").attr("name","petNo").val($spInfo.petNo).appendTo("#finalPayForm");
						 $("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($spInfo.sponsorNo).appendTo("#finalPayForm");
						 $("<input></input>").attr("type","hidden").attr("name","memberSponsorNo").val($spInfo.memberSponsorNo).appendTo("#finalPayForm");
						 $("<input></input>").attr("type","hidden").attr("name","payMoney").val($spInfo.payMoney).appendTo("#finalPayForm");
						 $("<input></input>").attr("type","hidden").attr("name","goalMoney").val($spInfo.goalMoney).appendTo("#finalPayForm");
						 $("<input></input>").attr("type","hidden").attr("name","sponsorMoney").val($spInfo.sponsorMoney).appendTo("#finalPayForm");
						 $("<input></input>").attr("type","hidden").attr("name","payWay").val($spInfo.payWay).appendTo("#finalPayForm");
						 $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#finalPayForm");
						 
						 $("#finalPayForm").on("click","#insertSponsorPayBtn",function(e){
							 
							 var $sponsorReply = $("#sponsorReply").val();
							 
							if($sponsorReply=="")
								$("#sponsorReply").val("후원합니다.");
							else
								$("#sponsorReply").val($sponsorReply);
							 
							$.ajax({
									url:"/jnj/menu/sponsor/pay_result",
									type:"post",
									data:$("#finalPayForm").serialize(),
									success: function(){
										self.close();
										opener.location.reload();
									}
						 	});
						});
					}
				});
			}

	});
});
</script>
</head>
<body>

	<div id="totalDiv">
		<div class="container" >
			<div class="navbar navbar-inverse" style="background-color:#FF9100; border: 1px solid #FF9100;">
				<p style="color:#fff; font-size:30px; font-weight: bold; background-color:#FF9100; text-align:center;">결제 진행</p>
			</div>
		</div>
	
		<div class="container" id="payMoneyContainer">
			<p><input type="text" id="payMoney" readonly="readonly" ></p>
		</div>
			
		<div class="container" id="payWayContainer">
			<form id="payCheckForm">
				<input type="radio" name="payWayCheck" id="payWayPhone" value="3">핸드폰결제 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="payWayCheck" id="payWayCard" value="1">카드 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="payWayCheck" id="payWayBank" value="2">무통장 입금&nbsp;&nbsp;<input type="text" name="depositor" id="depositor" placeholder="입금자" style="width:100px;"><br>
				<input type="button" class="btn btn-block" id="payWayBtn" value="결제하기"></button>
			</form>
		</div>
	</div>
	
</body>
</html>