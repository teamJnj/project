package com.icia.jnj.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class Message {
	private Integer messageNo;
	private String title;
	private String content;
	private String sendDate;
	private String senderId;
	private String receiverId;
	private Integer msgState;
}
