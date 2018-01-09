<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c02f43d2c62635fda30f33785e1785d5&libraries=services"></script>
<title>찾았어요 상세보기 뷰</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">


 

	$(function () {
		var $map = ${requestScope.map};
		var $find = $map.find;
		var $findComment = $map.findComment;
	
		console.log($map);
		
/* ======================================================================================================================================= */		
		
		
		// 상세보기 뷰
		var $table = ("#table");
		
		$("<img class='img-responsive' style=\"width:320px; height:200px;\"></img>")
		.attr("src","/jnjimg/find/"+ $find.petImg).appendTo($table);
				
		
		$("#findNo").text($find.findNo);
		$("#findTitle").text($find.findTitle);
		$("#findContent").text($find.findContent);
		$("#findDate").text($find.findDate);
		$("#centerAddr").text($find.centerAddr);
		$("#findAddr").text($find.findAddr);
		$("#mapX").text($find.mapX);
		$("#mapY").text($find.mapY);
		$("#writeDate").text($find.writeDate);
		$("#petImg").text($find.petImg);
		
		$("#writeId").text($find.writeId);
		$("#hits").text($find.hits);
		if($find.petSort==1) {
			$("#petSort").text("개");
		} else if($find.petSort==2) {
			$("#petSort").text("고양이");
		} else if($find.petSort==3) {
			$("#petSort").text("기타");
		}
		
		$("#petKind").text($find.petKind);
		
		if($find.petGender==1) {
			$("#petGender").text("숫컷");
		} else if($find.petGender==2) {
			$("#petGender").text("암컷");
		}
		
		$("#petFeature").text($find.petFeature);
		
		// 접속자와 글쓴이가 같다면 수정 삭제 띄우고 아니면 신고
		if($userName==$find.writeId){
			$("<button type='button'></button>").attr("id","findBoardUpdate").attr("name","findBoardUpdate").text("글수정").appendTo("#table2");
			$("<button type='button'></button>").attr("id","findBoardDelete").attr("name","findBoardDelete").text("글삭제").appendTo("#table2");
		}	else $("<button type='button'></button>").attr("id","findBoardReport").attr("name","findBoardReport").text("신고").appendTo("#table2");
		
		
		
		
/* ======================================================================================================================================= */		
		
		
		//댓글 리스트
		var $table = $("#reply");
		printReply($findComment);
		function printReply($findComment){
			
			$table.empty();
			$table.append('<colgroup width="10%"/><colgroup width="50%"/><colgroup width="20%"/><colgroup width="20%"/><thead><tr id="tableTrStyle"><th class="th">작성자</th><th class="th">댓글내용</th><th class="th">작성날짜</th><th class="th"></th></tr></thead>');
			
			var $tbody = $("<tbody></tbody>").appendTo($table);
			$.each($findComment,  function(i, $findComment) {
				
				var $tr = $("<tr></tr>").appendTo($tbody);
				$("<td class='td'></td>").text($findComment.writeId).appendTo($tr);
				$("<td class='tdContent'></td>").text($findComment.commentContent).appendTo($tr);
				$("<td class='td'></td>").text($findComment.writeDate).appendTo($tr);
				
				var td = $("<td class='td'></td>").appendTo($tr);
				console.log("userName : "+$userName);
				console.log("findComment.writeId : "+$findComment.writeId);
				// 로그인 사용자랑 댓글 글쓴이가 같으면 수정 삭제 버튼 띄우기
				if($userName==$findComment.writeId){
					$("<button type='button' data-idx='"+i+"'></button>").attr("class","updateFindComment").attr("data-FindCommentNo",$findComment.findCommentNo).text("수정").css("display", "block").appendTo(td);
					$("<button type='button'></button>").attr("class","deleteFindComment").attr("data-findCommentNo",$findComment.findCommentNo).attr("data-findNo",$find.findNo).text("삭제").css("display", "block").appendTo(td);
					
					$("<button type='button' data-idx='"+i+"'></button>").attr("class","updateCommentContent").attr("data-FindCommentNo",$findComment.findCommentNo).text("수정완료").css("display", "none").appendTo(td);
					$("<button type='button'></button>").attr("class","cancel").attr("data-findCommentNo",$findComment.findCommentNo).text("수정취소").css("display", "none").appendTo(td);
				}
			});
		}
		
		
		
		
/* ======================================================================================================================================= */
		
		
		// 댓글 insert
		$("#insertComment").on("click", function() {
				
				
				var formData = new FormData();
				formData.append("commentContent", $("#commentContent").val());
				formData.append("findNo", $find.findNo);
				formData.append("_csrf", "${_csrf.token}");
				
				console.log(formData);
				
				$.ajax({
					url : "/jnj/menu/board_find/comment_write",
					type:"post",
					data:formData,
					processData:false,	// FormData 전송에 필요한 설정
					contentType:false,	// FormData 전송에 필요한 설정
					success:function(commentContent) {
						console.log(commentContent);
						printReply(commentContent);
					}
				});
				location.reload();
			});	
			
			
/* ======================================================================================================================================= */
		//댓글삭제

		$(".deleteFindComment").on("click", function() {
					if (confirm("정말 삭제하시겠습니까??") == true){    //확인
						var formData = new FormData();
						formData.append("findNo", $(this).attr("data-findNo"));
						formData.append("findCommentNo", $(this).attr("data-findCommentNo"));
						formData.append("_csrf", "${_csrf.token}");
						console.log(formData);
						
						$.ajax({
							url : "/jnj/menu/board_find/comment_delete",
							type:"post",
							data:formData,
							processData:false,	// FormData 전송에 필요한 설정
							contentType:false,	// FormData 전송에 필요한 설정
							success:function(findComment) {
								console.log(findComment);
								printReply(findComment);
							}
						});
						location.reload();
					}
					
				
					
			});

/* ======================================================================================================================================= */
			
			// 댓글 수정창으로 변환
			$("#reply").on("click",".updateFindComment", function() {
				console.log("수정 클릭 : " + $(this).attr("data-idx") );
				console.log( $(this).parent().parent().children("td").eq(1).text() );
				
				var td = $(this).parent().parent().children("td").eq(1);
				var str = $(this).parent().parent().children("td").eq(1).text();
				
				$(this).parent().parent().children("td").eq(1).text("");
				
				$("<textarea rows='2' cols='80' id='commentContent' name='commentContent'></textarea>").val(str).appendTo( td );
		
				
				var td1 = $(this).parent().children("button").eq(0).css("display", "none");
				var td2 = $(this).parent().children("button").eq(1).css("display", "none");
				var td3 = $(this).parent().children("button").eq(2).css("display", "block");
				var td4 = $(this).parent().children("button").eq(3).css("display", "block");
				
				
			});
				
			
			
			
			
			
			//댓글 수정
			$(".updateCommentContent").on("click", function() {
				
				var formData = new FormData();
				formData.append("findCommentNo", $(this).attr("data-findCommentNo"));
				formData.append("commentContent", $("#commentContent").val());
				
				formData.append("writeDate", $findComment.writeDate);
				formData.append("_csrf", "${_csrf.token}");
				console.log(formData);
				 
				 $.ajax({
					url : "/jnj/menu/board_find/comment_update",
					type:"post",
					data:formData,
					processData:false,	// FormData 전송에 필요한 설정
					contentType:false,	// FormData 전송에 필요한 설정
					success:function(findComment) {
						console.log(findComment);
						printReply(findComment); 
					}    
				}); 
			alert("댓글이 수정 완료 되었습니다.");	
			location.reload();
			
			}); 
			
			$(".cancel").on("click", function() {
				location.reload();
			})

/* ======================================================================================================================================= */

		// 글 삭제
		$("#findBoardDelete").on("click", function() {
			if (confirm("정말 삭제하시겠습니까??") == true){ 
				
			var $form = $("<form></form>").appendTo("body");
			$form.attr("action", "/jnj/menu/board_find/delete");
			$form.attr("method", "post");
			$("<input>").attr("type","hidden").attr("name","findNo").val($find.findNo).appendTo($form);
			$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
			$form.submit();
			}
		});
			
/* ======================================================================================================================================= */
		
		// 글신고
		console.log($find.findDivision);
		console.log($find.findNo);
		$("#findBoardReport").on("click", function() {
			var formData = new FormData();
			formData.append("findDivision", $find.findDivision);
			formData.append("findNo", $find.findNo);
			formData.append("_csrf", "${_csrf.token}");
			$.ajax({
				url : "/jnj/menu/board_found/report",
				type:"post",
				data:formData,
				processData:false,	// FormData 전송에 필요한 설정
				contentType:false,	// FormData 전송에 필요한 설정
				success:function(reportCnt) {
					console.log(reportCnt);
					$("#reportCnt").text(reportCnt);
				}
			});
		});
		
		
				
/* ======================================================================================================================================= */		
		//  글 수정 하러 jsp 가기
		$("#findBoardUpdate").on("click",function(){
			location.href = "/jnj/menu/board_found/update?findNo="+$find.findNo;
		});
		var fullAddr = $find.addr2;
		viewMap(fullAddr);
		
		function viewMap(fullAddr) {
			  var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		      mapOption = {
		          center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		          level: 3 // 지도의 확대 레벨
		      };  

		  // 지도를 생성합니다    
		  var map = new daum.maps.Map(mapContainer, mapOption); 

		  // 주소-좌표 변환 객체를 생성합니다
		  var geocoder = new daum.maps.services.Geocoder();

		  // 주소로 좌표를 검색합니다
		  geocoder.addressSearch(fullAddr, function(result, status) {

		      // 정상적으로 검색이 완료됐으면 
		       if (status === daum.maps.services.Status.OK) {

		          var coords = new daum.maps.LatLng(result[0].y, result[0].x);

		          // 결과값으로 받은 위치를 마커로 표시합니다
		          var marker = new daum.maps.Marker({
		              map: map,
		              position: coords
		          });

		          // 인포윈도우로 장소에 대한 설명을 표시합니다
		          var infowindow = new daum.maps.InfoWindow({
		              content: '<div style="width:150px;text-align:center;padding:6px 0;">유기(추정) 장소</div>'
		          });
		          infowindow.open(map, marker);

		          // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
		          map.setCenter(coords);
		      } 
		  });
		}
	})
	
	
	
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
	display: block;
}
#container {
	width: 800px;
	margin: 0px 200px 0px 0px;
}
#reply,#commentContent {
	width: 800px;
}
h3{
	color: #7f5926;
}
#table2{
	float: right; 
}
.img-responsive {
	margin: 5px 0px 10px 200px;
}
#state {
	font-size: 3em;
	color: red;
	font-weight: bold;
}

.map_wrap {position:relative;width:100%;height:350px;}
.title {font-weight:bold;display:block;}
.hAddr {position:absolute;left:10px;top:10px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:5px;}
#centerAdd {display:block;margin-top:2px;font-weight: normal;}
.bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}


</style>
</head>
<body>
<h2 id="caca">- 찾았어요</h2>
	<a id="backList" href="/jnj/menu/board_found/list">목록으로</a>
	<br>
	<hr>
<form>





<div class="container" id="container">
	<h3>게시판 : 찾았어요</h3>
	<table id="table2"></table>
	<table class="table table-bordered">
	  	<thead>
	      <tr>
	        <th>구분</th>
	        <td>찾았어요</td>
	        <th id="contentTh">글제목</th>
			<td colspan="3" class="contentTd" id="findTitle"></td>
			<th id="contentTh">작성일</th>
			<td class="writeDate" id="writeDate"></td>
	      </tr>
	      <tr>
	        <th id="contentTh">작성자</th>
			<td class="writeId" id="writeId"></td>
			<th id="contentTh">조회수</th>
			<td class="hits" id="hits"></td>
			<th id="contentTh">종류</th>
			<td class="petSort" id="petSort"></td>
			<th id="contentTh">성별</th>
			<td class="petGender" id="petGender"></td>
	      </tr>
	     </thead>
	</table>

	<p id="state"></p>


	<table id="table"></table>
	  <hr>
	<table class="table">
	  	<thead>
	    	<tr>
				<th id="contentTh">내용</th>
				<td class="contentTd" id="findContent"></td>
			</tr>
			<tr>
				<th id="contentTh">발견한 날짜</th>
				<td class="contentTd" id="findDate"></td>
			</tr>
		
			<tr>
				<th id="contentTh">세부종류</th>
				<td class="contentTd" id="petKind"></td>
			</tr>

			<tr>
				<th id="contentTh">기타사항</th>
				<td class="contentTd" id="petFeature"></td>
			</tr>
			<tr>
			<th id="contentTh">발견 장소</th>
			<td class="contentTd" id="findAddr"></td>
		</tr>
		<tr>
			<td colspan="2" class="contentTd" id="findAddr">
			<div id="map" style="width:600px; height:350px; margin-left: 200px; margin-top: 30px; margin-bottom: 60px;"></div>
			</td>
		</tr>
			
			<!-- <tr>
				<th id="contentTh">센터 주소</th>
				<td class="contentTd" id="centerAddr"></td>
			</tr>
			<tr>
				<td colspan="2" class="contentTd" id="centerAddr">
					<div id="staticMap" style="width:600px;height:350px;"></div>
				</td>
			</tr> -->
		</thead>
	</table>
</div>

	<table class="table" id="reply"></table>
		
	<table>
		<tr>
			<td><textarea style="width: 800px" name="commentContent" rows="3" cols="120" id="commentContent"></textarea></td>
			<td>&emsp;<button style="padding: 21px;" type="button" id="insertComment">댓글 추가</button></td>
		</tr>
	</table>
		
		
</form>
<br><br>

</body>
</html>