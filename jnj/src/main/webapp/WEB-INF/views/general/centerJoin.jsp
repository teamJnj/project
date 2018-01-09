<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

<script type="text/javascript">
	$(function() {
		
		var centerImgDiv = ("#centerImgDiv");
	
		$("#centerImgPlus").on("click", function(){
			$('<input type="file" id="centerImg" name="files" multiple="multiple">').appendTo(centerImgDiv);
		});
		
		
		
		
		
		
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
		
		
		
		
		$("#joinBtn").on( "click", function(){

			var addrStr = $("#addr1").val() + $("#addr2").val() + $("#addr3").val();
			var emailStr = $("#str_email01").val()+"@"+$("#str_email02").val();
			console.log( addrStr );
			console.log( emailStr );
			
			var frminfo = $("#frminfo");
			frminfo.empty();
			$("<input type='hidden' name='centerAddr' value='"+addrStr+"'>").appendTo(frminfo);
			$("<input type='hidden' name='email' value='"+emailStr+"'>").appendTo(frminfo);
			
			$("form").submit();
		});
		
		
		
		$("#checkId").on("click",function(){
			
			console.log("시작");
			if( $("#centerId").val() == null || $("#centerId").val() == "" ){
				console.log("아이디를 입력받지 않았다..");
				$("#text").text("아이디를 입력해주세요.");
				return;
			}
			
			$.ajax({
				
				url : "/jnj/check_id",
				type: "post",
				data: $("form").serialize()+ "&type=2"+"&${_csrf.parameterName}=" + "${_csrf.token}",
				
				
				success: function(centerId) {
					console.log(centerId);
					if(centerId==true) {
						$("#text").text("아이디 사용 불가능");
					} else {
						$("#text").text("아이디 사용 가능");
						$("#join").prop("disabled", false);
					}
				}
				
				
			});
			
			
		});

		
		
		
		$("#checkEmail").on("click",function(){
			
			console.log("멜시작");
			if( $("#str_email01").val() == null || $("#str_email01").val() == "" || $("#str_email02").val() == 0 ){
				console.log("이메일을 입력받지 않았다..");
				$("#text1").text("이메일을 입력해주세요.");
				return;
			}
			$.ajax({
				
				url : "/jnj/check_email",
				type: "post",
				data: $("form").serialize()+ "&type=2"+ "&${_csrf.parameterName}=" + "${_csrf.token}",
				
				
				success: function(email) {
					console.log(email);
					if(email==true) {
						$("#text1").text("이메일 사용 불가능");
					} else {
						$("#text1").text("이메일 사용 가능");
					}
				}
				
				
			});
			
			
		});
		
		
		
		
		
		
		
		
		$("form").validate({
			
			// 검증 규칙 지정
			rules : {
				centerId : {
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
				centerName : {
					required : true,
					minlength : 2
				},
				email : {
					required : true,
					minlength : 5,
					email : true
				},				
				centerTel : {
					required : true,
					digits : true,
					minlength : 10,
					maxlength : 11
				},
				centerAddr : {
					required : true
				}, 
				licensee : {
					required : true,
					minlength : 2
				},
				homepage : {
					url : true,
				},
				licenseNo  : {
					required : true,
					digits : true,
					minlength : 1
				},
				sponsorAccountNo : {
					required : true,
					digits : true,
					minlength : 1
				}
				
				
			},
			messages : {
				centerId : {
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
				centerName : {
					required : "필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다"
				},
				email : {
					required : "필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다",
					email : "이메일 형식에 어긋납니다"
				},
				centerTel : {
					required :"필수입력입니다",
					digits : "숫자만 입력해야 합니다",
					minlength : "최소 {0}글자이상이어야 합니다",
					maxlength : "최대 {0}글자이하이어야 합니다"
				},
				centerAddr :{
					required :"필수입력입니다"
				}, 
				licensee : {
					required :"필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다"
				},
				homepage : {
					url : "url 형식으로 입력해야 합니다 ex)http://www.naver.com"
				},
				licenseNo  : {
					required :"필수입력입니다",
					digits : "숫자만 입력해야 합니다",
					minlength : "최소 {0}글자이상이어야 합니다"
				},
				sponsorAccountNo : {
					required :"필수입력입니다",
					digits : "숫자만 입력해야 합니다",
					minlength : "최소 {0}글자이상이어야 합니다"
				}
				
				
			}
		});
	
	
	
	
		$("#centerId").click(function(){
			$("#centerId").val('');
		})
		
		$("#password").click(function(){
			$("#password").val('');
		})
		
		$("#repassword").click(function(){
			$("#repassword").val('');
		})
		
		$("#centerName").click(function(){
			$("#centerName").val('');
		})
		
		$("#centerTel").click(function(){
			$("#centerTel").val('');
		})
		
		$("#centerAddr").click(function(){
			$("#centerAddr").val('');
		})
		
		$("#licensee").click(function(){
			$("#licensee").val('');
		})
		
		$("#homepage").click(function(){
			$("#homepage").val('');
		})
		
		$("#str_email01").click(function(){
			$("#str_email01").val('');
		})
		
		$("#str_email02").click(function(){
			$("#str_email02").val('');
		})
		
		$("#licenseNo").click(function(){
			$("#licenseNo").val('');
		})
	
	
	
		
		// 주소 api 버튼 이벤트
		$("#zipcode").on("click", function() {
		  sample6_execDaumPostcode();
		})
		
		
		$("#joinCenter").on("click",function(){
			console.log( )
			
		});
	
	});
	
	
	// 주소 api
	function sample6_execDaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var fullAddr = ''; // 최종 주소 변수
	                var extraAddr = ''; // 조합형 주소 변수

	                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    fullAddr = data.roadAddress;

	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    fullAddr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	                if(data.userSelectedType === 'R'){
	                    //법정동명이 있을 경우 추가한다.
	                    if(data.bname !== ''){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있을 경우 추가한다.
	                    if(data.buildingName !== ''){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('addr1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('addr2').value = fullAddr;

	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById('addr3').focus();
	            }
	        }).open();
	    }
</script>

<title>회원가입 - 센터</title>
<style type="text/css">
th {
	text-align: left;
	padding-right: 20px;
	font-size: 1.5em;
}
table {
	width: 50%;
  height: 50%;
  margin: 40px auto;
}
</style>

</head>
<body>


	<form action="/jnj/join_center" method="post" enctype="multipart/form-data">
	
		<table>
		
			<tr>
				<td><label>아이디</label></td>
				<td>
					<input type="text" class="btn btn-default" id="centerId" name="centerId" placeholder="아이디">
					<button type="button" id="checkId" class="btn btn-default">중복확인</button>
				</td>
			</tr>
			
			<tr>
				<td>
				</td>
				<td>
					<label class="error" for="centerId" generated="true" style="display:none; color: red;">error message</label>
					<p id="text"></p>
				</td>
			</tr>
			
			<tr>
				<td><label>비밀번호</label></td>
				<td>
					<input type="text" class="btn btn-default" id="password" name="password" placeholder="비밀번호">
				</td>
			</tr>
			
			<tr>
				<td><label>비밀번호 확인</label></td>
				<td>
					<input type="text" class="btn btn-default" id="repassword" name="repassword" placeholder="비밀번호 확인">
				</td>
			</tr>
			
			<tr>
				<td><label>센터명</label></td>
				<td>
					<input type="text" class="btn btn-default" id="centerName" name="centerName" placeholder="센터명">
				</td>
			</tr>
			
			<tr>
				<td><label class="lb" for="text">주소</label></td>
				<td>
					<input type="text"  class="btn btn-default" id="addr1" name="addr1" placeholder="우편번호" readonly="readonly">
					<button class="btn btn-default" type="button" id="zipcode">주소검색</button>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="text" class="btn btn-default" id="addr2" name="addr2" placeholder="주소" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type="text" class="btn btn-default"  id="addr3" name="addr3" placeholder="나머지주소">
				</td>
			</tr>
			
			
			<tr>
				<td><label>전화번호</label></td>
				<td>
					<input type="text" class="btn btn-default" id="centerTel" name="centerTel" placeholder="전화번호">
				</td>
			</tr>
			
			
			
			
			
			<tr>
				<td><label class="lb" for="text">대표자</label></td>
				<td>
					<input type="text" class="btn btn-default" id="licensee" name="licensee" placeholder="이름을 입력해 주세요">
				</td>
			</tr>
			
			<tr>
				<td><label class="lb" for="text">홈페이지</label></td>
				<td>
					<input type="text" class="btn btn-default" id="homepage" name="homepage" placeholder="홈페이지">
				</td>
			</tr>
			
			
			
			
			<tr>
				<td><label class="lb" for="text">이메일</label></td>
				<td>
					<input type="text" class="btn btn-default" name="str_email01" id="str_email01" style="width:100px"> @
					<input type="text" class="btn btn-default" name="str_email02" id="str_email02" style="width:100px;" disabled>
					
					<select style="width:100px;margin-right:10px" name="selectEmail" id="selectEmail" class="btn btn-default">
						<option value="기본값" class="btn btn-default" selected>이메일 선택</option>
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
				<td>
				</td>
				<td>
					<p id="text1"></p>
				</td>
			</tr>
			
			<tr>
				<td><label class="lb" for="text">사업자등록번호</label></td>
				<td>
					<input type="text" class="btn btn-default" name="licenseNo" id="licenseNo"  placeholder="사업자등록번호">
				</td>
			</tr>
		
		
			<tr>
				<td><label class="lb" for="text">은행선택</label></td>
				<td>
					<select id="sponsorAccountBank" class="btn btn-default" name="sponsorAccountBank">
						<option value="신한">신한</option>
						<option value="국민">국민</option>
						<option value="농협">농협</option>
						<option value="기업">기업</option>
					</select>
				</td>
				
			</tr>
		
		
			<tr>
				<td><label class="lb" for="text">후원금 계좌번호</label></td>
				<td>
					<input type="text" class="btn btn-default" id="sponsorAccountNo" name="sponsorAccountNo"  placeholder="계좌번호">
				</td>
			</tr>
		
		
			<tr>
				<td><label class="lb" for="text">예금주</label></td>
				<td>
					<input type="text" class="btn btn-default" id="sponsorAccountHolder" name="sponsorAccountHolder " placeholder="예금주">
				</td>
			</tr>
		
		
			<tr>
				<td><label class="lb" for="text">사업자등록증 사본</label></td>
				<td>
					<input class="btn btn-default" type="file" id="licenseImg" name="files" multiple="multiple">
				</td>
			</tr>
		
		
			<tr>
				<td><label class="lb" for="text">후원금통장 사본</label></td>
				<td>
					<input class="btn btn-default" type="file" id="sponsorAccountImg" name="files" multiple="multiple">
				</td>
			</tr>
		
		
			<tr>
				<td><label class="lb" for="text">센터 대표 사진</label></td>
				<td >
					<input class="btn btn-default" type="file" id="centerImg" name="files" multiple="multiple"><button type="button" class="btn btn-default" id="centerImgPlus">센터 대표 사진 추가</button>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</td>
			</tr>
			
		</table>
		<div id="frminfo">
		</div>		
		<button type="button" id="joinBtn" class="btn btn-default">가입</button><Br><br>
	</form>












	<%-- <form action="/jnj/join_center" method="post" enctype="multipart/form-data">
	<table>
		<article class="container">
			<h1>
				회원가입 <small>센터</small>
			</h1>


		<tr>
			<td><label class="lb" for="text">아이디</label></td>
			<td><input type="text" class="btn btn-default" id="centerId" name="centerId" placeholder="아이디"><button type="button" id="checkId" class="btn btn-default">중복확인</button><br>
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="centerId" generated="true" style="display:none; color: red;">error message</label>
				<p id="text"></p>
			</td>
		</tr>
		
		
		
		
		
		<tr>
			<td><label class="lb" for="text">비밀번호</label></td>
			<td>
				<input type="password" class="btn btn-default" id="password" name="password"	name="password" id="password" placeholder="비밀번호">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="password" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">비밀번호 확인</label></td>
			<td>
				<input type="password" class="btn btn-default" name="repassword" id="repassword" placeholder="비밀번호 확인">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="repassword" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		
		
		
		<tr>
			<td><label class="lb" for="text">센터명</label></td>
			<td>
				<input type="text" class="btn btn-default" name="centerName" id="centerName" placeholder="센터명">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="centerName" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">전화번호</label></td>
			<td>
				<input type="text" class="btn btn-default" name="centerTel" id="centerTel" placeholder="전화번호">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="centerTel" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		
		<tr>
			<td><label class="lb" for="text">주소</label></td>
			<td>
				<input type="text"  class="btn btn-default" id="addr1" name="addr1" placeholder="우편번호" readonly="readonly">
				<button class="btn btn-default" type="button" id="zipcode">주소검색</button>
			</td>
			<td>
			</td>
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="centerTel" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		<tr>
			<td></td>
			<td>
				<input type="text" class="btn btn-default" id="addr2" name="addr2" placeholder="주소" readonly="readonly">
			</td>
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="centerTel" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		<tr>
			<td></td>
			<td>
				<input type="text" class="btn btn-default  id="addr3" name="addr3" placeholder="나머지주소">
			</td>
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="centerTel" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		
		<tr>
			<td><label class="lb" for="text">대표자</label></td>
			<td>
				<input type="text" class="btn btn-default" id="licensee" name="licensee" placeholder="이름을 입력해 주세요">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="licensee" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>		
		
		
		
		<tr>
			<td><label class="lb" for="text">홈페이지</label></td>
			<td>
				<input type="url" class="btn btn-default" id="homepage" name="homepage"  placeholder="http://www.aaaaaa.bbbb">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="homepage" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		
		
		
		<tr>
			<td><label class="lb" for="text">이메일</label></td>
			<td>
				<input type="text" class="btn btn-default" name="str_email01" id="str_email01" style="width:100px"> 
			@ <input type="text" class="btn btn-default" name="str_email02" id="str_email02" style="width:100px;" disabled>
			<select style="width:100px;margin-right:10px" name="selectEmail" id="selectEmail" class="btn btn-default">
			<option value="기본값" class="btn btn-default" selected>이메일 선택</option>
			<option value="naver.com">naver.com</option>
			<option value="hanmail.net">hanmail.net</option>
			<option value="daum.net">daum.net</option>
			<option value="gmail.com">gmail.com</option>	
			<option value="1">직접입력</option>	
			</select><button type="button" id="checkEmail" class="btn btn-default">중복확인</button>
			
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<p id="text1"></p>
			</td>
		</tr>
		
		
		
		<tr>
			<td><label class="lb" for="text">사업자등록번호</label></td>
			<td>
				<input type="text" class="btn btn-default" name="licenseNo" id="licenseNo"  placeholder="사업자등록번호">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="licenseNo" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		<br>
				
		
		<tr>
			<td><label class="lb" for="text">은행선택</label></td>
			<td>
				<select id="sponsorAccountBank" class="btn btn-default" name="sponsorAccountBank">
				<option value="신한">신한</option>
					<option value="국민">국민</option>
					<option value="농협">농협</option>
					<option value="기업">기업</option>
				</select>
			</td>
			
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">후원금 계좌번호</label></td>
			<td>
				<input type="text" class="btn btn-default" id="sponsorAccountNo" name="sponsorAccountNo"  placeholder="계좌번호">
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="sponsorAccoutNo" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		
		<tr>
			<td><label class="lb" for="text">예금주</label></td>
			<td>
				<input type="text" class="btn btn-default" id="sponsorAccountHolder" name="sponsorAccountHolder " placeholder="예금주">
				
			</td>
			
		</tr>
		
		<tr>
			<td>
			</td>
			<td>
				<label class="error" for="sponsorAccountHolder" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">사업자등록증 사본</label></td>
			<td>
				<input class="btn btn-default" type="file" id="licenseImg" name="files" multiple="multiple">
			</td>
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">후원금통장 사본</label></td>
			<td>
				<input class="btn btn-default" type="file" id="sponsorAccountImg" name="files" multiple="multiple">
			</td>
		</tr>
		
		
		<tr>
			<td><label class="lb" for="text">센터 대표 사진</label></td>
			<td >
				<input class="btn btn-default" type="file" id="centerImg" name="files" multiple="multiple"><button type="button" class="btn btn-default" id="centerImgPlus">센터 대표 사진 추가</button>
			</td>
		</tr>
			<td></td>
			<td id="centerImgDiv">
			</td>
		<tr>
		
		</tr>

			<!-- <input type="submit" id="join" disabled="disabled" value="가입"> -->

		<hr>
		
		
		<tr>
			<td></td>
			<td>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button type="button" id="btn" class="btn btn-default">가입</button><Br><br>
			</td>
		</tr>
		</article>
	</table>
	</form> --%>
</body>
</html>