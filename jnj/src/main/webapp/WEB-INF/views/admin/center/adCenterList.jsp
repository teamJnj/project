<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>Admin Base Page</title>
	<script>
	
	// 상수 값 지정
	var CENTER_ID = 0;
	
	// 상수 값 지정
	var BLOCK 	= 0;
	var USE		= 1;
	var JOIN	= 2;
	var RESIGNS	= 3;
	var RESIGN	= 4;
	
	var table;
	
	$(function(){
		
		var tempMap = ${map};
		var $mapList;
		var $pagination;
		var $centerList;
		
		initValues( tempMap );
		display_setting( 0 );
		display_CSS();
		
		
		$("#totalBtn").on("click", function(){
			searchState( "center_state", "");
		});
		
		$("#useBtn").on("click", function(){
			searchState( "center_state", "1");
		});
		
		$("#blockBtn").on("click", function(){
			searchState( "center_state", "0");		
		});
				
		$("#joinBtn").on("click", function(){
			searchState( "center_state", "2");
		});
		
		$("#resignBtn").on("click", function(){
			searchState( "center_state", "3");
		});
		
		$("#resignBtn1").on("click", function(){
			searchState( "center_state", "4");
		});
		
		
		// 검색창에 포커스를 얻었을 때 인풋창 빈칸으로
		$("#searchText").focus(function(){
			$("#searchText").val("");
		});
		
		
		// 검색 selectbox가 바뀔 때
		$("#mSelect").change(function(){
			$("#searchText").val("");
			searchSelectBox();
			display_CSS();
		});
		
		
		// 검색 버튼을 클릭 시
		$("#searchBtn").on( "click", function (){
			
			var checkScreen = ($("#mSelect").val() != "center_state")? true : false;
			
			if( $("#searchText").val() == "" && checkScreen ){
				console.log("모달생성");
				// 모달창 생성
				var modalBody = $("#modalBody");
				modalBody.empty();
				$("<p id='modalText'></p>").text("검색어를 입력해주세요").appendTo(modalBody);
				$("<button type='button' id='closeBtn' class='btn btn-default'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				display_CSS();
				return;
			}
			
			// 검색 컬럼명과 값 폼에 셋팅하기
			var form = $("#searchFrm");
			var formAddDiv = $("#addInput");
			$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(formAddDiv);
			$("<input type='hidden' name='colName' value="+$("#mSelect option:selected").val()+" />").appendTo(formAddDiv);
			
			if( checkScreen )
				$("<input type='hidden' name='find' value="+$("#searchText").val()+" />").appendTo(formAddDiv);
			else
				$("<input type='hidden' name='find' value="+$("#authoritySelect option:selected").val()+" />").appendTo(formAddDiv);
			
			var url = form.serialize();
			//formAddDiv.empty();
			
			$.ajax({
				url 	: "/jnj/admin/center/search",
				type 	: "get", 
				data	: url,
				success : function(result){
					
					var resultMap = JSON.parse(result);
					
					// 테이블에 행 모두 지우기
					$("tbody>tr").each(function(idx){
						table .row( $(this) ).remove().draw();
					});
					
					// 바뀐 내용으로 화면 새로 그리기
					initValues( resultMap );
					display_setting( 1 );
					display_CSS();
				}
			});
		});
		
		// 모달 창 close 버튼 동작 ( 공통 )
		$("#modelTotal").on("click", "#closeBtn", function(){
			console.log("눌렀습니다.");
			$(this).attr( "data-dismiss", "modal");
		});
		
		// 상세보기 클릭 시
		$("#centerTable").on("click",".detail", function(){
			window.open("/jnj/admin/center_info?centerId="+$centerList[$(this).attr("data-idx")].centerId, '센터 상세 정보', 'width=1200, height=1200');
		});
		
		// 가입대기 클릭 시
		$("#joinAccept").on("click", function(){
			window.open("/jnj/admin/center_info?centerId="+$centerList[$(this).attr("data-idx")].centerId, '센터 상세 정보', 'width=1200, height=1200');
		});
		
		// 탈퇴대기 클릭 시
		$("#resignAccept").on("click", function(){
			window.open("/jnj/admin/center_info?centerId="+$centerList[$(this).attr("data-idx")].centerId, '센터 상세 정보', 'width=1200, height=1200');
		});
		
		// 변수 초기화
		function initValues( map ){
			$mapList = map.mapList;
			$centerList = map.centerList;
			$pagination = map.pagination;
		}
	
		// 화면 셋팅
		function display_setting( state ){
			
			if( state == 0 ){
				// 테이블 초기화
				table = $("#centerTable").DataTable({
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
			
			$("#block").text( "0명" );
			$("#use").text( "0명" );
			$("#join").text( "0명" );
			$("#resign").text( "0명" );
			$("#resign1").text( "0명" );
			console.log( $mapList );
			var totalNum = 0;
			$.each( $mapList, function(idx, center){
				var index = ($mapList[idx].CENTERSTATE);
				var num = $mapList[idx].COUNT;
				if( index == BLOCK )	
					$("#block").text( num+"명" );
				else if( index == USE )	
					$("#use").text( num+"명" );
				else if( index == JOIN )	
					$("#join").text( num+"명" );
				else if( index == RESIGNS )
					$("#resign").text( num+"명" );
				else
					$("#resign1").text( num+"명" );
				totalNum += num;
			});
			$("#total").text( totalNum+"명" );
			
			$.each($centerList, function(idx, center) {
	
				var centerState;
				if( center.centerState == USE )				centerState = "<span>사용중</span>";
				else if( center.centerState == BLOCK )		centerState = "<span style='color:green; font-weight:bold'>블락</span>";
				else if( center.centerState == JOIN )		centerState = "<span style='color:red; font-weight:bold'>가입대기</span>"
				else if( center.centerState == RESIGNS )	centerState = "<span style='color:red; font-weight:bold'>탈퇴대기</span>"
				else										centerState = "<span style='color:blue; font-weight:bold'>탈퇴회원</span>"
					
				// 테이블 행 추가
				table.row.add( [
					center.centerId,
					center.centerName,
					center.centerTel,
					center.email,
					center.homepage,
					centerState,
		           	"<a href='#' class='detail' data-idx='"+idx+"'>상세보기</a>"
		        ] ).draw( false );
				
			});
			
			searchSelectBox();
			$("#addInput").empty();
			
			// 페이지네이션
			var ul = $(".pagination");
			ul.empty();
			
			if( $pagination.prev > -1 ){
				var li = $("<li class='paginate_button page-item previous' id='dataTable_previous'></li>").appendTo(ul);
				$("<a href='/jnj/admin/center?pageno="+$pagination.prev+"' class='page-link'>Previous</a>").appendTo(li);
			}
			for( var i=$pagination.startPage; i<=$pagination.endPage; i++ ){
				var li = $("<li class='pagination_button page_item active'></li>").appendTo(ul);
				$("<a href='/jnj/admin/center?pageno="+i+"' class='page-link'>"+i+"</a>").appendTo(li);
			}
			if( $pagination.next > -1 ){
				var li = $("<li class='paginate_button page-item next' id='dataTable_next'></li>").appendTo(ul);
				$("<a href='/jnj/admin/center?pageno="+$pagination.next+"' class='page-link'>Next</a>").appendTo(li);
			}
		}
	
	
		function searchState(colName, find){
			
			// 검색 컬럼명과 값 폼에 셋팅하기
			var form = $("#searchFrm");
			var formAddDiv = $("#addInput");
			$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo(formAddDiv);
			$("<input type='hidden' name='colName' value="+colName+" />").appendTo(formAddDiv);
			$("<input type='hidden' name='find' value='"+find+"' />").appendTo(formAddDiv);
			
			var url = form.serialize();
			//formAddDiv.empty();
			
			console.log(url)
			$.ajax({
				url 	: "/jnj/admin/center/search",
				type 	: "get", 
				data	: url,
				success : function(result){
					
					var resultMap = JSON.parse(result);
					
					// 테이블에 행 모두 지우기
					$("tbody>tr").each(function(idx){
						table .row( $(this) ).remove().draw();
					});
					
					// 바뀐 내용으로 화면 새로 그리기
					initValues( resultMap );
					display_setting( 1 );
					display_CSS();
				}
			});
			
		}
		
		
		function searchSelectBox(){
			
			if( $("#mSelect").val() != "center_state" ){
				$("#searchText").val("").show();
				$("#authoritySelect").hide();
			}
			else{
				$("#searchText").val("").hide();
				$("#authoritySelect").show();
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
	});
	
    </script>
</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
 
	<div class="content-wrapper">
    	<div class="container-fluid">
    	
    		<div class="card mb-3">
		        <div class="card-header"> <i class="fa fa-table"></i> 센터 회원 목록 </div>
		        <div class="card-body">
                    
                    <div id="totlaNumDiv">
                    	<div class="alert alert-success" id="totalBtn">
	                    	<span>전체 : </span>
	                    	<span id="total"></span>
	                    </div>
	                    
	                    <div class="alert alert-success" id="useBtn">
	                    	<span>이용중 : </span>
	                    	<span id="use"></span>
	                    </div>
	                    
	                    <div class="alert alert-warning" id="blockBtn">
	                    	<span>블락 : </span>
	                    	<span id="block"></span>
	                    </div>
		        
			        	<div class="alert alert-danger" id="joinBtn">
	                    	<span>가입대기 : </span>
	                    	<span id="join"></span>
	                    </div>
	                    
	                    <div class="alert alert-danger" id="resignBtn">
	                    	<span>탈퇴대기 : </span>
	                    	<span id="resign"></span>
	                    </div>
	                    
	                     <div class="alert alert-danger" id="resignBtn1">
	                    	<span>탈퇴회원 : </span>
	                    	<span id="resign1"></span>
	                    </div>
                     </div>
		        
		    		<table id="centerTable" class="table display" cellspacing="0" width="100%">
				        <thead>
				            <tr>
				                <th>ID</th>
				                <th>센터명</th>
				                <th>전화</th>
				                <th>이메일</th>
				                <th>홈페이지</th>
				                <th>상태</th>
				                <th>기타</th>
				            </tr>
				        </thead>
				    </table>
				</div>
			</div>
			
			
			<div id="searchSelectDiv">
				<div id="selectDiv">
					<select id="mSelect" class="form-control"> 
						<option value="center_id">ID</option> 
						<option value="center_name">센터명</option> 
						<option value="email">이메일</option> 
						<option value="homepage">홈페이지</option> 
						<option value="center_state">상태</option> 
					</select>
				</div>
				<div id="searchDiv">
					<form id="searchFrm" class="form-inline my-2 my-lg-0 mr-lg-2">
		            	<div class="input-group">
		              		<input id="searchText" class="form-control" type="text" placeholder="Search for...">
		              		<select id="authoritySelect" class="form-control">
		              			<option value="1">사용중</option>
		              			<option value="2">가입대기</option>
		              			<option value="3">탈퇴대기</option>
		              			<option value="0">블락</option>
		              		</select>
		              		<span class="input-group-btn">
			                	<button id="searchBtn" class="btn btn-primary" type=button><i class="fa fa-search"></i></button>
		              		</span>
		              		<div id="addInput"> </div>
		            	</div>
		          	</form>
	          	</div>
          	</div>
          	
          	<br>
			
			<div id="pageDiv">
				<ul class="pagination">
				</ul>
			</div>
			
    	</div><!-- container-fluid -->
    </div><!-- content-wrapper -->
    
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