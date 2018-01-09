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
		var $search = $map.search;
		var $getVolunteerSearch = $map.getVolunteerSearch;
		var $colName = $map.colName;
		var $sortType = $map.sortType;
		
		
		
		if($search!=null)
			$("#selectFindAddr").val($search).attr("selected", "selected");
		
		var $table = $("#volunteerListTable")
		$table.empty();
		$table.append('<colgroup width="10%"/><colgroup width="10%"/><colgroup width="30%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="10%"/><colgroup width="10%"/><thead><tr id="tableTrStyle"><th class="th">글번호</th><th class="th">지역</th><th class="th">제목</th><th class="th">작성자</th><th class="th">나이제한</th><th class="th">신청인원</th><th class="th">조회</th><th class="th">상태</th></tr></thead>');		
		
		  
		console.log();
		
		display_setting($pagination,$getVolunteerSearch);
		
		
		
		function display_setting(pagination, getVolunteerSearch){
			
			$.each(getVolunteerSearch, function(idx,$volunteer){
				if($volunteer.volunteerDivision==2){
					$volunteer.volunteerDivision="일반회원";
				   } else if($volunteer.volunteerDivision==1) {
					   $volunteer.volunteerDivision="센터회원";
				   }
				var $tbody = $("<tbody></tbody>").appendTo($table)
				var $tr = $("<tr></tr>").appendTo($tbody);
				$("<td></td>").text($volunteer.volunteerNo).appendTo($tr);
				$("<td></td>").text($volunteer.volunteerAddr).appendTo($tr);
				var $title = $("<td></td>").text("["+$volunteer.volunteerDivision+"] "+$volunteer.volunteerTitle).appendTo($tr);
				
				$("<td></td>").text($volunteer.hostId).appendTo($tr);
				var ageLimit = "-";
				if($volunteer.ageLimit>2) ageLimit = $volunteer.ageLimit + "세 이상"
				else ageLimit = "전체이용"
				$("<td></td>").text(ageLimit).appendTo($tr);
				$("<td></td>").text($volunteer.applyPeople+" / "+$volunteer.maxPeople).appendTo($tr);
				$("<td></td>").text($volunteer.hits).appendTo($tr);
				var $link = $("<a>").attr("href", "/jnj/menu/volunteer/view?volunteerNo="  + $volunteer.volunteerNo );
				$title.wrapInner($link);
				var volunteerState = "모집중";
				if($volunteer.detailState==2) volunteerState = "모집완료";
				else if($volunteer.detailState==3) volunteerState = "봉사완료";
				else if($volunteer.detailState==4) volunteerState = "인원미달";
				
				if($volunteer.volunteerState==3) volunteerState="블락";
				
				else if($volunteer.volunteerState==2) volunteerState="취소";
				
				$("<td></td>").text(volunteerState).appendTo($tr);
			})
			var ul = $("#pagination");
			
			var li;
			if($pagination.prev>0) {
				li = $("<li></li>").text('<').appendTo(ul);
				li.wrapInner($("<a></a").attr('href', '/jnj/menu/volunteer/record?pageno='+ $pagination.prev +'&colName='+$colName+'&sortType='+$sortType+'&search='+$search))
			}
			for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
				li = $("<li></li>").text(i).appendTo(ul);
				if($pagination.pageno==i) 
					li.wrapInner($("<a></a").attr('href', '/jnj/menu/volunteer/record?pageno='+ i +'&colName='+$colName+'&sortType='+$sortType+'&search='+$search).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
				else
					li.wrapInner($("<a></a").attr('href', '/jnj/menu/volunteer/record?pageno='+ i +'&colName='+$colName+'&sortType='+$sortType+'&search='+$search))
			}
			if($pagination.next>0) {
				li = $("<li></li>").text('>').appendTo(ul);
				li.wrapInner($("<a></a").attr('href', '/jnj/menu/volunteer/record?pageno='+ $pagination.next +'&colName='+$colName+'&sortType='+$sortType+'&search='+$search));
			}
			
		
		
		
		
		
		}
		//최신순, 센터별, 상태별, 후원금순 정렬 
		function sortSelect($colName, $sortType){
			location.href = "/jnj/menu/volunteer/record?search="+$search+'&colName='+$colName+'&sortType='+$sortType;
			/*
			$.ajax({
				url : "/jnj/menu/volunteer/record",
				type : "get",
				data : formDataSetting(),
				success : function(result){
					console.log(result);
					display_Resetting(result);
				}
			});*/
		}
		// 최신순 정렬
		$("#a1").on("click", function(e){
			e.preventDefault();
			sortSelect("volunteerNo", "desc");
		});
		
		
		// 상태별 정렬
		$("#a3").on("click", function(e){
			e.preventDefault();
			sortSelect("volunteerState", "asc");
		});
		
		/*  $("#selectFindAddr").change(
			function() {
			$search = $("#selectFindAddr option:selected").val();
			location.href = "/jnj/menu/volunteer/record?search="+$search+'&colName='+$colName+'&sortType='+$sortType;
			
		});  */
		 
		 $("#selectFindAddr option:eq("+$search+")").attr("selected","selected");
	      $("#selectFindAddr").change(function(){
	         $search = $("#selectFindAddr option:selected").attr("value");
	         location.href="/jnj/menu/volunteer/record?search="+$search;
	      });
		
		
		// 정렬 시 화면 다시 그리기
		function display_Resetting( result ){
			
			var resultMap = JSON.parse(result);
			console.log("나와랏");
			console.log(resultMap);
			
			// 테이블에 행 모두 지우기
			$("tbody").empty();
			$("#pagination").empty();
			
			display_setting(resultMap.pagination, resultMap.getVolunteerSearch);
		}
		
		function formDataSetting(){
			var form=$("#volunteerForm");
			form.empty();
			
			if( $getVolunteerSearch.colName != null ) $("<input type='hidden' name='colName' value='"+$getVolunteerSearch.colName+"' >").appendTo(form);
			if( $getVolunteerSearch.sortType != null ) $("<input type='hidden' name='sortType' value='"+$getVolunteerSearch.sortType+"' >").appendTo(form);
			if( $getVolunteerSearch.search != null ) $("<input type='hidden' name='search' value='"+$getVolunteerSearch.search+"' >").appendTo(form);
			if( $getVolunteerSearch.startArticleNum != null ) $("<input type='hidden' name='startArticleNum' value='"+$getVolunteerSearch.startArticleNum+"' >").appendTo(form);
			if( $getVolunteerSearch.endArticleNum != null ) $("<input type='hidden' name='endArticleNum' value='"+$getVolunteerSearch.endArticleNum+"' >").appendTo(form);
			var result=form.serialize();
			return result;
			
			
		}
		
		$("#write").on("click", function() {
			location.href = "/jnj/menu/volunteer/write";
		}) 
		
		
	})
</script>
<style>
	.volunteerList{
		margin-top: 30px;
	}
	#tableTrStyle {
		
	}
	.volunteerList h3 {
		color: #7F5926;
	}
	table{
		text-align: center;
	}
	.volunteerServeListForm{
		margin-left: 46%;
		margin-top: 20px;
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
	#search{
		background-color: #FFB24C;
		color: #7F5926;
	}
 	#selectFindAddr{
 		display: inline-block;
 		width: 150px;
		margin-left: 45%;
	} 
	
</style>
</head>
<body>
	<div class="container volunteerList">
		<h3>모집 : 봉사</h3>
		<hr>
		<br>
		<div class="volunteerDiv1 pull-right" style="margin-bottom: 10px;">
		<a href="#" id="a1">최신순</a>&emsp; <a href="#" id="a3">상태별</a>
		</div>
		<table class="table table-bordered" id="volunteerListTable">
		
				<tr>
					<td></td>
				</tr>
		</table>
		<br>
		<div>
			<select class="form-control" id="selectFindAddr" name="search" >
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
				<option value="전남">전남</option>
				<option value="경북">경북</option>
				<option value="경남">경남</option>
				<option value="제주">제주</option>
			</select>
		</div>
          <br><br>
		<div class="form-group">
			<button id="write" type="submit" class="btn btn-default">글쓰기</button>
		</div>
        </div>
        
		<br><br>
		
		
		<div class="container">
			<ul class="pager" id="pagination">
			
			</ul>
		</div>
		<form id="volunteerForm"></form>
		<br><br><br><br><br><br>
	
</body>
</html>