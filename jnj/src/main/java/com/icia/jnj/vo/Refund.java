package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Refund {
	private Integer orderNo;
	private Integer goodsNo;
	private Integer optionNo;
	private Integer refundDivision;		// 1: 환불, 2: 교환
	private String applyDate;
	private String refundAccountNo;
	private String refundAccountBank;
	private String refundAccountHolder;
	private String refundReason;
}
