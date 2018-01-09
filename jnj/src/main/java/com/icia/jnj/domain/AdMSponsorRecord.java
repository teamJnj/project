package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMSponsorRecord {

	// 관리자 페이지에서 회원 후원 내역 볼 때 필요한 도메인
	
	private String 			memberId;
	private Integer 		petNo;
	private Integer 		sponsorNo;
	private Integer 		memberSponsorNo;
	private Integer 		payMoney;
	private Integer 		payWay;
	private String 			depositor;
	private String 			sponsorDate;
	private String 			sponsorReply;
	private String			petSort;
	private String 			centerName;
	private String 			centerId;
	private String			kind;
	private String 			petName;
	private String 			petState;
		
}
