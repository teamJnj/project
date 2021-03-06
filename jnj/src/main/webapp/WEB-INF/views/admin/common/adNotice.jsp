<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>Admin Base Page</title>
	<script>
	
	$(function(){
		
		var modalBody = $("#modalBody");
		
		var tempMap = ${map};
		var $noticeList;
		var $info;
		var $pagination;
		
		initValues( tempMap );
		display_setting( 0 );
		display_Search();
		display_CSS();
		
		
		// 전체보기
		$("#aTotal").on("click", function(e){
			e.preventDefault();
			$info.colName = null;
			$info.sortType = null;
			$info.searchColName = null;
			$info.searchText = null;
			sortSelect();
		});
		
		// 조회수 정렬
		$("#aHits").on("click", function(e){
			e.preventDefault();
			$info.colName = "hits";
			sortSelect();
		});
		
		// 날짜 정렬
		$("#aWriteDate").on("click", function(e){
			e.preventDefault();
			$info.colName = "writeDate";
			sortSelect();
		});
		
		
		// 검색 selectbox가 바뀔 때
		$("#mSelect").change(function(){
			
			// 검색 내용 부분 초기화 시켜주기 
			$info.searchText = "%";
			$("#searchText").val("");
			$("#searchMoney1").val("");
			$("#searchMoney2").val("");
			$("#searchDate1").val("");
			$("#searchDate2").val("");
			
			display_Search();
			display_CSS();
		});
		
		
		// 검색 버튼을 클릭 시
		$("#searchBtn").on( "click", function (){
			
			var selectbox = $("#mSelect").val();
			
			// 현재 무엇을 검색했는지 판단하고 검색한 값을 가져온다
			$info.searchColName = $("#mSelect option:selected").val();
			
			if( selectbox == "titleContent"){
				$info.searchText = $("#searchText").val();
				console.log("sdsdsd : " + $("#searchText").val());
			}
			else if( selectbox == "writeDate"){
				$info.startDate = $("#searchDate1").val();
				$info.endDate = $("#searchDate2").val();
			}
			
			$.ajax({
				url 	: "/jnj/admin/notice/sort",
				type 	: "get", 
				data	: formDataSetting(),
				success : function(result){
					 display_Resetting( result );
				}
			});
		});
		
		// 글쓰기
		$("#writeBtn").on("click", function(){
			window.open("/jnj/admin/notice/write", 
					"관리자 - 공지쓰기", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
		});
		
		// 상세뷰로
		$("#adoptTable").on("click", ".titleClick",function(){
			window.open("/jnj/admin/notice/view?noticeNo="+$noticeList[$(this).attr("data-idx")].noticeNo, 
					"관리자 - 공지 뷰", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
		});
		
		// 수정
		$("#adoptTable").on("click", ".updateClick",function(){
			window.open("/jnj/admin/notice/update?noticeNo="+$noticeList[$(this).attr("data-idx")].noticeNo, 
					"관리자 - 공지수정", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
		});
		
		// 삭제
		$("#adoptTable").on("click", ".deleteClick", function(){
			console.log("여기");
			$.ajax({
				url 	: "/jnj/admin/notice/delete",
				type 	: "post", 
				data	: {
					"noticeNo" : $noticeList[$(this).attr("data-idx")].noticeNo,
					'${_csrf.parameterName}' : '${_csrf.token}'
				},
				success : function(result){
					 location.reload();
				}
			});
		});
		
		
		// 변수 초기화
		function initValues( map  ){
			
			$noticeList = map.noticeList;
			$info = map.adNoticeInfo;
			$pagination = map.pagination;
			
			console.log( map );
			
		}
		
		// 화면 셋팅
		function display_setting( state ){
			
			if( state == 0 ){
				table = $("#adoptTable").DataTable({
					"paging": false,
					"searching": false,
					"ordering" : false,
					"columns": [
						{ "orderable": false },
						{ "orderable": false },
						{ "orderable": false },
						{ "orderable": false },
						{ "orderable": false },
						{ "orderable": false }
					]
				});
			}
			
			$.each($noticeList, function(idx, notice) {
				
				table.row.add( [
					idx+1,
					"<a href='#' class='titleClick' data-idx='"+idx+"'>"+notice.title+"</a>",
					"관리자",
					notice.hits,
					notice.writeDate,
					"<a href='#' class='updateClick' data-idx='"+idx+"'>수정</a>"
						+"<br>"
						+"<a href='#' class='deleteClick' data-idx='"+idx+"'>삭제</a>"
		        ]).draw(false);
				
			});
			
			// 페이지네이션
			var ul = $(".pagination");
			ul.empty();
			
			if( $pagination.prev > -1 ){
				var li = $("<li class='paginate_button page-item previous' id='dataTable_previous'></li>").appendTo(ul);
				$("<a href='#' class='page-link' data-page="+$pagination.prev+">Previous</a>").appendTo(li);
			}
			for( var i=$pagination.startPage; i<=$pagination.endPage; i++ ){
				var li = $("<li class='pagination_button page_item active'></li>").appendTo(ul);
				$("<a href='#' class='page-link' data-page="+i+">"+i+"</a>").appendTo(li);
			}
			if( $pagination.next > -1 ){
				var li = $("<li class='paginate_button page-item next' id='dataTable_next'></li>").appendTo(ul);
				$("<a href='#' class='page-link' data-page="+$pagination.next+">Next</a>").appendTo(li);
			}
		}
		
		// 정렬 시 화면 다시 그리기
		function display_Resetting( result ){
			
			var resultMap = JSON.parse(result);
			
			console.log(resultMap);
			
			// 테이블에 행 모두 지우기
			$("tbody>tr").each(function(){
				table .row( $(this) ).remove().draw();
			});
			
			initValues( resultMap );
			display_setting( 1 );
			display_Search();
			display_CSS();
			
		}

		
		// 검색내용 선택에 따라 검색창 모양 바꿔주기 
		function display_Search(){
			
			var select = $("#mSelect").val();
			var selectTextDiv = $("#searchTextDiv");
			var selectDateDiv = $("#searchDateDiv");
			var selectboxDiv = $("#searchOptionDiv");
			var selectbox = $("#selectedOption");
			selectbox.empty();
			
			if( select == "titleContent" ){
				selectTextDiv.show();
				selectDateDiv.hide();
				selectboxDiv.hide();
			}
			else{
				selectTextDiv.hide();
				selectDateDiv.show();
				selectboxDiv.hide();
			}										
		}
		
		// 화면 스타일 모음
		function display_CSS(){
			
			// 검색창, 셀렉트박스 스타일
			$("#searchDiv").css({
				"display"	: "inline-block",
				"float"		: "left"
			});
			
			$("#selectDiv").css({
				"display"	: "inline-block",
				"float"		: "left"
			});
			
			$( "#searchSelectDiv" ).css({
				"display" 	: "inline-block",
				"margin"	: "20px",
				"position" 	: "relative",
				"left" 		: "50%"
			}).css( "margin-left", (Math.ceil($("#searchSelectDiv").width()/2*-1)+"px") );
			
			// 페이지네이션 스타일
			// 인라인블락이랑 같이 width를 주니까 사이즈가 인라인블락 전 사이즈로 먹어서 따로 뺌
			$( "#pageDiv" ).css({
				"overflow"	: "hidden",
				"display" 	: "inline-block",
				"margin": "20px",
				"position" 	: "relative",
				"left" 		: "50%"
			}).css( "margin-left", (Math.ceil($("#pageDiv").width()/2*-1)+"px") );
			
			
			$( ".modal-dialog" ).css({
				"text-align"	: "center",
				"position"	: "relative",
				"margin-top" : ((screen.height/2)-30-55)+"px"
			});
			
			$("#totlaNumDiv span").css({
				"font-size":"13px",
				"font-weight":"bold"
			});
			
			$(".alert").css({
				"display":"inline-block",
				"margin-right" : "13px"
			});
			
		}

		
		// 정렬 눌렀을 때 동작
		function sortSelect(){
			$info.pageno = 1;
			$info.sortType = ( $info.sortType ) =="desc"? "asc" : "desc";
			
			$.ajax({
				url 	: 	"/jnj/admin/notice/sort",
				type	: 	"get",
				data	: 	formDataSetting(),
				success : function(result){
					display_Resetting(result);
				}
			});
		}
		
		// 필요한 데이터를 폼으로 미리 셋팅하고 전체를 넘겨준다,
		function formDataSetting(){
			
			var form = $("#searchFrm");
			form.empty();
			
			if( $info.memberId != null ) $("<input type='hidden' name='memberId' value='"+$info.memberId+"' >").appendTo( form );
			if( $info.pageno != null ) $("<input type='hidden' name='pageno' value='"+$info.pageno+"' >").appendTo( form );
			if( $info.colName != null ) $("<input type='hidden' name='colName' value='"+$info.colName+"' >").appendTo( form );
			if( $info.sortType != null ) $("<input type='hidden' name='sortType' value='"+$info.sortType+"' >").appendTo( form );
			if( $info.searchColName != null ) $("<input type='hidden' name='searchColName' value='"+$info.searchColName+"' >").appendTo( form );
			if( $info.searchText != null ) $("<input type='hidden' name='searchText' value='"+$info.searchText+"' >").appendTo( form );
			if( $info.searchText != null ) $("<input type='hidden' name='startDate' value='"+$info.startDate+"' >").appendTo( form );
			if( $info.searchText != null ) $("<input type='hidden' name='endDate' value='"+$info.endDate+"' >").appendTo( form );
			if( $info.sqlText != null ) $("<input type='hidden' name='sqlText' value='"+$info.sqlText+"' >").appendTo( form );
			if( $info.startArticleNum != null ) $("<input type='hidden' name='startArticleNum' value='"+$info.startArticleNum+"' >").appendTo( form );
			if( $info.endArticleNum != null ) $("<input type='hidden' name='endArticleNum' value='"+$info.endArticleNum+"' >").appendTo( form );
			
			var result = form.serialize();
			form.empty();
			
			return result;
		}
		
	});
	
	
    </script>
</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
 
	<div class="content-wrapper">
    	<div class="container-fluid">
    	
    		<div id="tableTotal">
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 공지사항 </div>
				<div class="card-body">
				
					<div id="aanav" style="background-color:white; overflow:hidden;">
						<ol id="sortAdopt" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="aTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aHits" href="#">조회수순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aWriteDate" href="#">날짜순</a>
							</li>
						</ol>
			    	</div>
					
					<table id="adoptTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th style="width:80px;">글번호</th>
					        	<th>제목</th>
					            <th style="width:80px;">작성자</th>
					            <th style="width:80px;">조회수</th>
					            <th style="width:100px;">날짜</th>
					            <th style="width:80px;">기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		
		<div id="menuDiv" style="float:right; margin-right:50px;">
	    		<button type="button" class="btn btn-warning" id="writeBtn">글쓰기</button>
	    </div>
	    	
		<div id="searchSelectDiv">
		
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="titleContent">제목/내용</option> 
					<option value="writeDate">날짜</option> 
				</select>
			</div>
			<div id="searchDiv">
		    	<div class="input-group">
		        	
		        	<div id="searchTextDiv" class="input-group">
		             	<input id="searchText" class="form-control" type="text" placeholder="Search for...">
		            </div>
		             	
		            <div id="searchDateDiv" class="input-group">
		            	<input id="searchDate1" class="form-control" type="date">~<input id="searchDate2" class="form-control" type="date">
		            </div>
		             	
		            <div id="searchOptionDiv" class="input-group">
			           	<select id="selectedOption" class="form-control">
			           	</select>
		            </div>
		            
		            <span class="input-group-btn" class="input-group">
			           	<button id="searchBtn" class="btn btn-primary" type=button><i class="fa fa-search"></i></button>
		            </span>
		    	</div>
	        </div>
	        
	        <br>
	
	        <div id="pageDiv">
				<ul class="pagination">
				</ul>
			</div>
			
		</div>
			
			
    	</div><!-- container-fluid -->
    </div><!-- content-wrapper -->
    
    <br>
		
		<form id="searchFrm" class="form-inline my-2 my-lg-0 mr-lg-2">
		</form>
		
		<br>
		
		<form id="infoFrm" class="form-inline my-2 my-lg-0 mr-lg-2">
		</form>
		
		<br>
		
    <div id="modelTotal">
		<div class="modal fade" id="myModal" role="dialog" data-backdrop="static" >
			<div class="modal-dialog">
				<div id="test">
					<div class="modal-content">
						<div class="modal-body" id="modalBody">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
     
</body>
</html>