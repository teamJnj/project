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
	margin-top: 100px;
}

.write h3 {
	color: #7F5926;
}
#write {
	width: 150px;
	margin-left: 420px;
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
$(function(){
	$("#cancel").on("click", function() {
		location.href = "/jnj/menu/board_notice/record";
	})
	
$("#form").validate({
		
		// 검증 규칙 지정
		rules : {
			title : {
				required : true,
				minlength : 1,
				maxlength : 50
			},
			content : {
				required : true,
				minlength : 1,
				maxlength : 500
			}
		},
		messages : {
			title : {
				required :"제목을 입력해주세요",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			},
			content : {
				required :"내용을 입력해주세요",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			}
		}
	});
	
	
	
})
</script>
</head>
<body>
	<div class="container write">
		<h3>-공지사항</h3>
		<hr />
		<form id="form" action="/jnj/menu/board_notice/write" class="form-horizontal" method="post">
			<!-- enctype="multipart/form-data" -->
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="title" name="title" placeholder="제목">
					<label class="error" for="title" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">내용</label>
				<div class="col-sm-8">
					<textarea rows="15"  class="form-control" id="content" name="content" placeholder="내용"></textarea>
					<label class="error" for="content" generated="true" style="display:none; color: red;">error message</label>
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