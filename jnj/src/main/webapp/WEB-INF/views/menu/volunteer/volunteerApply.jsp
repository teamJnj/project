<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<style>
.apply {
	width : 810px;
	height : 400px;;
}

.apply h3 {
	color: #7F5926;
}

#apply {
	width: 150px;
	margin-left: 200px;
	margin-right: 10px;
}

#cancel {
	width: 150px;
}

</style>
<script>
$(function(){
	var volunteerNo = "${volunteerNo}";
	
	
$("#form").validate({
		
		// 검증 규칙 지정
		rules : {
			tel2 : {
				required : true,
				digits : true,
				minlength : 7,
				maxlength : 8
			}
		},
		messages : {
			tel2 : {
				required :"전화번호를 입력해주세요",
				digits : "전화번호는 숫자만 입력 가능합니다",
				minlength : "최소 {0}숫자이상이어야 합니다",
				maxlength : "최대 {0}숫자이하이어야 합니다"
			}
		}
	});
	
	
	
	
	
	$("#cancel").on("click", function() {
		location.href = "/jnj/menu/volunteer/view?volunteerNo="+volunteerNo;
	})
})
</script>
</head>
<body>
	<div class="container apply">
		<h3>-봉사 신청</h3>
		<hr />
		<form id="form" action="/jnj/menu/volunteer/apply" class="form-horizontal" method="post" >
			<input type="hidden" class="form-control" id="volunteerNo" name="volunteerNo" value="${volunteerNo}">
			<input type="hidden" class="form-control" id="memberId" name="memberId"  value="${memberId}">

			<div class="form-group">
				<label class="control-label col-sm-2" for="title">전화번호</label>
					<div class="col-sm-2">
						<select id="tel1" name="tel1"  class="form-control">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="017">017</option>
						</select>
					</div>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="tel2" name="tel2"  placeholder="전화번호">
					<label class="error" for="tel2" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			<br> <br> <br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<button type="submit" id="apply"  class="btn btn-default">신청</button>
			<button type="button" id="cancel" class="btn btn-default">취소</button>
		</form>
	</div>
</body>
</html>