<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>Insert title here</title>
<script>
//단위 , 찍기
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


$(function() {
	var interestList = ${interestList};
	var map = ${storeList};
	var storeList = map.storeList;
	var $pagination = map.pagination;
	var $like = $(".storelike");
	var $main = $(".storemain");
	var breakcnt = 0;
	var option = $("#order").val(); 
	var search = $(location).attr("search");

	// 카테고리명
	var jj = ${categoryName};
	$("#subtitle").text(jj); 
	
	
	// 상단 인기상품 리스트
	$.each(interestList, function(idx, $interestList) {
		if(breakcnt<=3) {
			var	$col = $("<div></div>").attr("class", "col-md-3").appendTo($like);
			var	$thum = $("<div></div>").attr("class", "thumbnail").css("width", "210px").css("height", "280px").appendTo($col);
			var $a = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo="+$interestList.GOODSNO).appendTo($thum);
			$("<img>").attr("src", "/jnjimg/goods/"+$interestList.GOODSIMG).attr("alt", $interestList.GOODSNO).attr("style", "width: 100%").attr("style", "height: 70%").appendTo($a);
			var $cap = $("<div></div>").attr("class", "caption").appendTo($a);
			$("<p></p>").text($interestList.GOODSNAME).appendTo($cap);
			if($interestList.GOODSSTATE==1) {
				$("<p></p>").text(numberWithCommas($interestList.GOODSPRICE)+"원").appendTo($cap); 
			}
			else if($interestList.GOODSSTATE==0)
				$("<p></p>").text("품절").appendTo($cap); 
			breakcnt++;
		} else
			return false;
	})
	// 메인 상품 리스트
	$.each(storeList, function(idx, $storeList) {
		var	$col = $("<div></div>").attr("class", "col-md-3").appendTo($main);
		var	$thum = $("<div></div>").attr("class", "thumbnail").css("width", "210px").css("height", "280px").appendTo($col);
		var $a = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo="+$storeList.GOODSNO).appendTo($thum);
		$("<img>").attr("src", "/jnjimg/goods/"+$storeList.GOODSIMG).attr("alt", $storeList.GOODSNO).attr("style", "width: 100%").attr("style", "height: 70%").appendTo($a);
		var $cap = $("<div></div>").attr("class", "caption").appendTo($a);
		$("<p></p>").text($storeList.GOODSNAME).appendTo($cap);
		if($storeList.GOODSSTATE==1)
			$("<p></p>").text(numberWithCommas($storeList.GOODSPRICE)+"원").appendTo($cap); 
		else if($storeList.GOODSSTATE==0)
			$("<p></p>").text("품절").appendTo($cap); 
	}) 
	
	
	// 필터
	$("#order").change(function(){
		var $order = $("#order option:selected").attr("value");
		var oSplit = $order.split('/');
		var col = oSplit[0];
		var sort = oSplit[1];
		if(option!=$order) {
			var sSplit = search.split('&');
			
			if(search=="" || search.match("pageNo") || sSplit[0].match("colName")) {
				location.href=$(location).attr("pathname")+"?colName="+col+"&sortType="+sort;
			} 
			else if(sSplit[0].match("categoryName")) {
				location.href=$(location).attr("pathname")+sSplit[0]+"&colName="+col+"&sortType="+sort;
			} 
			else if(sSplit[0].match("keyword")) {
				
				var temp =($(location).attr("pathname")+sSplit[0]+"&colName="+col+"&sortType="+sort);
				
				location.href=temp;
			}
		}
	});
	
	
	
	
	// 검색
	$(".searchbtn").on("click", function() {
		var $storeform = $("<form></form>").attr("action", "/jnj/menu/store/search").attr("method", "get");
		$(".storesearch").wrap($storeform);
	})
	
	// 페이지네이션
	var sSplit = search.split('&');	
	var ul = $(".pager");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		if(search=="" || sSplit[0].match("pageNo")) {
			li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record?pageNo="+ $pagination.prev));
		} else if(sSplit[0].match("colName") || sSplit[0].match("categoryName") || sSplit[0].match("keyword")) {
			if(sSplit[(sSplit.length)-1].match("pageNo")) {
				var substr = search.lastIndexOf("&");
				var sub = search.substring(0,substr);
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record"+sub+"&pageNo="+ $pagination.prev));
			} else {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record"+search+"&pageNo="+ $pagination.prev));
			}
		} else if(sSplit[0].match("keyword")) {
			if(sSplit[(sSplit.length)-1].match("pageNo")) {
				var substr = search.lastIndexOf("&");
				var sub = search.substring(0,substr);
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/search"+sub+"&pageNo="+ $pagination.prev));
			} else {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/search"+search+"&pageNo="+ $pagination.prev));
			}
		}
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if(search=="" || sSplit[0].match("pageNo")) {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record?pageNo="+ i));
		} else if(sSplit[0].match("colName") || sSplit[0].match("categoryName")) {
			if(sSplit[(sSplit.length)-1].match("pageNo")) {
				var substr = search.lastIndexOf("&");
				var sub = search.substring(0,substr);
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record"+sub+"&pageNo="+ i));
			} else {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record"+search+"&pageNo="+ i));
			}
		} else if(sSplit[0].match("keyword")) {
			if(sSplit[(sSplit.length)-1].match("pageNo")) {
				var substr = search.lastIndexOf("&");
				var sub = search.substring(0,substr);
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/search"+sub+"&pageNo="+ i));
			} else {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/search"+search+"&pageNo="+ i));
			}
		}
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		if(search=="" || sSplit[0].match("pageNo")) {
			li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record?pageNo="+ $pagination.next));
		} else if(sSplit[0].match("colName") || sSplit[0].match("categoryName") || sSplit[0].match("keyword")) {
			if(sSplit[(sSplit.length)-1].match("pageNo")) {
				var substr = search.lastIndexOf("&");
				var sub = search.substring(0,substr);
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record"+sub+"&pageNo="+ $pagination.next));
			} else {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/record"+search+"&pageNo="+ $pagination.next));
			}
		} else if(sSplit[0].match("keyword")) {
			if(sSplit[(sSplit.length)-1].match("pageNo")) {
				var substr = search.lastIndexOf("&");
				var sub = search.substring(0,substr);
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/search"+sub+"&pageNo="+ $pagination.next));
			} else {
				li.wrapInner($("<a></a>").attr("href", "/jnj/menu/store/search"+search+"&pageNo="+ $pagination.next));
			}
		}
	}
	
	
	/* 혜미 miniBasket */
	//옆에 따라오는 작은 장바구니! session값이 null이면 안보이게 해줘야함
	var $basketList = ${cBasketList};
	var $productList = $basketList.productList;
	var size=null;
	$.each($productList,function(idx,product){
		size=idx;
	})
	console.log("미니장바구니 사이즈 : ");
	console.log(size);
	if(size<=-1 || size==null){
		$("#miniBasket").hide();
	}else if(size>=0){
		$(document).scroll(function(){
			var con = $("#miniBasket");
			var position = $(window).scrollTop();
			if(position > 50){ con.fadeIn(500); }
			else if(position < 50){ con.fadeOut(500); }
		});
		
	} 

})
</script>
<style>
.storeNav .sidenav {
	text-align: center;
}
.storeNav li {
	border-bottom: 1px solid #ccc;
	height: 60px;
	line-height: 30px;
}
.storeNav a {
	color: #585858;
}
.storeNav h2 {
	color: #7F5926;
	padding: 30px 0;
	border-bottom: 1px solid #ccc;
}

.storeList {
	margin-left: 30px;
}

.storeList .row {
	text-align: center;
}

.storeList h3 {
	color: #7F5926;
}

.storeList .search button {
	height: 34px;
}

.storeList .storesearch .form-control {
	display: inline;
	width: 160px;
}

.storeList .storesearch {
	margin-left: 78%;
}

.storeList .storeorder .form-control {
	display: inline;
	width: 130px;
	margin-left: 85%;
}

/* 혜미 miniBasket */
#miniBasket{
position: fixed;
width: 200px;
height: 420px;
left: 20px;
top:200px;
display: none;
}

</style>
</head>
<body>
	<div class="container-fluid storeAllList">
		<div class="row content storeNav">
			<div class="col-sm-2 sidenav hidden-xs">
				<h2 id="subtitle"></h2>
				
				<ul class="nav nav-pills nav-stacked storeside">
					<li><a href="/jnj/menu/store/record">전체</a></li>
					<li><a href="/jnj/menu/store/record?categoryName=액세서리">액세서리</a></li>
					<li><a href="/jnj/menu/store/record?categoryName=가방/파우치">가방/파우치</a></li>
					<li><a href="/jnj/menu/store/record?categoryName=문구">문구</a></li>
					<li><a href="/jnj/menu/store/record?categoryName=기타">기타</a></li>
				</ul>
				<br>
			</div>
			<div class="row col-sm-9 storeList">
				<br>
				<div class="input-group storesearch">
					<div class="input-group-btn">
						<button class="btn btn-default searchbtn" type="submit">
							<i class="glyphicon glyphicon-search"></i>
						</button>
					</div>
					<input type="text" id="keyword" name="keyword" class="form-control" placeholder="Search">
				</div>
				<h3>인기상품</h3>
				<hr/>
				<div class="row storelike">
					
				</div>
				<div class="form-group storeorder">
					<select id="order" name="order" class="form-control">
						<option value="">정렬</option>
						<option value="goodsNo/desc">등록일순</option>
						<option value="goodsPrice/desc">높은 가격순</option>
						<option value="goodsPrice/asc">낮은 가격순</option>
						<option value="goodsName/asc">이름순</option>
					</select>
				</div>			
				<hr/>
				<div class="row storemain">
				</div>
				<br>
				<div class="container2">
					<ul class="pager">
					</ul>
				</div>
				<br><br>
			</div>
		</div>
	</div>
	
	<div id="miniBasket">
		<jsp:include page="sessionBasket.jsp"></jsp:include>
	</div>
</body>
</html>