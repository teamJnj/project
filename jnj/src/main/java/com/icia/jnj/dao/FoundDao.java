package com.icia.jnj.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.icia.jnj.domain.FoundDomain;
import com.icia.jnj.vo.Find;
import com.icia.jnj.vo.FindComment;

@Repository
public class FoundDao {

	@Autowired
	private SqlSessionTemplate tpl;
	
	// 글갯수 찾았어요
	public int getBoardCount() {
		return tpl.selectOne("foundMapper.getBoardCnt");
	}
	
	public List<Find> listBoard(int startArticleNum, int endArticleNum) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("foundMapper.listBoard", map);
	}

	// 글번호로 글읽기
		public Find getFind(int findNo) {
			return tpl.selectOne("foundMapper.getFind", findNo);
	}

	// 글상세보기
	public Find boardFindViewPage(int findDivision, int findNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		return tpl.selectOne("foundMapper.getBoardFindViewPage", map);
	}

	// 전리플
	public List<FindComment> listReply(int findNo) {
		return tpl.selectList("foundMapper.listFindComment", findNo);
	}

	// 조회수 올리기
		public void FindHit(int findNo) {
			tpl.selectOne("foundMapper.getFindHit",findNo);
		}

	// 글쓰기
	public void boardFindWrite(Find find) {

		System.out.println(find);

		tpl.insert("foundMapper.boardFindWrite", find);
	}

	// 글수정
	public void boardFindUpdate(Find find) {
		tpl.update("foundMapper.boardFindUpdate", find);
	}

	// 찾아요 리스트 뽑기위해 필요한거
		public int getFindCount(String petSort, String firstAddr) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("petSort", petSort);
			map.put("firstAddr", firstAddr);
			return tpl.selectOne("foundMapper.getFindCount", map);
		}

	// 해당 리스트 뽑기
	public List<FoundDomain> getFindList(String petSort, String firstAddr, int startArticleNum, int endArticleNum){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("petSort", petSort);
		map.put("firstAddr", firstAddr);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("foundMapper.getFindList", map);
	}

	// 신고
	public int increaseReportCnt(int findNo) {
		return tpl.update("foundMapper.increaseReportCnt", findNo);
		
	}

	// 신고수 세기
	public int getReportCnt(int findNo) {
		return tpl.selectOne("foundMapper.getReportCnt", findNo);
	}

	public String addrFind(int findNo) {
		return tpl.selectOne("findMapper.getAddrFind",findNo);
	}
}
