package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdStoreInfo {

	private String		centerId;
	
	private Integer		pageno 			= 1;
	
	private String		colName			= "goodsNo";
	private String		sortType		= "desc";
	
	private String		searchColName	= "goodsName";
	private String		searchText		= "%";
	
	private Integer		startMoney;
	private Integer		endMoney;
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;
}
