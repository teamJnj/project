package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CSponsorDPRecord {
	private Integer petNo;
	private String petName;
	private String sponsorDate;
	private Integer sumDP;
}
