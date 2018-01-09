package com.icia.jnj.domain;

import javax.validation.*;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMQnaInfo {
	
	private String		writeId;
	private String		memberId;
	private String		centerId;
	
	private Integer		qnaDivision;
	
	private Integer		pageno 			= 1;
	
	private String		colName			= "writeDate";
	private String		sortType		= "desc";
	
	private String		searchColName	= "qnaTitle";
	private String		searchText		= "%";
	
	private String		startDate;
	private String		endDate;
	
	private String		sqlText			= "";
	
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;

}
