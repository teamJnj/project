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
			
			
			var tempMap = ${map};
			console.log(tempMap);
			var $ordersList;
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
				searchState( "orderState", "");
			});
			$("#orderBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "orderState", "1");
			});
			$("#depositBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "orderState", "2");
			});
			$("#standbyBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "orderState", "3");
			});
			$("#refundBtn").on("click", function(e){
				$info.pageno = 1;
				searchState( "orderState", "6");
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
			$("#sOrderNo").on("click", function(e){
				e.preventDefault();
				$info.colName = "orderNo";
				sortSelect();
			});
			$("#sPayMoney").on("click", function(e){
				e.preventDefault();
				$info.colName = "payMoney";
				sortSelect();
			});
			$("#sOrderState").on("click", function(e){
				e.preventDefault();
				$info.colName = "orderState";
				sortSelect();
			});
			$("#sOrderDate").on("click", function(e){
				e.preventDefault();
				$info.colName = "orderDate";
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
				if( selectbox == "orderNo"){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "orderState"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "orderDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				console.log( formDataSetting() );
				
				$.ajax({
					url 	: "/jnj/admin/member_orders/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 display_Resetting(result);
					}
				});
			});
			
			
			$("#orderTable").on("click", "#cancleBtn", function(){
				console.log("프리마켓 참가 취소 클릭");
				console.log( $ordersList[$(this).attr("data-idx")] );
				
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
				console.log("모달 예쓰! : " + $ordersList[$(this).attr("data-idx")].marketNo );
				
				var form = $("#infoFrm");
				form.empty();
				
			    $("<input type='hidden' name='marketNo' value='"+ $ordersList[index].marketNo +"' multiple='multiple' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	console.log( formDataSetting()+"&"+form.serialize() );
				
		    	$.ajax({
					url : "/jnj/admin/member_orders/apply/apply_cancle",
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
				location.href="/jnj/admin/member_orders?"+formDataSetting();
			});
			
			
			// 제목 클릭 시 상세뷰로!
			$("#orderTable").on("click", ".detailClick", function(e){
				e.preventDefault();
				window.open("/jnj/admin/orders/view?orderNo="+$ordersList[$(this).attr("data-idx")].orderNo+"&orderId="+$ordersList[$(this).attr("data-idx")].orderId,
					"관리자 - 구매내역 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 주문 접수 클릭 시 -> 배송준비중(3)으로 상태바꾸기
			$("#orderTable").on("click", ".standbyClick", function(e){
				e.preventDefault();
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText'></p>").text("배송준비 단계로 변경됩니다.").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-state=3 data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			
			// 출고하기 클릭 시 -> 배송중(4)으로 상태바꾸기
			$("#orderTable").on("click", ".deliveryClick", function(e){
				e.preventDefault();
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText'></p>").text("배송중 단계로 변경됩니다.").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-state=4 data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			
			// 배송완료 클릭 시 -> 배송완료(5)로 상태바꾸기( 택배사 없으니까 우리가 그냥 바꿔줍시다)
			$("#orderTable").on("click", ".completeClick", function(e){
				e.preventDefault();
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText'></p>").text("배송완료 단계로 변경됩니다.").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-state=5 data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			
			// 교환/환불 접수 클릭 시 -> 교환/환불중(7)으로 상태바꾸기
			$("#orderTable").on("click", ".refundingClick", function(e){
				e.preventDefault();
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText'></p>").text("교환/환불중 단계로 변경됩니다.").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-state=7 data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();;
			});
			
			// 교환/환불 접수 완료 시 -> 교환/환불완료(8)로 상태바꾸기
			$("#orderTable").on("click", ".refundCompleteClick", function(e){
				e.preventDefault();
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText'></p>").text("교환/환불완료 단계로 변경됩니다.").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-state=8 data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			
			$("#myModal").on("click", "#yesBtn", function(){
				changeOrderState( $ordersList[$(this).attr("data-idx")].orderNo, $(this).attr("data-state"));
			});
			
			// 변수 초기화
			function initValues( map ){
				
				$ordersList = map.ordersList;
				$info = map.adOrdersInfo;
				$pagination = map.pagination;
				
				$member = ${member};
				$info.memberId = $member.memberId;
				$info.orderId = $member.memberId;
				
				$state = map.stateCount;
			}
			
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#orderTable").DataTable({
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
				
				$.each($ordersList, function(idx, order) {
					
					table.row.add( [
						"<a href='#' class='detailClick' data-idx='"+idx+"'>"+order.orderNo+"</a>",
						order.orderId,
						order.orderTel,
						numberWithCommas(order.payMoney),
						currentOrderState(order.orderState),
						order.orderDate,
						currentBtn(order.orderState, idx)
			        ]).draw(false);
					
				});
				
				var totalCnt = 0;
				$.each($state, function(idx, state) {
					if( state.ORDERSTATE == 1 )
						$("#order").text(state.COUNT + "건");
					else if( state.ORDERSTATE == 2 )
						$("#deposit").text(state.COUNT + "건");
					else if( state.ORDERSTATE == 3 || state.ORDERSTATE == 4 || state.ORDERSTATE == 5 )
						$("#standby").text(state.COUNT + "건");
					else
						$("#refund").text(state.COUNT + "건");
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
				
				if( select != "orderState" && $info.searchColName == "orderState" )
					$info.searchText = "%";
				
				if( select == "orderNo" ){
					selectTextDiv.show();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				else if( select == "orderState" ){
					selectTextDiv.hide();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value=''>전체</option>").appendTo( selectbox );
					$("<option value='1'>주문완료</option>").appendTo( selectbox );
					$("<option value='2'>입금완료</option>").appendTo( selectbox );
					$("<option value='3'>배송</option>").appendTo( selectbox );
					$("<option value='6'>교환/환불</option>").appendTo( selectbox );
					
					$("#selectedOption").val(($info.searchText == "%")?"1":$info.searchText).attr("selected", "selected");
					
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
					url 	: 	"/jnj/admin/member_orders/sort",
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
				
				if( $info.orderId != null ) $("<input type='hidden' name='orderId' value='"+$info.orderId+"' >").appendTo( form );
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
			
			// 숫자 세자리마다 ,찍기( 단위 표시 )
			function numberWithCommas(num) {
			    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}
			
			function currentOrderState( orderState ){
				var str = "주문취소";
				if( orderState == 1 )		str = "주문완료";
				else if( orderState == 2 )	str = "입금완료";
				else if( orderState == 3 )	str = "배송준비중";
				else if( orderState == 4 )	str = "배송중";
				else if( orderState == 5 )	str = "배송완료";
				else if( orderState == 6 )	str = "교환/환불 접수";
				else if( orderState == 7 )	str = "교환/환불 중";
				else if( orderState == 8 )	str = "교환/환불 완료";
				else if( orderState == 9 )	str = "구매확정";
				return str;
			}
			function currentBtn( orderState, idx ){
				var str = "-";
				if( orderState == 2 )		str = "<a href='#' class='standbyClick' data-idx='"+idx+"'>배송준비</a>";
				else if( orderState == 3 )	str = "<a href='#' class='deliveryClick' data-idx='"+idx+"'>출고하기</a>";
				else if( orderState == 4 )	str = "<a href='#' class='completeClick' data-idx='"+idx+"'>배송완료</a>";
				else if( orderState == 5 )	str = "-";
				else if( orderState == 6 )	str = "<a href='#' class='refundingClick' data-idx='"+idx+"'>접수</a>";
				else if( orderState == 7 )	str = "<a href='#' class='refundCompleteClick' data-idx='"+idx+"'>교환/환불완료</a>";
				else if( orderState == 8 )	str = "-";
				else if( orderState == 9 )	str = "-";
				return str;
			}
			
			function searchState(colName, find){
				
				$info.searchColName = colName;
				$info.searchText = find;
				
				$.ajax({
					url 	: "/jnj/admin/member_orders/sort",
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
			
			
			// 주문 상태를 바꿀 때 씁니다
			function changeOrderState( selectOrderNo, selectState ){
				var form = $("#infoFrm");
				form.empty();
				
			    $("<input type='hidden' name='orderNo' value='"+ selectOrderNo +"' >").appendTo(form);
			    $("<input type='hidden' name='selectOrderState' value='"+ selectState +"' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	$.ajax({
					url : "/jnj/admin/member_orders/state",
					type : "post",
					data : formDataSetting()+"&"+form.serialize(),
					success : function(result){
						$("#myModal").modal("hide");
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
				<div class="card-header"> <i class="fa fa-table"></i> 구매 내역 </div>
				<div class="card-body">
				
					<div id="totlaNumDiv">
						<div class="alert alert-success" id="totalBtn">
	                    	<span>전체 : </span>
	                    	<span id="total">0건</span>
	                    </div>
                    	<div class="alert alert-success" id="orderBtn">
	                    	<span>주문완료 : </span>
	                    	<span id="order">0건</span>
	                    </div>
	                    <div class="alert alert-success" id="depositBtn">
	                    	<span>입금완료 : </span>
	                    	<span id="deposit">0건</span>
	                    </div>
	                    <div class="alert alert-success" id="standbyBtn">
	                    	<span>배송 : </span>
	                    	<span id="standby">0건</span>
	                    </div>
	                    <div class="alert alert-success" id="refundBtn">
	                    	<span>교환/환불 : </span>
	                    	<span id="refund">0건</span>
	                    </div>
                    </div>
				
					<div id="ssnav" style="background-color:white; overflow:hidden;">
						<ol id="sortMarket" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="sTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sOrderNo" href="#">주문번호순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sPayMoney" href="#">결제금액순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sOrderState" href="#">주문상태별</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sOrderDate" href="#">주문날짜순</a>
							</li>
						</ol>
			    	</div>
				
					<table id="orderTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>주문번호</th>
					            <th>아이디</th>
					            <th>전화번호</th>
					            <th>결제금액</th>
					            <th>주문상태</th>
					            <th>주문날짜</th>
					            <th>기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="orderNo">주문번호</option>
					<option value="orderState">주문상태</option> 
					<option value="orderDate">주문날짜</option> 
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