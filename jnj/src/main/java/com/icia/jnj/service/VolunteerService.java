package com.icia.jnj.service;

import java.security.Principal;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.JsonElement;
import com.icia.jnj.constant.*;
import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class VolunteerService {

	@Autowired
	private RecruitDao dao;
	
	@Autowired
	private MemberDao mDao;
	
	/*혜미혜미혜미혜미혜미혜미혜미혜미혜미혜미*/
	//마이페이지 봉사 내역 ><
	public Map<String, Object> getMypageMemberVolunteerAllList(String memberId, int pageno){
		int articleCnt = dao.getMypageMemberVolunteerCount(memberId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("getMypageMemberVolunteerAllList", dao.getMypageMemberVolunteerAllList(memberId, pagination.getStartArticleNum(),pagination.getEndArticleNum()));
		map.put("pagination",pagination);
		return map;
	}
	//마이페이지 봉사 내역 모집 필터 ><
	public Map<String, Object> getMypageMemberVolunteerHostMe(String memberId, int pageno){
		int articleCnt = dao.getMypageMemberVolunteerHostMeCount(memberId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("getMypageMemberVolunteerAllList", dao.getMypageMemberVolunteerHostMe(memberId, pagination.getStartArticleNum(),pagination.getEndArticleNum()));
		map.put("pagination",pagination);
		return map;
	}
	//마이페이지 봉사 내역 참여 필터 ><
	public Map<String, Object> getMypageMemberVolunteerJoin(String memberId, int pageno){
		int articleCnt = dao.getMypageMemberVolunteerJoinCount(memberId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("getMypageMemberVolunteerAllList", dao.getMypageMemberVolunteerJoin(memberId, pagination.getStartArticleNum(),pagination.getEndArticleNum()));
		map.put("pagination",pagination);
		return map;
	}
	
	
	//마이페이지 봉사 참가자 목록 보여주기 >//<
	public Map<String, Object> getMypageMemberVolunteerList( int volunteerNo, int pageno ){
		
		int articleCnt = dao.getMypageMemberVolunteerListCount(volunteerNo);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("getMypageMemberVolunteerList", dao.getMypageMemberVolunteerList(volunteerNo, pagination.getStartArticleNum(),pagination.getEndArticleNum()));
		map.put("pagination", pagination);
		
		return map;
	}
	
	//마이페이지 봉사 내역에서 신청자 거절시 신청자 상태 update >, <
	public VolunteerApply updateMemberVolunteerApplyState(VolunteerApply volunteerApply) {
		/*VolunteerComment volunteerComment = new VolunteerComment();
		volunteerComment.setVolunteerNo(volunteerApply.getVolunteerNo());
		dao.deleteVolunteerCommentApply(volunteerComment.getVolunteerNo(),"-----");*/
		
		dao.updateMemberVolunteerApplyState(volunteerApply.getMemberId(),volunteerApply.getVolunteerNo());
		dao.decreaseVolunteerApplyPeople(volunteerApply.getVolunteerNo());
		return volunteerApply;
	}
	
	
	// 주리
	// ==============================================================================================
	// 해당 회원 봉사(작성) 내역 리스트 조회( 페이지네이션, 정렬, 검색 )
	public Map<String, Object> getMemberVolunteerList(AdMVolunteerInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("volunteerTitle"))
				info.setSqlText("where volunteerTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("hostId"))
				info.setSqlText("where hostId like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("volunteerArea"))
				info.setSqlText("where volunteerTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("volunteerState")) {
				if (info.getType() == 1) {
					if (info.getSearchText().equals("1-1")) // 모집중
						info.setSqlText("where volunteerState like '%1%' and detailState like '%1%'");
					else if (info.getSearchText().equals("1-2")) // 모집완료
						info.setSqlText("where volunteerState like '%1%' and detailState like '%2%'");
					else if (info.getSearchText().equals("1-3")) // 봉사완료
						info.setSqlText("where volunteerState like '%1%' and detailState like '%3%'");
					else if (info.getSearchText().equals("1-4")) // 인원미달
						info.setSqlText("where volunteerState like '%1%' and detailState like '%4%'");
					else if (info.getSearchText().equals("2")) // 취소
						info.setSqlText("where volunteerState like '%2%'");
					else if (info.getSearchText().equals("3")) // 블락
						info.setSqlText("where volunteerState like '%3%'");
				} else {
					if (info.getSearchText().equals("0"))
						info.setSqlText("where volunteerApplyState like '%0%'");
					else if (info.getSearchText().equals("1"))
						info.setSqlText("where volunteerApplyState like '%1%'");
					else if (info.getSearchText().equals("2"))
						info.setSqlText("where volunteerApplyState like '%%'");
				}
			}
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountMemberVolunteerList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberVolunteerList", dao.getMemberVolunteerList(info));

		// 각각 상태별로 몇건인지 가져오기
		if (info.getType() == 1) { // 모집내역일때
			map.put("totalVolunteerState", dao.getTotalVolunteerState(info.getHostId()));
			map.put("totalDetailState", dao.getTotalDetailState(info.getHostId()));
		} else // 참여내역일때
			map.put("totalApplyState", dao.getMemberTotalVolunteerApplyState(info.getMemberId()));

		return map;
	}

	public Map<String, Object> getCenterVolunteerList(AdMVolunteerInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("volunteerTitle"))
				info.setSqlText("where volunteerTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("hostId"))
				info.setSqlText("where hostId like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("volunteerArea"))
				info.setSqlText("where volunteerTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("volunteerState")) {
				if (info.getType() == 1) {
					if (info.getSearchText().equals("1-1")) // 모집중
						info.setSqlText("where volunteerState like '%1%' and detailState like '%1%'");
					else if (info.getSearchText().equals("1-2")) // 모집완료
						info.setSqlText("where volunteerState like '%1%' and detailState like '%2%'");
					else if (info.getSearchText().equals("1-3")) // 봉사완료
						info.setSqlText("where volunteerState like '%1%' and detailState like '%3%'");
					else if (info.getSearchText().equals("1-4")) // 인원미달
						info.setSqlText("where volunteerState like '%1%' and detailState like '%4%'");
					else if (info.getSearchText().equals("2")) // 취소
						info.setSqlText("where volunteerState like '%2%'");
					else if (info.getSearchText().equals("3")) // 블락
						info.setSqlText("where volunteerState like '%3%'");
				} else {
					if (info.getSearchText().equals("0"))
						info.setSqlText("where volunteerApplyState like '%0%'");
					else if (info.getSearchText().equals("1"))
						info.setSqlText("where volunteerApplyState like '%1%'");
					else if (info.getSearchText().equals("2"))
						info.setSqlText("where volunteerApplyState like '%%'");
				}
			}
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountCenterVolunteerList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("centerVolunteerList", dao.getCenterVolunteerList(info));

		// 각각 상태별로 몇건인지 가져오기
		map.put("totalVolunteerState", dao.getTotalVolunteerState(info.getHostId()));
		map.put("totalDetailState", dao.getTotalDetailState(info.getHostId()));

		return map;
	}

	/*
	 * public Map<String, Object> getMypageCenterVolunteerList( int volunteerNo, int
	 * pageno ){ int articleCnt =
	 * dao.getMypageCenterVolunteerListCount(volunteerNo); Pagination pagination =
	 * PagingUtil.setPageMaker(pageno, articleCnt, 10); Map<String, Object> map=new
	 * HashMap<String, Object>(); map.put("getMypageCenterVolunteerList",
	 * dao.getMypageCenterVolunteerList(volunteerNo,
	 * pagination.getStartArticleNum(),pagination.getEndArticleNum()));
	 * map.put("pagination", pagination); return map; }
	 */

	public void updateVolunteerApplyState(int volunteerNo, String memberId, int volunteerApplyState, String num) {

		// 봉사글에 신청 인원수를 줄인다.
		dao.updateVolunteerApplyPeople(volunteerNo, num);
		// 봉사 신청 상태를 취소로 만든다.
		dao.updateVolunteerApply(volunteerNo, memberId, volunteerApplyState);
	}

	// 해당 봉사 글 삭제 시
	public void getVolunteerDelete(int volunteerNo) {
		// 해당 글 번호에 해당하는 신청자들 전부 삭제하기.
		dao.deleteAllVolunteerApply(volunteerNo);
		dao.deleteAllVolunteerComment(volunteerNo); // 댓글 전부 지우고
		dao.deleteVolunteer(volunteerNo); // 해당 글 삭제하기
	}

	// 봉사 댓글 리스트 보기
	public Map<String, Object> getMemberVolunteerCommentList(AdMVolunteerCommentInfo info) {

		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("volunteerTitle"))
				info.setSqlText("where volunteerTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("commentContent"))
				info.setSqlText("where commentContent like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("volunteerArea"))
				info.setSqlText("where volunteerTitle like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountMemberVolunteerCommentList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberVolunteerCommentList", dao.getMemberVolunteerCommentList(info));

		return map;
	}

	/*
	 * // 봉사 댓글 리스트 보기 public Map<String, Object>
	 * getCenterVolunteerCommentList(AdMVolunteerCommentInfo info) {
	 * 
	 * info.setSqlText(""); if (!info.getSearchText().equals("%")) { if
	 * (info.getSearchColName().equals("volunteerTitle"))
	 * info.setSqlText("where volunteerTitle like '%" + info.getSearchText() +
	 * "%'");
	 * 
	 * else if (info.getSearchColName().equals("commentContent"))
	 * info.setSqlText("where commentContent like '%" + info.getSearchText() +
	 * "%'");
	 * 
	 * else if (info.getSearchColName().equals("volunteerArea"))
	 * info.setSqlText("where volunteerTitle like '%" + info.getSearchText() +
	 * "%'"); } else { if (info.getSearchColName().equals("writeDate"))
	 * info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" +
	 * info.getStartDate() +
	 * ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" +
	 * info.getEndDate() + ", 'yyyyMMdd')"); }
	 * 
	 * int articleCnt = dao.getCountCenterVolunteerCommentList(info);
	 * 
	 * Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt,
	 * 10);
	 * 
	 * info.setStartArticleNum(pagination.getStartArticleNum());
	 * info.setEndArticleNum(pagination.getEndArticleNum());
	 * 
	 * Map<String, Object> map = new HashMap<String, Object>();
	 * 
	 * map.put("pagination", pagination); map.put("centerVolunteerCommentList",
	 * dao.getCenterVolunteerCommentList(info));
	 * 
	 * return map; }
	 */

	public void decreaseReportCnt(int volunteerNo) {
		dao.decreaseReportCnt(volunteerNo);
	}
	
		
	///////////////////////////////////////////////////////////// 치우
	// 봉사글 정보 가져오기
	public Volunteer getVolunteer( int volunteerNo ) {
		return dao.getVolunteer(volunteerNo);
	}
	
	// 봉사 리스트 보기!!
	public Map<String, Object> listVolunteer(int pageno, String colName, String sortType,String search) {
		Map<String, Object> map = new HashMap<String, Object>();
		
			int articleCnt = dao.getVolunteerCount();
			Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
			map.put("pagination", pagination);
			map.put("list", dao.getAllPageVolunteer(pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		
		return map;
	}
	
	// 봉사 글 쓰기
	public void insertVolunteer(Volunteer volunteer) {
		volunteer.setVolunteerDivision(1);	//센터주최
		volunteer.setApplyPeople(0);	// 신청인원 0으로 설정
		if(mDao.isMember(volunteer)==1) {	//member 테이블 안에 hostId가 있으면
			volunteer.setVolunteerDivision(2);	//회원주최
			volunteer.setApplyPeople(1);	// 신청인원 1으로 설정(자신 포함)
		}
		dao.insertVolunteer(volunteer);
		if(volunteer.getVolunteerDivision()==2) {		// 주최자가 member일 경우
			VolunteerApply va = new VolunteerApply();		// 신청자 명단에 주최자 자신을 추가
			va.setVolunteerNo(dao.getMaxVolunteerNo());
			va.setMemberId(volunteer.getHostId());
			va.setApplyTel(volunteer.getHostTel());
			dao.insertVolunteerApply(va);
		}
	}
	
	// 봉사 뷰 화면
	@PreAuthorize("isAuthenticated()")
	public Map<String, Object> viewVolunteer(int volunteerNo, String id ) {
		
		List<VolunteerComment> volunteerComment = dao.getVolunteerComment(volunteerNo);
		List<VolunteerApply> volunteerApply = dao.getVolunteerApplyList(volunteerNo);
		
		// 관리자가 뷰를 볼때는 조회수를 올리지 않도록 한다
		if( !id.equals("admin") )
			dao.increasehitsVolunteer(volunteerNo);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteer", dao.getVolunteer(volunteerNo));
		map.put("volunteerComment", volunteerComment);
		map.put("volunteerApply", volunteerApply);
		
		return map;
	}
	
	// 봉사 글 삭제 
	public void deleteVolunteer(Volunteer volunteer) {
		List<VolunteerApply> volunteerApply = dao.getVolunteerApplyList(volunteer.getVolunteerNo());
		
		// 쪽지 보내기
		
		
		// 신청삭제 
		dao.deleteAllVolunteerApply(volunteer.getVolunteerNo());
		// 댓글 삭제
		dao.deleteAllVolunteerComment(volunteer.getVolunteerNo());
		// 봉사 글 삭제
		dao.deleteVolunteer(volunteer.getVolunteerNo());
		
	}
	
	
	// 봉사 글 수정
	public void updateVolunteer(Volunteer volunteer) {
		dao.updateVolunteer(volunteer);
	}	
	
	
	// 봉사 글 댓글 작성
	public List<VolunteerComment> insertVolunteerComment(VolunteerComment volunteerComment) {
		dao.insertVolunteerComment(volunteerComment);
		return dao.readVolunteerReply(volunteerComment.getVolunteerNo());
	}
	
	
	// 봉사 글 댓글 뷰
	public List<VolunteerComment> viewVolunteerComment(int volunteerNo) {
		return dao.getVolunteerComment(volunteerNo);
	}
	
	
	
	
	
	// 봉사 글 댓글 수정
	public boolean updateVolunteerComment(VolunteerComment volunteerComment) {
		return dao.updateVolunteerComment(volunteerComment)==1? true:false;
	}
	
	// 봉사 글 댓글 삭제
	public boolean deleteVolunteerComment(VolunteerComment volunteerComment) {
		return dao.deleteVolunteerComment(volunteerComment.getVolunteerNo(), volunteerComment.getVolunteerCommentNo())==1? true: false;
	}
	
	// 봉사 신청 
	public void insertVolunteerApply(VolunteerApply volunteerApply) {
		volunteerApply.setApplyTel(volunteerApply.getTel1()+volunteerApply.getTel2());
		dao.insertVolunteerApply(volunteerApply);
		dao.increaseVolunteerApplyPeople(volunteerApply);
		
		VolunteerComment volunteerComment = new VolunteerComment();
		volunteerComment.setVolunteerNo(volunteerApply.getVolunteerNo());
		volunteerComment.setWriteId("-----");
		volunteerComment.setCommentContent(volunteerApply.getMemberId()+"님이 봉사를 신청하셨습니다");
		
		dao.insertVolunteerComment(volunteerComment);
	}
	
	
	public boolean deleteVolunteerApply(VolunteerApply volunteerApply) {
		
		VolunteerComment volunteerComment = new VolunteerComment();
		volunteerComment.setVolunteerNo(volunteerApply.getVolunteerNo());
		volunteerComment.setWriteId("-----");
		volunteerComment.setCommentContent(volunteerApply.getMemberId()+"님이 봉사를 취소하셨습니다");
		
		dao.insertVolunteerComment(volunteerComment);
		
		dao.decreaseVolunteerApplyPeople(volunteerApply.getVolunteerNo());
		return dao.deleteVolunteerApply(volunteerApply.getVolunteerNo(), volunteerApply.getMemberId())==1? true : false;
		
	}
	public Map<String, Object> getVolunteerSearch(int pageno,  String search, String colName, String sortType) {
		int articleCnt = 0;
		
		String sSearch = "'%"+search+"%'";
		
		if(search.equals("전체")) {
			sSearch="'%'";
		}
		
		articleCnt = dao.getSortCountVolunteer(sSearch);
		
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		map.put("sortType", sortType);
		map.put("search", search);
		
		map.put("pagination", pagination);
		map.put("getVolunteerSearch",dao.getSortAllVolunteer(colName, sortType, sSearch, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
	
	
	public int report(int volunteerNo) {
		System.out.println(volunteerNo);
		dao.increaseReportCnt(volunteerNo);
		System.out.println("개수:" + dao.getReportCnt(volunteerNo));
		return dao.getReportCnt(volunteerNo);
	}
	
	
	// 봉사 글 상태 바꾸기
	public void updateVolunteerState(int volunteerNo, int volunteerState) {
		dao.updateVolunteerState(volunteerNo, volunteerState);
	}
	
	
	
}
