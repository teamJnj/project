package com.icia.jnj.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icia.jnj.dao.MemberDao;
import com.icia.jnj.domain.SponsorPayInfo;
import com.icia.jnj.service.AdoptService;
import com.icia.jnj.vo.Adopt;

@Controller
@RequestMapping("/menu")
public class AdoptController {
	@Autowired
	private AdoptService service;
	@Autowired
	private Gson gson;
	@Autowired
	private MemberDao memberDao;
	
	// 수안==========================
	// 입양 리스트, 안락사 임박일순, 분류-지역-상태별 필터
	@GetMapping("/adopt/record")
	public String getAdoptList(@RequestParam(defaultValue="1") int pageno, @RequestParam(defaultValue="0") int petSort, @RequestParam(defaultValue="0") int petState, @RequestParam(defaultValue="전체")String firstAddr, Model model, Principal principal) {
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		}else {
		model.addAttribute("mAuthority", new Gson().toJson(memberDao.getMemberAuthority(principal.getName())));
		model.addAttribute("map", gson.toJson(service.getAdoptList(pageno, petSort, petState, firstAddr)));
		model.addAttribute("viewName", "menu/adopt/adoptList.jsp");
		}
		return "index";
	}
	
	// 입양글 보기
	@GetMapping("/adopt/view")
	public String getAdoptView(int petNo, String memberId, Model model, Principal principal) {
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		} else {
			model.addAttribute("mstate", new Gson().toJson(memberDao.getMemberState(principal.getName())));
			model.addAttribute("map", gson.toJson(service.getAdoptView(petNo,principal.getName())));
			model.addAttribute("viewName", "menu/adopt/adoptView.jsp");
		}
		return "index";
	}
	
	// 입양 신청화면 가기
	@PostMapping("/adopt/apply1")
	public String doSponsorPayPage(Adopt adopt, Model model, Principal principal) {
		adopt.setMemberId(principal.getName());
		model.addAttribute( "adopt",gson.toJson( adopt ) );
		return "menu/adopt/adoptApply";
	}
	
	
	// 입양 신청화면 가서 입양 신청하기
	@PostMapping("/adopt/apply2")
	public ResponseEntity<Void> adoptApply(Adopt adopt, Principal principal) {
		adopt.setMemberId(principal.getName());
		service.insertAdoptInfo(adopt);
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
	
	// 후원페이지 이동
	@GetMapping("/adopt/sponsor_view")
	public String goSponsorView(int petNo) {
		return "redirect:/sponsor/view?petNo="+petNo;
	}
	
	
	// 취소화면 이동(진짜취소? 여부 물으러가기)
	@PostMapping("/adopt/cancle1")
	public String deleteAdoptApply(Adopt adopt, Model model, Principal principal) {
		adopt.setMemberId(principal.getName());
		model.addAttribute( "adopt",gson.toJson( adopt ) );
		return "menu/adopt/cancleApply";
	}
		
	// 입양 취소하기
	@PostMapping("/adopt/cancle2")
	public ResponseEntity<Void> deleteAdoptInfo(Adopt adopt, Principal principal) {
		adopt.setMemberId(principal.getName());
		service.updateAdoptInfo(adopt);
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
	
}
