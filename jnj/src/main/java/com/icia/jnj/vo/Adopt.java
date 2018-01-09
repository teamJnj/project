package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Adopt {
	private Integer petNo;
	private String memberId;
	private String memberName;
	private Integer adoptNo;
	private String adoptTel;
	private String adoptApplyDate;
	private String adoptDate;
	private boolean cancle;
	private String cancleDate;
	
	
	// AdoptApply에서 필요한 객체
	private int petState;
	private String mercyDate;
}
