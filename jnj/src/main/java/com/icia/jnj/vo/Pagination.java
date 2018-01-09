package com.icia.jnj.vo;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Pagination {
	
	private Integer 	pageno;
	private Integer 	startArticleNum;
	private Integer 	endArticleNum;
	private Integer 	startPage;
	private Integer 	endPage;
	private Integer 	prev;
	private Integer 	next;
	
}
