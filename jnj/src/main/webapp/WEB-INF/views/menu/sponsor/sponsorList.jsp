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

div.progress-bar{
	background-color: #FFB24C;
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


#selectPetSort{
	float: right;
	margin-right: 70px;
}
</style>

<script>
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
};


$(function(){
	
	var $map = ${map};
	var $mAuthority = ${mAuthority};
	console.log($map);
	console.log($mAuthority);
	var $sponsorList = $map.getAllSponsorList;
	var $sponsorListGetSort = $map.sponsorList;
	
	var $pagination = $map.pagination;
	var $petSort = $map.petSort;
	var $thumbnails = $("#sponsorList");
	
	$("#selectPetSort option:eq("+$petSort+")").attr("selected","selected");
	$("#selectPetSort").change(function(){
		$petSort = $("#selectPetSort option:selected").attr("value");
		location.href="/jnj/menu/sponsor/record?petSort="+$petSort;
	});
	
	
   
	$.each($sponsorList, function(i, $sponsor){
		var $colMd =  $("<div class='col-md-3'></div>").appendTo($thumbnails);
		var $classThumbnail =($("<div class='thumbnail'></div>")).appendTo($colMd);
		$("<div></div>").attr("id","mercyDDay").text("D-"+$sponsor.mercyDate).appendTo($classThumbnail);
		$("<img class='img-responsive' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/pet/"+ $sponsor.petImg).appendTo($classThumbnail);
		var $caption = $("<div class='caption'></div>").appendTo($classThumbnail);
		var $progress = $("<div class='progress'></div>").appendTo($caption);
		var $progressBar = $("<div class='progress-bar' role='progressbar' aria-valuenow='1' aria-valuemin='0' aria-valuemax='100' style='width: "+$sponsor.goalPercent+"%;' data-toggle='tooltip' data-placement='top'></div>").appendTo($progress);
		$("<span class='progress-type'></span>").text($sponsor.goalPercent+'%').appendTo($progressBar);
		$("<p></p>").text("후원금액 : "+numberWithCommas($sponsor.sponsorMoney)).appendTo($caption);
		$("<p></p>").text("동물이름 : "+$sponsor.petName).appendTo($caption);
		$("<p></p>").text("동물종류 : "+$sponsor.kind).appendTo($caption);
		var $goViewBtn = $("<p align='center'></p>").appendTo($caption);
		
		if($mAuthority=="ROLE_CENTER"){
			$("<a class='btn btn-block goSponsorViewBtn' id='goSponsorViewBtn'></a>").text("후원하기").appendTo($goViewBtn);
		} else{
			$("<a class='btn btn-block goSponsorViewBtn' id='goSponsorViewBtn'></a>").attr("href","/jnj/menu/sponsor/view?petNo="+$sponsor.petNo).text("후원하기").appendTo($goViewBtn);			
		}
	
	});
	
	
	$.each($sponsorListGetSort, function(i, $sponsor){
		var $colMd =  $("<div class='col-md-3'></div>").appendTo($thumbnails);
		var $classThumbnail =($("<div class='thumbnail'></div>")).appendTo($colMd);
		$("<div></div>").attr("id","mercyDDay").text("D-"+$sponsor.mercyDate).appendTo($classThumbnail);
		$("<img class='img-responsive' style=\"width:320px; height:200px;\"></img>").attr("src","/jnjimg/pet/"+ $sponsor.petImg).appendTo($classThumbnail);
		var $caption = $("<div class='caption'></div>").appendTo($classThumbnail);
		var $progress = $("<div class='progress'></div>").appendTo($caption);
		var $progressBar = $("<div class='progress-bar' role='progressbar' aria-valuenow='1' aria-valuemin='0' aria-valuemax='100' style='width: "+$sponsor.goalPercent+"%;' data-toggle='tooltip' data-placement='top'></div>").appendTo($progress);
		$("<span class='progress-type'></span>").text($sponsor.goalPercent+'%').appendTo($progressBar);
		$("<p></p>").text("후원금액 : "+$sponsor.sponsorMoney).appendTo($caption);
		$("<p></p>").text("동물이름 : "+$sponsor.petName).appendTo($caption);
		$("<p></p>").text("동물종류 : "+$sponsor.kind).appendTo($caption);
		var $goViewBtn = $("<p align='center'></p>").appendTo($caption);
		
		if($mAuthority=="ROLE_CENTER"){
			$("<a class='btn btn-block goSponsorViewBtn' id='goSponsorViewBtn'></a>").text("후원하기").appendTo($goViewBtn);
		} else{
			$("<a class='btn btn-block goSponsorViewBtn' id='goSponsorViewBtn'></a>").attr("href","/jnj/menu/sponsor/view?petNo="+$sponsor.petNo).text("후원하기").appendTo($goViewBtn);			
		}

	});
	
	
	
	if($mAuthority=="ROLE_CENTER"){
		$(".goSponsorViewBtn").on("click",function(){
			alert("센터회원은 후원할 수 없습니다.");
		});
	};
	
	
	
	var ul = $("#pagination");
	var li;
	if($pagination.prev>0) {
		li = $("<li></li>").text('이전으로').appendTo(ul);
		li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/record?petSort='+$petSort+'&pageno='+$pagination.prev))
	}
	for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
		li = $("<li></li>").text(i).appendTo(ul);
		if($pagination.pageno==i) 
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/record?petSort='+$petSort+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
		else
			li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/record?petSort='+$petSort+'&pageno='+ i))
	}
	if($pagination.next>0) {
		li = $("<li></li>").text('다음으로').appendTo(ul);
		li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/record?petSort='+$petSort+'&pageno='+ $pagination.next));
	}	
}); 
</script>
</head>

<body>
<p id="adoptMainColor">후원</p>

<hr/>
<div>
	<select id="selectPetSort">
	  <option value="0">전체</option>
	  <option value="1">강아지</option>
	  <option value="2">고양이</option>
	  <option value="3">기타</option>
	</select>  
</div>

<br>
<br>
<div class="container" id="sponsorPetList">
    <div class="row">
    	<ul class="thumbnails" id="sponsorList">
    	
    	
    	
	    <!--  <div class="col-md-3">
	     	<div class="thumbnail">
	     		<div id="mercyDDay">D-10</div>
	        	<img src="http://placehold.it/320x200" alt="ALT NAME" class="img-responsive" />
	         		<div class="caption">
	        			<div class="progress">
							<div class="progress-bar" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100" style="width: 70%;" data-toggle="tooltip" data-placement="top" title="CSS / CSS3">
								<span class="progress-type">70%</span>
							</div>
					    </div>
	                    <p>후원 금액</p>
	                    <p>이름</p>
	                    <p>종류</p>
	                    <p align="center"><button class="btn btn-block" id="goAdoptViewBtn">후원하기</button></p>
	                </div>
	            </div>
	        </div> -->
	        
	        
	        
	        
		</ul>
	</div>
</div>


	<div class="container">
		<ul class="pager" id="pagination">
		</ul>
	</div>
	
</body>
</html>