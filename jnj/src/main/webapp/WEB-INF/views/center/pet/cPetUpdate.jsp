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
		margin-top: 30px; 
		margin-bottom: 30px;
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
	var $pet = ${pet};
	$("#petNo").text($pet.petNo);
	$("#petNoH").val($pet.petNo);
	$("#petName").text($pet.petName);
	var petSort = "강아지";
	if($pet.petSort==2) petSort="고양이";
	else if($pet.petSort==3) petSort="기타";
	$("#petSort").text(petSort);
	$("#kind").val($pet.kind);
	var gender = "남자";
	if($pet.gender==2) gender="여자";
	$("#gender").text(gender);
	if($pet.neutral)
		$("#neutral").prop('checked', true);
	else
		$("#neutral").prop('checked', false);
	$("#age").val($pet.age);
	$("#weight").val($pet.weight);
	$("#mercyDate").text($pet.mercyDate);
	$("#disease").val($pet.disease);
	$("#feature").val($pet.feature);
	$("#writeDate").text($pet.writeDate);
	$('input:radio[name=petState]:input[value=' + $pet.petState + ']').attr("checked", true);	
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
	/*
	var cnt=1;
	$("#addImg").on("click",function(){
		cnt++;
		if( cnt > 5 ) {
			alert("사진은 5장을 넘을 수 없습니다");
			cnt--;
			return false;
	    }
		var imgF=$("#imgForm");
	    $("<input type=\"file\" class=\"form-control\" name=\"files\" multiple=\"multiple\">").appendTo(imgF);
	});*/
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
	<div class="container write">
		<h3>센터 유기동물 수정</h3>
		<hr/>
		<br>
		<form action="/jnj/center/pet/update" method="post" enctype="multipart/form-data">
			<label class="lb" for="text">동물번호</label>
			<span class="ip" id="petNo"></span>
			<input type="hidden" id="petNoH" name="petNo">
			<br>
			<label class="lb" for="text">이름</label>
			<span class="ip" id="petName"></span>
			<br>
			<label class="lb" for="text">분류</label>
			<span class="ip" id="petSort"></span>
			<br>
			<label class="lb" for="text">종류</label>
			<input type="text" class="ip" id="kind" name="kind">
			<br>
			<label class="lb" for="text">성별</label>
			<span class="ip" id="gender"></span>&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" id="neutral" name="neutral" value=true> 중성화 수술
			<br>
			<label class="lb" for="text">나이</label>
			<input type="text" class="ip" id="age" name="age" placeholder="동물의 (추정)나이를 입력하세요"> 세
			<br>
			<label class="lb" for="text">무게</label>
			<input type="text" class="ip" id="weight" name="weight" placeholder="동물의 체중(kg)을 입력하세요"> kg
			<br>
			<label class="lb" for="text">안락사 예정일</label>
			<span class="ip" id="mercyDate" name="mercyDate"></span>
			<br>
			<label id="dis" for="text">병력</label>
			<textarea id="disease" name="disease" placeholder="동물의 병력을 입력하세요"></textarea>
			<br>
			<label id="fea" for="text">특징</label>
			<textarea id="feature" name="feature" placeholder="동물의 특징이나 성격을 입력하세요"></textarea>
			<br>
			<label class="lb" for="text">등록일</label>
			<span class="ip" id="writeDate"></span>
			<br>
			<label class="lb" for="text">상태</label>
			<input type="radio" id="a" name="petState" value=1>대기 &nbsp;
			<input type="radio" id="b" name="petState" value=2>접수 &nbsp;
			<input type="radio" id="c" name="petState" value=3>진행 &nbsp;
			<input type="radio" id="d" name="petState" value=4>입양완료 &nbsp;
			<input type="radio" id="e" name="petState" value=5>안락사
			<!--
			<label class="lb" for="text" id="img">사진</label>
			<div id="imgDiv" style="display: inline-block;">
			<input type="file" name="files" multiple="multiple" style="display: inline-block;">
			<input type="button" value="사진추가" id="addImg" />
			</div> -->
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<input type="submit" id="update" class="btn btn-default" value="수정" style="float:right; margin-bottom: 50px; margin-right:400px;">
		</form>
	</div>
</body>
</html>