package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class SponsorDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	
	// 0. 후원 전체 글갯수 가져오기
	public int getSponsorCount() {
		return tpl.selectOne("sponsorMapper.getSponsorCount");
	}
	
	// 0_1. 후원 필터 글갯수 가져오기
		public int getSponsorFilterCount(int petSort) {
			
			System.err.println(petSort);
			return tpl.selectOne("sponsorMapper.getSponsorFilterCount",petSort);
		}

	// 1_1.후원 리스트 전체
	public List<SponsorDomain> getAllSponsorList(int startArticleNum, int endArticleNum){
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum",endArticleNum);
		return tpl.selectList("sponsorMapper.getAllSponsorList",map);
	}
	
	
	// 1_2.후원 리스트: 필터 포함가져오기_펫정보+후원현황+센터정보 포함 전체 Domain 제작
	public List<SponsorDomain> getSponsorList(int petSort,int startArticleNum, int endArticleNum){
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("petSort", petSort);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum",endArticleNum);
		return tpl.selectList("sponsorMapper.getSponsorList",map);
	}
	
	// 2_1. 후원 뷰화면으로 이동: 내용
	public SponsorDomain getSponsorView(int petNo) {
		return tpl.selectOne("sponsorMapper.getSponsorView",petNo);
	}
	// 2_2. 후원 뷰 화면으로 이동: 사진
	public List<PetImg> getSponsorViewPicture(int petNo) {
		return tpl.selectList("sponsorMapper.getSponsorViewPicture",petNo);
	}
	
	
	
	
	// <결제 진행 순서>
	// 1. 현재 후원자의 memberSponsorNo 조회
	public int selectMemberSponsorNo( SponsorPayInfo spInfo ){
		// member_sponsor_record테이블에 접근해
		// pInfo에 들어 있는 memberId, petNo, sponsorNo로 memberSponsorNo를 조회해온다.
		// service단으로 가서 memberSponsorNo+1 해서 pInfo.memberSponsorNo에 셋팅!
		return tpl.selectOne( "sponsorMapper.selectMemberSponsorNo", spInfo );
	}
		
	// 2. 회원의 후원 내역에 등록하기
	public void insertMemberSponsorRecord( SponsorPayInfo spInfo ){
		// member_sponsor_record테이블에 접근해
		// pInfo에 들어 있는 memberId, petNo, sponsorNo, memberSponsorNo,
		// payWay, payMoney, depositor, 'sysdate', "후원합니다"를 insert!
		tpl.insert( "sponsorMapper.insertMemberSponsorRecord", spInfo );
	}
		
	// 3. 회원이 후원한 유기동물후원에 금액 올려주기
	public void updatePetSponsorMoney( SponsorPayInfo spInfo ){
		// 2번에서 회원이 최종적으로 후원을 했으니까 유기동물후원 테이블에도 후원 금액을 올려준다
		tpl.update( "sponsorMapper.updatePetSponsorMoney", spInfo );
	}
	
	// 3. 회원이 후원한 유기동물후원에 금액 달성날짜 바꿔주기
	public void updatePetSponsorAchieveDate( SponsorPayInfo spInfo ){
		// 2번에서 회원이 최종적으로 후원을 했으니까 유기동물후원 테이블에도 후원 금액을 올려준다
		tpl.update( "sponsorMapper.updatePetSponsorAchieveDate", spInfo );
	}
		
	// 우선 이 창이 문제 생겨서 제대로 동작하지 않을 때를 대비해 기본셋팅을 '후원합니다'로 잡아두기
	// 회원이 후원하고 난 다음 남기는 댓글 등록하기.
	public void updateMemberSponsorReply( SponsorPayInfo spInfo ) {
		// 다시 member_sponsor_record테이블에 접근해 사용자가 쓴 댓글을 업데이트하자
		tpl.update("sponsorMapper.updateMemberSponsorReply", spInfo);
	}
	
	
	// 덧글 전체 개수 가져오기
	public int getSponsorReplyCount(int petNo) {
		return tpl.selectOne("sponsorMapper.getSponsorReplyCount",petNo);
	}
	
	// 덧글 페이징 쿼리
	public List<MemberSponsorRecord> getAllSponsorReplyList(int petNo, int startArticleNum, int endArticleNum){
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("petNo", petNo);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum",endArticleNum);
		return tpl.selectList("sponsorMapper.getSponsorReplyList",map);
	} 
	
	
	// 후원 50만원 달성해서 후원번호 갱신해야 되는작업
	// 1. petSponsor 테이블에서 sponsor_no+1 인서트
	public void insertChangePetSponsor(SponsorPayInfo spInfo) {
		tpl.insert("sponsorMapper.insertChangePetSponsor",spInfo);
	}
	// 2.sponsor_no +1된 애들의 mercyDate+15로 업데이트
	public void updateMercyDate(SponsorPayInfo spInfo) {
		/*Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("petNo", petNo);
		map.put("petSponsor", sponsorNo);
		tpl.update("sponsorMapper.updateMercyDate",map);*/
		
		tpl.update("sponsorMapper.updateMercyDate",spInfo);
	}
	
	
	

	
	// 창재
	// 유기동물 후원 insert
	public void insertPetSponsor( PetSponsor pSponsor ) {
		tpl.insert("sponsorMapper.insertPetSponsor", pSponsor);
	}
	
	// 월별 후원내역의 총 월 수
	public int getMonthNum(String centerId) {
		return tpl.selectOne("sponsorMapper.getMonthNum", centerId);
	}
	
	// 월별 후원내역
	public List<CSponsorMonthlyRecord> getSponsorMonthlyRecord(int startArticleNum, int endArticleNum, String centerId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("centerId", centerId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum",endArticleNum);
		return tpl.selectList("sponsorMapper.getSponsorMonthlyRecord", map);
	}
	
	// 월 상세후원내역의 총 내역 수 (날짜-동물별)
	public int getSponsorDPNum(String centerId, String month) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("centerId", centerId);
		map.put("month", month);
		return tpl.selectOne("sponsorMapper.getSponsorDPNum", map);
	}
	
	// 월 상세후원내역
	public List<CSponsorDPRecord> getSponsorDPRecord(Integer startArticleNum, Integer endArticleNum, String centerId, String month) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("centerId", centerId);
		map.put("month", month);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum",endArticleNum);
		return tpl.selectList("sponsorMapper.getSponsorDPRecord", map);
	}
	
	
	/*혜미혜미혜미혜미혜미*/
	
	//마이페이지 후원 내역
	public List<Map<String, Object>> getMypageMemberSponsor(String colName, String sortType, int startArticleNum, int endArticleNum,String memberId){
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
		return tpl.selectList("sponsorMapper.getMypageMemberSponsor",map);
		
	}
	
	//마이페이지 후원 내역 개수
	public int getSponsorCountMypage(String memberId) {
		System.out.println("dao4");
		return tpl.selectOne("sponsorMapper.getSponsorCountMypage",memberId);
	}

	// 해당 멤버 후원 내역 가져오기( 페이지네이션 없고, 필터없고 )
	public List<MemberSponsorRecord> getMemberSponsorList(String memberId) {
		return tpl.selectList("sponsorMapper.getMemberSponsorList",memberId);
	}
	
	
	
	
	// 20171209ㅋ
	// 주리
	// ==============================================================================================
	// 해당 멤버 후원 내역 총 개수( 검색, 필터 )
	public int getCountMemberSponsorList(AdMSponsorInfo info) {
		return tpl.selectOne("sponsorMapper.getCountMemberSponsorList", info);
	}

	// 해당 멤버 후원 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<AdMSponsorRecord> getMemberSponsorList(AdMSponsorInfo info) {
		return tpl.selectList("sponsorMapper.getMemberSponsorList", info);
	}

	// 해당 멤버의 총 후원 가격
	public int getTotalMoneyMemberSponor(String memberId) {
		return tpl.selectOne("sponsorMapper.getTotalMoneyMemberSponor", memberId);
	}

	// 해당 센터의 총 후원 가격
	public int getTotalMoneyCenterSponor(String centerId) {
		return tpl.selectOne("sponsorMapper.getTotalMoneyCenterSponor", centerId);
	}

	// 센터의 동물 후원 받은 금액 내역 가져오기
	public int getCountCenterSponsorPetList(AdCSponsorInfo info) {
		return tpl.selectOne("sponsorMapper.getCountCenterSponsorPetList", info);
	}

	public List<Pet> getCenterSponsorPetList(AdCSponsorInfo info) {
		return tpl.selectList("sponsorMapper.getCenterSponsorPetList", info);
	}

	// 센터의 동물 후원 받은 금액 내역 가져오기
	public int getCountPetSponsor(AdCSponsorDetailInfo info) {
		return tpl.selectOne("sponsorMapper.getCountPetSponsor", info);
	}

	public List<Pet> getPetSponsor(AdCSponsorDetailInfo info) {
		return tpl.selectList("sponsorMapper.getPetSponsor", info);
	}

	// 후원 매출 내역 가져오기
	public int getTotalSponsorMoney(String sqlWhere) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sqlWhere", sqlWhere);
		return tpl.selectOne("sponsorMapper.getTotalSponsorMoney", map);
	}

	public int getCountTotalSponsorList(AdSalesInfo info) {
		return tpl.selectOne("sponsorMapper.getCountTotalSponsorList", info);
	}

	public List<MemberSponsorRecord> getTotalSponsorList(AdSalesInfo info) {
		return tpl.selectList("sponsorMapper.getTotalSponsorList", info);
	}
}
