<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript" src="/jnj/resources/masterform/jquery.form.js"></script>
<script type="text/javascript" src="/jnj/resources/masterform/jquery.form.min.js"></script>

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
function bs_input_file() {
	$(".input-file")
			.before(
					function() {
						if (!$(this).prev().hasClass('input-ghost')) {
							var element = $("<input type='file' class='input-ghost' style='visibility:hidden; height:0'>");
							element.attr("name", $(this).attr("name"));
							element.change(function() {
								element.next(element).find('input').val(
										(element.val()).split('\\').pop());
							});
							$(this).find("button.btn-choose").click(
									function() {
										element.click();
									});
							$(this).find("button.btn-reset").click(
									function() {
										element.val(null);
										$(this).parents(".input-file")
												.find('input').val('');
									});
							$(this).find('input').css("cursor", "pointer");
							$(this).find('input').mousedown(
									function() {
										$(this).parents('.input-file')
												.prev().click();
										return false;
									});
							return element;
						}
					});
}

$(function(){
	bs_input_file();
	
	$("#cancel").on("click", function() {
		self.close();
	});
	
	// 상품 등록 한다
	$("#write").on("click", function() {
		$("form").ajaxForm({
			enctype: "multipart/form-data",
			url : "/jnj/admin/goods/register",
			type: "post",
			data : $("form").serialize(),
		    success : function(result) {
		    	console.log( "result : " + result );
		    	self.close();
		    	opener.location.reload();
		    }
		}).submit();
	});
	
	var cnt = 0;
	$("#addOption").on("click", function(){
		console.log("zzzz");
		cnt++;
		var optionDiv = $("#optionDiv");
		$("<input type='text' class='form-control' name='optionContent' placeholder='옵션'>").appendTo(optionDiv);
	});
	
	$("#addImg").on("click", function(){
		console.log("qqqqq");
		var imgDiv = $("#imgDiv");
		var div = $("<div class=\"input-group input-file\" name=\"files\"></div>").appendTo( imgDiv );
		$("<span class=\"input-group-btn\"><button class=\"btn btn-default btn-choose\" type=\"button\">Choose</button></span>").appendTo(div);
		$("<input type=\"text\" class=\"form-control\" placeholder='Choose a file...' /> ").appendTo(div);
		$("<span class=\"input-group-btn\"> <button class=\"btn btn-warning btn-reset\" type=\"button\">Reset</button> </span>").appendTo(div);
		bs_input_file();
	});

});
</script>
</head>
<body>
	<div class="container write">
		<h3>- 상품 등록</h3>
		<hr/>
		<form action="/jnj/admin/goods/register" class="form-horizontal" method="post" enctype="multipart/form-data">
		
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">카테고리</label>
				<div class="col-sm-2">
					<select class="form-control" name="categoryName">
						<option value="">선택</option>
						<option value="액세서리">액세서리</option>
						<option value="가방/파우치">가방/파우치</option>
						<option value="문구">문구</option>
						<option value="기타">기타</option>
					</select>
				</div>		
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text" >옵션</label>
				<div class="col-sm-2" id="optionDiv">
					<input type="text" class="form-control" id="marketTitle" name="optionContent" placeholder="옵션">
				</div>	
				<button type="button" id="addOption" class="btn btn-default">추가</button>	
			</div>
			

			<div class="form-group">
				<label class="control-label col-sm-2" for="text">상품명</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" name="goodsName" placeholder="상품명">
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">상품내용</label>
				<div class="col-sm-8">
					<textarea class="form-control" name="goodsContent" placeholder="내용"></textarea>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">상품가격</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" name="goodsPrice" placeholder="가격">
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">재고수량</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" name="stockQnt" placeholder="재고수량">
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">상태</label>
				<div class="col-sm-2">
					<select class="form-control" name="goodsState">
						<option value="">선택</option>
						<option value="2">대기</option>
						<option value="1">판매중</option>
						<option value="0">품절</option>
					</select>
				</div>		
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">이미지</label>
				<div class="col-sm-5" id="imgDiv">
					<div class="input-group input-file" name="files">
						<span class="input-group-btn">
							<button class="btn btn-default btn-choose" type="button">Choose</button>
						</span> 
						<input type="text" class="form-control" placeholder='Choose a file...' /> 
						<span class="input-group-btn">
							<button class="btn btn-warning btn-reset" type="button">Reset</button>
						</span>
					</div>
				</div>	
				<button type="button" id="addImg" class="btn btn-default">추가</button>	
			</div>
			
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			
			<br>
			<br>
			<br>
			
			<button type="button" id="cancel" class="btn btn-default">취소</button>
			<button type="button" id="write" class="btn btn-default">작성</button>
		</form>
	</div>
	<br><br><br><br><br><br>
</body>
</html>