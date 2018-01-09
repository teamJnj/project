<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<title>Admin Base Page</title>
	
	<link href="/jnj/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="/jnj/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="/jnj/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
	<link href="/jnj/resources/css/sb-admin.css" rel="stylesheet">
	  
    <script src="/jnj/resources/vendor/jquery/jquery.min.js"></script>
    <script src="/jnj/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script src="/jnj/resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    
    <script src="/jnj/resources/vendor/chart.js/Chart.min.js"></script>
    <script src="/jnj/resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="/jnj/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    
    <script src="/jnj/resources/js/sb-admin.min.js"></script>

    <script src="/jnj/resources/js/sb-admin-datatables.min.js"></script>
    <!-- <script src="/jnj/resources/js/sb-admin-charts.min.js"></script> -->
	<script>
	
		$(function(){
			
			var table;
			var modalBody = $("#modalBody");
			
			var tempMap = ${map};
			var $memberMarketApplyList;
			var $info;
			var $pagination;
			var $state;
			
			console.log(tempMap);
			
			initValues( tempMap );
			display_setting( 0 );
			display_Search();
			display_CSS();
			
			$("#totalBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "marketApplyState", "");
			});
			$("#cancleBtn1").on("click", function(e){
				$info.pageno = 1;
				searchState( "marketApplyState", "0");
			});
			$("#applyBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "marketApplyState", "1");
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
			
			// 상태별 정렬
			$("#sMarketApplyState").on("click", function(e){
				e.preventDefault();
				$info.colName = "marketApplyState";
				sortSelect();
			});
			
			// 신청날짜순 정렬
			$("#sApplyDate").on("click", function(e){
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
					url 	: "/jnj/admin/market/apply/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 display_Resetting(result);
					}
				});
			});
			
			
			$("#marketTable").on("click", ".cancleClick", function(){
				console.log("프리마켓 참가 취소 클릭");
				console.log( $memberMarketApplyList[$(this).attr("data-idx")] );
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("정말 취소하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='cancleClick1' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
				.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				
			});
			
			// 참여 - 참여취소 모달창 클릭시
			$("#myModal").on("click", "#cancleClick1", function(){
				
				var index = $(this).attr("data-idx");
				
				console.log($(this).attr("data-idx"));
				console.log("모달 예쓰! : " + $memberMarketApplyList[$(this).attr("data-idx")].marketNo );
				
				var form = $("#infoFrm");
				form.empty();
				
			    $("<input type='hidden' name='marketNo' value='"+ $memberMarketApplyList[index].marketNo +"' multiple='multiple' >").appendTo(form);
			    $("<input type='hidden' name='memberId' value='"+ $memberMarketApplyList[index].memberId +"' multiple='multiple' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	console.log( formDataSetting()+"&"+form.serialize() );
				
		    	$.ajax({
					url : "/jnj/admin/market/apply/cancle",
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
				console.log( $memberMarketApplyList[$(this).attr("data-idx")].marketNo );
				window.open("/jnj/admin/market/apply/view?marketNo="+$memberMarketList[$(this).attr("data-idx")].marketNo,
					"관리자 - 마켓 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			
			
			
			// 신청목록
			$("#marketTable").on("click", ".applyClick", function(e){
				e.preventDefault();
				window.open("/jnj/admin/market/apply/apply",
					"관리자 - 마켓 수정", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 변수 초기화
			function initValues( map ){
				
				$memberMarketApplyList = map.memberMarketApplyList;
				$info = map.adMMarketApplyInfo;
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
							{ "orderable": false },
							{ "orderable": false }
						]
					});
				}
				
				$.each($memberMarketApplyList, function(idx, ml) {
					table.row.add( [
						ml.marketTitle,
						ml.memberId,
						ml.applyTel,
						ml.boothNum,
						ml.payMoney,
						(ml.marketApplyState == 0)?"취소(거절)":"신청" ,
						ml.applyDate,
						(ml.marketApplyState==1)?"<a href='#' class='cancleClick' data-idx='"+idx+"'>거절</a>" : "-"
			        ]).draw(false);
				});
				
				
				$("#total").text( "0건" );
				$("#cancle").text( "0건" );
				$("#apply").text( "0건" );
				var totalCnt = 0;
				$.each( $state, function(idx, state){
					if( state.MARKETAPPLYSTATE == 0 )
						$("#cancle").text( state.COUNT + "건");
					else
						$("#apply").text( state.COUNT + "건");
					totalCnt+=state.COUNT;
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
				
				if( select == "marketTitle" || select == "memberId" || select == "applyTel" ){
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
					url 	: 	"/jnj/admin/market/apply/sort",
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
					url 	: "/jnj/admin/market/apply/sort",
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
    
    
    	
    <div id="scorpTotal">
    	<div id="tableTotal">
    	
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 프리마켓  신청 목록 </div>
				<div class="card-body">
				
					<div id="totlaNumDiv">
						<div class="alert alert-success" id="totalBtn">
	                    	<span>전체 : </span>
	                    	<span id="total">0건</span>
	                    </div>
	                    
						<div class="alert alert-success" id="cancleBtn1">
	                    	<span>취소(거절) : </span>
	                    	<span id="cancle">0건</span>
	                    </div>
	                    
                    	<div class="alert alert-success" id="applyBtn">
	                    	<span>신청(기타) : </span>
	                    	<span id="apply">0건</span>
	                    </div>
                    </div>
				
					<div id="ssnav" style="background-color:white; overflow:hidden;">
						<ol id="sortMarket" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="sTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sMarketApplyState" href="#">상태별</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sApplyDate" href="#">날짜순</a>
							</li>
						</ol>
			    	</div>
				
					<table id="marketTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>제목</th>
					            <th style="width:80px;" >아이디</th>
					            <th style="width:50px;" >전화번호</th>
					            <th style="width:80px;" >부스</th>
					            <th style="width:80px;" >금액</th>
					            <th style="width:80px;" >상태</th>
					            <th style="width:80px;" >신청날짜</th>
					            <th style="width:50px;" >기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="marketTitle">제목</option> 
					<option value="memberId">아이디</option> 
					<option value="applyTel">전화</option> 
					<option value="boothNum">부스</option> 
					<option value="payMoney">금액</option> 
					<option value="marketApplyState">상태</option> 
					<option value="applyDate">신청날짜</option> 
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