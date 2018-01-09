<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<link rel="stylesheet" href="/jnj/resources/boot/css/bootstrap.css">
<script src="/jnj/resources/boot/js/bootstrap.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script type="text/javascript">
	$(function () {
		
		var id = ${id};
		console.log("2id : " + id);
		
		$("form").validate({
			rules : {
				password : {
					required : true,
					minlength : 3
				},
				repassword : {
					required : true,
					minlength : 3,
					equalTo : password
				}
			},
			messages : {
				password : {
					required : "필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다"
				},

				repassword : {
					required : "필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다",
					equalTo : "비밀번호가 일치하지 않습니다"
				}
			}
		});
		
		//type="hidden" name="${_csrf.parameterName}"
			//value="${_csrf.token}
		$("#settingPwd").on("click",function(){
			console.log("zzzzzzzzzzzzzzz");
			console.log($("form").serialize());
			$.ajax({
				url : "/jnj/setting_pwd",
				type : "POST",
				data : $("form").serialize()+"&id="+id+"&type=1&${_csrf.parameterName}=${_csrf.token}",  // password=1&repassword=2&id=주리
				success:function(){
					console.log("성공");
					opener.parent.location="/jnj/login";
					self.close();
				}
			})
		});
	});
</script>

<title>비밀번호찾기-재설정</title>
<style type="text/css">
* {
	text-align: center;
}
</style>
</head>
<body>
	<h1>비밀번호찾기-재설정</h1>
	<form action="/jnj/setting_pwd" method="post">
		<div>
			<input type="password" name="password" id="password" class="form-control" placeholder="비밀번호"><br>
			<input type="password" name="repassword" id="repassword" class="form-control" placeholder="비밀번호 확인">
			<br>
			<button type="button" id="settingPwd" class="btn btn-default">재설정</button>
		</div>

	</form>
</body>
</html>