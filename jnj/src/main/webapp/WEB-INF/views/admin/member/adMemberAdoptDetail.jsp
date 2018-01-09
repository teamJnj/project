<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style>

/* 상태바 스타일 */
#situation{
   width: 800px;
}
.smpl-step > .smpl-step-step {
    padding: 0;
    position: relative;
}   

.smpl-step > .smpl-step-step .smpl-step-num {
    font-size: 17px;
    margin-top: -20px;
    margin-left: 47px;
}

.smpl-step > .smpl-step-step > .smpl-step-icon {
    position: absolute;
    width: 70px;
    height: 70px;
    display: block;
    background: #FFB24C;
    top: 45px;
    left: 50%;
    margin-top: -35px;
    margin-left: -15px;
    border-radius: 50%;
    text-align: center;
    line-height: 70px;
    font-size: 20px;
    font-weight: bold;
    color: #7F5926;
}

#situationProgress {
    position: relative;
    height: 8px;
    box-shadow: none;
    margin-top: 37px;
    margin-left: 100px;
    width: 600px;
}


hr{
   border: 1px solid #FFB24C;
}



/* 댕댕이 정보 스타일 */
#info{
   margin-top: 50px;
   margin-left: 150px;
   width: 600px;
}

.contentTd,#petName{
   border-left: 1px solid #7F5926;
   border-bottom: 1px solid #fff;
   border-top: 1px solid #fff;
}

#contentTh{
   text-align: left;
   padding: 10px 0px 10px 0px;
   width: 120px;
   border-bottom: 1px solid #fff;
   border-top: 1px solid #fff;
}

#goAdoptListBtn{
   float: right;
   margin-right: 50px;
   width: 100px;
   height: 40px;
   text-align: 40px;
   background-color: #FFB24C;
   color: #fff;
}

#titleTotal{
	margin-top: 50px;
}

div.progress-bar{
   background-color: #FF9100;
}


#adoptBtns{
	float: right;
	width: 300px;
	margin-right: 150px;
	margin-top: 50px;
}

#applyAdoptBtn, #goSponsorViewBtn{
	float: right;
	width: 250px;
	height: 80px;
    background-color: #FFB24C;
    font-size: 28px;
    font-weight: bold;
    color: #7F5926;
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
   
   
   var $adopt = $map.spDomain;
   
   console.log($adopt);
   var $imgList = $map.imgList;
   var $petNo = $adopt.petNo;
   
   
   
   //이미지삽입
   var $imgOl = $("#imgOl");
   var $imgDiv = $("#imgDiv");
   $.each($imgList, function(i, $img){
	   if($img.petImgNo==1) {
			$("<li data-target=\"#myCarousel\" data-slide-to=\""+($img.petImgNo-1)+"\" class=\"active\"></li>").appendTo($imgOl);
			var $imgDivDiv = $("<div class=\"item active\"></div>").appendTo($imgDiv);
			$("<img src=\"/jnjimg/pet/"+ $img.petImg +"\" alt=\""+$img.petImgNo+"\">").appendTo($imgDivDiv);
	   } else {
			$("<li data-target=\"#myCarousel\" data-slide-to=\""+($img.petImgNo-1)+"\"></li>").appendTo($imgOl);
			var $imgDivDiv = $("<div class=\"item\"></div>").appendTo($imgDiv);
			$("<img src=\"/jnjimg/pet/"+ $img.petImg +"\" alt=\""+$img.petImgNo+"\">").appendTo($imgDivDiv);
	   }
	});
   
   //스폰서객체삽입
   $("#petName").text($adopt.petName);
   $("#petSort").text($adopt.petSort);
   $("#petKind").text($adopt.kind);
   $("#petGender").text($adopt.gender);
   $("#petAge").text($adopt.age);
   $("#petWeight").text($adopt.weight);
   $("#petDisease").text($adopt.disease);
   $("#petMercyDate").text($adopt.mercyDate);
   $("#petFeature").text($adopt.feature);
   $("#centerName").text($adopt.centerName);
   $("#centerAddr").text($adopt.centerAddr);
   $("#centerTel").text($adopt.centerTel);
   $("#centerEmail").text($adopt.centerEmail);
   
   if($adopt.petState==1){
	   $("#petSortsituationProgress").css("width","0%");
   } else if($adopt.petState==2){
	   $("#petSortsituationProgress").css("width","40%");
   } else if($adopt.petState==3){
	   $("#petSortsituationProgress").css("width","70%");
   } else if($adopt.petState==4){
	   $("#petSortsituationProgress").css("width","100%");
   } else if($adopt.petState==5){
	   $("#petSortsituationProgress").css("width","100%").css("background-color","black");
   }
   
   
   var idx =0 ;
   setInterval(function(){
	   idx+=1;
	   if( idx%2 == 0 )
	   		$("#goAdoptListBtn").css("background-color", "#FFB24C");
	   else 
			$("#goAdoptListBtn").css("background-color", "#FF9100");
	}, 2000);
	
   $("#goAdoptListBtn").on( "click", function () {
		self.close();	   
  	});
   
   
   $("#applyAdoptBtn").on("click", function(){
	   if($("#applyAdoptBtn").val()==0){
		   
		   var $frm = $("#frm");
		   $frm.empty();
		   
			   var $applyAdopt = window.open("", "입양신청", "width=810, height=400");
			   
			   $frm.attr("target", "입양신청");
		       $frm.attr("action", "/jnj/menu/adopt/apply1");
		       $frm.attr("method", "post");
		       
		       $("<input></input>").attr("type","hidden").attr("name","petNo").val($adopt.petNo).appendTo($frm);
		       $("<input></input>").attr("type","hidden").attr("name","petState").val($adopt.petState).appendTo($frm);
		       
		       $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($frm);
		      
		       console.log( $frm.serialize() );
	       	$frm.submit();
	       	
	   } else if($("#applyAdoptBtn").val()==1){
		   $("#applyAdoptBtn").text("취소하기");
		   $("#applyAdoptBtn").on("click",function(){
			   $("#applyAdoptBtn").val(0);
			   $("#applyAdoptBtn").text("입양신청");
		   });
	   }
	   
       
   });
   
   
   $("#goSponsorViewBtn").on("click",function(){
	   location.href="/jnj/menu/sponsor/view?petNo="+$adopt.petNo;
   });
});
</script>
</head>
<body>

<form id="frm"></form>


<div id="titleTotal">
   <a href="#" class="btn btn-block" id="goAdoptListBtn">닫기</a>
</div>

<br>
<br>
<br>
<div class="container" id="situation">
    <div class="row smpl-step" style="border-bottom: 0; min-width: 100px;">
        <div class="col-xs-3 smpl-step-step complete">
            <div class="progress" id="situationProgress">
                <div class="progress-bar" id="petSortsituationProgress" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100"></div>
               <!-- 40%: 신청, 70%: 진행, 100%: 완료 -->
            </div>
            <a class="smpl-step-icon">대기</a>
        </div>

        <div class="col-xs-3 smpl-step-step complete">           
            <a class="smpl-step-icon">접수</a>
        </div>
        <div class="col-xs-3 smpl-step-step active">          
            <a class="smpl-step-icon">진행</a>
        </div>
        <div class="col-xs-3 smpl-step-step disabled">           
            <a class="smpl-step-icon">입양</a>
        </div>
    </div>
</div>

<br>
<br>
<hr/>

<div id="adoptBtns">
	<button class="btn btn-block" id="applyAdoptBtn" value="0" disabled>입양신청</button><br><br><br><br><br><br>
	<button class="btn btn-block" id="goSponsorViewBtn" disabled>후원하기</button>
</div>

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
  <table class="table" id="petList">
  
      <tr>
        <th id="contentTh">이름</th>
        <td class="contentTd" id="petName"></td>
      </tr>
      <tr>
        <th id="contentTh">분류</th>
        <td class="contentTd" id="petSort"></td>
      </tr>
      <tr>
        <th id="contentTh">종류</th>
        <td class="contentTd" id="petKind"></td>
      </tr>
      <tr>
        <th id="contentTh">성별</th>
        <td class="contentTd" id="petGender"></td>
      </tr>
      <tr>
        <th id="contentTh">나이</th>
        <td class="contentTd" id="petAge"></td>
      </tr>
      <tr>
        <th id="contentTh">무게</th>
        <td class="contentTd" id="petWeight"></td>
      </tr>
      <tr>
        <th id="contentTh">병력</th>
        <td class="contentTd" id="petDisease"></td>
      </tr>
      <tr>
        <th id="contentTh">안락사 예정일</th>
        <td class="contentTd" id="petMercyDate"></td>
      </tr>
      <tr>
        <th id="contentTh">특징</th>
        <td class="contentTd" id="petFeature"></td>
      </tr>
      
      
      <tr>
        <th id="contentTh">센터명</th>
        <td class="contentTd" id="centerName"></td>
      </tr>
      <tr>
        <th id="contentTh">주소</th>
        <td class="contentTd" id="centerAddr"></td>
      </tr>
      <tr>
        <th id="contentTh">전화번호</th>
        <td class="contentTd" id="centerTel"></td>
      </tr>
      <tr>
        <th id="contentTh">이메일</th>
        <td class="contentTd" id="centerEmail"></td>
      </tr>

  </table>
</div>


</div>

<hr/>

</body>
</html>