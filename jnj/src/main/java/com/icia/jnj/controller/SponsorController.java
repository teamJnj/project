package com.icia.jnj.controller;

import java.security.Principal;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.icia.jnj.dao.MemberDao;
import com.icia.jnj.domain.SponsorPayInfo;
import com.icia.jnj.service.SponsorService;

@Controller
@RequestMapping("/menu")
public class SponsorController {
	
	@Autowired
	private SponsorService service;
	@Autowired
	private Gson gson;
	@Autowired
	private MemberDao memberDao;
	
	// 1.후원 리스트: 필터
	@GetMapping("/sponsor/record")
	public String getSponsorList(@RequestParam(defaultValue="1")int pageno, @RequestParam(defaultValue="0")int petSort, Model model, Principal principal) {
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		}else {
		Map<String,Object> map= service.getSponsorList(petSort, pageno);
		map.put("petSort", petSort);
		
		model.addAttribute("mAuthority", new Gson().toJson(memberDao.getMemberAuthority(principal.getName())));
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("viewName", "menu/sponsor/sponsorList.jsp");
		}
		return "index";
	}
	
	// 2. 후원 뷰화면으로 이동(사진포함)
	@GetMapping("/sponsor/view")
	public String getSponsorView(@RequestParam(defaultValue="1")int pageno, int petNo, Model model) {
		Map<String,Object> map= service.getAllSponsorReplyList(petNo, pageno);
		map.put("petNo", petNo);
		
		model.addAttribute("reply", gson.toJson(map));
		model.addAttribute("sponsorMap",gson.toJson(service.getSponsorView(petNo)));
		
		model.addAttribute("viewName","menu/sponsor/sponsorView.jsp");
		return "index";
	}
	
	// 3. 후원하기 눌렀을 때:결제 방법 선택 페이지
	@PostMapping("/sponsor/pay1")
	public String doSponsorPayPage(SponsorPayInfo spInfo, Model model) {
		model.addAttribute( "spInfo",gson.toJson( spInfo ) );
		return "menu/sponsor/sponsorPay";
	}
	
	// 4. 결제 방법 선택 후 결제 완료
	@PostMapping("/sponsor/pay2")
	public ResponseEntity<SponsorPayInfo> sponsorPayProcessAll(SponsorPayInfo spInfo, Principal principal) {
		
		System.err.println( "C전 : " + spInfo );
		
		//spInfo.setMemberId("suan");
		spInfo.setMemberId(principal.getName());
		spInfo.setSponsorReply("후원합니다.");
		
		System.err.println( "C후 : " + spInfo );
		
		return new ResponseEntity<SponsorPayInfo>(service.sponsorPayProcessAll(spInfo),HttpStatus.OK);
	}
	
	// 5. 결제 완료 페이지에서 덧글쓰기(덧글 추가)
	@PostMapping("/sponsor/pay_result")
	public ResponseEntity<Void> updateMemberSponsorReply(SponsorPayInfo spInfo, Principal principal) {
		
		System.err.println("결제 완료에서 덧글수정 : " + spInfo);
		
		//spInfo.setMemberId("suan");
		spInfo.setMemberId(principal.getName());
		service.updateMemberSponsorReply(spInfo);
		
		spInfo.setSponsorReply(spInfo.getSponsorReply());
		
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
}
