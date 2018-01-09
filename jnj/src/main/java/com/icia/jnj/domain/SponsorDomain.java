package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SponsorDomain {
	// 펫정보(상태)+사진+후원현황+센터
	private Integer 	petNo;	//key
	private String 		petName;
	private Integer 	neutral;
	private String 		petSort;
	private String 		kind;
	private Integer 	gender;
	private Integer 	age;
	private Integer 	weight;
	private String 		disease;
	private String 		feature;
	private String 		mercyDate;
	private String 		mercyDDay;
	private String 		achieveDate;
	private Integer 	petState;
	private Integer 	petImgNo;	//key
	private String 		petImg;
	private Integer 	sponsorNo;	//key
	private Integer 	goalMoney;
	private Integer 	sponsorMoney;
	private Integer 	goalPercent;
	
	private String 		centerId;	//key
	private String 		centerName;
	private String 		centerAddr;
	private String		firstAddr;
	private String 		centerTel;
	private String 		centerEmail;
	private boolean 	cancle;
	private Integer 	adoptNo;
	private String 		memberId;

	private String 		lastAdopter;
}
