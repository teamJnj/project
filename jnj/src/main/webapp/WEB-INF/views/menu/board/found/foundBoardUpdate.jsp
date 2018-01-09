<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
<script type="text/javascript">
$(function () {
	var $find = ${find};
	
	$("#writeBtn").on("click", function() {
	console.log("클릭");
	  var form = $("#form");
	  $("<input type='hidden' id='findAddr11' name='findAddr' value='("+$("#addr1").val()+")"+$("#addr2").val()+"　"+$("#addr3").val()+"'>").appendTo(form);
	  $("<input></input>").attr("type","hidden").attr("name","petImg").val($find.petImg).appendTo(form);
		form.submit();
	})
	console.log($find);
	console.log($find.findNo);
	console.log($find.addr1);
	console.log($find.addr2);
	console.log($find.addr3);
	$("#findTitle").val($find.findTitle);
	$("#findContent").val($find.findContent);
	$("#findDate").val($find.findDate);
	// $("#centerAddr").val($find.centerAddr);
	$("#findAddr").val($find.findAddr);
	
	$("#writeId").val($find.writeId);
	
	
	
	$("#findNo").val($find.findNo);
	
	
	$("#petSort").val($find.petSort);
	$("#petKind").val($find.petKind);
	$("#petGender").val($find.petGender);
	$("#petFeature").val($find.petFeature);
	
	$("#addr1").val($find.addr1);
	$("#addr2").val($find.addr2);
	$("#addr3").val($find.addr3);
	
	
	// 주소 api 버튼 이벤트
	$("#zipcode").on("click", function() {
	  sample6_execDaumPostcode();
	})
	
	
	$("#form").validate({
			
			// 검증 규칙 지정
			rules : {
				findTitle: {
					required : true,
					maxlength : 50
				},
				findContent: {
					required : true,
					minlength : 10
				},
				addr1: {
					digits : true
				},
				addr2: {
					required : true
				},/* 
				addr3: {
					required : true					
				}, */				
				petName: {
					required : true,
					minlength : 1,
					maxlength : 10
				},
				petSort: {
					required : true
				}, 
				petKind: {
					required : true
				},
				petGender: {
					required : true
				},
				petAge: {
					required : true,
					digits : true,
					minlength : 1,
					maxlength : 2
				}
				
				
			},
			messages : {
				findTitle: {
					required : "필수입력입니다",
					maxlength : "최대 {0}글자이하이어야 합니다"
				},
				findContent: {
					required : "필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다"
				},
				addr1: {
					digits : "숫자만 입력해야 합니다"
				},
				addr2: {
					required : "필수입력입니다"
				},/* 
				addr3: {
					required : "필수입력입니다"					
				}, */
				petName: {
					required :"필수입력입니다",
					minlength : "최소 {0}글자이상이어야 합니다",
					maxlength : "최대 {0}글자이하이어야 합니다"
				},
				petSort:{
					required :"필수선택입니다"
				}, 
				petKind: {
					required :"필수선택입니다"
				},
				petGender: {
					required :"필수선택입니다"
				},
				petAge: {
					required :"필수입력입니다",
					digits : "숫자만 입력해야 합니다",
					minlength : "최소 {0}글자이상이어야 합니다",
					maxlength : "최대 {0}글자이하이어야 합니다"
				}
			}
		});
		
		
		
		
		/* $("#findTitle").click(function(){
			$("#findTitle").val('');
		})
		
		$("#findContent").click(function(){
			$("#findContent").val('');
		})
		
		$("#addr3").click(function(){
			$("#addr3").val('');
		})
		
		$("#petName").click(function(){
			$("#petName").val('');
		})
		
		$("#petKind").click(function(){
			$("#petKind").val('');
		})
		
		$("#petAge").click(function(){
			$("#petAge").val('');
		})
		
		$("#petFeature").click(function(){
			$("#petFeature").val('');
		}) */
});


//주소 api
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
<style type="text/css">
#backList {
	font-size: 1.3em;
	float: right;
	margin: 0px 50px 0px 0px;
}

#caca {
	margin: 0px 0px 0px 50px;
}

form { 
	margin: 0px 0px 0px 200px;
}
</style>
</head>
<body>
	<h2 id="caca">- 찾았어요</h2>
	<a id="backList" href="/jnj/menu/board_found/list">목록으로</a>
	<br>
	<hr>
	<form id="form" action="/jnj/menu/board_found/update" method="post" enctype="multipart/form-data">
<table>
<article class="container">

	<div class="col-md-6 col-md-offset-3">
		<tr>
			<th>제목</th>
			<td>
				<input type="text" class="btn btn-default" id="findTitle"	name="findTitle" placeholder="제목">
			</td>
		</tr>
		<tr><td></td>
			<td>
			<label class="error" for="findTitle" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>



		<tr>
			<th>내용</th>
			<td>
				<textarea type="text" class="btn btn-default" id="findContent" name="findContent" placeholder="내용"></textarea>
			</td>
		</tr>
		<tr><td></td>
			<td>
			<label class="error" for="findContent" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>



		<tr>
			<th>발견일시</th>
			<td>
				<input type="date" class="btn btn-default" id="findDate" name="findDate">
			</td>
		</tr>



		<tr>
			<th>발견 장소</th>
			<td>
				<input type="text"  class="btn btn-default" id="addr1" name="addr1" readonly="readonly" placeholder="우편번호">
				<button type="button" class="btn btn-default" id="zipcode">우편번호</button>
			</td>
		</tr>
		
		<tr><td></td>
			<td>
				<input type="text"  class="btn btn-default" id="addr2" name="addr2" readonly="readonly" placeholder="주소">
			</td>
		</tr>
		<tr><td></td>
			<td>
				<label class="error" for="addr2" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>

		<tr><td></td>
			<td>
				<input type="text"  class="btn btn-default" id="addr3" name="addr3" placeholder="나머지주소">
			</td>
		</tr>
		<tr><td></td>
			<td>
				<label class="error" for="addr3" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>
		<br>



		<!-- <div class="form-group">
			<h1>좌표1</h1><br><input type="text" class="btn btn-default" id="mapX" name="mapX"
				placeholder="mapX">
		</div>



		<div class="form-group">
			<h1>좌표2</h1><br><input type="text" class="btn btn-default" id="mapY" name="mapY"
				placeholder="mapY">
		</div> -->





		<tr>
			<th>종류</th>
			<td>
			<select class="btn btn-default" id="petSort" name="petSort">
			<option value="1">개</option>
			<option value="2">고양이</option>
			<option value="3">기타</option>
			</select>
			</td>
		</tr>



		<tr>
			<th>세부종류</th>
			<td>
				<input type="text" class="btn btn-default" class="btn btn-default" id="petKind" name="petKind" placeholder="종류">
			</td>
		</tr>
		<tr><td></td>
			<td>
			<label class="error" for="petKind" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>


		<tr>
			<th>성별</th>
			<td>
				<select id="petGender" class="btn btn-default" name="petGender">
				<option value="1">수컷</option>
				<option value="2">암컷</option>
				</select>
			</td>
		</tr>


		
		<tr>
			<th>특징</th>
			<td>
				<textarea type="text" class="btn btn-default" id="petFeature" name="petFeature" placeholder="특징"></textarea>
			</td>
		</tr>
		<tr><td></td>
			<td>
			<label class="error" for="petFeature" generated="true" style="display:none; color: red;">error message</label>
			</td>
		</tr>



		<tr>
			<th>이미지</th>
			<td>
				<input type="file" class="btn btn-default" id="petImg"	name="file">
			</td>
		</tr>
		
		
		<tr>
			<td>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<input type="hidden" id="findNo" name="findNo" value="findNo">
			</td>
		</tr>
	 	<tr><td></td>
			<td>
				<button class="btn btn-default" id="writeBtn" type="button">작성완료</button>
			</td>
		</tr>
		<br>
		
		</article>
		</table>
	</form>
</body>
</html>