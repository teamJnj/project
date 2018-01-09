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

#goSponsorListBtn{
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





#getSponsorMoneyInfo{
   float: right;
   text-align: right;
   margin-right: 50px;
   border-left: 1px solid #7F5926;
   padding-left: 20px;
   padding-bottom: 20px;
   
}
#sponsorMoney{
   float: right;
   width: 350px;
   height: 10px;
}
#SponsorMoneyInfoMercyDate{
   font-size: 20px;
   color: blue;
   font-weight: bold;
}
#selectSponsorMoney{
   width: 350px;
   margin-top: 25px;
   background-color: #FFB24C;
}


button#selectSponsorMoneyElse.btn{
   float: left;
   width: 150px;
   margin-top: 25px;
   margin-right: 0px;
   background-color: #FFB24C;
}


#inputSponsorMoney{
   float: left;
   width: 200px;
   height: 34px;
}

#AllSponsorMoney, #AllSponsorMoneyPercent, #mercyDDay{
   border: 1px solid #fff;
   text-align: right;
}

#sponsorReplyList{
   text-align: center;
}


#myCarouselContainer{
   overflow: hidden;
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

#info{
margin-left:300px;
}
</style>
<script>

$(function(){
   
   var $reply = ${reply};
   var $sponsorMap = ${sponsorMap};
   
   var $sponsor = $sponsorMap.sponsor;
   var $imgList = $sponsorMap.imgList;
   var $petNo = $sponsor.petNo;
   
   //var $replyList = $reply.replyList;
   
   //var $pagination = $reply.pagination;
   
  // var $table = $("#sponsorReplyList");
  //var $thead = $table.append('<thead></thead>')
   //var $tbody = $table.append('<tbody></tbody>')
   
   //$thead.append('<tr><th style="text-align: center;">후원금</th><th style="text-align: center;">내용</th><th style="text-align: center;">작성자</th><th style="text-align: center;">날짜</th></tr>');
   /* $.each($replyList, function(i, $reList){
      var $tr = $("<tr></tr>").appendTo($tbody);
      $("<td></td>").text($reList.payMoney).appendTo($tr);
      $("<td></td>").text($reList.sponsorReply).appendTo($tr);
      $("<td></td>").text($reList.memberId).appendTo($tr);
      $("<td></td>").text($reList.sponsorDate).appendTo($tr);
   }); */
   
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
   $("#petName").text($sponsor.petName);
   	var petSort = "강아지";
	if($sponsor.petSort==2) petSort="고양이";
	else if($sponsor.petSort==3) petSort="기타";
   $("#petSort").text(petSort);
   $("#petKind").text($sponsor.kind);
   	var gender = "남자";
	if($sponsor.gender==2) gender="여자";
   $("#petGender").text(gender);
   $("#petAge").text($sponsor.age);
   $("#petWeight").text($sponsor.weight+"kg");
   $("#petDisease").text($sponsor.disease);
   $("#petMercyDate").text($sponsor.mercyDate);
   $("#petFeature").text($sponsor.feature);
   $("#centerName").text($sponsor.centerName);
   $("#centerAddr").text($sponsor.centerAddr);
   $("#centerTel").text($sponsor.centerTel);
   $("#centerEmail").text($sponsor.centerEmail);
   
   if($sponsor.petSort==1){
	   $("#petSortsituationProgress").css("width","0%");
   } else if($sponsor.petSort==2){
	   $("#petSortsituationProgress").css("width","40%");
   } else if($sponsor.petSort==3){
	   $("#petSortsituationProgress").css("width","70%");
   } else if($sponsor.petSort==4){
	   $("#petSortsituationProgress").css("width","100%");
   } else if($sponsor.petSort==5){
	   $("#petSortsituationProgress").css("width","100%").css("background-color","black");
   }
   
   $("#AllSponsorMoney").val($sponsor.sponsorMoney+" 원");
   $("#AllSponsorMoneyPercent").val($sponsor.goalPercent+" %");
   $("#mercyDDay").val("안락사 예정일 D- "+$sponsor.mercyDDay+"일");
   
   $("#percentForProgress").css("width",$sponsor.goalPercent+"%");

   var idx =0 ;
   setInterval(function(){
	   idx+=1;
	   if( idx%2 == 0 )
	   		$("#goSponsorListBtn").css("background-color", "#FFB24C");
	   else 
			$("#goSponsorListBtn").css("background-color", "#FF9100");
	}, 2000);

   
   $("#goSponsorListBtn").on( "click", function () {
		self.close();	   
   });
   
 
});
</script>
</head>
<body>

<form id="frm"></form>

<div id="titleTotal">
   <a href="#" class="btn btn-block" id="goSponsorListBtn">닫기</a>
</div>

<br>
<br>
<hr>
<br>
<br>

<div id="info">

<div class="container" id="myCarouselContainer">
  <div id="myCarousel" class="carousel slide" data-ride="carousel">
    <!-- Indicators -->
    <ol id="imgOl" class="carousel-indicators">
    </ol>

    <!-- Wrapper for slides -->
    <div id="imgDiv" class="carousel-inner">
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

   
</body>
</html>