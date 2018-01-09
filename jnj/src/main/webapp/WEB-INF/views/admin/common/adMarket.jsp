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
			
			var MARKETAPPLY_MARKETAPPLYSTATE_CANCLE 	= 0;	// 취소(거절)
			var MARKETAPPLY_MARKETAPPLYSTATE_APPLY 		= 1;	// 신청완료
			var MARKETAPPLY_MARKETAPPLYSTATE_COMPLETE 	= 2;	// 완료
			var MARKETAPPLY_MARKETAPPLYSTATE_LACK 		= 3;	// 인원미달
			
			
			var tempMap = ${map};
			console.log(tempMap);
			var $memberMarketList;
			var $info;
			var $pagination;
			var $member;
			var $state;
			
			initValues( tempMap );
			display_setting( 0 );
			display_Search();
			display_CSS();
			
			
			
			$("#totalBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "marketState", "");
			});
			$("#applyBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "marketState", "1");
			});
			$("#completBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "marketState", "2");
			});
			
			
			// 전체보기
			$("#sTotal").on("click", function(e){
				e.preventDefault();
				$info.colName = null;
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				sortSelect();
			});
			
			// 제목순 정렬
			$("#sTitle").on("click", function(e){
				e.preventDefault();
				$info.colName = "marketTitle";
				sortSelect();
			});
			
			// 부수별 정렬
			$("#sBooth").on("click", function(e){
				e.preventDefault();
				$info.colName = "boothNum";
				sortSelect();
			});
			
			// 참가비순 정렬
			$("#sMoney").on("click", function(e){
				e.preventDefault();
				$info.colName = "payMoney";
				sortSelect();
			});
			
			// 상태별 정렬
			$("#sState").on("click", function(e){
				e.preventDefault();
				$info.colName = "marketApplyState";
				sortSelect();
			});
			
			// 개최날짜순 정렬
			$("#sOpen").on("click", function(e){
				e.preventDefault();
				$info.colName = "marketDate";
				sortSelect();
			});
			
			// 신청날짜순 정렬
			$("#sApply").on("click", function(e){
				e.preventDefault();
				$info.colName = "applyDate";
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
				if( selectbox == "marketTitle"){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "boothNum"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "marketApplyState"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "payMoney"){
					$info.startMoney = $("#searchMoney1").val();
					$info.endMoney = $("#searchMoney2").val();
				}
				else if( selectbox == "applyDate" || selectbox == "marketDate" ){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				console.log( formDataSetting() );
				
				$.ajax({
					url 	: "/jnj/admin/market/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 display_Resetting(result);
					}
				});
			});
			
			
			$("#marketTable").on("click", "#cancleBtn", function(){
				console.log("프리마켓 참가 취소 클릭");
				console.log( $memberMarketList[$(this).attr("data-idx")] );
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("정말 취소하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='cancleBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
				.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				
			});
			
			// 참여 - 참여취소 모달창 클릭시
			$("#myModal").on("click", "#cancleBtn", function(){
				
				var index = $(this).attr("data-idx");
				
				console.log($(this).attr("data-idx"));
				console.log("모달 예쓰! : " + $memberMarketList[$(this).attr("data-idx")].marketNo );
				
				var form = $("#infoFrm");
				form.empty();
				
			    $("<input type='hidden' name='marketNo' value='"+ $memberMarketList[index].marketNo +"' multiple='multiple' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	console.log( formDataSetting()+"&"+form.serialize() );
				
		    	$.ajax({
					url : "/jnj/admin/market/apply/apply_cancle",
					type : "post",
					data : formDataSetting()+"&"+form.serialize(),
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
				
			});
			
			
			// 페이지 변경 시
			$(".pagination").on("click", "a[class=page-link]", function(e){
				e.preventDefault();
				$info.pageno = $(this).attr("data-page");
				location.href="/jnj/admin/market?"+formDataSetting();
			});
			
			
			// 제목 클릭 시 상세뷰로!
			$("#marketTable").on("click", ".detailClick", function(e){
				e.preventDefault();
				console.log( $memberMarketList[$(this).attr("data-idx")].marketNo );
				window.open("/jnj/admin/market/view?marketNo="+$memberMarketList[$(this).attr("data-idx")].marketNo,
					"관리자 - 마켓 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 수정
			$("#marketTable").on("click", ".updateClick", function(e){
				e.preventDefault();
				window.open("/jnj/admin/market/update?marketNo="+$memberMarketList[$(this).attr("data-idx")].marketNo,
					"관리자 - 마켓 수정", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 삭제
			$("#marketTable").on("click", ".deleteClick", function(e){
				e.preventDefault();
				console.log( $memberMarketList );
				$.ajax({
					url 	: "/jnj/admin/market/delete",
					type 	: "post", 
					data	: {
						"marketNo" : $memberMarketList[$(this).attr("data-idx")].marketNo,
						'${_csrf.parameterName}' : '${_csrf.token}'
					},
					success : function(result){
						 location.reload();
					}
				});
			});
			
			// 글쓰기
			$("#writeBtn").on("click", function(){
				window.open("/jnj/admin/market/write", 
						"관리자 - 마켓 쓰기", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 신청목록
			$("#marketTable").on("click", ".applyClick", function(e){
				e.preventDefault();
				
				if( $(this).attr("data-idx") != null ){
					$info.searchColName = "marketNo";
					$info.searchText = $memberMarketList[$(this).attr("data-idx")].marketNo;
					window.open("/jnj/admin/market/apply?searchColName=marketNo&searchText="+$memberMarketList[$(this).attr("data-idx")].marketNo,
							"관리자 - 마켓 수정", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
				}
				else{
					$info.searchColName = "marketTitle";
					$info.searchText = "%";
					window.open("/jnj/admin/market/apply",
							"관리자 - 마켓 수정", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
				}
				
				
			});
			
			
			// 변수 초기화
			function initValues( map ){
				$memberMarketList = map.memberMarketList;
				$info = map.adMMarketInfo;
				$pagination = map.pagination;
				$state = map.stateCount;
			}
			
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#marketTable").DataTable({
						"paging": false,
						"searching": false,
						"ordering" : false,
						"columns": [
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false }
						]
					});
				}
				
				
				$.each($memberMarketList, function(idx, ml) {
					
					table.row.add( [
						"<a href='#' class='detailClick' data-idx='"+idx+"' >" + ml.marketTitle + "</a>",
						ml.marketDate,
						ml.applyEndDate,
						"<a href='#' class='applyClick' data-idx='"+idx+"'>" + ml.applyPeople + "</a>",
						ml.writeDate,
						currentApplyState(ml.marketState),
						"<a href='#' class='updateClick' data-idx='"+idx+"'>수정</a><br><a href='#' class='deleteClick' data-idx='"+idx+"'>삭제</a>"
			        ]).draw(false);
					
				});
				
				
				var totalCnt = 0;
				$.each($state, function(idx, state) {
					
					if( state.MARKETSTATE == 1 )
						$("#apply").text(state.COUNT + "건");
					else if( state.MARKETSTATE == 2 )
						$("#complet").text(state.COUNT + "건");
					totalCnt += state.COUNT;
				});
				$("#total").text(totalCnt + "건");
				
				
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
				$("tbody>tr").each(function(idx){
					table .row( $(this) ).remove().draw();
				});
				
				// 바뀐 내용으로 화면 새로 그리기
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
				var selectMoneyDiv = $("#searchMoneyDiv");
				var selectDateDiv = $("#searchDateDiv");
				var selectboxDiv = $("#searchOptionDiv");
				var selectbox = $("#selectedOption");
				
				selectbox.empty();
				
				if( select != "marketApplyState" && $info.searchColName == "marketApplyState" )
					$info.searchText = "%";
				
				if( select == "marketTitle" ){
					selectTextDiv.show();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				else if( select == "boothNum" ){
					selectTextDiv.hide();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value='1'>1</option>").appendTo( selectbox );
					$("<option value='2'>2</option>").appendTo( selectbox );
					
					$("#selectedOption").val(($info.searchText == "%")?"1":$info.searchText).attr("selected", "selected");
					
				}
				else if( select == "marketApplyState" ){
					selectTextDiv.hide();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value='0'>취소(거절)</option>").appendTo( selectbox );
					$("<option value='1'>신청완료</option>").appendTo( selectbox );
					$("<option value='2'>완료</option>").appendTo( selectbox );
					$("<option value='3'>인원미달</option>").appendTo( selectbox );
					
					$("#selectedOption").val(($info.searchText == "%")?"0":$info.searchText).attr("selected", "selected");
					
				}
				else if( select == "payMoney" ){
					selectTextDiv.hide();
					selectMoneyDiv.show();
					selectDateDiv.hide();
					selectboxDiv.hide();
					
				}
				else{
					selectTextDiv.hide();
					selectMoneyDiv.hide();
					selectDateDiv.show();
					selectboxDiv.hide();
				}										
			}
			
			
			// 정렬 눌렀을 때 동작
			function sortSelect(){
				
				$info.pageno = 1;
				$info.sortType = (( $info.sortType  == null )?"asc" : (( $info.sortType  == "desc")? "asc" : "desc"));
				
				$.ajax({
					url 	: 	"/jnj/admin/market/sort",
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
			
			
			// 펫 상태 표기 변환
			function currentApplyState( marketState ){
				var strState = "모집완료";
				if( marketState == 1 )
					strState = "모집중";
				return strState;
			}
			
			
			function searchState(colName, find){
				
				$info.searchColName = colName;
				$info.searchText = find;
				
				$.ajax({
					url 	: "/jnj/admin/market/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						
						 var resultMap = JSON.parse(result);
						 console.log(resultMap);
						
						// 테이블에 행 모두 지우기
						$("tbody>tr").each(function(idx){
							table .row( $(this) ).remove().draw();
						});
						
						// 바뀐 내용으로 화면 새로 그리기
						initValues( resultMap );
						display_setting( 1 );
						display_Search();
						display_CSS();
					}
				});
			}
			
		});
		
	</script>
</head>
<body>
    
    
    <div class="content-wrapper">
    	<div class="container-fluid">
    	
    <div id="scorpTotal">
    	<div id="tableTotal">
    	
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 프리마켓 내역 </div>
				<div class="card-body">
				
					<div id="totlaNumDiv">
						<div class="alert alert-success" id="totalBtn">
	                    	<span>전체 : </span>
	                    	<span id="total">0건</span>
	                    </div>
	                    
                    	<div class="alert alert-success" id="applyBtn">
	                    	<span>모집중 : </span>
	                    	<span id="apply">0건</span>
	                    </div>
	                    
	                    <div class="alert alert-success" id="completBtn">
	                    	<span>모집완료 : </span>
	                    	<span id="complet">0건</span>
	                    </div>
                    </div>
				
					<div id="ssnav" style="background-color:white; overflow:hidden;">
						<ol id="sortMarket" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="sTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sTitle" href="#">작성날짜순</a>
							</li>
						</ol>
			    	</div>
				
					<table id="marketTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>제목</th>
					            <th style="width:80px;" >개최날짜</th>
					            <th style="width:50px;" >마감날짜</th>
					            <th style="width:80px;" ><a href='#' class='applyClick'>신청인원</a></th>
					            <th style="width:80px;" >작성날짜</th>
					            <th style="width:80px;" >상태</th>
					            <th style="width:50px;" >기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		</div>
		</div>
		
		<div id="menuDiv" style="float:right; margin-right:50px;">
	    		<button type="button" class="btn btn-warning" id="writeBtn">글쓰기</button>
	    </div>
		
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="marketTitle">제목</option> 
					<option value="marketDate">개최날짜</option> 
					<option value="marketState">상태</option> 
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
		            
		            <div id="searchMoneyDiv" class="input-group">
		             	<input id="searchMoney1" class="form-control" type="text" placeholder="금액 입력..">~<input id="searchMoney2" class="form-control" type="text" placeholder="금액 입력..">
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
	    		
</body>
</html>