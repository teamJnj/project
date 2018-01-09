package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FoundDomain {
	private String 		firstAddr;	// 주소
	
	private Integer findDivision;	// 1: 찾아요, 2: 찾았어요
	private Integer findNo;
	private String findTitle;
	private String findContent;
	private String findDate;
	private String findAddr;
	private String mapX;
	private String mapY;
	private String centerAddr;
	private String petImg;
	private String petName;
	private String petSort;
	private String petKind;
	private Integer petGender;	// 0: 알수없음, 1: 수컷, 2: 암컷
	private Integer petAge;
	private String petFeature;
	private String writeId;
	private String writeTel;
	private String writeDate;
	private Integer hits;
	private Integer commentNum;
	private Integer reportCnt;
	private Integer findState;	// 0: 블락, 1: 정상
	
}
