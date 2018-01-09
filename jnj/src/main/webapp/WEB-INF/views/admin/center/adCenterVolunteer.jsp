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
			
			var VOLUNTEER_VOLUNTEERSTATE_BLOCK 		= 0;
			var VOLUNTEER_VOLUNTEERSTATE_RECURIT 	= 1;
			var VOLUNTEER_VOLUNTEERSTATE_COMPLETE 	= 2;
			
			var tempMap = ${map};
			var $centerVolunteerList;
			var $info;
			var $pagination;
			var $center;
			var $totalVolunteerState;
			
			var $totalDetailState;
			var $center;
			var $totalApplyState;
			
			initValues( tempMap );
			display_setting( 0 );
			display_totalState();
			display_Search();
			display_CSS();
			
            $("#totlaNumDiv").on("click", "#sTotalBtn", function(e){
            	$info.pageno = 1;
				searchState("volunteerState", "");
			});
            
			$("#totlaNumDiv").on("click", "#sRecruitingBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "1-1");
			});
			
			$("#totlaNumDiv").on("click", "#sRecruitBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "1-2");
			});
			
			$("#totlaNumDiv").on("click", "#sVolCompletBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "1-3");
			});
			
			$("#totlaNumDiv").on("click", "#sFailBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "1-4");
			});
			
			$("#totlaNumDiv").on("click", "#sBlockBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "3");
			});
			
			$("#totlaNumDiv").on("click", "#sCancleBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "2");
			});
			
			
			
			
			$("#totlaNumDiv").on("click","#saTotalBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "2");
			});
			
			$("#totlaNumDiv").on("click","#saCancleBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "0");
			});
			
			$("#totlaNumDiv").on("click","#saApplyBtn", function(e){
				$info.pageno = 1;
				searchState("volunteerState", "1");
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
				if( selectbox == "volunteerTitle" || selectbox == "hostId"){
					$info.searchText = $("#searchText").val();
				}
				else if( selectbox == "volunteerArea"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "volunteerState"){
					$info.searchText = $("#selectedOption option:selected").val();
				}
				else if( selectbox == "writeDate"){
					$info.startDate = $("#searchDate1").val();
					$info.endDate = $("#searchDate2").val();
				}
				
				$.ajax({
					url 	: "/jnj/admin/center_volunteer/sort",
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
				
				console.log( $info );
				location.href="/jnj/admin/center_volunteer?"+formDataSetting();
			});
			
			// 신청 인원을 클릭 시 신청자 목록으로!
			$("#volTable").on("click", ".applyPeople", function(e){
				e.preventDefault();
				console.log( "신청인원을 클릭" );
				console.log( $centerVolunteerList[$(this).attr("data-idx")].volunteerNo );
				location.href="/jnj/admin/center_volunteer/apply_list?detailState="+$centerVolunteerList[$(this).attr("data-idx")].detailState+"&volunteerNo="+$centerVolunteerList[$(this).attr("data-idx")].volunteerNo+"&centerId="+$center.centerId;			
			});
			
			
			// 제목을 클릭 시 상세뷰로!
			$("#volTable").on("click", ".title", function(e){
				e.preventDefault();
				window.open("/jnj/admin/center_volunteer/view?volunteerNo="+$centerVolunteerList[$(this).attr("data-idx")].volunteerNo+"&centerId="+$center.centerId,
					"관리자 - 봉사 상세", "'width="+$( window ).width()+", height="+$( window ).height()+"'"); 
			});
			
			// 모집에서 글 삭제를 클릭 시
			$("#volTable").on("click", ".deleteBtn", function(){
				// 모달창 생성
				modalBody.empty();
				$("<p id='modalText1'></p>").text("글을 삭제하시겠습니까?").appendTo(modalBody);
				$("<p id='modalText2'></p>").text("참여자가 있을 경우 안내 쪽지를 보냅니다.").appendTo(modalBody);
				$("<button type='button' id='yesBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"'>확인</button>").appendTo(modalBody)
						.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			});
			
			
			// 글 삭제 모달창 확인 팝업
			$("#myModal").on("click", "#yesBtn", function(){
				
				var strUrl = formDataSetting()+"&volunteerNo="+$centerVolunteerList[$(this).attr("data-idx")].volunteerNo+"&${_csrf.parameterName}=${_csrf.token}";
				console.log(strUrl);
				$.ajax({
					url : "/jnj/admin/center_volunteer/delete",
					type : "post",
					data : strUrl,
					success : function(result){
						console.log("글을 삭제하고 왓습니다.");
						$("#myModal").modal("hide");
						display_Resetting( result );
					}
				});
				
			});
			

			// 참여에서 참여 취소를 클릭 시
			$("#volTable").on("click", "#joinBtn", function(){
				console.log("참여 취소 클릭 : " + $(this).attr("data-idx"));
				
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
				console.log("모달 예쓰! : " + $centerVolunteerList[$(this).attr("data-idx")].volunteerNo );
				
				var form = $("#infoForm");
				form.empty();
				
			    $("<input type='hidden' name='applyId' value='"+ $center.centerId +"' multiple='multiple' >").appendTo(form);
			    $("<input type='hidden' name='volunteerNo' value='"+ $centerVolunteerList[index].volunteerNo +"' multiple='multiple' >").appendTo(form);
			    //$("<input type='hidden' name='centerId' value='"+ $center.centerId +"' multiple='multiple' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	console.log( formDataSetting()+"&"+form.serialize() );
				
		    	$.ajax({
					url : "/jnj/admin/center_volunteer/apply/apply_cancle",
					type : "post",
					data : formDataSetting()+"&"+form.serialize(),
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
				
			});

			// 봉사댓글 클릭 시
			$("#volCommentBtn").on("click", function(){
				location.href="/jnj/admin/center_volunteer/comment?centerId="+$center.centerId+"&writeId="+$center.centerId;				
			});
			
			
			// 블락 클릭 시
			$("#volTable").on("click", ".blockBtn", function(){
				
				modalBody.empty();
				$("<p id='modalText1'></p>").text("정말 블락하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='blockModalBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"' data-state='"+$(this).attr("data-state")+"'>확인</button>").appendTo(modalBody)
				.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			
			});
			$("#myModal").on("click", "#blockModalBtn", function(){
				var index = $(this).attr("data-idx");
				var state = $(this).attr("data-state");
				
				var form = $("#infoForm");
				form.empty();
				
			    $("<input type='hidden' name='volunteerState' value='"+state+"' multiple='multiple' >").appendTo(form);
			    $("<input type='hidden' name='volunteerNo' value='"+ $centerVolunteerList[index].volunteerNo +"' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	var url = formDataSetting()+"&"+form.serialize();
				
		    	$.ajax({
					url : "/jnj/admin/center_volunteer/block",
					type : "post",
					data : url,
					success : function(result){
						$("#myModal").modal("hide");
						display_Resetting(result);
					}
				});
			});
			
			$("#volTable").on("click", ".reportBtn", function(){
				
				modalBody.empty();
				$("<p id='modalText1'></p>").text("신고 수를 초기화 하시겠습니까?").appendTo(modalBody);
				$("<button type='button' id='reportModalBtn' class='btn btn-default' data-idx='"+$(this).attr("data-idx")+"' data-state='"+$(this).attr("data-state")+"'>확인</button>").appendTo(modalBody)
				.css("margin-right", "10px");
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>취소</button>").appendTo(modalBody);
				$("#myModal").modal();
			
			});
			$("#myModal").on("click", "#reportModalBtn", function(){
				var index = $(this).attr("data-idx");
				var state = $(this).attr("data-state");
				
				var form = $("#infoForm");
				form.empty();
				
			    $("<input type='hidden' name='volunteerNo' value='"+ $centerVolunteerList[index].volunteerNo +"' >").appendTo(form);
		    	$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
		   
		    	var url = formDataSetting()+"&"+form.serialize();
				
		    	$.ajax({
					url : "/jnj/admin/center_volunteer/report",
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
				
				$centerVolunteerList = map.centerVolunteerList;
				$info = map.adMVolunteerInfo;
				$pagination = map.pagination;
				
				$center = ${center};
				$info.hostId = $center.centerId;
				$info.centerId = $center.centerId;
				
				$totalVolunteerState = map.totalVolunteerState;
				$totalDetailState = map.totalDetailState;
				
				console.log(map);
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
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false },
							{ "orderable": false }
						]
					});
				}
				
				$.each($centerVolunteerList, function(idx, volunteer) {
					
					table.row.add( [
						"<a class='title' href='#' data-idx='"+idx+"'>"+volunteer.volunteerTitle+"</a>",
						volunteer.hostId,
						("<a class='applyPeople' href='#' data-idx='"+idx+"'>"+volunteer.applyPeople+"/"+volunteer.maxPeople+"</a>"),
						volunteer.writeDate,
						currentVolunteerState( volunteer.volunteerState, volunteer.detailState, volunteer.volunteerApplyState ),
						volunteer.reportCnt,
						btnState( volunteer, volunteer.detailState, idx )
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
				
				$("#currentPage").text( "봉사 [모집] 내역");
			}
			
			
			function display_totalState(){
				
                var totalDiv = $("#totlaNumDiv");
                totalDiv.empty();
                
	                var vsCnt = new Array( 0, 0, 0, 0);
	                var vdCnt = new Array( 0, 0, 0, 0, 0);
	                
	    			$.each($totalVolunteerState, function(idx, vstate) {
	    				
	    				if( vstate.VOLUNTEERSTATE == 3 ) 		// 블락
	    					vsCnt[3] = vstate.COUNT;
	    				else if( vstate.VOLUNTEERSTATE == 2 ) 	// 취소
	    					vsCnt[2] = vstate.COUNT;
	    				else									// 정상
	    					vsCnt[1] = vstate.COUNT;
	    			});
	    			
					$.each($totalDetailState, function(idx, vdState) {
	    				
	    				if( vdState.DETAILSTATE == 1 ) 		//블락
	    					vdCnt[1] = vdState.COUNT;
	    				else if( vdState.DETAILSTATE == 2 ) //취소
	    					vdCnt[2] = vdState.COUNT;
	    				else if( vdState.DETAILSTATE == 3 ) //취소
	    					vdCnt[3] = vdState.COUNT;
	    				else if( vdState.DETAILSTATE == 4 ) //취소
	    					vdCnt[4] = vdState.COUNT;
	    			});
					
					var div = $("<div class='alert alert-success' id='sTotalBtn'></div>").appendTo(totalDiv);
	                $("<span>전체 : </span>").appendTo(div);
	                $("<span></span>").text((vsCnt[1]+vsCnt[2]+vsCnt[3])+"건").appendTo(div);
	                
	                div = $("<div class='alert alert-success' id='sRecruitingBtn'></div>").appendTo(totalDiv);
	                $("<span>모집중 : </span>").appendTo(div);
	                $("<span></span>").text(vdCnt[1]+"건").appendTo(div);
	                
	                div = $("<div class='alert alert-success' id='sRecruitBtn'></div>").appendTo(totalDiv);
	                $("<span>모집완료 : </span>").appendTo(div);
	                $("<span></span>").text(vdCnt[2]+"건").appendTo(div);
	                
	                div = $("<div class='alert alert-success' id='sVolCompletBtn'></div>").appendTo(totalDiv);
	                $("<span>봉사완료 : </span>").appendTo(div);
	                $("<span></span>").text(vdCnt[3]+"건").appendTo(div);
	                
	                div = $("<div class='alert alert-success' id='sFailBtn'></div>").appendTo(totalDiv);
	                $("<span>인원미달 : </span>").appendTo(div);
	                $("<span></span>").text(vdCnt[4]+"건").appendTo(div);
	                
	                div = $("<div class='alert alert-success' id='sBlockBtn'></div>").appendTo(totalDiv);
	                $("<span>블락 : </span>").appendTo(div);
	                $("<span></span>").text(vsCnt[3]+"건").appendTo(div);
	                
	                div = $("<div class='alert alert-success' id='sCancleBtn'></div>").appendTo(totalDiv);
	                $("<span>취소 : </span>").appendTo(div);
	                $("<span></span>").text(vsCnt[2]+"건").appendTo(div);
                
                
			}
			
			
			// 상태에 따라 버튼 그리기
			function btnState( volunteer, detailState, idx ){
				var btnStr = "";
					if( volunteer.reportCnt < 3){
						if( volunteer.volunteerState == 3 ) //블락이라면
							btnStr += ("<a href='#' class='blockBtn' data-idx='"+idx+"' data-state='1'>블락취소</a><br>");
						else
							btnStr += ("<a href='#' class='blockBtn' data-idx='"+idx+"' data-state='3'>블락</a><br>");
					}
					else
						btnStr += ("<a href='#' class='reportBtn' data-idx='"+idx+"' data-state='1'>신고초기화</a><br>");
					
					btnStr += ("<a class='deleteBtn' href='#' data-idx='"+idx+"'>글 삭제</a>")
				return btnStr;
			}
			
			
			// 펫 상태 표기 변환
			function currentVolunteerState( volunteerState, detailState, volunteerApplyState ){
				var strState = "";
				
				// 봉사 모집내역을 보는 상태 일 때
					if( volunteerState == 1 ){ // case
						if( detailState == 1 ) 		strState = "모집중";
						else if( detailState == 2 ) strState = "모집완료";
						else if( detailState == 3 ) strState = "봉사완료";
						else if( detailState == 4 ) strState = "인원미달";
					}
					else if( volunteerState == 2 )
						strState = "취소";
					else
						strState = "블락";
				
				
				return strState;
			}
			
			// 정렬 시 화면 다시 그리기
			function display_Resetting( result ){
				
				var resultMap = JSON.parse(result);
				
				console.log("===== result");
				console.log(resultMap);
				
				// 테이블에 행 모두 지우기
				$("tbody>tr").each(function(idx){
					table .row( $(this) ).remove().draw();
				});
				
				initValues( resultMap );
				display_setting( 1 );
				display_totalState();
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
				
				// 위의 상태 건 수를 클릭 했을때를 위해서
				/* if( select != $info.searchColName ){
					$("#mSelect").val($info.searchColName);
					select = $("#mSelect").val();
				} */
				
				if( select == "volunteerTitle" || select == "hostId" ){
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
					
					$("#selectedOption").val(($info.searchText == "%")?"서울":$info.searchText).attr("selected", "selected");
				}
				else if( select == "volunteerState" ){
					selectTextDiv.hide();
					selectDateDiv.hide();
					selectboxDiv.show();
					
						$("<option value='0'>전체</option>").appendTo( selectbox );
						$("<option value='1-1'>모집중</option>").appendTo( selectbox );
						$("<option value='1-2'>모집완료</option>").appendTo( selectbox );
						$("<option value='1-3'>봉사완료</option>").appendTo( selectbox );
						$("<option value='1-4'>인원미달</option>").appendTo( selectbox );
						$("<option value='3'>블락</option>").appendTo( selectbox );
						$("<option value='2'>취소</option>").appendTo( selectbox );
						
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
			
			
			// 정렬 눌렀을 때 동작
			function sortSelect(){
				$info.pageno = 1;
				$info.sortType = (( $info.sortType  == null )?"asc" : (( $info.sortType  == "desc")? "asc" : "desc"));
				
				$.ajax({
					url 	: 	"/jnj/admin/center_volunteer/sort",
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
				
				if( $info.centerId != null ) $("<input type='hidden' name='centerId' value='"+$info.centerId+"' >").appendTo( form );
				if( $info.centerId != null ) $("<input type='hidden' name='hostId' value='"+$info.hostId+"' >").appendTo( form );
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
					url 	: "/jnj/admin/center_volunteer/sort",
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
    			<button type="button" class="btn btn-warning" id="volRecordBtn" disabled="disabled">봉사내역</button>
    			<button type="button" class="btn btn-warning" id="volCommentBtn">봉사댓글</button>
    		</div>
    	
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 봉사 내역 </div>
				<div class="card-body">
				
						<div class="alert alert-warning" id="currentPage" 
							style="display:inline-block; font-weight:bold; font-size:18px;">
							봉사 [모집] 내역	
                        </div>
                        <hr>
                        
                        <div id="totlaNumDiv">
                     	</div>
					
					<table id="volTable" class="table display" cellspacing="0" width="100%">
						<thead>
					    	<tr>
					        	<th>제목</th>
					        	<th style="width:100px;" >주최자</th>
					            <th style="width:70px;" >신청인원</th>
					            <th style="width:100px;" >날짜</th>
					            <th style="width:100px;" >상태</th>
					            <th style="width:50px;" >신고</th>
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
					<option value="hostId">주최자</option> 
					<option value="volunteerState">상태</option> 
					<option value="writeDate">날짜</option> 
				</select>
			</div>
			<div id="searchDiv">
		    	<div class="input-group">
		        	<div id="searchTextDiv" class="input-group">
		             	<input id="searchText" class="form-control" type="text" placeholder="Search for...">
		            </div>
		             	
		            <div id="searchOptionDiv" class="input-group">
			           	<select id="selectedOption" class="form-control">
			           	</select>
		            </div>
		            
		            <span class="input-group-btn" class="input-group">
			           	<button id="searchBtn" class="btn btn-primary" type=button><i class="fa fa-search"></i></button>
		            </span>
		            
		            <div id="searchDateDiv" class="input-group">
		            	<input id="searchDate1" class="form-control" type="date">~<input id="searchDate2" class="form-control" type="date">
		            </div>
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