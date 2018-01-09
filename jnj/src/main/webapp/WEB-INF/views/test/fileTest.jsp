<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
</head>
<body>

	<form action="/jnj/file_upload" method="post" enctype="multipart/form-data">
		
		첨부파일:<br>
		<input type="hidden" name="_csrf" value="${_csrf.token}">
		<input type="file" name="files" multiple="multiple">
		<input type="file" name="files" multiple="multiple">
		<input type="file" name="files" multiple="multiple">
		<button>작성</button>
	
	</form>

	

</body>
</html>