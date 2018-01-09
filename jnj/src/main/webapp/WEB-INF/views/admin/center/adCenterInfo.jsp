<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	
	<style>
		#total{
			margin:0;
			padding:0;
		}
		
		.btn-block{
			display : inline-block;
			width : 40%;
			margin : 0px;
			margin-left : 20px;
		}
		
		.btn-block+.btn-block {
    		margin-top : 0px;
    		margin : 20px;
		}
		
		.modal-dialog{
			text-align:center;
			position:relative;
			margin-top: calc(100% - 50%);
		}
		.model-content{
			position: relative;
		}
		
		.card-login{
			margin: 0 auto;
			margin-bottom : 50px;
			max-width:50rem;
			width: 500px;
		}
	
}
	</style>
	<script>
	
		// 상수 값 지정
		var BLOCK 	= 0;
		var USE		= 1;
		var JOIN	= 2;
		var RESIGNS	= 3;
		var RESIGN	= 4;
	
		$(function(){
			
			// 컨트롤러에서 정보 받아오기
			center = ${center};
			console.log(center);
			
			display_setting();
			
			
			// 가입승인 클릭 시
			$("#btnDiv").on("click", "#joinAcceptBtn", function(){
				// 모달창 생성
				var modalBody = $("#modalBody");
				modalBody.empty();
				$("<p id='modalText'></p>").text("가입을 승인 하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='joinAcceptModalBtn' class='btn btn-default' >승인</button>").appendTo(modalBody)
					.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			$("#myModal").on("click", "#joinAcceptModalBtn", function(){
				$.ajax({
					url : "/jnj/admin/center_info/join_accept",
					type : "post",
					data : {
						centerId : center.centerId,
						"${_csrf.parameterName}":"${_csrf.token}"
					},
					success:function( result ){
						if( result > 0 ){
							opener.location.reload();
							location.reload();
						}
						else{
							var modalBody = $("#modalBody");
							modalBody.empty();
							$("<p id='modalText'></p>").text("승인 처리 실패").appendTo(modalBody);
							$("<p id='modalText'></p>").text("다시 시도해 주세요.").appendTo(modalBody);
							$("<button type='button' id='closeBtn' class='btn btn-default'>확인</button>").appendTo(modalBody);
							$("#myModal").modal();
						}
					}
				});
			});
			
			// 탈퇴승인 클릭 시
			$("#btnDiv").on("click", "#resignAcceptBtn", function(){
				// 모달창 생성
				var modalBody = $("#modalBody");
				modalBody.empty();
				$("<p id='modalText'></p>").text("탈퇴를 승인 하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='resignAcceptModalBtn' class='btn btn-default' >승인</button>").appendTo(modalBody)
					.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			$("#myModal").on("click", "#resignAcceptModalBtn", function(){
				$.ajax({
					url : "/jnj/admin/center_info/resign_accept",
					type : "post",
					data : {
						centerId : center.centerId,
						"${_csrf.parameterName}":"${_csrf.token}"
					},
					success:function( result ){
						
						if( result ){
							opener.location.reload();
							location.reload();
						}
						else{
							var modalBody = $("#modalBody");
							modalBody.empty();
							$("<p id='modalText'></p>").text("입양이 진행 중입니다.").appendTo(modalBody);
							$("<p id='modalText'></p>").text("취소 후 탈퇴를 진행해주세요.").appendTo(modalBody);
							$("<button type='button' id='closeBtn' class='btn btn-default'>확인</button>").appendTo(modalBody);
							$("#myModal").modal();
						}
					}
				});
			});
			
			
			// 블락 클릭 시
			$("#blockBtn").on("click", function(){
				console.log("회원 블락을 클릭하셨습니다.");
				
				var centerIntState = ( center.centerState == USE )? BLOCK : USE;
				
				// 모달창 생성
				var modalBody = $("#modalBody");
				modalBody.empty();
				$("<p id='modalText'></p>").text(( center.centerState == USE )? "블락 하시겠습니까?" : "블락을 취소하시겠습니까?").appendTo(modalBody);
				var btnStr = ( center.centerState == USE )?"블락":"블락해제";
				$("<button type='button' id='blockBtn' class='btn btn-default' >"+btnStr+"</button>").appendTo(modalBody)
					.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default'>취소</button>").appendTo(modalBody);
        	
				$("#myModal").modal();
				
			});
			
			// 강제탈퇴 클릭 시
			$("#resignBtn").on("click", function(){
				console.log("강제 탈퇴를 클릭하셨습니다.");
				
				// 모달창 생성
				var modalBody = $("#modalBody");
				modalBody.empty();
				$("<p id='modalText'></p>").text("강제탈퇴 하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='resBtn' class='btn btn-default' >강제탈퇴</button>").appendTo(modalBody)
					.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default'>취소</button>").appendTo(modalBody);
        	
				$("#myModal").modal();
			});
			
			
			// 모달창 버튼 시 ============================================================
			// 블락 처리 확인 버튼
			$(".modal-body").on("click", "#blockBtn", function(e){
				e.preventDefault();
				clickBlock();
			});
			
			// 강제탈퇴 확인 버튼
			$(".modal-body").on("click", "#resBtn", function(e){
				e.preventDefault();
				clickResign();
			});
			
			// 모달 창 close 버튼 동작 ( 공통 )
			$(".modal-body").on("click", "#closeBtn", function(){
				$(this).attr( "data-dismiss", "modal");
			});
			
			// 탈퇴 성공 확인 버튼
			$(".modal-body").on("click", "#checkBtn", function(){
				$(this).attr( "data-dismiss", "modal");
				self.close();
				opener.location.reload();
			});
			
			
			function display_setting(){
				// 회원 정보 셋팅
				$("#centerId").val( center.centerId );
				$("#centerName").val( center.centerName );
				$("#centerAddr").val( center.centerAddr );
				$("#centerTel").val( center.centerTel );
				$("#email").val( center.email );
				$("#homepage").val( center.homepage );
				$("#licensee").val( center.licensee );
				$("#licenseeNo").val( center.licenseeNo );
				$("#accountInfo").val( center.sponsorAccountBank+"은행 / "+center.sponsorAccountNo+" / "+center.sponsorAccountHolder );
				
				var centerState;
				if( center.centerState == USE )				centerState = "사용중";
				else if( center.centerState == BLOCK )		centerState = "블락";
				else if( center.centerState == JOIN )		centerState = "가입대기";
				else if( center.centerState == RESIGNS )	centerState = "탈퇴대기";
				else										centerState = "탈퇴센터";
				
				// 상태에 따라 버튼생성
				var btnDiv = $("#btnDiv");
				btnDiv.empty();
				
				if( center.centerState == USE ){
					$("<a class='btn btn-primary btn-block' id='blockBtn' href='#'>블락</a>").appendTo(btnDiv);
					$("<a class='btn btn-primary btn-block' id='resignBtn' href='#'>강제탈퇴</a>").appendTo(btnDiv);
				}
				else if( center.centerState == BLOCK ){
						$("<a class='btn btn-primary btn-block' id='blockBtn' href='#'>블락해제</a>").appendTo(btnDiv);
						$("<a class='btn btn-primary btn-block' id='resignBtn' href='#'>강제탈퇴</a>").appendTo(btnDiv);
				}
				else if( center.centerState ==  JOIN ){
					var btn = $("<a class='btn btn-primary btn-success' id='joinAcceptBtn' href='#'>가입승인</a>").appendTo(btnDiv);
					
					var temp1 = $(".card-header").width()/2;
					var temp2 = $(".btn-success").width()/2;
					var temp3 = temp1 - temp2;
					btn.css({
						"margin"	: "0px",
						"display" 	: "inline-block",
						"position" 	: "relative",
						"left" 		: "50%",
						"left" : temp3+"px"
					});
				}
				else if( center.centerState ==  RESIGNS ){
					
					var btn = $("<a class='btn btn-primary btn-success' id='resignAcceptBtn' href='#'>탈퇴승인</a>").appendTo(btnDiv);
					
					var temp1 = $(".card-header").width()/2;
					var temp2 = $(".btn-success").width()/2;
					var temp3 = temp1 - temp2;
					btn.css({
						"margin"	: "0px",
						"display" 	: "inline-block",
						"position" 	: "relative",
						"left" 		: "50%",
						"left" 		: temp3+"px"
					});
				}
				
				$("#centerState").val( centerState );
				
				// 신고 수가 3회 이상이면 스타일 주기
				if( center.reportCnt >=3 )
					$("#reportCnt").css("color", "red").css("font-weight", "bold");
			}
			
			function clickBlock(){
				
				// 데이터 생성
				var frmDiv = $("#frm");
				frmDiv.empty();
				var form = $("<form></form>").appendTo(frmDiv);
				$("<input type='text' name='centerId' value="+center.centerId+" />").appendTo(form);
				var centerIntState = ( center.centerState == USE )? BLOCK:USE;
				$("<input type='hidden' name='centerState' value="+centerIntState+" />").appendTo(form);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(form);
				
				$.ajax({
					url : "/jnj/admin/center_block",
					type : "post",
					data : form.serialize(),
					success : function(result){
						console.log("블락 처리 성공 화면 갱신 result : " + result);
						if( result > 0){
							opener.location.reload();
							location.reload();
						}
						else{
							var modalBody = $("#modalBody");
							modalBody.empty();
							$("<p id='modalText'></p>").text("블락 처리 실패").appendTo(modalBody);
							$("<p id='modalText'></p>").text("다시 시도해 주세요.").appendTo(modalBody);
							$("<button type='button' id='closeBtn' class='btn btn-default'>확인</button>").appendTo(modalBody);
							$("#myModal").modal();
						}
					}
				});
			}
			
			function clickResign(){
				
				// 데이터 생성
				var frmDiv = $("#frm");
				frmDiv.empty();
				var form = $("<form></form>").appendTo(frmDiv);
				$("<input type='hidden' name='centerId' value="+center.centerId+" />").appendTo(form);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(form);
				
				$.ajax({
					url : "/jnj/admin/center_resign",
					type : "post",
					data : form.serialize(),
					success : function(result){
						console.log("강탈 처리 성공 화면 갱신 : " + result);
						
						$(this).attr( "data-dismiss", "modal");
						var modalBody = $("#modalBody");
						modalBody.empty();
						
						if( result )
							$("<p id='modalText'></p>").text("강제 탈퇴 처리 완료").appendTo(modalBody);
						else{
							$("<p id='modalText'></p>").text("입양이 진행 중입니다.").appendTo(modalBody);
							$("<p id='modalText'></p>").text("취소 후 탈퇴를 진행해주세요.").appendTo(modalBody);
						
						}
						$("<button type='button' id='checkBtn' class='btn btn-default' >확인</button>").appendTo(modalBody);
						$("#myModal").modal();
						
						opener.location.reload();
						location.reload();
					}
				});
			}
		});
		
	</script>
</head>
<body>
	<div id ="total">
		<div class="card card-login mx-auto mt-5">
			<div class="card-header">센터 정보</div>
			<div class="card-body">
				<form>
					<div class="form-group">
						<label for="centerId">아이디</label> 
						<input class="form-control" id="centerId" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="centerName">센터명</label> <input
							class="form-control" id="centerName" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="birthDate">주소</label> 
						<input class="form-control" id="centerAddr" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="point">전화번호</label> <input
							class="form-control" id="centerTel" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="grade">이메일</label> <input
							class="form-control" id="email" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="reportCnt">홈페이지</label> <input
							class="form-control" id="homepage" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="centerState">대표자</label> <input
							class="form-control" id="licensee" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="centerState">사업자등록번호</label> <input
							class="form-control" id="licenseeNo" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="centerState">계좌정보</label> <input
							class="form-control" id="accountInfo" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="centerState">상태</label> <input
							class="form-control" id="centerState" type="text" readonly="readonly">
					</div>
					
					<div id="btnDiv"> </div>
				</form>
				
			</div>
		</div>
	</div>
	
	<form id="searchFrm" class="form-inline my-2 my-lg-0 mr-lg-2">
	</form>

	<br>
	
  	<div id="modelTotal">
		<div class="modal fade" id="myModal" role="dialog" data-backdrop="static" >
			<div class="modal-dialog">
				<div id="test">
		      	<div class="modal-content">
		        	<div class="modal-body" id="modalBody">
		        	</div>
		      	</div>
		      	</div>
	    	</div>
	  	</div>
  	</div>
  	
  	<div id="frm"></div>

</body>
</html>