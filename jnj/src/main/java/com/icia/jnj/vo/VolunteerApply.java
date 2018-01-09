package com.icia.jnj.vo;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VolunteerApply {
	private Integer 	volunteerNo;
	private String 		memberId;
	private String 		applyTel;
	private String 		tel1;
	private String 		tel2;
	private String 		applyDate;
	private Integer 	volunteerApplyState;
	
	
	// 봉사 신청자 목록 뽑을 떄 필요해서 추가
	private String		memberName;
	private String		birthDate;
	private String 		detailState;
	private String 		hostId;

}
