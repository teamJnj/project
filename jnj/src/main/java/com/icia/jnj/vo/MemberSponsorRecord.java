package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemberSponsorRecord {
	private String memberId;
	private Integer petNo;
	private Integer sponsorNo;
	private Integer memberSponsorNo;
	private Integer payMoney;
	private Integer payWay;
	private String depositor;
	private String sponsorDate;
	private String sponsorReply;

	// 주리
	private String centerId;
	private Integer petSort;
	private String petName;

}
