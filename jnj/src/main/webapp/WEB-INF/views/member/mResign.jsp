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
.mResign {
	margin-top: 30px;
}

.mResign h3 {
	color: #7F5926;
}
.mResign h2{
text-align: center;
}

.mResign button {
	
	background-color: #FFB24C;
	color: #7F5926;
}

.mResign button:hover {
	background-color: #7F5926;
	color: #FFB24C;
}
.mResign #resign {
margin: 0;
float: none;
margin-left:43%;
}
</style>
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
	
	$("#resign").on("click", function() {
		var form = $(".mResign form");
		form.attr("action", "/jnj/member/resign/1");
		$("#resign").attr("type", "submit");
	})
	
	$("#cancle").on("click", function() {
		var form = $(".mResign form");
		form.attr("action", "/jnj/member/resign/2");
		$("#cancle").attr("type", "submit");
	})
})
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
	<div class="container mResign">
		<h3>일반 회원 탈퇴</h3>
		<hr/>
		<h2>비밀번호를 입력해주세요!</h2>
		<br>
		<form class="form-horizontal" method="post">
			<div class="form-group">
				<label class="control-label col-sm-4" for="pwd">비밀번호</label>
				<div class="col-sm-4">
					<input type="password" class="form-control" id="password" name="password" placeholder="비밀번호를 입력해주세요!">
					<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />
				</div>
			</div>
			<br>
			<br>
			<br>
			<div class="form-group">
				<button id="resign" type="button" class="btn btn-default">탈퇴하기</button>
				<button id="cancle" type="button" class="btn btn-default">취소</button>
			</div>
			<br>
			<br>
			<br>
		</form>
	</div>

</body>
</html>