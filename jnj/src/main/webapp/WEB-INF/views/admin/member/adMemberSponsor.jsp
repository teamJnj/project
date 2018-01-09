<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	
	<script>
	
		$(function(){
			
			var PET_STATE_STANDBY 		= 1;	// 대기
			var PET_STATE_RECEIPT 		= 2;	// 접수
			var PET_STATE_PROCESS 		= 3;	// 진행
			var PET_STATE_ADOPT 		= 4;	// 입양
			var PET_STATE_MERCY 		= 5;	// 안락사
			
			var tempMap = ${map};
			var $info;
			var $member;
			var $memberSponsorListt;
			var $paginationn;
			var $totalMoney;
			
			
			initValues( tempMap );
			display_setting( 0 );
			display_Search();
			display_CSS();
			
			
			// 전체보기 정렬
			$("#sTotal").on("click", function(e){
				e.preventDefault();
				$info.colName = null;
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				sortSelect();
			});
			
			// 최신순 정렬
			$("#sCurrent").on("click", function(e){
				e.preventDefault();
				$info.colName = "sponsorDate";
				sortSelect();
			});
			
			// 센터별 정렬
			$("#sCenter").on("click", function(e){
				e.preventDefault();
				$info.colName = "centerName";
				sortSelect();
			});
			
			// 상태별 정렬
			$("#sState").on("click", function(e){
				e.preventDefault();
				$info.colName = "petState";
				sortSelect();
			});
			
			// 후원금별 정렬
			$("#sMoney").on("click", function(e){
				e.preventDefault();
				$info.colName = "payMoney";
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
				if( selectbox == "centerName" || selectbox == "petName"){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "petSort"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "petState"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "payMoney"){
					$info.startMoney = $("#searchMoney1").val();
					$info.endMoney = $("#searchMoney2").val();
				}
				else if( selectbox == "sponsorDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				$.ajax({
					url 	: "/jnj/admin/member_sponsor/sort",
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
				location.href="/jnj/admin/member_sponsor?"+formDataSetting();
			});
			
			// 상세보기 클릭 시
			$("#sponsorTable").on("click", "#detailClick", function(){
				console.log( "상세보기 클릭 : " + $(this).attr("data-pet") );
				window.open("/jnj/admin/member_sponsor/detail?petNo="+$(this).attr("data-pet"), 
						"관리자 - 후원 상세보기", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 후원 댓글 내역 보러가기
			$("#sponsorCommentBtn").on("click", function(){
				location.href="/jnj/admin/member_sponsor/comment?memberId="+$member.memberId;
			});
			
			
			// 변수 초기화
			function initValues( map ){
				
				$info = map.adMSponsorInfo;
				
				$member = map.member;
				$info.memberId = $member.memberId;
				
				$memberSponsorList = map.memberSponsorList;
				$pagination = map.pagination;
				$totalMoney = map.totalMoney;
			}
	
	
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#sponsorTable").DataTable({
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
				
				
				// 행 추가
				$.each($memberSponsorList, function(idx, spList) {
					
					table.row.add( [
						spList.centerName,
						currentPetSort(spList.petSort),
						spList.petName,
						currentPetState( spList.petState ),
						spList.payMoney,
			           	spList.sponsorDate,
			           	"<a href='#' id='detailClick' data-pet='"+spList.petNo+"' >상세보기</a>"
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
				
				// 총 후원 금액 
				$("#totalSponsorMoney").text("총 후원 금액 : " + numberWithCommas($totalMoney) + "원");
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
				var selectMoneyDiv = $("#searchMoneyDiv");
				var selectDateDiv = $("#searchDateDiv");
				var selectboxDiv = $("#searchOptionDiv");
				var selectbox = $("#selectedOption");
				selectbox.empty();
				
				if( select == "centerName" || select == "petName" ){
					selectTextDiv.show();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				else if( select == "petSort" ){
					selectTextDiv.hide();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value='0'>전체</option>").appendTo( selectbox );
					$("<option value='1'>강아지</option>").appendTo( selectbox );
					$("<option value='2'>고양이</option>").appendTo( selectbox );
					$("<option value='3'>기타</option>").appendTo( selectbox );
					
					$("#selectedOption").val(($info.searchText == "%")?"0":$info.searchText).attr("selected", "selected");
				
				}
				else if( select == "petState" ){
					selectTextDiv.hide();
					selectMoneyDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value='0'>전체</option>").appendTo( selectbox );
					$("<option value='1'>대기</option>").appendTo( selectbox );
					$("<option value='2'>접수</option>").appendTo( selectbox );
					$("<option value='3'>진행</option>").appendTo( selectbox );
					$("<option value='4'>입양</option>").appendTo( selectbox );
					$("<option value='5'>안락사</option>").appendTo( selectbox );
					
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
				
				
				// 최상단 메뉴버튼 스타일( 후원, 댓글 메뉴)
				$("#menuDiv").css("margin", "20px");
				$("#sponsorRecordBtn").css("margin-right", "5px");
				
			}
			
			
			
			// 정렬 눌렀을 때 동작
			function sortSelect(){
				$info.pageno = 1;
				$info.sortType = (( $info.sortType  == null )?"asc" : (( $info.sortType  == "desc")? "asc" : "desc"));
								
				$.ajax({
					url 	: 	"/jnj/admin/member_sponsor/sort",
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
			
			
			// 숫자 세자리마다 ,찍기( 단위 표시 )
			function numberWithCommas(num) {
			    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}
			
			// 펫 분류 표기 변환
			function currentPetSort( petState ){
				
				var strState = "강아지";
				if( petState == 2 )
					strState = "고양이";
				else if( petState == 3 )
					strState = "기타";
				
				return strState;
			}
			
			// 펫 상태 표기 변환
			function currentPetState( petState ){
				
				var strState = "대기";
				if( petState == PET_STATE_RECEIPT )
					strState = "접수";
				else if( petState == PET_STATE_PROCESS )
					strState = "진행";
				else if( petState == PET_STATE_ADOPT )
					strState = "입양";
				else if( petState == PET_STATE_MERCY )
					strState = "안락사";
				
				return strState;
			}
			
		});
		
	</script>
</head>
<body>
    
    <div id="scorpTotal">
    	<div id="tableTotal">
    		
    		<div id="menuDiv">
    			<button type="button" class="btn btn-warning" id="sponsorRecordBtn" disabled="disabled">후원내역</button>
    			<button type="button" class="btn btn-warning" id="sponsorCommentBtn">후원댓글</button>
    		</div>
    		
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 후원 내역 </div>
				<div class="card-body">
				
					<div id="ssnav" style="background-color:white; overflow:hidden;">
						
						<div class="alert alert-success" id="totalSponsorMoney" style="font-weight:bold; font-size:25px;">
							총 후원 금액 : 
                        </div>
						
						<ol id="sortSponsor" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="sTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sCurrent" href="#">최신순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sCenter" href="#">센터별</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sState" href="#">상태별</a>
							</li>
							<li class="breadcrumb-item">
								<a id="sMoney" href="#">후원금순</a>
							</li>
						</ol>
			    	</div>
    	
					<table id="sponsorTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>센터명</th>
					            <th>분류</th>
					            <th>이름</th>
					            <th>상태</th>
					            <th>후원금</th>
					            <th>날짜</th>
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
					<option value="centerName">센터명</option> 
					<option value="petSort">분류</option> 
					<option value="petName">이름</option> 
					<option value="petState">상태</option> 
					<option value="payMoney">후원금</option> 
					<option value="sponsorDate">날짜</option> 
				</select>
			</div>
			<div id="searchDiv">
		    	<div class="input-group">
		        	<div id="searchTextDiv" class="input-group">
		             	<input id="searchText" class="form-control" type="text" placeholder="Search for...">
		            </div>
		             	
		            <div id="searchMoneyDiv" class="input-group">
		             	<input id="searchMoney1" class="form-control" type="text" placeholder="금액 입력..">~<input id="searchMoney2" class="form-control" type="text" placeholder="금액 입력..">
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