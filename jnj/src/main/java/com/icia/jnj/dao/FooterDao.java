package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class FooterDao {
	@Autowired
	private SqlSessionTemplate tpl;
	
	// 센터 리스트 개수
	public int getBoardCenterCount(String keyword) {
		return tpl.selectOne("footerMapper.getBoardCenterCount",keyword);
	}
	// 센터 리스트 가져오기
	public List<Map<String, Object>> getBoardCenterList(String keyword, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("footerMapper.getBoardCenterList",map);
	}
	
	// 센터 글 가져오기
	public Center getBoardCenterView(String centerId) {
		return tpl.selectOne("footerMapper.getBoardCenterView",centerId);
	}
	// 센터 사진 가져오기
	public List<CenterImg> getBoardCenterPicture(String centerId) {
		return tpl.selectList("footerMapper.getBoardCenterPicture",centerId);
	}
	
	
	////////////////////////////////////////////////////////////// 공지사항
	public int getNoticeCount() {
		return tpl.selectOne("footerMapper.getNoticeCount");
	}
	
	public List<Notice> getAllPageNotice(Integer startArticleNum, Integer endArticleNum) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("footerMapper.getAllPageNotice", map);
	}
	
	public void insertNotice(Notice notice) {
		tpl.insert("footerMapper.insertNotice",notice);
		
	}
	
	public void increasehitsNotice(int noticeNo) {
		tpl.update("footerMapper.increasehitsNotice",noticeNo);
		
	}
	
	public Notice getNotice(int noticeNo) {
		return tpl.selectOne("footerMapper.getNotice",noticeNo);
	}
	
	public void updateNotice(Notice notice) {
		tpl.update("footerMapper.updateNotice",notice);
		
	}
	public void deleteNotice(Integer noticeNo) {
		tpl.delete("footerMapper.deleteNotice",noticeNo);
		
	}
	
	
	// 공지사항 리스트 가져오기( 필터, 검색 )
	public int getCountNoticList(AdNoticeInfo info) {
		return tpl.selectOne("footerMapper.getCountNoticList", info);
	}

	public List<Notice> getNoticList(AdNoticeInfo info) {
		return tpl.selectList("footerMapper.getNoticList", info);
	}
	
	
	
	/*//혜미 방명록
	public int getGuestbookCount() {
		return tpl.selectOne("guestbookMapper.getGuestbookCount");
	}
	public List<Guestbook> getGuestbookList(int startArticleNum, int endArticleNum){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("guestbookMapper.getGuestbookList", map);
	}
	public void insertGuestbook(Guestbook guestbook) {
		tpl.insert("guestbookMapper.insertGuestbook",guestbook);
	}
	public int updateGuestbook(Guestbook guestbook) {
		return tpl.update("guestbookMapper.updateGuestbook",guestbook);
	}
	public void deleteGuestbook(int guestbookNo) {
		tpl.delete("guestbookMapper.deleteGuestbook",guestbookNo);
	}*/
	
	
	
}
