package com.icia.jnj.service;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonElement;
import com.icia.jnj.dao.FoundDao;
import com.icia.jnj.util.PagingUtil;
import com.icia.jnj.vo.Find;
import com.icia.jnj.vo.FindComment;
import com.icia.jnj.vo.Pagination;
@Service
public class FoundService {
	@Autowired
	private FoundDao dao;
	
	@Value("\\\\192.168.0.203\\service\\find")
	private String uploadPath;
	
	// 게시판 목록 출력 (찾았어요)
	public Map<String, Object> listBoard(int pageno) {

		int articleCnt = dao.getBoardCount();

		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("list", dao.listBoard(pagination.getStartArticleNum(), pagination.getEndArticleNum()));

		return map;
	}


	// findNo로 find불러오기
	public Find getFind(int findNo) {
		Find find = dao.getFind(findNo);
		return find;
	}


	// 찾아요 글번호로 글상세 읽어오기
		public Map<String,Object> boardFindViewPage( int findNo) {
			// 상세글 읽어오기
			int findDivision = 2;
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
		public void boardFindWrite( Principal principal , Find find, MultipartFile file) throws IOException {

			String savedFileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();

			find.setPetImg(savedFileName);
			find.setFindDivision(2);
			find.setWriteId(principal.getName());
			find.setHits(0);
			find.setCommentNum(0);
			find.setReportCnt(0);
			find.setFindState(1);
			find.setPetName("");
			find.setPetAge(0);
			File f = new File(uploadPath, savedFileName);
			FileCopyUtils.copy(file.getBytes(), f);

			System.out.println(find);
			System.out.println(file);

			dao.boardFindWrite(find);
		}


		// 글수정
		public void boardFindUpdate( Principal principal , Find find, MultipartFile file) throws IOException {
			if(file.getOriginalFilename()!="") {
				String savedFileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
				
				File f = new File(uploadPath, savedFileName);
				FileCopyUtils.copy(file.getBytes(), f);
				
				find.setPetImg(savedFileName);
				
				System.err.println(find.getFindNo());
				
				find.setCenterAddr("");
				find.setPetAge(0);
				find.setPetName("");
				dao.boardFindUpdate(find);
			} else {
				find.setPetImg(find.getPetImg());
				find.setCenterAddr("");
				find.setPetAge(0);
				find.setPetName("");
				dao.boardFindUpdate(find);
			}
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


		// 주소 addr123 잘라서 가져오기
		public String addrFind(int findNo) {
			return dao.addrFind(findNo);
		}

}
