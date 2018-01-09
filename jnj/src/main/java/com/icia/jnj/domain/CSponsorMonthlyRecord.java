package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CSponsorMonthlyRecord {
	private String month;
	private Integer totalSponsorMoney;
	private Integer totalGoodsMoney;
}
