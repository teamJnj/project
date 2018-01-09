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
#mercyDDay{
	position: absolute;
	color: #fff;
	text-shadow: 0.1em 0.1em 0.3em #131313; 
	font-size: 30px;
	right: 1;
}
#petNowState{
	position: absolute;
	color: #fff;
	text-shadow: 0.1em 0.1em 0.3em #131313; 
	font-size: 15px;
	right: 0;
	margin-right: 20px;
	font-weight: bold;
}


#goSponsorViewBtn{
	background-color: #FF9100;
	color: #fff;
}

#adoptMainColor{
	color: #FF9100;
	margin-left: 30px;
	font-size: 28px;
}


#selectPetState, #selectCenterAddr{
	float: right;
	margin-right: 10px;
}

#selectPetSort{
	float: right;
	margin-right: 70px;
}
</style>

<script>

$(function(){
	
	var $map = ${map};
	var $adoptList = $map.getAdoptList;
	var $pagination = $map.pagination;
	var $mAuthority = ${mAuthority};
	
	//console.log($map);
	//console.log($mAuthority);
	
	var $petSort = $map.petSort;
	var $petState = $map.petState;
	var $firstAddr = $map.firstAddr;

	//console.log($petSort);
	//console.log($petState);
	//console.log($firstAddr);

	//var $mercyDate = $adopt.mercyDate;
	
	var $thumbnails = $("#adoptList");
	
	$("#selectPetSort option:eq("+$petSort+")").attr("selected","selected");
	$("#selectPetState option:eq("+$petState+")").attr("selected","selected");
	$("#selectCenterAddr").val($firstAddr).attr("selected","selected");
	
	$("#selectPetSort").change(function(){
		$petSort = $("#selectPetSort option:selected").val();
		$petState = $("#selectPetState option:selected").val();
		$firstAddr = $("#selectCenterAddr option:selected").val();
		
		location.href="/jnj/menu/adopt/record?petSort="+$petSort+"&petState="+$petState+"&firstAddr="+$firstAddr;
	});
	
	$("#selectPetState").change(function(){
		$petSort = $("#selectPetSort option:selected").val();
		$petState = $("#selectPetState option:selected").val();
		$firstAddr = $("#selectCenterAddr option:selected").val();
		location.href="/jnj/menu/adopt/record?petSort="+$petSort+"&petState="+$petState+"&firstAddr="+$firstAddr;
	});
	
	$("#selectCenterAddr").change(function(){
		$petSort = $("#selectPetSort option:selected").val();
		$petState = $("#selectPetState option:selected").val();
		$firstAddr = $("#selectCenterAddr option:selected").val();
		
		
		location.href="/jnj/menu/adopt/record?petSort="+$petSort+"&petState="+$petState+"&firstAddr="+$firstAddr;
	});
	
	
	/*
	<div class="col-md-3">
 	<div class="thumbnail">
 		<div id="dday">D-10</div>
    	<img src="http://placehold.it/320x200" alt="ALT NAME" class="img-responsive" />
     		<div class="caption">
                <p>견종</p>
                <p>성별</p>
                <p>센터</p>
                <p align="center"><button class="btn btn-block">상세보기</button></p>
            </div>
        </div>
    </div>	
	*/
	
	$.each($adoptList, function(i, $adopt){
		var $colMd =  $("<div class='col-md-3'></div>").appendTo($thumbnails);
		var $classThumbnail =($("<div class='thumbnail'></div>")).appendTo($colMd);
		//$("<div></div>").attr("id","mercyDDay").text("D-"+$adopt.mercyDate).appendTo($classThumbnail);
		
		if($adopt.petState==5 ){
			$("<div></div>").attr("id","mercyDDay").text("D-"+$adopt.mercyDate).appendTo($classThumbnail).css("display","none");
		} else if($adopt.petState==4){
			$("<div></div>").attr("id","mercyDDay").text("D-"+$adopt.mercyDate).appendTo($classThumbnail).css("display","none");
		} else{
			$("<div></div>").attr("id","mercyDDay").text("D-"+$adopt.mercyDate).appendTo($classThumbnail);
		}
		
		//$("<div></div>").attr("id","petNowState").text($adopt.petState).appendTo($classThumbnail);
		if($adopt.petState==1){
			$("<div></div>").attr("id","petNowState").text("입양대기").appendTo($classThumbnail);
		} else if($adopt.petState==2){
			$("<div></div>").attr("id","petNowState").text("입양접수").appendTo($classThumbnail);
		} else if($adopt.petState==3){
			$("<div></div>").attr("id","petNowState").text("입양 진행중").appendTo($classThumbnail);
		} else if($adopt.petState==4){
			$("<div></div>").attr("id","petNowState").text("입양완료").appendTo($classThumbnail);
		} else if($adopt.petState==5){
			$("<div></div>").attr("id","petNowState").text("안락사").appendTo($classThumbnail);
		}
		
		
		//$("<img class='img-responsive' id='petImgMini' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/pet/"+ $adopt.petImg).appendTo($classThumbnail);
		if($adopt.petState==5){
			$("<img class='img-responsive' id='petImgMini' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/pet/"+ $adopt.petImg).appendTo($classThumbnail).css("-webkit-filter","grayscale(100%)");
		} else{
			$("<img class='img-responsive' id='petImgMini' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/pet/"+ $adopt.petImg).appendTo($classThumbnail);
		}
		
		
		var $caption = $("<div class='caption'></div>").appendTo($classThumbnail);
		$("<p style='text-align: center; color: #DF7401; font-size: 17px; margin-bottom: 16px; font-weight: bold;'></p>").text($adopt.petName).appendTo($caption);
		
		//$("<p></p>").text("성별 : "+$adopt.gender).appendTo($caption);
		if($adopt.kind==null){
			$("<p></p>").text("종류 : 알 수 없음").appendTo($caption);
		} else{
			$("<p></p>").text("종류 : "+$adopt.kind).appendTo($caption);
		}
		if($adopt.gender==1){
			$("<p></p>").text("성별 : 남자").appendTo($caption);
		}else if($adopt.gender==2){
			$("<p></p>").text("성별 : 여자").appendTo($caption);
		}
		
		
		$("<p></p>").text("센터 : "+$adopt.centerName).appendTo($caption);
		var $goViewBtn = $("<p align='center'></p>").appendTo($caption);
		

		if($mAuthority=="ROLE_CENTER"){
			$("<a class='btn btn-block goSponsorViewBtn' id='goSponsorViewBtn'></a>").text("입양신청 페이지").appendTo($goViewBtn);
		} else{
			$("<a class='btn btn-block goSponsorViewBtn' id='goSponsorViewBtn'></a>").attr("href","/jnj/menu/adopt/view?petNo="+$adopt.petNo).text("입양신청 페이지").appendTo($goViewBtn);			
		}
		
	});
	
	
	if($mAuthority=="ROLE_CENTER"){
		$(".goSponsorViewBtn").on("click",function(){
			alert("센터회원은 입양 할 수 없습니다.");
		});
	};
	
	
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a").attr('href', '/jnj/menu/adopt/record?petSort='+$petSort+'&pageno='+$pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/adopt/record?petSort='+$petSort+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/adopt/record?petSort='+$petSort+'&pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a").attr('href', '/jnj/menu/adopt/record?petSort='+$petSort+'&pageno='+ $pagination.next));
	}	
}); 
</script>
</head>

<body>
<p id="adoptMainColor">입양</p>

<hr/>
<div>
	<select id="selectPetSort">
	  <option value="0">종류전체</option>
	  <option value="1">강아지</option>
	  <option value="2">고양이</option>
	  <option value="3">기타</option>
	</select>  
</div>

<div>
	<select id="selectPetState">
	  <option value="0">상태전체</option>
	  <option value="1">대기</option>
	  <option value="2">접수</option>
	  <option value="3">진행</option>
	  <option value="4">입양</option>
	  <option value="5">안락사</option>
	</select>  
</div>

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
      <option value="경남">경남</option>
      <option value="제주">제주</option>
	</select>  
</div>
<br>
<br>
<div class="container" id="adoptPetList">
    <div class="row">
    	<ul class="thumbnails" id="adoptList">
    	
    	
    	
	    <!-- 
	    <div class="col-md-3">
	     	<div class="thumbnail">
	     		<div id="dday">D-10</div>
	        	<img src="http://placehold.it/320x200" alt="ALT NAME" class="img-responsive" />
	         		<div class="caption">
	                    <p>견종</p>
	                    <p>성별</p>
	                    <p>센터</p>
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