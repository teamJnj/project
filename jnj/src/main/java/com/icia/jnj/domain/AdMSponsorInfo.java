package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMSponsorInfo {
	
	// 관리자 페이지에서 회원 후원 내역에서 검색과 필터 내용을 기억 해줄 도메인
	private String		memberId;
	
	private Integer		pageno 			= 1;
	
	private String		colName			= "sponsorDate";
	private String		sortType		= "desc";
	
	private String		searchColName	= "memberId";
	private String		searchText		= "%";
	
	private Integer		startMoney;
	private Integer		endMoney;
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;

}
