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
		var ADMIN	= 2;
		var RESIGN	= 3;
	
		$(function(){
			
			// 컨트롤러에서 멤버 정보 받아오기
			var member = ${member};
			console.log(member);
			
			display_setting();
			
			// 블락 클릭 시
			$("#blockBtn").on("click", function(){
				console.log("회원 블락을 클릭하셨습니다.");
				
				var memberIntState = ( member.memberState == USE )? BLOCK : USE;
				console.log( "memberIntState : " + memberIntState );
				
				// 모달창 생성
				var modalBody = $("#modalBody");
				modalBody.empty();
				$("<p id='modalText'></p>").text(( member.memberState == USE )? "블락 하시겠습니까?" : "블락을 취소하시겠습니까?").appendTo(modalBody);
				var btnStr = ( member.memberState == USE )?"블락":"블락해제";
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
				$("#memberId").val( member.memberId );
				$("#memberName").val( member.memberName );
				$("#birthDate").val( member.birthDate );
				$("#point").val( member.point+"점" );
				$("#grade").val( member.grade );
				$("#reportCnt").val( member.reportCnt+"회" );
				
				var memberState;
				if( member.memberState == USE )				memberState = "사용중";
				else if( member.memberState == BLOCK )		memberState = "블락";
				else if( member.memberState == ADMIN )		memberState = "관리자";
				else										memberState = "탈퇴회원";
				$("#memberState").val( memberState );
				
				if( member.memberState < 3 ){
					var btnDiv = $("#btnDiv");
					btnDiv.empty();
					$("<a class='btn btn-primary btn-block' id='blockBtn' href='#'>블락</a>").appendTo(btnDiv);
					$("<a class='btn btn-primary btn-block' id='resignBtn' href='#'>강제탈퇴</a>").appendTo(btnDiv);
					$("#blockBtn").text((member.memberState == USE)?"블락":"블락취소");
				}
				
				// 신고 수가 3회 이상이면 스타일 주기
				if( member.reportCnt >=3 )
					$("#reportCnt").css("color", "red").css("font-weight", "bold");
			}
			
			function clickBlock(){
				
				// 데이터 생성
				var frmDiv = $("#frm");
				frmDiv.empty();
				var form = $("<form></form>").appendTo(frmDiv);
				$("<input type='text' name='memberId' value="+member.memberId+" />").appendTo(form);
				var memberIntState = ( member.memberState == USE )? BLOCK:USE;
				$("<input type='hidden' name='memberState' value="+memberIntState+" />").appendTo(form);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(form);
				
				$.ajax({
					url : "/jnj/admin/member_block",
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
				$("<input type='hidden' name='memberId' value="+member.memberId+" />").appendTo(form);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(form);
				
				$.ajax({
					url : "/jnj/admin/member_resign",
					type : "post",
					data : form.serialize(),
					success : function(result){
						
						console.log("강탈 처리 성공 화면 갱신 : " + result);
						
						$(this).attr( "data-dismiss", "modal");
						
						if( result ){
							opener.location.reload();
							location.reload();
						}
						else{
							var modalBody = $("#modalBody");
							modalBody.empty();
							$("<p id='modalText'></p>").text("입양이 진행 중입니다.").appendTo(modalBody);
							$("<p id='modalText'></p>").text("취소 후 탈퇴를 진행해주세요.").appendTo(modalBody);
							$("<button type='button' id='checkBtn' class='btn btn-default' >확인</button>").appendTo(modalBody);
							$("#myModal").modal();
						}
						
						
						
					}
				});
			}
			
			
		});
		
	</script>
</head>
<body>
	<div id ="total">
		<div class="card card-login mx-auto mt-5">
			<div class="card-header">회원 정보</div>
			<div class="card-body">
				<form>
					<div class="form-group">
						<label for="memberId">아이디</label> 
						<input class="form-control" id="memberId" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="memberName">이름</label> <input
							class="form-control" id="memberName" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="birthDate">생년월일</label> 
						<input class="form-control" id="birthDate" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="point">포인트</label> <input
							class="form-control" id="point" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="grade">등급</label> <input
							class="form-control" id="grade" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="reportCnt">신고</label> <input
							class="form-control" id="reportCnt" type="text" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="memberState">상태</label> <input
							class="form-control" id="memberState" type="text" readonly="readonly">
					</div>
					<div id="btnDiv">
					</div>
				</form>
				
			</div>
		</div>
	</div>
	
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