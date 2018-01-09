package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PetCutAndImg {
	private Integer 	petNo;
	private String 		petImg;
	private String 		petName;
	private Integer 	petSort;
	private Integer 	gender;
	private Integer 	petState;
	private String 		mercyDate;
}
