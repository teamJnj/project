package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Orders {
	private Integer orderNo;
	private String orderId;
	private String orderTel;
	private String recipient;
	private String recipientAddr;
	private String memo;
	private Integer payMoney;
	private Integer payWay;		// 1:카드, 2:무통장입금
	private String depositor;	
	private String orderDate;
	private Integer orderState;	// 1:주문완료, 2:입금완료, 3:배송준비중, 4:배송중, 5:배송완료
}
