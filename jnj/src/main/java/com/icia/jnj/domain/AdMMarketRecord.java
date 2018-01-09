package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMMarketRecord {
	
	// 관리자 페이지에서 회원 프리마켓 내역 볼 때 필요한 도메인
	
	private String 			memberId;

	private Integer 		marketNo;
	private String 			marketTitle;
	private String			marketDate;
	
	private Integer 		boothNum;
	private Integer 		payMoney;
	private String 			applyDate;
	private String 			marketApplyState;
	
}
