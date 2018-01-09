package com.icia.jnj.vo;

import java.util.*;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Center {

	private String 		centerId;
	private String 		password;
	private String 		centerName;
	private String 		centerAddr;
	private String 		centerTel;
	private String 		email;
	private String 		homepage;
	private String 		licensee;
	private Integer 	licenseNo;
	private String 		licenseImg;
	private String 		sponsorAccountNo;
	
	private String 		sponsorAccountHolder;
	
	private String 		sponsorAccountBank;
	private String 		sponsorAccountImg;
	private Integer 	centerState;				// 0:블락 / 1:정상 / 2:가입승인대기
	
	List<CenterImg>		imgList;
	List<Authority>		Authorities;
}
