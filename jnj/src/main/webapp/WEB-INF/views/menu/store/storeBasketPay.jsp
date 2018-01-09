<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<style>
.storePay {
	margin-top: 100px;
}

.storePay h3 {
	color: #7F5926;
}

#order {
	margin-left: 380px;
	background-color: #FFB24C;
	color: #7F5926;
}

.storePay #zipcode {
	background-color: #7F5926;
	color: #FFB24C;
}

.storePay button:hover {
	background-color: #7F5926;
	color: #FFB24C;
}

.storePay thead {
	text-align: center;
	background-color: #FFB24C;
}
</style>
<script>
$(function() {
	//storeBasket���� ������ ������ �̰��� �Ѹ���
	var $basketList = ${cBasketList};
	
	var $productList = $basketList.productList;
	
	console.log($productList);
	var $table =$("table");
	 
	 var $AllTotal = 0;
	
	 $.each($productList,function(idx,product){
		 console.log("fire:" + $productList);
			var $tr = $("<tr></tr>").attr("class", "list").appendTo($table);
			var $imgTd = $("<td></td>").appendTo($tr);//�̹���
			var $infoTd = $("<td></td>").appendTo($tr);//��ǰ����
			var $qntTd = $("<td></td>").appendTo($tr);//����
			var $prTd = $("<td></td>").appendTo($tr);//����
			
			var $imgDiv = $("<div></div>").appendTo($imgTd).css("flaot","right");//������ ������..? �ٽ� Ȯ���ϱ�
			
			$("<img style=\"width:150px; height:150px;\"></img>").attr("src", "/jnjimg/goods/"+product.goodsImg).appendTo($imgDiv);
			var $spanNum =$("<span></span><br>").text('��ǰ��ȣ').appendTo($infoTd).css("text-align","center");
			var $spanName =$("<span></span><br>").text('��ǰ��').appendTo($infoTd).css("text-align","center");
			var $spanOption =$("<span></span>").text('�ɼ�').appendTo($infoTd).css("text-align","center");
			
			var $span1 = $("<span></span>").text(product.goodsNo).appendTo($spanNum);
			var $span2 = $("<span></span>").text(product.goodsName).appendTo($spanName);
			var $span3 = $("<span></span>").text(product.optionContent).appendTo($spanOption);
			

		 	var $spanQnt =$("<span></span><br>").text(product.qnt).appendTo($qntTd);
		 	$("<span></span>").text('��').appendTo($spanQnt);
		 	
		 	var $qnt = parseInt(product.qnt);
		 	
		 	console.log($qnt);
		 	
		 	var $price = parseInt(product.goodsPrice);
		 	
		 	console.log($price);
		 	
		 	var $oneTotal = $qnt*$price;
		 	
		 	var $spanPrice =$("<span></span><br>").text(numberWithCommas($oneTotal)).attr("id","oneTotal").appendTo($prTd);
		 	$("<span></span>").text('��').appendTo($spanPrice);
		 	
		 	$AllTotal += $oneTotal;
		
	})
	
		 	console.log($AllTotal);
		 	
		 	var $AllTotalTr = $("<tr></tr>").appendTo($table);
		 	var $td5 = $("<td colspan='3'></td>").appendTo($AllTotalTr);
		 	var $td6 = $("<td colspan='1'></td>").appendTo($AllTotalTr);
		 	var $spanTopTop =$("<span></span><br>").text('�� �հ�').appendTo($td6).css("text-align","center");
		 	var $spanSubSub = $("<br><span></span>").text(numberWithCommas($AllTotal)+" ").appendTo($spanTopTop);
		 	var $spanSubSub2 = $("<span></span>").text('��').appendTo($spanTopTop);
	//���� ������
   var orderbtn = $(".orderbtn");
   $("#order").on("click", function() {
	   var $basketList = ${cBasketList};
	   var $productList = $basketList.productList;
	   var idx =0;
	  	$("input").each(function(idx){
			if($(this).val()=="") {
				alert($(this).attr("placeholder")+"��(��) �Է��Ͻÿ�");
				return false;
			} 
		}) 
      if($("#checkbox1").prop("checked") && $("#checkbox2").prop("checked")) {
    	  console.log($productList);
    	  $("tr[class=list]").each(function(idx){
    		  console.log($productList[idx].goodsNo);
          	  console.log($productList[idx].optionNo);
    		  $("<input type='hidden' name='goodsNo' value='"+$productList[idx].goodsNo+"'>").appendTo(orderbtn);
            $("<input type='hidden' name='optionNo' value='"+$productList[idx].optionNo+"'>").appendTo(orderbtn);
            $("<input type='hidden' name='orderQnt' value='"+$productList[idx].qnt+"'>").appendTo(orderbtn);
            $("<input type='hidden' name='money' value='"+$productList[idx].qnt*$productList[idx].goodsPrice+"'>").appendTo(orderbtn);
              if(parseInt($("#payWay option:selected").val())==2) {
               $("<input type='hidden' name='orderRecordState' value='1'>").appendTo(orderbtn);
            } else if(parseInt($("#payWay option:selected").val())==1) {
               $("<input type='hidden' name='orderRecordState' value='2'>").appendTo(orderbtn);
            }
   			idx++
         })
    	  
         console.log($("#payWay option:selected").val());
         
         if(parseInt($("#payWay option:selected").val())==2) {
            $("<input type='hidden' name='orderState' value='1'>").appendTo(orderbtn);
         } else if(parseInt($("#payWay option:selected").val())==1) {
            $("<input type='hidden' name='orderState' value='2'>").appendTo(orderbtn);
         }   
         $("<input type='hidden' name='payWay' value='"+$("#payWay option:selected").val()+"'>").appendTo(orderbtn);            
         $("<input type='hidden' name='payMoney' value='"+$AllTotal+"'>").appendTo(orderbtn);            
         $("<input type='hidden' name='orderTel' value='"+$("#tel1 option:selected").val()+$("#tel2").val()+"'>").appendTo(orderbtn);
         $("<input type='hidden' name='recipientAddr' value='("+$("#addr1").val()+")"+$("#addr2").val()+", "+$("#addr3").val()+"'>").appendTo(orderbtn);
         $("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo(orderbtn);
         $("#order").attr("type", "submit");
      } else {
         alert("���� üũ�Ͻÿ�");
      }   
    
      
   })
   	
	$("#payWay").change(function() {
		var $payWay = $("#payWay option:selected").attr("value");
		if($payWay==2) {
			$("<label class='control-label col-sm-4' for='title'>�Ա��ڸ�</label>").appendTo("#deposit");
			var depo = $("<div class='col-sm-5'></div>").appendTo("#deposit");
			$("<input type='text' class='form-control' id='depositor' name='depositor' placeholder='�Ա��ڸ�'>").appendTo(depo);
		} else if($payWay==1) {
			$("#deposit").empty();
		}
	})
	
	$("#zipcode").on("click", function() {
		  sample6_execDaumPostcode();
	})
	
	 //���� �޸��ֱ�
	function numberWithCommas(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
})


// �ּ� api
function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.

                // �� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
                // �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
                var fullAddr = ''; // ���� �ּ� ����
                var extraAddr = ''; // ������ �ּ� ����

                // ����ڰ� ������ �ּ� Ÿ�Կ� ���� �ش� �ּ� ���� �����´�.
                if (data.userSelectedType === 'R') { // ����ڰ� ���θ� �ּҸ� �������� ���
                    fullAddr = data.roadAddress;

                } else { // ����ڰ� ���� �ּҸ� �������� ���(J)
                    fullAddr = data.jibunAddress;
                }

                // ����ڰ� ������ �ּҰ� ���θ� Ÿ���϶� �����Ѵ�.
                if(data.userSelectedType === 'R'){
                    //���������� ���� ��� �߰��Ѵ�.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // �ǹ����� ���� ��� �߰��Ѵ�.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // �������ּ��� ������ ���� ���ʿ� ��ȣ�� �߰��Ͽ� ���� �ּҸ� �����.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // �����ȣ�� �ּ� ������ �ش� �ʵ忡 �ִ´�.
                document.getElementById('addr1').value = data.zonecode; //5�ڸ� �������ȣ ���
                document.getElementById('addr2').value = fullAddr;

                // Ŀ���� ���ּ� �ʵ�� �̵��Ѵ�.
                document.getElementById('addr3').focus();
            }
        }).open();
    }
    
  
</script>
</head>
<body>
	<div class="container storePay">
		<h3>�ֹ��ϱ�</h3>
		<hr />
		<br>
		<table class="table storeBasketPayTable">
			<colgroup width="30%" />
			<colgroup width="30%" />
			<colgroup width="30%" />
			<colgroup width="10%" />
			<thead>
				<tr>
					<th></th>
					<th>��ǰ����</th>
					<th>����</th>
					<th>�ֹ��ݾ�</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<br> <br>
		<hr />
		<h2>�������</h2>
		<form class="form-horizontal" method="post" action="/jnj/menu/store/order" enctype="multipart/form-data">
			<div class="form-group ">
				<label class="control-label col-sm-4" for="text">������</label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="recipient" name="recipient" placeholder="������">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">����ó</label>
				<div class="form-group">
					<div class="col-md-2">
						<select id="tel1" class="form-control">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="017">017</option>
						</select>
					</div>
					<div class="col-sm-3 row">
						<input type="text" class="form-control" id="tel2" placeholder="��ȭ��ȣ">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">�����ȣ</label>
				<div class="col-sm-2">
					<input type="text" class="form-control" id="addr1" placeholder="�ּ�">
				</div>
				<button type="button" id="zipcode">�����ȣ</button>
				<br>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="title"></label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="addr2" placeholder="�ּ�">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="title"></label>
				<div class="col-sm-5">
					<input type="text" class="form-control" id="addr3" placeholder="�������ּ�">
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">��۸޸�</label>
				<div class="form-group">
					<div class="col-sm-5">
						<input type="text" class="form-control" id="memo" name="memo" placeholder="��۸޸�">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="control-label col-sm-4" for="text">�������</label>
				<div class="form-group">
					<div class="col-md-5">
						<select id="payWay" name="payWay" class="form-control">
							<option value="1">�ſ�ī��</option>
							<option value="2">�������Ա�</option>
						</select>
					</div>
				</div>
			</div>
			<div class="form-group" id="deposit">
			</div>
			<div class="form-group">
				<div class="checkbox">
					<label class="control-label col-sm-4" for="text"></label>
					<label>
						<input type="checkbox" id="checkbox1">���θ� ���� ��� ����
					</label>
						<br> 
					<label class="control-label col-sm-4" for="text">
					</label> 
					<label>
						<input type="checkbox" id="checkbox2">
						�� ��ǰ�� �������� Ȯ�� �� �������� ����
					</label>
				</div>
			</div>
			<br> <br> <br>
			<div class="form-group orderbtn">
				<div class="col-sm-offset-2 col-sm-10">
					<button id="order" type="button" class="btn btn-default">�����ϱ�</button>
				</div>
				
			</div>
			<br><br>
		</form>
	</div>
</body>
</html>