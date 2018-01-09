package com.icia.jnj.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class QnaDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	// 수안=======================
	// qna글 개수 가져오기
	public int qnaAllCount() {
		return tpl.selectOne("QnAMapper.qnaAllCount");
	}
	
	public int qnaCount(String writeId) {
		return tpl.selectOne("QnAMapper.qnaCount",writeId);
	}
	
	
	// 관리자용: qna 글 리스트 전체 가져오기
	public List<QnA> getAllQnaList(String writeId, int startArticleNum, int endArticleNum){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writeId", writeId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("QnAMapper.getAllQnaList", map);
	}
		
		
	// qna 글 리스트 가져오기
	public List<QnA> getQnaList(String writeId, int startArticleNum, int endArticleNum){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writeId", writeId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("QnAMapper.getQnaList", map);
	}
	
	// 관리자용: qna view 화면
		public QnA getAdminQnaView(int qnaNo) {
			return tpl.selectOne("QnAMapper.getAdminQnaView",qnaNo);
		}
	
	// qna view 화면
	public QnA getQnaView(int qnaNo, String writeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("qnaNo", qnaNo);
		map.put("writeId", writeId);
		return tpl.selectOne("QnAMapper.getQnaView",map);
	}
	
	// qna 글쓰기 
	public void insertQna(QnA qna) {
		tpl.insert("QnAMapper.insertQna",qna);
	}
	
	// qna 글수정 
	public int updateQna(QnA qna) {
		return tpl.update("QnAMapper.updateQna",qna);
	}
	
	// qna 글삭제 
	public void deleteQna(QnA qna) {
		tpl.delete("QnAMapper.deleteQna", qna);
	}
	
	// qna 답변여부 확인 
	public int checkAnswer(int qnaNo, String writeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("qnaNo", qnaNo);
		map.put("writeId", writeId);
		return tpl.selectOne("QnAMapper.checkAnswer", map);
	}
	
	// 관리자용: qna 답변쓰기(update) 
	public void updateAnswer(QnA qna) {
		tpl.update("QnAMapper.updateAnswer", qna);
	}	
	
	
	
	
	// 주리
	// 일반, 센터 qna 리스트 ( 필터 검색 ) 수
	public int getCountQnaList(AdMQnaInfo info) {
		return tpl.selectOne("QnAMapper.getCountQnaList", info);
	}

	// 일반, 센터 qna 리스트 ( 필터 검색 )
	public List<Volunteer> getQnaAllList(AdMQnaInfo info) {
		return tpl.selectList("QnAMapper.getQnaAllList", info);
	}

	public List<Map<String, Integer>> getMemberTotalQnaS1(String writeId) {
		return tpl.selectList("QnAMapper.getMemberTotalQnaS1", writeId);
	}

	public List<Map<String, Integer>> getMemberTotalQnaS2(String writeId) {
		return tpl.selectList("QnAMapper.getMemberTotalQnaS2", writeId);
	}

	// 일반, 센터 qna 리스트 ( 필터 검색 ) 수
	public int getCountTotalQnaList(AdMQnaInfo info) {
		return tpl.selectOne("QnAMapper.getCountTotalQnaList", info);
	}

	// 일반, 센터 qna 리스트 ( 필터 검색 )
	public List<Volunteer> getTotalQnaAllList(AdMQnaInfo info) {
		return tpl.selectList("QnAMapper.getTotalQnaAllList", info);
	}

	public List<Map<String, Integer>> getMemberTotalQnaS3() {
		return tpl.selectList("QnAMapper.getMemberTotalQnaS3");
	}

	public List<Map<String, Integer>> getMemberTotalQnaS4() {
		return tpl.selectList("QnAMapper.getMemberTotalQnaS4");
	}
	
	
}