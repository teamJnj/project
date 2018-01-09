<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script type="text/javascript">
	$(function () {
		
		$('#selectEmail').change(function(){ 
			$("#selectEmail option:selected").each(function () { 
				
				if($(this).val()== '1'){ //직접입력일 경우 
					$("#str_email02").val(''); //값 초기화 
					$("#str_email02").attr("disabled",false); //활성화 
				}else{ //직접입력이 아닐경우 
					$("#str_email02").val($(this).text()); //선택값 입력 
					$("#str_email02").attr("disabled",true); //비활성화 
					} 
			}); 
		});

		
		
		
		
		$("#checkId").on("click",function(){
					
					console.log("시작");
					if( $("#memberId").val() == null || $("#memberId").val() == "" ){
						console.log("아이디를 입력받지 않았다..");
						$("#text").text("아이디를 입력해주세요.");
						return;
					}
					$.ajax({
						
						url : "/jnj/check_id",
						type: "post",
						data: $("form").serialize()+ "&type=1"+ "&${_csrf.parameterName}=" + "${_csrf.token}",
						
						
						success: function(memberId) {
							console.log(memberId);
							if(memberId==true) {
								$("#text").text("아이디 사용 불가능");
							} else {
								$("#text").text("아이디 사용 가능");
								$("#join").prop("disabled", false);
							}
						}
						
						
					});
					
					
				});
		
		
		
		
		
		
		
		
		
		
		
		
		
		$("#checkEmail").on("click",function(){
			
			console.log("111 멜시작");
			if( $("#str_email01").val() == null || $("#str_email01").val() == "" || $("#str_email02").val() == 0 ){
				console.log("이메일을 입력받지 않았다..");
				$("#text1").text("이메일을 입력해주세요.");
				return;
			}
			//else{
				$.ajax({
					
					url : "/jnj/check_email",
					type: "post",
					data: $("form").serialize()+ "&type=1"+ "&${_csrf.parameterName}=" + "${_csrf.token}",
					
					
					success: function(email) {
						console.log(email);
						if(email==true) {
							$("#text1").text("이메일 사용 불가능");
						} else {
							$("#text1").text("이메일 사용 가능");
						}
					}
					
					
				});		
			//}
		});
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
				
	$("form").validate({
		
		// 검증 규칙 지정
		rules : {
			memberId : {
				required : true,
				minlength : 4,
				maxlength : 12
				
			},
			password : {
				required : true,
				minlength : 6,
				maxlength : 12
			},
			repassword : {
				required : true,
				minlength : 6,
				maxlength : 12,
				equalTo : password
			},
			memberName : {
				required : true,
				minlength : 2
			},
			email : {
				required : true,
				minlength : 5,
				email : true
			}
		},
		messages : {
			memberId : {
				required : "필수입력입니다",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			},
			password : {
				required : "필수입력입니다",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			},
			repassword : {
				required : "필수입력입니다",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다",
				equalTo : "비밀번호가 일치하지 않습니다"
			},
			memberName : {
				required : "필수입력입니다",
				minlength : "최소 {0}글자이상이어야 합니다"
			},
			email : {
				required : "필수입력입니다",
				minlength : "최소 {0}글자이상이어야 합니다",
				email : "이메일 형식에 어긋납니다"
			}
		}
	});
	
	
	
	
	
	/* $("#memberId").click(function(){
		$(":text").val('');
	}); */
	
	
	/* var memberId = $('#memberId');
	var memberIdtext = $('#text');
	memberId.focus(function(){
		memberId.val('');
		memberIdtext.text('');
	}); */
	
	
	/* var email = $('#email');
	var emailtext = $('#text1');
	email.focus(function(){
		email.val('');
		emailtext.text('');
	}); */
	
	
	$("#str_email01").click(function(){
		$(":text1").val('');
	})
	
	$("#memberId").click(function(){
		$(":text2").val('');
	})
	
	$("#memberName").click(function(){
		$(":text3").val('');
	});
	
	$("#password").click(function(){
		$("#password").val('');
	});
	 
	$("#repassword").click(function(){
		$("#repassword").val('');
	});
	
	
	/* $("#email").click(function(){
		$(":email").remove();
	}); */
	
	
	

});

</script>

<title>회원가입</title>
<style type="text/css">
	.lb {
		text-align: right;
		margin-bottom: 25px;
		margin-right: 20px;
		margin-left: 50px;
		width: 100px;
	}
	.ip {
		margin-bottom: 25px;
	}
	
/* * {
	text-align: center;
} */
table {
	width: 70%;
  height: 70%;
  margin: 40px auto;


}
</style>
</head>
<body>
<div class="container write" style="margin-top:0px;">
		<h3>회원가입 - 일반</h3>
		<hr/>
		<br>
	<form action="/jnj/join_member" method="post">
	<table>
		<tr>
			<td><label class="lb" for="text">아이디</label></td>
			<td><input type="text" class="ip" id="memberId" name="memberId" placeholder="아이디를 입력하세요"> <button type="button" id="checkId" class="btn btn-default">중복확인</button><br>
			</td>
			
		</tr>
		<tr>
			<td></td>
			<td><label class="error" for="memberId" generated="true" style="display:none; color: red;">error message</label><span id="text"></span></td>
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">이름</label></td>
			<td>
				<input type="text" class="ip" id="memberName" name="memberName" placeholder="이름을 입력하세요">
			</td>
			
		</tr>
		<tr>
			<td></td>
			<td><label class="error" for="memberName" generated="true" style="display:none; color: red;">error message</label></td>
		</tr>
		
		
		
		<tr>
			<td><label class="lb" for="text">비밀번호</label></td>
			<td>
				<input type="password" class="ip" id="password" name="password" placeholder="비밀번호를 입력하세요">
			</td>
			
		</tr>
		<tr>
			<td></td>
			<td><label class="error" for="password" generated="true" style="display:none; color: red;">error message</label></td>
		</tr>
		
		
		
		
		<tr>
			<td><label class="lb" for="text">비밀번호 확인</label></td>
			<td>
				<input type="password" class="ip" id="repassword" name="repassword" placeholder="비밀번호를 다시 입력하세요">
			</td>
			
		</tr>
		<tr>
			<td></td>
			<td>
				<label class="error" for="repassword" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		
		<tr>
			<td>
				<label class="lb" for="text">생년월일</label>
			</td>
			<td>
				<input type="date" class="ip" id="birthDate" name="birthDate">
			</td>
			
		</tr>
		
		
		<tr>
			<td>
				<label class="lb" for="text">이메일</label>
			</td>
			<td>
				<input type="text" name="str_email01" id="str_email01" style="width:100px"> 
				@ <input type="text" name="str_email02" id="str_email02" style="width:100px;" disabled>
				<select style="width:100px;margin-right:10px" name="selectEmail" id="selectEmail">
				<option value="기본값" selected>이메일 선택</option>
				<option value="naver.com">naver.com</option>
				<option value="hanmail.net">hanmail.net</option>
				<option value="daum.net">daum.net</option>
				<option value="gmail.com">gmail.com</option>	
				<option value="1">직접입력</option>	
				</select>
				<button type="button" id="checkEmail" class="btn btn-default">중복확인</button>
			</td>
			
		</tr>
		<tr>
			<td></td>
			<td>
				<span id="text1"></span>
			</td>
		</tr>
		
		<tr>
			<Td></Td>
			<td>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<input type="submit" id="join" disabled="disabled" value="가입" class="btn btn-default" style="float:right; margin-bottom: 80px; margin-right:400px;"><br>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>