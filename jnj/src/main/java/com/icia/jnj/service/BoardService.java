package com.icia.jnj.service;

import java.io.*;
import java.security.*;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.security.access.prepost.*;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.*;
import org.springframework.util.*;
import org.springframework.web.multipart.*;

import com.icia.jnj.constant.CT;
import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class BoardService {

	@Autowired
	private BoardDao dao;

	@Value("\\\\192.168.0.203\\service\\find")
	private String uploadPath;

	// 찾아요 글번호로 글상세 읽어오기
	public Map<String,Object> boardFindViewPage( int findNo) {
		// 상세글 읽어오기
		int findDivision = 1;
		Find find = dao.boardFindViewPage(findDivision, findNo);
		// 댓글 가져오기, 여러개 -> List<FindComment>
		List<FindComment> findComment = dao.listReply(findNo);
		// 조회수 올리기
		dao.FindHit(findNo);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("find", find);
		map.put("findComment", findComment);
		
		return map;
	}
	

	
	

	// 글쓰기
	public void boardFindWrite(Principal principal , Find find, MultipartFile file) throws IOException {

		String savedFileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();

		find.setPetImg(savedFileName);
		find.setFindDivision(1);
		find.setWriteId(principal.getName());
		find.setHits(0);
		find.setCommentNum(0);
		find.setReportCnt(0);
		find.setFindState(1);
		find.setCenterAddr("");

		File f = new File(uploadPath, savedFileName);
		FileCopyUtils.copy(file.getBytes(), f);

		System.out.println(find);
		System.out.println(file);

		dao.boardFindWrite(find);
	}

	// 글수정
	public void boardFindUpdate(  Principal principal , Find find, MultipartFile file) throws IOException {
		if(file.getOriginalFilename()!="") {
			String savedFileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
			
			File f = new File(uploadPath, savedFileName);
			FileCopyUtils.copy(file.getBytes(), f);
			
			find.setPetImg(savedFileName);
			
			System.err.println(find.getFindNo());
			
			find.setCenterAddr("");
			dao.boardFindUpdate(find);
		} else {
			// MultipartFile file이 null이 들어온경우 (dao, mapper필요)
			find.setPetImg(find.getPetImg());
			find.setCenterAddr("");
			dao.boardFindUpdate(find);
		}
	}

	// 글삭제
	public void boardFindDelete(int findNo) {
		dao.boardFindDelete(findNo);
	}

	// 게시판 목록 출력(찾아요)
	public Map<String, Object> listBoard(int pageno) {

		int articleCnt = dao.getBoardCount();

		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("list", dao.listBoard(pagination.getStartArticleNum(), pagination.getEndArticleNum()));

		return map;
	}
	
	
	

	// 전리플가져오기
	public List<FindComment> listAllReply(int findNo) {
		return dao.listReply(findNo);
	}
	
	// 리플 쓰기 로그인해야 된다
	@Transactional(rollbackFor=Exception.class)
	public List<FindComment> insertFindComment(Principal principal, FindComment findComment) {
		
		findComment.setFindDivision(1);
		findComment.setWriteId(principal.getName());
		System.out.println("service 작동된다아~");
		
		dao.insertReply(findComment);
		
		return dao.listReply(findComment.getFindNo());
	
	}
	
	// 댓글 삭제
		public boolean deleteFindComment(FindComment findComment) {
			System.err.println(findComment+"service");
			return dao.deleteFindComment(findComment.getFindNo(), findComment.getFindCommentNo())==1? true: false;
		}

	// 댓글 수정
		public boolean updateFindComment(FindComment findComment) {
			return dao.updateFindComment(findComment)==1? true: false;
		}
		


	// findNo로 find불러오기
	public Find getFind(int findNo) {
		Find find = dao.getFind(findNo);
		return find;
	}





		
	// Find 게시판 출력
	public Map<String, Object> getFindList(int pageno, int petSort, String firstAddr) {
		int articleCnt = 0;
		
		String sPetSort = "'%"+petSort+"%'";
		String sFirstAddr = "'%"+firstAddr+"%'";
		
		if(petSort==0) {
			sPetSort="'%'";
		} 
		if(firstAddr.equals("전체")) {
			sFirstAddr="'%'";
		}
		
		articleCnt = dao.getFindCount(sPetSort,sFirstAddr);
		
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("petSort", petSort);
		map.put("firstAddr", firstAddr);
		map.put("pagination", pagination);
		map.put("getFindList", dao.getFindList(sPetSort,sFirstAddr, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		
		
		return map;
	}




	// 신고오
	@PreAuthorize("#writeId != principal.username")
	public int report(int findDivision, int findNo) {
		System.out.println(findDivision);
		dao.increaseReportCnt(findNo);
		System.out.println("개수:" + dao.getReportCnt(findNo));
		return dao.getReportCnt(findNo);
	}
	
	
	// 주리
	// 해당 회원 후원 내역 리스트 조회( 페이지네이션, 정렬, 후원 총금액 추가 )
	public Map<String, Object> getMemberFindList(AdMFindInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("where findDivision like '%" + info.getType() + "%'");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("findTitle"))
				info.setSqlText(info.getSqlText() + " and findTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("commentNum"))
				info.setSqlText(info.getSqlText() + " and commentNum like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("reportCnt"))
				info.setSqlText(info.getSqlText() + " and reportCnt like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("findState"))
				info.setSqlText(info.getSqlText() + " and findState like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText(info.getSqlText() + " and to_date(writeDate, 'yyyyMMdd')>=to_date("
						+ info.getStartDate() + ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date("
						+ info.getEndDate() + ", 'yyyyMMdd')");
		}

		System.err.println(info.getSqlText());

		int articleCnt = dao.getCountMemberFindList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberFindList", dao.getMemberFindList(info));
		map.put("adMFindInfo", info);
		map.put("stateCount", dao.getMemberTotalFindState(info.getWriteId(), info.getType()));

		return map;
	}

	// 해당 게시글 삭제
	public void deleteFind(int findDivision, int findNo) {
		dao.deleteFind(findDivision, findNo);
		dao.deleteAllFindComment(findDivision, findNo);
	}

	// 해당 댓글 삭제
	public void deleteFindComment(int findDivision, int findNo, int findCommentNo, String writeId) {
		dao.deleteFindOneComment(findDivision, findNo, findCommentNo, writeId);
		dao.updateFindCommentNum("-1", findDivision, findNo);
	}

	// 해당 게시글 블락
	public void updateFindState(int findState, int findDivision, int findNo) {
		dao.updateFindState(findState, findDivision, findNo);
	}

	public Map<String, Object> getMemberFindCommentList(AdMFindCommentInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("where findDivision like '%" + info.getType() + "%'");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("findTitle"))
				info.setSqlText(info.getSqlText() + " and findTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("commentContent"))
				info.setSqlText(info.getSqlText() + " and commentContent like '%" + info.getSearchText() + "%'");

		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText(info.getSqlText() + " and to_date(writeDate, 'yyyyMMdd')>=to_date("
						+ info.getStartDate() + ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date("
						+ info.getEndDate() + ", 'yyyyMMdd')");
		}

		System.err.println(info.getSqlText());

		int articleCnt = dao.getCountMemberFindCommentList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberFindCommentList", dao.getMemberFindCommentList(info));
		map.put("adMFindCommentInfo", info);

		return map;
	}




	
	
	
}
