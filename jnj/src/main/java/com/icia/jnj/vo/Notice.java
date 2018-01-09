package com.icia.jnj.vo;

import lombok.AllArgsConstructor;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notice {
	private Integer noticeNo;
	private String writeDate;
	private String title;
	private String content;
	private Integer hits;
}
