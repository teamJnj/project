package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Review {
	private Integer reviewNo;
	private Integer goodsNo;
	private Integer optionNo;
	private String writeId;
	private Integer satisfy;	// 만족도 평가:1~5
	private String reviewContent;
	private String writeDate;
}
