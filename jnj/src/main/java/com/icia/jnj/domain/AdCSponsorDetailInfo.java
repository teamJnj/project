package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdCSponsorDetailInfo {
	
	private Integer		petNo;
	private String		centerId;
	
	private Integer		pageno 			= 1;
	
	private String		colName			= "sponsorNo";
	private String		sortType		= "asc";
	
	private String		searchColName	= "petSort";
	private String		searchText		= "%";
	
	private Integer		startMoney;
	private Integer		endMoney;
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;
}
