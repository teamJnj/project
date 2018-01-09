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
	$(function() {
		
		var $map = ${map};
		var $qnaList = $map.qnaList;
		var $pagination = $map.pagination;
		var $answerContent = $qnaList.answerContent;
		var $qnaSort = $qnaList.qnaSort;
		
		var $cState = ${cState};
		var $isFirst = ${isFirst};
		
		if($cState==0||$cState==2||$cState==3) {
			$(".normalState").attr("href", "#");
			if($cState==0||$cState==2)
				$(".normalStateH").attr("href", "#");
		}
		
		if($isFirst=="first") {
			if($cState==0)
				alert("블락상태인 회원은 [1:1문의]메뉴만 이용 가능합니다.");
			else if($cState==2)
				alert("가입승인 대기 중인 회원은 [1:1문의]메뉴만 이용 가능합니다.");
			else if($cState==3)
				alert("탈퇴승인 대기 중인 회원은 [입양관리], [후원관리], [1:1문의]메뉴만 이용 가능합니다.");
		}
			
		
		console.log($qnaList);
		
		var $table = $("table");
		$table.empty();
		$table.append('<colgroup width="15%"/><colgroup width="40%"/><colgroup width="15%"/><colgroup width="15%"/><colgroup width="15%"/><thead><tr id="tableTrStyle"><th class="th">분류</th><th class="th">제목</th><th class="th">작성자</th><th class="th">날짜</th><th class="th">처리상태</th></tr></thead>');
		//for(var i=0 ; i< $qnaList.length ; i++){
			$.each($qnaList,
					function(i, $qna) {
						var $tbody = $("<tbody></tbody>").appendTo($table)
						var $tr = $("<tr></tr>").appendTo($tbody);
						
						
						if($qna.qnaSort==1){
							$("<div></div>").attr("id","qnaSort").text("후원").appendTo($tr);
						} else if($qna.qnaSort==2){
							$("<div></div>").attr("id","qnaSort").text("입양").appendTo($tr);
						} else if($qna.qnaSort==3){
							$("<div></div>").attr("id","qnaSort").text("봉사").appendTo($tr);
						} else if($qna.qnaSort==4){
							$("<div></div>").attr("id","qnaSort").text("프리마켓").appendTo($tr);
						} else if($qna.qnaSort==5){
							$("<div></div>").attr("id","qnaSort").text("스토어").appendTo($tr);
						} else if($qna.qnaSort==6){
							$("<div></div>").attr("id","qnaSort").text("게시판").appendTo($tr);
						} else if($qna.qnaSort==7){
							$("<div></div>").attr("id","qnaSort").text("기타").appendTo($tr);
						}
						
						var $title = $("<td></td>").text($qna.qnaTitle).appendTo($tr);
						$("<td></td>").text($qna.writeId).appendTo($tr);
						$("<td></td>").text($qna.writeDate).appendTo($tr);
						
						if($qna.answerContent!=null){
							$("<td></td>").attr("id","answerContent").text("처리완료").appendTo($tr);
						} else{
							$("<td></td>").attr("id","answerContent").text("처리중").appendTo($tr);
						}
						
						
						var $link = $("<a>").attr("href", "/jnj/common/cQna/view?writeId="+$qna.writeId+"&qnaNo="+$qna.qnaNo );
						$title.wrapInner($link);
					})
		//}
		
		$("#write").on("click", function() {
			location.href = "/jnj/common/cQna/write1";
		})
		
		
		
		
		var ul = $("#pagination");
		var li;
		if($pagination.prev>0) {
			li = $("<li></li>").text('<').appendTo(ul);
			li.wrapInner($("<a></a").attr('href', '/jnj/common/cQna/record?writeId='+$qnaList[0].writeId+'&pageno='+ $pagination.prev))
		}
		for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
			li = $("<li></li>").text(i).appendTo(ul);
			if($pagination.pageno==i) 
				li.wrapInner($("<a></a").attr('href', '/jnj/common/cQna/record?writeId='+$qnaList[0].writeId+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
			else
				li.wrapInner($("<a></a").attr('href', '/jnj/common/cQna/record?writeId='+$qnaList[0].writeId+'&pageno='+ i))
		}
		if($pagination.next>0) {
			li = $("<li></li>").text('>').appendTo(ul);
			li.wrapInner($("<a></a").attr('href', '/jnj/common/cQna/record?writeId='+$qnaList[0].writeId+'&pageno='+ $pagination.next));
		}
	})
</script>

<style>
	.qnaList button {
		margin-left: 48%;
		background-color: #FFB24C;
		color: #7F5926;
	}
	.qnaList button:hover {
		background-color: #7F5926;
		color: #FFB24C;
	}
	.qnaList h3 {
		color: #7F5926;
	}
	.qnaList thead:first-of-type {
		background-color: #FFB24C;
	}
	th.th , tbody {
		text-align: center;
	}
	.qnaList .table {
		margin-top: 30px;
	}
</style>
<script>
</script>
</head>
<body>

	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info" class="normalState">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" class="normalState">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt" class="normalStateH">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor" class="normalStateH">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer" class="normalState">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna/record" style="color: navy; font-weight: 700; font-size: 20px;">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign" class="normalState">회원탈퇴</a></h4>
	<hr>


	<div class="container qnaList">
		<h3>1:1문의</h3>
		<hr/>
		<table class="table">
			<!--
			<colgroup width="15%"/><colgroup width="40%"/><colgroup width="15%"/><colgroup width="15%"/><colgroup width="15%"/>
			<colgroup width="40%"/>
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			<colgroup width="15%"/>
			
			<thead>
				<tr>
					<th>분류</th>
					<th>제목</th>
					<th>작성자</th>
					<th>날짜</th>
					<th>처리 상태</th>
				</tr>
			 -->	
			</thead>
			<tbody>
			<!-- 
				<tr>
					<td>스토어</td>
					<td><a href="#">환불해주세요</a></td>
					<td>***</td>
					<td>2017-11-18</td>
					<td>처리중</td>
				</tr>
 			-->
			</tbody>
		</table>
		<br><br>
		<div class="form-group">
			<button id="write" type="submit" class="btn btn-default">문의하기</button>
		</div>
		
		
		
		
		<br>
		<div class="container">
			<ul class="pager" id="pagination">
			</ul>
		</div>
		<br><br><br>
	</div>
</body>
</html>