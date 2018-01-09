<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
function checkMsg(){
	$.ajax({
		url:"/jnj/general/massage/msgcnt",
		type: "get",
		success: function(result){
			$("#target").text(result+"건의 읽지 않은 쪽지가 있습니다");
		}
	});
}
$(function() {
	checkMsg();
	setInterval(checkMsg, 10000);
})
</script>
<style>
#msgcheck {
	background-color: #F2F2F2;
	text-align: center;
	width: 300px;
	height: 30px;
	line-height: 30px;
	margin-left: 15%;
}
</style>
</head>
<body>
<div id="msgcheck">
	<p id="target"></p>
</div>
</body>
</html>