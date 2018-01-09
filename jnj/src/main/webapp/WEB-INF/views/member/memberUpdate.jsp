<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
	.write {
		margin-top: 30px; 
	}
	.write h3 {
		color: #7F5926;
	}
	 .write #update {
      margin-left:380px;
      background-color: #FFB24C;
      color: #7F5926;
   }
	.write #update:hover {
		background-color: #7F5926;
      color: #FFB24C;
	}
</style>
<script>
$(function() {
	// 상단 메뉴
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
	
   
var $member = ${member};
   
   $("#memberId").val($member.memberId);
   $("#memberName").val($member.memberName);
   $("#email").val($member.email);
   $("#birth").val($member.birthDate);
   console.log($member.memberId);
   console.log($member.memberName);
   console.log($member.email);
   console.log($member.birthDate);
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
	<div class="container write">
		<h3>개인정보수정</h3>
		<hr/>
		<form class="form-horizontal" action="/jnj/member/info" method="post" >
			 <div class="form-group">
				<label class="control-label col-sm-4" for="text">아이디</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="memberId" name="memberId" readonly="readonly">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">이름</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="memberName" name="memberName" readonly="readonly">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="pwd">비밀번호</label>
				<div class="col-sm-5">
					<input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호를 입력해주세요!">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="pwd">비밀번호 확인</label>
				<div class="col-sm-5">
					<input type="password" class="form-control" id="pwdCheck" name="password" placeholder="다시 한 번 비밀번호를 입력해주세요!">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">이메일</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="email" name="email" readonly="readonly">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">생년월일</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="birth" name="birth" readonly="readonly">
				</div>
			</div>
			
			<br><br><br>
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
						<input type="hidden" name="_csrf" value="${_csrf.token}">
						<input type="submit" id="update" class="btn btn-default" value="수정하기"> 
				</div>
			</div>
		</form> 
	</div>
</body>
</html>