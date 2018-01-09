package com.icia.jnj.vo;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VolunteerComment {
	private Integer		volunteerCommentNo;
	private Integer		volunteerNo;
	private String 		writeId;
	private String 		commentContent;
	private String 		writeDate;
	private Integer 	reportCnt;
	
	// 주리
	// 필요할 시 사용
	private String 		volunteerTitle;
	private String 		detailState;

}