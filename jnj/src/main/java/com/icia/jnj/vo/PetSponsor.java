package com.icia.jnj.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PetSponsor {
	private Integer petNo;
	private Integer sponsorNo;
	private Integer goalMoney;
	private Integer sponsorMoney;
	private String achieveDate;
}
