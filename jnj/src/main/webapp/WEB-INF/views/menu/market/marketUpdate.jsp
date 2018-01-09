<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<style>
.update {
	margin-top: 30px;
}

.update h3 {
	color: #7F5926;
}

#update{
	width:150px;
	margin-left:380px;
 	margin-right: 10px;
		
}
#cancel{
	width:150px;
}
</style>
<script>
$(function() {
		var $market = ${market};
		$("#marketNo").val($market.marketNo);
		$("#marketTitle").val($market.marketTitle);
		$("#marketContent").val($market.marketContent);
		$("#marketDate").val($market.marketDate);
		$("#boothPrice").val($market.boothPrice);
		$("#applyEndDate").val($market.applyEndDate);
		console.log($market.marketNo);
		
		
		$("#cancel").on("click", function() {
			
			location.href = "/jnj/menu/market/view?marketNo="+$market.marketNo;
		})
		
		
		$("#form").validate({
			
			// 검증 규칙 지정
			rules : {
				marketTitle : {
					required : true,
					minlength : 1,
					maxlength : 50
				},
				marketContent : {
					required : true,
					minlength : 1,
					maxlength : 200
				},
				marketDate : {
					required : true
				},
				applyEndDate : {
					required : true
				},
				boothPrice : {
					required : true,
					digits : true,
					minlength : 4,
					maxlength : 5
				}
			},
			messages : {
				marketTitle : {
					required : "제목을 입력해주세요.",
				} ,
				marketContent : {
					required : "내용 입력해주세요",
					minlength : "최소 {0}글자이상이어야 합니다",
					maxlength : "최대 {0}글자이하이어야 합니다"
				},
				marketDate : {
					required : "날짜를 입력해주세요."
				},
				applyEndDate : {
					required : "신청마감일 입력해주세요"
				},
				boothPrice : {
					required :"부스가격을 입력해주세요",
					digits : "숫자만 입력 가능합니다",
					minlength : "최소 {0}숫자이상이어야 합니다",
					maxlength : "최대 {0}숫자이하이어야 합니다"
				}
			}
		});
		
})
	



</script>
</head>
<body>

	<div class="container update">
		<h3>-모집:프리마켓</h3>
		<hr />
		<form id="form" action="/jnj/menu/market/update" class="form-horizontal" method="post">
			<input type="hidden" class="form-control" id="marketNo" name="marketNo">
			<!-- enctype="multipart/form-data" -->
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="marketTitle" name="marketTitle">
					<label class="error" for="marketTitle" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">내용</label>
				<div class="col-sm-8">
					<textarea  class="form-control" rows="15" id="marketContent" name="marketContent"></textarea>
					<label class="error" for="marketContent" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">날짜</label>
				<div class="col-sm-2">
					<input type="date" class="form-control" id="marketDate" name="marketDate">
					<label class="error" for="marketDate" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">신청마감일</label>
				<div class="col-sm-2">
					<input type="date" class="form-control" id="applyEndDate" name="applyEndDate">
					<label class="error" for="applyEndDate" generated="true" style="display:none; color: red;">error message</label>
				</div>		
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">부스 가격</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="boothPrice" name="boothPrice">
					<label class="error" for="boothPrice" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			
			
			
			<br>
			<br>
			<br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<input type="submit" id="update"  class="btn btn-default" value="작성">
			<button type="button" id="cancel" class="btn btn-default">취소</button>
		</form>
	</div>
	<br><br><br><br><br><br>
</body>
</html>