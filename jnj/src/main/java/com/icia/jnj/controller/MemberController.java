package com.icia.jnj.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.icia.jnj.dao.MemberDao;
import com.icia.jnj.dao.RecruitDao;
import com.icia.jnj.service.AdoptService;
import com.icia.jnj.service.MarketService;
import com.icia.jnj.service.MemberService;
import com.icia.jnj.service.SponsorService;
import com.icia.jnj.service.StoreService;
import com.icia.jnj.service.VolunteerService;
import com.icia.jnj.vo.Member;
import com.icia.jnj.vo.Refund;
import com.icia.jnj.vo.Review;
import com.icia.jnj.vo.VolunteerApply;

@Controller
public class MemberController {
   @Autowired
   private SponsorService Sponsorservice;
   @Autowired
   private AdoptService AdoptService;
   @Autowired
   private VolunteerService VolunteerService;
   @Autowired
   private MarketService MarketService;
   @Autowired
   private StoreService StoreService;
   @Autowired
   private MemberService MemberService;
   @Autowired
   private Gson gson;
   @Autowired
   private MemberDao memberDao;
   @Autowired
   private RecruitDao reDao;
   /*혜미혜미혜미혜미혜미혜미혜미*/
   //마이페이지 후원내역!
   @GetMapping("/member/sponsor/record")
   public String getMypageMemberSponsor(Principal principal, @RequestParam(defaultValue="1")int pageno, Model m,@RequestParam(defaultValue="centerName")String colName, @RequestParam(defaultValue="desc")String sortType, String memberId) {
      String member = principal.getName();
      int mState = memberDao.getMemberState(member);
      if(mState==0) {
    	  return "redirect:/common/qna";
      }else {
	  Map<String, Object> map = Sponsorservice.getMypageMemberSponsor(principal.getName(), pageno, colName, sortType);
      map.put("memberId", principal.getName());
      m.addAttribute("map", gson.toJson(map));
      m.addAttribute("viewName", "member/mSponsorList.jsp");
      }
      return "index";
   }
   //후원 내역 조회 필터! ("/member/sponsor/record")
   @GetMapping(value="/member/sponsor/record/sort", produces="application/text; charset=utf8")
   public ResponseEntity<String> getMypageMemberSponsorAjax(Principal principal,@RequestParam(defaultValue="1")int pageno, Model m,@RequestParam(defaultValue="centerName")String colName, @RequestParam(defaultValue="desc")String sortType, String memberId){
      Map<String, Object> map = Sponsorservice.getMypageMemberSponsor(principal.getName(), pageno, colName, sortType);
      map.put("memberId", principal.getName());
      map.put("colName", colName);
      map.put("sortType", sortType);
      m.addAttribute("map",gson.toJson(map));
      m.addAttribute("viewName","member/mSponsorList.jsp");
      return new ResponseEntity<String>(gson.toJson(map),HttpStatus.OK);
   }
   
   
   //후원 상세보기 get ("/member/sponsor/view")
   @GetMapping("/member/sponsor/view")
   public String getMypageMemberSponsorView(int petNo) {
      return "redirect:/sponsor/view?petNo="+petNo;
   }
   
   //마이페이지 입양내역!!!><!!
   @GetMapping("/member/adopt/record")
   public String getMypageMemberAdopt(Principal principal,@RequestParam(defaultValue="1")int pageno, Model m, String memberId) {
	  String member = principal.getName();
	  int mState = memberDao.getMemberState(member);
	  if(mState==0) {
	    return "redirect:/common/qna";
	  }else {
	  Map<String, Object> map= AdoptService.getMypageMemberAdopt(principal.getName(), pageno);
      map.put("memberId",principal.getName());
      m.addAttribute("map",gson.toJson(map));
      m.addAttribute("viewName","member/mAdoptionList.jsp");
	  }
      return "index";
   }
   
   //입양 상세보기 get ("/member/adopt/view")
   //이거 수정하기. 12월 11일에 했으니 그 이후에 수정확인!!!!
   @GetMapping("/member/adopt/view")
   public String getMypageMemberAdoptView(int petNo) {
      return "redirect:/adopt/view?petNo="+petNo;
   }
   
   //마이페이지 봉사내역 > .<
   @GetMapping("/member/volunteer/record")
   public String getMypageMemberVolunteerAllList(Principal principal,@RequestParam(defaultValue="1")int pageno, Model m, String memberId) {
	  String member = principal.getName();
	  int mState = memberDao.getMemberState(member);
	  if(mState==0) {
	    return "redirect:/common/qna";
	  }else {
	  Map<String,Object> map= VolunteerService.getMypageMemberVolunteerAllList(principal.getName(), pageno);
      map.put("memberId",principal.getName());
      m.addAttribute("map",gson.toJson(map));
      m.addAttribute("viewName","member/mVolunteerList.jsp");
	  }
      return"index";
   }
   //마이페이지 봉사내역 > .< (전체, 모집, 참여)
      @GetMapping("/member/volunteer/record_f")
      public ResponseEntity<Map<String,Object>> getMypageMemberVolunteerAllList_F(Principal principal,@RequestParam(defaultValue="1")int pageno, Model m, String memberId, int type) {
         Map<String,Object> map=null;
         if(type==0) {
            map = VolunteerService.getMypageMemberVolunteerHostMe(principal.getName(), pageno);
            map.put("memberId", principal.getName());
            map.put("type", type);
            m.addAttribute("map",gson.toJson(map));
         }else if(type==1) {
            map = VolunteerService.getMypageMemberVolunteerJoin(principal.getName(), pageno);
            map.put("memberId", principal.getName());
            map.put("type", type);
            m.addAttribute("map",gson.toJson(map));
         }
         return new ResponseEntity<Map<String,Object>>(map,HttpStatus.OK);
      }

   //신청자 목록이얌ㅎㅎ
   @GetMapping("/member/volunteer/apply_list")
   public String getMypageMemberVolunteerList(Principal principal,@RequestParam(defaultValue="1")int pageno, int volunteerNo,Model m,String memberId) {
      /*String host = reDao.getMypageVolunteerHostId(volunteerNo);*/
	  Map<String,Object> map = VolunteerService.getMypageMemberVolunteerList(volunteerNo, pageno);
      map.put("volunteerNo", volunteerNo);
      map.put("memberId", principal.getName());
      /*map.put("hostId", host);*/
      m.addAttribute("map",gson.toJson(map));
      m.addAttribute("viewName","member/volunteerApplyList.jsp");
      return "index";
   }
   //신청자 거절!
   @PostMapping("/member/volunteer/apply_deny")
   public String updateMemberVolunteerApplyState(VolunteerApply vA){
      VolunteerService.updateMemberVolunteerApplyState(vA);
      return "redirect:/member/volunteer/apply_list?volunteerNo="+vA.getVolunteerNo();
   }
   // 일반회원 정보수정(비밀번호)
   @GetMapping({"/member", "/member/info"})
   public String memberInfoView(Principal principal, Model model) {
	  String member = principal.getName();
	  int mState = memberDao.getMemberState(member);
	  if(mState==0) {
	    return "redirect:/common/qna";
	  }else {
	  model.addAttribute("viewName", "member/memberUpdate.jsp");
      model.addAttribute("member", gson.toJson(MemberService.getMember(principal.getName())));
	  }
      return "index";
   }
   @PostMapping("/member/info")
   public String updateMember(@Valid Member member,Principal principal) {
	    System.out.println("dddd");
		member.setMemberId(principal.getName());
		MemberService.updatePassword(member.getPassword(),member.getMemberId());
		return "redirect:/member";
	}
   
   
   
   
   
   // 수현
   // 일반회원 프리마켓 리스트
   @GetMapping("/member/market/record")
   public String getMemberMarketList(Model model, Principal principal, @RequestParam(defaultValue="1")int pageNo) {
	  int mState = memberDao.getMemberState(principal.getName());
	  if(mState==0) {
		  return "redirect:/common/qna";
	  } else {
		 model.addAttribute("viewName", "member/mMarketList.jsp");
		 model.addAttribute("map", new Gson().toJson(MarketService.getMemberMarketList(principal.getName(), pageNo)));
		 model.addAttribute("memberId", new Gson().toJson(principal.getName()));
		 return "index";
	  }
   }
   // 일반회원 프리마켓 뷰
   @GetMapping("/member/market/view")
   public String getMemberMarketView(int marketNo) {
      return "redirect:/menu/market/view?marketNo="+marketNo;
   }
   
   
   
   
   // 일반회원 구매내역 리스트
   @GetMapping("/member/store/record")
   public String getMemberOrderList(Model model, Principal principal, @RequestParam(defaultValue="1")int pageNo) {
	   int mState = memberDao.getMemberState(principal.getName());
	   if(mState==0) {
		   return "redirect:/common/qna";
	   } else {
		   model.addAttribute("viewName", "member/mOrderList.jsp");
		   model.addAttribute("map", new Gson().toJson(StoreService.getMemberOrderList(principal.getName(), pageNo)));
		   model.addAttribute("memberId", new Gson().toJson(principal.getName()));
		   return "index";
	   }   
   }
   // 일반회원 구매내역 뷰
   @GetMapping("/member/store/view")
   public String getMemberOrderView(Model model, int orderNo, Principal principal) {
      model.addAttribute("viewName", "member/mOrderView.jsp");
      model.addAttribute("writeId", new Gson().toJson(principal.getName()));
      model.addAttribute("map", new Gson().toJson(StoreService.getOrderViewGoods(orderNo)));
      return "index";
   }
   // 일반회원 구매상품 상세뷰
   @GetMapping("/member/store/goods_view")
   public String getMemberGoodsView(int goodsNo) {
	   return "redirect:/menu/store/view?goodsNo="+goodsNo;
   }
   
   
   
   // 상품후기 페이지
	@GetMapping("/member/store/comment")
	public String insertStoreReviewPage(Model model) {
		return "member/mOrderComment";
	}
	// 상품후기 작성페이지
	@PostMapping("/member/store/comment/1")
	public String insertStoreReviewPage(@RequestParam int goodsNo, @RequestParam int optionNo, @RequestParam int orderNo, RedirectAttributes ra) {
		ra.addFlashAttribute("goodsNo", goodsNo);
		ra.addFlashAttribute("optionNo", optionNo);
		ra.addFlashAttribute("orderNo", orderNo);
		return "redirect:/member/store/comment";
	}
	// 상품후기 작성
	@ResponseBody
	@PostMapping("/member/store/comment/write")
	public boolean insertStoreReview(RedirectAttributes ra, Principal principal, Review review, int orderNo) {
		review.setWriteId(principal.getName());
		boolean result = StoreService.insertStoreReview(review);
		if(result==true) {
			StoreService.updateSuccessOrdersRecord(orderNo, review.getGoodsNo(), review.getOptionNo());
			StoreService.updateSuccessOrders(orderNo);
		} 
		return result;
	}
   
  
   
   
   
   
   // 일반회원 교환/환불 페이지 이동
	@GetMapping("/member/store/rechange_apply")
	public String getRechangeView(Model model, int orderNo) {
		model.addAttribute("viewName", "member/mChangeReturn.jsp");
		model.addAttribute("map", new Gson().toJson(StoreService.getOrderViewGoods(orderNo)));
		return "index";
	}
	// 일반회원 교환 신청
	@PostMapping("/member/store/change")
	public String getChangeApply(Principal principal, @RequestParam int orderNo, @RequestParam int refundDivision, @RequestParam List<Integer> goodsNo, @RequestParam List<Integer> optionNo, @RequestParam String refundReason) {
		List<Refund> list = new ArrayList<Refund>();
		for(int i=0; i<goodsNo.size(); i++) {
			Refund r = new Refund(); 
			r.setGoodsNo(goodsNo.get(i));
			r.setOrderNo(orderNo);
			r.setOptionNo(optionNo.get(i));
			r.setRefundDivision(refundDivision);
			r.setRefundReason(refundReason);
			list.add(r);
		}
		StoreService.insertChange(list);
		return "redirect:/member/store/record?orderId="+principal.getName();
	}
	// 일반회원 환불 신청
	@PostMapping("/member/store/refund")
	public String getRefundApply(Principal principal, @RequestParam int orderNo, @RequestParam int refundDivision, @RequestParam List<Integer> goodsNo, @RequestParam List<Integer> optionNo, @RequestParam String refundReason, @RequestParam String refundAccountNo, @RequestParam String refundAccountBank, @RequestParam String refundAccountHolder) {
		List<Refund> list = new ArrayList<Refund>();
		for(int i=0; i<goodsNo.size(); i++) {
			Refund r = new Refund(); 
			r.setGoodsNo(goodsNo.get(i));
			r.setOrderNo(orderNo);
			r.setOptionNo(optionNo.get(i));
			r.setRefundAccountBank(refundAccountBank);
			r.setRefundAccountNo(refundAccountNo);
			r.setRefundAccountHolder(refundAccountHolder);
			r.setRefundDivision(refundDivision);
			r.setRefundReason(refundReason);
			list.add(r);
		}
		StoreService.insertRefund(list);
		return "redirect:/member/store/record?orderId="+principal.getName();
	}
	// 일반회원 주문 취소 
	@PostMapping("/member/store/cancle")
	public String cancleOrder(int orderNo, Principal principal) {
		StoreService.updateCancelOrders(orderNo);
		StoreService.updateCancelOrdersRecord(orderNo);
		return "redirect:/member/store/record?orderId="+principal.getName();
	}
	
	// 일반회원 탈퇴 페이지
	@GetMapping("/member/resign")
	public String resignMember(Model model) {
		model.addAttribute("viewName", "member/mResign.jsp");
		return "index";
	}
	// 일반회원 회원탈퇴
	@PostMapping("/member/resign/1")
	public String resignMember(SecurityContextLogoutHandler handler, HttpServletRequest req, HttpServletResponse res, Authentication auth, String password, Principal principal, RedirectAttributes ra) {
		System.out.println("탈퇴고고");
		boolean result = MemberService.resignMember(principal.getName(), password);
		if(result) {
			ra.addFlashAttribute("resign", result);
			handler.logout(req, res, auth);
			return "redirect:/";
		} else {
			System.out.println("실패잼");
			return "redirect:/";
		}
		
	}
	// 회원탈퇴취소
	@PostMapping("/member/resign/2")
	public String resignCancleMember() {
		return "redirect:/";
	}
}