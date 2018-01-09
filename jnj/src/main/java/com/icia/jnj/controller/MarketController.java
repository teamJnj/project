package com.icia.jnj.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.w3c.dom.stylesheets.LinkStyle;

import com.google.gson.Gson;
import com.icia.jnj.service.MarketService;
import com.icia.jnj.vo.Adopt;
import com.icia.jnj.vo.Market;
import com.icia.jnj.vo.MarketApply;
import com.icia.jnj.vo.MarketComment;

@Controller
@RequestMapping("/menu")
public class MarketController {
	@Autowired
	private Gson gson;
	@Autowired
	private MarketService service;
	
	// 마켓 조회
	@GetMapping("/market/record")
	public String marketList(@RequestParam(defaultValue="1") int pageno, Model model,Principal principal) {
		System.out.println(principal==null);
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		} else {
			model.addAttribute("viewName", "menu/market/marketList.jsp");
			model.addAttribute("map", gson.toJson(service.listMarket(pageno)));
			model.addAttribute("name", gson.toJson(principal.getName()));
		}
		return "index";
	}
	
	
	//1. 글쓰기페이지로 이동 -> 글쓰기화면  
	@GetMapping("/market/write")
	public String marketWrite(Model model, Principal principal) {
		model.addAttribute("name", gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/market/marketWrite.jsp");
		return "index";
	}
	
	// 2. 글쓰기
	@PostMapping("/market/write")
	public String market(Market market)  {
		service.insertMarket(market);
		return "redirect:/menu/market/record";
	}
	
	// 3. 글보기 화면 
	@GetMapping("/market/view")
	public String marketView(int marketNo, Model model,Principal principal) {
		model.addAttribute("map",gson.toJson(service.viewMarket(marketNo)));
		model.addAttribute("name", gson.toJson(principal.getName()));
		System.out.println(gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/market/marketView.jsp");
		return "index";
	}
	
	// 4. 글 정보 수정
	@GetMapping("/market/update")
	public String marketUpdate(Model model,int marketNo, RedirectAttributes ra) {
		model.addAttribute("market", gson.toJson(service.getMarket(marketNo)));
		model.addAttribute("viewName","menu/market/marketUpdate.jsp");
		return "index";
	}
	
	@PostMapping("/market/update")
	public String marketUpdate(Market market,HttpServletRequest req, RedirectAttributes ra) {
		service.updateMarket(market);
		return "redirect:/menu/market/view?marketNo="+market.getMarketNo();
	}
	
	// 프리마켓 글 삭제
	@PostMapping("/market/delete")
	public String marketDelete(Market market, RedirectAttributes ra) {
		service.deleteMarket(market);
		return "redirect:/menu/market/record";
	}
	
	//  전체 댓글 가져오기
	@PostMapping("/market/comment")
	public ResponseEntity<List<MarketComment>> viewAllMarketComment(int marketNo) {
		return new ResponseEntity<List<MarketComment>>(service.viewMarketComment(marketNo), HttpStatus.OK);
	}
	// 댓글 작성
	@PostMapping("/market/comment/insert")
	public ResponseEntity<List<MarketComment>> insertMarketComment(MarketComment mc, Principal principal){
		mc.setWriteId(principal.getName());
		List<MarketComment> r = service.insertMarketComment(mc);
		
		if (r!=null) {
			return new ResponseEntity<List<MarketComment>>(r, HttpStatus.OK);
		}
		return new ResponseEntity<List<MarketComment>>(HttpStatus.NOT_FOUND);
	}
	
	
	// 댓글 수정 
	@PostMapping("/market/comment/update")
	public ResponseEntity<Void> updateMarketComment(MarketComment marketComment,HttpServletRequest req, RedirectAttributes ra) {
		service.updateMarketComment(marketComment);
		
		
		return new ResponseEntity<Void>(HttpStatus.NOT_FOUND);
	}
	
	
	// 댓글 삭제
	@PostMapping("/market/comment/delete")
	public ResponseEntity<List<MarketComment>> deleteMarketComment(MarketComment marketComment) {
		System.err.println("22 marketComment : " + marketComment);
		boolean result = service.deleteMarketComment(marketComment);
		System.out.println("아아아"+result);
		/*if (result) {
			List<MarketComment> marketCommentList = service.listMarketCommentReply(marketComment.getMarketNo());
			return new ResponseEntity<List<MarketComment>>(marketCommentList, HttpStatus.OK);
		}*/
		return new ResponseEntity<List<MarketComment>>(HttpStatus.NOT_FOUND);
	}
	
	
	
	// 프리마켓 신청
	@GetMapping("/market/apply")
	public String marketApply(Market market, MarketApply marketApply, Model model ) {
		model.addAttribute("viewName", "menu/market/marketApply.jsp");
		model.addAttribute("marketNo", market.getMarketNo());
		model.addAttribute("applyPeople", market.getApplyPeople());
		model.addAttribute("boothPrice", market.getBoothPrice());
		return "index";
	}
	@PostMapping("/market/apply" )
	public String marketApply(MarketApply marketApply, Principal principal) {
		marketApply.setMemberId(principal.getName());
		service.insertMarketApply(marketApply);
		return "redirect:/menu/market/pay?marketNo="+marketApply.getMarketNo()+"&memberId="+marketApply.getMemberId();
	}
	// 프리마켓 결제 완료
	@GetMapping("/market/pay")
	public String marketPay(String memberId, int marketNo, Model model,Principal principal) {
		model.addAttribute("map",gson.toJson(service.marketPay(memberId,marketNo)));
		model.addAttribute("name", gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/market/marketPay.jsp");
		return "index";
	}
	
	
	// 프리마켓 신청 취소
	@PostMapping("/market/apply/delete")
	public String marketApplyDelete(MarketApply marketApply, Principal principal) {
		marketApply.setMemberId(principal.getName());
		service.deleteMarketApply(marketApply);
		return "redirect:/menu/market/view?marketNo="+marketApply.getMarketNo();
	}
}
