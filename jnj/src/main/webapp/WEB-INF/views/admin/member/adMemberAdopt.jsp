<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	
	<script>
	
		$(function(){
			
			var PET_STATE_STANDBY 		= 1;
			var PET_STATE_RECEIPT 		= 2;
			var PET_STATE_PROCESS 		= 3;
			var PET_STATE_ADOPT 		= 4;
			var PET_STATE_MERCY 		= 5;
			
			var modalBody = $("#modalBody");
			
			var tempMap = ${map};
			var $map;
			var $memberAdoptList;
			var $info;
			var $pagination;
			var $member;
			var $state;
			
			initValues( tempMap );
			display_setting( 0, $pagination, $memberAdoptList );
			display_Search();
			display_CSS();
			
			
			$("#totalBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "petState", "0");
			});
			
			$("#receiptBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "petState", "2");
			});
			
			$("#processBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "petState", "3");		
			});
					
			$("#adoptBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "petState", "4");
			});
			
			$("#canBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "petState", "1");
			});
			
			$("#etcBtn").on("click", function(){
				$info.pageno = 1;
				searchState( "petState", "5");
			});
			
			// 전체보기
			$("#aTotal").on("click", function(e){
				e.preventDefault();
				$info.colName = null;
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				sortSelect();
			});
			
			// 센터별 정렬
			$("#aCenter").on("click", function(e){
				e.preventDefault();
				$info.colName = "centerName";
				sortSelect();
			});
			
			// 동물 분류 별 정렬
			$("#aSort").on("click", function(e){
				e.preventDefault();
				$info.colName = "petSort";
				sortSelect();
			});
			
			// 동물 이름 별 정렬
			$("#aName").on("click", function(e){
				e.preventDefault();
				$info.colName = "petName";
				sortSelect();
			});
			
			// 입양 날짜 별 정렬
			$("#aDate").on("click", function(e){
				e.preventDefault();
				$info.colName = "adoptApplyDate";
				sortSelect();
			});
			
			// 동물 입양 상태 별 정렬
			$("#aState").on("click", function(e){
				e.preventDefault();
				$info.colName = "petState";
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
				
				if( selectbox == "centerName" || selectbox == "petName"){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "petSort"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "petState"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "adoptApplyDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				$.ajax({
					url 	: "/jnj/admin/member_adopt/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 var resultMap = JSON.parse(result);
						
						// 테이블에 행 모두 지우기
						$("tbody>tr").each(function(idx){
							table .row( $(this) ).remove().draw();
						});
						
						// 바뀐 내용으로 화면 새로 그리기
						display_setting( 1, resultMap.pagination, resultMap.memberAdoptList );
						display_CSS();
					}
				});
			});
			
			// 입양 취소를 클릭 시
			$("#adoptTable tbody").on("click", "#adoptCancle", function(){
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText'></p>").text("정말 입양을 취소 시키겠습니까?").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				
			});
			
			$("#myModal").on("click", "#yesBtn", function(){
				console.log("확인 클릭");	
				
				var memberAdopt = $memberAdoptList[$(this).attr("data-idx")];
				
				
				var infoForm = $("#infoFrm");
				infoForm.empty();
				$("<input type='hidden' name='petNo' value='"+memberAdopt.petNo+"'>").appendTo(infoForm);
				$("<input type='hidden' name='adoptNo' value='"+memberAdopt.adoptNo+"'>").appendTo(infoForm);
				$("<input type='hidden' name='memberId' value='"+memberAdopt.memberId+"'>").appendTo(infoForm);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(infoForm);
				
				$.ajax({
					url : "/jnj/admin/member_adopt/cancle",
					type : "post",
					data : infoForm.serialize(),
					success:function( result ){
						console.log( "입양 취소하고 왓어영ㅋ" );
						
						$('#myModal').modal('hide');
						
						var resultMap = JSON.parse(result);
						
						// 테이블에 행 모두 지우기
						$("tbody>tr").each(function(idx){
							table .row( $(this) ).remove().draw();
						});
						
						// 바뀐 내용으로 화면 새로 그리기
						display_setting( 1, resultMap.pagination, resultMap.memberAdoptList );
						display_CSS();
					}
				});
			});
			
			$("#adoptTable").on("click", "#adoptDetails", function(){
				console.log( "상세보기 클릭 : " + $(this).attr("data-pet") );
				window.open("/jnj/admin/member_adopt/detail?petNo="+$(this).attr("data-pet"), 
						"관리자 - 입양 상세보기", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			
			// 변수 초기화
			function initValues( map  ){
				$map = map;
				$memberAdoptList = $map.memberAdoptList;
				$info = $map.adMAdoptInfo;
				$pagination = $map.pagination;
				
				$member = ${member};
				$info.memberId = $member.memberId;
				
				$state	= $map.stateCount;
				console.log($state);
			}
			
			// 화면 셋팅
			function display_setting( state, page, memberAdoptList ){
				
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
				
				$.each(memberAdoptList, function(idx, adopt) {
					
					table.row.add( [
						adopt.centerName,
						currentPetSort(adopt.petSort),
						adopt.petName,
						adopt.adoptApplyDate,
						currentMemberAdoptState( adopt.petNo, adopt.petState, idx ),
						createBtn
			        ]).draw(false);
					
				});
				
				
             	$("#total").text( "0건" );
				$("#receipt").text( "0건" );
				$("#process").text( "0건" );
				$("#adopt").text( "0건" );
				$("#can").text( "0건" );
				$("#etc").text( "0건" );
				var totalNum = 0;
				
				$.each( $state, function(idx, state){
					var index = ($state[idx].PETSTATE);
					var num = $state[idx].COUNT;
					if( index == PET_STATE_RECEIPT )	 	$("#receipt").text( num+"건" );
					else if( index == PET_STATE_PROCESS )	$("#process").text( num+"건" );
					else if( index == PET_STATE_ADOPT )	 	$("#adopt").text( num+"건" );
					else if( index == PET_STATE_STANDBY )	$("#can").text( num+"건" );
					else									$("#etc").text( num+"건" );
					totalNum += num;
				});
				$("#total").text( totalNum+"건" );
				
				
				// 페이지네이션
				var ul = $(".pagination");
				ul.empty();
				
				if( page.prev > -1 ){
					var li = $("<li class='paginate_button page-item previous' id='dataTable_previous'></li>").appendTo(ul);
					$("<a href='#' class='page-link' data-page="+page.prev+">Previous</a>").appendTo(li);
				}
				for( var i=page.startPage; i<=page.endPage; i++ ){
					var li = $("<li class='pagination_button page_item active'></li>").appendTo(ul);
					$("<a href='#' class='page-link' data-page="+i+">"+i+"</a>").appendTo(li);
				}
				if( page.next > -1 ){
					var li = $("<li class='paginate_button page-item next' id='dataTable_next'></li>").appendTo(ul);
					$("<a href='#' class='page-link' data-page="+page.next+">Next</a>").appendTo(li);
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
				
				display_setting( 1, resultMap.pagination, resultMap.memberAdoptList );
				display_Search();
				display_CSS();
				
			}
			
			function searchState(colName, find){
				
				$info.searchColName = colName;
				$info.searchText = find;
				
				$.ajax({
					url 	: "/jnj/admin/member_adopt/sort",
					type 	: "get", 
					data	: formDataSetting(),
					success : function(result){
						 var resultMap = JSON.parse(result);
						
						// 테이블에 행 모두 지우기
						$("tbody>tr").each(function(idx){
							table .row( $(this) ).remove().draw();
						});
						
						// 바뀐 내용으로 화면 새로 그리기
						display_setting( 1, resultMap.pagination, resultMap.memberAdoptList );
						display_CSS();
					}
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
				
				// 위의 상태 건 수를 클릭 했을때를 위해서
				/* if( select != $info.searchColName ){
					$("#mSelect").val($info.searchColName);
					select = $("#mSelect").val();
				} */
				
				if( select != "petState" && $info.searchColName == "petState" )
					$info.searchText = "%";
				
				if( select == "centerName" || select == "petName" ){
					selectTextDiv.show();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				
				else if( select == "petSort" ){
					selectTextDiv.hide();
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
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value='0'>전체</option>").appendTo( selectbox );
					$("<option value='1'>취소</option>").appendTo( selectbox );
					$("<option value='2'>접수</option>").appendTo( selectbox );
					$("<option value='3'>진행</option>").appendTo( selectbox );
					$("<option value='4'>입양</option>").appendTo( selectbox );
					$("<option value='5'>안락사</option>").appendTo( selectbox );
					
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
					url 	: 	"/jnj/admin/member_adopt/sort",
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
			
			var createBtn;
			function currentMemberAdoptState( petNo, petState, idx ){
				
				var strState = "취소";
				createBtn = "<a href='#' id='adoptDetails' data-idx='"+idx+"' data-pet='"+petNo+"'>상세보기</a>"
									+"<br>"
									+"<a href='#' id='adoptCancle' data-idx='"+idx+"'>취소</a>";
				
				if( petState == PET_STATE_STANDBY ){
					strState = "취소";
					createBtn = "<a href='#' id='adoptDetails' data-idx='"+idx+"' data-pet='"+petNo+"'>상세보기</a>"
				}
				else if( petState == PET_STATE_RECEIPT )
					strState = "접수";
				else if( petState == PET_STATE_PROCESS )
					strState = "진행";
				else if( petState == PET_STATE_ADOPT ){
					strState = "입양";
					createBtn = "<a href='#' id='adoptDetails' data-idx='"+idx+"' data-pet='"+petNo+"'>상세보기</a>"
				}
				else if( petState == PET_STATE_MERCY ){
					strState = "안락사";
					createBtn = "<a href='#' id='adoptDetails' data-idx='"+idx+"' data-pet='"+petNo+"'>상세보기</a>"
				}
				return strState;
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
			
		});
		
	</script>
</head>
<body>
    
    <div id="scorpTotal">
    
    	<div id="tableTotal">
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 입양 내역 </div>
				<div class="card-body">
					
					<div id="totlaNumDiv">
					
						<div class="alert alert-success" id="totalBtn">
	                    	<span>전체 : </span>
	                    	<span id="total"></span>
	                    </div>
	                    
                    	<div class="alert alert-success" id="receiptBtn">
	                    	<span>접수 : </span>
	                    	<span id="receipt"></span>
	                    </div>
	                    
	                    <div class="alert alert-success" id="processBtn">
	                    	<span>진행중 : </span>
	                    	<span id="process"></span>
	                    </div>
	                    
	                    <div class="alert alert-success" id="adoptBtn">
	                    	<span>입양완료 : </span>
	                    	<span id="adopt"></span>
	                    </div>
		        
		        		<div class="alert alert-success" id="canBtn">
	                    	<span>취소 : </span>
	                    	<span id="can"></span>
	                    </div>
	                    
			        	<div class="alert alert-success" id="etcBtn">
	                    	<span>기타 : </span>
	                    	<span id="etc"></span>
	                    </div>
                     </div>
                     
					<div id="aanav" style="background-color:white; overflow:hidden;">
						<ol id="sortAdopt" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="aTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aCenter" href="#">센터별</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aSort" href="#">동물 분류별</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aName" href="#">동물이름순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aDate" href="#">최신순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="aState" href="#">상태별</a>
							</li>
						</ol>
			    	</div>
					
					<table id="adoptTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>센터명</th>
					        	<th>분류</th>
					            <th>이름</th>
					            <th>신청날짜</th>
					            <th>상태</th>
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
					<option value="adoptApplyDate">날짜</option> 
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