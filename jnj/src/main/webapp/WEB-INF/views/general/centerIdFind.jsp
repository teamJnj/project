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
	$(function () {
		
		$("#findId").on("click", function(){
			
			console.log($("form").serialize());
			$.ajax({
				url:"/jnj/find_id",
				type:"post",
				data:$("form").serialize()+"&type=2",
				
				success:function(centerId)
				{
					console.log("아이디 : " + centerId);
					if (centerId == 0) {
						$("#text").text("아이디를 찾지 못하였습니다.");
					} else {
						findIdResult(centerId);
					}
				}
			});
			
		});
		
		// 여기에 아이디 찾은 결과화면을 만들어줍니다.
		function findIdResult(centerId){
			$("body").empty();
			
			$("<input>").val(centerId).appendTo("body");
		}
		
	})
</script>
<title>센터아이디찾기</title>
<style type="text/css">
* {
	text-align: center;
}
</style>
</head>
<body>
	<form action="/jnj/find_id" method="post">
		<h1>센터 아이디 찾기</h1>
		<div>
			<input type="text" id="licensee" name="licensee" class="form-control" placeholder="대표자를 입력해주세요"> 
			<input type="email" id="email" name="email" class="form-control" placeholder="이메일을 입력해주세요">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<p id="text"></p>
		</div>
		<button type="button" id="findId" class="btn btn-default">아이디찾기</button>
	</form>
</body>
</html>