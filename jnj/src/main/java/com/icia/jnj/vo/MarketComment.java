package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MarketComment {
	private Integer marketCommentNo;
	private Integer marketNo;
	private String writeId;
	private String commentContent;
	private String writeDate;
	private Integer reportCnt;
	
	// 주리
	// 필요할 시 사용
	private String marketTitle;
}
