package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Pet {
	
	private Integer 	petNo;
	private String 		petName;
	private Integer 	petSort;
	private String 		kind;
	private Integer 	gender;
	private boolean 	neutral;
	private Integer 	age;
	private Integer 	weight;
	private String 		disease;
	private String 		feature;
	private String 		mercyDate;
	private String 		writeDate;
	private String		centerId;
	private Integer 	petState;
	
	// 주리
	private String petImg;
	private Integer sponsorMoney;
}
