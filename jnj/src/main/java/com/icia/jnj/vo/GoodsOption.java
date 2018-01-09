package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GoodsOption {
	private Integer goodsNo;
	private Integer optionNo;
	private String optionContent;
	private Integer qnt=1;	
}
