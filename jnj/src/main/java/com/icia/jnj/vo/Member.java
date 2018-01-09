package com.icia.jnj.vo;

import java.util.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {

	private String 		memberId;
	private String 		password;
	private String 		memberName;
	private String 		email;
	private String 		birthDate;
	private Integer 	point;
	private Integer 	grade;
	private Integer 	reportCnt;
	private Integer 	memberState;		// 0:블락 / 1:정상 / 2:관리자

	List<Authority>		Authorities;
}
