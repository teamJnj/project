package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdNoticeInfo {
private String		centerId;
	
	private Integer		pageno 			= 1;
	
	private String		colName			= "writeDate";
	private String		sortType		= "desc";
	
	private String		searchColName	= "titleContent";
	private String		searchText		= "%";
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;
}
