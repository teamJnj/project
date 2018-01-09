<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<style>
.update {
	margin-top: 30px;
}

.update h3 {
	color: #7F5926;
}
#update {
	width: 150px;
	margin-left: 420px;
	margin-right: 10px;
}
#cancel {
	width: 150px;
}
#minPeople, #maxPeople{
	display: inline-block;
	width: 100px;
}

</style>
<script>
$(function() {
		var $volunteer = ${volunteer};
		$("#volunteerNo").val($volunteer.volunteerNo);
		$("#volunteerTitle").val($volunteer.volunteerTitle);
		$("#volunteerContent").val($volunteer.volunteerContent);
		$("#volunteerAddr").val($volunteer.volunteerAddr);
		$("#volunteerDate").val($volunteer.volunteerDate);
		$("#applyEndDate").val($volunteer.applyEndDate);
		$("#ageLimit").val($volunteer.ageLimit);
		$("#minPeople").val($volunteer.minPeople);
		$("#maxPeople").val($volunteer.maxPeople);
		$("#hostTel").val($volunteer.hostTel);
		$("#addr1").val($volunteer.addr1);
		$("#addr2").val($volunteer.addr2);
		$("#addr3").val($volunteer.addr3);
		$("#tel2").val($volunteer.tel2);
	console.log($volunteer);
	
		
	$("#update").on("click", function() {
		$("<input type='hidden' name='hostTel' value='"+$("#tel1 option:selected").val()+$("#tel2").val()+"'>").appendTo("form");
		$("<input type='hidden' name='volunteerAddr' value='("+$("#addr1").val()+")"+$("#addr2").val()+", "+$("#addr3").val()+"'>").appendTo("form");
		$("#update").attr("type", "submit");
	})	
		
	$("#cancel").on("click", function() {
		location.href = "/jnj/menu/volunteer/view?volunteerNo="+$volunteer.volunteerNo;
	})
	$("#zipcode").on("click", function() {
		sample6_execDaumPostcode();
	})	
	
$("#form").validate({
		
		// 검증 규칙 지정
		rules : {
			volunteerTitle : {
				required : true,
				minlength : 1,
				maxlength : 50
			},
			addr1 : {
				required : true
			},
			addr3 : {
				required : true,
				minlength : 1,
				maxlength : 50
			},
			volunteerContent : {
				required : true,
				minlength : 1,
				maxlength : 200
			},
			volunteerDate : {
				required : true
			},
			applyEndDate : {
				required : true
			},
			minPeople : {
				required : true,
				digits : true,
				minlength : 1,
				maxlength : 2
			},
			maxPeople : {
				required : true,
				digits : true,
				minlength : 1,
				maxlength : 2
			},
			tel2 : {
				required : true,
				digits : true,
				minlength : 7,
				maxlength : 8
			}
		},
		messages : {
			volunteerTitle : {
				required : "제목을 입력해주세요.",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			} ,
			addr1 : {
				required : "우편번호를 입력해주세요."
			},
			addr3 : {
				required : "나머지주소를 입력해주세요",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			},
			volunteerContent : {
				required : "내용 입력해주세요",
				minlength : "최소 {0}글자이상이어야 합니다",
				maxlength : "최대 {0}글자이하이어야 합니다"
			},
			volunteerDate : {
				required : "날짜를 입력해주세요."
			},
			applyEndDate : {
				required : "신청마감일 입력해주세요"
			},
			minPeople : {
				required :"최소 인원수를 입력해주세요.",
				digits : "최소 인원수는 숫자만 입력 가능합니다",
				minlength : "최소 {0}숫자이상이어야 합니다",
				maxlength : "최대 {0}숫자이하이어야 합니다"
			},
			maxPeople : {
				required :"최대 인원수를 입력해주세요",
				digits : "최대 인원수는 숫자만 입력 가능합니다",
				minlength : "최소 {0}숫자이상이어야 합니다",
				maxlength : "최대 {0}숫자이하이어야 합니다"
			},
			tel2 : {
				required :"전화번호를 입력해주세요",
				digits : "전화번호는 숫자만 입력 가능합니다",
				minlength : "최소 {0}숫자이상이어야 합니다",
				maxlength : "최대 {0}숫자이하이어야 합니다"
			}
		}
	});
	
	
	
	
})
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
</head>
<body>
	<div class="container update">
		<h3>-모집:봉사</h3>
		<hr />
		<form id="form" action="/jnj/menu/volunteer/update" class="form-horizontal" method="post">
		<input type="hidden" class="form-control" id="volunteerNo" name="volunteerNo" >
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">봉사 제목</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="volunteerTitle" name="volunteerTitle" >
					<label class="error" for="volunteerTitle" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">봉사 주소</label>
				<div class="col-sm-2">
					<input id="addr1"type="text" class="form-control" id="addr1" readonly="readonly">
					<label class="error" for="addr1" generated="true" style="display:none; color: red;">error message</label>
				</div>
				<button type="button" id="zipcode">우편번호</button>
				<br>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="title"></label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="addr2" readonly="readonly">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="title"></label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="addr3" >
					<label class="error" for="addr3" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">봉사 내용</label>
				<div class="col-sm-8">
					<textarea class="form-control"  rows="15"id="volunteerContent" name="volunteerContent"  ></textarea>
					<label class="error" for="volunteerContent" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">봉사 날짜</label>
				<div class="col-sm-2">
					<input type="date" class="form-control" id="volunteerDate" name="volunteerDate">
					<label class="error" for="volunteerDate" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="text">신청마감일</label>
				<div class="col-sm-2">
					<input type="date" class="form-control" id="applyEndDate" name="applyEndDate">
					<label class="error" for="applyEndDate" generated="true" style="display:none; color: red;">error message</label>
				</div>		
			</div>
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="title">나이제한</label>
					<div class="col-sm-2">
						<select id="ageLimit" name="ageLimit" class="form-control">
							<option value="1">전체이용</option>
							<option value="14">14세 이상</option>
							<option value="20">20세 이상</option>
						</select>
					</div>
			</div>
			
			
		<div class="form-group">
				<label class="control-label col-sm-2" for="text">모집인원</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="minPeople" name="minPeople">  ~ 
					<input type="text" class="form-control" id="maxPeople" name="maxPeople"><br>
					<label class="error" for="minPeople" generated="true" style="display:none; color: red;">error message</label><br>
					<label class="error" for="maxPeople" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div> 
			
			
			<div class="form-group">
				<label class="control-label col-sm-2" for="title">주최자 전화번호</label>
					<div class="col-sm-2">
						<select id="tel1" class="form-control">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="017">017</option>
						</select>
					</div>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="tel2" name="tel2" >
					<label class="error" for="tel2" generated="true" style="display:none; color: red;">error message</label>
				</div>
			</div>
			
			
			
			
			
			
			<br>
			<br>
			<br>
			<input type="hidden" name="_csrf" value="${_csrf.token}">
			<button type="button" id="update"  class="btn btn-default">수정완료</button>
			<button type="button" id="cancel" class="btn btn-default">취소</button>
		</form>
	</div>
	<br><br><br><br><br><br>
</body>
</html>