package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMVolunteerInfo {
	
	// 관리자 페이지에서 회원 입양 내역에서 검색과 필터 내용을 기억 해줄 도메인
	private String		hostId;					// 작성자 아이디
	private String		memberId;				// 신청자 아이디
	
	private Integer		type			= 1;	// 1: 모집, 2: 참여
	private Integer		pageno 			= 1;
	
	private String		colName			= "writeDate";
	private String		sortType		= "desc";
	
	private String		searchColName	= "volunteerTitle";
	private String		searchText		= "%";
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;

}
