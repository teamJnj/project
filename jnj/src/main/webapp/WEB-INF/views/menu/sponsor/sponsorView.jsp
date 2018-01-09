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
</style>
<script>
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
};


$(function(){
   
   var $reply = ${reply};
   var $sponsorMap = ${sponsorMap};
   
   
   
   var $sponsor = $sponsorMap.sponsor;
   var $imgList = $sponsorMap.imgList;
   var $petNo = $sponsor.petNo;
   var $replyList = $reply.replyList;
   
   
   var $pagination = $reply.pagination;
   
   var $table = $("#sponsorReplyList");
   var $thead = $table.append('<thead></thead>')
   var $tbody = $table.append('<tbody></tbody>')
   
   $thead.append('<tr><th style="text-align: center;">후원금</th><th style="text-align: center;">내용</th><th style="text-align: center;">작성자</th><th style="text-align: center;">날짜</th></tr>');
   $.each($replyList, function(i, $reList){
      var $tr = $("<tr></tr>").appendTo($tbody);
      $("<td></td>").text($reList.payMoney).appendTo($tr);
      $("<td></td>").text($reList.sponsorReply).appendTo($tr);
      $("<td></td>").text($reList.memberId).appendTo($tr);
      $("<td></td>").text($reList.sponsorDate).appendTo($tr);
   });
   
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
   $("#petAge").text($sponsor.age+"세");
   $("#petWeight").text($sponsor.weight+"kg");
   
   if($sponsor.disease==null){
	   $("#petDisease").text("없음");
   }else{
	   $("#petDisease").text($sponsor.disease);
   }
   
   $("#petMercyDate").text($sponsor.mercyDate);
   $("#petFeature").text($sponsor.feature);
   $("#centerName").text($sponsor.centerName);
   $("#centerAddr").text($sponsor.centerAddr);
   $("#centerTel").text($sponsor.centerTel);
   $("#centerEmail").text($sponsor.centerEmail);
   
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
   
   
   $("#AllSponsorMoney").val(numberWithCommas($sponsor.sponsorMoney)+" 원");
   $("#AllSponsorMoneyPercent").val($sponsor.goalPercent+" %");
   $("#mercyDDay").val("안락사 예정일 D- "+$sponsor.mercyDDay+"일");
   
   $("#percentForProgress").css("width",$sponsor.goalPercent+"%");
   
   
   $("#sponsorMoney>button").on( "click", function () {
      
      var $frm=$("#frm");
      $frm.empty();
      
      var $payMoneyCheck = parseInt($(this).val());
        
        if(isNaN($payMoneyCheck)==true){
           if($("#inputSponsorMoney").val()==""){
				alert("금액 입력은 필수입니다.");
           } else{
        	   var $payMoney =  window.open("", "결제선택", "width=810, height=600");
               $frm.attr("target", "결제선택");
               $frm.attr("action", "/jnj/menu/sponsor/pay1");
               $frm.attr("method", "post");
               
               $("<input></input>").attr("type","hidden").attr("name","petNo").val($sponsor.petNo).appendTo($frm);
               $("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($sponsor.sponsorNo).appendTo($frm);
        	   $("<input type='hidden' name='payMoney' value="+$("#inputSponsorMoney").val()+"></input>").appendTo($frm);
        	   $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($frm);
               
               $frm.submit();
           }
        	
        } else if(isNaN($payMoneyCheck)==false){
	       	var $payMoney =  window.open("", "결제선택", "width=810, height=600");
            $frm.attr("target", "결제선택");
            $frm.attr("action", "/jnj/menu/sponsor/pay1");
            $frm.attr("method", "post");
            
            $("<input></input>").attr("type","hidden").attr("name","petNo").val($sponsor.petNo).appendTo($frm);
            $("<input></input>").attr("type","hidden").attr("name","sponsorNo").val($sponsor.sponsorNo).appendTo($frm);
            $("<input type='hidden' name='payMoney' value="+ $(this).val() +"></input>").appendTo($frm);
            $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' />").appendTo($frm);
           
            $frm.submit();
        }
        
     });
   
   
   var ul = $("#pagination");
   var li;
   if($pagination.prev>0) {
      li = $("<li></li>").text('이전으로').appendTo(ul);
      li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/view?petNo='+$petNo+'&pageno='+$pagination.prev))
   }
   for(var i=$pagination.startPage; i<=$pagination.endPage; i++) {
      li = $("<li></li>").text(i).appendTo(ul);
      if($pagination.pageno==i) 
         li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/view?petNo='+$petNo+'&pageno='+ i).css({"background-color":"#337ab7", "border" : "1px solid #337ab7", "color":"white"}));
      else
         li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/view?petNo='+$petNo+'&pageno='+ i))
   }
   if($pagination.next>0) {
      li = $("<li></li>").text('다음으로').appendTo(ul);
      li.wrapInner($("<a></a").attr('href', '/jnj/menu/sponsor/view?petNo='+$petNo+'&pageno='+ $pagination.next));
   }
});
</script>
</head>
<body>

<form id="frm"></form>

<div>
   <a href="/jnj/menu/sponsor/record?petSort=0" class="btn btn-block" id="goSponsorListBtn">목록</a>
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

<div id="getSponsorMoneyInfo">
      <p id="SponsorMoneyInfoMercyDate"><input type="text" id="mercyDDay" readonly="readonly"></p>
      <p><h2><input type="text" id="AllSponsorMoneyPercent" readonly="readonly"></h2></p>
         <div class="progress"  id="sponsorMoney">
            <div class="progress-bar progress-bar-striped active" id="percentForProgress" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100"></div>
         </div>
      <p><h3><input type="text" id="AllSponsorMoney" readonly="readonly"></h3></p>
   <br>

   <div id="sponsorMoney">
      <button class="btn btn-block" id="selectSponsorMoney" value="1000">1,000 원</button>
      <button class="btn btn-block" id="selectSponsorMoney" value="5000">5,000 원</button>
      <button class="btn btn-block" id="selectSponsorMoney" value="10000">10,000 원</button>
      <button class="btn btn-block" id="selectSponsorMoney" value="15000">15,000 원</button>
      <button class="btn btn-block" id="selectSponsorMoney" value="20000">20,000 원</button>
      <button class="btn btn-block" id="selectSponsorMoney" value="25000">25,000 원</button>
      <button class="btn btn-block" id="selectSponsorMoney" value="30000">30,000 원</button>
      <button class="btn" id="selectSponsorMoneyElse">추가 후원</button>
      <input type="text" id="inputSponsorMoney" placeholder="금액을 입력하세요" style="margin-top: 25px;"></input>
   </div>
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

<div class="container">
   <table class="table" id="sponsorReplyList">
            <!-- 
            <tr>
               <th style="text-align: center;">후원금</th>
               <th style="text-align: center;">내용</th>
               <th style="text-align: center;">작성자</th>
               <th style="text-align: center;">날짜</th>
            </tr>
            
            <tr>
               <td>1000</td>
               <td><a href="#">후원합니다</a></td>
               <td>***</td>
               <td>2017-11-18</td>
            </tr>
             -->
   </table>
</div>      



   <div class="container">
      <ul class="pager" id="pagination">
      </ul>
   </div>
   
</body>
</html>