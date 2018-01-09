<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
	$(function(){
		
		var findList;
		var imgName;
		var listLength;
		var $map = ${map};
		
		// 최근 본 게시물을 정보를 읽어온다
		$.ajax({
			url : "/jnj/menu/board/current",
			type : "get",
			success:function(result){
				display_setting( result );
			}
		});
		
		// 게시물 클릭 시 뷰로 이동
		$("#currentLine").on("click", ".imgClick", function(){
			var index = 4 - $(this).attr("data-idx");
			console.log( index );
			location.href="/jnj/menu/board/currclick?findNo="+findList[index].findNo+"&check=true";
		});
		
		
		// 이미지 그리기
		var currentLine = $("#currentLine");
		function display_setting( result ){
			
			if( result == "" )
				return;
			
			findList = JSON.parse(result);
			
			imgName = new Array();
			listLength = (findList.length-1);
			
			$.each( findList, function(idx, find){
				console.log( idx );
				imgName[idx] = find.petImg;
			});
			
			$.each( findList, function(idx, find){
				console.log( idx );
				var div = $("<div class='iconDiv'></div>").appendTo(currentLine);
				$("<img src='/jnjimg/find/"+imgName[4-idx]+"' class='imgClick' data-idx='"+idx+"'>").appendTo(div);
			});
			
			display_CSS();
		}
		
		function display_CSS(){
			$(".iconDiv").css({
				"margin-bottom" : "5px"
			});
			
			$(".imgClick").css({
				"width" : "90px",
				"height" : "90px",
			});
		}
		
	});
</script>
</head>
<body>
	
	<div id="currentLine">
		<div style="margin-bottom:10px;">
			<span>최근 본 게시물</span>
		</div>
	</div>
</body>
</html>