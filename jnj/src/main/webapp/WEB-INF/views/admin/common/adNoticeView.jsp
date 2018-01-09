<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<title>Insert title here</title>
<style>
.noticeView {
	margin-top: 100px;
	
}
#noticeTitle, #writeDate, #hits, #title, #admin{
	text-align: center;
}

.noticeView h3{
	color: #7F5926;
}
.noticeView h4{
	color: #7F5926;
}


.contentTd {
	border-left: 1px solid #7F5926;
	padding-left: 20px;
	border-bottom: 1px solid #fff;
}

.contentTh {
	text-align: left;
	padding: 10px 0px 10px 0px;
	width: 120px;
	border-bottom: 1px solid #fff;
}

.table {
	
	
}
#view{
	margin-left: 30%;
	margin-top: 5%;
}
#request, #noticeUpdate, #noticeApplyDelete, #noticeDelete, #noticeList{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	margin-left:450px;
		
}
.th, .td {
	text-align: center;
}
</style>
<script>




$(function() {
	//var noticeNo = "${noticeNo}";
	var $map = ${requestScope.map};
	var $notice = $map.notice;
	
	console.log($notice);
	
	
	/* var $btnNotice = $("#btnNotice");	
	if($name=="admin"){
		$("<button type='button'></button>").attr("id","noticeUpdate").attr("class","btn btn-default").text("글수정").appendTo($btnNotice);
	 	$("<button type='button'></button>").attr("id","noticeDelete").attr("class","btn btn-default").text("글삭제").appendTo($btnNotice);
	} */ 
	
	
	// 공지사항
	$("#noticeNo").text($notice.noticeNo);
	$("#title").text($notice.title);
	$("#writeDate").text($notice.writeDate);
	$("#hits").text($notice.hits);
	$("#content").text($notice.content);
	
	
	
			
			
			
			// 목록으로 리스트 화면
			$("#noticeList").on("click",function(){
				self.close();
			});
			
			
			
	
});
</script>
</head>
<body>
	<div class="container noticeView">
		<h3>공지사항</h3>
		<hr />
		<form class="form-horizontal"  method="post">
			<div class="form-group">
				<label class="control-label col-sm-1" for="category">제목</label>
				<span id="title"class="control-label col-sm-8"></span> 
				<label class="control-label col-sm-1" for="writedate">작성일</label> 
				<span id="writeDate" class="control-label col-sm-2"></span>
			</div>
			<hr />
			<div class="form-group">
				<label class="control-label col-sm-1" for="writer">작성자</label> 
				<span id="admin" class="control-label col-sm-6">관리자</span> 
				<label class="control-label col-sm-2"></label>  
				<label class="control-label col-sm-1" for="title">조회</label>
				<span id="hits"class="control-label col-sm-1"></span>  
			</div>
			<hr />
			<span id="content"></span>
			
			
			
			<div class="container">
				<table class="table" id="view">
				</table>
			
			</div><br>
			<br>
			<div id=btnNotice></div>
			<button id="noticeList" type="button" class="btn btn-default">닫기</button>
		<br><br><br><br><br><br>
		</form>
	</div>
</body>
</html>