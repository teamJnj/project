<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<script>
$(function(){
	var $map;
	var $table =$("#table");
	$.ajax({
		url : "/jnj/guest/view",
		type : "get",
		success : function(map){	
			$map = ${map};
			console.log($map);
			view();	
		}
	})
	function view(){
		$.each($map, function(idx,map){
			var $tbody = $("<tbody></tbody>").appendTo($table);
			$("<tr><th></th><th>작성자</th><th>내용</th><th>시간</th><th></th></tr>").appendTo($table).css("background","#FFB24C");
			var $tr = $("<tr></tr>").appendTo($tbody);
			$("<td></td>").text(map.guestbookNo).appendTo($tr);
			$("<td></td>").text(map.memberId).appendTo($tr);
			$("<td></td>").text(map.content).appendTo($tr);
			$("<td></td>").text(map.writeDate).appendTo($tr);
			var $td = $("<td></td>").appendTo($tr);
			$("<input type='submit'>").val("수정").attr("class","update").attr("data-guestbookNo",map.guestbookNo)
			.attr("data-idx",idx).appendTo($td);
			$("<input type='submit'>").val("삭제").attr("class","delete").attr("data-guestbookNo",map.guestbookNo)
			.attr("data-idx",idx).appendTo($td);
		})
	}
	var ul = $("#pagination");
	ul.empty();
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('<').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/guest/view?pageno='+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr('href', '/jnj/guest/view?pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a>").attr('href', '/jnj/guest/view?pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('>').appendTo(ul);
		li.wrapInner($("<a></a>").attr('href', '/jnj/guest/view?pageno='+ $pagination.next));
	}
	
	
	$("#table").on("click",".update", function() {
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
	   
	   
	   $("#table").on("click",".delete", function() {
	      var td1 = $(this).parent().children("button").eq(0).css("display", "inline-block");
	      var td2 = $(this).parent().children("button").eq(1).css("display", "inline-block");
	      var td3 = $(this).parent().children("button").eq(2).css("display", "none");
	      var td4 = $(this).parent().children("button").eq(3).css("display", "none");
	   });
	
	//insert
	$("#insertguestbook").on("click", function() {
            var formData = new FormData();
            formData.append("guestbookNo", $map.guestbookNo);
            formData.append("memberId", $map.memberId);
            formData.append("content", $("#guestbookWrite").val());
            formData.append("writeDate", $map.writeDate);
            formData.append("_csrf", "${_csrf.token}");
            $.ajax({
               url : "/jnj/guest/write",
               type:"post",
               data:formData,
               processData:false,   // FormData 전송에 필요한 설정
               contentType:false,   // FormData 전송에 필요한 설정
               success:function(book) {
                  view(book);
               }
            });
            location.reload();
         });  
	
	//update
	$(".update").on("click",function(){
		  var formData = new FormData();
          formData.append("guestbookNo", $(this).attr("data-guestbookNo"));
          formData.append("content", $("#commentContent").val());
          formData.append("writeDate", $map.writeDate);
          formData.append("_csrf", "${_csrf.token}");
          console.log(formData);
           
           $.ajax({
             url : "/jnj/guest/update",
             type:"post",
             data:formData,
             processData:false,   // FormData 전송에 필요한 설정
             contentType:false,   // FormData 전송에 필요한 설정
             success:function(book) {
                printReply(book); 
             }    
          }); 
       alert("수정 되었습니다.");   
       location.reload();
       
       });
	})
	
	//delete
	$("delete").on("click",function(){
		  if (confirm("삭제하시겠어요??") == true){    //확인
              var formData = new FormData();
              formData.append("guestbookNo", $(this).attr("data-guestbookNo"));
              formData.append("_csrf", "${_csrf.token}");
              console.log(formData);
              
              $.ajax({
                 url : "/jnj/guest/delete",
                 type:"post",
                 data:formData,
                 processData:false,   // FormData 전송에 필요한 설정
                 contentType:false,   // FormData 전송에 필요한 설정
                 success:function(book) {
                    printReply(book);
                 }
              });
              location.reload();
           }
	})
	 
	
})
</script>
<style>
/* .sessionBasket{
border: 1px solid #FFB24C;
width: 200px;
height: 420px;
position:relative;
background-color: #FFB24C;
border-radius: 50px;
}

#table{
position: absolute;
margin-left: 30px;
}
 */
</style>
</head>
<body>
	<div class="container-fluid guestbook">
		<table>
			<tr>
				<td><textarea rows="3" cols="120" id="guestbookWrite"></textarea></td>
				<td><button type="button" id="insertguestbook">방명록 쓰기</button></td>
			</tr>
		</table>
		<hr/>
		<table id="table"></table>
	</div>
</body>
</html>