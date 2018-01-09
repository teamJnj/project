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
.marketView {
	margin-top: 100px;
	
}
#marketTitle, #writeDate, #apply_People, #hits{
	text-align: center;
}

.marketView h3{
	color: #7F5926;
}
.marketView h4{
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
#request{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	margin-left: 450px;
}
#marketApplyDelete{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	margin-left: 450px;
}

#marketUpdate{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	margin-left: 30%;
	margin-right: 30px;
}
#marketDelete{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	
}

#marketList{
	width:150px;
	background-color: #FFB24C;
	color: #7F5926;
	float: right;
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
	var $market = $map.market;
	var $marketComment = $map.marketComment;
	var $marketApply = $map.marketApply;
	var $name = "admin";
	
	console.log($market.marketNo);
	
	var $btnMarket = $("#btnMarket");	
	if($name=="admin"){
		$("<button type='button'></button>").attr("id","marketUpdate").attr("class","btn btn-default").text("글수정").appendTo($btnMarket);
		$("<button type='button'></button>").attr("id","marketDelete").attr("class","btn btn-default").text("글삭제").appendTo($btnMarket);
	} else{
		$("<button type='button'></button>").attr("id","request").attr("class","btn btn-default").text("신청하기").appendTo($btnMarket);
	}
	
	$.each($marketApply, function(i, $marketApply) {
		if($name==$marketApply.memberId && $marketApply.marketApplyState!=0){
			$("<button type='button'></button>").attr("id","marketApplyDelete").attr("class","btn btn-default").text("신청취소").appendTo($btnMarket);
			$("#request").hide();
		} 
		
	}); 
	
	if($name=="admin"){
		$("#marketApplyDelete").hide();
	}
	
	if($market.applyPeople>=20){
		$("#request").hide();
	} 
	
	if( $marketComment.length <= 0 )
	if( $marketApply.length <= 0 )
	
	// 프리마켓
	$("#marketTitle").text($market.marketTitle);
	$("#marketTitle").text($market.marketTitle);
	$("#writeDate").text($market.writeDate);
	$("#hits").text($market.hits);
	$("#apply_People").text($market.applyPeople+"/20");
	$("#marketAddr").text($market.marketAddr);
	$("#marketContent").text($market.marketContent);
	$("#marketDate").text($market.marketDate);
	$("#boothPrice").text($market.boothPrice);
	$("#accountNumber").text("1002-135-1324100");
	$("#applyEndDate").text($market.writeDate+" ~ "+$market.applyEndDate);
	$("#recruitmentNumber").text("20개");
	$("#applyPeople").text($market.applyPeople+" / 20");
	$("#tel").text("01000000000");
	$("#age").text("20세이상");
	
	$("#popupCloseBtn").on( "click", function () {
		self.close();	   
   	});
	
});
</script>
</head>
<body>
	<div class="container marketView">
		<div id="titleTotal">
		   <a href="#" class="btn btn-block" id="popupCloseBtn">닫기</a>
		</div>
		<br>
		<br>
		<br>
		<br>
		
		<h3>모집 : 프리마켓</h3>
		<hr />
		<form class="form-horizontal"  method="post">
			<div class="form-group">
				<label class="control-label col-sm-1" for="category">제목</label>
				<span id="marketTitle"class="control-label col-sm-8"></span> 
				<label class="control-label col-sm-1" for="writedate">작성일</label> 
				<span id="writeDate" class="control-label col-sm-2"></span>
			</div>
			<hr />
			<div class="form-group">
				<label class="control-label col-sm-1" for="writer">작성자</label> 
				<span class="control-label col-sm-5">관리자</span> 
				<label class="control-label col-sm-2"></label> 
				<label class="control-label col-sm-1" for="title">조회</label> 
				<span id="hits"class="control-label col-sm-1"></span> 
				<label class="control-label col-sm-1" for="title">부스 개수</label> 
				<span id="apply_People"class="control-label col-sm-1"></span>
			</div>
			<hr />
			
			
			
			<div class="container">
				<table class="table" id="view">
					<tr>
						<th class="contentTh">장소</th>
						<td id="marketAddr"class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">내용</th>
						<td id="marketContent" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">날짜</th>
						<td id="marketDate" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">참가비</th>
						<td id="boothPrice" class="contentTd">
						
						</td>
					</tr>
					<tr>
						<th class="contentTh">계좌번호</th>
						<td id="accountNumber" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">신청기간</th>
						<td id="applyEndDate" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">총 부스 개수</th>
						<td id="recruitmentNumber" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">신청 부스 개수</th>
						<td id="applyPeople" name="applyPeople" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">전화번호</th>
						<td id="tel" class="contentTd"></td>
					</tr>
					<tr>
						<th class="contentTh">나이제한</th>
						<td id="age" class="contentTd"></td>
					</tr>
				</table>
			
			</div>
			<br><br>
		</form>
	</div>
</body>
</html>