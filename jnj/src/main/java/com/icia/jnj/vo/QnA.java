package com.icia.jnj.vo;

import lombok.AllArgsConstructor;

import lombok.NoArgsConstructor;

import lombok.Data;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QnA {
	private Integer qnaNo;
	private Integer qnaDivision;
	private Integer qnaSort;
	private String writeId;
	private String qnaTitle;
	private String qnaContent;
	private String qnaImg;
	private String writeDate;
	private String answerContent;
	private String answerDate;
}
