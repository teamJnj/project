package com.icia.jnj.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Guestbook {
	
	private Integer guestbookNo;//글번호
	private String memberId;	//아이디
	private String content;	//글내용
	private String writeDate;	//작성날짜
}
