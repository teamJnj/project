package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class FindComment {
	private Integer findCommentNo;
	private Integer findDivision;
	private Integer findNo;
	private String writeId;
	private String commentContent;
	private String writeDate;
	private Integer reportCnt;
	
	// 주리
	private String findTitle;
}
