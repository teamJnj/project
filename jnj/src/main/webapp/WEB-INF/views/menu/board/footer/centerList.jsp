<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<style>

#goCenterViewBtn{
	background-color: #FF9100;
	color: #fff;
}

#selectCenterAddr{
	float: right;
	margin-right: 10px;
}


#centerMainColor{
	color: #FF9100;
	margin-left: 30px;
	font-size: 28px;
}

#centerAddr{
	text-overflow: ellipsis;
   	overflow: hidden;
   	white-space: nowrap;
}

</style>

<script>

$(function(){
	
	var $map = ${map};
	var $centerList = $map.boardCenterList;
	var $pagination = $map.pagination;
	
	console.log($map);
	console.log($centerList);
	
	var $keyword = ${keyword};
	console.log($keyword);
	
	
	var $thumbnails = $("#centerList");
	
	$("#selectCenterAddr").val($keyword).attr("selected","selected");
	//$("#selectCenterAddr option:eq("+$keyword+")").attr("selected","selected");
	
	$("#selectCenterAddr").change(function(){
		$keyword = $("#selectCenterAddr option:selected").val();
		location.href="/jnj/menu/board_center/record?keyword="+$keyword;
	});
	
	
	/*
	<div class="col-md-3">
 	<div class="thumbnail">
 		<div id="dday">D-10</div>
    	<img src="http://placehold.it/320x200" alt="ALT NAME" class="img-responsive" />
     		<div class="caption">
	            <p>센터명</p>
	            <p>주소</p>
	            <p>전화번호</p>
                <p align="center"><button class="btn btn-block">상세보기</button></p>
            </div>
        </div>
    </div>	
	*/
	
	$.each($centerList, function(i, $center){
		var $colMd =  $("<div class='col-md-3'></div>").appendTo($thumbnails);
		var $classThumbnail =($("<div class='thumbnail'></div>")).appendTo($colMd);
		
		$("<img class='img-responsive' id='centerMainImg' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/center/"+ $center.CENTERIMG).appendTo($classThumbnail);
		
		
		var $caption = $("<div class='caption'></div>").appendTo($classThumbnail);
		$("<p style='text-align: center; color: #DF7401; font-size: 17px; margin-bottom: 16px; font-weight: bold;'></p>").text($center.CENTERNAME).appendTo($caption);
		$("<p></p>").attr("id","centerAddr").text("주소 : "+$center.CENTERADDR).appendTo($caption);
		
		$("<p></p>").text("전화번호 : "+$center.CENTERTEL).appendTo($caption);
		var $goViewBtn = $("<p align='center'></p>").appendTo($caption);
		$("<a class='btn btn-block' id='goCenterViewBtn'></a>").attr("href","/jnj/menu/board_center/view?centerId="+$center.CENTERID).text("센터 상세보기").appendTo($goViewBtn);
		
		
	});

	
	
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_center/record?keyword='+$keyword+'&pageno='+$pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_center/record?keyword='+$keyword+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_center/record?keyword='+$keyword+'&pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a").attr('href', '/jnj/menu/board_center/record?keyword='+$keyword+'&pageno='+ $pagination.next));
	}	
}); 
</script>
</head>

<body>
<p id="centerMainColor">센터 리스트</p>

<hr/>

<div>
	<select id="selectCenterAddr">
	  <option value="전체">지역전체</option>
	  <option value="서울">서울</option>
	  <option value="부산">부산</option>
      <option value="대구">대구</option>
      <option value="인천">인천</option>
      <option value="광주">광주</option>
      <option value="대전">대전</option>
      <option value="울산">울산</option>
      <option value="경기">경기</option>
      <option value="강원">강원</option>
      <option value="충북">충북</option>
      <option value="충남">충남</option>
      <option value="전북">전북</option>
      <option value="전남">전남</option>
      <option value="경북">경북</option>
      <option value="전남">전남</option>
      <option value="경북">경북</option>
      <option value="경남">경남</option>
      <option value="제주">제주</option>
	</select>  
</div>
<br>
<br>
<div class="container" id="allCenterList">
    <div class="row">
    	<ul class="thumbnails" id="centerList">
    	
    	
    	
	    <!-- 
	    <div class="col-md-3">
	     	<div class="thumbnail">
	     		<div id="dday">D-10</div>
	        	<img src="http://placehold.it/320x200" alt="ALT NAME" class="img-responsive" />
	         		<div class="caption">
	                    <p>센터명</p>
	                    <p>주소</p>
	                    <p>전화번호</p>
	                    <p align="center"><button class="btn btn-block">상세보기</button></p>
	                </div>
	            </div>
	        </div>
	    
	     -->
	        
	        
	        
	        
		</ul>
	</div>
</div>

	<div class="container">
		<ul class="pager" id="pagination">
		</ul>
	</div>
	
</body>
</html>