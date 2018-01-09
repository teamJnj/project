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
		// 상단 메뉴바
		$.ajax({
			url:"/jnj/username",
			type:"get",
			data:$("form").serialize(),
			success:function(principal){
				console.log(principal);
				$("#minfo").attr("href", "/jnj/member/info?memberId="+principal);
				$("#msponsor").attr("href", "/jnj/member/sponsor/record?memberId="+principal);
				$("#madopt").attr("href", "/jnj/member/adopt/record?memberId="+principal);
				$("#mvolunteer").attr("href", "/jnj/member/volunteer/record?memberId="+principal);
				$("#mmarket").attr("href", "/jnj/member/market/record?memberId="+principal);
				$("#mstore").attr("href", "/jnj/member/store/record?orderId="+principal);
				$("#mqna").attr("href", "/jnj/common/qna/record?writeId="+principal);
				$("#mresign").attr("href", "/jnj/member/resign?memberId="+principal);
			}
		});
		
		
		var $map = ${map};
		var $qnaList = $map.qnaList;
		var $pagination = $map.pagination;
		var $answerContent = $qnaList.answerContent;
		var $qnaSort = $qnaList.qnaSort;
		
		console.log($qnaList);
		console.log($map);
		
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
						
						
						var $link = $("<a>").attr("href", "/jnj/common/qna/view?writeId="+$qna.writeId+"&qnaNo="+$qna.qnaNo );
						$title.wrapInner($link);
					})
		//}
		
		$("#write").on("click", function() {
			location.href = "/jnj/common/qna/write1";
		})
		
		
		
		
		var ul = $("#pagination");
		var li;
		if($pagination.prev>0) {
			li = $("<li></li>").text('<').appendTo(ul);
			li.wrapInner($("<a></a").attr('href', '/jnj/common/qna/record?writeId='+$qnaList[0].writeId+'&pageno='+ $pagination.prev))
		}
		for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
			li = $("<li></li>").text(i).appendTo(ul);
			if($pagination.pageno==i) 
				li.wrapInner($("<a></a").attr('href', '/jnj/common/qna/record?writeId='+$qnaList[0].writeId+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
			else
				li.wrapInner($("<a></a").attr('href', '/jnj/common/qna/record?writeId='+$qnaList[0].writeId+'&pageno='+ i))
		}
		if($pagination.next>0) {
			li = $("<li></li>").text('>').appendTo(ul);
			li.wrapInner($("<a></a").attr('href', '/jnj/common/qna/record?writeId='+$qnaList[0].writeId+'&pageno='+ $pagination.next));
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
	<a id="minfo">개인정보수정</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="msponsor">후원내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="madopt">입양내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mvolunteer">봉사내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mmarket">프리마켓내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mstore">구매내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mqna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mresign">회원탈퇴</a></h4>
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