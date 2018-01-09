<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
.memberSponserList {
margin-top: 30px;
}

th {
	text-align: center;
}

.table {
	text-align: center;
}
.container h3{
color: #7F5926;
}

.col-sm-3, #totalSponsorPay {
background-color: #FFB24C;

}
#totalSponsorPay {
display: inline-block;
}

.memberSponserList a{
margin: 5px;
}
a{
text-decoration: none;
}
</style>
<script>

$(function(){
	// 상단 메뉴바
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
	
	
	var $map = ${map};
	console.log($map);
	
	
	var $mySponsorList = $map.getMypageMemberSponsor;
	console.log($mySponsorList);
	var $sponsorListA = $map.getMypageMemeberSponsorAjax;
	
	
	var $pagination = $map.pagination;
	console.log($pagination);
	
	var $memberId = $map.memberId;
	console.log($memberId);
	
	var $table = $("#memberSponsorListTable");
	$("<tr><th>센터명</th><th>분류</th><th>이름</th><th>상태</th><th>후원금</th><th>날짜</th></tr>").appendTo($table).css("background","#FFB24C");
	var $totalpayMoney=0;
	
	
	display_setting( $pagination, $mySponsorList );

	/* 동물상태*/
	function state(hihi){
		var $sponsorState;
		if(hihi == 1){
			$sponsorState="대기";
		}else if(hihi == 2){
			$sponsorState="접수";
		}else if(hihi == 3){
			$sponsorState="진행";
		}else if(hihi == 4){
			$sponsorState="입양";
		}else{
			$sponsorState="안락사";
		}
		return $sponsorState;
	}
	/* 분류 */
	function state2(hihi){
		var $petSort;
		if(hihi == 1){
			$petSort="강아지";
		}else if(hihi == 2){
			$petSort="고양이";
		}else if(hihi == 3){
			$petSort="기타";
		}
		return $petSort;
	}
	
	function display_setting( pagination, mySponsorList){
		
		$.each(mySponsorList, function(idx, $mySponsor){
			console.log(idx);
			console.log($mySponsor);
			
			var $tbody=$("<tbody></tbody>").appendTo($table);
			var $tr =$("<tr></tr>").appendTo($tbody);
			$("<td></td>").text($mySponsor.CENTERNAME).appendTo($tr);
			$("<td></td>").text(state2($mySponsor.PETSORT)).appendTo($tr);
			var $patNo = 	$("<td></td>").text($mySponsor.PETNAME).appendTo($tr);
			$("<td></td>").text(state($mySponsor.PETSTATE)).appendTo($tr);
			$("<td></td>").text(numberWithCommas($mySponsor.PAYMONEY)).appendTo($tr);
			$("<td></td>").text($mySponsor.SPONSORDATE).appendTo($tr);
			if(state($mySponsor.PETSTATE)!="입양"){
				var $link = $("<a></a>").attr("href","/jnj/menu/sponsor/view?petNo="+$mySponsor.PETNO);
				$patNo.wrapInner($link);	
			}
			var $payMoney = parseInt($mySponsor.PAYMONEY);
			
			$totalpayMoney+=$payMoney;
			$('#totalSponsorPay').text(numberWithCommas($totalpayMoney));
			
		})
		
		
		var ul = $("#pagination");
		ul.empty();
		var li;
		if(pagination.prev>0) {
			li = $("<li></li>").text('이전으로').appendTo(ul);
			li.wrapInner($("<a></a>").attr('href', '/jnj/member/sponsor/record?memberId='+$memberId+'&pageno='+ $pagination.prev))
		}
		for(var i=pagination.startPage; i<=pagination.endPage; i++) {
			li = $("<li></li>").text(i).appendTo(ul);
			if(pagination.pageno==i) 
				li.wrapInner($("<a></a>").attr('href', '/jnj/member/sponsor/record?memberId='+$memberId+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
			else
				li.wrapInner($("<a></a>").attr('href', '/jnj/member/sponsor/record?memberId='+$memberId+'&pageno='+ i))
		}
		if(pagination.next>0) {
			li = $("<li></li>").text('다음으로').appendTo(ul);
			li.wrapInner($("<a></a>").attr('href', '/jnj/member/sponsor/record?memberId='+$memberId+'&pageno='+ $pagination.next));
		}
	
	console.log($totalpayMoney);
	}
	//최신순, 센터별, 상태별, 후원금순 정렬 
	function sortSelect(){
		$mySponsorList.pageno = 1;
		$mySponsorList.sortType = ($mySponsorList.sortType)=="desc"?"asc":"desc";
		console.log(formDataSetting());
		
		
		
		$.ajax({
			url : "/jnj/member/sponsor/record/sort",
			type : "get",
			data : formDataSetting()+"&memberId="+$memberId,
			success : function(result){
				console.log(result);
				display_Resetting(result);
			}
		});
	}
	// 최신순 정렬
	$("#a1").on("click", function(e){
		e.preventDefault();
		$totalpayMoney =0;
		$mySponsorList.colName = "sponsorDate";
		sortSelect();
	});
	
	// 센터별 정렬
	$("#a2").on("click", function(e){
		e.preventDefault();
		$totalpayMoney =0;
		$mySponsorList.colName = "centerName";
		sortSelect();
	});
	
	// 상태별 정렬
	$("#a3").on("click", function(e){
		e.preventDefault();
		$totalpayMoney =0;
		$mySponsorList.colName = "petState";
		sortSelect();
	});
	
	// 후원금별 정렬
	$("#a4").on("click", function(e){
		e.preventDefault();
		$totalpayMoney =0;
		$mySponsorList.colName = "payMoney";
		sortSelect();
	});
	
	
	//숫자 콤마넣기
	function numberWithCommas(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
	
	
	
	
	// 정렬 시 화면 다시 그리기
	function display_Resetting( result ){
		
		var resultMap = JSON.parse(result);
		
		console.log(resultMap);
		
		// 테이블에 행 모두 지우기
		$("tbody").empty();
		
		display_setting( resultMap.pagination, resultMap.getMypageMemberSponsor);
	}
	
	
	
	function formDataSetting(){
		var form=$("#sponsorForm");
		form.empty();
		
		if( $mySponsorList.memberId != null ) $("<input type='hidden' name='memberId' value='"+$mySponsorList.memberId+"' >").appendTo(form);
		if( $mySponsorList.pageno != null ) $("<input type='hidden' name='pageno' value='"+$mySponsorList.pageno+"' >").appendTo(form);
		if( $mySponsorList.colName != null ) $("<input type='hidden' name='colName' value='"+$mySponsorList.colName+"' >").appendTo(form);
		if( $mySponsorList.sortType != null ) $("<input type='hidden' name='sortType' value='"+$mySponsorList.sortType+"' >").appendTo(form);
		if( $mySponsorList.startArticleNum != null ) $("<input type='hidden' name='startArticleNum' value='"+$mySponsorList.startArticleNum+"' >").appendTo(form);
		if( $mySponsorList.endArticleNum != null ) $("<input type='hidden' name='endArticleNum' value='"+$mySponsorList.endArticleNum+"' >").appendTo(form);
		var result=form.serialize();
		return result;
	}
	
	
});
</script>

</head>
<body>
	<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="minfo">개인정보수정</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="msponsor">후원내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="madopt">입양내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mvolunteer">봉사내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mmarket">프리마켓내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mstore">구매내역</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mqna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a id="mresign">회원탈퇴</a></h4>
	<hr>
	<div class="container memberSponserList">
		<h3>후원내역</h3>
		<hr>
		<div class="col-sm-3">
			총 후원금 : <span id="totalSponsorPay" readonly="readonly"></span>원
		</div>
		<br>
		<br>
		<div class="memberSponsorListDiv1 pull-right">
		<a href="#" id="a1">최신순</a> <a href="#" id="a2">센터별</a> <a href="#" id="a3">상태별</a> <a href="#"id="a4">후원금순</a>
		</div>
		<br>
		<br>
		<table class="table" id="memberSponsorListTable">
			
		</table>

		<div class="container2" >
			<ul class="pager" id="pagination">
			</ul>
		</div>
	</div>
	<form id="sponsorForm"></form>
	

</body>
</html>