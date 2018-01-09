package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMFindInfo {
	
	private String		writeId;
	private String		memberId;				// 신청자 아이디
	
	private Integer		type			= 1;	// 1: 찾았어요, 2:주었어요, 3:찾았어요댓글, 4:주었어요댓글
	private Integer		pageno 			= 1;
	
	private String		colName			= "writeDate";
	private String		sortType		= "desc";
	
	private String		searchColName	= "findTitle";
	private String		searchText		= "%";
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;

}
