<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
.memberAdoptionList {
margin-top: 30px;
}
#tableTrStyle {
	background-color: #FFB24C;
}

th {
	text-align: center;
}

.table {
	text-align: center;
}
h3{
color: #7F5926;
}
 #button1 {
  
      background-color: #FFB24C;
      color: #7F5926;
   }

#button1:hover{
background-color: #7F5926;
      color: #FFB24C;
}
</style>
<script>
$(function(){
	
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
	console.log($map);
	
	var $myAdoptList = $map.getMypageMemberAdopt;
	console.log($myAdoptList);
	var $pagination = $map.pagination;
	console.log($pagination);
	
	var $memberId = $map.memberId;
	console.log($memberId);
	
	var $table = $("#memberAdoptListTable")
	$("<tr><th>센터명</th><th>이름</th><th>신청날짜</th><th>상태</th><th>기타</th></tr>").appendTo($table).css("background","#FFB24C");

	$.each($myAdoptList, function(idx, $myAdopt){
		var $tr =$("<tr></tr>").appendTo($table);
		$("<td></td>").text($myAdopt.CENTERNAME).appendTo($tr);
		$("<td></td>").text($myAdopt.PETNAME).appendTo($tr);
		$("<td></td>").text($myAdopt.ADOPTAPPLYDATE).appendTo($tr);
		var petState = "대기";
		console.log($myAdopt.CANCLE);
		console.log($myAdopt.PETSTATE);
		if($myAdopt.CANCLE==1) petState="입양취소"
		else if($myAdopt.PETSTATE==2) petState="입양접수";
		else if($myAdopt.PETSTATE==3) petState="입양진행";
		else if($myAdopt.PETSTATE==4) petState="입양완료";
		$("<td></td>").text(petState).appendTo($tr);
		var $petNo = $("<td></td>").text('상세보기').appendTo($tr);
		var $link = $("<a></a>").attr("href","/jnj/menu/adopt/view?petNo="+$myAdopt.PETNO);
		//입양상세보기 경로 다시 확인하기 12월 14일
		$petNo.wrapInner($link);
	
	})
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/member/mAdoptionList?memberId='+$memberId+'&pageno='+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/member/mAdoptionList?memberId='+$memberId+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/member/mAdoptionList?memberId='+$memberId+'&pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/member/mAdoptionList?memberId='+$memberId+'&pageno='+ $pagination.next));
	}
	
});


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
	<div class="container memberAdoptionList">
		<h3>입양내역</h3>
		<hr>
		<table class="table" id="memberAdoptListTable">
			
		</table>

		<div class="container2">
			<ul class="pager" id="pagination">
				
			</ul>
		</div>
	</div>

</body>
</html>