<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.marketView {
	margin-top: 30px;
	
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
	text-align: center;
	border-left: 1px solid #7F5926;
	padding-left: 20px;
	border-bottom: 1px solid #fff;
}

.contentTh {
	text-align: center;
	padding: 10px 0px 10px 0px;
	width: 20%;
	height : 50px;
	border-bottom: 1px solid #fff;
}

.table {
	
	
}
 #view{
	margin-top: 5%; 
} 
#request{
	width:150px;
	margin-left: 500px;
}
#marketApplyDelete{
	width:150px;
	margin-left: 500px;
}

#marketUpdate{
	width:150px;
	margin-left: 38%;
	margin-right: 30px;
}
#marketDelete{
	width:150px;
}

#marketList{
	width:150px;
	float: right;
}
.th, .td {
	text-align: center;
}

/* 댓글 수정  */
.updateMarketComment{
 	width: 75px;
	margin-right: 10px;
	
}
/* 댓글 삭제  */
.deleteMarketComment {
 	width: 75px;
}

 /* 댓글 수정 완료 */
.updateCommentContent {
 	width: 75px;
 	margin-right: 10px;
}
/* 댓글 수정 취소 */
.cancel {
 	width: 75px;
}
/* 댓글 등록  */
#insertComment{
	width : 100px;
	height : 66px;
	text-align: center;
	margin-left: 30px;
}


</style>
<script>




$(function() {
	//var marketNo = "${marketNo}";
	var $map = ${requestScope.map};
	var $market = $map.market;
	var $marketComment = $map.marketComment;
	var $marketApply = $map.marketApply;
	var $name = ${requestScope.name};
	
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
	
	var $table = $("#reply");
	printReply($marketComment);	
	
	
	function printReply($marketComment){
		
		$table.empty();
		$table.append('<colgroup width="10%"/><colgroup width="60%"/><colgroup width="10%"/><colgroup width="20%"/><thead><tr id="tableTrStyle"><th class="th">작성자</th><th class="th">댓글내용</th><th class="th">작성날짜</th><th class="th"></th></tr></thead>');
		
		var $tbody = $("<tbody></tbody>").appendTo($table);
		$.each($marketComment,  function(i, $marketComment) {
			
			var $tr = $("<tr></tr>").appendTo($tbody);
			if($marketComment.writeId=="admin"){
				$("<td class='td'></td>").text($marketComment.writeId).css("color","red").text("관리자").appendTo($tr);
				$("<td class='tdContent'></td>").text($marketComment.commentContent).css("color","red").appendTo($tr);
				$("<td class='td'></td>").text($marketComment.writeDate).css("color","red").appendTo($tr);
			} else if($marketComment.writeId=="-----"){
				$("<td class='td'></td>").text($marketComment.writeId).css("color","blue").text("").appendTo($tr);
				$("<td class='tdContent'></td>").text($marketComment.commentContent).css("color","blue").appendTo($tr);
				$("<td class='td'></td>").text($marketComment.writeDate).css("color","blue").appendTo($tr);
			} else{
				$("<td class='td'></td>").text($marketComment.writeId).appendTo($tr);
				$("<td class='tdContent'></td>").text($marketComment.commentContent).appendTo($tr);
				$("<td class='td'></td>").text($marketComment.writeDate).appendTo($tr);
			}
			var td = $("<td class='td'></td>").appendTo($tr);
			if($name==$marketComment.writeId){
				$("<button type='button' data-idx='"+i+"'></button>").attr("class","btn btn-info updateMarketComment").attr("data-marketCommentNo",$marketComment.marketCommentNo).text("수정").css("display", "inline-block").appendTo(td);
				$("<button type='button'></button>").attr("class","btn btn-default deleteMarketComment").attr("data-marketCommentNo",$marketComment.marketCommentNo).attr("data-marketNo",$market.marketNo).text("삭제").css("display", "inline-block").appendTo(td);
				$("<button type='button' data-idx='"+i+"'></button>").attr("class","btn btn-info updateCommentContent").attr("data-marketCommentNo",$marketComment.marketCommentNo).text("수정완료").css("display", "none").appendTo(td);
				$("<button type='button'></button>").attr("class","btn btn-default cancel").attr("data-marketCommentNo",$marketComment.marketCommentNo).text("수정취소").css("display", "none").appendTo(td);
			}
		});
	}
	
	
	$("#reply").on("click",".updateMarketComment", function() {
		console.log("수정 클릭 : " + $(this).attr("data-idx") );
		console.log( $(this).parent().parent().children("td").eq(1).text() );
		
		var td = $(this).parent().parent().children("td").eq(1);
		var str = $(this).parent().parent().children("td").eq(1).text();
		
		$(this).parent().parent().children("td").eq(1).text("");
		
		$("<textarea rows='2' cols='80' id='commentContent' name='commentContent'></textarea>").val(str).appendTo( td );

		var td1 = $(this).parent().children("button").eq(0).css("display", "none");
		var td2 = $(this).parent().children("button").eq(1).css("display", "none");
		var td3 = $(this).parent().children("button").eq(2).css("display", "inline-block");
		var td4 = $(this).parent().children("button").eq(3).css("display", "inline-block");
		
	});
	
	
	$("#reply").on("click",".cancel", function() {
		var td1 = $(this).parent().children("button").eq(0).css("display", "inline-block");
		var td2 = $(this).parent().children("button").eq(1).css("display", "inline-block");
		var td3 = $(this).parent().children("button").eq(2).css("display", "none");
		var td4 = $(this).parent().children("button").eq(3).css("display", "none");
	});
	
	
	
	
	
	
	
	
	
	
			$("#insertComment").on("click", function() {
				var commentContentInsert = $("#commentContentInsert").val();
				if(commentContentInsert==""){
					alert("댓글 내용을 작성해주세요");
				} else {
					console.log( $market.marketNo);
					
					var formData = new FormData();
					formData.append("writeId", $marketComment.writeId);
					formData.append("commentContent", $("#commentContentInsert").val());
					formData.append("writeDate", $marketComment.writeDate);
					formData.append("marketNo", $market.marketNo);
					formData.append("_csrf", "${_csrf.token}");
					
					console.log(formData);
					
					$.ajax({
						url : "/jnj/menu/market/comment/insert",
						type:"post",
						data:formData,
						processData:false,	// FormData 전송에 필요한 설정
						contentType:false,	// FormData 전송에 필요한 설정
						success:function(marketComment) {
							console.log(marketComment);
							printReply(marketComment);
							location.reload();
						}
					});
				}
			});		
			
			$("#request").on("click", function() {
				location.href = "/jnj/menu/market/apply?marketNo="+$market.marketNo+"&applyPeople="+$market.applyPeople+"&boothPrice="+$market.boothPrice;
			        
			   });
			
			// 프리마켓 글 수정 하러 jsp 가기
			$("#marketUpdate").on("click",function(){
				location.href = "/jnj/menu/market/update?marketNo="+$market.marketNo;
			});
			
			// 프리마켓 신청 취소
			$("#marketApplyDelete").on("click", function() {
				if (confirm("프리마켓 신청 취소하시겠습니까??") == true){
				var $form = $("<form></form>").appendTo("body");
				$form.attr("action", "/jnj/menu/market/apply/delete");
				$form.attr("method", "post");
				$("<input>").attr("type","hidden").attr("name","marketNo").val($market.marketNo).appendTo($form);
				$("<input>").attr("type","hidden").attr("name","memberId").val($marketApply.memberId).appendTo($form);
				$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
				$form.submit();
				}
			});
		        
			// 프리 마켓 글 삭제
			$("#marketDelete").on("click", function() {
				if (confirm("정말 삭제하시겠습니까??") == true){ 
					
				var $form = $("<form></form>").appendTo("body");
				$form.attr("action", "/jnj/menu/market/delete");
				$form.attr("method", "post");
				$("<input>").attr("type","hidden").attr("name","marketNo").val($market.marketNo).appendTo($form);
				$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
				$form.submit();
				}
			});
			
			// 목록으로 리스트 화면
			$("#marketList").on("click",function(){
				location.href = "/jnj/menu/market/record"
			});
			
			
			$(".updateCommentContent").on("click", function() {
				
				var formData = new FormData();
				formData.append("marketCommentNo", $(this).attr("data-marketCommentNo"));
				formData.append("commentContent", $("#commentContent").val());
				
				formData.append("writeDate", $marketComment.writeDate);
				formData.append("_csrf", "${_csrf.token}");
				console.log(formData);
				 
				 $.ajax({
					url : "/jnj/menu/market/comment/update",
					type:"post",
					data:formData,
					processData:false,	// FormData 전송에 필요한 설정
					contentType:false,	// FormData 전송에 필요한 설정
					success:function(marketComment) {
						console.log(marketComment);
						printReply(marketComment); 
					}    
				}); 
			alert("댓글이 수정 완료 되었습니다.");	
			location.reload();
			}); 
			
			$(".cancel").on("click", function() {
				location.reload();
			})
			
			$(".deleteMarketComment").on("click", function() {
					if (confirm("정말 삭제하시겠습니까??") == true){    //확인
						var formData = new FormData();
						formData.append("marketNo", $(this).attr("data-marketNo"));
						formData.append("marketCommentNo", $(this).attr("data-marketCommentNo"));
						formData.append("_csrf", "${_csrf.token}");
						console.log(formData);
						
						$.ajax({
							url : "/jnj/menu/market/comment/delete",
							type:"post",
							data:formData,
							processData:false,	// FormData 전송에 필요한 설정
							contentType:false,	// FormData 전송에 필요한 설정
							success:function(marketComment) {
								console.log(marketComment);
								printReply(marketComment);
							}
						});
						location.reload();
					}
					
				
					
			});
	
});
</script>
</head>
<body>
	<div class="container marketView">
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
	<div class="row">
	<table id="view" class="table table-bordered table-condensed table-striped ">
	<tbody>
		<tr>
			<th class="contentTh" scope="row">장소</th>
			<td class="contentTd" id="marketAddr" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">내용</th>
			<td id="marketContent" class="contentTd" colspan="3" ></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">날짜</th>
			<td id="marketDate" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">부스 가격</th>
			<td id="boothPrice" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">계좌번호</th>
			<td id="accountNumber" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">신청기간</th>
			<td id="applyEndDate" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">총 부스 개수</th>
			<td id="recruitmentNumber" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">신청 부스 개수</th>
			<td id="applyPeople"  class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">전화 번호</th>
			<td id="tel" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th class="contentTh" scope="row">나이제한</th>
			<td id="age" class="contentTd" colspan="3"></td>
		</tr>
	</tbody>
</table>
	</div>
</div>
			
			
			<br><br><br> 
			
			
			<div id="btnMarket">
			</div>
			<br><br><br><br>
			<button id="marketList" type="button" class="btn btn-default">목록</button>
			<br><br><br>
			<h4>댓글</h4>
		<hr />
		<table class="table" id="reply">
			<tr>
					<td></td>
				</tr>
		</table>
		
		<hr>
		<div class="container">
	<div class="row">
		<div class="span4 well" style="padding-bottom:0">
		<table>
			<tr>
				<td><textarea class="span4" id="commentContentInsert"  rows="3" cols="120"></textarea></td>
               	<td><button class="btn btn-info" type="button" id="insertComment">댓글 추가</button></td>
        	</tr>
        </table>
        </div>
	</div>
</div>	
		
		
		
	<hr>
			
		<br><br><br><br><br><br><br><br><br>
					
		</form>
	</div>
</body>
</html>