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
			var $info;
			var $salesList;
			var $totalSponsorMoney;
			
			initValues( tempMap );
			display_setting( 0 );
			display_CSS();
			
			
			// 검색 버튼을 클릭 시
			$("#searchBtn").on( "click", function (){
				
				var selectbox = $("#mSelect").val();
				$info.searchText = "%";
				
				$info.startDate = $("#searchDate1").val();
				$info.endDate = $("#searchDate2").val();
				
				
				if( $info.startDate == null || $info.startDate =="" )
					return;
				if( $info.endDate == null || $info.endDate =="" )
					return;
				
				
				console.log( selectbox );
				console.log( $info.startDate + " ~ " + $info.endDate );
				$.ajax({
					url 	: "/jnj/admin/sales/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 display_Resetting(result);
					}
				});
			});
			
		
			
			// 페이지 변경 시
			$(".pagination").on("click", "a[class=page-link]", function(e){
				e.preventDefault();
				$info.pageno = $(this).attr("data-page");
				location.href="/jnj/admin/sales?"+formDataSetting();
			});
			
			
			
			// 변수 초기화
			function initValues( map ){
				
				$salesList = map.salesList;
				$info = map.adSalesInfo;
				$pagination = map.pagination;
				$totalSponsorMoney = map.totalSponsorMoney;
			}
			
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#salesTable").DataTable({
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
				
				$.each($salesList, function(idx, sales) {
					
					table.row.add( [
						sales.memberId,
						sales.centerId,
						currentPetSort(sales.petSort),
						sales.petName,
						numberWithCommas(sales.payMoney),
						sales.sponsorDate
			        ]).draw(false);
					
				});
				
				$("#total").text(numberWithCommas($totalSponsorMoney) + "원");
				
				
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
			
			function currentPetSort( petState ){
				
				var strState = "강아지";
				if( petState == 2 )
					strState = "고양이";
				else if( petState == 3 )
					strState = "기타";
				
				return strState;
			}
		});
		
	</script>
</head>
<body>
    
    
    <div class="content-wrapper">
    	<div class="container-fluid">
    	
	    	<div id="searchSelectDiv">
				<div id="selectDiv">
					<select id="mSelect" class="form-control"> 
						<option value="sponsorDate">날짜별</option> 
					</select>
				</div>
				<div id="searchDiv">
			    	<div class="input-group">
			            <div id="searchDateDiv" class="input-group">
			            	<input id="searchDate1" class="form-control" type="date">~<input id="searchDate2" class="form-control" type="date">
			            </div>
			            <span class="input-group-btn" class="input-group">
			           		<button id="searchBtn" class="btn btn-primary" type=button><i class="fa fa-search"></i></button>
		            	</span>
			    	</div>
		        </div>
			</div>
    	
    	
    		<div id="tableTotal">
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 후원 매출 내역 </div>
					<div class="card-body">
					
						<div id="totlaNumDiv">
							<div class="alert alert-success" id="totalBtn">
		                    	<span>누적 후원금: </span>
		                    	<span id="total">0원</span>
		                    </div>
	                    </div>
					
						<table id="salesTable" class="table display" cellspacing="0" width="100%">
							<thead>
						    	<tr>
						        	<th>아이디</th>
						            <th>센터명</th>
						            <th>분류</th>
						            <th>동물이름</th>
						            <th>후원금</th>
						            <th>후원날짜</th>
						        </tr>
						    </thead>
						</table>
					</div>
				</div>
			</div>
		
		    <div id="pageDiv">
				<ul class="pagination">
				</ul>
			</div>
    	</div>
    </div>
    
    <form id="searchFrm"></form>
	    		
</body>
</html>