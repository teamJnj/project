package com.icia.jnj.service;

import java.security.Principal;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.*;

import com.icia.jnj.constant.*;
import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class AdoptService {

	@Autowired
	private AdoptDao dao;
	
	@Autowired
	private PetDao petDao;
	
	// 수안==========================
	// 입양 게시판 출력
	//@PreAuthorize("isAuthenticated()")
	public Map<String, Object> getAdoptList(int pageno, int petSort, int petState, String firstAddr) {
		petDao.mercyState();	// 안락사날짜 지난 동물 상태 안락사 변경
		int articleCnt = 0;
		
		String sPetSort = "'%"+petSort+"%'";
		String sPetState = "'%"+petState+"%'";
		String sFirstAddr = "'%"+firstAddr+"%'";
		
		if(petSort==0) {
			sPetSort="'%'";
		} 
		if(petState==0) {
			sPetState="'%'";
		} 
		if(firstAddr.equals("전체")) {
			sFirstAddr="'%'";
			
		}
		
		articleCnt = dao.getAdoptCount(sPetSort,sPetState,sFirstAddr);
		
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("petSort", petSort);
		map.put("petState", petState);
		map.put("firstAddr", firstAddr);
		map.put("pagination", pagination);
		map.put("getAdoptList", dao.getAdoptList(sPetSort,sPetState,sFirstAddr, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		
		
		return map;
	}
	
	// 입양 게시판 상세뷰 출력
	@PreAuthorize("isAuthenticated()")
	public Map<String, Object> getAdoptView(int petNo, String memberId) {
		SponsorDomain spDomain = dao.getAdoptView(petNo);
		spDomain.setMemberId(memberId);
		
		String LastAdopter = dao.lastAdoptMember(petNo);
		if(LastAdopter==null) {
			spDomain.setLastAdopter("admin");
		} else {
			spDomain.setLastAdopter(LastAdopter);
		}
		
		List<PetImg> imgList = dao.getAdoptViewPicture(petNo);
		
		int cancleCnt = 0;
		if( !spDomain.getMemberId().equals("adminDetailView"))
		cancleCnt = dao.cancleCountForView(petNo, memberId);

		Map<String,Object> map = new HashMap<String, Object>();
		
		if( !spDomain.getMemberId().equals("adminDetailView")) {
			if(cancleCnt==0) {
				spDomain.setCancle(CT.ADOPT_CANCLE_NORMAILY);
			}else if(cancleCnt>0) {
				boolean cancleInfo = dao.cancleInfoForView(petNo, spDomain.getMemberId());
				spDomain.setCancle(cancleInfo);
			}
		}
		
		// 돈계산 로직2
		if(spDomain.getPetState()==4 || spDomain.getPetState()==5) {
			List<Pet> petList = petDao.allPetList(petNo);
			
			int endPetAllM = petDao.nowPetMoney(petNo);
			int goalM = 500000;
			
			
			for(int i=0; i<petList.size(); i++) {
				
				int nowSponM = petDao.nowPetMoney(petList.get(i).getPetNo()); 
				int needM = goalM - nowSponM;	
				
				endPetAllM = endPetAllM - needM;
				
				if(endPetAllM > 0) {
					petDao.updateThisSponMoney(petList.get(i).getPetNo());
					petDao.insertThisPetSponsor(petList.get(i).getPetNo(), (petDao.sponNoForReceiver(petList.get(i).getPetNo()))+1);
					petDao.updateThisMercyDate(petList.get(i).getPetNo());
					
				}
				
				else if(endPetAllM==0 || endPetAllM<0) {
					endPetAllM = endPetAllM + needM;
					int resultSponM = (petDao.sponMoneyForReceiver(petList.get(i).getPetNo()))+endPetAllM;
						
					petDao.updategetAllRestMoney(resultSponM, petList.get(i).getPetNo());
					petDao.updateEndPetMoney(petNo);
					break;
					
				}
			}
		}
		// 돈계산 끝!
		
		map.put("spDomain", spDomain);
		map.put("imgList", imgList);
		map.put("petNo", petNo);
		return map;
		
	}

	// 입양 버튼눌러서 입양 정보 인서트 하기
	@PreAuthorize("isAuthenticated()")
	public Adopt insertAdoptInfo(Adopt adopt) {
		dao.selectAdoptNumber(adopt.getPetNo(), adopt.getMemberId());
		int newAdoptNo = dao.increaseAdoptNo(adopt.getPetNo(), adopt.getMemberId());
		adopt.setAdoptNo(newAdoptNo);
		dao.insertAdoptInfo(adopt);
		dao.updatePetState(adopt.getPetNo(),CT.PET_STATE_RECEIPT);
		dao.updatePlusMercyDate(adopt.getPetNo());
		return adopt;
	}
	
	// 입양 취소
	@PreAuthorize("#adopt.memberId == principal.username or hasRole('ROLE_ADMIN')")
	public Adopt updateAdoptInfo(Adopt adopt) {
		dao.updatePetState(adopt.getPetNo(), CT.PET_STATE_STANDBY);
		dao.updateAdoptInfo(adopt);
		dao.updateMinusMercyDate(adopt.getPetNo());
		adopt.setCancle(CT.ADOPT_CANCLE_CANClE);
		adopt.setCancleDate(adopt.getCancleDate());
		return adopt;
	}

	
	
	
	/*혜미혜미혜미혜미혜미혜미최고짱짱*/
	//마이페이지 입양 내역
	public Map<String, Object> getMypageMemberAdopt(String memberId, int pageno){
		int articleCnt = dao.getAdoptCountMypage(memberId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("getMypageMemberAdopt",dao.getMypageMemberAdopt(memberId, pagination.getStartArticleNum(),pagination.getEndArticleNum()));
		map.put("pagination",pagination);
		return map;
	}
	
	// 주리
	// ==============================================================================================
	// 해당 회원 후원 내역 리스트 조회( 페이지네이션, 정렬, 후원 총금액 추가 )
	public Map<String, Object> getMemberAdoptList(AdMAdoptInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("centerName"))
				info.setSqlText("where centerName like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("petSort"))
				info.setSqlText("where petSort like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("petName"))
				info.setSqlText("where petName like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("petState"))
				info.setSqlText("where petState like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("adoptApplyDate"))
				info.setSqlText("where to_date(adoptApplyDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(adoptApplyDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountMemberAdoptList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberAdoptList", dao.getMemberAdoptList(info));
		map.put("stateCount", dao.getMemberAdoptStateCount(info.getMemberId()));

		return map;
	}

	public Map<String, Object> getCenterAdoptApplyList(AdCAdoptInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");
		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("petName"))
				info.setSqlText("where petName like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("petState")) {
				if (info.getSearchText().equals(""))
					info.setSqlText("where petState like '%' ");
				else if (info.getSearchText().equals("1"))
					info.setSqlText("where petState like '%1%' ");
				else if (info.getSearchText().equals("2"))
					info.setSqlText("where petState like '%2%' ");
				else if (info.getSearchText().equals("3"))
					info.setSqlText("where petState like '%3%' ");
				else if (info.getSearchText().equals("4"))
					info.setSqlText("where petState like '%4%' ");
				else if (info.getSearchText().equals("5"))
					info.setSqlText("where petState like '%5%' ");
				else if (info.getSearchText().equals("0"))
					info.setSqlText("where petState like '%0%' ");
			} else if (info.getSearchColName().equals("petSort")) {
				if (info.getSearchText().equals("0"))
					info.setSqlText("where petSort like '%' ");
				else if (info.getSearchText().equals("1"))
					info.setSqlText("where petSort like '%1%' ");
				else if (info.getSearchText().equals("2"))
					info.setSqlText("where petSort like '%2%' ");
				else if (info.getSearchText().equals("3"))
					info.setSqlText("where petSort like '%3%' ");
			}
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
			else if (info.getSearchColName().equals("mercyDate"))
				info.setSqlText("where to_date(mercyDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(mercyDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountCenterAdoptApplyList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("centerAdoptList", dao.getCenterAdoptApplyList(info));
		map.put("stateCount", dao.getTotalCenterAdoptPetState(info.getCenterId()));

		return map;
	}

	// 센터가 입양 상세 내역을 본다( 동물 정보와, 신청자 정보 )
	public Map<String, Object> getAdoptInfo(int petNo) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("petInfo", dao.getAdoptView(petNo));
		map.put("applyInfo", dao.getAdoptApplyInfo(petNo));
		map.put("imgList", dao.getAdoptViewPicture(petNo));
		return map;
	}
	
	
	

}//이거 끝이얌
