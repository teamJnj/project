package com.icia.jnj.service;

import java.io.*;
import java.util.*;

import javax.mail.*;
import javax.mail.internet.*;

import org.apache.commons.lang3.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.mail.javamail.*;
import org.springframework.security.access.prepost.*;
import org.springframework.security.crypto.password.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.*;
import org.springframework.util.*;
import org.springframework.web.multipart.*;

import com.icia.jnj.constant.*;
import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class CenterService {
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	private CenterDao dao;
	
	@Autowired
	private PetDao petDao;
	
	@Autowired
	private AdoptDao adoptDao;
	
	@Autowired
	private SponsorDao sponsorDao;
	
	@Autowired
	private RecruitDao volunteerDao;
	
	@Autowired
	private SUsersDao sUsersDao;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	
	@Value("\\\\192.168.0.203\\service\\pet")
	private String uploadPath;
	
	// 센터 정보보기
	public Center viewCenter(String centerId) {
		return dao.getCenter(centerId);
	}
	
	// 센터 정보 수정
	public void updateCenter(Center center) {
		dao.updateCenterInfo(center);
	}
	
	// 센터 - 동물관리 - 센터내동물내역
	public Map<String, Object> recordPet(String centerId, int pageno, int sort) {
		int petNum = petDao.getPetNum(centerId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, petNum, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("sort", sort);
		map.put("list", petDao.list(pagination.getStartArticleNum(), pagination.getEndArticleNum(), centerId, sort));
		return map;
	}
	
	// 센터 - 동물관리 - 동물등록 (+사진) (+후원정보)
	@Transactional(rollbackFor=Exception.class)
//	@PreAuthorize("isAuthenticated()")
	public boolean insertPet(Pet pet, MultipartFile[] files) throws IOException {
		// 동물정보 등록
		//petNo 세팅
		pet.setPetNo(petDao.getPetNoSeq());
		petDao.insertPet(pet);
		
		// 동물 후원정보 등록
		PetSponsor petSponsor = new PetSponsor();
		petSponsor.setPetNo(pet.getPetNo());
		petSponsor.setSponsorNo(1);
		petSponsor.setGoalMoney(500000);
		sponsorDao.insertPetSponsor(petSponsor);
		
		// 동물 사진 등록
		// files는 파일 업로드를 안해도 length가 1, 파일 하나 업로드해도 length가 1이다
		int idx =0;
		for( MultipartFile file:files ) {
			if( file.getOriginalFilename().equals("") )
				break;
			
			String imgName = System.currentTimeMillis() + "-"+ (idx+1) +"-" + file.getOriginalFilename();
			
			PetImg petImg = new PetImg();
 			petImg.setPetNo(pet.getPetNo());
 			petImg.setPetImgNo(idx+1);
 			petImg.setPetImg(imgName);
			
 			File f = new File(uploadPath, imgName);
			FileCopyUtils.copy(file.getBytes(), f);
			petDao.insertPetImg(petImg);
			
			idx++;
		}
		return true;
	}
	
	// 동물 한마리 정보
	public Pet getPet(int petNo){ //Map<String,Object> getPet(int petNo){
		Pet pet = petDao.getPet(petNo);
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("sponsor", sponsor);
//		map.put("imgList", imgList);
		return pet;
	}
	
	// 동물정보 수정
	public void updatePet(Pet pet) {
		petDao.updatePet(pet);
		
		
		// 돈계산로직2 실행하는 부분
		if(pet.getPetState()==4 || pet.getPetState()==5) {
			// 수안============================
						// 입양 완료됐으니까 돈계산 시작하자~
						List<Pet> petList = petDao.allPetList(pet.getPetNo());
						
						int endPetAllM = petDao.nowPetMoney(pet.getPetNo());
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

								petDao.updateEndPetMoney(pet.getPetNo());
								break;
									
							}
						}
						
						// 돈계산 끝======================================================
						
						
		}
	}
		
	// 입양내역
	public Map<String, Object> recordAdopt(String centerId, int pageno, int sort) {
		int adoptNum = adoptDao.getAdoptNumOfCenter(centerId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, adoptNum, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("sort", sort);
		map.put("list", adoptDao.getAdoptListOfCenter(pagination.getStartArticleNum(), pagination.getEndArticleNum(), centerId, sort));
		return map;
	}
	
	// 입양뷰
	public AdoptPetCutAndImg getAdopt(int petNo, String memberId, int adoptNo) { // Map<String,Object> getPet(int petNo){
		AdoptPetCutAndImg apcai = adoptDao.getAdoptOfCenter(petNo, memberId, adoptNo);
		// Map<String, Object> map = new HashMap<String, Object>();
		// map.put("sponsor", sponsor);
		// map.put("imgList", imgList);
		return apcai;
	}
	
	// 입양상태 업데이트
	public void updateAdopt(int petNo, String memberId, int adoptNo, int petState) {
		if(petState<3) {
			petState=3;	//진행
		} else if(petState<5) {
			petState=4;	//입양완료
			adoptDao.setAdoptDate(petNo, memberId, adoptNo);
			//petDao.eraseMercyDate(petNo);
			
			
			// 수안============================
			// 입양 완료됐으니까 돈계산 시작하자~
			List<Pet> petList = petDao.allPetList(petNo);
			System.err.println(petList);
			
			
			
			int endPetAllM = petDao.nowPetMoney(petNo);
			System.err.println(endPetAllM);
			int goalM = 500000;
			
			
			for(int i=0; i<petList.size(); i++) {
				
				System.out.println(i+"번째 펫넘버"+petList.get(i).getPetNo());
				
				
				int nowSponM = petDao.nowPetMoney(petList.get(i).getPetNo()); // i번째 펫에게 들어있는 sponsorMoney
				System.out.println(i+"번째 들어있는 돈"+nowSponM);
				
				int needM = goalM - nowSponM;	// 지금 i번째에게 필요한 돈
				System.out.println(i+"번째가 필요한 돈"+needM);
				
				endPetAllM = endPetAllM - needM;
				System.err.println(i+"번째에 남은 endPetM"+endPetAllM);
				
				if(endPetAllM > 0) {
					
					System.err.println("이리왔지롱111111111111111111111111");
					// for문 다시 돌아야하고
					// petList.get(i)의 sponsorNo번째의 sponsorMoney 가 50만원이되고
					petDao.updateThisSponMoney(petList.get(i).getPetNo());
					System.err.println("50만원 세팅완료");
					
					// petList.get(i)의 sponsorNo 가 +1되고, sponsorMoney가 0원으로 세팅
					petDao.insertThisPetSponsor(petList.get(i).getPetNo(), (petDao.sponNoForReceiver(petList.get(i).getPetNo()))+1);
					System.err.println("새로운 sponNo세팅완료!");
					
					
					// petList.get(i)의 mercyDate 가 +15일되야함
					petDao.updateThisMercyDate(petList.get(i).getPetNo());
					System.err.println("안락사 날짜 증가완료!");
					
				}
				
				
				
				else if(endPetAllM==0 || endPetAllM<0) {
					
					System.err.println("이리왔지롱222222222222222222");
					
						// petList.get(i)의 sponsorMoney에 +endPetAllM을 한 값으로 update
						endPetAllM = endPetAllM + needM;
						int resultSponM = (petDao.sponMoneyForReceiver(petList.get(i).getPetNo()))+endPetAllM;
						
						System.err.println(endPetAllM+"이거!!!!!!    결론"+resultSponM+"이거가 sponsorM에 set되야지");
						petDao.updategetAllRestMoney(resultSponM, petList.get(i).getPetNo());

						
						
						System.err.println("돈 0원 만들러가자@@@@@@@@!!!!!!!!!!!!!!!!!!");
						
						// 돈 나눠준 pet의 sponsorM은 0으로 세팅
						petDao.updateEndPetMoney(petNo);
						
						System.err.println("돈 0원 됐다!!!!!!!!!!!!!!!!!!");
						
						// 끝났으면 for문에서 빠져나오기(break)
						break;
						
					
				}
			}
			
			// 돈계산 끝======================================================
			
			
		} else {
			petState=1;
			adoptDao.cancleAdopt(petNo, memberId, adoptNo);
			adoptDao.updateMinusMercyDate(petNo);
		}
		
		petDao.updateState(petNo, petState);
	}
	
	
	
	
	
	
	
	
	// 센터의 월별 후원금 내역
	public Map<String, Object> recordSponsor(String centerId, int pageno) {
		int monthNum = sponsorDao.getMonthNum(centerId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, monthNum, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("sponsorRecord", sponsorDao.getSponsorMonthlyRecord(pagination.getStartArticleNum(), pagination.getEndArticleNum(), centerId));
		return map;
	}
	
	// 센터의 월별상세 후원금 내역
	public Map<String, Object> detailRecordSponsor(String centerId, String month, int pageno) {
		int sumDPNum = sponsorDao.getSponsorDPNum(centerId, month);
		Pagination pagination = PagingUtil.setPageMaker(pageno, sumDPNum, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("month", month);
		map.put("sponsorDetailRecord", sponsorDao.getSponsorDPRecord(pagination.getStartArticleNum(), pagination.getEndArticleNum(), centerId, month));
		return map;
	}
	
	// 센터주최의 봉사내역
	public Map<String, Object> recordVolunteer(String centerId, int pageno, int sort) {
		int volunteerNum = volunteerDao.getVolunteerNumOfCenter(centerId);
		Pagination pagination = PagingUtil.setPageMaker(pageno, volunteerNum, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("volunteerRecord", volunteerDao.getVolunteerRecordOfCenter(pagination.getStartArticleNum(),
				pagination.getEndArticleNum(), centerId, sort));
		return map;
	}
	
	// 특정 봉사의 신청자 내역
	public Map<String, Object> recordVolunteerApply(int volunteerNo, int pageno) {
		int applyNum = volunteerDao.getVolunteerApplyNum(volunteerNo);
		Pagination pagination = PagingUtil.setPageMaker(pageno, applyNum, 10);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("vno", volunteerNo);
		map.put("applyRecord", volunteerDao.getVolunteerApplyRecord(pagination.getStartArticleNum(),
				pagination.getEndArticleNum(), volunteerNo));
		return map;
	}
	
	@PreAuthorize("isAnonymous()")
	public Map<String, String> sendPwdEmail( String id, String email)
			throws MessagingException {
		String checkCode = RandomStringUtils.randomAlphabetic(6);

		Map<String, String> map = new HashMap<String, String>();
		map.put("id", id);
		map.put("checkCode", checkCode);
		
		Integer result = dao.checkCenterIdAndEmail(id, email);

		if (result == 1) {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");

			String text = checkCode;

			messageHelper.setFrom("webmaster@icia.com");
			messageHelper.setTo(email);
			messageHelper.setSubject("인증코드 메일입니다");
			messageHelper.setText(text);
			mailSender.send(message);
			
			return map;
		} else {
			return null;
		}
	}
	
	public void cancleVolunteerApply(int volunteerNo, String memberId) {
		volunteerDao.updateVolunteerApply(volunteerNo, memberId, 0);
		volunteerDao.decreaseVolunteerApplyPeople(volunteerNo);
	}
	
	// 비밀번호 재설정
	public void updatePassword(String password, String centerId) {
		String encodedPassword = passwordEncoder.encode(password);

		Map<String, String> map = new HashMap<String, String>();

		map.put("password", encodedPassword);
		map.put("centerId", centerId);

		dao.updateCenter(map);
		sUsersDao.updatePassword(centerId, encodedPassword);
	}

	// 아이디 사용가능 여부 확인 (센터)
	public Boolean idCheck(String centerId) {
		System.out.println("centerId서비스");
		return dao.checkExistCenterId(centerId) == 1 ? true : false;
	}

	// 이메일 사용가능 여부 확인 (센터)
	public Boolean idEmail(String email) {
		System.out.println("email서비스");
		return dao.checkExistCenterEmail(email) == 1 ? true : false;
	}
	
	// 센터 회원가입
	public void joinCenter( Center center, MultipartFile[] files) throws IOException {
		
		System.out.println("회원가입 service 센터");
		
		CenterImg cim = new CenterImg(); // vo CenterImg
		List<CenterImg> imgList = new ArrayList<CenterImg>(); // Center에 있는 List<CenterImg>

		int idx = 0;
		for (MultipartFile file : files) {

			if (file.getOriginalFilename().equals(""))
				break;

			String savedFileName = System.currentTimeMillis() + "-" + file.getOriginalFilename();

			File f = new File("\\\\192.168.0.203\\service\\center", savedFileName);
			FileCopyUtils.copy(file.getBytes(), f);
			
			if (idx == 0)
				// 1. 사업자 등록 사진
				center.setLicenseImg(savedFileName);

			else if (idx == 1)
				// 2. 후원 통장사진
				center.setSponsorAccountImg(savedFileName);

			else {
				// 3. 센터사진 여러장
				cim.setCenterId(center.getCenterId());
				cim.setCenterImgNo(idx - 1);
				cim.setImg(savedFileName);
				imgList.add(cim);
			}
			idx++;
		}

		String encodedPassword = passwordEncoder.encode(center.getPassword());
		center.setPassword(encodedPassword);

		System.err.println(center);
		dao.insertCenter(center);

		for (int i = 0; i < imgList.size(); i++) {
			dao.insertCenterImg(imgList.get(i));
		}

		dao.insertAuthority(center.getCenterId(), "ROLE_CENTER");
		dao.insertSUsers( new SUsers(center.getCenterId(), center.getPassword(), true) );
	}
	
	// 탈퇴상태 update
	public boolean resignCenter(String centerId, String password) {
		String encodedPassword = dao.getPassword(centerId);
		if(passwordEncoder.matches(password, encodedPassword)==false) return false;		
		dao.updateCenterState(centerId, 3);	// 3 : 탈퇴승인대기 
		return true;
	}
	
	
	
	// 주리
	// 10개씩 회원 목록 읽어오기
	public Map<String, Object> getAllCenter(int pageno) {

		int numberOfTotalArticle = dao.getCountCenter();

		Pagination p = PagingUtil.setPageMaker(pageno, numberOfTotalArticle, 10);

		List<Center> list = dao.getAllPageCenter(p.getStartArticleNum(), p.getEndArticleNum());
		List<Map<String, Integer>> mapList = dao.getCenterStateCount();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", p);
		map.put("centerList", list);
		map.put("mapList", mapList);

		return map;
	}

	// 검색 값으로 회원 목록 가져오기
	public Map<String, Object> getSearchAllCenter(int pageno, String colName, String find) {

		find = "'%" + find + "%'";

		int numberOfTotalArticle = dao.getSearchCountCenter(colName, find);

		Pagination p = PagingUtil.setPageMaker(pageno, numberOfTotalArticle, 10);

		List<Center> list = dao.getSearchAllPageCenter(p.getStartArticleNum(), p.getEndArticleNum(), colName, find);
		List<Map<String, Integer>> mapList = dao.getCenterStateCount();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", p);
		map.put("centerList", list);
		map.put("mapList", mapList);

		return map;
	}

	// 센터 회원 가입을 승인합시다
	public int acceptJoin(String centerId, int num) {
		return dao.updateCenterState(centerId, num);
	}

	// 센터 탈퇴를 승인합시다.
	public boolean acceptResign(String centerId) {

		// 입양 : 만약 신청중이나 진행중이면 탈퇴못해..그 외일때는 탈퇴
		if (adoptDao.getCenterAdoptForResign(centerId) <= 0) {

			// 동물 블락 처리..
			petDao.updateCenterAllPetState(centerId, CT.PET_STATE_BLOCK);
			System.err.println("1");

			// 탈퇴를 위한 봉사모집 취소상태로 변경
			volunteerDao.updateVolunteerStateForResign(centerId);
			System.err.println("2");

			// 탈퇴를 위한 봉사모집 신청자 거절
			volunteerDao.deleteVolunteerCancleForResign(centerId);
			System.err.println("3");

			// 보안T 정보 삭제
			sUsersDao.deleteSUsers(centerId);
			System.err.println("4");

			// 권한 삭제
			dao.deleteAuthority(centerId);
			System.err.println("5");

			// 회원 테이블에 회원 상태를 탈퇴회원(4)으로 바꾸기
			dao.updateCenterState(centerId, CT.CENTER_STATE_RESIGN);
			System.err.println("6");
			return true;
		}
		return false;
	}

	public Map<String, Object> getCenterPetList(AdCPetInfo info) {

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

		int articleCnt = petDao.getCountCenterPetList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("centerPetList", petDao.getCenterPetList(info));

		// 각각 상태별로 몇건인지 가져오기
		map.put("totalPetState", petDao.getTotalCenterPetState(info.getCenterId()));

		return map;
	}

	// 멤버 블락 처리
	public int centerblock(String centerId, int centerState) {
		return dao.updateCenterState(centerId, centerState);
	}

}
