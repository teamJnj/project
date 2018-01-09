<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>

/* 상태바 스타일 */
#situation{
   width: 800px;
   margin-left: 210px;
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
    margin-top: 40px;
    margin-left: 100px;
    width: 630px;
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
   width: 500px;
   padding-left: 10px;
   padding-bottom: 11px;
}

#contentTh{
   text-align: left;
   padding: 8px 20px 20px 0px;
   width: 110px;
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
   width: 350px;
   height: 10px;
   display: inline-block;
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
   display: inline-block;
   float: none;
   margin-left: 330px;
   margin-right: 250px;
}
.carousel-inner > .item > img {
      top: 0;
      left: 0;
      min-width: 600px;
      min-height: 400px;
    } 
#myCarousel{
	width: 600px;
   height: 400px;
}
</style>
<script>

$(function(){
   var $sponsorMap = ${sponsorMap};
   
   var $sponsor = $sponsorMap.sponsor;
   var $imgList = $sponsorMap.imgList;
   
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
   
   $("#update").on("click", function() {
		location.href = "/jnj/center/pet/update?petNo="+$sponsor.petNo;
	});
/*   $("#delete").on("click", function() {
		location.href = "/jnj/center/pet/delete";
	});*/
   
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
   
   if($sponsor.petState==1){
	   $("#petSortsituationProgress").css("width","0%");
   } else if($sponsor.petState==2){
	   $("#petSortsituationProgress").css("width","40%");
   } else if($sponsor.petState==3){
	   $("#petSortsituationProgress").css("width","70%");
   } else if($sponsor.petState==4){
	   $("#petSortsituationProgress").css("width","100%");
   } else if($sponsor.petState==5){
	   $("#petSortsituationProgress").css("width","100%").css("background-color","black");
   }
   
   $("#AllSponsorMoney").val($sponsor.sponsorMoney+" 원");
   $("#AllSponsorMoneyPercent").val($sponsor.goalPercent+" %");
   $("#mercyDDay").val("안락사 예정일 D- "+$sponsor.mercyDDay+"일");
   
   $("#percentForProgress").css("width",$sponsor.goalPercent+"%");
});
</script>
</head>
<body>
<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet" style="color: navy; font-weight: 700; font-size: 20px;">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign">회원탈퇴</a></h4>
	<hr>

<div>
   <a href="/jnj/center/pet/record" class="btn btn-block" id="goSponsorListBtn">목록</a>
</div>

<br>
<br>
<br>
<div id="situation">
    <div class="row smpl-step" style="border-bottom: 0; min-width: 100px;">
        <div class="col-xs-3 smpl-step-step complete">
            <div class="progress" id="situationProgress">
                <div class="progress-bar" id="petSortsituationProgress" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100" style="width: 70%;" data-toggle="tooltip" data-placement="top"></div>
               <!-- 40%: 신청, 70%: 진행, 100%: 완료 -->
            </div>
            <a class="smpl-step-icon">대기</a>
        </div>

        <div class="col-xs-3 smpl-step-step complete">           
            <a class="smpl-step-icon">신청</a>
        </div>
        <div class="col-xs-3 smpl-step-step active">          
            <a class="smpl-step-icon">진행</a>
        </div>
        <div class="col-xs-3 smpl-step-step disabled">           
            <a class="smpl-step-icon">완료</a>
        </div>
    </div>
</div>

<br>
<br>
<!-- 
      <span id="SponsorMoneyInfoMercyDate"><input type="text" id="mercyDDay" readonly="readonly"></span>
         <div class="progress" id="sponsorMoney">
            <div class="progress-bar" id="percentForProgress" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100" data-toggle="tooltip" data-placement="top">
            	<span class='progress-type' id="AllSponsorMoneyPercent"></span>
            </div>
         </div>
         <span><input type="text" id="AllSponsorMoney" readonly="readonly"></span>

 -->

<!-- <img src="이미지경로" width="300" height="250"> -->
<br>
<div id="myCarouselContainer">
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
<br>
<div style="margin-left: 320px;">
  <table  id="petList">
  
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
        <td class="contentTd" id="petDisease" width="300px"></td>
      </tr>
      <tr>
        <th id="contentTh">안락사 예정일</th>
        <td class="contentTd" id="petMercyDate"></td>
      </tr>
      <tr>
        <th id="contentTh">특징</th>
        <td class="contentTd" id="petFeature"></td>
      </tr>

  </table>
</div>
<div class="form-group" style="float:right; margin-right: 330px;">
	<button id="update" type="submit" class="btn btn-default">정보수정</button> 
<<<<<<< .mine
	<!-- <button id="updateImg" type="submit" class="btn btn-default">사진수정</button>  -->
||||||| .r541
=======
	<!-- <button id="updateImg" type="submit" class="btn btn-default">사진수정</button> -->
>>>>>>> .r553
	<!-- <button id="delete" type="submit" class="btn btn-default">삭제</button> -->
	</div>

	<br><br><br><br>
</body>
</html>