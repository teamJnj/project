package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMAdoptRecord {
	
	// 관리자 페이지에서 회원 입양 내역 볼 때 필요한 도메인
	
	private String 			memberId;

	private Integer 		petNo;
	private String 			petName;
	private Integer			petState;
	private String			petSort;
	
	private Integer 		adoptNo;
	private String 			adoptTel;
	private String 			adoptApplyDate;
	private String 			adoptDate;
	
	private String 			cancleDate;
	private String 			centerName;

	
}
