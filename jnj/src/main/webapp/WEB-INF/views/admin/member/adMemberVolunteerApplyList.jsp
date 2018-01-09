<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title></title>
	
	<script>
	
		$(function(){
			
			var VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE 		= 0;	// 취소(거절)
			var VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_RECURIT 		= 1;	// 모집중
			var VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_COMPLETE 	= 2;	// 완료
			var VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_LACK 		= 3;	// 인원미달
			
			var table;
			var modalBody = $("#modalBody");
			
			var tempMap = ${map};
			var $detailState;
			var $member;
			var $getMypageMemberVolunteerList;
			var $pagination;
			
			
			initValues( tempMap );
			display_setting( 0 );
			display_CSS();
			
			
			// 개인별 봉사 취소 클릭 시
			$("#applyTable").on("click", ".cancleBtn", function(){
				
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("봉사 신청을 취소 시키시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
				
			});
			
			
			// 개인별  참가 취소 확인을 눌렀을 때
			$("#myModal").on("click", "#yesBtn", function(){
				
				var index = $(this).attr("data-idx");
				
				$.ajax({
					url : "/jnj/admin/member_volunteer/apply_cancle",
					type : "post",
					data : {
						"volunteerNo" : $getMypageMemberVolunteerList[index].volunteerNo,
						"applyId" : $getMypageMemberVolunteerList[index].memberId,
						"memberId" : $member.memberId,
						"${_csrf.parameterName}" : "${_csrf.token}"
					},
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
				
			});
			
			
			// 목록 클릭 시
			$("#backBtn").on("click", function(){
				console.log("목록으로 돌아갑니다.");
				location.href = "/jnj/admin/member_volunteer?hostId=" + $member.memberId;
			});
			
			// 체크 클릭 시 모두 클릭 될 수 있도록 처리하기
			var state = false;
			$("#allCheck").on("click", function() {
				
				if( $("input[id='allCheck']").is(":checked") ) 		state = true;
				else 												state = false;
				
				$("input[name='check']:checkbox").each(function(idx) {
					$(this).prop("checked", state)
				});
			});
			
			// 선택 거절 클릭 시
			$("#selectDelete").on("click", function(e){
				
				e.preventDefault();
				console.log("선택거절 클릭");

				var cnt=0;
				$("input[name='check']:checked").each(function(idx) {
					cnt++;
				});
				
				if( !$("input[id='allCheck']").is(":checked") && cnt <=0 ){
					modalBody.empty();
					$("<p id='modalText1'></p>").text("선택해주세요").appendTo(modalBody);
					$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>확인</button>").appendTo(modalBody);
					$("#myModal").modal();
				}
				
				else{
					modalBody.empty();
					$("<p id='modalText1'></p>").text("정말로 선택한 신청을 취소하시겠습니까?").appendTo(modalBody);
					$("<button type='button' id='selectYesBtn' class='btn btn-default' data-dismiss='modal'>확인</button>").appendTo(modalBody)
					.css("margin-right", "10px");
					$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
					$("#myModal").modal();
				}
			});
			
			
			// 개인별  참가 취소 확인을 눌렀을 때
			$("#myModal").on("click", "#selectYesBtn", function(){
				
				var check = false;	// 만약 거절 가능한 사용자가 존재하지 않는다면 false
				
				var form = $("#infoFrm");
				form.empty();
			    
				// 체크가 된 사용자만 찾아서 form에 정보를 셋팅한다
				$("input[name='check']:checked").each(function(idx) {
			    	console.log( $(this).attr("data-idx") );
			    	var obj = $getMypageMemberVolunteerList[$(this).attr("data-idx")];
			    	
			    	if( obj.volunteerApplyState == VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_RECURIT){
			    		check = true;
			    		$("<input type='hidden' name='applyId' value='"+ obj.memberId +"' multiple='multiple' >").appendTo(form);
				    	$("<input type='hidden' name='volunteerNo' value='"+ obj.volunteerNo +"' multiple='multiple' >").appendTo(form);
				    	$("<input type='hidden' name='memberId' value='"+$member.memberId +"' multiple='multiple' >").appendTo(form);
			    	}
			    });
			    $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
			   
			    if( check == true ){
				    $.ajax({
			    		url : "/jnj/admin/member_volunteer/apply_cancle",
			    		type: "post",
			    		data: form.serialize(),
			    		success:function(result){
			    			
			    			// 체크박스 전부 지우기
			    			$("input[id='allCheck']").prop("checked", false);
			    			$("input[name='check']:checkbox").each(function(idx) {
								$(this).prop("checked", false)
							});
			    			
			    			$("#myModal").modal("hide");
			    			display_Resetting(result);
			    		}
			    	});
			    }
			    else{
			    	// 체크박스 전부 지우기
	    			$("input[id='allCheck']").prop("checked", false);
	    			$("input[name='check']:checkbox").each(function(idx) {
						$(this).prop("checked", false)
					});
			    }
				
			});
			
			
			// 변수 초기화
			function initValues( map ){
				
				$member = ${member};
				$detailState = map.detailState;
				console.log("ddd : " + $detailState);
				$getMypageMemberVolunteerList = map.getMypageMemberVolunteerList;
				$pagination = map.pagination;
			}
			
			
			// 화면 셋팅
			function display_setting( state ){
				
				if( state == 0 ){
					table = $("#applyTable").DataTable({
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
				
				var total = 0;
				$.each($getMypageMemberVolunteerList, function(idx, apply) {
					
					total++;
					table.row.add( [
						"<input type='checkbox' name='check' data-idx='"+idx+"'>"+apply.memberId,
						apply.memberName,
						apply.applyTel,
						apply.applyDate,
						currentVolunteerState( apply.volunteerApplyState ),
						currentBtnState( apply.volunteerApplyState, idx )
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
				
				$("#currentPage").text("봉사 모집 - 신청자 목록(총 "+total+"명)");
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
				
				$("#backBtn").css({
					"display": "inline-block",
					"width": "100px",
					"float": "right",
					"margin-bottom": "20px",
					"margin-right": "20px"
				})
				
				$("#currentPage").css({
				    "margin": "0px",
				    "background-color": "white",
				    "float": "left",
				    "font-weight": "bold",
				    "font-size": "20px"
				})
				
				
				// 메뉴 삭제 css
				$("#selectMenu").css({
					"overflow" : "hidden"
				});
				$("#selectDelete").css({
					"display": "inline-block",
				    "float": "right",
				    "margin-right": "10px"
				});
				
			}

			// 봉사 상태
			function currentVolunteerState( volunteerApplyState ){
				var strState = "";
				
				if( volunteerApplyState == 0 ) 		strState = "취소(거절)";
				else{
					if( $detailState == 1 ) 		strState = "신청완료(모집중)";
					else if( $detailState == 2 ) 	strState = "신청완료(모집완료)";
					else if( $detailState == 3 ) 	strState = "신청완료(봉사완료)";
					else 							strState = "신청완료(인원미달)";
				}
				return strState;
			}
			
			// 봉사 버튼 상태
			function currentBtnState( volunteerApplyState, idx ){
				var strState = "";
				if( volunteerApplyState == 0 ) 		strState = "-";
				else{
					if( $detailState == 1 ) 		strState = "<a href='#' class='cancleBtn' data-idx='"+idx+"'>참가 취소</a>";
					else if( $detailState == 2 ) 	strState = "-";
					else if( $detailState == 3 ) 	strState = "-";
					else 							strState = "-";
				}
				return strState;
			}
			
		});
		
	</script>
</head>
<body>
    
    <div id="scorpTotal">
    
    	<div id="vvnav" style="background-color:white; overflow:hidden;">
			<span id="currentPage" style="margin:0px; background-color:white; float:left">봉사 모집 - 신청자 목록</span>
			<a class="btn btn-primary btn-block" id="backBtn" href="#">목록</a>
    	</div>
    	
    	<div id="tableTotal">
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 참가자 목록 </div>
				<div class="card-body">
					<div id="selectMenu">
						<a href='#' class='page-link' id="selectDelete">선택거절</a>
					</div>
					<table id="applyTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th><input type='checkbox' id='allCheck'>&nbsp;아이디</th>
					            <th style="width:80px;">신청자</th>
					           	<th style="width:80px;">전화번호</th>
					            <th style="width:100px;">신청날짜</th>
					            <th>상태</th>
					            <th style="width:80px;">기타</th>
					        </tr>
					    </thead>
					</table>
				</div>
			</div>
		</div>
		
		<!-- 
		<div id="searchSelectDiv">
			<div id="selectDiv">
				<select id="mSelect" class="form-control"> 
					<option value="volunteerArea">지역</option> 
					<option value="volunteerTitle">제목</option> 
					<option value="hostId">주최자</option> 
					<option value="writeDate">날짜</option> 
					<option value="volunteerState">상태</option> 
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
		</div> -->
		
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