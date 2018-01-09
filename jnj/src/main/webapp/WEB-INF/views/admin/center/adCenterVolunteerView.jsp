<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style>
.volunteerView {
	margin-top: 100px;
	
}
#volunteerTitle, #writeDate, #applyPeople, #hits, #reportCnt{
	text-align: center;
}
#hostId{
	text-align: left;
}
.volunteerView h3{
	color: #7F5926;
}
.volunteerView h4{
	color: #7F5926;
}


.contentTd {
	border-left: 1px solid #7F5926;
	padding-left: 20px;
	border-bottom: 1px solid #fff;
}

.contentTh {
	text-align: left;
	padding: 10px 0px 10px 0px;
	width: 120px;
	border-bottom: 1px solid #fff;
}

.table {
	
	
}
#view{
	margin-left: 30%;
	margin-top: 5%;
}
#request, #volunteerUpdate, #volunteerApplyDelete, #volunteerDelete, #volunteerList{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	margin-left:450px;
		
}
.th, .td {
	text-align: center;
}
#state{
	text-align: center;
	color: red;
	font-weight: bold ;
	font-size: 5em;
}


#popupCloseBtn{
   float: right;
   margin-right: 50px;
   margin-bottom : 100px;
   width: 100px;
   height: 40px;
   text-align: 40px;
   background-color: #FFB24C;
   color: #fff;
   
}

</style>
<script>

$(function() {

	var $map = ${requestScope.map};
	var $volunteer = $map.volunteer;
	var $volunteerComment = $map.volunteerComment;
	var $volunteerApply = $map.volunteerApply;
	var $name = ${requestScope.name};
	
	
	// 자기 글 봉사취소, 신고 버튼 못하게
	if($volunteer.hostId==$name){
		$("#volunteerApplyDelete").hide();
		$("#reportCnt").hide();
	} else{
		$("#bin").hide();
	}
	if($volunteer.maxPeople==$volunteer.applyPeople){
		$("#request").hide();
	}
	
	
 	if($volunteer.volunteerDivision==2){
		$("#volunteerDivision").text("일반회원");
	} else if($volunteer.volunteerDivision==1) {
		$("#volunteerDivision").text("센터회원");
	}
	
	if( $volunteerComment.length <= 0 )
	if( $volunteerApply.length <= 0 )
	// 봉사
	
	$("#volunteerTitle").text($volunteer.volunteerTitle);
	$("#volunteerTitle").text($volunteer.volunteerTitle);
	console.log($volunteer.volunteerTitle);
	$("#applyPeople").text($volunteer.applyPeople+" / "+$volunteer.maxPeople);
	$("#writeDate").text($volunteer.writeDate);
	$("#hits").text($volunteer.hits);
	$("#ageLimit").text($volunteer.ageLimit);
	$("#volunteerAddr").text($volunteer.volunteerAddr);
	$("#volunteerContent").text($volunteer.volunteerContent);
	$("#volunteerDate").text($volunteer.volunteerDate);
	$("#maxPeople").text($volunteer.minPeople+" ~ "+$volunteer.maxPeople);
	$("#applyEndDate").text($volunteer.writeDate+" ~ "+$volunteer.applyEndDate);
	$("#hostTel").text($volunteer.hostTel);
	$("#hostId").text($volunteer.hostId);

	$("#popupCloseBtn").on( "click", function () {
		self.close();	   
   	});
				
});
</script>
</head>
<body>

		
	<div class="container volunteerView">
	
		<div id="titleTotal">
		   <a href="#" class="btn btn-block" id="popupCloseBtn">닫기</a>
		</div>
		<br>
		<br>
		<br>
		<br>
		<div>
			<h3>모집 : 봉사</h3>
			<hr />
			<form class="form-horizontal"  method="post">
				<div class="form-group">
					<label class="control-label col-sm-1" for="title">구분</label>
					<span id="volunteerDivision" class="control-label col-sm-1"></span>
					<label class="control-label col-sm-1" for="title">제목</label>
					<span id="volunteerTitle" class="control-label col-sm-6"></span> 
					<label class="control-label col-sm-1" for="title">작성일</label> 
					<span id="writeDate" class="control-label col-sm-2"></span>
				</div>
				<hr />
				<div class="form-group">
					<label class="control-label col-sm-1" for="writer">작성자</label> 
					<span id="hostId"class="control-label col-sm-5"></span> 
					<label id="bin"class="control-label col-sm-2" for="writer"></label>
					<button class="control-label col-sm-2" type="button" id="reportCnt">신고하기</button>
					<label class="control-label col-sm-1" for="title">조회</label> 
					<span id="hits"class="control-label col-sm-1"></span> 
					<label class="control-label col-sm-1" for="title">신청인원</label> 
					<span id="applyPeople"class="control-label col-sm-1"></span>
				</div>
				<hr />
				
				<p id="state"></p>
				
				<div class="container">
					<table class="table" id="view">
						<tr>
							<th class="contentTh">장소</th>
							<td id="volunteerAddr"class="contentTd"></td>
						</tr>
						<tr>
							<th class="contentTh">내용</th>
							<td id="volunteerContent" class="contentTd"></td>
						</tr>
						<tr>
							<th class="contentTh">날짜</th>
							<td id="volunteerDate" class="contentTd"></td>
						</tr>
						<tr>
							<th class="contentTh">신청기간</th>
							<td id="applyEndDate" class="contentTd">
							
							</td>
						</tr>
						<tr>
							<th class="contentTh">모집인원</th>
							<td id="maxPeople" class="contentTd"></td>
						</tr>
						<tr>
							<th class="contentTh">나이제한</th>
							<td id="ageLimit" class="contentTd"></td>
						</tr>
						<tr>
							<th class="contentTh">전화번호</th>
							<td id="hostTel" class="contentTd"></td>
						</tr>
					</table>
				
				</div>
			<br><br><br>
						
			</form>
		</div>
	</div>
</body>
</html>