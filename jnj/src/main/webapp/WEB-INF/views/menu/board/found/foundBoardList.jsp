<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	$(function() {
		
		var $map = ${map};
		var $petSort = $map.petSort
		var $firstAddr = $map.firstAddr;
		var $list = $map.list;
		var $findList = $map.getFindList;
		
		console.log($map);
		console.log($map.list);
		console.log($firstAddr);
		console.log($petSort);
		console.log($findList);
		//var $petsSort = $list.sPetSort;

		var $pagination = $map.pagination;

		var $thumbnails = $("#findList");

		
		//필터시작~
		// PetSort가 int인 경우
		
		
		
		if($petSort!=null)
			$("#selectPetSort option:eq("+$petSort+")").attr("selected","selected");
		if($firstAddr!=null)
			$("#selectFindAddr").val($firstAddr).attr("selected", "selected");
		
		
		
		$("#selectPetSort").change(function() {
					$petSort = $("#selectPetSort option:selected").val();
					$firstAddr = $("#selectFindAddr option:selected").val();

					location.href = "/jnj/menu/board_found/view_filter?petSort="+$petSort+"&firstAddr="+$firstAddr;
				});

		$("#selectFindAddr").change(
				function() {
					$petSort = $("#selectPetSort option:selected").val();
					$firstAddr = $("#selectFindAddr option:selected").val();

					location.href = "/jnj/menu/board_found/view_filter?petSort="	+ $petSort + "&firstAddr=" + $firstAddr;
				});
		//필터끝~
		
		
		
		var $table = $("table");
		$table.empty();
		$.each($findList,function(i, $find) {
			var $colMd = $("<div class='col-md-3'></div>").appendTo($thumbnails);
			var $classThumbnail = ($("<div class='thumbnail'></div>")).appendTo($colMd);
			var $a = $("<a></a>").attr("href","/jnj/menu/board_found/view?" + "findNo="+ $find.findNo + "&findDivision="+ $find.findDivision).appendTo($classThumbnail);
			$("<img class='img-responsive' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/find/" + $find.petImg).appendTo($a);

			var $caption = $("<div class='caption'></div>").appendTo($classThumbnail);

			$("<p></p>").text("제목 : " + $find.findTitle).appendTo($caption);
			$("<p></p>").text("지역 : " + $find.findAddr).appendTo($caption);
			$("<p></p>").text("등록일자 : " + $find.writeDate).appendTo($caption);


			var $findViewBtn = $("<p align='center'></p>").appendTo($caption);
			$("<a class='btn btn-block' id='boardFindViewBtn'></a>").attr("href","/jnj/menu/board_found/view?"+ "findNo=" + $find.findNo+ "&findDivision="+ $find.findDivision).text("상세보기").appendTo($findViewBtn);
		})
		// 글보기 하나 each로 돌려서 리스트 쫙
		$.each(	$list,function(i, $find) {
				var $colMd = $("<div class='col-md-3'></div>").appendTo($thumbnails);
				var $classThumbnail = ($("<div class='thumbnail'></div>")).appendTo($colMd);
				var $a = $("<a></a>").attr("href","/jnj/menu/board_found/view?" + "findNo="+ $find.findNo + "&findDivision="+ $find.findDivision).appendTo($classThumbnail);
				$("<img class='img-responsive' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/find/" + $find.petImg).appendTo($a);
	
				var $caption = $("<div class='caption'></div>").appendTo($classThumbnail);
	
				$("<p></p>").text("제목 : " + $find.findTitle).appendTo($caption);
				$("<p></p>").text("지역 : " + $find.findAddr).appendTo($caption);
				$("<p></p>").text("등록일자 : " + $find.writeDate).appendTo($caption);
	
	
				var $findViewBtn = $("<p align='center'></p>").appendTo($caption);
				$("<a class='btn btn-block' id='boardFindViewBtn'></a>").attr("href","/jnj/menu/board_found/view?"+ "findNo=" + $find.findNo+ "&findDivision="+ $find.findDivision).text("상세보기").appendTo($findViewBtn);
	
			});
		
		
		// 글쓰기 페이지로 ㄱㄱ
		$("#write").on("click", function() {
			location.href = "/jnj/menu/board_found/write";
		})

		// pagination
		var ul = $("#pagination");
		var li;

		if ($pagination.prev > 0) {
			li = $("<li></li>").text('이전').appendTo(ul);
			li.wrapInner($("<a></a>").attr('href',	'/jnj/menu/board_find/list?pageno=' + $pagination.prev));
		}

		// 해당페이지 css 변경하는 for문 , 시작번호 끝나는 번호까지 버튼 뿌리기
		for (var i = $pagination.startPage; i <= $pagination.endPage; i++) {

			li = $("<li></li>").text(i).appendTo(ul);
			
			if($firstAddr==null && $petSort==null) {
				li.wrapInner($("<a></a>").attr('href','/jnj/menu/board_found/list?&pageno='+i).css({"background-color" : "#337ab7","border" : "1px solid #337ab7","color" : "white"	}));
			} else {
				if ($pagination.pageno == i )
					li.wrapInner($("<a></a>").attr('href','/jnj/menu/board_found/view_filter?petSort='+$petSort+ '&firstAddr=' + $firstAddr +'&pageno=' + i).css({"background-color" : "#337ab7","border" : "1px solid #337ab7","color" : "white"	}));
				else
					li.wrapInner($("<a></a>").attr('href','/jnj/menu/board_found/view_filter?petSort='+$petSort+ '&firstAddr=' + $firstAddr +'&pageno=' + i));
			}
		}

		if ($pagination.next > 0) {
			li = $("<li></li>").text('다음').appendTo(ul);
			li.wrapInner($("<a></a>").attr('href','/jnj/menu/board_found/list?pageno=' + $pagination.next));
		}

	});
</script>
<title>findBoardList</title>
<style type="text/css">
#pagination  ul {
	maring: 0;
	padding: 0;
}

#pagination li {
	list-style: none;
	float: left;
	width: 35px;
	text-align: center;
	height: 35px;
	line-height: 35px;
	font-size: 0.75em;
	border: 1px solid #ddd;
}

#pagination a {
	text-decoration: none;
	display: block;
	color: #337ab7;
}

#pagination a:link, #pagination a:visited {
	color: #337ab7;
}

#pagination {
	margin-top: 20px;
}

#clear {
	clear: both;
}

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

#fPagination {
	text-align: right;
}

#selectPetSort {
	float: right;
	margin-right: 70px;
}

#selectPetState, #selectCenterAddr {
	float: right;
	margin-right: 10px;
}
#pagination {
       margin-left: 46%;
      margin-top: 20px; 
   }
#write {
	margin-left: 90%;
	margin-top: 5px;
}
.caption p{
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
}
section {
	margin-right: 150px;
}
#currentClick{
	position: fixed;
	width: 100px;
	height: 485px;
	left: 90%;
	top: 30%;
}
</style>
</head>
<body>

	<h2 id="caca">- 찾았어요</h2>
	<a id="backList" href="/jnj/menu/board_found/list">목록으로</a>
	<br>
	<hr>







	<!-- 필터 -->
	<div id="fPagination">
		<div>
			<select id="selectPetSort">
				<option value="0">종류전체</option>
				<option value="1">강아지</option>
				<option value="2">고양이</option>
				<option value="3">기타</option>
			</select>
		</div>

		<div>
			<select id="selectFindAddr" >
				<option value="전체">지역전체</option>
				<option value="서울">서울</option>
				<option value="부산">부산</option>
				<option value="대구">대구</option>
				<option value="인천">인천</option>
				<option value="광주">광주</option>
				<option value="대전">대전</option>
				<option value="울산">울산</option>
				<option value="경기">경기</option>
				<option value="강원">강원</option>
				<option value="충북">충북</option>
				<option value="충남">충남</option>
				<option value="전북">전북</option>
				<option value="전남">전남</option>
				<option value="경북">경북</option>
				<option value="경남">경남</option>
				<option value="제주">제주</option>
			</select>
		</div>
	</div>
	<hr>














	<div class="row">
		<ul class="thumbnails" id="findList">


		</ul>
	</div>
	<div id="pagination">
		<ul>
		</ul>
	</div>
	<div id="clear"></div>
	<button id="write">글 작성</button><Br><br>
	
	<div id="currentClick">
		<jsp:include page="../currView.jsp"></jsp:include>
	</div>
</body>
</html>