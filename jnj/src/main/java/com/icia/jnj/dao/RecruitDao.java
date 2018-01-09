package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.cglib.core.ObjectSwitchCallback;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class RecruitDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	
	
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	// 봉사
	
	public int getVolunteerCount() {
		return tpl.selectOne("volunteerMapper.getVolunteerCount");
	}
	//a
	
	public List<Volunteer> getAllPageVolunteer(int startArticleNum, int endArticleNum ) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("volunteerMapper.getAllPageVolunteer", map);
	}
	
	public List<Map<String, Object>> getSortAllVolunteer(String colName, String sortType, String search, int startArticleNum, int endArticleNum ) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		System.out.println("colName는"+ colName);
		map.put("sortType", sortType);
		System.out.println("sortType는"+ sortType);
		map.put("search", search);
		System.out.println("search는"+ search);
		map.put("startArticleNum", startArticleNum);
		System.out.println("startArticleNum는"+ startArticleNum);
		map.put("endArticleNum", endArticleNum);
		System.out.println("endArticleNum는"+ endArticleNum);
		return tpl.selectList("volunteerMapper.getSortAllVolunteer", map);
	}
	public void increaseVolunteerhits(int volunteerNo) {
		tpl.selectOne("volunteerMapper.increaseVolunteerhits",volunteerNo);
	}
	
	public void insertVolunteer( Volunteer volunteer ) {
		tpl.insert("volunteerMapper.insertVolunteer", volunteer);
	}
	
	public void updateVolunteer( Volunteer volunteer ) {
		tpl.update("volunteerMapper.updateVolunteer", volunteer);
	}
	
	public void deleteVolunteer( int volunteerNo ) {
		tpl.delete("volunteerMapper.deleteVolunteer", volunteerNo);
	}
	
	public List<VolunteerComment> getAllVolunteerComment() {
		return tpl.selectList("volunteerMapper.getAllVolunteerComment");
	}
	
	public List<VolunteerComment> getAllPageVolunteerComment(int startArticleNum, int endArticleNum ) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("volunteerMapper.getAllPageVolunteerComment", map);
	}
	
	public void insertVolunteerComment(VolunteerComment volunteerComment) {
		tpl.insert("volunteerMapper.insertVolunteerComment", volunteerComment);
	}
	
	public int updateVolunteerComment(VolunteerComment volunteerComment) {
		return tpl.insert("volunteerMapper.updateVolunteerComment", volunteerComment);
	}
	
	public int deleteVolunteerComment(int volunteerNo, int volunteerCommentNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("volunteerCommentNo", volunteerCommentNo);
		return tpl.delete("volunteerMapper.deleteVolunteerComment", map);
	}
	
	public List<VolunteerApply> getAllVolunteerApply(int volunteerNo){
		return tpl.selectList("volunteerMapper.getAllVolunteerApply", volunteerNo);
	}
	
	public List<VolunteerApply> getAllPageVolunteerApply(int startArticleNum, int endArticleNum ) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("volunteerMapper.getAllPageVolunteerApply",map);
	}
	
	public void insertVolunteerApply(VolunteerApply volunteerApply) {
		tpl.insert("volunteerMapper.insertVolunteerApply",volunteerApply);
	}
	
	public int deleteVolunteerApply(int volunteerNo, String memberId ) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("memberId", memberId);
		return tpl.delete("volunteerMapper.deleteVolunteerApply",map);
	}
	
	// ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ창재님꺼
	public int getVolunteerNumOfCenter(String centerId) {
		return tpl.selectOne("volunteerMapper.getVolunteerNumOfCenter", centerId);
	}

	public List<Volunteer> getVolunteerRecordOfCenter(int startArticleNum, int endArticleNum, String centerId, int sort) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("centerId", centerId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		String sortS="volunteer_no desc";
		if(sort==2)
			sortS="volunteer_date, volunteer_no desc";
		else if(sort==3)
			sortS="volunteerState, detailState";
		map.put("sort", sortS);
		return tpl.selectList("volunteerMapper.getVolunteerRecordOfCenter", map);
	}

	public int getVolunteerApplyNum(int volunteerNo) {
		return tpl.selectOne("volunteerMapper.getVolunteerApplyNum", volunteerNo);
	}

	public List<VolunteerApply> getVolunteerApplyRecord(int startArticleNum, int endArticleNum, int volunteerNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("volunteerMapper.getVolunteerApplyRecord", map);
	}
	
	public int getMaxVolunteerNo() {
		return tpl.selectOne("volunteerMapper.getMaxVolunteerNo");
	}
	
	
	// 20171209ㅋ
	// 박주리가 사용 하고 있는 함수
	// 해당 멤버 봉사(작성) 내역 총 개수( 검색, 필터 )
	public int getCountMemberVolunteerList(AdMVolunteerInfo info) {
		if (info.getType() == 1)
			return tpl.selectOne("volunteerMapper.getCountMemberVolunteerList", info);
		else
			return tpl.selectOne("volunteerMapper.getCountMemberVolunteerListApply", info);
	}

	public int getCountCenterVolunteerList(AdMVolunteerInfo info) {
		return tpl.selectOne("volunteerMapper.getCountMemberVolunteerList", info); // 일반, 센터 공용으로 씁니다.
	}

	// 해당 멤버 봉사(작성) 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<Volunteer> getMemberVolunteerList(AdMVolunteerInfo info) {

		if (info.getType() == 1)
			return tpl.selectList("volunteerMapper.getMemberVolunteerList", info);
		else
			return tpl.selectList("volunteerMapper.getMemberVolunteerListApply", info);

	}

	public List<Volunteer> getCenterVolunteerList(AdMVolunteerInfo info) {
		return tpl.selectList("volunteerMapper.getMemberVolunteerList", info); // 일반, 센터 공용으로 씁니다.
	}

	// 봉사글에 해당하는 신청자들 신청 상태를 한번에 업데이트
	public int updateAllVolunteerApply(int volunteerNo, int volunteerApplyState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("volunteerApplyState", volunteerApplyState);
		return tpl.update("volunteerMapper.updateAllVolunteerApply", map);
	}

	// 봉사글에 해당하는 신청자 신청 상태를 업데이트
	public int updateVolunteerApply(int volunteerNo, String memberId, int volunteerApplyState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("memberId", memberId);
		map.put("volunteerApplyState", volunteerApplyState);
		return tpl.update("volunteerMapper.updateVolunteerApply", map);
	}

	// 봉사글에 해당하는 신청자들 한번에 삭제
	public int deleteAllVolunteerApply(int volunteerNo) {
		return tpl.delete("volunteerMapper.deleteAllVolunteerApply", volunteerNo);
	}

	// 봉사글에 해당하는 댓글을 전부 삭제해 버린다.
	public int deleteAllVolunteerComment(int volunteerNo) {
		return tpl.delete("volunteerMapper.deleteAllVolunteerComment", volunteerNo);
	}

	// 봉사글 정보 가져오기
	public Volunteer getVolunteer(int volunteerNo) {
		return tpl.selectOne("volunteerMapper.getVolunteer", volunteerNo);
	}

	// 봉사 신청자 수 업데이트
	public void updateVolunteerApplyPeople(int volunteerNo, String num) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("num", num);
		tpl.update("volunteerMapper.updateVolunteerApplyPeople", map);
	}

	// 프리마켓 글 수 가져오기
	public int getCountMemberMarketList(AdMMarketInfo info) {
		return tpl.selectOne("marketMapper.getAdminCountMemberMarketList", info);
	}

	// 해당 멤버 입양 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<AdMMarketRecord> getMemberMarketList(AdMMarketInfo info) {
		return tpl.selectList("marketMapper.getAdminMemberMarketList", info);
	}

	// 프리마켓 신청자 수 업데이트
	public void updateMarketApplyPeople(int marketNo, String num) {
		System.out.println("=========================================");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("marketNo", marketNo);
		map.put("num", num);
		tpl.update("marketMapper.updateMarketApplyPeople", map);
	}

	// 프리마켓에 해당하는 신청자 신청 상태를 업데이트
	public int updateMarketApply(int marketNo, String memberId, int marketApplyState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("marketNo", marketNo);
		map.put("memberId", memberId);
		map.put("marketApplyState", marketApplyState);
		return tpl.update("marketMapper.updateMarketApply", map);
	}

	// 봉사 댓글 리스트 수
	public int getCountMemberVolunteerCommentList(AdMVolunteerCommentInfo info) {
		return tpl.selectOne("volunteerMapper.getCountMemberVolunteerCommentList", info);
	}

	// 봉사 댓글 리스트
	public List<VolunteerComment> getMemberVolunteerCommentList(AdMVolunteerCommentInfo info) {
		return tpl.selectList("volunteerMapper.getMemberVolunteerCommentList", info);
	}

	// 마켓 댓글 리스트 수
	public int getCountMemberMarketCommentList(AdMMarketCommentInfo info) {
		return tpl.selectOne("marketMapper.getCountMemberMarketCommentList", info);
	}

	// 마켓 댓글 리스트
	public List<MarketComment> getMemberMarketCommentList(AdMMarketCommentInfo info) {
		return tpl.selectList("marketMapper.getMemberMarketCommentList", info);
	}

	// 마켓 전체 리스트 수
	public int getCountTotalMarketList(AdMarketInfo info) {
		return tpl.selectOne("marketMapper.getCountTotalMarketList", info);
	}

	// 마켓 전체 리스트
	public List<Market> getTotalMarketList(AdMarketInfo info) {
		return tpl.selectList("marketMapper.getTotalMarketList", info);
	}

	// 마켓 전체 신청자 전체 리스트 수
	public int getCountTotalMarketApplyList(AdMarketApplyInfo info) {
		return tpl.selectOne("marketMapper.getCountTotalMarketApplyList", info);
	}

	// 마켓 전체 신청자 리스트
	public List<MarketApply> getTotalMarketApplyList(AdMarketApplyInfo info) {
		return tpl.selectList("marketMapper.getTotalMarketApplyList", info);
	}

	// 봉사글 상태 업데이트
	public void updateVolunteerState(int volunteerNo, int volunteerState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("volunteerNo", volunteerNo);
		map.put("volunteerState", volunteerState);
		tpl.update("volunteerMapper.updateVolunteerState", map);
	}

	// 봉사 글 신고수 초기화
	public void decreaseReportCnt(int volunteerNo) {
		tpl.update("volunteerMapper.decreaseReportCnt", volunteerNo);
	}

	// 회원의 각 봉사 기본 상태 별 개수
	public List<Map<String, Object>> getTotalVolunteerState(String hostId) {
		return tpl.selectList("volunteerMapper.getTotalVolunteerState", hostId);
	}

	// 회원의 각 봉사 상세 상태 별 개수
	public List<Map<String, Object>> getTotalDetailState(String hostId) {
		return tpl.selectList("volunteerMapper.getTotalDetailState", hostId);
	}

	// 회원의 각 봉사 참여 상세 상태 별 개수
	public List<Map<String, Object>> getMemberTotalVolunteerApplyState(String memberId) {
		return tpl.selectList("volunteerMapper.getMemberTotalVolunteerApplyState", memberId);
	}

	// 회원의 각 마켓 참여 상세 상태 별 개수
	public List<Map<String, Object>> getMemberTotalMarketApplyState(String memberId) {
		return tpl.selectList("marketMapper.getMemberTotalMarketApplyState", memberId);
	}

	public List<Map<String, Object>> getTotalMarketApplyState() {
		return tpl.selectList("marketMapper.getTotalMarketApplyState");
	}
	
	public List<Map<String,Integer>> getMarketApplyState() {
		return tpl.selectList("marketMapper.getMarketApplyState");
	}
	
	
	/*혜미혜미혜미혜미혜미혜미혜미혜미*/
	//마이페이지 봉사 내역ㅇ0ㅇ...
	public List<Map<String, Object>> getMypageMemberVolunteerAllList(String memberId, int startArticleNum, int endArticleNum){
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("memberId", memberId);
		return tpl.selectList("volunteerMapper.getMypageMemberVolunteerAllList",map);
	}
	//마이페이지 봉사 내역 개수ㅇ0ㅇ...!
	public int getMypageMemberVolunteerCount(String memberId) {
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("memberId", memberId);
		return tpl.selectOne("volunteerMapper.getMypageMemberVolunteerCount",map);
	}
	//마이페이지 봉사 내역 모집 필터ㅇㅅㅇ..
	public List<Map<String, Object>> getMypageMemberVolunteerHostMe(String memberId, int startArticleNum, int endArticleNum){
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("memberId", memberId);
		return tpl.selectList("volunteerMapper.getMypageMemberVolunteerHostMe",map);
	}
	//마이페이지 봉사 내역 모집 필터 글 개수 가져오기,,
	public int getMypageMemberVolunteerHostMeCount(String memberId) {
		return tpl.selectOne("volunteerMapper.getMypageMemberVolunteerHostMeCount",memberId);
	}
	//마이페이지 봉사 내역 참여 필터..시벌탱..또있어..
	public List<Map<String, Object>> getMypageMemberVolunteerJoin(String memberId, int startArticleNum, int endArticleNum){
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("memberId", memberId);
		return tpl.selectList("volunteerMapper.getMypageMemberVolunteerJoin",map);
	}
	//마이페이지 봉사 내역 참여 필터 글 개수 가져오기,,
		public int getMypageMemberVolunteerJoinCount(String memberId) {
			return tpl.selectOne("volunteerMapper.getMypageMemberVolunteerJoinCount",memberId);
		}
	//마이페이지 봉사 내역 참가자 목록보여주기...언제끝남..ㅜ
	public List<Map<String, Object>> getMypageMemberVolunteerList(int volunteerNo, int startArticleNum, int endArticleNum){
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("volunteerNo", volunteerNo);
		return tpl.selectList("volunteerMapper.getMypageMemberVolunteerList",map);
	}
	//마이페이지 봉사 내역 hostId 가져오기 가져와서 호스트아이디가 나라면 안띄워
	/*public String getMypageVolunteerHostId(int volunteerNo) {
		return tpl.selectOne("volunteerMapper.getMypageVolunteerHostId", volunteerNo);
	}*/
	//마이페이지 봉사 참가자 목록 개수 가져오기
	public int getMypageMemberVolunteerListCount(int volunteerNo) {
		return tpl.selectOne("volunteerMapper.getMypageMemberVolunteerListCount",volunteerNo);
	}
	
	//마이페이지 봉사 내역에서 봉사 신청자 거절했을때 신청자의 상태를 update..끝이당...
	public void updateMemberVolunteerApplyState(String memberId, int volunteerNo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("memberId", memberId);
		map.put("volunteerNo", volunteerNo);
		tpl.update("volunteerMapper.updateMemberVolunteerApplyState",map);
	}
	
	
	
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	//=================================================================================================================
	// 프리마켓
	
	public int getMarketCount() {
		return tpl.selectOne("marketMapper.getMarketCount");
	}
	public List<Market> getAllMarket(){
		return tpl.selectList("marketMapper.getAllMarket");
	}
	public List<Market> getAllPageMarket(int startArticleNum, int endArticleNum ) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("marketMapper.getAllPageMarket", map);
	}
	public Market getMarket(int marketNo){
		return tpl.selectOne("marketMapper.getMarket",marketNo);
	}
	public void insertMarket(Market market){
		tpl.insert("marketMapper.insertMarket",market);
	}
	public void deleteMarket(int marketNo) {
		tpl.delete("marketMapper.deleteMarket",marketNo);
	}
	public void updateMarket(Market market) {
		tpl.update("marketMapper.updateMarket",market);
	}
	public void increasehits(int marketNo) {
		tpl.update("marketMapper.increasehits",marketNo);
	}
	public void increaseApplyPeople(MarketApply marketApply) {
		tpl.update("marketMapper.increaseApplyPeople",marketApply);
	}
	public void decreaseApplyPeople(MarketApply marketApply) {
		tpl.update("marketMapper.decreaseApplyPeople",marketApply);
	}
	
	public int marketCommnetCount(int marketNo) {
		return tpl.selectOne("marketMapper.marketCommentCount",marketNo);
	}
	
	
	/*마켓 댓글*/
	public int getMarketCommentCount() {
		return tpl.selectOne("marketMapper.getMarketCommentCount");
	}
	public List<MarketComment> getAllMarketComment(){
		return tpl.selectList("marketMapper.getAllMarketComment");
	}
	public List<MarketComment> getAllPageMarketComment(int startArticleNum, int endArticleNum){
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("marketMapper.getAllPageMarketComment", map);
	}
	public List<MarketComment> getMarketComment(int marketNo){
		return tpl.selectList("marketMapper.getMarketComment",marketNo);
	}
	public void insertMarketComment(MarketComment marketComment) {
		tpl.insert("marketMapper.insertMarketComment",marketComment);
	}
	public void deleteAllMarketComment(int marketNo) {
		tpl.delete("marketMapper.deleteAllMarketComment",marketNo);
	}
	public int updateMarketComment(MarketComment marketComment) {
		return tpl.update("marketMapper.updateMarketComment",marketComment);
	}
	public int deleteMarketComment(int marketNo, int marketCommentNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("marketNo", marketNo);
		map.put("marketCommentNo", marketCommentNo);
		return tpl.delete("marketMapper.deleteMarketComment",map);
	}
	public void increaseReplyCnt(int marketNo) {
		tpl.update("marketMapper.increaseReplyCnt",marketNo);
	}
	public List<MarketComment> readReply(int marketNo) {
		return tpl.selectList("marketMapper.readReply", marketNo);
	}
	
	
	/* 마켓 신청 */
	public List<MarketApply> getAllMarketApply(){
		return tpl.selectList("marketMapper.getAllMarketApply");
	}
	public List<MarketApply> getMarketApplyList(int marketNo){
		return tpl.selectList("marketMapper.getMarketApplyList",marketNo);
	}
	public List<MarketApply> getAllPageMarketApply(int startArticleNum, int endArticleNum ){
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum",startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("marketMapper.getAllPageMarketApply",map);
	}
	public void insertMarketApply(MarketApply marketApply) {
		tpl.insert("marketMapper.insertMarketApply",marketApply);
	}
	public int deleteMarketApply(Integer marketNo, String memberId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("marketNo", marketNo);
		map.put("memberId", memberId);
		return tpl.delete("marketMapper.deleteMarketApply",map);
	}
	public List<MarketComment> listRecentReply(int marketNo) {
		return tpl.selectList("marketMapper.listRecentReply",marketNo);
	}
	public void deleteAllMarketApply(int marketNo) {
		tpl.delete("marketMapper.deleteAllMarketApply",marketNo);
	}
	
	
	// 수현
	// 일반회원 프리마켓 리스트
	public List<Map<String, Object>> getMemberMarketList(String memberId, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberId", memberId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("marketMapper.getMemberMarketList", map);
	}
		
	// 일반회원 프리마켓 리스트 개수
	public int getgetMemberMarketCnt(String memberId) {
		return tpl.selectOne("marketMapper.getgetMemberMarketCnt", memberId);
	}
	
	
	///////////////////////////////////////////// 치우
	public List<VolunteerComment> getVolunteerComment(int volunteerNo) {
		return tpl.selectList("volunteerMapper.getVolunteerComment",volunteerNo);
	}
	public List<VolunteerApply> getVolunteerApplyList(int volunteerNo) {
		return tpl.selectList("volunteerMapper.getVolunteerApplyList",volunteerNo);
	}
	public List<VolunteerComment> readVolunteerReply(Integer volunteerNo) {
		return tpl.selectList("volunteerMapper.readVolunteerReply", volunteerNo);
	}
	public void increaseVolunteerApplyPeople(VolunteerApply volunteerApply) {
		tpl.update("volunteerMapper.increaseVolunteerApplyPeople",volunteerApply);
		
	}
	public void decreaseVolunteerApplyPeople(int volunteerNo) {
		tpl.update("volunteerMapper.decreaseVolunteerApplyPeople",volunteerNo);
		
	}
	public void increasehitsVolunteer(int volunteerNo) {
		tpl.update("volunteerMapper.increasehitsVolunteer",volunteerNo);
		
	} 
	public int getBoothNum(int marketNo, String memberId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("marketNo", marketNo);
		map.put("memberId", memberId);
		return tpl.selectOne("marketMapper.getBoothNum",map);
	}
	public int getMarketSearchCnt(String keyword) {
		return tpl.selectOne("marketMapper.getMarketSearchCnt",keyword);
	}
	public int getCountMemberVolunteerListApply(String memberId) {
		return tpl.selectOne("volunteerMapper.getCountMemberVolunteerListApply",memberId);
	}
	public Object getMemberVolunteerListApply(String colName, String sortType, Integer startArticleNum, Integer endArticleNum, String memberId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName",colName);
		System.out.println(colName);
		map.put("sortType",sortType);
		System.out.println(sortType);
		map.put("startArticleNum",startArticleNum);
		System.out.println(startArticleNum);
		map.put("endArticleNum",endArticleNum);
		System.out.println(endArticleNum);
		map.put("memberId",memberId);
		System.out.println(memberId);
		return tpl.selectList("volunteerMapper.getMemberVolunteerListApply",map);
	}
	
	public int getSearchCountVolunteer(String colName, String search) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("colName",colName);
		map.put("search", search);
		return tpl.selectOne( "volunteerMapper.getSearchCountVolunteer", map );
	}
	public List<Member> getSearchAllPageVolunteer(String colName, Integer startArticleNum, Integer endArticleNum, String search) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		map.put("search", search);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList( "volunteerMapper.getSearchAllPageVolunteer", map );
	}
	public int getSortCountVolunteer(String search) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("search", search);
		return tpl.selectOne("volunteerMapper.getSortCountVolunteer", map);
	}

	public void increaseReportCnt(int volunteerNo) {
		tpl.update("volunteerMapper.increaseReportCnt", volunteerNo);	
		
	}

	public int getReportCnt(int volunteerNo) {
		return tpl.selectOne("volunteerMapper.getReportCnt", volunteerNo);
	}

	public MarketApply marketPay(String memberId, int marketNo) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("memberId",memberId);
		map.put("marketNo", marketNo);
		return tpl.selectOne("marketMapper.marketPay",map);
	}
	public int deleteMarketCommentApply(int marketNo, String writeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writeId", writeId);
		map.put("marketNo", marketNo);
		return tpl.delete("marketMapper.deleteMarketCommentApply",map);
	}
	
	
	
	
	// 수현
	// 탈퇴를 위한 봉사모집 취소상태로 변경
	public int updateVolunteerStateForResign(String hostId) {
		return tpl.update("volunteerMapper.updateVolunteerStateForResign", hostId);	
	}
	
	// 탈퇴를 위한 봉사모집 신청자 거절
	public int deleteVolunteerCancleForResign(String hostId) {
		return tpl.delete("volunteerMapper.deleteVolunteerCancleForResign", hostId);	
	}
	
    // 탈퇴를 위한 봉사참가신청 취소
	public int deleteVolunteerApplyForResign(String memberId) {
		return tpl.delete("volunteerMapper.deleteVolunteerApplyForResign", memberId);
	}
	
	//탈퇴를 위한 프리마켓 참가 취소
	public int deleteMarketApplyForResign(String memberId) {
		return tpl.delete("marketMapper.deleteMarketApplyForResign", memberId);
	}


	
}
