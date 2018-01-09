package com.icia.jnj.controller.admin;

import java.util.*;

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
public class AdminMemberController {

	@Autowired
	private Gson gson;
	
	@Autowired
	private MemberService 		memberService;		// member
	
	@Autowired
	private SponsorService 		sponsorService;		// pet_sponsor, member_sponsor_record
	
	@Autowired
	private AdoptService 		adoptService;		// adopt
	
	@Autowired
	private VolunteerService 	volService;			// volunteer
	
	@Autowired
	private MarketService 		marketService;		// market
	
	@Autowired
	private BoardService 		boardService;		// find
	@Autowired
	private FoundService 		fService;		// find
	
	@Autowired
	private QnaService			qnaService;			// qna
	
	@Autowired
	private StoreService		storeService;

	@InitBinder
	public void initBinder(WebDataBinder dataBinder) {
		dataBinder.registerCustomEditor(String.class, "sponsorDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "adoptApplyDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "endDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "startDate", new DatePropertyEditor());
	}
	
	
	// 1. 관리자 메인 화면
	@GetMapping({ "/", "/main" })
	public String main( Model model ) {
		model.addAttribute("adminViewName", "adMain.jsp");
		return "admin/adIndex";
	}
	
	
	// 1-1. 회원 검색 할 때
	@GetMapping( value="/member/search", produces="application/text; charset=utf8" )
	public ResponseEntity<String> memberList( @RequestParam(defaultValue="1")int pageno,
			@RequestParam(required=false)String colName, @RequestParam(required=false)String find ) {
		String map = gson.toJson( memberService.getSearchAllMember(pageno, colName, find) );
		return new ResponseEntity<String>( map, HttpStatus.OK );
	}

	
	// 2. 관리자 일반회원
	@GetMapping("/member")
	public String memberList( Model model, @RequestParam(defaultValue="1")int pageno ) {
		
		model.addAttribute("map", gson.toJson( memberService.getAllMember(pageno) ) );
		model.addAttribute("state", gson.toJson( memberService.getMembetStateCount() ) );
		model.addAttribute("adminViewName", "member/adMemberList.jsp");
		return "admin/adIndex";
	}
	
	
	// 2-1. 관리자 일반회원 - 회원정보
	@GetMapping("/member_info")
	public String memberInfo( Model model, String memberId ) {
		
		model.addAttribute("member", gson.toJson(memberService.getMember(memberId)) );
		model.addAttribute("memberInfoIndex","adMemberInfo.jsp" );
	
		return "admin/member/adMemberIndex";
	}
	
	
	// 2-2. 관리자 일반회원 - 회원정보(블락)
	@PostMapping("/member_block")
	public ResponseEntity<Integer> memberBlock( String memberId, int memberState ) {
		int result = memberService.memberblock(memberId, memberState);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	
	// 2-3. 관리자 일반회원 - 회원정보(탈퇴)
	@PostMapping("/member_resign")
	public ResponseEntity<Boolean> memberResign( String memberId ) {
		boolean result = memberService.memberResign(memberId);
		return new ResponseEntity<Boolean>( result, HttpStatus.OK );
	}
	
	
	// 3. 관리자 일반회원 - 후원내역
	@GetMapping("/member_sponsor")
	public String memberSponsorList( Model model, AdMSponsorInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = sponsorService.getMemberSponsorList( info );
		map.put( "member", m );
		map.put( "adMSponsorInfo", info );
		
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute( "memberInfoIndex", "adMemberSponsor.jsp" );
		
		return "admin/member/adMemberIndex";
	}
	
	// 3. 관리자 일반회원 - 후원내역( ajax )
	@GetMapping( value="/member_sponsor/sort", produces="application/text; charset=utf8" )
	public ResponseEntity<String> memberSponsorListAjax( AdMSponsorInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = sponsorService.getMemberSponsorList( info );
		map.put( "member", m );
		map.put( "adMSponsorInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 3-1 관리자 일반회원 - 후원내역 상세보기
	@GetMapping( "/member_sponsor/detail" )
	public String memberSponsorDetail( Model model, int petNo, @RequestParam(defaultValue="1")int pageno ){
		
		Map<String,Object> map= sponsorService.getAllSponsorReplyList(petNo, pageno);
		map.put("petNo", petNo);
		
		model.addAttribute("reply", gson.toJson(map));
		model.addAttribute("sponsorMap",gson.toJson(sponsorService.getSponsorView(petNo)));
		
		return "admin/member/adMemberSponsorDetail";
	} 
	
	// 3-2 관리자 일반회원 - 후원댓글내역
	@GetMapping("/member_sponsor/comment")
	public String memberSponsorCommentList( Model model, AdMSponsorInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = sponsorService.getMemberSponsorList( info );
		map.put( "member", m );
		map.put( "adMSponsorInfo", info );
		
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute( "memberInfoIndex", "adMemberSponsorComment.jsp" );
		
		return "admin/member/adMemberIndex";
	}
	
	// 3-2 관리자 일반회원 - 후원댓글내역( ajax )
	@GetMapping( value="/member_sponsor/comment/sort", produces="application/text; charset=utf8" )
	public ResponseEntity<String> memberSponsorCommentListAjax( AdMSponsorInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = sponsorService.getMemberSponsorList( info );
		map.put( "member", m );
		map.put( "adMSponsorInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	} 
	
	
	
	
	
	
	

	// 4. 관리자 일반회원 - 입양내역
	@GetMapping("/member_adopt")
	public String memberAdopt( Model model, AdMAdoptInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = adoptService.getMemberAdoptList( info );
		map.put( "member", m );
		map.put( "adMAdoptInfo", info );
		
		System.err.println(map.get("stateCount"));
		
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute( "memberInfoIndex", "adMemberAdopt.jsp" );
		
		return "admin/member/adMemberIndex";
	}
	
	// 4. 관리자 일반회원 - 입양내역( ajax )
	@GetMapping( value="/member_adopt/sort", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberAdoptListAjax( AdMAdoptInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = adoptService.getMemberAdoptList( info );
		map.put( "member", m );
		map.put( "adMAdoptInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-1. 관리자 일반회원 - 입양내역 - 입양취소
	@PostMapping( value="/member_adopt/cancle", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberAdoptBlock( int petNo, int adoptNo, String memberId, AdMAdoptInfo info ){
		
		Adopt adopt = new Adopt();
		adopt.setMemberId(memberId);
		adopt.setPetNo(petNo);
		adopt.setAdoptNo(adoptNo);
		
		adoptService.updateAdoptInfo( adopt );
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = adoptService.getMemberAdoptList( info );
		map.put( "member", m );
		map.put( "adMAdoptInfo", info );
		
		return new ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-2 관리자 일반회원 - 입양 내역 상세보기
	@GetMapping( "/member_adopt/detail" )
	public String memberAdoptDetail( Model model, int petNo, @RequestParam(defaultValue="1")int pageno ){
		
		model.addAttribute("map", gson.toJson(adoptService.getAdoptView(petNo, "adminDetailView")));
		return "admin/member/adMemberAdoptDetail";
	} 
	
	
	// 5. 관리자 일반회원 - 봉사(모집)내역
	@GetMapping("/member_volunteer")
	public String memberVolunteerList( Model model, AdMVolunteerInfo info ){
		
		Member m = memberService.getMember(info.getHostId());
		
		Map<String,Object> map = volService.getMemberVolunteerList( info );
		map = volService.getMemberVolunteerList( info );
		
		map.put( "member", m );
		map.put( "adMVolunteerInfo", info );
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute( "memberInfoIndex", "adMemberVolunteer.jsp" );
		
		return "admin/member/adMemberIndex";
	}
	
	// 5. 관리자 일반회원 - 봉사내역( ajax )
	@GetMapping( value="/member_volunteer/sort", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerListAjax( AdMVolunteerInfo info ){
		
		Member m = memberService.getMember(info.getHostId());
		
		Map<String,Object> map = volService.getMemberVolunteerList( info );
		map.put( "member", m );
		map.put( "adMVolunteerInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}

	// 5-1. 관리자 일반회원 - 봉사(모집) - 글 삭제 
	@PostMapping( value="/member_volunteer/delete", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerDelete( AdMVolunteerInfo info, int volunteerNo ){
		
		volService.getVolunteerDelete(volunteerNo);
		
		// 삭제하고 글 목록을 다시 읽어서 화면에 뿌려주기
		Member m = memberService.getMember(info.getHostId());
		
		Map<String,Object> map = volService.getMemberVolunteerList( info );
		map.put( "member", m );
		map.put( "adMVolunteerInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK );
	}
	
	// 5-2. 관리자 일반회원 - 봉사(모집) - 신청자보기
	@GetMapping("/member_volunteer/apply_list")
	public String memberVolunteerApplyList( Model model, int volunteerNo, 
			@RequestParam(defaultValue="1")int pageno, String memberId, int detailState ) {
		
		Member m = memberService.getMember(memberId);
		
		Map<String, Object> map = volService.getMypageMemberVolunteerList( volunteerNo, pageno );
		map.put("detailState", detailState);
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute( "map",  gson.toJson(map) );
		model.addAttribute( "memberInfoIndex", "adMemberVolunteerApplyList.jsp" );
		
		return "admin/member/adMemberIndex";
	}
	
	
	// 5-3. 관리자 일반회원 - 봉사(참여) - 신청자 목록 - 참가 취소
	@PostMapping( value="/member_volunteer/apply/apply_cancle", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerApplyCancle( AdMVolunteerInfo info, int volunteerNo, String applyId ){
		
		volService.updateVolunteerApplyState(volunteerNo, applyId, CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		
		Member m = memberService.getMember(info.getHostId());
		
		Map<String,Object> map = volService.getMemberVolunteerList( info );
		map.put( "member", m );
		map.put( "adMVolunteerInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 5-3. 관리자 일반회원 - 봉사(모집) - 신청자 목록 - 참가 취소
	@PostMapping( value="/member_volunteer/apply_cancle", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerApplyCancle( Model model, String[] applyId, int[] volunteerNo, String[] memberId ){
		
		// 봉사 취소 할 사용자가 여러명인지, 한명인지 판단
		if( applyId.length <= 1)
			volService.updateVolunteerApplyState(volunteerNo[0], applyId[0], CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		else {
			for( int i=0; i<applyId.length; i++ ) 
				volService.updateVolunteerApplyState(volunteerNo[i], applyId[i], CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		}

		// 거절하고 글 목록을 다시 읽어서 화면에 뿌려주기
		Member m = memberService.getMember(memberId[0]);
		Map<String, Object> map = volService.getMypageMemberVolunteerList( volunteerNo[0], 1 );
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute( "map",  gson.toJson(map) );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK );
	}
	
	// 5-4. 관리자 일반회원 - 봉사(모집) - 상세화면
	@GetMapping("/member_volunteer/view")
	public String memberVolunteerView( Model model, int volunteerNo, String memberId ) {
		
		Member m = memberService.getMember(memberId);
		
		Map<String, Object> map = new HashMap<String, Object>();

		model.addAttribute("map", gson.toJson(volService.viewVolunteer(volunteerNo, "admin")));
		model.addAttribute("name", gson.toJson(memberId));
		//model.addAttribute("volunteer", gson.toJson(volService.getVolunteer(volunteerNo)));
		model.addAttribute("member", gson.toJson(m));
		
		return "admin/member/adMemberVolunteerView";
	}
	
	// 5-5. 관리자 일반회원 - 봉사댓글내역
	@GetMapping("/member_volunteer/comment")
	public String memberVolunteerCommentList( Model model, AdMVolunteerCommentInfo info) {

		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = volService.getMemberVolunteerCommentList(info);

		map.put("member", m);
		map.put("adMVolunteerCommentInfo", info);

		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("memberInfoIndex", "adMemberVolunteerComment.jsp");

		return "admin/member/adMemberIndex";
	}

	// 5-5. 관리자 일반회원 - 봉사댓글내역( ajax )
	@GetMapping(value = "/member_volunteer/comment/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerCommentListAjax( AdMVolunteerCommentInfo info) {

		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = volService.getMemberVolunteerCommentList(info);
		map.put("member", m);
		map.put("adMVolunteerCommentInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 5-6. 관리자 일반회원 - 봉사댓글내역 - 삭제
	@PostMapping(value = "/member_volunteer/comment_delete", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerCommentDelete( int volunteerNo, int volunteerCommentNo, AdMVolunteerCommentInfo info ) {

		// 해당 댓글 삭제
		VolunteerComment volunteerComment = new VolunteerComment();
		volunteerComment.setVolunteerNo(volunteerNo);
		volunteerComment.setVolunteerCommentNo(volunteerCommentNo);
		volService.deleteVolunteerComment(volunteerComment);
		
		// 리스트 새로 읽어오기
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = volService.getMemberVolunteerCommentList(info);
		map.put("member", m);
		map.put("adMVolunteerCommentInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	// 5-7. 관리자 일반회원 - 봉사내역( ajax ) - 블락
	@PostMapping(value = "/member_volunteer/block", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerBlock(int volunteerNo, int volunteerState, AdMVolunteerInfo info) {

		volService.updateVolunteerState(volunteerNo, volunteerState);
		
		Member m = memberService.getMember(info.getHostId());

		Map<String, Object> map = volService.getMemberVolunteerList(info);
		map.put("member", m);
		map.put("adMVolunteerInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 5-7. 관리자 일반회원 - 봉사내역( ajax ) - 신고수초기화
	@PostMapping(value = "/member_volunteer/report", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberVolunteerReport(int volunteerNo, AdMVolunteerInfo info) {
		
		volService.decreaseReportCnt(volunteerNo);
		
		Member m = memberService.getMember(info.getHostId());
			Map<String, Object> map = volService.getMemberVolunteerList(info);
		map.put("member", m);
		map.put("adMVolunteerInfo", info);
			return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 6. 관리자 일반회원 - 프리마켓내역
	@GetMapping("/member_market")
	public String memberMarketList( Model model, AdMMarketInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = marketService.getMemberMarketAllList( info );
		map.put( "member", m );
		map.put( "adMMarketInfo", info );
		
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute( "memberInfoIndex", "adMemberMarket.jsp" );
		
		return "admin/member/adMemberIndex";
	}
	
	// 6. 관리자 일반회원 - 프리마켓내역( ajax )
	@GetMapping( value="/member_market/sort", produces="application/text; charset=utf8" )
	public ResponseEntity<String> memberMarketListAjax( Model model, AdMMarketInfo info ){
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = marketService.getMemberMarketAllList( info );
		map.put( "member", m );
		map.put( "adMMarketInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	
	// 6-1. 관리자 일반회원 - 프리마켓 - 참가 취소
	@PostMapping( value="/member_market/apply/apply_cancle", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberMarketApplyCancle( AdMMarketInfo info, int marketNo ){
		
		marketService.updateMarketApplyState(marketNo, info.getMemberId(), CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = marketService.getMemberMarketAllList( info );
		map.put( "member", m );
		map.put( "adMMarketInfo", info );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	
	// 6-2. 관리자 일반회원 - 프리마켓 - 상세화면
	@GetMapping("/member_market/view")
	public String membeMarketView( Model model, int marketNo, String memberId ) {
		
		Member m = memberService.getMember(memberId);
		model.addAttribute("member", gson.toJson(m));
		
		model.addAttribute( "map",gson.toJson(marketService.viewMarket(marketNo)) );
		model.addAttribute( "name", gson.toJson(memberId) );
		
		return "admin/member/adMemberMarketView";
	}
	
	
	// 6-3. 관리자 일반회원 - 마켓댓글내역
	@GetMapping("/member_market/comment")
	public String memberMarketCommentList(Model model, AdMMarketCommentInfo info) {

		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = marketService.getMemberMarketCommentList(info);

		map.put("member", m);
		map.put("adMMarketCommentInfo", info);

		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("memberInfoIndex", "adMemberMarketComment.jsp");

		return "admin/member/adMemberIndex";
	}

	// 6-3. 관리자 일반회원 - 마켓댓글내역( ajax )
	@GetMapping(value = "/member_market/comment/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberMarketCommentListAjax(Model model, AdMMarketCommentInfo info) {

		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = marketService.getMemberMarketCommentList(info);
		map.put("member", m);
		map.put("adMMarketCommentInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 6-3. 관리자 일반회원 - 봉사댓글내역 - 삭제
	@PostMapping(value = "/member_market/comment_delete", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberMarketCommentDelete(Model model, int marketNo, int marketCommentNo, AdMMarketCommentInfo info) {

		// 해당 댓글 삭제
		MarketComment marketComment = new MarketComment();
		marketComment.setMarketNo(marketNo);
		marketComment.setMarketCommentNo(marketCommentNo);
		marketService.deleteMarketComment(marketComment);

		// 리스트 새로 읽어오기
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = marketService.getMemberMarketCommentList(info);
		map.put("member", m);
		map.put("adMMarketCommentInfo", info);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	
	
	// 7. 관리자 일반회원 - 게시판 이용 내역
	@GetMapping("/member_find")
	public String memberBoardList( Model model, AdMFindInfo info ){
		
		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = boardService.getMemberFindList( info );
		map.put( "member", m );
		
		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		
		model.addAttribute( "memberInfoIndex", "adMemberFind.jsp" );
		
		System.err.println("1 타입은 : " + info.getType());
		return "admin/member/adMemberIndex";
	}
	
	// 7. 관리자 일반회원 - 게시판 이용 내역( ajax )
	@GetMapping( value="/member_find/sort", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberBoardListAjax( Model model, AdMFindInfo info ){
		
		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = boardService.getMemberFindList( info );
		map.put( "member", m );
		
		System.err.println("2 타입은 : " + info.getType());
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 7-1. 관리자 일반회원 - 게시판 - 삭제
	@PostMapping( value="/member_find/delete", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberFindDelete( Model model, AdMFindInfo info, int findDivision, int findNo ){
		
		// 해당 게시글 삭제
		boardService.deleteFind(findDivision, findNo);
		
		// 화면 갱신하기
		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = boardService.getMemberFindList( info );
		map.put( "member", m );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 7-2. 관리자 일반회원 - 게시판 - 블락 처리
	@PostMapping( value="/member_find/block", produces="application/text; charset=utf8")
	public ResponseEntity<String> memberFindBlock( Model model, AdMFindInfo info, 
			int findState, int findDivision, int findNo ){
		
		
		System.err.println("findState : " + findState);
		// 해당 게시글 블락 처리
		boardService.updateFindState( findState, findDivision, findNo );
		
		// 화면 갱신하기
		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());
		
		Map<String,Object> map = boardService.getMemberFindList( info );
		map.put( "member", m );
		
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	
	// 7-3. 관리자 일반회원 - 게시판 - 댓글 삭제
	@PostMapping(value = "/member_find/comment/delete", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberFindCommentDelete(Model model, AdMFindInfo info, int findDivision, int findNo,
			int findCommentNo) {

		// 해당 댓글 지우기
		boardService.deleteFindComment(findDivision, findNo, findCommentNo, info.getMemberId());

		// 화면 갱신하기
		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = boardService.getMemberFindList(info);
		map.put("member", m);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	// 7-4. 관리자 일반회원 - 게시판 이용 내역
	@GetMapping("/member_find/comment")
	public String memberBoardCommentList(Model model, AdMFindCommentInfo info) {

		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = boardService.getMemberFindCommentList(info);
		map.put("member", m);

		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute("memberInfoIndex", "adMemberFindComment.jsp");

		return "admin/member/adMemberIndex";
	}

	// 7-4. 관리자 일반회원 - 게시판 이용 내역( ajax )
	@GetMapping(value = "/member_find/comment/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> memberBoardListAjax(Model model, AdMFindCommentInfo info) {

		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = boardService.getMemberFindCommentList(info);
		map.put("member", m);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	// 찾아요 상세보기 이동 -> 찾아요 글보기(상세보기)
	@GetMapping("/member_find/view")
	public String boardFindView(Model model, int findNo) {
		model.addAttribute("map", gson.toJson(boardService.boardFindViewPage(findNo)));
		return "admin/member/adMemberFindBoardView";
	}

	// 찾아요 상세보기 이동 -> 찾아요 글보기(상세보기)
	@GetMapping("/member_found/view")
	public String boardFoundView(Model model, int findNo) {
		model.addAttribute("map",gson.toJson(fService.boardFindViewPage( findNo)));
		return "admin/member/adMemberFoundBoardView";
	}
	
	
	
	
	// 8. 관리자 일반,회원 - 1:1문의
	@GetMapping("/member_qna")
	public String qnaList(Model model, AdMQnaInfo info) {

		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = qnaService.getQnaList(info);
		map.put("member", m);

		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute("memberInfoIndex", "adMemberQna.jsp");

		return "admin/member/adMemberIndex";
	}

	// 8. 관리자 일반회원 - 1:1문의( ajax )
	@GetMapping(value = "/member_qna/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> qnaListAjax(Model model, AdMQnaInfo info) {

		info.setWriteId(info.getMemberId());
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = qnaService.getQnaList(info);
		map.put("member", m);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 8-1. 관리자 일반회원 - 1:1문의 - 상세보기
	@GetMapping("/member_qna/view")
	public String qnaView(Model model, int qnaNo, String writeId) {

		System.err.println("memberQnaView");
		QnA qna = qnaService.getQnaView(qnaNo, writeId);
		Member m = memberService.getMember(writeId);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("member", m);

		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("qna", gson.toJson(qna));

		model.addAttribute("memberInfoIndex", "adMemberQnaWrite.jsp");
		return "admin/member/adMemberIndex";
	}

	// 8-2. 관리자 일반회원 - 1:1문의 - qna 답변쓰기
	@PostMapping(value = "/member_qna/answer", produces = "application/text; charset=utf8")
	public ResponseEntity<String> updateAnswer(Model model, QnA qna) {
		qnaService.updateAnswer(qna);
		QnA newQna = qnaService.getQnaView(qna.getQnaNo(), qna.getWriteId());
		Member m = memberService.getMember(qna.getWriteId());

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("member", m);

		return new ResponseEntity<String>(gson.toJson(newQna), HttpStatus.OK);
	}
	
	
	
	
	
	
	
	
	// 일반회원 구매내역 리스트
	// 9. 관리자 일반- 구매내역
	@GetMapping("/member_orders")
	public String ordersList(Model model, AdOrdersInfo info) {

		info.setOrderId(info.getMemberId());
		info.setSqlWhere( "where order_id='"+info.getMemberId()+"'" );
		
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = storeService.getAdminOrderList(info);
		map.put("member", m);

		model.addAttribute("member", gson.toJson(m));
		model.addAttribute("map", gson.toJson(map));
		
		model.addAttribute("memberInfoIndex", "adMemberOrders.jsp");
		return "admin/member/adMemberIndex";
	}

	// 9. 관리자 일반- 구매내역
	@GetMapping(value = "/member_orders/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> ordersListAjax(Model model, AdOrdersInfo info) {

		info.setOrderId(info.getMemberId());
		info.setSqlWhere( "where order_id='"+info.getMemberId()+"'" );
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = storeService.getAdminOrderList(info);
		map.put("member", m);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 9. 관리자 일반- 구매내역 - 상태바꾸기...
	@PostMapping(value = "/member_orders/state", produces = "application/text; charset=utf8")
	public ResponseEntity<String> orderStateAjax(Model model, AdOrdersInfo info, int orderNo, int selectOrderState ) {

		storeService.updateAdminOrderState(orderNo,selectOrderState);
		
		info.setOrderId(info.getMemberId());
		info.setSqlWhere("where order_id='" + info.getMemberId() + "'");
		Member m = memberService.getMember(info.getMemberId());

		Map<String, Object> map = storeService.getAdminOrderList(info);
		map.put("member", m);

		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
}
