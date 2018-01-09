package com.icia.jnj.service;

import java.util.*;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.*;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.*;

import com.icia.jnj.constant.CT;
import com.icia.jnj.dao.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class MemberService {
	@Autowired
	private PasswordEncoder passwordEncoder;
	@Autowired
	JavaMailSender mailSender;
	@Autowired
	private MemberDao dao;
	@Autowired
	private SUsersDao sUsersDao;
	@Autowired
	private AdoptDao aDao;
	@Autowired
	private RecruitDao rDao;

	// 10개씩 회원 목록 읽어오기
	public Map<String, Object> getAllMember(int pageno) {

		int numberOfTotalArticle = dao.getCountMember();
		Pagination p = PagingUtil.setPageMaker(pageno, numberOfTotalArticle, 10);

		List<Member> list = dao.getAllPageMember(p.getStartArticleNum(), p.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", p);
		map.put("memberList", list);

		return map;
	}
	
	// 검색 값으로 회원 목록 가져오기
	public Map<String, Object> getSearchAllMember(int pageno, String colName, String find ) {
		
		find = "'%"+find+"%'";
		int numberOfTotalArticle = dao.getSearchCountMember(colName, find);
		Pagination p = PagingUtil.setPageMaker(pageno, numberOfTotalArticle, 10);
		List<Member> list = dao.getSearchAllPageMember(p.getStartArticleNum(), p.getEndArticleNum(), colName, find);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", p);
		map.put("memberList", list);
		return map;
	}

	// 한명의 회원 정보 가져오기
	public Member getMember(String memberId) {
		return dao.getMemeber(memberId);
	}

	// 비번 바꾸기 인증번호 멜로 보내기
	@PreAuthorize("isAnonymous()")
	public Map<String, String> sendPwdEmail( String id, String email)
			throws MessagingException {
		String checkCode = RandomStringUtils.randomAlphabetic(6);

		Map<String, String> map = new HashMap<String, String>();
		map.put("id", id);
		map.put("checkCode", checkCode);
		
		Integer result = dao.checkMemberIdAndEmail(id, email);

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

	// 
	public void updatePassword(String password, String memberId) {
		String encodedPassword = passwordEncoder.encode(password);
		
		Map<String, String> map = new HashMap<String, String>(); 
		
		map.put("password",encodedPassword);
		map.put("memberId", memberId);
		
		dao.updateMember(map);
		sUsersDao.updatePassword(memberId, encodedPassword);
	}
	
	// 멤버 블락 처리
	public int memberblock(String memberId, int memberState) {
		return dao.updateMemberState(memberId,memberState);
	}
	
	// 아이디 사용가능 여부 확인 (일반)
		public Boolean idCheck(String memberId) {
			System.out.println("memberId서비스");
		return dao.checkExistMemberId(memberId) == 1 ? true : false;
	}
		
	// 이메일 사용가능 여부 확인 (일반)
	public Boolean idEmail(String email) {
		System.out.println("email서비스");
		return dao.checkExistMemberEmail(email) == 1 ? true : false;
	}

	// 일반 회원가입
	public void joinMember(Member member) {
		System.out.println("회원가입 service 일반");
		
		String encodedPassword = passwordEncoder.encode(member.getPassword());
		member.setPassword(encodedPassword);

		dao.insertMember(member);
		dao.insertAuthority(member.getMemberId(),"ROLE_MEMBER");
		
		// 스프링 시큐리티을 위해 보안테이블에도 추가
		dao.insertSUsers( new SUsers(member.getMemberId(), member.getPassword(), true) );
	}
	
	
	// 일반회원 탈퇴하기
	public boolean memberResign(String memberId) {
		System.out.println("회원탈퇴고고");
		// 아이디는 두번 다시 쓸 수 없고
		// 활동내역은 그대로 남아 있다. 라고 안내문 띄워줘.. 사용자들한테..ㅋㅋ..
		
		// 입양 : 만약 신청중이나 진행중이면 탈퇴못해..그 외일때는 탈퇴
		if(aDao.getMyAdoptForResign(memberId).size() <=0) {
			System.out.println("회원탈퇴고고-입양유무확인");
			// 탈퇴를 위한 봉사모집 취소상태로 변경
			rDao.updateVolunteerStateForResign(memberId);
			System.out.println("회원탈퇴고고-모집글상태변경");
			// 탈퇴를 위한 봉사모집 신청자 거절
			rDao.deleteVolunteerCancleForResign(memberId);
			System.out.println("회원탈퇴고고-봉사신청자거절");
			// 탈퇴를 위한 봉사참가신청 취소
			rDao.deleteVolunteerApplyForResign(memberId);
			System.out.println("회원탈퇴고고-봉사신청취소");
			// 탈퇴를 위한 프리마켓참가신청 취소
			rDao.deleteMarketApplyForResign(memberId);
			System.out.println("회원탈퇴고고-프리마켓신청취소");
			// 보안T 정보 삭제
			sUsersDao.deleteSUsers(memberId);
			// 권한 삭제
			dao.deleteAuthority(memberId);
			// 회원 테이블에 회원 상태를 탈퇴회원(4)으로 바꾸기
			dao.updateMemberState(memberId, CT.MEMBER_STATE_RESIGN);
			return true;
		}	
		return false;
	}
	
	// 멤버 상태 별 총 몇명인지 가지고 온다
	public List<Map<String,Integer>> getMembetStateCount(){
		return dao.getMembetStateCount();
	}

	// 멤버 전체 읽어오기( 페이지네이션 없고, 필터 없고 )
	public List<Member> getAllMember() {
		return dao.getAllMember();
	}
	
	// 마이페이지 일반회원 탈퇴하기
	public boolean resignMember(String memberId, String password) {
		String encodedPassword = dao.getPassword(memberId);
		boolean result = passwordEncoder.matches(password, encodedPassword);
		
		if(!result)
			return false;
		else{
			if(aDao.getMyAdoptForResign(memberId).size() <=0) {
				// 탈퇴를 위한 봉사모집 취소상태로 변경
				rDao.updateVolunteerStateForResign(memberId);
				// 탈퇴를 위한 봉사모집 신청자 거절
				rDao.deleteVolunteerCancleForResign(memberId);
				// 탈퇴를 위한 봉사참가신청 취소
				rDao.deleteVolunteerApplyForResign(memberId);
				// 탈퇴를 위한 프리마켓참가신청 취소
				rDao.deleteMarketApplyForResign(memberId);
				// 보안T 정보 삭제
				sUsersDao.deleteSUsers(memberId);
				// 권한 삭제
				dao.deleteAuthority(memberId);
				// 회원 테이블에 회원 상태를 탈퇴회원(4)으로 바꾸기
				dao.updateMemberState(memberId, CT.MEMBER_STATE_RESIGN);
				return true;
			} else{
				return false;
			}
			
		}
	}
}
