package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class AdoptDao {
	
	@Autowired
	private SqlSessionTemplate tpl;

	// 수안============================
	// 입양 리스트 뽑기위해 필요한거
	public int getAdoptCount(String petSort, String petState, String firstAddr) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petSort", petSort);
		map.put("petState", petState);
		map.put("firstAddr", firstAddr);
		return tpl.selectOne("adoptMapper.getAdoptCount", map);
	}

	public List<SponsorDomain> getAdoptList(String petSort, String petState, String firstAddr, int startArticleNum, int endArticleNum){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("petSort", petSort);
		map.put("petState", petState);
		map.put("firstAddr", firstAddr);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("adoptMapper.getAdoptList", map);
	}

	
	// 입양 뷰 보기 위해 필요한거
	public SponsorDomain getAdoptView(int petNo) {
		return tpl.selectOne("adoptMapper.getAdoptView",petNo);
	}
	
	// 캔슬정보가 없을때
	public int cancleCountForView(int petNo,String memberId) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		return tpl.selectOne("adoptMapper.cancleCountForView",map);
	}
	
	// 취소 정보가 있어서 0과 1로 판단해야할때
	public boolean cancleInfoForView(int petNo, String memberId) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		return tpl.selectOne("adoptMapper.cancleInfoForView",map);
	}
	
	// 최종적으로 입양신청한 사람
	public String lastAdoptMember(int petNo) {
		return tpl.selectOne("adoptMapper.lastAdoptMember",petNo);
	}
	
	
	// 입양뷰에 이미지
	public List<PetImg> getAdoptViewPicture(int petNo){
		return tpl.selectList("adoptMapper.getAdoptViewPicture", petNo);
	}
	
	
	
	// 입양 인서트 하기 위해 필요한거
	public int selectAdoptNumber(int petNo, String memberId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		return tpl.selectOne("adoptMapper.selectAdoptNumber", map);
	}
	
	public int increaseAdoptNo(int petNo, String memberId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		return tpl.selectOne("adoptMapper.increaseAdoptNo", map);
	}
	
	public void insertAdoptInfo(Adopt adopt) {
		tpl.insert("adoptMapper.insertAdoptInfo", adopt);
	}
	
	public void updatePetState(int petNo, int petState) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("petState", petState);
		tpl.update("adoptMapper.updatePetState",map);
	}
	
	
	// 입양 취소하기 위해 필요한거
	public void updateAdoptInfo(Adopt adopt) {
		tpl.update("adoptMapper.updateAdoptInfo",adopt);
	}
	
	
	// 입양 신청중인 아이들 D-day 조정
	public void updatePlusMercyDate(int petNo) {
		tpl.update("adoptMapper.updatePlusMercyDate",petNo);
	}

	public void updateMinusMercyDate(int petNo) {
		tpl.update("adoptMapper.updateMinusMercyDate",petNo);
	}
	
	
	
	/*혜미최고짱혜미최고짱혜미최고짱혜미최고짱혜미최고짱*/
	//마이페이지 입양 내역@_@
	public List<Map<String, Object>> getMypageMemberAdopt(String memberId, int startArticleNum, int endArticleNum){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("memberId", memberId);
		return tpl.selectList("adoptMapper.getMypageMemberAdopt",map);
	}
	//마이페이지 입양 내역 개수@_@!
	public int getAdoptCountMypage(String memberId) {
		return tpl.selectOne("adoptMapper.getMypageMemberAdoptCount",memberId);
	}
	
	
	// 20171209ㅋ
	// 주리
	// ==============================================================================================
	// 해당 멤버 입양 내역 총 개수( 검색, 필터 )
	public int getCountMemberAdoptList(AdMAdoptInfo info) {
		return tpl.selectOne("adoptMapper.getCountMemberAdoptList", info);
	}

	// 해당 멤버 입양 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<AdMAdoptRecord> getMemberAdoptList(AdMAdoptInfo info) {
		return tpl.selectList("adoptMapper.getMemberAdoptList", info);
	}

	// 탈퇴를 위한 센터 입양 진행 중 검색
	public int getCenterAdoptForResign(String centerId) {
		return tpl.selectOne("adoptMapper.getCenterAdoptForResign", centerId);
	}

	// 일반회원 입양 내역 상태 개수
	public List<Map<String, Object>> getMemberAdoptStateCount(String memberId) {
		return tpl.selectList("adoptMapper.getMemberAdoptStateCount", memberId);
	}

	// 해당 멤버 입양 내역 총 개수( 검색, 필터 )
	public int getCountCenterAdoptApplyList(AdCAdoptInfo info) {
		return tpl.selectOne("adoptMapper.getCountCenterAdoptApplyList", info);
	}

	// 해당 멤버 입양 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<Pet> getCenterAdoptApplyList(AdCAdoptInfo info) {
		return tpl.selectList("adoptMapper.getCenterAdoptApplyList", info);
	}

	// 해당 멤버 입양 내역 가져오기( 페이지네이션, 검색, 필터 )
	public List<Map<String, Integer>> getTotalCenterAdoptPetState(String centerId) {
		return tpl.selectList("adoptMapper.getTotalCenterAdoptPetState", centerId);
	}

	// 센터가 자기 동물에 대해 누가 입양신청 했는지 정보 가져오기
	// 주의! 취소내역도 있을 수 있음으로 리스트로 받아온다..
	public List<Adopt> getAdoptApplyInfo(int petNo) {
		return tpl.selectList("adoptMapper.getAdoptApplyInfo", petNo);
	}
	
	
	
	// ==============================창재님꺼===================================
	// 한 센터의 총 입양 건수
	public int getAdoptNumOfCenter(String centerId) {
		return tpl.selectOne("adoptMapper.getAdoptNumOfCenter", centerId);
	}
	// 한 센터의 입양 리스트 보기
	public List<AdoptPetCutAndImg> getAdoptListOfCenter(Integer startArticleNum, Integer endArticleNum, String centerId, int sort) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("centerId", centerId);
		String sortS= "decode( cancle, 1, cancle_date, decode(adopt_date, null, adopt_apply_date, adopt_date)) desc";
		if(sort==2)	//입양일순
			sortS="nvl(adopt_date, '1111-11-11') desc";
		else if(sort==3) //상태순
			sortS="cancle, petState";
		else if(sort==4) //이름순
			sortS="petName";
		else if(sort==5) //동물번호순
			sortS="petNo desc";
		map.put("sort", sortS);
		return tpl.selectList("adoptMapper.getAdoptListOfCenter", map);
	}
	// 한 센터의 입양 뷰 
	public AdoptPetCutAndImg getAdoptOfCenter(int petNo, String memberId, int adoptNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		map.put("adoptNo", adoptNo);
		return tpl.selectOne("adoptMapper.getAdoptOfCenter", map);
	}
	
	// 입양날짜 기록
	public int setAdoptDate(int petNo, String memberId, int adoptNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		map.put("adoptNo", adoptNo);
		return tpl.update("adoptMapper.setAdoptDate", map);
	}
	
	// 입양 취소
	public int cancleAdopt(int petNo, String memberId, int adoptNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("memberId", memberId);
		map.put("adoptNo", adoptNo);
		return tpl.update("adoptMapper.cancleAdopt", map);
	}
	
	
	// 수현
	// 탈퇴를 위한 내 입양내역 검색
	public List<Integer> getMyAdoptForResign(String memberId) {
		return tpl.selectList("adoptMapper.getMyAdoptForResign", memberId);
	}

}
