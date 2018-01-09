<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style>
.write {
	margin-top: 100px;
}

.write h3 {
	color: #7F5926;
}

#write{
	width:150px;
	margin-left:380px;
 	margin-right: 10px;
	background-color: #FFB24C;
	color: #7F5926;
		
}
#cancel{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
}
</style>
<script>
$(function() {
		var $market = ${market};
		$("#marketNo").val($market.marketNo);
		$("#marketTitle").val($market.marketTitle);
		$("#marketAddr").val($market.marketAddr);
		$("#marketContent").val($market.marketContent);
		$("#marketDate").val($market.marketDate);
		$("#boothPrice").val($market.boothPrice);
		$("#applyEndDate").val($market.applyEndDate);
		console.log($market.marketNo);
		
		
		$("#cancel").on("click", function() {
			self.close();
		});
		
		$("#write").on("click", function() {
			console.log("여기");
			$.ajax({
				url 	: "/jnj/admin/market/update",
				type 	: "post", 
				data	: $("form").serialize(),
				success : function(result){
					self.close();
					opener.location.reload();
				}
			});
		});
		
})
	



</script>
</head>
<body>

	<div class="container write">
		<h3>-모집:프리마켓</h3>
		<hr />
		<form action="/jnj/menu/market/pay" class="form-horizontal" method="get">
			<input type="hidden" class="form-control" id="marketNo" name="marketNo" placeholder="marketNo">
			<!-- enctype="multipart/form-data" -->
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="marketTitle" name="marketTitle"
						placeholder="제목">
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">내용</label>
				<div class="col-sm-8">
					<textarea class="form-control" id="marketContent" name="marketContent"
						placeholder="내용"></textarea>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">날짜</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="marketDate" name="marketDate"
						placeholder="날짜">
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">참가비</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="boothPrice" name="boothPrice"
						placeholder="참가비">
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">신청마감일</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="applyEndDate" name="applyEndDate"
						placeholder="신청마감일">
				</div>		
			</div>
			
			
			
			
			
			
			<br>
			<br>
			<br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<button type="button" id="cancel" class="btn btn-default">취소</button>
			<button type="button" id="write" class="btn btn-default">작성</button>
		</form>
	</div>
	<br><br><br><br><br><br>
</body>
</html>