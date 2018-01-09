package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Market {
	private Integer marketNo;
	private String marketTitle;
	private String marketContent;
	private String marketAddr;
	private String marketDate;
	private String applyEndDate;
	private Integer boothPrice;
	private Integer applyPeople;
	private String writeDate;
	private Integer hits;
	private Integer marketState;	// 1: 모집중, 2: 모집완료
}
