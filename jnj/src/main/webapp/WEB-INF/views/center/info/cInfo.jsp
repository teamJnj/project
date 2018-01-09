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

.contentTd{
   border-left: 1px solid #7F5926;
   border-bottom: 1px solid #fff;
   border-top: 1px solid #fff;
   width: 400px;
   padding-left: 40px;
   padding-top: 20px;
   padding-bottom: 25px;
   font-size: 16px;
}

#contentTh{
   text-align: right;
   font-size: 18px;
   padding-right: 40px;
   padding-top: 20px;
   padding-bottom: 25px;
   width: 200px;
   border-bottom: 1px solid #fff;
   border-top: 1px solid #fff;
}

#goSponsorListBtn {
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
.btn {
	 width: 100px;
	 height:40px;
	 background-color: #0080FF;
   	color: #fff;
}
</style>
<script>

$(function(){
   var $center = ${center};
   
   $("#centerId").text($center.centerId);
   $("#centerName").text($center.centerName);
   $("#centerTel").text($center.centerTel);
   $("#centerAddr").text($center.centerAddr);
   $("#email").text($center.email);
   $("#homepage").text($center.homepage);
   $("#licensee").text($center.licensee);
   $("#licenseNo").text($center.licenseNo);
   $("#sponsorAccountNo").text($center.sponsorAccountNo);
   $("#sponsorAccountBank").text($center.sponsorAccountBank);
   $("#sponsorAccountHolder").text($center.sponsorAccountHolder);

   $("#update").on("click", function() {
		location.href = "/jnj/center/info/update";
	});
});
</script>
</head>
<body>
<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info" style="color: navy; font-weight: 700; font-size: 20px;">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign">회원탈퇴</a></h4>
	<hr>
<h3 style="margin-left: 60px; margin-top:40px; color: #7F5926;">센터 정보</h3>
<div style="margin-left: 200px; margin-top: 40px; display: inline-block;">
  <table>
      <tr>
        <th id="contentTh">아이디</th>
        <td class="contentTd" id="centerId" name="centerId"></td>
      </tr>
      <tr>
        <th id="contentTh">센터명</th>
        <td class="contentTd" id="centerName" name="centerName"></td>
      </tr>
      <tr>
        <th id="contentTh">전화번호</th>
        <td class="contentTd" id="centerTel" name="centerTel"></td>
      </tr>
      <tr>
        <th id="contentTh">주소</th>
        <td class="contentTd" id="centerAddr" name="centerAddr"></td>
      </tr>
      <tr>
        <th id="contentTh">이메일</th>
        <td class="contentTd" id="email" name="email"></td>
      </tr>
      <tr>
        <th id="contentTh">홈페이지</th>
        <td class="contentTd" id="homepage" name="homepage"></td>
      </tr>
      <tr>
        <th id="contentTh">대표자</th>
        <td class="contentTd" id="licensee" name="licensee"></td>
      </tr>
      <tr>
        <th id="contentTh">사업자 등록번호</th>
        <td class="contentTd" id="licenseNo" name="licenseNo"></td>
      </tr>
      <tr>
        <th id="contentTh">후원금 계좌</th>
        <td class="contentTd"><span id="sponsorAccountNo"></span>[<span id="sponsorAccountBank"></span>, <span id="sponsorAccountHolder"></span>]</td>
      </tr>
  </table>
</div>
<div class="form-group" style="float:right; margin-right: 350px; margin-top: 620px;">
	<button id="update" type="submit" class="btn btn-default">정보수정</button> 
	<!-- <button id="updateImg" type="submit" class="btn btn-default">사진수정</button> -->
</div>


	<br><br><br><br>
</body>
</html>