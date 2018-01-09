package com.icia.jnj.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.vo.Message;

@Repository
public class MessageDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	// 보낸 글 개수
	public int getSendCount(String senderId) {
		return tpl.selectOne("msgMapper.getSendCount", senderId);
	}
		
	// 보낸 쪽지 리스트 
	public List<Message> getSendList(String senderId, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("senderId", senderId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("msgMapper.getSendList", map);
	}
	
	// 받은 글 개수
	public int getReceiveCount(String receiverId) {
		return tpl.selectOne("msgMapper.getReceiveCount", receiverId);
	}
	
	// 받은 쪽지 리스트
	public List<Message> getReceiveList(String receiverId, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("receiverId", receiverId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("msgMapper.getReceiveList", map);
	}
	
	// 보낸 쪽지 뷰
	public Message getSendView(int messageNo, String senderId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("senderId", senderId);
		map.put("messageNo", messageNo);
		return tpl.selectOne("msgMapper.getSendView", map);
	}
	
	// 받은 쪽지 뷰
	public Message getReceiveView(int messageNo, String receiverId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("receiverId", receiverId);
		map.put("messageNo", messageNo);
		return tpl.selectOne("msgMapper.getReceiveView", map);
	}
	
	// 쪽지 읽음 상태 업데이트
	public int updateMsgRead(int messageNo) {
		return tpl.update("msgMapper.updateMsgRead", messageNo);
	}
	
	// 쪽지 보내기
	public int insertMessage(Message msg) {
		return tpl.insert("msgMapper.insertMessage", msg);
	}

	// 보낸 쪽지 삭제(상태 업데이트)
	public int updateSendDel(int messageNo) {
		return tpl.update("msgMapper.updateSendDel", messageNo);
	}
	
	// 받은 쪽지 삭제(상태 업데이트) -->
	public int updateReceiveDel(int messageNo) {
		return tpl.update("msgMapper.updateReceiveDel", messageNo);
	}
	
	// 쪽지 삭제(보낸사람-받은사람 모두 삭제시) -->
	public int deleteMsg(int messageNo) {
		return tpl.delete("msgMapper.deleteMsg", messageNo);
	}

	public int getReceivedMsgCount(String receiverId) {
		return tpl.selectOne("msgMapper.getReceivedMsgCount", receiverId);
	}
}
