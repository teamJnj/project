<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script>
	$(function() {
		var $map = ${map};
		var $list = $map.list;
		var $pagination = $map.pagination;
		var $count = $map.count;
		var $name = ${name};
		
		var $btnNotice = $("#btnNotice");	
		if($name=="admin"){
			$("<button type='submit'></button>").attr("id","write").attr("class","btn btn-default").text("글쓰기").appendTo($btnNotice);
		}
			
			
		var $table = $("table");
		$table.empty();
		$table.append('<colgroup width="10%"/><colgroup width="70%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="20%"/><thead><tr id="tableTrStyle"><th class="th">글번호</th><th class="th">제목</th><th class="th">작성자</th><th class="th">조회</th></tr></thead>');
		$.each($list,
				function(i, $notice) {
					var $tbody = $("<tbody></tbody>").appendTo($table)
					var $tr = $("<tr></tr>").appendTo($tbody);
					$("<td></td>").text($notice.noticeNo).appendTo($tr);
					var $title = $("<td></td>").text($notice.title).appendTo($tr);
					$("<td></td>").text("관리자").appendTo($tr);
					$("<td></td>").text($notice.hits).appendTo($tr);
					var $link = $("<a>").attr("href", "/jnj/menu/board_notice/view?noticeNo="  + $notice.noticeNo );
					$title.wrapInner($link);			
				})
		$("#write").on("click", function() {
		location.href = "/jnj/menu/board_notice/write";
		})


		var ul = $("#pagination");
		var li;
		if($pagination.prev>0) {
			li = $("<li></li>").text('<').appendTo(ul);
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_notice/record?pageno='+ $pagination.prev))
		}
		for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
			li = $("<li></li>").text(i).appendTo(ul);
			if($pagination.pageno==i) 
				li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_notice/record?pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
			else
				li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_notice/record?pageno='+ i))
		}
		if($pagination.next>0) {
			li = $("<li></li>").text('>').appendTo(ul);
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_notice/record?pageno='+ $pagination.next));
		} 
	})
</script>
<style>
	.noticeList{
		margin-top: 100px;
	}
	#tableTrStyle {
		
	}
	.noticeList h3 {
		color: #7F5926;
	}
	table{
		text-align: center;
	}
	.th{
		text-align: center;
	}
	
	#pagination  ul {
		maring: 0;
		padding: 0;
	}
	#pagination li {
		list-style: none;
		float: left;
		width: 35px;
		text-align : center;
		height : 35px;
		line-height: 35px;
		font-size : 0.75em;
		border: 1px solid #ddd;
	}
	#pagination a {
		text-decoration:  none;
		display : block;
		color : #7F5926;
	}
	#pagination a:link, #pagination a:visited {
		color : #7F5926;
	}
	#pagination {
		margin-left: 46%;
		margin-top: 20px;
	}
	#write{
		width:150px;
		float: right;
	}
	
</style>
</head>
<body>
	<div class="container noticeList">
		<h3>공지사항</h3>
		<hr>
		<br><br>
		<table id="table" class="table table-bordered">
		
				<tr>
					<td></td>
				</tr>
		</table>
		
		<br><br>
		<div id="btnNotice"></div>
		<br><br>
		
		<div class="container">
			<ul class="pager" id="pagination">
			
			</ul>
		</div>
		 <br><br><br><br><br><br>
	</div>
</body>
</html>
