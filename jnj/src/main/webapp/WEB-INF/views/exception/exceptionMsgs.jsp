<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
var msgs = ${msgs};
$(function() {
	$.each(msgs, function(idx, msg) {
		var li = $("<li></li>").appendTo($("ul"));
		li.text(msg);
	});
});
</script>
<title>Insert title here</title>
</head>
	<ul>
	</ul>
<body>
</body>
</html>