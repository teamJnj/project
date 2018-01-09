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
.memberServeList {
	margin-top: 30px;
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

h3 {
	color: #7F5926;
}

#memberServeListSearchButton {
	background-color: #FFB24C;
	color: #7F5926;
}

#memberServeListSearchButton:hover {
	background-color: #7F5926;
	color: #FFB24C;
}

.memberServeList a {
	margin: 5px;
}
.memberServeListForm{
text-align: center;
}
</style>
<script>
$(function(){
	// ��� �޴���
	$.ajax({
		url:"/jnj/username",
		type:"get",
		data:$("form").serialize(),
		success:function(principal){
			console.log(principal);
			$("#minfo").attr("href", "/jnj/member/info?memberId="+principal);
			$("#msponsor").attr("href", "/jnj/member/sponsor/record?memberId="+principal);
			$("#madopt").attr("href", "/jnj/member/adopt/record?memberId="+principal);
			$("#mvolunteer").attr("href", "/jnj/member/volunteer/record?memberId="+principal);
			$("#mmarket").attr("href", "/jnj/member/market/record?memberId="+principal);
			$("#mstore").attr("href", "/jnj/member/store/record?orderId="+principal);
			$("#mqna").attr("href", "/jnj/common/qna/record?writeId="+principal);
			$("#mresign").attr("href", "/jnj/member/resign?memberId="+principal);
		}
	});
	
	//�̰� ������ �� �����Ϸ��� ���
	var $map = ${map};
	var $myVolunteerList = $map.getMypageMemberVolunteerAllList;
	var $pagination = $map.pagination;
	var $memberId = $map.memberId;
	
	function state(hihi){
		var $volunteerState;
		if(hihi==0){
			$volunteerState="����";
		}else if(hihi==1){
			$volunteerState="������";
		}
		return $volunteerState;
	}
	
	var $table = $("#mVolunteerListTable")
	$("<tr><th>�۹�ȣ</th><th>����</th><th>����</th><th>������</th><th>��û�ο�</th><th>��¥</th><th>����</th></tr>").appendTo($table).css("background","#FFB24C");
	
	display_setting($pagination,$myVolunteerList);
	
	function display_setting(pagination, myVolunteerList){
		
		$.each(myVolunteerList, function(idx,$volunteerList){
			var $tbody = $("<tbody></tbody>").appendTo($table);
			var $tr = $("<tr></tr>").appendTo($tbody);
			var $num = $("<td></td>").text($volunteerList.VOLUNTEERNO).appendTo($tr);
			var $num = $("<td></td>").text($volunteerList.VOLUNTEERADDR).appendTo($tr);
			var $vNo = $("<td></td>").text($volunteerList.VOLUNTEERTITLE).appendTo($tr);
			var $vNoLink = $("<a></a>").attr("href","/jnj/menu/volunteer/view?volunteerNo="+$volunteerList.VOLUNTEERNO);
			$vNo.wrapInner($vNoLink);
			$("<td></td>").text($volunteerList.HOSTID).appendTo($tr);
			var $vNo2 = $("<td></td>").text($volunteerList.APPLYPEOPLE+"/"+$volunteerList.MAXPEOPLE).appendTo($tr);
			if($volunteerList.HOSTID == $memberId){
				var vNoLink2 = $("<a></a>").attr("href","/jnj/member/volunteer/apply_list?volunteerNo="+$volunteerList.VOLUNTEERNO+"&memberId="+$memberId);
				$vNo2.wrapInner(vNoLink2);
			}
			$("<td></td>").text($volunteerList.WRITEDATE).appendTo($tr);
			var vstate = "����";
			if($volunteerList.VOLUNTEERSTATE==0) vstate = "��� : ������";
			else if($volunteerList.VOLUNTEERSTATE==3) vstate = "��� : ���";
			else if($volunteerList.VOLUNTEERAPPLYSTATE==0) vstate = "��� : ����";
			else if($volunteerList.DETAILSTATE==1) vstate = "��û : ������";
			else if($volunteerList.DETAILSTATE==2) vstate = "��û : �����Ϸ�";
			else if($volunteerList.DETAILSTATE==3) vstate = "����Ϸ�";
			else if($volunteerList.DETAILSTATE==4) vstate = "��� : �ο��̴�";
			$("<td></td>").text(vstate).appendTo($tr);
		})
		var ul = $("#pagination");
		ul.empty();
		var li;
		if(pagination.prev>0) {
			li = $("<li></li>").text('��������').appendTo(ul);
			li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/record?memberId='+$memberId+'&pageno='+ $pagination.prev))
		}
		for(var i=pagination.startPage; i<=pagination.endPage; i++) {
			li = $("<li></li>").text(i).appendTo(ul);
			if(pagination.pageno==i) 
				li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/record?memberId='+$memberId+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
			else
				li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/record?memberId='+$memberId+'&pageno='+ i))
		}
		if(pagination.next>0) {
			li = $("<li></li>").text('��������').appendTo(ul);
			li.wrapInner($("<a></a>").attr('href', '/jnj/member/volunteer/record?memberId='+$memberId+'&pageno='+ $pagination.next));
		}
	
	
	
	
	
	}
	//���� �߰��ؾߵ�!������!!
	function sortSelect(){
		$myVolunteerList.pageno = 1;
		console.log(formDataSetting());
		
		
		$.ajax({
			url : "/jnj/member/volunteer/record_f",
			type : "get",
			data : formDataSetting()+"&memberId="+$memberId,
			success : function(result){
				console.log(result);
				display_Resetting(result);
			}
		})
	}
	//��ü
	$("#a1").on("click",function(e){
		 e.preventDefault();
		 location.href="/jnj/member/volunteer/record?memberId="+$memberId;
	})
	
	
	//���� 
	 $("#a2").on("click",function(e){
		 e.preventDefault();
			$myVolunteerList.type = 0;
			sortSelect();
	})
	//����
	$("#a3").on("click",function(e){
		 e.preventDefault();
			$myVolunteerList.type = 1;
			sortSelect();
	})
	
	
	// ���� �� ȭ�� �ٽ� �׸���
	function display_Resetting( result ){
		
		var resultMap = result;
		console.log("���Ͷ�");
		console.log(resultMap);
		
		// ���̺� �� ��� �����
		$("tbody").empty();
		display_setting(resultMap.pagination, resultMap.getMypageMemberVolunteerAllList);
	}
	
	function formDataSetting(){
		var form=$("#volunteerForm");
		form.empty();
		
		if( $myVolunteerList.memberId != null ) $("<input type='hidden' name='memberId' value='"+$myVolunteerList.memberId+"' >").appendTo(form);
		if( $myVolunteerList.pageno != null ) $("<input type='hidden' name='pageno' value='"+$myVolunteerList.pageno+"' >").appendTo(form);
		if( $myVolunteerList.type != null ) $("<input type='hidden' name='type' value='"+$myVolunteerList.type+"' >").appendTo(form);
		if( $myVolunteerList.startArticleNum != null ) $("<input type='hidden' name='startArticleNum' value='"+$myVolunteerList.startArticleNum+"' >").appendTo(form);
		if( $myVolunteerList.endArticleNum != null ) $("<input type='hidden' name='endArticleNum' value='"+$myVolunteerList.endArticleNum+"' >").appendTo(form);
		var result=form.serialize();
		return result;
	}
	

	
})
</script>
</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="minfo">������������</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="msponsor">�Ŀ�����</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="madopt">�Ծ系��</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mvolunteer">���系��</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mmarket">�������ϳ���</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mstore">���ų���</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mqna">1:1����</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mresign">ȸ��Ż��</a></h4>
	<hr>
	<div class="container memberServeList">
		<h3>�������</h3>
		<hr>
		<br> <br>
		<div class="memberServeListDiv1 pull-right">
			<a href="#" id="a1">��ü</a><a href="#" id="a2">����</a> <a href="#" id="a3">����</a>
		</div>
		<br>
		<table class="table" id="mVolunteerListTable">

		</table>
		<!-- <form class="memberServeListForm">
			<span class="glyphicon glyphicon-search"></span>
			<input type="text" name="search" placeholder="�˻��ϱ�">
			<button type="button" id="memberServeListSearchButton">�˻�</button>
		</form> -->

		<div class="container2">
			<ul class="pager" id="pagination">
		
			</ul>
		</div>
	</div>
	<form id="volunteerForm"></form>

</body>
</html>