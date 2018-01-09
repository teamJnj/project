<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	
	<script>
	
		$(function(){
			
			var tempMap = ${map};
			var $info;
			var $member;
			var $qnaList;
			var $paginationn;
			var $state1;
			var $state2;
			
			initValues( tempMap );
			display_setting( 0 );
			display_Search();
			display_CSS();
			
			$("#totalBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "answerContent", "");
			});
			
			$("#processBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "answerContent", "0");		
			});
			
			$("#completBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "answerContent", "1");
			});
			
			// 전체보기 정렬
			$("#qTotal").on("click", function(e){
				e.preventDefault();
				$info.colName = null;
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				sortSelect();
			});
			
			// 최신순 정렬
			$("#qCurrent").on("click", function(e){
				e.preventDefault();
				$info.colName = "writeDate";
				sortSelect();
			});
			
			// 상태별 정렬
			$("#qState").on("click", function(e){
				e.preventDefault();
				$info.colName = "answerContent";
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
				$info.searchText = "%";
				
				// 현재 무엇을 검색했는지 판단하고 검색한 값을 가져온다
				$info.searchColName = $("#mSelect option:selected").val();
				if( selectbox == "qnaTitle" ){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "answerContent"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "writeDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				$.ajax({
					url 	: "/jnj/admin/member_qna/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function( result ){
						display_Resetting(result);
					}
				});
			});
			
			
			// 페이지 변경 시
			$(".pagination").on("click", "a[class=page-link]", function(e){
				e.preventDefault();
				$info.pageno = $(this).attr("data-page");
				location.href="/jnj/admin/member_qna?"+formDataSetting();
			});
			
			
			// 상세보기 클릭 시
			$("#qnaTable").on("click", ".titleClick", function(){
				console.log( "상세보기 클릭 : " + $(this).attr("data-idx") );
				console.log( "상세보기 클릭 : " + $qnaList[$(this).attr("data-idx")].qnaNo );
				console.log( "상세보기 클릭 : " + $member.memberId );
				location.href="/jnj/admin/member_qna/view?qnaNo="+$qnaList[$(this).attr("data-idx")].qnaNo+"&writeId="+$member.memberId;
			});
			
			// 변수 초기화
			function initValues( map ){
				
				$info = map.adMQnaInfo;
				
				$member = map.member;
				$info.writeId = $member.memberId;
				$info.memberId = $member.memberId;
				
				$qnaList = map.qnaList;
				$pagination = map.pagination;
				
				$state1 = map.stateCount1;
				$state2 = map.stateCount2;
				
				console.log($state1);
				console.log($state2);
			}
	
	
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#qnaTable").DataTable({
						"paging": false,
						"searching": false,
						"ordering" : false,
						"columns": [
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false }
						]
					});
				}
				
				
				// 행 추가
				$.each($qnaList, function(idx, qna) {
					
					table.row.add( [
						currentQnaDivision(qna.qnaDivision),
						"<a href='#' class='titleClick' data-idx='"+idx+"'>" + qna.qnaTitle + "</a>",
						qna.writeId,
						qna.writeDate,
						currentAnswerState(qna.answerContent)
			        ]).draw(false);
					
				});
				
				var totalCnt = 0;
				$.each( $state1, function(idx, state){
					if( state.ANSWERCONTENT == null || state.ANSWERCONTENT == "")
						$("#process").text(state.COUNT+"건");
					totalCnt += state.COUNT;
				});
				$.each( $state2, function(idx, state){
					if( state.ANSWERCONTENT != null || state.ANSWERCONTENT != "")
						$("#complet").text(state.COUNT+"건");
					totalCnt += state.COUNT;
				});
				$("#total").text( totalCnt+"건" );
				
				
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
			function display_Resetting( resultMap ){
				
				var resultMap = JSON.parse(resultMap);
				
				console.log(resultMap);
				
				// 테이블에 행 모두 지우기
				$("tbody>tr").each(function(idx){
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
				
				if( select != "answerContent" && $info.searchColName == "answerContent" )
					$info.searchText = "%";
				
				if( select == "qnaTitle" ){
					selectTextDiv.show();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				else if( select == "answerContent" ){
					selectTextDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value=''>전체</option>").appendTo( selectbox );
					$("<option value='0'>처리중</option>").appendTo( selectbox );
					$("<option value='1'>처리완료</option>").appendTo( selectbox );
					
					$("#selectedOption").val(($info.searchText == "%")?"0":$info.searchText).attr("selected", "selected");
					
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
				$info.sortType = (( $info.sortType  == null )?"asc" : (( $info.sortType  == "desc")? "asc" : "desc"));
								
				$.ajax({
					url 	: 	"/jnj/admin/member_qna/sort",
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
				
				if( $info.memberId != null ) $("<input type='hidden' name='writeId' value='"+$info.memberId+"' >").appendTo( form );
				if( $info.memberId != null ) $("<input type='hidden' name='memberId' value='"+$info.memberId+"' >").appendTo( form );
				if( $info.memberId != null ) $("<input type='hidden' name='qnaDivision' value='"+$info.qnaDivision+"' >").appendTo( form );
				if( $info.pageno != null ) $("<input type='hidden' name='pageno' value='"+$info.pageno+"' >").appendTo( form );
				if( $info.colName != null ) $("<input type='hidden' name='colName' value='"+$info.colName+"' >").appendTo( form );
				if( $info.sortType != null ) $("<input type='hidden' name='sortType' value='"+$info.sortType+"' >").appendTo( form );
				if( $info.searchColName != null ) $("<input type='hidden' name='searchColName' value='"+$info.searchColName+"' >").appendTo( form );
				if( $info.searchText != null ) $("<input type='hidden' name='searchText' value='"+$info.searchText+"' >").appendTo( form );
				if( $info.startMoney != null ) $("<input type='hidden' name='startMoney' value='"+$info.startMoney+"' >").appendTo( form );
				if( $info.endMoney != null ) $("<input type='hidden' name='endMoney' value='"+$info.endMoney+"' >").appendTo( form );
				if( $info.startDate != null ) $("<input type='hidden' name='startDate' value='"+$info.startDate+"' >").appendTo( form );
				if( $info.endDate != null ) $("<input type='hidden' name='endDate' value='"+$info.endDate+"' >").appendTo( form );
				if( $info.sqlText != null ) $("<input type='hidden' name='sqlText' value='"+$info.sqlText+"' >").appendTo( form );
				if( $info.startArticleNum != null ) $("<input type='hidden' name='startArticleNum' value='"+$info.startArticleNum+"' >").appendTo( form );
				if( $info.endArticleNum != null ) $("<input type='hidden' name='endArticleNum' value='"+$info.endArticleNum+"' >").appendTo( form );
				
				var result = form.serialize();
				form.empty();
				
				return result;
			}
			
			
			function currentQnaDivision( qnaDivision ){
				var str = "센터회원";
				if( qnaDivision == 1 )
					str = "일반회원";
				return str;
			}
			
			function currentAnswerState( answerContent ){
				var str = "처리완료";
				if( answerContent == null )
					str = "처리중";
				return str;
			}
			
		function searchState(colName, find){
				
				$info.searchColName = colName;
				$info.searchText = find;
				
				$.ajax({
					url 	: "/jnj/admin/member_qna/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function( result ){
						display_Resetting(result);
					}
				});
			}
			
			
		});
		
	</script>
</head>
<body>
    
    <div id="scorpTotal">
    	<div id="tableTotal">
    		
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> QnA </div>
				<div class="card-body">
				
					<div id="totlaNumDiv">
						<div class="alert alert-success" id="totalBtn">
	                    	<span>전체 : </span>
	                    	<span id="total">0건</span>
	                    </div>
	                    
                    	<div class="alert alert-success" id="processBtn">
	                    	<span>처리중 : </span>
	                    	<span id="process">0건</span>
	                    </div>
	                    
	                    <div class="alert alert-success" id="completBtn">
	                    	<span>처리완료 : </span>
	                    	<span id="complet">0건</span>
	                    </div>
                     </div>
				
					<div id="ssnav" style="background-color:white; overflow:hidden;">
						
						<ol id="sortQna" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="qTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="qCurrent" href="#">최신순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="qState" href="#">상태별</a>
							</li>
						</ol>
			    	</div>
    	
					<table id="qnaTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th style="width:100px;">분류</th>
					            <th>제목</th>
					            <th style="width:80px;">작성자</th>
					            <th style="width:80px;">날짜</th>
					            <th style="width:80px;">처리상태</th>
					        </tr>
					    </thead>
					</table>
					
				</div>
			</div>
		</div>
		
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="qnaTitle">제목</option> 
					<option value="answerContent">상태</option> 
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
	
			<br>
	        
	        <form action="/jnj/member/search" method="post" id="searchFrm" class="form-inline my-2 my-lg-0 mr-lg-2">
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
		</div>
	</div>
	    		
</body>
</html>