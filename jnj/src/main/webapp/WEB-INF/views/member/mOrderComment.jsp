<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="/jnj/resources/boot/js/bootstrap.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="/jnj/resources/boot/css/bootstrap.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<title>Insert title here</title>
<script>
$(function() {
	var goodsNo = ${goodsNo};
	var optionNo = ${optionNo};
	var orderNo = ${orderNo};
	
	
	$("#write").on("click", function() {
		var comm = $("#commWrite");
		$("<input type='hidden' name='orderNo' value='"+orderNo+"'>").appendTo(comm);
		$("<input type='hidden' name='goodsNo' value='"+goodsNo+"'>").appendTo(comm);
		$("<input type='hidden' name='optionNo' value='"+optionNo+"'>").appendTo(comm);
		$.ajax({
			url: "/jnj/member/store/comment/write",
			method: "post",
			data: $("#reviewComm").serialize(),
			success: function(result) {
				if(result) {
					window.location.reload();
					window.close();
					opener.location.reload();
				}
			}	
		})
		
		
	})
})
</script>
<style>
#reviewComm {
	padding: 20px;
}
</style>
</head>
<body>
	
	<form method="post" id="reviewComm">
		<h3>리뷰 작성</h3>
		<hr/>
		<div class="form-group" id="commWrite">
			<select id="satisfy" name="satisfy" class="form-control">
				<option>만족도</option>
				<option value="5">★★★★★</option>
				<option value="4">☆★★★★</option>
				<option value="3">☆☆★★★</option>
				<option value="2">☆☆☆★★</option>
				<option value="1">☆☆☆☆★</option>
				<option value="0">☆☆☆☆☆</option>
			</select>
			<input type="text" class="form-control" id="reviewContent" name="reviewContent" placeholder="내용을 입력해주세요">
			<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />
		</div>
		<button id="write" type="button" class="btn btn-default">입력</button>
	</form>
</body>
</html>