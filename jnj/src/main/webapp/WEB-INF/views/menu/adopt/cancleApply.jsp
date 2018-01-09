<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<style>
#adoptCancleContainer{
	text-align: center;
	margin-top: 80px;
}

#applyCancleBtn{
	float: center;
	width: 150px;
	margin-left: 40%;
	margin-top: 60px;
	background-color: #FFB24C;
}
</style>


<script>
$(document).ready(function(){
	var $adopt = ${adopt};
	
	console.log($adopt);
	
	
	$("#applyCancleBtn").on("click",function(){
		$("#applyCancleBtn").attr("disabled","disabled");
		
		$("<input></input>").attr("type","hidden").attr("name","petNo").val($adopt.petNo).appendTo("#applyAdoptCancleForm");
		$("<input></input>").attr("type","hidden").attr("name","petState").val($adopt.petState).appendTo("#applyAdoptCancleForm");
		$("<input></input>").attr("type","hidden").attr("name","memberId").val($adopt.memberId).appendTo("#applyAdoptCancleForm");
		$("<input></input>").attr("type","hidden").attr("name","adoptNo").val($adopt.adoptNo).appendTo("#applyAdoptCancleForm");
		$("<input></input>").attr("type","hidden").attr("name","cancle").val($adopt.cancle).appendTo("#applyAdoptCancleForm");
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#applyAdoptCancleForm");
		
		console.log($("#applyAdoptCancleForm").serialize());
		$.ajax({
			url:"/jnj/menu/adopt/cancle2",
			type:"post",
			data:$("#applyAdoptCancleForm").serialize(),
			success: function($adopt){
				self.close();
				opener.location.reload();
			}
		});
		
		
		
	});
});
</script>
</head>
<body>
<div class="container" >
	<div class="navbar navbar-inverse" style="background-color:#FF9100; border: 1px solid #FF9100;">
		<p style="color:#fff; font-size:30px; font-weight: bold; background-color:#FF9100; text-align:center;">입양취소</p>
	</div>
</div>
		<div class="container" id="adoptCancleContainer">
			<form id="applyAdoptCancleForm">
				<p style="color:red; font-size:40px; font-weight: bold; text-align:center;">정말 입양 취소하시겠습니까?</p>
				<input type="button" class="btn btn-block" id="applyCancleBtn" value="취소하기">
			</form>
		</div>

</body>
</html>