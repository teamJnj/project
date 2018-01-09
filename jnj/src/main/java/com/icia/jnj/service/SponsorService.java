package com.icia.jnj.service;

import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.*;

import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class SponsorService {

	@Autowired
	private SponsorDao dao;
	@Autowired
	private PetDao petDao;
	
	// 1. 후원 게시판 목록 출력
	//@PreAuthorize("isAuthenticated()")
	public Map<String,Object> getSponsorList(int petSort, int pageno){
		petDao.mercyState();	// 안락사날짜 지난 동물 상태 안락사 변경
		Map<String,Object> map = new HashMap<String, Object>();
		
		if(petSort==0) {
			int articleCnt = dao.getSponsorCount();
			Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);
			map.put("getAllSponsorList",dao.getAllSponsorList(pagination.getStartArticleNum(), pagination.getEndArticleNum()));
			map.put("pagination", pagination);
		}
		else {
			int articleCnt = dao.getSponsorFilterCount(petSort);
			Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 16);
			map.put("sponsorList",dao.getSponsorList(petSort, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
			map.put("pagination", pagination);
		}
		
		return map;
	}
	
	
	// 2. 후원 게시글 보기
	@PreAuthorize("isAuthenticated()")
	public Map<String,Object> getSponsorView(int petNo){
		SponsorDomain sponsor = dao.getSponsorView(petNo);
		List<PetImg> imgList = dao.getSponsorViewPicture(petNo);
		
		// 돈계산 로직2
			if(sponsor.getPetState()==4 || sponsor.getPetState()==5) {
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
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sponsor", sponsor);
		map.put("imgList", imgList);
		return map;
	}
	
	
	// 3. 후원하기
	// 후원 50만원 달성해서 후원번호 갱신해야 되는작업
	public SponsorPayInfo petSponsorNewSetting(SponsorPayInfo spInfo) {
		
		//돈계산 로직추가
		int sponG = spInfo.getGoalMoney(); 				// 목표금액 500,000원
		int currentSponsorNo = spInfo.getSponsorNo(); 	// 현재 동물 후원 번호1
		int sponM = spInfo.getSponsorMoney();			// 동물 현재 후원금 100,000
		int userM = spInfo.getPayMoney(); 				// 유저 결제 금액 450,000
			
		int result = (userM + sponM) / sponG;		// (45+10) / 50 = 1
	    int resultM = (userM + sponM) % sponG;		// (45+10) / 50 = 50,000
	    int useMoney = sponG-sponM;					// (50-10) = 40
	    
	    System.out.println("남은금액은 : " + resultM);
	    if(result==0) {
	    	System.out.println("금액이 넘치지 않아요");
	    	
	    	spInfo.setSponsorNo(currentSponsorNo);
	    	int memberSponsorNo = dao.selectMemberSponsorNo(spInfo);
	    	
			spInfo.setMemberSponsorNo(memberSponsorNo+1);
			
	    	dao.updatePetSponsorMoney(spInfo);
	    	dao.insertMemberSponsorRecord(spInfo);
	    	
		    return spInfo;
	    } 
	    
	    else {
	    	System.out.println("금액이 넘쳐요");
	    	
	    	// 멤버의 후원 내역을 추가한다.
	    	int memberSponsorNo = dao.selectMemberSponsorNo(spInfo);
			spInfo.setMemberSponsorNo(memberSponsorNo+1);
	    	dao.insertMemberSponsorRecord(spInfo);
	    	
	    	// 현재 후원 번호부터 금액이 넘친 수만큼 포문을 돈다.
	    	int lastIndex = currentSponsorNo+result;
	    	for( int i=currentSponsorNo; i<=lastIndex; i++){
	    		
	    		spInfo.setSponsorNo(i);
		    	
	    		// 맨 첫번째. 동물에 후원금이 있을 수 있느까.
	    		if( i == currentSponsorNo ) {
		    		// 첫번째는 동물에 후원금액이 존재 할 수 있으니까 useMoney를 넣고
		    		// 그 다음부터는 무조건 50만원 풀셋팅으로 간다.
		    		spInfo.setPayMoney( useMoney );
		    		dao.updatePetSponsorMoney(spInfo);
		    		dao.updatePetSponsorAchieveDate(spInfo);
		    	}
	    		
	    		// 맨 마지막. 남은 금액 셋팅
	    		else if( i == lastIndex ){
		    		spInfo.setPayMoney(userM);
		    		System.out.println("남은금액은 : " + resultM);
		    		spInfo.setSponsorMoney(resultM);
		    		dao.insertChangePetSponsor(spInfo);
		    		dao.updateMercyDate(spInfo);
		    	} 
	    		
	    		// 첫번째와 마지막 사이는 무조건 50만원 풀 셋팅
	    		else{
		    		spInfo.setSponsorMoney(500000);
		    		dao.insertChangePetSponsor(spInfo);
		    		dao.updateMercyDate(spInfo);
		    		dao.updatePetSponsorAchieveDate(spInfo);
		    	} 
		     }
	    }
	    return spInfo;
	}
	/*public SponsorPayInfo petSponsorNewSetting(SponsorPayInfo spInfo) {
    
	    //돈계산 로직추가
	    int sponG=spInfo.getGoalMoney();
	    int currentSponsorNo=spInfo.getSponsorNo();
	    int sponM=spInfo.getSponsorMoney();//현재후원
	    int userM=spInfo.getPayMoney(); // 유저가 한 금액
	
	    int result = (userM + sponM) / sponG;
	     int resultM = (userM + sponM) % sponG;
	     int useMoney = sponG-sponM;
	     
	     
	     
	     if(result==0) {
	        spInfo.setSponsorNo(currentSponsorNo);
	        int memberSponsorNo = dao.selectMemberSponsorNo(spInfo);
	        
	       spInfo.setMemberSponsorNo(memberSponsorNo+1);
	       System.err.println("1111멤버스폰서 넘버 증가안함?:   "+memberSponsorNo);
	       
	        dao.updatePetSponsorMoney(spInfo);
	        dao.insertMemberSponsorRecord(spInfo);
	        
	        return spInfo;
	        
	     } else {
	        for( int i=currentSponsorNo; i<currentSponsorNo+result; i++){
	           spInfo.setSponsorNo(i);
	           
	           
	           int memberSponsorNo = dao.selectMemberSponsorNo(spInfo);
	          spInfo.setMemberSponsorNo(memberSponsorNo+1);
	          System.err.println("2222멤버스폰서 넘버 증가안함?:   "+memberSponsorNo);
	          
	          
	           if(currentSponsorNo==i) {
	              spInfo.setPayMoney(userM);
	              spInfo.setSponsorMoney(useMoney);
	              
	              System.err.println("1111너의 멤버인포는?:   "+spInfo);
	              dao.updatePetSponsorMoney(spInfo);
	              
	           } else {
	              spInfo.setPayMoney(500000);
	              spInfo.setSponsorMoney(500000);
	              
	              System.err.println("22222너의 멤버인포는?:   "+spInfo);
	              dao.insertChangePetSponsor(spInfo);
	           }
	           
	           
	         }
	        
	        if( resultM > 0) {
	           spInfo.setSponsorNo(currentSponsorNo+result);
	           spInfo.setSponsorMoney(resultM);
	           
	           System.err.println("11111동물 현재 스폰서인포는?:   "+spInfo);
	           dao.insertChangePetSponsor(spInfo);
	           dao.updateMercyDate(spInfo);
	           System.err.println("동물 메르시데이트11111"+spInfo.getMercyDate());
	           dao.insertMemberSponsorRecord(spInfo);
	        }
	           
	        if( resultM == 0) {
	           spInfo.setSponsorNo(currentSponsorNo+result);
	           spInfo.setSponsorMoney(0);
	           
	           System.err.println("22222동물 현재 스폰서인포는?:   "+spInfo);
	           dao.insertChangePetSponsor(spInfo);
	           dao.updateMercyDate(spInfo);
	           System.err.println("동물 메르시데이트222222"+spInfo.getMercyDate());
	           dao.insertMemberSponsorRecord(spInfo);
	           
	        }
	     }
	     
	     
	     System.err.println( "S돈계산후 : " + spInfo );
	     return spInfo;
	 }*/
	
	
	// 결제 진행(등록 및 후원금 증액)
	@PreAuthorize("isAuthenticated()")
	public SponsorPayInfo sponsorPayProcessAll(SponsorPayInfo spInfo) {
		
		System.err.println( "S전 : " + spInfo );
		
		SponsorDomain spDomain = dao.getSponsorView(spInfo.getPetNo());
		
		System.err.println( "안락사 날짜변경 전 : " + spDomain );
		
		int msn = dao.selectMemberSponsorNo(spInfo);
		
		spInfo.setMemberSponsorNo(msn);
		spInfo.setGoalMoney(spDomain.getGoalMoney());
		spInfo.setSponsorMoney(spDomain.getSponsorMoney());
		spInfo.setAchieveDate(spDomain.getAchieveDate());
		spInfo.setMercyDate(spDomain.getMercyDate());
		
		
		//System.err.println("안락사 날짜 변경 후:  "+spDomain);
		//dao.updateMercyDate(spDomain);
    	//spInfo.setMercyDate(spDomain.getMercyDate());
    	
		
		
		System.err.println( "S후 : " + spInfo );
		return petSponsorNewSetting(spInfo);
	}
	
	
	
	
	
	// 4. 덧글쓰기(기본댓글 수정)
	@PreAuthorize("isAuthenticated()")
	public SponsorPayInfo updateMemberSponsorReply(SponsorPayInfo spInfo) {
		
		System.err.println("덧글쓰기 dao: " + spInfo);
		dao.updateMemberSponsorReply(spInfo);
		return spInfo;
	}
	
	
	//  덧글 리스트 가져오기
	@PreAuthorize("isAuthenticated()")
	public Map<String,Object> getAllSponsorReplyList(int petNo, int pageno){
		int articleCnt = dao.getSponsorReplyCount(petNo);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("replyList",dao.getAllSponsorReplyList(petNo, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		map.put("pagination", pagination);
		return map;
	}
	
	
	
	
	
	
	/*혜미혜미혜미혜미혜미혜미혜미혜미혜미*/
	//마이페이지 후원 내역
	//@PreAuthorize("isAuthenticated()")
	public Map<String,Object> getMypageMemberSponsor(String memberId, int pageno, String colName, String sortType){
		int articleCnt = dao.getSponsorCountMypage(memberId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("getMypageMemberSponsor",dao.getMypageMemberSponsor(colName, sortType,pagination.getStartArticleNum(), pagination.getEndArticleNum(),memberId));
		map.put("pagination", pagination);
		System.out.println("Service!");
		return map;
	}
	
	// 주리
	// ==============================================================================================
	// 해당 회원 후원 내역 리스트 조회( 페이지네이션, 정렬, 후원 총금액 추가 )
	public Map<String, Object> getMemberSponsorList(AdMSponsorInfo info) {

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

			// 펫 상태를 검색하는데 전체 일때는 값없이 비교를 한다
			else if (info.getSearchColName().equals("petState"))
				info.setSqlText("where petState like '%"
						+ ((!info.getSearchText().equals("0")) ? info.getSearchText() : "") + "%'");

			else if (info.getSearchColName().equals("sponsorReply"))
				info.setSqlText("where sponsorReply like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("payMoney"))
				info.setSqlText("where payMoney>=" + info.getStartMoney() + " and payMoney<= " + info.getEndMoney());

			else if (info.getSearchColName().equals("sponsorDate"))
				info.setSqlText("where to_date(sponsorDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(sponsorDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountMemberSponsorList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("memberSponsorList", dao.getMemberSponsorList(info));
		map.put("totalMoney", (articleCnt == 0) ? 0 : dao.getTotalMoneyMemberSponor(info.getMemberId()));

		return map;
	}

	public Map<String, Object> getCenterSponsorList(AdCSponsorInfo info) {

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
			else if (info.getSearchColName().equals("sponsorMoney"))
				info.setSqlText(
						"where sponsorMoney>=" + info.getStartMoney() + " and sponsorMoney<= " + info.getEndMoney());
			else if (info.getSearchColName().equals("mercyDate"))
				info.setSqlText("where to_date(mercyDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(mercyDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountCenterSponsorPetList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("centerSponsorList", dao.getCenterSponsorPetList(info));

		// 각각 상태별로 몇건인지 가져오기
		map.put("totalSponsorState", dao.getTotalMoneyCenterSponor(info.getCenterId()));

		return map;
	}

	public Map<String, Object> getCenterSponsorDetailList(AdCSponsorDetailInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("sponsorNo"))
				info.setSqlText("where sponsorNo like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("achieveDate"))
				info.setSqlText("where to_date(achieveDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(achieveDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
			else if (info.getSearchColName().equals("sponsorMoney"))
				info.setSqlText(
						"where sponsorMoney>=" + info.getStartMoney() + " and sponsorMoney<= " + info.getEndMoney());
		}

		int articleCnt = dao.getCountPetSponsor(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("centerSponsorList", dao.getPetSponsor(info));

		// 각각 상태별로 몇건인지 가져오기
		map.put("totalSponsorState", dao.getTotalMoneyCenterSponor(info.getCenterId()));

		return map;
	}

	// 후원 매출 내역 가져오기
	public Map<String, Object> getSponsorSalesList(AdSalesInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
		} else {
			if (info.getSearchColName().equals("sponsorDate")
					&& (info.getStartDate() != null && info.getEndDate() != null))
				info.setSqlText("where to_date(sponsorDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(sponsorDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountTotalSponsorList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("salesList", dao.getTotalSponsorList(info));
		map.put("adSalesInfo", info);
		map.put("totalSponsorMoney", dao.getTotalSponsorMoney(""));

		return map;
	}
		
		
}
