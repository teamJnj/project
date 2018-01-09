<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.volunteerView {
   margin-top: 30px;
   
}
#volunteerTitle, #writeDate, #applyPeople, #hits{
   
   text-align: center;
}
#reportCnt{
	text-align: center;
}
#reportCnt1{
	text-align: center;
}
#hostId{
   text-align: left;
}
.volunteerView h3{
   color: #7F5926;
}
.volunteerView h4{
   color: #7F5926;
}


.contentTd {
	text-align : center;
	border-left: 1px solid #7F5926;
	padding-left: 20px;
	border-bottom: 1px solid #fff;
	 
}

.contentTh {
	text-align : center;
	padding: 10px 0px 10px 0px;
	width: 20%;
	border-bottom: 1px solid #fff;
}

.table {
   
}
#view{
   margin-top: 5%;
}
#request{
    width:150px;
	margin-left: 500px;
      
}
 #volunteerUpdate{
  	width:150px;
	margin-left: 38%;
	margin-right: 30px;
      
}
#volunteerApplyDelete{
  	width:150px;
	margin-left: 500px;
      
}
 #volunteerDelete{
  	width:150px;
}
#volunteerList{
   	width:150px;
	float: right;
      
}
.th, .td {
   text-align: center;
   margin: 0;
}
#state{
   text-align: center;
   color: red;
   font-weight: bold ;
   font-size: 5em;
}

/* 댓글 수정  */
.updateVolunteerComment{
 	width: 75px;
	margin-right: 10px;
	
}
/* 댓글 삭제  */
.deleteVolunteerComment {
 	width: 75px;
}

 /* 댓글 수정 완료 */
.updateCommentContent {
 	width: 75px;
 	margin-right: 10px;
}
/* 댓글 수정 취소 */
.cancel {
 	width: 75px;
}
/* 댓글 등록  */
#insertComment{
	width : 100px;
	height : 66px;
	text-align: center;
	margin-left: 30px;
}

</style>
<script>




$(function() {
   //var volunteerNo = "${volunteerNo}";
   var $map = ${requestScope.map};
   var $volunteer = $map.volunteer;
   var $volunteerComment = $map.volunteerComment;
   var $volunteerApply = $map.volunteerApply;
   var $name = ${requestScope.name};
   console.log($volunteer);
   
   var $btnVolunteer = $("#btnVolunteer");   
   if($volunteer.hostId==$name){
      $("<button type='button'></button>").attr("id","volunteerUpdate").attr("class","btn btn-default").text("글수정").appendTo($btnVolunteer);
      $("<button type='button'></button>").attr("id","volunteerDelete").attr("class","btn btn-default").text("글삭제").appendTo($btnVolunteer);
      
   } else{
      $("<button type='button'></button>").attr("id","request").attr("class","btn btn-default").text("신청하기").appendTo($btnVolunteer);
   }
   
   $.each($volunteerApply, function(i, $volunteerApply) {
      if($volunteerApply.memberId==$name && $volunteerApply.volunteerApplyState!=0){
         $("<button type='button'></button>").attr("id","volunteerApplyDelete").attr("class","btn btn-default").text("신청취소").appendTo($btnVolunteer);
         $("#request").hide();
      } 
   });
   
   // 자기 글 봉사취소, 신고 버튼 못하게
   if($volunteer.hostId==$name){
      $("#volunteerApplyDelete").hide();
      $("#reportCnt").hide();
   } else{
      $("#bin").hide();
   }
   if($volunteer.maxPeople==$volunteer.applyPeople){
      $("#request").hide();
   }
   
   
   // 버튼을 클릭을 했다면
   if($volunteer.reportCnt>=3 || $volunteer.volunteerState == 3){
      $("table").hide();
      $("#volunteerUpdate").hide();
      $("#request").hide();
      $("#reportCnt").hide();
      $("#volunteerApplyDelete").hide();
      $("h4").hide();
      $("textarea").hide();
      $("#insertComment").hide();
      $("#bin").show();
      $("#state").text("블락을 당해 글을 볼 수 없습니다");
   } 
   
   
    if($volunteer.volunteerDivision==2){
      $("#volunteerDivision").text("일반회원");
   } else if($volunteer.volunteerDivision==1) {
      $("#volunteerDivision").text("센터회원");
   }
   
    
    
   // if( $volunteerComment.length <= 0 )
    //if( $volunteerApply.length <= 0 )
	   
	   
	   
	   
   // 봉사
   console.log($volunteer.ageLimit);
   if($volunteer.ageLimit==1){
	   $("#ageLimit").text("전체이용");
   }else{
	   $("#ageLimit").text($volunteer.ageLimit+"세 이상");
   }
	   
   
   $("#volunteerTitle").text($volunteer.volunteerTitle);
   $("#volunteerTitle").text($volunteer.volunteerTitle);
   $("#applyPeople").text($volunteer.applyPeople+" / "+$volunteer.maxPeople);
   $("#writeDate").text($volunteer.writeDate);
   $("#hits").text($volunteer.hits);
   
   $("#volunteerAddr").text($volunteer.volunteerAddr);
   $("#volunteerContent").text($volunteer.volunteerContent);
   $("#volunteerDate").text($volunteer.volunteerDate);
   $("#maxPeople").text($volunteer.minPeople+" ~ "+$volunteer.maxPeople);
   $("#applyEndDate").text($volunteer.writeDate+" ~ "+$volunteer.applyEndDate);
   $("#hostTel").text($volunteer.hostTel);
   $("#hostId").text($volunteer.hostId);
   $("#reportCnt1").text($volunteer.reportCnt+"회");

   
   var $table = $("#reply");
   printReply($volunteerComment);   
   
   
   function printReply($volunteerComment){
      $table.empty();
      $table.append('<colgroup width="10%"/><colgroup width="50%"/><colgroup width="20%"/><colgroup width="20%"/><thead><tr id="tableTrStyle"><th class="th">작성자</th><th class="th">댓글내용</th><th class="th">작성날짜</th><th class="th"></th></tr></thead>');
      
      var $tbody = $("<tbody></tbody>").appendTo($table);
      $.each($volunteerComment,  function(i, $volunteerComment) {
         var $tr = $("<tr></tr>").appendTo($tbody);
         console.log($volunteerComment.writeDate+"11");
         	if($volunteerComment.writeId=="admin"){
         		 $("<td class='td'></td>").text($volunteerComment.writeId).css("color","red").text("관리자").appendTo($tr);
		         $("<td class='tdContent'></td>").text($volunteerComment.commentContent).css("color","red").appendTo($tr);
		         $("<td class='td'></td>").text($volunteerComment.writeDate).css("color","red").appendTo($tr);
         	} else if($volunteerComment.writeId=="-----"){
         		 $("<td class='td'></td>").text($volunteerComment.writeId).css("color","blue").text("").appendTo($tr);
		         $("<td class='tdContent'></td>").text($volunteerComment.commentContent).css("color","blue").appendTo($tr);
		         $("<td class='td'></td>").text($volunteerComment.writeDate).css("color","blue").appendTo($tr);
	         }else{
	         	 $("<td class='td'></td>").text($volunteerComment.writeId).appendTo($tr);
			     $("<td class='tdContent'></td>").text($volunteerComment.commentContent).appendTo($tr);
			     $("<td class='td'></td>").text($volunteerComment.writeDate).appendTo($tr);
         	}
         var td = $("<td class='td'></td>").appendTo($tr);
         if($volunteerComment.writeId== $name){
            $("<button type='button' id='btn"+i+"' data-idx='"+i+"'></button>").attr("class","btn btn-info updateVolunteerComment").attr("data-volunteerCommentNo",$volunteerComment.volunteerCommentNo).text("수정").css("display", "inline-block").appendTo(td);
            $("<button type='button'></button>").attr("class","btn btn-default deleteVolunteerComment").attr("data-volunteerCommentNo",$volunteerComment.volunteerCommentNo).attr("data-volunteerNo",$volunteer.volunteerNo).text("삭제").css("display", "inline-block").appendTo(td);
            $("<button type='button' data-idx='"+i+"'></button>").attr("class","btn btn-info updateCommentContent").attr("data-volunteerCommentNo",$volunteerComment.volunteerCommentNo).text("수정완료").css("display", "none").appendTo(td);
            $("<button type='button'></button>").attr("class","btn btn-default cancel").attr("data-volunteerCommentNo",$volunteerComment.volunteerCommentNo).text("수정취소").css("display", "none").appendTo(td);
         }
      }); 
   } 
   
   $("#reply").on("click",".updateVolunteerComment", function() {
      console.log("수정 클릭 : " + $(this).attr("data-idx") );
      console.log( $(this).parent().parent().children("td").eq(1).text() );
      
      var td = $(this).parent().parent().children("td").eq(1);
      var str = $(this).parent().parent().children("td").eq(1).text();
      
      $(this).parent().parent().children("td").eq(1).text("");
      
      $("<textarea rows='2' cols='80' id='commentContent' name='commentContent'></textarea>").val(str).appendTo( td );

      var td1 = $(this).parent().children("button").eq(0).css("display", "none");
      var td2 = $(this).parent().children("button").eq(1).css("display", "none");
      var td3 = $(this).parent().children("button").eq(2).css("display", "inline-block");
      var td4 = $(this).parent().children("button").eq(3).css("display", "inline-block");
      
   });
   
   
   $("#reply").on("click",".cancel", function() {
      var td1 = $(this).parent().children("button").eq(0).css("display", "inline-block");
      var td2 = $(this).parent().children("button").eq(1).css("display", "inline-block");
      var td3 = $(this).parent().children("button").eq(2).css("display", "none");
      var td4 = $(this).parent().children("button").eq(3).css("display", "none");
   });
   
   
   
   
   
   
   
   
   
   
         $("#insertComment").on("click", function() {
        	 var commentContentInsert = $("#commentContentInsert").val();
				if(commentContentInsert==""){
					alert("댓글 내용을 작성해주세요");
				} else {
		            console.log( $volunteer.volunteerNo);
		            
		            var formData = new FormData();
		            formData.append("writeId", $volunteerComment.writeId);
		            formData.append("commentContent", $("#commentContentInsert").val());
		            formData.append("writeDate", $volunteerComment.writeDate);
		            formData.append("volunteerNo", $volunteer.volunteerNo);
		            formData.append("_csrf", "${_csrf.token}");
		            
		            console.log(formData);
		            
		            $.ajax({
		               url : "/jnj/menu/volunteer/comment/insert",
		               type:"post",
		               data:formData,
		               processData:false,   // FormData 전송에 필요한 설정
		               contentType:false,   // FormData 전송에 필요한 설정
		               success:function(volunteerComment) {
		            	   console.log("여기!!");
		                  console.log(volunteerComment);
		                  printReply(volunteerComment);
		               }
		            });
		            location.reload();
            }
         });      
         
         $("#request").on("click", function() {
            location.href = "/jnj/menu/volunteer/apply?volunteerNo="+$volunteer.volunteerNo;
         
         
         /* var $frm=$("#frm");
         $frm.empty();
         window.open("/jnj/menu/volunteer/apply", "결제선택", "width=810, height=400");
         $frm.attr("target", "결제선택");
           $frm.attr("action", "/jnj/menu/volunteer/apply");
           $frm.attr("method", "post");
           
           $("<input></input>").attr("type","hidden").attr("name","volunteerNo").val($volunteerComment.volunteerNo).appendTo($frm);
           $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($frm);
           
           console.log( $frm.serialize() );
           $frm.submit(); */
           
         
         }); 
         
         // 봉사 글 수정 하러 jsp 가기
         $("#volunteerUpdate").on("click",function(){
            location.href = "/jnj/menu/volunteer/update?volunteerNo="+$volunteer.volunteerNo;
         });
         
         // 봉사 신청 취소
         $("#volunteerApplyDelete").on("click", function() {
        	 if (confirm("프리마켓 신청 취소하시겠습니까??") == true){
            var $form = $("<form></form>").appendTo("body");
            $form.attr("action", "/jnj/menu/volunteer/apply/delete");
            $form.attr("method", "post");
            $("<input>").attr("type","hidden").attr("name","volunteerNo").val($volunteer.volunteerNo).appendTo($form);
            $("<input>").attr("type","hidden").attr("name","memberId").val($volunteerApply.memberId).appendTo($form);
            $("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
            $form.submit();
        	 }
         });
              
         // 봉사 글 삭제
         $("#volunteerDelete").on("click", function() {
            if (confirm("정말 삭제하시겠습니까??") == true){ 
               
            var $form = $("<form></form>").appendTo("body");
            $form.attr("action", "/jnj/menu/volunteer/delete");
            $form.attr("method", "post");
            $("<input>").attr("type","hidden").attr("name","volunteerNo").val($volunteer.volunteerNo).appendTo($form);
            $("<input>").attr("type","hidden").attr("name", "${_csrf.parameterName}").val("${_csrf.token}").appendTo($form);
            $form.submit();
            }
         });
         
         // 목록으로 리스트 화면
         $("#volunteerList").on("click",function(){
            location.href = "/jnj/menu/volunteer/record"
         }); 
        
         
         // 봉사 글 댓글 수정
         $(".updateCommentContent").on("click", function() {
            var formData = new FormData();
            formData.append("volunteerCommentNo", $(this).attr("data-volunteerCommentNo"));
            formData.append("commentContent", $("#commentContent").val());
            formData.append("writeDate", $volunteerComment.writeDate);
            formData.append("_csrf", "${_csrf.token}");
            console.log(formData);
             
             $.ajax({
               url : "/jnj/menu/volunteer/comment/update",
               type:"post",
               data:formData,
               processData:false,   // FormData 전송에 필요한 설정
               contentType:false,   // FormData 전송에 필요한 설정
               success:function(volunteerComment) {
                  console.log(volunteerComment);
                  printReply(volunteerComment); 
               }    
            }); 
         alert("댓글이 수정 완료 되었습니다.");   
         location.reload();
         
         }); 
         
         $(".cancel").on("click", function() {
            location.reload();
         })
         
         // 봉사 글 댓글 삭제
         $(".deleteVolunteerComment").on("click", function() {
               if (confirm("정말 삭제하시겠습니까??") == true){    //확인
                  var formData = new FormData();
                  formData.append("volunteerNo", $(this).attr("data-volunteerNo"));
                  formData.append("volunteerCommentNo", $(this).attr("data-volunteerCommentNo"));
                  formData.append("_csrf", "${_csrf.token}");
                  console.log(formData);
                  
                  $.ajax({
                     url : "/jnj/menu/volunteer/comment/delete",
                     type:"post",
                     data:formData,
                     processData:false,   // FormData 전송에 필요한 설정
                     contentType:false,   // FormData 전송에 필요한 설정
                     success:function(volunteerComment) {
                        console.log(volunteerComment);
                        printReply(volunteerComment);
                     }
                  });
                  location.reload();
               }
               
            
               
         });
         
         
         $("#reportCnt").on("click", function() {
         if (confirm("정말 신고하시겠습니까??") == true){    //확인
         var formData = new FormData();
         formData.append("volunteerNo", $volunteer.volunteerNo);
         formData.append("_csrf", "${_csrf.token}");
         $.ajax({
            url : "/jnj/menu/volunteer/report_cnt",
            type:"post",
            data:formData,
            processData:false,   // FormData 전송에 필요한 설정
            contentType:false,   // FormData 전송에 필요한 설정
            success:function(reportCnt) {
               console.log(reportCnt);
               location.reload();
            }
         });
         }
      });  
         
   
});
</script>
</head>
<body>
   <div class="container volunteerView">
      <h3>모집 : 봉사</h3>
      <hr />
      <form class="form-horizontal"  method="post">
         <div class="form-group">
            <label class="control-label col-sm-1" for="title">구분</label>
            <span id="volunteerDivision" class="control-label col-sm-1"></span>
            <label class="control-label col-sm-1" for="title">제목</label>
            <span id="volunteerTitle" class="control-label col-sm-6"></span> 
            <label class="control-label col-sm-1" for="title">작성일</label> 
            <span id="writeDate" class="control-label col-sm-2"></span>
         </div>
         <hr />
         <div class="form-group">
            <label class="control-label col-sm-1" for="writer">작성자</label> 
            <span id="hostId"class="control-label col-sm-3"></span>
            <label class="control-label col-sm-1" for="writer">신고횟수</label> 
            <span id="reportCnt1"class="control-label col-sm-2"></span> 
            <label id="bin"class="control-label col-sm-1" for="writer"></label>
            <button class="btn btn-default control-label col-sm-1" type="button" id="reportCnt">신고하기</button>
            <label class="control-label col-sm-1" for="title">조회</label> 
            <span id="hits"class="control-label col-sm-1"></span> 
            <label class="control-label col-sm-1" for="title">신청인원</label> 
            <span id="applyPeople"class="control-label col-sm-1"></span>
         </div>
         <hr />
         
         <p id="state"></p>
         
         
         <div class="container">
	<div class="row">
	<table id="view" class="table table-bordered table-condensed table-striped" >
		
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">장소</th>
			<td style="height : 50px; line-height: 50px;" class="contentTd" id="volunteerAddr" colspan="3"></td>
		</tr>
		
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">내용</th>
			<td style="height : 50px; line-height: 50px;" id="volunteerContent" class="contentTd" colspan="3" ></td>
		</tr>
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">날짜</th>
			<td style="height : 50px; line-height: 50px;" id="volunteerDate" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">신청기간</th>
			<td style="height : 50px; line-height: 50px;" id="applyEndDate" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">모집인원</th>
			<td style="height : 50px; line-height: 50px;"id="maxPeople" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">나이제한</th>
			<td style="height : 50px; line-height: 50px;" id="ageLimit" class="contentTd" colspan="3"></td>
		</tr>
		<tr>
			<th style="height : 50px; line-height: 50px;" class="contentTh" scope="row">전화번호</th>
			<td style="height : 50px; line-height: 50px;" id="hostTel" class="contentTd" colspan="3"></td>
		</tr>
</table>
	</div>
</div>
         
         <div class="container">
            <table class="table" id="view">
               
               
              
              
              
            </table>
         
         </div><br>
         <br>
         <div id="btnVolunteer"></div>
         <br><br><br><br><br><br>
         <button id="volunteerList" type="button" class="btn btn-default" >목록</button>
         <br><br><br>
         <h4>댓글</h4>
      <table class="table" id="reply">
         <tr>
               <td></td>
            </tr>
      </table>
     
      
      
      <div class="container">
	<div class="row">
		<div class="span4 well" style="padding-bottom:0">
		<table>
			<tr>
				<td><textarea class="span4"  rows="3" cols="120" id="commentContentInsert"></textarea></td>
               	<td><button class="btn btn-info"  type="button" id="insertComment" >댓글 추가</button></td>
        	</tr>
        </table>
        </div>
	</div>
</div>
      
         
      <br><br><br><br><br><br><br><br><br>
               
      </form>
   </div>
</body>
</html>