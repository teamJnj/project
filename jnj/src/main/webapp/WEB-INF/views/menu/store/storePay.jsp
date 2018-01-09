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
.payview img {
	height: 150px;
	width: 150px;
}
</style>
<script>
//���� , ���
function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

$(function() {
	var map = ${map};
	console.log(map);

	var tbody = $(".payview tbody");
	
	$.each(map, function(idx, pay) {
		var tr = $("<tr></tr>").attr("class", "list").appendTo(tbody);
		var img = $("<td></td>").appendTo(tr);
		var imga = $("<a></a>").attr("href", "/jnj/menu/store/view?goodsNo="+pay.goods.GOODSNO).appendTo(img);
		$("<img>").attr("src", "/jnjimg/goods/"+pay.goodsImg).attr("alt", pay.goods.GOODSNO).appendTo(imga);
		var goods = $("<td></td>").appendTo(tr);
		$("<span></span>").text("��ǰ��ȣ ").appendTo(goods);
		$("<span></span>").text(pay.goods.GOODSNO).appendTo(goods);
		$("<br>").appendTo(goods);
		$("<span></span>").text("��ǰ�� ").appendTo(goods);
		$("<span></span>").text(pay.goods.GOODSNAME).appendTo(goods);
		$("<br>").appendTo(goods);
		$("<span></span>").text("�ɼ� ").appendTo(goods);
		$("<span></span>").text(pay.goodsOption.OPTIONCONTENT).appendTo(goods);
		$("<td></td>").text(pay.orderQnt+"��").appendTo(tr);
		$("<td></td>").text(numberWithCommas(pay.orderQnt*pay.goods.GOODSPRICE)+"��").appendTo(tr);
	})
	var total = $("<tr></tr>").attr("id", "totalprice").appendTo(tbody);
	$("<td></td>").attr("colspan", 3).appendTo(total);
	
	var payMoney = 0;
	var money = 0;
	var qnt = 0;
	var price = 0;
	$("tr[class=list]").each(function(i){
		qnt = map[i].orderQnt
		price = map[i].goods.GOODSPRICE;
		payMoney = payMoney+(qnt*price);
	})
	var totaltd = $("<td></td>").attr("colspan", 2).appendTo(total);
	$("<span></span>").text("�� �հ� ").appendTo(totaltd);
	$("<span></span>").text(numberWithCommas(payMoney) + "��").appendTo(totaltd);
	
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
	
	/* 
	<label class='control-label col-sm-4' for='title'>�Ա��ڸ�</label>
	<div class='col-sm-5'>
		<input type='text' class='form-control' id='depositor' name='depositor' placeholder='�Ա��ڸ�'>
	</div> */

	
	var orderbtn = $(".orderbtn");
	var check = false;
	$("#order").on("click", function() {
		
		$("input").each(function(idx){
			console.log(check)
			if($(this).val()=="") {
				alert($(this).attr("placeholder")+"��(��) �Է��Ͻÿ�");
				console.log(check)
				check = true;
				console.log(check)
				return false;
			} 
		})
		if(check) { 
			check = false;
			return false;
		}
		
		else {
		
			if($("#checkbox1").prop("checked") && $("#checkbox2").prop("checked")) {
				$("tr[class=list]").each(function(idx){
					$("<input type='hidden' name='goodsNo' value='"+map[idx].goods.GOODSNO+"'>").appendTo(orderbtn);
					$("<input type='hidden' name='optionNo' value='"+map[idx].goodsOption.OPTIONNO+"'>").appendTo(orderbtn);
					$("<input type='hidden' name='orderQnt' value='"+map[idx].orderQnt+"'>").appendTo(orderbtn);
					$("<input type='hidden' name='money' value='"+map[idx].orderQnt*map[idx].goods.GOODSPRICE+"'>").appendTo(orderbtn);
					if(parseInt($("#payWay option:selected").val())==2) {
						$("<input type='hidden' name='orderRecordState' value='1'>").appendTo(orderbtn);
					} else if(parseInt($("#payWay option:selected").val())==1) {
						$("<input type='hidden' name='orderRecordState' value='2'>").appendTo(orderbtn);
					}	
				})
				
				if(parseInt($("#payWay option:selected").val())==2) {
					$("<input type='hidden' name='orderState' value='1'>").appendTo(orderbtn);
				} else if(parseInt($("#payWay option:selected").val())==1) {
					$("<input type='hidden' name='orderState' value='2'>").appendTo(orderbtn);
				}	
				$("<input type='hidden' name='payWay' value='"+$("#payWay option:selected").val()+"'>").appendTo(orderbtn);				
				$("<input type='hidden' name='payMoney' value='"+payMoney+"'>").appendTo(orderbtn);				
				$("<input type='hidden' name='orderTel' value='"+$("#tel1 option:selected").val()+$("#tel2").val()+"'>").appendTo(orderbtn);
				$("<input type='hidden' name='recipientAddr' value='("+$("#addr1").val()+")"+$("#addr2").val()+", "+$("#addr3").val()+"'>").appendTo(orderbtn);
				$("<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' >").appendTo(orderbtn);
				$("#order").attr("type", "submit");
				
			} else {
				alert("���� üũ�Ͻÿ�");
			}	
		}
		check = false;
	})
	
	
	$("#zipcode").on("click", function() {
		  sample6_execDaumPostcode();
	})
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
		<table class="table payview">
			<colgroup width="30%" />
			<colgroup width="30%" />
			<colgroup width="20%" />
			<colgroup width="20%" />
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
		<form class="form-horizontal" method="post" action="/jnj/menu/store/order" id="form">
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