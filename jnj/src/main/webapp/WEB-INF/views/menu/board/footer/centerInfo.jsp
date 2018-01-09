<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<style>

hr{
   border: 1px solid #FFB24C;
}

#info{
   margin-top: 50px;
   margin-left: 25%;
}

.contentTd, #centerName{
   border-left: 1px solid #7F5926;
   border-bottom: 1px solid #fff;
   width: 300px;
   border-top: 1px solid #fff;
   font-size: 18px;
   padding: 10px 10px 10px 10px;
   font-weight:bold;
   color: #7F5926;
}

#contentTh{
   text-align: left;
   padding: 10px 0px 10px 10px;
   font-size: 25px;
   width: 70px;
   font-weight:bold;
   color: #FF9100;
   border-bottom: 1px solid #fff;
   border-top: 1px solid #fff;
}

#goCenterListBtn{
   float: right;
   margin-right: 50px;
   width: 100px;
   height: 40px;
   text-align: 40px;
   background-color: #FFB24C;
   color: #fff;
}


#myCarouselContainer{
   overflow: hidden;
   display: inline-block;
   width: 600px;
}
.carousel-inner > .item > img {
      top: 0;
      left: 0;
      min-width: 600px;
      height: auto;
    } 
#myCarousel{
	width: 600px;
   	height: 400px;
}
</style>
<script>

$(function(){
   
   var $map = ${map};
   
   
   var $center = $map.centerView;
   var $imgList = $map.centerImg;
   
   
   
   //이미지삽입
   var $imgOl = $("#imgOl");
   var $imgDiv = $("#imgDiv");
   $.each($imgList, function(i, $img){
	   if($img.centerImgNo==1) {
			$("<li data-target=\"#myCarousel\" data-slide-to=\""+($img.centerImgNo-1)+"\" class=\"active\"></li>").appendTo($imgOl);
			var $imgDivDiv = $("<div class=\"item active\"></div>").appendTo($imgDiv);
			$("<img src=\"/jnjimg/center/"+ $img.img +"\" alt=\""+$img.img+"\">").appendTo($imgDivDiv);
	   } else {
			$("<li data-target=\"#myCarousel\" data-slide-to=\""+($img.centerImgNo-1)+"\"></li>").appendTo($imgOl);
			var $imgDivDiv = $("<div class=\"item\"></div>").appendTo($imgDiv);
			$("<img src=\"/jnjimg/center/"+ $img.img +"\" alt=\""+$img.centerImgNo+"\">").appendTo($imgDivDiv);
	   }
	});
   
   
   //센터객체 삽입
   $("#centerName").text($center.centerName);
   $("#centerAddr").text($center.centerAddr);
   $("#centerTel").text($center.centerTel);
   $("#centerMail").text($center.email);
   $("#centerHomepage").text($center.homepage);
   
   
   $("#goCenterListBtn").on("click",function(){
	   location.href="/jnj/menu/board_center/record?keyword=전체";
   });
});
</script>
</head>
<body>

<div>
   <a href="/jnj/menu/adopt/record?petSort=0&petState=0&firstAddr=전체" class="btn btn-block" id="goCenterListBtn">목록</a>
</div>

<br>
<br>
<hr/>

<div id="info">

<!-- <img src="이미지경로" width="300" height="250"> -->

<div class="container" id="myCarouselContainer">
  <div id="myCarousel" class="carousel slide" data-ride="carousel">
    <!-- Indicators -->
    <ol id="imgOl" class="carousel-indicators">
    	<!-- 
      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
      <li data-target="#myCarousel" data-slide-to="1"></li>
      <li data-target="#myCarousel" data-slide-to="2"></li> -->
    </ol>

    <!-- Wrapper for slides -->
    <div id="imgDiv" class="carousel-inner">
    <!-- 
      <div class="item active">
        <img src="la.jpg" alt="Los Angeles" style="width:100%;">
      </div>

      <div class="item">
        <img src="chicago.jpg" alt="Chicago" style="width:100%;">
      </div>
    
      <div class="item">
        <img src="ny.jpg" alt="New york" style="width:100%;">
      </div>
       -->
    </div>

    <!-- Left and right controls -->
    <a class="left carousel-control" href="#myCarousel" data-slide="prev">
      <span class="glyphicon glyphicon-chevron-left"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control" href="#myCarousel" data-slide="next">
      <span class="glyphicon glyphicon-chevron-right"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
</div>

<br>

<div>
  <table class="table" id="centerList">
  
      <tr>
        <th id="contentTh">센터명</th>
        <td class="contentTd" id="centerName"></td>
      </tr>
      <tr>
        <th id="contentTh">센터 주소</th>
        <td class="contentTd" id="centerAddr"></td>
      </tr>
      <tr>
        <th id="contentTh">센터 전화번호</th>
        <td class="contentTd" id="centerTel"></td>
      </tr>
      <tr>
        <th id="contentTh">센터 이메일</th>
        <td class="contentTd" id="centerMail"></td>
      </tr>
      <tr>
        <th id="contentTh">센터 홈페이지</th>
        <td class="contentTd" id="centerHomepage"></td>
      </tr>

  </table>
</div>


</div>

<hr/>

</body>
</html>