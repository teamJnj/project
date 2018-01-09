package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class PetDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	// 센터내 총 유기동물 수 얻어오기
	public int getPetNum(String centerId) {
		return tpl.selectOne("petMapper.getPetNum", centerId);
	}
	// 센터내 유기동물 리스트 보기
	public List<PetCutAndImg> list(Integer startArticleNum, Integer endArticleNum, String centerId, int sort) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		map.put("centerId", centerId);
		String sortS="pet.pet_no desc";
		if(sort==2)
			sortS="pet_name";
		else if(sort==3)
			sortS="decode(sign(mercy_date-sysdate), -1, 999, mercy_date-sysdate)";
		map.put("sort", sortS);
		return tpl.selectList("petMapper.listPet", map);
	}
	
	// 유기동물 등록
	public int insertPet(Pet pet) {
		return tpl.insert( "petMapper.insertPet", pet );
	}
	// 유기동물 사진등록
	public int insertPetImg(PetImg petImg) {
		return tpl.insert("petMapper.insertPetImg", petImg);
	}
	// 유기동물 등록전 시퀀스값 얻어오기
	public int getPetNoSeq() {
		return tpl.selectOne("petMapper.getPetNoSeq");
	}
	// 동물 수정
	public int updatePet(Pet pet) {
		return tpl.update("petMapper.updatePet", pet);
	}
	
	// 동물 한마리 정보
	public Pet getPet(int petNo) {
		return tpl.selectOne("petMapper.getPet", petNo);
	}
	
	// 동물의 상태 수정
	public int updateState(int petNo, int petState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petNo", petNo);
		map.put("petState", petState);
		return tpl.update("petMapper.updateState", map);
	}
	
	// 동물의 상태 수정
	public void mercyState() {
		tpl.update("petMapper.mercyState");
	}
	
	
	// 수안==================================
	// 펫상태 4,5 돈계산 로직
	// 펫 리스트 전체 뽑아오기
	public List<Pet> allPetList(int petNo){
		return tpl.selectList("petMapper.allPetList",petNo);
	}
	
	// 1. 펫에게 들어있는 sponsorMoney 뽑아내기
	public int nowPetMoney(int petNo) {
		return tpl.selectOne("petMapper.nowPetMoney", petNo);
	}
	
	
	// 2. 돈 다 뽑아낸 애 sponsorMoney 0으로 업데이트
	public void updateEndPetMoney(int petNo) {
		tpl.update("petMapper.updateEndPetMoney", petNo);
	}
	
	// 돈받는 애의 후원번호
	public int sponNoForReceiver(int petNo) {
		return tpl.selectOne("petMapper.sponNoForReceiver", petNo);
	}
	
	// 돈받는 애의 후원금액
	public int sponMoneyForReceiver(int petNo) {
		return tpl.selectOne("petMapper.sponMoneyForReceiver", petNo);
	}
	
	
	// 돈계산로직 2번째의 1번째 케이스
	// sponsorNo번째의 sponsorMoney를 50만원으로 세팅
	public void updateThisSponMoney(int petNo) {
		tpl.update("petMapper.updateThisSponMoney", petNo);
	}
	
	// sponsorNo가 +1되고, sponsorMoney가 0원으로 세팅
	public void insertThisPetSponsor(int petNo, int sponsorNo) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("petNo", petNo);
		map.put("sponsorNo", sponsorNo);
		tpl.insert("petMapper.insertThisPetSponsor", map);
	}
	
	// i번째 pet의 안락사날짜+15일
	public void updateThisMercyDate(int petNo) {
		tpl.update("petMapper.updateThisMercyDate", petNo);
	}
	
	
	// 돈계산로직 2번째의 2번째 케이스
	// i번째의 돔눌 sponsorMoney에 +남은돈 하는 update문
	public void updategetAllRestMoney(int sponsorMoney, int petNo) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("sponsorMoney", sponsorMoney);
		map.put("petNo", petNo);
		
		tpl.update("petMapper.updategetAllRestMoney", map);
	}
	
	public void updateCenterAllPetState(String centerId, int petState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("centerId", centerId);
		map.put("petState", petState);
		tpl.update("petMapper.updateCenterAllPetState", map);
	}
	
	/*
	// 입양 시 mercy_date 지움
	public void eraseMercyDate(int petNo) {
		tpl.update("petMapper.eraseMercyDate", petNo);
	}
	*/
	
	// 주리
	// 해당 센터의 동물 수
	public int getCountCenterPetList(AdCPetInfo info) {
		return tpl.selectOne("petMapper.getCountCenterPetList", info);
	}

	// 해당 센터의 동물 리스트
	public List<Pet> getCenterPetList(AdCPetInfo info) {
		return tpl.selectList("petMapper.getCenterPetList", info);
	}

	// 해당 센터 동물의 상태 별 개수
	public List<Map<String, Integer>> getTotalCenterPetState(String centerId) {
		return tpl.selectList("petMapper.getTotalCenterPetState", centerId);
	}
	
}
