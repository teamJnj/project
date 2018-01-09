<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
   .qnaView h3 {
      color: #7F5926;
   }
   .qnaView .control-label {
   		text-align: center;
   }
  
   .qnaView textarea {
		height: 300px;
		border: white;
		background-color: white;
	}
	
	.qnaView span{
		margin-right : 80px;
	}
</style>

<script>
	$(function(){
		
		var modalBody = $("#modalBody");
		
		var tempQna = ${qna};
		var $qna;

		
		initValue( tempQna );
		display_setting();
		display_CSS();
		
		
		$("#backBtn").on("click", function(){
			location.href = "/jnj/admin/center_qna?qnaDivision=2&centerId=" + $qna.writeId;
		});
		
		// 처리완료 버튼 클릭 시
		$("#completBtn").on("click", function(){
			
			if( $("#answerContent").val() == "" ){
				modalBody.empty();
				$("<p id='modalText1'></p>").text("답변을 입력해주세요.").appendTo(modalBody);
				$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>확인</button>").appendTo(modalBody);
				$("#myModal").modal();
				return;
			}
			
			var form = $("#infoFrm");
			form.empty();
			
			$("<input type='hidden' name='qnaNo' value='"+ $qna.qnaNo +"'>").appendTo( form );
			$("<input type='hidden' name='writeId' value='"+ $qna.writeId +"'>").appendTo( form );
			$("<input type='hidden' name='answerContent' value='"+ $("#answerContent").val() +"'>").appendTo( form );
			$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo(form);
			
			var url = form.serialize();
			form.empty();

			$.ajax({
				url:"/jnj/admin/center_qna/answer",
				type:"post",
				data: url,
				success: function( result ){
					
					initValue( JSON.parse( result ) );
					display_setting();
					display_CSS();
					
					modalBody.empty();
					$("<p id='modalText1'></p>").text("답변 처리가 완료되었습니다").appendTo(modalBody);
					$("<button type='button' id='closeBtn' class='btn btn-default' data-dismiss='modal'>확인</button>").appendTo(modalBody);
					$("#myModal").modal();
					
					
				}
	 		});
		});
		
		
		function initValue( qna ){
			$qna = qna;
		}
		
		function display_setting(){
			
			if($qna.qnaSort==1) 		$("#qnaSort").text("후원");
			else if($qna.qnaSort==2) 	$("#qnaSort").text("입양");
			else if($qna.qnaSort==3) 	$("#qnaSort").text("봉사");
			else if($qna.qnaSort==4) 	$("#qnaSort").text("프리마켓");
			else if($qna.qnaSort==5) 	$("#qnaSort").text("스토어");
			else if($qna.qnaSort==6) 	$("#qnaSort").text("게시판");
			else if($qna.qnaSort==7) 	$("#qnaSort").text("기타");
			
			$("#qnaTitle").text($qna.qnaTitle);
			$("#writeDate").text($qna.writeDate);
			$("#writeId").text($qna.writeId);
			$("#qnaContent").text($qna.qnaContent);
			
			$("#imgDiv").empty();
			$("<img class='img-responsive' style=\"width:400px; height:300px;\"></img>").attr("src","/jnjimg/qna/"+ $qna.qnaImg).appendTo("#imgDiv");
			
			if($qna.answerContent=="null")
				$("#answerContentCheck").text("처리중");
			else
				$("#answerContentCheck").text("처리완료");
			
			console.log("여기!!!");
			console.log( $qna.answerContent );
			
			if($qna.answerContent=="null")
		    	$("#answerContent").val("");
		    else
		    	$("#answerContent").val( $qna.answerContent );
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
			});
			
			$("#completBtn").css({
				"display": "inline-block",
				"width": "100px",
				"float": "right",
				"margin-bottom": "20px",
				"margin-right": "20px"
			});
			
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
	     
	});
</script>
</head>
<body>



	<div id="scorpTotal">
    
    	<div id="vvnav" style="background-color:white; overflow:hidden;">
			<a class="btn btn-primary btn-block" id="backBtn" href="#">목록</a>
    	</div>
    	
    	<div id="tableTotal">
			<div class="card mb-3">
				<div class="card-header"> <i class="fa fa-table"></i> 1:1문의 상세 </div>
				<div class="card-body">
					<div class="container qnaView">
				 		
					 	<form id="qnaAllForm" class="form-horizontal">
								<h3>1:1문의 상세</h3>
								<hr>
								<div class="form-group">
									<label>분류 : </label>
						            <span id="qnaSort"></span>
						            
						            <label >글제목 : </label>
						            <span id="qnaTitle"></span>
						            
						            <label>작성일 : </label>
						            <span id="writeDate"></span>
								</div>
								<hr/>
						        
						        <div class="form-group">
						           <label>작성자 : </label>
						           <span id="writeId"></span>
						           
						           <label>처리상태 : </label>
						           <span id="answerContentCheck"></span>
						        </div>
								<hr/>
								
								
						        <div class="form-group" id="qnaContentBox">
						        	<label>문의내용</label>
						           	<div>
						            	<textarea class="form-control" id="qnaContent" name="qnaContent" readonly="readonly"></textarea>
						            	<br>
						            </div>
						            <div id="imgDiv"></div>
						        </div>
						        
						        <hr/>
						        
						        
						       <div class="form-group" id="answerContentBox">
						        	<label>답변</label>
						           	<div>
						            	<textarea class="form-control" id="answerContent" name="answerContent" style="border:1px solid gray;"></textarea>
						            </div>
						        </div>
						        
						        
						        <hr/>
						        <br>
						        <div class="form-group">
						           <div style="background-color:white; overflow:hidden;">
										<a class="btn btn-primary btn-success" id="completBtn" href="#">처리완료</a>
							    	</div>
						        </div>
						        <br>
						        <br>
						</form>
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