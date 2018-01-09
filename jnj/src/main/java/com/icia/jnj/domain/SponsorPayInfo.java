package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SponsorPayInfo {
	
	private String 		memberId;	//		// 후원자 아이디
	private Integer 	petNo;		//		// 후원하는 동물 번호
	private Integer 	petState;		//		// 후원하는 동물 번호
	private Integer 	sponsorNo;			// 후원하는 동물 후원 번호
	private String 		mercyDate;	//		// 동물 안락사 날짜
	
	private Integer		memberSponsorNo;//	// 사용자가 현재 후원하려는 동물에 몇번째 후원인지?
	
	private Integer		payMoney;			// 후원한 금액
	private Integer		goalMoney;	//		// 목표 금액
	private Integer		sponsorMoney;	//	// 유기동물이 받은 총 후원 금액
	
	private Integer 	payWay;				// 사용자가 사용한 결제방법
	private String		depositor;			// 입금명
	private String		sponsorReply;		// 사용자가 후원 후 남긴 댓글
	private String		achieveDate;		// 달성날짜
}
