package com.icia.jnj.controller;

import java.io.*;
import java.security.*;

import javax.servlet.http.*;
import javax.validation.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;
import org.springframework.web.servlet.mvc.support.*;

import com.google.gson.*;
import com.icia.jnj.dao.*;
import com.icia.jnj.service.*;
import com.icia.jnj.vo.*;

@Controller
public class CenterController {
	
	@Autowired
	private CenterService service;
	@Autowired
	private SponsorService sponsorService;
	@Autowired
	private CenterDao dao;
	
	@Autowired
	private Gson gson;

	// 센터 정보보기
	@GetMapping({"/center", "/center/info"})
	public String viewCenter(Model model, Principal principal) {
		String centerId = principal.getName();
		int cState = dao.getCenterState(centerId);
		if(cState==0||cState==2||cState==3) {
			return "redirect:/common/cQna";
		}else {
			model.addAttribute("center", gson.toJson(service.viewCenter(centerId)));
			model.addAttribute("viewName", "center/info/cInfo.jsp");
		}
		return "index";
	}
	
	// 센터 정보수정 페이지
	@GetMapping("/center/info/update")
	public String updateCenter(Model model, Principal principal) {
		String centerId = principal.getName();
		model.addAttribute("center", gson.toJson(service.viewCenter(centerId)));
		model.addAttribute("viewName", "center/info/cInfoUpdate.jsp");
		return "index";
	}
	
	// 센터정보 수정하기
	@PostMapping("/center/info/update")
	public String updateCenter(@Valid Center center, // @RequestParam(required = false) MultipartFile[] files,
			Model model, HttpServletRequest req, RedirectAttributes ra, Principal principal) { // throws IOException {
		center.setCenterId(principal.getName());
		service.updateCenter(center);// , files);
		if(center.getPassword()!="")
			service.updatePassword(center.getPassword(), center.getCenterId());
		
		return "redirect:/center";
	}
	
	// 센터 동물관리 - 센터내 동물내역 - 정렬:이름순-분류순-상태순-안락사예정일순
	@GetMapping({"/center/pet/record", "/center/pet"})
	public String recordPet(@RequestParam(defaultValue = "1") int pageno, @RequestParam(defaultValue = "1") int sort, Model model, Principal principal) {
		String centerId = principal.getName();			//sort 1:등록일순 2:이름순 3:예정일순
//		String centerId = "center1";
		model.addAttribute("map", gson.toJson(service.recordPet(centerId, pageno, sort)));
		model.addAttribute("viewName", "center/pet/cPetRecord.jsp");
		return "index";
	}

	// 동물등록 페이지
	@GetMapping("/center/pet/insert")
	public String insertPet(Model model) {
		model.addAttribute("viewName", "center/pet/cPetInsert.jsp");
		return "index";
	}

	// 동물 등록하기
	@PostMapping("/center/pet/insert")
	public String insertPet(@Valid Pet pet, @RequestParam(required = false) MultipartFile[] files, //Principal principal, 
			Model model, HttpServletRequest req, RedirectAttributes ra, Principal principal) throws IOException {
		pet.setCenterId(principal.getName());
		service.insertPet(pet, files);
		return "redirect:/center/pet/record";
	}
	
	// 동물 수정페이지
	@GetMapping("/center/pet/update")
	public String updatePet(int petNo, Model model) {
		model.addAttribute("pet", gson.toJson(service.getPet(petNo)));
		model.addAttribute("viewName", "center/pet/cPetUpdate.jsp");
		return "index";
	}
	
	// 동물 수정하기
	@PostMapping("/center/pet/update")
	public String updatePet(@Valid Pet pet, @RequestParam(required = false) MultipartFile[] files, 
			Model model, HttpServletRequest req, RedirectAttributes ra) throws IOException {
		service.updatePet(pet);//, files);
		return "redirect:/center/pet/view?petNo="+pet.getPetNo();
	}
	
	// 동물 뷰
	@GetMapping("/center/pet/view")
	public String viewPet(int petNo, Model model) {	
		model.addAttribute("sponsorMap",gson.toJson(sponsorService.getSponsorView(petNo)));
		model.addAttribute("viewName","center/pet/cPetView.jsp");
		return "index";
	}
	
	// 유기동물 입양 리스트
	@GetMapping({"/center/adopt/record", "/center/adopt"})
	public String recordAdopt(@RequestParam(defaultValue = "1") int pageno, @RequestParam(defaultValue = "1") int sort, Model model, Principal principal) {
		String centerId = principal.getName();		//sort 1:최신순 2:입양일순 3:상태순 4:이름순 5:동물번호순
		int cState = dao.getCenterState(centerId);
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("map", gson.toJson(service.recordAdopt(centerId, pageno, sort)));
		model.addAttribute("viewName", "center/adopt/cAdoptRecord.jsp");
		return "index";
	}

	// 입양 뷰
	@GetMapping("/center/adopt/view")
	public String viewAdopt(int petNo, String memberId, int adoptNo, Model model, Principal principal) {
		String centerId = principal.getName();
		int cState = dao.getCenterState(centerId);
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("adopt", gson.toJson(service.getAdopt(petNo, memberId, adoptNo)));
		model.addAttribute("viewName", "center/adopt/cAdoptView.jsp");
		return "index";
	}
	
	// 입양상태 업데이트
	@PostMapping("/center/adopt/update")
	public String updateAdopt(int petNo, String memberId, int adoptNo, int petState) {
		service.updateAdopt(petNo, memberId, adoptNo, petState);//, files);
		return "redirect:/center/adopt/view?petNo="+petNo+"&memberId="+memberId+"&adoptNo="+adoptNo;
	}
	
	// 입양 취소
	@PostMapping("/center/adopt/cancle")
	public String cancleAdopt(int petNo, String memberId, int adoptNo) {
		service.updateAdopt(petNo, memberId, adoptNo, 6);// , files);
		return "redirect:/center/adopt/view?petNo=" + petNo + "&memberId=" + memberId + "&adoptNo=" + adoptNo;
	}
	
	// 후원 내역보기
	@GetMapping({"/center/sponsor", "/center/sponsor/record"})
	public String recordSponsor(@RequestParam(defaultValue = "1") int pageno, Model model, Principal principal) {
		String centerId = principal.getName();
		int cState = dao.getCenterState(centerId);
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("map", gson.toJson(service.recordSponsor(centerId, pageno)));
		model.addAttribute("viewName", "center/sponsor/cSponsorRecord.jsp");
		return "index";
	}
	
	// 특정 월 후원 상세내역보기
	@GetMapping("/center/sponsor/record/detail")
	public String detailRecordSponsor(@RequestParam(defaultValue = "1") int pageno, String month, Model model, Principal principal) {
		String centerId = principal.getName();
		int cState = dao.getCenterState(centerId);
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("map", gson.toJson(service.detailRecordSponsor(centerId, month, pageno)));
		model.addAttribute("viewName", "center/sponsor/cSponsorDetailRecord.jsp");
		return "index";
	}
	
	// 봉사 내역보기
	@GetMapping({ "/center/volunteer", "/center/volunteer/record" })
	public String recordVolunteer(@RequestParam(defaultValue = "1") int pageno, @RequestParam(defaultValue = "1") int sort, Model model, Principal principal) {
		String centerId = principal.getName();			//sort 1:최신순 2:봉사날짜순 3:상태순
		// String centerId = "center1";
		model.addAttribute("map", gson.toJson(service.recordVolunteer(centerId, pageno, sort)));
		model.addAttribute("viewName", "center/volunteer/cVolunteerRecord.jsp");
		return "index";
	}
	
	// 봉사 신청내역보기
	@GetMapping("/center/volunteer/record/apply")
	public String recordVolunteerApply(@RequestParam(defaultValue = "1") int pageno, int volunteerNo, Model model, Principal principal) {
		String centerId = principal.getName();
		// String centerId = "center1";
		model.addAttribute("map", gson.toJson(service.recordVolunteerApply(volunteerNo, pageno)));
		model.addAttribute("viewName", "center/volunteer/cVolunteerApplyRecord.jsp");
		return "index";
	}
	
	// 봉사 신청 취소(거절)
	@PostMapping("/center/volunteer/cancle")
	public String cancleVolunteerApply(int volunteerNo, String memberId) {
		service.cancleVolunteerApply(volunteerNo, memberId);
		return "redirect:/center/volunteer/record/apply?volunteerNo=" + volunteerNo;
	}
	
	// 탈퇴페이지
	@GetMapping("/center/resign")
	public String resignCenter(Model model) {
		model.addAttribute("viewName", "center/cResign.jsp");
		model.addAttribute("isFail", gson.toJson(0));
		return "index";
	}
	
	// 탈퇴페이지-실패
	@GetMapping("/center/resign/fail")
	public String resignCenterF(Model model) {
		model.addAttribute("viewName", "center/cResign.jsp");
		model.addAttribute("isFail", gson.toJson(1));
		return "index";
	}
	
	// 센터 탈퇴상태 update
	@PostMapping("/center/resign")
	public String resignCenter(String password, Principal principal, Model model) {
		boolean isSuccess = service.resignCenter(principal.getName(), password);
		if(isSuccess) {
			return "redirect:/";
		} else {
			return "redirect:/center/resign/fail";
		}
	}
}