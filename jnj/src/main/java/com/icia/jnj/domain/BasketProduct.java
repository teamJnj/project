package com.icia.jnj.domain;

import java.util.ArrayList;
import java.util.List;

import com.icia.jnj.vo.GoodsOption;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BasketProduct {	
	private Integer goodsNo;
	private String goodsName;
	private Integer goodsPrice;
	private String goodsImg;
	private Integer optionNo;
	private String optionContent;
	private Integer qnt;
}
