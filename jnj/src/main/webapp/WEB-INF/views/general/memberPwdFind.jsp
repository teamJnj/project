<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<script src="js/bootstrap.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function() {
		var tmap;
		$("#emailSend").on("click", function() {

			$.ajax({
				url : "/jnj/find_pwd?type=2",
				type : "post",
				data : $("form").serialize(),

				success : function(map) {
					tmap = map;
					console.log(map);
					if (map == 0) {
						$("#text").text("아이디/이메일을 정확히 입력해주세요");
					} 
					else
						createScreenCheckCode(map);
				}
			});

		});
		
		$(document).on("click","#checkCodeButton", function(){
			var recheckCode = $("#recheckCode").val();
			var $checkCode = tmap.checkCode;
			if($checkCode==recheckCode){
				location.href="/jnj/setting_pwd?type=2&id="+tmap.id;
			}else {
				$("#text").text("인증번호 불일치");
			}
			
			
		});
		
		
		
		
		
		
	});
	
	function createScreenCheckCode(map){
		console.log(map);
		$("body").empty();
		
		var $form = $("<form></form>").appendTo("body");
		$("<input>").attr("type","text").attr("id","recheckCode").attr("name","recheckCode").attr("placeholder","인증번호입력").appendTo($form);
		$("<p></p>").attr("id","text").appendTo($form);
		$("<button>확인</button>").attr("type","button").attr("id","checkCodeButton").appendTo($form);
	}
	
	
</script>
<title>일반비밀번호찾기</title>
<style type="text/css">
* {
	text-align: center;
}
</style>
</head>
<body>
	<form action="/jnj/check_code" method="post">
		<h1>일반 비밀번호 찾기</h1>
		<div>
			<input type="text" id="id" name="id" class="form-control"
				placeholder="아이디를 입력해주세요"> <input type="email" id="email"
				name="email" class="form-control" placeholder="이메일을 입력해주세요">
			<p id="text"></p>
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}"> <br>
			<button type="button" id="emailSend" class="btn btn-default">비밀번호찾기</button>
		</div>

	</form>
</body>
</html>