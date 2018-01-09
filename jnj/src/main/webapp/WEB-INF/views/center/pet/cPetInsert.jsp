<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert Pet </title>
<style>
	/*
	form {
		text-align: center;
	}*/
	
	
	.write {
		margin-top: 100px; 
	}
	.write h3 {
		color: #7F5926;
	}
	 .write button {
      margin-left:380px;
      background-color: #FFB24C;
      color: #7F5926;
   }
	.write button:hover {
		background-color: #7F5926;
      color: #FFB24C;
	}
	.lb {
		text-align: right;
		margin-bottom: 25px;
		margin-right: 20px;
		margin-left: 50px;
		width: 100px;
	}
	#dis, #fea {
		text-align: right;
		float: left;
		margin-top: 40px;
		margin-right: 20px;
		margin-left: 50px;
		width: 100px;
	}
	.ip {
		margin-bottom: 25px;
	}
	#disease, #feature {
		width: 400px;
		height: 100px;
		margin-bottom: 25px;
	}
	#age, #weight {
		width: 60px;
	}
</style>
<script>
$(function() {
	/* $("form").validate({
		rules : {
			petName : {
				required : true
			},
			kind : {
				maxlength : 30
			},
			age : {
				required : true,
				number : true,
				maxlength : 2
			},
			weight : {
				required : true,
				number : true,
				maxlength : 3
			}
		},

		messages : {
			petName : {
				required : "유기동물의 이름을 입력해주세요"
			},
			kind : {
				maxlength : "종류는 {0}글자를 넘을 수 없습니다"
			},
			age : {
				required : "유기동물의 나이를 입력해주세요",
				number : "나이는 숫자만 입력 가능합니다",
				maxlength : "나이는 {0}자릿수를 넘을 수 없습니다"
			},
			weight : {
				required : "유기동물의 무게를 입력해주세요",
				number : "무게는 숫자만 입력 가능합니다",
				maxlength : "무게는 {0}자릿수를 넘을 수 없습니다"
			}
		}
	}); */
	var cnt=1;
	$("#addImg").on("click",function(){
		cnt++;
		if( cnt > 5 ) {
			alert("사진은 5장을 넘을 수 없습니다");
			cnt--;
			return false;
	    }
		var imgF=$("#imgDiv");
	    $("<br><input type='file' name='files' multiple='multiple' style=\"display: inline-block;\">").appendTo(imgF);
	});
});
</script>
</head>
<body>
<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" style="color: navy; font-weight: 700; font-size: 20px;">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign">회원탈퇴</a></h4>
	<hr>
	<div class="container write" style="margin-top:0px;">
		<h3>센터 유기동물 등록</h3>
		<hr/>
		<br>
		<form action="/jnj/center/pet/insert" method="post" enctype="multipart/form-data">
			<label class="lb" for="text">*이름</label>
			<input type="text" class="ip" id="petName" name="petName" placeholder="동물의 이름을 입력하세요">
			<br>
			<label class="lb" for="text">*분류</label>
			<input type="radio" id="dog" name="petSort" value=1>강아지 &nbsp;
			<input type="radio" id="cat" name="petSort" value=2>고양이 &nbsp;
			<input type="radio" id="etc" name="petSort" value=3>기타
			<br>
			<label class="lb" for="text">종류</label>
			<input type="text" class="ip" id="kind" name="kind" placeholder="동물의 종류를 입력하세요">
			<br>
			<label class="lb" for="text">*성별</label>
			<input type="radio" id="male" name="gender" value=1>남 &nbsp;
			<input type="radio" id="female" name="gender" value=2>여 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" id="neutral" name="neutral" value=true> 중성화 수술
			<br>
			<label class="lb" for="text">*나이</label>
			<input type="text" class="ip" id="age" name="age"> 세
			<br>
			<label class="lb" for="text">*무게</label>
			<input type="text" class="ip" id="weight" name="weight"> kg
			<br>
			<label class="lb" for="text">*안락사 예정일</label>
			<input type="date" class="ip" id="mercyDate" name="mercyDate">
			<br>
			<label class="lb" id="dis" for="text">병력</label>
			<textarea class="ip" id="disease" name="disease" placeholder="동물의 병력을 입력하세요"></textarea>
			<br>
			<label class="lb" id="fea" for="text">특징</label>
			<textarea class="ip" id="feature" name="feature" placeholder="동물의 특징이나 성격을 입력하세요"></textarea>
			<br>
			<label class="lb" for="text" id="img">*사진</label>
			<div id="imgDiv" style="display: inline-block;">
			<input type="file" name="files" multiple="multiple" style="display: inline-block;">
			<input type="button" value="사진추가" id="addImg" />
			</div>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<input type="submit" id="insert" class="btn btn-default" value="등록" style="float:right; margin-bottom: 50px; margin-right:400px;">
		</form>
	</div>
</body>
</html>