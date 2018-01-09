package com.icia.jnj.service;

import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.security.access.prepost.*;
import org.springframework.stereotype.*;

import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class FooterService {
	@Autowired
	private FooterDao dao;
	
	// 센터 리스트
	public Map<String,Object> getBoardCenterList(String keyword, int pageno){
		
		if(keyword.equals("전체")) {
			keyword="%";
		}
		
		int articleCnt = dao.getBoardCenterCount(keyword);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("boardCenterList", dao.getBoardCenterList(keyword, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
	
	
	// 센터 글+사진 가져오기
	@PreAuthorize("isAuthenticated()")
	public Map<String,Object> getBoardCenterView(String centerId){
		List<CenterImg> centerImg = dao.getBoardCenterPicture(centerId);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("centerView", dao.getBoardCenterView(centerId));
		map.put("centerImg", centerImg);
		return map;
	}

	///////////////////////////////////////////////////////////////////////// 공지사항 
	// 공지사항 조회
	public Map<String, Object> listBoardNotice(int pageno) {
		int articleCnt = dao.getNoticeCount();
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("list", dao.getAllPageNotice(pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}

	// 공지사항 글쓰기
	public void insertBoardNotice(Notice notice) {
		dao.insertNotice(notice);
	}

	// 공지사항 화면
	public Map<String, Object> viewBoardNotice(int noticeNo) {
		dao.increasehitsNotice(noticeNo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("notice", dao.getNotice(noticeNo));
		return map;
	}

	
	public Notice getBoardNotice(int noticeNo) {
		Notice notice = dao.getNotice(noticeNo);
		return notice;
	}

	// 공지사항 정보수정
	public void updateBoardNotice(Notice notice) {
		dao.updateNotice(notice);
	}

	// 공지사항 글삭제
	public void deleteBoardNotice(Notice notice) {
		dao.deleteNotice(notice.getNoticeNo());
	}
	
	
	// 주리
	public Map<String, Object> getNoticeList( AdNoticeInfo info ){
		
		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		System.err.println("getNoticeList : " + info);
		
		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("titleContent"))
				info.setSqlText("where title like '%" + info.getSearchText() + "%' or content like '%"+ info.getSearchText() +"%'");
		}
		else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}
		
		System.err.println(info.getSqlText());
		int articleCnt = dao.getCountNoticList(info);
		
		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);
		
		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());
		
		Map<String, Object> map=new HashMap<String, Object>();
		
		map.put("pagination", pagination);
		map.put("noticeList", dao.getNoticList( info ));
		map.put("adNoticeInfo", info);
		
		return map;
	}

	
	/*//혜미혜미혜미 방명록
	public Map<String, Object> getGuestbookList(int pageno){
		int articleCnt = dao.getGuestbookCount();
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 15);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("getGuestbookList", dao.getGuestbookList(pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
	public void insertGuestbook(Guestbook guestbook) {
		dao.insertGuestbook(guestbook);
	}
	public void updateGuestbook(Guestbook guestbook) {
		dao.updateGuestbook(guestbook);
	}
	public void deleteGuestbook(int guestbookNo) {
		dao.deleteGuestbook(guestbookNo);
	}*/
	
	
}
