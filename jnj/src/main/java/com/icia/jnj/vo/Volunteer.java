package com.icia.jnj.vo;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Volunteer {

	private Integer 	volunteerNo;
	private Integer 	volunteerDivision;
	private String 		volunteerTitle;
	private String 		volunteerContent;
	private String 		volunteerAddr;
	private String 		volunteerDate;
	private String 		applyEndDate;
	private Integer 	ageLimit;
	private Integer 	minPeople;
	private Integer 	maxPeople;
	private Integer 	applyPeople;
	private String 		writeDate;
	private String 		hostId;
	private String 		hostTel;
	private String 		addr1;
	private String 		addr2;
	private String 		addr3;
	private String 		tel2;
	private Integer 	hits;
	private Integer 	volunteerState;	// 0:블락 / 1:[CASE4] / 2:취소
	private Integer		reportCnt;
	private Integer 	detailState;	// [CASE4] 모집중(1)-모집완료(2)-봉사완료(3)-인원미달(4)
	private Integer		volunteerApplyState;
}
