<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<style>
	#cancelQnaWrite, .qnaWrite h3 {
		color: #7F5926;
	}
	#cancelQnaWrite, .qnaWrite button {
		float: right;
		margin-right: 10px;
		background-color: #FFB24C;
		color: #7F5926;
	}
	#cancelQnaWrite:hover, .qnaWrite button:hover {
		background-color: #7F5926;
		color: #FFB24C;
	}
	
	/* 
	.qnaWrite textarea {
		height: 300px;
	}
	 */
	 
	#qnaContent{
		height:300px;
		width: 750px;
	}
</style>

<script>
$(function(){
	
	
	var $qna = ${qna};
	
	
	console.log($qna);
	
	var $cState = ${cState};
	
	if($cState==0||$cState==3) {
		$(".nomalState").attr("href", "#");
	}
	
	
	$("#qnaTitle").val($qna.qnaTitle);
	$("#qnaContent").val($qna.qnaContent);
	$("#file").val($qna.file);
	
	
	$("#cancelQnaWrite").on("click",function(){
		location.href="/jnj/common/cQna/record";
	});
	
 
	$("#qnaUpdate").on("click",function(){
		var $form = $("#qnaUpdateForm");
		$("<input></input>").attr("type","hidden").attr("name","qnaNo").val($qna.qnaNo).appendTo($form);
		
		
		/* if($("#file").val!=null){
			$("<input></input>").attr("type","hidden").attr("name","qnaImg").val($("#file").val()).appendTo($form);
		} else{
			$("<input></input>").attr("type","hidden").attr("name","qnaImg").val($qna.qnaImg).appendTo($form);
		} */
		
		$("<input></input>").attr("type","hidden").attr("name","qnaImg").val($qna.qnaImg).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","writeId").val($qna.writeId).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","writeDate").val($qna.writeDate).appendTo($form);
		$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
		
		$form.submit();
		
	});

});

</script>
</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info" class="nomalState">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" class="nomalState">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt" class="nomalState">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor" class="nomalState">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer" class="nomalState">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna" style="color: navy; font-weight: 700; font-size: 20px;">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign" class="nomalState">회원탈퇴</a></h4>
	<hr>

	<div class="container qnaWrite">
		<h3>1:1문의</h3>
		
		<hr/>
		<form action="/jnj/common/cQna/update2" method="post" id="qnaUpdateForm" class="form-horizontal" enctype="multipart/form-data">
		<%-- 
			<div class="form-group">
				<label class="control-label col-sm-2" for="category">분류</label>
				<div class="col-sm-2">
					<input id="qnaSort" name="qnaSort" class="form-control" value="${Gqna.qnaSort }">
				</div>
			</div>
		 --%>
			<div class="form-group">
				<label class="control-label col-sm-2" for="title">제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="qnaTitle" name="qnaTitle" placeholder="제목">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="pwd">내용</label>
				<div class="col-sm-8">
					<input class="form-control" id="qnaContent" name="qnaContent" placeholder="내용">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="pwd">첨부파일</label>
				<div class="col-sm-8">
					<input type="file" class="form-control" id="file" name="file">
				</div>
			</div>
			<br><br><br>
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
				
					<%-- <input type="hidden" name="_csrf" value="${_csrf.token}"> --%>
					<button id="qnaUpdate" type="button" class="btn btn-default">수정완료</button>
					<a href="/jnj/common/cQna/record" class="btn btn-default" id="cancelQnaWrite">취소</a>
				</div>
			</div>
			<br><br>
		</form>
		
		
	</div>
</body>
</html>