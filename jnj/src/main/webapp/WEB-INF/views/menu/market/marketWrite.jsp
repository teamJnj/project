<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<style>
.write {
	margin-top: 30px;
}

.write h3 {
	color: #7F5926;
}
#write {
	width: 150px;
	margin-left: 420px;
	margin-right: 10px;
}
#cancel{
	width:150px;
}
</style>
<script>


$(function(){
	$("#cancel").on("click", function() {
		location.href = "/jnj/menu/market/record";
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
	<div class="container write">
		<h3>-모집:프리마켓</h3>
		<hr />
		<form id="form" action="/jnj/menu/market/write" class="form-horizontal" method="post">
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="marketTitle" name="marketTitle" placeholder="제목">
					<label class="error" for="marketTitle" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">내용</label>
				<div class="col-sm-8">
					<textarea class="form-control" rows="15" id="marketContent" name="marketContent" placeholder="내용"></textarea>
					<label class="error" for="marketContent" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">날짜</label>
				<div class="col-sm-2">
					<input type="date" class="form-control" id="marketDate" name="marketDate" placeholder="날짜">
					<label class="error" for="marketDate" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">신청마감일</label>
				<div class="col-sm-2">
					<input type="date" class="form-control" id="applyEndDate" name="applyEndDate" placeholder="신청마감일">
					<label class="error" for="applyEndDate" generated="true" style="display:none; color: red;">error message</label>
				</div>		
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">부스 가격</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="boothPrice" name="boothPrice" placeholder="부스가격">
					<label class="error" for="boothPrice" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			
			
			
			<br>
			<br>
			<br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<input type="submit" id="write"  class="btn btn-default" value="작성">
			<button type="button" id="cancel" class="btn btn-default">취소</button>
		</form>
	</div>
	<br><br><br><br><br><br>
</body>
</html>