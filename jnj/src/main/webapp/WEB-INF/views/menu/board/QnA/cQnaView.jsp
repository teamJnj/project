<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
   .qnaView h3 {
      color: #7F5926;
   }
   .qnaView button {
      	float: right;
     	margin-right: 10px;
     	background-color: #FFB24C;
      	color: #7F5926;
   }
   .qnaView button:hover {
      	background-color: #7F5926;
      	color: #FFB24C;
   }
   .qnaView .control-label {
   		text-align: center;
   }
  
   .qnaView textarea {
		height: 300px;
		border: white;
		background-color: white;
	}
	
	/* #qnaContent{
		width: 945px;
		height: 100px;
		text-align: left;
	} */
	
</style>

<script>
$(function(){
	
	var $cState = ${requestScope.cState};
	
	if($cState==0||$cState==2||$cState==3) {
		$(".normalState").attr("href", "#");
		if($cState==0||$cState==2)
			$(".normalStateH").attr("href", "#");
	}
	
	var $map = ${map};
	var $writeId = ${writeId};
	var $answerContent = $map.answerContent;
	
	console.log($map);
	//$("#qnaSort").text($map.qnaSort);
	
	if($map.qnaSort==1){
		$("#qnaSort").text("후원");
	} else if($map.qnaSort==2){
		$("#qnaSort").text("입양");
	} else if($map.qnaSort==3){
		$("#qnaSort").text("봉사");
	} else if($map.qnaSort==4){
		$("#qnaSort").text("프리마켓");
	} else if($map.qnaSort==5){
		$("#qnaSort").text("스토어");
	} else if($map.qnaSort==6){
		$("#qnaSort").text("게시판");
	} else if($map.qnaSort==7){
		$("#qnaSort").text("기타");
	}
	
	$("#qnaTitle").text($map.qnaTitle);
	$("#writeDate").text($map.writeDate);
	$("#writeId").text($map.writeId);
	$("#qnaContent").text($map.qnaContent);
	
	if($map.qnaImg==null){
		$("<p></p>").appendTo("#qnaContentBox");
	} else{
		$("<img class='img-responsive' style=\"width:400px; height:300px;\"></img>").attr("src","/jnjimg/qna/"+ $map.qnaImg).appendTo("#qnaContentBox");	
	}
	
	
	////$("#answerContent").text($map.answerContent);
	if($map.answerContent=="null"){
		$("#answerContentCheck").text("처리중");
	} else {
		$("#answerContentCheck").text("처리완료");
		$("#updateQna").css("display","none").attr("disabled","disabled");
		$("#deleteQna").css("display","none").attr("disabled","disabled");
	}
	
	
	
    if($map.answerContent=="null"){
    	$("#answerContentRead").val(" ");
    }else{
    	$("#answerContentRead").val($map.answerContent);
    }
	
    
	
    if($writeId=="admin"){
    	$("<input type='text' class='form-control' id='answerContent' name='answerContent'>").appendTo("#answerContentBox");
    	$("<button id='updateAnswer' type='button' class='btn btn-default'>답글달기</button>").appendTo("#answerContentBox");
    	
    	$("#updateAnswer").on("click", function() {
    		$("<input></input>").attr("type","hidden").attr("name","qnaNo").val($map.qnaNo).appendTo("#qnaAllForm");
    		$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo("#qnaAllForm");
    		
    		$("#qnaAllForm").submit();
    		console.log($("#qnaAllForm").serialize());
    		
    		
    		
    		$.ajax({
				url:"/jnj/common/cQna/update3",
				type:"post",
				data:$("#qnaAllForm").serialize(),
				success: function(){
					window.location.reload();
				}
	 		});
    		
    		
    	}); 
    }

    
    
    $("#goQnaList").on("click", function() {
			location.href = "/jnj/common/cQna/record";
	})
    
	$("#deleteQna").on("click", function() {
		var $form = $("#qnaAllForm");
		$form.attr("action", "/jnj/common/cQna/delete");
		$form.attr("method", "post");
		$("<input>").attr("type","hidden").attr("name","qnaNo").val($map.qnaNo).appendTo($form);
		$("<input>").attr("type","hidden").attr("name","writeId").val($map.writeId).appendTo($form);
		$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
		$form.submit();
	});
	
    $("#updateQna").on("click", function() {
		var $form = $("<form></form>").appendTo("body");
		$form.attr("action", "/jnj/common/cQna/update1");
		$form.attr("method", "post");
		$("<input></input>").attr("type","hidden").attr("name","qnaNo").val($map.qnaNo).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","qnaImg").val($map.qnaImg).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","qnaSort").val($map.qnaSort).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","qnaTitle").val($map.qnaTitle).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","writeId").val($map.writeId).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","qnaContent").val($map.qnaContent).appendTo($form);
		$("<input></input>").attr("type","hidden").attr("name","writeDate").val($map.writeDate).appendTo($form);
		$("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
		console.log($form.serialize());
		$form.submit();
	}); 
    
   
     
});

</script>
</head>
<body>

	<h4 id="h4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info" class="normalState">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" class="normalState">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt" class="normalStateH">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor" class="normalStateH">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer" class="normalState">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna/record" style="color: navy; font-weight: 700; font-size: 20px;">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign" class="normalState">회원탈퇴</a></h4>
	<hr>
	
	
	<div class="container qnaView">
		<h3>1:1문의</h3>
		<hr/>
 		
 	<form id="qnaAllForm" class="form-horizontal">
		<div class="form-group">
			<label class="control-label col-sm-1" for="category">분류</label>	<!-- 내용은 기입정보 알아서 jquery로 불러오세요 -->
            <span class="control-label col-sm-1" id="qnaSort"></span>
            
            <label class="control-label col-sm-3" for="title">글제목</label>
            <span class="control-label col-sm-3" id="qnaTitle"></span>
            
            <label class="control-label col-sm-2" for="writedate">작성일</label>
            <span class="control-label col-sm-2" id="writeDate"></span>
		</div>
		<hr/>
        
        <div class="form-group">
           <label class="control-label col-sm-1" for="writer">작성자</label>
           <span class="control-label col-sm-1" id="writeId"></span>
           
           <span class="control-label col-sm-7" ></span>
           
           <label class="control-label col-sm-1" for="title">처리상태</label>
           <span class="control-label col-sm-2"  id="answerContentCheck"></span>
        </div>
		<hr/>
		
		
        <div class="form-group" id="qnaContentBox">
        	<label class="control-label col-sm-1" for="question">문의내용</label>
           	<div class="control-label col-sm-10">
           		<!-- <input class="control-label col-sm-10" id="qnaContent" name="qnaContent" readonly="readonly" style="border:1px solid white;"> -->
            	<textarea class="form-control" id="qnaContent" name="qnaContent" readonly="readonly"></textarea>
            </div>
        </div>
        
        
        <hr/>
        
        
        <div class="form-group" id="answerContentBox">
           <label class="control-label col-sm-1" for="ask">답변</label>
           <input class="control-label col-sm-10" id="answerContentRead" name="answerContentRead" readonly="readonly" style="border:1px solid white;">
           <!-- 
            	<textarea class="form-control" id="answerContentWrite" name="answerContentWrite" readonly="readonly"></textarea>
            -->
       		<sec:authorize access="hasRole('ROLE_USER')">
				<jsp:include page="answerForAdmin.jsp" />
			</sec:authorize>
        </div>
        
        
        <hr/>
        <br>
        <div class="form-group">
           <div class="col-sm-offset-2 col-sm-10">
				<button id="goQnaList" type="button" class="btn btn-default">목록</button>
				<button id="deleteQna" type="button" class="btn btn-default">삭제</button>
				<button id="updateQna" type="button" class="btn btn-default">수정</button>
           </div>
        </div>
        <br><br>
        </form>
	</div>
</body>
</html>