package com.icia.jnj.service;

import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class MarketService {
	@Autowired
	private RecruitDao dao;

	// 마켓 글 리스트
	public Map<String, Object> listMarket(int pageno) {
		int articleCnt = dao.getMarketCount();
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("list", dao.getAllPageMarket(pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		
		List<Market> list = dao.getAllPageMarket(pagination.getStartArticleNum(), pagination.getEndArticleNum());
		
		for( int i=0; i<list.size(); i++) {
			list.get(i).getMarketNo();
			
		}
		
		
		
		
		
		return map;
	}

	// @Transactional(rollbackFor=Exception.class)
	// @PreAuthorize("isAuthenticated()")
	public void insertMarket(Market market) {
		dao.insertMarket(market);
	}

	// 마켓 글 뷰 화면
	public Map<String, Object> viewMarket(int marketNo) {
		List<MarketComment> MarketComment = dao.getMarketComment(marketNo);
		List<MarketApply> MarketApply = dao.getMarketApplyList(marketNo);
		dao.increasehits(marketNo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("market", dao.getMarket(marketNo));
		map.put("marketComment", MarketComment);
		map.put("marketApply", MarketApply);
		return map;
	}

	// 댓글 리스트
	public Map<String, Object> listMarketComment(int pageno) {
		int articleCnt = dao.getMarketCommentCount();
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("list", dao.getAllPageMarketComment(pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}

	// 마켓 글 뷰
	public List<MarketComment> viewMarketComment(int marketNo) {
		return dao.getMarketComment(marketNo);
	}

	// 마켓 글 댓글 작성
	public List<MarketComment> insertMarketComment(MarketComment marketComment) {
		dao.insertMarketComment(marketComment);
		return dao.readReply(marketComment.getMarketNo());
	}

	// 마켓 글 댓글 리스트
	public List<MarketComment> listMarketCommentReply(int marketNo) {
		return dao.listRecentReply(marketNo);
	}

	// 마켓 신청
	public void insertMarketApply(MarketApply marketApply) {
		marketApply.setApplyTel(marketApply.getTel1()+marketApply.getTel2());
		dao.insertMarketApply(marketApply);
		dao.increaseApplyPeople(marketApply);
		MarketComment marketcomment = new MarketComment();
		marketcomment.setMarketNo(marketApply.getMarketNo());
		marketcomment.setWriteId("-----");
		marketcomment.setCommentContent(marketApply.getMemberId() + "님이 " + marketApply.getBoothNum() + "개의 부스를 신청하셨습니다.");

		dao.insertMarketComment(marketcomment);
	}

	// 마켓 글 수정
	public void updateMarket(Market market) {
		dao.updateMarket(market);

	}

	// 마켓 글 마켓번호 불러오기
	public Market getMarket(int marketNo) {
		Market market = dao.getMarket(marketNo);
		return market;
	}

	// 마켓 글 삭제 ( 프리마켓을 신청 한 회원이 있으면 신청 삭제하고 글 삭제)
	public void deleteMarket(Market market) {
		List<MarketApply> marketApplyList = dao.getMarketApplyList(market.getMarketNo());
		// 쪽지 추가 
		
		// 신청 삭제
		dao.deleteAllMarketApply(market.getMarketNo());
		// 댓글 삭제
		dao.deleteAllMarketComment(market.getMarketNo());
		// 프리마켓 글 삭제
		dao.deleteMarket(market.getMarketNo());
		
	}
	// 댓글 마켓번호 불러오기 
	public List<MarketComment> getMarketComment(int marketNo) {
		List<MarketComment> marketComment = dao.getMarketComment(marketNo);
		return marketComment;
	}
	// 댓글 수정
	public boolean updateMarketComment(MarketComment marketComment) {
		return dao.updateMarketComment(marketComment)==1? true: false;
	}
	// 댓글 삭제
	public boolean deleteMarketComment(MarketComment marketComment) {
		return dao.deleteMarketComment(marketComment.getMarketNo(), marketComment.getMarketCommentNo())==1? true: false;
	}
	// 프리마켓 신청 취소
	public boolean deleteMarketApply(MarketApply marketApply) {
		int boothNum = dao.getBoothNum(marketApply.getMarketNo(), marketApply.getMemberId());
		marketApply.setBoothNum(boothNum);
		MarketComment marketcomment = new MarketComment();
		marketcomment.setMarketNo(marketApply.getMarketNo());
		marketcomment.setWriteId("-----");
		marketcomment.setCommentContent(marketApply.getMemberId() + "님이 " + marketApply.getBoothNum() + "개의 부스를 취소하셨습니다.");

		
		
		dao.insertMarketComment(marketcomment);
		
		
		
		dao.decreaseApplyPeople(marketApply);
		return dao.deleteMarketApply(marketApply.getMarketNo(), marketApply.getMemberId())==1? true: false;
		
		
	
	
	}
	
	
	
	
	// 수현
	// 일반회원 프리마켓 리스트
	public Map<String, Object> getMemberMarketList(String memberId, int pageNo) {
		Pagination pagination = PagingUtil.setPageMaker(pageNo, dao.getgetMemberMarketCnt(memberId), 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mMarketList", dao.getMemberMarketList(memberId, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		map.put("pagination", pagination);
		return map;
	}
	
	// 주리 ==============================================================================================
		// 해당 회원 후원 내역 리스트 조회( 페이지네이션, 정렬, 후원 총금액 추가 )
		public Map<String, Object> getMemberMarketAllList( AdMMarketInfo info ){
			
			// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
			// 없을때는 기본셋팅으로
			info.setSqlText("");
			if( !info.getSearchText().equals("%") ) {
				if( info.getSearchColName().equals("marketTitle"))
					info.setSqlText("where marketTitle like '%"+info.getSearchText()+"%'");
				
				else if( info.getSearchColName().equals("boothNum") ) 
					info.setSqlText("where boothNum like '%"+info.getSearchText()+"%'");
				
				else if( info.getSearchColName().equals("marketApplyState"))
					info.setSqlText("where marketApplyState like '%"+info.getSearchText()+"%'");
				
				else if( info.getSearchColName().equals("petState") )
					info.setSqlText("where petState like '%"+info.getSearchText()+"%'");
			}
			else {
				if( info.getSearchColName().equals("payMoney"))
					info.setSqlText( "where payMoney>="+ info.getStartMoney()+" and payMoney<= "+info.getEndMoney() );
				
				else if( info.getSearchColName().equals("applyDate"))
					info.setSqlText( "where to_date(applyDate, 'yyyyMMdd')>=to_date("+ info.getStartDate()+", 'yyyyMMdd') and to_date(applyDate, 'yyyyMMdd')<= to_date("+info.getEndDate()+", 'yyyyMMdd')" );
			
				else if( info.getSearchColName().equals("marketDate"))
					info.setSqlText( "where to_date(marketDate, 'yyyyMMdd')>=to_date("+ info.getStartDate()+", 'yyyyMMdd') and to_date(marketDate, 'yyyyMMdd')<= to_date("+info.getEndDate()+", 'yyyyMMdd')" );
			
			}
			
			
			int articleCnt = dao.getCountMemberMarketList(info);
			
			Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);
			
			info.setStartArticleNum(pagination.getStartArticleNum());
			info.setEndArticleNum(pagination.getEndArticleNum());
			
			Map<String, Object> map=new HashMap<String, Object>();
			
			map.put("pagination", pagination);
			map.put("memberMarketList", dao.getMemberMarketList( info ));
			map.put("stateCount", dao.getMemberTotalMarketApplyState(info.getMemberId()) );
			
			return map;
		}
		
		
	// 주리
	// ==============================================================================================
	// 해당 회원 후원 내역 리스트 조회( 페이지네이션, 정렬, 후원 총금액 추가 )
	public Map<String, Object> getMemberMarketList(AdMMarketInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("marketTitle"))
				info.setSqlText("where marketTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("boothNum"))
				info.setSqlText("where boothNum like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("marketState"))
				info.setSqlText("where marketApplyState like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("petState"))
				info.setSqlText("where petState like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("payMoney"))
				info.setSqlText("where payMoney>=" + info.getStartMoney() + " and payMoney<= " + info.getEndMoney());

			else if (info.getSearchColName().equals("applyDate"))
				info.setSqlText("where to_date(applyDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(applyDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");

			else if (info.getSearchColName().equals("marketDate"))
				info.setSqlText("where to_date(marketDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(marketDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");

		}

		int articleCnt = dao.getCountMemberMarketList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberMarketList", dao.getMemberMarketList(info));

		return map;
	}

	public void updateMarketApplyState(int marketNo, String memberId, int marketApplyState, String num) {

		// 프리마켓 글에 신청 인원수를 줄인다.
		dao.updateMarketApplyPeople(marketNo, num);

		// 프리마켓 신청 상태를 취소로 만든다.
		dao.updateMarketApply(marketNo, memberId, marketApplyState);

	}

	// 마켓 댓글 리스트 보기
	public Map<String, Object> getMemberMarketCommentList(AdMMarketCommentInfo info) {

		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("marketTitle"))
				info.setSqlText("where marketTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("commentContent"))
				info.setSqlText("where commentContent like '%" + info.getSearchText() + "%'");

		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountMemberMarketCommentList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberMarketCommentList", dao.getMemberMarketCommentList(info));

		return map;
	}

	public Map<String, Object> marketPay(String memberId, int marketNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("market", dao.getMarket(marketNo));
		map.put("marketApply", dao.marketPay(memberId, marketNo));
		return map;
	}

	public Map<String, Object> getTotalMarketList(AdMarketInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("marketTitle"))
				info.setSqlText("where marketTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("marketState"))
				info.setSqlText("where marketState like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("marketDate"))
				info.setSqlText("where to_date(marketDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(marketDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountTotalMarketList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberMarketList", dao.getTotalMarketList(info));
		map.put("stateCount", dao.getTotalMarketApplyState());

		return map;
	}

	public Map<String, Object> getTotalMarketApplyList(AdMarketApplyInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("marketTitle"))
				info.setSqlText("where marketTitle like '%" + info.getSearchText() + "%'");

			if (info.getSearchColName().equals("marketNo"))
				info.setSqlText("where marketNo like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("memberId"))
				info.setSqlText("where memberId like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("applyTel"))
				info.setSqlText("where applyTel like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("boothNum"))
				info.setSqlText("where boothNum like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("marketApplyState"))
				info.setSqlText("where marketApplyState like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("payMoney"))
				info.setSqlText("where payMoney>=" + info.getStartMoney() + " and payMoney<= " + info.getEndMoney());

			else if (info.getSearchColName().equals("applyDate"))
				info.setSqlText("where to_date(applyDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(applyDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");

			else if (info.getSearchColName().equals("marketDate"))
				info.setSqlText("where to_date(marketDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(marketDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");

		}

		int articleCnt = dao.getCountTotalMarketApplyList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberMarketApplyList", dao.getTotalMarketApplyList(info));
		map.put("stateCount", dao.getMarketApplyState());

		return map;
	}

}