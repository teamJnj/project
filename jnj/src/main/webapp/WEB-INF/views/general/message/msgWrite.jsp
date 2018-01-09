<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<script>
function checkMsg(){
	$.ajax({
		url:"/jnj/general/massage/msgcnt",
		type: "get",
		success: function(result){
			$("#msgcnt").text(result);
		}
	});
}

// 주소에 따라 보낸쪽지함 - 받은 쪽지함 구분
$(function() {
	checkMsg();
		
	var receiverId = ${receiverId};
	
	console.log(receiverId)
	if(receiverId!="receiverId") {
		$("#receiver").attr("value", receiverId);
	} 
	
	
	$("#msg").on("click", function() {
		var msgform = $("<form></form>").attr("action", "/jnj/general/message/write").attr("method", "post");
		$("<input type='hidden' name='receiverId'>").attr("value","receiverId").appendTo("#writeM");	
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo("#writeM");	
		$("#writeM").wrap(msgform);
		$("#msg").attr("type", "submit");
	})
	
	$("#write").on("click", function() {
		$.ajax({
			url: "/jnj/general/message/write/1",
			type: "post",
			data: $("#msgForm").serialize(),
			success: function(result) {
				if(!result)
					alert("존재하지 않는 아이디 입니다");
				else
					alert("쪽지를 성공적으로 보냈습니다");
					location.href="/jnj/general/message/send/record";
			}
		}) 
	})
	
	$("#cancleM").on("click", function() {
		location.href="/jnj/general/message/receive/record";
	})
})
</script>
<style>
#msgcnt {
	color: #7F5926; 
	font-size: 0.8em;
	font-weight: bold;
}
.msgWrite #content {
	height: 200px;
}
.msgWrite #write {
	margin-left: 400px;
}
.msgnav #msg {
	margin-left: 5px;
	height: 40px;
	width: 90px;
}
.msgnav h2 {
	margin-left: 10px;
}
</style>
</head>
<body>
	<div class="col-sm-2 sidenav hidden-xs msgnav">
		<h2>쪽지함</h2>
		<br>
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/jnj/general/message/receive/record">받은 쪽지함 <span id="msgcnt"></span></a></li>
			<li><a href="/jnj/general/message/send/record">보낸 쪽지함</a></li>				
		</ul>
		<br>
		<div id="writeM">
			<button id="msg" type="button" class="btn btn-default">쪽지쓰기</button>
		</div>
	</div>
	<div class="container msgWrite">
		<form class="form-horizontal row col-sm-9" id="msgForm">
			<br><br>
			<div class="form-group">
				<label class="control-label col-sm-3" for="title">제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="title" name="title" placeholder="제목">
				</div>
			</div>
			<div class="form-group">	
				<label class="control-label col-sm-3" for="receive">받는 사람</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="receiver" name="receiverId" placeholder="받는 사람">
				</div>
				<br><br><br>
				<label class="control-label col-sm-2" for="content"></label>
				<div class="col-sm-9">
					<textarea class="form-control" id="content" name="content" placeholder="내용"></textarea>
				</div>
			</div>
			<br>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<button id="write" type="button" class="btn btn-default">보내기</button>
			<button id="cancleM" type="button" class="btn btn-default">취소</button>
			<br><br>
		</form>
	</div>
</body>
</html>