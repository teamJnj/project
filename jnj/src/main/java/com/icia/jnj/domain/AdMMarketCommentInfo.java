package com.icia.jnj.domain;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdMMarketCommentInfo {

	private String writeId;
	private String memberId;

	private Integer pageno = 1;

	private String colName = "writeDate";
	private String sortType = "desc";

	private String searchColName = "writeId";
	private String searchText = "%";

	private String startDate;
	private String endDate;

	private String sqlText = "";

	private Integer startArticleNum;
	private Integer endArticleNum;
}
