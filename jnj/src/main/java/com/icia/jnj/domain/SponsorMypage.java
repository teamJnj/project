package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SponsorMypage {
	private Integer 	petNo;	//key
	private String 		petName;
	private String 		petSort;
	private Integer 	petState;
	private Integer 	petMoney;
	private String 		sponsorDate;
	private String 		centerName;
	private String 		memberId;
}
