<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
.memberServe_myServeList {
	margin-top: 100px;
}
#tableTrStyle {
	background-color: #FFB24C;
}

th {
	text-align: center;
}

.table {
	text-align: center;
}
h3 span{
color: #7F5926;
}
 #button1 {
  
      background-color: #FFB24C;
      color: #7F5926;
   }

#button1:hover{
background-color: #7F5926;
      color: #FFB24C;
}
#mVolunteerListB {  
      background-color: #FFB24C;
      color: #7F5926;
      margin: 0;
      float: right;
   }

#mVolunteerListB:hover{
background-color: #7F5926;
      color: #FFB24C;
}
</style>
<script>
$(function(){
	var $map = ${map};
	console.log($map);
	var $memberVolunteerList = $map.getMypageMemberVolunteerList;
	
	var $pagination = $map.pagination;
	
	var $volunteerNo = $map.volunteerNo;
	
	var $memberId = $map.memberId;
	var $hostId = $memberVolunteerList;
	console.log($memberId);
	console.log($hostId);

	console.log("집좀가자");
	console.log($memberVolunteerList);
	
	var $table= $("#volunteerApplyListTable");
	$("<tr><th>ID</th><th>신청자</th><th>전화번호</th><th>기타</th></tr>").appendTo($table).css("background","#FFB24C");
	
	display_setting($pagination, $memberVolunteerList);
	
	function display_setting(pagination,memberVolunteerList){
	
		$.each(memberVolunteerList, function(idx, $volunteerList){
	 		console.log("배고프당");
			console.log($volunteerList);
			var $tbody=$("<tbody></tbody>").appendTo($table);
			var $tr =$("<tr></tr>").appendTo($tbody);
		
			$("<td></td>").text($volunteerList.memberId).appendTo($tr);
			
			console.log($volunteerList.memberId);
			
			$("<td></td>").text($volunteerList.memberName).appendTo($tr);
			$("<td></td>").text($volunteerList.applyTel).appendTo($tr);
			var $td = $("<td></td>").appendTo($tr);
			console.log($volunteerList.memberId);
			console.log($volunteerList.hostId);
			console.log("ㅋ");
			if($volunteerList.memberId == $volunteerList.hostId){
				console.log($volunteerList.memberId);
				console.log($volunteerList.hostId);
				console.log("ㅎㅎ");
				
				$("<span></span>").text("").appendTo($td);
			}else if($volunteerList.volunteerApplyState == 1){
				$("<input type='submit'>").val("거절").attr("class","cancle").attr("data-volunteerNo",$volunteerList.volunteerNo)
				.attr("data-idx",idx).attr("data-memberId",$volunteerList.memberId).appendTo($td);
			}else{
				$("<span></span>").text("거절되었습니다.").appendTo($td);
			}
		
			var ul = $("#pagination");
			ul.empty();
			var li;
			if($pagination.prev>0) {
				li = $("<li></li>").text('<').appendTo(ul);
				li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/apply_list?pageno='+ $pagination.prev))
			}
			for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
				li = $("<li></li>").text(i).appendTo(ul);
				if($pagination.pageno==i) 
					li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/apply_list?pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
				else
					li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/apply_list?pageno='+ i))
			}
			if($pagination.next>0) {
				li = $("<li></li>").text('>').appendTo(ul);
				li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/apply_list?pageno='+ $pagination.next));
			}
		})
	}
	
	$(".cancle").on("click",function(){
		if(confirm("봉사 신청을 거절하시겠어요?")==true){
			var index=$(this).attr("data-idx");
			console.log(index);
			$.ajax({
				url : "/jnj/member/volunteer/apply_deny",
				type : "post",
				data :{
					"volunteerNo" : $memberVolunteerList[index].volunteerNo,
					"memberId" : $memberVolunteerList[index].memberId,
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
				success : function(index){
					console.log("주리언닝");
					window.location.reload();
					/* location.href="/jnj/member/volunteer/apply_list?volunteerNo="+$volunteerNo; */
					
				}
			})
		}
	})
	
	//목록으로 돌아가는 버튼 만들기
	$("#mVolunteerListB").on("click",function(){
		console.log("들어왔쭘"+$memberId);
		location.href="/jnj/member/volunteer/record?memberId="+$memberId;
	})
	
	
	
})


</script>
</head>
<body>
<!-- 내가 주최한 봉사에 참가하는 인원목록을 보여주는 곳이얌 팝업창이지!! -->

	<div class="container memberServe_myServeList" id="volunteerDivId">
		<h3><span id="memberServe_myServe"></span></h3>
		<hr>
		<table class="table" id="volunteerApplyListTable">
			
		</table>
	

		<div class="container2">
			<ul class="pager" id="pagination">
			</ul>
		</div>
		<button type="button" id="mVolunteerListB" >목록으로</button>
		<br>
		<br>
		<br>
		<br>
	</div>

</body>
</html>