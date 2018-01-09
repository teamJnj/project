package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MarketApply {
	private Integer marketNo;
	private String memberId;
	private String applyTel;
	private String tel1;
	private String tel2;
	private String applyDate;
	private Integer boothNum;
	private Integer payMoney;
	private Integer payWay;	// 1: 카드, 2: 무통장
	private String depositor;
	private Integer marketApplyState;	// 0:취소(거절), 1:신청완료, 2:완료, 3:인원미달

	private String 	marketTitle;
	private String	marketDate;
}
