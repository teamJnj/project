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
#adoptApplyContainer{
	text-align: center;
	margin-top: 80px;
}

#applyOkBtn{
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
	
	
	$("#applyOkBtn").on("click",function(){
		if($("#adoptMemberTel2").val()==""){
			alert("전화번호는 필수입력입니다.");
		}else{
			$("#applyOkBtn").attr("disabled","disabled");
			$adopt.adoptTel = ($("#adoptMemberTel1").val())+($("#adoptMemberTel2").val());
			
			$("<input></input>").attr("type","hidden").attr("name","petNo").val($adopt.petNo).appendTo("#applyAdoptCheckForm");
			$("<input></input>").attr("type","hidden").attr("name","petNo").val($adopt.petState).appendTo("#applyAdoptCheckForm");
			$("<input></input>").attr("type","hidden").attr("name","memberId").val($adopt.memberId).appendTo("#applyAdoptCheckForm");
			$("<input></input>").attr("type","hidden").attr("name","adoptNo").val($adopt.adoptNo).appendTo("#applyAdoptCheckForm");
			$("<input></input>").attr("type","hidden").attr("name","adoptTel").val($adopt.adoptTel).appendTo("#applyAdoptCheckForm");
			$("<input></input>").attr("type","hidden").attr("name","cancle").val($adopt.cancle).appendTo("#applyAdoptCheckForm");
			$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo("#applyAdoptCheckForm");
			
			console.log($("#applyAdoptCheckForm").serialize());
			$.ajax({
				url:"/jnj/menu/adopt/apply2",
				type:"post",
				data:$("#applyAdoptCheckForm").serialize(),
				success: function($adopt){
					self.close();
					opener.location.reload();
				}
			});
		}
		
		
	});
});
</script>
</head>
<body>
<div class="container" >
	<div class="navbar navbar-inverse" style="background-color:#FF9100; border: 1px solid #FF9100;">
		<p style="color:#fff; font-size:30px; font-weight: bold; background-color:#FF9100; text-align:center;">입양신청</p>
	</div>
</div>
		<div class="container" id="adoptApplyContainer">
			<form id="applyAdoptCheckForm">
				<p>전화번호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<select name="adoptMemberTel1" id="adoptMemberTel1">
				  <option value="010">010</option>
				  <option value="011">011</option>
				  <option value="019">019</option>
				  <option value="017">017</option>
				  <option value="-">직접입력</option>
				</select>  
				<input type="text" name="adoptMemberTel2" id="adoptMemberTel2"></p>
				<input type="button" class="btn btn-block" id="applyOkBtn" value="신청하기">
			</form>
		</div>

</body>
</html>