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
	
	var msgView = ${msgView};
	var href = $(location).attr("href");
	var sort = href.split('/')[6];
	
	var table = $(".msgview table");
	var tr1 = $("<tr></tr>").appendTo(table);
	$("<th></th>").attr("id", "msgId").appendTo(tr1);
	if(sort.match("send")) {
		$("#msgId").text("받을사람 ");
		$("<td></td>").text(msgView.receiverId).appendTo(tr1);	
	} else if(sort.match("receive")) {
		$("#msgId").text("보낸사람 ");
		$("<td></td>").text(msgView.senderId).appendTo(tr1);
		$("<button id='replymsg' type='button' class='btn btn-default'>답장</button>").appendTo("#msgbtn");
	}	
	var tr2 = $("<tr></tr>").appendTo(table);
	$("<th></th>").text("날짜 ").appendTo(tr2);
	$("<td></td>").text(msgView.sendDate).appendTo(tr2);
	
	$(".msgcon").text(msgView.content);
	
	
	
	$("#delmsg").on("click", function() {
		var form = $("<form></form>");
		var div = $("#delmsg").parent();
		 
		$("<input type='hidden' name='messageNo'>").attr("value", msgView.messageNo).appendTo(div);
		$("<input type='hidden' name='msgState'>").attr("value", msgView.msgState).appendTo(div);
		$("<input type='hidden' name='sort'>").attr("value", sort).appendTo(div);
		
		form.attr("method", "post");
		form.attr("action", "/jnj/general/message/delete");
		div.wrap(form);
		$("#delmsg").attr("type", "submit");
	})	
	
	$("#replymsg").on("click", function() {
		var reform = $("<form></form>").attr("action", "/jnj/general/message/write").attr("method", "post");
		$("<input type='hidden' name='receiverId'>").attr("value", msgView.senderId).appendTo("#msgbtn");
		$("#msgbtn").wrap(reform);
		$("#replymsg").attr("type", "submit");
	})
	
	$("#msg").on("click", function() {
		var msgform = $("<form></form>").attr("action", "/jnj/general/message/write").attr("method", "post");
		$("<input type='hidden' name='receiverId'>").attr("value","receiverId").appendTo("#writeM");	
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo("#writeM");	
		$("#writeM").wrap(msgform);
		$("#msg").attr("type", "submit");
	})
	
	$("#listM").on("click", function() {
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
.msgnav #msg {
	margin-left: 5px;
	height: 40px;
	width: 90px;
}
.msgnav h2 {
	margin-left: 10px;
}
.msgview th {
	width: 200px;
}
.msgview {
	margin-left: 150px;
}
#msgbtn {
	margin-left: 350px;
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
	<div class="container msgView">
		<br>
		<br>
		<div class="row col-sm-6 msgview">
			<table>
			</table>
			<hr/>
			<div class="msgcon">
			</div>
			<br><br><br><br>
			<div id="msgbtn">
				<button id="listM" type="button" class="btn btn-default">목록</button>
				<button id="delmsg" type="button" class="btn btn-default">삭제</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</div>
			<br><br>
		</div>
		
	</div>
</body>
</html>