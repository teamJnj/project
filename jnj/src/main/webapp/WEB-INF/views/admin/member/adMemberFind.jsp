<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	
	<script>
	
		$(function(){
			
			var table;
			var modalBody = $("#modalBody");
			
			var TYPE_FIND 		= 1;
			var TYPE_FOUND 		= 2;
			
			var strBtn = "";		// 게시글 블락 상태에 따라 버튼 생성
			
			var tempMap = ${map};
			var $memberFindList;
			var $info;
			var $pagination;
			var $member;
			var $state;
			
			
			initValues( tempMap );
			display_setting(0);
			display_Search();
			display_CSS();
			
			
			
			$("#sTotalBtn").on("click", function(e){
				$info.pageno = 1;
				searchState("findState", "");
			});
			$("#sBlockBtn").on("click", function(e){
				$info.pageno = 1;
				searchState("findState", "0");
			});
			$("#sShowBtn").on("click", function(e){
				$info.pageno = 1;
				searchState("findState", "1");
			});
			
			
			$("#commentBtn").on("click", function(e){
				location.href="/jnj/admin/member_find/comment?memberId="+$member.memberId;
			});
			
			
			$("#fFind").on("click", function(e){
				e.preventDefault();
				$("#currentPage").text( "찾아요 게시글" );
				$info.colName = "writeDate";
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				$info.type = TYPE_FIND;
				sortSelect();
			});
			
			$("#fFound").on("click", function(e){
				e.preventDefault();
				$("#currentPage").text( "찾았어요 게시글" );
				$info.colName = "writeDate";
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				$info.type = TYPE_FOUND;
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
			
			$("#findTable").on("click", ".findview", function(){
				console.log("게시글 상세보기");
				console.log( $memberFindList[$(this).attr("data-idx")] );
				
				if( $memberFindList[$(this).attr("data-idx")].findDivision <= 1 ){
					window.open("/jnj/admin/member_find/view?findNo="+$memberFindList[$(this).attr("data-idx")].findNo, 
						"관리자 - 찾아요 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
				}
				else
					window.open("/jnj/admin/member_found/view?findNo="+$memberFindList[$(this).attr("data-idx")].findNo, 
							"관리자 - 찾았어요 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			
			})
			
			
			// 검색 버튼을 클릭 시
			$("#searchBtn").on( "click", function (){
				
				var selectbox = $("#mSelect").val();
				$info.searchText = "%";
				
				// 현재 무엇을 검색했는지 판단하고 검색한 값을 가져온다
				$info.searchColName = $("#mSelect option:selected").val();
				if( selectbox == "findState"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "writeDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				else if( selectbox == "findTitle" || selectbox == "commentNum" || selectbox == "reportCnt"){
					$info.searchText = $("#searchText").val();
				}
				
				$.ajax({
					url 	: "/jnj/admin/member_find/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 display_Resetting( result );
					}
				});
			});
			
			
			// 페이지 변경 시
			$(".pagination").on("click", "a[class=page-link]", function(e){
				e.preventDefault();
				$info.pageno = $(this).attr("data-page");
				location.href="/jnj/admin/member_find?"+formDataSetting();
			});
			
			
			// 게시글 삭제 클릭 시
			$("#findTable").on("click", ".deleteBtn", function(){
				
				console.log( "게시글 삭제 : " + $(this).attr("data-idx") );
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("글을 삭제하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='deleteModalBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>삭제</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			$("#myModal").on("click", "#deleteModalBtn", function(){
				
				var url = "";
				var index = $(this).attr("data-idx");
				var form = $("#infoFrm");
				form.empty();
				
				$("<input type='hidden' name='findDivision' value='"+ $memberFindList[index].findDivision +"'>").appendTo(form);
			    $("<input type='hidden' name='findNo' value='"+ $memberFindList[index].findNo +"'>").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	url = formDataSetting()+"&"+form.serialize();
		    	form.empty();
		    	
		    	$.ajax({
					url : "/jnj/admin/member_find/delete",
					type : "post",
					data : url,
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
			});
			
			
			// 블락 클릭 시
			$("#findTable").on("click", ".blockBtn", function(){

				console.log( "게시글 블락 : " + $(this).attr("data-idx") );
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("블락 하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='blockModalBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>블락</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
		    	
			});
			$("#myModal").on("click", "#blockModalBtn", function(){
				var url = "";
				var index = $(this).attr("data-idx");
				var form = $("#infoFrm");
				form.empty();
				
				$("<input type='hidden' name='findDivision' value='"+ $memberFindList[index].findDivision +"'>").appendTo(form);
			    $("<input type='hidden' name='findNo' value='"+ $memberFindList[index].findNo +"'>").appendTo(form);
			    $("<input type='hidden' name='findState' value='0'>").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	url = formDataSetting()+"&"+form.serialize();
		    	form.empty();
		    	
		    	$.ajax({
					url : "/jnj/admin/member_find/block",
					type : "post",
					data : url,
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
			});
			
			
			// 블락해제 클릭 시
			$("#findTable").on("click", ".blockBackBtn", function(){

				console.log( "게시글 블락취소 : " + $(this).attr("data-idx") );
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("블락을 취소 하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='blockBackModalBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>블락해지</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				
			});
			$("#myModal").on("click", "#blockBackModalBtn", function(){
				var url = "";
				var index = $(this).attr("data-idx");
				var form = $("#infoFrm");
				form.empty();
				
				$("<input type='hidden' name='findDivision' value='"+ $memberFindList[index].findDivision +"'>").appendTo(form);
			    $("<input type='hidden' name='findNo' value='"+ $memberFindList[index].findNo +"'>").appendTo(form);
			    $("<input type='hidden' name='findState' value='1'>").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	url = formDataSetting()+"&"+form.serialize();
		    	form.empty();
		    	
		    	$.ajax({
					url : "/jnj/admin/member_find/block",
					type : "post",
					data : url,
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
			});
			
			
			// 변수 초기화
			function initValues( map ){
				
				$memberFindList = map.memberFindList;
				$info = map.adMFindInfo;
				$pagination = map.pagination;
				
				$member = ${member};
				$info.writeId = $member.memberId;
				$info.memberId = $member.memberId;
				
				$state = map.stateCount;
				
				console.log("상태 수는?");
				console.log($state);
			}
			
			
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#findTable").DataTable({
						"paging": false,
						"searching": false,
						"ordering" : false,
						"autowidth": false,
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
				
				$.each($memberFindList, function(idx, find) {
					
					table.row.add([
						"<a href='#' class='findview' data-idx='"+idx+"'>"+ find.findTitle+"</a>",
						find.writeDate,
						find.commentNum,
						find.reportCnt,
						currentFindState(find.findState, idx),
						strBtn
			        ]).draw(false);
				});
				
				
				var totoalCnt = 0;
				$.each($state, function(idx, state) {
					if( state.FINDSTATE == 0 )
						$("#block").text(state.COUNT+"건");
					else
						$("#show").text(state.COUNT+"건");
					totoalCnt += state.COUNT;
				});
				$("#total").text(totoalCnt+"건");
				
				
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
				
				$("#currentPage").text( ($info.type == TYPE_FIND)? "찾아요 게시글" : "찾았어요 게시글");
			}
			
			// 정렬 시 화면 다시 그리기
			function display_Resetting( result ){
				
				var resultMap = JSON.parse(result);
				
				// 테이블에 행 모두 지우기
				$("tbody>tr").each(function(idx){
					table .row( $(this) ).remove().draw();
				});
				
				initValues( resultMap );
				display_setting( 1 );
				display_Search();
				display_CSS();
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
				
				// 최상단 메뉴버튼 스타일( 후원, 댓글 메뉴)
				$("#menuDiv").css("margin", "20px");
				$("#sponsorRecordBtn").css("margin-right", "5px");
				
				$("#totlaNumDiv span").css({
					"font-size":"13px",
					"font-weight":"bold"
				});
				
				$(".alert").css({
					"display":"inline-block",
					"margin-right" : "13px"
				});
			}
			
			// 검색내용 선택에 따라 검색창 모양 바꿔주기 
			function display_Search(){
				
				var select = $("#mSelect").val();
				var selectTextDiv = $("#searchTextDiv");
				var selectDateDiv = $("#searchDateDiv");
				var selectboxDiv = $("#searchOptionDiv");
				var selectbox = $("#selectedOption");
				selectbox.empty();
				
				
				if( select != "findState" && $info.searchColName == "findState" )
					$info.searchText = "%";
				
				if( select == "findTitle" || select == "commentNum" || select == "reportCnt"){
					selectTextDiv.show();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				else if( select == "findState" ){
					selectTextDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value=''>전체</option>").appendTo( selectbox );
					$("<option value='0'>블락</option>").appendTo( selectbox );
					$("<option value='1'>정상</option>").appendTo( selectbox );
					
					$("#selectedOption").val(($info.searchText == "%")?"0":$info.searchText).attr("selected", "selected");
					
				}
				else{
					selectTextDiv.hide();
					selectDateDiv.show();
					selectboxDiv.hide();
				}										
			}
			
			
			// 정렬 눌렀을 때 동작
			function sortSelect(){
				$info.pageno = 1;
				$info.sortType = (( $info.sortType  == null )?"asc" : (( $info.sortType  == "desc")? "asc" : "desc"));
				
				
				$.ajax({
					url 	: 	"/jnj/admin/member_find/sort",
					type	: 	"get",
					data	: 	formDataSetting(),
					success : function(result){
						display_Resetting(result);
					}
				});
			}
			
			
			// 게시글 블락 상태에 따라 상태 한글로 변환 / 버튼 생성
			function currentFindState( findState, idx ){
				var str = "";
				if( findState == 0 ){
					str = "블락";
					strBtn = "<a href='#' class='blockBackBtn' data-idx="+idx+" >블락해제</a><br><a href='#' class='deleteBtn' data-idx="+idx+">삭제</a>";
				        
				}
				else if( findState == 1 ){
					str = "정상";
					strBtn = "<a href='#' class='blockBtn' data-idx="+idx+" >블락</a><br><a href='#' class='deleteBtn' data-idx="+idx+">삭제</a>";
				}
				return str;
			}
			
			// 필요한 데이터를 폼으로 미리 셋팅하고 전체를 넘겨준다,
			function formDataSetting(){
				
				var form = $("#searchFrm");
				form.empty();
				
				if( $info.memberId != null ) $("<input type='hidden' name='memberId' value='"+$info.memberId+"' >").appendTo( form );
				if( $info.memberId != null ) $("<input type='hidden' name='writeId' value='"+$info.hostId+"' >").appendTo( form );
				if( $info.type != null ) $("<input type='hidden' name='type' value='"+$info.type+"' >").appendTo( form );
				if( $info.pageno != null ) $("<input type='hidden' name='pageno' value='"+$info.pageno+"' >").appendTo( form );
				if( $info.colName != null ) $("<input type='hidden' name='colName' value='"+$info.colName+"' >").appendTo( form );
				if( $info.sortType != null ) $("<input type='hidden' name='sortType' value='"+$info.sortType+"' >").appendTo( form );
				if( $info.searchColName != null ) $("<input type='hidden' name='searchColName' value='"+$info.searchColName+"' >").appendTo( form );
				if( $info.searchText != null ) $("<input type='hidden' name='searchText' value='"+$info.searchText+"' >").appendTo( form );
				if( $info.startDate != null ) $("<input type='hidden' name='startDate' value='"+$info.startDate+"' >").appendTo( form );
				if( $info.endDate != null ) $("<input type='hidden' name='endDate' value='"+$info.endDate+"' >").appendTo( form );
				if( $info.sqlText != null ) $("<input type='hidden' name='sqlText' value='"+$info.sqlText+"' >").appendTo( form );
				if( $info.startArticleNum != null ) $("<input type='hidden' name='startArticleNum' value='"+$info.startArticleNum+"' >").appendTo( form );
				if( $info.endArticleNum != null ) $("<input type='hidden' name='endArticleNum' value='"+$info.endArticleNum+"' >").appendTo( form );
				
				var result = form.serialize();
				form.empty();
				
				return result;
			}
			
			function searchState(colName, find){
				
				$info.searchColName = colName;
				$info.searchText = find;
				
				$.ajax({
					url 	: "/jnj/admin/member_find/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						display_Resetting( result );
					}
				});
			}
			
		});
		
	</script>
</head>
<body>
    
    <div id="scorpTotal">
    
    	<div id="tableTotal">
    	
    		<div id="menuDiv">
    			<button type="button" class="btn btn-warning" id="recordBtn" disabled="disabled">게시글 글</button>
    			<button type="button" class="btn btn-warning" id="commentBtn">게시글 댓글</button>
    		</div>
    	
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 게시판 이용 내역 </div>
				<div class="card-body">
				
					<div class="alert alert-warning" id="currentPage"  style="display:inline-block; font-weight:bold; font-size:18px;">
							찾아요 게시글	
                   	</div>
                   	
                   	<hr>

					<div id="totlaNumDiv">
						<div class="alert alert-success" id="sTotalBtn">
							<span>전체 : </span> <span id="total"></span>
						</div>

						<div class="alert alert-success" id="sShowBtn">
							<span>게시 : </span> <span id="show">0건</span>
						</div>

						<div class="alert alert-success" id="sBlockBtn">
							<span>블락 : </span> <span id="block">0건</span>
						</div>
					</div>

					<div id="ssnav" style="background-color:white; overflow:hidden;">
						
						<ol id="sortFind" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="fFind" href="#">찾아요</a>
							</li>
							<li class="breadcrumb-item">
								<a id="fFound" href="#">찾았어요</a>
							</li>
						</ol>
			    	</div>
    	
					<table id="findTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>제목</th>
					            <th style="width:110px;">작성날짜</th>
					            <th style="width:80px;">댓글수</th>
					            <th style="width:80px;">신고수</th>
					            <th style="width:80px;">상태</th>
					            <th style="width:80px;">기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="findTitle">제목</option> 
					<option value="commentNum">댓글수</option> 
					<option value="reportCnt">신고수</option> 
					<option value="findState">상태</option> 
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
		</div>
	</div>
	    		
</body>
</html>