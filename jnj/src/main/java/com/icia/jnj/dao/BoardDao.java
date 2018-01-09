package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class BoardDao {

	@Autowired
	private SqlSessionTemplate tpl;

	// 글상세보기
	public Find boardFindViewPage(int findDivision, int findNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		return tpl.selectOne("findMapper.getBoardFindViewPage", map);
	}
	
	
	
	// 글쓰기
	public void boardFindWrite(Find find) {

		System.out.println(find);

		tpl.insert("findMapper.boardFindWrite", find);
	}

	// 글수정
	public void boardFindUpdate(Find find) {
		tpl.update("findMapper.boardFindUpdate", find);
	}

	// 글삭제
	public void boardFindDelete(int findNo) {
		tpl.delete("findMapper.boardFindDelete", findNo);
	}

	// 글갯수 찾아요
	public int getBoardCount() {
		return tpl.selectOne("findMapper.getBoardCnt");
	}
	
	
	public List<Find> listBoard(int startArticleNum, int endArticleNum) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("findMapper.listBoard", map);
	}
	
	
	// 전리플
	public List<FindComment> listReply(int findNo) {
		return tpl.selectList("findMapper.listFindComment", findNo);
	}
	// 댓글 쓰기
	public void insertReply(FindComment findComment) {
		System.err.println(findComment.getCommentContent());
		tpl.insert("findMapper.insertReply", findComment);
	}
	
	// 리플 갯수 읽
	public int countReply (FindComment findComment) {
		return tpl.selectOne("findMapper.countReply",findComment);
	}

	// 댓삭
	public int deleteFindComment(Integer findNo, Integer findCommentNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("findNo", findNo);
		map.put("findCommentNo", findCommentNo);
		
		System.err.println(map);
		return tpl.delete("findMapper.deleteFindComment",map);
	}

	// 댓글 수정
	public int updateFindComment(FindComment findComment) {
		return tpl.update("findMapper.updateFindComment",findComment);
	}
	
	// 글번호로 글읽기
	public Find getFind(int findNo) {
		return tpl.selectOne("findMapper.getFind", findNo);
	}

	// 찾아요 리스트 뽑기위해 필요한거
	public int getFindCount(String petSort, String firstAddr) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petSort", petSort);
		map.put("firstAddr", firstAddr);
		return tpl.selectOne("findMapper.getFindCount", map);
	}

	// 해당 리스트 뽑기
	public List<FindDomain> getFindList(String petSort, String firstAddr, int startArticleNum, int endArticleNum){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("petSort", petSort);
		map.put("firstAddr", firstAddr);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("findMapper.getFindList", map);
	}
	
	// 조회수 올리기
	public void FindHit(int findNo) {
		tpl.selectOne("findMapper.getFindHit",findNo);
	}
	
	// 신고
	public int increaseReportCnt(int findNo) {
		return tpl.update("findMapper.increaseReportCnt", findNo);	
	}
		
	// 신고수 세기
	public int getReportCnt(int findNo) {
		return tpl.selectOne("findMapper.getReportCnt", findNo);
	}

	
	
	
	// 주리
	// 해당 게시판 내역 총 개수( 검색, 필터 )
	public int getCountMemberFindList(AdMFindInfo info) {
		return tpl.selectOne("findMapper.getCountMemberFindList", info);
	}

	// 해당 게시판 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<Find> getMemberFindList(AdMFindInfo info) {
		return tpl.selectList("findMapper.getMemberFindList", info);
	}

	// 해당 게시글 상태 변경
	public void updateFindState(int finsState, int findDivision, int findNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("finsState", finsState);
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		tpl.update("findMapper.updateFindState", map);
	}

	// 해당 게시글 댓글 수 변경
	public void updateFindCommentNum(String commentNum, int findDivision, int findNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("commentNum", commentNum);
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		tpl.update("findMapper.updateFindCommentNum", map);
	}

	// 해당 게시글 삭제
	public void deleteFind(int findDivision, int findNo) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		tpl.delete("findMapper.deleteFind", map);
	}

	// 해당 게시글에 달린 댓글 하나 삭제
	public void deleteFindOneComment(int findDivision, int findNo, int findCommentNo, String writeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		map.put("findCommentNo", findCommentNo);
		map.put("writeId", writeId);
		tpl.delete("findMapper.deleteFindOneComment", map);
	}

	// 해당 게시글에 달린 댓글 하나 삭제
	public void deleteAllFindComment(int findDivision, int findNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("findDivision", findDivision);
		map.put("findNo", findNo);
		tpl.delete("findMapper.deleteAllFindComment", map);
	}

	// 해당 게시판 댓글 내역 총 개수( 검색, 필터 )
	public int getCountMemberFindCommentList(AdMFindCommentInfo info) {
		return tpl.selectOne("findMapper.getCountMemberFindCommentList", info);
	}

	// 해당 게시판 댓글 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<FindComment> getMemberFindCommentList(AdMFindCommentInfo info) {
		return tpl.selectList("findMapper.getMemberFindCommentList", info);
	}

	// 회원의 게시판 별 글 상태 수 가져오기
	public List<Map<String, Integer>> getMemberTotalFindState(String writeId, int findDivision) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writeId", writeId);
		map.put("findDivision", findDivision);
		return tpl.selectList("findMapper.getMemberTotalFindState", map);
	}

	// 해당 게시판번호가 어느 게시판에 속하는지 가져온다
	public int getDivisionByFindNo(int findNo) {
		return tpl.selectOne("findMapper.getDivisionByFindNo", findNo);
	}


}
