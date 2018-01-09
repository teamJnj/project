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
   margin-right: 150px;
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
var $isFail = ${isFail};

console.log($isFail);
if($isFail==1) {
	console.log($isFail);
	alert("비밀번호가 올바르지 않습니다.");
}
	
</script>
</head>
<body>
<h4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/info">센터정보</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/pet">동물관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/adopt">입양관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/sponsor">후원관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/volunteer">봉사관리</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/common/cQna">1:1문의</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="/jnj/center/resign" style="color: navy; font-weight: 700; font-size: 20px;">회원탈퇴</a></h4>
	<hr>
<h3 style="margin-left: 60px; margin-top:40px; color: #7F5926;">센터 탈퇴하기</h3>
<form action="/jnj/center/resign" method="post">
<div style="margin-left: 200px; margin-top: 40px; display: inline-block;">
  <table>
      <tr>
        <th id="contentTh">비밀번호</th>
        <td class="contentTd"><input type="password" id="password" name="password"></td>
      </tr>
  </table>
</div>
<div class="form-group" style="float:right; margin-right: 380px; margin-top: 55px;">
	<input type="hidden" name="_csrf" value="${_csrf.token}">
	<input type="submit" id="resign" class="btn btn-default" value="탈퇴하기"> 
</div>
</form>
	<br><br><br><br>
</body>
</html>