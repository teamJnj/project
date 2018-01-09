package com.icia.jnj.domain;

import javax.validation.*;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMAdoptInfo {
	
	// 관리자 페이지에서 회원 입양 내역에서 검색과 필터 내용을 기억 해줄 도메인
	private String		memberId;
	private String		centerId;
	
	
	private Integer		pageno 			= 1;
	
	private String		colName			= "adoptApplyDate";
	private String		sortType		= "desc";
	
	private String		searchColName	= "centerName";
	private String		searchText		= "%";
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;

}
