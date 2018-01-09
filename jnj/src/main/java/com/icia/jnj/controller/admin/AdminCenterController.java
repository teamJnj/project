package com.icia.jnj.controller.admin;

import java.security.*;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.*;
import org.springframework.http.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.*;
import org.springframework.web.bind.annotation.*;

import com.google.gson.*;
import com.icia.jnj.constant.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.service.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Controller
@RequestMapping("/admin")
public class AdminCenterController {

	@Autowired
	private Gson gson;
	
	@Autowired
	private CenterService 		centerService;		// center
	
	@Autowired
	private SponsorService 		sponsorService;		// pet_sponsor, center_sponsor_record
	
	@Autowired
	private AdoptService 		adoptService;		// adopt
	
	@Autowired
	private VolunteerService 	volService;			// volunteer
	
	@Autowired
	private MarketService 		marketService;		// market
	
	@Autowired
	private BoardService 		boardService;		// find
	
	@Autowired
	private QnaService			qnaService;			// qna
	
	@InitBinder
	public void initBinder(WebDataBinder dataBinder) {
		dataBinder.registerCustomEditor(String.class, "sponsorDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "adoptApplyDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "endDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "startDate", new DatePropertyEditor());
	}
	
	
	// 1-1. 관리자 센터회원
	@GetMapping("/center")
	public String centerList( Model model, @RequestParam(defaultValue="1")int pageno ) {
		model.addAttribute("map", gson.toJson( centerService.getAllCenter(pageno) ) );
		model.addAttribute("adminViewName", "center/adCenterList.jsp");
		return "admin/adIndex";
	}
	
	// 1-2. 관리자 센터회원 검색 할 때
	@GetMapping( value="/center/search", produces="application/text; charset=utf8" )
	public ResponseEntity<String> centerList( @RequestParam(defaultValue="1")int pageno,
			@RequestParam(required=false)String colName, @RequestParam(required=false)String find ) {
		
		System.out.println(colName + "   " + find);
		String map = gson.toJson( centerService.getSearchAllCenter(pageno, colName, find) );
		return new ResponseEntity<String>( map, HttpStatus.OK );
	}
	
	// 2-1. 관리자 센터회원 - 회원정보
	@GetMapping("/center_info")
	public String centerInfo( Model model, String centerId ) {
		
		model.addAttribute("center", gson.toJson(centerService.viewCenter(centerId)) );
		model.addAttribute("centerInfoIndex","adCenterInfo.jsp" );
	
		return "admin/center/adCenterIndex";
	}
	
	// 2-2. 관리자 센터회원 - 회원정보 - 가입승인
	@PostMapping( value="/center_info/join_accept")
	public ResponseEntity<Integer> centerInfo_joinAccept(String centerId) {
		int result = centerService.acceptJoin(centerId, 1);
		return new ResponseEntity<Integer>( result, HttpStatus.OK );
	}
	
	// 2-3. 관리자 센터회원 - 회원정보 - 탈퇴승인
	@PostMapping( value="/center_info/resign_accept"/*, produces="application/text; charset=utf8"*/)
	public ResponseEntity<Boolean> centerInfo_resignAccept(String centerId) {
		boolean check = centerService.acceptResign(centerId);
		return new ResponseEntity<Boolean>( check, HttpStatus.OK );
	}
	
	// 2-4. 관리자 센터회원 - 회원정보 - 회원블락
	@PostMapping("/center_block")
	public ResponseEntity<Integer> centerBlock( String centerId, int centerState ) {
		int result = centerService.centerblock(centerId, centerState);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	
	// 3. 관리자 센터회원 - 1:1문의
	@GetMapping("/center_qna")
	public String centerQnaList(Model model, AdMQnaInfo info) {

		info.setWriteId(info.getCenterId());
		Center c = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = qnaService.getQnaList(info);
		map.put("center", c);

		model.addAttribute("center", gson.toJson(c));
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute("centerInfoIndex", "adCenterQna.jsp");

		return "admin/center/adCenterIndex";
	}

	// 3. 관리자 센터회원 - 1:1문의( ajax )
	@GetMapping(value = "/center_qna/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerQnaListAjax(Model model, AdMQnaInfo info) {
		info.setWriteId(info.getCenterId());
		Center m = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = qnaService.getQnaList(info);
		map.put("center", m);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 3-1. 관리자 센터회원 - 1:1문의 - 상세보기
	@GetMapping("/center_qna/view")
	public String centerQnaView(Model model, int qnaNo, String writeId) {
		
		QnA qna = qnaService.getQnaView(qnaNo, writeId);
		Center c = centerService.viewCenter(writeId);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("center", c);

		model.addAttribute("center", gson.toJson(c));
		model.addAttribute("qna", gson.toJson(qna));

		model.addAttribute("centerInfoIndex", "adCenterQnaWrite.jsp");
		return "admin/center/adCenterIndex";
	}

	// 3-2. 관리자 센터회원 - 1:1문의 - qna 답변쓰기
	@PostMapping(value = "/center_qna/answer", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerUpdateAnswer(Model model, QnA qna) {
		qnaService.updateAnswer(qna);
		
		QnA newQna = qnaService.getQnaView(qna.getQnaNo(), qna.getWriteId());
		Center c = centerService.viewCenter(qna.getWriteId());

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("center", c);

		return new ResponseEntity<String>(gson.toJson(newQna), HttpStatus.OK);
	}
	
	
	
	
	// 4. 관리자 센터회원 - 봉사(모집)내역
	@GetMapping("/center_volunteer")
	public String centerVolunteerList(Model model, AdMVolunteerInfo info) {

		Center m = centerService.viewCenter(info.getHostId());

		Map<String, Object> map = volService.getCenterVolunteerList(info);
		map = volService.getCenterVolunteerList(info);

		map.put("center", m);
		map.put("adMVolunteerInfo", info);

		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("centerInfoIndex", "adCenterVolunteer.jsp");

		return "admin/center/adCenterIndex";
	}

	// 4. 관리자 센터회원 - 봉사내역( ajax )
	@GetMapping(value = "/center_volunteer/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerListAjax(AdMVolunteerInfo info) {

		Center c = centerService.viewCenter(info.getHostId());

		Map<String, Object> map = volService.getCenterVolunteerList(info);
		map.put("center", c);
		map.put("adMVolunteerInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-1. 관리자 센터회원 - 봉사(모집) - 상세화면
	@GetMapping("/center_volunteer/view")
	public String centerVolunteerView(Model model, int volunteerNo, String centerId) {

		Center m = centerService.viewCenter(centerId);

		Map<String, Object> map = new HashMap<String, Object>();

		model.addAttribute("map", gson.toJson(volService.viewVolunteer(volunteerNo, "admin")));
		model.addAttribute("name", gson.toJson(centerId));
		model.addAttribute("center", gson.toJson(m));

		return "admin/center/adCenterVolunteerView";
	}
	
	// 4-2. 관리자 센터회원 - 봉사(모집) - 신청자보기
	@GetMapping("/center_volunteer/apply_list")
	public String centerVolunteerApplyList(Model model, int volunteerNo, @RequestParam(defaultValue = "1") int pageno,
			String centerId, int detailState) {

		Center m = centerService.viewCenter(centerId);

		Map<String, Object> map = volService.getMypageMemberVolunteerList(volunteerNo, pageno);
		map.put("detailState", detailState);

		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("centerInfoIndex", "adCenterVolunteerApplyList.jsp");

		return "admin/center/adCenterIndex";
	}
	
	// 4-3. 관리자 센터회원 - 봉사(모집) - 신청자 목록 - 참가 취소
	@PostMapping(value = "/center_volunteer/apply_cancle", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerApplyCancle(Model model, String[] applyId, int[] volunteerNo,
			String[] centerId, int detailState) {

		// 봉사 취소 할 사용자가 여러명인지, 한명인지 판단
		if (applyId.length <= 1)
			volService.updateVolunteerApplyState(volunteerNo[0], applyId[0],
					CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		else {
			for (int i = 0; i < applyId.length; i++)
				volService.updateVolunteerApplyState(volunteerNo[i], applyId[i],
						CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		}

		// 거절하고 글 목록을 다시 읽어서 화면에 뿌려주기
		Center m = centerService.viewCenter(centerId[0]);
		Map<String, Object> map = volService.getMypageMemberVolunteerList(volunteerNo[0], 1);
		map.put("detailState", detailState);
		
		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-4. 관리자 센터회원 - 봉사(모집) - 글 삭제
	@PostMapping(value = "/center_volunteer/delete", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerDelete(AdMVolunteerInfo info, int volunteerNo) {

		volService.getVolunteerDelete(volunteerNo);

		// 삭제하고 글 목록을 다시 읽어서 화면에 뿌려주기
		Center m = centerService.viewCenter(info.getHostId());

		Map<String, Object> map = volService.getCenterVolunteerList(info);
		map.put("center", m);
		map.put("adMVolunteerInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-5. 관리자 센터회원 - 봉사내역( ajax ) - 블락
	@PostMapping(value = "/center_volunteer/block", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerBlock(int volunteerNo, int volunteerState, AdMVolunteerInfo info) {

		volService.updateVolunteerState(volunteerNo, volunteerState);

		Center m = centerService.viewCenter(info.getHostId());

		Map<String, Object> map = volService.getCenterVolunteerList(info);
		map.put("center", m);
		map.put("adMVolunteerInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 4-6. 관리자 센터회원 - 봉사내역( ajax ) - 신고수초기화
	@PostMapping(value = "/center_volunteer/report", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerReport(int volunteerNo, AdMVolunteerInfo info) {

		volService.decreaseReportCnt(volunteerNo);

		Center m = centerService.viewCenter(info.getHostId());
		Map<String, Object> map = volService.getCenterVolunteerList(info);
		map.put("center", m);
		map.put("adMVolunteerInfo", info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-7. 관리자 센터회원 - 봉사댓글내역
	@GetMapping("/center_volunteer/comment")
	public String centerVolunteerCommentList(Model model, AdMVolunteerCommentInfo info) {

		Center m = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = volService.getMemberVolunteerCommentList(info);

		map.put("center", m);
		map.put("adMVolunteerCommentInfo", info);

		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("centerInfoIndex", "adCenterVolunteerComment.jsp");

		return "admin/center/adCenterIndex";
	}

	// 4-7. 관리자 센터회원 - 봉사댓글내역( ajax )
	@GetMapping(value = "/center_volunteer/comment/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerCommentListAjax(AdMVolunteerCommentInfo info) {

		Center m = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = volService.getMemberVolunteerCommentList(info);
		map.put("center", m);
		map.put("adMVolunteerCommentInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 4-8. 관리자 센터회원 - 봉사댓글내역 - 삭제
	@PostMapping(value = "/center_volunteer/comment_delete", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerVolunteerCommentDelete(int volunteerNo, int volunteerCommentNo,
			AdMVolunteerCommentInfo info) {

		// 해당 댓글 삭제
		VolunteerComment volunteerComment = new VolunteerComment();
		volunteerComment.setVolunteerNo(volunteerNo);
		volunteerComment.setVolunteerCommentNo(volunteerCommentNo);
		volService.deleteVolunteerComment(volunteerComment);

		// 리스트 새로 읽어오기
		Center m = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = volService.getMemberVolunteerCommentList(info);
		map.put("center", m);
		map.put("adMVolunteerCommentInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	

	
	
	
	// 5. 관리자 센터회원 - 동물내역
	@GetMapping("/center_pet")
	public String centerPetList(Model model, AdCPetInfo info) {

		Center m = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = centerService.getCenterPetList(info);

		map.put("center", m);
		map.put("adCPetInfo", info);

		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("centerInfoIndex", "adCenterPet.jsp");

		return "admin/center/adCenterIndex";
	}

	// 5. 관리자 센터회원 - 동물내역( ajax )
	@GetMapping(value = "/center_pet/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerPetListAjax(AdCPetInfo info) {

		Center c = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = centerService.getCenterPetList(info);
		map.put("center", c);
		map.put("adCPetInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 5-1 관리자 일반회원 - 동물 상세보기
	@GetMapping("/center_pet/detail")
	public String petDetail(Model model, int petNo, @RequestParam(defaultValue = "1") int pageno) {

		Map<String, Object> map = sponsorService.getAllSponsorReplyList(petNo, pageno);
		map.put("petNo", petNo);

		model.addAttribute("reply", gson.toJson(map));
		model.addAttribute("sponsorMap", gson.toJson(sponsorService.getSponsorView(petNo)));

		return "admin/center/adPetDetail";
	}
	
	
	
	
	
	// 6. 관리자 센터회원 - 입양내역
	@GetMapping("/center_adopt")
	public String centerAdoptPetList(Model model, AdCAdoptInfo info) {

		Center m = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = adoptService.getCenterAdoptApplyList(info);

		map.put("center", m);
		map.put("adCAdoptInfo", info);

		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("centerInfoIndex", "adCenterAdopt.jsp");

		return "admin/center/adCenterIndex";
	}

	// 6. 관리자 센터회원 - 입양내역( ajax )
	@GetMapping(value = "/center_adopt/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerAdoptListAjax(AdCAdoptInfo info) {

		Center c = centerService.viewCenter(info.getCenterId());

		Map<String, Object> map = adoptService.getCenterAdoptApplyList(info);
		map.put("center", c);
		map.put("adCAdoptInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 6. 관리자 센터회원 - 입양 상세보기
	@GetMapping("/center_adopt/detail")
	public String getAdoptView(int petNo, Model model) {
		Map<String, Object> map = adoptService.getAdoptInfo(petNo);
		model.addAttribute("map", gson.toJson(map) );
		return "admin/center/adCenterAdoptDetail";
	}
	
	
	
	
	
	// 7. 관리자 센터회원 - 후원내역
	@GetMapping("/center_sponsor")
	public String centerPetSponsorList(Model model, AdCSponsorInfo info) {
		Center m = centerService.viewCenter(info.getCenterId());
		Map<String, Object> map = sponsorService.getCenterSponsorList(info);
		map.put("center", m);
		map.put("adCSponsorInfo", info);
		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("centerInfoIndex", "adCenterSponsor.jsp");
		return "admin/center/adCenterIndex";
	}

	// 7. 관리자 센터회원 - 후원내역( ajax )
	@GetMapping(value = "/center_sponsor/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerPetSponsorListAjax(AdCSponsorInfo info) {
			Center c = centerService.viewCenter(info.getCenterId());
			Map<String, Object> map = sponsorService.getCenterSponsorList(info);
		map.put("center", c);
		map.put("adCSponsorInfo", info);
			return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	
	// 7. 관리자 센터회원 - 후원 상세 내역
	@GetMapping("/center_sponsor/detail")
	public String centerPetSponsorDetailList(Model model, AdCSponsorDetailInfo info) {
		Center m = centerService.viewCenter(info.getCenterId());
		Map<String, Object> map = sponsorService.getCenterSponsorDetailList(info);
		map.put("center", m);
		map.put("adCSponsorDetailInfo", info);
		model.addAttribute("center", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		return "admin/center/adCenterSponsorDetail";
	}

	// 7. 관리자 센터회원 - 후원 상세 내역( ajax )
	@GetMapping(value = "/center_sponsor/detail/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> centerPetSponsorDetailListAjax(AdCSponsorDetailInfo info) {
		Center c = centerService.viewCenter(info.getCenterId());
		Map<String, Object> map = sponsorService.getCenterSponsorDetailList(info);
		map.put("center", c);
		map.put("adCSponsorDetailInfo", info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
}


