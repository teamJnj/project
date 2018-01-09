package com.icia.jnj.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.*;

import com.icia.jnj.dao.CenterDao;
import com.icia.jnj.dao.MessageDao;
import com.icia.jnj.dao.SUsersDao;
import com.icia.jnj.util.PagingUtil;
import com.icia.jnj.vo.Message;
import com.icia.jnj.vo.Pagination;
import com.icia.jnj.vo.SUsers;

@Service
public class GeneralService {

	@Autowired
	JavaMailSender mailSender;

	@Autowired
	private CenterDao dao;
	@Autowired
	private MessageDao msgDao;
	@Autowired
	private SUsersDao sDao;

	@PreAuthorize("isAnonymous()")
	public String findId(String memberName, String licensee, String email) {

		if (memberName == null)
			return dao.getCenterId(licensee, email);

		return dao.getMemberId(memberName, email);
	}
	
	
	
	
	// 수현 - 쪽지
	// 보낸 쪽지 리스트
	public Map<String, Object> getSendList(String senderId, int pageNo) {
		Pagination pagination = PagingUtil.setPageMaker(pageNo, msgDao.getSendCount(senderId), 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("msgList", msgDao.getSendList(senderId, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}

	// 받은 쪽지 리스트
	public Map<String, Object> getReceiveList(String receiverId, int pageNo) {
		Pagination pagination = PagingUtil.setPageMaker(pageNo, msgDao.getReceiveCount(receiverId), 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("msgList", msgDao.getReceiveList(receiverId, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
	
	// 보낸 쪽지 뷰
	public Message getSendView(int messageNo, String senderId) {
		return msgDao.getSendView(messageNo, senderId);
	}

	// 받은 쪽지 뷰
	public Message getReceiveView(int messageNo, String receiverId) {
		// 쪽지 읽음 상태 업데이트
		msgDao.updateMsgRead(messageNo);
		return msgDao.getReceiveView(messageNo, receiverId);
	}

	// 쪽지 보내기
	public boolean insertMessage(Message msg) {
		SUsers su = sDao.getUsers(msg.getReceiverId());
		System.out.println(su);
		if(su==null) {
			return false;
		} else {
			msgDao.insertMessage(msg);
			return true;
		}
	}
	
	// 보낸 쪽지 삭제(상태 업데이트)
	public int updateSendDel(int messageNo) {
		return msgDao.updateSendDel(messageNo);
	}

	// 받은 쪽지 삭제(상태 업데이트) -->
	public int updateReceiveDel(int messageNo) {
		return msgDao.updateReceiveDel(messageNo);
	}

	// 쪽지 삭제(보낸사람-받은사람 모두 삭제시) -->
	public int deleteMsg(int messageNo) {
		return msgDao.deleteMsg(messageNo);
	}

	public int getReceivedMsgCount(String receiverId) {
		return msgDao.getReceivedMsgCount(receiverId);
	}
}
