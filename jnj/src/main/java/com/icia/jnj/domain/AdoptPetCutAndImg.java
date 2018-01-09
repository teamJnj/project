package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdoptPetCutAndImg {
	private Integer 	petNo;
	private String 		petImg;
	private String 		petName;
	private Integer 	petSort;
	private Integer 	gender;
	private Integer 	petState;
	private String 		mercyDate;
	
	private String		memberId;
	private String		memberName;
	private String		adoptTel;
	private String		adoptApplyDate;
	private String		adoptDate;
	private boolean		cancle;
	private String		cancleDate;
	
	private String		birthDate;
	private String		email;
	private Integer		adoptNo;
	private String 		kind;
	private Integer 	age;
	private Integer 	weight;
	private String 		disease;
}
