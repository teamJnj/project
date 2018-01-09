package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Goods {
	
	private Integer goodsNo;
	private String goodsName;
	private String goodsContent;
	private Integer goodsPrice;
	private Integer stockQnt;
	private Integer sellQnt;
	private String categoryName;
	private String goodsDate;
	private Integer goodsState;	// 0:품절, 1:판매중
	
	
	//주리
	private String 		goodsImg;
	private Integer 	optionNo; 
	private String 		optionContent;
}
