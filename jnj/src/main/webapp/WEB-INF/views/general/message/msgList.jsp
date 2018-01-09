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
function check(){
	$.ajax({
		url:"/jnj/general/massage/msgcnt",
		type: "get",
		success: function(result){
			$("#msgcnt").text(result);
		}
	});
}


// 주소에 따라 보낸쪽지함 - 받은 쪽지함 구분
$(function() {
	check();
	
	
	var map = ${map};
	var $pagination = map.pagination;
	var msgList = map.msgList;
	
	var tbody = $(".msgSend tbody");
	
	var href = $(location).attr("href");
	var sort = href.split('/')[6];
	var thead = $(".msgSend thead tr");
	if(sort.match("send")) {
		$("#msgId").text("받을사람");
	} else if(sort.match("receive")) {
		$("#msgId").text("보낸사람");
		$("<th>상태</th>").appendTo(thead);
	}	
	
	$.each(msgList, function(idx, list) {
		var tr = $("<tr></tr>").appendTo(tbody);
		var check = $("<td></td>").appendTo(tr);
		$("<input type='checkbox'>").attr("value", list.messageNo+"/"+list.msgState).appendTo(check);
		if(sort.match("send")) {
			$("<td></td>").text(list.receiverId).appendTo(tr);
		} else if(sort.match("receive")) {
			$("<td></td>").text(list.senderId).appendTo(tr);
		}
		var title = $("<td></td>").appendTo(tr);
		$("<a></a>").attr("href", "/jnj/general/message/"+sort+"/view?messageNo="+list.messageNo).text(list.title).appendTo(title);
		if(sort.match("receive")) {
			if(list.msgState==1)
				$("<td></td>").text("읽지 않음").appendTo(tr);
			else if(list.msgState==2)
				$("<td></td>").text("읽음").appendTo(tr);
		}
		$("<td></td>").text(list.sendDate).appendTo(tr);
	})
	
	var ul = $(".pager");
	var li;
 	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr("href", "/jnj/general/message/"+sort+"?pageNo="+ $pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a>").attr("href", "/jnj/general/message/"+sort+"?pageNo="+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a").attr("href", "/jnj/general/message/"+sort+"?pageNo="+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a>").attr("href", "/jnj/general/message/"+sort+"?pageNo="+ $pagination.next));
	} 	
	
	$("#delmsg").on("click", function() {
		var form = $("<form></form>");
		var div = $("#delmsg").parent();
		$("input:checkbox:checked").each(function (index) {  
			var val = $(this).val();
			$("<input type='hidden' name='messageNo'>").attr("value", val.split('/')[0]).appendTo(div);
			$("<input type='hidden' name='msgState'>").attr("value", val.split('/')[1]).appendTo(div);
			$("<input type='hidden' name='sort'>").attr("value", sort).appendTo(div);
		})
		form.attr("method", "post");
		form.attr("action", "/jnj/general/message/delete");
		div.wrap(form);
		$("#delmsg").attr("type", "submit");
	})	
	
	$("#msg").on("click", function() {
		var msgform = $("<form></form>").attr("action", "/jnj/general/message/write").attr("method", "post");
		$("<input type='hidden' name='receiverId'>").attr("value","receiverId").appendTo("#writeM");	
		$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>").appendTo("#writeM");	
		$("#writeM").wrap(msgform);
		$("#msg").attr("type", "submit");
	})
		
})
</script>
<style>
.msgnav #msg {
	margin-left: 5px;
	height: 40px;
	width: 90px;
}
.msgnav h2 {
	margin-left: 10px;
}
.msgList {
	margin-left: 30px;
}
#delsend {
	margin-left: 870px;
}
.msgSend, .msgSend th {
	text-align: center;
}
#msgcnt {
	color: #7F5926; 
	font-size: 0.8em;
	font-weight: bold;
}

</style>
</head>
<body>
	<div class="col-sm-2 sidenav hidden-xs msgnav">
		<h2>쪽지함</h2>
		<br>
		<ul class="nav nav-pills nav-stacked">
			<li><a href="/jnj/general/message/receive/record">받은 쪽지함 <span id="msgcnt"></span></a></li>
			<li><a href="/jnj/general/message/send/record">보낸 쪽지함</a></li>				
		</ul>
		<br>
		<div id="writeM">
			<button id="msg" type="button" class="btn btn-default">쪽지쓰기</button>
		</div>
	</div>
	<br>
	<div class="container msgList">
		<div id="msgCheck">
			<jsp:include page="msgCheck.jsp"></jsp:include>
		</div>
		<br><br>
		<div class="row col-sm-10 msgSend">
			<table class="table">
				<colgroup width="7%"/>
				<colgroup width="13%"/>
				<colgroup width="55%"/>
				<colgroup width="15%"/>
				<colgroup width="10%"/>
				<thead>
					<tr>
						<th></th>
						<th id="msgId"></th>
						<th>제목</th>
						<th>날짜</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			<br>
			<div>
				<button id="delmsg" type="button" class="btn btn-default">삭제</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</div>
			<div class="container2">
				<ul class="pager">
				</ul>
			</div>
			<br><br><br>
		</div>
	</div>
	
</body>
</html>