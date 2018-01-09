package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrdersRecord {
	private Integer orderNo;
	private Integer goodsNo;
	private Integer optionNo;
	private Integer orderQnt;
	private Integer money;
	private Integer orderRecordState;	// 1:주문완료, 2:입금완료, 3: 배송준비중, 4: 배송중, 5: 배송완료, 6:교환-환불접수, 7:교환-환불중, 8:교환-환불완료
}
