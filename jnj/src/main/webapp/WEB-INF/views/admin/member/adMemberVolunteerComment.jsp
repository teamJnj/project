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
			
			var TYPE_RECURIT 	= 1;				// 모집내역
			var TYPE_APPLY 		= 2;				// 참여내역
			var screenState 	= TYPE_RECURIT;
			
			var VOLUNTEER_VOLUNTEERSTATE_BLOCK 		= 0;
			var VOLUNTEER_VOLUNTEERSTATE_RECURIT 	= 1;
			var VOLUNTEER_VOLUNTEERSTATE_COMPLETE 	= 2;
			
			var tempMap = ${map};
			var $memberVolunteerCommentList;
			var $info;
			var $pagination;
			var $member;
			
			initValues( tempMap );
			display_setting( 0 );
			display_Search();
			display_CSS();
			
			// 전체보기 정렬
			$("#vTotal").on("click", function(e){
				e.preventDefault();
				$info.colName = null;
				$info.sortType = null;
				$info.searchColName = null;
				$info.searchText = null;
				sortSelect();
			});
			
			// 제목순
			$("#vTitle").on("click", function(e){
				e.preventDefault();
				$info.colName = "volunteerTitle";
				sortSelect();
			});
			
			// 내용순
			$("#vContent").on("click", function(e){
				e.preventDefault();
				$info.colName = "commentContent";
				sortSelect();
			});
			
			// 내용순
			$("#vDate").on("click", function(e){
				e.preventDefault();
				$info.colName = "writeDate";
				sortSelect();
			});
			
			
			// 검색 selectbox가 바뀔 때
			$("#mSelect").change(function(){
				display_Search();
				display_CSS();
			});
			
			
			// 검색 버튼을 클릭 시
			$("#searchBtn").on( "click", function (){
				
				var selectbox = $("#mSelect").val();
				$info.searchText = "%";
				
				// 현재 무엇을 검색했는지 판단하고 검색한 값을 가져온다
				$info.searchColName = $("#mSelect option:selected").val();
				if( selectbox == "volunteerTitle" || selectbox == "commentContent"){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "volunteerArea"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "writeDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				$.ajax({
					url 	: "/jnj/admin/member_volunteer/comment/sort",
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
				console.log("duirl");
				location.href="/jnj/admin/member_volunteer/comment?"+formDataSetting();
			});
			
			
			// 제목을 클릭 시 상세뷰로!
			$("#volTable").on("click", ".title", function(e){
				e.preventDefault();
				console.log( "제목을 클릭" );
				console.log( $memberVolunteerCommentList[$(this).attr("data-idx")].volunteerNo );
				//location.href="/jnj/admin/member_volunteer/view?volunteerNo="+$memberVolunteerCommentList[$(this).attr("data-idx")].volunteerNo+"&memberId="+$member.memberId;
				window.open("/jnj/admin/member_volunteer/view?volunteerNo="+$memberVolunteerCommentList[$(this).attr("data-idx")].volunteerNo+"&memberId="+$member.memberId,
						"관리자 - 봉사 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 참여에서 참여 취소를 클릭 시
			$("#volTable").on("click", ".deleteBtn", function(){
				console.log("삭제 클릭 : " + $(this).attr("data-idx"));
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("정말 삭제하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='cancleBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
				.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				
			});
			
			// 참여 - 참여취소 모달창 클릭시
			$("#myModal").on("click", "#cancleBtn", function(){
				
				var index = $(this).attr("data-idx");
				
				console.log($(this).attr("data-idx"));
				
				var form = $("#infoForm");
				form.empty();
				
			    $("<input type='hidden' name='volunteerNo' value='"+ $memberVolunteerCommentList[index].volunteerNo +"' multiple='multiple' >").appendTo(form);
			    $("<input type='hidden' name='volunteerCommentNo' value='"+ $memberVolunteerCommentList[index].volunteerCommentNo +"' multiple='multiple' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	console.log( formDataSetting()+"&"+form.serialize() );
				
		    	$.ajax({
					url : "/jnj/admin/member_volunteer/comment_delete",
					type : "post",
					data : formDataSetting()+"&"+form.serialize(),
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
			});
			
			
			$("#volRecordBtn").on("click", function(){
				location.href="/jnj/admin/member_volunteer?hostId="+$member.memberId;				
			});
			
			// 변수 초기화
			function initValues( map ){
				
				$memberVolunteerCommentList = map.memberVolunteerCommentList;
				$info = map.adMVolunteerCommentInfo;
				$pagination = map.pagination;
				
				$member = ${member};
				$info.writeId = $member.memberId;
				$info.memberId = $member.memberId;
				
				console.log("변수 초기화 셋팅합시다. initValues() ")
				console.log($memberVolunteerCommentList);
				console.log($info);
				console.log($pagination);
				console.log($member);
			}
			
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#volTable").DataTable({
						"paging": false,
						"searching": false,
						"ordering" : false,
						"autowidth": false,
						"columns": [
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false }
						]
					});
				}
				
				$.each($memberVolunteerCommentList, function(idx, volunteer) {
					table.row.add( [
						"<a href='#' class='title' data-idx='"+idx+"' >"+volunteer.volunteerTitle+"</a>",
						volunteer.commentContent,
						volunteer.writeDate,
						"<a href='#' class='deleteBtn' data-idx='"+idx+"' >삭제</a>"
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
				
				console.log("result");
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
				
				if( select == "volunteerTitle" || select == "commentContent" ){
					selectTextDiv.show();
					selectDateDiv.hide();
					selectboxDiv.hide();
				}
				else if( select == "volunteerArea" ){
					selectTextDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
					$("<option value='서울'>서울</option>").appendTo( selectbox );
					$("<option value='부산'>부산</option>").appendTo( selectbox );
					$("<option value='대구'>대구</option>").appendTo( selectbox );
					$("<option value='인천'>인천</option>").appendTo( selectbox );
					$("<option value='광주'>광주</option>").appendTo( selectbox );
					$("<option value='대전'>대전</option>").appendTo( selectbox );
					$("<option value='울산'>울산</option>").appendTo( selectbox );
					$("<option value='경기'>경기</option>").appendTo( selectbox );
					$("<option value='강원'>강원</option>").appendTo( selectbox );
					$("<option value='충북'>충북</option>").appendTo( selectbox );
					$("<option value='충남'>충남</option>").appendTo( selectbox );
					$("<option value='전북'>전북</option>").appendTo( selectbox );
					$("<option value='전남'>전남</option>").appendTo( selectbox );
					$("<option value='경북'>경북</option>").appendTo( selectbox );
					$("<option value='전남'>전남</option>").appendTo( selectbox );
					$("<option value='경북'>경북</option>").appendTo( selectbox );
					$("<option value='경남'>경남</option>").appendTo( selectbox );
					$("<option value='제주'>제주</option>").appendTo( selectbox );
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
				
				// 최상단 메뉴버튼 스타일( 후원, 댓글 메뉴)
				$("#menuDiv").css("margin", "20px");
				$("#sponsorRecordBtn").css("margin-right", "5px");
			}
			
			
			// 정렬 눌렀을 때 동작
			function sortSelect(){
				$info.pageno = 1;
				$info.sortType = (( $info.sortType  == null )?"asc" : (( $info.sortType  == "desc")? "asc" : "desc"));
				
				$.ajax({
					url 	: 	"/jnj/admin/member_volunteer/comment/sort",
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
				if( $info.memberId != null ) $("<input type='hidden' name='writeId' value='"+$info.writeId+"' >").appendTo( form );
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
				
				return result;
			}
			
		});
		
	</script>
</head>
<body>
    
    <div id="scorpTotal">
    
    	<div id="tableTotal">
    	
    		<div id="menuDiv">
    			<button type="button" class="btn btn-warning" id="volRecordBtn" >봉사내역</button>
    			<button type="button" class="btn btn-warning" id="volCommentBtn" disabled="disabled">봉사댓글</button>
    		</div>
    	
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 봉사댓글내역 </div>
				<div class="card-body">
					
					<div id="vvnav" style="background-color:white; overflow:hidden;">
						<ol id="sortVol" class="breadcrumb" style="background-color:white; float:right">
							<li class="breadcrumb-item">
								<a id="vTotal" href="#">전체</a>
							</li>
							<li class="breadcrumb-item">
								<a id="vTitle" href="#">제목순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="vContent" href="#">내용순</a>
							</li>
							<li class="breadcrumb-item">
								<a id="vDate" href="#">날짜순</a>
							</li>
						</ol> 
			    	</div>
					
					<table id="volTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>제목</th>
					            <th>내용</th>
					            <th style="width:100px;" >날짜</th>
					            <th style="width:100px;" >기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="volunteerArea">지역</option> 
					<option value="volunteerTitle">제목</option> 
					<option value="commentContent">내용</option> 
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
		
		<form id="infoForm" class="form-inline my-2 my-lg-0 mr-lg-2">
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